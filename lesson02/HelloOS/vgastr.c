// CKCat @ 2021.10.19
void _strwrite(char* string){
    char* p_strdst = (char*)(0xb8000);  // 指向显存的开始地址
    while(*string){
        *p_strdst = *string++;
        p_strdst += 2;  // 跳过字符的颜色信息
    }
    return;
}
void printf(char* fmt, ...){
    _strwrite(fmt);
    return;
}