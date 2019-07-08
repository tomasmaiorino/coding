package com.ff.vo;

/**
 * Created by tomas on 7/7/19.
 */
public class OrderVO {



    private boolean higherVal = false;

    private String boutiqueId;

    private String orderId;

    private Double totalOrderPrice;

    private Double comissionValue;

    public OrderVO() {
    }

    public OrderVO(String id, Double value, String boutiqueId) {
        this.orderId = id;
        this.totalOrderPrice = value;
        this.boutiqueId = boutiqueId;
    }

    public String getBoutiqueId() {
        return boutiqueId;
    }

    public void setBoutiqueId(String boutiqueId) {
        this.boutiqueId = boutiqueId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Double getTotalOrderPrice() {
        return totalOrderPrice;
    }

    public boolean isHigherVal() {
        return higherVal;
    }

    public void setHigherVal(boolean higherVal) {
        this.higherVal = higherVal;
    }

    public void setTotalOrderPrice(Double totalOrderPrice) {
        this.totalOrderPrice = totalOrderPrice;
    }

    public Double getComissionValue() {
        return comissionValue;
    }

    public void setComissionValue(Double comissionValue) {
        this.comissionValue = comissionValue;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        OrderVO orderVO = (OrderVO) o;

        if (!boutiqueId.equals(orderVO.boutiqueId)) return false;
        return orderId.equals(orderVO.orderId);

    }

    @Override
    public int hashCode() {
        int result = boutiqueId.hashCode();
        result = 31 * result + orderId.hashCode();
        return result;
    }
}
