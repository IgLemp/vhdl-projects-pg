PHONY:
	led_disp
	clean

led_disp:
	nvc -a basys3.vhdl ende.vhdl disp.vhdl led_disp.vhdl
	nvc -a tb_led_disp.vhdl -e tb_led_disp -r --wave

clean:
	rm *.fst
