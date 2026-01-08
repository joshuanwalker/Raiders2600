; ***  R A I D E R S  O F  T H E  L O S T  A R K  ***
; Copyright 1982 Atari, Inc.
; Designer: Howard Scott Warshaw
; Artist:	Jerome Domurat
;
; Analyzed, labeled and commented
;  by Dennis Debro
; Last Update: Aug. 8, 2018
;
; Furthur coding and updates
;	by Halkun - 2025
;
; ==============================================================================
; = THIS REVERSE-ENGINEERING PROJECT IS BEING SUPPLIED TO THE PUBLIC DOMAIN		=
; = FOR EDUCATIONAL PURPOSES ONLY. THOUGH THE CODE WILL ASSEMBLE INTO THE		=
; = EXACT GAME ROM, THE LABELS AND COMMENTS ARE THE INTERPRETATION OF MY OWN   =
; = AND MAY NOT REPRESENT THE ORIGINAL VISION OF THE AUTHOR.					=
; =																				=
; = THE ASSEMBLED CODE IS  1982, ATARI, INC.								   =
; =																				=
; ==============================================================================
;
; Disassembly of ~\Projects\Programming\reversing\6502\raiders\raiders.bin
; Disassembled 07/02/23 15:14:09
; Using Stella 6.7
;
; ROM properties name : Raiders of the Lost Ark (1982) (Atari)
; ROM properties MD5  : f724d3dd2471ed4cf5f191dbb724b69f
; Bankswitch type	  : F8* (8K) 
;
; Updated: Halkun
; Legend: *	 = CODE not yet run (tentative code)
;		  D	 = DATA directive (referenced in some way)
;		  G	 = GFX directive, shown as '#' (stored in player, missile, ball)
;		  P	 = PGFX directive, shown as '*' (stored in playfield)
;		  C	 = COL directive, shown as color constants (stored in player color)
;		  CP = PCOL directive, shown as color constants (stored in playfield color)
;		  CB = BCOL directive, shown as color constants (stored in background color)
;		  A	 = AUD directive (stored in audio registers)
;		  i	 = indexed accessed only
;		  c	 = used by code executed in RAM
;		  s	 = used by stack
;		  !	 = page crossed, 1 cycle penalty

	processor 6502


;-----------------------------------------------------------
;	   Color constants
;-----------------------------------------------------------

;BLACK			  = $00
;YELLOW			  = $10
;BROWN			  = $20
;ORANGE			  = $30
;RED			  = $40
;MAUVE			  = $50
;VIOLET			  = $60
;PURPLE			  = $70
;BLUE			  = $80
;BLUE_CYAN		  = $90
;CYAN			  = $a0
;CYAN_GREEN		  = $b0
;GREEN			  = $c0
;GREEN_YELLOW	  = $d0
;GREEN_BEIGE	  = $e0
;BEIGE			  = $f0


;-----------------------------------------------------------
;	   TIA and IO constants accessed
;-----------------------------------------------------------

CXM0P			= $00  ; (R)
CXM1FB			= $05  ; (R)
CXPPMM			= $07  ; (R)
INPT4			= $0c  ; (R)
INPT5			= $0d  ; (R)

VSYNC			= $00  ; (W)
VBLANK			= $01  ; (W)
WSYNC			= $02  ; (W)
NUSIZ0			= $04  ; (W)
NUSIZ1			= $05  ; (W)
COLUP0			= $06  ; (W)
COLUP1			= $07  ; (W)
COLUPF			= $08  ; (W)
COLUBK			= $09  ; (W)
CTRLPF			= $0a  ; (W)
REFP0			= $0b  ; (W)
REFP1			= $0c  ; (W)
PF0				= $0d  ; (W)
PF1				= $0e  ; (W)
PF2				= $0f  ; (W)
RESP0			= $10  ; (W)
RESP1			= $11  ; (W)
RESM0			= $12  ; (Wi)
RESM1			= $13  ; (Wi)
RESBL			= $14  ; (W)
AUDC0			= $15  ; (W)
AUDC1			= $16  ; (Wi)
AUDF0			= $17  ; (W)
AUDF1			= $18  ; (Wi)
AUDV0			= $19  ; (W)
AUDV1			= $1a  ; (Wi)
GRP0			= $1b  ; (W)
GRP1			= $1c  ; (W)
ENAM0			= $1d  ; (W)
ENAM1			= $1e  ; (W)
ENABL			= $1f  ; (W)
HMP0			= $20  ; (W)
HMP1			= $21  ; (W)
HMM0			= $22  ; (Wi)
HMM1			= $23  ; (Wi)
HMBL			= $24  ; (W)
VDELP0			= $25  ; (W)
VDELP1			= $26  ; (W)
HMOVE			= $2a  ; (W)
HMCLR			= $2b  ; (W)
CXCLR			= $2c  ; (W)

SWCHA			= $0280
SWCHB			= $0282
INTIM			= $0284
TIM64T			= $0296


;-----------------------------------------------------------
;	   Additional constants from verboseraiders.asm
;-----------------------------------------------------------

SOUND_CHANNEL_SAW			   = 1
SOUND_CHANNEL_ENGINE		   = 3
SOUND_CHANNEL_SQUARE		   = 4
SOUND_CHANNEL_BASS			   = 6
SOUND_CHANNEL_PITFALL		   = 7
SOUND_CHANNEL_NOISE			   = 8
SOUND_CHANNEL_LEAD			   = 12
SOUND_CHANNEL_BUZZ			   = 15

LEAD_E4							= 15
LEAD_D4							= 17
LEAD_C4_SHARP					= 18
LEAD_A3							= 23
LEAD_E3_2						= 31

BANK0TOP					   = $1000
BANK1TOP					   = $2000
BANK0_REORG					   = $d000
BANK1_REORG					   = $f000
BANK0STROBE					   = $fff8
BANK1STROBE					   = $fff9

LDA_ABS						   = $ad
JMP_ABS						   = $4c

INIT_SCORE					   = 100

SET_PLAYER_0_COLOR			   = %10000000
SET_PLAYER_0_HMOVE			   = %10000001

XMAX						   = 160

ID_TREASURE_ROOM			   = 0
ID_MARKETPLACE				   = 1
ID_ENTRANCE_ROOM			   = 2
ID_BLACK_MARKET				   = 3
ID_MAP_ROOM					   = 4
ID_MESA_SIDE				   = 5
ID_TEMPLE_ENTRANCE			   = 6
ID_SPIDER_ROOM				   = 7
ID_ROOM_OF_SHINING_LIGHT	   = 8
ID_MESA_FIELD				   = 9
ID_VALLEY_OF_POISON			   = 10
ID_THIEVES_DEN				   = 11
ID_WELL_OF_SOULS			   = 12
ID_ARK_ROOM					   = 13

H_ARK_OF_THE_COVENANT		   = 7
H_PEDESTAL					   = 15
H_INDY_SPRITE				   = 11
H_INVENTORY_SPRITES			   = 8
H_PARACHUTE_INDY_SPRITE		   = 15
H_THIEF						   = 16
H_KERNEL					   = 160

ENTRANCE_ROOM_CAVE_VERT_POS	   = 9
ENTRANCE_ROOM_ROCK_VERT_POS	   = 53

MAX_INVENTORY_ITEMS			   = 6

INDY_CARRYING_WHIP			   = %00000001
GRENADE_OPENING_IN_WALL		   = %00000010
INDY_NOT_CARRYING_COINS		   = %10000000
INDY_CARRYING_SHOVEL		   = %00000001

BASKET_STATUS_MARKET_GRENADE   = %00000001
BASKET_STATUS_BLACK_MARKET_GRENADE = %00000010
BACKET_STATUS_REVOLVER		   = %00001000
BASKET_STATUS_REVOLVER		   = BACKET_STATUS_REVOLVER
BASKET_STATUS_COINS			   = %00010000
BASKET_STATUS_KEY			   = %00100000

PICKUP_ITEM_STATUS_WHIP		   = %00000001
PICKUP_ITEM_STATUS_SHOVEL	   = %00000010
PICKUP_ITEM_STATUS_HEAD_OF_RA  = %00000100
PICKUP_ITEM_STATUS_TIME_PIECE  = %00001000
PICKUP_ITEM_STATUS_HOUR_GLASS  = %00100000
PICKUP_ITEM_STATUS_ANKH		   = %01000000
PICKUP_ITEM_STATUS_CHAI		   = %10000000

PENALTY_GRENADE_OPENING		   = 2
PENALTY_SHOOTING_THIEF		   = 4
PENALTY_ESCAPE_SHINING_LIGHT_PRISON = 13
BONUS_USING_PARACHUTE		   = 3
BONUS_LANDING_IN_MESA		   = 3
BONUS_FINDING_YAR			   = 5
BONUS_SKIP_MESA_FIELD		   = 9
BONUS_FINDING_ARK			   = 10
BONUS_USING_HEAD_OF_RA_IN_MAPROOM = 14

BULLET_OR_WHIP_ACTIVE		   = %10000000
USING_GRENADE_OR_PARACHUTE	   = %00000010


;-----------------------------------------------------------
;	   RIOT RAM (zero-page) labels
;-----------------------------------------------------------

zero_page					= $00
scanline					= $80 ; scanline
currentScreenId				= $81 ; current screen id
frameCount	  				= $82 ; frame count
secondsTimer	  		 	= $83 ; seconds timer
BSLDALoop		   			= $84; bank switch LDA/loop count
BankStrobeAddrTemp			= $85; bank strobe address/temp char
BSJMP		   				= $86; bank switch JMP instruction
BSJMPAddr		   			= $87; bank switch JMP address
ram_88						= $88; zp_88
ram_89						= $89; zp_89
playerInput					= $8a ; player input
ram_8B						= $8b ; zp_8B
ram_8C						= $8c ; zp_8C/action code
ram_8D						= $8d ; zp_8D
ram_8E						= $8e ; zp_8E
WeaponStatus				= $8f ; bullet/whip status
ram_90						= $90
ram_91						= $91
indy_dir					= $92
ram_93						= $93
playfieldControl			= $94 ; playfield control
pickupStatusFlags			= $95 ; pickup status flags
ram_96						= $96
ram_97						= $97
ram_98						= $98
ram_99						= $99
ram_9A						= $9a
grenadeDetinationTime		= $9b ; grenade detonation time
resetEnableFlag				= $9c ; reset enable flag
majorEventFlag				= $9d ; major event flag
adventurePoints				= $9e ; adventure points
livesLeft					= $9f ; lives
numberOfBullets				= $a0 ; number of bullets
ram_A1						= $a1
ram_A2						= $a2
ram_A3						= $a3
diamond_h					= $a4
grenadeUsed			 		= $a5 ; grenade opening penalty
escapedShiningLight			= $a6 ; escaped shining light penalty
findingArkBonus				= $a7 ; finding ark bonus
usingParachuteBonus			= $a8 ; using parachute bonus
skipToMesaFieldBonus		= $a9 ; skip to mesa field bonus
yarFoundBonus				= $aa ; finding Yar Easter egg bonus
usingHeadOfRaInMapRoomBonus	= $ab ; using Head of Ra in map room bonus
thiefShot		   			= $ac ; shooting thief penalty
landingInMesaBonus			= $ad ; landing in mesa bonus
unknown_action				= $ae
ram_AF						= $af

entranceRoomState			= $b1 ; entrance room state
blackMarketState			= $b2 ; black market state

ram_B4						= $b4
ram_B5						= $b5
ram_B6						= $b6
inventoryGraphicPointers	= $b7 ; inventory graphics pointer lo ($b7-$c2)
inv_slot1_hi		  		= $b8
inv_slot2_lo		 		= $b9
inv_slot2_hi		  		= $ba
inv_slot3_lo			  	= $bb
inv_slot3_hi		  		= $bc
inv_slot4_lo		  		= $bd
inv_slot4_hi		  		= $be
pwatch_state		 	 	= $bf
pwatch_Addr			 	 	= $c0
inv_slot6_lo		 	 	= $c1
inv_slot6_hi		 	 	= $c2
selectedInventoryIndex		= $c3 ; selected inventory index
numberOfInventoryItems		= $c4 ; number of inventory items
selectedInventoryId			= $c5 ; selected inventory id
basketItemsStatus			= $c6 ; basket items status
pickupItemsStatus			= $c7 ; pickup items status
objectXPos			 		= $c8 ; object horizontal positions
indyXPos			 		= $c9 ; Indy horizontal position
ram_CA						= $ca
weaponXPos					= $cb ; bullet/whip horizontal position
ram_CC						= $cc
objectYPos					= $ce ; object vertical positions
indyYPos			 		= $cf ; Indy vertical position
missileYPos			 		= $d0 ; missile 0 vertical position
weaponYPos					= $d1 ; bullet/whip vertical position
ram_D2						= $d2

ram_D4						= $d4
snakeYPos			   		= $d5 ; snake vertical position
timePieceGfxPointers		= $d6 ; timepiece graphic pointers ($d6-$d7)
ram_D7						= $d7
ram_D8						= $d8
indyGfxPointers				= $d9 ; Indy graphic pointers ($d9-$da)
ram_DA						= $da
indySpriteHeight			= $db ; Indy sprite height
player0SpriteHeight			= $dc ; player0 sprite height
player0GfxPointers			= $dd ; player0 graphic pointers ($dd-$de)
ram_DE						= $de
player0YPos					= $df ; thieves direction and size ($df-$e2)
ram_E0						= $e0
pf1GfxPointers				= $e1 ; player0 TIA pointers / PF1 graphics
ram_E2						= $e2
pf2GfxPointers				= $e3 ; PF2 graphics / fine motion pointer
ram_E4						= $e4
dungeonGfx					= $e5 ; thieves HMOVE index / dungeon graphics
ram_E6						= $e6
ram_E7						= $e7
ram_E8						= $e8
ram_E9						= $e9
ram_EA						= $ea
ram_EB						= $eb
ram_EC						= $ec
ram_ED						= $ed
thievesXPos			  		= $ee ; thieves horizontal positions ($ee-$f1)



;-----------------------------------------------------------
;	   User Defined Labels
;-----------------------------------------------------------

;Break			 = $dd68


;***********************************************************
;	   Bank 0 / 0..1
;***********************************************************

	SEG		CODE
	ORG		$0000
	RORG	$d000

;NOTE: 1st bank's vector points right at the cold start routine
	lda	   $FFF8				   ;4 trigger 1st bank (no effect here, matching LDA in 2nd)
	
Ld003
	jmp		game_start					 ;3	  =	  3
	
HorizontallyPositionObjects
	ldx		#$04					;2	 =	 2
.moveObjectLoop
	sta		WSYNC					; wait for next scan line
;---------------------------------------
	lda		objectXPos ,x				 ; get object's horizontal position
	tay								;2		  
	lda		Ldb00,y					; get fine motion/coarse position value
	sta		HMP0,x					; set object's fine motion value
	and		#$0f					; mask off fine motion value
	tay								; move coarse move value to y
.coarseMoveObject
	dey								;2		  
	bpl		.coarseMoveObject					;2/3	  
	sta		RESP0,x					; set object's coarse position
	dex								;2		  
	bpl		.moveObjectLoop					  ;2/3		
	sta		WSYNC					; wait for next scan line
;---------------------------------------
	sta		HMOVE					;3		  
	jmp		JumpToDisplayKernel					  ;3   =   6
	
	.byte	$24,$31,$10,$34,$a6,$81,$e0,$0a ; $d024 (*)
	.byte	$90,$2e,$f0,$0f,$a5,$d1,$69,$01 ; $d02c (*)
	.byte	$4a,$4a,$4a,$4a,$aa,$a9,$08,$55 ; $d034 (*)
	.byte	$df,$95,$df,$a5,$8f,$10,$11,$29 ; $d03c (*)
	.byte	$7f,$85,$8f,$a5,$95,$29,$1f,$f0 ; $d044 (*)
	.byte	$03,$20,$e9,$dc,$a9,$40,$85,$95 ; $d04c (*)
	.byte	$a9,$7f,$85,$d1,$a9,$04,$85,$ac ; $d054 (*)
	.byte	$24,$35,$10,$4a,$a6,$81,$e0,$09 ; $d05c (*)
	.byte	$f0,$56,$e0,$06,$f0,$04,$e0,$08 ; $d064 (*)
	.byte	$d0,$3c,$a5,$d1,$e5,$d4,$4a,$4a ; $d06c (*)
	.byte	$f0,$11,$aa,$a4,$cb,$c0,$12,$90 ; $d074 (*)
	.byte	$27,$c0,$8d,$b0,$23,$a9,$00,$95 ; $d07c (*)
	.byte	$e5,$f0,$1d,$a5,$cb,$c9,$30,$b0 ; $d084 (*)
	.byte	$11,$e9,$10,$49,$1f,$4a,$4a,$aa ; $d08c (*)
	.byte	$bd,$5c,$dc,$25,$e5,$85,$e5,$4c ; $d094 (*)
	.byte	$a4,$d0,$e9,$71,$c9,$20,$90,$ed ; $d09c (*)
	.byte	$a0,$7f,$84,$8f,$84,$d1,$24,$35 ; $d0a4 (*)
	.byte	$50,$0e,$24,$93,$50,$0a,$a9,$5a ; $d0ac (*)
	.byte	$85,$d2,$85,$dc,$85,$8f,$85,$d1 ; $d0b4 (*)
	.byte	$24,$33,$50,$2d,$a6,$81,$e0,$06 ; $d0bc (*)
	.byte	$f0,$1c,$a5,$c5,$c9,$02,$f0,$21 ; $d0c4 (*)
	.byte	$24,$93,$10,$0a,$a5,$83,$29,$07 ; $d0cc (*)
	.byte	$09,$80,$85,$a1,$d0,$13,$50,$11 ; $d0d4 (*)
	.byte	$a9,$80,$85,$9d,$d0,$0b,$a5,$d6 ; $d0dc (*)
	.byte	$c9,$ba,$d0,$05,$a9,$0f,$20,$e9 ; $d0e4 (*)
	.byte	$dc,$a2,$05,$e4,$81,$d0,$3a,$24 ; $d0ec (*)
	.byte	$30,$10,$0f,$86,$cf,$a9,$0c,$85 ; $d0f4 (*)
	.byte	$81,$20,$78,$d8,$a9,$4c,$85,$c9 ; $d0fc (*)
	.byte	$d0,$25,$a6,$cf,$e0,$4f,$90,$21 ; $d104 (*)
	.byte	$a9,$0a,$85,$81,$20,$78,$d8,$a5 ; $d10c (*)
	.byte	$eb,$85,$df,$a5,$ec,$85,$cf,$a5 ; $d114 (*)
	.byte	$ed,$85,$c9,$a9,$fd,$25,$b4,$85 ; $d11c (*)
	.byte	$b4,$30,$04,$a9,$80,$85,$9d,$85 ; $d124 (*)
	.byte	$2c,$24,$37,$30,$0f,$a2,$00,$86 ; $d12c (*)
	.byte	$91,$ca,$86,$97,$26,$95,$18,$66 ; $d134 (*)
	.byte	$95,$4c,$b4,$d2,$a5,$81,$d0,$13 ; $d13c (*)
	.byte	$a5,$af,$29,$07,$aa,$bd,$78,$df ; $d144 (*)
	.byte	$20,$e9,$dc,$90,$ec,$a9,$01,$85 ; $d14c (*)
	.byte	$df,$d0,$e6,$0a,$aa,$bd,$9c,$dc ; $d154 (*)
	.byte	$48,$bd,$9b,$dc,$48,$60,$a5,$cf ; $d15c (*)
	.byte	$c9,$3f,$90,$22,$a5,$96,$c9,$54 ; $d164 (*)
	.byte	$d0,$53,$a5,$8c,$c5,$8b,$d0,$13 ; $d16c (*)
	.byte	$a9,$58,$85,$9c,$85,$9e,$20,$db ; $d174 (*)
	.byte	$dd,$a9,$0d,$85,$81,$20,$78,$d8 ; $d17c (*)
	.byte	$4c,$d8,$d3,$4c,$da,$d2,$a9,$0b ; $d184 (*)
	.byte	$d0,$06,$a9,$07,$d0,$02,$a9,$04 ; $d18c (*)
	.byte	$24,$95,$30,$29,$18,$20,$10,$da ; $d194 (*)
	.byte	$b0,$06,$38,$20,$10,$da,$90,$1d ; $d19c (*)
	.byte	$c0,$0b,$d0,$05,$66,$b2,$18,$26 ; $d1a4 (*)
	.byte	$b2,$a5,$95,$20,$59,$dd,$98,$09 ; $d1ac (*)
	.byte	$c0,$85,$95,$d0,$08,$a2,$00,$86 ; $d1b4 (*)
	.byte	$b6,$a9,$80,$85,$9d,$4c,$b4,$d2 ; $d1bc (*)
	.byte	$24,$b4,$70,$20,$10,$1e,$a5,$c9 ; $d1c4 (*)
	.byte	$c9,$2b,$90,$12,$a6,$cf,$e0,$27 ; $d1cc (*)
	.byte	$90,$0c,$e0,$2b,$b0,$08,$a9,$40 ; $d1d4 (*)
	.byte	$05,$b4,$85,$b4,$d0,$06,$a9,$03 ; $d1dc (*)
	.byte	$38,$20,$10,$da,$4c,$b4,$d2,$24 ; $d1e4 (*)
	.byte	$33,$10,$2b,$a4,$cf,$c0,$3a,$90 ; $d1ec (*)
	.byte	$0b,$a9,$e0,$25,$91,$09,$43,$85 ; $d1f4 (*)
	.byte	$91,$4c,$b4,$d2,$c0,$20,$90,$07 ; $d1fc (*)
	.byte	$a9,$00,$85,$91,$4c,$b4,$d2,$c0 ; $d204 (*)
	.byte	$09,$90,$f5,$a9,$e0,$25,$91,$09 ; $d20c (*)
	.byte	$42,$85,$91,$4c,$b4,$d2,$a5,$cf ; $d214 (*)
	.byte	$c9,$3a,$90,$04,$a2,$07,$d0,$0c ; $d21c (*)
	.byte	$a5,$c9,$c9,$4c,$b0,$04,$a2,$05 ; $d224 (*)
	.byte	$d0,$02,$a2,$0d,$a9,$40,$85,$93 ; $d22c (*)
	.byte	$a5,$83,$29,$1f,$c9,$02,$b0,$02 ; $d234 (*)
	.byte	$a2,$0e,$20,$43,$dd,$b0,$04,$8a ; $d23c (*)
	.byte	$20,$e9,$dc,$4c,$b4,$d2,$24,$33 ; $d244 (*)
	.byte	$30,$20,$a5,$c9,$c9,$50,$b0,$0e ; $d24c (*)
	.byte	$c6,$c9,$26,$b2,$18,$66,$b2,$a9 ; $d254 (*)
	.byte	$00,$85,$91,$4c,$b4,$d2,$a2,$06 ; $d25c (*)
	.byte	$a5,$83,$c9,$40,$b0,$d4,$a2,$07 ; $d264 (*)
	.byte	$d0,$d0,$a4,$cf,$c0,$44,$90,$0a ; $d26c (*)
	.byte	$a9,$e0,$25,$91,$09,$0b,$85,$91 ; $d274 (*)
	.byte	$d0,$e1,$c0,$20,$b0,$d9,$c0,$0b ; $d27c (*)
	.byte	$90,$d5,$a9,$e0,$25,$91,$09,$41 ; $d284 (*)
	.byte	$d0,$ec,$e6,$c9,$d0,$22,$a5,$cf ; $d28c (*)
	.byte	$c9,$3f,$90,$12,$a9,$0a,$20,$e9 ; $d294 (*)
	.byte	$dc,$90,$15,$66,$b1,$38,$26,$b1 ; $d29c (*)
	.byte	$a9,$42,$85,$df,$d0,$0a,$c9,$16 ; $d2a4 (*)
	.byte	$90,$04,$c9,$1f,$90,$02,$c6,$c9 ; $d2ac (*)
	.byte	$a5,$81,$0a,$aa,$24,$33,$10,$09 ; $d2b4 (*)
	.byte	$bd,$b6,$dc,$48,$bd,$b5,$dc,$48 ; $d2bc (*)
	.byte	$60,$bd,$d0,$dc,$48,$bd,$cf,$dc ; $d2c4 (*)
	.byte	$48,$60							; $d2cc (*)
	
WarpToMesaSide
	lda		player0YPos					 ; Load vertical position of an object (likely thief or Indy)
	sta		ram_EB					; Store it to temp variable $EB (could be thief vertical position)
	lda		indyYPos				  ; get Indy's vertical position
	sta		ram_EC					; Store to temp variable $EC
	lda		indyXPos				  ; 3
	sta		ram_ED					; Store to temp variable $ED
	lda		#$05					; Change screen to Mesa Side
	sta		currentScreenId					   ;3		  *
	jsr		InitializeScreenState					;6		   *
	lda		#$05					; 2
	sta		indyYPos				  ; Set Indy's vertical position on entry to Mesa Side
	lda		#$50					; 2
	sta		indyXPos				  ; Set Indy's horizontal position on entry
	tsx								; 2
	cpx		#$fe					; 2
	bcs		FailSafeToCollisionCheck				   ; If X = $FE, jump to FailSafeToCollisionCheck (possibly collision or restore logic)
	rts								; Otherwise, return
	
FailSafeToCollisionCheck
	jmp		CheckIfIndyShotOrTouchedByTsetseFlies					;3	 =	 3 *
	
	.byte	$24,$b3,$30,$f9,$a9,$50,$85,$eb ; $d2f2 (*)
	.byte	$a9,$41,$85,$ec,$a9,$4c,$d0,$d6 ; $d2fa (*)
	.byte	$a4,$c9,$c0,$2c,$90,$12,$c0,$6b ; $d302 (*)
	.byte	$b0,$10,$a4,$cf,$c8,$c0,$1e,$90 ; $d30a (*)
	.byte	$02,$88,$88,$84,$cf,$4c,$64,$d3 ; $d312 (*)
	.byte	$c8,$c8,$88,$84,$c9,$d0,$43,$a9 ; $d31a (*)
	.byte	$02,$25,$b1,$f0,$0a,$a5,$cf,$c9 ; $d322 (*)
	.byte	$12,$90,$04,$c9,$24,$90,$39,$c6 ; $d32a (*)
	.byte	$c9,$d0,$2f,$a2,$1a,$a5,$c9,$c9 ; $d332 (*)
	.byte	$4c,$90,$02,$a2,$7d,$86,$c9,$a2 ; $d33a (*)
	.byte	$40,$86,$cf,$a2,$ff,$86,$e5,$a2 ; $d342 (*)
	.byte	$01,$86,$e6,$86,$e7,$86,$e8,$86 ; $d34a (*)
	.byte	$e9,$86,$ea,$d0,$0d,$a5,$92,$29 ; $d352 (*)
	.byte	$0f,$a8,$b9,$d5,$df,$a2,$01,$20 ; $d35a (*)
	.byte	$c0,$df,$a9,$05,$85,$a2,$d0,$0a ; $d362 (*)
	.byte	$26,$8a,$38,$b0,$03,$26,$8a,$18 ; $d36a (*)
	.byte	$66,$8a							; $d372 (*)
	
CheckIfIndyShotOrTouchedByTsetseFlies
	bit		CXM0P|$30				; check player collisions with missile0
	bpl		CheckGrenadeDetonation					 ; branch if didn't collide with Indy
	ldx		currentScreenId					   ; get the current screen id
	cpx		#$07					; Are we in the Spider Room?
	beq		ClearInputBit0ForSpiderRoom					  ; Yes,  go to ClearInputBit0ForSpiderRoom
	bcc		CheckGrenadeDetonation					 ; If screen ID is lower than Spider Room, skip
	lda		#$80					; Trigger a major event
	sta		majorEventFlag					  ; 3
	bne		DespawnMissile0					  ; unconditional branch
ClearInputBit0ForSpiderRoom
	rol		playerInput					 ; Rotate input left, bit 7 ? carry
	sec								; Set carry (overrides carry from rol)
	ror		playerInput					 ; Rotate right, carry -> bit 7 (bit 0 lost)
	rol		ram_B6					; Rotate a status byte left (bit 7 ? carry)
	sec								; Set carry (again overrides whatever came before)
	ror		ram_B6					; Rotate right, carry -> bit 7 (bit 0 lost)
DespawnMissile0
	lda		#$7f					;2		   *
	sta		ram_8E					; Possibly related state or shadow position
	sta		missileYPos					 ; Move missile0 offscreen (to y=127)
CheckGrenadeDetonation
	bit		ram_9A					; Check status flags
	bpl		waitTime				   ; If bit 7 is clear, skip (no grenade active?)
	bvs		ApplyGrenadeWallEffect					 ; If bit 6 is set, jump (special case, maybe already exploded)
	lda		secondsTimer				   ; get seconds time value
	cmp		grenadeDetinationTime					; compare with grenade detination time
	bne		waitTime				   ; branch if not time to detinate grenade
	lda		#$a0					; 2
	sta		weaponYPos					; Move bullet/whip offscreen (simulate detonation?)
	sta		majorEventFlag					  ; Trigger major event (explosion happened?)
ApplyGrenadeWallEffect
	lsr		ram_9A					; Logical shift right: bit 0 -> carry
	bcc		SkipUpdate					 ; If bit 0 was clear, skip this (grenade effect not triggered)
	lda		#$02					;2		   *
	sta		grenadeUsed					 ; Apply penalty (e.g., reduce score)
	ora		entranceRoomState				   ;3		  *
	sta		entranceRoomState				   ; Mark the entrance room as having the grenade opening
	ldx		#$02					;2		   *
	cpx		currentScreenId					   ;3		  *
	bne		UpdateEntranceRoomEventState				   ; branch if not in the ENTRANCE_ROOM
	jsr		InitializeScreenState					; Update visuals/state to reflect the wall opening
UpdateEntranceRoomEventState
	lda		ram_B5					; 3
	and		#$0f					;2		   *
	beq		SkipUpdate					 ; If no condition active, exit
	lda		ram_B5					;3		   *
	and		#$f0					; Clear lower nibble
	ora		#$01					; Set bit 0 (indicate some triggered state)
	sta		ram_B5					; Store updated state
	ldx		#$02					;2		   *
	cpx		currentScreenId					   ;3		  *
	bne		SkipUpdate					 ; branch if not in the ENTRANCE_ROOM
	jsr		InitializeScreenState					; Refresh screen visuals
SkipUpdate
	sec								;2		   *
	jsr		TakeItemFromInventory					; carry set...take away selected item
waitTime
	lda		INTIM					;4		  
	bne		waitTime				   ;2/3 =	6
StartNewFrame
	lda		#$02					;2		  
	sta		WSYNC					; wait for next scan line
;---------------------------------------
	sta		VSYNC					; start vertical sync (D1 = 1)
	lda		#$50					;2		  
	cmp		weaponYPos					;3		  
	bcs		UpdateFrameAndSecondsTimer					 ;2/3	   
	sta		weaponXPos					;3	 =	13 *
UpdateFrameAndSecondsTimer
	inc		frameCount			  ; increment frame count
	lda		#$3f					;	 
	and		frameCount			  ;Every 63 frames (?)	  
	bne		firstLineOfVerticalSync					  ; branch if roughly 60 frames haven't passed
	inc		secondsTimer			  ; increment every second
	lda		ram_A1					; If $A1 is positive, skip
	bpl		firstLineOfVerticalSync					  ;2/3		
	dec		ram_A1					; Else, decrement it
firstLineOfVerticalSync
	sta		WSYNC					; Wait for start of next scanline
;---------------------------------------
	bit		resetEnableFlag					  ;3		
	bpl		frame_start					  ;2/3		
	ror		SWCHB					; rotate RESET to carry
	bcs		frame_start					  ; branch if RESET not pressed
	jmp		game_start					 ; If RESET was pressed, restart the game
	
frame_start
	sta		WSYNC					; Sync with scanline (safely time video registers)
;---------------------------------------
	lda		#$00					;Load A for VSYNC pause	   
	ldx		#$2c					;Load Timer for 
	sta		WSYNC					; last line of vertical sync
;---------------------------------------
	sta		VSYNC					; end vertical sync (D1 = 0)
	stx		TIM64T					; set timer for vertical blanking period
	ldx		majorEventFlag					  ;3		
	inx								; Increment counter
	bne		Ld42a					; If not overflowed, check initials display
	stx		majorEventFlag					  ; Overflowed: zero -> set majorEventFlag to 0
	jsr		DetermineFinalScore					  ; Call final score calculation
	lda		#$0d					;2		   *
	sta		currentScreenId					   ;3		  *
	jsr		InitializeScreenState					; Transition to Ark Room
Ld427
	jmp		Ld80d					; 3
	
Ld42a
	lda		currentScreenId					   ; get the current screen id
	cmp		#$0d					;2		  
	bne		Ld482					; branch if not in ID_ARK_ROOM
	lda		#$9c					;2		  
	sta		ram_A3					; Likely sets a display timer or animation state
	ldy		yarFoundBonus					;3		  
	beq		Ld44a					; If not in Yar's Easter Egg mode, skip
	bit		resetEnableFlag					  ;3		 *
	bmi		Ld44a					; If resetEnableFlag has bit 7 set, skip
	ldx		#$ff					;2		   *
	stx		inv_slot1_hi				  ;3		 *
	stx		inv_slot2_hi				  ;3		 *
	lda		#$46					;2		   *
	sta		inventoryGraphicPointers				  ;3		 *
	lda		#$01					;2		   *
	sta		inv_slot2_lo				  ;3   =  40 *
Ld44a
	ldy		indyYPos				  ; get Indy's vertical position
	cpy		#$7c					; 124 dev
	bcs		Ld465					; If Indy is below or at Y=$7C (124), skip
	cpy		adventurePoints					  ;3		
	bcc		Ld45b					; If Indy is higher up than his point score, skip
	bit		INPT5|$30				; read action button from right controller
	bmi		Ld427					; branch if action button not pressed
	jmp		game_start					 ; RESET game if button *is* pressed
	
Ld45b
	lda		frameCount					 ; get current frame count
	ror								; shift D0 to carry
	bcc		Ld427					; branch on even frame
	iny								; Move Indy down by 1 pixel
	sty		indyYPos				  ;3		
	bne		Ld427					; unconditional branch
Ld465
	bit		resetEnableFlag					  ; Check bit 7 of resetEnableFlag
	bmi		Ld46d					; If bit 7 is set, skip (reset enabled)
	lda		#$0e					;2		   *
	sta		ram_A2					; Set Indys state to 0E
Ld46d
	lda		#$80					;2		   *
	sta		resetEnableFlag					  ; Set bit 7 to enable reset logic
	bit		INPT5|$30				; Check action button on right controller
	bmi		Ld427					; If not pressed, skip
	lda		frameCount					 ; get current frame count
	and		#$0f					; Limit to every 16th frame
	bne		Ld47d					; If not at correct frame, skip
	lda		#$05					;2	 =	19 *
Ld47d
	sta		ram_8C					; Store action/state code
	jmp		reset_vars					 ; Handle command
	
Ld482
	bit		ram_93					;3		   *
	bvs		Ld489					; If bit 6 set, jump to alternate path
Ld486
	jmp		Ld51c					; Continue Ark Room or endgame logic
	
Ld489
	lda		frameCount					 ; get current frame count
	and		#$03					; Only act every 4 frames
	bne		Ld501					; If not, skip
	ldx		player0SpriteHeight					 ; 3
	cpx		#$60					; 2
	bcc		Ld4a5					; If $DC < $60, branch (some kind of position or counter)
	bit		majorEventFlag					  ;3		 *
	bmi		Ld486					; If bit 7 is set, jump to continue logic
	ldx		#$00					; Reset X
	lda		indyXPos				  ; 3
	cmp		#$20					; 2
	bcs		Ld4a3					; If Indy is right of x=$20, skip
	lda		#$20					; 2
Ld4a3
	sta		ram_CC					; Store Indys forced horizontal position?
Ld4a5
	inx								; 2
	stx		player0SpriteHeight					 ; Increment and store progression step or counter
	txa								; 2
	sec								; 2
	sbc		#$07					; Subtract 7 to control pacing
	bpl		Ld4b0					; If result = 0, continue
	lda		#$00					; Otherwise, reset A to 0
Ld4b0
	sta		ram_D2					; Store A (probably from LD4A5) into $D2  possibly temporary Y position
	and		#$f8					; 2
	cmp		snakeYPos				   ; 3
	beq		Ld501					; If vertical alignment hasnt changed, skip update
	sta		snakeYPos				   ; Update snakes vertical position
	lda		ram_D4					; 3
	and		#$03					; 2
	tax								; 2
	lda		ram_D4					; 3
	lsr								; 2
	lsr								; 2
	tay								; 2
	lda		Ldbff,x					; 4
	clc								; 2
	adc		Ldbff,y					; Add two offset values from table at LDBFF
	clc								; 2
	adc		ram_CC					; Add forced Indy X position
	ldx		#$00					;2		   *
	cmp		#$87					; Apply Horizontal Constraints
	bcs		Ld4e2					; If = $87, skip update
	cmp		#$18					; 2
	bcc		Ld4de					; If < $18, also skip update
	sbc		indyXPos				  ; 3
	sbc		#$03					; 2
	bpl		Ld4e2					; If result = 0, skip
Ld4de
	inx								; X = 1
	inx								; X = 2 (prepare alternate motion state)
	eor		#$ff					; Flip delta (ones complement)
Ld4e2
	cmp		#$09					;2		   *
	bcc		Ld4e7					; If too close, skip speed/direction adjustment
	inx								; Otherwise, refine behavior with additional increment
Ld4e7
	txa								; 2
	asl								; 2
	asl								; 2
	sta		BSLDALoop				   ; Multiply X by 4 -> store as upper bits of state
	lda		ram_D4					; 3
	and		#$03					; 2
	tax								; 2
	lda		Ldbff,x					; 4
	clc								; 2
	adc		ram_CC					; 3
	sta		ram_CC					; Refine target horizontal position
	lda		ram_D4					; 3
	lsr								; 2
	lsr								; 2
	ora		BSLDALoop				   ; 3
	sta		ram_D4					; Store new composite motion/state byte
Ld501
	lda		ram_D4					; 3
	and		#$03					; 2
	tax								; 2
	lda		Ldbfb,x					; 4
	sta		timePieceGfxPointers				   ; Store horizontal movement/frame data
	lda		#$fa					;2		   *
	sta		ram_D7					; Store high byte of graphics or pointer address
	lda		ram_D4					; 3
	lsr								; 2
	lsr								; 2
	tax								; 2
	lda		Ldbfb,x					; 4
	sec								; 2
	sbc		#$08					; 2
	sta		ram_D8					; Store vertical offset (with adjustment)
Ld51c
	bit		majorEventFlag					  ; 3
	bpl		Ld523					; If major event not complete, continue sequence
	jmp		Ld802					; Else, jump to end/cutscene logic
	
Ld523
	bit		ram_A1					; 3
	bpl		Ld52a					; If timer still counting or inactive, proceed
	jmp		Ld78c					; Else, jump to alternate script path (failure/end?)
	
Ld52a
	lda		frameCount					 ; get current frame count
	ror								; ; Test even/odd frame
	bcc		Ld532					; ; If even, continue next step
	jmp		Ld627					; If odd, do something else
	
Ld532
	ldx		currentScreenId					   ; get the current screen id
	cpx		#$05					;2		   *
	beq		Ld579					; If on Mesa Side, use a different handler
	bit		ram_8D					;3		   *
	bvc		Ld56e					; If no event/collision flag set, skip
	ldx		weaponXPos					; get bullet or whip horizontal position
	txa								; 2
	sec								; 2
	sbc		indyXPos				  ; 3
	tay								; Y = horizontal distance between Indy and projectile
	lda		SWCHA					; read joystick values
	ror								; shift right joystick UP value to carry
	bcc		Ld55b					; branch if right joystick pushing up
	ror								; shift right joystick DOWN value to carry
	bcs		Ld579					; branch if right joystick not pushed down
	cpy		#$09					;2		   *
	bcc		Ld579					; If too close to projectile, skip
	tya								;2		   *
	bpl		Ld556					; If projectile is to the right of Indy, continue
Ld553
	inx								; 2
	bne		Ld557					; 2
Ld556
	dex								; 2
Ld557
	stx		weaponXPos					;3		   *
	bne		Ld579					; Exit if projectile has nonzero position
Ld55b
	cpx		#$75					; 2
	bcs		Ld579					; Right bound check
	cpx		#$1a					; 2
	bcc		Ld579					; Left bound check
	dey								; 2
	dey								; 2
	cpy		#$07					; 2
	bcc		Ld579					; Too close vertically
	tya								; 2
	bpl		Ld553					; If projectile right of Indy, nudge right
	bmi		Ld556					; Else, nudge left
Ld56e
	bit		ram_B4					; 3
	bmi		Ld579					; If flag set, skip
	bit		playerInput					 ;3			*
	bpl		Ld57c					; If no button, skip
	ror								; 2
	bcc		Ld57c					; If wrong button, skip
Ld579
	jmp		Ld5e0					; 3
	
Ld57c
	ldx		#$01					; Get index of Indy in object list
	lda		SWCHA					; read joystick values
	sta		BankStrobeAddrTemp					; Store raw joystick input
	and		#$0f					;2		   *
	cmp		#$0f					;2		   *
	beq		Ld579					; Skip if no movement
	sta		indy_dir				  ; 3
	jsr		move_enemy					 ; Move Indy according to input
	ldx		currentScreenId					   ; get the current screen id
	ldy		#$00					; 2
	sty		BSLDALoop				   ; Reset scan index/counter
	beq		Ld599					; Unconditional (Y=0, so BNE not taken)
Ld596
	tax								; Transfer A to X (probably to use as an object index or ID)
	inc		BSLDALoop				   ; Increment $84	 a general-purpose counter or index
Ld599
	lda		indyXPos				  ; 3
	pha								; Temporarily store horizontal position
	lda		indyYPos				  ; get Indy's vertical position
	ldy		BSLDALoop				   ; Load current scan/event index
	cpy		#$02					; 2
	bcs		Ld5ac					; If index >= 2, store in reverse order
	sta		BSJMP				   ; Vertical position
	pla								;4		   *
	sta		BSJMPAddr				   ; Horizontal position
	jmp		Ld5b1					;3	 =	29 *
	
Ld5ac
	sta		BSJMPAddr				   ; Vertical -> $87
	pla								;4		   *
	sta		BSJMP				   ; Horizontal -> $86
Ld5b1
	ror		BankStrobeAddrTemp					; Rotate player input to extract direction
	bcs		Ld5d1					; If carry set, skip
	jsr		CheckRoomOverrideCondition					 ; Run event/collision subroutine
	bcs		Ld5db					; If failed/blocked, exit
	bvc		Ld5d1					; If no vertical/horizontal event flag, skip
	ldy		BSLDALoop				   ; Event index
	lda		Ldf6c,y					; Get movement offset from table
	cpy		#$02					; 2
	bcs		Ld5cc					; If index = 2, move horizontally
	adc		indyYPos				  ; 3
	sta		indyYPos				  ; 3
	jmp		Ld5d1					; 3
	
Ld5cc
	clc								; 2
	adc		indyXPos				  ; 3
	sta		indyXPos				  ; 3
Ld5d1
	txa								; 2
	clc								; 2
	adc		#$0d					; Offset for object range or screen width
	cmp		#$34					; 2
	bcc		Ld596					; If still within bounds, continue scanning
	bcs		Ld5e0					; Else, exit
Ld5db
	sty		currentScreenId					   ; Set new screen based on event result
	jsr		InitializeScreenState					; Load new room or area
Ld5e0
	bit		INPT4|$30				; read action button from left controller
	bmi		Ld5f5					; branch if action button not pressed
	bit		ram_9A					; 3
	bmi		Ld624					; If game state prevents interaction, skip
	lda		playerInput					 ;3			*
	ror								; Check bit 0 of input
	bcs		Ld5fa					; If set, already mid-action, skip
	sec								; Prepare to take item
	jsr		TakeItemFromInventory					; carry set...take away selected item
	inc		playerInput					 ; Advance to next inventory slot
	bne		Ld5fa					; Always branch
Ld5f5
	ror		playerInput					 ;5			*
	clc								; 2
	rol		playerInput					 ;5	  =	 12 *
Ld5fa
	lda		ram_91					; 3
	bpl		Ld624					; If no item queued, exit
	and		#$1f					; Mask to get item ID
	cmp		#$01					; 2
	bne		Ld60c					; 2
	inc		numberOfBullets					   ; Give Indy 3 bullets
	inc		numberOfBullets					   ;5		  *
	inc		numberOfBullets					   ;5		  *
	bne		Ld620					; unconditional branch
Ld60c
	cmp		#$0b					; 2
	bne		Ld61d					; 2
	ror		blackMarketState				   ; rotate Black Market state right
	sec								; set carry
	rol		blackMarketState				   ; rotate left to show Indy carrying Shovel
	ldx		#$45					; 2
	stx		player0YPos					 ; Set Y-pos for shovel on screen
	ldx		#$7f					; 2
	stx		missileYPos					 ;3	  =	 26 *
Ld61d
	jsr		PlaceItemInInventory				   ;6	=	6 *
Ld620
	lda		#$00					; 2
	sta		ram_91					; Clear item pickup/use state
Ld624
	jmp		Ld777					; ; Return from event handle
	
Ld627
	bit		ram_9A					; Test game state flags
	bmi		Ld624					; If bit 7 is set (N = 1), then a grenade or parachute event is in progress.
	bit		INPT5|$30				; read action button from right controller
	bpl		Ld638					; branch if action button pressed
	lda		#$fd					; Load inverse of USING_GRENADE_OR_PARACHUTE (i.e., clear bit 1)
	and		playerInput					 ; ; Clear the USING_GRENADE_OR_PARACHUTE bit from the player input state
	sta		playerInput					 ; Store the updated input state
	jmp		Ld777					;3	 =	21 *
	
Ld638
	lda		#$02					; Load the flag indicating item use (grenade/parachute)
	bit		playerInput					 ; Check if the flag is already set in player input
	bne		Ld696					; If it's already set, skip re-setting (item already active)
	ora		playerInput					 ; Otherwise, set the USING_GRENADE_OR_PARACHUTE bit
	sta		playerInput					 ; Save the updated input state
	ldx		selectedInventoryId					  ; get the current selected inventory id
	cpx		#$05					; Is the selected item the marketplace grenade?
	beq		Ld64c					; If yes, jump to grenade activation logic
	cpx		#$06					; If not, is it the black market grenade?
	bne		Ld671					; If neither, check if it's a parachute
Ld64c
	ldx		indyYPos				  ; get Indy's vertical position
	stx		weaponYPos					; Set grenade's starting vertical position
	ldy		indyXPos				  ; get Indy horizontal position
	sty		weaponXPos					; Set grenade's starting horizontal position
	lda		secondsTimer				   ; get the seconds timer
	adc		#$04					; increment value by 5...carry set
	sta		grenadeDetinationTime					; detinate grenade 5 seconds from now
	lda		#$80					; Prepare base grenade state value (bit 7 set)
	cpx		#$35					; Is Indy below the rock's vertical line?
	bcs		Ld66c					; branch if Indy is under rock scanline
	cpy		#$64					; Is Indy too far left?
	bcc		Ld66c					;2/3	   *
	ldx		currentScreenId					   ; get the current screen id
	cpx		#$02					; Are we in the Entrance Room?
	bne		Ld66c					; branch if not in the ENTRANCE_ROOM
	ora		#$01					; Set bit 0 to trigger wall explosion effect
Ld66c
	sta		ram_9A					; Store the grenade state flags: Bit 7 set: grenade is active - Bit 0 optionally set: triggers wall explosion if conditions were met
	jmp		Ld777					;3	 =	 6 *
	
Ld671
	cpx		#$03					; Is the selected item the parachute?
	bne		Ld68b					; If not, branch to other item handling
	stx		usingParachuteBonus					  ; Store the parachute usage flag for scoring bonus
	lda		ram_B4					; Load major event and state flags
	bmi		Ld696					; If bit 7 is set (already parachuting), skip reactivation
	ora		#$80					; Set bit 7 to indicate parachute is now active
	sta		ram_B4					; Save the updated event flags
	lda		indyYPos				  ; get Indy's vertical position
	sbc		#$06					; Subtract 6 (carry is set by default), to move him slightly up
	bpl		Ld687					; If the result is positive, keep it
	lda		#$01					; If subtraction underflows, cap position to 1
Ld687
	sta		indyYPos				  ; 3
	bpl		Ld6d2					; unconditional branch
Ld68b
	bit		ram_8D					; Check special state flags (likely related to scripted events)
	bvc		Ld6d5					; If bit 6 is clear (no vertical event active), skip to further checks
	bit		CXM1FB|$30				; Check collision between missile 1 and playfield
	bmi		Ld699					; If collision occurred (bit 7 set), go to handle collision impact
	jsr		WarpToMesaSide					 ; No collision  warp Indy to Mesa Side (context-dependent event)
Ld696
	jmp		Ld777					; 3
	
Ld699
	lda		weaponYPos					; get bullet or whip vertical position
	lsr								; Divide by 2 (fine-tune for tile mapping)
	sec								; Set carry for subtraction
	sbc		#$06					; Subtract 6 (offset to align to tile grid)
	clc								; Clear carry before next addition
	adc		player0YPos					 ; Add reference vertical offset (likely floor or map tile start)
	lsr								; Divide by 16 total:
	lsr								; Effectively: (Y - 6 + $DF) / 16
	lsr								;2		   *
	lsr								;2		   *
	cmp		#$08					; Check if the result fits within bounds (max 7)
	bcc		Ld6ac					; If less than 8, jump to store the index
	lda		#$07					; Clamp to max value (7) if out of bounds
Ld6ac
	sta		BSLDALoop				   ; Store the region index calculated from vertical position
	lda		weaponXPos					; get bullet or whip horizontal position
	sec								; 2
	sbc		#$10					; Adjust for impact zone alignment
	and		#$60					; Mask to relevant bits (coarse horizontal zone)
	lsr								;2		   *
	lsr								; Divide by 4	convert to tile region
	adc		BSLDALoop				   ; Combine with vertical region index to form a unique map zone index
	tay								; Move index to Y
	lda		Ldf7c,y					; Load impact response from lookup table
	sta		ram_8B					; Store result	 likely affects state or visual of game field
	ldx		weaponYPos					; get bullet or whip vertical position
	dex								; Decrease projectile X by 2  simulate impact offset
	stx		weaponYPos					;3		   *
	stx		indyYPos				  ; Sync Indy's horizontal position to projectiles new position
	ldx		weaponXPos					;3		   *
	dex								; Decrease projectile X by 2  simulate impact offset
	dex								;2		   *
	stx		weaponXPos					;3		   *
	stx		indyXPos				  ; Sync Indy's horizontal position to projectiles new position
	lda		#$46					; Set special state value
	sta		ram_8D					; Likely a flag used by event logic
Ld6d2
	jmp		Ld773					; Jump to item-use or input continuation logic
	
Ld6d5
	cpx		#$0b					; Is the selected item the shovel?
	bne		Ld6f7					; If not, skip to other item handling
	lda		indyYPos				  ; get Indy's vertical position
	cmp		#$41					; Is Indy deep enough to dig?
	bcc		Ld696					; If not, exit (can't dig here)
	bit		CXPPMM|$30				; check player / missile collisions (probably shovel sprite contact with dig site)
	bpl		Ld696					; branch if players didn't collide
	inc		ram_97					; Increment dig attempt counter
	bne		Ld696					; If not the first dig attempt, exit
	ldy		ram_96					; Load current dig depth or animation frame
	dey								; Decrease depth
	cpy		#$54					; Is it still within range?
	bcs		Ld6ef					; If at or beyond max depth, cap it
	iny								; Otherwise restore it back (prevent negative values)
Ld6ef
	sty		ram_96					; Save the clamped or unchanged dig depth value
	lda		#$0a					;2		   *
	sta		findingArkBonus					 ; Set the bonus for having found the Ark
	bne		Ld696					; unconditional branch
Ld6f7
	cpx		#$10					; Is the selected item the Ankh?
	bne		Ld71e					; If not, skip to next item handling
	ldx		currentScreenId					   ; get the current screen id
	cpx		#$00					; Is Indy in the Treasure Room?
	beq		Ld696					; If so, don't allow Ankh warp from here
	lda		#$09					; Mark this warp use (likely applies 9-point score penalty)
	sta		skipToMesaFieldBonus				   ; set to reduce score by 9 points
	sta		currentScreenId					   ; Change current screen to Mesa Field
	jsr		InitializeScreenState					; Load the data for the new screen
	lda		#$4c					; Prepare a flag or state value for later use (e.g., warp effect)
	sta		indyXPos				  ; Set Indy's horizontal position
	sta		weaponXPos					; Set projectile's horizontal position (same as Indy)
	lda		#$46					; Fixed vertical position value (start of Mesa Field?)
	sta		indyYPos				  ; Set Indy's vertical position
	sta		weaponYPos					; Set projectile's vertical position
	sta		ram_8D					; Set event/state flag (used later to indicate transition or animation)
	lda		#$1d					; Set initial vertical scroll or map offset?
	sta		player0YPos					 ; Likely adjusts tile map base Y
	bne		Ld777					; Unconditional jump to common handler
Ld71e
	lda		SWCHA					; read joystick values
	and		#$0f					; Mask to isolate movement bits
	cmp		#$0f					;2		   *
	beq		Ld777					; branch if right joystick not moved
	cpx		#$0d					;2		   *
	bne		Ld747					; check for Indy using whip
	bit		WeaponStatus				  ; check bullet or whip status
	bmi		Ld777					; branch if bullet active
	ldy		numberOfBullets					   ; get number of bullets remaining
	bmi		Ld777					; branch if no more bullets
	dec		numberOfBullets					   ; reduce number of bullets
	ora		#$80					;2		   *
	sta		WeaponStatus				  ; set BULLET_OR_WHIP_ACTIVE bit
	lda		indyYPos				  ; get Indy's vertical position
	adc		#$04					; Offset to spawn bullet slightly above Indy
	sta		weaponYPos					; Set bullet Y position
	lda		indyXPos				  ;3		 *
	adc		#$04					; Offset to spawn bullet slightly ahead of Indy
	sta		weaponXPos					; Set bullet X position
	bne		Ld773					; unconditional branch
Ld747
	cpx		#$0a					; Is Indy using the whip?
	bne		Ld777					; branch if Indy not using whip
	ora		#$80					; Set a status bit (probably to indicate whip action)
	sta		ram_8D					; Store it in the game state/event flags
	ldy		#$04					; Default vertical offset (X)
	ldx		#$05					; Default horizontal offset (Y)
	ror								; shift MOVE_UP to carry
	bcs		Ld758					; branch if not pushed up
	ldx		#$fa					; If pressing up, set vertical offset
Ld758
	ror								; shift MOVE_DOWN to carry
	bcs		Ld75d					; branch if not pushed down
	ldx		#$0f					; If pressing down, set vertical offset
Ld75d
	ror								; shift MOVE_LEFT to carry
	bcs		Ld762					; branch if not pushed left
	ldy		#$f7					; If pressing left, set horizontal offset
Ld762
	ror								; shift MOVE_RIGHT to carry
	bcs		Ld767					; branch if not pushed right
	ldy		#$10					; If pressing right, set horizontal offset
Ld767
	tya								; Move horizontal offset (Y) into A
	clc								;2		   *
	adc		indyXPos				  ;3		 *
	sta		weaponXPos					; Add to Indys current horizontal position
	txa								; 2				 ; Move vertical offset (X) into A
	clc								; 2
	adc		indyYPos				  ; Add to Indys current vertical position
	sta		weaponYPos					; Set whip strike vertical position
Ld773
	lda		#$0f					; Set effect timer or flag for whip (e.g., 15 frames)
	sta		ram_A3					; Likely used to animate or time whip visibility/effect
Ld777
	bit		ram_B4					; Check game status flags
	bpl		Ld783					; If parachute bit (bit 7) is clear, skip parachute rendering
	lda		#$63					; Load low byte of parachute sprite address
	sta		indyGfxPointers					 ; Set Indy's sprite pointer
	lda		#$0f					; Load height for parachuting sprite
	bne		Ld792					; unconditional branch
Ld783
	lda		SWCHA					; read joystick values
	and		#$0f					; Mask movement input
	cmp		#$0f					;2		   *
	bne		Ld796					; If any direction is pressed, skip (Indy is moving)
Ld78c
	lda		#$58					; Load low byte of pointer to stationary sprite
Ld78e
	sta		indyGfxPointers					 ; Store sprite pointer (low byte)
	lda		#$0b					; Load height for standard Indy sprite
Ld792
	sta		indySpriteHeight				  ; Store sprite height
	bne		Ld7b2					; unconditional branch
Ld796
	lda		#$03					; Mask to isolate movement input flags (e.g., up/down/left/right)
	bit		playerInput					 ;3			*
	bmi		Ld79d					; If bit 7 (UP) is set, skip right shift
	lsr								; Shift movement bits (to vary animation speed/direction)
Ld79d
	and		frameCount					 ; Use frameCount to time animation updates
	bne		Ld7b2					; If result is non-zero, skip sprite update this frame
	lda		#$0b					; Load base sprite height
	clc								;2		   *
	adc		indyGfxPointers					 ; Advance to next sprite frame
	cmp		#$58					; Check if we've reached the end of walking frames
	bcc		Ld78e					; If not yet at stationary, update sprite pointer
	lda		#$02					; Set a short animation timer
	sta		ram_A3					; 3
	lda		#$00					; ; Reset animation back to first walking frame
	bcs		Ld78e					; Unconditional jump to store new sprite pointer
Ld7b2
	ldx		currentScreenId					   ; get the current screen id
	cpx		#$09					; Load current screen ID
	beq		Ld7bc					; If yes, check sinking conditions
	cpx		#$0a					; If yes, check sinking conditions
	bne		Ld802					; If neither, skip this routine
Ld7bc
	lda		frameCount					 ; get current frame count
	bit		playerInput					 ;3			*
	bpl		Ld7c3					; If bit 7 of playerInput is clear (not pushing up?), apply shift
	lsr								; Adjust animation or action pacing
Ld7c3
	ldy		indyYPos				  ; get Indy's vertical position
	cpy		#$27					; Is he at the sinking zone Y-level?
	beq		Ld802					; If so, skip (already sunk enough)
	ldx		player0YPos					 ; Load terrain deformation or sink offset?
	bcs		Ld7e8					; If carry is set from earlier BIT, go to advanced sink
	beq		Ld802					; If $DF is 0, no further sinking
	inc		indyYPos				  ; Sink Indy vertically
	inc		weaponYPos					; Sink the projectile too
	and		#$02					; Control sinking frequency
	bne		Ld802					; Skip if odd/even frame constraint not me
	dec		player0YPos					 ; Reduce sink counter
	inc		objectYPos					; Possibly animation or game state flag
	inc		missileYPos					 ; Sink a visible element (perhaps parachute/missile sprite)
	inc		ram_D2					; Another state tracker
	inc		objectYPos					;5		   *
	inc		missileYPos					 ; Repeated to simulate multi-phase sinking
	inc		ram_D2					; 5
	jmp		Ld802					; Continue normal processing
	
Ld7e8
	cpx		#$50					; Check if Indy has reached the upper bound for rising
	bcs		Ld802					; If Indy is already high enough, skip
	dec		indyYPos				  ; Move Indy upward
	dec		weaponYPos					; Move projectile upward as well
	and		#$02					; Use timing mask to control frame-based rise rate
	bne		Ld802					; If not aligned, skip this update
	inc		player0YPos					 ; Increase sink offset counter (reversing descent)
	dec		objectYPos					; Adjust state/animation back
	dec		missileYPos					 ; Move visible missile/sprite upward
	dec		ram_D2					; Update related state
	dec		objectYPos					;5		   *
	dec		missileYPos					 ;5			*
	dec		ram_D2					; Mirror the changes made in the sinking routine
Ld802
	lda		#$28					; Load low byte of destination routine in Bank 1
	sta		ram_88					;3		   *
	lda		#$f5					; Load high byte of destination
	sta		ram_89					;3		   *
	jmp		Ldfad					; Perform the bank switch and jump to new code
	
Ld80d
	lda		ram_99					; Check status flag (likely screen initialization)
	beq		Ld816					; If zero, skip subroutine
	jsr		AddTableValueToRam98	; Apply indexed adjustment to ram_98
	lda		#$00					; Clear the flag afterward
Ld816
	sta		ram_99					; Store the updated flag
	ldx		currentScreenId					   ; get the current screen id
	lda		Ldb00,x					;4		  
	sta		NUSIZ0					; Set object sizing/horizontal motion control
	lda		playfieldControl				   ;3		 
	sta		CTRLPF					; Set playfield control flags
	lda		Ldba0,x					;4		  
	sta		COLUBK					; set current screen background color
	lda		Ldbae,x					;4		  
	sta		COLUPF					; set current screen playfield color
	lda		Ldbc3,x					;4		  
	sta		COLUP0					; Set Player 0 (usually enemies or projectiles) color
	lda		Ldbbc,x					;4		  
	sta		COLUP1					;3		  
	cpx		#$0b					;2		  
	bcc		Ld84b					;2/3	  
	lda		#$20					;2		  
	sta		ram_D4					; Possibly enemy counter, timer, or position marker
	ldx		#$04					;2	 =	58
Ld841
	ldy		dungeonGfx,x				;4		  
	lda		Ldb00,y					;4		  
	sta		thievesXPos ,x				  ;4		
	dex								;2		  
	bpl		Ld841					; Loop through all Thieves' Den enemy positions
Ld84b
	jmp		HorizontallyPositionObjects					  ;3   =   3
	
Ld84e
	lda		#$4d					; Set Indy's horizontal position in the Ark Room
	sta		indyXPos				  ; 3
	lda		#$48					; 2
	sta		objectXPos					 ; Unknown, likely related to screen offset or trigger state
	lda		#$1f					; 2
	sta		indyYPos				  ; Set Indy's vertical position in the Ark Room
	rts								; Return from subroutine
	
Ld85b
	ldx		#$00					; Start at index 0
	txa								; A = 0 (will be used to clear memory)
Ld85e
	sta		player0YPos,x				 ; Clear/reset memory at $DF$E4
	sta		ram_E0,x				;4		   *
	sta		pf1GfxPointers ,x				 ;4			*
	sta		ram_E2,x				;4		   *
	sta		pf2GfxPointers ,x				 ;4			*
	sta		ram_E4,x				;4		   *
	txa								; Check accumulator value
	bne		Ld873					; If A ? 0, exit (used for conditional init)
	ldx		#$06					; Prepare to re-run loop with X = 6
	lda		#$14					; Now set A = 20 (used for secondary initialization)
	bne		Ld85e					; Unconditional loop to write new value
Ld873
	lda		#$fc					; Load setup value (likely a countdown, position, or state flag)
	sta		ram_D7					; Store it to a specific control variable
	rts								; Return from subroutine
	
InitializeScreenState
	lda		ram_9A					; Load player item state / status flags
	bpl		ResetRoomFlags					 ; If bit 7 is clear (no grenade/parachute active), skip flag set
	ora		#$40					; Set bit 6: possibly "re-entering room" or "just warped"
	sta		ram_9A					; Save updated status
ResetRoomFlags
	lda		#$5c					; Likely a vertical offset or a default Y-position baseline
	sta		ram_96					; Used for digging or vertical alignment mechanics
	ldx		#$00					; Clear various status bytes
	stx		ram_93					; Could be a cutscene or transition state
	stx		ram_B6					; Possibly enemy or item slot usage
	stx		ram_8E					; May control animation phase or enemy flags
	stx		ram_90					; Could be Indy or enemy action lock
	lda		pickupStatusFlags					; Read item collection flags
	stx		pickupStatusFlags					; Clear them all (reset pickups for new screen)
	jsr		AddTableValueToRam98	; Apply indexed adjustment to ram_98
	rol		playerInput					 ; Rotate input flags  possibly to mask off an "item use" bit
	clc								; 2
	ror		playerInput					 ; Reverse the bit rotation; keeps input state consistent
	ldx		currentScreenId					   ; Load which room Indy is in
	lda		Ldb92,x					;4		  
	sta		playfieldControl				   ; Set up playfield reflection, score display, priorities
	cpx		#$0d					;2		  
	beq		Ld84e					; Setup special Ark Room spawn point
	cpx		#$05					;2		   *
	beq		Ld8b1					;2/3	   *
	cpx		#$0c					;2		   *
	beq		Ld8b1					;2/3	   *
	lda		#$00					;2		   *
	sta		ram_8B					; General-purpose flag for room state, cleared by default
Ld8b1
	lda		Ldbee,x					; 4
	sta		player0GfxPointers					; Set low byte of sprite pointer for P0 (non-Indy)
	lda		Ldbe1,x					; 4
	sta		ram_DE					; Set high byte of sprite pointer for P0
	lda		Ldbc9,x					; 4
	sta		player0SpriteHeight					 ; Set height of the sprite (e.g., enemy size)
	lda		Ldbd4,x					; 4
	sta		objectXPos					 ; Likely a screen property (enemy group type, warp flag)
	lda		Ldc0e,x					; 4
	sta		ram_CA					; Possibly related to object spawning
	lda		Ldc1b,x					; 4
	sta		missileYPos					 ; Position for environmental object (missile0 = visual fx)
	cpx		#$0b					;2		   *
	bcs		Ld85b					; If this is Thieves Den or later, clear additional state
	adc		Ldc03,x					; 4
	sta		ram_E0					; 3					; Special room behavior index or environmental parameter
	lda		Ldc28,x					; 4
	sta		pf1GfxPointers					 ; PF1 low byte
	lda		Ldc33,x					; 4
	sta		ram_E2					; PF1 high byte
	lda		Ldc3e,x					; 4
	sta		pf2GfxPointers					 ; PF2 low byte
	lda		Ldc49,x					; 4
	sta		ram_E4					; PF2 high byte
	lda		#$55					; 2
	sta		ram_D2					; Likely a default animation frame or sound cue value
	sta		weaponYPos					; Default vertical position for bullets/whips
	cpx		#$06					;2		   *
	bcs		Ld93e					; Jump past object position logic if in later screens
	lda		#$00					; Clear out default vertical offset value
	cpx		#$00					;2		   *
	beq		Ld91b					;2/3!	   *
	cpx		#$02					;2		   *
	beq		Ld92a					;2/3	   *
	sta		objectYPos					; Default vertical position for objects (top of screen)
Ld902
	ldy		#$4f					; Default environmental sink or vertical state
	cpx		#$02					;2		   *
	bcc		Ld918					; If before Entrance Room, use default Y
	lda		ram_AF,x				; 4
	ror								; Check a control bit from table (could enable falling)
	bcc		Ld918					; If not set, use default
	ldy		Ldf72,x					; 4					; Load alternate vertical offset from table
	cpx		#$03					;2		   *
	bne		Ld918					; Only override object height if in Black Market
	lda		#$ff					; 2
	sta		missileYPos					 ; Hide missile object by placing it off-screen
Ld918
	sty		player0YPos					 ; Finalize vertical object/environment state
	rts								; Return from screen initialization
	
Ld91b
	lda		ram_AF					; Load screen control byte
	and		#$78					; Mask off all but bits 36 (preserve mid flags, clear others)
	sta		ram_AF					; Save the updated control state
	lda		#$1a					;2		   *
	sta		objectYPos					; Set vertical position for the top object
	lda		#$26					; 2
	sta		player0YPos					 ; Set vertical position for the bottom object
	rts								; Return
	
Ld92a
	lda		entranceRoomState				   ;3		  *
	and		#$07					;2		   *
	lsr								; shift value right
	bne		Ld935					; branch if wall opening present in Entrance Room
	ldy		#$ff					; 2
	sty		missileYPos					 ;3	  =	 14 *
Ld935
	tay								; Transfer A (index) to Y
	lda		Ldf70,y					; Look up Y-position for Entrance Room's top object
	sta		objectYPos					; Set the object's vertical position
	jmp		Ld902					; Continue the screen setup process
	
Ld93e
	cpx		#$08					; Check if current room is "Room of Shining Light"
	beq		Ld950					; If so, jump to its specific init routine
	cpx		#$06					; If not, is it the Temple Entrance?
	bne		Ld968					; If neither, skip this routine
	ldy		#$00					; 2
	sty		ram_D8					; Clear some dungeon-related state variable
	ldy		#$40					; 2
	sty		dungeonGfx					; Set visual reference for top-of-dungeon graphics
	bne		Ld958					; Always taken
Ld950
	ldy		#$ff					; 2
	sty		dungeonGfx					; Top of dungeon should render with full brightness/effect
	iny								; y = 0
	sty		ram_D8					; Possibly clear temple or environmental state
	iny								; y = 1
Ld958
	sty		ram_E6					; Set dungeon tiles to base values
	sty		ram_E7					;3		   *
	sty		ram_E8					;3		   *
	sty		ram_E9					;3		   *
	sty		ram_EA					;3		   *
	ldy		#$39					; 2
	sty		ram_D4					; Likely a counter or timer
	sty		snakeYPos				   ; Set snake enemy Y-position baseline
Ld968
	cpx		#$09					;2		   *
	bne		ReturnFromRoomSpecificInit					 ; If not Mesa Field, skip
	ldy		indyYPos				  ; get Indy's vertical position
	cpy		#$49					; 2
	bcc		ReturnFromRoomSpecificInit					 ; If Indy is above threshold, no sinking
	lda		#$50					; 2
	sta		player0YPos					 ; Set environmental sink value  starts Indy sinking
	rts								; return
	
ReturnFromRoomSpecificInit
	lda		#$00					;2		   *
	sta		player0YPos					 ; Clear the environmental sink value (Indy won't sink)
	rts								; Return to caller (completes screen init)
	
CheckRoomOverrideCondition
	ldy		Lde00,x					; Load room override index based on current screen ID
	cpy		BSJMP				   ; Compare with current override key or control flag
	beq		ApplyRoomOverridesIfMatched					  ; If it matches, apply special overrides
	clc								; Clear carry (no override occurred)
	clv								; Clear overflow (in case its used for flag-based branching)
	rts								; Exit with no overrides
	
ApplyRoomOverridesIfMatched
	ldy		Lde34,x					; Load vertical override flag
	bmi		CheckAdvancedOverrideConditions					  ; If negative, skip overrides and return with SEC
CheckVerticalOverride
	lda		Ldf04,x					; Load vertical position override (if any)
	beq		ApplyHorizontalOverride					  ; If zero, skip vertical positioning
ApplyVerticalOverride
	sta		indyYPos				  ; Apply vertical override to Indy
ApplyHorizontalOverride
	lda		Ldf38,x					; Load horizontal position override (if any)
	beq		ReturnFromOverrideWithSEC					; If zero, skip horizontal positioning
	sta		indyXPos				  ; Apply horizontal override to Indy
ReturnFromOverrideWithSEC
	sec								; Set carry to indicate an override was applied
	rts								; Return to caller
	
CheckAdvancedOverrideConditions
	iny								; Bump Y from previous LDE34 value
	beq		Ld9f9					; If it was $FF, return early
	iny								;2		   *
	bne		Ld9b6					; If not $FE, jump to advanced evaluation
	; Case where Y = $FE
	ldy		Lde68,x					; Load lower horizontal boundary
	cpy		BSJMPAddr				   ; Compare with current horizontal state
	bcc		Ld9af					; If below lower limit, use another check
	ldy		Lde9c,x					; Load upper horizontal boundary
	bmi		Ld9c7					; If negative, apply default vertical
	bpl		CheckVerticalOverride					; Always taken	 go check vertical override normally
Ld9af
	ldy		Lded0,x					; Load alternate override flag
	bmi		Ld9c7					; If negative, jump to handle special override
	bpl		CheckVerticalOverride					; Always taken
Ld9b6
	lda		BSJMPAddr				   ; Load current horizontal position
	cmp		Lde68,x					; Compare with lower limit
	bcc		Ld9f9					;2/3	   *
	cmp		Lde9c,x					; Compare with upper limit
	bcs		Ld9f9					;2/3	   *
	ldy		Lded0,x					; Load override control byte
	bpl		CheckVerticalOverride					; If positive, allow override
Ld9c7
	iny								;2		   *
	bmi		Ld9d4					; If negative, special flag check
	ldy		#$08					; Use a fixed override value
	bit		ram_AF					; Check room flag register
	bpl		CheckVerticalOverride					; If bit 7 is clear, proceed
	lda		#$41					;2		   *
	bne		ApplyVerticalOverride					; Always taken	 apply forced vertical position
Ld9d4
	iny								; 2
	bne		Ld9e1					; Always taken unless overflowed
	lda		ram_B5					; 3
	and		#$0f					; Mask to lower nibble
	bne		Ld9f9					; If any bits set, don't override
	ldy		#$06					; 2
	bne		CheckVerticalOverride					; Always taken
Ld9e1
	iny								; 2
	bne		Ld9f0					; Continue check chain
	lda		ram_B5					; 3
	and		#$0f					; 2
	cmp		#$0a					; 2
	bcs		Ld9f9					; 2
	ldy		#$06					; 2
	bne		CheckVerticalOverride					; Always taken
Ld9f0
	iny								; 2
	bne		Ld9fe					; Continue to final check
	ldy		#$01					; 2
	bit		playerInput					 ;3			*
	bmi		CheckVerticalOverride					; If fire button pressed, allow override
Ld9f9
	clc								; Clear carry to signal no override
	bit		Ld9fd					; Dummy BIT used for timing/padding
	
Ld9fd
	.byte	$60								; $d9fd (D)
	
Ld9fe
	iny								; Increment Y (used as a conditional trigger)
	bne		Ld9f9					; If Y was not zero before, exit ear
	ldy		#$06					; Load override index value into Y (used if conditions match)
	lda		#$0e					; Load ID for the Head of Ra item
	cmp		selectedInventoryId					  ; compare with current selected inventory id
	bne		Ld9f9					; branch if not holding Head of Ra
	bit		INPT5|$30				; read action button from right controller
	bmi		Ld9f9					; branch if action button not pressed
	jmp		CheckVerticalOverride					; All conditions met: apply vertical override
	
TakeItemFromInventory
	ldy		numberOfInventoryItems					 ; get number of inventory items
	bne		.takeItemFromInventory					 ; branch if Indy carrying items
	clc								; Otherwise, clear carry (indicates no item removed)
	rts								; Return (nothing to do)
	
.takeItemFromInventory
	bcs		.takeSelectedItemFromInventory					 ;2/3		*
	tay								; move item id to be removed to y
	asl								; multiply value by 8 to get graphic LSB
	asl								;2		   *
	asl								;2		   *
	ldx		#$0a					; Start from the last inventory slot (there are 6 slots, each 2 bytes)
.takeItemFromInventoryLoop
	cmp		inventoryGraphicPointers,x				  ; Compare target LSB value to current inventory slot
	bne		.checkNextItem					 ; If not a match, try the next slot
	cpx		selectedInventoryIndex					 ;3			*
	beq		.checkNextItem					 ;2/3		*
	dec		numberOfInventoryItems					 ; reduce number of inventory items
	lda		#$00					;2		   *
	sta		inventoryGraphicPointers,x				  ; place empty sprite in inventory
	cpy		#$05					; If item index is less than 5, skip clearing pickup flag
	bcc		FinalizeInventoryRemoval				   ; 2
	; Remove pickup status bit if this is a non-basket item
	tya								; Move item ID to A
	tax								; move item id to x
	jsr		ShowItemAsNotTaken					 ; Update pickup/basket flags to show it's no longer taken
	txa								; X -> A
	tay								; And back to Y for further use
FinalizeInventoryRemoval
	jmp		FinalizeInventorySelection					 ; 3
	
.checkNextItem
	dex								; Move to previous inventory slot
	dex								; Each slot is 2 bytes (pointer to sprite)
	bpl		.takeItemFromInventoryLoop					 ; If still within bounds, continue checking
	clc								; Clear carry	no matching item was found/removed
	rts								; Return (nothing removed)
	
.takeSelectedItemFromInventory
	lda		#$00					;2		   *
	ldx		selectedInventoryIndex					 ;3			*
	sta		inventoryGraphicPointers,x				  ; remove selected item from inventory
	ldx		selectedInventoryId					  ; get current selected inventory id
	cpx		#$07					;2		   *
	bcc		JumpToItemRemovalHandler				   ; 2
	jsr		ShowItemAsNotTaken					 ;6	  =	 22 *
JumpToItemRemovalHandler
	txa								; move inventory id to accumulator
	tay								; move inventory id to y
	asl								; multiple inventory id by 2
	tax								;2		   *
	lda		Ldc76,x					;4		   *
	pha								; push MSB to stack
	lda		Ldc75,x					;4		   *
	pha								; push LSB to stack
	ldx		currentScreenId					   ; get the current screen id
	rts								; jump to Remove Item strategy
	
	.byte	$a9,$3f,$25,$b4,$85,$b4,$4c,$d8 ; $da5e (*)
	.byte	$da,$86,$8d,$a9,$70,$85,$d1,$d0 ; $da66 (*)
	.byte	$f5,$a9,$42,$c5,$91,$d0,$11,$a9 ; $da6e (*)
	.byte	$03,$85,$81,$20,$78,$d8,$a9,$15 ; $da76 (*)
	.byte	$85,$c9,$a9,$1c,$85,$cf,$d0,$52 ; $da7e (*)
	.byte	$e0,$05,$d0,$4e,$a9,$05,$c5,$8b ; $da86 (*)
	.byte	$d0,$48,$85,$aa,$a9,$00,$85,$ce ; $da8e (*)
	.byte	$a9,$02,$05,$b4,$85,$b4,$d0,$3a ; $da96 (*)
	.byte	$66,$b1,$18,$26,$b1,$e0,$02,$d0 ; $da9e (*)
	.byte	$04,$a9,$4e,$85,$df,$d0,$2b,$66 ; $daa6 (*)
	.byte	$b2,$18,$26,$b2,$e0,$03,$d0,$08 ; $daae (*)
	.byte	$a9,$4f,$85,$df,$a9,$4b,$85,$d0 ; $dab6 (*)
	.byte	$d0,$18,$a6,$81,$e0,$03,$d0,$0b ; $dabe (*)
	.byte	$a5,$c9,$c9,$3c,$b0,$05,$26,$b2 ; $dac6 (*)
	.byte	$38,$66,$b2,$a5,$91,$18,$69,$40 ; $dace (*)
	.byte	$85,$91,$c6,$c4,$d0,$06,$a9,$00 ; $dad6 (*)
	.byte	$85,$c5,$f0,$15,$a6,$c3,$e8,$e8 ; $dade (*)
	.byte	$e0,$0b,$90,$02,$a2,$00,$b5,$b7 ; $dae6 (*)
	.byte	$f0,$f4,$86,$c3,$4a,$4a,$4a,$85 ; $daee (*)
	.byte	$c5								; $daf6 (*)
	
FinalizeInventorySelection
	lda		#$0d					; Mask to clear bit 6 (parachute active flag)
	sta		ram_A2					; 3
	sec								; Set carry to indicate success
	rts								; 6
	
	.byte	$00,$00,$00						; $dafd (*)
Ldb00
	.byte	$00								; $db00 (D)
	.byte	$00,$35,$10,$17,$30,$00,$00,$00 ; $db01 (*)
	.byte	$00,$00,$00,$00					; $db09 (*)
	.byte	$05								; $db0d (D)
	.byte	$00,$00,$f0,$e0,$d0,$c0,$b0,$a0 ; $db0e (*)
	.byte	$90,$71,$61,$51,$41,$31,$21,$11 ; $db16 (*)
	.byte	$01,$f1,$e1,$d1,$c1,$b1,$a1,$91 ; $db1e (*)
	.byte	$72,$62,$52,$42,$32,$22,$12,$02 ; $db26 (*)
	.byte	$f2,$e2,$d2,$c2,$b2,$a2,$92,$73 ; $db2e (*)
	.byte	$63,$53,$43,$33,$23,$13,$03,$f3 ; $db36 (*)
	.byte	$e3,$d3,$c3,$b3,$a3,$93,$74,$64 ; $db3e (*)
	.byte	$54,$44							; $db46 (*)
	.byte	$34								; $db48 (D)
	.byte	$24,$14,$04,$f4					; $db49 (*)
	.byte	$e4								; $db4d (D)
	.byte	$d4,$c4,$b4,$a4,$94,$75,$65,$55 ; $db4e (*)
	.byte	$45,$35,$25,$15,$05,$f5,$e5,$d5 ; $db56 (*)
	.byte	$c5,$b5,$a5,$95,$76,$66,$56,$46 ; $db5e (*)
	.byte	$36,$26,$16,$06,$f6,$e6,$d6,$c6 ; $db66 (*)
	.byte	$b6,$a6,$96,$77,$67,$57,$47,$37 ; $db6e (*)
	.byte	$27,$17,$07,$f7,$e7,$d7,$c7,$b7 ; $db76 (*)
	.byte	$a7,$97,$78,$68,$58,$48,$38,$28 ; $db7e (*)
	.byte	$18,$08,$f8,$e8,$d8,$c8,$b8,$a8 ; $db86 (*)
	.byte	$98,$79,$69,$59					; $db8e (*)
Ldb92
	.byte	$11,$11,$11,$11,$31,$11,$25,$05 ; $db92 (*)
	.byte	$05,$01,$01,$05,$05				; $db9a (*)
	.byte	$01								; $db9f (D)
Ldba0
	.byte	$00,$24,$96,$22,$72,$fc,$00,$00 ; $dba0 (*)
	.byte	$00,$72,$12,$00,$f8				; $dba8 (*)
	
	.byte	$00|$0						  ; $dbad (CB)
	
Ldbae
	.byte	$08,$22,$08,$00,$1a,$28,$c8,$e8 ; $dbae (*)
	.byte	$8a,$1a,$c6,$00,$28				; $dbb6 (*)
	
	.byte	$70|$8						 ; $dbbb (CP)
	
Ldbbc
	.byte	$cc,$ea,$5a,$26,$9e,$a6,$7c		; $dbbc (*)
Ldbc3
	.byte	$88,$28,$f8,$4a,$26,$a8			; $dbc3 (*)
	
Ldbc9
	.byte	$c0|$c						  ; $dbc9 (C)
	
	.byte	$ce,$4a,$98,$00,$00,$00			; $dbca (*)
	
	.byte	$00|$8						  ; $dbd0 (C)
	
	.byte	$07,$01,$10						; $dbd1 (*)
Ldbd4
	.byte	$78,$4c,$5d,$4c,$4f,$4c,$12,$4c ; $dbd4 (*)
	.byte	$4c,$4c,$4c,$12,$12				; $dbdc (*)
Ldbe1
	.byte	$ff,$ff,$ff,$f9,$f9,$f9,$fa,$00 ; $dbe1 (*)
	.byte	$fd,$fb,$fc,$fc,$fc				; $dbe9 (*)
Ldbee
	.byte	$00,$51,$a1,$00,$51,$a2,$c1,$e5 ; $dbee (*)
	.byte	$e0,$00,$00,$00,$00				; $dbf6 (*)
Ldbfb
	.byte	$72,$7a,$8a,$82					; $dbfb (*)
Ldbff
	.byte	$fe,$fa,$02,$06					; $dbff (*)
Ldc03
	.byte	$00,$00,$18,$04,$03,$03,$85,$85 ; $dc03 (*)
	.byte	$3b,$85,$85						; $dc0b (*)
Ldc0e
	.byte	$20,$78,$85,$4d,$62,$17,$50,$50 ; $dc0e (*)
	.byte	$50,$50,$50,$12,$12				; $dc16 (*)
Ldc1b
	.byte	$ff,$ff,$14,$4b,$4a,$44,$ff,$27 ; $dc1b (*)
	.byte	$ff,$ff,$ff,$f0,$f0				; $dc23 (*)
Ldc28
	.byte	$06,$06,$06,$06,$06,$06,$48,$68 ; $dc28 (*)
	.byte	$89,$00,$00						; $dc30 (*)
Ldc33
	.byte	$00,$00,$00,$00,$00,$00,$fd,$fd ; $dc33 (*)
	.byte	$fd,$fe,$fe						; $dc3b (*)
Ldc3e
	.byte	$20,$20,$20,$20,$20,$20,$20,$b7 ; $dc3e (*)
	.byte	$9b,$78,$78						; $dc46 (*)
Ldc49
	.byte	$00,$00,$00,$00,$00,$00,$fd,$fd ; $dc49 (*)
	.byte	$fd,$fe,$fe						; $dc51 (*)
Ldc54
	.byte	$01,$02,$04,$08,$10,$20,$40,$80 ; $dc54 (*)
Ldc5c
	.byte	$fe,$fd,$fb,$f7,$ef,$df,$bf,$7f ; $dc5c (*)
Ldc64
	.byte	$00,$00,$00,$00,$08,$00,$02,$0a ; $dc64 (*)
	.byte	$0c,$0e,$01,$03,$04,$06,$05,$07 ; $dc6c (*)
	.byte	$0d								; $dc74 (*)
Ldc75
	.byte	$0f								; $dc75 (*)
Ldc76
	.byte	$0b,$d7,$da,$d7,$da,$5d,$da,$bf ; $dc76 (*)
	.byte	$da,$d7,$da,$d7,$da,$d7,$da,$d7 ; $dc7e (*)
	.byte	$da,$d7,$da,$9d,$da,$ac,$da,$d7 ; $dc86 (*)
	.byte	$da,$d7,$da,$d7,$da,$d7,$da,$66 ; $dc8e (*)
	.byte	$da,$6e,$da,$66,$da,$b3,$d2,$ea ; $dc96 (*)
	.byte	$d1,$91,$d2,$49,$d2,$b3,$d2,$c3 ; $dc9e (*)
	.byte	$d1,$8d,$d2,$b8,$d1,$34,$d3,$b3 ; $dca6 (*)
	.byte	$d2,$91,$d1,$8d,$d1,$61,$d1,$73 ; $dcae (*)
	.byte	$d3,$73,$d3,$20,$d3,$73,$d3,$73 ; $dcb6 (*)
	.byte	$d3,$56,$d3,$01,$d3,$56,$d3,$34 ; $dcbe (*)
	.byte	$d3,$73,$d3,$69,$d3,$73,$d3,$73 ; $dcc6 (*)
	.byte	$d3,$73,$d3,$73,$d3,$6e,$d3,$73 ; $dcce (*)
	.byte	$d3,$f1,$d2,$73,$d3,$73,$d3,$73 ; $dcd6 (*)
	.byte	$d3,$73,$d3,$cd,$d2,$6e,$d3,$73 ; $dcde (*)
	.byte	$d3,$73,$d3						; $dce6 (*)
	
PlaceItemInInventory
	ldx		numberOfInventoryItems					 ; get number of inventory items
	cpx		#$06					; see if Indy carrying maximum number of items
	bcc		.spaceAvailableForItem					 ; branch if Indy has room to carry more items
	clc								;2		   *
	rts								;6	 =	15 *
	
.spaceAvailableForItem
	ldx		#$0a					;2	 =	 2 *
.searchForEmptySpaceLoop
	ldy		inventoryGraphicPointers,x				  ; get the LSB for the inventory graphic
	beq		.addInventoryItem					; branch if nothing is in the inventory slot
	dex								;2		   *
	dex								;2		   *
	bpl		.searchForEmptySpaceLoop				   ;2/3		  *
	brk								; break if no more items can be carried
	
.addInventoryItem
	tay								; move item number to y
	asl								; mutliply item number by 8 for graphic LSB
	asl								;2		   *
	asl								;2		   *
	sta		inventoryGraphicPointers,x				  ; place graphic LSB in inventory
	lda		numberOfInventoryItems					 ; get number of inventory items
	bne		Ldd0a					; branch if Indy carrying items
	stx		selectedInventoryIndex					 ; set index to newly picked up item
	sty		selectedInventoryId					  ; set the current selected inventory id
Ldd0a
	inc		numberOfInventoryItems					 ; increment number of inventory items
	cpy		#$04					;2		   *
	bcc		Ldd15					; 2
	tya								; move item number to accumulator
	tax								; move item number to x
	jsr		ShowItemAsTaken					  ;6   =  19 *
Ldd15
	lda		#$0c					;2		   *
	sta		ram_A2					;3		   *
	sec								;2		   *
	rts								;6	 =	13 *
	
ShowItemAsNotTaken
	lda		Ldc64,x					; get the item index value
	lsr								; shift D0 to carry
	tay								;2		   *
	lda		Ldc5c,y					;4		   *
	bcs		.showPickUpItemAsNotTaken					; branch if item not a basket item
	and		basketItemsStatus					;3		   *
	sta		basketItemsStatus					; clear status bit showing item not taken
	rts								;6	 =	26 *
	
.showPickUpItemAsNotTaken
	and		pickupItemsStatus					;3		   *
	sta		pickupItemsStatus					; clear status bit showing item not taken
	rts								;6	 =	12 *
	
ShowItemAsTaken
	lda		Ldc64,x					; get the item index value
	lsr								; shift D0 to carry
	tax								;2		   *
	lda		Ldc54,x					; get item bit value
	bcs		Ldd3e					; branch if item not a basket item
	ora		basketItemsStatus					;3		   *
	sta		basketItemsStatus					; show item taken
	rts								;6	 =	26 *
	
Ldd3e
	ora		pickupItemsStatus					;3		   *
	sta		pickupItemsStatus					; show item taken
	rts								;6	 =	12 *
	
	.byte	$bd,$64,$dc,$4a,$a8,$b9,$54,$dc ; $dd43 (*)
	.byte	$b0,$06,$25,$c6,$f0,$01,$38,$60 ; $dd4b (*)
	.byte	$25,$c7,$d0,$fb,$18,$60			; $dd53 (*)
	
AddTableValueToRam98
	and		#$1f					; 2
	tax								; 2
	lda		ram_98					; 3
	cpx		#$0c					; 2
	bcs		Ldd67					; 2
	adc		Ldfe5,x					; 4
	sta		ram_98					; 3
Ldd67
	rts								; 6
	
game_start
;
; Set up everything so the power up state is known.
;
	sei								; disable interrupts
	cld								; clear decimal mode
	ldx		#$ff					;		 
	txs								; set stack to the beginning
	inx								; x = 0
	txa								;Clear A 
clear_zp
	sta		zero_page,x					 
	dex									   
	bne		clear_zp					  

	dex								; x = -1
	stx		adventurePoints					  ;3		
	lda		#$fb					;2		  
	sta		inv_slot1_hi				  ;3		
	sta		inv_slot2_hi				  ;3		
	sta		inv_slot3_hi				  ;3		
	sta		inv_slot4_hi				  ;3		
	sta		pwatch_Addr					 ;3		   
	sta		inv_slot6_hi				  ;3		
	lda		#$60					;2		  
	sta		inventoryGraphicPointers				  ;3		
	lda		#$48					;2		  
	sta		inv_slot2_lo				  ;3		
	lda		#$d8					;2		  
	sta		inv_slot4_lo				  ;3		
	lda		#$08					;2		  
	sta		inv_slot3_lo				  ;3		
	lda		#$e0					;2		  
	sta		pwatch_state				  ;3		
	lda		#$0d					;2		  
	sta		currentScreenId					   ;3		 
	lsr								;2		  
	sta		numberOfBullets				  ; Load 6 bullets		   
	jsr		InitializeScreenState					;6		  
	jmp		StartNewFrame					;3	 =	77
	
reset_vars
	lda		#$20					;2		   *
	sta		inventoryGraphicPointers				  ; place coins in Indy's inventory
	lsr								; divide value by 8 to get the inventory id
	lsr								;2		   *
	lsr								;2		   *
	sta		selectedInventoryId					  ; set the current selected inventory id
	inc		numberOfInventoryItems					 ; increment number of inventory items
	lda		#$00					;2		   *
	sta		inv_slot2_lo				  ; clear the remainder of Indy's inventory
	sta		inv_slot3_lo				  ;3		 *
	sta		inv_slot4_lo				  ;3		 *
	sta		pwatch_state				  ;3		 *
	lda		#$64					;2		   *
	sta		adventurePoints					  ;3		 *
	lda		#$58					;2		   *
	sta		indyGfxPointers					 ;3			*
	lda		#$fa					;2		   *
	sta		ram_DA					;3		   *
	lda		#$4c					; 2
	sta		indyXPos				  ; 3
	lda		#$0f					; 2
	sta		indyYPos				  ; 3
	lda		#$02					;2		   *
	sta		currentScreenId					   ;3		  *
	sta		livesLeft				   ;3		  *
	jsr		InitializeScreenState					;6		   *
	jmp		Ld80d					; 3
	
DetermineFinalScore
	lda		adventurePoints					  ; get current adventure points
	sec								;2		   *
	sbc		findingArkBonus					 ; reduce for finding the Ark of the Covenant
	sbc		usingParachuteBonus					  ; reduce for using the parachute
	sbc		skipToMesaFieldBonus				   ; reduce if player skipped the Mesa field
	sbc		yarFoundBonus					; reduce if player found Yar
	sbc		livesLeft				   ; reduce by remaining lives
	sbc		usingHeadOfRaInMapRoomBonus					 ; reduce if player used the Head of Ra
	sbc		landingInMesaBonus					; reduce if player landed in Mesa
	sbc		unknown_action					; 3
	clc								;2		   *
	adc		grenadeUsed					 ; add 2 if Entrance Room opening activated
	adc		escapedShiningLight					  ; add 13 if escaped from Shining Light prison
	adc		thiefShot				   ; add 4 if shot a thief
	sta		adventurePoints					  ;3		 *
	rts								;6	 =	49 *
	
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $ddf8 (*)
Lde00
	.byte	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$f8 ; $de00 (*)
	.byte	$ff,$ff,$ff,$ff,$ff,$4f,$4f,$4f ; $de08 (*)
	.byte	$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f ; $de10 (*)
	.byte	$44,$44,$0f,$0f,$1c,$0f,$0f,$18 ; $de18 (*)
	.byte	$0f,$0f,$0f,$0f,$0f,$12,$12,$89 ; $de20 (*)
	.byte	$89,$8c,$89,$89,$86,$89,$89,$89 ; $de28 (*)
	.byte	$89,$89,$86,$86					; $de30 (*)
Lde34
	.byte	$ff,$fd,$ff,$ff,$fd,$ff,$ff,$ff ; $de34 (*)
	.byte	$fd,$01,$fd,$04,$fd,$ff,$fd,$01 ; $de3c (*)
	.byte	$ff,$0b,$0a,$ff,$ff,$ff,$04,$ff ; $de44 (*)
	.byte	$fd,$ff,$fd,$ff,$ff,$ff,$ff,$ff ; $de4c (*)
	.byte	$fe,$fd,$fd,$ff,$ff,$ff,$ff,$ff ; $de54 (*)
	.byte	$fd,$fd,$fe,$ff,$ff,$fe,$fd,$fd ; $de5c (*)
	.byte	$ff,$ff,$ff,$ff					; $de64 (*)
Lde68
	.byte	$00,$1e,$00,$00,$11,$00,$00,$00 ; $de68 (*)
	.byte	$11,$00,$10,$00,$60,$00,$11,$00 ; $de70 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $de78 (*)
	.byte	$70,$00,$12,$00,$00,$00,$00,$00 ; $de80 (*)
	.byte	$30,$15,$24,$00,$00,$00,$00,$00 ; $de88 (*)
	.byte	$18,$03,$27,$00,$00,$30,$20,$12 ; $de90 (*)
	.byte	$00,$00,$00,$00					; $de98 (*)
Lde9c
	.byte	$00,$7a,$00,$00,$88,$00,$00,$00 ; $de9c (*)
	.byte	$88,$00,$80,$00,$65,$00,$88,$00 ; $dea4 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $deac (*)
	.byte	$72,$00,$16,$00,$00,$00,$00,$00 ; $deb4 (*)
	.byte	$02,$1f,$2f,$00,$00,$00,$00,$00 ; $debc (*)
	.byte	$1c,$40,$01,$00,$00,$07,$27,$16 ; $dec4 (*)
	.byte	$00,$00,$00,$00					; $decc (*)
Lded0
	.byte	$00,$02,$00,$00,$09,$00,$00,$00 ; $ded0 (*)
	.byte	$07,$00,$fc,$00,$05,$00,$09,$00 ; $ded8 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $dee0 (*)
	.byte	$03,$00,$ff,$00,$00,$00,$00,$00 ; $dee8 (*)
	.byte	$01,$06,$fe,$00,$00,$00,$00,$00 ; $def0 (*)
	.byte	$fb,$fd,$0b,$00,$00,$08,$08,$00 ; $def8 (*)
	.byte	$00,$00,$00,$00					; $df00 (*)
Ldf04
	.byte	$00,$4e,$00,$00,$4e,$00,$00,$00 ; $df04 (*)
	.byte	$4d,$4e,$4e,$4e,$04,$01,$03,$01 ; $df0c (*)
	.byte	$01,$01,$01,$01,$01,$01,$01,$01 ; $df14 (*)
	.byte	$40,$00,$23,$00,$00,$00,$00,$00 ; $df1c (*)
	.byte	$00,$00,$41,$00,$00,$00,$00,$00 ; $df24 (*)
	.byte	$45,$00,$42,$00,$00,$00,$42,$23 ; $df2c (*)
	.byte	$28,$00,$00,$00					; $df34 (*)
Ldf38
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $df38 (*)
	.byte	$00,$00,$00,$00,$4c,$00,$00,$00 ; $df40 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $df48 (*)
	.byte	$80,$00,$86,$00,$00,$00,$00,$00 ; $df50 (*)
	.byte	$80,$86,$80,$00,$00,$00,$00,$00 ; $df58 (*)
	.byte	$12,$12,$4c,$00,$00,$16,$80,$12 ; $df60 (*)
	.byte	$50,$00,$00,$00					; $df68 (*)
Ldf6c
	.byte	$01,$ff,$01,$ff					; $df6c (*)
Ldf70
	.byte	$35,$09							; $df70 (*)
Ldf72
	.byte	$00,$00,$42,$45,$0c,$20,$04,$11 ; $df72 (*)
	.byte	$10,$12							; $df7a (*)
Ldf7c
	.byte	$07,$03,$05,$06,$09,$0b,$0e,$00 ; $df7c (*)
	.byte	$01,$03,$05,$00,$09,$0c,$0e,$00 ; $df84 (*)
	.byte	$01,$04,$05,$00,$0a,$0c,$0f,$00 ; $df8c (*)
	.byte	$02,$04,$05,$08,$0a,$0d,$0f,$00 ; $df94 (*)
	
JumpToDisplayKernel
	lda		INTIM					;4		  
	bne		JumpToDisplayKernel					  ;2/3		
	sta		WSYNC					;3	 =	 9
;---------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	lda		#$44					;2		  
	sta		ram_88					;3		  
	lda		#$f8					;2		  
	sta		ram_89					;3	 =	10
Ldfad
	lda		#$ad					;2		  
	sta		BSLDALoop				   ;3		 
	lda		#$f9					;2		  
	sta		BankStrobeAddrTemp					;3		  
	lda		#$ff					;2		  
	sta		BSJMP				   ;3		 
	lda		#$4c					;2		  
	sta		BSJMPAddr				   ;3		 
	jmp.w	BSLDALoop				   ;3	=  23
	
move_enemy
	ror								;Move first bit into carry
	bcs		mov_emy_right			;If 1 check if enemy shoulld go right
	dec		objectYPos,x			   ; move object up one pixel
mov_emy_right
	ror								;Rotate next bit into carry
	bcs		mov_emy_down			  ;if 1 check if enemy should go up
	inc		objectYPos,x			   ; move object down one pixel
mov_emy_down
	ror								;Rotate next bit into carry
	bcs		mov_emy_up				;if 1 check if enemy should go up
	dec		objectXPos ,x				; move object left one pixel
mov_emy_up
	ror								;Rotate next bit into carry
	bcs		mov_eny_finish			;if 1, moves are finished
	inc		objectXPos ,x				; move object right one pixel
mov_eny_finish
	rts								;return
	
	.byte	$00,$00,$00,$00,$00,$0a,$09,$0b ; $dfd5 (*)
	.byte	$00,$06,$05,$07,$00,$0e,$0d,$0f ; $dfdd (*)
Ldfe5
	.byte	$00								; $dfe5 (D)
	.byte	$06,$03,$03,$03,$00,$00,$06,$00 ; $dfe6 (*)
	.byte	$00,$00,$06,$00,$00,$00,$00,$00 ; $dfee (*)
	.byte	$00,$00,$00						; $dff6 (*)
	.byte	$00								; $dff9 (D)
	.byte	$68,$dd,$68,$dd					; $dffa (*)
	.byte	$68								; $dffe (D)
	.byte	$dd								; $dfff (*)


;***********************************************************
;	   Bank 1 / 0..1
;***********************************************************

	SEG		CODE
	ORG		$1000
	RORG	$f000

	lda		Lfff8					;4	 =	 4
Lf003
	cmp		ram_E0					; 3
	bcs		Lf01a					; 2
	lsr								; 2
	clc								; 2
	adc		player0YPos					 ; 3
	tay								; 2
	sta		WSYNC					;3	 =	17 *
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3 = @03
	lda		(pf1GfxPointers ),y				 ; 5
	sta		PF1						; 3 = @11
	lda		(pf2GfxPointers ),y				 ; 5
	sta		PF2						; 3 = @19
	bcc		Lf033					; 2
Lf01a
	sbc		ram_D4					; 3
	lsr								; 2
	lsr								; 2
	sta		WSYNC					;3	 =	10 *
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3 = @03
	tax								; 2
	cpx		snakeYPos				   ; 3
	bcc		Lf02d					; 2
	ldx		ram_D8					; 3
	lda		#$00					; 2
	beq		Lf031					; 3
Lf02d
	lda		dungeonGfx,x				; 4
	ldx		ram_D8					; 3
Lf031
	sta		PF1,x					; 4
Lf033
	ldx		#$1e					; 2
	txs								; 2
	lda		scanline				  ; 3
	sec								; 2
	sbc		indyYPos				  ; 3
	cmp		indySpriteHeight				  ; 3
	bcs		Lf079					; 2
	tay								; 2
	lda		(indyGfxPointers),y				 ; 5
	tax								; 2
Lf043
	lda		scanline				  ; 3
	sec								; 2
	sbc		objectYPos					; 3
	cmp		player0SpriteHeight					 ; 3
	bcs		Lf07d					; 2
	tay								; 2
	lda		(player0GfxPointers),y				; 5
	tay								; 2
Lf050
	lda		scanline				  ; 3
	sta		WSYNC					;3	 =	 6 *
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	cmp		weaponYPos					; 3
	php								; 3 = @09	  enable / disable M1
	cmp		missileYPos					 ; 3
	php								; 3 = @15	  enable / disable M0
	stx		GRP1					; 3 = @18
	sty		GRP0					; 3 = @21
	sec								; 2
	sbc		ram_D2					; 3
	cmp		#$08					; 2
	bcs		Lf06e					; 2
	tay								; 2
	lda		(timePieceGfxPointers ),y			   ; 5
	sta		ENABL					; 3 = @40
	sta		HMBL					; 3 = @43
Lf06e
	inc		scanline				  ; 5		  increment scanline
	lda		scanline				  ; 3
	cmp		#$50					; 2
	bcc		Lf003					; 2
	jmp		Lf1ea					; 3
	
Lf079
	ldx		#$00					; 2
	beq		Lf043					; 2
Lf07d
	ldy		#$00					; 2
	beq		Lf050					; 2
Lf081
	cpx		#$4f					; 2
	bcc		Lf088					; 2
	jmp		Lf1ea					; 3
	
Lf088
	lda		#$00					; 2
	beq		Lf0a4					; 3	  unconditional branch
Lf08c
	lda		(player0GfxPointers),y				; 5
	bmi		Lf09c					; 2
	cpy		player0YPos					 ; 3
	bcs		Lf081					; 2
	cpy		objectYPos					; 3
	bcc		Lf088					; 2
	sta		GRP0					; 3
	bcs		Lf0a4					; 3	  unconditional branch
Lf09c
	asl								; 2		  shift value left
	tay								; 2		  move value to y
	and		#$02					; 2		  value 0 || 2
	tax								; 2		  set for correct pointer index
	tya								; 2		  move value to accumulator
	sta		(pf1GfxPointers ,x)				 ; 6		  set player 0 color or fine motion
Lf0a4
	inc		scanline				  ; 5		  increment scan line
	ldx		scanline				  ; 3		  get current scan line
	lda		#$02					; 2
	cpx		missileYPos					 ; 3
	bcc		Lf0b2					; 2		 branch if not time to draw missile
	cpx		ram_E0					; 3
	bcc		Lf0b3					; 2
Lf0b2
	ror								; 2		  shift ENABLE_BM right
Lf0b3
	sta		ENAM0					; 3
	sta		WSYNC					;3	 =	 6 *
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	txa								; 2		  move scan line count to accumulator
	sec								; 2
	sbc		snakeYPos				   ; 3		  subtract Snake vertical position
	cmp		#$10					; 2
	bcs		Lf0ff					; 2
	tay								; 2
	cmp		#$08					; 2
	bcc		Lf0fb					; 2
	lda		ram_D8					; 3
	sta		timePieceGfxPointers				   ; 3
Lf0ca
	lda		(timePieceGfxPointers ),y			   ; 5
	sta		HMBL					; 3 = @34
Lf0ce
	ldy		#$00					; 2
	txa								; 2		  move scanline count to accumulator
	cmp		weaponYPos					; 3
	bne		Lf0d6					; 2
	dey								; 2		  y = -1
Lf0d6
	sty		ENAM1					; 3 = @48
	sec								; 2
	sbc		indyYPos				  ; 3
	cmp		indySpriteHeight				  ; 3
	bcs		Lf107					; 2+1
	tay								; 2
	lda		(indyGfxPointers),y				 ; 5
Lf0e2
	ldy		scanline				  ; 3
	sta		GRP1					; 3 = @71
	sta		WSYNC					;3	 =	 9 *
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	lda		#$02					; 2
	cpx		ram_D2					; 3
	bcc		Lf0f9					; 2
	cpx		player0SpriteHeight					 ; 3
	bcc		Lf0f5					; 2
Lf0f4
	ror								; 2
Lf0f5
	sta		ENABL					; 3 = @20
	bcc		Lf08c					; 3		  unconditional branch
Lf0f9
	bcc		Lf0f4					; 3		  unconditional branch
Lf0fb
	nop								;2		   *
	jmp		Lf0ca					; 3
	
Lf0ff
	pha								; 3
	pla								; 4
	pha								; 3
	pla								; 4
	nop								;2		   *
	jmp		Lf0ce					; 3
	
Lf107
	lda		#$00					; 2
	beq		Lf0e2					; 3+1		  unconditional branch
Lf10b
	inx								; 2		  increment scanline
	sta		HMCLR					; 3		  clear horizontal movement registers
	cpx		#$a0					; 2
	bcc		Lf140					; 2
	jmp		Lf1ea					; 3
	
Lf115
	sta		WSYNC					;3	 =	 3 *
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	inx								; 2		  increment scanline
	lda		BSLDALoop				   ; 3
	sta		GRP0					; 3 = @11
	lda		BankStrobeAddrTemp					; 3
	sta		COLUP0					; 3 = @17
	txa								; 2		  move canline to accumulator
	ldx		#$1f					; 2
	txs								; 2
	tax								; 2		  move scanline to x
	lsr								; 2		  divide scanline by 2
	cmp		ram_D2					; 3
	php								; 3 = @33	  enable / disable BALL
	cmp		weaponYPos					; 3
	php								; 3 = @39	  enable / disable M1
	cmp		missileYPos					 ; 3
	php								; 3 = @45	  enable / disable M0
	sec								; 2
	sbc		indyYPos				  ; 3
	cmp		indySpriteHeight				  ; 3
	bcs		Lf10b					; 2
	tay								; 2		  move scanline value to y
	lda		(indyGfxPointers),y				 ; 5		  get Indy graphic data
	sta		HMCLR					; 3 = @65	  clear horizontal movement registers
	inx								; 2		  increment scanline
	sta		GRP1					; 3 = @70
Lf140
	sta		WSYNC					;3	 =	 3 *
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	bit		ram_D4					; 3
	bpl		Lf157					; 2
	ldy		ram_89					; 3
	lda		ram_88					; 3
	lsr		ram_D4					; 5
Lf14e
	dey								; 2
	bpl		Lf14e					; 2
	sta		RESP0					; 3
	sta		HMP0					; 3
	bmi		Lf115					; 3 unconditional branch
Lf157
	bvc		Lf177					; 2
	txa								; 2
	and		#$0f					; 2
	tay								; 2
	lda		(player0GfxPointers),y				; 5
	sta		GRP0					; 3 = @25
	lda		(timePieceGfxPointers ),y			   ; 5
	sta		COLUP0					; 3 = @33
	iny								; 2
	lda		(player0GfxPointers),y				; 5
	sta		BSLDALoop				   ; 3
	lda		(timePieceGfxPointers ),y			   ; 5
	sta		BankStrobeAddrTemp					; 3
	cpy		player0SpriteHeight					 ; 3
	bcc		Lf174					; 2
	lsr		ram_D4					; 5
Lf174
	jmp		Lf115					; 3
	
Lf177
	lda		#$20					; 2
	bit		ram_D4					; 3
	beq		Lf1a7					; 2
	txa								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	bcs		Lf115					; 2
	tay								; 2
	sty		BSJMPAddr				   ; 3
	lda.wy	player0YPos,y				 ;4			*
	sta		REFP0					; 3
	sta		NUSIZ0					; 3
	sta		BSJMP				   ; 3
	bpl		Lf1a2					; 2
	lda		ram_96					; 3
	sta		player0GfxPointers					; 3
	lda		#$65					; 2
	sta		timePieceGfxPointers				   ;3		  *
	lda		#$00					; 2
	sta		ram_D4					; 3
	jmp		Lf115					; 3
	
Lf1a2
	lsr		ram_D4					; 5
	jmp		Lf115					; 3
	
Lf1a7
	lsr								; 2
	bit		ram_D4					; 3
	beq		Lf1ce					; 2
	ldy		BSJMPAddr				   ; 3
	lda		#$08					; 2
	and		BSJMP				   ; 3
	beq		Lf1b6					; 2
	lda		#$03					; 2
Lf1b6
	eor.wy	dungeonGfx,y				;4		   *
	and		#$03					; 4 frames of animation for the Thief
	tay								;2		   *
	lda		Lfc40,y					;4		   *
	sta		player0GfxPointers					; set Thief graphic LSB value
	lda		#$44					;2		   *
	sta		timePieceGfxPointers				   ;3		  *
	lda		#$0f					;2		   *
	sta		player0SpriteHeight					 ; 3
	lsr		ram_D4					; 5
	jmp		Lf115					; 3
	
Lf1ce
	txa								; 2
	and		#$1f					; 2
	cmp		#$0c					; 2
	beq		Lf1d8					; 2
	jmp		Lf115					; 3
	
Lf1d8
	ldy		BSJMPAddr				   ; 3
	lda.wy	thievesXPos ,y				  ;4		 *
	sta		ram_88					; 3
	and		#$0f					; 2
	sta		ram_89					; 3
	lda		#$80					; 2
	sta		ram_D4					; 3
	jmp		Lf115					; 3
	
Lf1ea
	sta		WSYNC					;3	 =	 3
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	ldx		#$ff					; 2
	stx		PF1						; 3 = @08
	stx		PF2						; 3 = @11
	inx								; 2		  x = 0
	stx		GRP0					; 3 = @16
	stx		GRP1					; 3 = @19
	stx		ENAM0					; 3 = @22
	stx		ENAM1					; 3 = @25
	stx		ENABL					; 3 = @28
	sta		WSYNC					;3	 =	31
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	lda		#$03					; 2
	ldy		#$00					; 2
	sty		REFP1					; 3 = @10
	sta		NUSIZ0					; 3 = @13
	sta		NUSIZ1					; 3 = @16
	sta		VDELP0					; 3 = @19
	sta		VDELP1					; 3 = @22
	sty		GRP0					; 3 = @25
	sty		GRP1					; 3 = @28
	sty		GRP0					; 3 = @31
	sty		GRP1					; 3 = @34
	nop								;2		  
	sta		RESP0					; 3 = @39
	sta		RESP1					; 3 = @42
	sty		HMP1					; 3 = @45
	lda		#$f0					; 2
	sta		HMP0					; 3 = @50
	sty		REFP0					; 3 = @53
	sta		WSYNC					;3	 =	56
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	lda		#$1a					; 2
	sta		COLUP0					; 3 = @08
	sta		COLUP1					; 3 = @11
	lda		selectedInventoryIndex					 ; 3		  get selected inventory index
	lsr								; 2		  divide value by 2
	tay								; 2
	lda		Lfff2,y					; 4
	sta		HMBL					; 3 = @25	  set fine motion for inventory indicator
	and		#$0f					; 2		  keep coarse value
	tay								; 2
	ldx		#$00					; 2
	stx		HMP0					; 3 = @34
	sta		WSYNC					;3	 =	37
;---------------------------------------
;--------------------------------------
	stx		PF0						; 3 = @03
	stx		COLUBK					; 3 = @06
	stx		PF1						; 3 = @09
	stx		PF2						; 3 = @12
Lf24a
	dey								; 2
	bpl		Lf24a					; 2
	sta		RESBL					; 3
	stx		CTRLPF					; 3
	sta		WSYNC					;3	 =	13
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	lda		#$3f					; 2
	and		frameCount					 ; 3
	bne		draw_menu					; 2
	lda		#$3f					; 2
	and		secondsTimer				   ; 3
	bne		draw_menu					; 2
	lda		ram_B5					; 3
	and		#$0f					; 2
	beq		draw_menu					; 2
	cmp		#$0f					; 2
	beq		draw_menu					; 2
	inc		ram_B5					; 5
draw_menu
	sta		WSYNC					;Draw Blank Line
;--------------------------------------
	lda		#$42					; 2
	sta		COLUBK					; 3 = @05
	sta		WSYNC					;Draw four more scanlines
;--------------------------------------
	sta		WSYNC					;
;--------------------------------------
	sta		WSYNC					;
;--------------------------------------
	sta		WSYNC					;
;--------------------------------------
	lda		#$07					; 2
	sta		BSLDALoop				   ; 3
draw_inventory
	ldy		BSLDALoop				   ; 3
	lda		(inventoryGraphicPointers),y			  ; 5
	sta		GRP0					; 3
	sta		WSYNC					;3	 =	14
;---------------------------------------
;--------------------------------------
	lda		(inv_slot2_lo),y			  ; 5
	sta		GRP1					; 3 = @08
	lda		(inv_slot3_lo),y			  ; 5
	sta		GRP0					; 3 = @16
	lda		(inv_slot4_lo),y			  ; 5
	sta		BankStrobeAddrTemp					; 3
	lda		(pwatch_state),y			  ; 5
	tax								; 2
	lda		(inv_slot6_lo),y			  ; 5
	tay								; 2
	lda		BankStrobeAddrTemp					; 3
	sta		GRP1					; 3 = @44
	stx		GRP0					; 3 = @47
	sty		GRP1					; 3 = @50
	sty		GRP0					; 3 = @53
	dec		BSLDALoop				   ; 5
	bpl		draw_inventory					 ; 2
	lda		#$00					; 2
	sta		WSYNC					;3	 =	65
;---------------------------------------
;--------------------------------------
	sta		GRP0					; 3 = @03
	sta		GRP1					; 3 = @06
	sta		GRP0					; 3 = @09
	sta		GRP1					; 3 = @12
	sta		NUSIZ0					; 3 = @15
	sta		NUSIZ1					; 3 = @18
	sta		VDELP0					; 3 = @21
	sta		VDELP1					; 3 = @23
	sta		WSYNC					;3	 =	27
;---------------------------------------
;--------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
;--------------------------------------
	ldy		#$02					; 2
	lda		numberOfInventoryItems					 ; 3		  get number of inventory items
	bne		Lf2c6					; 2		 branch if Indy carry items
	dey								; 2		  y = 1
Lf2c6
	sty		ENABL					; 3 = @12
	ldy		#$08					; 2
	sty		COLUPF					; 3 = @17
	sta		WSYNC					;3	 =	11
;---------------------------------------
;--------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
;--------------------------------------
	ldy		#$00					; 2
	sty		ENABL					; 3 = @05
	sta		WSYNC					;3	 =	 8
;---------------------------------------
;--------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
;--------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	ldx		#$0f					;2		  
	stx		VBLANK					; turn off TIA (D1 = 1)
	ldx		#$24					;2		  
	stx		TIM64T					; set timer for overscan period
	ldx		#$ff					;2		  
	txs								; point stack to the beginning
	ldx		#$01					; 2
Lf2e8
	lda		ram_A2,x				; 4
	sta		AUDC0,x					; 4
	sta		AUDV0,x					; 4
	bmi		Lf2fb					; 2
	ldy		#$00					; 2
	sty		ram_A2,x				; 4
Lf2f4
	sta		AUDF0,x					; 4
	dex								; 2
	bpl		Lf2e8					; 2
	bmi		Lf320					; unconditional branch
Lf2fb
	cmp		#$9c					; 2
	bne		Lf314					; 2
	lda		#$0f					; 2
	and		frameCount					 ; 3
	bne		Lf30d					; 2
	dec		diamond_h				   ; 5
	bpl		Lf30d					; 2
	lda		#$17					; 2
	sta		diamond_h				   ; 3
Lf30d
	ldy		diamond_h				   ; 3
	lda		Lfbe8,y					; 4
	bne		Lf2f4					; 2
Lf314
	lda		frameCount					 ; get current frame count
	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	tay								; 2
	lda		Lfaee,y					; 4
	bne		Lf2f4					; 2
Lf320
	lda		selectedInventoryId					  ; get current selected inventory id
	cmp		#$0f					;2		  
	beq		Lf330					; 2
	cmp		#$02					;2		  
	bne		Lf344					; 2
	lda		#$84					; 2
	sta		ram_A3					; 3
	bne		Lf348					; unconditional branch
Lf330
	bit		INPT5|$30				; read action button from right controller
	bpl		Lf338					; branch if action button pressed
	lda		#$78					;2		   *
	bne		Lf340					; unconditional branch
Lf338
	lda		secondsTimer				   ; 3
	and		#$e0					; 2
	lsr								; 2
	lsr								; 2
	adc		#$98					;2	 =	11 *
Lf340
	ldx		selectedInventoryIndex					 ;3			*
	sta		inventoryGraphicPointers,x				  ; 4
Lf344
	lda		#$00					; 2
	sta		ram_A3					; 3
Lf348
	bit		ram_93					; 3
	bpl		Lf371					; 2
	lda		frameCount					 ; get current frame count
	and		#$07					; 2
	cmp		#$05					; 2
	bcc		Lf365					; 2
	ldx		#$04					; 2
	ldy		#$01					; 2
	bit		majorEventFlag					  ; 3
	bmi		Lf360					; 2
	bit		ram_A1					; 3
	bpl		Lf362					; 2
Lf360
	ldy		#$03					; 2
Lf362
	jsr		MoveObjectTowardTarget	; 6
Lf365
	lda		frameCount					 ; get current frame count
	and		#$06					; 2
	asl								; 2
	asl								; 2
	sta		timePieceGfxPointers				   ; 3
	lda		#$fd					; 2
	sta		ram_D7					; 3
Lf371
	ldx		#$02					; 2
Lf373
	jsr		ProcessActiveObjectMovement ; 6
	inx								; 2
	cpx		#$05					; 2
	bcc		Lf373					; 2
	bit		majorEventFlag					  ; 3
	bpl		Lf3bf					; 2
	lda		frameCount					 ; get current frame count
	bvs		Lf39d					; 2
	and		#$0f					; 2
	bne		Lf3c5					; 2
	ldx		indySpriteHeight				  ; 3
	dex								; 2
	stx		ram_A3					; 3
	cpx		#$03					; 2
	bcc		Lf398					; 2
	lda		#$8f					; 2
	sta		weaponYPos					;3		   *
	stx		indySpriteHeight				  ; 3
	bcs		Lf3c5					; unconditional branch
Lf398
	sta		frameCount					 ; 3
	sec								; 2
	ror		majorEventFlag					  ; 5
Lf39d
	cmp		#$3c					; 2
	bcc		Lf3a9					; 2
	bne		Lf3a5					; 2
	sta		ram_A3					; 3
Lf3a5
	ldy		#$00					; 2
	sty		indySpriteHeight				  ;3   =   5 *
Lf3a9
	cmp		#$78					; 2
	bcc		Lf3c5					; 2
	lda		#$0b					;2		   *
	sta		indySpriteHeight				  ;3		 *
	sta		ram_A3					; 3
	sta		majorEventFlag					  ; 3
	dec		livesLeft				   ;5		  *
	bpl		Lf3c5					; 2
	lda		#$ff					; 2
	sta		majorEventFlag					  ; 3
	bne		Lf3c5					; unconditional branch
Lf3bf
	lda		currentScreenId					   ; get the current screen id
	cmp		#$0d					;2		  
	bne		Lf3d0					; branch if not in ID_ARK_ROOM
Lf3c5
	lda		#$d8					;2		  
	sta		ram_88					;3		  
	lda		#$d3					;2		  
	sta		ram_89					;3		  
	jmp		Lf493					;3	 =	13
	
Lf3d0
	bit		ram_8D					; 3
	bvs		Lf437					;2/3!	   *
	bit		ram_B4					; 3
	bmi		Lf437					;2/3!	   *
	bit		ram_9A					; 3
	bmi		Lf437					;2/3!	   *
	lda		#$07					;2		   *
	and		frameCount					 ;3			*
	bne		Lf437					; check to move inventory selector ~8 frames
	lda		numberOfInventoryItems					 ; get number of inventory items
	and		#$06					;2		   *
	beq		Lf437					; branch if Indy not carrying items
	ldx		selectedInventoryIndex					 ;3			*
	lda		inventoryGraphicPointers,x				  ; get inventory graphic LSB value
	cmp		#$98					;2		   *
	bcc		Lf3f2					; branch if the item is not a clock sprite
	lda		#$78					; reset inventory item to the time piece
Lf3f2
	bit		SWCHA					; check joystick values
	bmi		Lf407					; branch if left joystick not pushed right
	sta		inventoryGraphicPointers,x				  ; set inventory graphic LSB value
Lf3f9
	inx								;2		   *
	inx								;2		   *
	cpx		#$0b					;2		   *
	bcc		Lf401					;2/3!	   *
	ldx		#$00					;2	 =	10 *
Lf401
	ldy		inventoryGraphicPointers,x				  ; get inventory graphic LSB value
	beq		Lf3f9					; branch if no item present (i.e. Blank)
	bne		Lf415					; unconditional branch
Lf407
	bvs		Lf437					; branch if left joystick not pushed left
	sta		inventoryGraphicPointers,x				  ;4   =   6 *
Lf40b
	dex								;2		   *
	dex								;2		   *
	bpl		Lf411					;2/3	   *
	ldx		#$0a					;2	 =	 8 *
Lf411
	ldy		inventoryGraphicPointers,x				  ;4		 *
	beq		Lf40b					; branch if no item present (i.e. Blank)
Lf415
	stx		selectedInventoryIndex					 ;3			*
	tya								; move inventory graphic LSB to accumulator
	lsr								; divide value by 8 (i.e. H_INVENTORY_SPRITES)
	lsr								;2		   *
	lsr								;2		   *
	sta		selectedInventoryId					  ; set selected inventory id
	cpy		#$90					;2		   *
	bne		Lf437					; branch if the Hour Glass not selected
	ldy		#$09					;2		   *
	cpy		currentScreenId					   ;3		  *
	bne		Lf437					; branch if not in Mesa Field
	lda		#$49					; 2
	sta		ram_8D					; 3
	lda		indyYPos				  ; get Indy's vertical position
	adc		#$09					;2		   *
	sta		weaponYPos					;3		   *
	lda		indyXPos				  ;3		 *
	adc		#$09					;2		   *
	sta		weaponXPos					;3	 =	46 *
Lf437
	lda		ram_8D					; 3
	bpl		Lf454					; 2
	cmp		#$bf					; 2
	bcs		Lf44b					; 2
	adc		#$10					; 2
	sta		ram_8D					; 3
	ldx		#$03					; 2
	jsr		ApplyMovementBitsToObject ; 6
	jmp		Lf48b					; 3
	
Lf44b
	lda		#$70					; 2
	sta		weaponYPos					;3		   *
	lsr								; 2
	sta		ram_8D					; 3
	bne		Lf48b					; 2
Lf454
	bit		ram_8D					; 3
	bvc		Lf48b					; 2
	ldx		#$03					; 2
	jsr		ApplyMovementBitsToObject ; 6
	lda		weaponXPos					; get bullet or whip horizontal position
	sec								; 2
	sbc		#$04					; 2
	cmp		indyXPos				  ; 3
	bne		Lf46a					; 2
	lda		#$03					; 2
	bne		Lf481					; unconditional branch
Lf46a
	cmp		#$11					; 2
	beq		Lf472					; 2
	cmp		#$84					; 2
	bne		Lf476					; 2
Lf472
	lda		#$0f					; 2
	bne		Lf481					; unconditional branch
Lf476
	lda		weaponYPos					; get bullet or whip vertical position
	sec								; 2
	sbc		#$05					; 2
	cmp		indyYPos				  ; 3
	bne		Lf487					; 2
	lda		#$0c					; 2
Lf481
	eor		ram_8D					; 3
	sta		ram_8D					; 3
	bne		Lf48b					; 2
Lf487
	cmp		#$4a					; 2
	bcs		Lf472					; 2
Lf48b
	lda		#$24					;2		   *
	sta		ram_88					;3		   *
	lda		#$d0					;2		   *
	sta		ram_89					;3	 =	10 *
Lf493
	lda		#$ad					;2		  
	sta		BSLDALoop				   ;3		 
	lda		#$f8					;2		  
	sta		BankStrobeAddrTemp					;3		  
	lda		#$ff					;2		  
	sta		BSJMP				   ;3		 
	lda		#$4c					;2		  
	sta		BSJMPAddr				   ;3		 
	jmp.w	BSLDALoop				   ;3	=  23
	
Lf4a6
	sta		WSYNC					;3	 =	 3
;---------------------------------------
;--------------------------------------
	cpx		#$12					; 2
	bcc		Lf4d0					; 2
	txa								; 2		  move scanline to accumulator
	sbc		indyYPos				  ; 3
	bmi		Lf4c9					; 2
	cmp		#$14					; 2
	bcs		Lf4bd					; 2
	lsr								; 2
	tay								; 2
	lda		indy_sprite,y				  ; 4
	jmp		Lf4c3					; 3
	
Lf4bd
	and		#$03					; 2
	tay								; 2
	lda		Lf9fc,y					; 4
Lf4c3
	sta		GRP1					; 3 = @27
	lda		indyYPos				  ; 3		  get Indy's vertical position
	sta		COLUP1					; 3 = @33
Lf4c9
	inx								; 2		  increment scanline count
	cpx		#$90					; 2
	bcs		Lf4ea					; 2
	bcc		Lf4a6					; 3		  unconditional branch
Lf4d0
	bit		resetEnableFlag					  ; 3
	bmi		Lf4e5					; 2
	txa								; 2		  move scanline to accumulator
	sbc		#$07					; 2
	bmi		Lf4e5					; 2
	tay								; 2
	lda		Lfb40,y					; 4
	sta		GRP1					; 3
	txa								; 2		  move scanline to accumulator
	adc		frameCount					 ; 3		  increase value by current frame count
	asl								; 2		  multiply value by 2
	sta		COLUP1					; 3		  color Ark of the Covenant sprite
Lf4e5
	inx								; 2
	cpx		#$0f					; 2
	bcc		Lf4a6					; 2
Lf4ea
	sta		WSYNC					;3	 =	 3
;---------------------------------------
;--------------------------------------
	cpx		#$20					; 2
	bcs		Lf511					; 2+1
	bit		resetEnableFlag					  ; 3
	bmi		Lf504					; 2
	txa								; 2		  move scanline to accumulator
	ldy		#$7e					; 2
	and		#$0e					; 2
	bne		Lf4fd					; 2
	ldy		#$ff					; 2
Lf4fd
	sty		GRP0					; 3
	txa								; 2
	eor		#$ff					; 2
	sta		COLUP0					; 3
Lf504
	inx								; 2
	cpx		#$1d					; 2
	bcc		Lf4ea					; 2
	lda		#$00					; 2
	sta		GRP0					; 3
	sta		GRP1					; 3
	beq		Lf4a6					; 2+1		 unconditional branch
Lf511
	txa								; 2 = @08
	sbc		#$90					; 2
	cmp		#$0f					; 2
	bcc		Lf51b					; 2
	jmp		Lf1ea					; 3
	
Lf51b
	lsr								; 2		  divide by 4 to read graphic data
	lsr								; 2
	tay								; 2
	lda		Lfef0,y					; 4
	sta		GRP0					; 3 = @28
	stx		COLUP0					; 3 = @31
	inx								; 2
	bne		Lf4ea					; 3		  unconditional branch
	lda		currentScreenId					   ; get the current screen id
	asl								; multiply screen id by 2
	tax								;2		   *
	lda		Lfc89,x					;4		   *
	pha								;3		   *
	lda		Lfc88,x					;4		   *
	pha								;3		   *
	rts								;6	 =	47 *
	
	.byte	$a9,$7f,$85,$ce,$85,$d0,$85,$d2 ; $f535 (*)
	.byte	$d0,$5b,$a2,$00,$a0,$01,$24,$33 ; $f53d (*)
	.byte	$30,$14,$24,$b6,$30,$10,$a5,$82 ; $f545 (*)
	.byte	$29,$07,$d0,$0d,$a0,$05,$a9,$4c ; $f54d (*)
	.byte	$85,$cd,$a9,$23,$85,$d3,$20,$b3 ; $f555 (*)
	.byte	$f8,$a9,$80,$85,$93,$a5,$ce,$29 ; $f55d (*)
	.byte	$01,$66,$c8,$2a,$a8,$6a,$26,$c8 ; $f565 (*)
	.byte	$b9,$ea,$fa,$85,$dd,$a9,$fc,$85 ; $f56d (*)
	.byte	$de,$a5,$8e,$30,$20,$a2,$50,$86 ; $f575 (*)
	.byte	$ca,$a2,$26,$86,$d0,$a5,$b6,$30 ; $f57d (*)
	.byte	$14,$24,$9d,$30,$10,$29,$07,$d0 ; $f585 (*)
	.byte	$04,$a0,$06,$84,$b6,$aa,$bd,$d2 ; $f58d (*)
	.byte	$fc,$85,$8e,$c6,$b6,$4c,$33,$f8 ; $f595 (*)
	.byte	$a9,$80,$85,$93,$a2,$00,$24,$9d ; $f59d (*)
	.byte	$30,$04,$24,$95,$50,$0c,$a0,$05 ; $f5a5 (*)
	.byte	$a9,$55,$85,$cd,$85,$d3,$a9,$01 ; $f5ad (*)
	.byte	$d0,$04,$a0,$01,$a9,$03,$25,$82 ; $f5b5 (*)
	.byte	$d0,$0f,$20,$b3,$f8,$a5,$ce,$10 ; $f5bd (*)
	.byte	$08,$c9,$a0,$90,$04,$e6,$ce,$e6 ; $f5c5 (*)
	.byte	$ce,$50,$0e,$a5,$ce,$c9,$51,$90 ; $f5cd (*)
	.byte	$08,$a5,$95,$85,$99,$a9,$00,$85 ; $f5d5 (*)
	.byte	$95,$a5,$c8,$c5,$c9,$b0,$03,$ca ; $f5dd (*)
	.byte	$49,$03,$86,$0b,$29,$03,$0a,$0a ; $f5e5 (*)
	.byte	$0a,$0a,$85,$dd,$a5,$82,$29,$7f ; $f5ed (*)
	.byte	$d0,$20,$a5,$ce,$c9,$4a,$b0,$1a ; $f5f5 (*)
	.byte	$a4,$98,$f0,$16,$88,$84,$98,$a0 ; $f5fd (*)
	.byte	$8e,$69,$03,$85,$d0,$c5,$cf,$b0 ; $f605 (*)
	.byte	$01,$88,$a5,$c8,$69,$04,$85,$ca ; $f60d (*)
	.byte	$84,$8e,$a0,$7f,$a5,$8e,$30,$02 ; $f615 (*)
	.byte	$84,$d0,$a5,$d1,$c9,$52,$90,$02 ; $f61d (*)
	.byte	$84,$d1,$4c,$33,$f8,$a2,$3a,$86 ; $f625 (*)
	.byte	$e9,$a2,$85,$86,$e3,$a2,$03,$86 ; $f62d (*)
	.byte	$ad,$d0,$02,$a2,$04,$bd,$d8,$fc ; $f635 (*)
	.byte	$25,$82,$d0,$15,$b4,$e5,$a9,$08 ; $f63d (*)
	.byte	$35,$df,$d0,$13,$88,$c0,$14,$b0 ; $f645 (*)
	.byte	$06,$a9,$08,$55,$df,$95,$df,$94 ; $f64d (*)
	.byte	$e5,$ca,$10,$e1,$4c,$33,$f8,$c8 ; $f655 (*)
	.byte	$c0,$85,$b0,$ed,$90,$f1,$24,$b4 ; $f65d (*)
	.byte	$10,$1e,$50,$04,$c6,$c9,$d0,$18 ; $f665 (*)
	.byte	$a5,$82,$6a,$90,$13,$ad,$80,$02 ; $f66d (*)
	.byte	$85,$92,$6a,$6a,$6a,$b0,$04,$c6 ; $f675 (*)
	.byte	$c9,$d0,$05,$6a,$b0,$02,$e6,$c9 ; $f67d (*)
	.byte	$a9,$02,$25,$b4,$d0,$06,$85,$8d ; $f685 (*)
	.byte	$a9,$0b,$85,$ce,$a6,$cf,$a5,$82 ; $f68d (*)
	.byte	$24,$b4,$30,$0a,$e0,$15,$90,$06 ; $f695 (*)
	.byte	$e0,$30,$90,$09,$b0,$06,$6a,$90 ; $f69d (*)
	.byte	$04,$4c,$33,$f8,$e8,$e8,$86,$cf ; $f6a5 (*)
	.byte	$d0,$f7,$a5,$c9,$c9,$64,$90,$07 ; $f6ad (*)
	.byte	$26,$b2,$18,$66,$b2,$10,$22,$c9 ; $f6b5 (*)
	.byte	$2c,$f0,$06,$a9,$7f,$85,$d2,$d0 ; $f6bd (*)
	.byte	$18,$24,$b2,$30,$14,$a9,$30,$85 ; $f6c5 (*)
	.byte	$cc,$a0,$00,$84,$d2,$a0,$7f,$84 ; $f6cd (*)
	.byte	$dc,$84,$d5,$e6,$c9,$a9,$80,$85 ; $f6d5 (*)
	.byte	$9d,$4c,$33,$f8,$a4,$df,$88,$d0 ; $f6dd (*)
	.byte	$f8,$a5,$af,$29,$07,$d0,$31,$a9 ; $f6e5 (*)
	.byte	$40,$85,$93,$a5,$83,$4a,$4a,$4a ; $f6ed (*)
	.byte	$4a,$4a,$aa,$bc,$dc,$fc,$be,$aa ; $f6f5 (*)
	.byte	$fc,$84,$84,$20,$9d,$f8,$90,$05 ; $f6fd (*)
	.byte	$e6,$df,$d0,$d5,$00,$a4,$84,$98 ; $f705 (*)
	.byte	$05,$af,$85,$af,$b9,$a2,$fc,$85 ; $f70d (*)
	.byte	$ce,$b9,$a6,$fc,$85,$df,$d0,$c1 ; $f715 (*)
	.byte	$c9,$04,$b0,$e4,$26,$af,$38,$66 ; $f71d (*)
	.byte	$af,$30,$dd,$a0,$00,$84,$d2,$a0 ; $f725 (*)
	.byte	$7f,$84,$dc,$84,$d5,$a9,$71,$85 ; $f72d (*)
	.byte	$cc,$a0,$4f,$a9,$3a,$c5,$cf,$d0 ; $f735 (*)
	.byte	$0c,$a5,$c5,$c9,$07,$f0,$08,$a9 ; $f73d (*)
	.byte	$5e,$c5,$c9,$f0,$02,$a0,$0d,$84 ; $f745 (*)
	.byte	$df,$a5,$83,$38,$e9,$10,$10,$05 ; $f74d (*)
	.byte	$49,$ff,$38,$69,$00,$c9,$0b,$90 ; $f755 (*)
	.byte	$02,$a9,$0b,$85,$ce,$24,$b3,$10 ; $f75d (*)
	.byte	$25,$c9,$08,$b0,$1d,$a6,$c5,$e0 ; $f765 (*)
	.byte	$0e,$d0,$17,$86,$ab,$a9,$04,$25 ; $f76d (*)
	.byte	$82,$d0,$0f,$a5,$8c,$29,$0f,$aa ; $f775 (*)
	.byte	$bd,$c2,$fa,$85,$cb,$bd,$d2,$fa ; $f77d (*)
	.byte	$d0,$02,$a9,$70,$85,$d1,$26,$b3 ; $f785 (*)
	.byte	$a9,$3a,$c5,$cf,$d0,$0f,$c0,$4f ; $f78d (*)
	.byte	$f0,$06,$a9,$5e,$c5,$c9,$d0,$05 ; $f795 (*)
	.byte	$38,$66,$b3,$30,$03,$18,$66,$b3 ; $f79d (*)
	.byte	$4c,$33,$f8,$a9,$08,$25,$c7,$d0 ; $f7a5 (*)
	.byte	$12,$a9,$4c,$85,$cc,$a9,$2a,$85 ; $f7ad (*)
	.byte	$d2,$a9,$ba,$85,$d6,$a9,$fa,$85 ; $f7b5 (*)
	.byte	$d7,$d0,$04,$a9,$f0,$85,$d2,$a5 ; $f7bd (*)
	.byte	$b5,$29,$0f,$f0,$69,$85,$dc,$a0 ; $f7c5 (*)
	.byte	$14,$84,$ce,$a0,$3b,$84,$e0,$c8 ; $f7cd (*)
	.byte	$84,$d4,$a9,$c1,$38,$e5,$dc,$85 ; $f7d5 (*)
	.byte	$dd,$d0,$53,$a5,$82,$29,$18,$69 ; $f7dd (*)
	.byte	$e0,$85,$dd,$a5,$82,$29,$07,$d0 ; $f7e5 (*)
	.byte	$21,$a2,$00,$a0,$01,$a5,$cf,$c9 ; $f7ed (*)
	.byte	$3a,$90,$14,$a5,$c9,$c9,$2b,$90 ; $f7f5 (*)
	.byte	$04,$c9,$6d,$90,$0a,$a0,$05,$a9 ; $f7fd (*)
	.byte	$4c,$85,$cd,$a9,$0b,$85,$d3,$20 ; $f805 (*)
	.byte	$b3,$f8,$a2,$4e,$e4,$cf,$d0,$1e ; $f80d (*)
	.byte	$a6,$c9,$e0,$76,$f0,$04,$e0,$14 ; $f815 (*)
	.byte	$d0,$14,$ad,$80,$02,$29,$0f,$c9 ; $f81d (*)
	.byte	$0d,$d0,$0b,$85,$a6,$a9,$4c,$85 ; $f825 (*)
	.byte	$c9,$66,$b5,$38,$26,$b5,$a9,$0d ; $f82d (*)
	.byte	$85,$88,$a9,$d8,$85,$89,$4c,$93 ; $f835 (*)
	.byte	$f4,$a9,$40,$85,$93,$d0,$ef		; $f83d (*)
	
draw_field
	sta		WSYNC					;3	 =	 3
;---------------------------------------
;--------------------------------------
	sta		HMCLR					; 3 = @03	  clear horizontal motion
	sta		CXCLR					; 3 = @06	  clear all collisions
	ldy		#$ff					; 2
	sty		PF1						; 3 = @11
	sty		PF2						; 3 = @14
	ldx		currentScreenId					   ; 3		  get the current screen id
	lda		Lfaac,x					; 4
	sta		PF0						; 3 = @24
	iny								; 2		  y = 0
	sta		WSYNC					;3	 =	29
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	sty		VBLANK					; 3 = @06	  enable TIA (D1 = 0)
	sty		scanline				  ; 3
	cpx		#$04					; 2
	bne		Lf865					; 2		 branch if not in Map Room
	dey								; 2		  y = -1
Lf865
	sty		ENABL					; 3 = @18
	cpx		#$0d					; 2
	beq		Lf874					; 2		 branch if in Ark Room
	bit		majorEventFlag					  ; 3
	bmi		Lf874					; 2
	ldy		SWCHA					; 4		  read joystick values
	sty		REFP1					; 3 = @34
Lf874
	sta		WSYNC					;3	 =	 3
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	sta		WSYNC					;3	 =	 6
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	ldy		currentScreenId					   ; 3		  get the current screen id
	sta		WSYNC					;3	 =	 9
;---------------------------------------
;--------------------------------------
	sta		HMOVE					; 3
	lda		Lfa91,y					; 4
	sta		PF1						; 3 = @10
	lda		Lfa9e,y					; 4
	sta		PF2						; 3 = @17
	ldx		Lf9ee,y					; 4
	lda		Lfae3,x					; 4
	pha								; 3
	lda		Lfae2,x					; 4
	pha								; 3
	lda		#$00					; 2
	tax								; 2
	sta		BSLDALoop				   ; 3
	rts								; 6		  jump to specified kernel


	.byte	$bd,$75,$fc,$4a,$a8,$b9,$e2,$fc ; $f89d (*)
	.byte	$b0,$06,$25,$c6,$f0,$01,$38,$60 ; $f8a5 (*)
	.byte	$25,$c7,$d0,$fb,$18,$60			; $f8ad (*)
	
MoveObjectTowardTarget
	cpy		#$01					;2		   *
	bne		Lf8bb					; 2
	lda		indyYPos				  ; get Indy's vertical position
	bmi		Lf8cc					; 2
Lf8bb
	lda		objectYPos,x				; 4
	cmp.wy	objectYPos,y				;4		   *
	bne		Lf8c6					; 2
	cpy		#$05					; 2
	bcs		Lf8ce					; 2
Lf8c6
	bcs		Lf8cc					; 2
	inc		objectYPos,x				; 6
	bne		Lf8ce					; 2
Lf8cc
	dec		objectYPos,x				; 6
Lf8ce
	lda		objectXPos ,x				 ; 4
	cmp.wy	objectXPos ,y				 ;4			*
	bne		Lf8d9					; 2
	cpy		#$05					; 2
	bcs		Lf8dd					; 2
Lf8d9
	bcs		Lf8de					; 2
	inc		objectXPos ,x				 ; 6
Lf8dd
	rts								; 6
	
Lf8de
	dec		objectXPos ,x				 ; 6
	rts								; 6
	
ClampObjectPositionToBounds
	lda		objectYPos,x				; 4
	cmp		#$53					; 2
	bcc		Lf8f1					; 2
Lf8e7
	rol		ram_8C,x				; 6
	clc								; 2
	ror		ram_8C,x				; 6
	lda		#$78					; 2
	sta		objectYPos,x				; 4
	rts								; 6
	
Lf8f1
	lda		objectXPos ,x				 ; 4
	cmp		#$10					; 2
	bcc		Lf8e7					; 2
	cmp		#$8e					; 2
	bcs		Lf8e7					; 2
	rts								; 6
	
	.byte	$00,$00,$00,$00,$00,$e4,$7e,$9a ; $f8fc (*)
	.byte	$e4,$a6,$5a,$7e,$e4,$7f,$00,$00 ; $f904 (*)
	.byte	$84,$08,$2a,$22,$00,$22,$2a,$08 ; $f90c (*)
	.byte	$00,$b9,$d4,$89,$6c,$7b,$7f,$81 ; $f914 (*)
	.byte	$a6,$3f,$77,$07,$7f,$86,$89,$3f ; $f91c (*)
	.byte	$1f,$0e,$0c,$00,$c1,$b6,$00,$00 ; $f924 (*)
	.byte	$00,$81,$1c,$2a,$55,$2a,$14,$3e ; $f92c (*)
	.byte	$00,$a9,$00,$e4,$89,$81,$7e,$9a ; $f934 (*)
	.byte	$e4,$a6,$5a,$7e,$e4,$7f,$00,$c9 ; $f93c (*)
	.byte	$89,$82,$00,$7c,$18,$18,$92,$7f ; $f944 (*)
	.byte	$1f,$07,$00,$00,$00				; $f94c (*)
	
	
;Map Room
	.byte	$94 ; |#  # #  |
	.byte	$00 ; |		   |
	.byte	$08 ; |	   #   |
	.byte	$1C ; |	  ###  |
	.byte	$3E ; |	 ##### |
	.byte	$3E ; |	 ##### |
	.byte	$3E ; |	 ##### |
	.byte	$3E ; |	 ##### |
	.byte	$1C ; |	  ###  |
	.byte	$08 ; |	   #   |
	.byte	$00 ; |		   |
	.byte	$8E ; |#   ### |
	.byte	$7F ; | #######|
	.byte	$7F ; | #######|
	.byte	$7F ; | #######|
	.byte	$14 ; |	  # #  |
	.byte	$14 ; |	  # #  |
	.byte	$00 ; |		   |
	.byte	$00 ; |		   |
	.byte	$2A ; |	 # # # |
	.byte	$2A ; |	 # # # |
	.byte	$00 ; |		   |
	.byte	$00 ; |		   |
	.byte	$14 ; |	  # #  |
	.byte	$36 ; |	 ## ## |
	.byte	$22 ; |	 #	 # |
	.byte	$08 ; |	   #   |
	.byte	$08 ; |	   #   |
	.byte	$3E ; |	 ##### |
	.byte	$1C ; |	  ###  |
	.byte	$08 ; |	   #   |
	.byte	$00 ; |		   |
	.byte	$41 ; | #	  #|
	.byte	$63 ; | ##	 ##|
	.byte	$49 ; | #  #  #|
	.byte	$08 ; |	   #   |
	.byte	$00 ; |		   |
	.byte	$00 ; |		   |
	.byte	$14 ; |	  # #  |
	.byte	$14 ; |	  # #  |
	.byte	$00 ; |		   |
	.byte	$00 ; |		   |
	.byte	$08 ; |	   #   |
	.byte	$6B ; | ## # ##|
	.byte	$6B ; | ## # ##|
	.byte	$08 ; |	   #   |
	.byte	$00 ; |		   |
	.byte	$22 ; |	 #	 # |
	.byte	$22 ; |	 #	 # |
	.byte	$00 ; |		   |
	.byte	$00 ; |		   |
	.byte	$08 ; |	   #   |
	.byte	$1C ; |	  ###  |
	.byte	$1C ; |	  ###  |
	.byte	$7F ; | #######|
	.byte	$7F ; | #######|
	.byte	$7F ; | #######|
	.byte	$E4 ; |###	#  |
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$41 ; | #	  #|
	.byte	$7F ; | #######|
	.byte	$92 ; |#  #	 # |
	.byte	$77 ; | ### ###|
	.byte	$77 ; | ### ###|
	.byte	$63 ; | ##	 ##|
	.byte	$77 ; | ### ###|
	.byte	$14 ; |	  # #  |
	.byte	$36 ; |	 ## ## |
	.byte	$55 ; | # # # #|
	.byte	$63 ; | ##	 ##|
	.byte	$77 ; | ### ###|
	.byte	$7F ; | #######|
	.byte	$7F ; | #######|
	.byte	$00 ; |		   |
	.byte	$86 ; |#	## |
	.byte	$24 ; |	 #	#  |
	.byte	$18 ; |	  ##   |
	.byte	$24 ; |	 #	#  |
	.byte	$24 ; |	 #	#  |
	.byte	$7E ; | ###### |
	.byte	$5A ; | # ## # |
	.byte	$5B ; | # ## ##|
	.byte	$3C ; |	 ####  |


; $f94c (*)
; $f954 (*)
; $f95c (*)
; $f964 (*)
; $f96c (*)
; $f974 (*)
; $f97c (*)
; $f984 (*)
; $f98c (*)
; $f994 (*)
; $f99c (*)
; $f9a4 (*)





	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $f9ac (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $f9b4 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $f9bc (*)
	.byte	$00,$b9,$e4,$81,$89,$55,$f9,$89 ; $f9c4 (*)
	.byte	$f9,$81,$fa,$32,$1c,$89,$3e,$91 ; $f9cc (*)
	.byte	$7f,$7f,$7f,$7f,$89,$1f,$07,$01 ; $f9d4 (*)
	.byte	$00,$e9,$fe,$89,$3f,$7f,$f9,$91 ; $f9dc (*)
	.byte	$f9,$89,$3f,$f9,$7f,$3f,$7f,$7f ; $f9e4 (*)
	.byte	$00,$00							; $f9ec (*)
Lf9ee
	.byte	$00,$00,$00,$00,$00,$00,$02,$02 ; $f9ee (*)
	.byte	$02,$02,$02,$04,$04				; $f9f6 (*)
	.byte	$06								; $f9fb (D)
	
Lf9fc
	.byte	$1c ; |	  ###  |			$f9fc (G)
	.byte	$36 ; |	 ## ## |			$f9fd (G)
	.byte	$63 ; | ##	 ##|			$f9fe (G)
	.byte	$36 ; |	 ## ## |			$f9ff (G)
	
	.byte	$18 ; |	  XX   |			$fa00 (G)
	.byte	$3C ; |	 XXXX  |			$fa01 (G)
	.byte	$00 ; |		   |			$fa02 (G)
	.byte	$18 ; |	  XX   |			$fa03 (G)
	.byte	$1C ; |	  XXX  |			$fa04 (G)
	.byte	$18 ; |	  XX   |			$fa05 (G)
	.byte	$18 ; |	  XX   |			$fa06 (G)
	.byte	$0C ; |	   XX  |			$fa07 (G)
	.byte	$62 ; | XX	 X |			$fa08 (G)
	.byte	$43 ; | X	 XX|			$fa09 (G)
	.byte	$00 ; |		   |			$fa0a (G)

	.byte	$18 ; |	  XX   |			$fa0b (G)
	.byte	$3C ; |	 XXXX  |			$fa0c (G)
	.byte	$00 ; |		   |			$fa0d (G)
	.byte	$18 ; |	  XX   |			$fa0e (G)
	.byte	$38 ; |	 XXX   |			$fa0f (G)
	.byte	$1C ; |	  XXX  |			$fa10 (G)
	.byte	$18 ; |	  XX   |			$fa11 (G)
	.byte	$14 ; |	  X X  |			$fa12 (G)
	.byte	$64 ; | XX	X  |			$fa13 (G)
	.byte	$46 ; | X	XX |			$fa14 (G)
	.byte	$00 ; |		   |			$fa15 (G)

	.byte	$18 ; |	  XX   |			$fa16 (G)
	.byte	$3C ; |	 XXXX  |			$fa17 (G)
	.byte	$00 ; |		   |			$fa18 (G)
	.byte	$38 ; |	 XXX   |			$fa19 (G)
	.byte	$38 ; |	 XXX   |			$fa1a (G)
	.byte	$18 ; |	  XX   |			$fa1b (G)
	.byte	$18 ; |	  XX   |			$fa1c (G)
	.byte	$28 ; |	 X X   |			$fa1d (G)
	.byte	$48 ; | X  X   |			$fa1e (G)
	.byte	$8C ; |X   XX  |			$fa1f (G)
	.byte	$00 ; |		   |			$fa20 (G)

	.byte	$18 ; |	  XX   |			$fa21 (G)
	.byte	$3C ; |	 XXXX  |			$fa22 (G)
	.byte	$00 ; |		   |			$fa23 (G)
	.byte	$38 ; |	 XXX   |			$fa24 (G)
	.byte	$58 ; | X XX   |			$fa25 (G)
	.byte	$38 ; |	 XXX   |			$fa26 (G)
	.byte	$10 ; |	  X	   |			$fa27 (G)
	.byte	$E8 ; |XXX X   |			$fa28 (G)
	.byte	$88 ; |X   X   |			$fa29 (G)
	.byte	$0C ; |	   XX  |			$fa2a (G)
	.byte	$00 ; |		   |			$fa2b (G)

	.byte	$18 ; |	  XX   |			$fa2c (G)
	.byte	$3C ; |	 XXXX  |			$fa2d (G)
	.byte	$00 ; |		   |			$fa2e (G)
	.byte	$30 ; |	 XX	   |			$fa2f (G)
	.byte	$78 ; | XXXX   |			$fa30 (G)
	.byte	$34 ; |	 XX X  |			$fa31 (G)
	.byte	$18 ; |	  XX   |			$fa32 (G)
	.byte	$60 ; | XX	   |			$fa33 (G)
	.byte	$50 ; | X X	   |			$fa34 (G)
	.byte	$18 ; |	  XX   |			$fa35 (G)
	.byte	$00 ; |		   |			$fa36 (G)

	.byte	$18 ; |	  XX   |			$fa37 (G)
	.byte	$3C ; |	 XXXX  |			$fa38 (G)
	.byte	$00 ; |		   |			$fa39 (G)
	.byte	$30 ; |	 XX	   |			$fa3a (G)
	.byte	$38 ; |	 XXX   |			$fa3b (G)
	.byte	$3C ; |	 XXXX  |			$fa3c (G)
	.byte	$18 ; |	  XX   |			$fa3d (G)
	.byte	$38 ; |	 XXX   |			$fa3e (G)
	.byte	$20 ; |	 X	   |			$fa3f (G)
	.byte	$30 ; |	 XX	   |			$fa40 (G)
	.byte	$00 ; |		   |			$fa41 (G)

	.byte	$18 ; |	  XX   |			$fa42 (G)
	.byte	$3C ; |	 XXXX  |			$fa43 (G)
	.byte	$00 ; |		   |			$fa44 (G)
	.byte	$18 ; |	  XX   |			$fa45 (G)
	.byte	$38 ; |	 XXX   |			$fa46 (G)
	.byte	$1C ; |	  XXX  |			$fa47 (G)
	.byte	$18 ; |	  XX   |			$fa48 (G)
	.byte	$2C ; |	 X XX  |			$fa49 (G)
	.byte	$20 ; |	 X	   |			$fa4a (G)
	.byte	$30 ; |	 XX	   |			$fa4b (G)
	.byte	$00 ; |		   |			$fa4c (G)

	.byte	$18 ; |	  XX   |			$fa4d (G)
	.byte	$3C ; |	 XXXX  |			$fa4e (G)
	.byte	$00 ; |		   |			$fa4f (G)
	.byte	$18 ; |	  XX   |			$fa50 (G)
	.byte	$18 ; |	  XX   |			$fa51 (G)
	.byte	$18 ; |	  XX   |			$fa52 (G)
	.byte	$08 ; |	   X   |			$fa53 (G)
	.byte	$16 ; |	  X XX |			$fa54 (G)
	.byte	$30 ; |	 XX	   |			$fa55 (G)
	.byte	$20 ; |	 X	   |			$fa56 (G)
	.byte	$00 ; |		   |			$fa57 (G)

indy_sprite
	.byte	$18 ; |	  ##   |			$fa58 (G)
	.byte	$3c ; |	 ####  |			$fa59 (G)
	.byte	$00 ; |		   |			$fa5a (G)
	.byte	$18 ; |	  ##   |			$fa5b (G)
	.byte	$3c ; |	 ####  |			$fa5c (G)
	.byte	$5a ; | # ## # |			$fa5d (G)
	.byte	$3c ; |	 ####  |			$fa5e (G)
	.byte	$18 ; |	  ##   |			$fa5f (G)
	.byte	$18 ; |	  ##   |			$fa60 (G)
	.byte	$3c ; |	 ####  |			$fa61 (G)
	.byte	$00 ; |		   |			$fa62 (G)

	.byte	$3C ; |	 ####  |			$fa63 (G)
	.byte	$7E ; | ###### |			$fa64 (G)
	.byte	$FF ; |########|			$fa65 (G)
	.byte	$A5 ; |# #	# #|			$fa66 (G)
	.byte	$42 ; | #	 # |			$fa67 (G)
	.byte	$42 ; | #	 # |			$fa68 (G)
	.byte	$18 ; |	  ##   |			$fa69 (G)
	.byte	$3C ; |	 ####  |			$fa6a (G)
	.byte	$81 ; |#	  #|			$fa6b (G)
	.byte	$5A ; | # ## # |			$fa6c (G)
	.byte	$3C ; |	 ####  |			$fa6d (G)
	.byte	$3C ; |	 ####  |			$fa6e (G)
	.byte	$38 ; |	 ###   |			$fa6f (G)
	.byte	$18 ; |	  ##   |			$fa70 (G)
	.byte	$00 ; |		   |			$fa71 (G)



	.byte	$10,$10,$00,$f0,$f0,$00,$10,$00 ; $fa72 (*)
	.byte	$10,$10,$00,$f0,$00,$10,$10,$00 ; $fa7a (*)
	.byte	$10,$00,$f0,$f0,$00,$f0,$f0,$00 ; $fa82 (*)
	.byte	$f0,$f0,$00,$10,$10,$00,$f0		; $fa8a (*)
Lfa91
	.byte	$00,$00,$e0,$00,$00,$c0,$ff,$ff ; $fa91 (*)
	.byte	$00,$ff,$ff,$f0,$f0				; $fa99 (*)
	
Lfa9e
	.byte	$00 ; |		   |			$fa9e (P)
	
	.byte	$e0,$00,$e0,$80,$00,$ff,$ff,$00 ; $fa9f (*)
	.byte	$ff,$ff,$c0,$00					; $faa7 (*)
	
	.byte	$00 ; |		   |			$faab (P)
	
Lfaac
	.byte	$c0,$f0,$f0,$f0,$f0,$f0,$c0,$c0 ; $faac (*)
	.byte	$c0,$f0,$f0,$f0,$f0				; $fab4 (*)
	
	.byte	$c0 ; |**	   |			$fab9 (P)
	
	.byte	$f7,$f7,$f7,$f7,$f7,$37,$37,$00 ; $faba (*)
	.byte	$63,$62,$6b,$5b,$6a,$5f,$5a,$5a ; $fac2 (*)
	.byte	$6b,$5e,$67,$5a,$62,$6b,$5a,$6b ; $faca (*)
	.byte	$22,$13,$13,$18,$18,$1e,$21,$13 ; $fad2 (*)
	.byte	$21,$26,$26,$2b,$2a,$2b,$31,$31 ; $fada (*)
Lfae2
	.byte	$b4								; $fae2 (*)
Lfae3
	.byte	$f0,$02,$f0,$3f,$f1				; $fae3 (*)
	.byte	$a5,$f4							; $fae8 (D)
	.byte	$ae,$c0,$b7,$c9					; $faea (*)
Lfaee
	.byte	$1b,$18,$17,$17,$18,$18,$1b,$1b ; $faee (*)
	.byte	$1d,$18,$17,$12,$18,$17,$1b,$1d ; $faf6 (*)
	.byte	$00,$00							; $fafe (*)
	
	.byte	$00 ; |		   |			$fb00 (G)
	.byte	$00 ; |		   |			$fb01 (G)
	.byte	$00 ; |		   |			$fb02 (G)
	.byte	$00 ; |		   |			$fb03 (G)
	.byte	$00 ; |		   |			$fb04 (G)
	.byte	$00 ; |		   |			$fb05 (G)
	.byte	$00 ; |		   |			$fb06 (G)
	.byte	$00 ; |		   |			$fb07 (G)

	.byte	$71 ; | ###	  #|			$fb08 (G)
	.byte	$41 ; | #	  #|			$fb09 (G)
	.byte	$41 ; | #	  #|			$fb0a (G)
	.byte	$71 ; | ###	  #|			$fb0b (G)
	.byte	$11 ; |	  #	  #|			$fb0c (G)
	.byte	$51 ; | # #	  #|			$fb0d (G)
	.byte	$70 ; | ###	   |			$fb0e (G)
	.byte	$00 ; |		   |			$fb0f (G)

	.byte	$00 ; |		   |			$fb10 (G)
	.byte	$01 ; |		  #|			$fb11 (G)
	.byte	$3F ; |	 ######|			$fb12(G)
	.byte	$6B ; | ## # ##|			$fb12 (G)
	.byte	$7F ; | #######|			$fb13 (G)
	.byte	$01 ; |		  #|			$fb14 (G)
	.byte	$00 ; |		   |			$fb15 (G)
	.byte	$00 ; |		   |			$fb16 (G)

	.byte	$77 ; | ### ###|			$fb17 (G)
	.byte	$77 ; | ### ###|			$fb18 (G)
	.byte	$77 ; | ### ###|			$fb19 (G)
	.byte	$00 ; |		   |			$fb1a (G)
	.byte	$00 ; |		   |			$fb1b (G)
	.byte	$77 ; | ### ###|			$fb1c (G)
	.byte	$77 ; | ### ###|			$fb1d (G)
	.byte	$77 ; | ### ###|			$fb1e (G)

	.byte	$1C ; |	  ###  |			$fb1f (G)
	.byte	$2A ; |	 # # # |			$fb20 (G)
	.byte	$55 ; | # # # #|			$fb21 (G)
	.byte	$2A ; |	 # # # |			$fb22 (G)
	.byte	$55 ; | # # # #|			$fb23 (G)
	.byte	$2A ; |	 # # # |			$fb24 (G)
	.byte	$1C ; |	  ###  |			$fb25 (G)
	.byte	$3E ; |	 ##### |			$fb26 (G)

	.byte	$3A ; |	 ### # |			$fb27 (G)
	.byte	$01 ; |		  #|			$fb28 (G)
	.byte	$7D ; | ##### #|			$fb29 (G)
	.byte	$01 ; |		  #|			$fb2a (G)
	.byte	$39 ; |	 ###  #|			$fb2b (G)
	.byte	$02 ; |		 # |			$fb2c (G)
	.byte	$3C ; |	 ####  |			$fb2d (G)
	.byte	$30 ; |	 ##	   |			$fb2e (G)

	.byte	$2E ; |	 # ### |			$fb2f (G)
	.byte	$40 ; | #	   |			$fb30 (G)
	.byte	$5F ; | # #####|			$fb31 (G)
	.byte	$40 ; | #	   |			$fb32 (G)
	.byte	$4E ; | #  ### |			$fb33 (G)
	.byte	$20 ; |	 #	   |			$fb34 (G)
	.byte	$1E ; |	  #### |			$fb35 (G)
	.byte	$06 ; |		## |			$fb36 (G)

	.byte	$00 ; |		   |			$fb37 (G)
	.byte	$25 ; |	 #	# #|			$fb38 (G)
	.byte	$52 ; | # #	 # |			$fb39 (G)
	.byte	$7F ; | #######|			$fb3a (G)
	.byte	$50 ; | # #	   |			$fb3b (G)
	.byte	$20 ; |	 #	   |			$fb3c (G)
	.byte	$00 ; |		   |			$fb3d (G)
	.byte	$00 ; |		   |			$fb3e (G)

Lfb40
	.byte	$ff ; |########|			$fb40 (G)
	.byte	$66 ; | ##	## |			$fb41 (G)
	.byte	$24 ; |	 #	#  |			$fb42 (G)
	.byte	$24 ; |	 #	#  |			$fb43 (G)
	.byte	$66 ; | ##	## |			$fb44 (G)
	.byte	$e7 ; |###	###|			$fb45 (G)
	.byte	$c3 ; |##	 ##|			$fb46 (G)

	.byte	$e7 ; |###	###|			$fb47 (G)
	
	.byte	$17 ; |	  # ###|			$fb48 (G)
	.byte	$15 ; |	  # # #|			$fb49 (G)
	.byte	$15 ; |	  # # #|			$fb4a (G)
	.byte	$77 ; | ### ###|			$fb4b (G)
	.byte	$55 ; | # # # #|			$fb4c (G)
	.byte	$55 ; | # # # #|			$fb4d (G)
	.byte	$77 ; | ### ###|			$fb4e (G)
	.byte	$00 ; |		   |			$fb4f (G)

	.byte	$21 ; |	 #	  #|			$fb50 (G)
	.byte	$11 ; |	  #	  #|			$fb51 (G)
	.byte	$09 ; |	   #  #|			$fb52 (G)
	.byte	$11 ; |	  #	  #|			$fb53 (G)
	.byte	$22 ; |	 #	 # |			$fb54 (G)
	.byte	$44 ; | #	#  |			$fb55 (G)
	.byte	$28 ; |	 # #   |			$fb56 (G)
	.byte	$10 ; |	  #	   |			$fb57 (G)

	.byte	$01 ; |		  #|			$fb58 (G)
	.byte	$03 ; |		 ##|			$fb59 (G)
	.byte	$07 ; |		###|			$fb5a (G)
	.byte	$0F ; |	   ####|			$fb5b (G)
	.byte	$06 ; |		## |			$fb5c (G)
	.byte	$0C ; |	   ##  |			$fb5d (G)
	.byte	$18 ; |	  ##   |			$fb5e (G)
	.byte	$3C ; |	 ####  |			$fb5f (G)
	
	.byte	$79 ; | ####  #|			$fb60 (G)
	.byte	$85 ; |#	# #|			$fb61 (G)
	.byte	$b5 ; |# ## # #|			$fb62 (G)
	.byte	$a5 ; |# #	# #|			$fb63 (G)
	.byte	$b5 ; |# ## # #|			$fb64 (G)
	.byte	$85 ; |#	# #|			$fb65 (G)
	.byte	$79 ; | ####  #|			$fb66 (G)
	.byte	$00 ; |		   |			$fb67 (G)
 
	.byte	$00 ; |		   |			$fb68 (G)
	.byte	$60 ; | ##	   |			$fb69 (G)
	.byte	$60 ; | ##	   |			$fb6a (G)
	.byte	$78 ; | ####   |			$fb6b (G)
	.byte	$68 ; | ## #   |			$fb6c (G)
	.byte	$3F ; |	 ######|			$fb6d (G)
	.byte	$5F ; | # #####|			$fb6e (G)
	.byte	$00 ; |		   |			$fb6f (G)

	.byte	$08 ; |	   #   |			$fb70 (G)
	.byte	$1C ; |	  ###  |			$fb71 (G)
	.byte	$22 ; |	 #	 # |			$fb72 (G)
	.byte	$49 ; | #  #  #|			$fb73 (G)
	.byte	$6B ; | ## # ##|			$fb74 (G)
	.byte	$00 ; |		   |			$fb75 (G)
	.byte	$1C ; |	  ###  |			$fb76 (G)
	.byte	$08 ; |	   #   |			$fb77 (G)

	.byte	$7F ; | #######|			$fb78 (G)
	.byte	$5D ; | # ### #|			$fb79 (G)
	.byte	$77 ; | ### ###|			$fb7a (G)
	.byte	$77 ; | ### ###|			$fb7b (G)
	.byte	$5D ; | # ### #|			$fb7c (G)
	.byte	$7F ; | #######|			$fb7d (G)
	.byte	$08 ; |	   #   |			$fb7e (G)
	.byte	$1C ; |	  ###  |			$fb7f (G)

	.byte	$3E ; |	 ##### |			$fb80 (G)
	.byte	$1C ; |	  ###  |			$fb81 (G)
	.byte	$49 ; | #  #  #|			$fb82 (G)
	.byte	$7F ; | #######|			$fb83 (G)
	.byte	$49 ; | #  #  #|			$fb84 (G)
	.byte	$1C ; |	  ###  |			$fb85 (G)
	.byte	$36 ; |	 ## ## |			$fb86 (G)
	.byte	$1C ; |	  ###  |			$fb87 (G)

	.byte	$16 ; |	  # ## |			$fb88 (G)
	.byte	$0B ; |	   # ##|			$fb89 (G)
	.byte	$0D ; |	   ## #|			$fb8a (G)
	.byte	$05 ; |		# #|			$fb8b (G)
	.byte	$17 ; |	  # ###|			$fb8c (G)
	.byte	$36 ; |	 ## ## |			$fb8d (G)
	.byte	$64 ; | ##	#  |			$fb8e (G)
	.byte	$04 ; |		#  |			$fb8f (G)

	.byte	$77 ; | ### ###|			$fb90 (G)
	.byte	$36 ; |	 ## ## |			$fb91 (G)
	.byte	$14 ; |	  # #  |			$fb92 (G)
	.byte	$22 ; |	 #	 # |			$fb93 (G)
	.byte	$22 ; |	 #	 # |			$fb94 (G)
	.byte	$14 ; |	  # #  |			$fb95 (G)
	.byte	$36 ; |	 ## ## |			$fb96 (G)
	.byte	$77 ; | ### ###|			$fb97 (G)

	.byte	$3E ; |	 ##### |			$fb98 (G)
	.byte	$41 ; | #	  #|			$fb99 (G)
	.byte	$41 ; | #	  #|			$fb9a (G)
	.byte	$49 ; | #  #  #|			$fb9b (G)
	.byte	$49 ; | #  #  #|			$fb9c (G)
	.byte	$49 ; | #  #  #|			$fb9d (G)
	.byte	$3E ; |	 ##### |			$fb9e (G)
	.byte	$1C ; |	  ###  |			$fb9f (G)

	.byte	$3E ; |	 ##### |			$fba0 (G)
	.byte	$41 ; | #	  #|			$fba1 (G)
	.byte	$41 ; | #	  #|			$fba2 (G)
	.byte	$49 ; | #  #  #|			$fba3 (G)
	.byte	$45 ; | #	# #|			$fba4 (G)
	.byte	$43 ; | #	 ##|			$fba5 (G)
	.byte	$3E ; |	 ##### |			$fba6 (G)
	.byte	$1C ; |	  ###  |			$fba7 (G)

	.byte	$3E ; |	 ##### |			$fba8 (G)
	.byte	$41 ; | #	  #|			$fba9 (G)
	.byte	$41 ; | #	  #|			$fbaa (G)
	.byte	$4F ; | #  ####|			$fbab (G)
	.byte	$41 ; | #	  #|			$fbac (G)
	.byte	$41 ; | #	  #|			$fbad (G)
	.byte	$3E ; |	 ##### |			$fbae (G)
	.byte	$1C ; |	  ###  |			$fbaf (G)

	.byte	$3E ; |	 ##### |			$fbb0 (G)
	.byte	$43 ; | #	 ##|			$fbb1 (G)
	.byte	$45 ; | #	# #|			$fbb2 (G)
	.byte	$49 ; | #  #  #|			$fbb3 (G)
	.byte	$41 ; | #	  #|			$fbb4 (G)
	.byte	$41 ; | #	  #|			$fbb5 (G)
	.byte	$3E ; |	 ##### |			$fbb6 (G)
	.byte	$1C ; |	  ###  |			$fbb7 (G)

	.byte	$3E ; |	 ##### |			$fbb8 (G)
	.byte	$49 ; | #  #  #|			$fbb9 (G)
	.byte	$49 ; | #  #  #|			$fbba (G)
	.byte	$49 ; | #  #  #|			$fbbb (G)
	.byte	$41 ; | #	  #|			$fbbc (G)
	.byte	$41 ; | #	  #|			$fbbd (G)
	.byte	$3E ; |	 ##### |			$fbbe (G)
	.byte	$1C ; |	  ###  |			$fbbf (G)

	.byte	$3E ; |	 ##### |			$fbc0 (G)
	.byte	$61 ; | ##	  #|			$fbc1 (G)
	.byte	$51 ; | # #	  #|			$fbc2 (G)
	.byte	$49 ; | #  #  #|			$fbc3 (G)
	.byte	$41 ; | #	  #|			$fbc4 (G)
	.byte	$41 ; | #	  #|			$fbc5 (G)
	.byte	$3E ; |	 ##### |			$fbc6 (G)
	.byte	$1C ; |	  ###  |			$fbc7 (G)

	.byte	$3E ; |	 ##### |			$fbc8 (G)
	.byte	$41 ; | #	  #|			$fbc9 (G)
	.byte	$41 ; | #	  #|			$fbca (G)
	.byte	$79 ; | ####  #|			$fbcb (G)
	.byte	$41 ; | #	  #|			$fbcc (G)
	.byte	$41 ; | #	  #|			$fbcd (G)
	.byte	$3E ; |	 ##### |			$fbce (G)
	.byte	$1C ; |	  ###  |			$fbcf (G)

	.byte	$3E ; |	 ##### |			$fbd0 (G)
	.byte	$41 ; | #	  #|			$fbd1 (G)
	.byte	$41 ; | #	  #|			$fbd2 (G)
	.byte	$49 ; | #  #  #|			$fbd3 (G)
	.byte	$51 ; | # #	  #|			$fbd4 (G)
	.byte	$61 ; | ##	  #|			$fbd5 (G)
	.byte	$3E ; |	 ##### |			$fbd6 (G)
	.byte	$1C ; |	  ###  |			$fbd7 (G)

	.byte	$49 ; | #  #  #|			$fbd8 (G)
	.byte	$49 ; | #  #  #|			$fbd9 (G)
	.byte	$49 ; | #  #  #|			$fbda (G)
	.byte	$C9 ; |##  #  #|			$fbdb (G)
	.byte	$49 ; | #  #  #|			$fbdc (G)
	.byte	$49 ; | #  #  #|			$fbdd (G)
	.byte	$BE ; |# ##### |			$fbde (G)
	.byte	$00 ; |		   |			$fbdf (G) 

	.byte	$55 ; | # # # #|			$fbe0 (G)
	.byte	$55 ; | # # # #|			$fbe1 (G)
	.byte	$55 ; | # # # #|			$fbe2 (G)
	.byte	$d9 ; |## ##  #|			$fbe3 (G)
	.byte	$55 ; | # # # #|			$fbe4 (G)
	.byte	$55 ; | # # # #|			$fbe5 (G)
	.byte	$99 ; |#  ##  #|			$fbe6 (G)
	.byte	$00 ; |		   |			$fbe7 (G)
	
Lfbe8
	.byte	$14								; $fbe8 (D)
	.byte	$14,$14,$0f,$10,$12,$0b,$0b,$0b ; $fbe9 (*)
	.byte	$10,$12,$14,$17,$17,$17,$17		; $fbf1 (*)
	.byte	$18,$1b,$0f,$0f,$0f,$14,$17,$18 ; $fbf8 (D)


	.byte	$14 ; |	  # #  |			$fc00 (G)
	.byte	$3C ; |	 ####  |			$fc01 (G)
	.byte	$7E ; | ###### |			$fc02 (G)
	.byte	$00 ; |		   |			$fc03 (G)
	.byte	$30 ; |	 ##	   |			$fc04 (G)
	.byte	$38 ; |	 ###   |			$fc05 (G)
	.byte	$3C ; |	 ####  |			$fc06 (G)
	.byte	$3E ; |	 ##### |			$fc07 (G)
	.byte	$3F ; |	 ######|			$fc08 (G)
	.byte	$7F ; | #######|			$fc09 (G)
	.byte	$7F ; | #######|			$fc0a (G)
	.byte	$7F ; | #######|			$fc0b (G)
	.byte	$11 ; |	  #	  #|			$fc0c (G)
	.byte	$11 ; |	  #	  #|			$fc0d (G)
	.byte	$33 ; |	 ##	 ##|			$fc0e (G)
	.byte	$00 ; |		   |			$fc0f (G)

	.byte	$14 ; |	  # #  |			$fc10 (G)
	.byte	$3C ; |	 ####  |			$fc11 (G)
	.byte	$7E ; | ###### |			$fc12 (G)
	.byte	$00 ; |		   |			$fc13 (G)
	.byte	$30 ; |	 ##	   |			$fc14 (G)
	.byte	$38 ; |	 ###   |			$fc15 (G)
	.byte	$3C ; |	 ####  |			$fc16 (G)
	.byte	$3E ; |	 ##### |			$fc17 (G)
	.byte	$3F ; |	 ######|			$fc18 (G)
	.byte	$7F ; | #######|			$fc19 (G)
	.byte	$7F ; | #######|			$fc1a (G)
	.byte	$7F ; | #######|			$fc1b (G)
	.byte	$22 ; |	 #	 # |			$fc1c (G)
	.byte	$22 ; |	 #	 # |			$fc1d (G)
	.byte	$66 ; | ##	## |			$fc1e (G)
	.byte	$00 ; |		   |			$fc1f (G)

	.byte	$14 ; |	  # #  |			$fc20 (G)
	.byte	$3C ; |	 ####  |			$fc21 (G)
	.byte	$7E ; | ###### |			$fc22 (G)
	.byte	$00 ; |		   |			$fc23 (G)
	.byte	$30 ; |	 ##	   |			$fc24 (G)
	.byte	$38 ; |	 ###   |			$fc25 (G)
	.byte	$3C ; |	 ####  |			$fc26 (G)
	.byte	$3E ; |	 ##### |			$fc27 (G)
	.byte	$3F ; |	 ######|			$fc28 (G)
	.byte	$7F ; | #######|			$fc29 (G)
	.byte	$7F ; | #######|			$fc2a (G)
	.byte	$7F ; | #######|			$fc2b (G)
	.byte	$44 ; | #	#  |			$fc2c (G)
	.byte	$44 ; | #	#  |			$fc2d (G)
	.byte	$CC ; |##  ##  |			$fc2e (G)
	.byte	$00 ; |		   |			$fc2f (G)

	.byte	$14 ; |	  # #  |			$fc30 (G)
	.byte	$3C ; |	 ####  |			$fc31 (G)
	.byte	$7E ; | ###### |			$fc32 (G)
	.byte	$00 ; |		   |			$fc33 (G)
	.byte	$30 ; |	 ##	   |			$fc34 (G)
	.byte	$38 ; |	 ###   |			$fc35 (G)
	.byte	$3C ; |	 ####  |			$fc36 (G)
	.byte	$3E ; |	 ##### |			$fc37 (G)
	.byte	$3F ; |	 ######|			$fc38 (G)
	.byte	$7F ; | #######|			$fc39 (G)
	.byte	$7F ; | #######|			$fc3a (G)
	.byte	$7F ; | #######|			$fc3b (G)
	.byte	$08 ; |	   #   |			$fc3c (G)
	.byte	$08 ; |	   #   |			$fc3d (G)
	.byte	$18 ; |	  ##   |			$fc3e (G)
	.byte	$00 ; |		   |			$fc3f (G)
	
	

Lfc40
	.byte	$00,$10,$20,$30,$7c,$0f,$7c,$00 ; $fc40 (*)
	.byte	$0a,$02,$04,$06,$08,$0a,$08,$06 ; $fc48 (*)
	.byte	$98,$98,$9e,$9e,$00,$00,$00,$00 ; $fc50 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$08 ; $fc58 (*)
	.byte	$1c,$3c,$3e,$7f,$ff,$ff,$ff,$ff ; $fc60 (*)
	.byte	$ff,$ff,$ff,$ff,$3e,$3c,$3a,$38 ; $fc68 (*)
	.byte	$36,$34,$32,$20,$10,$00,$00,$00 ; $fc70 (*)
	.byte	$00,$08,$00,$02,$0a,$0c,$0e,$01 ; $fc78 (*)
	.byte	$03,$04,$06,$05,$07,$0d,$0f,$0b ; $fc80 (*)
Lfc88
	.byte	$e0								; $fc88 (*)
Lfc89
	.byte	$f6,$32,$f8,$3d,$f8,$ae,$f6,$27 ; $fc89 (*)
	.byte	$f7,$62,$f6,$a7,$f7,$3e,$f5,$df ; $fc91 (*)
	.byte	$f7,$34,$f5,$9c,$f5,$37,$f6,$29 ; $fc99 (*)
	.byte	$f6,$1a,$38,$09,$26,$26,$46,$1a ; $fca1 (*)
	.byte	$38,$04,$11,$10,$12				; $fca9 (*)
	
	
	.byte	$54 ; | # # #  |			$fcae (G)
	.byte	$FC ; |######  |			$fcaf (G)
	.byte	$5F ; | # #####|			$fcb0 (G)
	.byte	$FE ; |####### |			$fcb1 (G)
	.byte	$7F ; | #######|			$fcb2 (G)
	.byte	$FA ; |##### # |			$fcb3 (G)
	.byte	$3F ; |	 ######|			$fcb4 (G)
	.byte	$2A ; |	 # # # |			$fcb5 (G)
	.byte	$00 ; |		   |			$fcb6 (G)
	.byte	$54 ; | # # #  |			$fcb7 (G)
	.byte	$5F ; | # #####|			$fcb8 (G)
	.byte	$FC ; |######  |			$fcb9 (G)
	.byte	$7F ; | #######|			$fcba (G)
	.byte	$FE ; |####### |			$fcbb (G)
	.byte	$3F ; |	 ######|			$fcbc (G)
	.byte	$FA ; |##### # |			$fcbd (G)
	.byte	$2A ; |	 # # # |			$fcbe (G)
	.byte	$00 ; |		   |			$fcbf (G)
	.byte	$2A ; |	 # # # |			$fcc0 (G)
	.byte	$FA ; |##### # |			$fcc1 (G)
	.byte	$3F ; |	 ######|			$fcc2 (G)
	.byte	$FE ; |####### |			$fcc3 (G)
	.byte	$7F ; | #######|			$fcc4 (G)
	.byte	$FA ; |##### # |			$fcc5 (G)
	.byte	$5F ; | # #####|			$fcc6 (G)
	.byte	$54 ; | # # #  |			$fcc7 (G)
	.byte	$00 ; |		   |			$fcc8 (G)
	.byte	$2A ; |	 # # # |			$fcc9 (G)
	.byte	$3F ; |	 ######|			$fcca (G)
	.byte	$FA ; |##### # |			$fccb (G)
	.byte	$7F ; | #######|			$fccc (G)
	.byte	$FE ; |####### |			$fccd (G)
	.byte	$5F ; | # #####|			$fcce (G)
	.byte	$FC ; |######  |			$fccf (G)
	.byte	$54 ; | # # #  |			$fcd0 (G)


	.byte	$00,$8b,$8a,$86,$87,$85,$89,$03 ; $fcd1 (*)
	.byte	$01,$00,$01,$03,$02,$01,$03,$02 ; $fcd9 (*)
	.byte	$03,$01,$02,$04,$08,$10,$20,$40 ; $fce1 (*)
	.byte	$80								; $fce9 (*)
	
ApplyMovementBitsToObject
	ror								; 2
	bcs		Lfcef					; 2
	dec		objectYPos,x				; 6
Lfcef
	ror								; 2
	bcs		Lfcf4					; 2
	inc		objectYPos,x				; 6
Lfcf4
	ror								; 2
	bcs		Lfcf9					; 2
	dec		objectXPos ,x				 ; 6
Lfcf9
	ror								; 2
	bcs		Lfcfe					; 2
	inc		objectXPos ,x				 ; 6
Lfcfe
	rts								; 6
	
	.byte	$00,$f2,$40,$f2,$c0,$12,$10,$f2 ; $fcff (*)
	.byte	$00,$12,$20,$02,$b0,$f2,$30,$12 ; $fd07 (*)
	.byte	$00,$f2,$40,$f2,$d0,$12,$10,$02 ; $fd0f (*)
	.byte	$00,$02,$30,$12,$b0,$02,$20,$12 ; $fd17 (*)
	.byte	$00,$ff,$ff,$fc,$f0,$e0,$e0,$c0 ; $fd1f (*)
	.byte	$80,$00,$00,$00,$00,$00,$00,$00 ; $fd27 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fd2f (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fd37 (*)
	.byte	$00,$00,$80,$80,$c0,$e0,$e0,$f0 ; $fd3f (*)
	.byte	$fe,$ff,$ff,$ff,$ff,$fc,$f0,$e0 ; $fd47 (*)
	.byte	$e0,$c0,$80,$00,$00,$00,$00,$00 ; $fd4f (*)
	.byte	$00,$00,$00,$00,$00,$00,$c0,$f0 ; $fd57 (*)
	.byte	$f8,$fe,$fe,$f8,$f0,$e0,$c0,$80 ; $fd5f (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fd67 (*)
	.byte	$00,$02,$07,$07,$0f,$0f,$0f,$07 ; $fd6f (*)
	.byte	$07,$02,$00,$00,$00,$00,$00,$00 ; $fd77 (*)
	.byte	$00,$00,$04,$0e,$0e,$0f,$0e,$06 ; $fd7f (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fd87 (*)
	.byte	$00,$00,$02,$07,$07,$0f,$1f,$0f ; $fd8f (*)
	.byte	$07,$07,$02,$00,$00,$00,$00,$00 ; $fd97 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$01 ; $fd9f (*)
	.byte	$03,$01,$00,$00,$00,$00,$00,$80 ; $fda7 (*)
	.byte	$80,$c0,$e0,$f8,$e0,$c0,$80,$80 ; $fdaf (*)
	.byte	$00,$00,$00,$c0,$e0,$e0,$c0,$00 ; $fdb7 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fdbf (*)
	.byte	$00,$80,$80,$80,$80,$80,$80,$00 ; $fdc7 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fdcf (*)
	.byte	$00,$c0,$e0,$e0,$c0,$00,$00,$00 ; $fdd7 (*)
	.byte	$00,$22,$41,$08,$14,$08,$41,$22 ; $fddf (*)
	.byte	$00,$41,$08,$14,$2a,$14,$08,$41 ; $fde7 (*)
	.byte	$00,$08,$14,$3e,$55,$3e,$14,$08 ; $fdef (*)
	.byte	$00,$14,$3e,$63,$2a,$63,$3e,$14 ; $fdf7 (*)
	.byte	$00,$07,$07,$07,$03,$03,$03,$01 ; $fdff (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fe07 (*)
	.byte	$30,$78,$7c,$3c,$3c,$18,$08,$00 ; $fe0f (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fe17 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fe1f (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$01 ; $fe27 (*)
	.byte	$0f,$01,$00,$00,$00,$00,$00,$00 ; $fe2f (*)
	.byte	$00,$80,$c0,$e0,$f8,$fc,$fe,$fc ; $fe37 (*)
	.byte	$f0,$e0,$c0,$c0,$80,$80,$00,$00 ; $fe3f (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fe47 (*)
	.byte	$00,$03,$07,$03,$01,$00,$00,$00 ; $fe4f (*)
	.byte	$00,$00,$80,$e0,$f8,$f8,$f8,$f8 ; $fe57 (*)
	.byte	$f0,$c0,$80,$00,$00,$00,$00,$00 ; $fe5f (*)
	.byte	$00,$00,$00,$03,$0f,$1f,$3f,$3e ; $fe67 (*)
	.byte	$3c,$38,$30,$00,$00,$00,$00,$00 ; $fe6f (*)
	.byte	$00,$07,$07,$07,$03,$03,$03,$01 ; $fe77 (*)
	.byte	$00,$00,$00,$00,$00,$00,$80,$80 ; $fe7f (*)
	.byte	$c0,$e0,$e0,$c0,$c0,$80,$00,$00 ; $fe87 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $fe8f (*)
	.byte	$30,$38,$1c,$1e,$0e,$0c,$0c,$00 ; $fe97 (*)
	.byte	$00,$00,$80,$80,$c0,$f0,$fc,$ff ; $fe9f (*)
	.byte	$ff,$ff,$ff,$fe,$fc,$f8,$f0,$e0 ; $fea7 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $feaf (*)
	.byte	$00,$00,$80,$e0,$f0,$e0,$80,$00 ; $feb7 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $febf (*)
	.byte	$03,$07,$03,$03,$01,$01,$00,$00 ; $fec7 (*)
	.byte	$00,$80,$c0,$f0,$f0,$e0,$e0,$c0 ; $fecf (*)
	.byte	$c0,$80,$80,$00,$00,$00,$00,$00 ; $fed7 (*)
	.byte	$00,$00,$03,$07,$07,$03,$01,$00 ; $fedf (*)
	.byte	$00,$c0,$e0,$f0,$f8,$f8,$fc,$fc ; $fee7 (*)
	.byte	$fc								; $feef (*)
	
Lfef0
	.byte	$3c ; |	 ####  |			$fef0 (G)
	.byte	$3c ; |	 ####  |			$fef1 (G)
	.byte	$7e ; | ###### |			$fef2 (G)
	.byte	$ff ; |########|			$fef3 (G)
	
ProcessActiveObjectMovement
	lda		ram_8C,x				; 4
	bmi		Lfef9					; 2
	rts								; 6
	
Lfef9
	jsr		ApplyMovementBitsToObject ; 6
	jsr		ClampObjectPositionToBounds ; 6
	rts								; 6
	
	.byte	$80,$00,$07,$04,$77,$71,$75,$57 ; $ff00 (*)
	.byte	$50,$00,$d6,$1c,$36,$1c,$49,$7f ; $ff08 (*)
	.byte	$49,$1c,$3e,$00,$b9,$8a,$a1,$81 ; $ff10 (*)
	.byte	$00,$00,$00,$00,$00,$00,$1c,$70 ; $ff18 (*)
	.byte	$07,$70,$0e,$00,$cf,$a6,$00,$81 ; $ff20 (*)
	.byte	$77,$36,$14,$22,$ae,$14,$36,$77 ; $ff28 (*)
	.byte	$00,$bf,$ce,$00,$ef,$81,$00,$00 ; $ff30 (*)
	.byte	$00,$00,$00,$00,$68,$2f,$0a,$0c ; $ff38 (*)
	.byte	$08,$00,$80,$81,$00,$00,$07,$01 ; $ff40 (*)
	.byte	$57,$54,$77,$50,$50,$00,$00,$00 ; $ff48 (*)
	.byte	$00,$80,$7e,$86,$80,$a6,$5a,$7e ; $ff50 (*)
	.byte	$80,$7f,$00,$b1,$f9,$f6,$06,$1e ; $ff58 (*)
	.byte	$12,$1e,$12,$1e,$7f,$00,$b9,$00 ; $ff60 (*)
	.byte	$d4,$00,$81,$1c,$2a,$55,$2a,$14 ; $ff68 (*)
	.byte	$3e,$00,$c1,$e6,$00,$00,$00,$81 ; $ff70 (*)
	.byte	$7f,$55,$2a,$55,$2a,$3e,$00,$b9 ; $ff78 (*)
	.byte	$86,$91,$81,$7e,$80,$86,$a6,$5a ; $ff80 (*)
	.byte	$7e,$86,$7f,$00,$d6,$77,$77,$80 ; $ff88 (*)
	.byte	$d6,$77,$00,$c1,$b6,$a1,$81,$1c ; $ff90 (*)
	.byte	$2a,$55,$2a,$14,$3e,$00,$00,$00 ; $ff98 (*)
	.byte	$00,$00,$86,$70,$5f,$72,$05,$00 ; $ffa0 (*)
	.byte	$c1,$00,$81,$84,$1f,$89,$f9,$91 ; $ffa8 (*)
	.byte	$f9,$18,$81,$80,$1c,$1f,$f1,$7f ; $ffb0 (*)
	.byte	$89,$f9,$f9,$89,$91,$f1,$f9,$89 ; $ffb8 (*)
	.byte	$f9,$f9,$89,$f9,$89,$f9,$89,$3f ; $ffc0 (*)
	.byte	$91,$81,$70,$40,$84,$89,$7e,$f9 ; $ffc8 (*)
	.byte	$91,$f9,$f1,$00,$b9,$84,$00,$00 ; $ffd0 (*)
	.byte	$89,$38,$78,$7b,$f9,$89,$f9,$6f ; $ffd8 (*)
	.byte	$00,$b1,$92,$e9,$f9,$00,$30,$30 ; $ffe0 (*)
	.byte	$30,$e9,$30,$30,$30,$10,$00,$00 ; $ffe8 (*)
	.byte	$00,$00							; $fff0 (*)
Lfff2
	.byte	$a4								; $fff2 (D)
	.byte	$15,$95,$06,$86,$f7				; $fff3 (*)
Lfff8
	.byte	$00								; $fff8 (D)
	.byte	$00,$00,$f0						; $fff9 (*)
	.byte	$00,$f0							; $fffc (D)
	.byte	$00								; $fffe (*)
	.byte	$f0								; $ffff (*)
