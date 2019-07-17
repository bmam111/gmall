package com.atguigu.gmall.order.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.alibaba.fastjson.JSON;
import com.atguigu.gmall.bean.OrderDetail;
import com.atguigu.gmall.bean.OrderInfo;
import com.atguigu.gmall.order.mapper.OrderDetailMapper;
import com.atguigu.gmall.order.mapper.OrderInfoMapper;
import com.atguigu.gmall.service.OrderService;
import com.atguigu.gmall.util.ActiveMQUtil;
import com.atguigu.gmall.util.RedisUtil;
import org.apache.activemq.command.ActiveMQMapMessage;
import org.apache.activemq.command.ActiveMQTextMessage;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import redis.clients.jedis.Jedis;
import tk.mybatis.mapper.entity.Example;

import javax.jms.*;
import java.util.List;
import java.util.UUID;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    RedisUtil redisUtil;

    @Autowired
    OrderInfoMapper orderInfoMapper;

    @Autowired
    OrderDetailMapper orderDetailMapper;

    @Autowired
    ActiveMQUtil activeMQUtil;

    @Override
    public String genTradeCode(String userId) {

        String k = "user:" + userId + ":tradeCode";
        String v = UUID.randomUUID().toString();

        Jedis jedis = redisUtil.getJedis();
        jedis.setex(k,60*30,v);

        jedis.close();

        return v;
    }

    @Override
    public boolean checkTradeCode(String tradeCode, String userId) {

        boolean b = false;
        String k = "user:" + userId + ":tradeCode";
        Jedis jedis = redisUtil.getJedis();
        String s = jedis.get(k);
        if(StringUtils.isNotBlank(s) && s.equals(tradeCode)){
            b = true;
            jedis.del(k);
        }

        jedis.close();

        return b;
    }

    @Override
    public String saveOrder(OrderInfo orderInfo) {

        orderInfoMapper.insertSelective(orderInfo);
        String orderId = orderInfo.getId();

        List<OrderDetail> orderDetailList = orderInfo.getOrderDetailList();
        for (OrderDetail orderDetail : orderDetailList) {
            orderDetail.setOrderId(orderId);
            orderDetailMapper.insertSelective(orderDetail);
        }

        return orderId;

    }

    @Override
    public OrderInfo getOrderById(String orderId) {

        OrderInfo info = new OrderInfo();
        info.setId(orderId);
        OrderInfo orderInfo = orderInfoMapper.selectByPrimaryKey(info);

        if(orderInfo != null){
            OrderDetail detail = new OrderDetail();
            detail.setOrderId(orderId);
            List<OrderDetail> orderDetails = orderDetailMapper.select(detail);
            orderInfo.setOrderDetailList(orderDetails);
        }

        return orderInfo;
    }

    @Override
    public void updateOrderStatus(OrderInfo orderInfo) {
        Example e = new Example(OrderInfo.class);
        e.createCriteria().andEqualTo("outTradeNo",orderInfo.getOutTradeNo());
        orderInfoMapper.updateByExampleSelective(orderInfo, e);
    }

    @Override
    public void sendOrderResultQueue(String outTradeNo) {
        try{
            //建立MQ的连接
            Connection connection = activeMQUtil.getConnection();
            connection.start();

            //通过连接创建一次与MQ的会话任务
            //第一个值标识是否使用事务,如果选择true,第二个值相当于0
            Session session = connection.createSession(true, Session.SESSION_TRANSACTED);
            Queue queue = session.createQueue("ORDER_RESULT_QUEUE");

            //通过MQ的会话任务将队列消息发送出去
            MessageProducer producer = session.createProducer(queue);
            TextMessage textMessage = new ActiveMQTextMessage();

            //获得订单消息数据
            OrderInfo orderInfo = new OrderInfo();
            orderInfo.setOutTradeNo(outTradeNo);
            orderInfo = orderInfoMapper.selectOne(orderInfo);

            OrderDetail orderDetail = new OrderDetail();
            orderDetail.setOrderId(orderInfo.getId());
            List<OrderDetail> select = orderDetailMapper.select(orderDetail);
            orderInfo.setOrderDetailList(select);

            //将消息数据转化为JSON字符串文本输出
            textMessage.setText(JSON.toJSONString(orderInfo));

            producer.setDeliveryMode(DeliveryMode.PERSISTENT);
            producer.send(textMessage);

            //提交任务
            session.commit();
            connection.close();

            System.out.println("订单支付成功,发送订单的消息队列");

        }catch(Exception e){
            e.printStackTrace();
        }
    }

}
