PHONY:
	parity
	funkcja
	gray
	johnson
	dzielnik
	# led_disp

	work
	clean

simulate = nvc -a $(1).vhdl tb_$(1).vhdl -e tb_$(1) -r --wave

parity:
	@$(call simulate,parity)

funkcja:
	@$(call simulate,funkcja)

gray:
	@$(call simulate,gray)

johnson:
	@$(call simulate,johnson)

dzielnik:
	@$(call simulate,dzielnik)

led_disp:
	@$(call simulate,led_disp)

all: parity funkcja gray johnson dzielnik

clean:
	rm *.fst
