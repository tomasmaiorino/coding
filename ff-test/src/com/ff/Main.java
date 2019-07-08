package com.ff;

import com.ff.service.CalculateCommissionServiceImpl;
import com.ff.service.OrderService;
import com.ff.service.ReadFileService;
import com.ff.service.impl.OrderServiceImpl;
import com.ff.vo.OrderVO;

import java.util.Locale;
import java.util.Objects;
import java.util.Set;

public class Main {

    private String filePath;
    private OrderService orderService = new OrderServiceImpl();
    private CalculateCommissionServiceImpl calculate = new CalculateCommissionServiceImpl();
    private ReadFileService readFileService = new ReadFileService();

    public Main(String filePath) {
        this.filePath = filePath;
    }

    public static void main(String[] args) {

        Main m = new Main(args[0]);
    }

    private void processOrders() {
        Set<String> lines = readFileService.readFile(this.filePath);

        Set<OrderVO> orderVOs = orderService.buildOrders(lines);

        Set<OrderVO> ordersResult = calculate.doesCalculation(orderVOs);

        ordersResult.forEach(order -> {
            System.out.printf(Locale.US, "%s, %.2f" + System.lineSeparator(), order.getBoutiqueId(),
                    Objects.isNull(order.getComissionValue()) ? order.getTotalOrderPrice() : order.getComissionValue())
        });

    }
}
