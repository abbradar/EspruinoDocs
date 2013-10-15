<!--- Copyright (c) 2013 Gordon Williams, Pur3 Ltd. See the file LICENSE for copying permission. -->
Analog to Digital Converter
=======================

* KEYWORDS: Analog,ADC,A2D

Analog inputs are easy to read in Espruino:

```analogRead(A0)```

This returns a value between 0 and 1 (internally ADCs in Espruino are usually 12 bits, but these are re-scaled).

**Note:** Not all pins are capable of Analog Input. See the [[Reference]] for your board ```ADC```.

Using Analog Inputs
------------------------

* APPEND_KEYWORD: ADC