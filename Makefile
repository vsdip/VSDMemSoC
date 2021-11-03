SRC_PATH = src
LIB_PATH = $(SRC_PATH)/lib
GDS_PATH = $(SRC_PATH)/gds
LEF_PATH = $(SRC_PATH)/lef
MODULE_PATH = $(SRC_PATH)/module
INCLUDE_PATH = $(SRC_PATH)/include
LAYOUT_CONF_PATH = $(SRC_PATH)/layout_conf
OUTPUT_PATH = output
OPENLANE_PATH = /home/manili/OpenLane
PDKS_PATH = $(OPENLANE_PATH)/pdks
OPENLANE_VER = mpw-3a

STA_PATH = $(OUTPUT_PATH)/sta
SYNTH_PATH = $(OUTPUT_PATH)/synth
COMPILED_TLV_PATH = $(OUTPUT_PATH)/compiled_tlv
PRE_SYNTH_SIM_PATH = $(OUTPUT_PATH)/pre_synth_sim
POST_SYNTH_SIM_PATH = $(OUTPUT_PATH)/post_synth_sim

.PHONY: all
all: sim

.PHONY: sim
sim: pre_synth_sim post_synth_sim

.PHONY: clean
clean:
	rm -rf $(OUTPUT_PATH)

.PHONY: mount
mount:
	docker run -it --rm \
		-v $(OPENLANE_PATH):/openLANE_flow \
		-v $(OPENLANE_PATH)/pdks:/openLANE_flow/pdks \
		-v $(shell pwd):/VSDMemSoC \
		-e PDK_ROOT=/openLANE_flow/pdks \
		-u 1000:1000 \
		efabless/openlane:$(OPENLANE_VER) \
		bash

$(COMPILED_TLV_PATH): $(MODULE_PATH)/*.tlv
	sandpiper-saas -i $< -o rvmyth.v \
		--bestsv --noline -p verilog --outdir $@

pre_synth_sim: $(COMPILED_TLV_PATH)
	if [ ! -f "$(PRE_SYNTH_SIM_PATH)/pre_synth_sim.vcd" ]; then \
		mkdir -p $(PRE_SYNTH_SIM_PATH); \
		iverilog -o $(PRE_SYNTH_SIM_PATH)/pre_synth_sim.out -DPRE_SYNTH_SIM \
			$(MODULE_PATH)/testbench.v \
			-I $(SRC_PATH)/include -I $(MODULE_PATH) -I $(COMPILED_TLV_PATH); \
		cd $(PRE_SYNTH_SIM_PATH); ./pre_synth_sim.out; \
	fi

post_synth_sim: synth
	if [ ! -f "$(POST_SYNTH_SIM_PATH)/post_synth_sim.vcd" ]; then \
		mkdir -p $(POST_SYNTH_SIM_PATH); \
		iverilog -o $(POST_SYNTH_SIM_PATH)/post_synth_sim.out -DPOST_SYNTH_SIM -DFUNCTIONAL -DUNIT_DELAY=#1 \
			$(MODULE_PATH)/testbench.v \
			-I $(SRC_PATH)/include -I $(MODULE_PATH) -I $(SRC_PATH)/gls_model -I $(SYNTH_PATH); \
		cd $(POST_SYNTH_SIM_PATH); ./post_synth_sim.out; \
	fi

post_routing_sim: controller_layout
	if [ ! -f "$(OUTPUT_PATH)/rvmyth_layout/post_routing_sim.vcd" ]; then \
		iverilog -o $(OUTPUT_PATH)/rvmyth_layout/post_routing_sim.out \
			-DFUNCTIONAL -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
			$(MODULE_PATH)/testbench.rvmyth.post-routing.v \
			$(OUTPUT_PATH)/rvmyth_layout/rvmyth_test/results/lvs/rvmyth.lvs.powered.v \
			-I $(SRC_PATH)/gls_model; \
		cd $(OUTPUT_PATH)/rvmyth_layout; ./post_routing_sim.out; \
	fi

synth: $(COMPILED_TLV_PATH)
	if [ ! -f "$(SYNTH_PATH)/vsdmemsoc.synth.v" ]; then \
		mkdir -p $(SYNTH_PATH); \
		docker run -it --rm \
			-v $(OPENLANE_PATH):/openLANE_flow \
			-v $(OPENLANE_PATH)/pdks:/openLANE_flow/pdks \
			-v $(shell pwd):/VSDMemSoC \
			-e PDK_ROOT=/openLANE_flow/pdks \
			-u 1000:1000 \
			efabless/openlane:$(OPENLANE_VER) \
			bash -c "cd /VSDMemSoC/src; yosys -s /VSDMemSoC/src/script/yosys.ys | tee ../output/synth/synth.log"; \
	fi

sta: synth
	if [ ! -f "$(STA_PATH)/sta.log" ]; then \
		mkdir -p $(STA_PATH); \
		docker run -it --rm \
			-v $(OPENLANE_PATH):/openLANE_flow \
			-v $(OPENLANE_PATH)/pdks:/openLANE_flow/pdks \
			-v $(shell pwd):/VSDMemSoC \
			-e PDK_ROOT=/openLANE_flow/pdks \
			-u 1000:1000 \
			efabless/openlane:$(OPENLANE_VER) \
			bash -c "cd /VSDMemSoC/src; sta -exit -threads max /VSDMemSoC/src/script/sta.conf | tee ../output/sta/sta.log"; \
	fi

controller_layout: $(COMPILED_TLV_PATH)
	if [ ! -d "$(OUTPUT_PATH)/controller_layout/layout.log" ]; then \
		mkdir -p $(OUTPUT_PATH)/controller_layout; \
		mkdir -p $(OUTPUT_PATH)/controller_layout/controller; \
		mkdir -p $(OUTPUT_PATH)/controller_layout/controller/src; \
		mkdir -p $(OUTPUT_PATH)/controller_layout/controller/src/module; \
		mkdir -p $(OUTPUT_PATH)/controller_layout/controller/src/include; \
		cp -r $(LAYOUT_CONF_PATH)/controller/* $(OUTPUT_PATH)/controller_layout/controller; \
		cp $(COMPILED_TLV_PATH)/rvmyth.v $(OUTPUT_PATH)/controller_layout/controller/src/module; \
		cp $(MODULE_PATH)/controller.v $(OUTPUT_PATH)/controller_layout/controller/src/module; \
		cp $(MODULE_PATH)/clk_gate.v $(OUTPUT_PATH)/controller_layout/controller/src/module; \
		cp $(COMPILED_TLV_PATH)/rvmyth_gen.v $(OUTPUT_PATH)/controller_layout/controller/src/include; \
		cp $(INCLUDE_PATH)/*.vh $(OUTPUT_PATH)/controller_layout/controller/src/include; \
		docker run -it --rm \
			-v $(OPENLANE_PATH)/pdks:/openlane/pdks \
			-v $(shell pwd):/VSDMemSoC \
			-v $(shell pwd)/$(OUTPUT_PATH)/controller_layout/controller:/openlane/designs/controller \
			-e PDK_ROOT=/openlane/pdks \
			-u 1000:1000 \
			efabless/openlane:$(OPENLANE_VER) \
			bash -c "./flow.tcl -design controller -tag controller_test | tee /VSDMemSoC/output/controller_layout/layout.log"; \
	fi

vsdmemsoc_layout: controller_layout
	if [ ! -d "$(OUTPUT_PATH)/vsdmemsoc_layout/layout.log" ]; then \
		mkdir -p $(OUTPUT_PATH)/vsdmemsoc_layout; \
		mkdir -p $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc; \
		mkdir -p $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src; \
		mkdir -p $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/module; \
		mkdir -p $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/blackbox; \
		mkdir -p $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/gds; \
		mkdir -p $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/lef; \
		cp -r $(LAYOUT_CONF_PATH)/vsdmemsoc/* $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc; \
		cp $(MODULE_PATH)/vsdmemsoc.v $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/module; \
		cp $(INCLUDE_PATH)/*.v $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/blackbox; \
		cp $(LEF_PATH)/*.lef $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/lef; \
		cp $(GDS_PATH)/*.gds $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/gds; \
		cp $(MODULE_PATH)/controller.v $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/blackbox; \
		cp $(OUTPUT_PATH)/controller_layout/controller/runs/controller_test/results/magic/controller.lef $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/lef; \
		cp $(OUTPUT_PATH)/controller_layout/controller/runs/controller_test/results/magic/controller.gds $(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc/src/gds; \
		docker run -it --rm \
			-v $(OPENLANE_PATH)/pdks:/openlane/pdks \
			-v $(shell pwd):/VSDMemSoC \
			-v $(shell pwd)/$(OUTPUT_PATH)/vsdmemsoc_layout/vsdmemsoc:/openlane/designs/vsdmemsoc \
			-e PDK_ROOT=/openlane/pdks \
			-u 1000:1000 \
			efabless/openlane:$(OPENLANE_VER) \
			bash -c "./flow.tcl -design vsdmemsoc -tag vsdmemsoc_test | tee /VSDMemSoC/output/vsdmemsoc_layout/layout.log"; \
	fi
