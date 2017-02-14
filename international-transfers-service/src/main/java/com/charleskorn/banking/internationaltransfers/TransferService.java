package com.charleskorn.banking.internationaltransfers;

import com.charleskorn.banking.internationaltransfers.persistence.Database;
import com.charleskorn.banking.internationaltransfers.services.ExchangeRateService;
import com.google.inject.Inject;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.OffsetDateTime;

public class TransferService {
    private final Database database;
    private final ExchangeRateService exchangeRateService;

    @Inject
    public TransferService(Database database, ExchangeRateService exchangeRateService) {
        this.database = database;
        this.exchangeRateService = exchangeRateService;
    }

    public Transfer createTransfer(String fromCurrency, String toCurrency, OffsetDateTime transferDate, BigDecimal originalAmount) {
        try {
            BigDecimal exchangeRate = this.exchangeRateService.getExchangeRate(fromCurrency, toCurrency, transferDate.toLocalDate());
            return this.database.saveTransfer(fromCurrency, toCurrency, transferDate, originalAmount, exchangeRate);
        } catch (IOException | SQLException e) {
            throw new RuntimeException("Could not save transfer.", e);
        }
    }
}
