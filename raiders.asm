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


;============================================================================
; Z P - V A R I A B L E S
;============================================================================

zero_page		= $00
scan_line		= $80
currentRoomId		= $81
frame_counter	= $82
secondsTimer		= $83
ram_84			= $84; (c)
ram_85			= $85; (c)
ram_86			= $86; (c)
ram_87			= $87; (c)
ram_88			= $88; (c)
ram_89			= $89; (c)
ram_8a			= $8a
arkDigRegionId			= $8b
arkLocationRegionId			= $8c
ram_8d			= $8d
ram_8e			= $8e
weaponStatus			= $8f
ram_90			= $90
moveDirection			= $91
indyDir		= $92
screenEventState			= $93
room_pf_cfg		= $94
pickupStatusFlags			= $95
diggingState			= $96
digAttemptCounter			= $97
ram_98			= $98
ram_99			= $99
ram_9a			= $9a
ram_9b			= $9b
resetEnableFlag			= $9c
majorEventFlag			= $9d
score			= $9e
lives_left		= $9f
num_bullets		= $a0
eventTimer			= $a1
ram_a2			= $a2
ram_a3			= $a3
diamond_h		= $a4
grenade_used	= $a5
escape_hatch_used		= $a6
shovel_used		= $a7
parachute_used	= $a8
ankh_used		= $a9
yar_found		= $aa
ark_found		= $ab
thiefShot		= $ac
mesa_entered	= $ad
unknown_action	= $ae
treasureIndex			= $af

entranceRoomState			= $b1
blackMarketState			= $b2
mapRoomState			= $b3
mesaSideState			= $b4
ram_b5			= $b5
spiderRoomState			= $b6
inv_slot_lo	= $b7
inv_slot_hi	= $b8
inv_slot2_lo	= $b9
inv_slot2_hi	= $ba
inv_slot3_lo	= $bb
inv_slot3_hi	= $bc
inv_slot4_lo	= $bd
inv_slot4_hi	= $be
inv_slot5_lo	= $bf
inv_slot5_hi	= $c0
inv_slot6_lo	= $c1
inv_slot6_hi	= $c2
cursor_pos		= $c3
ram_c4			= $c4
selectedInventoryId	= $c5
ram_c6			= $c6
ram_c7			= $c7
ObjectPosX			= $c8
indyPosX			= $c9
ram_ca			= $ca
weaponHorizPos			= $cb
ram_cc			= $cc

objectPosY			= $ce
indyPosY			= $cf
ram_d0			= $d0
weaponVertPos			= $d1	;Weapon vertical position (Whip or Bullet)
objPosY			= $d2

objectState			= $d4
ram_d5			= $d5
timepieceGfxPtrs			= $d6
ram_d7			= $d7
ram_d8			= $d8
indy_anim		= $d9
ram_da			= $da
indy_h			= $db
p0SpriteHeight			= $dc
emy_anim		= $dd
ram_de			= $de
objState			= $df
ram_e0			= $e0
PF1_data		= $e1
ram_e2			= $e2
PF2_data		= $e3
ram_e4			= $e4
dungeonGfxData			= $e5
dungeonBlock1			= $e6
dungeonBlock2			= $e7
dungeonBlock3			= $e8
dungeonBlock4			= $e9
dungeonBlock5			= $ea
savedThiefPosY			= $eb
savedIndyPosY			= $ec
savedIndyPosX			= $ed
ram_ee			= $ee
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
H_INVENTORY_SPRITES		= 8

;--------------------
;objects
;---------------------

key_obj = $07

;--------------------
; Inventory Sprite Ids
;--------------------
ID_INVENTORY_EMPTY		= (emptySprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_FLUTE		= (inventoryFluteSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_PARACHUTE	= (inventoryParachuteSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_COINS		= (inventoryCoinsSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_MARKETPLACE_GRENADE	= (marketplaceGrenadeSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_BLACK_MARKET_GRENADE = (blackMarketGrenadeSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_KEY		= (inventoryKeySprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_WHIP		= (inventoryWhipSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_SHOVEL		= (inventoryShovelSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_REVOLVER	= (inventoryRevolverSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_HEAD_OF_RA = (inventoryHeadOfRaSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_TIME_PIECE = (inventoryTimepieceSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_ANKH		= (inventoryAnkhSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_CHAI		= (inventoryChaiSprite - inventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_HOUR_GLASS = (inventoryHourGlassSprite - inventorySprites) / H_INVENTORY_SPRITES


;--------------------
; Room State Values
;--------------------

GRENADE_OPENING_IN_WALL = %00000010

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

XMAX					= 160

BULLET_OR_WHIP_ACTIVE 	= %10000000

PENALTY_SHOOTING_THIEF	= 4


;***********************************************************
;	bank 0 / 0..1
;***********************************************************

	seg		code
	org		$0000
	rorg	BANK0_REORG

;note: 1st bank's vector points right at the cold start routine
	lda	BANK0STROBE				;trigger 1st bank

coldStart
	jmp		gameStart				;cold start


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; setObjPosX
; set object horizontal position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setObjPosX
	ldx		#<RESBL - RESP0					
.moveObjectLoop
	sta		WSYNC					; wait for next scan line
	lda		ObjectPosX,x			; get object's horizontal position
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


	lda		weaponVertPos			; Load Weapon Vertical Position.				
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
	sta		weaponVertPos				; Invalidates weapon Y (effectively removing it).			
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
	lda		weaponVertPos				; get bullet or whip vertical position						
	sbc		objectState				; subtract dungeon wall height						
	lsr									; divide by 4 total
	lsr								
	beq		handleLeftWall			; if zero, left wall hit
	tax								
	ldy		weaponHorizPos			; get weapon horizontal position						
	cpy		#$12						
	bcc		clearWeaponState			; branch if too far left			
	cpy		#$8d						
	bcs		clearWeaponState			; branch if too far right			
	lda		#$00						
	sta		dungeonGfxData,x			; zero out dungeon gfx data for wall hit			
	beq		clearWeaponState			; unconditional branch			

handleLeftWall:
	lda		weaponHorizPos			; get bullet or whip horizontal position						
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
	and		dungeonGfxData			; Apply the mask to the current
										; dungeon graphic state 
										; (clear bits to "erase" part of it)			
	sta		dungeonGfxData			; Store the updated graphic
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
	sty    weaponVertPos				; set vertical position out of range						
weaponObjHit:
	bit		CXM1FB						; check if snake hit with bullet or whip
	bvc		handleIndyVsObjHit		; branch if object not hit				
	bit		screenEventState									
	bvc		handleIndyVsObjHit						
	lda		#$5a							; set object y position high byte
	sta		objPosY					; move offscreen (?)						
	sta		p0SpriteHeight							
	sta    weaponStatus				; clear BULLET_OR_WHIP_ACTIVE status					
	sta    weaponVertPos						

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
	jmp		InitScreenState 			; Finish frame cleanly and transition visually			

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
	stx		dungeonGfxData				; restore dungeon graphics	
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
	ldx		#<indyPosY - objectPosY ; X = offset to Indy in object array						
	jsr		getMoveDir					
setIndyToNormalMove:
	lda		#$05						
	sta		$a2						
	bne		roomIdleHandler						

indyEnterHole:
	rol		$8a						
	sec								
	bcs		ld372						

ld36f:
	rol		$8a						
	clc								
ld372:
	ror		$8a						

roomIdleHandler:
	bit		CXM0P|$30				
	bpl		ld396					
	ldx		currentRoomId					
	cpx		#ID_SPIDER_ROOM					
	beq		ld386					
	bcc		ld396					
	lda		#$80					
	sta		majorEventFlag					
	bne		ld390					
ld386
	rol		ram_8a					
	sec								
	ror		ram_8a					
	rol		spiderRoomState					
	sec								
	ror		spiderRoomState					
ld390
	lda		#$7f					
	sta		ram_8e					
	sta		ram_d0					
ld396
	bit		ram_9a					
	bpl		InitScreenState 					
	bvs		ld3a8					
	lda		secondsTimer					 
	cmp		ram_9b					
	bne		InitScreenState 					
	lda		#$a0					
	sta		weaponVertPos					
	sta		majorEventFlag					
ld3a8
	lsr		ram_9a					
	bcc		ld3d4					
	lda		#$02					
	sta		grenade_used					
	ora		entranceRoomState					
	sta		entranceRoomState					
	ldx		#ID_ENTRANCE_ROOM					
	cpx		currentRoomId					
	bne		ld3bd					
	jsr		InitializeScreenState					
ld3bd
	lda		ram_b5					
	and		#$0f					
	beq		ld3d4					
	lda		ram_b5					
	and		#$f0					
	ora		#$01					
	sta		ram_b5					
	ldx		#ID_ENTRANCE_ROOM					
	cpx		currentRoomId					
	bne		ld3d4					
	jsr		InitializeScreenState					
ld3d4
	sec								
	jsr		removeItem					
InitScreenState 
	lda		INTIM					
	bne		InitScreenState 					
ld3dd
	lda		#$02					
	sta		WSYNC					
;---------------------------------------
	sta		VSYNC					
	lda		#$50					
	cmp		weaponVertPos					
	bcs		ld3eb					
	sta		weaponHorizPos					
ld3eb
	inc		frame_counter			;up the frame counter by 1
	lda		#$3f					;
	and		frame_counter			;every 63 frames (?)
	bne		ld3fb					;
	inc		secondsTimer				;increse the time of day
	lda		eventTimer					
	bpl		ld3fb					
	dec		eventTimer					
ld3fb
	sta		WSYNC					
;---------------------------------------
	bit		resetEnableFlag					
	bpl		frame_start						
	ror		SWCHB					
	bcs		frame_start						
	jmp		gameStart					 

frame_start
	sta		WSYNC					;wait for first sync
;---------------------------------------
	lda		#$00					;load a for VSYNC pause
	ldx		#$2c					;load timer for
	sta		WSYNC					
;---------------------------------------
	sta		VSYNC					
	stx		TIM64T					
	ldx		majorEventFlag					
	inx								
	bne		ld42a					
	stx		majorEventFlag					
	jsr		getFinalScore				; set score to minimum
	lda		#ID_ARK_ROOM				; set ark title screen 
	sta		currentRoomId				; to the current room
	jsr		InitializeScreenState					
ld427
	jmp		ld80d					

ld42a
	lda		currentRoomId				; get teh room number
	cmp		#ID_ARK_ROOM				; are we in the ark room? 
	bne		ld482					
	lda		#$9c					
	sta		ram_a3					
	ldy		yar_found				; check if yar was found
	beq		ld44a					; if not hold for button(?)
	bit		resetEnableFlag					
	bmi		ld44a					
	ldx		#>dev_name_1_gfx		; get programmer 1 initials...
	stx		inv_slot_hi				; put in slot 1
	stx		inv_slot2_hi			
	lda		#<dev_name_1_gfx		
	sta		inv_slot_lo				
	lda		#<dev_name_2_gfx		; get programmer 2 initials...
	sta		inv_slot2_lo			; put in slot 2
ld44a
	ldy		indyPosY					
	cpy		#$7c					
	bcs		ld465					
	cpy		score				
	bcc		ld45b					
	bit		INPT5|$30				
	bmi		ld427					
	jmp		gameStart					 

ld45b
	lda		frame_counter				
	ror								
	bcc		ld427					
	iny								
	sty		indyPosY					
	bne		ld427					
ld465
	bit		resetEnableFlag					
	bmi		ld46d					
	lda		#$0e					
	sta		ram_a2					
ld46d
	lda		#$80					
	sta		resetEnableFlag					
	bit		INPT5|$30				
	bmi		ld427					
	lda		frame_counter				
	and		#$0f					
	bne		ld47d					
	lda		#$05					
ld47d
	sta		arkLocationRegionId					
	jmp		reset_vars					 

ld482
	bit		screenEventState					
	bvs		ld489					
ld486
	jmp		ld51c					

ld489
	lda		frame_counter				
	and		#$03					
	bne		ld501					
	ldx		p0SpriteHeight					 
	cpx		#$60					
	bcc		ld4a5					
	bit		majorEventFlag					
	bmi		ld486					
	ldx		#$00					
	lda		indyPosX					
	cmp		#$20					
	bcs		ld4a3					
	lda		#$20					
ld4a3
	sta		ram_cc					
ld4a5
	inx								
	stx		p0SpriteHeight					 
	txa								
	sec								
	sbc		#$07					
	bpl		ld4b0					
	lda		#$00					
ld4b0
	sta		objPosY					
	and		#$f8					
	cmp		ram_d5					
	beq		ld501					
	sta		ram_d5					
	lda		objectState					
	and		#$03					
	tax								
	lda		objectState					
	lsr								
	lsr								
	tay								
	lda		ldbff,x					
	clc								
	adc		ldbff,y					
	clc								
	adc		ram_cc					
	ldx		#$00					
	cmp		#$87					
	bcs		ld4e2					
	cmp		#$18					
	bcc		ld4de					
	sbc		indyPosX					
	sbc		#$03					
	bpl		ld4e2					
ld4de
	inx								
	inx								
	eor		#$ff					
ld4e2
	cmp		#$09					
	bcc		ld4e7					
	inx								
ld4e7
	txa								
	asl								
	asl								
	sta		ram_84					
	lda		objectState					
	and		#$03					
	tax								
	lda		ldbff,x					
	clc								
	adc		ram_cc					
	sta		ram_cc					
	lda		objectState					
	lsr								
	lsr								
	ora		ram_84					
	sta		objectState					
ld501
	lda		objectState					
	and		#$03					
	tax								
	lda		ldbfb,x					
	sta		timepieceGfxPtrs					
	lda		#$fa					
	sta		ram_d7					
	lda		objectState					
	lsr								
	lsr								
	tax								
	lda		ldbfb,x					
	sec								
	sbc		#$08					
	sta		ram_d8					
ld51c
	bit		majorEventFlag					
	bpl		ld523					
	jmp		ld802					

ld523
	bit		eventTimer					
	bpl		ld52a					
	jmp		ld78c					

ld52a
	lda		frame_counter				
	ror								
	bcc		ld532					
	jmp		ld627					

ld532
	ldx		currentRoomId					
	cpx		#ID_MESA_SIDE					
	beq		ld579					
	bit		ram_8d					
	bvc		ld56e					
	ldx		weaponHorizPos					
	txa								
	sec								
	sbc		indyPosX					
	tay								
	lda		SWCHA					
	ror								
	bcc		ld55b					
	ror								
	bcs		ld579					
	cpy		#$09					
	bcc		ld579					
	tya								
	bpl		ld556					
ld553
	inx								
	bne		ld557					
ld556
	dex								
ld557
	stx		weaponHorizPos					
	bne		ld579					
ld55b
	cpx		#$75					
	bcs		ld579					
	cpx		#$1a					
	bcc		ld579					
	dey								
	dey								
	cpy		#$07					
	bcc		ld579					
	tya								
	bpl		ld553					
	bmi		ld556					
ld56e
	bit		mesaSideState					
	bmi		ld579					
	bit		ram_8a					
	bpl		ld57c					
	ror								
	bcc		ld57c					
ld579
	jmp		ld5e0					

ld57c
	ldx		#$01					
	lda		SWCHA					
	sta		ram_85					
	and		#$0f					
	cmp		#$0f					
	beq		ld579					
	sta		indyDir					
	jsr		getMoveDir					 
	ldx		currentRoomId					
	ldy		#$00					
	sty		ram_84					
	beq		ld599					
ld596
	tax								
	inc		ram_84					
ld599
	lda		indyPosX					
	pha								
	lda		indyPosY					
	ldy		ram_84					
	cpy		#$02					
	bcs		ld5ac					
	sta		ram_86					
	pla								
	sta		ram_87					
	jmp		ld5b1					

ld5ac
	sta		ram_87					
	pla								
	sta		ram_86					
ld5b1
	ror		ram_85					
	bcs		ld5d1					
	jsr		CheckRoomOverrideCondition					
	bcs		ld5db					
	bvc		ld5d1					
	ldy		ram_84					
	lda		ldf6c,y					
	cpy		#$02					
	bcs		ld5cc					
	adc		indyPosY					
	sta		indyPosY					
	jmp		ld5d1					

ld5cc
	clc								
	adc		indyPosX					
	sta		indyPosX					
ld5d1
	txa								
	clc								
	adc		#$0d					
	cmp		#$34					
	bcc		ld596					
	bcs		ld5e0					
ld5db
	sty		currentRoomId					
	jsr		InitializeScreenState					
ld5e0
	bit		INPT4|$30				
	bmi		ld5f5					
	bit		ram_9a					
	bmi		ld624					
	lda		ram_8a					
	ror								
	bcs		ld5fa					
	sec								
	jsr		removeItem					
	inc		ram_8a					
	bne		ld5fa					
ld5f5
	ror		ram_8a					
	clc								
	rol		ram_8a					
ld5fa
	lda		moveDirection					
	bpl		ld624					
	and		#$1f					
	cmp		#$01					
	bne		ld60c					
	inc		num_bullets					 
	inc		num_bullets					 
	inc		num_bullets					 
	bne		ld620					
ld60c
	cmp		#$0b					
	bne		ld61d					
	ror		blackMarketState					
	sec								
	rol		blackMarketState					
	ldx		#$45					
	stx		objState					
	ldx		#$7f					
	stx		ram_d0					
ld61d
	jsr		placeItemInInventory					
ld620
	lda		#$00					
	sta		moveDirection					
ld624
	jmp		ld777					

ld627
	bit		ram_9a					
	bmi		ld624					
	bit		INPT5|$30				
	bpl		ld638					
	lda		#$fd					
	and		ram_8a					
	sta		ram_8a					
	jmp		ld777					

ld638
	lda		#$02					
	bit		ram_8a					
	bne		ld696					
	ora		ram_8a					
	sta		ram_8a					
	ldx		selectedInventoryId					
	cpx		#$05					
	beq		ld64c					
	cpx		#$06					
	bne		ld671					
ld64c
	ldx		indyPosY					
	stx		weaponVertPos					
	ldy		indyPosX					
	sty		weaponHorizPos					
	lda		secondsTimer					 
	adc		#$04					
	sta		ram_9b					
	lda		#$80					
	cpx		#$35					
	bcs		ld66c					
	cpy		#$64					
	bcc		ld66c					
	ldx		currentRoomId					
	cpx		#ID_ENTRANCE_ROOM					
	bne		ld66c					
	ora		#$01					
ld66c
	sta		ram_9a					
	jmp		ld777					

ld671
	cpx		#$03					
	bne		ld68b					
	stx		parachute_used					
	lda		mesaSideState					
	bmi		ld696					
	ora		#$80					
	sta		mesaSideState					
	lda		indyPosY					
	sbc		#$06					
	bpl		ld687					
	lda		#$01					
ld687
	sta		indyPosY					
	bpl		ld6d2					
ld68b
	bit		ram_8d					
	bvc		ld6d5					
	bit		CXM1FB|$30				
	bmi		ld699					
	jsr		warpToMesaSide					
ld696
	jmp		ld777					

ld699
	lda		weaponVertPos					
	lsr								
	sec								
	sbc		#$06					
	clc								
	adc		objState					
	lsr								
	lsr								
	lsr								
	lsr								
	cmp		#$08					
	bcc		ld6ac					
	lda		#$07					
ld6ac
	sta		ram_84					
	lda		weaponHorizPos					
	sec								
	sbc		#$10					
	and		#$60					
	lsr								
	lsr								
	adc		ram_84					
	tay								
	lda		ldf7c,y					
	sta		arkDigRegionId					
	ldx		weaponVertPos					
	dex								
	stx		weaponVertPos					
	stx		indyPosY					
	ldx		weaponHorizPos					
	dex								
	dex								
	stx		weaponHorizPos					
	stx		indyPosX					
	lda		#$46					
	sta		ram_8d					
ld6d2
	jmp		ld773					

ld6d5
	cpx		#$0b					
	bne		ld6f7					
	lda		indyPosY					
	cmp		#$41					
	bcc		ld696					
	bit		CXPPMM|$30				
	bpl		ld696					
	inc		digAttemptCounter					
	bne		ld696					
	ldy		diggingState					
	dey								
	cpy		#$54					
	bcs		ld6ef					
	iny								
ld6ef
	sty		diggingState					
	lda		#$0a					
	sta		shovel_used					 
	bne		ld696					
ld6f7
	cpx		#$10					
	bne		ld71e					
	ldx		currentRoomId					
	cpx		#ID_TREASURE_ROOM					
	beq		ld696					
	lda		#ID_MESA_FIELD					
	sta		ankh_used				
	sta		currentRoomId					
	jsr		InitializeScreenState					
	lda		#$4c					
	sta		indyPosX					
	sta		weaponHorizPos					
	lda		#$46					
	sta		indyPosY					
	sta		weaponVertPos					
	sta		ram_8d					
	lda		#$1d					
	sta		objState					
	bne		ld777					
ld71e
	lda		SWCHA					
	and		#$0f					
	cmp		#$0f					
	beq		ld777					
	cpx		#$0d					
	bne		ld747					
	bit		weaponStatus					
	bmi		ld777					
	ldy		num_bullets					 
	bmi		ld777					
	dec		num_bullets					 
	ora		#$80					
	sta		weaponStatus					
	lda		indyPosY					
	adc		#$04					
	sta		weaponVertPos					
	lda		indyPosX					
	adc		#$04					
	sta		weaponHorizPos					
	bne		ld773					
ld747
	cpx		#$0a					
	bne		ld777					
	ora		#$80					
	sta		ram_8d					
	ldy		#$04					
	ldx		#$05					
	ror								
	bcs		ld758					
	ldx		#$fa					
ld758
	ror								
	bcs		ld75d					
	ldx		#$0f					
ld75d
	ror								
	bcs		ld762					
	ldy		#$f7					
ld762
	ror								
	bcs		ld767					
	ldy		#$10					
ld767
	tya								
	clc								
	adc		indyPosX					
	sta		weaponHorizPos					
	txa								
	clc								
	adc		indyPosY					
	sta		weaponVertPos					
ld773
	lda		#$0f					
	sta		ram_a3					
ld777
	bit		mesaSideState					
	bpl		ld783					
	lda		#$63					
	sta		indy_anim				
	lda		#$0f					
	bne		ld792					
ld783
	lda		SWCHA					
	and		#$0f					
	cmp		#$0f					
	bne		ld796					
ld78c
	lda		#$58					
ld78e
	sta		indy_anim				
	lda		#$0b					
ld792
	sta		indy_h					
	bne		ld7b2					
ld796
	lda		#$03					
	bit		ram_8a					
	bmi		ld79d					
	lsr								
ld79d
	and		frame_counter				
	bne		ld7b2					
	lda		#$0b					
	clc								
	adc		indy_anim				
	cmp		#$58					
	bcc		ld78e					
	lda		#$02					
	sta		ram_a3					
	lda		#$00					
	bcs		ld78e					
ld7b2
	ldx		currentRoomId					
	cpx		#ID_MESA_FIELD					
	beq		ld7bc					
	cpx		#$0a					
	bne		ld802					
ld7bc
	lda		frame_counter				
	bit		ram_8a					
	bpl		ld7c3					
	lsr								
ld7c3
	ldy		indyPosY					
	cpy		#$27					
	beq		ld802					
	ldx		objState					
	bcs		ld7e8					
	beq		ld802					
	inc		indyPosY					
	inc		weaponVertPos					
	and		#$02					
	bne		ld802					
	dec		objState					
	inc		objectPosY					 
	inc		ram_d0					
	inc		objPosY					
	inc		objectPosY					 
	inc		ram_d0					
	inc		objPosY					
	jmp		ld802					

ld7e8
	cpx		#$50					
	bcs		ld802					
	dec		indyPosY					
	dec		weaponVertPos					
	and		#$02					
	bne		ld802					
	inc		objState					
	dec		objectPosY					 
	dec		ram_d0					
	dec		objPosY					
	dec		objectPosY					 
	dec		ram_d0					
	dec		objPosY					
ld802
	lda		#$28					
	sta		ram_88					
	lda		#$f5					
	sta		ram_89					
	jmp		ldfad					

ld80d
	lda		ram_99					
	beq		set_room_attr					
	jsr		updateRoomEventState				
	lda		#$00					
set_room_attr
	sta		ram_99					
	ldx		currentRoomId					
	lda		HMOVETable,x					
	sta		NUSIZ0					
	lda		room_pf_cfg					
	sta		CTRLPF					
	lda		room_bg_color_tbl,x					
	sta		COLUBK					
	lda		room_pf_color_tbl,x					
	sta		COLUPF					
	lda		room_p0_color_tbl,x					
	sta		COLUP0					
	lda		room_p1_color_tbl,x					
	sta		COLUP1					
	cpx		#$0b					
	bcc		ld84b					
	lda		#$20					
	sta		objectState					
	ldx		#$04					
ld841
	ldy		dungeonGfxData,x				
	lda		HMOVETable,y					
	sta		ram_ee,x				
	dex								
	bpl		ld841					
ld84b
	jmp		setObjPosX					

ld84e
	lda		#$4d					
	sta		indyPosX					
	lda		#$48					
	sta		ObjectPosX					 
	lda		#$1f					
	sta		indyPosY					
	rts								

ld85b
	ldx		#$00					
	txa								
ld85e
	sta		objState,x				
	sta		ram_e0,x				
	sta		PF1_data,x					
	sta		ram_e2,x				
	sta		PF2_data,x					
	sta		ram_e4,x				
	txa								
	bne		ld873					
	ldx		#$06					
	lda		#$14					
	bne		ld85e					
ld873
	lda		#$fc					
	sta		ram_d7					
	rts								

InitializeScreenState
	lda		ram_9a					
	bpl		ld880					
	ora		#$40					
	sta		ram_9a					
ld880
	lda		#$5c					
	sta		diggingState					
	ldx		#$00					
	stx		screenEventState					
	stx		spiderRoomState					
	stx		ram_8e					
	stx		ram_90					
	lda		pickupStatusFlags					
	stx		pickupStatusFlags					
	jsr		updateRoomEventState				
	rol		ram_8a					
	clc								
	ror		ram_8a					
	ldx		currentRoomId					
	lda		ldb92,x					
	sta		room_pf_cfg					
	cpx		#$0d					
	beq		ld84e					
	cpx		#$05					
	beq		ld8b1					
	cpx		#$0c					
	beq		ld8b1					
	lda		#$00					
	sta		arkDigRegionId					
ld8b1
	lda		ldbee,x					
	sta		emy_anim					
	lda		ldbe1,x					
	sta		ram_de					
	lda		ldbc9,x					
	sta		p0SpriteHeight					 
	lda		ldbd4,x					
	sta		ObjectPosX					 
	lda		ldc0e,x					
	sta		ram_ca					
	lda		ldc1b,x					
	sta		ram_d0					
	cpx		#$0b					
	bcs		ld85b					
	adc		ldc03,x					
	sta		ram_e0					
	lda		ldc28,x					
	sta		PF1_data					
	lda		ldc33,x					
	sta		ram_e2					
	lda		ldc3e,x					
	sta		PF2_data					
	lda		ldc49,x					
	sta		ram_e4					
	lda		#$55					
	sta		objPosY					
	sta		weaponVertPos					
	cpx		#$06					
	bcs		ld93e					
	lda		#$00					
	cpx		#$00					
	beq		ld91b					
	cpx		#$02					
	beq		ld92a					
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
	sta		ram_d0					
ld918
	sty		objState					
	rts								

ld91b
	lda		treasureIndex					
	and		#$78					
	sta		treasureIndex					
	lda		#$1a					
	sta		objectPosY					 
	lda		#$26					
	sta		objState					
	rts								

ld92a
	lda		entranceRoomState					
	and		#$07					
	lsr								
	bne		ld935					
	ldy		#$ff					
	sty		ram_d0					
ld935
	tay								
	lda		ldf70,y					
	sta		objectPosY					 
	jmp		ld902					

ld93e
	cpx		#$08					
	beq		ld950					
	cpx		#$06					
	bne		ld968					
	ldy		#$00					
	sty		ram_d8					
	ldy		#$40					
	sty		dungeonGfxData					
	bne		ld958					
ld950
	ldy		#$ff					
	sty		dungeonGfxData					
	iny								
	sty		ram_d8					
	iny								
ld958
	sty		dungeonBlock1					
	sty		dungeonBlock2					
	sty		dungeonBlock3					
	sty		dungeonBlock4					
	sty		dungeonBlock5					
	ldy		#$39					
	sty		objectState					
	sty		ram_d5					
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
	cpy		ram_86					
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
	cpy		ram_87					
	bcc		ld9af					
	ldy		lde9c,x					
	bmi		ld9c7					
	bpl		ld98b					
ld9af
	ldy		lded0,x					
	bmi		ld9c7					
	bpl		ld98b					
ld9b6
	lda		ram_87					
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
	lda		ram_b5					
	and		#$0f					
	bne		ld9f9					
	ldy		#$06					
	bne		ld98b					
ld9e1
	iny								
	bne		ld9f0					
	lda		ram_b5					
	and		#$0f					
	cmp		#$0a					
	bcs		ld9f9					
	ldy		#$06					
	bne		ld98b					
ld9f0
	iny								
	bne		ld9fe					
	ldy		#$01					
	bit		ram_8a					
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
	cmp		inv_slot_lo,x					
	bne		lda3a					
	cpx		cursor_pos					
	beq		lda3a					
	dec		ram_c4					
	lda		#$00					
	sta		inv_slot_lo,x					
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
	sta		inv_slot_lo,x			; put in current slot
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
	sta		yar_found					
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
	lda		inv_slot_lo,x		 
	beq		ldae4						
	stx		$c3						
	lsr								
	lsr								
	lsr								
	sta		selectedInventoryId			
ldaf7
	lda		#$0d					
	sta		ram_a2					
	sec								
	rts								

	.byte	$00,$00,$00						; $dafd (*)
HMOVETable
	.byte	$00								; $db00 (d)
	.byte	$00,$35,$10,$17,$30,$00,$00,$00 ; $db01 (*)
	.byte	$00,$00,$00,$00					; $db09 (*)
	.byte	$05								; $db0d (d)
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
ldb92
	.byte	$11,$11,$11,$11,$31,$11,$25,$05 ; $db92 (*)
	.byte	$05,$01,$01,$05,$05				; $db9a (*)
	.byte	$01								; $db9f (d)

room_bg_color_tbl
    .byte $00 ; |        | $dba0 - room $00 - black #000000
    .byte $24 ; |  x  x  | $dba1 - room $01 - paarl #985c28
    .byte $96 ; |x  x xx | $dba2 - room $02 
    .byte $22 ; |  x   x | $dba3 - room $03 
    .byte $72 ; | xxx  x | $dba4 - room $04 
    .byte $fc ; |xxxxxx  | $dba5 - room $05 
    .byte $00 ; |        | $dba6 - room $06 - black #000000
    .byte $00 ; |        | $dba7 - room $07 - black #000000 
    .byte $00 ; |        | $dba8 - room $08 - black #000000 
    .byte $72 ; | xxx  x | $dba9 - room $09 
    .byte $12 ; |   x  x | $dbaa - room $0a 
    .byte $00 ; |        | $dbab - room $0b - black #000000 
    .byte $f8 ; |xxxxx   | $dbac - room $0c 
    .byte $00 ; |        | $dbad - room $0d - black #000000 

room_pf_color_tbl
    .byte $08 ; |    x   | $dbae - room $00
    .byte $22 ; |  x   x | $dbaf - room $01
    .byte $08 ; |    x   | $dbb0 - room $02
    .byte $00 ; |        | $dbb1 - room $03 - black #000000
    .byte $1a ; |   xx x | $dbb2 - room $04
    .byte $28 ; |  x x   | $dbb3 - room $05
    .byte $c8 ; |xx  x   | $dbb4 - room $06
    .byte $e8 ; |xxx x   | $dbb5 - room $07
	.byte $8a ; |x   x x | $dbb6 - room $08
    .byte $1a ; |   xx x | $dbb7 - room $09
    .byte $c6 ; |xx   xx | $dbb8 - room $0a
    .byte $00 ; |        | $dbb9 - room $0b - black #000000
    .byte $28 ; |  x x   | $dbba - room $0c
    .byte $78 ; | xxxx   | $dbbb - room $0d

room_p1_color_tbl
	.byte $cc ; |xx  xx  | $dbbc
    .byte $ea ; |xxx x x | $dbbd
    .byte $5a ; | x xx x | $dbbe
    .byte $26 ; |  x  xx | $dbbf
    .byte $9e ; |x  xxxx | $dbc0
    .byte $a6 ; |x x  xx | $dbc1
    .byte $7c ; | xxxxx  | $dbc2

room_p0_color_tbl
	.byte $88 ; |x   x   | $dbc3
    .byte $28 ; |  x x   | $dbc4
    .byte $f8 ; |xxxxx   | $dbc5
    .byte $4a ; | x  x x | $dbc6
    .byte $26 ; |  x  xx | $dbc7
    .byte $a8 ; |x x x   | $dbc8

ldbc9
	.byte	$c0|$c							; $dbc9 (c)

	.byte	$ce,$4a,$98,$00,$00,$00			; $dbca (*)

	.byte	$00|$8							; $dbd0 (c)

	.byte	$07,$01,$10						; $dbd1 (*)
ldbd4
	.byte	$78,$4c,$5d,$4c,$4f,$4c,$12,$4c ; $dbd4 (*)
	.byte	$4c,$4c,$4c,$12,$12				; $dbdc (*)
ldbe1
	.byte	$ff,$ff,$ff,$f9,$f9,$f9,$fa,$00 ; $dbe1 (*)
	.byte	$fd,$fb,$fc,$fc,$fc				; $dbe9 (*)
ldbee
	.byte	$00,$51,$a1,$00,$51,$a2,$c1,$e5 ; $dbee (*)
	.byte	$e0,$00,$00,$00,$00				; $dbf6 (*)
ldbfb
	.byte	$72,$7a,$8a,$82					; $dbfb (*)
ldbff
	.byte	$fe,$fa,$02,$06					; $dbff (*)
ldc03
	.byte	$00,$00,$18,$04,$03,$03,$85,$85 ; $dc03 (*)
	.byte	$3b,$85,$85						; $dc0b (*)
ldc0e
	.byte	$20,$78,$85,$4d,$62,$17,$50,$50 ; $dc0e (*)
	.byte	$50,$50,$50,$12,$12				; $dc16 (*)
ldc1b
	.byte	$ff,$ff,$14,$4b,$4a,$44,$ff,$27 ; $dc1b (*)
	.byte	$ff,$ff,$ff,$f0,$f0				; $dc23 (*)
ldc28
	.byte	$06,$06,$06,$06,$06,$06,$48,$68 ; $dc28 (*)
	.byte	$89,$00,$00						; $dc30 (*)
ldc33
	.byte	$00,$00,$00,$00,$00,$00,$fd,$fd ; $dc33 (*)
	.byte	$fd,$fe,$fe						; $dc3b (*)
ldc3e
	.byte	$20,$20,$20,$20,$20,$20,$20,$b7 ; $dc3e (*)
	.byte	$9b,$78,$78						; $dc46 (*)
ldc49
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
	.word ld36f-1 ; $dcd3/d4
	.word roomIdleHandler-1 ; $dcd5/d6
	.word initFallbackEntryPosition-1 ; $dcd7/d8
	.word roomIdleHandler-1 ; $dcd9/da
	.word roomIdleHandler-1 ; $dcdb/dc
	.word roomIdleHandler-1 ; $dcdd/de
	.word roomIdleHandler-1 ; $dcdf/e0
	.word warpToMesaSide-1 ; $dce1/e2
	.word ld36f-1 ; $dce3/e4
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
	ldy		inv_slot_lo,x					
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
	sta		inv_slot_lo,x			; and store in current slot
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
	sta		ram_a2					
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

gameStart
	sei								; turn off interrupts
	cld								; clear decimal flag (no bcd)
	ldx		#$ff					;
	txs								; reset the stack pointer
	inx								; clear x
	txa								; clear a
clear_zp
	sta		zero_page,x
	dex
	bne		clear_zp

	dex								; x = $ff
	stx		score					; reset score
	lda		#>emptySprite				; blank inventory
	sta		inv_slot_hi				; slot 1
	sta		inv_slot2_hi			; slot 2
	sta		inv_slot3_hi			; slot 3
	sta		inv_slot4_hi			; slot 4
	sta		inv_slot5_hi			; slot 5
	sta		inv_slot6_hi			; slot 6

	;fill with copyright text
	lda		#<copyrightGfx0
	sta		inv_slot_lo
	lda		#<copyrightGfx1
	sta		inv_slot2_lo
	lda		#<copyrightGfx2
	sta		inv_slot4_lo
	lda		#<copyrightGfx3
	sta		inv_slot3_lo
	lda		#<copyrightGfx4
	sta		inv_slot5_lo
	lda		#ID_ARK_ROOM				; set "ark elevator room" (room 13)
	sta		currentRoomId				; as current room
	lsr								; divide 13 by 2 (round down)
	sta		num_bullets				; load 6 bullets
	jsr		InitializeScreenState					
	jmp		ld3dd					

reset_vars
	lda		#$20					
	sta		inv_slot_lo					
	lsr								
	lsr								
	lsr								
	sta		selectedInventoryId					
	inc		ram_c4					
	lda		#$00					
	sta		inv_slot2_lo					
	sta		inv_slot3_lo					
	sta		inv_slot4_lo					
	sta		inv_slot5_lo					
	lda		#$64					
	sta		score				
	lda		#$58					
	sta		indy_anim				
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
	jmp		ld80d					

;------------------------------------------------------------
; getFinalScore
; The player's progress is determined by Indy's height on the pedestal when the
; game is complete. The player wants to achieve the lowest adventure points
; possible to lower Indy's position on the pedestal.
;
getFinalScore
	lda		score					; load score
	sec								; positve actions...
	sbc		shovel_used				; shovel used
	sbc		parachute_used			; parachute used
	sbc		ankh_used				; ankh used
	sbc		yar_found				; yar found
	sbc		lives_left				; lives left
	sbc		ark_found				; ark found
	sbc		mesa_entered				; mesa entered
	sbc		unknown_action			; never updated
	clc								; negitive actions...
	adc		grenade_used			; gernade used
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
ldf6c
	.byte	$01,$ff,$01,$ff					; $df6c (*)
ldf70
	.byte	$35,$09							; $df70 (*)
ldf72
	.byte	$00,$00,$42,$45,$0c,$20

MarketBasketItems
	.byte ID_INVENTORY_COINS, ID_INVENTORY_CHAI
	.byte ID_INVENTORY_ANKH, ID_INVENTORY_HOUR_GLASS


ldf7c
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
	sta		ram_88					
	lda		#$f8					
	sta		ram_89					
ldfad
	lda		#$ad					
	sta		ram_84					
	lda		#$f9					
	sta		ram_85					
	lda		#$ff					
	sta		ram_86					
	lda		#$4c					
	sta		ram_87					
	jmp.w	ram_84					

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
	dec		ObjectPosX,x				;move enemy down 1 unit
mov_emy_up
	ror								;rotate next bit into carry
	bcs		mov_emy_finish			;if 1, moves are finished
	inc		ObjectPosX,x				;move enemy up 1 unit
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

	lda		lfff8					
lf003
	cmp		ram_e0					
	bcs		lf01a					
	lsr								
	clc								
	adc		objState					
	tay								
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	lda		(PF1_data),y				
	sta		PF1						
	lda		(PF2_data),y				
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
	cpx		ram_d5					
	bcc		lf02d					
	ldx		ram_d8					
	lda		#$00					
	beq		lf031					
lf02d
	lda		dungeonGfxData,x				
	ldx		ram_d8					
lf031
	sta		PF1,x					
lf033
	ldx		#$1e					
	txs								
	lda		scan_line				
	sec								
	sbc		indyPosY					
	cmp		indy_h					
	bcs		lf079					
	tay								
	lda		(indy_anim),y			
	tax								
lf043
	lda		scan_line				
	sec								
	sbc		objectPosY					 
	cmp		p0SpriteHeight					 
	bcs		lf07d					
	tay								
	lda		(emy_anim),y				
	tay								
lf050
	lda		scan_line				
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	cmp		weaponVertPos					
	php								
	cmp		ram_d0					
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
	inc		scan_line				
	lda		scan_line				
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
	lda		(emy_anim),y				
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
	sta		(PF1_data,x)				
lf0a4
	inc		scan_line				
	ldx		scan_line				
	lda		#$02					
	cpx		ram_d0					
	bcc		lf0b2					
	cpx		ram_e0					
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
	sbc		ram_d5					
	cmp		#$10					
	bcs		lf0ff					
	tay								
	cmp		#$08					
	bcc		lf0fb					
	lda		ram_d8					
	sta		timepieceGfxPtrs					
lf0ca
	lda		(timepieceGfxPtrs),y				
	sta		HMBL					
lf0ce
	ldy		#$00					
	txa								
	cmp		weaponVertPos					
	bne		lf0d6					
	dey								
lf0d6
	sty		ENAM1					
	sec								
	sbc		indyPosY					
	cmp		indy_h					
	bcs		lf107					
	tay								
	lda		(indy_anim),y			
lf0e2
	ldy		scan_line				
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
	lda		ram_84					
	sta		GRP0					
	lda		ram_85					
	sta		COLUP0					
	txa								
	ldx		#$1f					
	txs								
	tax								
	lsr								
	cmp		objPosY					
	php								
	cmp		weaponVertPos					
	php								
	cmp		ram_d0					
	php								
	sec								
	sbc		indyPosY					
	cmp		indy_h					
	bcs		lf10b					
	tay								
	lda		(indy_anim),y			
	sta		HMCLR					
	inx								
	sta		GRP1					
lf140
	sta		WSYNC					
;---------------------------------------
	sta		HMOVE					
	bit		objectState					
	bpl		lf157					
	ldy		ram_89					
	lda		ram_88					
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
	lda		(emy_anim),y				
	sta		GRP0					
	lda		(timepieceGfxPtrs),y				
	sta		COLUP0					
	iny								
	lda		(emy_anim),y				
	sta		ram_84					
	lda		(timepieceGfxPtrs),y				
	sta		ram_85					
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
	sty		ram_87					
	lda.wy	objState,y				
	sta		REFP0					
	sta		NUSIZ0					
	sta		ram_86					
	bpl		lf1a2					
	lda		diggingState					
	sta		emy_anim					
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
	ldy		ram_87					
	lda		#$08					
	and		ram_86					
	beq		lf1b6					
	lda		#$03					
lf1b6
	eor.wy	dungeonGfxData,y				
	and		#$03					
	tay								
	lda		lfc40,y					
	sta		emy_anim					
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
	ldy		ram_87					
	lda.wy	ram_ee,y				
	sta		ram_88					
	and		#$0f					
	sta		ram_89					
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
	lda		lfff2,y					
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
	and		frame_counter				
	bne		draw_menu					
	lda		#$3f					
	and		secondsTimer					 
	bne		draw_menu					
	lda		ram_b5					
	and		#$0f					
	beq		draw_menu					
	cmp		#$0f					
	beq		draw_menu					
	inc		ram_b5					
draw_menu
	sta		WSYNC					; draw blank line
	lda		#$42					; set red...
	sta		COLUBK					; ...as the background color
	sta		WSYNC					; draw four more scanlines
	sta		WSYNC					;
	sta		WSYNC					;
	sta		WSYNC					;
	lda		#$07					
	sta		ram_84					
draw_inventory
	ldy		ram_84					
	lda		(inv_slot_lo),y				
	sta		GRP0					
	sta		WSYNC					
;---------------------------------------
	lda		(inv_slot2_lo),y				
	sta		GRP1					
	lda		(inv_slot3_lo),y				
	sta		GRP0					
	lda		(inv_slot4_lo),y				
	sta		ram_85					
	lda		(inv_slot5_lo),y				
	tax								
	lda		(inv_slot6_lo),y				
	tay								
	lda		ram_85					
	sta		GRP1					
	stx		GRP0					
	sty		GRP1					
	sty		GRP0					
	dec		ram_84					
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
	lda		ram_a2,x				
	sta		AUDC0,x					
	sta		AUDV0,x					
	bmi		lf2fb					
	ldy		#$00					
	sty		ram_a2,x				
lf2f4
	sta		AUDF0,x					
	dex								
	bpl		lf2e8					
	bmi		lf320					
lf2fb
	cmp		#$9c					
	bne		lf314					
	lda		#$0f					
	and		frame_counter				
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
	lda		frame_counter				
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
	sta		ram_a3					
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
	sta		inv_slot_lo,x					
lf344
	lda		#$00					
	sta		ram_a3					
lf348
	bit		screenEventState					
	bpl		lf371					
	lda		frame_counter				
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
	lda		frame_counter				
	and		#$06					
	asl								
	asl								
	sta		timepieceGfxPtrs					
	lda		#$fd					
	sta		ram_d7					
lf371
	ldx		#$02					
lf373
	jsr		lfef4					
	inx								
	cpx		#$05					
	bcc		lf373					
	bit		majorEventFlag					
	bpl		lf3bf					
	lda		frame_counter				
	bvs		lf39d					
	and		#$0f					
	bne		lf3c5					
	ldx		indy_h					
	dex								
	stx		ram_a3					
	cpx		#$03					
	bcc		lf398					
	lda		#$8f					
	sta		weaponVertPos					
	stx		indy_h					
	bcs		lf3c5					
lf398
	sta		frame_counter				
	sec								
	ror		majorEventFlag					
lf39d
	cmp		#$3c					
	bcc		lf3a9					
	bne		lf3a5					
	sta		ram_a3					
lf3a5
	ldy		#$00					
	sty		indy_h					
lf3a9
	cmp		#$78					
	bcc		lf3c5					
	lda		#$0b					
	sta		indy_h					
	sta		ram_a3					
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
	sta		ram_88					
	lda		#$d3					
	sta		ram_89					
	jmp		lf493					

lf3d0
	bit		ram_8d					
	bvs		lf437					
	bit		mesaSideState					
	bmi		lf437					
	bit		ram_9a					
	bmi		lf437					
	lda		#$07					
	and		frame_counter				
	bne		lf437					
	lda		ram_c4					
	and		#$06					
	beq		lf437					
	ldx		cursor_pos					
	lda		inv_slot_lo,x					
	cmp		#$98					
	bcc		lf3f2					
	lda		#$78					
lf3f2
	bit		SWCHA					
	bmi		lf407					
	sta		inv_slot_lo,x					
lf3f9
	inx								
	inx								
	cpx		#$0b					
	bcc		lf401					
	ldx		#$00					
lf401
	ldy		inv_slot_lo,x					
	beq		lf3f9					
	bne		lf415					
lf407
	bvs		lf437					
	sta		inv_slot_lo,x					
lf40b
	dex								
	dex								
	bpl		lf411					
	ldx		#$0a					
lf411
	ldy		inv_slot_lo,x					
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
	sta		ram_8d					
	lda		indyPosY					
	adc		#$09					
	sta		weaponVertPos					
	lda		indyPosX					
	adc		#$09					
	sta		weaponHorizPos					
lf437
	lda		ram_8d					
	bpl		lf454					
	cmp		#$bf					
	bcs		lf44b					
	adc		#$10					
	sta		ram_8d					
	ldx		#$03					
	jsr		lfcea					
	jmp		lf48b					

lf44b
	lda		#$70					
	sta		weaponVertPos					
	lsr								
	sta		ram_8d					
	bne		lf48b					
lf454
	bit		ram_8d					
	bvc		lf48b					
	ldx		#$03					
	jsr		lfcea					
	lda		weaponHorizPos					
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
	lda		weaponVertPos					
	sec								
	sbc		#$05					
	cmp		indyPosY					
	bne		lf487					
	lda		#$0c					
lf481
	eor		ram_8d					
	sta		ram_8d					
	bne		lf48b					
lf487
	cmp		#$4a					
	bcs		lf472					
lf48b
	lda		#$24					
	sta		ram_88					
	lda		#$d0					
	sta		ram_89					
lf493
	lda		#$ad					
	sta		ram_84					
	lda		#$f8					
	sta		ram_85					
	lda		#$ff					
	sta		ram_86					
	lda		#$4c					
	sta		ram_87					
	jmp.w	ram_84					

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
	lda		indy_sprite,y					
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
	adc		frame_counter				
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
       lda    #<ld80d                 
       sta    $88                     
       lda    #>ld80d                 
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
	sty		scan_line				
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
	ldx		lf9ee,y					
	lda		lfae2+1,x				
	pha								
	lda		lfae2,x					
	pha								
	lda		#$00					
	tax								
	sta		ram_84					
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
	lda		ObjectPosX,x				 
	cmp.wy	ObjectPosX,y				 
	bne		lf8d9					
	cpy		#$05					
	bcs		lf8dd					
lf8d9
	bcs		lf8de					
	inc		ObjectPosX,x				 
lf8dd
	rts								

lf8de
	dec		ObjectPosX,x				 
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
	lda		ObjectPosX,x				 
	cmp		#$10					
	bcc		lf8e7					
	cmp		#$8e					
	bcs		lf8e7					
	rts								

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


;map room
	.byte	$94 ; |#  # #  |
	.byte	$00 ; |		|
	.byte	$08 ; |	#   |
	.byte	$1c ; |		###  |
	.byte	$3e ; |	 ##### |
	.byte	$3e ; |	 ##### |
	.byte	$3e ; |	 ##### |
	.byte	$3e ; |	 ##### |
	.byte	$1c ; |		###  |
	.byte	$08 ; |	#   |
	.byte	$00 ; |		|
	.byte	$8e ; |#   ### |
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$14 ; |		# #  |
	.byte	$14 ; |		# #  |
	.byte	$00 ; |		|
	.byte	$00 ; |		|
	.byte	$2a ; |	 # # # |
	.byte	$2a ; |	 # # # |
	.byte	$00 ; |		|
	.byte	$00 ; |		|
	.byte	$14 ; |		# #  |
	.byte	$36 ; |	 ## ## |
	.byte	$22 ; |	 #	 # |
	.byte	$08 ; |	#   |
	.byte	$08 ; |	#   |
	.byte	$3e ; |	 ##### |
	.byte	$1c ; |		###  |
	.byte	$08 ; |	#   |
	.byte	$00 ; |		|
	.byte	$41 ; | #		#|
	.byte	$63 ; | ##	 ##|
	.byte	$49 ; | #  #  #|
	.byte	$08 ; |	#   |
	.byte	$00 ; |		|
	.byte	$00 ; |		|
	.byte	$14 ; |		# #  |
	.byte	$14 ; |		# #  |
	.byte	$00 ; |		|
	.byte	$00 ; |		|
	.byte	$08 ; |	#   |
	.byte	$6b ; | ## # ##|
	.byte	$6b ; | ## # ##|
	.byte	$08 ; |	#   |
	.byte	$00 ; |		|
	.byte	$22 ; |	 #	 # |
	.byte	$22 ; |	 #	 # |
	.byte	$00 ; |		|
	.byte	$00 ; |		|
	.byte	$08 ; |	#   |
	.byte	$1c ; |		###  |
	.byte	$1c ; |		###  |
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$e4 ; |###	#  |
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$41 ; | #		#|
	.byte	$7f ; | #######|
	.byte	$92 ; |#  #	 # |
	.byte	$77 ; | ### ###|
	.byte	$77 ; | ### ###|
	.byte	$63 ; | ##	 ##|
	.byte	$77 ; | ### ###|
	.byte	$14 ; |		# #  |
	.byte	$36 ; |	 ## ## |
	.byte	$55 ; | # # # #|
	.byte	$63 ; | ##	 ##|
	.byte	$77 ; | ### ###|
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$00 ; |		|
	.byte	$86 ; |#	## |
	.byte	$24 ; |	 #	#  |
	.byte	$18 ; |		##   |
	.byte	$24 ; |	 #	#  |
	.byte	$24 ; |	 #	#  |
	.byte	$7e ; | ###### |
	.byte	$5a ; | # ## # |
	.byte	$5b ; | # ## ##|
	.byte	$3c ; |	 ####  |






	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $f9ac (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $f9b4 (*)
	.byte	$00,$00,$00,$00,$00,$00,$00,$00 ; $f9bc (*)
	.byte	$00,$b9,$e4,$81,$89,$55,$f9,$89 ; $f9c4 (*)
	.byte	$f9,$81,$fa,$32,$1c,$89,$3e,$91 ; $f9cc (*)
	.byte	$7f,$7f,$7f,$7f,$89,$1f,$07,$01 ; $f9d4 (*)
	.byte	$00,$e9,$fe,$89,$3f,$7f,$f9,$91 ; $f9dc (*)
	.byte	$f9,$89,$3f,$f9,$7f,$3f,$7f,$7f ; $f9e4 (*)
	.byte	$00,$00							; $f9ec (*)
lf9ee
	.byte	$00,$00,$00,$00,$00,$00,$02,$02 ; $f9ee (*)
	.byte	$02,$02,$02,$04,$04				; $f9f6 (*)
	.byte	$06								; $f9fb (d)

lf9fc
	.byte	$1c ; |		###  |			$f9fc (g)
	.byte	$36 ; |	 ## ## |			$f9fd (g)
	.byte	$63 ; | ##	 ##|			$f9fe (g)
	.byte	$36 ; |	 ## ## |			$f9ff (g)

	.byte	$18 ; |		xx   |			$fa00 (g)
	.byte	$3c ; |	 xxxx  |			$fa01 (g)
	.byte	$00 ; |		|			$fa02 (g)
	.byte	$18 ; |		xx   |			$fa03 (g)
	.byte	$1c ; |		xxx  |			$fa04 (g)
	.byte	$18 ; |		xx   |			$fa05 (g)
	.byte	$18 ; |		xx   |			$fa06 (g)
	.byte	$0c ; |	xx  |			$fa07 (g)
	.byte	$62 ; | xx	 x |			$fa08 (g)
	.byte	$43 ; | x	 xx|			$fa09 (g)
	.byte	$00 ; |		|			$fa0a (g)

	.byte	$18 ; |		xx   |			$fa0b (g)
	.byte	$3c ; |	 xxxx  |			$fa0c (g)
	.byte	$00 ; |		|			$fa0d (g)
	.byte	$18 ; |		xx   |			$fa0e (g)
	.byte	$38 ; |	 xxx   |			$fa0f (g)
	.byte	$1c ; |		xxx  |			$fa10 (g)
	.byte	$18 ; |		xx   |			$fa11 (g)
	.byte	$14 ; |		x x  |			$fa12 (g)
	.byte	$64 ; | xx	x  |			$fa13 (g)
	.byte	$46 ; | x	xx |			$fa14 (g)
	.byte	$00 ; |		|			$fa15 (g)

	.byte	$18 ; |		xx   |			$fa16 (g)
	.byte	$3c ; |	 xxxx  |			$fa17 (g)
	.byte	$00 ; |		|			$fa18 (g)
	.byte	$38 ; |	 xxx   |			$fa19 (g)
	.byte	$38 ; |	 xxx   |			$fa1a (g)
	.byte	$18 ; |		xx   |			$fa1b (g)
	.byte	$18 ; |		xx   |			$fa1c (g)
	.byte	$28 ; |	 x x   |			$fa1d (g)
	.byte	$48 ; | x  x   |			$fa1e (g)
	.byte	$8c ; |x   xx  |			$fa1f (g)
	.byte	$00 ; |		|			$fa20 (g)

	.byte	$18 ; |		xx   |			$fa21 (g)
	.byte	$3c ; |	 xxxx  |			$fa22 (g)
	.byte	$00 ; |		|			$fa23 (g)
	.byte	$38 ; |	 xxx   |			$fa24 (g)
	.byte	$58 ; | x xx   |			$fa25 (g)
	.byte	$38 ; |	 xxx   |			$fa26 (g)
	.byte	$10 ; |		x	|			$fa27 (g)
	.byte	$e8 ; |xxx x   |			$fa28 (g)
	.byte	$88 ; |x   x   |			$fa29 (g)
	.byte	$0c ; |	xx  |			$fa2a (g)
	.byte	$00 ; |		|			$fa2b (g)

	.byte	$18 ; |		xx   |			$fa2c (g)
	.byte	$3c ; |	 xxxx  |			$fa2d (g)
	.byte	$00 ; |		|			$fa2e (g)
	.byte	$30 ; |	 xx	|			$fa2f (g)
	.byte	$78 ; | xxxx   |			$fa30 (g)
	.byte	$34 ; |	 xx x  |			$fa31 (g)
	.byte	$18 ; |		xx   |			$fa32 (g)
	.byte	$60 ; | xx	|			$fa33 (g)
	.byte	$50 ; | x x	|			$fa34 (g)
	.byte	$18 ; |		xx   |			$fa35 (g)
	.byte	$00 ; |		|			$fa36 (g)

	.byte	$18 ; |		xx   |			$fa37 (g)
	.byte	$3c ; |	 xxxx  |			$fa38 (g)
	.byte	$00 ; |		|			$fa39 (g)
	.byte	$30 ; |	 xx	|			$fa3a (g)
	.byte	$38 ; |	 xxx   |			$fa3b (g)
	.byte	$3c ; |	 xxxx  |			$fa3c (g)
	.byte	$18 ; |		xx   |			$fa3d (g)
	.byte	$38 ; |	 xxx   |			$fa3e (g)
	.byte	$20 ; |	 x	|			$fa3f (g)
	.byte	$30 ; |	 xx	|			$fa40 (g)
	.byte	$00 ; |		|			$fa41 (g)

	.byte	$18 ; |		xx   |			$fa42 (g)
	.byte	$3c ; |	 xxxx  |			$fa43 (g)
	.byte	$00 ; |		|			$fa44 (g)
	.byte	$18 ; |		xx   |			$fa45 (g)
	.byte	$38 ; |	 xxx   |			$fa46 (g)
	.byte	$1c ; |		xxx  |			$fa47 (g)
	.byte	$18 ; |		xx   |			$fa48 (g)
	.byte	$2c ; |	 x xx  |			$fa49 (g)
	.byte	$20 ; |	 x	|			$fa4a (g)
	.byte	$30 ; |	 xx	|			$fa4b (g)
	.byte	$00 ; |		|			$fa4c (g)

	.byte	$18 ; |		xx   |			$fa4d (g)
	.byte	$3c ; |	 xxxx  |			$fa4e (g)
	.byte	$00 ; |		|			$fa4f (g)
	.byte	$18 ; |		xx   |			$fa50 (g)
	.byte	$18 ; |		xx   |			$fa51 (g)
	.byte	$18 ; |		xx   |			$fa52 (g)
	.byte	$08 ; |	x   |			$fa53 (g)
	.byte	$16 ; |		x xx |			$fa54 (g)
	.byte	$30 ; |	 xx	|			$fa55 (g)
	.byte	$20 ; |	 x	|			$fa56 (g)
	.byte	$00 ; |		|			$fa57 (g)

indy_sprite
	.byte	$18 ; |		##   |			$fa58 (g)
	.byte	$3c ; |	 ####  |			$fa59 (g)
	.byte	$00 ; |		|			$fa5a (g)
	.byte	$18 ; |		##   |			$fa5b (g)
	.byte	$3c ; |	 ####  |			$fa5c (g)
	.byte	$5a ; | # ## # |			$fa5d (g)
	.byte	$3c ; |	 ####  |			$fa5e (g)
	.byte	$18 ; |		##   |			$fa5f (g)
	.byte	$18 ; |		##   |			$fa60 (g)
	.byte	$3c ; |	 ####  |			$fa61 (g)
	.byte	$00 ; |		|			$fa62 (g)

	.byte	$3c ; |	 ####  |			$fa63 (g)
	.byte	$7e ; | ###### |			$fa64 (g)
	.byte	$ff ; |########|			$fa65 (g)
	.byte	$a5 ; |# #	# #|			$fa66 (g)
	.byte	$42 ; | #	 # |			$fa67 (g)
	.byte	$42 ; | #	 # |			$fa68 (g)
	.byte	$18 ; |		##   |			$fa69 (g)
	.byte	$3c ; |	 ####  |			$fa6a (g)
	.byte	$81 ; |#		#|			$fa6b (g)
	.byte	$5a ; | # ## # |			$fa6c (g)
	.byte	$3c ; |	 ####  |			$fa6d (g)
	.byte	$3c ; |	 ####  |			$fa6e (g)
	.byte	$38 ; |	 ###   |			$fa6f (g)
	.byte	$18 ; |		##   |			$fa70 (g)
	.byte	$00 ; |		|			$fa71 (g)



	.byte	$10,$10,$00,$f0,$f0,$00,$10,$00 ; $fa72 (*)
	.byte	$10,$10,$00,$f0,$00,$10,$10,$00 ; $fa7a (*)
	.byte	$10,$00,$f0,$f0,$00,$f0,$f0,$00 ; $fa82 (*)
	.byte	$f0,$f0,$00,$10,$10,$00,$f0		; $fa8a (*)

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
	.byte	$00 ; |		|			$fb00 (g)
	.byte	$00 ; |		|			$fb01 (g)
	.byte	$00 ; |		|			$fb02 (g)
	.byte	$00 ; |		|			$fb03 (g)
	.byte	$00 ; |		|			$fb04 (g)
	.byte	$00 ; |		|			$fb05 (g)
	.byte	$00 ; |		|			$fb06 (g)
	.byte	$00 ; |		|			$fb07 (g)

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


	.byte	$14 ; |		# #  |			$fc00 (g)
	.byte	$3c ; |	 ####  |			$fc01 (g)
	.byte	$7e ; | ###### |			$fc02 (g)
	.byte	$00 ; |		|			$fc03 (g)
	.byte	$30 ; |	 ##	|			$fc04 (g)
	.byte	$38 ; |	 ###   |			$fc05 (g)
	.byte	$3c ; |	 ####  |			$fc06 (g)
	.byte	$3e ; |	 ##### |			$fc07 (g)
	.byte	$3f ; |	 ######|			$fc08 (g)
	.byte	$7f ; | #######|			$fc09 (g)
	.byte	$7f ; | #######|			$fc0a (g)
	.byte	$7f ; | #######|			$fc0b (g)
	.byte	$11 ; |		#		#|			$fc0c (g)
	.byte	$11 ; |		#		#|			$fc0d (g)
	.byte	$33 ; |	 ##	 ##|			$fc0e (g)
	.byte	$00 ; |		|			$fc0f (g)

	.byte	$14 ; |		# #  |			$fc10 (g)
	.byte	$3c ; |	 ####  |			$fc11 (g)
	.byte	$7e ; | ###### |			$fc12 (g)
	.byte	$00 ; |		|			$fc13 (g)
	.byte	$30 ; |	 ##	|			$fc14 (g)
	.byte	$38 ; |	 ###   |			$fc15 (g)
	.byte	$3c ; |	 ####  |			$fc16 (g)
	.byte	$3e ; |	 ##### |			$fc17 (g)
	.byte	$3f ; |	 ######|			$fc18 (g)
	.byte	$7f ; | #######|			$fc19 (g)
	.byte	$7f ; | #######|			$fc1a (g)
	.byte	$7f ; | #######|			$fc1b (g)
	.byte	$22 ; |	 #	 # |			$fc1c (g)
	.byte	$22 ; |	 #	 # |			$fc1d (g)
	.byte	$66 ; | ##	## |			$fc1e (g)
	.byte	$00 ; |		|			$fc1f (g)

	.byte	$14 ; |		# #  |			$fc20 (g)
	.byte	$3c ; |	 ####  |			$fc21 (g)
	.byte	$7e ; | ###### |			$fc22 (g)
	.byte	$00 ; |		|			$fc23 (g)
	.byte	$30 ; |	 ##	|			$fc24 (g)
	.byte	$38 ; |	 ###   |			$fc25 (g)
	.byte	$3c ; |	 ####  |			$fc26 (g)
	.byte	$3e ; |	 ##### |			$fc27 (g)
	.byte	$3f ; |	 ######|			$fc28 (g)
	.byte	$7f ; | #######|			$fc29 (g)
	.byte	$7f ; | #######|			$fc2a (g)
	.byte	$7f ; | #######|			$fc2b (g)
	.byte	$44 ; | #	#  |			$fc2c (g)
	.byte	$44 ; | #	#  |			$fc2d (g)
	.byte	$cc ; |##  ##  |			$fc2e (g)
	.byte	$00 ; |		|			$fc2f (g)

	.byte	$14 ; |		# #  |			$fc30 (g)
	.byte	$3c ; |	 ####  |			$fc31 (g)
	.byte	$7e ; | ###### |			$fc32 (g)
	.byte	$00 ; |		|			$fc33 (g)
	.byte	$30 ; |	 ##	|			$fc34 (g)
	.byte	$38 ; |	 ###   |			$fc35 (g)
	.byte	$3c ; |	 ####  |			$fc36 (g)
	.byte	$3e ; |	 ##### |			$fc37 (g)
	.byte	$3f ; |	 ######|			$fc38 (g)
	.byte	$7f ; | #######|			$fc39 (g)
	.byte	$7f ; | #######|			$fc3a (g)
	.byte	$7f ; | #######|			$fc3b (g)
	.byte	$08 ; |	#   |			$fc3c (g)
	.byte	$08 ; |	#   |			$fc3d (g)
	.byte	$18 ; |		##   |			$fc3e (g)
	.byte	$00 ; |		|			$fc3f (g)


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
	dec		ObjectPosX,x				 
lfcf9
	ror								
	bcs		lfcfe					
	inc		ObjectPosX,x				 
lfcfe
	rts								

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



    .byte $80 ; |x       | $ff00

dev_name_2_gfx ;programmer's initials #2
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
	
	
dev_name_1_gfx
	.byte $07 ; |     xxx| $ff46
    .byte $01 ; |       x| $ff47
    .byte $57 ; | x x xxx| $ff48
    .byte $54 ; | x x x  | $ff49
    .byte $77 ; | xxx xxx| $ff4a
    .byte $50 ; | x x    | $ff4b
    .byte $50 ; | x x    | $ff4c

	
	

	.byte	$00,$00,$00 ; $ff4d (*)
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
lfff2
	.byte	$a4								; $fff2 (d)
	.byte	$15,$95,$06,$86,$f7				; $fff3 (*)
lfff8
	.byte	$00								; $fff8 (d)
	.byte	$00,$00,$f0						; $fff9 (*)
	.byte	$00,$f0							; $fffc (d)
	.byte	$00								; $fffe (*)
	.byte	$f0								; $ffff (*)
