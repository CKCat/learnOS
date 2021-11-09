/****************************************************************
        Cosmos HAL全局初始化文件halinit.c
*****************************************************************
                彭东
****************************************************************/

#include "cosmostypes.h"
#include "cosmosmctrl.h"


void init_hal()
{
    // 平台初始化函数
    init_halplaltform();
    // 将 img 移动到高地址的内存空间，防止被覆盖
    move_img2maxpadr(&kmachbsp);
    // 初始化内存
    init_halmm(); 
    // 初始化中断
    init_halintupt();
    return;
}
