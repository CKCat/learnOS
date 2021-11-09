###################################################################
#		主控自动化编译配置文件 Makefile
#				彭东  
###################################################################

MAKEFLAGS = -sR

MKDIR = mkdir
RMDIR = rmdir
CP = cp
CD = cd
DD = dd
RM = rm

BUILD_PATH = ./build
MAKE = make
INITLDRMFLGS = -C $(BUILD_PATH) -f initldr.mk
INITLDRLINKMFLGS = -C $(BUILD_PATH) -f ldrlink.mk
SRCFILE = $(BOOTEXCIMG) $(KRNLEXCIMG) $(LDEREXCIMG) $(SHELEXCIMG)
RSRCFILE = $(BOOTEXCIMG) $(KRNLEXCIMG) $(LDEREXCIMG) $(SHELEXCIMG) $(VDIFNAME) $(VMDKFNAME)
.PHONY : build print clean all

build: clean print all

all:
	@echo '$(MAKE) $(INITLDRMFLGS)'
	$(MAKE) $(INITLDRMFLGS)
	@echo '$(MAKE) $(INITLDRLINKMFLGS)'
	$(MAKE) $(INITLDRLINKMFLGS)
	@echo '恭喜，Initldr 编译构建完成！ ^_^'
clean:
	@echo '$(CD) $(BUILD_PATH); $(RM) -f *.o *.bin *.i *.krnl *.s *.map *.lib *.btoj *.vdi *vmdk *.eki *.elf'
	$(CD) $(BUILD_PATH); $(RM) -f *.o *.bin *.i *.krnl *.s *.map *.lib *.btoj *.vdi *vmdk *.eki *.elf
	@echo 'Initldr:清理全部已构建文件... ^_^'

print:
	@echo '*********正在开始编译构建系统*************'




