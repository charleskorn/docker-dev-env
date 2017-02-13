package com.charleskorn.banking.internationaltransfers;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

public class Transfer {
    private final UUID id;
    private final String fromCurrency;
    private final String toCurrency;
    private final OffsetDateTime transferDate;
    private final BigDecimal originalAmount;
    private final BigDecimal exchangeRate;

    public Transfer(UUID id, String fromCurrency, String toCurrency, OffsetDateTime transferDate, BigDecimal originalAmount, BigDecimal exchangeRate) {
        this.id = id;
        this.fromCurrency = fromCurrency;
        this.toCurrency = toCurrency;
        this.transferDate = transferDate;
        this.originalAmount = originalAmount;
        this.exchangeRate = exchangeRate;
    }

    public UUID getId() {
        return id;
    }

    public String getFromCurrency() {
        return fromCurrency;
    }

    public String getToCurrency() {
        return toCurrency;
    }

    public OffsetDateTime getTransferDate() {
        return transferDate;
    }

    public BigDecimal getOriginalAmount() {
        return originalAmount;
    }

    public BigDecimal getExchangeRate() {
        return exchangeRate;
    }

    public BigDecimal getConvertedAmount() {
        return this.originalAmount.multiply(this.exchangeRate);
    }
}
