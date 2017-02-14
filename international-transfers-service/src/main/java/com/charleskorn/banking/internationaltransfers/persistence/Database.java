package com.charleskorn.banking.internationaltransfers.persistence;

import com.charleskorn.banking.internationaltransfers.Transfer;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public interface Database {
    Transfer saveTransfer(String fromCurrency, String toCurrency, OffsetDateTime transferDate, BigDecimal originalAmount, BigDecimal exchangeRate) throws SQLException;
    List<Transfer> getAllTransfers() throws SQLException;
}
