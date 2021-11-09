/**********************************************************
		转换显示字符串头文件vgastr.h
***********************************************************
				彭东
**********************************************************/

#ifndef _VGASTR_T_H
#define _VGASTR_T_H

#define VGASTR_RAM_BASE (0xb8000)
#define VGASTR_RAM_END  (0xbffff)
#define VGADP_DFVL 0x0700
#define VGADP_HLVL 0x0f00
#define VGACTRL_REG_ADR 0x3d4
#define VGACTRL_REG_DAT 0x3d5
#define VGACURS_REG_INX 0x0a
#define VGACURS_CLOSE 0x20
#define VGACHAR_LR_CFLG 10
#define VGACHAR_DF_CFLG 0
#define VGASADH_REG_INX 0x0c
#define VGASADL_REG_INX 0x0d

typedef struct s_CURSOR
{
    //spinlock_t c_lock;
    //spinlock_t p_lock;
    uint_t vmem_s;         // 显存的起始位置    
    uint_t vmem_e;         // 显存的末尾位置
    uint_t cvmemadr;
	
    uint_t x;              // 字符的 x 坐标
    uint_t y;              // 字符的 y 坐标
}cursor_t; 

#endif

