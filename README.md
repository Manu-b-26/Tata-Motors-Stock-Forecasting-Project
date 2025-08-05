# 📈 Tata Motors Stock Price & Volatility Forecasting

A time series forecasting project using ARIMA and GARCH models in R to analyze and predict the stock price and volatility of Tata Motors Limited.

---

## 📂 Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Methodology](#methodology)
- [Key Results](#key-results)
- [How to Run](#how-to-run)
- [Project Structure](#project-structure)
- [References](#references)

---

## 🧠 Overview

This project aims to:
- Analyze historical stock data of Tata Motors
- Forecast future stock prices using ARIMA
- Predict stock price volatility using GARCH
- Evaluate model performance using residual diagnostics
- Visualize trends, seasonality, and forecast confidence intervals

---

## ⚙️ Tech Stack

- **Language:** R  
- **Libraries:** `forecast`, `tseries`, `fGarch`, `ggplot2`, `rugarch`, `xts`

---

## 🔍 Methodology

1. **Data Acquisition**  
   - Daily stock prices of Tata Motors were collected via [source].

2. **Preprocessing**  
   - Handled missing values and transformed data into time series format.

3. **STL Decomposition**  
   - Used to separate trend, seasonality, and residuals.

4. **Stationarity Testing**  
   - ADF test and differencing to achieve stationarity.

5. **ARIMA Modeling**  
   - Identified appropriate (p,d,q) using ACF/PACF plots and AIC criteria.

6. **Residual Diagnostics**  
   - Checked residuals for white noise behavior and model adequacy.

7. **Volatility Modeling (GARCH)**  
   - Fitted a GARCH(1,1) model to capture heteroskedasticity.

---

## 📊 Key Results

- **ARIMA model:** Best fit was ARIMA(p,d,q) = ...
- **Forecast:** 10/30/60-day forecast with 95% CI
- **GARCH model:** Captured periods of high volatility
- **Diagnostics:** Residuals passed Ljung-Box and ARCH tests

---

## ▶️ How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/tata-motors-forecasting.git
   cd tata-motors-forecasting
