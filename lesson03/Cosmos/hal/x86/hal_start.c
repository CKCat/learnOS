/**********************************************************
        开始入口文件hal_start.c
***********************************************************
                彭东
**********************************************************/
#include "cosmostypes.h"
#include "cosmosmctrl.h"

void hal_start()
{
    // 初始化hal层
    init_hal();
    // 初始化内核层
    //init_krl();
    for(;;);
    return;
}
