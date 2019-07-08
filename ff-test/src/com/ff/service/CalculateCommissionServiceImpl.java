package com.ff.service;

import com.ff.exception.CalculateCommissionExcepetion;
import com.ff.vo.OrderVO;

import java.util.Comparator;
import java.util.Objects;
import java.util.Set;

/**
 * Created by tomas on 7/7/19.
 */
public class CalculateCommissionServiceImpl {


    public static final int PERCENTAGE_TO_ADD = 10;

    public Set<OrderVO> doesCalculation(final Set<OrderVO> orders) {

        if (Objects.isNull(orders) || orders.isEmpty()) {
            throw new CalculateCommissionExcepetion("The orders must not be null nor empty!");
        }

        return calculate(orders);
    }

    private Double doesCalculation(final OrderVO c) {
        return c.getTotalOrderPrice() * PERCENTAGE_TO_ADD / 100;
    }

    private Set<OrderVO> calculate(final Set<OrderVO> orders) {

        OrderVO o = orders.stream().max(Comparator.comparingDouble(OrderVO::getTotalOrderPrice)).orElse(null);

        if (Objects.nonNull(o)) {
            o.setHigherVal(true);
        }

        orders.stream().forEach(c -> {
            if (!c.isHigherVal()) {
                c.setComissionValue(doesCalculation(c));
            }
        });

        return orders;
    }
}
