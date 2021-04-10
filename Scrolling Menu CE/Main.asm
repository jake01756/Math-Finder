; Scrolling Menu CE
; MENU.8xp
; this version has full scrolling and arrows
; FINALLY, MULTI-MENUS, WOOHOO!!!!!!
; Grabs menu data from Ans and stores ASCII code of selected option into Ans
; can store 148 options/titles and 37 max options per menu
; To-do: Add paging, (alpha key then up or down)
; Also ported to TI-83/84 plus, "Scrolling Menu Plus"
; Ver: 1.1.1





#include "ti84pce.inc"
.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
	call _RunIndicOff
	RES	donePrgm, (IY + doneFlags)
;	SET	putMapUseColor, (IY + grFlags)
;	LD	HL, %0000011111111111	; Ignore this
;	call _SetTextFGBGcolors
	CALL	StartMenu		; call the program, ASCII code of option will be in A
Ending:
	call _RunIndicOn
	RET	

; Beginning of Menu

; Address equates
MenuDataStart		equ	pixelShadow2 + 450	; $D05488
CharCodes		equ	pixelShadow2 + 4000	; $D06266
ListLength		equ	pixelShadow2 + 4150	; $D062FC
NumMenus		equ	pixelShadow2 + 4151	; $D062FD
CurrentMenuAddress	equ	pixelShadow2 + 4152	; $D062FE
MenuAddresses		equ	pixelShadow2 + 4155	; $D06301

; Number equates
maxRow		equ	9
maxCol		equ	26
bpp		equ	2
Thickness	equ	2*bpp
pixelPerRow	equ	320
pixelPerCol	equ	240
RowsInBanner	equ	30



StartMenu:
	call _RclAns			; DE points to menu data
	LD	A, (OP1+1)
	CP	tAns
	JP	NZ, _ErrDataType	; make sure OP1 is actually a string, technically it only checks if Ans is a string, program, AppVar, or equation so might get an error and hopefully not a crash
; Load MenuData from Ans to MenuDataStart
	LD	HL, MenuDataStart
	EX	DE, HL			; HL point to Ans, DE to MenuDataStart
	INC	HL
	INC	HL		; First two bytes are size of string, useless
LoadLoop:
	LDI
	LD	A, (HL)			
	CP	tDecPt			; should end with "."
	JR	NZ, LoadLoop
	LDI

	LD	A, 1
	LD	(NumMenus), A		; Reset NumMenus to 1
	XOR	A
	LD	(CurrentMenuAddress), A	; Reset Offset to 0
	LD	DE, MenuDataStart-1
	LD	HL, pixelShadow2
	LD	(MenuAddresses), HL	; First menu addresses always starts at pixelShadow2
	LD	IX, MenuAddresses+3	; IX will be destination later

;make an address table for the elements(titles and options)

AddressLoop:
	INC	DE
	LD	(HL), DE
	INC	HL
	INC	HL
	INC	HL
AddressLoopDE:
	INC	DE
	LD	A, (DE)
	CP	tComma
	JR	Z, AddressLoop
	CP	tColon
	JR	Z, SubMenu
	CP	tDecPt
	JR	Z, AddressDone
	OR	A
SyntaxJump:
	JP	Z, _ErrSyntax
	JR	AddressLoopDE

; If a colon appears, a seperate menu must be noted
SubMenu:
	LD	A, (NumMenus)
	INC	A
	LD	(NumMenus), A
	LD	(IX), HL
	INC	IX
	INC	IX
	INC	IX
	JR	AddressLoop

; all done with address table, now set up the character table
AddressDone:
	LD	B, 37
	LD	C, 0
	LD	HL, CharCodes
LoadCharCodes:
; Since ASCII codes aren't nice
	INC	C
	LD	A, C
	CP	$01
	JR	Z, InitializeC
	CP	$3A		; ':'
	JR	NZ, CodeIsNot0
	LD	C, $30		; '0'
	JR	IncCharCodeDone
CodeIsNot0:
	CP	$31		; '1'
	JR	NZ, IncCharCodeDone
	LD	C, $41		; 'A'
CodeIsNot0OrA:
	JR	IncCharCodeDone
InitializeC:
	LD	C, $31		; '1'
IncCharCodeDone:
	LD	(HL), C
	INC	HL
	DJNZ	LoadCharCodes
	call _ClrLCDFull		; I like to wait as long as possible before clearing the screen

;--------------------------

GetListLength:
	CALL	SetHLCMA
	LD	HL, (HL)
	LD	HL, (HL)		; Point to start of current menu
	LD	C, 0
ListLengthLoop:
	INC	HL
	LD	A, (HL)
	CP	tComma
	JR	Z, IncLength
	CP	tColon
	JR	Z, LengthDone
	CP	tDecPt
	JR	Z, LengthDone
	JR	ListLengthLoop

IncLength:
	INC	C
	JR	ListLengthLoop

LengthDone:
	LD	A, C
	LD	(ListLength), A
	CP	38
	JP	NC, _ErrDimension	; It'll look weird if you go past 37
	OR	A
	JR	Z, SyntaxJump		; Can't have a menu with no options

;------------------------

DrawFromTop:
	LD	C, 1			; C will indicate top option
	LD	DE, CharCodes
	CALL	DispMenu
	LD	HL, $0001		; Reset cursor
	LD	(curRow), HL
	JP	HighLightcurRow

;-------------------------------------	

DispTitle:
	PUSH	BC
	PUSH	DE
	LD	HL, 0
	LD	(curRow), HL
	CALL	SetHLCMA
	LD	DE, MenuAddresses
	EX	DE, HL
	LD	A, (NumMenus)
	LD	B, A
TitleLoop:
	PUSH	HL
	LD	A, E
	CP	L
	JR	Z, TitleDark
	LD	HL, (HL)
	LD	HL, (HL)
	CALL	PutString
DarkBack:
	LD	A, ' '
	call _PutC
	POP	HL
	INC	HL
	INC	HL
	INC	HL
	DJNZ	TitleLoop
	POP	DE
	POP	BC
	RET
TitleDark:
	SET	textInverse, (IY + textFlags)
	CALL	SetHLCMA
	LD	HL, (HL)
	LD	HL, (HL)
	CALL	PutString
	RES	textInverse, (IY + textFlags)
	JR	DarkBack

DispMenu:
	CALL	DispTitle
	PUSH	BC
	LD	A, (ListLength)
	SUB	A, C
	CP	maxRow
	JR	NC, TruncDisp
NumOptions:
	INC	A
	LD	B, A			; B holds the total options to display	
; this section is an eyesore but grabs the address of the C'th option
	PUSH	DE
	LD	A, C
	ADD	A, A
	ADD	A, C
	LD	HL, $000000
	LD	L, A
	PUSH	HL
	CALL	SetHLCMA
	LD	HL, (HL)	
	EX	DE, HL
	POP	HL
	ADD	HL, DE	
	LD	HL, (HL)
; Add C + CharCodes into DE
	PUSH	HL
	LD	HL, $000000
	LD	L, C
	LD	DE, CharCodes-1
	ADD	HL, DE
	EX	DE, HL
	POP	HL
DisplayOptions:
	call _NewLine
	CALL	DeHighLightcurRow
	INC	DE
	CALL	PutString
	call _EraseEOL
	DJNZ	DisplayOptions
	call _EraseEOW
	POP	DE
	POP	BC
	RET

TruncDisp:
	LD	A, maxRow-1
	JR	NumOptions

;------------------------------------------------

HighLightcurRow:		; HighLight the current option and draw arrows
	LD	A, (curRow)
	PUSH	AF
	CALL	DrawUpArrow
	CALL	DrawDownArrow
	POP	AF
	LD	(curRow), A		; restore the cursor row
	XOR	A			; same as LD A, 0
	LD	(curCol), A
	SET	textInverse, (IY + textFlags)
	LD	A, (DE)
	call _PutC
	LD	A, ':'
	call _PutC
	LD	A, (curRow)
	CP	maxRow
	CALL	Z, DrawDownArrow
	CP	1
	CALL	Z, DrawUpArrow
	RES	textInverse, (IY + textFlags)
	XOR	A
	LD	(curCol), A
PreKeyLoop:
	PUSH	BC
	PUSH	DE

;---------------------------

KeyLoop:
	XOR	A
	call _GetKey
	OR	A
	JR	Z, KeyLoop
	POP	DE
	POP	BC
	CP	kEnter
	JR	Z, KeyEnter
	CP	kDown
	JR	Z, KeyDown
	CP	kUp
	JP	Z, KeyUp
	CP	kLeft
	JP	Z, KeyLeft
	CP	kRight
	JP	Z, KeyRight
	JR	KeyPressed
	PUSH	BC
	PUSH	DE
	JR	KeyLoop

KeyEnter:
	LD	A, (DE)
StoAtoAns:
	LD	L, A
	LD	A, (CurrentMenuAddress)
	INC	A
	LD	H, A
	MLT	HL
	call _SetXXXXOP2
	call _OP2ToOP1
	call _StoAns
	RET

KeyPressed:
	CP	k9 + 1
	JR	NC, Letters
	SUB	A, k0 - '0'
	JR	CheckIfKeyValid
Letters:
	SUB	A, kCapA - 'A'

CheckIfKeyValid:
	PUSH	BC
	LD	HL, CharCodes
	PUSH	AF
	LD	A, (ListLength)
	LD	B, A
	POP	AF
CheckIfKeyValid.Loop
	CP	(HL)
	JR	Z, KeyValid
	INC	HL
	DJNZ	CheckIfKeyValid.Loop
	POP	BC
	JR	PreKeyLoop
KeyValid:
	POP	BC
	JR	StoAtoAns
	
;----------------------------------

KeyDown:
	CALL	DeHighLightcurRow
	LD	HL, vRam + (pixelPerRow*bpp*(RowsInBanner+25))
	CALL	WhiteVertLine
	INC	DE
	LD	A, (curRow)
	ADD	A, C			; get the index of current option
	LD	HL, ListLength
	LD	B, (HL)
	SUB	A, B			; if index of current option=list length, go to top
	CP	1
	JP	Z, DrawFromTop
	LD	A, (curRow)
	CP	maxRow
	JR	Z, ScrollDown
	call _NewLine
HighLightJump:
	JP	HighLightcurRow

ScrollDown:
	INC	C
	CALL	DispMenu
	JR	HighLightJump

;-----------------------

KeyUp:
	CALL	DeHighLightcurRow
	LD	HL, vRam + (pixelPerRow*bpp*(RowsInBanner+25))
	CALL	WhiteVertLine
	LD	A, (DE)
	CP	$31		; '1'	
	JR	Z, WrapToBottom
	DEC	DE
	LD	A, (curRow)
	CP	1
	JR	Z, ScrollUp
	DEC	A
	LD	(curRow), A
	JR	HighLightJump

ScrollUp:
	DEC	C
	CALL	DispMenu
	LD	A, 1
	LD	(curRow), A
	JR	HighLightJump

WrapToBottom:
	LD	A, (ListLength)
	CP	maxRow + 1
	JR	C, WrapBotSmall
	SUB	A, maxRow - 1
	LD	C, A
	ADD	A, maxRow - 1

WrapBotSmall:
	DEC	A
	LD	HL, $000000
	LD	L, A
	LD	DE, CharCodes
	ADD	HL, DE
	EX	DE, HL
	CALL	DispMenu
	JR	HighLightJump
	
;---------------------------------

KeyRight:
	LD	A, (NumMenus)
	CP	1
PreKeyLoopJump:
	JP	Z, PreKeyLoop
	LD	HL, vRam + (pixelPerRow*bpp*RowsInBanner)
	CALL	WhiteVertLine
	LD	L, A
	LD	A, (CurrentMenuAddress)
	INC	A
	CP	L
	JR	NC, WrapLeft
	LD	(CurrentMenuAddress), A
GetListLengthJump:
	JP	GetListLength

WrapLeft:
	XOR	A
	LD	(CurrentMenuAddress), A
	JR	GetListLengthJump

;-------------------------------

KeyLeft:
	LD	A, (NumMenus)
	CP	1
	JR	Z, PreKeyLoopJump
	LD	HL, vRam + (pixelPerRow*bpp*RowsInBanner)
	CALL	WhiteVertLine
	LD	L, A
	LD	A, (CurrentMenuAddress)
	DEC	A
	CP	-1
	JR	NC, WrapRight
	LD	(CurrentMenuAddress), A
	JR	GetListLengthJump

WrapRight:
	LD	A, L
	DEC	A
	LD	(CurrentMenuAddress), A
	JR	GetListLengthJump

;---------------------------------

DrawUpArrow:
	LD	A, C
	CP	1
	RET	Z			; if on first page don't draw up arrow
	LD	HL, $0101
	LD	(curRow), HL
	LD	A, $1E			; 'up arrow'
	call _PutC	
	RET

DrawDownArrow:
	LD	A, C
	ADD	A, maxRow - 1
	LD	HL, ListLength
	CP	(HL)
	RET	NC			; if on last page don't draw down arrow
	LD	HL, $0100 + maxRow
	LD	(curRow), HL
	LD	A, $1F			; 'down arrow'
	call _PutC
	RET

;-----------------------------------------------

PutString:	; I can't just use PutS since strings don't end with 0
	LD	A, (curCol)
	CP	maxCol - 1
	JP	NC, _ErrOverFlow
	LD	A, (HL)
	CP	tComma
	JR	Z, PutString.IncreaseHL
	CP	tDecPt
	RET	Z
	CP	tColon
	RET	Z
	call _PutC

PutString.Check
	INC	HL
	JR	PutString

PutString.IncreaseHL
	INC	HL
	RET

;--------------------------------

SetHLCMA:	; This uses CMA to offset to correct MenuAddress
	LD	A, (CurrentMenuAddress)
	PUSH	BC
	LD	C, A
	ADD	A, A
	ADD	A, C
	POP	BC
	LD	HL, MenuAddresses
	ADD	A, L
	LD	L, A
	LD	A, H
	ADC	A, 0			; just in case carry was set
	LD	H, A
	RET

;---------------------------------

WhiteVertLine:
; Remove two black pixels (4 bytes) in all pixelrows in curRow
	PUSH	BC
	PUSH	DE
	PUSH	AF
	LD	B, pixelPerCol-RowsInBanner	; 210 rows
	LD	A, $FF				; White
	LD	DE, (pixelPerRow*bpp)-Thickness
Clear.Pri:
	PUSH	BC
	LD	B, Thickness
Clear.Sec:
	LD	(HL), A
	INC	HL
	DJNZ	Clear.Sec
	ADD	HL, DE				; Go to start of next row
	POP	BC
	DJNZ	Clear.Pri
	POP	AF
	POP	DE
	POP	BC
	RET

;------------------------------------------	
	
DeHighLightcurRow:
	LD	A, (DE)
	call _PutC
	LD	A, ':'
	call _PutC
	RET
	



