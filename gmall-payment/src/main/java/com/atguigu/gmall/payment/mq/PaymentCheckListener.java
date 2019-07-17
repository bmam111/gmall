package com.atguigu.gmall.payment.mq;

import com.atguigu.gmall.payment.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;

import javax.jms.JMSException;
import javax.jms.MapMessage;

@Component
public class PaymentCheckListener {

    @Autowired
    PaymentService paymentService;

    @JmsListener(containerFactory = "jmsQueueListener", destination = "PAYMENT_CHECK_QUEUE")
    public void consumePaymentSuccess(MapMessage mapMessage) throws JMSException {
        int count = mapMessage.getInt("count");
        String outTradeNo = mapMessage.getString("outTradeNo");

        //为了测试不访问支付宝,先注释掉
        //检查支付状态
        /*Map<String,String> map = paymentService.checkPayment(outTradeNo);
        String status = map.get("status");
        String tradeNo = map.get("TradeNo");  //支付宝的订单编码
        String callbackContent = map.get("callbackContent");
        if("TRADE_SUCCESS".equals(status) || "TRADE_CLOSED".equals(status)){

            //进行幂等性检查
            boolean b = paymentService.checkPaied(outTradeNo);
            if(!b){
                //发送支付成功的队列
                paymentService.sendPaymentSuccessQueue(tradeNo, outTradeNo, callbackContent);
            }

        }else {
            if(count > 0){
                System.out.println("监听到延迟检查队列,执行延迟检查第" + (6-count) + "次检查");
                paymentService.sendPaymentCheckQueue(outTradeNo, (count-1));
            }else{
                System.out.println("监听到延迟检查队列次数耗尽,结束检查");
            }
        } */

        //用于测试调用循环检查队列,实际应该注释掉该段代码并放开上面的注释
        if(count > 0){
            System.out.println("监听到延迟检查队列,执行延迟检查第" + (6-count) + "次检查");
            paymentService.sendPaymentCheckQueue(outTradeNo, (count-1));
        }else{
            System.out.println("监听到延迟检查队列次数耗尽,结束检查");
        }
    }
}
