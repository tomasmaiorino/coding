package com.service;

import com.ff.exception.CalculateCommissionExcepetion;
import com.ff.service.CalculateCommissionServiceImpl;
import com.ff.vo.OrderVO;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import static com.ff.service.CalculateCommissionServiceImpl.PERCENTAGE_TO_ADD;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.nullValue;

/**
 * Created by tomas on 7/8/19.
 */
public class CalculateCommissionServiceImplTest {

    private CalculateCommissionServiceImpl service;

    @Before
    public void setUp() {
        service = new CalculateCommissionServiceImpl();
    }

    @Test(expected = CalculateCommissionExcepetion.class)
    public void doesCalculation_NullLinesGiven_ShouldThrowException() {
        Set<OrderVO> orders = null;

        service.doesCalculation(orders);
    }

    @Test(expected = CalculateCommissionExcepetion.class)
    public void doesCalculation_EmptyLinesGiven_ShouldThrowException() {
        Set<OrderVO> orders = Collections.emptySet();

        service.doesCalculation(orders);
    }

    @Test
    public void doesCalculation_ValidOrdersWithDifferentValueGiven_ShouldReturnNotNullResult() {
        final Double commonValue = 100d;
        Set<OrderVO> orders = new HashSet<>();
        OrderVO orderVO = new OrderVO();
        orderVO.setBoutiqueId("1");
        orderVO.setTotalOrderPrice(commonValue);
        orderVO.setOrderId("o1");
        orders.add(orderVO);

        orderVO = new OrderVO();
        orderVO.setBoutiqueId("2");
        orderVO.setTotalOrderPrice(commonValue);
        orderVO.setOrderId("o2");
        orders.add(orderVO);

        orderVO = new OrderVO();
        orderVO.setBoutiqueId("3");
        orderVO.setTotalOrderPrice(103.);
        orderVO.setOrderId("o3");
        orders.add(orderVO);

        Set<OrderVO> result = service.doesCalculation(orders);
        Assert.assertNotNull(result);
    }

    @Test
    public void doesCalculation_ValidOrdersWithDifferentValueGiven_ShouldReturnSaveSizeOrdersSet() {
        final Double commonValue = 100d;
        Set<OrderVO> orders = new HashSet<>();
        OrderVO orderVO = new OrderVO();
        orderVO.setBoutiqueId("1");
        orderVO.setTotalOrderPrice(commonValue);
        orderVO.setOrderId("o1");
        orders.add(orderVO);

        orderVO = new OrderVO();
        orderVO.setBoutiqueId("2");
        orderVO.setTotalOrderPrice(commonValue);
        orderVO.setOrderId("o2");
        orders.add(orderVO);

        orderVO = new OrderVO();
        orderVO.setBoutiqueId("3");
        orderVO.setTotalOrderPrice(103.);
        orderVO.setOrderId("o3");
        orders.add(orderVO);

        Set<OrderVO> result = service.doesCalculation(orders);
        Assert.assertThat(result.size(), is(orders.size()));
    }

    @Test
    public void doesCalculation_ValidOrdersWithDifferentValueGiven_ShouldReturnValidOrders() {
        final Double commonValue = 100d;
        Set<OrderVO> orders = new HashSet<>();
        OrderVO orderVO1 = new OrderVO();
        orderVO1.setBoutiqueId("1");
        orderVO1.setTotalOrderPrice(commonValue);
        orderVO1.setOrderId("o1");
        orders.add(orderVO1);

        OrderVO orderVO2 = new OrderVO();
        orderVO2.setBoutiqueId("2");
        orderVO2.setTotalOrderPrice(commonValue);
        orderVO2.setOrderId("o2");
        orders.add(orderVO2);

        OrderVO orderVO3 = new OrderVO();
        orderVO3.setBoutiqueId("3");
        orderVO3.setTotalOrderPrice(103.);
        orderVO3.setOrderId("o3");
        orders.add(orderVO3);

        Set<OrderVO> result = service.doesCalculation(orders);

        OrderVO order3 = result.stream().filter(o -> o.getOrderId().equals(orderVO3.getOrderId())).findFirst().get();
        OrderVO order2 = result.stream().filter(o -> o.getOrderId().equals(orderVO2.getOrderId())).findFirst().get();
        OrderVO order1 = result.stream().filter(o -> o.getOrderId().equals(orderVO1.getOrderId())).findFirst().get();

        Assert.assertThat(order3.getComissionValue(), is(nullValue()));
        Assert.assertThat(order2.getComissionValue(), is(
                orderVO2.getTotalOrderPrice() * PERCENTAGE_TO_ADD / 100));
        Assert.assertThat(order1.getComissionValue(), is(
                orderVO1.getTotalOrderPrice() * PERCENTAGE_TO_ADD / 100));
    }
}
