INCLUDE Irvine32.inc

main          EQU start@0

BucketWidth=18 
BucketHeight=17

.data
bucket		BYTE '      ______      '
			BYTE '     | .  . |     '
			BYTE '     |      |     '
			BYTE '     |  \/  |     '
			BYTE '     |__  __|     '
			BYTE '        ||        '
			BYTE '    ____||____    '
			BYTE '  /  |    |    \  '
			BYTE ' /   0    4 |   \ '
			BYTE '/ |         9    \'
			BYTE '| 1  |           |'
			BYTE '|    7   |    |  |'
			BYTE '| |      3    5  |'
			BYTE '| 8        |     |'
			BYTE '\   |      6     /'
			BYTE ' \  2           / '
			BYTE '  \____________/  '
			
dead		BYTE '     | x  x |     ' 
			BYTE '     |      |     '
			BYTE '     |  /\  |     '

blade		BYTE '+';���C�᪺�}�f�Ϯ�
turn1		BYTE 'Player1''s turn',0
turn2		BYTE 'Player2''s turn',0
hit1		BYTE 'Player1 loses! Press any key to restart',0
hit2		BYTE 'Player2 loses! Press any key to restart',0
stabbed		BYTE 'This hole has already been stabbed, please choose another hole',0

space		BYTE 100 DUP(' ')	;cover the original message
wrongnumber DWORD ? ;���s�|�u�X���}�f��m
message COORD <0,0>	;message's initial position

player		BYTE ?	;show the current player

hole STRUCT
	position COORD <?,?>
	ifstabbed BYTE ? ;�x�s���C���A
hole ENDS

hole0 hole <<15,12>,>
hole1 hole <<12,14>,>
hole2 hole <<14,19>,>
hole3 hole <<19,16>,>
hole4 hole <<20,12>,>
hole5 hole <<24,16>,>
hole6 hole <<21,18>,>
hole7 hole <<15,15>,>
hole8 hole <<12,17>,>
hole9 hole <<22,13>,>

outputHandle DWORD 0
bytesWritten DWORD 0
count DWORD 0
xyPosition COORD <10,5>				;draw bucket from <10,5>
cellsWritten DWORD ?
attributes WORD BucketWidth DUP(0Eh)	;yellow

.code
PutKnife MACRO coor ;�x�s�w���C���}�f
	INVOKE WriteConsoleOutputAttribute,
	outputHandle,
	OFFSET attributes,
	1,
	coor,
	OFFSET cellsWritten
		
	INVOKE WriteConsoleOutputCharacter,
	outputHandle,
	OFFSET blade,
	1,
	coor,
	OFFSET cellsWritten
ENDM

main PROC
	INVOKE GetStdHandle,std_output_handle
	mov outputHandle,eax	
	
Initialize: ;��l�ƩҦ��ܼ�
	call Clrscr; �M���ù�
	
	mov eax,10
	call RandomRange	;choose the number between 0~9
	mov wrongnumber,eax
	
	mov player,1
	
	mov xyPosition.X,10
	mov xyPosition.Y,5
	
	mov esi,OFFSET bucket
	mov ecx,BucketHeight
	
	mov hole0.ifstabbed,0 ;�٨S���C�����A
	mov hole1.ifstabbed,0
	mov hole2.ifstabbed,0
	mov hole3.ifstabbed,0
	mov hole4.ifstabbed,0
	mov hole5.ifstabbed,0
	mov hole6.ifstabbed,0
	mov hole7.ifstabbed,0
	mov hole8.ifstabbed,0
	mov hole9.ifstabbed,0
	
DrawBucket: ;�e�X���s��   
	push ecx
	
	INVOKE WriteConsoleOutputAttribute,		;color
	outputHandle,
	OFFSET attributes,
	BucketWidth,
	xyPosition,
	OFFSET cellsWritten
	
	INVOKE WriteConsoleOutputCharacter,		;sign
	outputHandle,
	esi,
	BucketWidth,
	xyPosition,
	OFFSET cellsWritten
	
	inc xyPosition.Y
	add esi,BucketWidth
	pop ecx
	loop DrawBucket
	
Play: ; �B�z��Ӫ��a���^�X�T��
	INVOKE SetConsoleCursorPosition,	;set cursor to the message's initial position
	outputHandle,
	message
	
	INVOKE WriteConsoleOutputCharacter,	;cover the former message
	outputHandle,
	offset space,
	lengthof space,
	message,
	OFFSET cellsWritten
	
	.IF player==1
		mov edx,offset turn1
		call WriteString
	.ENDIF
	
	.IF player==2
		mov edx,offset turn2
		call WriteString
	.ENDIF
	
Stab: ; �B�z���C�᪺���G
	call ReadChar
	.IF ax==0B30h
		.IF hole0.ifstabbed==1 ;�p�G�w�g���C�F�|�������a
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole0.position
		
		mov hole0.ifstabbed,1;���ܴ��C���A
		
		.IF wrongnumber==0 ;����wrongnumber���}�f�N��F
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0231h
		.IF hole1.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole1.position
		
		mov hole1.ifstabbed,1
		
		.IF wrongnumber==1
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0332h
		.IF hole2.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole2.position
		
		mov hole2.ifstabbed,1
		
		.IF wrongnumber==2
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0433h
		.IF hole3.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole3.position
		
		mov hole3.ifstabbed,1
		
		.IF wrongnumber==3
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0534h
		.IF hole4.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole4.position
		
		mov hole4.ifstabbed,1
		
		.IF wrongnumber==4
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0635h
		.IF hole5.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole5.position
		
		mov hole5.ifstabbed,1
		
		.IF wrongnumber==5
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0736h
		.IF hole6.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole6.position
		
		mov hole6.ifstabbed,1
		
		.IF wrongnumber==6
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0837h
		.IF hole7.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole7.position
		
		mov hole7.ifstabbed,1
		
		.IF wrongnumber==7
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0938h
		.IF hole8.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole8.position
		
		mov hole8.ifstabbed,1
		
		.IF wrongnumber==8
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF ax==0A39h
		.IF hole9.ifstabbed==1
			INVOKE SetConsoleCursorPosition,
			outputHandle,
			message
			
			mov edx,offset stabbed
			call WriteString
			jmp Stab
		.ENDIF
		
		PutKnife hole9.position
		
		mov hole9.ifstabbed,1
		
		.IF wrongnumber==9
			jmp Lose
		.ENDIF
	.ENDIF
	
	.IF player==1
		mov player,2
		jmp Play
	.ENDIF
	
	.IF player==2
		mov player,1
	.ENDIF
	jmp Play
	
Lose: ; ���ܮ��s��ҼˡB�L�X��a�W�r�í��s�}�l�C��
	mov ecx,3
	mov esi,OFFSET dead
	mov xyPosition.X,10
	mov xyPosition.Y,6
	DrawDead: ;�e�X�鱼�᪺���y
		push ecx
		INVOKE WriteConsoleOutputAttribute,
		outputHandle,
		OFFSET attributes,
		BucketWidth,
		xyPosition,
		OFFSET cellsWritten
		
		INVOKE WriteConsoleOutputCharacter,
		outputHandle,
		esi,
		BucketWidth,
		xyPosition,
		OFFSET cellsWritten
		inc xyPosition.Y
		add esi,BucketWidth
		pop ecx
		loop DrawDead
	
	INVOKE SetConsoleCursorPosition,
	outputHandle,
	message
	
	INVOKE WriteConsoleOutputCharacter,	;cover the former message
	outputHandle,
	offset space,
	lengthof space,
	message,
	OFFSET cellsWritten
	
	.IF player==1
		mov edx,offset hit1
	.ENDIF
	.IF player==2
		mov edx,offset hit2
	.ENDIF
	call WriteString
	call ReadChar
	jmp Initialize;���s�}�l�C��
	
goExit:
	exit
main ENDP
END main
