package com.atguigu.gmall.interceptor;

import com.atguigu.gmall.annotation.LoginRequire;
import com.atguigu.gmall.util.CookieUtil;
import com.atguigu.gmall.util.HttpClientUtil;
import com.atguigu.gmall.util.JwtUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@Component
public class AuthInterceptor extends HandlerInterceptorAdapter {

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception{
        /*String newToken = request.getParameter("newToken");
        if(newToken != null && newToken.length() > 0){
            CookieUtil.setCookie(request,response,"token",newToken,WebConst.cookieExpire,false);
        }*/

        //判断当前访问的方法是否需要认证拦截
        //HandlerMethod是一个反射类,专门反射方法信息;它可以提供方法中关于注解的信息
        HandlerMethod method = (HandlerMethod)handler;
        LoginRequire methodAnnotation = method.getMethodAnnotation(LoginRequire.class);

        if(methodAnnotation == null){
            return true;
        }
        String oldToken = CookieUtil.getCookieValue(request, "oldToken", true);
        String newToken = request.getParameter("newToken");
        String token = "";

        /**
         * oldToken不空,newToken空,用户登陆过
         * oldToken空,newToken不空,用户第一次登陆
         * oldToken空,newToken空,用户从未登陆
         * oldToken不空,newToken不空,用户登陆过期
         * */
        if(StringUtils.isNotBlank(oldToken) && StringUtils.isBlank(newToken)){
            //登陆过
            token = oldToken;
        }
        if(StringUtils.isBlank(oldToken) && StringUtils.isNotBlank(newToken)){
            //第一次登陆
            token = newToken;
        }
        if(StringUtils.isBlank(oldToken) && StringUtils.isBlank(newToken)){
            //从未登陆
        }
        if(StringUtils.isNotBlank(oldToken) && StringUtils.isNotBlank(newToken)){
            //登陆过期
            token = newToken;
        }




        if(methodAnnotation.ifNeedSuccess() && StringUtils.isBlank(token)){
            StringBuffer requestURL = request.getRequestURL();
            response.sendRedirect("http://passport.gmall.com:8085/index?returnURL=" + requestURL);
            return false;
        }

        String success = "";
        if(StringUtils.isNotBlank(token)){
            //远程访问passport,验证token
            success = HttpClientUtil.doGet("http://passport.gmall.com:8085/verify?token=" + token + "&salt=" + getMyIp(request));
            if(!"success".equals(success) && methodAnnotation.ifNeedSuccess()){
                response.sendRedirect("http://passport.gmall.com:8085/index");
                return false;
            }
            if(!"success".equals(success) && !methodAnnotation.ifNeedSuccess()){
                return true;
            }
            if("success".equals(success)){
                //token验证通过,重新刷新cookie的过期时间
                CookieUtil.setCookie(request,response,"oldToken",token,60*60*2,true);
                Map userMap = JwtUtil.decode("atguigu0328", token, getMyIp(request));
                request.setAttribute("userId", userMap.get("userId"));
                request.setAttribute("nickName", userMap.get("nickName"));
            }

            return true;
        }

        return true;
    }

    private String getMyIp(HttpServletRequest request) {
        String ip = "";
        ip = request.getHeader("x-forwarded-for");  //负载均衡时获取Ip的方法
        if(StringUtils.isBlank(ip)){
            ip = request.getRemoteAddr();   //直接获取ip的方法
        }
        if(StringUtils.isBlank(ip)){
            ip = "127.0.0.1";  //正常到这一步就应该返回错误代码了
        }
        return ip;
    }

}
