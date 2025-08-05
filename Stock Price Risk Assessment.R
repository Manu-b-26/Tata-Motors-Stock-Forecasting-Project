# === Libraries ===
library(quantmod)
library(forecast)
library(ggplot2)
library(lubridate)
library(tseries)

# === Load Data ===
start_date <- Sys.Date() - years(10)
getSymbols("TATAMOTORS.NS", src = "yahoo", from = start_date, to = Sys.Date())
prices <- na.omit(Cl(TATAMOTORS.NS))

# === STL Decomposition ===
ts_prices <- ts(as.numeric(prices), frequency = 252)  # Approx 252 trading days/year
fit_stl <- stl(ts_prices, t.window = 22, s.window = "periodic", robust = TRUE)

# STL Forecast (Naive)
forecast_stl <- forecast(fit_stl, method = "naive")
autoplot(forecast_stl) + ggtitle('STL Forecast (Naive Method)')

# === ARIMA Model and Forecast ===
# Create ts object with proper start date
start_year <- year(index(prices)[1])
start_week <- week(index(prices)[1])  # Optional granularity
ts_prices <- ts(as.numeric(prices), frequency = 252, start = c(start_year, 1))

# Fit ARIMA
arima_model <- auto.arima(ts_prices)
print(arima_model)

# Forecast 60 periods ahead
arima_forecast <- forecast(arima_model, h = 60)
print(arima_forecast)

# Base Plot
plot(arima_forecast, main = "ARIMA Forecast: Tata Motors Price")

# Autoplot with Year Labels
autoplot(arima_forecast) +
  xlab("Year") + ylab("Price") +
  ggtitle("ARIMA Forecast: Tata Motors Price")

# === test plots ===
adf.test(prices)
par(mfrow = c(1, 2))  # Arrange plots side-by-side
acf(na.omit(diff_prices), main = "ACF of Differenced Series")
pacf(na.omit(diff_prices), main = "PACF of Differenced Series")

checkresiduals(arima_model)


# First difference the prices and test again
diff_prices <- diff(prices)
adf.test(na.omit(diff_prices))
print(adf.test(prices))                 # For raw prices
print(adf.test(na.omit(diff_prices)))
autoplot(diff_prices) +
  ggtitle("First Differenced Prices (To Check Stationarity)") +
  xlab("Date") + ylab("Differenced Price")

# === STL decomposition ===
plot(fit_stl, main = "STL Decomposition of Tata Motors Prices")


# === GARCH(1,1) ===
garch_spec <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
  distribution.model = "std"
)
garch_fit <- ugarchfit(spec = garch_spec, data = returns)
print(garch_fit)
plot(garch_fit, which = 1)
plot(garch_fit, which = 2)
garch_forecast <- ugarchforecast(garch_fit, n.ahead = 30)
print(garch_forecast)
plot(garch_forecast, main = "GARCH Forecast: Volatility")

# === EGARCH ===
egarch_spec <- ugarchspec(
  variance.model = list(model = "eGARCH", garchOrder = c(2, 1)),
  mean.model = list(armaOrder = c(2, 1), include.mean = TRUE),
  distribution.model = "std"
)
egarch_fit <- ugarchfit(spec = egarch_spec, data = returns)
print(egarch_fit)
plot(egarch_fit, which = 1)
plot(garch_fit, which = 2)
plot(garch_fit, which = 3)
egarch_forecast <- ugarchforecast(egarch_fit, n.ahead = 30)
print(egarch_forecast)
plot(egarch_forecast, main = "EGARCH Forecast: Volatility")

# === GJR-GARCH ===
gjr_spec <- ugarchspec(
  variance.model = list(model = "gjrGARCH", garchOrder = c(2, 2)),
  mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
  distribution.model = "std"
)
gjr_fit <- ugarchfit(spec = gjr_spec, data = returns)
print(gjr_fit)
plot(gjr_fit, which = 1)
gjr_forecast <- ugarchforecast(gjr_fit, n.ahead = 30)
print(gjr_forecast)
plot(gjr_forecast, main = "GJR-GARCH Forecast: Volatility")

# === Summary Metrics ===
cat("\nARIMA Coefficients:\n")
print(arima_model)

cat("\nGARCH Summary:\n")
print(garch_fit)

cat("\nEGARCH Summary:\n")
print(egarch_fit)

cat("\nGJR-GARCH Summary:\n")
print(gjr_fit)

# === (Optional) Export Returns and Volatility Estimates ===
vol_data <- data.frame(
  Date = index(returns),
  Returns = coredata(returns),
  GARCH_Vol = sigma(garch_fit),
  EGARCH_Vol = sigma(egarch_fit),
  GJR_Vol = sigma(gjr_fit)
)

write.csv(vol_data, "tata_volatility_analysis.csv", row.names = FALSE)

# Use ARIMA on returns
arima_returns <- auto.arima(returns)
print(arima_returns)
forecast_returns <- forecast(arima_returns, h = 30)
print(forecast_returns)
plot(forecast_returns, main = "ARIMA Forecast on Returns")