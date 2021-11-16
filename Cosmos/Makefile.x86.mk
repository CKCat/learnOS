###################################################################
#		主控自动化编译配置文件 Makefile			  #
#				彭东  
###################################################################

MAKEFLAGS =

MKDIR = mkdir
RMDIR = rmdir
CP = cp
CD = cd
DD = dd
RM = rm
MAKE = make
PREMENTMFLGS = -C $(BUILD_PATH) -f pretreatment.mk
HALYMFLGS = -C $(BUILD_PATH) -f hal.mk
KRNLMFLGS = -C $(BUILD_PATH) -f krl.mk
DRIVMFLGS = -C $(BUILD_PATH) -f drv.mk
LIBSMFLGS = -C $(BUILD_PATH) -f lib.mk
LINKMFLGS = -C $(BUILD_PATH) -f link.mk
APPSMFLGS = -C $(BUILD_PATH) -f app.mk
LAPPMFLGS = -C $(BUILD_PATH) -f appslink.mk
BUILD_PATH = ./build/
INITLDR_PATH =./initldr/
SCRIPT_PATH = ./script/

build: all

all:
	$(CP) $(SCRIPT_PATH)pretreatment.mk $(BUILD_PATH)pretreatment.mk
	@echo '$(CP) $(SCRIPT_PATH)pretreatment.mk $(BUILD_PATH)pretreatment.mk'
	$(MAKE) $(PREMENTMFLGS)
	@echo '$(MAKE) $(PREMENTMFLGS)'
	$(CD) $(INITLDR_PATH) && $(MAKE)
	@echo '$(CD) $(INITLDR_PATH) && $(MAKE)'
	$(MAKE) $(HALYMFLGS)
	@echo '$(MAKE) $(HALYMFLGS)'
	$(MAKE) $(KRNLMFLGS)
	@echo '$(MAKE) $(KRNLMFLGS)'
	$(MAKE) $(DRIVMFLGS)
	@echo '$(MAKE) $(DRIVMFLGS)'
	$(MAKE) $(LIBSMFLGS)
	@echo '$(MAKE) $(LIBSMFLGS)'
	$(MAKE) $(LINKMFLGS)
	@echo '$(MAKE) $(LINKMFLGS)'
	$(MAKE) $(APPSMFLGS)
	@echo '$(MAKE) $(APPSMFLGS)'


	@echo '恭喜我，系统编译构建完成！ ^_^'