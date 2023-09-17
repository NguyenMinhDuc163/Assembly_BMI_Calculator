; Font chu: Terminal, Fontstyle: Regular 
include "emu8086.inc" ;thu vien co san trong emu8086
.Model Small
.Stack 100H
.Data
     
     x dw ? 
     y dw ?
     dauphay db ',$'
     
     tb1 db 'Nhap vao can nang cua ban(kg): $'
     tb2 db 'Nhap vao chieu cao cua ban(cm): $'
     tb3 db 'Chi so BMI cua ban la: $'
     
     tbthuacan db  'Thua can$'
     tbthieucan db  'Thieu can$'
     tbbinhthuong db  'Binh thuong$'
     
     bthg db 'Chi so BMI cua ban on dinh. Hay giu gin che do an uong.$'
     
     beophi1 db '1.Hay han che do an nhieu calo. $'
     beophi2 db '2.Bo sung thuc pham giau protein va chat xo.$'
     beophi3 db '3.Thuc hien cac bai tap dot calo du thua nhu cardio.$'
     
     gay1 db '1.Nap nhieu calo hon luong calo da dot chay.$'
     gay2 db '2.Bo sung cac thuc pham giau protein.$'
     gay3 db '3.Ngu du giac moi ngay va co che do lam viec nghi ngoi hop ly.$'
     
     tb5 db 'BAM SPACE DE BAT DAU LAI $'
     tb6 db 'BAM ENTER DE KET THUC$'
     tb7 db 'BAM PHIM BAT KY DE BAT DAU$'
     tb8 db '==KTMT-NHOM 07==$'
     tb9 db '*BMI(Body mass index) la chi so dang tin cay ve do map om cua mot nguoi*$'
     
     w dw ?
     h dw ?
     nguyen1 dw ?
     du1 dw ?
     thapphan2 dw ?
     bminguyen dw ?
     bmithapphan dw ?
     
.Code
Main Proc 
    
    mov ax, @data
    mov ds, ax    
    
    ;xoa man hinh va khoi tao mau 
    MOV AH, 06h    
    XOR AL, AL     
    XOR CX, CX    
    MOV DX, 184FH  
    MOV BH, 1Eh   ;khoi tao nen xanh chu vang 
    INT 10H 
    
    ;GIAO DIEN
    GOTOXY 10, 5  
    printn "°°°° °   ° °°°   °°° °°° °   °°° °  ° °   °°° °°° °°° °°°°"
    GOTOXY 10, 6
    printn " ° ° °° °°  °    °   ° ° °   °   °  ° °   ° °  °  ° °  ° °"
    GOTOXY 10, 7
    printn " °°° ° ° °  °    °   °°° °   °   °  ° °   °°°  °  ° °  °°°"
    GOTOXY 10, 8
    printn " ° ° °   °  °    °   ° ° °   °   °  ° °   ° °  °  ° °  °° "
    GOTOXY 10, 9
    printn "°°°° °   ° °°°   °°° ° ° °°° °°° °°°° °°° ° °  °  °°°  ° °"
    
    GOTOXY 26,15
    ;BAM PHIM BAT KY DE BAT DAU
    lea dx, tb7 
    mov ah,9
    int 21h
    
    GOTOXY 30,22
    lea dx, tb8 
    mov ah,9
    int 21h
               
    
    GOTOXY 4,20
    lea dx, tb9 
    mov ah,9
    int 21h
            
    GOTOXY 54,15
    mov ah,1
    int 21h

chuongtrinh: 
    
    MOV AH, 06h    
    XOR AL, AL     
    XOR CX, CX    
    MOV DX, 184FH  
    MOV BH, 1Eh    
    INT 10H    
    
    GOTOXY 15,4
    lea dx, tb1
    mov ah, 9
    int 21h
   
    call nhapSo
    mov w, ax

    GOTOXY 15,6
    lea dx, tb2
    mov ah, 9
    int 21h
   
    call nhapSo
    mov h, ax

  
;tinh bmi
    mov ax, w
    mov bx, 100
    mul bx
    mov dx, 0
    mov bx, h
    div bx
    
    mov nguyen1, ax
    mov du1, dx
    
    ;xu ly phan du 1
    mov ax, du1 
    mov bx, 100
    mul bx 
    mov bx, h 
    mov dx, 0 
    div bx 
    mov bx, 10 
    mul bx 
    mov bx, h
    mov dx, 0
    div bx
    mov thapphan2, ax ; luu phan thap phan cua phan du thu nhat
     
    ;xu ly phan nguyen 1
    mov ax, nguyen1
    mov bx, 100
    mul bx
    mov bx, h
    mov dx, 0
    div bx
    mov bminguyen, ax 
    mov bmithapphan, dx    
    
    ;xu ly phan du 
    mov ax, bmithapphan
    mov bx, 10
    mul bx
    mov bx, h
    mov dx, 0
    div bx
    mov bmithapphan, ax
    mov ax, bmithapphan
    add ax,thapphan2
    cmp ax, 10
    jge capnhap
    jmp ra
    
    capnhap:
        sub ax, 10
        mov bmithapphan, ax
        inc bminguyen
        
    ra:
    ;in ra thong bao chi so BMI
        GOTOXY 15,10
        lea dx, tb3 
        mov ah, 9
        int 21h
    ;in ra chi so BMI: in phan nguyen, in dau phay, in phan du
        mov ax, bminguyen
        push ax

    call inSo
    
    mov dl, ','
    mov ah, 2
    int 21h
     
    mov ax, bmithapphan
    call inSo
   
    ;so sanh BMI
   
    ;<18,5: thieu can
    ;18,5 <= BMI < 24,9: binh thuong 
    ;>= 25: thua can
      
    mov ax, bminguyen
    cmp bminguyen, 25 
    jge thuacan
    cmp ax, 18
    jl thieucan
    je bang
    jg binhthuong   
    
    bang:
        cmp bmithapphan, 5
        jl thieucan
        jge binhthuong
     
    binhthuong:
        GOTOXY 15,12
        mov ah, 9
        lea dx, tbbinhthuong
        int 21h 
        GOTOXY 15,14
        mov ah,9
        lea dx,bthg
        int 21h
        GOTOXY 20,17
        mov ah,9
        lea dx,tb5
        int 21h
        GOTOXY 20,19
        mov ah,9
        lea dx,tb6
        int 21h
        
        mov ah,1
        int 21h
        
        cmp al,13
        je ketthuc
        
        cmp al,32
        je chuongtrinh     
         
    thieucan:
        GOTOXY 15,12
        lea dx, tbthieucan
        mov ah,9
        int 21h 
        
        GOTOXY 15,14 
        mov ah,9
        lea dx,gay1
        int 21h
        
        GOTOXY 15,16
        mov ah,9
        lea dx,gay2
        int 21h
        
        GOTOXY 15,18
        mov ah,9
        lea dx,gay3
        int 21h  
        
        GOTOXY 20,21
        mov ah,9
        lea dx,tb5
        int 21h
        
        GOTOXY 20,23
        mov ah,9
        lea dx,tb6
        int 21h
        
        mov ah,1
        int 21h
        
        cmp al,13
        je ketthuc
        
        cmp al,32
        je chuongtrinh   
                      
    thuacan:
        GOTOXY 15,12
        lea dx, tbthuacan
        mov ah,9
        int 21h
        
        GOTOXY 15,14
        mov ah,9
        lea dx,beophi1
        int 21h
        
        GOTOXY 15,16
        mov ah,9
        lea dx,beophi2
        int 21h
        
        GOTOXY 15,18
        mov ah,9
        lea dx,beophi3
        int 21h          
        
        GOTOXY 20,21
        mov ah,9
        lea dx,tb5
        int 21h
        
        GOTOXY 20,23
        mov ah,9
        lea dx,tb6
        int 21h
        
        mov ah,1
        int 21h
        
        cmp al,13
        je ketthuc
        
        cmp al,32
        je chuongtrinh
           
    ketthuc: 
     MOV AH, 06h    
    XOR AL, AL     
    XOR CX, CX    
    MOV DX, 184FH  
    MOV BH, 1Eh    
    INT 10H
    
    GOTOXY 34, 2
    printn "Thanh Vien"
    GOTOXY 34, 3
    print "----------"  
    
    GOTOXY 32, 11
    printn "Nguyen Minh Duc"
    GOTOXY 32, 13
    printn "MSV: B21DCCN249"
    
    GOTOXY 55, 18
    printn "Pham Huy Hoa"
    GOTOXY 55, 20
    printn "MSV:B21DCCN381"
    
    GOTOXY 7, 18
    printn "Nguyen Thanh Hai"
    GOTOXY 7, 20
    printn "MSV: B21DCCN321"
    
    GOTOXY 55, 6
    printn "Tran Duc Thinh"
    GOTOXY 55, 8
    printn "MSV: B21DCCN693"
    
    GOTOXY 7, 6
    printn "Hoang Viet Trung"  
    GOTOXY 7, 8
    printn "MSV: B21DCCN729" 
    
    
    GOTOXY 20, 23
    printn "**Thong tin du lieu duoc su dung tu VinMec** "  
    
    mov ah, 4ch
    int 21h
    
Main Endp 

nhapSo Proc
    mov x, 0
    mov y, 0
    mov bx, 10
    lap:
        mov ah, 1
        int 21h
    
        cmp al, 13
        je break
    
        sub al, '0'
        mov ah, 0
    
        mov y, ax
        mov ax, x
        mul bx
        add ax, y 
    
        mov x, ax
        jmp lap
      
        break:   
            mov ax, x 
            
    ret
nhapSo Endp 

inSo Proc  
    push ax
    push bx
    push cx
    push dx 
    
    mov bx, 10
    mov cx, 0; dem so luong chu so trong ax
    lap2:
        mov dx, 0
        div bx; dxax/bx phan du luu o dx, nguyen luu o ax
        push dx
        inc cx
        cmp ax, 0
        jg lap2
        
    hienthi:
        pop dx
        add dl, '0'
        mov [si], dl
        inc si
        mov ah,2
        int 21h
        loop hienthi
            
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret 
inSo Endp 
  


 

END MAIN