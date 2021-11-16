MAKEFLAGS = -s
CCSTR		= 	'CC -[M] 正在从 $< 生成 $@ 文件'
PRINTCSTR 	=	@echo $(CCSTR) 

CCSTRLMK	= 	'LMKFBUID -[M] 正在从  $< 生成 $@ 文件'
PRINTCSTRLMK 	=	@echo $(CCSTRLMK) 


KERNELCE_PATH	= ../script/
HEADFILE_PATH = -I ../include/script/ -I ../include/ -I ../include/bastypeinc -I ../include/halinc
CCBUILDPATH	= $(KERNELCE_PATH)
LMKFBUID = ./lmkfbuild
CC		= gcc
CPPFLGSLDS	= $(HEADFILE_PATH) -E -P 

PREMENTMKI_OBJS = krnlobjs.mki applds.lds cosmoslink.lds krnlbuidcmd.mki krnlbuidrule.mki hal.mki krl.mki drv.mki lib.mki app.mki link.mki appslink.mki
PREMENTMK_OBJS = krnlobjs.mk krnlbuidcmd.mk krnlbuidrule.mk hal.mk krl.mk drv.mk lib.mk app.mk link.mk appslink.mk
.PHONY : all everything everymk build_kernel
all: build_kernel

build_kernel:everything everymk

everything : $(PREMENTMKI_OBJS) 

everymk : $(PREMENTMK_OBJS)

# %.lds: %.S 是 make 的匹配模式，即 : 两边的 % 表示相同的文件名。
# $@ 指当前目标
# $< 指代第一个前置条件
# 例如下面的 $@ 指 %.lds ， $< 指 $(CCBUILDPATH)%.S
%.lds : $(CCBUILDPATH)%.S
	$(CC) $(CPPFLGSLDS) -o $@ $<
	$(PRINTCSTR)

%.mkh : $(CCBUILDPATH)%.S
	$(CC) $(CPPFLGSLDS) -o $@ $<
	$(PRINTCSTR)

%.mki : $(CCBUILDPATH)%.S
	$(CC) $(CPPFLGSLDS) -o $@ $<
	$(PRINTCSTR)

%.mk : %.mki
	chmod +x $(LMKFBUID)
	$(LMKFBUID) -i $< -o $@
	$(PRINTCSTRLMK)