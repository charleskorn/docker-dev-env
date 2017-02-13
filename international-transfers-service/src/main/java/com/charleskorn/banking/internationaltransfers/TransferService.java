package com.charleskorn.banking.internationaltransfers;

import com.charleskorn.banking.internationaltransfers.persistence.Database;
import com.charleskorn.banking.internationaltransfers.services.ExchangeRateService;
import com.google.inject.Inject;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

public class TransferService {
    private final Database database;
    private final ExchangeRateService exchangeRateService;

    @Inject
    public TransferService(Database database, ExchangeRateService exchangeRateService) {
        this.database = database;
        this.exchangeRateService = exchangeRateService;
    }

    public Transfer createTransfer(String fromCurrency, String toCurrency, OffsetDateTime transferDate, BigDecimal originalAmount) {
        BigDecimal exchangeRate = this.exchangeRateService.getExchangeRate(fromCurrency, toCurrency, transferDate.toLocalDate());
        UUID id = this.database.saveTransfer(fromCurrency, toCurrency, transferDate, originalAmount, exchangeRate);

        return new Transfer(id, fromCurrency, toCurrency, transferDate, originalAmount, exchangeRate);
    }
}
