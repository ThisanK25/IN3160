# Makefile

SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl

EXTRA_ARGS +=--std=08

TOPLEVEL = decoder
ARCH ?= select

VHDL_SOURCES += $(PWD)/../src/$(TOPLEVEL)_ent.vhd
VHDL_SOURCES += $(PWD)/../src/$(TOPLEVEL)_$(ARCH).vhd

SIM_ARGS +=--wave=$(TOPLEVEL)_$(ARCH).ghw

MODULE = tb_$(TOPLEVEL)_$(ARCH)

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	-@rm -f $(TOPLEVEL)
	-@rm -f e~$(TOPLEVEL).o