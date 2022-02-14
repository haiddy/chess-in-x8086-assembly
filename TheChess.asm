.model small
.stack
.data

num dw ?
num2 dw ?
opt_num dw ?
big_loop dw ?
counter dw ?
starting_row db 00h
ending_row db 01h
row db ?
col db ?
char db ?
enter_row db " enter the row and the col seprated with enter please ",'$'
enter_char db 10," enter the piece as char ",'$'
enter_row_tomove db "  enter the row and the col seprated with enter please ",'$'
hint db " K : king  , R : rook  , N : knight  , P : pawn  ,  B :  bishop , Q : queen  ",'$' 

starting_col db 00h
ending_col db 08h

.stack

.code
  main proc far
        MOV AX, @data            
        MOV DS, AX
        
        
        call chess_board                    ;display the chess board
        
        mov cx,2
        mov big_loop,2
        
        call white                          ; diplay the white pieces
        call black                          ; display the black pieces
        
        input:
            
          mov al,0
          mov bl,0
          call reset_moves                  ;take the char and its directions
          call white_char                  ;move the white player chosed piece
          
          call reset_moves                  ;take the char and its directions
          call black_char                   ;move the black player chosed piece
          dec big_loop
          cmp big_loop,0
          je ask
            ask:
                ;jmp stop
                ;ret
          jmp input
          
       
          
          ; stop:
       ret
    
    
    main endp
    
    
    
    
    white_box proc near      ; setting the white rectangle on the chess board   
        mov ah,06h
        mov al,00h
        mov bh,01111000b        ; white coler
        int 10h                 ; print the graph
  
        ret
    white_box endp
    
    
    
    displaying_rows proc near       ; display the white boxes of the chess board
   
     
        mov cx,5                   ; for the loop
        mov num,5                  ; to save yhe cx value
          
          
     dis_by_col:  
            mov ch,starting_row         ; start displaying from row
            mov dh,ending_row           ; the ending row after we finish our displayed box
            mov cl,starting_col 
            mov dl,ending_col
            
            call white_box              ; display the white box
            add starting_col ,13h       ; update the col value 
            add ending_col,13h          ; update the ending col value  (both needed for displaying the white graphic)
        
            dec num
            mov cx,num                  ; the saved value of cx which was lost
            loop dis_by_col                   ; loop this till you finish the first row with white and black boxes
      ret
    displaying_rows endp
    
       
    editing_sec proc near            ; we need to reset the col after each row in order to update the row value
   
     
         add starting_row,02h                         ; go to the second row
         add ending_row,02h
        
           mov starting_col,09h                      ; set the starting col for the second row 
          
           mov ending_col,12h                         ; set the col position we finish at
        ret
     editing_sec endp
      
      
      
     editing_first proc near                     ;we need to reset the col after each row in order to update the row value
   
     
        add starting_row,02h
        add ending_row,02h
           mov starting_col,00h
           mov ending_col,08h
        ret
     editing_first endp
        
        
     chess_board proc near              ; all we do is some func calls that displayes the chess board with white and black boxes as background  
        
        
        mov cx,4
        mov counter,4
       
        call displaying_rows
        call editing_sec
        call displaying_rows
      a:  
        call editing_first
        call displaying_rows
        
        call editing_sec
        call displaying_rows
        
        dec counter
         mov cx,counter
      loop a
        
        
        ret
    chess_board endp
    
  
  
    set_curser proc near             ; we gave this fnc the row and the cols and it set the curser in a specific pos to display a graphic
    
        MOV AH, 02h     ; move to upper left 15th column cursor
        MOV BH, 00h
        INT 10h
        
        ret
   set_curser endp
  
  
   white_char proc near      ; set the pieces of the white player collerd yellow
  
    mov ah,09h
    mov bl,1110b               ; yellow binary rep
    mov bh,0
    mov cx,1
    int 10h
    
  ret
  white_char endp
  
  black_char proc near             ; display a given char of the black player colered light cyan
  
    mov ah,09h
    mov bl,1011b
    mov bh,0
    mov cx,1
    int 10h
    
  ret
  black_char endp
  
  
  text proc near                 ; display a text
  
    mov ah,09
    int 21h
    
    ret
  text endp
  
  graph_by_col proc near            ; ubdate the col pos by add to it 9h and set curser then display the given char for the white player   
    
        add DL, 09h             ; move to the col
        call set_curser
        call white_char
        
  
    ret
  graph_by_col endp
  
  
  graph_black proc near          ; update the col then display a given char for the black player 
    
        add DL, 09h     ; move to the col
     
        call set_curser
        call black_char
        
  
    ret
  graph_black endp
  
  white proc near                 ; display all white player pieces (colerd yellow)
  
        MOV DH, 00h               ; move to the row
        MOV DL, 04h               ; move to the col
        call set_curser
        mov al,'R'
        call white_char
        
        mov al,'N'
        call graph_by_col
        
         mov al,'B'
        call graph_by_col
        
         mov al,'Q'
        call graph_by_col
        
         mov al,'K'
        call graph_by_col
        
         mov al,'B'
        call graph_by_col
        
         mov DL, 3ah
         mov al,'N'
         call set_curser
         call white_char
        
         mov DL, 43h
         mov al,'R'
         call set_curser
         call white_char
        
        add dh,03h
        mov dl,04h
        call set_curser
        mov al,'P'
        call white_char
        
        mov cx ,8
        mov num2,8
    dis_pawn :
        mov al, 'P'
        call graph_by_col
        
        dec num2
        mov cx,num2
    loop dis_pawn
        
        ; i finished the white one
        
        ret
  white endp
  
  black proc near               ; print each black piece as a char in the chess borad (colored light cyan)
  
        
        MOV DH, 0fh             ; move to the row
        MOV DL, 04h             ; move to the col
        call set_curser         ; set the curser in the dh and dl location
        mov al,'R'
        call black_char         ; set the light cyan
        
        mov al,'N'
        call graph_black
        
         mov al,'B'
        call graph_black
        
         mov al,'Q'
        call graph_black
        
         mov al,'K'
        call graph_black
        
         mov al,'B'
        call graph_black
        
         mov DL, 3ah
         mov al,'N'
         call set_curser
        call black_char
        
         mov DL, 43h
         mov al,'R'
         call set_curser
        call black_char
        
        sub dh,02h
        mov dl,04h
        call set_curser
        mov al,'P'
        call black_char
        
        mov cx ,8
        mov num2,8
        
   dis_pawn2 :                             ; display the pawn pieces
        mov al , 'P'
        call graph_black
        
        dec num2
        mov cx,num2
        loop dis_pawn2
        
        ; i finished the black one
        
         ret
  black endp
  
  
  clear_place proc near             ; clear a specific box to move its piece
        
        MOV DH, row                 ; move to the row
        MOV DL, col                 ; move to the col
        call set_curser
        mov al,''                  ;replace the piece with empty place
        call white_char
        ret
  clear_place endp
  
  take_input proc near            ; take the row and the col num besides the piece char
    mov bh, 00
    mov dl, 10 
    mov bl, 0    
  scanNum:

      mov ah, 01h
      int 21h

      cmp al, 13   ; Check if user pressed enter
      je  exit 

      mov ah, 0  
      sub al, 48   ; ASCII to DECIMAL

      mov cl, al
      mov al, bl   ; Store the previous value in AL

      mul dl       ; multiply the previous value with 10

      add al, cl   ; previous value + new value ( after previous value is multiplyed with 10 )
      mov bl, al
      
      jmp scanNum    

    exit:
    
  ret
  take_input endp
  
  
  
  reset_moves proc near                 ; the whole movement of the pieces 
  
        MOV DH, 12h     ; move to the row
        MOV DL, 00h     ; move to the col 
        call set_curser
        mov al,' '
        call white_char  
        lea dx, hint
        call text
        
        lea dx, enter_char              ; take a piece to move
        call text
        call take_input
        mov char,bl
        add char,48
        
        lea dx, enter_row               ; takes the row and the col of the piece
        call text
        call take_input
        call optmaize_Rowinput
        call take_input 
        call optmaize_Colinput 
        call clear_place
        MOV DH, 16h     ; move to the row
        MOV DL, 00h     ; move to the col 
        call set_curser
         mov al,' '
         call white_char 
         
         lea dx, enter_row_tomove                  ; takes the row and the col to move to
         call text
         call take_input
         call optmaize_Rowinput
         
         call take_input
         call optmaize_Colinput
         
          MOV DH, row                ; move to the row
          MOV DL, col                ; move to the col
          call set_curser
          mov al,char               ; print the piece in the updated place
           
  ret
  reset_moves endp
  
  optmaize_Rowinput proc near           ; take the row from the user and modify it to the chess board
  mov bh,00
  mov row,00
  mov opt_num,bx
  
  cmp bl,0
  je nada
  jne modify
  
  nada :
    mov row,00
    ret
  modify :
    cmp bl,1
    je first
    jne normal
    first:
        mov row ,03
        ret
    normal :
        add row , 03
        sub opt_num ,01
        mov cx, opt_num
        final :
        add row , 02
        loop final

  ret
  optmaize_Rowinput endp
  
  
   optmaize_Colinput proc near          ; take the col from the user and modify it to the chess board
  mov bh,00
  mov col,00
  mov opt_num,bx
  cmp bl,0
  je do_na
  jne modify_col
  
  do_na :
  mov col,04h
    ret
    modify_col :
  
    add col , 04h
       
        mov cx, opt_num
        final_col :
        add col , 09h
        loop final_col

  ret
  optmaize_Colinput endp
  
  
end main