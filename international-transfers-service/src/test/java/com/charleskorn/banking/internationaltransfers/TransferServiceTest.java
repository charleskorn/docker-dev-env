package com.charleskorn.banking.internationaltransfers;

import com.charleskorn.banking.internationaltransfers.persistence.Database;
import com.charleskorn.banking.internationaltransfers.services.ExchangeRateService;
import org.junit.Test;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.UUID;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;
import static org.mockito.Mockito.*;

public class TransferServiceTest {
    @Test
    public void createTransfer_happyPath_retrievesExchangeRateAndSavesTransferToDatabase() throws SQLException {
        Database database = mock(Database.class);
        ExchangeRateService exchangeRateService = mock(ExchangeRateService.class);
        TransferService service = new TransferService(database, exchangeRateService);

        String fromCurrency = "AUD";
        String toCurrency = "EUR";
        OffsetDateTime transferDate = OffsetDateTime.of(2017, 2, 13, 16, 17, 21, 0, ZoneOffset.UTC);
        BigDecimal originalAmount = new BigDecimal("12.30");
        BigDecimal exchangeRate = new BigDecimal("1.2");
        UUID id = UUID.fromString("88888888-4444-4444-4444-121212121212");
        Transfer createdTransfer = new Transfer(id, fromCurrency, toCurrency, transferDate, originalAmount, exchangeRate);

        when(exchangeRateService.getExchangeRate(fromCurrency, toCurrency, LocalDate.of(2017, 2, 13))).thenReturn(exchangeRate);
        when(database.saveTransfer(fromCurrency, toCurrency, transferDate, originalAmount, exchangeRate)).thenReturn(createdTransfer);

        Transfer returnedTransfer = service.createTransfer(fromCurrency, toCurrency, transferDate, originalAmount);

        verify(database).saveTransfer(fromCurrency, toCurrency, transferDate, originalAmount, exchangeRate);
        assertThat(returnedTransfer, is(createdTransfer));
    }
}
