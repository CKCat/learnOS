; 二级引导器核心入口汇编部分
%include "ldrasm.inc"
global _start
global realadr_call_entry
global IDT_PTR
extern ldrkrl_entry
[section .text]
[bits 32]

; 通过 imginithead.asm 中 jmp 0x200000 跳转过来。
_start:
_entry:
	cli
	lgdt [GDT_PTR]				; 加载 GDT 地址到 GDTR 寄存器  
	lidt [IDT_PTR]				; 加载 IDT 地址到 IDTR 寄存器  
	jmp dword 0x8 :_32bits_mode ; 长跳转刷新 CS 影子寄存器

_32bits_mode:
	mov ax, 0x10				; 数据段选择子(目的)
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx
	xor edx,edx
	xor edi,edi
	xor esi,esi
	xor ebp,ebp
	xor esp,esp
	mov esp,0x90000				; 使得栈底指向了 0x90000
	call ldrkrl_entry			; 调用 ldrkrl_entry 函数
	xor ebx,ebx
	jmp 0x2000000				; 跳转到 0x2000000 的内存地址，这里存放着 kernel.bin
	jmp $


realadr_call_entry:
	pushad						; 保存通用寄存器
	push    ds
	push    es
	push    fs
	push    gs					; 保存4个段寄存器
	call save_eip_jmp			; 调用save_eip_jmp
	pop	gs
	pop	fs
	pop	es
	pop	ds						; 恢复4个段寄存器
	popad						; 恢复通用寄存器
	ret
save_eip_jmp:
	pop esi						; 弹出 call save_eip_jmp 时保存的 eip 到 esi 寄存器中
	mov [PM32_EIP_OFF],esi		; 把 eip 保存到特定的内存空间中
	mov [PM32_ESP_OFF],esp		; 把 esp 保存到特定的内存空间中
	jmp dword far [cpmty_mode]	; 长跳转这里表示把 cpmty_mode 处的第一个 4 字节装入 eip ，把其后的 2 字节装入 cs 
cpmty_mode:
	dd 0x1000					; 内存中 0x1000 存放着 initldrsve.bin 文件
	dw 0x18
	jmp $

GDT_START:
knull_dsc: dq 0
kcode_dsc: dq 0x00cf9a000000ffff 
kdata_dsc: dq 0x00cf92000000ffff
k16cd_dsc: dq 0x00009a000000ffff ; 16位代码段描述符
; [0000 0000]: 段基址:24~31
; [0000] G:段长度的颗粒 1=4k,0=1b，D/B:操作数是否为32位，L:段是否64位模式，AVL: 系统待用
; [0000] 段长度:16~19
; [1 00 1 1110] P:段是否在内存中，DPL:段描述符权限级别，S:段是系统段还是代码段和数据段，
; T:代码段或数据段，C: 段是否可执行，R:段是否可读，A:段是否已经访问，又CPU自动设置
; [000000000000000000000000] 段基址0~23 
; [1111111111111111] 段长度:0~15
k16da_dsc: dq 0x000092000000ffff ; 16位数据段描述符
GDT_END:

GDT_PTR:
GDTLEN	dw GDT_END-GDT_START-1	;GDT界限
GDTBASE	dd GDT_START

IDT_PTR:
IDTLEN	dw 0x3ff	; BIOS 中断表的长度
IDTBAS	dd 0		; BIOS 中断表的地址
