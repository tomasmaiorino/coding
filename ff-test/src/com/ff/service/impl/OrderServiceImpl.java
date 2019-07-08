package com.ff.service.impl;

import com.ff.exception.OrderServiceException;
import com.ff.service.OrderService;
import com.ff.vo.OrderVO;

import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

public class OrderServiceImpl implements OrderService {


    private static final int QT_ITEMS_REQUIRED = 3;

    public Set<OrderVO> buildOrders(final Set<String> lines) {

        if (Objects.isNull(lines) || lines.isEmpty()) {
            throw new OrderServiceException("The lines must not be null nor empty!");
        }

        Set<OrderVO> orders = lines.stream().map(line -> buildOrder(line)).collect(Collectors.toSet());

        orders.removeIf(o -> Objects.isNull(o));

        return orders;
    }

    //<Boutique_ID>,<Order_ID>,<TotalOrderPrice>
    private OrderVO buildOrder(final String line) {
        try {
            String l[] = line.split(",");
            if (l.length < QT_ITEMS_REQUIRED) {
                System.out.println(String.format("Invalid line length [%s].", line));
                return null;
            }
            return new OrderVO(l[0], Double.parseDouble(l[2]), l[1]);
        } catch (Exception e) {
            //log error
            System.out.println(String.format("Invalid line [%s]. Error message [%s].", line, e.getMessage()));
        }
        return null;
    }
}