PHONY:
	stopwatch
	clean

stopwatch:
	nvc -a utils.vhdl disp.vhdl driver.vhdl stopwatch.vhdl
	nvc -a tb_stopwatch.vhdl -e tb_stopwatch -r --wave

clean:
	rm *.fst
