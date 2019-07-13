package com.atguigu.gmall.order.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.atguigu.gmall.service.OrderService;
import com.atguigu.gmall.util.RedisUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import redis.clients.jedis.Jedis;

import java.util.UUID;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    RedisUtil redisUtil;

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
}
