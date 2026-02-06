; disassembly of ~\projects\programming\reversing\6502\raiders\raiders.bin
; disassembled 07/02/23 15:14:09
; using stella 6.7
;
; rom properties name : raiders of the lost ark (1982) (atari)
; rom properties md5  : f724d3dd2471ed4cf5f191dbb724b69f
; bankswitch type		: f8* (8k)
;
; legend: *	 = code not yet run (tentative code)
;			d	 = data directive (referenced in some way)
;			g	 = gfx directive, shown as '#' (stored in player, missile, ball)
;			p	 = pgfx directive, shown as '*' (stored in playfield)
;			c	 = col directive, shown as color constants (stored in player color)
;			cp = pcol directive, shown as color constants (stored in playfield color)
;			cb = bcol directive, shown as color constants (stored in background color)
;			a	 = aud directive (stored in audio registers)
;			i	 = indexed accessed only
;			c	 = used by code executed in ram
;			s	 = used by stack
;			!	 = page crossed, 1 cycle penalty

	processor 6502

	include "tia_constants.h"

;-----------------------------------------------------------
;	color constants
;-----------------------------------------------------------

BLACK					= $00
WHITE					= $0E
YELLOW					= $10
LT_RED					= $20
RED						= $30
ORANGE					= $40
DK_PINK					= $50
DK_BLUE					= $70
BLUE					= $80
LT_BLUE					= $90
GREEN_BLUE				= $A0
GREEN					= $C0
DK_GREEN				= $D0
LT_BROWN				= $E0
BROWN					= $F0




;-----------------------------------------------------------
;	TIA and IO constants accessed
;-----------------------------------------------------------


;Write only registers
VSYNC			= $00  ; ......1.  vertical sync set-clear
VBLANK			= $01  ; 11....1.  vertical blank set-clear
WSYNC			= $02  ; <strobe>  wait for leading edge of horizontal blank
NUSIZ0			= $04  ; ..111111  number-size player-missile 0
NUSIZ1			= $05  ; ..111111  number-size player-missile 1
COLUP0			= $06  ; 1111111.  color-lum player 0 and missile 0
COLUP1			= $07  ; 1111111.  color-lum player 1 and missile 1
COLUPF			= $08  ; 1111111.  color-lum playfield and ball
COLUBK			= $09  ; 1111111.  color-lum background
CTRLPF			= $0a  ; ..11.111  control playfield ball size & collisions
REFP0			= $0b  ; ....1...  reflect player 0
REFP1			= $0c  ; ....1...  reflect player 1
PF0				= $0d  ; 1111....  playfield register byte 0
PF1				= $0e  ; 11111111  playfield register byte 1
PF2				= $0f  ; 11111111  playfield register byte 2
RESP0			= $10  ; <strobe>  reset player 0
RESP1			= $11  ; <strobe>  reset player 1
RESM0			= $12  ; <strobe>  reset missile 0
RESM1			= $13  ; <strobe>  reset missile 1
RESBL			= $14  ; <strobe>  reset ball
AUDC0			= $15  ; ....1111  audio control 0
AUDC1			= $16  ; ....1111  audio control 1
AUDF0			= $17  ; ...11111  audio frequency 0
AUDF1			= $18  ; ...11111  audio frequency 1
AUDV0			= $19  ; ....1111  audio volume 0
AUDV1			= $1a  ; ....1111  audio volume 1
GRP0			= $1b  ; 11111111  graphics player 0
GRP1			= $1c  ; 11111111  graphics player 1
ENAM0			= $1d  ; ......1.  graphics (enable) missile 0
ENAM1			= $1e  ; ......1.  graphics (enable) missile 1
ENABL			= $1f  ; ......1.  graphics (enable) ball
HMP0			= $20  ; 1111....  horizontal motion player 0
HMP1			= $21  ; 1111....  horizontal motion player 1
HMM0			= $22  ; 1111....  horizontal motion missile 0
HMM1			= $23  ; 1111....  horizontal motion missile 1
HMBL			= $24  ; 1111....  horizontal motion ball
VDELP0			= $25  ; .......1  vertical delay player 0
VDELP1			= $26  ; .......1  vertical delay player 1
HMOVE			= $2a  ; <strobe>  apply horizontal motion
HMCLR			= $2b  ; <strobe>  clear horizontal motion registers
CXCLR			= $2c  ; <strobe>  clear collision latches

CXM0P			= $30  ; 11......  read collision M0-P1, M0-P0 (Bit 7,6)
CXM1P			= $31  ; 11......  read collision M1-P0, M1-P1
CXP1FB			= $33  ; 11......  read collision P1-PF, P1-BL
CXM1FB			= $35  ; 11......  read collision M1-PF, M1-BL
CXPPMM			= $37  ; 11......  read collision P0-P1, M0-M1
INPT4			= $0c  ; 1.......  read input 4
INPT5			= $0d  ; 1.......  read input 5

SWCHA			= $0280 ; 11111111  Port A; input or output  (read or write)
SWCHB			= $0282 ; 11111111  Port B; console switches (read only)
INTIM			= $0284 ; 11111111  Timer output (read only)
TIM64T			= $0296 ; 11111111  set 64 clock interval (53.6 usec/interval)


;===============================================================================
; F R A M E - T I M I N G S
;===============================================================================
;	NTSC version for now

;	IF COMPILE_VERSION = NTSC

VBLANK_TIME				= 44
OVERSCAN_TIME			= 36

;	ELSE

;VBLANK_TIME				= 78
;OVERSCAN_TIME			= 72

;	ENDIF
	


;============================================================================
; Z P - V A R I A B L E S
;============================================================================

scanline		= $80
currentRoomId		= $81
frameCount	= $82
secondsTimer		= $83
loopCounter			= $84; (c)
tempGfxHolder			= $85; (c)
bankSwitchJMPOpcode			= $86; (c)
bankSwitchJMPAddr			= $87; (c)
bankSwitchJMPAddrLo			= $88; (c)
bankSwitchJMPAddrHi			= $89; (c)
playerInputState			= $8a
arkDigRegionId			= $8b
arkLocationRegionId			= $8c
eventState			= $8d
m0PosYShadow			= $8e
weaponStatus			= $8f
unused_90			= $90
moveDirection			= $91
indyDir		= $92
screenEventState			= $93
roomPFControlFlags		= $94
pickupStatusFlags			= $95
diggingState			= $96
digAttemptCounter			= $97
EventStateOffset			= $98
screenInitFlag			= $99
grenadeState			= $9a
grenadeCookTime			= $9b
resetEnableFlag			= $9c
majorEventFlag			= $9d
score			= $9e
livesLeft		= $9f
bulletCount		= $a0
eventTimer			= $a1
soundChan0EffectTimer			= $a2
soundChan1EffectTimer			= $a3
soundTimer		= $a4
grenadeOpeningPenalty	= $a5
escapePrisonPenalty		= $a6
findingArkBonus			= $a7
usingParachuteBonus	= $a8
ankhUsedBonus		= $a9
yarFoundBonus		= $aa
mapRoomBonus		= $ab
thiefShotPenalty		= $ac
mesaLandingBonus	= $ad
UnusedBonus	= $ae
treasureIndex			= $af

entranceRoomState			= $b1
blackMarketState			= $b2
mapRoomState			= $b3
mesaSideState			= $b4
entranceRoomEventState			= $b5
spiderRoomState			= $b6
invSlotLo	= $b7
invSlotHi	= $b8
invSlotLo2	= $b9
invSlotHi2	= $ba
invSlotLo3	= $bb
invSlotHi3	= $bc
invSlotLo4	= $bd
invSlotHi4	= $be
invSlotLo5	= $bf
invSlotHi5	= $c0
invSlotLo6	= $c1
invSlotHi6	= $c2
selectedItemSlot		= $c3
inventoryItemCount			= $c4
selectedInventoryId	= $c5
basketItemsStatus			= $c6
pickupItemsStatus			= $c7
objectPosX			= $c8
indyPosX			= $c9
m0PosX			= $ca
weaponPosX			= $cb
indyPosXSet			= $cc
unused_CD			= $cd
p0PosY			= $ce
indyPosY			= $cf
m0PosY		= $d0
weaponPosY			= $d1	;Weapon vertical position (Whip or Bullet)
ballPosY			= $d2
targetPosY			= $d3
objectState			= $d4
snakePosY			= $d5
timepieceGfxPtrs			= $d6
snakeMotionPtr			= $d7
timepieceSpriteDataPtr			= $d8
indyGfxPtrLo		= $d9
indyGfxPtrHi			= $da
indySpriteHeight			= $db
p0SpriteHeight			= $dc
p0GfxPtrLo		= $dd
p0GfxPtrHi			= $de
objOffsetPosY			= $df
p0GfxState			= $e0
PF1GfxPtrLo		= $e1
PF1GfxPtrHi			= $e2
PF2GfxPtrLo		= $e3
PF2GfxPtrHi			= $e4
dynamicGfxData			= $e5
dungeonBlock1			= $e6
dungeonBlock2			= $e7
dungeonBlock3			= $e8
dungeonBlock4			= $e9
dungeonBlock5			= $ea
savedThiefPosY			= $eb
savedIndyPosY			= $ec
savedIndyPosX			= $ed
thiefPosX			= $ee
;					$ef  (i)
;					$f0  (i)
;					$f1  (i)
;					$f2  (i)

;					$fc  (s)
;					$fd  (s)
;					$fe  (s)
;					$ff  (s)


;--------------------
;sprite heights
;--------------------
HEIGHT_ARK					= 7
HEIGHT_PEDESTAL				= 15
HEIGHT_INDY_SPRITE			= 11
HEIGHT_ITEM_SPRITES	= 8
HEIGHT_PARACHUTING_SPRITE 	= 15
HEIGHT_THIEF				= 16
HEIGHT_KERNEL				= 160



;--------------------
; Inventory Sprite Ids
;--------------------
ID_INVENTORY_EMPTY		= (emptySprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_FLUTE		= (invFluteSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_PARACHUTE	= (invParachuteSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_COINS		= (invCoinsSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_MARKETPLACE_GRENADE	= (marketplaceGrenadeSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_BLACK_MARKET_GRENADE = (blackMarketGrenadeSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_KEY		= (invKeySprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_WHIP		= (invWhipSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_SHOVEL		= (invShovelSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_REVOLVER	= (invRevolverSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_HEAD_OF_RA = (invHeadOfRaSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_TIME_PIECE = (closedTimepieceSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_ANKH		= (invAnkhSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_CHAI		= (invChaiSprite - inventorySprites) / HEIGHT_ITEM_SPRITES
ID_INVENTORY_HOUR_GLASS = (invHourGlassSprite - inventorySprites) / HEIGHT_ITEM_SPRITES


;--------------------
; Room State Values
;--------------------

; Entrance Room status values
INDY_CARRYING_WHIP		= %00000001
GRENADE_OPENING_IN_WALL = %00000010

; Black Market status values
INDY_NOT_CARRYING_COINS = %10000000
INDY_CARRYING_SHOVEL	= %00000001

BASKET_STATUS_MARKET_GRENADE = %00000001
BASKET_STATUS_BLACK_MARKET_GRENADE = %00000010
BACKET_STATUS_REVOLVER	= %00001000
BASKET_STATUS_COINS		= %00010000
BASKET_STATUS_KEY		= %00100000

PICKUP_ITEM_STATUS_WHIP = %00000001
PICKUP_ITEM_STATUS_SHOVEL = %00000010
PICKUP_ITEM_STATUS_HEAD_OF_RA = %00000100
PICKUP_ITEM_STATUS_TIME_PIECE = %00001000
PICKUP_ITEM_STATUS_HOUR_GLASS = %00100000
PICKUP_ITEM_STATUS_ANKH = %01000000
PICKUP_ITEM_STATUS_CHAI = %10000000

PENALTY_GRENADE_OPENING = 2
PENALTY_SHOOTING_THIEF	= 4
PENALTY_ESCAPE_SHINING_LIGHT_PRISON = 13
BONUS_USING_PARACHUTE	= 3
BONUS_LANDING_IN_MESA	= 3
BONUS_FINDING_YAR		= 5
BONUS_SKIP_MESA_FIELD	= 9
BONUS_FINDING_ARK		= 10
BONUS_USING_HEAD_OF_RA_IN_MAPROOM = 14

;--------------------
;rooms
;---------------------

ID_TREASURE_ROOM		 = $00 ;--
ID_MARKETPLACE			 = $01 ; |
ID_ENTRANCE_ROOM		 = $02 ; |
ID_BLACK_MARKET			 = $03 ; | -- JumpIntoStationaryPlayerKernel
ID_MAP_ROOM				 = $04 ; |
ID_MESA_SIDE			 = $05 ;--
ID_TEMPLE_ENTRANCE		 = $06 ;--
ID_SPIDER_ROOM			 = $07 ;  |
ID_ROOM_OF_SHINING_LIGHT = $08 ;  | -- DrawPlayfieldKernel
ID_MESA_FIELD			 = $09 ;  |
ID_VALLEY_OF_POISON		 = $0A ;--
ID_THIEVES_DEN			 = $0B ;-- ThievesDenWellOfSoulsScanlineHandler
ID_WELL_OF_SOULS		 = $0C ;-- ThievesDenWellOfSoulsScanlineHandler
ID_ARK_ROOM				 = $0D

;===============================================================================
; U S E R - C O N S T A N T S
;===============================================================================

BANK0STROBE				= $FFF8
BANK1STROBE				= $FFF9
BANK0_REORG				= $D000
BANK1_REORG				= $F000

BANK0TOP				= $1000
BANK1TOP				= $2000

LDA_ABS					= $AD		; instruction to LDA $XXXX
JMP_ABS					= $4C		; instruction for JMP $XXXX

INIT_SCORE				= 100		; starting score

SET_PLAYER_0_COLOR		= %10000000
SET_PLAYER_0_HMOVE		= %10000001

XMAX					= 160

BULLET_OR_WHIP_ACTIVE 	= %10000000
USING_GRENADE_OR_PARACHUTE = %00000010


ENTRANCE_ROOM_CAVE_VERT_POS = 9
ENTRANCE_ROOM_ROCK_VERT_POS = 53

MAX_INVENTORY_ITEMS		= 6

;***********************************************************
;	bank 0 / 0..1
;***********************************************************

	seg		bank0
	org		BANK0TOP
	rorg	BANK0_REORG

;note: 1st bank's vector points right at the cold start routine
	lda	BANK0STROBE				;trigger 1st bank

coldStart
	jmp		startGame				;cold start


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; setObjPosX
; set object horizontal position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setObjPosX
	ldx		#<RESBL - RESP0					
moveObjectLoop
	sta		WSYNC					; wait for next scan line
	lda		objectPosX,x			; get object's horizontal position
	tay								
	lda		HMOVETable,y	; get fine motion/coarse position value				
	sta		HMP0,x					; set object's fine motion value
	and		#$0f					; mask off fine motion value
	tay								; move coarse move value to y
coarseMoveObj
	dey								
	bpl		coarseMoveObj			; set object's coarse position			
	sta		RESP0,x					
	dex								
	bpl		moveObjectLoop					
	sta		WSYNC					; wait for next scan line
	sta		HMOVE					
	jmp		jmpDisplayKernel					

checkObjectHit:
	bit		CXM1P					; check player collision with Indy bullet 
	bpl		checkWeaponHit		; branch if no player collision				
	ldx		currentRoomId			; get the current screen id				
	cpx		#ID_VALLEY_OF_POISON	; are we in the valley of poison?						
	bcc		checkWeaponHit						
	beq		weaponHitThief		; branch if Indy in the Valley of Poison

	; --------------------------------------------------------------------------
	; CALCULATE STRUCK THIEF INDEX
	; The screen is divided vertically. We use Weapon Y to determine which thief (0-4) was hit.
	; Formula: Index = ((WeaponY + 1) / 16)
	; --------------------------------------------------------------------------


	lda		weaponPosY			; Load Weapon Vertical Position.				
	adc		#$01					; Adjust for offset (Carry set assumed).  
	lsr							; Divide by 2.  
	lsr							; Divide by 4. 
	lsr							; Divide by 8. 
	lsr							; Divide by 16. 
	tax							; Move result (Index 0-3?) to X.

	; --------------------------------------------------------------------------
	; FLIP THIEF DIRECTION
	; Hitting a thief makes them reverse direction.
	; --------------------------------------------------------------------------

	lda		#REFLECT				; Load Reflect Bit.		
	eor		objOffsetPosY,x			; XOR with current state (Toggle Direction).			
	sta		objOffsetPosY,x			; Save new state.			

weaponHitThief:
	lda		weaponStatus			; get bullet or whip status			
	bpl		setThiefShotPenalty	; branch if bullet or whip not active					
	and		#~BULLET_OR_WHIP_ACTIVE						
	sta		weaponStatus			; clear BULLET_OR_WHIP_ACTIVE bit			
	lda		pickupStatusFlags						
	and		#%00011111			; Mask check.			
	beq		finishItemPickup						
	jsr		placeItemInInventory						

finishItemPickup:
	lda		#%01000000		 	; Set Bit 6.					
	sta		pickupStatusFlags
								
setThiefShotPenalty
	; --------------------------------------------------------------------------
	; PENALTY FOR SHOOTING THIEF
	; Killing a thief is dishonorable (or noise?). Deducts score.
	; --------------------------------------------------------------------------
	lda    #~BULLET_OR_WHIP_ACTIVE 	; Clear Active Bit mask.						
	sta		weaponPosY				; Invalidates weapon Y (effectively removing it).			
	lda		#PENALTY_SHOOTING_THIEF 	; Load Penalty Value.					
	sta		thiefShotPenalty					; Apply penalty.

checkWeaponHit:
	bit		CXM1FB					; check missile 1 and playfield collisions
	bpl		weaponObjHit				; if playfield is not hit try snake hit
	ldx		currentRoomId				; get the current screen id						
	cpx		#ID_MESA_FIELD			; are we in the mesa field?
	beq		handleIndyVsObjHit		; see what we hit  			
	cpx		#ID_TEMPLE_ENTRANCE		; are we in the temple entrance?						
	beq		checkDungeonWallHit		; check for dungeon wall hit				
	cpx		#ID_ROOM_OF_SHINING_LIGHT	; are we in the room of shining light?					
	bne		weaponObjHit				; did we hit the snake?
checkDungeonWallHit:
	lda		weaponPosY				; get bullet or whip vertical position						
	sbc		objectState				; subtract dungeon wall height						
	lsr									; divide by 4 total
	lsr								
	beq		handleLeftWall			; if zero, left wall hit
	tax								
	ldy		weaponPosX			; get weapon horizontal position						
	cpy		#$12						
	bcc		clearWeaponState			; branch if too far left			
	cpy		#$8d						
	bcs		clearWeaponState			; branch if too far right			
	lda		#$00						
	sta		dynamicGfxData,x			; zero out dungeon gfx data for wall hit			
	beq		clearWeaponState			; unconditional branch			

handleLeftWall:
	lda		weaponPosX			; get bullet or whip horizontal position						
	cmp		#$30							; Compare it to 48 (left side boundary threshold)
	bcs		handleRighrWall			; If bullet is at or beyond 48, branch to right-side logic			
	sbc		#$10						; Subtract 16 from position 
										; (adjusting to fit into the masking table index range)			
	eor		#$1f							; XOR with 31 to mirror or normalize the range 
										; (helps align to bitmask values)

maskDungeonWall:
	lsr								; Divide by 4 Total				
	lsr									;
	tax									; Move result to X to use as index into mask table
	lda		itemStatusMaskTable,x		; Load a mask value from the 
										; itemStatusMaskTable table 
										; (mask used to disable a wall segment)		
	and		dynamicGfxData			; Apply the mask to the current
										; dungeon graphic state 
										; (clear bits to "erase" part of it)			
	sta		dynamicGfxData			; Store the updated graphic
										; state back (modifying visual representation
										; of the wall)			
	jmp		clearWeaponState			; unconditional branch			

handleRighrWall:
	sbc		#$71							; Subtract 113 from bullet/whip horizontal position
	cmp		#$20							; Compare result to 32
	bcc		maskDungeonWall			; apply wall mask		
clearWeaponState:
	ldy    #~BULLET_OR_WHIP_ACTIVE	; Invert BULLET_OR_WHIP_ACTIVE							
	sty    weaponStatus				; clear BULLET_OR_WHIP_ACTIVE status	 					
	sty    weaponPosY				; set vertical position out of range						
weaponObjHit:
	bit		CXM1FB						; check if snake hit with bullet or whip
	bvc		handleIndyVsObjHit		; branch if object not hit				
	bit		screenEventState									
	bvc		handleIndyVsObjHit						
	lda		#$5a							; set object y position high byte
	sta		ballPosY		; move offscreen (?)						
	sta		p0SpriteHeight							
	sta    weaponStatus				; clear BULLET_OR_WHIP_ACTIVE status					
	sta    weaponPosY						

handleIndyVsObjHit:
	; Handles collision with Snakes, Tsetse Flies, or Items (Time Piece).
	bit		CXP1FB						; Check P1 (Indy) vs Playfield/Ball Collision.
	bvc		handleMesaSideSecretExit	; Branch if no collision (Bit 6 clear).					
	ldx    currentRoomId				; Get Room ID.						
	cpx    #ID_TEMPLE_ENTRANCE		; Are we in Temple Entrance?					
	beq		timePieceTouch			; If yes, handle Time Piece pickup.

	; --- Flute Immunity Check ---
	lda		selectedInventoryId		; Get currently selected item.  
	cmp		#ID_INVENTORY_FLUTE		; Is it the Flute?					
	beq		handleMesaSideSecretExit	; If Flute is selected, IGNORE collision
										; (Immunity to Snakes/Flies)					

	; --- Damage / Effect Logic --
	bit		screenEventState			; Check Event State (Snakes vs Flies?)				
	bpl		setWellOfSoulsEntryEvent	; If Bit 7 is CLEAR, it's a Snake/Lethal
										; Jump to Death Logic.				
	; --- Tsetse Fly Paralysis ---
	; If Bit 7 is SET, it implies Tsetse Flies (Spider Room / Valley).
	lda    secondsTimer				; Get Timer.		
	and		#$07							; Mask for random duration?
	ora		#$80						; Set Bit 7.  
	sta		eventTimer				; Set "Paralysis" Timer (Indy freezes).		
	bne		handleMesaSideSecretExit	; Return.					

setWellOfSoulsEntryEvent:
	bvc		handleMesaSideSecretExit	; Fail-safe?					
	lda		#$80							; Set Bit 7.
	sta		majorEventFlag 			; Trigger Major Event				
	bne		handleMesaSideSecretExit	; Return.					

timePieceTouch:
	lda		timepieceGfxPtrs						
	cmp		#<timeSprite						
	bne		handleMesaSideSecretExit						
	lda		#ID_INVENTORY_TIME_PIECE					
	jsr		placeItemInInventory
						
handleMesaSideSecretExit:
	ldx    #ID_MESA_SIDE					
	cpx    currentRoomId				; are we on the mesa side?				
	bne		dispatchHits				; branch if not  
	bit		CXM0P						; check missile 0 and player collisions
	bpl		handleMesaFall			; branch if Indy not entering WELL_OF_SOULS			
	stx		indyPosY					; set Indy vertical position (i.e. x = 5)						
	lda		#ID_WELL_OF_SOULS									
	sta    currentRoomId				; move Indy to the Well of Souls						
	jsr		initRoomState						
	lda		#(XMAX / 2) - 4						
	sta		indyPosX					; place Indy in horizontal middle  
	bne		clearHits					; unconditional branch  

handleMesaFall:
	ldx		indyPosY					; get Indy vertical position						
	cpx		#$4f							; Compare it to 79 
	bcc		dispatchHits				; If Indy is above this threshold,
										; branch to CheckAndDispatchCollisions
										; (don't fall)		
	lda		#ID_VALLEY_OF_POISON 		; Otherwise, load Valley of Poison						
	sta		currentRoomId 			; Set the current screen to Valley of Poison						
	jsr		initRoomState		; initialize rooom state				
	lda		savedThiefPosY			; get saved thief vertical position						
	sta		objOffsetPosY				; set thief vertical position						
	lda		savedIndyPosY				; get saved Indy vertical position						
	sta		indyPosY					; set Indy vertical position						
	lda		savedIndyPosX				; get saved Indy horizontal position						
	sta		indyPosX					; set Indy horizontal position						
	lda		#$fd							; Load bitmask value
	and		mesaSideState				; Apply bitmask to a status/control flag		
	sta		mesaSideState				; Store the result back 
	bmi		clearHits					; If the result has bit 7 set,
										; skip setting major event  
	lda		#$80							; Otherwise, set major event flag
	sta		majorEventFlag						
clearHits:
	sta		CXCLR							; clear all collisions
dispatchHits:
	bit		CXPPMM						; check player / missile collisions
	bmi		collectTreasure			; branch if player touched treasure 
	ldx		#$00						
	stx		moveDirection				; Clear movement direction						
	dex									; X = $FF
	stx		digAttemptCounter			; Set dig attempt counter to max value						
	rol		pickupStatusFlags						
	clc								
	ror		pickupStatusFlags						
continueToHitDispatch:
	jmp		playerHitDefaut						

collectTreasure:
	lda		currentRoomId				; get the current screen id						
	bne		jumpPlayerHit				; branch if not Treasure Room		
	lda		treasureIndex						
	and		#$07						
	tax								
	lda		marketBasketItems,x		; get items from market basket			
	jsr		placeItemInInventory		; place basket item in inventory				
	bcc		continueToHitDispatch						
	lda		#$01						
	sta		objOffsetPosY					; mark treasure as collected 
	bne		continueToHitDispatch		; unconditional branch				

jumpPlayerHit:
	asl									; multiply screen id by 2
	tax								
	lda		playerHitJumpTable+1,x					
	pha									; push MSB to stack
	lda		playerHitJumpTable,x					
	pha									; push LSB to stack
	rts									; jump to player collision routine

;-playerHitInWellOfSouls
;
; Handles logic when Indy is in the Well of Souls (Room ID 11).
; This is where the GAME WIN condition is triggered.
;
; Win Logic:
; 1. Checks if Indy is at the correct vertical depth (Y >= 63).
; 2. Checks if a specific "digging/action" state is active ($54).
; 3. Checks if Indy is aligned with the Ark's position (arkLocationRegionId == arkImpactRegionId).
; 4. If all true, sets resetEnableFlag to a positive value, which triggers the End Game sequence.


playerHitInWellOfSouls:
	lda		indyPosY					; get Indy's vertical position	
	cmp		#$3f						; Compare it to 63 (Depth Threshold)
	bcc		takeAwayShovel				; If Indy is above this threshold,
										; he hasn't reached the Ark yet  take away shovel		
	lda		diggingState				; Load action/state variable	
	cmp		#$54						; Compare to $54 (Required State/Frame to trigger)
	bne		resumeHitDispatch			; If not equal, nothing special happens			
	lda		arkLocationRegionId			; Load Ark's Position State		
	cmp		arkDigRegionId				; Compare to Indy's calculated region	
	bne		arkNotFound 				; If not lined up with the Ark, skip the win logic

	; --- WIN CONDITION MET ---		
	lda		#INIT_SCORE - 12   			; Load final score modifier ($58 = Positive)						
	sta		resetEnableFlag				; Store it. This Positive value signals
										; ArkRoomKernel to DRAW the Ark.	
	sta		score						; Set the players final adventure score
	jsr		getFinalScore				; Calculate ranking/title based on score		
	lda		#ID_ARK_ROOM				; Set up transition to Ark Room		
	sta		currentRoomId					
	jsr		initRoomState		; Load new screen data for the Ark Room				
	jmp		newFrame 			; Finish frame cleanly and transition visually			

arkNotFound:
	jmp		putIndyInMesaSide						

takeAwayShovel:
	lda		#ID_INVENTORY_SHOVEL						
	bne		takeItemFromInv				; check to remove shovel from inventory		

playerHitInThievesDen:
	lda		#ID_INVENTORY_KEY			; check to remove key from inventory			
	bne		takeItemFromInv						

playerHitInValleyOfPoison:
	lda		#ID_INVENTORY_COINS						
takeItemFromInv:
	bit		pickupStatusFlags 					
	bmi		resumeHitDispatch						
	clc									; Carry clear
	jsr		removeItem					; take away specified item				
	bcs		updateAfterItemRemove						
	sec									; Carry set
	jsr		removeItem						
	bcc		resumeHitDispatch						
updateAfterItemRemove:
	cpy		#$0b						
	bne		setPickupProcessedFlag						
	ror		blackMarketState			; rotate Black Market state right			
	clc								
	rol		blackMarketState			; rotate left to show Indy not carrying Shovel			
setPickupProcessedFlag:
	lda		pickupStatusFlags						
	jsr		updateRoomEventState					 
	tya								
	ora		#$c0						
	sta		pickupStatusFlags						
	bne		resumeHitDispatch			; unconditional branch			

playerHitInSpiderRoom:
	ldx		#$00						; Set X to 0
	stx		spiderRoomState				; Clear spider room state	
	lda		#%10000000					; Set Bit 7						
	sta		majorEventFlag				; Trigger major event flag					
resumeHitDispatch:
	jmp		playerHitDefaut						

playerHitInMesaSide:
	bit		mesaSideState		  		;Check event state flags					
	bvs		continueAfterParachute		; If bit 6 is set, skip parachute logic
										; and resume normal game loop				
	bpl		continueAfterParachute		; If bit 7 is clear, also skip parachute logic				
	lda		indyPosX					; Get Indy's horizontal position
	cmp		#$2b						; Check if Indy is within parachute landing zone
	bcc		removeParachute						
	ldx		indyPosY					; Get Indy's vertical position					
	cpx		#$27						; Check if he is high enough (39)
	bcc		removeParachute				; If not, remove parachute and exit		
	cpx		#$2b						; Check if he is too low (43)
	bcs		removeParachute				; If so, remove parachute and exit 		
	lda		#$40						; Bitmask to clear parachute state
	ora		mesaSideState				; Set that bit in event flag	
	sta		mesaSideState				;  Store it back	
	bne		continueAfterParachute		; Unconditionally resume normal flow				
removeParachute:
	lda		#ID_INVENTORY_PARACHUTE
	sec								
	jsr		removeItem					; carry set...take away selected item	
continueAfterParachute:
	jmp		playerHitDefaut						

playerHitInMarket:
	; This handles collision with the 3 Baskets in the Marketplace.
	; It also handles wall collisions (which might represent people or stalls).
	bit		CXP1FB						; Check P1 (Indy) vs Playfield (Walls/People)
	bpl		indyTouchMarketBaskets		; If NO wall collision,
										; check if he's touching baskets.	

	; --- Wall/Crowd Interaction Logic ---
	; If Indy walks into the "Walls" (likely the decorative stalls or crowd):													
	ldy		indyPosY					; Get Indy's vertical position						
	cpy		#$3a						; Check Vertical Zone (Row $3A)
	bcc		checkIndyYForMarketFlags	; If Y < $3A, Check specific "shoving" zones.

	; Zone 1: Below $3A (Bottom of screen)				
	lda		#$e0						; Mask Top 3 bits
	and		moveDirection				; Preserve current movement		
	ora		#$43						; Force bits 6, 1, and 0 ($43).
	sta		moveDirection				; Set "Bumping/Shoving"	
	jmp		playerHitDefaut		; Resume				

checkIndyYForMarketFlags:
	cpy		#$20						; Check Zone (Row $20)
	bcc		setMarketFlags				; If Y < $20, check top zone.

clearMarketFlags:
	; Zone 2: Between $20 and $3A (Middle path)
	lda		#$00						
	sta		moveDirection				; Clear movement modification flags.		
	jmp		playerHitDefaut		; Resume				

setMarketFlags:
	cpy		#$09						; Check Topmost Boundary ($09)
	bcc		clearMarketFlags			; If Y < $09 (Very top), clear flags.		
	lda		#$e0						; Mask Top 3 bits
	and		moveDirection					
	ora		#$42						; Force bits 6 and 1 ($42).
	sta		moveDirection				; Apply "Shove" physics.	
	jmp		playerHitDefaut		; Resume		

indyTouchMarketBaskets:
	; --- Basket Content Logic ---
	; If we're not touching walls, we check which basket Indy is touching.
	; The item received depends on WHICH basket (Position) and WHEN (Timer? for Ra).
	lda		indyPosY					; Get Indy's vertical position						
	cmp		#$3a						; Check Y-pos against Basket Row
	bcc		notTouchingBottomBasket		; If Y < $3A, check Top Baskets.

	; Bottom Basket: Contains the KEY				
	ldx		#ID_INVENTORY_KEY			; Pre-load Key ID						
	bne		tryAwardHeadOfRa			; Go to award logic (Unconditional branch)			

notTouchingBottomBasket:
	; Top Row Baskets (check X position)
	lda		indyPosX					; Get Indy's horizontal position					
	cmp		#$4c						; Check Middle/Right boundary
	bcs		touchingRightBasket			; If X >= $4C, it's the Right Basket.

	; Left Basket: Contains GRENADES			
	ldx		#ID_MARKETPLACE_GRENADE		; Pre-load Grenade ID						
	bne		tryAwardHeadOfRa			; Go to award logic (Unconditional branch)			

touchingRightBasket:
	; Right Basket: Contains REVOLVER (usually)
	ldx 	#ID_INVENTORY_REVOLVER		; Pre-load Revolver ID

tryAwardHeadOfRa:
	; --- head of Ra ---
	; Sometimes, a basket contains the Head of Ra instead of its usual item.
	lda		#$40						
	sta		screenEventState			; Set flag
	lda		secondsTimer				; get global timer					
	and		#$1f						; Mask to 0-31 seconds cycle
	cmp		#$02						; Check if time is < 2
	bcs		checkAddItemToInv			; If Time >= 2, give the standard item
										; (Key/Grenade/Revolver)			
	ldx		#ID_INVENTORY_HEAD_OF_RA  	; If Time < 2, swap prize to HEAD OF RA!						
checkAddItemToInv:
	jsr		isItemAlreadyTaken			; Check if we already have this specific item					
	bcs		exitGiveItem				; If taken, do nothing.		
	txa									; Move Item ID to A
	jsr		placeItemInInventory		; Add to inventory				
exitGiveItem:
	jmp		playerHitDefaut		; Resume				


playerHitInBlackMarket:
	bit		CXP1FB						; check Indy collision with playfield
	bmi		checkIndyPosForMarketFlags	; branch if Indy collided with playfield					
	lda		indyPosX					; get Indy's horizontal position					
	cmp		#$50						
	bcs		pickMarketItemByTime						
	dec		indyPosX					; move Indy left one pixel					
	rol		blackMarketState			; rotate Black Market state left			
	clc									; clear carry
	ror		blackMarketState			; rotate right to show Indy carrying coins			
resetInteractionFlags:
	lda		#$00						
	sta		moveDirection						

resumeScreenLogic:
	jmp		playerHitDefaut						

pickMarketItemByTime:
	ldx		#ID_BLACK_MARKET_GRENADE  	; Load X with the grenade item ID (for black market)						
	lda		secondsTimer  				; Load the global seconds timer					
	cmp		#$40						; Check if >= 64 seconds have passed
	bcs		checkAddItemToInv			; If yes, continue with grenade			
	ldx		#ID_INVENTORY_KEY  			; If not, switch to the key as the item to give						
	bne		checkAddItemToInv			; Always branch (unconditional jump)			

checkIndyPosForMarketFlags:
	ldy		indyPosY					; get Indy's vertical position						
	cpy		#$44						
	bcc		checkMiddleMarketZone		; If Indy is above row 68, jump to alternate logic				
	lda		#$e0						
	and		moveDirection				; Mask moveDirection to preserve top 3 bits 	
	ora		#%00001011					; Set bits 0, 1, and 3 
setBlackMarketFlags:
	sta		moveDirection		  		; Store the updated value back into moveDirection					
	bne		resumeScreenLogic			; Always branch to resume game logic

checkMiddleMarketZone:
	cpy		#$20						
	bcs		resetInteractionFlags		; If Y = 32, exit via reset logic				
	cpy		#$0b						
	bcc		resetInteractionFlags		; If Y < 11, exit via reset logic				
	lda		#$e0						
	and		moveDirection						
	ora		#%01000001					; Set bits 7 and 0						
	bne		setBlackMarketFlags			; Go apply and resume logic			

playerHitInTempleEntrance:
	inc		indyPosX					; Push Indy right					
	bne		playerHitDefaut		; Resume				

playerHitInEntranceRoom:
	; This routine handles interactions with the central Rock object and whip.
	; The Rock collision pushes Indy left.
	; The Whip (if Y >= 63 triggers pickup).
	lda		indyPosY					; get Indy's vertical position					
	cmp		#$3f						; Check Pickup Threshold >= 63(Is Indy "below" the rock?)
	bcc		checkRockRange		
	
	; --- Whip Pickup Logic ---			
	lda		#ID_INVENTORY_WHIP			; Load Whip Item ID					
	jsr		placeItemInInventory		; Attempt to add to inventory				
	bcc		playerHitDefaut		; If inventory full (Carry Clear), exit				
	ror		entranceRoomState						
	sec								
	rol		entranceRoomState			; Update Room State:		
	lda		#$42						;   Set High Bit of rotated value 
										;   (becomes Bit 0 after roll)
	sta		$df							; Move the Whip to Y=66
	bne		playerHitDefaut		; Resume				

checkRockRange:
	; --- Rock Collision Logic ---
	; Determines if Indy is hitting the solid part of the rock.
	; The Rock seems to have a hole between Y=22 and Y=31
	cmp		#$16						; Top Boundary Check (22)	
	bcc		pushIndyOutOfRock						
	cmp		#$1f						; Bottom Bound of Top Segment
	bcc		playerHitDefaut		; If 22 <= Y < 31, pass-through

	; If Y >= 31 (and < 63 from earlier check), fall through to push left.			
pushIndyOutOfRock:
	dec		indyPosX					; Push Indy Left

playerHitDefaut:
	lda		currentRoomId				; get the current screen id					
	asl									; multiply screen id by 2 (word table)
	tax									; Move the result to X
										; X is the index into a jump table
	bit		CXP1FB						; check Indy collision with playfield
	bpl		screenIdleLogicDispatcher	; If no collision (bit 7 is clear),
										; branch to non-collision handler					
	lda		playfieldHitJumpTable+1,x	; Load high byte of handler address				
	pha									; Push it to the return stack  
	lda		playfieldHitJumpTable,x		; Load low byte of handler address				
	pha									; Push it to the return stack
	rts									; jump to Player / Playfield collision strategy

screenIdleLogicDispatcher:
	lda		roomIdleHandlerJumpTable+1,x	; Load high byte of default screen behavior routine				
	pha									;push to stack
	lda		roomIdleHandlerJumpTable,x		; Load low byte of default screen behavior routine			
	pha									; push to stack
	rts									; Indirect jump to it (no collision case)

warpToMesaSide:
	lda		objOffsetPosY					; Load vertical position of an object 
	sta		savedThiefPosY			; Store it to temp variable savedThiefPosY		
	lda		indyPosY					; get Indy's vertical position
	sta		savedIndyPosY				; Store to temp variable savedIndyVertPo	
	lda		indyPosX					
SaveIndyAndThiefPosition:
	sta		savedIndyPosX				; Store to temp variable savedIndyHorizPos 	
putIndyInMesaSide:
	lda		#ID_MESA_SIDE				; Change screen to Mesa Side	
	sta		currentRoomId					
	jsr		initRoomState					
	lda		#$05					
	sta		indyPosY					; Set Indy's vertical position on entry to Mesa Side
	lda		#$50					
	sta		indyPosX					; Set Indy's horizontal position on entry
	tsx								
	cpx		#$fe					
	bcs		FailSafeToCollisionCheck	;If X = $FE, jump to FailSafeToCollisionCheck				
	rts									; Otherwise, return

FailSafeToCollisionCheck:
	jmp		defaultIdleHandler					


initFallbackEntryPosition:
	bit		mapRoomState									
	bmi		FailSafeToCollisionCheck	; Check status bits					
	lda		#$50						
	sta		savedThiefPosY				; Store a fixed vertical position into savedThiefPosY
	lda		#$41						
	sta		savedIndyPosY				; Store a fixed vertical position into savedIndyPosY						
	lda		#$4c						
	bne		SaveIndyAndThiefPosition	; Store fixed horizontal position
										; and continue to position saving logic					

stopIndyMovInTemple:
	ldy		indyPosX				
	cpy		#$2c						; Is Indy too far left? (< 44)
	bcc		nudgeIndyRight				; Yes, nudge him right		
	cpy		#$6b						; Is Indy too far right? (= 107)
	bcs		nudgeIndyLeft				; Yes, nudge him left		
	ldy		indyPosY					; get Indy's vertical position					
	iny									; Try to move Indy down 1 px
	cpy		#$1e						; Cap at vertical position 30
	bcc		setFrozenPosY				; If not over, continue		
	dey								
	dey									; Else, move Indy up 1 px instead
setFrozenPosY:
	sty		indyPosY		  			; Apply vertical adjustment					
	jmp		setIndyToNormalMove			; Continue to Indy-snake interaction check			

nudgeIndyRight:
	iny								
	iny									; Nudge Indy right 2 px
nudgeIndyLeft:
	dey								
	sty		indyPosX					; Apply horizontal adjustment					
	bne		setIndyToNormalMove			; Continue			

indyPFHitEntranceRoom:
	; Handles collision with Room Walls.
	; Specifically handles the "Grenade Opening" 
	lda		#GRENADE_OPENING_IN_WALL	; check flag: Is the wall blown open? ($02)						
	and		entranceRoomState					
	beq		indyPixelLeft						
	lda		indyPosY					; get Indy's vertical position						
	cmp		#$12						
	bcc		indyPixelLeft				; If Y < 18 (Above Hole), Hit Wall.		
	cmp		#$24						; If 18 <= Y < 36 (Inside Hole), enter hole.
	bcc		indyEnterHole						

indyPixelLeft:
	dec		$c9						
	bne		setIndyToNormalMove						

playerHitInRoomOfShiningLight:
	ldx		#$1a						
	lda		indyPosX					; get Indy horizontal position					
	cmp		#$4c						
	bcc		setIndyInDungeon			; branch if Indy on left of screen			
	ldx		#$7d						
setIndyInDungeon:
	stx		indyPosX					; set Indy horizontal position					
	ldx		#$40						
	stx		indyPosY					; set Indy vertical position					
	ldx		#$ff						
	stx		dynamicGfxData				; restore dungeon graphics	
	ldx		#$01						
	stx		dungeonBlock1					
	stx		dungeonBlock2					
	stx		dungeonBlock3					
	stx		dungeonBlock4					
	stx		dungeonBlock5					
	bne		setIndyToNormalMove			; unconditional branch			

indyMoveOnInput:
	lda		indyDir						; Load movement direction from Indy's direction state
	and		#$0f						; Isolate lower 4 bits (D-pad direction)
	tay									; Use as index
	lda		indyMoveDeltaTable,y		; Get movement delta from direction lookup table			
	ldx		#<indyPosY - p0PosY 	; X = offset to Indy in object array						
	jsr		getMoveDir					; Move Indy accordingly

setIndyToNormalMove:
	lda		#$05						
	sta		soundChan0EffectTimer		; Set Indy walk state	
	bne		defaultIdleHandler			; unconditional branch		

indyEnterHole:
	rol		playerInputState					
	sec								
	bcs		undoInputBitShift			; unconditional branch			

setIndyToTriggeredState:
	rol		playerInputState					
	clc								

undoInputBitShift:
	ror		playerInputState					

defaultIdleHandler:
	bit		CXM0P						; check player collisions with missile0
	bpl		checkGrenadeDetonation		; branch if didn't collide with Indy			
	ldx		currentRoomId				; get the current screen id	
	cpx		#ID_SPIDER_ROOM				; Are we in the Spider Room?	
	beq		clearInputBit0ForSpiderRoom	; Yes, go to clearInputBit0ForSpiderRoom				
	bcc		checkGrenadeDetonation		; If screen ID is lower than Spider Room, skip 			
	lda		#$80						; Trigger a major event (Death/Capture)
	sta		majorEventFlag				; Set flag.	
	bne		despawnMissile0				; unconditional branch

clearInputBit0ForSpiderRoom:
	rol		playerInputState			; Rotate input left, bit 7 ? carry		
	sec									; Set carry (overrides carry from rol)
	ror		playerInputState			; Rotate right, carry -> bit 7 (bit 0 lost)		
	rol		spiderRoomState				; Rotate a status byte left (bit 7 ? carry)	
	sec									; Set carry (again overrides whatever came before)
	ror		spiderRoomState				; Rotate right, carry -> bit 7 (bit 0 lost)	
despawnMissile0:
	lda		#$7f					
	sta		m0PosYShadow				; Possibly related state or shadow position	
	sta		m0PosY						; Move missile0 offscreen (to y=127)

checkGrenadeDetonation:
	bit		grenadeState				; Check status flags	
	bpl		newFrame 				; If bit 7 is clear, skip (no grenade active)	
	bvs		applyGrenadeWallEffect		; If bit 6 is set, jump			
	lda		secondsTimer				; get seconds time value	 
	cmp		grenadeCookTime				; compare with grenade detination time	
	bne		newFrame 				; branch if not time to detinate grenade	
	lda		#$a0					
	sta		weaponPosY				; Move grenade offscreen 	
	sta		majorEventFlag				; Trigger major event (explosion happened)	
applyGrenadeWallEffect:
	lsr		grenadeState				; Logical shift right: bit 0 -> carry	
	bcc		skipUpdate					; If bit 0 was clear, skip this
										; (grenade effect not triggered)
	lda		#GRENADE_OPENING_IN_WALL					
	sta		grenadeOpeningPenalty		; Apply penalty (e.g., reduce score)			
	ora		entranceRoomState			; Mark the entrance room as 		
	sta		entranceRoomState			; having the grenade opening		
	ldx		#ID_ENTRANCE_ROOM					
	cpx		currentRoomId					
	bne		updateEntranceRoomEventState ; branch if not in the ENTRANCE_ROOM					
	jsr		initRoomState		; Update visuals/state to reflect the wall opening			
updateEntranceRoomEventState:
	lda		entranceRoomEventState					
	and		#$0f					
	beq		skipUpdate					; If no condition active, exit
	lda		entranceRoomEventState					
	and		#$f0						; Clear lower nibble
	ora		#$01						; Set bit 0
	sta		entranceRoomEventState		; Store updated state			
	ldx		#ID_ENTRANCE_ROOM					
	cpx		currentRoomId					
	bne		skipUpdate					; branch if not in the ENTRANCE_ROOM
	jsr		initRoomState		; Refresh screen visuals			
skipUpdate
	sec								
	jsr		removeItem					; carry set...take away selected item

newFrame:
	lda		INTIM					
	bne		newFrame 					
startNewFrame
	lda		#START_VERT_SYNC					
	sta		WSYNC						; wait for next scan line
	sta		VSYNC						; start vertical sync (D1 = 1)
	lda		#$50					
	cmp		weaponPosY					
	bcs		updateTimers					
	sta		weaponPosX					
updateTimers
	inc		frameCount					; increment frame count
	lda		#$3f					
	and		frameCount					; every 63 frames
	bne		firstLineOfVerticalSync		; branch if roughly 60 frames haven't passed
	inc		secondsTimer				; increment every second
	lda		eventTimer					; If eventTimer is positive, skip
	bpl		firstLineOfVerticalSync					
	dec		eventTimer					; Else, decrement it
firstLineOfVerticalSync
	sta		WSYNC						; Wait for start of next scanlineCounter
	bit		resetEnableFlag					
	bpl		frameFirstLine						
	ror		SWCHB						; rotate RESET to carry
	bcs		frameFirstLine				; branch if RESET not pressed		
	jmp		startGame					; If RESET was pressed, restart the game 

frameFirstLine
	sta		WSYNC						;wait for first sync
	lda		#STOP_VERT_SYNC				;load a for VSYNC pause
	ldx		#VBLANK_TIME				
	sta		WSYNC						; last line of vertical sync
	sta		VSYNC						; end vertical sync (D1 = 0)
	stx		TIM64T						; set timer for vertical blanking period
	ldx		majorEventFlag					
	inx									; Increment counter
	bne		checkShowDevInitials		; If not overflowed, check initials display
	stx		majorEventFlag				; Overflowed: zero -> set majorEventFlag to 0	
	jsr		getFinalScore				; set score to minimum
	lda		#ID_ARK_ROOM				; set ark title screen 
	sta		currentRoomId				; to the current room
	jsr		initRoomState		; Transition to Ark Room			
gotoArkRoomLogic:
	jmp		setupScreenAndObj					

checkShowDevInitials:
	lda		currentRoomId				; get teh room number
	cmp		#ID_ARK_ROOM				; are we in the ark room? 
	bne		HandleEasterEgg				; branch if not in ID_ARK_ROOM	
	lda		#$9c					
	sta		soundChan1EffectTimer					
	ldy		yarFoundBonus				; check if yar was found
	beq		checkEasterEggFail			; If not in Yar's Easter Egg mode, skip
	bit		resetEnableFlag					
	bmi		checkEasterEggFail			; If resetEnableFlag has bit 7 set, skip		
	ldx		#>devInitialsGfx0			; get programmer initials part 1 high byte
	stx		invSlotHi					; put address in slot 1 high byte
	stx		invSlotHi2					; put address in slot 2 high byte
	lda		#<devInitialsGfx0			; get programmer initials low byte
	sta		invSlotLo					; put in slot 1 low byte
	lda		#<devInitialsGfx1			; get programmer initials part 2 low byte
	sta		invSlotLo2					; put in slot 2 low byte
checkEasterEggFail:
	ldy		indyPosY					; get Indy's vertical position
	cpy		#$7c						; 124 levels
	bcs		setIndyArkDescentState		; If Indy is below or at Y=$7C (124), skip			
	cpy		score				
	bcc		slowlyLowerIndy				; If Indy is higher up than his point score, skip	
	bit		INPT5|$30					; read action button from right controller
	bmi		gotoArkRoomLogic			; branch if action button not pressed		
	jmp		startGame					; RESET game if button *is* pressed 

slowlyLowerIndy:
	lda		frameCount					; get current frame count
	ror									; shift D0 to carry
	bcc		gotoArkRoomLogic			; branch on even frame		
	iny									; Move Indy down by 1 pixel
	sty		indyPosY					
	bne		gotoArkRoomLogic			; unconditional branch	

setIndyArkDescentState
	bit		resetEnableFlag				; Check bit 7 of resetEnableFlag	
	bmi		checkArkInput				; If bit 7 is set, skip (reset enabled)	
	lda		#$0e					
	sta		soundChan0EffectTimer				; Set Indys state to 0E	

checkArkInput
	lda		#$80						
	sta		resetEnableFlag				; Set bit 7 to enable reset logic	
	bit		INPT5|$30					; Check action button on right controller
	bmi		gotoArkRoomLogic			; If not pressed, skip		
	lda		frameCount					; get current frame count
	and		#$0f						; Limit to every 16th frame
	bne		setArkActionCode			; If not at correct frame, skip		
	lda		#$05					
setArkActionCode
	sta		arkLocationRegionId			; Store action/state code		
	jmp		initGameVars				; Clear game variables 

HandleEasterEgg
	bit		screenEventState					
	bvs		advanceArkSeq				; If bit 6 set, jump to alternate path	
continueArkSeq
	jmp		checkMajorEventDone					

advanceArkSeq
	lda		frameCount					; get current frame count
	and		#$03						; Only act every 4 frames
	bne		configSnake					; If not, skip
	ldx		p0SpriteHeight				 
	cpx		#$60					
	bcc		incrementArkSeq				; If sprite height < $60, branch	
	bit		majorEventFlag					
	bmi		continueArkSeq				; If bit 7 is set, jump to continue logic	
	ldx		#$00						; Reset X 
	lda		indyPosX					
	cmp		#$20					
	bcs		setIndyArkLevel				; If Indy is right of x=$20, skip
	lda		#$20					
setIndyArkLevel
	sta		indyPosXSet				; Store Indys forced horizontal position?
incrementArkSeq
	inx								
	stx		p0SpriteHeight				; Increment and store progression
	txa								
	sec								
	sbc		#$07						; Subtract 7 to control pacing
	bpl		snakeMove					
	lda		#$00					
snakeMove
	; This routine controls the Snake (or Dungeon Entrance Guardian).
	; The Snake is drawn using the BALL sprite (`ENABL`).
	; Its "Shape" is created by modifying the Horizontal Motion (`HMBL`) 
	; on every scanline, causing the ball to "wiggle" as it is drawn.

	sta		ballPosY			; Store A (Timer/Counter-based Y) into objPosY
	and		#$f8						; Mask to coarse vertical steps
	cmp		snakePosY					; Compare with current visual Y
	beq		configSnake					; If vertical alignment hasn't changed,
										; skip movement update
	sta		snakePosY					; Update snake's vertical position

	; --- Calculate Horizontal Steering ---
	; The snake steers towards Indy.
	lda		objectState					; Load state (movement/animation frame)
	and		#$03						; Mask low 2 bits (Animation Frame 0-3)
	tax									; X = Frame ID
	lda		objectState					; Load state again
	lsr									; Shift 4 times to get upper nibble (Direction)
	lsr								
	tay									; Y = Steering Mode
	lda		snakePosXOffsetTable,x		; Get base sway offset			
	clc								
	adc		snakePosXOffsetTable,y		; Add Steering offset			
	clc								
	adc		indyPosXSet				; Add Indy's X position (Snake follows Indy)

	; --- Check Boundaries and Distance ---		
	ldx		#$00						; Default Steering Adjustment
	cmp		#$87						; Right Boundary Check
	bcs		adjSnakePosByDistance		; If > $87, skip logic			
	cmp		#$18						; Left Boundary Check
	bcc		checkIfFlipSnakeDir			; If < $18, force flip		
	sbc		indyPosX					; Calculate distance to Indy
	sbc		#$03						; Minus 3 pixels
	bpl		adjSnakePosByDistance		; If positive skip			
checkIfFlipSnakeDir
	inx									; X = 1
	inx									; X = 2 (Reverse direction/sway)
	eor		#$ff						; Invert delta

adjSnakePosByDistance:
	cmp		#$09						; Check proximity to Indy
	bcc		updateSnakeMove				; If < 9 pixels away (Very Close),
										; don't change state height	
	inx									; Else increments X (Change Sway intensity)

updateSnakeMove
	txa									; Move Sway/Steering Factor to A
	asl								
	asl								
	sta		loopCounter					; Store in loopCounter as Upper Nibble
	lda		objectState					
	and		#$03					
	tax								
	lda		snakePosXOffsetTable,x					
	clc								
	adc		indyPosXSet					; Set base position towards Indy
	sta		indyPosXSet

	; --- Resolve Final State ---					
	lda		objectState					
	lsr								
	lsr								
	ora		loopCounter					; Combine new Steering Factor
										; (High Nibble) with old state		
	sta		objectState					; Save

configSnake
	; Sets up the pointers for the Bank 1 Kernel to draw the "Wiggling Ball".
	lda		objectState					
	and		#$03						; Frame 0-3
	tax								
	lda		snakeMoveTableLSB,x			; Get Low Byte of Motion Table for this frame		
	sta		timepieceGfxPtrs			; Store in Pointer (reused $D6)		
	lda		##>snakeMotionTable0		; High Byte is fixed 			
	sta		snakeMotionPtr				; Store High Byte

	; Calculate Vertical Offset/Sprite Index	
	lda		objectState					
	lsr								
	lsr								
	tax								
	lda		snakeMoveTableLSB,x			; Look up another table value		
	sec								
	sbc		#$08						; Subtract 8 lines (Height of snake)
	sta		timepieceSpriteDataPtr		; Store as Sprite Data Pointer			

checkMajorEventDone
	bit		majorEventFlag				
	bpl		checkGameScriptTimer		; If major event not complete
										; continue sequence	
	jmp		jmpRoomHandler				; Else, jump to end	

checkGameScriptTimer
	bit		eventTimer					
	bpl		branchOnFrameParity			; If timer still counting or inactive, proceed		
	jmp		setIndyStandSprite		; Else, jump to alternate script path			

branchOnFrameParity
	lda		frameCount					; get current frame count
	ror									; Test even/odd frame
	bcc		gatePlayerTriggeredEvent	; If even, continue next step				
	jmp		clearItemUseOnButtonRelease	; If odd, do something else				

gatePlayerTriggeredEvent
	ldx		currentRoomId				; get the current screen id	
	cpx		#ID_MESA_SIDE				
	beq		stopWeaponEvent				; If on Mesa Side, use a different handler		
	bit		eventState					
	bvc		checkInputAndStateForEvent	; If no event/collision flag set, skip				
	ldx		weaponPosX					; get bullet or whip horizontal position
	txa								
	sec								
	sbc		indyPosX					
	tay									; Y = horizontal distance between Indy
										; and projectile
	lda		SWCHA						; read joystick values
	ror									; shift right joystick UP value to carry
	bcc		checkWeaponRangeAndDir		; branch if right joystick pushing up		
	ror									; shift right joystick DOWN value to carry
	bcs		stopWeaponEvent				; branch if right joystick not pushed down	
	cpy		#$09					
	bcc		stopWeaponEvent				; If too close to projectile, skip	
	tya									
	bpl		nudgeProjectileLeft			; If projectile is to the right of Indy,
										; continue		
nudgeProjectileRight
	inx								
	bne		setProjectilePos					
nudgeProjectileLeft
	dex								
setProjectilePos
	stx		weaponPosX					
	bne		stopWeaponEvent				; Exit if projectile has nonzero position		
checkWeaponRangeAndDir
	cpx		#$75					
	bcs		stopWeaponEvent				; Right bound check
	cpx		#$1a					
	bcc		stopWeaponEvent				; Left bound check	
	dey								
	dey								
	cpy		#$07					
	bcc		stopWeaponEvent				; Too close vertically	
	tya								
	bpl		nudgeProjectileRight		; If projectile right of Indy, nudge right			
	bmi		nudgeProjectileLeft			; Else, nudge left
			
checkInputAndStateForEvent
	bit		mesaSideState					
	bmi		stopWeaponEvent				; If flag set, skip	
	bit		playerInputState					
	bpl		handleIndyMove				; If no button, skip	
	ror								
	bcc		handleIndyMove				; If no button, skip	
stopWeaponEvent
	jmp		HandleIInventorySelect					

handleIndyMove
	ldx		#<indyPosY - p0PosY		; Get index of Indy in object list					
	lda		SWCHA						; read joystick values
	sta		tempGfxHolder				; Store raw joystick input		
	and		#P1_NO_MOVE					
	cmp		#P1_NO_MOVE					
	beq		stopWeaponEvent				; Skip if no movement	
	sta		indyDir					
	jsr		getMoveDir					; Move Indy according to input 
	ldx		currentRoomId				; get the current screen id	
	ldy		#$00					
	sty		loopCounter					; Reset scan index/counter 
	beq		setIndyPosForEvent			; Unconditional (Y=0, so BNE not taken)		
incEventScanIndex
	tax									; Transfer A to X 
	inc		loopCounter					; increase index
setIndyPosForEvent
	lda		indyPosX					
	pha									; Temporarily store horizontal position
	lda		indyPosY					; get Indy's vertical position
	ldy		loopCounter					; Load current scan/event index
	cpy		#$02					
	bcs		reversePosOrder				; If index >= 2, store in reverse order	
	sta		bankSwitchJMPOpcode			; Vertical position		
	pla								
	sta		bankSwitchJMPAddr			; Horizontal position		
	jmp		applyEventOffsetToIndy					

reversePosOrder
	sta		bankSwitchJMPAddr			; Vertical -> $87		
	pla								
	sta		bankSwitchJMPOpcode			; Horizontal -> $86		
applyEventOffsetToIndy
	ror		tempGfxHolder				; Rotate player input to extract direction	
	bcs		checkScanBoundaryOrContinue	; If carry set, skip
	jsr		CheckRoomOverrideCondition	; Run event/collision subroutine				
	bcs		triggerScreenTransition		; If failed/blocked, exit			
	bvc		checkScanBoundaryOrContinue	; If no vertical/horizontal event flag, skip				
	ldy		loopCounter					; Event index
	lda		roomEventOffsetTable,y		; Get movement offset from table			
	cpy		#$02					
	bcs		applyHorizontalOffset		; If index = 2, move horizontally
	adc		indyPosY					
	sta		indyPosY					
	jmp		checkScanBoundaryOrContinue					

applyHorizontalOffset
	clc								
	adc		indyPosX					
	sta		indyPosX					
checkScanBoundaryOrContinue
	txa								
	clc								
	adc		#$0d						; Offset for object range or screen width
	cmp		#$34					
	bcc		incEventScanIndex			; If still within bounds, continue scanning		
	bcs		HandleIInventorySelect		; Else, exit

triggerScreenTransition
	sty		currentRoomId				; Set new screen based on event result	
	jsr		initRoomState		; Load new room or area

HandleIInventorySelect
	bit		INPT4|$30					; read action button from left controller
	bmi		normalizeplayerInput		; branch if action button not pressed			
	bit		grenadeState					
	bmi		ExitItemHandler				; If game state prevents interaction, skip	
	lda		playerInputState					
	ror									; Check bit 0 of input
	bcs		handleIInventoryUpdate		; If set, already mid-action, skip			
	sec									; Prepare to take item
	jsr		removeItem					; carry set...take away selected item
	inc		playerInputState			;  Advance to next inventory slot		
	bne		handleIInventoryUpdate		; Always branch			
normalizeplayerInput
	ror		playerInputState					
	clc								
	rol		playerInputState					
handleIInventoryUpdate
	lda		moveDirection					
	bpl		ExitItemHandler				; If no item queued, exit	
	and		#$1f					
	cmp		#$01					
	bne		checkShovelPickup					
	inc		bulletCount					; Give Indy 3 bullets
	inc		bulletCount					 
	inc		bulletCount					 
	bne		clearItemUseFlag					
checkShovelPickup
	cmp		#$0b					
	bne		placeGenericItem					
	ror		blackMarketState			; rotate Black Market state right		
	sec									; set carry
	rol		blackMarketState			; rotate left to show Indy carrying Shovel		
	ldx		#$45					
	stx		objOffsetPosY					; Set Y-pos for shovel on screen
	ldx		#$7f					
	stx		m0PosY				
placeGenericItem
	jsr		placeItemInInventory					
clearItemUseFlag
	lda		#$00					
	sta		moveDirection				; Clear item pickup/use state	
ExitItemHandler
	jmp		updateIndyParachuteSprite					

clearItemUseOnButtonRelease
	bit		grenadeState				; Test game state flags	
	bmi		ExitItemHandler				; If bit 7 is set (N = 1), 
										; then a grenade or parachute event
										; is in progress.	
	bit		INPT5|$30					; read action button from right controller
	bpl		handleItemUse				; branch if action button pressed	
	lda		#~USING_GRENADE_OR_PARACHUTE ; Load inverse of USING_GRENADE_OR_PARACHUTE
										;(i.e., clear bit 1)					
	and		playerInputState			; Clear the USING_GRENADE_OR_PARACHUTE bit
										; from the player input state		
	sta		playerInputState			; Store the updated input state		
	jmp		updateIndyParachuteSprite					

handleItemUse
	lda		#USING_GRENADE_OR_PARACHUTE ; Load the flag indicating item use
										; (grenade/parachute)					
	bit		playerInputState			; Check if the flag is already set in player input		
	bne		exitItemUseHandler			; If it's already set, skip re-setting (item already active)		
	ora		playerInputState			; Otherwise, set the USING_GRENADE_OR_PARACHUTE bit		
	sta		playerInputState			; Save the updated input state		
	ldx		selectedInventoryId			; get the current selected inventory id		
	cpx		#ID_MARKETPLACE_GRENADE  	; Is the selected item the marketplace grenade?					
	beq		startGrenadeThrow			; If yes, jump to grenade activation logic		
	cpx		#ID_BLACK_MARKET_GRENADE 	; If not, is it the black market grenade?					
	bne		checkToActivateParachute	; If neither, check if it's a parachute				
startGrenadeThrow
	ldx		indyPosY					; get Indy's vertical position
	stx		weaponPosY					; Set grenade's starting vertical position
	ldy		indyPosX					; get Indy horizontal position
	sty		weaponPosX					; Set grenade's starting horizontal position
	lda		secondsTimer				; get the seconds timer	 
	adc		#5 - 1						; increment value by 5...carry set					
	sta		grenadeCookTime				; detinate grenade 5 seconds from now	
	lda		#$80						; Prepare base grenade state value (bit 7 set)
	cpx		#ENTRANCE_ROOM_ROCK_VERT_POS  ; Is Indy below the rock's vertical line?					
	bcs		setGrenadeState					
	cpy		#$64						; Is Indy too far left?
	bcc		setGrenadeState					
	ldx		currentRoomId				; get the current screen id	
	cpx		#ID_ENTRANCE_ROOM			; Are we in the Entrance Room?		
	bne		setGrenadeState			; branch if not in the ENTRANCE_ROOM		
	ora		#$01						; Set bit 0 to trigger wall explosion effect
setGrenadeState
	sta		grenadeState				; Store the grenade state flags: 
										; Bit 7 set: grenade is active
										; Bit 0 optionally set: triggers 
										; wall explosion if conditions were met	
	jmp		updateIndyParachuteSprite					

checkToActivateParachute
	cpx		#ID_INVENTORY_PARACHUTE  	; Is the selected item the parachute?					
	bne		handleSpecialItemUseCases	; If not, branch to other item handling				
	stx		usingParachuteBonus			; Store the parachute usage flag for scoring bonus	
	lda		mesaSideState				; Load major event and state flags	
	bmi		exitItemUseHandler			; If bit 7 is set (already parachuting),
										; skip reactivation		
	ora		#$80						; Set bit 7 to indicate parachute is now active
	sta		mesaSideState				; Save the updated event flags	
	lda		indyPosY					; get Indy's vertical position
	sbc		#$06						; move Indy up 6 pixels to account for parachute deployment
	bpl		fixParachuteStartY			; If the result is positive, keep it		
	lda		#$01						; If subtraction underflows, cap position to 1
fixParachuteStartY
	sta		indyPosY					
	bpl		finalizeImpact				; unconditional branch		
handleSpecialItemUseCases
	bit		eventState					; Check special state flags
	bvc		attemptArkDig			; If bit 6 is clear , skip to further checks		
	bit		CXM1FB|$30					; Check collision between missile 1 and playfield
	bmi		CalculateImpactRegionIndex	; If collision occurred (bit 7 set),
										; go to handle collision impact				
	jsr		warpToMesaSide				; No collision  warp Indy to Mesa Side
exitItemUseHandler
	jmp		updateIndyParachuteSprite					

CalculateImpactRegionIndex
	lda		weaponPosY					; get bullet or whip vertical position
	lsr									; Divide by 2 (fine-tune for tile mapping)
	sec									; Set carry for subtraction
	sbc		#$06						; Subtract 6 (offset to align to tile grid)
	clc									; Clear carry before next addition
	adc		objOffsetPosY					; Add reference vertical offset (likely floor or map tile start)
	lsr									; Divide by 16 total:
	lsr									; Effectively: (Y - 6 + objectVertOffset) / 16
	lsr								
	lsr								
	cmp		#$08					 	; Check if the result fits within bounds (max 7)
	bcc		hookAndMoveIndy				; If less than 8, jump to store the index	
	lda		#$07						; Clamp to max value (7) if out of bounds
hookAndMoveIndy						
	sta		loopCounter					; Store the region index calculated from vertical position
	lda		weaponPosX					; get bullet or whip horizontal position
	sec								
	sbc		#$10						; Adjust for impact zone alignment
	and		#$60						; Mask to relevant bits (coarse horizontal zone)
	lsr								
	lsr									; Divide by 4  convert to tile region
	adc		loopCounter					; Combine with vertical region index to form a unique map zone index
	tay									; Move index to Y
	lda		ArkRoomImpactResponseTable,y	; Lookup impact response based on calculated region index				
	sta		arkDigRegionId				; Store result	
	ldx		weaponPosY					; get bullet or whip vertical position
	dex									; Decrease projectile X by 2  simulate impact offset
	stx		weaponPosY					
	stx		indyPosY					; Sync Indy's vertical position to projectiles new position
	ldx		weaponPosX					
	dex									; Decrease projectile X by 2  simulate impact offset
	dex								
	stx		weaponPosX					
	stx		indyPosX					; Sync Indy's horizontal position to projectiles new position
	lda		#$46						; Set special state value
	sta		eventState					; Likely a flag used by event logic
finalizeImpact
	jmp		triggerWhipEffect			; Jump to item-use or input continuation logic		

attemptArkDig
	cpx		#ID_INVENTORY_SHOVEL		; Is the selected item the shovel?					
	bne		ankhWarpToMesa				; If not, skip to other item handling	
	lda		indyPosY					; get Indy's vertical position
	cmp		#$41						; Is Indy deep enough to dig?
	bcc		exitItemUseHandler			; If not, exit (can't dig here)		
	bit		CXPPMM|$30					; check player / missile collisions
	bpl		exitItemUseHandler			; branch if players didn't collide		
	inc		digAttemptCounter			; Increment dig attempt counter		
	bne		exitItemUseHandler			; If not the first dig attempt, exit		
	ldy		diggingState				; Load current dig depth or animation frame	
	dey									; Decrease depth
	cpy		#$54						; Is it still within range?
	bcs		clampDigDepth						; If at or beyond max depth, cap it
	iny									; Otherwise restore it back (prevent negative values)
clampDigDepth
	sty		diggingState				; Save the clamped or unchanged dig depth value	
	lda		#BONUS_FINDING_ARK					
	sta		findingArkBonus				; Set the bonus for having found the Ark		 
	bne		exitItemUseHandler			; unconditional branch		
ankhWarpToMesa
	cpx		#ID_INVENTORY_ANKH			; Is the selected item the Ankh?					
	bne		handleWeaponUseOnMove		; If not, skip to next item handling			
	ldx		currentRoomId				; get the current screen id	
	cpx		#ID_TREASURE_ROOM			; Is Indy in the Treasure Room?		
	beq		exitItemUseHandler			; If so, don't allow Ankh warp from here		
	lda		#ID_MESA_FIELD				; Mark this warp use 	
	sta		ankhUsedBonus				; set to reduce score by 9 points
	sta		currentRoomId				; Change current screen to Mesa Field	
	jsr		initRoomState		; Load the data for the new screen			
	lda		#$4c						; Prepare a flag or state value for later use
	;Warp Indy to center of Mesa Field
	sta		indyPosX					; Set Indy's horizontal position
	sta		weaponPosX					; Set projectile's horizontal position
	lda		#$46						; Fixed vertical position value (mesa starting Y)
	sta		indyPosY					; Set Indy's vertical position
	sta		weaponPosY					; Set projectile's vertical position
	sta		eventState					; Set event/state flag0
	lda		#$1d						; Set initial Y for object
	sta		objOffsetPosY					; set object vertical position
	bne		updateIndyParachuteSprite	; Unconditional jump to common handler				

handleWeaponUseOnMove
	lda		SWCHA						; read joystick values
	and		#P1_NO_MOVE					; Mask to isolate movement bits					
	cmp		#P1_NO_MOVE					
	beq		updateIndyParachuteSprite	; branch if right joystick not moved				
	cpx		#ID_INVENTORY_REVOLVER					
	bne		checkUsingWhip				; check for Indy using whip
	bit		weaponStatus				; check bullet or whip status	
	bmi		updateIndyParachuteSprite	; branch if bullet active				
	ldy		bulletCount					; get number of bullets remaining
	bmi		updateIndyParachuteSprite	; branch if no more bullets				
	dec		bulletCount					; reduce number of bullets 
	ora		#BULLET_OR_WHIP_ACTIVE					
	sta		weaponStatus				; set BULLET_OR_WHIP_ACTIVE bit	
	lda		indyPosY					; get Indy's vertical position
	adc		#$04						; Offset to spawn bullet slightly above Indy
	sta		weaponPosY					; Set bullet Y position
	lda		indyPosX					
	adc		#$04						; Offset to spawn bullet slightly ahead of Indy
	sta		weaponPosX					; Set bullet X position
	bne		triggerWhipEffect			; unconditional branch		

checkUsingWhip
	cpx		#ID_INVENTORY_WHIP			; Is Indy using the whip?					
	bne		updateIndyParachuteSprite	; branch if Indy not using whip				
	ora		#$80						; Set a status bit (bit 7) to indicate whip is active
	sta		eventState					; Store it in the game state/event flags
	ldy		#$04						; Default vertical offset (X)
	ldx		#$05						; Default horizontal offset (Y)
	ror									; shift MOVE_UP to carry
	bcs		checkWhipDownDirection					
	ldx		#<-6						; If pressing up, set vertical offset					
checkWhipDownDirection
	ror									; shift MOVE_DOWN to carry
	bcs		checkWhipLeftDirection		; branch if not pushed down			
	ldx		#$0f						; If pressing down, set vertical offset
checkWhipLeftDirection
	ror									; shift MOVE_LEFT to carry
	bcs		checkWhipRightDirection		; branch if not pushed left			
	ldy		#<-9						; If pressing left, set horizontal offset
checkWhipRightDirection
	ror									; shift MOVE_RIGHT to carry
	bcs		applyWhipStrikePosition		; branch if not pushed right			
	ldy		#$10						; If pressing right, set horizontal offset
applyWhipStrikePosition
	tya									; Move horizontal offset (Y) into A
	clc								
	adc		indyPosX					
	sta		weaponPosX					; Add to Indys current horizontal position
	txa									; Move vertical offset (X) into A
	clc								
	adc		indyPosY					; Add to Indys current vertical position
	sta		weaponPosY					; Set whip strike vertical position
triggerWhipEffect
	lda		#$0f						; Set effect timer for whip (15 frames)
	sta		soundChan1EffectTimer			; Animate or time whip	
updateIndyParachuteSprite
	bit		mesaSideState				; Check game status flags	
	bpl		setIndySpriteIfStill		; If parachute bit (bit 7) is clear,
										; skip parachute rendering			
	lda		#<ParachutingIndySprite		; Load low byte of parachute sprite address					
	sta		indyGfxPtrLo					; Set Indy's sprite pointer
	lda		#HEIGHT_PARACHUTING_SPRITE	; Load height for parachuting sprite					
	bne		setIndySpriteHeight					
setIndySpriteIfStill
	lda		SWCHA						; read joystick values
	and		#P1_NO_MOVE					; Mask movement input
	cmp		#P1_NO_MOVE					
	bne		updateIndyWalkCycle			; If any direction is pressed, skip
										; (Indy is moving)	
setIndyStandSprite
	lda		#<IndyStandSprite			; Load low byte of pointer to stationary sprite			
setIndySpriteLSBValue
	sta		indyGfxPtrLo					; Store sprite pointer (low byte)		
	lda		#<HEIGHT_INDY_SPRITE		; Load low byte of pointer to stationary sprite					
setIndySpriteHeight
	sta		indySpriteHeight			; Store sprite height		
	bne		handleMesaScroll			; unconditional branch		

updateIndyWalkCycle
	lda		#$03						; Mask to isolate movement input flags
										; (e.g., up/down/left/right)
	bit		playerInputState							
	bmi		checkAnimationTiming		; If bit 7 (UP) is set, skip right shift			
	lsr									; Shift movement bits
										; (to vary animation speed/direction)
checkAnimationTiming
	and		frameCount					; Use frameCount to time animation updates
	bne		handleMesaScroll			; If result is non-zero, do Mesa scroll handling		
	lda		#HEIGHT_INDY_SPRITE			; Load height for walking sprite		
	clc								
	adc		indyGfxPtrLo					; Advance to next sprite frame
	cmp		#<IndyStandSprite			; Check if we've reached the end of walkcycle					
	bcc		setIndySpriteLSBValue		; If not, update walking frame			
	lda		#$02						; Set a short animation timer
	sta		soundChan1EffectTimer					
	lda		#<Indy_0					; Reset animation back to first walking frame					
	bcs		setIndySpriteLSBValue		; Unconditional jump to store new sprite pointer


handleMesaScroll
	ldx		currentRoomId				; get the current screen id		
	cpx		#ID_MESA_FIELD				; are we on the Mesa Field?	
	beq		checkScrollEligibility		; Yes, check if we need to scroll
	cpx		#ID_VALLEY_OF_POISON		; Do check if we are in Valley of Poison too			
	bne		jmpRoomHandler			; If neither, continue to Bank 1 routines
checkScrollEligibility
	lda		frameCount					; get current frame count
	bit		playerInputState			; Check movement input flags		
	bpl		scrollIfInZone				; If bit 7 of playerInputState is clear 
	lsr								
scrollIfInZone
	ldy		indyPosY					; get Indy's vertical position			
	cpy		#$27						; Check Lower Bound 
	beq		jmpRoomHandler			; ; If at bottom, stop scrolling

	ldx		objOffsetPosY					; Load Scroll Offset	
	bcs		reverseScrollIfApplicable	; if pushing up 				
	beq		jmpRoomHandler			; if objOffsetPosY is zero, skip scrolling		
	inc		indyPosY					; Increment Indy's vertical position	
	inc		weaponPosY					; Move Weapon DOWN with him
	and		#$02						; Check Frame Timing every 2 frames
	bne		jmpRoomHandler			; if not time to scroll, skip			

	; These variables are modified but overridden in Bank 1 for display.
	dec		objOffsetPosY					; Decrement scroll offset
	inc		p0PosY					 
	inc		m0PosY				
	inc		ballPosY		
	inc		p0PosY					 
	inc		m0PosY				
	inc		ballPosY		
	jmp		jmpRoomHandler					

reverseScrollIfApplicable
	cpx		#$50						; Check Upper Bound
	bcs		jmpRoomHandler			; If at top, stop scrolling	
	dec		indyPosY					; Move Indy UP
	dec		weaponPosY					; Move Weapon UP
	and		#$02						; Frame Timer check
	bne		jmpRoomHandler					

	inc		objOffsetPosY										
	dec		p0PosY					 
	dec		m0PosY				
	dec		ballPosY		
	dec		p0PosY					 
	dec		m0PosY				
	dec		ballPosY		

jmpRoomHandler
	lda		#<selectRoomHandler			; Load low byte of Bank 1 Kernel address	
	sta		bankSwitchJMPAddrLo			; Store in Bank Switch JMP Addr Low		
	lda		#>selectRoomHandler			; Load high byte of Bank 1 Kernel address	
	sta		bankSwitchJMPAddrHi			; Store in Bank Switch JMP Addr High
	jmp		jumpToBank1					; Jump to Bank 1 Kernel

setupScreenAndObj
	lda		screenInitFlag				; Check status flag	
	beq		setRoomAttr					; If zero, skip subroutine 
	jsr		updateRoomEventState		; Run special screen setup routine		
	lda		#$00						; Clear the flag afterward
setRoomAttr
	sta		screenInitFlag				; Store the updated flag
	ldx		currentRoomId				; get the current room id	
	lda		HMOVETable,x					
	sta		NUSIZ0						; Set object sizing/horizontal motion control
	lda		roomPFControlFlags					
	sta		CTRLPF						; Set playfield control flags
	lda		roomBGColorTable,x					
	sta		COLUBK						; set current room background color
	lda		roomPFColorTable,x					
	sta		COLUPF						; set current room playfield color
	lda		roomP0ColorTable,x					
	sta		COLUP0						; Set current room Player 0 color (enemies)
	lda		indyColorValues,x					
	sta		COLUP1						; Set indy's color for this room
	cpx		#ID_THIEVES_DEN				; Is this the Thieves' Den?					
	bcc		placeObjectPosX					
	lda		#$20					
	sta		objectState					; set object state value					
	ldx		#$04					

SetupThievesDenObjects
	; --------------------------------------------------------------------------
	; INITIALIZE THIEVES POSITIONS
	; Uses a lookup table to set initial HMOVE values for 5 thieves.
	; --------------------------------------------------------------------------
	ldy		dynamicGfxData,x			; Get index.
	lda		HMOVETable,y				; Load X position from table.
	sta		thiefPosX,x					; Store
	dex									; Next thief.
	bpl		SetupThievesDenObjects		; Loop through all Thieves' Den
										; enemy positions			
placeObjectPosX
	jmp		setObjPosX					

initArkRoomObjPos
	lda		#$4d						; Set Indy's X position in the Ark Room
	sta		indyPosX					
	lda		#$48					
	sta		objectPosX					; Set object X position					 
	lda		#$1f					
	sta		indyPosY					; Set Indy's Y position in the Ark Room
	rts								

clearGameStateMem
	ldx		#$00						; Start at index 0		
	txa									; A also 0
clearStateLoop
	sta		objOffsetPosY,x					; Clear object state array
	sta		p0GfxState,x				
	sta		PF1GfxPtrLo,x					
	sta		PF1GfxPtrHi,x				
	sta		PF2GfxPtrLo,x					
	sta		PF2GfxPtrHi,x				
	txa									; Check accumulator value
	bne		exitStateClear				; If A ? 0, exit		
	ldx		#$06						; Prepare to re-run loop with X = 6
	lda		#$14						; Now set A = 20
	bne		clearStateLoop				; Unconditional loop to write new value	
exitStateClear
	lda		#$fc						; Load setup value	
	sta		snakeMotionPtr				; Store it to a specific control variable	
	rts									; Return from subroutine

initRoomState
; Initialize the screen state, loading graphics, setting positions, and resetting flags.
; This is called when entering a new room or restarting a room.
	lda		grenadeState				; Load grenade/parachute state.		
	bpl		resetRoomFlags				; If bit 7 is clear (not active),
										; skip setting the "warped/re-entered" flag.	
	ora		#$40						; Set bit 6 to indicate re-entry or warp status.
	sta		grenadeState				; Update the state.	
resetRoomFlags
	lda		#$5c						; Load default value for digging state
	sta		diggingState					
	ldx		#$00						; Initialize X to 0 for clearing.
	stx		screenEventState			; Clear screen event state.
	stx		spiderRoomState				; Clear spider room state.	
	stx		m0PosYShadow				; Clear shadow variable for missile Y Position
	stx		unused_90					; Clear unknown flag at $90
	lda		pickupStatusFlags			; Load pickup flags.		
	stx		pickupStatusFlags			; Clear pickup flags.
	jsr		updateRoomEventState		; Update room event counters/offsets.		
	rol		playerInputState			; Rotate input flags
	clc								
	ror		playerInputState			; Reverse the bit rotation
										; keeps input state consistent	
	ldx		currentRoomId				; Load the current room ID into X.	
	lda		PFControlTable,x			; Set playfield control flags
										; (reflection, priority) based on table.		
	sta		roomPFControlFlags					
	cpx		#ID_ARK_ROOM				; Is this the Ark Room?					
	beq		initArkRoomObjPos			; then jump to special setup	
	cpx		#ID_MESA_SIDE				; Is this the Mesa Side?					
	beq		loadRoomGfx					; skip clear and go to load graphics.
	cpx		#ID_WELL_OF_SOULS			; Is this the Well of Souls?					
	beq		loadRoomGfx					; skip clear and go to load graphics.
	lda		#$00					
	sta		arkDigRegionId				; CLear Ark location	

loadRoomGfx
	;Load the graphics for the current room
	lda		p0GfxDataLo,x			
	sta		p0GfxPtrLo					; Set low byte of sprite pointer for P0
	lda		p0GfxDataHi,x					
	sta		p0GfxPtrHi					; Set high byte of sprite pointer for P0
	lda		p0SpriteHeightData,x					
	sta		p0SpriteHeight				; Set sprite height for P0	 
	lda		objectPosXTable,x				
	sta		objectPosX					; Set default object X position 
	lda		m0PosXTable,x					
	sta		m0PosX						; Set default missile X position
	lda		m0PosYTable,x					
	sta		m0PosY						; Set default missile Y position
	cpx		#ID_THIEVES_DEN				; Are we in the Thieves' Den?	
	bcs		clearGameStateMem			; jump to clear game state memory.	
	adc		roomSpecialTable,x			; set special behavior flags for room		
	sta		p0GfxState					; put into p0GfxState
	lda		PF1GfxDataLo,x					
	sta		PF1GfxPtrLo					; Load PF1 graphics pointer LSB.
	lda		PF1GfxDataHi,x					
	sta		PF1GfxPtrHi					; Load PF1 graphics pointer MSB.
	lda		PF2GfxDataLo,x					
	sta		PF2GfxPtrLo					; Load PF2 graphics pointer LSB.
	lda		PF2GfxDataHi,x					
	sta		PF2GfxPtrHi					; Load PF2 graphics pointer MSB.
	lda		#$55					
	sta		ballPosY			; Init object vertical parameter
	sta		weaponPosY					; Reset Weapon vertical parameter
	cpx		#ID_TEMPLE_ENTRANCE			; If Temple Entrance or later,		
	bcs		initTempleAndShiningLight	; jump to specific initialization.				
	lda		#$00						; Load 0
	cpx		#ID_TREASURE_ROOM			; Is this the Treasure Room?					
	beq		setTreasureRoomObjPosY		; Special setup for Treasure Room.			
	cpx		#ID_ENTRANCE_ROOM					
	beq		setEntranceRoomObjPosY		; Special setup for Enterance Room.			
	sta		p0PosY					 
setObjPosY
	ldy		#$4f						; Load default vertical offset ($4F).
	cpx		#ID_ENTRANCE_ROOM			; If ID < Entrance Room				
	bcc		finishScreenInit			; keep default and return.	
	lda		treasureIndex,x				; Load treasure index
	ror									; Rotate bit 0 into carry.
	bcc		finishScreenInit			; If carry clear, use default offset.		
	ldy		roomObjPosYTable,x			; Load room-specific vertical offset.	
	cpx		#ID_BLACK_MARKET			; if Black Market or later,	
	bne		finishScreenInit			; use loaded offset and return.		
	lda		#$ff						; Load $FF
	sta		m0PosY						; Hide Missile 0 (off-screen).
finishScreenInit
	sty		objOffsetPosY					; Store the final vertical object
	rts									; Return from subroutine.

setTreasureRoomObjPosY
	lda		treasureIndex				; Load screen control byte
	and		#$78						; Mask off all but bits 3-6
	sta		treasureIndex				; Save the updated control state	
	lda		#$1a					
	sta		p0PosY					; Set Y Pos for the top object 
	lda		#$26					
	sta		objOffsetPosY					; Set vertical position for the bottom object
	rts									; Return 

setEntranceRoomObjPosY
	lda		entranceRoomState					
	and		#$07					
	lsr									; shift value right
	bne		setEntranceRoomTopObjPos	; branch if wall opening present
	ldy		#$ff					
	sty		m0PosY				
setEntranceRoomTopObjPos
	tay									; Transfer A (index) to Y
	lda		entranceRoomTopObjPosY,y	; Look up Y-position for top object				
	sta		p0PosY					 
	jmp		setObjPosY					

initTempleAndShiningLight
	cpx		#ID_ROOM_OF_SHINING_LIGHT	; Is this the Room of Shining Light?					
	beq		initRoomOfShiningLight		; If so, jump to its specific init routine		
	cpx		#ID_TEMPLE_ENTRANCE			; If not, is it the Temple Entrance?					
	bne		initMesaFieldScrollState	; If neither, skip this routine				
	ldy		#$00					
	sty		timepieceSpriteDataPtr		; Clear timepiece sprite data pointer			
	ldy		#$40					
	sty		dynamicGfxData				; Set visual reference for top dungeon gfx	
	bne		ConfigTempleOrShiningLightGfx	;Always taken				

initRoomOfShiningLight
	ldy		#$ff					
	sty		dynamicGfxData				; Top of dungeon should render so light is "behind"		
	iny									; y = 0
	sty		timepieceSpriteDataPtr		; Possibly clear temple or environmental state			
	iny									; y = 1
ConfigTempleOrShiningLightGfx
	sty		dungeonBlock1				; render dungeon wall blocks	
	sty		dungeonBlock2					
	sty		dungeonBlock3					
	sty		dungeonBlock4					
	sty		dungeonBlock5					
	ldy		#$39					
	sty		objectState					; Likely a counter or timer
	sty		snakePosY					; Set snake enemy Y-position baseline
initMesaFieldScrollState
	cpx		#ID_MESA_FIELD				; Is this the Mesa Field?					
	bne		finishRoomSpecificInit		; If not Mesa Field, skip			
	ldy		indyPosY					; get Indy's vertical position
	cpy		#$49						; If Indy is "Above" the scroll line
	bcc		finishRoomSpecificInit					
	lda		#$50					
	sta		objOffsetPosY					; start scrolling from bottom
	rts									; return

finishRoomSpecificInit
	lda		#$00					
	sta		objOffsetPosY					; Clear Scroll Offset
	rts									; complete screen init

CheckRoomOverrideCondition
	ldy		roomOverrideTable,x			; Load room override index based on
										; current screen ID			
	cpy		bankSwitchJMPOpcode			; Compare with current override 		
	beq		applyOverrideIfMatch		; If it matches, apply special overrides			
	clc									; Clear carry (no override occurred)
	clv									; Clear overflow 
	rts									; Exit with no overrides

applyOverrideIfMatch
	ldy		posYOverrideFlagTable,x		; Load vertical override flag				
	bmi		checkOverrideConditions		; If negative, skip overrides and return 			
checkPosYlOverride
	lda		roomPosYOverrideTable,x		; Load vertical position override (if any)		
	beq		applyPosXOverride			; If zero, skip vertical positioning		
applyPosYOverride
	sta		indyPosY					; Apply vertical override to Indy
applyPosXOverride
	lda		roomPosXOverrideTable,x		; Load horizontal position override			
	beq		rtsWithOverride				; If zero, skip horizontal positioning	
	sta		indyPosX					; Apply horizontal override to Indy
rtsWithOverride
	sec									; Set carry to indicate an override was applied
	rts									; Return to caller

checkOverrideConditions
	iny									; Bump Y from previous Y override
	beq		rtsNoOverrideSideEffect		; If it was $FF, return early			
	iny								
	bne		evalRangeXOverride			; If not $FE, jump to advanced evaluation
	; Case where Y = $FE
	ldy		overrideLowXBoundTable,x	; Load lower horizontal boundary			
	cpy		bankSwitchJMPAddr			; Compare with current horizontal state		
	bcc		cmpWithExtRoomThreshold		; If below lower limit, use another check			
	ldy		overrideHighXBoundTable,x	; Load upper horizontal boundary			
	bmi		checkFlagforFixedY			; If negative, apply default vertical		
	bpl		checkPosYlOverride			; Always taken  go check vertical override	

cmpWithExtRoomThreshold
	ldy		advOverrideControlTable,x	; Load alternate override flag				
	bmi		checkFlagforFixedY			; If negative, jump to handle special override		
	bpl		checkPosYlOverride			; Always taken		
evalRangeXOverride
	lda		bankSwitchJMPAddr			; Load current horizontal position		
	cmp		overrideLowXBoundTable,x	; Compare with lower limit				
	bcc		rtsNoOverrideSideEffect					
	cmp		overrideHighXBoundTable,x	; Compare with upper limit				
	bcs		rtsNoOverrideSideEffect					
	ldy		advOverrideControlTable,x	; Load override control byte				
	bpl		checkPosYlOverride			; If positive, allow override		
checkFlagforFixedY
	iny								
	bmi		eventStateOverride			; If negative, special flag check		
	ldy		#$08						; Use a fixed override value
	bit		treasureIndex				; Check room flag register	
	bpl		checkPosYlOverride			; If bit 7 is clear, proceed		
	lda		#$41						
	bne		applyPosYOverride			; Always taken  apply forced vertical position		
eventStateOverride
	iny								
	bne		overrideEventStateLess10	; Always taken unless overflowed				
	lda		entranceRoomEventState					
	and		#$0f						; Mask to lower nibble
	bne		rtsNoOverrideSideEffect		; If any bits set, don't override			
	ldy		#$06					
	bne		checkPosYlOverride			; Always taken		
overrideEventStateLess10
	iny								
	bne		inputFinalOverride			; Continue check chain		
	lda		entranceRoomEventState					
	and		#$0f					
	cmp		#$0a					
	bcs		rtsNoOverrideSideEffect					
	ldy		#$06					
	bne		checkPosYlOverride			; Always taken	
inputFinalOverride
	iny								
	bne		checkHeadOfRaAlign			; Continue to final check		
	ldy		#$01					
	bit		playerInputState					
	bmi		checkPosYlOverride			; If fire button pressed, allow override		
rtsNoOverrideSideEffect
	clc									; Clear carry to signal no override
	bit		NoOpRTS						; Dummy BIT used for timing/padding

NoOpRTS
	rts	

checkHeadOfRaAlign
	iny									; Increment Y (conditional trigger)	
	bne		rtsNoOverrideSideEffect		; If Y was not zero before, exit early		
	ldy		#$06						; Load override index value into Y
	lda		#ID_INVENTORY_HEAD_OF_RA	; Load ID for the Head of Ra item				
	cmp		selectedInventoryId			; compare with current selected inventory id		
	bne		rtsNoOverrideSideEffect		; branch if not holding Head of Ra		
	bit		INPT5|$30					; read action button from right controller
	bmi		rtsNoOverrideSideEffect		; branch if action button not pressed			
	jmp		checkPosYlOverride			; All conditions met: apply vertical override		

removeItem
	ldy		inventoryItemCount			; get number of inventory items		
	bne		dropInvIentoryItem					; branch if Indy carrying items
	clc									; clear carry (indicates no item removed)
	rts									; Return (nothing to do)

dropInvIentoryItem
	bcs		clearInventorySlot					
	tay									; move item id to be removed to y
	asl									; multiply value by 8 to get graphic LSB
	asl								
	asl								
	ldx		#$0a						; Start from the last inventory slot
dropItemLoop
	cmp		invSlotLo,x					; Compare target LSB value to 
										; current inventory slot	
	bne		checkNextItem				; If not a match, try the next slot	
	cpx		selectedItemSlot					
	beq		checkNextItem					
	dec		inventoryItemCount			; reduce number of inventory items	
	lda		##<emptySprite				; place empty sprite in inventory
	sta		invSlotLo,x	
	cpy		#$05						; If item index is less than 5,
										; skip clearing pickup flag
	bcc		FinishItemRemoval
; Remove pickup status bit if this is a non-basket item					
	tya									; Move item ID to A
	tax									; move item id to x
	jsr		setItemAsNotTaken			; Update pickup/basket flags to
										; show it's no longer taken		
	txa									; X -> A
	tay									; And back to Y for further use
FinishItemRemoval
	jmp		finishInventorySelect					

checkNextItem
	dex									; Move to previous inventory slot
	dex									; Each slot is 2 bytes (pointer to sprite)
	bpl		dropItemLoop				; If still within bounds, continue checking	
	clc									; Clear carry  no matching item was found
	rts									; Return (nothing removed)

clearInventorySlot
	lda		#ID_INVENTORY_EMPTY			; load blank space
	ldx		selectedItemSlot			; get slot at current position
	sta		invSlotLo,x					; put empy item in current slot
	ldx		selectedInventoryId			; is the current object
	cpx		#ID_INVENTORY_KEY			; the key?
	bcc		handleInventoryRemove		; If not jump to handler
	jsr		setItemAsNotTaken			; Else, mark as "Not Taken" 
										; so it respawns in original room	

handleInventoryRemove
	txa									; move inventory id to accumulator
	tay									; move inventory id to y
	asl									; multiple inventory id by 2
	tax								
	lda		dropItemTable-1,x			; Load specific drop handler High Byte		
	pha									; push MSB to stack
	lda		dropItemTable-2,x			; Load specific drop handler Low Byte
	pha									; push LSB to stack
	ldx		currentRoomId				; get the current room id
	rts									; jump to Remove Item strategy from stack

dropParachute:
	lda		#$3f						; Mask to clear bit 6 (parachute active flag)	
	and		mesaSideState				; Remove parachute bit from game state flag
	sta		mesaSideState					
finishDrop:
	jmp		dropItem			; Go to general item removal cleanup				

dropGrappleItem:
	stx		eventState	   				; Store current room ID
										; (cheking for Mesa Field)						
	lda		#$70						; set X position to offscreen
	sta		weaponPosY					; move grapple crosshair offscreen
	bne		finishDrop					; Unconditional jump

dropChai:
	; --------------------------------------------------------------------------
	; CHAI DROP HANDLER
	; The Chai is part of the "Yar's Revenge" Easter Egg.
	; If dropped with a specific movement vector ($42), it triggers a warp and bonuses.
	; --------------------------------------------------------------------------
	lda 	#$42						; Check for specific movement direction command.						
	cmp		moveDirection				; Check if player is pushing against boundary?						
	bne		checkMarketYar				; If not $42, skip the main warp.	

	; --------------------------------------------------------------------------
	; MARKETPLACE / BLACK MARKET WARP
	; If the $42 condition is met, Indy is warped to the Black Market.
	; --------------------------------------------------------------------------
	lda		#ID_BLACK_MARKET			; Load Black Market ID.						
	sta		currentRoomId				; Change Room.						
	jsr		initRoomState				; Initialize new room state.	
	lda		#$15						; Set Indy X (Entrance).
	sta		indyPosX
	lda		#$1c						; Set Indy Y	
	sta		indyPosY						
	bne		dropItem						

checkMarketYar:
	cpx		#ID_MARKETPLACE_GRENADE		; Are we removing a Grenade?						
	bne		dropItem			; If NOT Grenade (is chai) just drop it.			
	lda		#BONUS_FINDING_YAR			; Set Yar bonus flag					
	cmp		arkDigRegionId				; Check if Yar bonus already awarded.						
	bne		dropItem			
	; Award Yar bonus		
	sta		yarFoundBonus					
	lda		#$00						
	sta		$ce							; Clear sprite
	lda		#$02						
	ora		mesaSideState				; Set Mesa Side State Bit 1		
	sta		mesaSideState						
	bne		dropItem						

dropWhip:
	ror		entranceRoomState			; rotate entrance room state right						
	clc									; clear carry
	rol		entranceRoomState			; rotate left to show Whip not taken
										; by Indy (Restore State)						
	cpx		#ID_ENTRANCE_ROOM									
	bne		finishWhipDrop						
	lda		#$4e						
	sta		objOffsetPosY					; Reset Whip position below rock					
finishWhipDrop:
	bne		dropItem					; unconditional branch			

dropShovel:
	ror		blackMarketState			; Clear lowest bit to indicate Indy
										; is no longer carrying the shovel						
	clc									; Clear carry (ensures bit 7 won't
										; be set on next instruction)
	rol		blackMarketState			; Restore original order of
										; bits with bit 0 cleared						
	cpx		#ID_BLACK_MARKET			; Is Indy currently in the Black Market?						
	bne		finishShovelDrop			; If not, skip 			
	lda		#$4f						
	sta		objOffsetPosY					; Reset Shovel position						
	lda		#$4b						
	sta		m0PosY						
finishShovelDrop:
	bne		dropItem						

dropCoins:
	ldx		currentRoomId				; get the current screen id					
	cpx		#ID_BLACK_MARKET			; are we in the Black Market?						
	bne		finishCoinDrop						
	lda		indyPosX					; get Indy's horizontal position					
	cmp		#$3c						; Check if Indy is on the Left side 
	bcs		finishCoinDrop						
	rol		blackMarketState			; rotate Black Market state left			
	sec									; set carry (Successful Purchase)
	ror		blackMarketState			; rotate right to clear coin flag	
finishCoinDrop:
	lda		moveDirection						
	clc								
	adc		#$40						; Update UI/event state 
	sta		moveDirection

dropItem:
	dec		inventoryItemCount			; reduce number of inventory items			
	bne		selectNextAvailableItem				; branch if Indy has remaining items		
	lda		#ID_INVENTORY_EMPTY						
	sta		selectedInventoryId			; clear the current selected invendory id
	beq		finishInventorySelect		; unconditional branch				

selectNextAvailableItem:
	ldx		selectedItemSlot			; get selected inventory index		
nextItemIndex:
	inx									; increment by 2 to compensate for word pointer
	inx								
	cpx		#$0b						
	bcc		selectNextItem						
	ldx		#$00						; wrap around to the beginning
selectNextItem:
	lda		invSlotLo,x		 			; get inventory graphic LSB value
	beq		nextItemIndex				; branch if nothing in the inventory location		
	stx		selectedItemSlot			; set inventory index			
	lsr								
	lsr								
	lsr								
	sta		selectedInventoryId			; set inventory id
finishInventorySelect
	lda		#$0d						; Possibly sets UI state
	sta		soundChan0EffectTimer					
	sec									; Set carry to indicate success
	rts								

	.byte	$00,$00,$00				; $dafd (*)


HMOVETable
	.byte MSBL_SIZE1 | ONE_COPY		; Treasure Room
	.byte MSBL_SIZE1 | ONE_COPY		; Marketplace
	.byte MSBL_SIZE8 | DOUBLE_SIZE	; Entrance Room
	.byte MSBL_SIZE2 | ONE_COPY		; Black Market
	.byte MSBL_SIZE2 | QUAD_SIZE	; Map Room
	.byte MSBL_SIZE8 | ONE_COPY		; Mesa Side
	.byte MSBL_SIZE1 | ONE_COPY		; Temple Entrance
	.byte MSBL_SIZE1 | ONE_COPY		; Spider Room
	.byte MSBL_SIZE1 | ONE_COPY		; Room of Shining Light
	.byte MSBL_SIZE1 | ONE_COPY		; Mesa Field
	.byte MSBL_SIZE1 | ONE_COPY		; Valley of Poison
	.byte MSBL_SIZE1 | ONE_COPY		; Thieves Den
	.byte MSBL_SIZE1 | ONE_COPY		; Well of Souls
	.byte MSBL_SIZE1 | DOUBLE_SIZE	; Ark Room

COARSE_MOTION SET 0

	.byte HMOVE_0  | COARSE_MOTION, HMOVE_0	| COARSE_MOTION, HMOVE_R1 | COARSE_MOTION
	.byte HMOVE_R2 | COARSE_MOTION, HMOVE_R3 | COARSE_MOTION, HMOVE_R4 | COARSE_MOTION
	.byte HMOVE_R5 | COARSE_MOTION, HMOVE_R6 | COARSE_MOTION, HMOVE_R7 | COARSE_MOTION

	REPEAT 8

COARSE_MOTION SET COARSE_MOTION + 1

	.byte HMOVE_L7 | COARSE_MOTION, HMOVE_L6 | COARSE_MOTION, HMOVE_L5 | COARSE_MOTION
	.byte HMOVE_L4 | COARSE_MOTION, HMOVE_L3 | COARSE_MOTION, HMOVE_L2 | COARSE_MOTION
	.byte HMOVE_L1 | COARSE_MOTION, HMOVE_0	| COARSE_MOTION, HMOVE_R1 | COARSE_MOTION
	.byte HMOVE_R2 | COARSE_MOTION, HMOVE_R3 | COARSE_MOTION, HMOVE_R4 | COARSE_MOTION
	.byte HMOVE_R5 | COARSE_MOTION, HMOVE_R6 | COARSE_MOTION, HMOVE_R7 | COARSE_MOTION	

	REPEND	
COARSE_MOTION SET 9
	.byte HMOVE_L7 | COARSE_MOTION, HMOVE_L6 | COARSE_MOTION, HMOVE_L5 | COARSE_MOTION
	



PFControlTable
	.byte MSBL_SIZE2 | PF_REFLECT					; Treasure Room
	.byte MSBL_SIZE2 | PF_REFLECT					; Marketplace
	.byte MSBL_SIZE2 | PF_REFLECT					; Entrance Room
	.byte MSBL_SIZE2 | PF_REFLECT					; Black Market
	.byte MSBL_SIZE8 | PF_REFLECT					; Map Room
	.byte MSBL_SIZE2 | PF_REFLECT					; Mesa Side
	.byte MSBL_SIZE4 | PF_PRIORITY | PF_REFLECT		; Temple Entrance
	.byte MSBL_SIZE1 | PF_PRIORITY | PF_REFLECT		; Spider Room
	.byte MSBL_SIZE1 | PF_PRIORITY | PF_REFLECT		; Room of the Shining Light
	.byte MSBL_SIZE1 | PF_REFLECT					; Mesa Field
	.byte MSBL_SIZE1 | PF_REFLECT					; Valley of Poison
	.byte MSBL_SIZE1 | PF_PRIORITY | PF_REFLECT		; Thieves Den
	.byte MSBL_SIZE1 | PF_PRIORITY | PF_REFLECT		; Well of Souls
	.byte MSBL_SIZE1 | PF_REFLECT					; Ark Room



roomBGColorTable
	.byte BLACK						; Treasure Room
	.byte LT_RED + 4				; Marketplace
	.byte LT_BLUE + 6				; Entrance Room
	.byte LT_RED + 2				; Black Market
	.byte DK_BLUE + 2				; Map Room
	.byte BROWN + 12				; Mesa Side
	.byte BLACK						; Temple Entrance
	.byte BLACK						; Spider Room
	.byte BLACK						; Room of the Shining Light
	.byte DK_BLUE + 2				; Mesa Field
	.byte YELLOW + 2				; Valley of Poison
	.byte BLACK						; Thieves Den
	.byte BROWN + 8					; Well of Souls
	.byte BLACK						; Ark Room

roomPFColorTable
	.byte BLACK + 8					; Treasure Room
	.byte LT_RED + 2				; Marketplace
	.byte BLACK + 8					; Entrance Room
	.byte BLACK						; Black Market
	.byte YELLOW + 10				; Map Room
	.byte LT_RED + 8				; Mesa Side
	.byte GREEN + 8					; Temple Entrance
	.byte LT_BROWN + 8				; Spider Room
	.byte BLUE + 10					; Room of the Shining Light
	.byte YELLOW + 10				; Mesa Field
	.byte GREEN + 6					; Valley of Poison
	.byte BLACK						; Thieves Den
	.byte LT_RED + 8				; Well of Souls
	.byte DK_BLUE + 8				; Ark Room

indyColorValues
	.byte GREEN + 12				; Treasure Room
	.byte LT_BROWN + 10				; Marketplace Room
	.byte DK_PINK + 10				; Entrance Room
	.byte LT_RED + 6				; Black Market
	.byte LT_BLUE + 14				; Map Room
	.byte GREEN_BLUE + 6			; Mesa Side
	.byte DK_BLUE + 12				; Temple Entrance

roomP0ColorTable
	.byte BLUE + 8					; Treasure Room
	.byte LT_RED + 8				; Marketplace Room
	.byte BROWN + 8					; Entrance Room - Whip
	.byte ORANGE +10				; Black Market - Shovel
	.byte LT_RED + 6				; Map Room - Marker
	.byte GREEN_BLUE + 8			; Mesa Side - Indy Parachute

p0SpriteHeightData
	.byte $CC						; Treasure Room
	.byte $CE 						; Marketplace
	.byte $4A						; Entrance Room
	.byte $98						; Black Market
	.byte $00						; Map Room
	.byte $00						; Mesa Side
	.byte $00						; Temple Entrance
	.byte $08						; Spider Room
	.byte $07						; Room of the Shining Light
	.byte $01						; Mesa Field
	.byte $10						; Valley of Poison

objectPosXTable
	.byte	$78,$4c,$5d,$4c,$4f,$4c,$12,$4c 
	.byte	$4c,$4c,$4c,$12,$12	

p0GfxDataHi
	.byte >TreasureRoomPlayerGraphics
	.byte >MarketplacePlayerGraphics
	.byte >EntranceRoomPlayerGraphics
	.byte >BlackMarketPlayerGraphics
	.byte >MapRoomPlayerGraphics
	.byte >MesaSidePlayerGraphics
	.byte $FA
	.byte $00
	.byte >ShiningLightSprites
	.byte >emptySprite
	.byte >thiefSprites
	.byte >thiefSprites
	.byte >thiefSprites

p0GfxDataLo
	.byte <TreasureRoomPlayerGraphics
	.byte <MarketplacePlayerGraphics
	.byte <EntranceRoomPlayerGraphics
	.byte <BlackMarketPlayerGraphics
	.byte <MapRoomPlayerGraphics
	.byte <MesaSidePlayerGraphics
	.byte $C1
	.byte $E5
	.byte <ShiningLightSprites
	.byte <emptySprite
	.byte <thiefSprites
	.byte <thiefSprites
	.byte <thiefSprites



snakeMoveTableLSB
	.byte <snakeMotionTable0,<snakeMotionTable1,<snakeMotionTable3,<snakeMotionTable2
	


snakePosXOffsetTable:
	.byte	$fe,$fa,$02,$06	

roomSpecialTable
	.byte	$00,$00,$18,$04,$03,$03,$85,$85,$3b,$85,$85	

m0PosXTable
	.byte	$20					
	.byte	$78					
	.byte	$85					
	.byte	$4d					
	.byte	$62					
	.byte	$17					
	.byte	$50					
	.byte	$50					
	.byte	$50					
	.byte	$50					
	.byte	$50					
	.byte	$12					
	.byte	$12					


m0PosYTable
	.byte	$ff
	.byte	$ff
	.byte	$14
	.byte	$4b
	.byte	$4a
	.byte	$44
	.byte	$ff
	.byte	$27
	.byte	$ff
	.byte	$ff
	.byte	$ff
	.byte	$f0
	.byte	$f0	


PF1GfxDataLo
	.byte <COLUP0,<COLUP0,<COLUP0,<COLUP0,<COLUP0,<COLUP0,<RoomPF1GraphicData_7,<RoomPF1GraphicData_8,<RoomPF1GraphicData_9,<RoomPF1GraphicData_10,<RoomPF1GraphicData_10

PF1GfxDataHi
	.byte >COLUP0,>COLUP0,>COLUP0,>COLUP0,>COLUP0,>COLUP0,>RoomPF1GraphicData_7,>RoomPF1GraphicData_8,>RoomPF1GraphicData_9,>RoomPF1GraphicData_10,>RoomPF1GraphicData_10
	
PF2GfxDataLo
	.byte <HMP0,<HMP0,<HMP0,<HMP0,<HMP0,<HMP0,<RoomPF1GraphicData_6,<RoomPF2GraphicData_7,<RoomPF2GraphicData_6,<RoomPF2GraphicData_9,<RoomPF2GraphicData_9
	
PF2GfxDataHi
	.byte >HMP0,>HMP0,>HMP0,>HMP0,>HMP0,>HMP0,>RoomPF1GraphicData_6,>RoomPF2GraphicData_7,>RoomPF2GraphicData_6,>RoomPF2GraphicData_9,>RoomPF2GraphicData_9
	
itemStatusBitValues
	.byte BASKET_STATUS_MARKET_GRENADE | PICKUP_ITEM_STATUS_WHIP
	.byte BASKET_STATUS_BLACK_MARKET_GRENADE | PICKUP_ITEM_STATUS_SHOVEL
	.byte PICKUP_ITEM_STATUS_HEAD_OF_RA
	.byte BACKET_STATUS_REVOLVER | PICKUP_ITEM_STATUS_TIME_PIECE
	.byte BASKET_STATUS_COINS
	.byte BASKET_STATUS_KEY | PICKUP_ITEM_STATUS_HOUR_GLASS
	.byte PICKUP_ITEM_STATUS_ANKH
	.byte PICKUP_ITEM_STATUS_CHAI


itemStatusMaskTable
	.byte ~(BASKET_STATUS_MARKET_GRENADE | PICKUP_ITEM_STATUS_WHIP);$FE
	.byte ~(BASKET_STATUS_BLACK_MARKET_GRENADE | PICKUP_ITEM_STATUS_SHOVEL);$FD
	.byte ~PICKUP_ITEM_STATUS_HEAD_OF_RA;$FB
	.byte ~(BACKET_STATUS_REVOLVER | PICKUP_ITEM_STATUS_TIME_PIECE);$F7
	.byte ~BASKET_STATUS_COINS;$EF
	.byte ~(BASKET_STATUS_KEY | PICKUP_ITEM_STATUS_HOUR_GLASS);$DF
	.byte ~PICKUP_ITEM_STATUS_ANKH;$BF
	.byte ~PICKUP_ITEM_STATUS_CHAI;$7F


itemIndexTable
	.byte $00						; empty
	.byte $00						; Copyright 1 (not used)
	.byte $00						; flute
	.byte $00						; parachute
	.byte $08						; coins
	.byte $00						; Marketplace Grenade
	.byte $02						; Black Market Grenade
	.byte $0A						; key
	.byte $0C						; ark (not used)
	.byte $0E						; Copyright 2 (not used)
	.byte $01						; whip........C
	.byte $03						; shovel......C
	.byte $04						; Copyright 3 (not used)
	.byte $06						; revolver
	.byte $05						; Ra..........C
	.byte $07						; Time piece..C
	.byte $0D						; Ankh........C
	.byte $0F						; Chai........C
	.byte $0B						; hour glass..C


dropItemTable: 						; ID 0: Empty/Default (No Action)
	.word dropItem-1 				; ID 1: Copyright 1 (Shown at Start Screen)
	.word dropItem-1 				; ID 2: Flute (Generic Drop)
	.word dropParachute-1 			; ID 3: Parachute (Clear mesaSideState bit)
	.word dropCoins-1 				; ID 4: Coins (Check Black Market Purchase)
	.word dropItem-1 				; ID 5: Marketplace Grenade
	.word dropItem-1 				; ID 6: Black Market Grenade
	.word dropItem-1 				; ID 7: Key
	.word dropItem-1 				; ID 8: Ark (Unused in Inventory)
	.word dropItem-1 				; ID 9: Copyright 2 (Shown at Start Screen)
	.word dropWhip-1 				; ID 10: Whip (put in Entrance Room)
	.word dropShovel-1 				; ID 11: Shovel (Restore to Black Market)
	.word dropItem-1 				; ID 12: Copyright 3 (Shown at Start Screen)
	.word dropItem-1 				; ID 13: Revolver
	.word dropItem-1 				; ID 14: Head of Ra
	.word dropItem-1 				; ID 15: Time Piece
	.word dropGrappleItem-1 		; ID 16: Ankh
	.word dropChai-1 				; ID 17: Chai (Yar's Revenge Check)
	.word dropGrappleItem-1 		; ID 18: Hourglass

playerHitJumpTable
	.word playerHitDefaut-1 				; Treasure Room
	.word playerHitInMarket-1 				; Marketplace
	.word playerHitInEntranceRoom-1 		; Entrance Room
	.word playerHitInBlackMarket-1 			; Black Market
	.word playerHitDefaut-1 				; Map Room
	.word playerHitInMesaSide-1 			; Mesa Side
	.word playerHitInTempleEntrance-1 		; Temple Entrance
	.word playerHitInSpiderRoom-1 			; Spider Room
	.word playerHitInRoomOfShiningLight-1 	; Room of the Shining Light
	.word playerHitDefaut-1 				; Mesa Field
	.word playerHitInValleyOfPoison-1 		; Valley of Poison
	.word playerHitInThievesDen-1 			; Thieves Den
	.word playerHitInWellOfSouls-1 			; Well of Souls

playfieldHitJumpTable:
	.word defaultIdleHandler-1 				; Treasure Room
	.word defaultIdleHandler-1 				; Marketplace
	.word indyPFHitEntranceRoom-1 			; Entrance Room
	.word defaultIdleHandler-1 				; Black Market
	.word defaultIdleHandler-1 				; Map Room
	.word indyMoveOnInput-1 				; Mesa Side
	.word stopIndyMovInTemple-1 			; Temple Entrance
	.word indyMoveOnInput-1 				; Spider Room
	.word playerHitInRoomOfShiningLight-1 	; Room of the Shining Light
	.word defaultIdleHandler-1 				; Mesa Field
	.word indyEnterHole-1 					; Valley of Poison
	.word defaultIdleHandler-1 				; Thieves Den
	.word defaultIdleHandler-1 				; Well of Souls

roomIdleHandlerJumpTable:
	.word defaultIdleHandler-1 				; Treasure Room
	.word defaultIdleHandler-1				; Marketplace
	.word setIndyToTriggeredState-1 		; Entrance Room
	.word defaultIdleHandler-1 				; Black Market
	.word initFallbackEntryPosition-1 		; Map Room
	.word defaultIdleHandler-1 				; Mesa Side
	.word defaultIdleHandler-1 				; Temple Entrance
	.word defaultIdleHandler-1 				; Spider Room
	.word defaultIdleHandler-1 				; Room of the Shining Light
	.word warpToMesaSide-1 					; Mesa Field
	.word setIndyToTriggeredState-1 		; Valley of Poison
	.word defaultIdleHandler-1 				; Thieves Den
	.word defaultIdleHandler-1 				; Well of Souls

placeItemInInventory
	ldx		inventoryItemCount		; get number of inventory items	
	cpx		#MAX_INVENTORY_ITEMS	; is Indy carrying fill inventory? (6)					
	bcc		getSpaceForItem			; branch if Indy has room to carry more items
	clc								
	rts								

getSpaceForItem
	ldx		#$0a					; start from last inventory slot (10)
invSearchLoop
	ldy		invSlotLo,x				; get the LSB for the inventory graphic
	beq		addItem					; branch if current slot is free
	dex								
	dex								; Move to the previous slot 
	bpl		invSearchLoop					
	brk								; break if no more items can be carried
									; (Should never happen -- if ItemCount < Max)

addItem
	tay								; move item number to y
	asl								; multiply object number by 8 for gfx
	asl								;...
	asl								;...
	sta		invSlotLo,x				; place graphic LSB in inventory
	lda		inventoryItemCount		; get number of inventory items		
	bne		updateInventory			; branch if Indy carrying items	
	stx		selectedItemSlot		; set index to newly picked up item			
	sty		selectedInventoryId		; set the current selected inventory id			
updateInventory
	inc		inventoryItemCount		; increment number of inventory items		
	cpy		#ID_INVENTORY_COINS		; If ID < Coins'		
	bcc		finishInventoryUpdate	; ex Flute, Parachute, skip marking as "Taken"			
	tya								; move item number to accumulator
	tax								; move item number to x
	jsr		showItemAsTaken			; Mark item as taken in global bitmasks		
finishInventoryUpdate
	lda		#$0c					; Make sound
	sta		soundChan0EffectTimer		; play with Indy's footstep sound		
	sec								
	rts								

setItemAsNotTaken
	lda		itemIndexTable,x		; get the item index value			
	lsr								; shift D0 to carry
	tay								
	lda		itemStatusMaskTable,y	; branch if item not a basket item				
	bcs		showItemAsNotTaken					
	and		basketItemsStatus					
	sta		basketItemsStatus		; clear status bit showing item not taken			
	rts								

showItemAsNotTaken
	and		pickupItemsStatus					
	sta		pickupItemsStatus		; clear status bit showing item not taken			
	rts								

showItemAsTaken
	lda		itemIndexTable,x		; get the item index value			
	lsr								; shift D0 to carry
	tax								
	lda		itemStatusBitValues,x	; get item bit value				
	bcs		pickUpItemTaken			; branch if item not a basket item		
	ora		basketItemsStatus					
	sta		basketItemsStatus		; show item taken			
	rts								

pickUpItemTaken
	ora		pickupItemsStatus					
	sta		pickupItemsStatus		; show item taken			
	rts								

isItemAlreadyTaken:
	lda		itemIndexTable,x		; get the item index value			
	lsr								; shift D0 to carry
	tay								
	lda		itemStatusBitValues,y	; get item bit value				
	bcs		isItemTaken				; branch if item not a basket item		
	and		basketItemsStatus		; branch if item not taken from basket			 
	beq		finishIsItemTaken		; set carry for item taken already				
	sec								
finishIsItemTaken:
	rts								

isItemTaken:
	and		pickupItemsStatus					 
	bne		finishIsItemTaken						
	clc								; clear carry for item not taken already	
	rts								


updateRoomEventState
	and		#$1f					
	tax								
	lda		EventStateOffset					
	cpx		#$0c					
	bcs		doneRoomEventState					
	adc		eventStateOffsetTable,x					
	sta		EventStateOffset					
doneRoomEventState
	rts								

startGame
; Set up everything so the power up state is known.
;
	sei								; turn off interrupts
	cld								; clear decimal flag (no bcd)
	ldx		#$ff					; Load X with $FF.
	txs								; reset the stack pointer
	inx								; clear x
	txa								; clear a
clearZeroPage
	sta		VSYNC,x					; clear zero page variables and TIA regs
	dex								; Decrement X.
	bne		clearZeroPage			; Loop until all 256 bytes are cleared.
	dex								; x = $ff
	stx		score					; reset score
	; -------------------------------------------------------------------------
	; INITIALIZE INVENTORY WITH COPYRIGHT
	;
	; The game displays the Copyright Notice ("(c) 1982 Atari Inc") inside the 
	; Inventory Strip at the very beginning of the game or after a reset.
	; It manually populates the `inventoryGfxPtrs` with the Copyright_X sprites.
	; -------------------------------------------------------------------------
	lda		#>emptySprite			; blank inventory
	sta		invSlotHi				; slot 1
	sta		invSlotHi2				; slot 2
	sta		invSlotHi3				; slot 3
	sta		invSlotHi4				; slot 4
	sta		invSlotHi5				; slot 5
	sta		invSlotHi6				; slot 6

	;fill with copyright text
	lda		#<copyrightGfx0
	sta		invSlotLo
	lda		#<copyrightGfx1
	sta		invSlotLo2
	lda		#<copyrightGfx2
	sta		invSlotLo4
	lda		#<copyrightGfx3
	sta		invSlotLo3
	lda		#<copyrightGfx4
	sta		invSlotLo5
	lda		#ID_ARK_ROOM				; set "ark elevator room" (room 13)
	sta		currentRoomId				; as current room
	lsr									; A = ID_ARK_ROOM / 2 (becomes 6)
	sta		bulletCount					; load 6 bullets
	jsr		initRoomState				; Init various screen and game state	
	jmp		startNewFrame				; Jump to the main game loop.	

initGameVars:
	lda		#<invCoinsSprite					
	sta		invSlotLo					; place coins in Indy's inventory
	lsr									; divide by 8 to get the inventory id
	lsr								
	lsr								
	sta		selectedInventoryId			; set the current selected inventory id		
	inc		inventoryItemCount			; increment number of inventory items		
	lda		#<emptySprite					
	sta		invSlotLo2					; clear the remainder of Indy's inventory
	sta		invSlotLo3					
	sta		invSlotLo4					
	sta		invSlotLo5					
	lda		#INIT_SCORE					; set initial score
	sta		score				
	lda		#<IndyStandSprite			; set Indy's initial sprite (standing)		
	sta		indyGfxPtrLo				
	lda		#>IndySprites					
	sta		indyGfxPtrHi					
	lda		#$4c					
	sta		indyPosX					; set Indy's initial X position		
	lda		#$0f					
	sta		indyPosY					; set Indy's initial Y position
	lda		#ID_ENTRANCE_ROOM					
	sta		currentRoomId				; set current room to Entrance Room
	sta		livesLeft					; set initial number of lives
	jsr		initRoomState				; Initialize new room state.
	jmp		setupScreenAndObj			; Setup the screen and objects for the
										; entrance room.	

;------------------------------------------------------------
; getFinalScore
; The player's progress is determined by Indy's height on the pedestal when the
; game is complete. The player wants to achieve the lowest adventure points
; possible to lower Indy's position on the pedestal.
;
getFinalScore
	lda		score					; load score
	sec								; positve actions...
	sbc		findingArkBonus			; found the ark
	sbc		usingParachuteBonus		; parachute used
	sbc		ankhUsedBonus			; ankh used (Mesa Skip)
	sbc		yarFoundBonus			; yar found
	sbc		livesLeft				; lives left
	sbc		mapRoomBonus			; used the Head of Ra in the Map Room
	sbc		mesaLandingBonus		; landed in Mesa
	sbc		UnusedBonus				; never used
	clc								; negitive actions...
	adc		grenadeOpeningPenalty	; gernade used on wall (2 points)
	adc		escapePrisonPenalty		; escape hatch used (13 points)
	adc		thiefShotPenalty		; thief shot (4 points)
	sta		score					; store in final score
	rts								; return

	;Padding for tables
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $ddf8 (*)
roomOverrideTable
	.byte	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$f8 ; $de00 (*)
	.byte	$ff,$ff,$ff,$ff,$ff,$4f,$4f,$4f ; $de08 (*)
	.byte	$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f ; $de10 (*)
	.byte	$44,$44,$0f,$0f,$1c,$0f,$0f,$18 ; $de18 (*)
	.byte	$0f,$0f,$0f,$0f,$0f,$12,$12,$89 ; $de20 (*)
	.byte	$89,$8c,$89,$89,$86,$89,$89,$89 ; $de28 (*)
	.byte	$89,$89,$86,$86					; $de30 (*)
posYOverrideFlagTable
	.byte	$ff,$fd,$ff,$ff,$fd,$ff,$ff,$ff ; $de34 (*)
	.byte	$fd,$01,$fd,$04,$fd,$ff,$fd,$01 ; $de3c (*)
	.byte	$ff,$0b,$0a,$ff,$ff,$ff,$04,$ff ; $de44 (*)
	.byte	$fd,$ff,$fd,$ff,$ff,$ff,$ff,$ff ; $de4c (*)
	.byte	$fe,$fd,$fd,$ff,$ff,$ff,$ff,$ff ; $de54 (*)
	.byte	$fd,$fd,$fe,$ff,$ff,$fe,$fd,$fd ; $de5c (*)
	.byte	$ff,$ff,$ff,$ff					; $de64 (*)
overrideLowXBoundTable
	.byte	$00,$1e,$00,$00,$11,$00,$00,$00 ; $de68 (*)
	.byte	$11,$00,$10,$00,$60,$00,$11,$00 ; $de70 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $de78 (*)
	.byte	$70,$00,$12,$00,$00,$00,$00,$00 ; $de80 (*)
	.byte	$30,$15,$24,$00,$00,$00,$00,$00 ; $de88 (*)
	.byte	$18,$03,$27,$00,$00,$30,$20,$12 ; $de90 (*)
	.byte	$00,$00,$00,$00					; $de98 (*)
overrideHighXBoundTable
	.byte	$00,$7a,$00,$00,$88,$00,$00,$00 ; $de9c (*)
	.byte	$88,$00,$80,$00,$65,$00,$88,$00 ; $dea4 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $deac (*)
	.byte	$72,$00,$16,$00,$00,$00,$00,$00 ; $deb4 (*)
	.byte	$02,$1f,$2f,$00,$00,$00,$00,$00 ; $debc (*)
	.byte	$1c,$40,$01,$00,$00,$07,$27,$16 ; $dec4 (*)
	.byte	$00,$00,$00,$00					; $decc (*)
advOverrideControlTable
	.byte	$00,$02,$00,$00,$09,$00,$00,$00 ; $ded0 (*)
	.byte	$07,$00,$fc,$00,$05,$00,$09,$00 ; $ded8 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $dee0 (*)
	.byte	$03,$00,$ff,$00,$00,$00,$00,$00 ; $dee8 (*)
	.byte	$01,$06,$fe,$00,$00,$00,$00,$00 ; $def0 (*)
	.byte	$fb,$fd,$0b,$00,$00,$08,$08,$00 ; $def8 (*)
	.byte	$00,$00,$00,$00					; $df00 (*)
roomPosYOverrideTable
	.byte	$00,$4e,$00,$00,$4e,$00,$00,$00 ; $df04 (*)
	.byte	$4d,$4e,$4e,$4e,$04,$01,$03,$01 ; $df0c (*)
	.byte	$01,$01,$01,$01,$01,$01,$01,$01 ; $df14 (*)
	.byte	$40,$00,$23,$00,$00,$00,$00,$00 ; $df1c (*)
	.byte	$00,$00,$41,$00,$00,$00,$00,$00 ; $df24 (*)
	.byte	$45,$00,$42,$00,$00,$00,$42,$23 ; $df2c (*)
	.byte	$28,$00,$00,$00					; $df34 (*)
roomPosXOverrideTable
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $df38 (*)
	.byte	$00,$00,$00,$00,$4c,$00,$00,$00 ; $df40 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $df48 (*)
	.byte	$80,$00,$86,$00,$00,$00,$00,$00 ; $df50 (*)
	.byte	$80,$86,$80,$00,$00,$00,$00,$00 ; $df58 (*)
	.byte	$12,$12,$4c,$00,$00,$16,$80,$12 ; $df60 (*)
	.byte	$50,$00,$00,$00					; $df68 (*)

roomEventOffsetTable
	.byte	$01,$ff,$01,$ff	

entranceRoomTopObjPosY
	.byte ENTRANCE_ROOM_ROCK_VERT_POS
	.byte ENTRANCE_ROOM_CAVE_VERT_POS

roomObjPosYTable
	.byte	$00,$00,$42,$45,$0c,$20

marketBasketItems
	.byte ID_INVENTORY_COINS, ID_INVENTORY_CHAI
	.byte ID_INVENTORY_ANKH, ID_INVENTORY_HOUR_GLASS


ArkRoomImpactResponseTable
	.byte	$07,$03,$05,$06,$09,$0b,$0e,$00 ; $df7c (*)
	.byte	$01,$03,$05,$00,$09,$0c,$0e,$00 ; $df84 (*)
	.byte	$01,$04,$05,$00,$0a,$0c,$0f,$00 ; $df8c (*)
	.byte	$02,$04,$05,$08,$0a,$0d,$0f,$00 ; $df94 (*)

jmpDisplayKernel
waitTime
	lda		INTIM					
	bne		waitTime				
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	lda		#<drawScreen					
	sta		bankSwitchJMPAddrLo					
	lda		#>drawScreen				
	sta		bankSwitchJMPAddrHi					
jumpToBank1
	lda		#LDA_ABS					
	sta		loopCounter					
	lda		#<BANK1STROBE					
	sta		tempGfxHolder					
	lda		#>BANK1STROBE					
	sta		bankSwitchJMPOpcode					
	lda		#JMP_ABS				
	sta		bankSwitchJMPAddr					
	jmp.w	loopCounter					

getMoveDir
	ror								;move first bit into carry
	bcs		mov_emy_right			;if 1 check if enemy shoulld go right
	dec		p0PosY,x				;move enemy left 1 unit
mov_emy_right
	ror								;rotate next bit into carry
	bcs		mov_emy_down				;if 1 check if enemy should go up
	inc		p0PosY,x				;move enemy right 1 unit
mov_emy_down
	ror								;rotate next bit into carry
	bcs		mov_emy_up				;if 1 check if enemy should go up
	dec		objectPosX,x				;move enemy down 1 unit
mov_emy_up
	ror								;rotate next bit into carry
	bcs		mov_emy_finish			;if 1, moves are finished
	inc		objectPosX,x				;move enemy up 1 unit
mov_emy_finish
	rts								;return

indyMoveDeltaTable
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte $00
	.byte (MOVE_LEFT & MOVE_UP) >> 4;$0A
	.byte (MOVE_LEFT & MOVE_DOWN) >> 4;$09
	.byte MOVE_LEFT >> 4;$0B
	.byte $00
	.byte $06
	.byte $05
	.byte $07
	.byte $00
	.byte $0E
	.byte $0D
	.byte $0F


eventStateOffsetTable
	.byte $00,$06,$03,$03,$03,$00,$00,$06,$00,$00,$00,$06


	.org BANK0TOP + 4096 - 6, 0

	;Vector Table					
	.word startGame							;NMI
	.word startGame							;RESET
	.word startGame							;IRQ/BRK


;***********************************************************
;	bank 1 / 0..1
;***********************************************************

	seg		bank1
	org		BANK1TOP
	rorg	BANK1_REORG 

BANK1Start
	lda		BANK0STROBE					

drawPlayField
; This loop draws the main playfield area.
; It handles walls, background graphics, and player sprites.
	cmp		p0GfxState					; Check against graphics data/state.	
	bcs		DungeonWallScanlineHandler	; Branch if carry set.				
	lsr									; Divide by 2.
	clc									; Clear carry
	adc		objOffsetPosY				; Add vertical offset.
	tay									; Transfer to Y index.
	sta		WSYNC						; Wait for Horizontal Sync.
;---------------------------------------
	sta		HMOVE						; Apply horizontal motion.
	lda		(PF1GfxPtrLo),y				; Load PF1 graphics data.
	sta		PF1							; Store in PF1.
	lda		(PF2GfxPtrLo),y				; Load PF2 graphics data.
	sta		PF2							; Store in PF2.
	bcc		drawIndySprite				; Branch to draw player sprites.		
DungeonWallScanlineHandler
	sbc		objectState					; Adjust for snake/dungeon state.
	lsr									; Divide by 4.
	lsr								
	sta		WSYNC						; Wait for Horizontal Sync.
;---------------------------------------
	sta		HMOVE						; Apply horizontal motion.
	tax									; Transfer A to X.
	cpx		snakePosY					; Compare with Snake vertical position.
	bcc		drawDungeonWall				; Branch if X < Snake Pos.	
	ldx		timepieceSpriteDataPtr		; Load Timepiece sprite data pointer.			
	lda		#$00					
	beq		setDungeonWall				; Unconditional branch to store 0.	
drawDungeonWall
	lda		dynamicGfxData,x			; Load dungeon graphics data.	
	ldx		timepieceSpriteDataPtr		; Restore X.			
setDungeonWall
	sta		PF1,x						; Store graphics (or 0) to PF1 using X
										; as offset
drawIndySprite
	ldx		#<ENAM1						; Load address of ENAM1 
	txs									; Set Stack Pointer
	lda		scanline					; Load current scanline.
	sec									; Set carry.
	sbc		indyPosY					; Subtract Indy's vertical position.
	cmp		indySpriteHeight			; Compare with Indy's height.		
	bcs		skipIndyDraw				; Skip if outside drawing range.	
	tay									; Transfer index to Y.
	lda		(indyGfxPtrLo),y			; Load Indy graphics.
	tax									; Transfer to X.

drawP0Sprite
	lda		scanline					; Reload scanline.
	sec									; Set carry.
	sbc		p0PosY					; Subtract Player 0 vertical position.
	cmp		p0SpriteHeight				; Compare with P0 height	 
	bcs		skipDrawP0Sprite			; Skip if outside drawing range.		
	tay									; Transfer index to Y.
	lda		(p0GfxPtrLo),y				; Load P0 graphics.
	tay									; Transfer to Y.

nextPFScanline
	lda		scanline					; Reload scanline.
	sta		WSYNC						; Wait for Horizontal Sync.
;---------------------------------------
	sta		HMOVE						; Apply horizontal motion.
	cmp		weaponPosY					; Check weapon (M1) vertical position.
	php									; Push status (Timing/Enable logic).
	cmp		m0PosY						; Check M0 vertical position.
	php									; Push status (Timing/Enable logic).
	stx		GRP1						; Update GRP1 (Indy graphics).
	sty		GRP0						; Update GRP0 (P0 graphics).
	sec									; Set carry.
	sbc		ballPosY			; Adjust for object Y.
	cmp		#$08						; Check height range
	bcs		goNextPFScanline			; Skip if outside range.
	tay									; Transfer to Y.
	lda		(timepieceGfxPtrs),y		; Load timepiece graphics.		
	sta		ENABL						; Enable/Disable Ball.
	sta		HMBL						; Set Horizontal Motion for Ball.
goNextPFScanline
	inc		scanline					; Increment scanline counter.
	lda		scanline				
	cmp		#(HEIGHT_KERNEL / 2)		; Compare with kernel height/2.					
	bcc		drawPlayField				; Loop if not done.	
	jmp		drawInventoryKernel			; jump to draw the inventory zone.		

skipIndyDraw
	ldx		#$00						; Load 0.
	beq		drawP0Sprite				; Proceed to check Player 0.

skipDrawP0Sprite
	ldy		#$00						; Load 0.	
	beq		nextPFScanline				; Proceed to next scanline.

drawStillPlayerKernel
;
; This is used when the player is stationary (or fewer sprites moving).
; Optimizes TIA updates.
;
	cpx		#(HEIGHT_KERNEL / 2) - 1	; Check if kernel scanlines complete.					
	bcc		skipP0Draw					; If not done, skip drawing player 0.
	jmp		drawInventoryKernel			; Jump to draw inventory zone.	

skipP0Draw
	lda		#$00						; Load 0	
	beq		nextStillPlayerScanline		; Unconditional branch.

drawStillP0Sprite
	lda		(p0GfxPtrLo),y				; Load P0 graphics.
	bmi		setP0Values					; If negative (special flag
	;									; bit 7), jump to setting values.
	cpy		objOffsetPosY				; Compare Y with offset.	
	bcs		drawStillPlayerKernel		; Branch if greater or equal	
	cpy		p0PosY					; Compare Y with P0 vertical position.
	bcc		skipP0Draw					; Skip if below.
	sta		GRP0						; Store to GRP0.
	bcs		nextStillPlayerScanline		; Unconditional branch.	

setP0Values
	asl									; Shift left.
	tay									; Transfer to Y.
	and		#$02						; Mask bit 1.
	tax									; Transfer to X.
	tya									; Transfer to A.
	sta		(PF1GfxPtrLo,x)				; Store to TIA pointer address.

nextStillPlayerScanline					
	inc		scanline					; Increment scanline counter.
	ldx		scanline					; Load to X.
	lda		#ENABLE_BM					; Load Enable Missile mask value.				
	cpx		m0PosY						; Compare with M0 vertical position.
	bcc		skipM0Draw					; Branch if not reached.
	cpx		p0GfxState					; Compare with P0 Graphics Data.
	bcc		setMissleEnable				; Enable missile.

skipM0Draw
	ror									; Rotate right.

setMissleEnable
	sta		ENAM0						; Store to ENAM0.

drawStillPlayer
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE						; Execute horizontal move.
	txa									; Move scanline count to A.
	sec									; Set carry for subtraction.
	sbc		snakePosY					; Subtract Snake vertical position.
	cmp		#$10						; Compare with 16.
	bcs		burn19Cycles				; Branch if snake not active here.
	tay									; Transfer to Y.
	cmp		#$08						; Compare with 8.
	bcc		burn5Cycles				; Branch if < 8.
	lda		timepieceSpriteDataPtr		; Load pointer to timepiece sprite data.		
	sta		timepieceGfxPtrs			; Store in graphics pointer.		
drawTimepieceSprite
	lda		(timepieceGfxPtrs),y		; Load timepiece graphics.
	sta		HMBL						; Store in Ball Horizontal Motion check.

setMissile1Enable
	ldy		#DISABLE_BM					; Default to disable missile.	
	txa									; Move scanlineCounter to A.
	cmp		weaponPosY					; Compare with weapon position.
	bne		UpdateMissile1Enable		; If not weapon pos, skip enable.			
	dey									; Enable missile (Y becomes $FF/Enable).
UpdateMissile1Enable
	sty		ENAM1						; Update Missile 1 Enable.
	sec									; Set carry.
	sbc		indyPosY					; Subtract Indy vertical position.
	cmp		indySpriteHeight			; Compare with sprite height.	
	bcs		skipDrawStillPlayer1Sprite	; Skip if outside sprite.			
	tay									; Transfer to Y (sprite index).
	lda		(indyGfxPtrLo),y			; Load Indy graphics.

drawStillPlayer1Sprite
	ldy		scanline					; Restore scanline counter to Y.
	sta		GRP1						; Store in GRP1.
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	lda		#ENABLE_BM					; Load Enable Ball value.					
	cpx		ballPosY			; Compare scanline with Snake Y.
	bcc		skipDrawingTheBall			; Branch if below.	
	cpx		p0SpriteHeight				; Compare with p0SpriteHeight 
	bcc		setBallEnable				; Enable ball.	

skipBallDraw
	ror									; Rotate right.

setBallEnable
	sta		ENABL						; Update Ball Enable.
	bcc		drawStillP0Sprite			; Unconditional branch back to loop start.	

skipDrawingTheBall
	bcc		skipBallDraw				; Unconditional branch.	

burn5Cycles
	nop									; Burn cycles.
	jmp		drawTimepieceSprite			; Jump back.		

burn19Cycles
	pha									; Burn cycles.
	pla								
	pha								
	pla								
	nop								
	jmp		setMissile1Enable			; Jump back.	

skipDrawStillPlayer1Sprite
	lda		#$00						; Load 0 (clear graphics).
	beq		drawStillPlayer1Sprite		; Jump back to store 0 in GRP1.

AdvanceStillKernelScanline
	inx									; Increment scanline counter.
	sta		HMCLR						; Clear horizontal motion.
	cpx		#HEIGHT_KERNEL				; Check limit.			
	bcc		drawThieves	; Branch if not done.			
	jmp		drawInventoryKernel			; Jump to Inventory Kernel.		

thiefKernel
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	inx									; Increment scanline counter.
	lda		loopCounter					; Load loop counter.
	sta		GRP0						; Store to GRP0 (Thief/Player 0).
	lda		tempGfxHolder				; Load value from temp
	sta		COLUP0						; Store to COLUP0.
	txa									; Move scanline to A.
	ldx		#<ENABL						; Load address of ENABL
	txs									; Set Stack Pointer to $1F.
										; This allows PHP to write to
										; TIA registers via stack mirror
										; $01xx -> $00xx.	
	tax									; Move scanline to X.
	lsr									; Divide Scanline by 2.
	cmp		ballPosY			; Compare with Ball Y.
	php									; Push Status (Writes P to ENABL
										; at $1F). If Equal (Z=1),
										; Bit 1 is set -> Enabled.
	cmp		weaponPosY					; Compare with Missile 1 Y.
	php									; Push Status (Writes P to ENAM1 @ $1E).
	cmp		m0PosY						; Compare with Missile 0 Y.
	php									; Push Status (Writes P to ENAM0 @ $1D).
	sec									; Set Carry.
	sbc		indyPosY					; Subtract Indy Y.
	cmp		indySpriteHeight			; Compare with Height.	
	bcs		AdvanceStillKernelScanline	; If outside (Carry Set), branch back.				
	tay									; Use result as Y index.
	lda		(indyGfxPtrLo),y			; Load Indy graphics.
	sta		HMCLR						; Clear horizontal motion.
	inx									; Increment scanline.
	sta		GRP1						; Store Indy graphics.
	
drawThieves
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	bit		objectState					; Check state flag to determine
										; if we are positioning or
										; drawing/updating.
	bpl		animateThieves				; If bit 7 is clear, jump to Animation Logic.
	; --------------------------------------------------------------------------
	; THIEF POSITIONING LOGIC
	; If Bit 7 of snakeDungeonState is SET, we are in the "Positioning" phase.
	; --------------------------------------------------------------------------
	ldy		bankSwitchJMPAddrHi			; Load Fine position timing value 	
	lda		bankSwitchJMPAddrLo			; Load Coarse position value (HMOVE).		
	lsr		objectState					; Shift state right (clears Bit 7,
										; moves to next state).	
ThiefPosTimingLoop
	dey									; Delay loop for horizontal positioning.
	bpl		ThiefPosTimingLoop			; Loop until Y < 0.	
	sta		RESP0						; Strobe Reset Player 0 to set
										; coarse horizontal position.
	sta		HMP0						; Set Fine Motion Player 0
										; (High nibble of A).
	bmi		thiefKernel					; Unconditional branch 

animateThieves
	bvc		updateThiefAnimation		; If Bit 6 is clear, jump to State
										; Update logic.
	; --------------------------------------------------------------------------
	; THIEF DRAWING LOGIC
	; If Bit 6 of objectState is SET, we are drawing the sprite.
	; --------------------------------------------------------------------------		
	txa									; Move current scanline count to A.
	and		#$0f						; Mask to lower 4 bits
	tay									; Transfer directly to Y index for graphics.
	lda		(p0GfxPtrLo),y				; Load P0 Graphics data (Indirect Y).
	sta		GRP0						; Store to GRP0 (Draw).
	lda		(timepieceGfxPtrs),y		; Load P0 Color data.
	sta		COLUP0						; Store to COLUP0.
	iny									; Next line of sprite data.
	lda		(p0GfxPtrLo),y				; Look ahead: Load next graphics line.
	sta		loopCounter					; store loop cpunter
	lda		(timepieceGfxPtrs),y		; Look ahead: Load next color line.		
	sta		tempGfxHolder				; Store in temp
	cpy		p0SpriteHeight				; Check if we have drawn the full
										; height of the sprite. 
	bcc		returnToThiefKernel			; If Y < Height, continue drawing next line.		
	lsr		objectState					; If done, Shift state right (Clear Bit 6).
returnToThiefKernel
	jmp		thiefKernel					; Jump back to main kernel loop.

updateThiefAnimation
	; --------------------------------------------------------------------------
	; THIEF STATE & ANIMATION SELECTION
	; Determines which thief is active based on scanline height.
	; --------------------------------------------------------------------------
	lda		#$20						; Load Bit 5 mask.	
	bit		objectState					; Check Bit 5 of state.
	beq		thiefFrameSetup				; If Bit 5 clear, proceed to Frame Setup.	
	txa									; Move scanline to A.
	lsr									; Shift right 5 times (Divide by 32)
	lsr									; 32 scanlines allocated per thief zone?
	lsr								
	lsr								
	lsr								
	bcs		thiefKernel					; If Carry Set 
	tay									; Y = Thief Index (0-4).
	sty		bankSwitchJMPAddr			; Store Index in temp 		
	lda.wy	objOffsetPosY,y				; Load State for this Thief.
	sta		REFP0						; Set Reflection (Direction).
	sta		NUSIZ0						; Set Number/Size
	sta		bankSwitchJMPOpcode			; Store State in temp 	
	bpl		finishThiefAnimate			; If Bit 7 clear, jump 

	; Special "Digging" state - removes pile of dirt	
	lda		diggingState				; Load digging state.	
	sta		p0GfxPtrLo					; Update pointers.
	lda		#$65						; Load Color.
	sta		timepieceGfxPtrs			; Update color pointer.	
	lda		#$00						; Clear A.
	sta		objectState					; Clear state completely.
	jmp		thiefKernel					; Return.

finishThiefAnimate
	lsr		objectState					; Shift state (Bit 5 cleared).
	jmp		thiefKernel					; Return.

thiefFrameSetup
	; --------------------------------------------------------------------------
	; ANIMATION FRAME SELECTION
	; Calculates the correct animation frame based on movement.
	; --------------------------------------------------------------------------
	lsr									; Shift A
	bit		objectState					; Check state (Bit 4?).
	beq		thiefSpecialAnimate			; If zero, jump to Special Case.		
	ldy		bankSwitchJMPAddr			; Restore Thief Index.		
	lda		#$08						; Load Bit 3 mask.
	and		bankSwitchJMPOpcode			; Check temp state		
	beq		pickThiefSpriteFrame		; If Bit 3 clear, jump.			
	lda		#$03						; Load Offset 3

pickThiefSpriteFrame
	eor.wy	dynamicGfxData,y			; XOR with HMOVE index
										; (Position-based animation).		
	and		#$03						; Mask to 2 bits (4 frames).
	tay									; Use as index.
	lda		thiefSpriteValueLo,y		; Load LSB for Sprite Graphic.			
	sta		p0GfxPtrLo					; Set Graphic Pointer LSB.
	lda		#<thiefColors				; Load Colors Base Address. 	
	sta		timepieceGfxPtrs			; Set Color Pointer LSB.		
	lda		#HEIGHT_THIEF - 1			; Load Height for Thief (-1).	
	sta		p0SpriteHeight				; Set Height.	 
	lsr		objectState					; Shift state.
	jmp		thiefKernel					; Return.

thiefSpecialAnimate
	txa								
	and		#$1f						; Move scanline to A.
	cmp		#$0c						; Compare
	beq		thiefSpriteHandeler			; Branch if equal.
	jmp		thiefKernel					; Jump back.

thiefSpriteHandeler
	ldy		bankSwitchJMPAddr			; Load temp		
	lda.wy	thiefPosX,y					; Load horizontal position.
	sta		bankSwitchJMPAddrLo			; Store coarse.		
	and		#$0f						; Mask low nibble.
	sta		bankSwitchJMPAddrHi			; Store fine.		
	lda		#$80						; Load $80.
	sta		objectState					; Store state.
	jmp		thiefKernel					; Jump back.

drawInventoryKernel
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	ldx		#$ff						; Load $FF (Solid).
	stx		PF1							; Set PF1.
	stx		PF2							; Set PF2.
	inx									; Increment X to 0.
	stx		GRP0						; Clear GRP0.
	stx		GRP1						; Clear GRP1.
	stx		ENAM0						; Disable Missile 0.
	stx		ENAM1						; Disable Missile 1.
	stx		ENABL						; Disable Ball.
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	lda		#$03						; Three copies close.
	ldy		#$00						; No reflection.
	sty		REFP1						; Set REFP1.
	sta		NUSIZ0						; Set NUSIZ0.
	sta		NUSIZ1						; Set NUSIZ1.
	sta		VDELP0						; Vertical Delay P0 (Copies update).
	sta		VDELP1						; Vertical Delay P1.
	sty		GRP0						; Clear GRP0 (Y=0).
	sty		GRP1						; Clear GRP1.
	sty		GRP0						; Clear GRP0.
	sty		GRP1						; Clear GRP1.
	nop									; Wait.
	sta		RESP0						; Reset Player 0.
	sta		RESP1						; Reset Player 1.
	sty		HMP1						; Set Fine Motion P1 (Y=0).
	lda		#$f0						; Load right motion.
	sta		HMP0						; Set HMP0.
	sty		REFP0						; Set REFP0 (Y=0).
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	lda		#YELLOW + 10				; Golden color for item sprites
	sta		COLUP0						; Set Color P0.
	sta		COLUP1						; Set Color P1.
	lda		selectedItemSlot			; Get selected inventory index.		
	lsr									; Divide by 2.
	tay									; Transfer to Y.
	lda		inventoryIndexPosX,y		; Load Horizontal value for indicator.		
	sta		HMBL						; Set Ball Fine Motion.
	and		#$0f						; Keep coarse value.
	tay									; Transfer to Y.
	ldx 	#HMOVE_0					; No motion.
	stx		HMP0						; Set HMP0.
	sta		WSYNC					
;---------------------------------------
	stx		PF0							; Clear PF0 
	stx		COLUBK						; Set Background Color.
	stx		PF1							; Set PF1.
	stx		PF2							; Set PF2.
coarseMoveInventorySelector
	dey									; Decrement coarse counter.
	bpl		coarseMoveInventorySelector	; Loop until done			
	sta		RESBL						; Reset Ball (Inventory Selector).
	stx		CTRLPF						; Set CTRLPF.
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	lda		#$3f						; Mask.
	and		frameCount					; Check frame count.
	bne		updateInventoryMenu			; Skip if not 0.	
	lda		#$3f						; Mask.
	and		secondsTimer				; Check timer.
	bne		updateInventoryMenu			; Skip if not 0.		
	lda		entranceRoomEventState		; Load event state.		
	and		#$0f						; Mask low nibble.
	beq		updateInventoryMenu			; Skip if 0.	
	cmp		#$0f						; Compare with Max.
	beq		updateInventoryMenu			; Skip if Max.		
	inc		entranceRoomEventState		; Increment state.	

updateInventoryMenu
	sta		WSYNC						; draw blank line
;--------------------------------------
	lda		#ORANGE + 2					; set burgundy 
	sta		COLUBK						; ...as the background color
	sta		WSYNC						; draw four more scanlines
;--------------------------------------
	sta		WSYNC						;
;--------------------------------------
	sta		WSYNC						;
;--------------------------------------
	sta		WSYNC						;
;--------------------------------------
	lda		#HEIGHT_ITEM_SPRITES - 1	; Load Height-1.					
	sta		loopCounter					; Set loop counter.

drawInventoryItems
	ldy		loopCounter					; Load Y with index.
	lda		(invSlotLo),y				; Load inv item 1.
	sta		GRP0						; Store GRP0.
	sta		WSYNC					
;---------------------------------------
	lda		(invSlotLo2),y				; Load inv item 2.
	sta		GRP1						; Store GRP1.
	lda		(invSlotLo3),y				; Load inv item 3.
	sta		GRP0						; Store GRP0
	lda		(invSlotLo4),y				; Load inv item 4.
	sta		tempGfxHolder				; Save to temp.
	lda		(invSlotLo5),y				; Load inv item 5.
	tax									; Save to X.
	lda		(invSlotLo6),y				; Load inv item 6.
	tay									; Save to Y
	lda		tempGfxHolder				; Restore item 4.	
	sta		GRP1						; Store GRP1
	stx		GRP0						; Store item 5 to GRP0.
	sty		GRP1						; Store item 6 to GRP1.
	sty		GRP0						; Store item 6 to GRP0 
	dec		loopCounter					; Decrement counter.
	bpl		drawInventoryItems			; Loop.
	lda		#$00						; Load 0.
	sta		WSYNC					
;---------------------------------------
	sta		GRP0						; Clear GRP0.
	sta		GRP1						; Clear GRP1.
	sta		GRP0						; Clear GRP0.
	sta		GRP1						; Clear GRP1.
	sta		NUSIZ0						; Reset NUSIZ0.
	sta		NUSIZ1						; Reset NUSIZ1.
	sta		VDELP0						; Reset VDELP0.
	sta		VDELP1						; Reset VDELP1.
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	ldy		#ENABLE_BM					; Load Enable Ball Mask.					
	lda		inventoryItemCount			; Get item count.		
	bne		updateSelector				; Branch if items exist.
	dey									; Disable Ball

updateSelector
	sty		ENABL						; Update ENABL.
	ldy		#BLACK + 8					; Load color.					
	sty		COLUPF						; Set COLUPF.
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	ldy		#DISABLE_BM					; Disable Ball.					
	sty		ENABL						; Store ENABL.
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	ldx		#$0f					
	stx		VBLANK						; turn off TIA (D1 = 1)		
	ldx		#OVERSCAN_TIME				; depending on NTSC/PAL 				
	stx		TIM64T						; set timer for overscan period
	ldx		#$ff					
	txs									; point stack to the beginning
	ldx		#$01
					
updateSoundRegisters
	lda		soundChan0EffectTimer,x			; Load Sound Control Byte (Channel 0)	
	sta		AUDC0,x						; Set Distortion Type (Uses Low Nibble)
	sta		AUDV0,x						; Set Volume (Uses Low Nibble)
	bmi		updateSpecialSound			; If Bit 7 Set -> Sustain/Sequence Logic
	; --- One-Shot / Decay Logic ---		
	ldy		#$00						; Prepare 0
	sty		soundChan0EffectTimer,x			; Clear the source variable	

updateSoundFreq
	sta		AUDF0,x						; Set Frequency
	dex									; Decrement Channel Index
	bpl		updateSoundRegisters		; Loop for next channel			
	bmi		finishUpdateSound			; All channels done

updateSpecialSound
	cmp		#$9c						; Check for "Main Theme" Sound ID
	bne		updateSoundFromFrameCount	; If not $9C, 
										; check for "Snake Charmer Song"
														
	lda		#$0f						; --- Main Theme (Raiders March) ---	
	and		frameCount					; Slow tick 
	bne		updateSoundTimer			; If not tick, just verify timer	
	dec		soundTimer					; Decrement timer
	bpl		updateSoundTimer			; If still positive, play	
	lda		#$17						; Reset timer to start (Loop)
	sta		soundTimer				

updateSoundTimer	
	ldy		soundTimer					; Get timer value
	lda		soundEffectTable,y			; Look up Frequency from Table		
	bne		updateSoundFreq				; Go to write Frequency

updateSoundFromFrameCount				; get global frame counter
	lda		frameCount				
	lsr									; Divide by 16 (Plays note for ~16 frames)
	lsr								
	lsr								
	lsr								
	tay									; Use as index
	lda		soundFreqTable,y			; Look up Note/Frequency		
	bne		updateSoundFreq				; Go to write Frequency

finishUpdateSound
	lda		selectedInventoryId			; Get current selected inventory id.		
	cmp		#ID_INVENTORY_TIME_PIECE	; Is it the Time Piece?					
	beq		openTimepiece				; Check for Time Piece display action.			
	cmp		#ID_INVENTORY_FLUTE			; Is it the Flute?					
	bne		resetInventoryState			; If NOT Flute, skip music.

	; --- Flute Music Logic ---		
	lda		#$84						; Load Sound/Frequency Value
	sta		soundChan1EffectTimer		; Store in effect timer		
	bne		updateEventState			; Unconditional branch.

openTimepiece
	bit		INPT5|$30					; read action button from right controller
	bpl		updateTimepieceSprite		; branch if action button pressed
	lda		#<closedTimepieceSprite					
	bne		StoreTimepieceSprite		; unconditional branch

updateTimepieceSprite
	; --------------------------------------------------------------------------
	; UPDATE TIMEPIECE GRAPHIC
	; The timepiece in the inventory shows the passing of time by hand rotation.
	; Uses secondsTimer to select the correct graphic frame.
	; --------------------------------------------------------------------------
	lda		secondsTimer				; Load seconds counter.
	and		#$e0						; Keep top 3 bits for the 8 sprites
	lsr								
	lsr								
	adc		#<timepiece12_00			; Add Base Address of Timepiece Graphics.

StoreTimepieceSprite	
	ldx		selectedItemSlot			; Get the current slot for the timepiece.		
	sta		invSlotLo,x					; Update the graphics pointer (Low Byte).

resetInventoryState
	lda		#$00						; Clear A.
	sta		soundChan1EffectTimer		; Reset Timer 

updateEventState
	bit		screenEventState			; Check for special inventory event.		
	bpl		UpdateInvItemPos			; If Bit 7 clear, skip to standard update.

	; --------------------------------------------------------------------------
	; INVENTORY EVENT ANIMATION
	; --------------------------------------------------------------------------
	lda		frameCount					; Get current frame coun
	and		#$07						; Mask lower 3 bits.
	cmp		#$05						; Compare with 5.
	bcc		UpdateInvEventState			; If < 5, Update Animation State.	
	ldx		#$04						; X = 4.
	ldy		#$01						; Y = 1.
	bit		majorEventFlag				; Check Major Event Flag 	
	bmi		setInvEventStateTo3			; If Set (Minus), Set Y=3.	
	bit		eventTimer					; Check event Timer 
	bpl		updateInvEventStateAfterYSet	; If positive, skip.
					
setInvEventStateTo3
	ldy		#$03						; Set Y = 3.

updateInvEventStateAfterYSet
	jsr		updateMoveToTarget			; Call Object Position Handler.

UpdateInvEventState
	lda		frameCount					; Get current frame count.
	and		#$06						; Mask bits 1 and 2.
	asl									; Shift left
	asl								
	sta		timepieceGfxPtrs			; Update Timepiece Graphics Pointer		
	lda		#$fd						; Load $FD.
	sta		snakeMotionPtr				; Set snakeMotionPtr (?)

UpdateInvItemPos
	; --------------------------------------------------------------------------
	; POSITION INVENTORY OBJECTS
	; Positions the strip of 3 items visible in the inventory.
	; --------------------------------------------------------------------------
	ldx		#$02						; Start at Index 2.				

invObjPosLoop
	jsr		lfef4						; Update Position for Item X.
	inx									; Next Item.
	cpx		#$05						; Loop until 5.
	bcc		invObjPosLoop				; Loop.	
	bit		majorEventFlag				; Check Major Event (Death).	
	bpl		invItemSelectCycle			; If Clear, Normal Gameplay 
										; (Selection Allowed).

	; --------------------------------------------------------------------------
	; DEATH / MAJOR EVENT SEQUENCE
	; Handles Indy dissolving upon death.
	; --------------------------------------------------------------------------										
	lda		frameCount					; Get current frame count.
	bvs		indyHatPause				; Branch if Overflow Set
	and		#$0f						; Mask lower 4 bits.
	bne		jmpToNewFrame				; If not 0 (Speed control), Skip.	
	ldx		indySpriteHeight			; Load Indy Height.		
	dex									; Decrease Height (delete Indy part)
	stx		soundChan1EffectTimer		; sound update				
	cpx		#$03						; Check if height is at hat (3 lines).
	bcc		removeIndySpriteLine		; If < 3, delete hat			
	lda		#$8f						; Load Y Position?
	sta		weaponPosY					; Reset Weapon Y Position.
	stx		indySpriteHeight			; Save new Height.		
	bcs		jmpToNewFrame				; Always branch.	
removeIndySpriteLine
	sta		frameCount					; Reset Frame Count
	sec									; Set Carry
	ror		majorEventFlag				; Rotate Major Event Flag	
indyHatPause
	cmp		#$3c						; Compare A with 60
	bcc		resetIndyAfterDeath			; If < 60, Continue.		
	bne		indyvanish					; If != 60, Reset.
	sta		soundChan1EffectTimer		; Store in Timer.			
indyvanish
	ldy		#$00						; Clear Y.
	sty		indySpriteHeight			; Set Height 0 (Invisible)

resetIndyAfterDeath
	cmp		#$78						; Compare with 120.
	bcc		jmpToNewFrame				; If < 120, Exit.

	; --------------------------------------------------------------------------
	; LIFE LOSS / RESPAWN
	; --------------------------------------------------------------------------		
	lda		#HEIGHT_INDY_SPRITE			; Reset Height default.					
	sta		indySpriteHeight			; Store.		
	sta		soundChan1EffectTimer		; Store.			
	sta		majorEventFlag				; Reset Flag.	
	dec		livesLeft					; Decrement Lives.
	bpl		jmpToNewFrame				; If Lives >= 0, Continue Game.	
	lda		#$ff						; Game Over State?
	sta		majorEventFlag				; Set Flag.	
	bne		jmpToNewFrame				; Exit.

invItemSelectCycle
	; --------------------------------------------------------------------------
	; INVENTORY SELECTION
	; Check inputs to cycle through inventory items.
	; --------------------------------------------------------------------------
	lda		currentRoomId				; Get the current screen id.		
	cmp		#ID_ARK_ROOM				; Check if in Ark Room.
	bne		checkInvCycle				; If not, allow selection.	

jmpToNewFrame
	lda		#<newFrame					; Load LSB address to start new frame
	sta		bankSwitchJMPAddrLo			; store to dynamic jump
	lda		#>newFrame					; Load MSB address to start new frame
	sta		bankSwitchJMPAddrHi			; store to dynamic jump		
	jmp		JumpToBank0					; Jump to routine in Bank 0

checkInvCycle
	bit		eventState					; Check general event state.
	bvs		finishInvCycle				; If Overflow Set (Bit 6?), Block Selection.	
	bit		mesaSideState				; Check Mesa State.	
	bmi		finishInvCycle				; If Bit 7 Set (Parachuting), Block.	
	bit		grenadeState				; Check Grenade State.	
	bmi		finishInvCycle				; If Bit 7 Set (Thrown), Block.	
	lda		#$07					
	and		frameCount				
	bne		finishInvCycle				; check to move inventory selector ~8 frames	
	lda		inventoryItemCount			; get number of inventory items		
	and		#MAX_INVENTORY_ITEMS				
	beq		finishInvCycle				; branch if Indy not carrying items		
	ldx		selectedItemSlot			
	lda		invSlotLo,x					; get inventory graphic LSB value		
	cmp		#<timepiece12_00			
	bcc		checkInvItemChoice			; branch if the item is not open clock sprite				
	lda		#<closedTimepieceSprite		; close the timepiece			

checkInvItemChoice
	bit		SWCHA						; check joystick values
	bmi		checkInvCycleLeft			; branch if left joystick not pushed right		
	sta		invSlotLo,x					; set inventory graphic LSB value

checkInvCycleRight
	inx								
	inx									; Move to next slot (2-byte stride)
	cpx		#$0b					
	bcc		continueInvCycleRight					
	ldx		#$00						; Wrap around to first slot if > 10

continueInvCycleRight
	ldy		invSlotLo,x					; get inventory graphic LSB value
	beq		checkInvCycleRight			; If empty (0), skip and keep searching Right		
	bne		setSelectedInvSlot			; Found an item, select it

checkInvCycleLeft
	bvs		finishInvCycle				; branch if left joystick not pushed left	
	sta		invSlotLo,x					

cycleInvLeft
	dex								
	dex									; Move to previous slot
	bpl		continueInvCycleLeft					
	ldx		#$0a						; Wrap around to last slot if < 0

continueInvCycleLeft
	ldy		invSlotLo,x					
	beq		cycleInvLeft				; If empty (0), skip and keep searching Left

setSelectedInvSlot
	stx		selectedItemSlot			; Update the active slot index	
	tya									; move inventory graphic LSB to A
	lsr									; divide value by 8 (HEIGHT_ITEM_SPRITES)
	lsr								
	lsr								
	sta		selectedInventoryId			; Convert Sprite Pointer LSB -> Item ID		
	cpy		#<invHourGlassSprite				
	bne		finishInvCycle				; branch if the Hour Glass not selected
	ldy		#ID_MESA_FIELD				; are we in Mesa Field?
	cpy		currentRoomId				; compare room id	
	bne		finishInvCycle				; Branch if not in Mesa Field context.

	; --------------------------------------------------------------------------
	; INITIALIZE GRAPPLE IN MESA
	; Sets up a grapple in the Mesa Field.
	; Positions the "Weapon" (grapple crosshair) relative to Indy.
	; --------------------------------------------------------------------------		
	lda		#$49						; Load Event State value.
	sta		eventState					; Set State.
	lda		indyPosY					; Get Indy's vertical position.
	adc		#$09						; Add Offset for crosshair.
	sta		weaponPosY					; Set Object Y to Indy Y + 9.
	lda		indyPosX					; Get Indy's horizontal position.
	adc		#$09						; Add Offset for crosshair.
	sta		weaponPosX					; Set Object X to Indy X + 9.

finishInvCycle
	lda		eventState					; Check Event State.
	bpl		handleInvSelectAdj			; If Bit 7 Clear, go to standard collision.

	; --------------------------------------------------------------------------
	; EVENT STATE UPDATE
	; If Bit 7 is set, we are in an active sequence (swinging grapple).
	; Increments the state value (Timer/Stage).
	; --------------------------------------------------------------------------			
	cmp		#$bf						; Check if state has reached terminal value.			
	bcs		handleInvSelEdgeCase		; If >= $BF, handle end case.			
	adc		#$10						; Increment High Nibble (Timer/Stage).
	sta		eventState					; Update State.
	ldx		#$03						; Load Index 3.
	jsr		invSelectAdjHandler			; Call Handler.	
	jmp		jmpObjHitHandeler			; Return.		

handleInvSelEdgeCase
	lda		#$70						; Load $70.
	sta		weaponPosY					; Reset Object Y.
	lsr									; Divide by 2 -> $38.
	sta		eventState					; Set Event State to $38 (Bit 7 Clear).
	bne		jmpObjHitHandeler			; Return.

handleInvSelectAdj
	; --------------------------------------------------------------------------
	; INVENTORY SELECTION / CURSOR ALIGNMENT
	; Checks if Indy's position aligns with the crosshair cursor.
	; Used to determine if Indy has "hit" the target when using the grapple.
	; --------------------------------------------------------------------------
	bit		eventState					; Check State.
	bvc		jmpObjHitHandeler			; If Bit 6 Clear, Exit.		
	ldx		#$03						; Load Index 3.
	jsr		invSelectAdjHandler			; Update Cursor/Object Position logic?

	; Check Horizontal Alignment		
	lda		weaponPosX					; Get crosshair X.
	sec									; Set Carry.
	sbc		#$04						; Subtract offset.
	cmp		indyPosX					; Compare with Indy X.
	bne		checkPosition				; If not equal, check boundaries.

	lda		#$03						; Load Mask $03 (Bits 0, 1)
	bne		handleBitwiseUpdate			; Jump to Update State.

checkPosition
	cmp		#$11						; Check Left Boundary/Specific X.
	beq		handleLeftBoundary					
	cmp		#$84						; Check Right Boundary/Specific X.
	bne		handleYBoundary				; If not equal, check Vertical.

handleLeftBoundary
	lda		#$0f						; Load Mask $0F.
	bne		handleBitwiseUpdate			; Jump to Update State.

handleYBoundary
	; Check Vertical Alignment
	lda		weaponPosY					; Get crosshair Y.
	sec									; Set Carry.
	sbc		#$05						; Subtract offset.
	cmp		indyPosY					; Compare with Indy Y.
	bne		checkBoundary				; If not equal, check boundary.
	lda		#$0c						; Load Mask $0C (Bits 2, 3).

handleBitwiseUpdate
	eor		eventState					; Toggle State Bits based on alignment.
	sta		eventState					; Store State.
	bne		jmpObjHitHandeler			; Return.

checkBoundary
	cmp		#$4a						; Check Y Boundary.
	bcs		handleLeftBoundary			; If >= $4A, trigger special value update.

jmpObjHitHandeler
	; --------------------------------------------------------------------------
	; BANK SWITCH RETURN
	; Return to CheckObjectCollisions in Bank 0.
	; --------------------------------------------------------------------------
	lda		#<checkObjectHit					
	sta		bankSwitchJMPAddrLo					
	lda		#>checkObjectHit				
	sta		bankSwitchJMPAddrHi					
JumpToBank0
	lda		#LDA_ABS					
	sta		loopCounter					
	lda		#<BANK0STROBE					
	sta		tempGfxHolder					
	lda		#>BANK0STROBE			
	sta		bankSwitchJMPOpcode					
	lda		#JMP_ABS				
	sta		bankSwitchJMPAddr					
	jmp.w	loopCounter					


;
; This kernel handles the visuals for the "Ark Room" (Room ID 13).
; This room serves as both the Start Screen (Indy on Pedestal) and the End Screen (Winning Animation).
; Unlike standard rooms, it uses a dedicated scanline loop to draw the Ark (Top) and Pedestal (Bottom).
;
; Visual Logic:
; 1. Top Section (Scanlines 0-18 approx): Checks logic to draw the Ark of the Covenant.
;    - The Ark is only drawn if resetEnableFlag is positive (indicating Win State).
; 2. Mid/Bottom Section: Draws Indy standing on the Lifting Pedestal.

drawArkRoom
	sta		WSYNC					
;---------------------------------------
	cpx		#$12						; Compare scanline with 18.	
	bcc		checkToDrawArk				; Branch if < 18 (Ark area).	
	txa									; Move scanline to A.
	sbc		indyPosY					; Subtract Indy Y to check relative position
	bmi		nextArkRoomScanline			; If negative, skip drawing Indy line		
	cmp 	#(HEIGHT_INDY_SPRITE-1)*2	; Compare with Height*2
										; (Double-height sprite check) 				
	bcs		drawLiftingPedestal			; If > Height*2, draw pedestal bits instead		
	lsr									; Divide by 2 (Sprite shift)
	tay									; Transfer to Y index
	lda		IndyStandSprite,y			; Load Indy standing sprite data		
	jmp		drawPlayer1Sprite			; Jump to common draw routine		

drawLiftingPedestal
	and		#$03						; Mask low 2 bits for Pedestal pattern
	tay									; Transfer to Y
	lda		PedestalLiftSprite,y		; Load Pedestal lift diamond Sprite data
					
drawPlayer1Sprite
	sta		GRP1						; Store in GRP1 (Player 1 Graphics)
	lda		indyPosY					; Load Indy Y Position
	sta		COLUP1						; Set Color P1 (flash indy sprite colors)

nextArkRoomScanline
	inx									; Increment scanline counter
	cpx		#$90						; check if kernel finished (144 scanlines)
	bcs		drawArkBody				; Branch if >= 144 to finish up	
	bcc		drawArkRoom					; Loop back if not done

checkToDrawArk
	bit		resetEnableFlag				; Check Game State Flag	
	bmi		skipArkDraw					; Branch if Minus (Bit 7 Set).
										; If Set, Ark is HIDDEN.
	txa									; Move scanline to A.
	sbc		#HEIGHT_ARK					; Subtract Ark Height
	bmi		skipArkDraw					; Skip if outside Ark area
	tay									; Transfer to Y
	lda		arkTopWingsSprite,y			; Load Ark Sprite data
	sta		GRP1						; Draw Ark in GRP1
	txa									; Move scanline to A.
	adc		frameCount					; Add frame count for color cycling
	asl									; Shift left
	sta		COLUP1						; Set Ark Color (Rainbow effect)

skipArkDraw
	inx									; Increment scanline
	cpx		#$0f						; Compare with 15
	bcc		drawArkRoom					; Loop

drawArkBody
	sta		WSYNC					
;---------------------------------------
	cpx		#$20						; Compare with 32.	
	bcs		checkToDrawPedestal			; Branch if >= 32.		
	bit		resetEnableFlag				; Check flag.	
	bmi		arkDrawLoop		; Skip.		
	txa									; Move scanline to A.
	ldy		#%01111110					; Ark Body Gfx		
	and		#$0e						; Mask bits 1-3.
	bne		shadeArkBody				; draw and color ark body	
	ldy		#%11111111					; Ark Handles Gfx		
shadeArkBody
	sty		GRP0					
	txa								
	eor		#$ff						;Shade light to dark gold
	sta		COLUP0					

arkDrawLoop
	inx								
	cpx		#$1d						; Compare with 29.
	bcc		drawArkBody					; Loop.
	lda		#$00						; Load 0.
	sta		GRP0						; Clear GRP0.
	sta		GRP1						; Clear GRP1.
	beq		drawArkRoom					; Jump back to main loop.

checkToDrawPedestal
	txa									; Move scanline to A.
	sbc		#$90						; Subtract 144 (Y start).
	cmp		#HEIGHT_PEDESTAL			; Compare height.		
	bcc		drawPedestal				; Draw Ppdestal	
	jmp		drawInventoryKernel			; Draw inventory bar		

drawPedestal
	lsr									; Divide by 4.
	lsr								
	tay									; Transfer to Y.
	lda		pedestalSprite,y			; Load Pedestal Sprite.		
	sta		GRP0						; Store to GRP0.
	stx		COLUP0						; Set Color P0.
	inx									; Increment Scanline.
	bne		drawArkBody					; Unconditional branch (X!=0)

selectRoomHandler:				
	lda		currentRoomId				; get the current screen id		
	asl									; multiply screen id by 2
	tax								
	lda		RoomHandlerJmpTableHi,x		; get room handeler from jump table				
	pha									; push MSB
	lda		RoomHandlerJmpTableLo,x		; Get LSB			
	pha									; push to stack too
	rts									; return 

mesaFieldRoomHandler:
	; --------------------------------------------------------------------------
	; MESA FIELD / VALLEY OF POISON (Bank 1 Logic)
	; --------------------------------------------------------------------------
	; This makes sure that everything is "pinned"
	; to the vertical center of the screen ($7F) during a scroll
	; --------------------------------------------------------------------------
       lda    #$7f                    	; Y screen center 
       sta    p0PosY                     	; Pin Player 0 to Center Y
       sta    m0PosY                    ; Pin Missile 0 to Center Y 
       sta    ballPosY                  ; Pin Ball to Center Y  
       bne    finishRoomHandle          ; Exit         

spiderRoomHandler:
       ldx    #$00						; X = 0 (Spider Object / Player 0 Index)                    
       ldy    #$01                    	; Y = Offset to Indy's Y Position in array
       bit    CXP1FB                  	; Check P1 (Indy) vs Playfield (Walls) hit
       bmi    updateMoveSpider          ; If Indy touches walls, Agro Spider
       bit    spiderRoomState			; ; Check bit 7 of spiderRoomState
	   									; (Set if Indy touches the Web/M0)                   
       bmi    updateMoveSpider			; If Indy trapped in web, Spider
	   									; enters "Aggressive Mode" (Chases Indy)
	; Mode: Passive (Guard Nest)
	; Spider moves slowly (once every 8 frames) back to the top of the screen.
       lda    frameCount	          	; Get global frame counter           
       and    #$07                    	; check every 8th frame
       bne    animateSpider             ; If not the 8th frame, skip movement update     
       ldy    #$05                    	; Set Target Index to 5 (a unused/static slot?) 
       lda    #$4c                    	; Load Passive Target X?
       sta    unused_CD                 ; (Unused write)   
       lda    #$23                    	; Set Passive home Target Y = $23
       sta    targetPosY                ; Store in target variable for
updateMoveSpider:
	; Calls generic handler to move Object[X] towards Object[Y].
	; Valid inputs at this point:
	;   Aggressive: X=0(Spider), Y=Indy Offset. Result: Spider moves to Indy.
	;   Passive:    X=0(Spider), Y=5(Static).   Result: Spider moves to Home ($23)
       jsr    updateMoveToTarget        ; Execute movement logic          
animateSpider:
       lda    #$80                    	; Set bit 7
       sta    screenEventState			; Update screen event flags
	; Animation Logic
	; Calculates a sprite frame based on position to simulate scuttling.                  	
       lda    p0PosY					; Load Spider Vertical Position                   
       and    #$01                    	; Check LSB (Odd/Even pixel)
       ror    objectPosX                ; Rotate Spider X into Carry   
       rol                            	; Rotate Carry into A 
       tay                            	; Use result as index into sprite table
       ror                            	; Restore Carry
       rol    objectPosX                ; Restore Spider X Position    
       lda    spiderSpriteTable,y    	; Load the appropriate Spider Sprite frame            
       sta    p0GfxPtrLo                ; Store Low Byte of sprite pointer     
       lda    #>spiderSprites    		; Start at first spider frame
       sta    p0GfxPtrHi                     
       lda    m0PosYShadow                     
       bmi    finishRoomHandle                   
       ldx    #$50                    
       stx    m0PosX                     
       ldx    #$26                    
       stx    m0PosY                     
       lda    spiderRoomState                     
       bmi    finishRoomHandle                   
       bit    majorEventFlag                     
       bmi    finishRoomHandle                   
       and    #$07                    
       bne    lf592                   
       ldy    #$06                    
       sty    spiderRoomState                     
lf592:
       tax                            
       lda    lfcd2,x                 
       sta    m0PosYShadow                     
       dec    spiderRoomState                     
finishRoomHandle:
       jmp    lf833                   

lf59d:
       lda    #$80                    
       sta    screenEventState                     
       ldx    #$00                    
       bit    majorEventFlag                     
       bmi    lf5ab                   
       bit    pickupStatusFlags                     
       bvc    lf5b7                   
lf5ab:
       ldy    #$05                    
       lda    #$55                    
       sta    unused_CD                     
       sta    targetPosY                     
       lda    #$01                    
       bne    lf5bb                   

lf5b7:
       ldy    #$01                    
       lda    #$03                    
lf5bb:
       and    frameCount                     
       bne    lf5ce                   
       jsr    updateMoveToTarget                   
       lda    p0PosY                     
       bpl    lf5ce                   
       cmp    #$a0                    
       bcc    lf5ce                   
       inc    p0PosY                     
       inc    p0PosY                     
lf5ce:
       bvc    lf5de                   
       lda    p0PosY                     
       cmp    #$51                    
       bcc    lf5de                   
       lda    pickupStatusFlags                     
       sta    screenInitFlag                     
       lda    #$00                    
       sta    pickupStatusFlags                     
lf5de:
       lda    objectPosX                     
       cmp    indyPosX                     
       bcs    lf5e7                   
       dex                            
       eor    #$03                    
lf5e7:
       stx    REFP0                   
       and    #$03                    
       asl                            
       asl                            
       asl                            
       asl                            
       sta    p0GfxPtrLo                     
       lda    frameCount                     
       and    #$7f                    
       bne    lf617                   
       lda    p0PosY                     
       cmp    #$4a                    
       bcs    lf617                   
       ldy    EventStateOffset                     
       beq    lf617                   
       dey                            
       sty    EventStateOffset                     
       ldy    #$8e                    
       adc    #$03                    
       sta    m0PosY                     
       cmp    indyPosY                     
       bcs    lf60f                   
       dey                            
lf60f:
       lda    objectPosX                     
       adc    #$04                    
       sta    m0PosX                     
       sty    m0PosYShadow                     
lf617:
       ldy    #$7f                    
       lda    m0PosYShadow                     
       bmi    lf61f                   
       sty    m0PosY                     
lf61f:
       lda    weaponPosY                     
       cmp    #$52                    
       bcc    lf627                   
       sty    weaponPosY                     
lf627:
       jmp    lf833                   

lf62a:
       ldx    #$3a                    
       stx    dungeonBlock4                     
       ldx    #$85                    
       stx    PF2GfxPtrLo                     
       ldx    #$03                    
       stx    mesaLandingBonus            
       bne    lf63a                   

lf638
       ldx    #$04                    
lf63a:
       lda    lfcd8,x                 
       and    frameCount                     
       bne    lf656                   
       ldy    dynamicGfxData,x                   
       lda    #$08                    
       and    objOffsetPosY,x                   
       bne    lf65c                   
       dey                            
       cpy    #$14                    
       bcs    lf654                   
lf64e:
       lda    #$08                    
       eor    objOffsetPosY,x                   
       sta    objOffsetPosY,x                   
lf654:
       sty    dynamicGfxData,x                   
lf656:
       dex                            
       bpl    lf63a                   
       jmp    lf833                   

lf65c:
       iny                            
       cpy    #$85                    
       bcs    lf64e                   
       bcc    lf654                   

lf663
       bit    mesaSideState                     
       bpl    lf685                   
       bvc    lf66d                   
       dec    indyPosX                     
       bne    lf685                   
lf66d:
       lda    frameCount                     
       ror                            
       bcc    lf685                   
       lda    SWCHA                   
       sta    indyDir                     
       ror                            
       ror                            
       ror                            
       bcs    lf680                   
       dec    indyPosX                     
       bne    lf685                   
lf680:
       ror                            
       bcs    lf685                   
       inc    indyPosX                     
lf685:
       lda    #$02                    
       and    mesaSideState                     
       bne    lf691                   
       sta    eventState                     
       lda    #$0b                    
       sta    p0PosY                     
lf691:
       ldx    indyPosY                     
       lda    frameCount                     
       bit    mesaSideState                     
       bmi    lf6a3                   
       cpx    #$15                    
       bcc    lf6a3                   
       cpx    #$30                    
       bcc    lf6aa                   
       bcs    lf6a9                   

lf6a3:
       ror                            
       bcc    lf6aa                   
lf6a6:
       jmp    lf833                   

lf6a9:
       inx                            
lf6aa:
       inx                            
       stx    indyPosY                     
       bne    lf6a6                   

lf6af:
       lda    indyPosX                     
       cmp    #$64                    
       bcc    lf6bc                   
       rol    blackMarketState                     
       clc                            
       ror    blackMarketState                     
       bpl    lf6de                   
lf6bc:
       cmp    #$2c                    
       beq    lf6c6                   
       lda    #$7f                    
       sta    ballPosY                     
       bne    lf6de                   

lf6c6:
       bit    blackMarketState                     
       bmi    lf6de                   
       lda    #$30                    
       sta    indyPosXSet                     
       ldy    #$00                    
       sty    ballPosY                     
       ldy    #$7f                    
       sty    p0SpriteHeight                     
       sty    snakePosY                     
       inc    indyPosX                     
       lda    #$80                    
       sta    majorEventFlag                     
lf6de:
       jmp    lf833                   

lf6e1:
       ldy    objOffsetPosY                     
       dey                            
       bne    lf6de                   
       lda    treasureIndex                     
       and    #$07                    
       bne    lf71d                   
       lda    #$40                    
       sta    screenEventState                     
       lda    secondsTimer                     
       lsr                            
       lsr                            
       lsr                            
       lsr                            
       lsr                            
       tax                            
       ldy    lfcdc,x                 
       ldx    lfcaa,y                 
       sty    loopCounter                     
       jsr    lf89d                   
       bcc    lf70a                   
lf705:
       inc    objOffsetPosY                     
       bne    lf6de                   


       .byte $00 ; |        | $f709 unused


lf70a:
       ldy    loopCounter                     
       tya                            
       ora    treasureIndex                     
       sta    treasureIndex                     
       lda    lfca2,y                 
       sta    p0PosY                     
       lda    lfca6,y                 
       sta    objOffsetPosY                     
       bne    lf6de                   

lf71d:
       cmp    #$04                    
       bcs    lf705                   
       rol    treasureIndex                     
       sec                            
       ror    treasureIndex                     
       bmi    lf705                   

lf728: ;map room stuff...
       ldy    #$00                    
       sty    ballPosY                     
       ldy    #$7f                    
       sty    p0SpriteHeight                     
       sty    snakePosY                     
       lda    #$71                    
       sta    indyPosXSet                     
       ldy    #$4f                    
       lda    #$3a                    
       cmp    indyPosY                     
       bne    lf74a                   
       lda    selectedInventoryId          
       cmp    #$07                    
       beq    lf74c                   
       lda    #$5e                    
       cmp    indyPosX                     
       beq    lf74c                   
lf74a:
       ldy    #$0d                    
lf74c:
       sty    objOffsetPosY                     
       lda    secondsTimer                     
       sec                            
       sbc    #$10                    
       bpl    lf75a                   
       eor    #$ff                    
       sec                            
       adc    #$00                    
lf75a:
       cmp    #$0b                    
       bcc    lf760                   
       lda    #$0b                    
lf760:
       sta    p0PosY                     
       bit    mapRoomState                     
       bpl    lf78b                   
       cmp    #$08                    
       bcs    lf787                   
       ldx    selectedInventoryId          
       cpx    #$0e                    
       bne    lf787                   
       stx    mapRoomBonus               
       lda    #$04                    
       and    frameCount                     
       bne    lf787                   
       lda    arkLocationRegionId                     
       and    #$0f                    
       tax                            
       lda    lfac2,x                 
       sta    weaponPosX                     
       lda    lfad2,x                 
       bne    lf789                   

lf787:
       lda    #$70                    
lf789:
       sta    weaponPosY                     
lf78b:
       rol    mapRoomState                     
       lda    #$3a                    
       cmp    indyPosY                     
       bne    lf7a2                   
       cpy    #$4f                    
       beq    lf79d                   
       lda    #$5e                    
       cmp    indyPosX                     
       bne    lf7a2                   
lf79d:
       sec                            
       ror    mapRoomState                     
       bmi    lf7a5                   
lf7a2:
       clc                            
       ror    mapRoomState                     
lf7a5:
       jmp    lf833                   

lf7a8:
       lda    #$08                    
       and    pickupItemsStatus                     
       bne    lf7c0                   
       lda    #$4c                    
       sta    indyPosXSet                     
       lda    #$2a                    
       sta    ballPosY                     
       lda    #$ba                    
       sta    timepieceGfxPtrs                     
       lda    #$fa                    
       sta    snakeMotionPtr                     
       bne    lf7c4                   

lf7c0:
       lda    #$f0                    
       sta    ballPosY                     
lf7c4:
       lda    entranceRoomEventState                     
       and    #$0f                    
       beq    lf833                   
       sta    p0SpriteHeight                     
       ldy    #$14                    
       sty    p0PosY                     
       ldy    #$3b                    
       sty    p0GfxState                     
       iny                            
       sty    objectState                     
       lda    #$c1                    
       sec                            
       sbc    p0SpriteHeight                     
       sta    p0GfxPtrLo                     
       bne    lf833                   

lf7e0:
       lda    frameCount                     
       and    #$18                    
       adc    #$e0                    
       sta    p0GfxPtrLo                     
       lda    frameCount                     
       and    #$07                    
       bne    lf80f                   
       ldx    #$00                    
       ldy    #$01                    
       lda    indyPosY                     
       cmp    #$3a                    
       bcc    lf80c                   
       lda    indyPosX                     
       cmp    #$2b                    
       bcc    lf802                   
       cmp    #$6d                    
       bcc    lf80c                   
lf802:
       ldy    #$05                    
       lda    #$4c                    
       sta    unused_CD                     
       lda    #$0b                    
       sta    targetPosY                     
lf80c:
       jsr    updateMoveToTarget                   
lf80f:
       ldx    #$4e                    
       cpx    indyPosY                     
       bne    lf833                   
       ldx    indyPosX                     
       cpx    #$76                    
       beq    lf81f                   
       cpx    #$14                    
       bne    lf833                   
lf81f:
       lda    SWCHA                   
       and    #$0f                    
       cmp    #$0d                    
       bne    lf833                   
       sta    escapePrisonPenalty       
       lda    #$4c                    
       sta    indyPosX                     
       ror    entranceRoomEventState                     
       sec                            
       rol    entranceRoomEventState                     
lf833
       lda    #<setupScreenAndObj                 
       sta    bankSwitchJMPAddrLo                     
       lda    #>setupScreenAndObj                 
       sta    bankSwitchJMPAddrHi                     
       jmp    JumpToBank0                   

lf83e
       lda    #$40                    
       sta    screenEventState                     
       bne    lf833                   

drawScreen
	sta		WSYNC					
;---------------------------------------
	sta		HMCLR					
	sta		CXCLR					
	ldy		#$ff					
	sty		PF1						
	sty		PF2						
	ldx		currentRoomId					
	lda		room_PF0_gfx,x					
	sta		PF0						
	iny								
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	sty		VBLANK					
	sty		scanline				
	cpx		#$04					
	bne		lf865					
	dey								
lf865
	sty		ENABL					
	cpx		#$0d					
	beq		lf874					
	bit		majorEventFlag					
	bmi		lf874					
	ldy		SWCHA					
	sty		REFP1					
lf874
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	ldy		currentRoomId					
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	lda		room_PF1_gfx,y					
	sta		PF1						
	lda		room_PF2_gfx,y					
	sta		PF2						
	ldx		KernelJumpTableIndex,y					
	lda		kernelJumpTable+1,x				
	pha								
	lda		kernelJumpTable,x					
	pha								
	lda		#$00					
	tax								
	sta		loopCounter					
	rts								

lf89d:
       lda    lfc75,x                 
       lsr                            
       tay                            
       lda    lfce2,y                 
       bcs    lf8ad                   
       and    basketItemsStatus                     
       beq    lf8ac                   
       sec                            
lf8ac
       rts                            

lf8ad									;called dynamically 
       and    pickupItemsStatus                     ;and c7
       bne    lf8ac                   ;return if 0
       clc                            ;if not, clear carry
       rts                            ;return 



updateMoveToTarget
	cpy		#$01					
	bne		lf8bb					
	lda		indyPosY					
	bmi		lf8cc					
lf8bb
	lda		p0PosY,x				 
	cmp.wy	p0PosY,y				 
	bne		lf8c6					
	cpy		#$05					
	bcs		lf8ce					
lf8c6
	bcs		lf8cc					
	inc		p0PosY,x				 
	bne		lf8ce					
lf8cc
	dec		p0PosY,x				 
lf8ce
	lda		objectPosX,x				 
	cmp.wy	objectPosX,y				 
	bne		lf8d9					
	cpy		#$05					
	bcs		lf8dd					
lf8d9
	bcs		lf8de					
	inc		objectPosX,x				 
lf8dd
	rts								

lf8de
	dec		objectPosX,x				 
	rts								

lf8e1
	lda		p0PosY,x				 
	cmp		#$53					
	bcc		lf8f1					
lf8e7
	rol		arkLocationRegionId,x				
	clc								
	ror		arkLocationRegionId,x				
	lda		#$78					
	sta		p0PosY,x				 
	rts								

lf8f1
	lda		objectPosX,x				 
	cmp		#$10					
	bcc		lf8e7					
	cmp		#$8e					
	bcs		lf8e7					
	rts								

	;padding to $F900
	.byte	$00,$00,$00,$00				

BlackMarketPlayerGraphics
	.byte $00 ; |........| $F900
	.byte $E4 ; |XXX..X..| $F901
	.byte $7E ; |.XXXXXX.| $F902
	.byte $9A ; |X..XX.X.| $F903
	.byte $E4 ; |XXX..X..| $F904
	.byte $A6 ; |X.X..XX.| $F905
	.byte $5A ; |.X.XX.X.| $F906
	.byte $7E ; |.XXXXXX.| $F907
	.byte $E4 ; |XXX..X..| $F908
	.byte $7F ; |.XXXXXXX| $F909
	.byte $00 ; |........| $F90A
	.byte $00 ; |........| $F90B
	.byte $84 ; |X....X..| $F90C
	.byte $08 ; |....X...| $F90D
	.byte $2A ; |..X.X.X.| $F90E
	.byte $22 ; |..X...X.| $F90F
	.byte $00 ; |........| $F910
	.byte $22 ; |..X...X.| $F911
	.byte $2A ; |..X.X.X.| $F912
	.byte $08 ; |....X...| $F913
	.byte $00 ; |........| $F914
	.byte $B9 ; |X.XXX..X| $F915
	.byte $D4 ; |XX.X.X..| $F916
	.byte $89 ; |X...X..X| $F917
	.byte $6C ; |.XX.XX..| $F918
	.byte $7B ; |.XXXX.XX| $F919
	.byte $7F ; |.XXXXXXX| $F91A
	.byte $81 ; |X......X| $F91B
	.byte $A6 ; |X.X..XX.| $F91C
	.byte $3F ; |..XXXXXX| $F91D
	.byte $77 ; |.XXX.XXX| $F91E
	.byte $07 ; |.....XXX| $F91F
	.byte $7F ; |.XXXXXXX| $F920
	.byte $86 ; |X....XX.| $F921
	.byte $89 ; |X...X..X| $F922
	.byte $3F ; |..XXXXXX| $F923
	.byte $1F ; |...XXXXX| $F924
	.byte $0E ; |....XXX.| $F925
	.byte $0C ; |....XX..| $F926
	.byte $00 ; |........| $F927
	.byte $C1 ; |XX.....X| $F928
	.byte $B6 ; |X.XX.XX.| $F929
	.byte $00 ; |........| $F92A
	.byte $00 ; |........| $F92B
	.byte $00 ; |........| $F92C
	.byte $81 ; |X......X| $F92D
	.byte $1C ; |...XXX..| $F92E
	.byte $2A ; |..X.X.X.| $F92F
	.byte $55 ; |.X.X.X.X| $F930
	.byte $2A ; |..X.X.X.| $F931
	.byte $14 ; |...X.X..| $F932
	.byte $3E ; |..XXXXX.| $F933
	.byte $00 ; |........| $F934
	.byte $A9 ; |X.X.X..X| $F935
	.byte $00 ; |........| $F936
	.byte $E4 ; |XXX..X..| $F937
	.byte $89 ; |X...X..X| $F938
	.byte $81 ; |X......X| $F939
	.byte $7E ; |.XXXXXX.| $F93A
	.byte $9A ; |X..XX.X.| $F93B
	.byte $E4 ; |XXX..X..| $F93C
	.byte $A6 ; |X.X..XX.| $F93D
	.byte $5A ; |.X.XX.X.| $F93E
	.byte $7E ; |.XXXXXX.| $F93F
	.byte $E4 ; |XXX..X..| $F940
	.byte $7F ; |.XXXXXXX| $F941
	.byte $00 ; |........| $F942
	.byte $C9 ; |XX..X..X| $F943
	.byte $89 ; |X...X..X| $F944
	.byte $82 ; |X.....X.| $F945
	.byte $00 ; |........| $F946
	.byte $7C ; |.XXXXX..| $F947
	.byte $18 ; |...XX...| $F948
	.byte $18 ; |...XX...| $F949
	.byte $92 ; |X..X..X.| $F94A
	.byte $7F ; |.XXXXXXX| $F94B
	.byte $1F ; |...XXXXX| $F94C
	.byte $07 ; |.....XXX| $F94D
	.byte $00 ; |........| $F94E
	.byte $00 ; |........| $F94F
	.byte $00 ; |........| $F950

MapRoomPlayerGraphics
	.byte $94 ; |X..X.X..| $F951
	.byte $00 ; |........| $F952
	.byte $08 ; |....X...| $F953
	.byte $1C ; |...XXX..| $F954
	.byte $3E ; |..XXXXX.| $F955
	.byte $3E ; |..XXXXX.| $F956
	.byte $3E ; |..XXXXX.| $F957
	.byte $3E ; |..XXXXX.| $F958
	.byte $1C ; |...XXX..| $F959
	.byte $08 ; |....X...| $F95A
	.byte $00 ; |........| $F95B
	.byte $8E ; |X...XXX.| $F95C
	.byte $7F ; |.XXXXXXX| $F95D
	.byte $7F ; |.XXXXXXX| $F95E
	.byte $7F ; |.XXXXXXX| $F95F
	.byte $14 ; |...X.X..| $F960
	.byte $14 ; |...X.X..| $F961
	.byte $00 ; |........| $F962
	.byte $00 ; |........| $F963
	.byte $2A ; |..X.X.X.| $F964
	.byte $2A ; |..X.X.X.| $F965
	.byte $00 ; |........| $F966
	.byte $00 ; |........| $F967
	.byte $14 ; |...X.X..| $F968
	.byte $36 ; |..XX.XX.| $F969
	.byte $22 ; |..X...X.| $F96A
	.byte $08 ; |....X...| $F96B
	.byte $08 ; |....X...| $F96C
	.byte $3E ; |..XXXXX.| $F96D
	.byte $1C ; |...XXX..| $F96E
	.byte $08 ; |....X...| $F96F
	.byte $00 ; |........| $F970
	.byte $41 ; |.X.....X| $F971
	.byte $63 ; |.XX...XX| $F972
	.byte $49 ; |.X..X..X| $F973
	.byte $08 ; |....X...| $F974
	.byte $00 ; |........| $F975
	.byte $00 ; |........| $F976
	.byte $14 ; |...X.X..| $F977
	.byte $14 ; |...X.X..| $F978
	.byte $00 ; |........| $F979
	.byte $00 ; |........| $F97A
	.byte $08 ; |....X...| $F97B
	.byte $6B ; |.XX.X.XX| $F97C
	.byte $6B ; |.XX.X.XX| $F97D
	.byte $08 ; |....X...| $F97E
	.byte $00 ; |........| $F97F
	.byte $22 ; |..X...X.| $F980
	.byte $22 ; |..X...X.| $F981
	.byte $00 ; |........| $F982
	.byte $00 ; |........| $F983
	.byte $08 ; |....X...| $F984
	.byte $1C ; |...XXX..| $F985
	.byte $1C ; |...XXX..| $F986
	.byte $7F ; |.XXXXXXX| $F987
	.byte $7F ; |.XXXXXXX| $F988
	.byte $7F ; |.XXXXXXX| $F989
	.byte $E4 ; |XXX..X..| $F98A
	.byte $41 ; |.X.....X| $F98B
	.byte $41 ; |.X.....X| $F98C
	.byte $41 ; |.X.....X| $F98D
	.byte $41 ; |.X.....X| $F98E
	.byte $41 ; |.X.....X| $F98F
	.byte $41 ; |.X.....X| $F990
	.byte $41 ; |.X.....X| $F991
	.byte $41 ; |.X.....X| $F992
	.byte $41 ; |.X.....X| $F993
	.byte $41 ; |.X.....X| $F994
	.byte $7F ; |.XXXXXXX| $F995
	.byte $92 ; |X..X..X.| $F996
	.byte $77 ; |.XXX.XXX| $F997
	.byte $77 ; |.XXX.XXX| $F998
	.byte $63 ; |.XX...XX| $F999
	.byte $77 ; |.XXX.XXX| $F99A
	.byte $14 ; |...X.X..| $F99B
	.byte $36 ; |..XX.XX.| $F99C
	.byte $55 ; |.X.X.X.X| $F99D
	.byte $63 ; |.XX...XX| $F99E
	.byte $77 ; |.XXX.XXX| $F99F
	.byte $7F ; |.XXXXXXX| $F9A0
	.byte $7F ; |.XXXXXXX| $F9A1
	
MesaSidePlayerGraphics
	.byte $00 ; |........| $F9A2
	.byte $86 ; |X....XX.| $F9A3
	.byte $24 ; |..X..X..| $F9A4
	.byte $18 ; |...XX...| $F9A5
	.byte $24 ; |..X..X..| $F9A6
	.byte $24 ; |..X..X..| $F9A7
	.byte $7E ; |.XXXXXX.| $F9A8
	.byte $5A ; |.X.XX.X.| $F9A9
	.byte $5B ; |.X.XX.XX| $F9AA
	.byte $3C ; |..XXXX..| $F9AB
	.byte $00 ; |........| $F9AC
	.byte $00 ; |........| $F9AD
	.byte $00 ; |........| $F9AE
	.byte $00 ; |........| $F9AF
	.byte $00 ; |........| $F9B0
	.byte $00 ; |........| $F9B1
	.byte $00 ; |........| $F9B2
	.byte $00 ; |........| $F9B3
	.byte $00 ; |........| $F9B4
	.byte $00 ; |........| $F9B5
	.byte $00 ; |........| $F9B6
	.byte $00 ; |........| $F9B7
	.byte $00 ; |........| $F9B8
	.byte $00 ; |........| $F9B9
	.byte $00 ; |........| $F9BA
	.byte $00 ; |........| $F9BB
	.byte $00 ; |........| $F9BC
	.byte $00 ; |........| $F9BD
	.byte $00 ; |........| $F9BE
	.byte $00 ; |........| $F9BF
	.byte $00 ; |........| $F9C0
	.byte $00 ; |........| $F9C1
	.byte $00 ; |........| $F9C2
	.byte $00 ; |........| $F9C3
	.byte $00 ; |........| $F9C4
	.byte $B9 ; |X.XXX..X| $F9C5
	.byte $E4 ; |XXX..X..| $F9C6
	.byte $81 ; |X......X| $F9C7
	.byte $89 ; |X...X..X| $F9C8
	.byte $55 ; |.X.X.X.X| $F9C9
	.byte $F9 ; |XXXXX..X| $F9CA
	.byte $89 ; |X...X..X| $F9CB
	.byte $F9 ; |XXXXX..X| $F9CC
	.byte $81 ; |X......X| $F9CD
	.byte $FA ; |XXXXX.X.| $F9CE
	.byte $32 ; |..XX..X.| $F9CF
	.byte $1C ; |...XXX..| $F9D0
	.byte $89 ; |X...X..X| $F9D1
	.byte $3E ; |..XXXXX.| $F9D2
	.byte $91 ; |X..X...X| $F9D3
	.byte $7F ; |.XXXXXXX| $F9D4
	.byte $7F ; |.XXXXXXX| $F9D5
	.byte $7F ; |.XXXXXXX| $F9D6
	.byte $7F ; |.XXXXXXX| $F9D7
	.byte $89 ; |X...X..X| $F9D8
	.byte $1F ; |...XXXXX| $F9D9
	.byte $07 ; |.....XXX| $F9DA
	.byte $01 ; |.......X| $F9DB
	.byte $00 ; |........| $F9DC
	.byte $E9 ; |XXX.X..X| $F9DD
	.byte $FE ; |XXXXXXX.| $F9DE
	.byte $89 ; |X...X..X| $F9DF
	.byte $3F ; |..XXXXXX| $F9E0
	.byte $7F ; |.XXXXXXX| $F9E1
	.byte $F9 ; |XXXXX..X| $F9E2
	.byte $91 ; |X..X...X| $F9E3
	.byte $F9 ; |XXXXX..X| $F9E4
	.byte $89 ; |X...X..X| $F9E5
	.byte $3F ; |..XXXXXX| $F9E6
	.byte $F9 ; |XXXXX..X| $F9E7
	.byte $7F ; |.XXXXXXX| $F9E8
	.byte $3F ; |..XXXXXX| $F9E9
	.byte $7F ; |.XXXXXXX| $F9EA
	.byte $7F ; |.XXXXXXX| $F9EB
	.byte $00 ; |........| $F9EC
	.byte $00 ; |........| $F9ED

KernelJumpTableIndex
	.byte 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 4, 6

PedestalLiftSprite
	.byte $1C ; |...XXX..| $F9FC
	.byte $36 ; |..XX.XX.| $F9FD
	.byte $63 ; |.XX...XX| $F9FE
	.byte $36 ; |..XX.XX.| $F9FF

IndySprites
Indy_0
	.byte $18 ; |...XX...| $FA00
	.byte $3C ; |..XXXX..| $FA01
	.byte $00 ; |........| $FA02
	.byte $18 ; |...XX...| $FA03
	.byte $1C ; |...XXX..| $FA04
	.byte $18 ; |...XX...| $FA05
	.byte $18 ; |...XX...| $FA06
	.byte $0C ; |....XX..| $FA07
	.byte $62 ; |.XX...X.| $FA08
	.byte $43 ; |.X....XX| $FA09
	.byte $00 ; |........| $FA0A

Indy_1
	.byte $18 ; |...XX...| $FA0B
	.byte $3C ; |..XXXX..| $FA0C
	.byte $00 ; |........| $FA0D
	.byte $18 ; |...XX...| $FA0E
	.byte $38 ; |..XXX...| $FA0F
	.byte $1C ; |...XXX..| $FA10
	.byte $18 ; |...XX...| $FA11
	.byte $14 ; |...X.X..| $FA12
	.byte $64 ; |.XX..X..| $FA13
	.byte $46 ; |.X...XX.| $FA14
	.byte $00 ; |........| $FA15

Indy_2
	.byte $18 ; |...XX...| $FA16
	.byte $3C ; |..XXXX..| $FA17
	.byte $00 ; |........| $FA18
	.byte $38 ; |..XXX...| $FA19
	.byte $38 ; |..XXX...| $FA1A
	.byte $18 ; |...XX...| $FA1B
	.byte $18 ; |...XX...| $FA1C
	.byte $28 ; |..X.X...| $FA1D
	.byte $48 ; |.X..X...| $FA1E
	.byte $8C ; |X...XX..| $FA1F
	.byte $00 ; |........| $FA20

Indy_3
	.byte $18 ; |...XX...| $FA21
	.byte $3C ; |..XXXX..| $FA22
	.byte $00 ; |........| $FA23
	.byte $38 ; |..XXX...| $FA24
	.byte $58 ; |.X.XX...| $FA25
	.byte $38 ; |..XXX...| $FA26
	.byte $10 ; |...X....| $FA27
	.byte $E8 ; |XXX.X...| $FA28
	.byte $88 ; |X...X...| $FA29
	.byte $0C ; |....XX..| $FA2A
	.byte $00 ; |........| $FA2B

Indy_4
	.byte $18 ; |...XX...| $FA2C
	.byte $3C ; |..XXXX..| $FA2D
	.byte $00 ; |........| $FA2E
	.byte $30 ; |..XX....| $FA2F
	.byte $78 ; |.XXXX...| $FA30
	.byte $34 ; |..XX.X..| $FA31
	.byte $18 ; |...XX...| $FA32
	.byte $60 ; |.XX.....| $FA33
	.byte $50 ; |.X.X....| $FA34
	.byte $18 ; |...XX...| $FA35
	.byte $00 ; |........| $FA36

Indy_5
	.byte $18 ; |...XX...| $FA37
	.byte $3C ; |..XXXX..| $FA38
	.byte $00 ; |........| $FA39
	.byte $30 ; |..XX....| $FA3A
	.byte $38 ; |..XXX...| $FA3B
	.byte $3C ; |..XXXX..| $FA3C
	.byte $18 ; |...XX...| $FA3D
	.byte $38 ; |..XXX...| $FA3E
	.byte $20 ; |..X.....| $FA3F
	.byte $30 ; |..XX....| $FA40
	.byte $00 ; |........| $FA41

Indy_6
	.byte $18 ; |...XX...| $FA42
	.byte $3C ; |..XXXX..| $FA43
	.byte $00 ; |........| $FA44
	.byte $18 ; |...XX...| $FA45
	.byte $38 ; |..XXX...| $FA46
	.byte $1C ; |...XXX..| $FA47
	.byte $18 ; |...XX...| $FA48
	.byte $2C ; |..X.XX..| $FA49
	.byte $20 ; |..X.....| $FA4A
	.byte $30 ; |..XX....| $FA4B
	.byte $00 ; |........| $FA4C

Indy_7	 
	.byte $18 ; |...XX...| $FA4D
	.byte $3C ; |..XXXX..| $FA4E
	.byte $00 ; |........| $FA4F
	.byte $18 ; |...XX...| $FA50
	.byte $18 ; |...XX...| $FA51
	.byte $18 ; |...XX...| $FA52
	.byte $08 ; |....X...| $FA53
	.byte $16 ; |...X.XX.| $FA54
	.byte $30 ; |..XX....| $FA55
	.byte $20 ; |..X.....| $FA56
	.byte $00 ; |........| $FA57

IndyStandSprite
	.byte $18 ; |...XX...| $FA58
	.byte $3C ; |..XXXX..| $FA59
	.byte $00 ; |........| $FA5A
	.byte $18 ; |...XX...| $FA5B
	.byte $3C ; |..XXXX..| $FA5C
	.byte $5A ; |.X.XX.X.| $FA5D
	.byte $3C ; |..XXXX..| $FA5E
	.byte $18 ; |...XX...| $FA5F
	.byte $18 ; |...XX...| $FA60
	.byte $3C ; |..XXXX..| $FA61
	.byte $00 ; |........| $FA62

ParachutingIndySprite
	.byte $3C ; |..XXXX..| $FA63
	.byte $7E ; |.XXXXXX.| $FA64
	.byte $FF ; |XXXXXXXX| $FA65
	.byte $A5 ; |X.X..X.X| $FA66
	.byte $42 ; |.X....X.| $FA67
	.byte $42 ; |.X....X.| $FA68
	.byte $18 ; |...XX...| $FA69
	.byte $3C ; |..XXXX..| $FA6A
	.byte $81 ; |X......X| $FA6B
	.byte $5A ; |.X.XX.X.| $FA6C
	.byte $3C ; |..XXXX..| $FA6D
	.byte $3C ; |..XXXX..| $FA6E
	.byte $38 ; |..XXX...| $FA6F
	.byte $18 ; |...XX...| $FA70
	.byte $00 ; |........| $FA71

snakeMotionTable0:
	.byte HMOVE_L1
	.byte HMOVE_L1
	.byte HMOVE_0
	.byte HMOVE_R1
	.byte HMOVE_R1
	.byte HMOVE_0
	.byte HMOVE_L1
	.byte HMOVE_0
snakeMotionTable1:
	.byte HMOVE_L1
	.byte HMOVE_L1
	.byte HMOVE_0
	.byte HMOVE_R1
	.byte HMOVE_0
	.byte HMOVE_L1
	.byte HMOVE_L1
	.byte HMOVE_0
snakeMotionTable2:
	.byte HMOVE_L1
	.byte HMOVE_0
	.byte HMOVE_R1
	.byte HMOVE_R1
	.byte HMOVE_0
	.byte HMOVE_R1
	.byte HMOVE_R1
	.byte HMOVE_0
snakeMotionTable3:
	.byte HMOVE_R1
	.byte HMOVE_R1
	.byte HMOVE_0
	.byte HMOVE_L1
	.byte HMOVE_L1
	.byte HMOVE_0
	.byte HMOVE_R1


room_PF1_gfx
       .byte $00 ; |        | $fa91
       .byte $00 ; |        | $fa92
       .byte $e0 ; |xxx     | $fa93
       .byte $00 ; |        | $fa94
       .byte $00 ; |        | $fa95
       .byte $c0 ; |xx      | $fa96
       .byte $ff ; |xxxxxxxx| $fa97
       .byte $ff ; |xxxxxxxx| $fa98
       .byte $00 ; |        | $fa99
       .byte $ff ; |xxxxxxxx| $fa9a
       .byte $ff ; |xxxxxxxx| $fa9b
       .byte $f0 ; |xxxx    | $fa9c
       .byte $f0 ; |xxxx    | $fa9d

room_PF2_gfx
       .byte $00 ; |        | $fa9e
       .byte $e0 ; |xxx     | $fa9f
       .byte $00 ; |        | $faa0
       .byte $e0 ; |xxx     | $faa1
       .byte $80 ; |x       | $faa2
       .byte $00 ; |        | $faa3
       .byte $ff ; |xxxxxxxx| $faa4
       .byte $ff ; |xxxxxxxx| $faa5
       .byte $00 ; |        | $faa6
       .byte $ff ; |xxxxxxxx| $faa7
       .byte $ff ; |xxxxxxxx| $faa8
       .byte $c0 ; |xx      | $faa9
       .byte $00 ; |        | $faaa
       .byte $00 ; |        | $faab

room_PF0_gfx
       .byte $c0 ; |xx      | $faac
       .byte $f0 ; |xxxx    | $faad
       .byte $f0 ; |xxxx    | $faae
       .byte $f0 ; |xxxx    | $faaf
       .byte $f0 ; |xxxx    | $fab0
       .byte $f0 ; |xxxx    | $fab1
       .byte $c0 ; |xx      | $fab2
       .byte $c0 ; |xx      | $fab3
       .byte $c0 ; |xx      | $fab4
       .byte $f0 ; |xxxx    | $fab5
       .byte $f0 ; |xxxx    | $fab6
       .byte $f0 ; |xxxx    | $fab7
       .byte $f0 ; |xxxx    | $fab8
       .byte $c0 ; |xx      | $fab9

timeSprite
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_L3 | 7
	.byte HMOVE_L3 | 7
	.byte HMOVE_0  | 0
	


lfac2
	.byte	$63,$62,$6b,$5b,$6a,$5f,$5a,$5a ; $fac2 (*)
	.byte	$6b,$5e,$67,$5a,$62,$6b,$5a,$6b ; $faca (*)
lfad2
	.byte	$22,$13,$13,$18,$18,$1e,$21,$13 ; $fad2 (*)
	.byte	$21,$26,$26,$2b,$2a,$2b,$31,$31 ; $fada (*)

kernelJumpTable:
	.word drawStillPlayer-1 ; $fae2/3
	.word drawPlayField-1 ; $fae4/5
	.word drawThieves-1 ; $fae6/7
	.word drawArkRoom-1 ; $fae8/9

spiderSpriteTable: ;tarantula animation table
	.byte <spiderGfxFrame1 ; $faea
	.byte <spiderGfxFrame2 ; $faeb
	.byte <spiderGfxFrame3 ; $faec
	.byte <spiderGfxFrame4 ; $faed

soundFreqTable
	.byte	$1b,$18,$17,$17,$18,$18,$1b,$1b ; $faee (*)
	.byte	$1d,$18,$17,$12,$18,$17,$1b,$1d ; $faf6 (*)
	.byte	$00,$00							; $fafe (*)


;inventory gfx...
inventorySprites


emptySprite ; blank space
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|

copyrightGfx3 ;copyright3
    ; Used to display "(c) 1982 Atari" in the inventory strip
	.byte $71 ; |.XXX...X|
	.byte $41 ; |.X.....X|
	.byte $41 ; |.X.....X|
	.byte $71 ; |.XXX...X|
	.byte $11 ; |...X...X|
	.byte $51 ; |.X.X...X|
	.byte $70 ; |.XXX....|
	.byte $00 ; |........|

invFluteSprite
	.byte $00 ; |........|
	.byte $01 ; |.......X|
	.byte $3F ; |..XXXXXX|
	.byte $6B ; |.XX.X.XX|
	.byte $7F ; |.XXXXXXX|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|

invParachuteSprite
	.byte $77 ; |.XXX.XXX|
	.byte $77 ; |.XXX.XXX|
	.byte $77 ; |.XXX.XXX|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $77 ; |.XXX.XXX|
	.byte $77 ; |.XXX.XXX|
	.byte $77 ; |.XXX.XXX|

invCoinsSprite
	.byte $1C ; |...XXX..|
	.byte $2A ; |..X.X.X.|
	.byte $55 ; |.X.X.X.X|
	.byte $2A ; |..X.X.X.|
	.byte $55 ; |.X.X.X.X|
	.byte $2A ; |..X.X.X.|
	.byte $1C ; |...XXX..|
	.byte $3E ; |..XXXXX.|

marketplaceGrenadeSprite
	.byte $3A ; |..XXX.X.|
	.byte $01 ; |.......X|
	.byte $7D ; |.XXXXX.X|
	.byte $01 ; |.......X|
	.byte $39 ; |..XXX..X|
	.byte $02 ; |......X.|
	.byte $3C ; |..XXXX..|
	.byte $30 ; |..XX....|


blackMarketGrenadeSprite
	.byte $2E ; |..X.XXX.|
	.byte $40 ; |.X......|
	.byte $5F ; |.X.XXXXX|
	.byte $40 ; |.X......|
	.byte $4E ; |.X..XXX.|
	.byte $20 ; |..X.....|
	.byte $1E ; |...XXXX.|
	.byte $06 ; |.....XX.|

invKeySprite
	.byte $00 ; |........|
	.byte $25 ; |..X..X.X|
	.byte $52 ; |.X.X..X.|
	.byte $7F ; |.XXXXXXX|
	.byte $50 ; |.X.X....|
	.byte $20 ; |..X.....|
	.byte $00 ; |........|
	.byte $00 ; |........|

arkTopWingsSprite
	.byte $FF ; |XXXXXXXX| $FB40
	.byte $66 ; |.XX..XX.| $FB41
	.byte $24 ; |..X..X..| $FB42
	.byte $24 ; |..X..X..| $FB43
	.byte $66 ; |.XX..XX.| $FB44
	.byte $E7 ; |XXX..XXX| $FB45
	.byte $C3 ; |XX....XX| $FB46
	.byte $E7 ; |XXX..XXX| $FB47

copyrightGfx1: ;copyright2
	.byte $17 ; |...X.XXX| $FB48
	.byte $15 ; |...X.X.X| $FB49
	.byte $15 ; |...X.X.X| $FB4A
	.byte $77 ; |.XXX.XXX| $FB4B
	.byte $55 ; |.X.X.X.X| $FB4C
	.byte $55 ; |.X.X.X.X| $FB4D
	.byte $77 ; |.XXX.XXX| $FB4E
	.byte $00 ; |........| $FB4F

invWhipSprite
	.byte $21 ; |..X....X| $FB50
	.byte $11 ; |...X...X| $FB51
	.byte $09 ; |....X..X| $FB52
	.byte $11 ; |...X...X| $FB53
	.byte $22 ; |..X...X.| $FB54
	.byte $44 ; |.X...X..| $FB55
	.byte $28 ; |..X.X...| $FB56
	.byte $10 ; |...X....| $FB57

invShovelSprite
	.byte $01 ; |.......X| $FB58
	.byte $03 ; |......XX| $FB59
	.byte $07 ; |.....XXX| $FB5A
	.byte $0F ; |....XXXX| $FB5B
	.byte $06 ; |.....XX.| $FB5C
	.byte $0C ; |....XX..| $FB5D
	.byte $18 ; |...XX...| $FB5E
	.byte $3C ; |..XXXX..| $FB5F

copyrightGfx0
	.byte $79 ; |.XXXX..X| $FB60
	.byte $85 ; |X....X.X| $FB61
	.byte $B5 ; |X.XX.X.X| $FB62
	.byte $A5 ; |X.X..X.X| $FB63
	.byte $B5 ; |X.XX.X.X| $FB64
	.byte $85 ; |X....X.X| $FB65
	.byte $79 ; |.XXXX..X| $FB66
	.byte $00 ; |........| $FB67

invRevolverSprite
	.byte $00 ; |........| $FB68
	.byte $60 ; |.XX.....| $FB69
	.byte $60 ; |.XX.....| $FB6A
	.byte $78 ; |.XXXX...| $FB6B
	.byte $68 ; |.XX.X...| $FB6C
	.byte $3F ; |..XXXXXX| $FB6D
	.byte $5F ; |.X.XXXXX| $FB6E
	.byte $00 ; |........| $FB6F

invHeadOfRaSprite	
	.byte $08 ; |....X...| $FB70
	.byte $1C ; |...XXX..| $FB71
	.byte $22 ; |..X...X.| $FB72
	.byte $49 ; |.X..X..X| $FB73
	.byte $6B ; |.XX.X.XX| $FB74
	.byte $00 ; |........| $FB75
	.byte $1C ; |...XXX..| $FB76
	.byte $08 ; |....X...| $FB77

closedTimepieceSprite ; unopen pocket watch
	.byte $7F ; |.XXXXXXX| $FB78
	.byte $5D ; |.X.XXX.X| $FB79
	.byte $77 ; |.XXX.XXX| $FB7A
	.byte $77 ; |.XXX.XXX| $FB7B
	.byte $5D ; |.X.XXX.X| $FB7C
	.byte $7F ; |.XXXXXXX| $FB7D
	.byte $08 ; |....X...| $FB7E
	.byte $1C ; |...XXX..| $FB7F

invAnkhSprite
	.byte $3E ; |..XXXXX.| $FB80
	.byte $1C ; |...XXX..| $FB81
	.byte $49 ; |.X..X..X| $FB82
	.byte $7F ; |.XXXXXXX| $FB83
	.byte $49 ; |.X..X..X| $FB84
	.byte $1C ; |...XXX..| $FB85
	.byte $36 ; |..XX.XX.| $FB86
	.byte $1C ; |...XXX..| $FB87

invChaiSprite
	.byte $16 ; |...X.XX.| $FB88
	.byte $0B ; |....X.XX| $FB89
	.byte $0D ; |....XX.X| $FB8A
	.byte $05 ; |.....X.X| $FB8B
	.byte $17 ; |...X.XXX| $FB8C
	.byte $36 ; |..XX.XX.| $FB8D
	.byte $64 ; |.XX..X..| $FB8E
	.byte $04 ; |.....X..| $FB8F

invHourGlassSprite
	.byte $77 ; |.XXX.XXX| $FB90
	.byte $36 ; |..XX.XX.| $FB91
	.byte $14 ; |...X.X..| $FB92
	.byte $22 ; |..X...X.| $FB93
	.byte $22 ; |..X...X.| $FB94
	.byte $14 ; |...X.X..| $FB95
	.byte $36 ; |..XX.XX.| $FB96
	.byte $77 ; |.XXX.XXX| $FB97

timepiece12_00: ;timepiece bitmaps...
	.byte $3E ; |..XXXXX.| $FB98
	.byte $41 ; |.X.....X| $FB99
	.byte $41 ; |.X.....X| $FB9A
	.byte $49 ; |.X..X..X| $FB9B
	.byte $49 ; |.X..X..X| $FB9C
	.byte $49 ; |.X..X..X| $FB9D
	.byte $3E ; |..XXXXX.| $FB9E
	.byte $1C ; |...XXX..| $FB9F

timepiece01_00
	.byte $3E ; |..XXXXX.| $FBA0
	.byte $41 ; |.X.....X| $FBA1
	.byte $41 ; |.X.....X| $FBA2
	.byte $49 ; |.X..X..X| $FBA3
	.byte $45 ; |.X...X.X| $FBA4
	.byte $43 ; |.X....XX| $FBA5
	.byte $3E ; |..XXXXX.| $FBA6
	.byte $1C ; |...XXX..| $FBA7

timepiece03_00
	.byte $3E ; |..XXXXX.| $FBA8
	.byte $41 ; |.X.....X| $FBA9
	.byte $41 ; |.X.....X| $FBAA
	.byte $4F ; |.X..XXXX| $FBAB
	.byte $41 ; |.X.....X| $FBAC
	.byte $41 ; |.X.....X| $FBAD
	.byte $3E ; |..XXXXX.| $FBAE
	.byte $1C ; |...XXX..| $FBAF

timepiece05_00
	.byte $3E ; |..XXXXX.| $FBB0
	.byte $43 ; |.X....XX| $FBB1
	.byte $45 ; |.X...X.X| $FBB2
	.byte $49 ; |.X..X..X| $FBB3
	.byte $41 ; |.X.....X| $FBB4
	.byte $41 ; |.X.....X| $FBB5
	.byte $3E ; |..XXXXX.| $FBB6
	.byte $1C ; |...XXX..| $FBB7

timepiece06_00
	.byte $3E ; |..XXXXX.| $FBB8
	.byte $49 ; |.X..X..X| $FBB9
	.byte $49 ; |.X..X..X| $FBBA
	.byte $49 ; |.X..X..X| $FBBB
	.byte $41 ; |.X.....X| $FBBC
	.byte $41 ; |.X.....X| $FBBD
	.byte $3E ; |..XXXXX.| $FBBE
	.byte $1C ; |...XXX..| $FBBF

timepiece07_00
	.byte $3E ; |..XXXXX.| $FBC0
	.byte $61 ; |.XX....X| $FBC1
	.byte $51 ; |.X.X...X| $FBC2
	.byte $49 ; |.X..X..X| $FBC3
	.byte $41 ; |.X.....X| $FBC4
	.byte $41 ; |.X.....X| $FBC5
	.byte $3E ; |..XXXXX.| $FBC6
	.byte $1C ; |...XXX..| $FBC7

timepiece09_00
	.byte $3E ; |..XXXXX.| $FBC8
	.byte $41 ; |.X.....X| $FBC9
	.byte $41 ; |.X.....X| $FBCA
	.byte $79 ; |.XXXX..X| $FBCB
	.byte $41 ; |.X.....X| $FBCC
	.byte $41 ; |.X.....X| $FBCD
	.byte $3E ; |..XXXXX.| $FBCE
	.byte $1C ; |...XXX..| $FBCF

timepiece11_00
	.byte $3E ; |..XXXXX.| $FBD0
	.byte $41 ; |.X.....X| $FBD1
	.byte $41 ; |.X.....X| $FBD2
	.byte $49 ; |.X..X..X| $FBD3
	.byte $51 ; |.X.X...X| $FBD4
	.byte $61 ; |.XX....X| $FBD5
	.byte $3E ; |..XXXXX.| $FBD6
	.byte $1C ; |...XXX..| $FBD7

copyrightGfx2 ;copyright2
	.byte $49 ; |.X..X..X| $FBD8
	.byte $49 ; |.X..X..X| $FBD9
	.byte $49 ; |.X..X..X| $FBDA
	.byte $C9 ; |XX..X..X| $FBDB
	.byte $49 ; |.X..X..X| $FBDC
	.byte $49 ; |.X..X..X| $FBDD
	.byte $BE ; |X.XXXXX.| $FBDE
	.byte $00 ; |........| $FBDF

copyrightGfx4: ;copyright5
	.byte $55 ; |.X.X.X.X| $FBE0
	.byte $55 ; |.X.X.X.X| $FBE1
	.byte $55 ; |.X.X.X.X| $FBE2
	.byte $D9 ; |XX.XX..X| $FBE3
	.byte $55 ; |.X.X.X.X| $FBE4
	.byte $55 ; |.X.X.X.X| $FBE5
	.byte $99 ; |X..XX..X| $FBE6
	.byte $00 ; |........| $FBE7

;------------------------------------------------------------
; OverscanSpecialSoundEffectTable
;
; Frequency data for the "Main Theme" (Raiders March).
; Played when channel control is $9C (Pure Tone).
; Indexed by `soundEffectTimer` (counts down from $17).
;

soundEffectTable
	.byte $14 ; |...X.X..|
	.byte $14 ; |...X.X..|
	.byte $14 ; |...X.X..|
	.byte $0F ; |....XXXX|
	.byte $10 ; |...X....|
	.byte $12 ; |...X..X.|
	.byte $0B ; |....X.XX|
	
	.byte $0B ; |....X.XX|
	.byte $0B ; |....X.XX|
	.byte $10 ; |...X....|
	.byte $12 ; |...X..X.|
	.byte $14 ; |...X.X..|
	.byte $17 ; |...X.XXX|
	.byte $17 ; |...X.XXX|
	.byte $17 ; |...X.XXX|
	
	.byte $17 ; |...X.XXX|
	.byte $18 ; |...XX...|
	.byte $1B ; |...XX.XX|
	.byte $0F ; |....XXXX|
	.byte $0F ; |....XXXX|
	.byte $0F ; |....XXXX|
	.byte $14 ; |...X.X..|
	.byte $17 ; |...X.XXX|
	.byte $18 ; |...XX...|

thiefSprites
ThiefSprite_0
	.byte $14 ; |...X.X..| $FC00
	.byte $3C ; |..XXXX..| $FC01
	.byte $7E ; |.XXXXXX.| $FC02
	.byte $00 ; |........| $FC03
	.byte $30 ; |..XX....| $FC04
	.byte $38 ; |..XXX...| $FC05
	.byte $3C ; |..XXXX..| $FC06
	.byte $3E ; |..XXXXX.| $FC07
	.byte $3F ; |..XXXXXX| $FC08
	.byte $7F ; |.XXXXXXX| $FC09
	.byte $7F ; |.XXXXXXX| $FC0A
	.byte $7F ; |.XXXXXXX| $FC0B
	.byte $11 ; |...X...X| $FC0C
	.byte $11 ; |...X...X| $FC0D
	.byte $33 ; |..XX..XX| $FC0E
	.byte $00 ; |........| $FC0F
ThiefSprite_1
	.byte $14 ; |...X.X..| $FC10
	.byte $3C ; |..XXXX..| $FC11
	.byte $7E ; |.XXXXXX.| $FC12
	.byte $00 ; |........| $FC13
	.byte $30 ; |..XX....| $FC14
	.byte $38 ; |..XXX...| $FC15
	.byte $3C ; |..XXXX..| $FC16
	.byte $3E ; |..XXXXX.| $FC17
	.byte $3F ; |..XXXXXX| $FC18
	.byte $7F ; |.XXXXXXX| $FC19
	.byte $7F ; |.XXXXXXX| $FC1A
	.byte $7F ; |.XXXXXXX| $FC1B
	.byte $22 ; |..X...X.| $FC1C
	.byte $22 ; |..X...X.| $FC1D
	.byte $66 ; |.XX..XX.| $FC1E
	.byte $00 ; |........| $FC1F
ThiefSprite_2
	.byte $14 ; |...X.X..| $FC20
	.byte $3C ; |..XXXX..| $FC21
	.byte $7E ; |.XXXXXX.| $FC22
	.byte $00 ; |........| $FC23
	.byte $30 ; |..XX....| $FC24
	.byte $38 ; |..XXX...| $FC25
	.byte $3C ; |..XXXX..| $FC26
	.byte $3E ; |..XXXXX.| $FC27
	.byte $3F ; |..XXXXXX| $FC28
	.byte $7F ; |.XXXXXXX| $FC29
	.byte $7F ; |.XXXXXXX| $FC2A
	.byte $7F ; |.XXXXXXX| $FC2B
	.byte $44 ; |.X...X..| $FC2C
	.byte $44 ; |.X...X..| $FC2D
	.byte $CC ; |XX..XX..| $FC2E
	.byte $00 ; |........| $FC2F
ThiefSprite_3
	.byte $14 ; |...X.X..| $FC30
	.byte $3C ; |..XXXX..| $FC31
	.byte $7E ; |.XXXXXX.| $FC32
	.byte $00 ; |........| $FC33
	.byte $30 ; |..XX....| $FC34
	.byte $38 ; |..XXX...| $FC35
	.byte $3C ; |..XXXX..| $FC36
	.byte $3E ; |..XXXXX.| $FC37
	.byte $3F ; |..XXXXXX| $FC38
	.byte $7F ; |.XXXXXXX| $FC39
	.byte $7F ; |.XXXXXXX| $FC3A
	.byte $7F ; |.XXXXXXX| $FC3B
	.byte $08 ; |....X...| $FC3C
	.byte $08 ; |....X...| $FC3D
	.byte $18 ; |...XX...| $FC3E
	.byte $00 ; |........| $FC3F

thiefSpriteValueLo
	.byte <ThiefSprite_0, <ThiefSprite_1
	.byte <ThiefSprite_2, <ThiefSprite_3	


thiefColors
	.byte DK_BLUE + 12, WHITE + 1, DK_BLUE + 12, BLACK, BLACK + 10, BLACK + 2
	.byte BLACK + 4, BLACK + 6, BLACK + 8, BLACK + 10, BLACK + 8, BLACK + 6
	.byte LT_BLUE + 8, LT_BLUE + 8, LT_BLUE + 14, LT_BLUE + 14



       .byte $00 ; |        | $fc54
       .byte $00 ; |        | $fc55
       .byte $00 ; |        | $fc56
       .byte $00 ; |        | $fc57
       .byte $00 ; |        | $fc58
       .byte $00 ; |        | $fc59
       .byte $00 ; |        | $fc5a
       .byte $00 ; |        | $fc5b
       .byte $00 ; |        | $fc5c
       .byte $00 ; |        | $fc5d
       .byte $00 ; |        | $fc5e
       .byte $08 ; |    x   | $fc5f
       .byte $1c ; |   xxx  | $fc60
       .byte $3c ; |  xxxx  | $fc61
       .byte $3e ; |  xxxxx | $fc62
       .byte $7f ; | xxxxxxx| $fc63
       .byte $ff ; |xxxxxxxx| $fc64
       .byte $ff ; |xxxxxxxx| $fc65
       .byte $ff ; |xxxxxxxx| $fc66
       .byte $ff ; |xxxxxxxx| $fc67
       .byte $ff ; |xxxxxxxx| $fc68
       .byte $ff ; |xxxxxxxx| $fc69
       .byte $ff ; |xxxxxxxx| $fc6a
       .byte $ff ; |xxxxxxxx| $fc6b

       .byte $3e ; |  xxxxx | $fc6c
       .byte $3c ; |  xxxx  | $fc6d
       .byte $3a ; |  xxx x | $fc6e
       .byte $38 ; |  xxx   | $fc6f
       .byte $36 ; |  xx xx | $fc70
       .byte $34 ; |  xx x  | $fc71
       .byte $32 ; |  xx  x | $fc72

       .byte $20 ; |  x     | $fc73
       .byte $10 ; |   x    | $fc74
lfc75
       .byte $00 ; |        | $fc75
       .byte $00 ; |        | $fc76
       .byte $00 ; |        | $fc77
       .byte $00 ; |        | $fc78
       .byte $08 ; |    x   | $fc79
       .byte $00 ; |        | $fc7a
       .byte $02 ; |      x | $fc7b
       .byte $0a ; |    x x | $fc7c
       .byte $0c ; |    xx  | $fc7d
       .byte $0e ; |    xxx | $fc7e
       .byte $01 ; |       x| $fc7f
       .byte $03 ; |      xx| $fc80
       .byte $04 ; |     x  | $fc81
       .byte $06 ; |     xx | $fc82
       .byte $05 ; |     x x| $fc83
       .byte $07 ; |     xxx| $fc84
       .byte $0d ; |    xx x| $fc85
       .byte $0f ; |    xxxx| $fc86
       .byte $0b ; |    x xx| $fc87


RoomHandlerJmpTableLo
       .byte $e0             ; $fc88 (*)
RoomHandlerJmpTableHi 
       .byte $f6             ; $fc89 (*)


       .word lf833-1 ; $fc8a/b
       .word lf83e-1 ; $fc8c/d
       .word lf6af-1 ; $fc8e/f
       .word lf728-1 ; $fc90/1
       .word lf663-1 ; $fc92/3
       .word lf7a8-1 ; $fc94/5
       .word spiderRoomHandler-1 ; $fc96/7
       .word lf7e0-1 ; $fc98/9
       .word mesaFieldRoomHandler-1 ; $fc9a/b
       .word lf59d-1 ; $fc9c/d
       .word lf638-1 ; $fc9e/f
       .word lf62a-1 ; $fca0/1

lfca2
       .byte $1a ; |   xx x | $fca2
       .byte $38 ; |  xxx   | $fca3
       .byte $09 ; |    x  x| $fca4
       .byte $26 ; |  x  xx | $fca5
lfca6
       .byte $26 ; |  x  xx | $fca6
       .byte $46 ; | x   xx | $fca7
       .byte $1a ; |   xx x | $fca8
       .byte $38 ; |  xxx   | $fca9
lfcaa
       .byte $04 ; |     x  | $fcaa
       .byte $11 ; |   x   x| $fcab
       .byte $10 ; |   x    | $fcac
       .byte $12 ; |   x  x | $fcad




spiderSprites
spiderGfxFrame1
	.byte	$54 ; | # # #  |			$fcae (g)
	.byte	$fc ; |######  |			$fcaf (g)
	.byte	$5f ; | # #####|			$fcb0 (g)
	.byte	$fe ; |####### |			$fcb1 (g)
	.byte	$7f ; | #######|			$fcb2 (g)
	.byte	$fa ; |##### # |			$fcb3 (g)
	.byte	$3f ; |	 ######|			$fcb4 (g)
	.byte	$2a ; |	 # # # |			$fcb5 (g)
	.byte	$00 ; |        |			$fcb6 (g)

spiderGfxFrame3
	.byte	$54 ; | # # #  |			$fcb7 (g)
	.byte	$5f ; | # #####|			$fcb8 (g)
	.byte	$fc ; |######  |			$fcb9 (g)
	.byte	$7f ; | #######|			$fcba (g)
	.byte	$fe ; |####### |			$fcbb (g)
	.byte	$3f ; |	 ######|			$fcbc (g)
	.byte	$fa ; |##### # |			$fcbd (g)
	.byte	$2a ; |	 # # # |			$fcbe (g)
	.byte	$00 ; |	       |			$fcbf (g)

spiderGfxFrame2
	.byte	$2a ; |	 # # # |			$fcc0 (g)
	.byte	$fa ; |##### # |			$fcc1 (g)
	.byte	$3f ; |	 ######|			$fcc2 (g)
	.byte	$fe ; |####### |			$fcc3 (g)
	.byte	$7f ; | #######|			$fcc4 (g)
	.byte	$fa ; |##### # |			$fcc5 (g)
	.byte	$5f ; | # #####|			$fcc6 (g)
	.byte	$54 ; | # # #  |			$fcc7 (g)
	.byte	$00 ; |	       |			$fcc8 (g)

spiderGfxFrame4
	.byte	$2a ; |	 # # # |			$fcc9 (g)
	.byte	$3f ; |	 ######|			$fcca (g)
	.byte	$fa ; |##### # |			$fccb (g)
	.byte	$7f ; | #######|			$fccc (g)
	.byte	$fe ; |####### |			$fccd (g)
	.byte	$5f ; | # #####|			$fcce (g)
	.byte	$fc ; |######  |			$fccf (g)
	.byte	$54 ; | # # #  |			$fcd0 (g)
    .byte   $00 ; |        |            $fcd1

lfcd2
       .byte $8b ; |x   x xx| $fcd2
       .byte $8a ; |x   x x | $fcd3
       .byte $86 ; |x    xx | $fcd4
       .byte $87 ; |x    xxx| $fcd5
       .byte $85 ; |x    x x| $fcd6
       .byte $89 ; |x   x  x| $fcd7
lfcd8
       .byte $03 ; |      xx| $fcd8
       .byte $01 ; |       x| $fcd9
       .byte $00 ; |        | $fcda
       .byte $01 ; |       x| $fcdb
lfcdc
       .byte $03 ; |      xx| $fcdc
       .byte $02 ; |      x | $fcdd
       .byte $01 ; |       x| $fcde
       .byte $03 ; |      xx| $fcdf
       .byte $02 ; |      x | $fce0
       .byte $03 ; |      xx| $fce1
lfce2
       .byte $01 ; |       x| $fce2
       .byte $02 ; |      x | $fce3
       .byte $04 ; |     x  | $fce4
       .byte $08 ; |    x   | $fce5
       .byte $10 ; |   x    | $fce6
       .byte $20 ; |  x     | $fce7
       .byte $40 ; | x      | $fce8
       .byte $80 ; |x       | $fce9

invSelectAdjHandler
	ror								
	bcs		lfcef					
	dec		p0PosY,x				 
lfcef
	ror								
	bcs		lfcf4					
	inc		p0PosY,x				 
lfcf4
	ror								
	bcs		lfcf9					
	dec		objectPosX,x				 
lfcf9
	ror								
	bcs		lfcfe					
	inc		objectPosX,x				 
lfcfe
	rts								
	.byte $00 ; |........| $FCFF
	.byte $F2 ; |XXXX..X.| $FD00
	.byte $40 ; |.X......| $FD01
	.byte $F2 ; |XXXX..X.| $FD02
	.byte $C0 ; |XX......| $FD03
	.byte $12 ; |...X..X.| $FD04
	.byte $10 ; |...X....| $FD05
	.byte $F2 ; |XXXX..X.| $FD06
	.byte $00 ; |........| $FD07
	.byte $12 ; |...X..X.| $FD08
	.byte $20 ; |..X.....| $FD09
	.byte $02 ; |......X.| $FD0A
	.byte $B0 ; |X.XX....| $FD0B
	.byte $F2 ; |XXXX..X.| $FD0C
	.byte $30 ; |..XX....| $FD0D
	.byte $12 ; |...X..X.| $FD0E
	.byte $00 ; |........| $FD0F
	.byte $F2 ; |XXXX..X.| $FD10
	.byte $40 ; |.X......| $FD11
	.byte $F2 ; |XXXX..X.| $FD12
	.byte $D0 ; |XX.X....| $FD13
	.byte $12 ; |...X..X.| $FD14
	.byte $10 ; |...X....| $FD15
	.byte $02 ; |......X.| $FD16
	.byte $00 ; |........| $FD17
	.byte $02 ; |......X.| $FD18
	.byte $30 ; |..XX....| $FD19
	.byte $12 ; |...X..X.| $FD1A
	.byte $B0 ; |X.XX....| $FD1B
	.byte $02 ; |......X.| $FD1C
	.byte $20 ; |..X.....| $FD1D
	.byte $12 ; |...X..X.| $FD1E
	.byte $00 ; |........| $FD1F
	
RoomPF1GraphicData_6:
	.byte $FF ; |XXXXXXXX| $FD20
	.byte $FF ; |XXXXXXXX| $FD21
	.byte $FC ; |XXXXXX..| $FD22
	.byte $F0 ; |XXXX....| $FD23
	.byte $E0 ; |XXX.....| $FD24
	.byte $E0 ; |XXX.....| $FD25
	.byte $C0 ; |XX......| $FD26
	.byte $80 ; |X.......| $FD27
	.byte $00 ; |........| $FD28
	.byte $00 ; |........| $FD29
	.byte $00 ; |........| $FD2A
	.byte $00 ; |........| $FD2B
	.byte $00 ; |........| $FD2C
	.byte $00 ; |........| $FD2D
	.byte $00 ; |........| $FD2E
	.byte $00 ; |........| $FD2F
	.byte $00 ; |........| $FD30
	.byte $00 ; |........| $FD31
	.byte $00 ; |........| $FD32
	.byte $00 ; |........| $FD33
	.byte $00 ; |........| $FD34
	.byte $00 ; |........| $FD35
	.byte $00 ; |........| $FD36
	.byte $00 ; |........| $FD37
	.byte $00 ; |........| $FD38
	.byte $00 ; |........| $FD39
	.byte $00 ; |........| $FD3A
	.byte $00 ; |........| $FD3B
	.byte $00 ; |........| $FD3C
	.byte $00 ; |........| $FD3D
	.byte $00 ; |........| $FD3E
	.byte $00 ; |........| $FD3F
	.byte $00 ; |........| $FD40
	.byte $80 ; |X.......| $FD41
	.byte $80 ; |X.......| $FD42
	.byte $C0 ; |XX......| $FD43
	.byte $E0 ; |XXX.....| $FD44
	.byte $E0 ; |XXX.....| $FD45
	.byte $F0 ; |XXXX....| $FD46
	.byte $FE ; |XXXXXXX.| $FD47
	
RoomPF1GraphicData_7:
	.byte $FF ; |XXXXXXXX| $FD48
	.byte $FF ; |XXXXXXXX| $FD49
	.byte $FF ; |XXXXXXXX| $FD4A
	.byte $FF ; |XXXXXXXX| $FD4B
	.byte $FC ; |XXXXXX..| $FD4C
	.byte $F0 ; |XXXX....| $FD4D
	.byte $E0 ; |XXX.....| $FD4E
	.byte $E0 ; |XXX.....| $FD4F
	.byte $C0 ; |XX......| $FD50
	.byte $80 ; |X.......| $FD51
	.byte $00 ; |........| $FD52
	.byte $00 ; |........| $FD53
	.byte $00 ; |........| $FD54
	.byte $00 ; |........| $FD55
	.byte $00 ; |........| $FD56
	.byte $00 ; |........| $FD57
	.byte $00 ; |........| $FD58
	.byte $00 ; |........| $FD59
	.byte $00 ; |........| $FD5A
	.byte $00 ; |........| $FD5B
	.byte $00 ; |........| $FD5C
	.byte $C0 ; |XX......| $FD5D
	.byte $F0 ; |XXXX....| $FD5E
	.byte $F8 ; |XXXXX...| $FD5F
	.byte $FE ; |XXXXXXX.| $FD60
	.byte $FE ; |XXXXXXX.| $FD61
	.byte $F8 ; |XXXXX...| $FD62
	.byte $F0 ; |XXXX....| $FD63
	.byte $E0 ; |XXX.....| $FD64
	.byte $C0 ; |XX......| $FD65
	.byte $80 ; |X.......| $FD66
	.byte $00 ; |........| $FD67
	
RoomPF1GraphicData_8:
	.byte $00 ; |........| $FD68
	.byte $00 ; |........| $FD69
	.byte $00 ; |........| $FD6A
	.byte $00 ; |........| $FD6B
	.byte $00 ; |........| $FD6C
	.byte $00 ; |........| $FD6D
	.byte $00 ; |........| $FD6E
	.byte $00 ; |........| $FD6F
	.byte $02 ; |......X.| $FD70
	.byte $07 ; |.....XXX| $FD71
	.byte $07 ; |.....XXX| $FD72
	.byte $0F ; |....XXXX| $FD73
	.byte $0F ; |....XXXX| $FD74
	.byte $0F ; |....XXXX| $FD75
	.byte $07 ; |.....XXX| $FD76
	.byte $07 ; |.....XXX| $FD77
	.byte $02 ; |......X.| $FD78
	.byte $00 ; |........| $FD79
	.byte $00 ; |........| $FD7A
	.byte $00 ; |........| $FD7B
	.byte $00 ; |........| $FD7C
	.byte $00 ; |........| $FD7D
	.byte $00 ; |........| $FD7E
	.byte $00 ; |........| $FD7F
	.byte $00 ; |........| $FD80
	.byte $04 ; |.....X..| $FD81
	.byte $0E ; |....XXX.| $FD82
	.byte $0E ; |....XXX.| $FD83
	.byte $0F ; |....XXXX| $FD84
	.byte $0E ; |....XXX.| $FD85
	.byte $06 ; |.....XX.| $FD86
	.byte $00 ; |........| $FD87
	.byte $00 ; |........| $FD88
	
RoomPF1GraphicData_9:
	.byte $00 ; |........| $FD89
	.byte $00 ; |........| $FD8A
	.byte $00 ; |........| $FD8B
	.byte $00 ; |........| $FD8C
	.byte $00 ; |........| $FD8D
	.byte $00 ; |........| $FD8E
	.byte $00 ; |........| $FD8F
	.byte $00 ; |........| $FD90
	.byte $02 ; |......X.| $FD91
	.byte $07 ; |.....XXX| $FD92
	.byte $07 ; |.....XXX| $FD93
	.byte $0F ; |....XXXX| $FD94
	.byte $1F ; |...XXXXX| $FD95
	.byte $0F ; |....XXXX| $FD96
	.byte $07 ; |.....XXX| $FD97
	.byte $07 ; |.....XXX| $FD98
	.byte $02 ; |......X.| $FD99
	.byte $00 ; |........| $FD9A
	
RoomPF2GraphicData_6:
	.byte $00 ; |........| $FD9B
	.byte $00 ; |........| $FD9C
	.byte $00 ; |........| $FD9D
	.byte $00 ; |........| $FD9E
	.byte $00 ; |........| $FD9F
	.byte $00 ; |........| $FDA0
	.byte $00 ; |........| $FDA1
	.byte $00 ; |........| $FDA2
	.byte $00 ; |........| $FDA3
	.byte $00 ; |........| $FDA4
	.byte $00 ; |........| $FDA5
	.byte $01 ; |.......X| $FDA6
	.byte $03 ; |......XX| $FDA7
	.byte $01 ; |.......X| $FDA8
	.byte $00 ; |........| $FDA9
	.byte $00 ; |........| $FDAA
	.byte $00 ; |........| $FDAB
	.byte $00 ; |........| $FDAC
	.byte $00 ; |........| $FDAD
	.byte $80 ; |X.......| $FDAE
	.byte $80 ; |X.......| $FDAF
	.byte $C0 ; |XX......| $FDB0
	.byte $E0 ; |XXX.....| $FDB1
	.byte $F8 ; |XXXXX...| $FDB2
	.byte $E0 ; |XXX.....| $FDB3
	.byte $C0 ; |XX......| $FDB4
	.byte $80 ; |X.......| $FDB5
	.byte $80 ; |X.......| $FDB6
	
RoomPF2GraphicData_7:
	.byte $00 ; |........| $FDB7
	.byte $00 ; |........| $FDB8
	.byte $00 ; |........| $FDB9
	.byte $C0 ; |XX......| $FDBA
	.byte $E0 ; |XXX.....| $FDBB
	.byte $E0 ; |XXX.....| $FDBC
	.byte $C0 ; |XX......| $FDBD
	.byte $00 ; |........| $FDBE
	.byte $00 ; |........| $FDBF
	.byte $00 ; |........| $FDC0
	.byte $00 ; |........| $FDC1
	.byte $00 ; |........| $FDC2
	.byte $00 ; |........| $FDC3
	.byte $00 ; |........| $FDC4
	.byte $00 ; |........| $FDC5
	.byte $00 ; |........| $FDC6
	.byte $00 ; |........| $FDC7
	.byte $80 ; |X.......| $FDC8
	.byte $80 ; |X.......| $FDC9
	.byte $80 ; |X.......| $FDCA
	.byte $80 ; |X.......| $FDCB
	.byte $80 ; |X.......| $FDCC
	.byte $80 ; |X.......| $FDCD
	.byte $00 ; |........| $FDCE
	.byte $00 ; |........| $FDCF
	.byte $00 ; |........| $FDD0
	.byte $00 ; |........| $FDD1
	.byte $00 ; |........| $FDD2
	.byte $00 ; |........| $FDD3
	.byte $00 ; |........| $FDD4
	.byte $00 ; |........| $FDD5
	.byte $00 ; |........| $FDD6
	.byte $00 ; |........| $FDD7
	.byte $C0 ; |XX......| $FDD8
	.byte $E0 ; |XXX.....| $FDD9
	.byte $E0 ; |XXX.....| $FDDA
	.byte $C0 ; |XX......| $FDDB
	.byte $00 ; |........| $FDDC
	.byte $00 ; |........| $FDDD
	.byte $00 ; |........| $FDDE
	.byte $00 ; |........| $FDDF
	
ShiningLightSprites
ShiningLight_00
	.byte $22 ; |..X...X.| $FDE0
	.byte $41 ; |.X.....X| $FDE1
	.byte $08 ; |....X...| $FDE2
	.byte $14 ; |...X.X..| $FDE3
	.byte $08 ; |....X...| $FDE4
	.byte $41 ; |.X.....X| $FDE5
	.byte $22 ; |..X...X.| $FDE6
	.byte $00 ; |........| $FDE7
ShiningLight_01
	.byte $41 ; |.X.....X| $FDE8
	.byte $08 ; |....X...| $FDE9
	.byte $14 ; |...X.X..| $FDEA
	.byte $2A ; |..X.X.X.| $FDEB
	.byte $14 ; |...X.X..| $FDEC
	.byte $08 ; |....X...| $FDED
	.byte $41 ; |.X.....X| $FDEE
	.byte $00 ; |........| $FDEF
ShiningLight_02
	.byte $08 ; |....X...| $FDF0
	.byte $14 ; |...X.X..| $FDF1
	.byte $3E ; |..XXXXX.| $FDF2
	.byte $55 ; |.X.X.X.X| $FDF3
	.byte $3E ; |..XXXXX.| $FDF4
	.byte $14 ; |...X.X..| $FDF5
	.byte $08 ; |....X...| $FDF6
	.byte $00 ; |........| $FDF7
ShiningLight_03
	.byte $14 ; |...X.X..| $FDF8
	.byte $3E ; |..XXXXX.| $FDF9
	.byte $63 ; |.XX...XX| $FDFA
	.byte $2A ; |..X.X.X.| $FDFB
	.byte $63 ; |.XX...XX| $FDFC
	.byte $3E ; |..XXXXX.| $FDFD
	.byte $14 ; |...X.X..| $FDFE
	.byte $00 ; |........| $FDFF
	
	
RoomPF1GraphicData_10:
	.byte $07 ; |.....XXX| $FE00
	.byte $07 ; |.....XXX| $FE01
	.byte $07 ; |.....XXX| $FE02
	.byte $03 ; |......XX| $FE03
	.byte $03 ; |......XX| $FE04
	.byte $03 ; |......XX| $FE05
	.byte $01 ; |.......X| $FE06
	.byte $00 ; |........| $FE07
	.byte $00 ; |........| $FE08
	.byte $00 ; |........| $FE09
	.byte $00 ; |........| $FE0A
	.byte $00 ; |........| $FE0B
	.byte $00 ; |........| $FE0C
	.byte $00 ; |........| $FE0D
	.byte $00 ; |........| $FE0E
	.byte $30 ; |..XX....| $FE0F
	.byte $78 ; |.XXXX...| $FE10
	.byte $7C ; |.XXXXX..| $FE11
	.byte $3C ; |..XXXX..| $FE12
	.byte $3C ; |..XXXX..| $FE13
	.byte $18 ; |...XX...| $FE14
	.byte $08 ; |....X...| $FE15
	.byte $00 ; |........| $FE16
	.byte $00 ; |........| $FE17
	.byte $00 ; |........| $FE18
	.byte $00 ; |........| $FE19
	.byte $00 ; |........| $FE1A
	.byte $00 ; |........| $FE1B
	.byte $00 ; |........| $FE1C
	.byte $00 ; |........| $FE1D
	.byte $00 ; |........| $FE1E
	.byte $00 ; |........| $FE1F
	.byte $00 ; |........| $FE20
	.byte $00 ; |........| $FE21
	.byte $00 ; |........| $FE22
	.byte $00 ; |........| $FE23
	.byte $00 ; |........| $FE24
	.byte $00 ; |........| $FE25
	.byte $00 ; |........| $FE26
	.byte $00 ; |........| $FE27
	.byte $00 ; |........| $FE28
	.byte $00 ; |........| $FE29
	.byte $00 ; |........| $FE2A
	.byte $00 ; |........| $FE2B
	.byte $00 ; |........| $FE2C
	.byte $00 ; |........| $FE2D
	.byte $01 ; |.......X| $FE2E
	.byte $0F ; |....XXXX| $FE2F
	.byte $01 ; |.......X| $FE30
	.byte $00 ; |........| $FE31
	.byte $00 ; |........| $FE32
	.byte $00 ; |........| $FE33
	.byte $00 ; |........| $FE34
	.byte $00 ; |........| $FE35
	.byte $00 ; |........| $FE36
	.byte $00 ; |........| $FE37
	.byte $80 ; |X.......| $FE38
	.byte $C0 ; |XX......| $FE39
	.byte $E0 ; |XXX.....| $FE3A
	.byte $F8 ; |XXXXX...| $FE3B
	.byte $FC ; |XXXXXX..| $FE3C
	.byte $FE ; |XXXXXXX.| $FE3D
	.byte $FC ; |XXXXXX..| $FE3E
	.byte $F0 ; |XXXX....| $FE3F
	.byte $E0 ; |XXX.....| $FE40
	.byte $C0 ; |XX......| $FE41
	.byte $C0 ; |XX......| $FE42
	.byte $80 ; |X.......| $FE43
	.byte $80 ; |X.......| $FE44
	.byte $00 ; |........| $FE45
	.byte $00 ; |........| $FE46
	.byte $00 ; |........| $FE47
	.byte $00 ; |........| $FE48
	.byte $00 ; |........| $FE49
	.byte $00 ; |........| $FE4A
	.byte $00 ; |........| $FE4B
	.byte $00 ; |........| $FE4C
	.byte $00 ; |........| $FE4D
	.byte $00 ; |........| $FE4E
	.byte $00 ; |........| $FE4F
	.byte $03 ; |......XX| $FE50
	.byte $07 ; |.....XXX| $FE51
	.byte $03 ; |......XX| $FE52
	.byte $01 ; |.......X| $FE53
	.byte $00 ; |........| $FE54
	.byte $00 ; |........| $FE55
	.byte $00 ; |........| $FE56
	.byte $00 ; |........| $FE57
	.byte $00 ; |........| $FE58
	.byte $80 ; |X.......| $FE59
	.byte $E0 ; |XXX.....| $FE5A
	.byte $F8 ; |XXXXX...| $FE5B
	.byte $F8 ; |XXXXX...| $FE5C
	.byte $F8 ; |XXXXX...| $FE5D
	.byte $F8 ; |XXXXX...| $FE5E
	.byte $F0 ; |XXXX....| $FE5F
	.byte $C0 ; |XX......| $FE60
	.byte $80 ; |X.......| $FE61
	.byte $00 ; |........| $FE62
	.byte $00 ; |........| $FE63
	.byte $00 ; |........| $FE64
	.byte $00 ; |........| $FE65
	.byte $00 ; |........| $FE66
	.byte $00 ; |........| $FE67
	.byte $00 ; |........| $FE68
	.byte $00 ; |........| $FE69
	.byte $03 ; |......XX| $FE6A
	.byte $0F ; |....XXXX| $FE6B
	.byte $1F ; |...XXXXX| $FE6C
	.byte $3F ; |..XXXXXX| $FE6D
	.byte $3E ; |..XXXXX.| $FE6E
	.byte $3C ; |..XXXX..| $FE6F
	.byte $38 ; |..XXX...| $FE70
	.byte $30 ; |..XX....| $FE71
	.byte $00 ; |........| $FE72
	.byte $00 ; |........| $FE73
	.byte $00 ; |........| $FE74
	.byte $00 ; |........| $FE75
	.byte $00 ; |........| $FE76
	.byte $00 ; |........| $FE77
	
RoomPF2GraphicData_9:
	.byte $07 ; |.....XXX| $FE78
	.byte $07 ; |.....XXX| $FE79
	.byte $07 ; |.....XXX| $FE7A
	.byte $03 ; |......XX| $FE7B
	.byte $03 ; |......XX| $FE7C
	.byte $03 ; |......XX| $FE7D
	.byte $01 ; |.......X| $FE7E
	.byte $00 ; |........| $FE7F
	.byte $00 ; |........| $FE80
	.byte $00 ; |........| $FE81
	.byte $00 ; |........| $FE82
	.byte $00 ; |........| $FE83
	.byte $00 ; |........| $FE84
	.byte $80 ; |X.......| $FE85
	.byte $80 ; |X.......| $FE86
	.byte $C0 ; |XX......| $FE87
	.byte $E0 ; |XXX.....| $FE88
	.byte $E0 ; |XXX.....| $FE89
	.byte $C0 ; |XX......| $FE8A
	.byte $C0 ; |XX......| $FE8B
	.byte $80 ; |X.......| $FE8C
	.byte $00 ; |........| $FE8D
	.byte $00 ; |........| $FE8E
	.byte $00 ; |........| $FE8F
	.byte $00 ; |........| $FE90
	.byte $00 ; |........| $FE91
	.byte $00 ; |........| $FE92
	.byte $00 ; |........| $FE93
	.byte $00 ; |........| $FE94
	.byte $00 ; |........| $FE95
	.byte $00 ; |........| $FE96
	.byte $30 ; |..XX....| $FE97
	.byte $38 ; |..XXX...| $FE98
	.byte $1C ; |...XXX..| $FE99
	.byte $1E ; |...XXXX.| $FE9A
	.byte $0E ; |....XXX.| $FE9B
	.byte $0C ; |....XX..| $FE9C
	.byte $0C ; |....XX..| $FE9D
	.byte $00 ; |........| $FE9E
	.byte $00 ; |........| $FE9F
	.byte $00 ; |........| $FEA0
	.byte $80 ; |X.......| $FEA1
	.byte $80 ; |X.......| $FEA2
	.byte $C0 ; |XX......| $FEA3
	.byte $F0 ; |XXXX....| $FEA4
	.byte $FC ; |XXXXXX..| $FEA5
	.byte $FF ; |XXXXXXXX| $FEA6
	.byte $FF ; |XXXXXXXX| $FEA7
	.byte $FF ; |XXXXXXXX| $FEA8
	.byte $FF ; |XXXXXXXX| $FEA9
	.byte $FE ; |XXXXXXX.| $FEAA
	.byte $FC ; |XXXXXX..| $FEAB
	.byte $F8 ; |XXXXX...| $FEAC
	.byte $F0 ; |XXXX....| $FEAD
	.byte $E0 ; |XXX.....| $FEAE
	.byte $00 ; |........| $FEAF
	.byte $00 ; |........| $FEB0
	.byte $00 ; |........| $FEB1
	.byte $00 ; |........| $FEB2
	.byte $00 ; |........| $FEB3
	.byte $00 ; |........| $FEB4
	.byte $00 ; |........| $FEB5
	.byte $00 ; |........| $FEB6
	.byte $00 ; |........| $FEB7
	.byte $00 ; |........| $FEB8
	.byte $80 ; |X.......| $FEB9
	.byte $E0 ; |XXX.....| $FEBA
	.byte $F0 ; |XXXX....| $FEBB
	.byte $E0 ; |XXX.....| $FEBC
	.byte $80 ; |X.......| $FEBD
	.byte $00 ; |........| $FEBE
	.byte $00 ; |........| $FEBF
	.byte $00 ; |........| $FEC0
	.byte $00 ; |........| $FEC1
	.byte $00 ; |........| $FEC2
	.byte $00 ; |........| $FEC3
	.byte $00 ; |........| $FEC4
	.byte $00 ; |........| $FEC5
	.byte $00 ; |........| $FEC6
	.byte $03 ; |......XX| $FEC7
	.byte $07 ; |.....XXX| $FEC8
	.byte $03 ; |......XX| $FEC9
	.byte $03 ; |......XX| $FECA
	.byte $01 ; |.......X| $FECB
	.byte $01 ; |.......X| $FECC
	.byte $00 ; |........| $FECD
	.byte $00 ; |........| $FECE
	.byte $00 ; |........| $FECF
	.byte $80 ; |X.......| $FED0
	.byte $C0 ; |XX......| $FED1
	.byte $F0 ; |XXXX....| $FED2
	.byte $F0 ; |XXXX....| $FED3
	.byte $E0 ; |XXX.....| $FED4
	.byte $E0 ; |XXX.....| $FED5
	.byte $C0 ; |XX......| $FED6
	.byte $C0 ; |XX......| $FED7
	.byte $80 ; |X.......| $FED8
	.byte $80 ; |X.......| $FED9
	.byte $00 ; |........| $FEDA
	.byte $00 ; |........| $FEDB
	.byte $00 ; |........| $FEDC
	.byte $00 ; |........| $FEDD
	.byte $00 ; |........| $FEDE
	.byte $00 ; |........| $FEDF
	.byte $00 ; |........| $FEE0
	.byte $03 ; |......XX| $FEE1
	.byte $07 ; |.....XXX| $FEE2
	.byte $07 ; |.....XXX| $FEE3
	.byte $03 ; |......XX| $FEE4
	.byte $01 ; |.......X| $FEE5
	.byte $00 ; |........| $FEE6
	.byte $00 ; |........| $FEE7
	.byte $C0 ; |XX......| $FEE8
	.byte $E0 ; |XXX.....| $FEE9
	.byte $F0 ; |XXXX....| $FEEA
	.byte $F8 ; |XXXXX...| $FEEB
	.byte $F8 ; |XXXXX...| $FEEC
	.byte $FC ; |XXXXXX..| $FEED
	.byte $FC ; |XXXXXX..| $FEEE
	.byte $FC ; |XXXXXX..| $FEEF

pedestalSprite
	.byte $3C ; |..XXXX..| $FEF0
	.byte $3C ; |..XXXX..| $FEF1
	.byte $7E ; |.XXXXXX.| $FEF2
	.byte $FF ; |XXXXXXXX| $FEF3
	
lfef4
	lda		arkLocationRegionId,x				
	bmi		lfef9					
	rts								

lfef9
	jsr		invSelectAdjHandler					
	jsr		lf8e1					
	rts								



TreasureRoomPlayerGraphics
	.byte SET_PLAYER_0_COLOR | BLACK >> 1

devInitialsGfx1 ;programmer's initials #2
    .byte $00 ; |        | $ff01
    .byte $07 ; |     xxx| $ff02
    .byte $04 ; |     x  | $ff03
    .byte $77 ; | xxx xxx| $ff04
    .byte $71 ; | xxx   x| $ff05
    .byte $75 ; | xxx x x| $ff06
    .byte $57 ; | x x xxx| $ff07
    .byte $50 ; | x x    | $ff08



	.byte	$00,$d6,$1c,$36,$1c,$49,$7f ; $ff09 (*)
	.byte	$49,$1c,$3e,$00,$b9,$8a,$a1,$81 ; $ff10 (*)
	.byte	$00,$00,$00,$00,$00,$00,$1c,$70 ; $ff18 (*)
	.byte	$07,$70,$0e,$00,$cf,$a6,$00,$81 ; $ff20 (*)
	.byte	$77,$36,$14,$22,$ae,$14,$36,$77 ; $ff28 (*)
	.byte	$00,$bf,$ce,$00,$ef,$81,$00,$00 ; $ff30 (*)
	.byte	$00,$00,$00,$00,$68,$2f,$0a,$0c ; $ff38 (*)
	.byte	$08,$00,$80,$81,$00,$00
	
	
devInitialsGfx0
	.byte $07 ; |.....XXX| $FF46
	.byte $01 ; |.......X| $FF47
	.byte $57 ; |.X.X.XXX| $FF48
	.byte $54 ; |.X.X.X..| $FF49
	.byte $77 ; |.XXX.XXX| $FF4A
	.byte $50 ; |.X.X....| $FF4B
	.byte $50 ; |.X.X....| $FF4C
	.byte $00 ; |........| $FF4D
	.byte $00 ; |........| $FF4E
	.byte $00 ; |........| $FF4F
	.byte $00 ; |........| $FF50

	
	
MarketplacePlayerGraphics
	.byte $80 ; |X.......| $FF51
	.byte $7E ; |.XXXXXX.| $FF52
	.byte $86 ; |X....XX.| $FF53
	.byte $80 ; |X.......| $FF54
	.byte $A6 ; |X.X..XX.| $FF55
	.byte $5A ; |.X.XX.X.| $FF56
	.byte $7E ; |.XXXXXX.| $FF57
	.byte $80 ; |X.......| $FF58
	.byte $7F ; |.XXXXXXX| $FF59
	.byte $00 ; |........| $FF5A
	.byte $B1 ; |X.XX...X| $FF5B
	.byte $F9 ; |XXXXX..X| $FF5C
	
	.byte $F6 ; |XXXX.XX.| $FF5D
	.byte $06 ; |.....XX.| $FF5E
	.byte $1E ; |...XXXX.| $FF5F
	.byte $12 ; |...X..X.| $FF60
	.byte $1E ; |...XXXX.| $FF61
	.byte $12 ; |...X..X.| $FF62
	.byte $1E ; |...XXXX.| $FF63
	.byte $7F ; |.XXXXXXX| $FF64
	.byte $00 ; |........| $FF65
	.byte $B9 ; |X.XXX..X| $FF66
	.byte $00 ; |........| $FF67
	.byte $D4 ; |XX.X.X..| $FF68
	.byte $00 ; |........| $FF69
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1;$81
	.byte $1C ; |...XXX..| $FF6B
	.byte $2A ; |..X.X.X.| $FF6C
	.byte $55 ; |.X.X.X.X| $FF6D
	.byte $2A ; |..X.X.X.| $FF6E
	.byte $14 ; |...X.X..| $FF6F
	.byte $3E ; |..XXXXX.| $FF70
	.byte $00 ; |........| $FF71
	.byte $C1 ; |XX.....X| $FF72
	.byte $E6 ; |XXX..XX.| $FF73
	.byte $00 ; |........| $FF74
	.byte $00 ; |........| $FF75
	.byte $00 ; |........| $FF76
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1;$81
	.byte $7F ; |.XXXXXXX| $FF78
	.byte $55 ; |.X.X.X.X| $FF79
	.byte $2A ; |..X.X.X.| $FF7A
	.byte $55 ; |.X.X.X.X| $FF7B
	.byte $2A ; |..X.X.X.| $FF7C
	.byte $3E ; |..XXXXX.| $FF7D
	.byte $00 ; |........| $FF7E
	.byte $B9 ; |X.XXX..X| $FF7F
	.byte $86 ; |X....XX.| $FF80
	.byte $91 ; |X..X...X| $FF81
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1;$81
	.byte $7E ; |.XXXXXX.| $FF83
	.byte $80 ; |X.......| $FF84
	.byte $86 ; |X....XX.| $FF85
	.byte $A6 ; |X.X..XX.| $FF86
	.byte $5A ; |.X.XX.X.| $FF87
	.byte $7E ; |.XXXXXX.| $FF88
	.byte $86 ; |X....XX.| $FF89
	.byte $7F ; |.XXXXXXX| $FF8A
	.byte $00 ; |........| $FF8B
	.byte $D6 ; |XX.X.XX.| $FF8C
	.byte $77 ; |.XXX.XXX| $FF8D
	.byte $77 ; |.XXX.XXX| $FF8E
	.byte $80 ; |X.......| $FF8F
	.byte $D6 ; |XX.X.XX.| $FF90
	.byte $77 ; |.XXX.XXX| $FF91
	.byte $00 ; |........| $FF92
	.byte $C1 ; |XX.....X| $FF93
	.byte $B6 ; |X.XX.XX.| $FF94
	.byte $A1 ; |X.X....X| $FF95
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1;$81
	.byte $1C ; |...XXX..| $FF97
	.byte $2A ; |..X.X.X.| $FF98
	.byte $55 ; |.X.X.X.X| $FF99
	.byte $2A ; |..X.X.X.| $FF9A
	.byte $14 ; |...X.X..| $FF9B
	.byte $3E ; |..XXXXX.| $FF9C
	.byte $00 ; |........| $FF9D
	.byte $00 ; |........| $FF9E
	.byte $00 ; |........| $FF9F
	.byte $00 ; |........| $FFA0




EntranceRoomPlayerGraphics
	;Rock Sprite Setup
	.byte $00						; Padding/Space.
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1; Set Color (Grey/White).
	
	; The Rock Sprite Pattern
	.byte $70 						; |.XXX....|
	.byte $5F 						; |.X.XXXXX|
	.byte $72 						; |.XXX..X.|
	.byte $05 						; |.....X.X|
	
	.byte $00 						; End of sprite.

	; Positioning Commands (for subsequent items or HMOVE logic)
	.byte SET_PLAYER_0_HMOVE | HMOVE_R8 >> 1
	.byte $00
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1
	.byte SET_PLAYER_0_COLOR | (BLACK + 8) >> 1
	.byte $1F ; |...XXXXX|
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte $18 ; |...XX...|
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1
	.byte SET_PLAYER_0_COLOR | BLACK >> 1
	.byte $1C ; |...XXX..|
	.byte $1F ; |...XXXXX|
	.byte SET_PLAYER_0_HMOVE | HMOVE_R2 >> 1
	.byte $7F ; |.XXXXXXX|
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R2 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte $3F ; |..XXXXXX|
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1
	.byte $70 ; |.XXX....|
	.byte $40 ; |.X......|
	.byte SET_PLAYER_0_COLOR | (BLACK + 8) >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte $7E ; |.XXXXXX.|
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R2 >> 1
	.byte $00 ; |........|
	.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1
	.byte SET_PLAYER_0_COLOR | (BLACK + 8) >> 1
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte $38 ; |..XXX...|
	.byte $78 ; |.XXXX...|
	.byte $7B ; |.XXXX.XX|
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte $6F ; |.XX.XXXX|
	.byte $00 ; |........|
	.byte SET_PLAYER_0_HMOVE | HMOVE_L6 >> 1
	.byte SET_PLAYER_0_COLOR | (LT_RED + 4) >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R3 >> 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1
	.byte $00 ; |........|
	.byte $30 ; |..XX....|
	.byte $30 ; |..XX....|
	.byte $30 ; |..XX....|
	.byte SET_PLAYER_0_HMOVE | HMOVE_R3 >> 1
	.byte $30 ; |..XX....|
	.byte $30 ; |..XX....|
	.byte $30 ; |..XX....|
	.byte $10 ; |...X....|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|





inventoryIndexPosX
	.byte HMOVE_R6 | 4
	.byte HMOVE_L1 | 5
	.byte HMOVE_R7 | 5
	.byte HMOVE_0  | 6
	.byte HMOVE_R8 | 6
	.byte HMOVE_R1 | 7

	.org BANK1TOP + 4096 - 6, 0
	
	;Interrupt Vectors
	.word BANK1Start	; NMI
	.word BANK1Start	; RESET
	.word BANK1Start	; IRQ/BRK