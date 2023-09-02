# garmin-watch-face

Data rich watch face for Garmin watches focusing on both current and historical readings.

### Compatibility

Currently targeting **Garmin Fenix 6** and minimum API version **3.2.0**.

### Features (TODO)

#### Basics

-   [x] 📆 Current time, day of week, month and date

#### Metrics

-   [ ] ❤️ Heart rate: current, daily resting, 7-day average resting, daily low and high
-   [ ] 📈 HRV: last night avg, 7-day data for: average night avg., lowest night avg., highest night avg.
-   [ ] 🌙 Sleep duration: last night, 7-day average/shortest/longest
-   [ ] ⚡ Body battery: current, higest today, lowest yesterday, 7-day average of the highest daily value
-   [ ] 😵 Stress Score: current, 7-day average/lowest/highest

If the current reading is also the highest or lowest reading, it will be highlighted. E.g. if last night's sleep duration was the longest of the last 7 days, it will be highlighted.

#### Additional features

-   [ ] 🌅 Sunrise and sunset times
-   [ ] ⏰ Next alarm (if on)
-   [ ] 🔋 Watch battery level

## 💻 Requirements

1. [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
2. VS Code with the [Monkey C Visual Studio Code Extension](https://developer.garmin.com/connect-iq/reference-guides/visual-studio-code-extension/)
3. Preferably a Garmin watch to test on
