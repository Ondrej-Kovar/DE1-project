# RGB mood lamp
  VHDL code for RGB lamp to enlighten your day. Fading colours with adjustable brightness and speed of color change. Designed for Nexys A7-50T board.
## Main functions
 - fading efect of rgb LED
 - modifying brightness of LED
 - modifying speed of colour change

## Description
  RGB LED is glowing with fading effect, you can use buttons to change either brightness or colour change speed. LED is supplied with PWM signal for each colour, pressing corresponding buttons changes duty cycle of those PWMs.
  
![block diagram](main/block_scheme.drawio.png)

### Debounce
  Module making sure one press of button is registered as one pulse. With every rising edge of clock signal (clk) algorythm checks whether is button signalizing "pressed" long enough. This diferentitates pressing of button from bouncing after pressing. Outputs are logic variables btn_pressed and btn_state.

### Clk_en
  Easy solution to lower frequency of clk. Rising edges are counted, overflow of counter releases output pulse.

### Bright_control
  This module is basically counter whose inputs are two button states. On every rising edge of clk if only one of inputs has rising edge, output (8 bit number) is incremented. If both inputs are on rising edge, nothing happens, if either of buttons is held, after some time, output number is incremented periodically.

### Clk_en_dyn
  Clk_en_dyn combines functions of Clk_en and Bright_control. Input rising edge increments counter capacity changing frequency of output signal.

### Fade
  Module periodically transitioning through spectre of colours. If red is on maximum level, green starts to rise, once green hits maximum, red starts to fall. When red hits minimum, blue starts to rise and so on. Outputs are 8bit numbers for corresponding colours.
