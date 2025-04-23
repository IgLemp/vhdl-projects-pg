PHONY:
	ps2_mouse
	clean

ps2_mouse:
	nvc -a utils.vhdl display.vhdl decoder.vhdl driver.vhdl ps2_mouse.vhdl
	nvc -a tb_ps2_mouse.vhdl -e tb_ps2_mouse -r --wave

clean:
	rm *.fst
