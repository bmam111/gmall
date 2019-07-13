package com.atguigu.gmall.passport.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.atguigu.gmall.bean.CartInfo;
import com.atguigu.gmall.bean.UserInfo;
import com.atguigu.gmall.service.CartService;
import com.atguigu.gmall.service.UserService;
import com.atguigu.gmall.util.CookieUtil;
import com.atguigu.gmall.util.JwtUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class PassportController {

    @Reference
    UserService userService;

    @Reference
    CartService cartService;

    //登录页
    @RequestMapping("index")
    public String index(String returnURL, ModelMap map){

        map.put("returnURL", returnURL);
        return "index";
    }

    //颁发token
    @ResponseBody
    @RequestMapping("login")
    public String login(HttpServletRequest request, HttpServletResponse response, UserInfo userInfo){

        //调用用户服务验证用户名和密码
        UserInfo user = userService.login(userInfo);
        if(user == null){
            //用户名或密码错误
            return "username or password err";
        }else{
            //颁发token,使用jwt,重定向原始业务

            HashMap<String, String> stringStringHashMap = new HashMap<>();
            stringStringHashMap.put("userId", user.getId());
            stringStringHashMap.put("nickName", user.getNickName());
            String token = JwtUtil.encode("atguigu0328", stringStringHashMap, getMyIp(request));

            //合并购物车数据
            String cartListCookie = CookieUtil.getCookieValue(request, "cartListCookie", true);
            List<CartInfo> cartInfos = null;
            if(StringUtils.isNotBlank(cartListCookie)){
                cartInfos = JSON.parseArray(cartListCookie, CartInfo.class);
            }
            cartService.combineCart(cartInfos, user.getId());
            //删除cookie中的购物车数据
            CookieUtil.setCookie(request,response,"cartListCookie","",0,true);

            return token;
        }

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

    //验证token
    @ResponseBody
    @RequestMapping("verify")
    public String verify(String token, String salt){
        Map<String, String> userMap = null;
        try{
            userMap = JwtUtil.decode("atguigu0328", token, salt);
        }catch(Exception e){
            e.printStackTrace();
            return "fail";
        }


        if(userMap != null){
            return "success";
        }else{
            return "fail";
        }

    }
}
