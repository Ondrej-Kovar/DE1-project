# RGB mood lamp
  VHDL code for RGB lamp to enlighten your day. Fading colours with adjustable brightness and speed of color change. Designed for Nexys A7-50T board.
## Main functions
 - fading efect of rgb LED
 - modifying brightness of LED
 - modifying speed of colour change

## Description
  RGB LED is glowing with fading effect, you can use buttons to either change brightness or colour change speed. LED is supplied with PWM signal for each colour, pressing corresponding buttons changes duty cycle of those PWMs.
  
![block diagram](main/block_scheme.drawio.png)

### Debounce
  Module making sure one press of button is registered as one pulse. 
