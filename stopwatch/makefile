PHONY:
	stopwatch
	clean

stopwatch:
	nvc -a utils.vhdl disp.vhdl driver.vhdl stopwatch.vhdl
	nvc -a bounce.vhdl tb_stopwatch_sane.vhdl -e tb_stopwatch_sane -r --wave

clean:
	rm *.fst
