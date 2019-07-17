package com.atguigu.gmall.payment.service.impl;

import com.alibaba.fastjson.JSON;
import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.atguigu.gmall.bean.PaymentInfo;
import com.atguigu.gmall.payment.mapper.PaymentInfoMapper;
import com.atguigu.gmall.payment.service.PaymentService;
import com.atguigu.gmall.util.ActiveMQUtil;
import org.apache.activemq.ScheduledMessage;
import org.apache.activemq.command.ActiveMQMapMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import javax.jms.*;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired
    PaymentInfoMapper paymentInfoMapper;

    @Autowired
    ActiveMQUtil activeMQUtil;

    @Autowired
    AlipayClient alipayClient;

    @Override
    public void savePayment(PaymentInfo paymentInfo) {
        paymentInfoMapper.insertSelective(paymentInfo);
    }

    @Override
    public void updatePayment(PaymentInfo paymentInfo) {
        Example e = new Example(PaymentInfo.class);
        e.createCriteria().andEqualTo("outTradeNo", paymentInfo.getOutTradeNo());
        paymentInfoMapper.updateByExampleSelective(paymentInfo, e);
    }

    @Override
    public void sendPaymentSuccessQueue(String tradeNo, String outTradeNo, String callbackContent) {

        //修改支付信息
        PaymentInfo paymentInfo = new PaymentInfo();
        paymentInfo.setPaymentStatus("已支付");
        paymentInfo.setCallbackTime(new Date());
        paymentInfo.setOutTradeNo(outTradeNo);
        paymentInfo.setCallbackContent(callbackContent);
        paymentInfo.setAlipayTradeNo(tradeNo);
        updatePayment(paymentInfo);

        try{
            //建立MQ的连接
            Connection connection = activeMQUtil.getConnection();
            connection.start();

            //通过连接创建一次与MQ的会话任务
            //第一个值标识是否使用事务,如果选择true,第二个值相当于0
            Session session = connection.createSession(true, Session.SESSION_TRANSACTED);
            Queue queue = session.createQueue("PAYMENT_SUCCESS_QUEUE");

            //通过MQ的会话任务将队列消息发送出去
            MessageProducer producer = session.createProducer(queue);
            MapMessage mapMessage = new ActiveMQMapMessage();
            mapMessage.setString("trackingNo", tradeNo);
            mapMessage.setString("outTradeNo", outTradeNo);

            producer.setDeliveryMode(DeliveryMode.PERSISTENT);
            producer.send(mapMessage);

            //提交任务
            session.commit();
            connection.close();

            System.out.println("支付成功,发送支付服务的消息队列");

        }catch(Exception e){
            e.printStackTrace();
        }

    }

    /**
     * 如何设置延迟队列:
     * 1.在activemq.xml中的broker中增加配置:schedulerSupport="true",即
     *     <broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" schedulerSupport="true" dataDirectory="${activemq.data}">
     * 2.设置发送消息队列是使用延迟队列并且定义延迟时间
     *     mapMessage.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_DELAY, 1000*10);
     * 3.设计自己的巡检策略
     * */
    @Override
    public void sendPaymentCheckQueue(String outTradeNo, int count) {
        try{
            //建立MQ的连接
            Connection connection = activeMQUtil.getConnection();
            connection.start();

            //通过连接创建一次与MQ的会话任务
            //第一个值标识是否使用事务,如果选择true,第二个值相当于0
            Session session = connection.createSession(true, Session.SESSION_TRANSACTED);
            Queue queue = session.createQueue("PAYMENT_CHECK_QUEUE");

            //通过MQ的会话任务将队列消息发送出去
            MessageProducer producer = session.createProducer(queue);
            MapMessage mapMessage = new ActiveMQMapMessage();
            mapMessage.setInt("count", count);
            mapMessage.setString("outTradeNo", outTradeNo);
            //设置为延迟队列,延迟时间一分钟
            mapMessage.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_DELAY, 1000*10);

            producer.setDeliveryMode(DeliveryMode.PERSISTENT);
            producer.send(mapMessage);

            //提交任务
            session.commit();
            connection.close();

            System.out.println("发送第" + (6-count) + "的延迟检查的消息队列");

        }catch(Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public Map<String, String> checkPayment(String outTradeNo) {

        HashMap<String, String> stringStringHashMap = new HashMap<>();

        //调用支付宝检查接口
        AlipayTradeQueryRequest request = new AlipayTradeQueryRequest();

        HashMap<String, Object> stringObjectHashMap = new HashMap<>();
        stringObjectHashMap.put("out_trade_no", outTradeNo);
        String s = JSON.toJSONString(stringObjectHashMap);
        request.setBizContent(s);

        AlipayTradeQueryResponse response = null;
        try {
            response = alipayClient.execute(request);
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }

        if(response.isSuccess()){
            stringStringHashMap.put("status", response.getTradeStatus());
            stringStringHashMap.put("tradeNo", response.getTradeNo());
            stringStringHashMap.put("callbackContent", response.getBody());

        }else {
            System.out.println("用户未扫码");
        }

        return stringStringHashMap;
    }

    @Override
    public boolean checkPaied(String outTradeNo) {

        boolean b = false;

        PaymentInfo paymentInfo = new PaymentInfo();
        paymentInfo.setOutTradeNo(outTradeNo);
        PaymentInfo paymentInfo1 = paymentInfoMapper.selectOne(paymentInfo);

        if(paymentInfo1 != null && "已支付".equals(paymentInfo1.getPaymentStatus())){
            b = true;
        }

        return b;
    }

}
