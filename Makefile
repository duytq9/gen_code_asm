# Coverage options
CM_OPTION   = -cm line+cond+path+branch+tgl
CM_HIER     = -cm_hier ./code_coverage/config_file
CM_DIR_BASE = ./testcase_database

# VCS
comp:
	@rm -rf $(LOG_DIR)
	@mkdir $(LOG_DIR)
	vcs $(COMP_OPTION) $(DEFINE_OPTION) -f filelist.f \
	-error=PCWM-L -error=noZMMCM \
	-debug_acc+all -debug_region+cell+encrypt -debug_acc+pp+dmptf +define+PRINTF_COND=0 \
	+define+RANDOMIZE_MEM_INIT +define+RANDOMIZE_REG_INIT +define+RANDOMIZE_GARBAGE_ASSIGN +define+RANDOMIZE_INVALID_ASSIGN \
	$(CM_OPTION) $(CM_HIER) \
	-l $(LOG_DIR)/comp.log -o simv -licqueue -top tb_top +lint=TFIPC-L

# Pattern rule: tự tạo thư mục coverage riêng cho từng testcase
run_%: comp
	@mkdir -p $(CM_DIR_BASE)/$*
	./simv +UVM_TESTNAME=$*_test +UVM_VERBOSITY=UVM_MEDIUM \
	$(CM_OPTION) -cm_dir $(CM_DIR_BASE)/$*/simv.cm.vdb \
	-l $*.log

run_all: run_tc1 run_tc2 run_tc3 run_tc4 run_tc5
	@echo "===== ALL 5 TESTCASES COMPLETED ====="
