package com.atguigu.gmall.payment.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.atguigu.gmall.bean.OrderInfo;
import com.atguigu.gmall.bean.PaymentInfo;
import com.atguigu.gmall.payment.config.AlipayConfig;
import com.atguigu.gmall.payment.service.PaymentService;
import com.atguigu.gmall.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class PaymentController {

    @Reference
    OrderService orderService;

    @Autowired
    AlipayClient alipayClient;

    @Autowired
    PaymentService paymentService;

    @RequestMapping("alipay/callback/return")
    public String callbackReturn(HttpServletRequest request, String orderId, ModelMap map){

        Map<String,String> paramsMap = null;

        //这里为了测试,不真正调用支付宝验签
        /*boolean signVerified = false;
        try {
            //调用SDK验证签名
            signVerified = AlipaySignature.rsaCheckV1(paramsMap, AlipayConfig.alipay_public_key, AlipayConfig.charset, AlipayConfig.sign_type);
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }*/

        //为了测试,直接写验签通过
        boolean signVerified = true;

        if(signVerified){
            //验签成功后,按照支付结果异步通知中的描述,对支付结果中的业务内容进行二次校验,校验成功后在response中返回success
            String tradeNo = request.getParameter("trade_no");  //支付宝端生成的订单号
            String outTradeNo = request.getParameter("out_trade_no");  //系统中的外部订单号
            String tradeStatus = request.getParameter("trade_status");
            String callbackContent = request.getQueryString();

            //进行幂等性检查(防止重复执行)
            boolean b = paymentService.checkPaied(outTradeNo);
            if(!b){
                //发送支付成功的消息PAYMENT_SUCCESS_QUEUE
                paymentService.sendPaymentSuccessQueue(tradeNo, outTradeNo, callbackContent);
            }
        }else{
            //验签失败则记录日常日志,并在response中返回failure

            //返回失败页面给用户
        }


        return "testPaySuccess";
    }

    @RequestMapping("alipay/submit")
    //@ResponseBody  //为了测试暂时注释掉
    public String alipaySubmit(String orderId, ModelMap map){

        OrderInfo orderInfo = orderService.getOrderById(orderId);

        //生成和保存支付信息
        PaymentInfo paymentInfo = new PaymentInfo();
        paymentInfo.setOutTradeNo(orderInfo.getOutTradeNo());
        paymentInfo.setPaymentStatus("未支付");
        paymentInfo.setOrderId(orderId);
        paymentInfo.setTotalAmount(orderInfo.getTotalAmount());
        paymentInfo.setSubject(orderInfo.getOrderDetailList().get(0).getSkuName());  //如有多个商品,以第一件商品为主
        paymentInfo.setCreateTime(new Date());
        paymentService.savePayment(paymentInfo);

        //为了测试,不真正调用支付宝,而是直接模拟付款成功
        /*//重定向到支付宝平台
        AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();
        alipayRequest.setReturnUrl(AlipayConfig.return_payment_url);
        alipayRequest.setNotifyUrl(AlipayConfig.notify_payment_url);  //在公共参数中设置回跳和通知地址

        HashMap<String, Object> stringObjectHashMap = new HashMap<>();
        stringObjectHashMap.put("out_trade_no",orderInfo.getOutTradeNo());
        stringObjectHashMap.put("product_code","FAST_INSTANT_TRADE_PAY");
        stringObjectHashMap.put("total_amount",orderInfo.getTotalAmount());
        stringObjectHashMap.put("subject","测试标题(应该是从订单中查询出来的)");
        String json = JSON.toJSONString(stringObjectHashMap);
        alipayRequest.setBizContent(json);

        String form = "";
        try{
            form = alipayClient.pageExecute(alipayRequest).getBody(); // 调用SDK生成表单
        }catch (AlipayApiException e){
            e.printStackTrace();
        }*/

        System.out.println("设置一个定时巡检订单" + paymentInfo.getOutTradeNo() + "的支付状态的延迟队列");
        paymentService.sendPaymentCheckQueue(paymentInfo.getOutTradeNo(), 5);

        //return form;

        //为了测试,直接模拟付款成功
        return "redirect:http://payment.gmall.com:8087/alipay/callback/return?trade_no=aliNo0001&out_trade_no=" + orderInfo.getOutTradeNo() + "&trade_status=SUCCESS";

    }

    @RequestMapping("mx/submit")
    public String wxSubmit(String orderId, ModelMap map){

        //重定向到财付通平台

        return "mxTest";
    }

    @RequestMapping("index")
    public String index(String orderId, ModelMap map){

        OrderInfo orderInfo = orderService.getOrderById(orderId);
        map.put("totalAmount", orderInfo.getTotalAmount());
        map.put("orderId", orderInfo.getId());
        map.put("outTradeNo", orderInfo.getOutTradeNo());

        return "index";
    }
}
