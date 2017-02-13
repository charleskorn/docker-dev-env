package com.charleskorn.banking.exchangerate.service;

import java.math.BigDecimal;

public class ExchangeRate {
    private final String fromCurrency;
    private final String toCurrency;
    private final int year;
    private final int month;
    private final int day;
    private final BigDecimal rate;

    public ExchangeRate(String fromCurrency, String toCurrency, int year, int month, int day, BigDecimal rate) {
        this.fromCurrency = fromCurrency;
        this.toCurrency = toCurrency;
        this.year = year;
        this.month = month;
        this.day = day;
        this.rate = rate;
    }

    public String getFromCurrency() {
        return fromCurrency;
    }

    public String getToCurrency() {
        return toCurrency;
    }

    public int getYear() {
        return year;
    }

    public int getMonth() {
        return month;
    }

    public int getDay() {
        return day;
    }

    public BigDecimal getRate() {
        return rate;
    }
}
