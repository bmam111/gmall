package com.atguigu.gmall.order.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.atguigu.gmall.annotation.LoginRequire;
import com.atguigu.gmall.bean.CartInfo;
import com.atguigu.gmall.bean.OrderDetail;
import com.atguigu.gmall.bean.OrderInfo;
import com.atguigu.gmall.bean.UserAddress;
import com.atguigu.gmall.bean.enums.PaymentWay;
import com.atguigu.gmall.service.CartService;
import com.atguigu.gmall.service.OrderService;
import com.atguigu.gmall.service.SkuService;
import com.atguigu.gmall.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.invoke.CallSite;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
public class OrderController {

    @Reference
    CartService cartService;

    @Reference
    UserService userService;

    @Reference
    SkuService skuService;

    @Reference
    OrderService orderService;

    /**
     * 防重复提交
     * 令牌机制：
     * 1、当前页直接刷新(之前提交过的所有数据再来一次)
     * 2、回退到上一步页面，再来一次(之前提交过的所有数据再来一次)
     * 共同点：之前提交过的所有数据再来一次
     * 令牌：
     *      每次提交带唯一令牌，令牌使用后就删除
     *      1）、页面提交的时候上次可能给页面放了个令牌，提交上来，判断这个令牌第一次用，执行方法
     *          有一次提交还带着老令牌；不要
     *      2）、只要来到这页面给他创建一个令牌，除了刷新此页面会更新令牌。回退浏览器是显示上次页面的所有缓存内容。
     *          令牌不会更替，再提交还是老令牌
     */
    @LoginRequire(ifNeedSuccess = true)
    @RequestMapping("submitOrder")
    private String submitOrder(String tradeCode, HttpServletRequest request, HttpServletResponse response, ModelMap map){

        String userId = (String)request.getAttribute("userId");

        //比较交易码
        boolean bTradeCode = orderService.checkTradeCode(tradeCode, userId);

        //执行提交订单的业务
        if(bTradeCode){
            //订单对象
            OrderInfo orderInfo = new OrderInfo();
            List<OrderDetail> orderDetails = new ArrayList<>();

            //获取购物车中被选中的商品数据(注意不能从页面中获取,因为不安全)
            List<CartInfo> cartInfos = cartService.getCartCacheByChecked(userId);


            //校验价格、库存
            //生成订单信息
            for (CartInfo cartInfo : cartInfos) {
                OrderDetail orderDetail = new OrderDetail();
                BigDecimal skuPrice = cartInfo.getSkuPrice();
                String skuId = cartInfo.getSkuId();
                //验价
                boolean bPrice = skuService.checkPrice(skuPrice, skuId);
                //验库存 todo
                if(bPrice){
                    orderDetail.setSkuName(cartInfo.getSkuName());
                    orderDetail.setSkuId(cartInfo.getSkuId());
                    orderDetail.setOrderPrice(cartInfo.getCartPrice());
                    orderDetail.setImgUrl(cartInfo.getImgUrl());
                    orderDetail.setSkuNum(cartInfo.getSkuNum());
                    orderDetails.add(orderDetail);
                }else {
                    /**
                     * 提交订单时,只要有一件商品的价格或库存校验不通过,则全部商品都不能提交
                    * */
                    map.put("errMsg", "订单中的商品价格(库存)发生了变化,请重新确认订单");
                    return "tradeFail";
                }
            }
            orderInfo.setOrderDetailList(orderDetails);
            //封装订单信息
            orderInfo.setProcessStatus("订单未支付");
            Calendar c = Calendar.getInstance();
            c.add(Calendar.DATE, 1);
            orderInfo.setExpireTime(c.getTime());
            orderInfo.setOrderStatus("未支付");
            String consignee = "测试收件人";
            orderInfo.setConsignee(consignee);
            //外部订单号,要保证全网唯一
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
            String outTradeNo = "ATGUIGU" + sdf.format(new Date()) + System.currentTimeMillis();
            orderInfo.setOutTradeNo(outTradeNo);
            orderInfo.setPaymentWay(PaymentWay.ONLINE);
            orderInfo.setUserId(userId);
            orderInfo.setTotalAmount(getTotalPrice(cartInfos));
            orderInfo.setOrderComment("硅谷订单");
            String address = "测试收件地址";
            orderInfo.setDeliveryAddress(address);
            orderInfo.setCreateTime(new Date());
            String tel = "13123123123123";
            orderInfo.setConsigneeTel(tel);

            String orderId = orderService.saveOrder(orderInfo);

            //删除购物车中提交的商品信息,同步缓存
            cartService.deleteCartById(cartInfos);


            //对接支付系统接口
            return "redirect:http://payment.gmall.com:8087/index?orderId=" + orderId;

        }else {
            map.put("errMsg", "获取订单信息失败");
            return "tradeFail";
        }


    }

    //订单系统中,必须登录才能访问的方法
    @LoginRequire(ifNeedSuccess = true)
    @RequestMapping("toTrade")
    private String toTrade(HttpServletRequest request, HttpServletResponse response, ModelMap map){
        //需要被单点登录的拦截器拦截
        String userId = (String)request.getAttribute("userId");

        //将被选中的购物车对象转化为订单对象,展示出来
        List<CartInfo> cartInfos = cartService.getCartCacheByChecked(userId);
        List<OrderDetail> orderDetailList = new ArrayList<>();
        for (CartInfo cartInfo : cartInfos) {
            OrderDetail orderDetail = new OrderDetail();
            //将购物车对象转化为订单对象
            orderDetail.setImgUrl(cartInfo.getImgUrl());
            orderDetail.setOrderPrice(cartInfo.getCartPrice());
            orderDetail.setSkuId(cartInfo.getSkuId());
            orderDetail.setSkuName(cartInfo.getSkuName());
            orderDetail.setSkuNum(cartInfo.getSkuNum());

            orderDetailList.add(orderDetail);
        }

        //查询用户收货地址列表,让用户选择
        List<UserAddress> userAddressList = userService.getUserAddressList(userId);

        //生成交易码
        String tradeCode = orderService.genTradeCode(userId);

        map.put("tradeCode", tradeCode);
        map.put("userAddressList", userAddressList);
        map.put("orderDetailList", orderDetailList);
        map.put("totalAmount", getTotalPrice(cartInfos));

        return "trade";
    }

    private BigDecimal getTotalPrice(List<CartInfo> cartInfos) {
        BigDecimal b = new BigDecimal("0");
        for (CartInfo cartInfo : cartInfos) {
            if(cartInfo.getIsChecked().equals("1")){
                b = b.add(cartInfo.getCartPrice());
            }
        }
        return b;
    }

}
