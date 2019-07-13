package com.atguigu.gmall.service;

public interface OrderService {

    String genTradeCode(String userId);

    boolean checkTradeCode(String tradeCode, String userId);
}
