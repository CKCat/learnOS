/**********************************************************
        物理内存区间文件memarea_t.h
***********************************************************
                彭东
**********************************************************/
#ifndef _MEMAREA_T_H
#define _MEMAREA_T_H

#define MMSTUS_ERR (0)
#define MMSTUS_OK (1)



typedef struct s_ARCLST
{
	list_h_t al_lru1;
	list_h_t al_lru2;
	uint_t al_lru1nr;
	uint_t al_lru2nr;
}arclst_t;

typedef struct s_MMAFRETS
{
	msadsc_t* mat_fist;
	uint_t mat_sz;
	uint_t mat_phyadr;
	u16_t mat_runmode;
	u16_t mat_gen;
	u32_t mat_mask;
}__attribute__((packed)) mmafrets_t;



struct s_MEMAREA;
typedef struct s_MAFUNCOBJS
{
	mmstus_t (*mafo_init)(struct s_MEMAREA* memarea,void* valp,uint_t val);
	mmstus_t (*mafo_exit)(struct s_MEMAREA* memarea);
	mmstus_t (*mafo_aloc)(struct s_MEMAREA* memarea,mmafrets_t* mafrspack,void* valp,uint_t val);
	mmstus_t (*mafo_free)(struct s_MEMAREA* memarea,mmafrets_t* mafrspack,void* valp,uint_t val);
	mmstus_t (*mafo_recy)(struct s_MEMAREA* memarea,mmafrets_t* mafrspack,void* valp,uint_t val);

}mafuncobjs_t;

#define BAFH_STUS_INIT 0
#define BAFH_STUS_ONEM 1
#define BAFH_STUS_DIVP 2
#define BAFH_STUS_DIVM 3
// 挂载 msadsc_t 结构，以 2 的 n 次方对内存页面进行分组
typedef struct s_BAFHLST
{
	spinlock_t af_lock;	// 保护自身结构的自旋锁
	u32_t af_stus;		// 状态 
	uint_t af_oder;		// 页面数的位移量
	uint_t af_oderpnr;	// oder 对应的页面数比如 oder 为 2 那就是 1<<2=4
	uint_t af_fobjnr;	// 多少个空闲 msadsc_t 结构，即空闲页面
	//uint_t af_aobjnr;
	uint_t af_mobjnr;	// 此结构的 msadsc_t 结构总数，即此结构总页面
	uint_t af_alcindx;	// 此结构的分配计数
	uint_t af_freindx;	// 此结构的释放计数
	list_h_t af_frelst;	// 挂载此结构的空闲 msadsc_t 结构
	list_h_t af_alclst;	// 挂载此结构已经分配的 msadsc_t 结构
	list_h_t af_ovelst;
}bafhlst_t;

#define MDIVMER_ARR_LMAX 52
#define MDIVMER_ARR_BMAX 11
#define MDIVMER_ARR_OMAX 9
// 进行内存分割合并管理
typedef struct s_MEMDIVMER
{
	spinlock_t dm_lock;		// 保护自身结构的自旋锁
	u32_t dm_stus;			// 状态
	uint_t dm_dmmaxindx;	// 内存分配次数
	uint_t dm_phydmindx;	// 内存合并次数
	uint_t dm_predmindx;
	uint_t dm_divnr;
	uint_t dm_mernr;
	//bafhlst_t dm_mdmonelst[MDIVMER_ARR_OMAX];
	//bafhlst_t dm_mdmblklst[MDIVMER_ARR_BMAX];
	bafhlst_t dm_mdmlielst[MDIVMER_ARR_LMAX];	// bafhlst_t 结构数组
	bafhlst_t dm_onemsalst;	// 单个的 bafhlst_t 结构
}memdivmer_t;



#define MA_TYPE_INIT 0
#define MA_TYPE_HWAD 1
#define MA_TYPE_KRNL 2
#define MA_TYPE_PROC 3
#define MA_TYPE_SHAR 4
#define MEMAREA_MAX 4
#define MA_HWAD_LSTART 0
#define MA_HWAD_LSZ 0x2000000
#define MA_HWAD_LEND (MA_HWAD_LSTART+MA_HWAD_LSZ-1)
#define MA_KRNL_LSTART 0x2000000
#define MA_KRNL_LSZ (0x400000000-0x2000000)
#define MA_KRNL_LEND (MA_KRNL_LSTART+MA_KRNL_LSZ-1)
#define MA_PROC_LSTART 0x400000000
#define MA_PROC_LSZ (0xffffffffffffffff-0x400000000)
#define MA_PROC_LEND (MA_PROC_LSTART+MA_PROC_LSZ)

// 内存区的数据结构，进行内存区，解决功能分区的问题
//0x400000000  0x40000000
typedef struct s_MEMAREA
{
	list_h_t ma_list;			// 内存区自身的链表
	spinlock_t ma_lock;			// 保护内存区的自旋锁
	uint_t ma_stus;				// 内存区的状态
	uint_t ma_flgs;				// 内存区的标志
	uint_t ma_type;				// 内存区的类型
	sem_t ma_sem;				// 内存区的信号量
	wait_l_head_t ma_waitlst;	// 内存区的等待队列
	uint_t ma_maxpages;			// 内存区总的页面数
	uint_t ma_allocpages;		// 内存区分配的页面数
	uint_t ma_freepages;		// 内存区空闲的页面数
	uint_t ma_resvpages;		// 内存区保留的页面数
	uint_t ma_horizline;		// 内存区分配时的水位线
	adr_t ma_logicstart;		// 内存区开始地址
	adr_t ma_logicend;			// 内存区结束地址
	uint_t ma_logicsz;			// 内存区大小
	adr_t ma_effectstart;
	adr_t ma_effectend;
	uint_t ma_effectsz;
	list_h_t ma_allmsadsclst;
	uint_t ma_allmsadscnr;
	arclst_t ma_arcpglst;
	mafuncobjs_t ma_funcobj;
	memdivmer_t ma_mdmdata;
	void* ma_privp;
	/*
	*这个结构至少占用一个页面，当然
	*也可以是多个连续的的页面，但是
	*该结构从第一个页面的首地址开始
	*存放，后面的空间用于存放实现分
	*配算法的数据结构，这样每个区可
	*方便的实现不同的分配策略，或者
	*有天你觉得我的分配算法是渣渣，
	*完全可以替换 mafuncobjs_t 结构
	*中的指针，指向你的函数。
	*/
}memarea_t;
#endif

/**
memarea_t -> ma_mdmdata
				|
			memdivmer_t -> dm_mdmlielst		
								|				
							bafhlst_t[0] -> af_ovelst
								|
							bafhlst_t[1] -> af_ovelst
**/