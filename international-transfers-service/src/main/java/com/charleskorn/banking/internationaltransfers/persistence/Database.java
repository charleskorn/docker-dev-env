package com.charleskorn.banking.internationaltransfers.persistence;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

public interface Database {
    UUID saveTransfer(String fromCurrency, String toCurrency, OffsetDateTime transferDate, BigDecimal originalAmount, BigDecimal exchangeRate);
}
