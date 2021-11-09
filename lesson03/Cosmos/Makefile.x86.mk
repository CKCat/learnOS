###################################################################
#		主控自动化编译配置文件 Makefile			  #
#				彭东  
###################################################################

MAKEFLAGS = -sR

MKDIR = mkdir
RMDIR = rmdir
CP = cp
CD = cd
DD = dd
RM = rm
MAKE = make
PREMENTMFLGS = -C $(BUILD_PATH) -f pretreatment.mkf
HALYMFLGS = -C $(BUILD_PATH) -f hal.mk
KRNLMFLGS = -C $(BUILD_PATH) -f krl.mk
DRIVMFLGS = -C $(BUILD_PATH) -f drv.mk
LIBSMFLGS = -C $(BUILD_PATH) -f lib.mk
TASKMFLGS = -C $(BUILD_PATH) -f task.mk
LINKMFLGS = -C $(BUILD_PATH) -f link.mk
BUILD_PATH = ./build/
INITLDR_PATH =./initldr/

build: all

all:
	@echo '$(MAKE) $(PREMENTMFLGS)'
	$(MAKE) $(PREMENTMFLGS)
	@echo '$(CD) $(INITLDR_PATH) && $(MAKE)'
	$(CD) $(INITLDR_PATH) && $(MAKE)
	@echo '$(MAKE) $(HALYMFLGS)'
	$(MAKE) $(HALYMFLGS)
	@echo '$(MAKE) $(KRNLMFLGS)'
	$(MAKE) $(KRNLMFLGS)
	@echo '$(MAKE) $(LINKMFLGS)'
	$(MAKE) $(LINKMFLGS)
	@echo '恭喜，系统编译构建完成！ ^_^'