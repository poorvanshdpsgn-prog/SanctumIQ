# Sanctum IQ diagnostics sketch

This sketch implements the serial protocol used by the Sanctum IQ website. It
is a starter for the component list currently shown in the site, not a
replacement for your project firmware.

## Assumed setup

- Arduino Uno-compatible board, using `115200` baud.
- HC-SR04 ultrasonic sensor: TRIG on D7, ECHO on D8.
- RC522 RFID reader: SDA/SS on D10, RST on D9, with SPI on the board's normal
  SPI pins.
- Analog moisture sensor signal on A0.
- DS3231 RTC on I2C address `0x68`.
- SSD1306 OLED on I2C address `0x3C` or `0x3D`.

**Check the pin assignments against your actual wiring before uploading.** The
RTC and OLED share I2C. Install the `MFRC522` library by Miguel Balboa and
`RTClib` by Adafruit from Arduino IDE Library Manager.

## Website protocol

The website opens serial at `115200` baud and sends one line:

```json
{"protocol":"sanctum-iq/1","command":"diagnostics"}
```

The sketch responds with one JSON line using the component keys the website
reads: `arduino`, `ultrasonic`, `moisture`, `rfid`, `servo`, `rtc`, and `oled`.

The ultrasonic check needs a plausible echo. RFID checks that the reader
returns a usable version register value. RTC checks I2C communication and its
lost-power flag. OLED checks for an I2C acknowledgement; that confirms a device
at the configured display address, not that every pixel works.

Moisture is `NOT TESTED` because an unplugged analog input cannot reliably be
distinguished from a valid sensor reading without calibration or extra wiring.
Servo is `NOT TESTED` because movement cannot be verified without position
feedback. Add a feedback sensor or a user-observed movement test before marking
either one healthy.

This sketch does not restore firmware. It does not test the actual RFID card,
moisture readings, OLED pixels, or servo movement. It has not been uploaded to
or tested on your physical board. If your wiring differs, change the pin/address
constants and recheck electrical compatibility before powering the circuit.
