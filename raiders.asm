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
ram_98			= $98
screenInitFlag			= $99
grenadeState			= $9a
grenadeCookTime			= $9b
resetEnableFlag			= $9c
majorEventFlag			= $9d
score			= $9e
lives_left		= $9f
bulletCount		= $a0
eventTimer			= $a1
indyFootstep			= $a2
soundChan1WhipTimer			= $a3
diamond_h		= $a4
grenadeOpeningPenalty	= $a5
escape_hatch_used		= $a6
findingArkBonus			= $a7
usingParachuteBonus	= $a8
ankhUsedBonus		= $a9
yarFoundBonus		= $aa
ark_found		= $ab
thiefShot		= $ac
mesa_entered	= $ad
unknown_action	= $ae
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
cursor_pos		= $c3
ram_c4			= $c4
selectedInventoryId	= $c5
ram_c6			= $c6
ram_c7			= $c7
objectPosX			= $c8
indyPosX			= $c9
m0PosX			= $ca
weaponPosX			= $cb
indyPosXSet			= $cc

objectPosY			= $ce
indyPosY			= $cf
m0PosY		= $d0
weaponPosY			= $d1	;Weapon vertical position (Whip or Bullet)
objPosY			= $d2

objectState			= $d4
snakePosY			= $d5
timepieceGfxPtrs			= $d6
snakeMotionPtr			= $d7
timepieceSpriteDataPtr			= $d8
indyGfxPtrs		= $d9
ram_da			= $da
indySpriteHeight			= $db
p0SpriteHeight			= $dc
p0GfxPtrLo		= $dd
p0GfxPtrHi			= $de
objState			= $df
roomSpecialData			= $e0
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
HEIGHT_ARK	= 7
HEIGHT_PEDESTAL				= 15
HEIGHT_INDY_SPRITE			= 11
HEIGHT_INVENTORY_SPRITES		= 8
HEIGHT_PARACHUTING_SPRITE = 15
HEIGHT_THIEF					= 16
HEIGHT_KERNEL				= 160

;--------------------
;objects
;---------------------

key_obj = $07

;--------------------
; Inventory Sprite Ids
;--------------------
ID_INVENTORY_EMPTY		= (emptySprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_FLUTE		= (inventoryFluteSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_PARACHUTE	= (inventoryParachuteSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_COINS		= (inventoryCoinsSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_MARKETPLACE_GRENADE	= (marketplaceGrenadeSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_BLACK_MARKET_GRENADE = (blackMarketGrenadeSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_KEY		= (inventoryKeySprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_WHIP		= (inventoryWhipSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_SHOVEL		= (inventoryShovelSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_REVOLVER	= (inventoryRevolverSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_HEAD_OF_RA = (inventoryHeadOfRaSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_TIME_PIECE = (inventoryTimepieceSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_ANKH		= (inventoryAnkhSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_CHAI		= (inventoryChaiSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES
ID_INVENTORY_HOUR_GLASS = (inventoryHourGlassSprite - inventorySprites) / HEIGHT_INVENTORY_SPRITES


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
BANK0_REORG				= $D000

INIT_SCORE				= 100		; starting score

SET_PLAYER_0_COLOR		= %10000000
SET_PLAYER_0_HMOVE		= %10000001

XMAX					= 160

BULLET_OR_WHIP_ACTIVE 	= %10000000
USING_GRENADE_OR_PARACHUTE = %00000010


ENTRANCE_ROOM_CAVE_VERT_POS = 9
ENTRANCE_ROOM_ROCK_VERT_POS = 53

;***********************************************************
;	bank 0 / 0..1
;***********************************************************

	seg		code
	org		$0000
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
.moveObjectLoop
	sta		WSYNC					; wait for next scan line
	lda		objectPosX,x			; get object's horizontal position
	tay								
	lda		HMOVETable,y	; get fine motion/coarse position value				
	sta		HMP0,x					; set object's fine motion value
	and		#$0f					; mask off fine motion value
	tay								; move coarse move value to y
.coarseMoveObj
	dey								
	bpl		.coarseMoveObj			; set object's coarse position			
	sta		RESP0,x					
	dex								
	bpl		.moveObjectLoop					
	sta		WSYNC					; wait for next scan line
	sta		HMOVE					
	jmp		JumpToDisplayKernel					

CheckObjectHit:
	bit		CXM1P					; check player collision with Indy bullet 
	bpl		.checkWeaponHit		; branch if no player collision				
	ldx		currentRoomId			; get the current screen id				
	cpx		#ID_VALLEY_OF_POISON	; are we in the valley of poison?						
	bcc		.checkWeaponHit						
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
	eor		objState,x			; XOR with current state (Toggle Direction).			
	sta		objState,x			; Save new state.			

weaponHitThief:
	lda		weaponStatus			; get bullet or whip status			
	bpl		.setThiefShotPenalty	; branch if bullet or whip not active					
	and		#~BULLET_OR_WHIP_ACTIVE						
	sta		weaponStatus			; clear BULLET_OR_WHIP_ACTIVE bit			
	lda		pickupStatusFlags						
	and		#%00011111			; Mask check.			
	beq		finishItemPickup						
	jsr		placeItemInInventory						

finishItemPickup:
	lda		#%01000000		 	; Set Bit 6.					
	sta		pickupStatusFlags
								
.setThiefShotPenalty
	; --------------------------------------------------------------------------
	; PENALTY FOR SHOOTING THIEF
	; Killing a thief is dishonorable (or noise?). Deducts score.
	; --------------------------------------------------------------------------
	lda    #~BULLET_OR_WHIP_ACTIVE 	; Clear Active Bit mask.						
	sta		weaponPosY				; Invalidates weapon Y (effectively removing it).			
	lda		#PENALTY_SHOOTING_THIEF 	; Load Penalty Value.					
	sta		thiefShot					; Apply penalty.

.checkWeaponHit:
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
	sta		objPosY					; move offscreen (?)						
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
	bpl		SetWellOfSoulsEntryEvent	; If Bit 7 is CLEAR, it's a Snake/Lethal
										; Jump to Death Logic.				
	; --- Tsetse Fly Paralysis ---
	; If Bit 7 is SET, it implies Tsetse Flies (Spider Room / Valley).
	lda    secondsTimer				; Get Timer.		
	and		#$07							; Mask for random duration?
	ora		#$80						; Set Bit 7.  
	sta		eventTimer				; Set "Paralysis" Timer (Indy freezes).		
	bne		handleMesaSideSecretExit	; Return.					

SetWellOfSoulsEntryEvent:
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
	jsr		InitializeScreenState						
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
	jsr		InitializeScreenState		; initialize rooom state				
	lda		savedThiefPosY			; get saved thief vertical position						
	sta		objState				; set thief vertical position						
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
ContinueToHitDispatch:
	jmp		screenLogicDispatcher						

collectTreasure:
	lda		currentRoomId				; get the current screen id						
	bne		jumpPlayerHit				; branch if not Treasure Room		
	lda		treasureIndex						
	and		#$07						
	tax								
	lda		MarketBasketItems,x		; get items from market basket			
	jsr		placeItemInInventory		; place basket item in inventory				
	bcc		ContinueToHitDispatch						
	lda		#$01						
	sta		objState					; mark treasure as collected 
	bne		ContinueToHitDispatch		; unconditional branch				

jumpPlayerHit:
	asl									; multiply screen id by 2
	tax								
	lda		playerCollisionJumpTable+1,x					
	pha									; push MSB to stack
	lda		playerCollisionJumpTable,x					
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
	bne		ResumeHitDispatch			; If not equal, nothing special happens			
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
	jsr		InitializeScreenState		; Load new screen data for the Ark Room				
	jmp		verticalSync 			; Finish frame cleanly and transition visually			

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
	bmi		ResumeHitDispatch						
	clc									; Carry clear
	jsr		removeItem					; take away specified item				
	bcs		updateAfterItemRemove						
	sec									; Carry set
	jsr		removeItem						
	bcc		ResumeHitDispatch						
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
	bne		ResumeHitDispatch			; unconditional branch			

playerHitInSpiderRoom:
	ldx		#$00						; Set X to 0
	stx		spiderRoomState				; Clear spider room state	
	lda		#%10000000					; Set Bit 7						
	sta		majorEventFlag				; Trigger major event flag					
ResumeHitDispatch:
	jmp		screenLogicDispatcher						

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
	jmp		screenLogicDispatcher						

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
	jmp		screenLogicDispatcher		; Resume				

checkIndyYForMarketFlags:
	cpy		#$20						; Check Zone (Row $20)
	bcc		setMarketFlags				; If Y < $20, check top zone.

clearMarketFlags:
	; Zone 2: Between $20 and $3A (Middle path)
	lda		#$00						
	sta		moveDirection				; Clear movement modification flags.		
	jmp		screenLogicDispatcher		; Resume				

setMarketFlags:
	cpy		#$09						; Check Topmost Boundary ($09)
	bcc		clearMarketFlags			; If Y < $09 (Very top), clear flags.		
	lda		#$e0						; Mask Top 3 bits
	and		moveDirection					
	ora		#$42						; Force bits 6 and 1 ($42).
	sta		moveDirection				; Apply "Shove" physics.	
	jmp		screenLogicDispatcher		; Resume		

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
	jmp		screenLogicDispatcher		; Resume				


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
	jmp		screenLogicDispatcher						

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
	bne		screenLogicDispatcher		; Resume				

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
	bcc		screenLogicDispatcher		; If inventory full (Carry Clear), exit				
	ror		entranceRoomState						
	sec								
	rol		entranceRoomState			; Update Room State:		
	lda		#$42						;   Set High Bit of rotated value 
										;   (becomes Bit 0 after roll)
	sta		$df							; Move the Whip to Y=66
	bne		screenLogicDispatcher		; Resume				

checkRockRange:
	; --- Rock Collision Logic ---
	; Determines if Indy is hitting the solid part of the rock.
	; The Rock seems to have a hole between Y=22 and Y=31
	cmp		#$16						; Top Boundary Check (22)	
	bcc		pushIndyOutOfRock						
	cmp		#$1f						; Bottom Bound of Top Segment
	bcc		screenLogicDispatcher		; If 22 <= Y < 31, pass-through

	; If Y >= 31 (and < 63 from earlier check), fall through to push left.			
pushIndyOutOfRock:
	dec		indyPosX					; Push Indy Left

screenLogicDispatcher:
	lda		currentRoomId				; get the current screen id					
	asl									; multiply screen id by 2 (word table)
	tax									; Move the result to X
										; X is the index into a jump table
	bit		CXP1FB						; check Indy collision with playfield
	bpl		screenIdleLogicDispatcher	; If no collision (bit 7 is clear),
										; branch to non-collision handler					
	lda		PlayerPFCollisionJumpTable+1,x	; Load high byte of handler address				
	pha									; Push it to the return stack  
	lda		PlayerPFCollisionJumpTable,x	; Load low byte of handler address				
	pha									; Push it to the return stack
	rts									; jump to Player / Playfield collision strategy

screenIdleLogicDispatcher:
	lda		roomIdleHandlerJumpTable+1,x	; Load high byte of default screen behavior routine				
	pha									;push to stack
	lda		roomIdleHandlerJumpTable,x		; Load low byte of default screen behavior routine			
	pha									; push to stack
	rts									; Indirect jump to it (no collision case)

warpToMesaSide:
	lda		objState					; Load vertical position of an object 
	sta		savedThiefPosY			; Store it to temp variable savedThiefPosY		
	lda		indyPosY					; get Indy's vertical position
	sta		savedIndyPosY				; Store to temp variable savedIndyVertPo	
	lda		indyPosX					
SaveIndyAndThiefPosition:
	sta		savedIndyPosX				; Store to temp variable savedIndyHorizPos 	
putIndyInMesaSide:
	lda		#ID_MESA_SIDE				; Change screen to Mesa Side	
	sta		currentRoomId					
	jsr		InitializeScreenState					
	lda		#$05					
	sta		indyPosY					; Set Indy's vertical position on entry to Mesa Side
	lda		#$50					
	sta		indyPosX					; Set Indy's horizontal position on entry
	tsx								
	cpx		#$fe					
	bcs		FailSafeToCollisionCheck	;If X = $FE, jump to FailSafeToCollisionCheck				
	rts									; Otherwise, return

FailSafeToCollisionCheck:
	jmp		roomIdleHandler					


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

IndyPFHitEntranceRoom:
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
	ldx		#<indyPosY - objectPosY 	; X = offset to Indy in object array						
	jsr		getMoveDir					; Move Indy accordingly

setIndyToNormalMove:
	lda		#$05						
	sta		indyFootstep				; Set Indy walk state	
	bne		roomIdleHandler				; unconditional branch		

indyEnterHole:
	rol		playerInputState					
	sec								
	bcs		undoInputBitShift			; unconditional branch			

setIndyToTriggeredState:
	rol		playerInputState					
	clc								

undoInputBitShift:
	ror		playerInputState					

roomIdleHandler:
	bit		CXM0P						; check player collisions with missile0
	bpl		CheckGrenadeDetonation		; branch if didn't collide with Indy			
	ldx		currentRoomId				; get the current screen id	
	cpx		#ID_SPIDER_ROOM				; Are we in the Spider Room?	
	beq		ClearInputBit0ForSpiderRoom	; Yes, go to ClearInputBit0ForSpiderRoom				
	bcc		CheckGrenadeDetonation		; If screen ID is lower than Spider Room, skip 			
	lda		#$80						; Trigger a major event (Death/Capture)
	sta		majorEventFlag				; Set flag.	
	bne		DespawnMissile0				; unconditional branch

ClearInputBit0ForSpiderRoom:
	rol		playerInputState			; Rotate input left, bit 7 ? carry		
	sec									; Set carry (overrides carry from rol)
	ror		playerInputState			; Rotate right, carry -> bit 7 (bit 0 lost)		
	rol		spiderRoomState				; Rotate a status byte left (bit 7 ? carry)	
	sec									; Set carry (again overrides whatever came before)
	ror		spiderRoomState				; Rotate right, carry -> bit 7 (bit 0 lost)	
DespawnMissile0:
	lda		#$7f					
	sta		m0PosYShadow				; Possibly related state or shadow position	
	sta		m0PosY						; Move missile0 offscreen (to y=127)

CheckGrenadeDetonation:
	bit		grenadeState				; Check status flags	
	bpl		verticalSync 				; If bit 7 is clear, skip (no grenade active)	
	bvs		ApplyGrenadeWallEffect		; If bit 6 is set, jump			
	lda		secondsTimer				; get seconds time value	 
	cmp		grenadeCookTime				; compare with grenade detination time	
	bne		verticalSync 				; branch if not time to detinate grenade	
	lda		#$a0					
	sta		weaponPosY				; Move grenade offscreen 	
	sta		majorEventFlag				; Trigger major event (explosion happened)	
ApplyGrenadeWallEffect:
	lsr		grenadeState				; Logical shift right: bit 0 -> carry	
	bcc		skipUpdate					; If bit 0 was clear, skip this
										; (grenade effect not triggered)
	lda		#GRENADE_OPENING_IN_WALL					
	sta		grenadeOpeningPenalty		; Apply penalty (e.g., reduce score)			
	ora		entranceRoomState			; Mark the entrance room as 		
	sta		entranceRoomState			; having the grenade opening		
	ldx		#ID_ENTRANCE_ROOM					
	cpx		currentRoomId					
	bne		UpdateEntranceRoomEventState ; branch if not in the ENTRANCE_ROOM					
	jsr		InitializeScreenState		; Update visuals/state to reflect the wall opening			
UpdateEntranceRoomEventState:
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
	jsr		InitializeScreenState		; Refresh screen visuals			
skipUpdate
	sec								
	jsr		removeItem					; carry set...take away selected item

verticalSync:
	lda		INTIM					
	bne		verticalSync 					
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
	jsr		InitializeScreenState		; Transition to Ark Room			
gotoArkRoomLogic:
	jmp		setupScreenAndObj					

checkShowDevInitials:
	lda		currentRoomId				; get teh room number
	cmp		#ID_ARK_ROOM				; are we in the ark room? 
	bne		HandleEasterEgg				; branch if not in ID_ARK_ROOM	
	lda		#$9c					
	sta		soundChan1WhipTimer					
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
	sta		indyFootstep				; Set Indys state to 0E	

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

	sta		objPosY						; Store A (Timer/Counter-based Y) into objPosY
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
	jmp		jmpBank1Kernel			; Else, jump to end	

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
	bpl		NudgeProjectileLeft			; If projectile is to the right of Indy,
										; continue		
NudgeProjectileRight
	inx								
	bne		setProjectilePos					
NudgeProjectileLeft
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
	bpl		NudgeProjectileRight		; If projectile right of Indy, nudge right			
	bmi		NudgeProjectileLeft			; Else, nudge left
			
checkInputAndStateForEvent
	bit		mesaSideState					
	bmi		stopWeaponEvent				; If flag set, skip	
	bit		playerInputState					
	bpl		HandleIndyMove				; If no button, skip	
	ror								
	bcc		HandleIndyMove				; If no button, skip	
stopWeaponEvent
	jmp		HandleIInventorySelect					

HandleIndyMove
	ldx		#<indyPosY - objectPosY		; Get index of Indy in object list					
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
	bcs		TriggerScreenTransition		; If failed/blocked, exit			
	bvc		checkScanBoundaryOrContinue	; If no vertical/horizontal event flag, skip				
	ldy		loopCounter					; Event index
	lda		RoomEventOffsetTable,y		; Get movement offset from table			
	cpy		#$02					
	bcs		ApplyHorizontalOffset		; If index = 2, move horizontally
	adc		indyPosY					
	sta		indyPosY					
	jmp		checkScanBoundaryOrContinue					

ApplyHorizontalOffset
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

TriggerScreenTransition
	sty		currentRoomId				; Set new screen based on event result	
	jsr		InitializeScreenState		; Load new room or area

HandleIInventorySelect
	bit		INPT4|$30					; read action button from left controller
	bmi		NormalizeplayerInput		; branch if action button not pressed			
	bit		grenadeState					
	bmi		ExitItemHandler				; If game state prevents interaction, skip	
	lda		playerInputState					
	ror									; Check bit 0 of input
	bcs		handleIInventoryUpdate		; If set, already mid-action, skip			
	sec									; Prepare to take item
	jsr		removeItem					; carry set...take away selected item
	inc		playerInputState			;  Advance to next inventory slot		
	bne		handleIInventoryUpdate		; Always branch			
NormalizeplayerInput
	ror		playerInputState					
	clc								
	rol		playerInputState					
handleIInventoryUpdate
	lda		moveDirection					
	bpl		ExitItemHandler				; If no item queued, exit	
	and		#$1f					
	cmp		#$01					
	bne		CheckShovelPickup					
	inc		bulletCount					; Give Indy 3 bullets
	inc		bulletCount					 
	inc		bulletCount					 
	bne		ClearItemUseFlag					
CheckShovelPickup
	cmp		#$0b					
	bne		placeGenericItem					
	ror		blackMarketState			; rotate Black Market state right		
	sec									; set carry
	rol		blackMarketState			; rotate left to show Indy carrying Shovel		
	ldx		#$45					
	stx		objState					; Set Y-pos for shovel on screen
	ldx		#$7f					
	stx		m0PosY				
placeGenericItem
	jsr		placeItemInInventory					
ClearItemUseFlag
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
	bcs		StoreGrenadeState					
	cpy		#$64						; Is Indy too far left?
	bcc		StoreGrenadeState					
	ldx		currentRoomId				; get the current screen id	
	cpx		#ID_ENTRANCE_ROOM			; Are we in the Entrance Room?		
	bne		StoreGrenadeState			; branch if not in the ENTRANCE_ROOM		
	ora		#$01						; Set bit 0 to trigger wall explosion effect
StoreGrenadeState
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
	bvc		AttemptDigForArk			; If bit 6 is clear , skip to further checks		
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
	adc		objState					; Add reference vertical offset (likely floor or map tile start)
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

AttemptDigForArk
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
	bcs		ClampDigDepth						; If at or beyond max depth, cap it
	iny									; Otherwise restore it back (prevent negative values)
ClampDigDepth
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
	jsr		InitializeScreenState		; Load the data for the new screen			
	lda		#$4c						; Prepare a flag or state value for later use
	;Warp Indy to center of Mesa Field
	sta		indyPosX					; Set Indy's horizontal position
	sta		weaponPosX					; Set projectile's horizontal position
	lda		#$46						; Fixed vertical position value (mesa starting Y)
	sta		indyPosY					; Set Indy's vertical position
	sta		weaponPosY					; Set projectile's vertical position
	sta		eventState					; Set event/state flag0
	lda		#$1d						; Set initial Y for object
	sta		objState					; set object vertical position
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
	bcs		CheckWhipLeftDirection		; branch if not pushed down			
	ldx		#$0f						; If pressing down, set vertical offset
CheckWhipLeftDirection
	ror									; shift MOVE_LEFT to carry
	bcs		CheckWhipRightDirection		; branch if not pushed left			
	ldy		#<-9						; If pressing left, set horizontal offset
CheckWhipRightDirection
	ror									; shift MOVE_RIGHT to carry
	bcs		ApplyWhipStrikePosition		; branch if not pushed right			
	ldy		#$10						; If pressing right, set horizontal offset
ApplyWhipStrikePosition
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
	sta		soundChan1WhipTimer			; Animate or time whip	
updateIndyParachuteSprite
	bit		mesaSideState				; Check game status flags	
	bpl		setIndySpriteIfStill		; If parachute bit (bit 7) is clear,
										; skip parachute rendering			
	lda		#<ParachutingIndySprite		; Load low byte of parachute sprite address					
	sta		indyGfxPtrs					; Set Indy's sprite pointer
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
	sta		indyGfxPtrs					; Store sprite pointer (low byte)		
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
	adc		indyGfxPtrs					; Advance to next sprite frame
	cmp		#<IndyStandSprite			; Check if we've reached the end of walkcycle					
	bcc		setIndySpriteLSBValue		; If not, update walking frame			
	lda		#$02						; Set a short animation timer
	sta		soundChan1WhipTimer					
	lda		#<Indy_0					; Reset animation back to first walking frame					
	bcs		setIndySpriteLSBValue		; Unconditional jump to store new sprite pointer


handleMesaScroll
	ldx		currentRoomId				; get the current screen id		
	cpx		#ID_MESA_FIELD				; are we on the Mesa Field?	
	beq		CheckScrollEligibility		; Yes, check if we need to scroll
	cpx		#ID_VALLEY_OF_POISON		; Do check if we are in Valley of Poison too			
	bne		jmpBank1Kernel			; If neither, continue to Bank 1 routines
CheckScrollEligibility
	lda		frameCount					; get current frame count
	bit		playerInputState			; Check movement input flags		
	bpl		scrollIfInZone				; If bit 7 of playerInputState is clear 
	lsr								
scrollIfInZone
	ldy		indyPosY					; get Indy's vertical position			
	cpy		#$27						; Check Lower Bound 
	beq		jmpBank1Kernel			; ; If at bottom, stop scrolling

	ldx		objState					; Load Scroll Offset	
	bcs		ReverseScrollIfApplicable	; if pushing up 				
	beq		jmpBank1Kernel			; if objState is zero, skip scrolling		
	inc		indyPosY					; Increment Indy's vertical position	
	inc		weaponPosY					; Move Weapon DOWN with him
	and		#$02						; Check Frame Timing every 2 frames
	bne		jmpBank1Kernel			; if not time to scroll, skip			

	; These variables are modified but overridden in Bank 1 for display.
	dec		objState					; Decrement scroll offset
	inc		objectPosY					 
	inc		m0PosY				
	inc		objPosY					
	inc		objectPosY					 
	inc		m0PosY				
	inc		objPosY					
	jmp		jmpBank1Kernel					

ReverseScrollIfApplicable
	cpx		#$50						; Check Upper Bound
	bcs		jmpBank1Kernel			; If at top, stop scrolling	
	dec		indyPosY					; Move Indy UP
	dec		weaponPosY					; Move Weapon UP
	and		#$02						; Frame Timer check
	bne		jmpBank1Kernel					

	inc		objState										
	dec		objectPosY					 
	dec		m0PosY				
	dec		objPosY					
	dec		objectPosY					 
	dec		m0PosY				
	dec		objPosY					

jmpBank1Kernel
	lda		#<bank1Kernel				; Load low byte of Bank 1 Kernel address	
	sta		bankSwitchJMPAddrLo			; Store in Bank Switch JMP Addr Low		
	lda		#>bank1Kernel				; Load high byte of Bank 1 Kernel address	
	sta		bankSwitchJMPAddrHi			; Store in Bank Switch JMP Addr High
	jmp		JumpToBank1					; Jump to Bank 1 Kernel

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
	lda		IndyColorValues,x					
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
	sta		objState,x					; Clear object state array
	sta		roomSpecialData,x				
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

InitializeScreenState
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
	sta		roomSpecialData				; put into roomSpecialData
	lda		PF1GfxDataLo,x					
	sta		PF1GfxPtrLo					; Load PF1 graphics pointer LSB.
	lda		PF1GfxDataHi,x					
	sta		PF1GfxPtrHi					; Load PF1 graphics pointer MSB.
	lda		PF2GfxDataLo,x					
	sta		PF2GfxPtrLo					; Load PF2 graphics pointer LSB.
	lda		PF2GfxDataHi,x					
	sta		PF2GfxPtrHi					; Load PF2 graphics pointer MSB.
	lda		#$55					
	sta		objPosY						; Init object vertical parameter
	sta		weaponPosY					; Reset Weapon vertical parameter
	cpx		#ID_TEMPLE_ENTRANCE			; If Temple Entrance or later,		
	bcs		initTempleAndShiningLight	; jump to specific initialization.				
	lda		#$00						; Load 0
	cpx		#ID_TREASURE_ROOM			; Is this the Treasure Room?					
	beq		setTreasureRoomObjPosY		; Special setup for Treasure Room.			
	cpx		#ID_ENTRANCE_ROOM					
	beq		setEntranceRoomObjPosY		; Special setup for Enterance Room.			
	sta		objectPosY					 
ld902
	ldy		#$4f					
	cpx		#$02					
	bcc		ld918					
	lda		treasureIndex,x				
	ror								
	bcc		ld918					
	ldy		ldf72,x					
	cpx		#$03					
	bne		ld918					
	lda		#$ff					
	sta		m0PosY				
ld918
	sty		objState					
	rts								

setTreasureRoomObjPosY
	lda		treasureIndex					
	and		#$78					
	sta		treasureIndex					
	lda		#$1a					
	sta		objectPosY					 
	lda		#$26					
	sta		objState					
	rts								

setEntranceRoomObjPosY
	lda		entranceRoomState					
	and		#$07					
	lsr								
	bne		ld935					
	ldy		#$ff					
	sty		m0PosY				
ld935
	tay								
	lda		ldf70,y					
	sta		objectPosY					 
	jmp		ld902					

initTempleAndShiningLight
	cpx		#$08					
	beq		ld950					
	cpx		#$06					
	bne		ld968					
	ldy		#$00					
	sty		timepieceSpriteDataPtr					
	ldy		#$40					
	sty		dynamicGfxData					
	bne		ld958					
ld950
	ldy		#$ff					
	sty		dynamicGfxData					
	iny								
	sty		timepieceSpriteDataPtr					
	iny								
ld958
	sty		dungeonBlock1					
	sty		dungeonBlock2					
	sty		dungeonBlock3					
	sty		dungeonBlock4					
	sty		dungeonBlock5					
	ldy		#$39					
	sty		objectState					
	sty		snakePosY					
ld968
	cpx		#$09					
	bne		ld977					
	ldy		indyPosY					
	cpy		#$49					
	bcc		ld977					
	lda		#$50					
	sta		objState					
	rts								

ld977
	lda		#$00					
	sta		objState					
	rts								

CheckRoomOverrideCondition
	ldy		lde00,x					
	cpy		bankSwitchJMPOpcode					
	beq		ld986					
	clc								
	clv								
	rts								

ld986
	ldy		lde34,x					
	bmi		ld99b					
ld98b
	lda		ldf04,x					
	beq		ld992					
ld990
	sta		indyPosY					
ld992
	lda		ldf38,x					
	beq		ld999					
	sta		indyPosX					
ld999
	sec								
	rts								

ld99b
	iny								
	beq		ld9f9					
	iny								
	bne		ld9b6					
	ldy		lde68,x					
	cpy		bankSwitchJMPAddr					
	bcc		ld9af					
	ldy		lde9c,x					
	bmi		ld9c7					
	bpl		ld98b					
ld9af
	ldy		lded0,x					
	bmi		ld9c7					
	bpl		ld98b					
ld9b6
	lda		bankSwitchJMPAddr					
	cmp		lde68,x					
	bcc		ld9f9					
	cmp		lde9c,x					
	bcs		ld9f9					
	ldy		lded0,x					
	bpl		ld98b					
ld9c7
	iny								
	bmi		ld9d4					
	ldy		#$08					
	bit		treasureIndex					
	bpl		ld98b					
	lda		#$41					
	bne		ld990					
ld9d4
	iny								
	bne		ld9e1					
	lda		entranceRoomEventState					
	and		#$0f					
	bne		ld9f9					
	ldy		#$06					
	bne		ld98b					
ld9e1
	iny								
	bne		ld9f0					
	lda		entranceRoomEventState					
	and		#$0f					
	cmp		#$0a					
	bcs		ld9f9					
	ldy		#$06					
	bne		ld98b					
ld9f0
	iny								
	bne		ld9fe					
	ldy		#$01					
	bit		playerInputState					
	bmi		ld98b					
ld9f9
	clc								
	bit		ld9fd					

ld9fd
	.byte	$60								; $d9fd (d)

ld9fe
	iny								
	bne		ld9f9					
	ldy		#$06					
	lda		#$0e					
	cmp		selectedInventoryId					
	bne		ld9f9					
	bit		INPT5|$30				
	bmi		ld9f9					
	jmp		ld98b					

removeItem
	ldy		ram_c4					
	bne		lda16					
	clc								
	rts								

lda16
	bcs		check_key					
	tay								
	asl								
	asl								
	asl								
	ldx		#$0a					
lda1e
	cmp		invSlotLo,x					
	bne		lda3a					
	cpx		cursor_pos					
	beq		lda3a					
	dec		ram_c4					
	lda		#$00					
	sta		invSlotLo,x					
	cpy		#$05					
	bcc		lda37					
	tya								
	tax								
	jsr		ShowItemAsNotTaken					
	txa								
	tay								
lda37
	jmp		ldaf7					

lda3a
	dex								
	dex								
	bpl		lda1e					
	clc								
	rts								

check_key
	lda		#<emptySprite				; load blank space
	ldx		cursor_pos				; get at current position
	sta		invSlotLo,x			; put in current slot
	ldx		selectedInventoryId			; is the current object
	cpx		#key_obj				; the key?
	bcc		lda4f					
	jsr		ShowItemAsNotTaken					
lda4f
	txa								
	tay								
	asl								
	tax								
	lda		ldc76,x					
	pha								
	lda		ldc75,x					
	pha								
	ldx		currentRoomId					
	rts								

lda5e:
	lda		#$3f						
	and		$b4						
	sta		$b4						
lda64:
	jmp		ldad8						

lda67:
	stx		$8d						
	lda		#$70						
	sta		$d1						
	bne		lda64						

lda6f:
	lda		#$42						
	cmp		$91						
	bne		lda86						
	lda		#$03						
	sta		$81						
	jsr		InitializeScreenState						
	lda		#$15						
	sta		$c9						
	lda		#$1c						
	sta		$cf						
	bne		ldad8						

lda86:
	cpx		#$05						
	bne		ldad8						
	lda		#$05						
	cmp		$8b						
	bne		ldad8						
	sta		yarFoundBonus					
	lda		#$00						
	sta		$ce						
	lda		#$02						
	ora		$b4						
	sta		$b4						
	bne		ldad8						

lda9e:
	ror		$b1						
	clc								
	rol		$b1						
	cpx		#$02						
	bne		ldaab						
	lda		#$4e						
	sta		$df						
ldaab:
	bne		ldad8						

ldaad:
	ror		$b2						
	clc								
	rol		$b2						
	cpx		#$03						
	bne		ldabe						
	lda		#$4f						
	sta		$df						
	lda		#$4b						
	sta		$d0						
ldabe:
	bne		ldad8						

ldac0:
	ldx		$81						
	cpx		#$03						
	bne		ldad1						
	lda		$c9						
	cmp		#$3c						
	bcs		ldad1						
	rol		$b2						
	sec								
	ror		$b2						
ldad1:
	lda		$91						
	clc								
	adc		#$40						
	sta		$91						
ldad8:
	dec		$c4						
	bne		ldae2						
	lda		#$00						
	sta		selectedInventoryId			
	beq		ldaf7						

ldae2:
	ldx		$c3						
ldae4:
	inx								
	inx								
	cpx		#$0b						
	bcc		ldaec						
	ldx		#$00						
ldaec:
	lda		invSlotLo,x		 
	beq		ldae4						
	stx		$c3						
	lsr								
	lsr								
	lsr								
	sta		selectedInventoryId			
ldaf7
	lda		#$0d					
	sta		indyFootstep					
	sec								
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




	; .byte	$00								; $db00 (d)
	; .byte	$00,$35,$10,$17,$30,$00,$00,$00 ; $db01 (*)
	; .byte	$00,$00,$00,$00					; $db09 (*)
	; .byte	$05								; $db0d (d)
	.byte	$00,$00,$f0,$e0,$d0,$c0,$b0,$a0 ; $db0e (*)
	.byte	$90,$71,$61,$51,$41,$31,$21,$11 ; $db16 (*)
	.byte	$01,$f1,$e1,$d1,$c1,$b1,$a1,$91 ; $db1e (*)
	.byte	$72,$62,$52,$42,$32,$22,$12,$02 ; $db26 (*)
	.byte	$f2,$e2,$d2,$c2,$b2,$a2,$92,$73 ; $db2e (*)
	.byte	$63,$53,$43,$33,$23,$13,$03,$f3 ; $db36 (*)
	.byte	$e3,$d3,$c3,$b3,$a3,$93,$74,$64 ; $db3e (*)
	.byte	$54,$44							; $db46 (*)
	.byte	$34								; $db48 (d)
	.byte	$24,$14,$04,$f4					; $db49 (*)
	.byte	$e4								; $db4d (d)
	.byte	$d4,$c4,$b4,$a4,$94,$75,$65,$55 ; $db4e (*)
	.byte	$45,$35,$25,$15,$05,$f5,$e5,$d5 ; $db56 (*)
	.byte	$c5,$b5,$a5,$95,$76,$66,$56,$46 ; $db5e (*)
	.byte	$36,$26,$16,$06,$f6,$e6,$d6,$c6 ; $db66 (*)
	.byte	$b6,$a6,$96,$77,$67,$57,$47,$37 ; $db6e (*)
	.byte	$27,$17,$07,$f7,$e7,$d7,$c7,$b7 ; $db76 (*)
	.byte	$a7,$97,$78,$68,$58,$48,$38,$28 ; $db7e (*)
	.byte	$18,$08,$f8,$e8,$d8,$c8,$b8,$a8 ; $db86 (*)
	.byte	$98,$79,$69,$59					; $db8e (*)

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

IndyColorValues
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
	.byte	$78,$4c,$5d,$4c,$4f,$4c,$12,$4c ; $dbd4 (*)
	.byte	$4c,$4c,$4c,$12,$12				; $dbdc (*)

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
	.byte	$fe,$fa,$02,$06					; $dbff (*)

roomSpecialTable
	.byte	$00,$00,$18,$04,$03,$03,$85,$85,$3b,$85,$85	

m0PosXTable
	.byte	$20					; Treasure Room
	.byte	$78					; Marketplace
	.byte	$85					; Entrance Room
	.byte	$4d					; Black Market
	.byte	$62					; Map Room
	.byte	$17					; Mesa Side
	.byte	$50					; Temple Entrance
	.byte	$50					; Spider Room
	.byte	$50					; Room of the Shining Light
	.byte	$50					; Mesa Field
	.byte	$50					; Valley of Poison
	.byte	$12					; Thieves Den
	.byte	$12					; Well of Souls


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
	.byte	$06,$06,$06,$06,$06,$06,$48,$68 ; $dc28 (*)
	.byte	$89,$00,$00						; $dc30 (*)
PF1GfxDataHi
	.byte	$00,$00,$00,$00,$00,$00,$fd,$fd ; $dc33 (*)
	.byte	$fd,$fe,$fe						; $dc3b (*)
PF2GfxDataLo
	.byte	$20,$20,$20,$20,$20,$20,$20,$b7 ; $dc3e (*)
	.byte	$9b,$78,$78						; $dc46 (*)
PF2GfxDataHi
	.byte	$00,$00,$00,$00,$00,$00,$fd,$fd ; $dc49 (*)
	.byte	$fd,$fe,$fe						; $dc51 (*)
ldc54
	.byte	$01,$02,$04,$08,$10,$20,$40,$80 ; $dc54 (*)
itemStatusMaskTable
	.byte	$fe,$fd,$fb,$f7,$ef,$df,$bf,$7f ; $dc5c (*)
ldc64
	.byte	$00,$00,$00,$00,$08,$00,$02,$0a ; $dc64 (*)
	.byte	$0c,$0e,$01,$03,$04,$06,$05,$07 ; $dc6c (*)
	.byte	$0d								; $dc74 (*)
ldc75
	.byte	$0f								; $dc75 (*)
ldc76
	.byte	$0b




ldc77: ;read from 2 bytes ealier (index >=2)
	.word ldad8-1 ; $dc77/78
	.word ldad8-1 ; $dc79/7a
	.word lda5e-1 ; $dc7b/7c
	.word ldac0-1 ; $dc7d/7e
	.word ldad8-1 ; $dc7f/80
	.word ldad8-1 ; $dc81/82
	.word ldad8-1 ; $dc83/84
	.word ldad8-1 ; $dc85/86
	.word ldad8-1 ; $dc87/88
	.word lda9e-1 ; $dc89/8a
	.word ldaad-1 ; $dc8b/8c
	.word ldad8-1 ; $dc8d/8e
	.word ldad8-1 ; $dc8f/90
	.word ldad8-1 ; $dc91/92
	.word ldad8-1 ; $dc93/94
	.word lda67-1 ; $dc95/96
	.word lda6f-1 ; $dc97/98
	.word lda67-1 ; $dc99/9a

playerCollisionJumpTable
	.word screenLogicDispatcher-1 ; $dc9b/9c
	.word playerHitInMarket-1 ; $dc9d/9e
	.word playerHitInEntranceRoom-1 ; $dc9f/a0
	.word playerHitInBlackMarket-1 ; $dca1/a2
	.word screenLogicDispatcher-1 ; $dca3/a4
	.word playerHitInMesaSide-1 ; $dca5/a6
	.word playerHitInTempleEntrance-1 ; $dca7/a8
	.word playerHitInSpiderRoom-1 ; $dca9/aa
	.word playerHitInRoomOfShiningLight-1 ; $dcab/ac
	.word screenLogicDispatcher-1 ; $dcad/ae
	.word playerHitInValleyOfPoison-1 ; $dcaf/b0
	.word playerHitInThievesDen-1 ; $dcb1/b2
	.word playerHitInWellOfSouls-1 ; $dcb3/b4

PlayerPFCollisionJumpTable:
	.word roomIdleHandler-1 ; $dcb5/b6
	.word roomIdleHandler-1 ; $dcb7/b8
	.word IndyPFHitEntranceRoom-1 ; $dcb9/ba
	.word roomIdleHandler-1 ; $dcbb/bc
	.word roomIdleHandler-1 ; $dcbd/be
	.word indyMoveOnInput-1 ; $dcbf/c0
	.word stopIndyMovInTemple-1 ; $dcc1/c2
	.word indyMoveOnInput-1 ; $dcc3/c4
	.word playerHitInRoomOfShiningLight-1 ; $dcc5/c6
	.word roomIdleHandler-1 ; $dcc7/c8
	.word indyEnterHole-1 ; $dcc9/ca
	.word roomIdleHandler-1 ; $dccb/cc
	.word roomIdleHandler-1 ; $dccd/ce

roomIdleHandlerJumpTable:
	.word roomIdleHandler-1 ; $dccf/d0
	.word roomIdleHandler-1 ; $dcd1/d2
	.word setIndyToTriggeredState-1 ; $dcd3/d4
	.word roomIdleHandler-1 ; $dcd5/d6
	.word initFallbackEntryPosition-1 ; $dcd7/d8
	.word roomIdleHandler-1 ; $dcd9/da
	.word roomIdleHandler-1 ; $dcdb/dc
	.word roomIdleHandler-1 ; $dcdd/de
	.word roomIdleHandler-1 ; $dcdf/e0
	.word warpToMesaSide-1 ; $dce1/e2
	.word setIndyToTriggeredState-1 ; $dce3/e4
	.word roomIdleHandler-1 ; $dce5/e6
	.word roomIdleHandler-1 ; $dce7/e8

placeItemInInventory
	ldx		ram_c4					
	cpx		#$06					
	bcc		ldcf1					
	clc								
	rts								

ldcf1
	ldx		#$0a					
ldcf3
	ldy		invSlotLo,x					
	beq		ldcfc					; branch if current slot is free
	dex								
	dex								
	bpl		ldcf3					
	brk								; unused

ldcfc
	tay								
	asl								; multiply object number by 8 for gfx
	asl								;...
	asl								;...
	sta		invSlotLo,x			; and store in current slot
	lda		ram_c4					
	bne		ldd0a					
	stx		cursor_pos					
	sty		selectedInventoryId					
ldd0a
	inc		ram_c4					
	cpy		#$04					
	bcc		ldd15					
	tya								
	tax								
	jsr		ShowItemAsTaken					
ldd15
	lda		#$0c					
	sta		indyFootstep					
	sec								
	rts								

ShowItemAsNotTaken
	lda		ldc64,x					
	lsr								
	tay								
	lda		itemStatusMaskTable,y					
	bcs		ldd2a					
	and		ram_c6					
	sta		ram_c6					
	rts								

ldd2a
	and		ram_c7					
	sta		ram_c7					
	rts								

ShowItemAsTaken
	lda		ldc64,x					
	lsr								
	tax								
	lda		ldc54,x					
	bcs		ldd3e					
	ora		ram_c6					
	sta		ram_c6					
	rts								

ldd3e
	ora		ram_c7					
	sta		ram_c7					
	rts								

isItemAlreadyTaken:
	lda		ldc64,x					
	lsr								
	tay								
	lda		ldc54,y					
	bcs		ldd53						
	and		ram_c6					 
	beq		ldd52						
	sec								
ldd52:
	rts								

ldd53:
	and		ram_c7					 
	bne		ldd52						
	clc								
	rts								


updateRoomEventState
	and		#$1f					
	tax								
	lda		ram_98					
	cpx		#$0c					
	bcs		ldd67					
	adc		ldfe5,x					
	sta		ram_98					
ldd67
	rts								

startGame
	sei								; turn off interrupts
	cld								; clear decimal flag (no bcd)
	ldx		#$ff					;
	txs								; reset the stack pointer
	inx								; clear x
	txa								; clear a
clear_zp
	sta		VSYNC,x
	dex
	bne		clear_zp

	dex								; x = $ff
	stx		score					; reset score
	lda		#>emptySprite				; blank inventory
	sta		invSlotHi				; slot 1
	sta		invSlotHi2			; slot 2
	sta		invSlotHi3			; slot 3
	sta		invSlotHi4			; slot 4
	sta		invSlotHi5			; slot 5
	sta		invSlotHi6			; slot 6

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
	lsr								; divide 13 by 2 (round down)
	sta		bulletCount				; load 6 bullets
	jsr		InitializeScreenState					
	jmp		startNewFrame					

initGameVars:
	lda		#$20					
	sta		invSlotLo					
	lsr								
	lsr								
	lsr								
	sta		selectedInventoryId					
	inc		ram_c4					
	lda		#$00					
	sta		invSlotLo2					
	sta		invSlotLo3					
	sta		invSlotLo4					
	sta		invSlotLo5					
	lda		#$64					
	sta		score				
	lda		#$58					
	sta		indyGfxPtrs				
	lda		#$fa					
	sta		ram_da					
	lda		#$4c					
	sta		indyPosX					
	lda		#$0f					
	sta		indyPosY					
	lda		#ID_ENTRANCE_ROOM					
	sta		currentRoomId					
	sta		lives_left					
	jsr		InitializeScreenState					
	jmp		setupScreenAndObj					

;------------------------------------------------------------
; getFinalScore
; The player's progress is determined by Indy's height on the pedestal when the
; game is complete. The player wants to achieve the lowest adventure points
; possible to lower Indy's position on the pedestal.
;
getFinalScore
	lda		score					; load score
	sec								; positve actions...
	sbc		findingArkBonus					; shovel used
	sbc		usingParachuteBonus			; parachute used
	sbc		ankhUsedBonus				; ankh used
	sbc		yarFoundBonus				; yar found
	sbc		lives_left				; lives left
	sbc		ark_found				; ark found
	sbc		mesa_entered				; mesa entered
	sbc		unknown_action			; never updated
	clc								; negitive actions...
	adc		grenadeOpeningPenalty			; gernade used
	adc		escape_hatch_used		; escape hatch used
	adc		thiefShot				; thief shot
	sta		score					; store in final score
	rts								; return

	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $ddf8 (*)
lde00
	.byte	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$f8 ; $de00 (*)
	.byte	$ff,$ff,$ff,$ff,$ff,$4f,$4f,$4f ; $de08 (*)
	.byte	$4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f ; $de10 (*)
	.byte	$44,$44,$0f,$0f,$1c,$0f,$0f,$18 ; $de18 (*)
	.byte	$0f,$0f,$0f,$0f,$0f,$12,$12,$89 ; $de20 (*)
	.byte	$89,$8c,$89,$89,$86,$89,$89,$89 ; $de28 (*)
	.byte	$89,$89,$86,$86					; $de30 (*)
lde34
	.byte	$ff,$fd,$ff,$ff,$fd,$ff,$ff,$ff ; $de34 (*)
	.byte	$fd,$01,$fd,$04,$fd,$ff,$fd,$01 ; $de3c (*)
	.byte	$ff,$0b,$0a,$ff,$ff,$ff,$04,$ff ; $de44 (*)
	.byte	$fd,$ff,$fd,$ff,$ff,$ff,$ff,$ff ; $de4c (*)
	.byte	$fe,$fd,$fd,$ff,$ff,$ff,$ff,$ff ; $de54 (*)
	.byte	$fd,$fd,$fe,$ff,$ff,$fe,$fd,$fd ; $de5c (*)
	.byte	$ff,$ff,$ff,$ff					; $de64 (*)
lde68
	.byte	$00,$1e,$00,$00,$11,$00,$00,$00 ; $de68 (*)
	.byte	$11,$00,$10,$00,$60,$00,$11,$00 ; $de70 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $de78 (*)
	.byte	$70,$00,$12,$00,$00,$00,$00,$00 ; $de80 (*)
	.byte	$30,$15,$24,$00,$00,$00,$00,$00 ; $de88 (*)
	.byte	$18,$03,$27,$00,$00,$30,$20,$12 ; $de90 (*)
	.byte	$00,$00,$00,$00					; $de98 (*)
lde9c
	.byte	$00,$7a,$00,$00,$88,$00,$00,$00 ; $de9c (*)
	.byte	$88,$00,$80,$00,$65,$00,$88,$00 ; $dea4 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $deac (*)
	.byte	$72,$00,$16,$00,$00,$00,$00,$00 ; $deb4 (*)
	.byte	$02,$1f,$2f,$00,$00,$00,$00,$00 ; $debc (*)
	.byte	$1c,$40,$01,$00,$00,$07,$27,$16 ; $dec4 (*)
	.byte	$00,$00,$00,$00					; $decc (*)
lded0
	.byte	$00,$02,$00,$00,$09,$00,$00,$00 ; $ded0 (*)
	.byte	$07,$00,$fc,$00,$05,$00,$09,$00 ; $ded8 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $dee0 (*)
	.byte	$03,$00,$ff,$00,$00,$00,$00,$00 ; $dee8 (*)
	.byte	$01,$06,$fe,$00,$00,$00,$00,$00 ; $def0 (*)
	.byte	$fb,$fd,$0b,$00,$00,$08,$08,$00 ; $def8 (*)
	.byte	$00,$00,$00,$00					; $df00 (*)
ldf04
	.byte	$00,$4e,$00,$00,$4e,$00,$00,$00 ; $df04 (*)
	.byte	$4d,$4e,$4e,$4e,$04,$01,$03,$01 ; $df0c (*)
	.byte	$01,$01,$01,$01,$01,$01,$01,$01 ; $df14 (*)
	.byte	$40,$00,$23,$00,$00,$00,$00,$00 ; $df1c (*)
	.byte	$00,$00,$41,$00,$00,$00,$00,$00 ; $df24 (*)
	.byte	$45,$00,$42,$00,$00,$00,$42,$23 ; $df2c (*)
	.byte	$28,$00,$00,$00					; $df34 (*)
ldf38
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $df38 (*)
	.byte	$00,$00,$00,$00,$4c,$00,$00,$00 ; $df40 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $df48 (*)
	.byte	$80,$00,$86,$00,$00,$00,$00,$00 ; $df50 (*)
	.byte	$80,$86,$80,$00,$00,$00,$00,$00 ; $df58 (*)
	.byte	$12,$12,$4c,$00,$00,$16,$80,$12 ; $df60 (*)
	.byte	$50,$00,$00,$00					; $df68 (*)

RoomEventOffsetTable
	.byte	$01,$ff,$01,$ff					; $df6c (*)

ldf70
	.byte	$35,$09							; $df70 (*)
ldf72
	.byte	$00,$00,$42,$45,$0c,$20

MarketBasketItems
	.byte ID_INVENTORY_COINS, ID_INVENTORY_CHAI
	.byte ID_INVENTORY_ANKH, ID_INVENTORY_HOUR_GLASS


ArkRoomImpactResponseTable
	.byte	$07,$03,$05,$06,$09,$0b,$0e,$00 ; $df7c (*)
	.byte	$01,$03,$05,$00,$09,$0c,$0e,$00 ; $df84 (*)
	.byte	$01,$04,$05,$00,$0a,$0c,$0f,$00 ; $df8c (*)
	.byte	$02,$04,$05,$08,$0a,$0d,$0f,$00 ; $df94 (*)

JumpToDisplayKernel SUBROUTINE
.waitTime
	lda		INTIM					
	bne		.waitTime				
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	lda		#$44					
	sta		bankSwitchJMPAddrLo					
	lda		#$f8					
	sta		bankSwitchJMPAddrHi					
JumpToBank1
	lda		#$ad					
	sta		loopCounter					
	lda		#$f9					
	sta		tempGfxHolder					
	lda		#$ff					
	sta		bankSwitchJMPOpcode					
	lda		#$4c					
	sta		bankSwitchJMPAddr					
	jmp.w	loopCounter					

getMoveDir
	ror								;move first bit into carry
	bcs		mov_emy_right			;if 1 check if enemy shoulld go right
	dec		objectPosY,x				;move enemy left 1 unit
mov_emy_right
	ror								;rotate next bit into carry
	bcs		mov_emy_down				;if 1 check if enemy should go up
	inc		objectPosY,x				;move enemy right 1 unit
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

	; .byte	$00,$00,$00,$00,$00,$0a,$09,$0b ; $dfd5 (*)
	; .byte	$00,$06,$05,$07,$00,$0e,$0d,$0f ; $dfdd (*)
ldfe5
	.byte	$00								; $dfe5 (d)
	.byte	$06,$03,$03,$03,$00,$00,$06,$00 ; $dfe6 (*)
	.byte	$00,$00,$06,$00,$00,$00,$00,$00 ; $dfee (*)
	.byte	$00,$00,$00						; $dff6 (*)
	.byte	$00								; $dff9 (d)
	.byte	$68,$dd,$68,$dd					; $dffa (*)
	.byte	$68								; $dffe (d)
	.byte	$dd								; $dfff (*)


;***********************************************************
;	bank 1 / 0..1
;***********************************************************

	seg		code
	org		$1000
	rorg	$f000

BANK1Start
	lda		lfff8					

lf003
	cmp		roomSpecialData					
	bcs		lf01a					
	lsr								
	clc								
	adc		objState					
	tay								
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	lda		(PF1GfxPtrLo),y				
	sta		PF1						
	lda		(PF2GfxPtrLo),y				
	sta		PF2						
	bcc		lf033					
lf01a
	sbc		objectState					
	lsr								
	lsr								
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	tax								
	cpx		snakePosY					
	bcc		lf02d					
	ldx		timepieceSpriteDataPtr					
	lda		#$00					
	beq		lf031					
lf02d
	lda		dynamicGfxData,x				
	ldx		timepieceSpriteDataPtr					
lf031
	sta		PF1,x					
lf033
	ldx		#$1e					
	txs								
	lda		scanline				
	sec								
	sbc		indyPosY					
	cmp		indySpriteHeight					
	bcs		lf079					
	tay								
	lda		(indyGfxPtrs),y			
	tax								
lf043
	lda		scanline				
	sec								
	sbc		objectPosY					 
	cmp		p0SpriteHeight					 
	bcs		lf07d					
	tay								
	lda		(p0GfxPtrLo),y				
	tay								
lf050
	lda		scanline				
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	cmp		weaponPosY					
	php								
	cmp		m0PosY				
	php								
	stx		GRP1					
	sty		GRP0					
	sec								
	sbc		objPosY					
	cmp		#$08					
	bcs		lf06e					
	tay								
	lda		(timepieceGfxPtrs),y				
	sta		ENABL					
	sta		HMBL					
lf06e
	inc		scanline				
	lda		scanline				
	cmp		#$50					
	bcc		lf003					
	jmp		lf1ea					

lf079
	ldx		#$00					
	beq		lf043					
lf07d
	ldy		#$00					
	beq		lf050					
lf081
	cpx		#$4f					
	bcc		lf088					
	jmp		lf1ea					

lf088
	lda		#$00					
	beq		lf0a4					
lf08c
	lda		(p0GfxPtrLo),y				
	bmi		lf09c					
	cpy		objState					
	bcs		lf081					
	cpy		objectPosY					 
	bcc		lf088					
	sta		GRP0					
	bcs		lf0a4					
lf09c
	asl								
	tay								
	and		#$02					
	tax								
	tya								
	sta		(PF1GfxPtrLo,x)				
lf0a4
	inc		scanline				
	ldx		scanline				
	lda		#$02					
	cpx		m0PosY				
	bcc		lf0b2					
	cpx		roomSpecialData					
	bcc		lf0b3					
lf0b2
	ror								
lf0b3
	sta		ENAM0					
lf0b5
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	txa								
	sec								
	sbc		snakePosY					
	cmp		#$10					
	bcs		lf0ff					
	tay								
	cmp		#$08					
	bcc		lf0fb					
	lda		timepieceSpriteDataPtr					
	sta		timepieceGfxPtrs					
lf0ca
	lda		(timepieceGfxPtrs),y				
	sta		HMBL					
lf0ce
	ldy		#$00					
	txa								
	cmp		weaponPosY					
	bne		lf0d6					
	dey								
lf0d6
	sty		ENAM1					
	sec								
	sbc		indyPosY					
	cmp		indySpriteHeight					
	bcs		lf107					
	tay								
	lda		(indyGfxPtrs),y			
lf0e2
	ldy		scanline				
	sta		GRP1					
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	lda		#$02					
	cpx		objPosY					
	bcc		lf0f9					
	cpx		p0SpriteHeight					 
	bcc		lf0f5					
lf0f4
	ror								
lf0f5
	sta		ENABL					
	bcc		lf08c					
lf0f9
	bcc		lf0f4					
lf0fb
	nop								
	jmp		lf0ca					

lf0ff
	pha								
	pla								
	pha								
	pla								
	nop								
	jmp		lf0ce					

lf107
	lda		#$00					
	beq		lf0e2					
lf10b
	inx								
	sta		HMCLR					
	cpx		#$a0					
	bcc		lf140					
	jmp		lf1ea					

lf115
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	inx								
	lda		loopCounter					
	sta		GRP0					
	lda		tempGfxHolder					
	sta		COLUP0					
	txa								
	ldx		#$1f					
	txs								
	tax								
	lsr								
	cmp		objPosY					
	php								
	cmp		weaponPosY					
	php								
	cmp		m0PosY				
	php								
	sec								
	sbc		indyPosY					
	cmp		indySpriteHeight					
	bcs		lf10b					
	tay								
	lda		(indyGfxPtrs),y			
	sta		HMCLR					
	inx								
	sta		GRP1					
lf140
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	bit		objectState					
	bpl		lf157					
	ldy		bankSwitchJMPAddrHi					
	lda		bankSwitchJMPAddrLo					
	lsr		objectState					
lf14e
	dey								
	bpl		lf14e					
	sta		RESP0					
	sta		HMP0					
	bmi		lf115					
lf157
	bvc		lf177					
	txa								
	and		#$0f					
	tay								
	lda		(p0GfxPtrLo),y				
	sta		GRP0					
	lda		(timepieceGfxPtrs),y				
	sta		COLUP0					
	iny								
	lda		(p0GfxPtrLo),y				
	sta		loopCounter					
	lda		(timepieceGfxPtrs),y				
	sta		tempGfxHolder					
	cpy		p0SpriteHeight					 
	bcc		lf174					
	lsr		objectState					
lf174
	jmp		lf115					

lf177
	lda		#$20					
	bit		objectState					
	beq		lf1a7					
	txa								
	lsr								
	lsr								
	lsr								
	lsr								
	lsr								
	bcs		lf115					
	tay								
	sty		bankSwitchJMPAddr					
	lda.wy	objState,y				
	sta		REFP0					
	sta		NUSIZ0					
	sta		bankSwitchJMPOpcode					
	bpl		lf1a2					
	lda		diggingState					
	sta		p0GfxPtrLo					
	lda		#$65					
	sta		timepieceGfxPtrs					
	lda		#$00					
	sta		objectState					
	jmp		lf115					

lf1a2
	lsr		objectState					
	jmp		lf115					

lf1a7
	lsr								
	bit		objectState					
	beq		lf1ce					
	ldy		bankSwitchJMPAddr					
	lda		#$08					
	and		bankSwitchJMPOpcode					
	beq		lf1b6					
	lda		#$03					
lf1b6
	eor.wy	dynamicGfxData,y				
	and		#$03					
	tay								
	lda		lfc40,y					
	sta		p0GfxPtrLo					
	lda		#$44					
	sta		timepieceGfxPtrs					
	lda		#$0f					
	sta		p0SpriteHeight					 
	lsr		objectState					
	jmp		lf115					

lf1ce
	txa								
	and		#$1f					
	cmp		#$0c					
	beq		lf1d8					
	jmp		lf115					

lf1d8
	ldy		bankSwitchJMPAddr					
	lda.wy	thiefPosX,y				
	sta		bankSwitchJMPAddrLo					
	and		#$0f					
	sta		bankSwitchJMPAddrHi					
	lda		#$80					
	sta		objectState					
	jmp		lf115					

lf1ea
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	ldx		#$ff					
	stx		PF1						
	stx		PF2						
	inx								
	stx		GRP0					
	stx		GRP1					
	stx		ENAM0					
	stx		ENAM1					
	stx		ENABL					
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	lda		#$03					
	ldy		#$00					
	sty		REFP1					
	sta		NUSIZ0					
	sta		NUSIZ1					
	sta		VDELP0					
	sta		VDELP1					
	sty		GRP0					
	sty		GRP1					
	sty		GRP0					
	sty		GRP1					
	nop								
	sta		RESP0					
	sta		RESP1					
	sty		HMP1					
	lda		#$f0					
	sta		HMP0					
	sty		REFP0					
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	lda		#$1a					
	sta		COLUP0					
	sta		COLUP1					
	lda		cursor_pos					
	lsr								
	tay								
	lda		InventoryIndexHorizValues,y					
	sta		HMBL					
	and		#$0f					
	tay								
	ldx		#$00					
	stx		HMP0					
	sta		WSYNC					
;---------------------------------------
	stx		PF0						
	stx		COLUBK					
	stx		PF1						
	stx		PF2						
lf24a
	dey								
	bpl		lf24a					
	sta		RESBL					
	stx		CTRLPF					
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	lda		#$3f					
	and		frameCount				
	bne		draw_menu					
	lda		#$3f					
	and		secondsTimer					 
	bne		draw_menu					
	lda		entranceRoomEventState					
	and		#$0f					
	beq		draw_menu					
	cmp		#$0f					
	beq		draw_menu					
	inc		entranceRoomEventState					
draw_menu
	sta		WSYNC					; draw blank line
	lda		#$42					; set red...
	sta		COLUBK					; ...as the background color
	sta		WSYNC					; draw four more scanlines
	sta		WSYNC					;
	sta		WSYNC					;
	sta		WSYNC					;
	lda		#$07					
	sta		loopCounter					
draw_inventory
	ldy		loopCounter					
	lda		(invSlotLo),y				
	sta		GRP0					
	sta		WSYNC					
;---------------------------------------
	lda		(invSlotLo2),y				
	sta		GRP1					
	lda		(invSlotLo3),y				
	sta		GRP0					
	lda		(invSlotLo4),y				
	sta		tempGfxHolder					
	lda		(invSlotLo5),y				
	tax								
	lda		(invSlotLo6),y				
	tay								
	lda		tempGfxHolder					
	sta		GRP1					
	stx		GRP0					
	sty		GRP1					
	sty		GRP0					
	dec		loopCounter					
	bpl		draw_inventory					 
	lda		#$00					
	sta		WSYNC					
;---------------------------------------
	sta		GRP0					
	sta		GRP1					
	sta		GRP0					
	sta		GRP1					
	sta		NUSIZ0					
	sta		NUSIZ1					
	sta		VDELP0					
	sta		VDELP1					
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	ldy		#$02					
	lda		ram_c4					
	bne		lf2c6					
	dey								
lf2c6
	sty		ENABL					
	ldy		#$08					
	sty		COLUPF					
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	ldy		#$00					
	sty		ENABL					
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	sta		WSYNC					
;---------------------------------------
	ldx		#$0f					
	stx		VBLANK					
	ldx		#$24					
	stx		TIM64T					
	ldx		#$ff					
	txs								
	ldx		#$01					
lf2e8
	lda		indyFootstep,x				
	sta		AUDC0,x					
	sta		AUDV0,x					
	bmi		lf2fb					
	ldy		#$00					
	sty		indyFootstep,x				
lf2f4
	sta		AUDF0,x					
	dex								
	bpl		lf2e8					
	bmi		lf320					
lf2fb
	cmp		#$9c					
	bne		lf314					
	lda		#$0f					
	and		frameCount				
	bne		lf30d					
	dec		diamond_h				
	bpl		lf30d					
	lda		#$17					
	sta		diamond_h				
lf30d
	ldy		diamond_h				
	lda		lfbe8,y					
	bne		lf2f4					
lf314
	lda		frameCount				
	lsr								
	lsr								
	lsr								
	lsr								
	tay								
	lda		lfaee,y					
	bne		lf2f4					
lf320
	lda		selectedInventoryId					
	cmp		#$0f					
	beq		lf330					
	cmp		#$02					
	bne		lf344					
	lda		#$84					
	sta		soundChan1WhipTimer					
	bne		lf348					
lf330
	bit		INPT5|$30				
	bpl		lf338					
	lda		#$78					
	bne		lf340					
lf338
	lda		secondsTimer					 
	and		#$e0					
	lsr								
	lsr								
	adc		#$98					
lf340
	ldx		cursor_pos					
	sta		invSlotLo,x					
lf344
	lda		#$00					
	sta		soundChan1WhipTimer					
lf348
	bit		screenEventState					
	bpl		lf371					
	lda		frameCount				
	and		#$07					
	cmp		#$05					
	bcc		lf365					
	ldx		#$04					
	ldy		#$01					
	bit		majorEventFlag					
	bmi		lf360					
	bit		eventTimer					
	bpl		lf362					
lf360
	ldy		#$03					
lf362
	jsr		lf8b3					
lf365
	lda		frameCount				
	and		#$06					
	asl								
	asl								
	sta		timepieceGfxPtrs					
	lda		#$fd					
	sta		snakeMotionPtr					
lf371
	ldx		#$02					
lf373
	jsr		lfef4					
	inx								
	cpx		#$05					
	bcc		lf373					
	bit		majorEventFlag					
	bpl		lf3bf					
	lda		frameCount				
	bvs		lf39d					
	and		#$0f					
	bne		lf3c5					
	ldx		indySpriteHeight					
	dex								
	stx		soundChan1WhipTimer					
	cpx		#$03					
	bcc		lf398					
	lda		#$8f					
	sta		weaponPosY					
	stx		indySpriteHeight					
	bcs		lf3c5					
lf398
	sta		frameCount				
	sec								
	ror		majorEventFlag					
lf39d
	cmp		#$3c					
	bcc		lf3a9					
	bne		lf3a5					
	sta		soundChan1WhipTimer					
lf3a5
	ldy		#$00					
	sty		indySpriteHeight					
lf3a9
	cmp		#$78					
	bcc		lf3c5					
	lda		#$0b					
	sta		indySpriteHeight					
	sta		soundChan1WhipTimer					
	sta		majorEventFlag					
	dec		lives_left					
	bpl		lf3c5					
	lda		#$ff					
	sta		majorEventFlag					
	bne		lf3c5					
lf3bf
	lda		currentRoomId					
	cmp		#ID_ARK_ROOM					
	bne		lf3d0					
lf3c5
	lda		#$d8					
	sta		bankSwitchJMPAddrLo					
	lda		#$d3					
	sta		bankSwitchJMPAddrHi					
	jmp		lf493					

lf3d0
	bit		eventState					
	bvs		lf437					
	bit		mesaSideState					
	bmi		lf437					
	bit		grenadeState					
	bmi		lf437					
	lda		#$07					
	and		frameCount				
	bne		lf437					
	lda		ram_c4					
	and		#$06					
	beq		lf437					
	ldx		cursor_pos					
	lda		invSlotLo,x					
	cmp		#$98					
	bcc		lf3f2					
	lda		#$78					
lf3f2
	bit		SWCHA					
	bmi		lf407					
	sta		invSlotLo,x					
lf3f9
	inx								
	inx								
	cpx		#$0b					
	bcc		lf401					
	ldx		#$00					
lf401
	ldy		invSlotLo,x					
	beq		lf3f9					
	bne		lf415					
lf407
	bvs		lf437					
	sta		invSlotLo,x					
lf40b
	dex								
	dex								
	bpl		lf411					
	ldx		#$0a					
lf411
	ldy		invSlotLo,x					
	beq		lf40b					
lf415
	stx		cursor_pos					
	tya								
	lsr								
	lsr								
	lsr								
	sta		selectedInventoryId					
	cpy		#$90					
	bne		lf437					
	ldy		#ID_MESA_FIELD					
	cpy		currentRoomId					
	bne		lf437					
	lda		#$49					
	sta		eventState					
	lda		indyPosY					
	adc		#$09					
	sta		weaponPosY					
	lda		indyPosX					
	adc		#$09					
	sta		weaponPosX					
lf437
	lda		eventState					
	bpl		lf454					
	cmp		#$bf					
	bcs		lf44b					
	adc		#$10					
	sta		eventState					
	ldx		#$03					
	jsr		lfcea					
	jmp		lf48b					

lf44b
	lda		#$70					
	sta		weaponPosY					
	lsr								
	sta		eventState					
	bne		lf48b					
lf454
	bit		eventState					
	bvc		lf48b					
	ldx		#$03					
	jsr		lfcea					
	lda		weaponPosX					
	sec								
	sbc		#$04					
	cmp		indyPosX					
	bne		lf46a					
	lda		#$03					
	bne		lf481					
lf46a
	cmp		#$11					
	beq		lf472					
	cmp		#$84					
	bne		lf476					
lf472
	lda		#$0f					
	bne		lf481					
lf476
	lda		weaponPosY					
	sec								
	sbc		#$05					
	cmp		indyPosY					
	bne		lf487					
	lda		#$0c					
lf481
	eor		eventState					
	sta		eventState					
	bne		lf48b					
lf487
	cmp		#$4a					
	bcs		lf472					
lf48b
	lda		#$24					
	sta		bankSwitchJMPAddrLo					
	lda		#$d0					
	sta		bankSwitchJMPAddrHi					
lf493
	lda		#$ad					
	sta		loopCounter					
	lda		#$f8					
	sta		tempGfxHolder					
	lda		#$ff					
	sta		bankSwitchJMPOpcode					
	lda		#$4c					
	sta		bankSwitchJMPAddr					
	jmp.w	loopCounter					

lf4a6
	sta		WSYNC					
;---------------------------------------
	cpx		#$12					
	bcc		lf4d0					
	txa								
	sbc		indyPosY					
	bmi		lf4c9					
	cmp		#$14					
	bcs		lf4bd					
	lsr								
	tay								
	lda		IndyStandSprite,y					
	jmp		lf4c3					

lf4bd
	and		#$03					
	tay								
	lda		lf9fc,y					
lf4c3
	sta		GRP1					
	lda		indyPosY					
	sta		COLUP1					
lf4c9
	inx								
	cpx		#$90					
	bcs		lf4ea					
	bcc		lf4a6					
lf4d0
	bit		resetEnableFlag					
	bmi		lf4e5					
	txa								
	sbc		#$07					
	bmi		lf4e5					
	tay								
	lda		arkOfTheCovenantSprite,y					
	sta		GRP1					
	txa								
	adc		frameCount				
	asl								
	sta		COLUP1					
lf4e5
	inx								
	cpx		#$0f					
	bcc		lf4a6					
lf4ea
	sta		WSYNC					
;---------------------------------------
	cpx		#$20					
	bcs		lf511					
	bit		resetEnableFlag					
	bmi		lf504					
	txa								
	ldy		#$7e					
	and		#$0e					
	bne		lf4fd					
	ldy		#$ff					
lf4fd
	sty		GRP0					
	txa								
	eor		#$ff					
	sta		COLUP0					
lf504
	inx								
	cpx		#$1d					
	bcc		lf4ea					
	lda		#$00					
	sta		GRP0					
	sta		GRP1					
	beq		lf4a6					
lf511
	txa								
	sbc		#$90					
	cmp		#$0f					
	bcc		lf51b					
	jmp		lf1ea					

lf51b
	lsr								
	lsr								
	tay								
	lda		lfef0,y					
	sta		GRP0					
	stx		COLUP0					
	inx								
	bne		lf4ea

bank1Kernel:				
	lda		currentRoomId					
	asl								
	tax								
	lda		lfc89,x					
	pha								
	lda		lfc88,x					
	pha								
	rts								

lf535:
       lda    #$7f                    
       sta    $ce                     
       sta    $d0                     
       sta    $d2                     
       bne    lf59a                   

lf53f
       ldx    #$00                    
       ldy    #$01                    
       bit    CXP1FB                  
       bmi    lf55b                   
       bit    $b6                     
       bmi    lf55b                   
       lda    $82                     
       and    #$07                    
       bne    lf55e                   
       ldy    #$05                    
       lda    #$4c                    
       sta    $cd                     
       lda    #$23                    
       sta    $d3                     
lf55b:
       jsr    lf8b3                   
lf55e:
       lda    #$80                    
       sta    $93                     
       lda    $ce                     
       and    #$01                    
       ror    $c8                     
       rol                            
       tay                            
       ror                            
       rol    $c8                     
       lda    lfaea,y                 
       sta    $dd                     
       lda    #$fc    
       sta    $de                     
       lda    $8e                     
       bmi    lf59a                   
       ldx    #$50                    
       stx    $ca                     
       ldx    #$26                    
       stx    $d0                     
       lda    $b6                     
       bmi    lf59a                   
       bit    $9d                     
       bmi    lf59a                   
       and    #$07                    
       bne    lf592                   
       ldy    #$06                    
       sty    $b6                     
lf592:
       tax                            
       lda    lfcd2,x                 
       sta    $8e                     
       dec    $b6                     
lf59a:
       jmp    lf833                   

lf59d:
       lda    #$80                    
       sta    $93                     
       ldx    #$00                    
       bit    $9d                     
       bmi    lf5ab                   
       bit    $95                     
       bvc    lf5b7                   
lf5ab:
       ldy    #$05                    
       lda    #$55                    
       sta    $cd                     
       sta    $d3                     
       lda    #$01                    
       bne    lf5bb                   

lf5b7:
       ldy    #$01                    
       lda    #$03                    
lf5bb:
       and    $82                     
       bne    lf5ce                   
       jsr    lf8b3                   
       lda    $ce                     
       bpl    lf5ce                   
       cmp    #$a0                    
       bcc    lf5ce                   
       inc    $ce                     
       inc    $ce                     
lf5ce:
       bvc    lf5de                   
       lda    $ce                     
       cmp    #$51                    
       bcc    lf5de                   
       lda    $95                     
       sta    $99                     
       lda    #$00                    
       sta    $95                     
lf5de:
       lda    $c8                     
       cmp    $c9                     
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
       sta    $dd                     
       lda    $82                     
       and    #$7f                    
       bne    lf617                   
       lda    $ce                     
       cmp    #$4a                    
       bcs    lf617                   
       ldy    $98                     
       beq    lf617                   
       dey                            
       sty    $98                     
       ldy    #$8e                    
       adc    #$03                    
       sta    $d0                     
       cmp    $cf                     
       bcs    lf60f                   
       dey                            
lf60f:
       lda    $c8                     
       adc    #$04                    
       sta    $ca                     
       sty    $8e                     
lf617:
       ldy    #$7f                    
       lda    $8e                     
       bmi    lf61f                   
       sty    $d0                     
lf61f:
       lda    $d1                     
       cmp    #$52                    
       bcc    lf627                   
       sty    $d1                     
lf627:
       jmp    lf833                   

lf62a:
       ldx    #$3a                    
       stx    $e9                     
       ldx    #$85                    
       stx    $e3                     
       ldx    #$03                    
       stx    mesa_entered            
       bne    lf63a                   

lf638
       ldx    #$04                    
lf63a:
       lda    lfcd8,x                 
       and    $82                     
       bne    lf656                   
       ldy    $e5,x                   
       lda    #$08                    
       and    $df,x                   
       bne    lf65c                   
       dey                            
       cpy    #$14                    
       bcs    lf654                   
lf64e:
       lda    #$08                    
       eor    $df,x                   
       sta    $df,x                   
lf654:
       sty    $e5,x                   
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
       bit    $b4                     
       bpl    lf685                   
       bvc    lf66d                   
       dec    $c9                     
       bne    lf685                   
lf66d:
       lda    $82                     
       ror                            
       bcc    lf685                   
       lda    SWCHA                   
       sta    $92                     
       ror                            
       ror                            
       ror                            
       bcs    lf680                   
       dec    $c9                     
       bne    lf685                   
lf680:
       ror                            
       bcs    lf685                   
       inc    $c9                     
lf685:
       lda    #$02                    
       and    $b4                     
       bne    lf691                   
       sta    $8d                     
       lda    #$0b                    
       sta    $ce                     
lf691:
       ldx    $cf                     
       lda    $82                     
       bit    $b4                     
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
       stx    $cf                     
       bne    lf6a6                   

lf6af:
       lda    $c9                     
       cmp    #$64                    
       bcc    lf6bc                   
       rol    $b2                     
       clc                            
       ror    $b2                     
       bpl    lf6de                   
lf6bc:
       cmp    #$2c                    
       beq    lf6c6                   
       lda    #$7f                    
       sta    $d2                     
       bne    lf6de                   

lf6c6:
       bit    $b2                     
       bmi    lf6de                   
       lda    #$30                    
       sta    $cc                     
       ldy    #$00                    
       sty    $d2                     
       ldy    #$7f                    
       sty    $dc                     
       sty    $d5                     
       inc    $c9                     
       lda    #$80                    
       sta    $9d                     
lf6de:
       jmp    lf833                   

lf6e1:
       ldy    $df                     
       dey                            
       bne    lf6de                   
       lda    $af                     
       and    #$07                    
       bne    lf71d                   
       lda    #$40                    
       sta    $93                     
       lda    $83                     
       lsr                            
       lsr                            
       lsr                            
       lsr                            
       lsr                            
       tax                            
       ldy    lfcdc,x                 
       ldx    lfcaa,y                 
       sty    $84                     
       jsr    lf89d                   
       bcc    lf70a                   
lf705:
       inc    $df                     
       bne    lf6de                   


       .byte $00 ; |        | $f709 unused


lf70a:
       ldy    $84                     
       tya                            
       ora    $af                     
       sta    $af                     
       lda    lfca2,y                 
       sta    $ce                     
       lda    lfca6,y                 
       sta    $df                     
       bne    lf6de                   

lf71d:
       cmp    #$04                    
       bcs    lf705                   
       rol    $af                     
       sec                            
       ror    $af                     
       bmi    lf705                   

lf728: ;map room stuff...
       ldy    #$00                    
       sty    $d2                     
       ldy    #$7f                    
       sty    $dc                     
       sty    $d5                     
       lda    #$71                    
       sta    $cc                     
       ldy    #$4f                    
       lda    #$3a                    
       cmp    $cf                     
       bne    lf74a                   
       lda    selectedInventoryId          
       cmp    #$07                    
       beq    lf74c                   
       lda    #$5e                    
       cmp    $c9                     
       beq    lf74c                   
lf74a:
       ldy    #$0d                    
lf74c:
       sty    $df                     
       lda    $83                     
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
       sta    $ce                     
       bit    $b3                     
       bpl    lf78b                   
       cmp    #$08                    
       bcs    lf787                   
       ldx    selectedInventoryId          
       cpx    #$0e                    
       bne    lf787                   
       stx    ark_found               
       lda    #$04                    
       and    $82                     
       bne    lf787                   
       lda    $8c                     
       and    #$0f                    
       tax                            
       lda    lfac2,x                 
       sta    $cb                     
       lda    lfad2,x                 
       bne    lf789                   

lf787:
       lda    #$70                    
lf789:
       sta    $d1                     
lf78b:
       rol    $b3                     
       lda    #$3a                    
       cmp    $cf                     
       bne    lf7a2                   
       cpy    #$4f                    
       beq    lf79d                   
       lda    #$5e                    
       cmp    $c9                     
       bne    lf7a2                   
lf79d:
       sec                            
       ror    $b3                     
       bmi    lf7a5                   
lf7a2:
       clc                            
       ror    $b3                     
lf7a5:
       jmp    lf833                   

lf7a8:
       lda    #$08                    
       and    $c7                     
       bne    lf7c0                   
       lda    #$4c                    
       sta    $cc                     
       lda    #$2a                    
       sta    $d2                     
       lda    #$ba                    
       sta    $d6                     
       lda    #$fa                    
       sta    $d7                     
       bne    lf7c4                   

lf7c0:
       lda    #$f0                    
       sta    $d2                     
lf7c4:
       lda    $b5                     
       and    #$0f                    
       beq    lf833                   
       sta    $dc                     
       ldy    #$14                    
       sty    $ce                     
       ldy    #$3b                    
       sty    $e0                     
       iny                            
       sty    $d4                     
       lda    #$c1                    
       sec                            
       sbc    $dc                     
       sta    $dd                     
       bne    lf833                   

lf7e0:
       lda    $82                     
       and    #$18                    
       adc    #$e0                    
       sta    $dd                     
       lda    $82                     
       and    #$07                    
       bne    lf80f                   
       ldx    #$00                    
       ldy    #$01                    
       lda    $cf                     
       cmp    #$3a                    
       bcc    lf80c                   
       lda    $c9                     
       cmp    #$2b                    
       bcc    lf802                   
       cmp    #$6d                    
       bcc    lf80c                   
lf802:
       ldy    #$05                    
       lda    #$4c                    
       sta    $cd                     
       lda    #$0b                    
       sta    $d3                     
lf80c:
       jsr    lf8b3                   
lf80f:
       ldx    #$4e                    
       cpx    $cf                     
       bne    lf833                   
       ldx    $c9                     
       cpx    #$76                    
       beq    lf81f                   
       cpx    #$14                    
       bne    lf833                   
lf81f:
       lda    SWCHA                   
       and    #$0f                    
       cmp    #$0d                    
       bne    lf833                   
       sta    escape_hatch_used       
       lda    #$4c                    
       sta    $c9                     
       ror    $b5                     
       sec                            
       rol    $b5                     
lf833
       lda    #<setupScreenAndObj                 
       sta    $88                     
       lda    #>setupScreenAndObj                 
       sta    $89                     
       jmp    lf493                   

lf83e
       lda    #$40                    
       sta    $93                     
       bne    lf833                   

draw_field
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
	lda		lfae2+1,x				
	pha								
	lda		lfae2,x					
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
       and    $c6                     
       beq    lf8ac                   
       sec                            
lf8ac
       rts                            

lf8ad									;called dynamically 
       and    $c7                     ;and c7
       bne    lf8ac                   ;return if 0
       clc                            ;if not, clear carry
       rts                            ;return 



lf8b3
	cpy		#$01					
	bne		lf8bb					
	lda		indyPosY					
	bmi		lf8cc					
lf8bb
	lda		objectPosY,x				 
	cmp.wy	objectPosY,y				 
	bne		lf8c6					
	cpy		#$05					
	bcs		lf8ce					
lf8c6
	bcs		lf8cc					
	inc		objectPosY,x				 
	bne		lf8ce					
lf8cc
	dec		objectPosY,x				 
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
	lda		objectPosY,x				 
	cmp		#$53					
	bcc		lf8f1					
lf8e7
	rol		arkLocationRegionId,x				
	clc								
	ror		arkLocationRegionId,x				
	lda		#$78					
	sta		objectPosY,x				 
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

lf9fc
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
	



	;.byte	$f7,$f7,$f7,$f7,$f7,$37,$37,$00 ; $faba (*)
lfac2
	.byte	$63,$62,$6b,$5b,$6a,$5f,$5a,$5a ; $fac2 (*)
	.byte	$6b,$5e,$67,$5a,$62,$6b,$5a,$6b ; $faca (*)
lfad2
	.byte	$22,$13,$13,$18,$18,$1e,$21,$13 ; $fad2 (*)
	.byte	$21,$26,$26,$2b,$2a,$2b,$31,$31 ; $fada (*)

lfae2:
	.word lf0b5-1 ; $fae2/3
	.word lf003-1 ; $fae4/5
	.word lf140-1 ; $fae6/7
	.word lf4a6-1 ; $fae8/9

lfaea: ;tarantula animation table
	.byte <spider_frame_1_gfx ; $faea
	.byte <spider_frame_2_gfx ; $faeb
	.byte <spider_frame_3_gfx ; $faec
	.byte <spider_frame_4_gfx ; $faed
lfaee
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
	.byte	$71 ; | ###		#|			$fb08 (g)
	.byte	$41 ; | #		#|			$fb09 (g)
	.byte	$41 ; | #		#|			$fb0a (g)
	.byte	$71 ; | ###		#|			$fb0b (g)
	.byte	$11 ; |		#		#|			$fb0c (g)
	.byte	$51 ; | # #		#|			$fb0d (g)
	.byte	$70 ; | ###	|			$fb0e (g)
	.byte	$00 ; |		|			$fb0f (g)

inventoryFluteSprite
	.byte	$00 ; |		|			$fb10 (g)
	.byte	$01 ; |			#|			$fb11 (g)
	.byte	$3f ; |	 ######|			$fb12(g)
	.byte	$6b ; | ## # ##|			$fb12 (g)
	.byte	$7f ; | #######|			$fb13 (g)
	.byte	$01 ; |			#|			$fb14 (g)
	.byte	$00 ; |		|			$fb15 (g)
	.byte	$00 ; |		|			$fb16 (g)

inventoryParachuteSprite
	.byte	$77 ; | ### ###|			$fb17 (g)
	.byte	$77 ; | ### ###|			$fb18 (g)
	.byte	$77 ; | ### ###|			$fb19 (g)
	.byte	$00 ; |		|			$fb1a (g)
	.byte	$00 ; |		|			$fb1b (g)
	.byte	$77 ; | ### ###|			$fb1c (g)
	.byte	$77 ; | ### ###|			$fb1d (g)
	.byte	$77 ; | ### ###|			$fb1e (g)

inventoryCoinsSprite
	.byte	$1c ; |		###  |			$fb1f (g)
	.byte	$2a ; |	 # # # |			$fb20 (g)
	.byte	$55 ; | # # # #|			$fb21 (g)
	.byte	$2a ; |	 # # # |			$fb22 (g)
	.byte	$55 ; | # # # #|			$fb23 (g)
	.byte	$2a ; |	 # # # |			$fb24 (g)
	.byte	$1c ; |		###  |			$fb25 (g)
	.byte	$3e ; |	 ##### |			$fb26 (g)

marketplaceGrenadeSprite
	.byte	$3a ; |	 ### # |			$fb27 (g)
	.byte	$01 ; |			#|			$fb28 (g)
	.byte	$7d ; | ##### #|			$fb29 (g)
	.byte	$01 ; |			#|			$fb2a (g)
	.byte	$39 ; |	 ###  #|			$fb2b (g)
	.byte	$02 ; |		 # |			$fb2c (g)
	.byte	$3c ; |	 ####  |			$fb2d (g)
	.byte	$30 ; |	 ##	|			$fb2e (g)

blackMarketGrenadeSprite
	.byte	$2e ; |	 # ### |			$fb2f (g)
	.byte	$40 ; | #	|			$fb30 (g)
	.byte	$5f ; | # #####|			$fb31 (g)
	.byte	$40 ; | #	|			$fb32 (g)
	.byte	$4e ; | #  ### |			$fb33 (g)
	.byte	$20 ; |	 #	|			$fb34 (g)
	.byte	$1e ; |		#### |			$fb35 (g)
	.byte	$06 ; |		## |			$fb36 (g)

inventoryKeySprite
	.byte	$00 ; |		|			$fb37 (g)
	.byte	$25 ; |	 #	# #|			$fb38 (g)
	.byte	$52 ; | # #	 # |			$fb39 (g)
	.byte	$7f ; | #######|			$fb3a (g)
	.byte	$50 ; | # #	|			$fb3b (g)
	.byte	$20 ; |	 #	|			$fb3c (g)
	.byte	$00 ; |		|			$fb3d (g)
	.byte	$00 ; |		|			$fb3e (g)

arkOfTheCovenantSprite
	.byte	$ff ; |########|			$fb40 (g)
	.byte	$66 ; | ##	## |			$fb41 (g)
	.byte	$24 ; |	 #	#  |			$fb42 (g)
	.byte	$24 ; |	 #	#  |			$fb43 (g)
	.byte	$66 ; | ##	## |			$fb44 (g)
	.byte	$e7 ; |###	###|			$fb45 (g)
	.byte	$c3 ; |##	 ##|			$fb46 (g)
	.byte	$e7 ; |###	###|			$fb47 (g)

copyrightGfx1: ;copyright2
	.byte	$17 ; |		# ###|			$fb48 (g)
	.byte	$15 ; |		# # #|			$fb49 (g)
	.byte	$15 ; |		# # #|			$fb4a (g)
	.byte	$77 ; | ### ###|			$fb4b (g)
	.byte	$55 ; | # # # #|			$fb4c (g)
	.byte	$55 ; | # # # #|			$fb4d (g)
	.byte	$77 ; | ### ###|			$fb4e (g)
	.byte	$00 ; |		|			$fb4f (g)

inventoryWhipSprite
	.byte	$21 ; |	 #		#|			$fb50 (g)
	.byte	$11 ; |		#		#|			$fb51 (g)
	.byte	$09 ; |	#  #|			$fb52 (g)
	.byte	$11 ; |		#		#|			$fb53 (g)
	.byte	$22 ; |	 #	 # |			$fb54 (g)
	.byte	$44 ; | #	#  |			$fb55 (g)
	.byte	$28 ; |	 # #   |			$fb56 (g)
	.byte	$10 ; |		#	|			$fb57 (g)

inventoryShovelSprite
	.byte	$01 ; |			#|			$fb58 (g)
	.byte	$03 ; |		 ##|			$fb59 (g)
	.byte	$07 ; |		###|			$fb5a (g)
	.byte	$0f ; |	####|			$fb5b (g)
	.byte	$06 ; |		## |			$fb5c (g)
	.byte	$0c ; |	##  |			$fb5d (g)
	.byte	$18 ; |		##   |			$fb5e (g)
	.byte	$3c ; |	 ####  |			$fb5f (g)

copyrightGfx0
	.byte	$79 ; | ####  #|			$fb60 (g)
	.byte	$85 ; |#	# #|			$fb61 (g)
	.byte	$b5 ; |# ## # #|			$fb62 (g)
	.byte	$a5 ; |# #	# #|			$fb63 (g)
	.byte	$b5 ; |# ## # #|			$fb64 (g)
	.byte	$85 ; |#	# #|			$fb65 (g)
	.byte	$79 ; | ####  #|			$fb66 (g)
	.byte	$00 ; |		|			$fb67 (g)

inventoryRevolverSprite
	.byte	$00 ; |		|			$fb68 (g)
	.byte	$60 ; | ##	|			$fb69 (g)
	.byte	$60 ; | ##	|			$fb6a (g)
	.byte	$78 ; | ####   |			$fb6b (g)
	.byte	$68 ; | ## #   |			$fb6c (g)
	.byte	$3f ; |	 ######|			$fb6d (g)
	.byte	$5f ; | # #####|			$fb6e (g)
	.byte	$00 ; |		|			$fb6f (g)

inventoryHeadOfRaSprite	
	.byte	$08 ; |	#   |			$fb70 (g)
	.byte	$1c ; |		###  |			$fb71 (g)
	.byte	$22 ; |	 #	 # |			$fb72 (g)
	.byte	$49 ; | #  #  #|			$fb73 (g)
	.byte	$6b ; | ## # ##|			$fb74 (g)
	.byte	$00 ; |		|			$fb75 (g)
	.byte	$1c ; |		###  |			$fb76 (g)
	.byte	$08 ; |	#   |			$fb77 (g)

inventoryTimepieceSprite ; unopen pocket watch
	.byte	$7f ; | #######|			$fb78 (g)
	.byte	$5d ; | # ### #|			$fb79 (g)
	.byte	$77 ; | ### ###|			$fb7a (g)
	.byte	$77 ; | ### ###|			$fb7b (g)
	.byte	$5d ; | # ### #|			$fb7c (g)
	.byte	$7f ; | #######|			$fb7d (g)
	.byte	$08 ; |	#   |			$fb7e (g)
	.byte	$1c ; |		###  |			$fb7f (g)

inventoryAnkhSprite
	.byte	$3e ; |	 ##### |			$fb80 (g)
	.byte	$1c ; |		###  |			$fb81 (g)
	.byte	$49 ; | #  #  #|			$fb82 (g)
	.byte	$7f ; | #######|			$fb83 (g)
	.byte	$49 ; | #  #  #|			$fb84 (g)
	.byte	$1c ; |		###  |			$fb85 (g)
	.byte	$36 ; |	 ## ## |			$fb86 (g)
	.byte	$1c ; |		###  |			$fb87 (g)

inventoryChaiSprite
	.byte	$16 ; |		# ## |			$fb88 (g)
	.byte	$0b ; |	# ##|			$fb89 (g)
	.byte	$0d ; |	## #|			$fb8a (g)
	.byte	$05 ; |		# #|			$fb8b (g)
	.byte	$17 ; |		# ###|			$fb8c (g)
	.byte	$36 ; |	 ## ## |			$fb8d (g)
	.byte	$64 ; | ##	#  |			$fb8e (g)
	.byte	$04 ; |		#  |			$fb8f (g)

inventoryHourGlassSprite
	.byte	$77 ; | ### ###|			$fb90 (g)
	.byte	$36 ; |	 ## ## |			$fb91 (g)
	.byte	$14 ; |		# #  |			$fb92 (g)
	.byte	$22 ; |	 #	 # |			$fb93 (g)
	.byte	$22 ; |	 #	 # |			$fb94 (g)
	.byte	$14 ; |		# #  |			$fb95 (g)
	.byte	$36 ; |	 ## ## |			$fb96 (g)
	.byte	$77 ; | ### ###|			$fb97 (g)

inventory12_00: ;timepiece bitmaps...
	.byte	$3e ; |	 ##### |			$fb98 (g)
	.byte	$41 ; | #		#|			$fb99 (g)
	.byte	$41 ; | #		#|			$fb9a (g)
	.byte	$49 ; | #  #  #|			$fb9b (g)
	.byte	$49 ; | #  #  #|			$fb9c (g)
	.byte	$49 ; | #  #  #|			$fb9d (g)
	.byte	$3e ; |	 ##### |			$fb9e (g)
	.byte	$1c ; |		###  |			$fb9f (g)

inventory01_00
	.byte	$3e ; |	 ##### |			$fba0 (g)
	.byte	$41 ; | #		#|			$fba1 (g)
	.byte	$41 ; | #		#|			$fba2 (g)
	.byte	$49 ; | #  #  #|			$fba3 (g)
	.byte	$45 ; | #	# #|			$fba4 (g)
	.byte	$43 ; | #	 ##|			$fba5 (g)
	.byte	$3e ; |	 ##### |			$fba6 (g)
	.byte	$1c ; |		###  |			$fba7 (g)

inventory03_00
	.byte	$3e ; |	 ##### |			$fba8 (g)
	.byte	$41 ; | #		#|			$fba9 (g)
	.byte	$41 ; | #		#|			$fbaa (g)
	.byte	$4f ; | #  ####|			$fbab (g)
	.byte	$41 ; | #		#|			$fbac (g)
	.byte	$41 ; | #		#|			$fbad (g)
	.byte	$3e ; |	 ##### |			$fbae (g)
	.byte	$1c ; |		###  |			$fbaf (g)

inventory05_00
	.byte	$3e ; |	 ##### |			$fbb0 (g)
	.byte	$43 ; | #	 ##|			$fbb1 (g)
	.byte	$45 ; | #	# #|			$fbb2 (g)
	.byte	$49 ; | #  #  #|			$fbb3 (g)
	.byte	$41 ; | #		#|			$fbb4 (g)
	.byte	$41 ; | #		#|			$fbb5 (g)
	.byte	$3e ; |	 ##### |			$fbb6 (g)
	.byte	$1c ; |		###  |			$fbb7 (g)

inventory06_00
	.byte	$3e ; |	 ##### |			$fbb8 (g)
	.byte	$49 ; | #  #  #|			$fbb9 (g)
	.byte	$49 ; | #  #  #|			$fbba (g)
	.byte	$49 ; | #  #  #|			$fbbb (g)
	.byte	$41 ; | #		#|			$fbbc (g)
	.byte	$41 ; | #		#|			$fbbd (g)
	.byte	$3e ; |	 ##### |			$fbbe (g)
	.byte	$1c ; |		###  |			$fbbf (g)

inventory07_00
	.byte	$3e ; |	 ##### |			$fbc0 (g)
	.byte	$61 ; | ##		#|			$fbc1 (g)
	.byte	$51 ; | # #		#|			$fbc2 (g)
	.byte	$49 ; | #  #  #|			$fbc3 (g)
	.byte	$41 ; | #		#|			$fbc4 (g)
	.byte	$41 ; | #		#|			$fbc5 (g)
	.byte	$3e ; |	 ##### |			$fbc6 (g)
	.byte	$1c ; |		###  |			$fbc7 (g)

inventory09_00
	.byte	$3e ; |	 ##### |			$fbc8 (g)
	.byte	$41 ; | #		#|			$fbc9 (g)
	.byte	$41 ; | #		#|			$fbca (g)
	.byte	$79 ; | ####  #|			$fbcb (g)
	.byte	$41 ; | #		#|			$fbcc (g)
	.byte	$41 ; | #		#|			$fbcd (g)
	.byte	$3e ; |	 ##### |			$fbce (g)
	.byte	$1c ; |		###  |			$fbcf (g)

inventory11_00
	.byte	$3e ; |	 ##### |			$fbd0 (g)
	.byte	$41 ; | #		#|			$fbd1 (g)
	.byte	$41 ; | #		#|			$fbd2 (g)
	.byte	$49 ; | #  #  #|			$fbd3 (g)
	.byte	$51 ; | # #		#|			$fbd4 (g)
	.byte	$61 ; | ##		#|			$fbd5 (g)
	.byte	$3e ; |	 ##### |			$fbd6 (g)
	.byte	$1c ; |		###  |			$fbd7 (g)

copyrightGfx2 ;copyright2
	.byte	$49 ; | #  #  #|			$fbd8 (g)
	.byte	$49 ; | #  #  #|			$fbd9 (g)
	.byte	$49 ; | #  #  #|			$fbda (g)
	.byte	$c9 ; |##  #  #|			$fbdb (g)
	.byte	$49 ; | #  #  #|			$fbdc (g)
	.byte	$49 ; | #  #  #|			$fbdd (g)
	.byte	$be ; |# ##### |			$fbde (g)
	.byte	$00 ; |		|			$fbdf (g)

copyrightGfx4: ;copyright5
	.byte	$55 ; | # # # #|			$fbe0 (g)
	.byte	$55 ; | # # # #|			$fbe1 (g)
	.byte	$55 ; | # # # #|			$fbe2 (g)
	.byte	$d9 ; |## ##  #|			$fbe3 (g)
	.byte	$55 ; | # # # #|			$fbe4 (g)
	.byte	$55 ; | # # # #|			$fbe5 (g)
	.byte	$99 ; |#  ##  #|			$fbe6 (g)
	.byte	$00 ; |		|			$fbe7 (g)

;------------------------------------------------------------
; OverscanSpecialSoundEffectTable
;
; Frequency data for the "Main Theme" (Raiders March).
; Played when channel control is $9C (Pure Tone).
; Indexed by `soundEffectTimer` (counts down from $17).
;

lfbe8
	.byte	$14								; $fbe8 (d)
	.byte	$14,$14,$0f,$10,$12,$0b,$0b,$0b ; $fbe9 (*)
	.byte	$10,$12,$14,$17,$17,$17,$17		; $fbf1 (*)
	.byte	$18,$1b,$0f,$0f,$0f,$14,$17,$18 ; $fbf8 (d)

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

lfc40
       .byte $00 ; |        | $fc40
       .byte $10 ; |   x    | $fc41
       .byte $20 ; |  x     | $fc42
       .byte $30 ; |  xx    | $fc43
       .byte $7c ; | xxxxx  | $fc44
       .byte $0f ; |    xxxx| $fc45
       .byte $7c ; | xxxxx  | $fc46
       .byte $00 ; |        | $fc47
       .byte $0a ; |    x x | $fc48
       .byte $02 ; |      x | $fc49
       .byte $04 ; |     x  | $fc4a
       .byte $06 ; |     xx | $fc4b
       .byte $08 ; |    x   | $fc4c
       .byte $0a ; |    x x | $fc4d
       .byte $08 ; |    x   | $fc4e
       .byte $06 ; |     xx | $fc4f
       .byte $98 ; |x  xx   | $fc50
       .byte $98 ; |x  xx   | $fc51
       .byte $9e ; |x  xxxx | $fc52
       .byte $9e ; |x  xxxx | $fc53
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


lfc88
       .byte $e0             ; $fc88 (*)
lfc89 
       .byte $f6             ; $fc89 (*)


       .word lf833-1 ; $fc8a/b
       .word lf83e-1 ; $fc8c/d
       .word lf6af-1 ; $fc8e/f
       .word lf728-1 ; $fc90/1
       .word lf663-1 ; $fc92/3
       .word lf7a8-1 ; $fc94/5
       .word lf53f-1 ; $fc96/7
       .word lf7e0-1 ; $fc98/9
       .word lf535-1 ; $fc9a/b
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





spider_frame_1_gfx
	.byte	$54 ; | # # #  |			$fcae (g)
	.byte	$fc ; |######  |			$fcaf (g)
	.byte	$5f ; | # #####|			$fcb0 (g)
	.byte	$fe ; |####### |			$fcb1 (g)
	.byte	$7f ; | #######|			$fcb2 (g)
	.byte	$fa ; |##### # |			$fcb3 (g)
	.byte	$3f ; |	 ######|			$fcb4 (g)
	.byte	$2a ; |	 # # # |			$fcb5 (g)
	.byte	$00 ; |		|			$fcb6 (g)

spider_frame_3_gfx
	.byte	$54 ; | # # #  |			$fcb7 (g)
	.byte	$5f ; | # #####|			$fcb8 (g)
	.byte	$fc ; |######  |			$fcb9 (g)
	.byte	$7f ; | #######|			$fcba (g)
	.byte	$fe ; |####### |			$fcbb (g)
	.byte	$3f ; |	 ######|			$fcbc (g)
	.byte	$fa ; |##### # |			$fcbd (g)
	.byte	$2a ; |	 # # # |			$fcbe (g)
	.byte	$00 ; |		|			$fcbf (g)

spider_frame_2_gfx
	.byte	$2a ; |	 # # # |			$fcc0 (g)
	.byte	$fa ; |##### # |			$fcc1 (g)
	.byte	$3f ; |	 ######|			$fcc2 (g)
	.byte	$fe ; |####### |			$fcc3 (g)
	.byte	$7f ; | #######|			$fcc4 (g)
	.byte	$fa ; |##### # |			$fcc5 (g)
	.byte	$5f ; | # #####|			$fcc6 (g)
	.byte	$54 ; | # # #  |			$fcc7 (g)
	.byte	$00 ; |		|			$fcc8 (g)

spider_frame_4_gfx
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

lfcea
	ror								
	bcs		lfcef					
	dec		objectPosY,x				 
lfcef
	ror								
	bcs		lfcf4					
	inc		objectPosY,x				 
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
	
	
	
	.byte   $07,$07,$07,$03,$03,$03,$01 ; $fdff (*)
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

lfef0
	.byte	$3c ; |	 ####  |			$fef0 (g)
	.byte	$3c ; |	 ####  |			$fef1 (g)
	.byte	$7e ; | ###### |			$fef2 (g)
	.byte	$ff ; |########|			$fef3 (g)

lfef4
	lda		arkLocationRegionId,x				
	bmi		lfef9					
	rts								

lfef9
	jsr		lfcea					
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





InventoryIndexHorizValues
	.byte HMOVE_R6 | 4
	.byte HMOVE_L1 | 5
	.byte HMOVE_R7 | 5
	.byte HMOVE_0  | 6
	.byte HMOVE_R8 | 6
	.byte HMOVE_R1 | 7

lfff8
	.byte	$00								; $fff8 (d)
	.byte	$00
	
	;Interrupt Vectors
	.word BANK1Start	; NMI
	.word BANK1Start	; RESET
	.word BANK1Start	; IRQ/BRK