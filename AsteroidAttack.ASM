.386

;THERE IS AN ASTEROID ATTACK! TRY TO DODGE THEM TO SURVIVE!
;MADE BY ASHER EPSTEIN 
	IDEAL
	MODEL small
	
	
;macro that creates an asteroid taking his x starting place as an argument	
macro draw_another_astroid x ;x -> x place of the astroid
	
	mov ax, x				;takes the seed for the function
	mov ax,x
	call draw_astorid 		;drawing the astorid
					
	
endm draw_another_astroid x

	STACK 100h
	
	DATASEG

	spaceship_size dw 20h			;spaceship lenth (how many pixels spaceship has in width)
    spaceship_x dw 55h 				;original placement of the spaceship (x)
	spaceship_y dw 0beh 			;original placement of the spaceship (y)
	spaceship_velocity_x dw 06h 	;horizintal velocity of the spaceship

	time_vrbl db 0 					;verible used when checking if time have changed 
	time_seed dw ? 					;creates random seed for the x of the astroids
	second_time_seed dw 100        ;this value is added to the original random time seed to create another seed
	third_time_seed dw 150         ;this value is added to the original random time seed to create another seed
	firth_time_seed dw 200			;this value is added to the original random time seed to create another seed
	
	game_over_str db 'The spaceship is going down! one of the astreoids hit us!$' ;this massage displays on the screen in the end
	
	astroid_x  dw   0ah  			;original placement of the asteroid (x)
	astroid_y  dw   00h				;original placement of the asteroid (y)
	astroid_size dw 04h  			;the lenth and hight of the asteroid 
	astroid_starting_velocity dw 06h ;vertical starting velocity of the astroid
	

	
	screen_bottom dw  0c8h 			;the bottom of the screen, used to check if astroids touched bottom
	screen_top dw 00h				;the hight of the is window 200 pixels, the y colum is upside down
	screen_width dw 140h 			;the width of the screen(320 pixels)
	
	
	
	
	CODESEG
start:
	mov ax,@data
	mov ds,ax
;create time seed
	create_new_time_seed:
	call create_seed
	
	
;clear the screen
	call clear_screen

	
;check the time:
	check_time:
	mov ah,2ch 			;get the system time
	int 21h 			;Return: CH = hour CL = minute DH = second DL = 1/100 seconds	
	cmp dl,[time_vrbl]	;checking if current time equal to the previous time(time_vrbl)
	je check_time
	mov [time_vrbl],dl 	;uptade the time
;clear the screen
	call clear_screen
;move the spaceship
	call move_spaceship
	
;draw the spaceship
	call draw_spaceship
;move the astroid
	call move_astroid

;draw the astroids 

	mov ax,[time_seed]
	draw_another_astroid ax			;macro that creates the first asteroid

	mov ax,[second_time_seed]
	
	draw_another_astroid ax			;macro that creates the second asteroid
	
	mov ax,[third_time_seed] 
	
	draw_another_astroid ax 		;macro that creates the third asteroid 
	
	mov ax,[firth_time_seed]
	
	draw_another_astroid ax			;macro that creates the firth asteroid
;checking if asteroids touched bottom
	mov ax,[astroid_y]
	cmp ax,[screen_bottom] 
	jg  reset_astroid_top ;if the asteroid touched the bottom, reset to the top of the screen
	

	
;after everthing is done, check the time again
	jmp check_time
	 
;reset asterid to top
	reset_astroid_top:	
	mov ax,[screen_top]
	mov [astroid_y],ax
	jmp create_new_time_seed ;after reseting, continue the asteroid movment with a new time seed



		
;-------draw the astroid (used in a macro with ax as a parameter)
	proc draw_astorid
	
		mov [astroid_x], ax         ;moving the parameter in to the astroid_x
		mov cx,[astroid_x] 			;set the colum (x)
		mov dx,[astroid_y] 			;set the line (y)
		
		draw_astorid_x_y:
			mov ah,0Ch 				;set to writing a pixel
			mov al,0Eh 				;choose white as color
			mov bh,00h 				;set the page number
			int 10h
			
			inc cx ;cx =+ 1
			mov ax,cx				;cx - astroid_x > astroid_size (y -> go to next line,n -> go over the procces of addeing a pixel again)
			sub ax,[astroid_x]
			cmp ax,[astroid_size]
			jng draw_astorid_x_y
			mov cx,[astroid_x]
			
			 
			inc dx
			mov ax,dx ;dx - astroid_y > astroid_size (y -> go to next line,n -> go over the procces of addeing a pixel again)
			sub ax,[astroid_y]
			cmp ax,[astroid_size]
			jng draw_astorid_x_y
			mov dx,[astroid_y]
			
;check if the asteroid hit the spaceship			
;if spaceship(y) > asterid_y && spaceship smallest x <asterid_x < spaceship biggest x  -> we know there is a hit		
;----------------
;checikng if astroid_y == spaceship_y
	mov ax,[astroid_y]
	cmp [spaceship_y],ax
	jl check_hit_x ;if the asteroid is above the spaceship, exit(ret)
	ret
;checking if   spaceship smallest x <asterid_x < spaceship biggest x

;checking if spaceship smallest x <asterid_x -> exit if false
	check_hit_x:
	mov ax,[spaceship_x]
	cmp [astroid_x],ax 
	jl exit_draw_astroid
;checking if  asterid_x < spaceship biggest x	 -> exit if false
	mov ax,[spaceship_x]
	add ax,[spaceship_size]
	mov bx,[astroid_x]
	cmp bx,ax
	jg exit_draw_astroid

;if everthing is true, there is a hit
;game over screen
	mov dx, offset game_over_str
	mov ah, 9
	int 21h
	mov ax,4C00h
	int 21h
	
	
	exit_draw_astroid:
		ret
			
			
	
	endp draw_astorid

;-----moving the astroid
	proc move_astroid
;set vilocity of the asteroid
	mov ax,[astroid_starting_velocity]
	add [astroid_y],ax 			;addeing astroid_starting_velocity to the asterid_y

	ret
	
	endp move_astroid

	
;-----draw the spaceship
	proc draw_spaceship
	mov cx,[spaceship_x] 		;set the colum (x)
	mov dx,[spaceship_y] 		;set the line (y)
		
	draw_spaceship_x:
			mov ah,0Ch 			;set to writing a pixel
			mov al,0Fh 			;choose white as color
			mov bh,00h 			;set the page number
			int 10h
								;inc spaceship_y until we get to spaceship_size
			inc cx ;cx =+ 1
			mov ax,cx			
			sub ax,[spaceship_x]
			cmp ax,[spaceship_size]
			jng draw_spaceship_x
			mov cx,[spaceship_x]
			
			ret
	endp draw_spaceship
	
	
	



;----moving the spaceship to left or  to the right
	proc move_spaceship
	
		;checking if any key is being pressed
		check_spaceship_movment:

		;check if any key is being pressed
		mov ah,01h
		int 16h
		jz exit_spaceship_movement 		;JZ ==1, JZ -> jump if zero (if no key is being pressed)
		;check wich key is being pressed (al == ASCII key being pressed)
		mov ah,0h
		int 16h
		
		
		;if 'x' or 'X' move right
		
		cmp al,78h ;'x'					;in ASCII 78h -> 'x', 58h -> 'X'
		je move_spaceship_right
		
		cmp al,58h ;'X'
		je move_spaceship_right
		
		;if 'z' or 'Z' move left
		cmp al,7ah ;'z'					;in ASCII 7ah -> 'z', 5ah -> 'Z'
		je move_spaceship_left
		
		cmp al,5ah ;'Z'
		je move_spaceship_left
		
			
				
		
		
		;move the spaceship to the left
		move_spaceship_left:
		mov ax, [spaceship_velocity_x]
		sub [spaceship_x], ax
		
		;checikng if the spaceship is in the screen width from the left
		mov ax,00h
		cmp [spaceship_x],ax
		jl fix_left_spaceship
		jmp check_spaceship_movment
		
		;move the spaceship to the right
		move_spaceship_right:
		mov ax,[spaceship_velocity_x]
		add [spaceship_x],ax
		
		;checikng that the spaceship is in the screen width from the right
		mov ax,[screen_width]
		sub ax,[spaceship_size]
		cmp [spaceship_x],ax
		jg fix_right_spaceship
		jmp check_spaceship_movment
		
		
		fix_left_spaceship: 			;spaceship_x = 00h
		mov ax,00h
		mov [spaceship_x],ax
		jmp check_spaceship_movment
		
		fix_right_spaceship:			;spaceship_x = screen_width
		mov ax,[screen_width]
		sub ax,[spaceship_size]
		mov [spaceship_x],ax
		jmp check_spaceship_movment
		
		
		exit_spaceship_movement:
		
		ret
	endp move_spaceship
	

	
			
	
	
;------clear the screen:
	proc clear_screen
		;set video mode
		mov ah,00h
		mov al,13h 			;choose the video mode
		int 10h 
	;set background color	
		mov ah,0Bh
		mov bh,00h
		mov bl,00h			 ;set to black
		int 10h
		
		ret
	
	
	
	endp clear_screen

;-----create the seeds
	proc create_seed
		mov ah,2ch 					;get the system time
		int 21h 					;Return: CH = hour CL = minute DH = second DL = 1/100 seconds	
		xor ax,ax 					;ax = 0
		mov al, dl
		mov [time_seed],ax 			;creating the first seed using system time
		add [time_seed], 20
		mov ax,[time_seed]
		add [second_time_seed],ax   ;creating three another seeds by adding the time with another value
		add [third_time_seed],ax
		add [third_time_seed],ax
		
;checking if the time seed x is smaller than screen width
		check_if_time_seed_x_in_window:
		cmp ax,[screen_width] 		;comparing time seed(x) to screen width
		jl check_if_second_time_seed_x_in_window
		
		mov bx, 100					;in case the x created is bigger than screen_width we sub 100 until it fits to screen_width
		sub ax,bx
		mov [time_seed],ax
		jmp check_if_time_seed_x_in_window
		
;checking if the second time seed x is smaller than screen width		
		check_if_second_time_seed_x_in_window:
		mov ax,[second_time_seed]
		cmp ax,[screen_width]
		jl check_if_third_time_seed_x_in_window
		
		mov bx, 100					;in case the x created is bigger than screen_width we sub 100 until it fits to screen_width
		sub ax,bx
		mov [second_time_seed],ax
		jmp check_if_second_time_seed_x_in_window
		
;checking if the third time seed x is smaller than screen width	
	check_if_third_time_seed_x_in_window:
		mov ax,[third_time_seed]
		cmp ax,[screen_width]
		jl check_if_firth_time_seed_x_in_window
		
		mov bx, 100					;in case the x created is bigger than screen_width we sub 100 until it fits to screen_width
		sub ax,bx
		mov [third_time_seed],ax
		jmp check_if_third_time_seed_x_in_window


;checking if the firth time seed x is smaller than screen width	
	check_if_firth_time_seed_x_in_window:
		mov ax,[firth_time_seed]
		cmp ax,[screen_width]
		jl exit_create_seed
		
		mov bx, 100					;in case the x created is bigger than screen_width we sub 100 until it fits to screen_width
		sub ax,bx
		mov [firth_time_seed],ax
		jmp check_if_firth_time_seed_x_in_window

;exit the proc		
		exit_create_seed:
		ret
	endp create_seed
	
exit:

	
	END start
