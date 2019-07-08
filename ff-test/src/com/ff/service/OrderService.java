package com.ff.service;

import com.ff.vo.OrderVO;

import java.util.Set;

public interface OrderService {

    public Set<OrderVO> buildOrders(final Set<String> lines);
}