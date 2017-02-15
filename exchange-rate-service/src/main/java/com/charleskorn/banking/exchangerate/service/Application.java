package com.charleskorn.banking.exchangerate.service;

import com.google.gson.Gson;
import spark.Request;
import spark.Response;

import java.math.BigDecimal;

import static spark.Spark.get;
import static spark.Spark.port;

public class Application {
    public static void main(String[] args) {
        port(6000);

        get("/ping", (req, res) -> "pong");
        get("/exchangerate/:from/:to/:year/:month/:day", Application::handleGetExchangeRate);
    }

    private static Object handleGetExchangeRate(Request req, Response res) {
        // If this was a real service we would have to do some error checking / validation here.
        String from = req.params("from");
        String to = req.params("to");
        int year = Integer.parseInt(req.params("year"));
        int month = Integer.parseInt(req.params("month"));
        int day = Integer.parseInt(req.params("day"));

        ExchangeRate exchangeRate = getExchangeRate(from, to, year, month, day);

        res.type("application/json");
        return new Gson().toJson(exchangeRate);
    }

    // If this was a real service this would go off to a database or something like that and get the real
    // exchange rate. Here we just make one up.
    private static ExchangeRate getExchangeRate(String from, String to, int year, int month, int day) {
        int multiplier = (from.hashCode() ^ to.hashCode()) % 100;
        double positionInYear = year * 365 + month * 31 + day; // Ugly hack but it's close enough
        BigDecimal rate = BigDecimal
                .valueOf(multiplier * 0.1 * (1.1 + Math.sin(positionInYear / (2 * Math.PI * 365))))
                .setScale(5, BigDecimal.ROUND_CEILING);

        return new ExchangeRate(from, to, year, month, day, rate);
    }
}
