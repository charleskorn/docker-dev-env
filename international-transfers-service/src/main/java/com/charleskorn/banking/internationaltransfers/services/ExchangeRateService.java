package com.charleskorn.banking.internationaltransfers.services;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ExchangeRateService {
    public BigDecimal getExchangeRate(String fromCurrency, String toCurrency, LocalDate effectiveDate) {
        throw new RuntimeException("Not implemented");
    }
}
