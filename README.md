# Intelligent Planting Management and Monitoring System based on ATmega16

## Content

This system is composed of AT mega16 MCU circuit +LCD1602 LCD circuit + light detection circuit + soil moisture sensor circuit +A/D sampling PCF8591 circuit + fan control circuit + relay control circuit + bright LED light filling circuit + bright LED light heating circuit + key control circuit + power circuit.

1. The photoresistor detects the light intensity, and then after processing by A/D module PCF8591, the light intensity value is displayed on the LCD screen in real time, and you can control the light intensity value by pressing the button, when the light is lower than the set threshold, a white high-light LED lights up to fill the light, if the light is higher than the set threshold, no action.
2. DS18B20 detects the temperature value, and displays it on the LCD screen in real time, and can set the temperature value by pressing the button, when the temperature is lower than the set value, through a yellow high-lighted LED light to simulate heating. When the temperature exceeds the set value, the fan rotates to dissipate heat.
3. The soil moisture sensor detects the soil moisture, and the humidity value is displayed on the LCD screen in real time, and the soil moisture value can be set, when the soil moisture is less than the set threshold, the pump adds water. When the value is greater than the threshold, no action is taken.

<div align=center><img src="https://i.imgur.com/cH7ZOst.png" width="60%"></div>

The intelligent planting management system is characterized by energy saving, emission reduction and intelligence. Overall function: display the above set threshold; Button switch Settings, adjust the setting threshold; If the light is not enough, automatically fill the light; If the temperature is too high, it will cool down, and if the temperature is too low, it will warm up. If the humidity is too high, the humidity will decrease, and if the humidity is too low, the humidity will increase. Simple line, fast operation.

## Application Prospect

This intelligent planting management system has broad application prospects in intelligent agriculture, intelligent greenhouse, intelligent garden and other fields. Through automatic monitoring and control of the planting environment, planting efficiency can be improved, costs can be reduced, quality can be improved, and agricultural production and urban greening can be contributed.

Combined with the modernization of agriculture and rural areas mentioned in the 14th Five-Year Plan for National Economic and Social Development of the People's Republic of China and the Outline of 2035 Vision Goals, the software can alleviate the pressure of manpower problems through automation after landing deployment, and realize the true sense of resource waste, energy saving and emission reduction through automatic control. 

Specifically, it can be used in the following aspects:

1. **Agricultural production:** Intelligent planting management system can improve the efficiency of agricultural production, reduce costs, improve quality, and bring more benefits to farmers and farm operators.

2. **Urban greening:** Intelligent planting management system can be used in urban greening projects to help maintain the urban landscape environment and create a good urban atmosphere.

3. **Tourist agriculture:** The intelligent planting management system can be used to maintain the landscape environment of tourist agriculture, and ensure the growth and development of plants by real-time monitoring and adjusting the planting environment. This will help attract more tourists and bring more revenue to tourism agriculture.

In addition, intelligent planting management systems can also be used in research and development, biopharmaceutical, healthcare and other fields. Through the fine control of the planting environment, it can promote the growth and development of plants, and provide support for the research and development of new biopharmaceuticals and improve the quality of medical care services.

In short, the intelligent planting management system has broad application prospects and can bring more convenience and benefits to various industries and fields.

## Develop Equipment and Tools

**Components and Tools:**

Mega16 single chip microcomputer, DS18B20 temperature sensor, PCF8591 ADC module, motor, relay, transistor, sliding rheostat, switch, LED, key, resistor, etc.

**Development tools:**

PC, CodeVision AVR integrated development software, Proteus, etc.

### DS18B20 Temperature Sensor

The temperature range is -55 ° C to +125 ° C, and the error is ±0.4° in the range of -10 °C to +85 °C.

<img src="https://i.imgur.com/P3mF8rA.png" width="50%">

GND: Power ground cable.

DQ: digital signal input/output.

VCC: external power supply input.

**When the five symbol bits S=0**, the temperature is positive, directly convert the following 11 bits of binary to decimal, and then multiply by 0.0625(12-bit resolution), you can get the temperature value.

**When the five symbol bits S=1**, the temperature is negative, and the following 11 bits of binary complement are changed into the original code (the symbol bit is unchanged, the numerical bit is reversed and added by 1), and then the decimal value is calculated. Multiply this by 0.0625(12-bit resolution) to get the temperature value.

### LCD1602

<img src="https://i.imgur.com/Y4JCdVh.png" width="50%">

<img src="https://i.imgur.com/kR0hANM.png" width="40%">

*The button used to set the threshold.*

**LCD1602 RAM address map and standard font table:**

<img src="https://i.imgur.com/8qnSvXF.png" width="40%">

This ROM solidifies some commonly used ASCII characters and some Japanese characters dot matrix data, you need to write that character, you can directly set the corresponding code, such as the uppercase letter A, the code is 0100 0001 (41H) consistent with the ASCII code. That is, the address of the ASCII character in the table is the same as the actual ASCII character.

**Reading time slots**

<img src="https://i.imgur.com/cEktcrn.png" width="60%">

**Writing time slots**

<img src="https://i.imgur.com/A1aDmeM.png" width="60%">

### PCF8591

The PCF8591 is an 8-bit A/D and D/A conversion chip with an IIC interface, with four analog inputs, one DAC output, and one IIC bus interface.

<img src="https://i.imgur.com/l4Ogkor.png" width="50%">

At the beginning of A A/D conversion cycle, always after sending a valid read device address to the PCF8591, A/D conversion is triggered on the back edge of the reply clock pulse. 

The PCF8591 A/D conversion programming process can be divided into four steps:

1-- Send write device address, select the PCF8591 device on the IIC bus.

2-- Send control bytes, select analog input mode and channel.

3-- Send read device address, select the PCF8591 device on the IIC bus.

4-- Read the data of the target channel in PCF8591.

Here it is mainly used to convert the analog values of soil moisture and light intensity to the digital values that can be processed.

### Fan

<img src="https://i.imgur.com/vGM02Ee.png" width="40%">

The fan circuit is mainly built by triode, resistor and field effect tube, and the specific principle is as follows:

When A6 is 1, the high level, the transistor is not on, the current does not flow through the fan, the fan is off, and the LED light is not bright.

When A6 is 0, it is low, there is no output voltage, the transistor is on, the current flows through the fan, the fan is on, and the LED light is on.

### Water Pump

<img src="https://i.imgur.com/7uSioU7.png" width="50%">

The circuit is mainly composed of triode, resistor, LED, electromagnetic relay, motor, the specific working mode is:

D0 is high, at this time the transistor is not on, at this time the collector pump motor is not on.

D0 is low level, the lower collector of the triode is high level and on, and then the electromagnetic coil is energized to generate magnetism, adsorption switch, and the motor is on.

### Fill Light and Heat

<img src="https://i.imgur.com/RsAnKaM.png" width="60%">

*The light that supplements heat is on the left and the light that supplements light is on the right*

Both of them are composed of light-emitting diodes and resistors. A3/A4 is usually not conductive at high voltage. At low voltage, the on-light is on.

### Soil Moisture and Light Intensity

<img src="https://i.imgur.com/fmOrf9S.png" width="60%">

This module is mainly composed of voltmeter and resistor, and the corresponding voltage change on the sliding rheostat represents the actual voltage change on the soil moisture detection device due to the photosensitive device.

## Demonstration

### Temperature

When the ambient temperature is above the threshold, the fan module starts working, the LIGHT8 lights up, and the motor starts running:

<img src="https://i.imgur.com/BK7SlmE.png" width="100%">

When the ambient temperature is lower than the threshold, the supplementary temperature light will turn on:

<img src="https://i.imgur.com/beb8nag.png" width="100%">

### Light Intensity

When the ambient light intensity is higher than the threshold, no action is taken:

<img src="https://i.imgur.com/tpCF9sm.png" width="100%">

When the ambient light intensity is below the threshold, the light will turn on:

<img src="https://i.imgur.com/6Jzq0EX.png" width="100%">

### Humidity

When the soil moisture is higher than the threshold, nothing is done, the pump does not operate, and the LIGHT1 is not bright:

<img src="https://i.imgur.com/owNCE57.jpg" width="100%">

When the soil moisture falls below the threshold, the pump starts running and LIGHT1 lights up:

<img src="https://i.imgur.com/VGQy5YC.png" width="100%">

## Video Demo (CN Version)

[<div align=center><img src="https://i.imgur.com/Gk6BYng.jpg" width="70%"></div>](https://www.youtube.com/watch?v=R3Pz3viNpK0)

## Chinese Software Copyright Certificate

<div align=center><img src="https://i.imgur.com/8nzwq9f.jpg" width="50%"></div>
