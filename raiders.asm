	LIST OFF
; ***  R A I D E R S  O F  T H E  L O S T  A R K  ***
; Copyright 1982 Atari, Inc.
; Designer: Howard Scott Warshaw
; Artist:	Jerome Domurat

; Analyzed, labeled and commented
;  by Dennis Debro
; Last Update: Aug. 8, 2018
;
; Furthur coding and updates
;	by Halkun - 2025
;
;  *** ### BYTES OF RAM USED ### BYTES FREE
;  *** ### BYTES OF ROM FREE
;
; ==============================================================================
; = THIS REVERSE-ENGINEERING PROJECT IS BEING SUPPLIED TO THE PUBLIC DOMAIN		=
; = FOR EDUCATIONAL PURPOSES ONLY. THOUGH THE CODE WILL ASSEMBLE INTO THE		=
; = EXACT GAME ROM, THE LABELS AND COMMENTS ARE THE INTERPRETATION OF MY OWN	=
; = AND MAY NOT REPRESENT THE ORIGINAL VISION OF THE AUTHOR.					=
; =																				=
; = THE ASSEMBLED CODE IS � 1982, ATARI, INC.								  =
; =																				=
; ==============================================================================
;
; This is Howard Scott Warshaw's second game with Atari.

	processor 6502

;
; NOTE: You must compile this with vcs.h version 105 or greater.
;
TIA_BASE_READ_ADDRESS = $30			; set the read address base so this runs on
									; the real VCS and compiles to the exact
									; ROM image

	include macro.h
	include tia_constants.h
	include vcs.h

;
; Make sure we are using vcs.h version 1.05 or greater.
;
	IF VERSION_VCS < 105
	
	  echo ""
	  echo "*** ERROR: vcs.h file *must* be version 1.05 or higher!"
	  echo "*** Updates to this file, DASM, and associated tools are"
	  echo "*** available at https://github.com/munsie/dasm"
	  echo ""
	  err
	  
	ENDIF
;
; Make sure we are using macro.h version 1.01 or greater.
;
	IF VERSION_MACRO < 101

	  echo ""
	  echo "*** ERROR: macro.h file *must* be version 1.01 or higher!"
	  echo "*** Updates to this file, DASM, and associated tools are"
	  echo "*** available at https://github.com/munsie/dasm"
	  echo ""
	  err

	ENDIF
	
	LIST ON

;===============================================================================
; A S S E M B L E R - S W I T C H E S
;===============================================================================

NTSC					= 0
PAL50					= 1

TRUE					= 1
FALSE					= 0

	IFNCONST COMPILE_VERSION

COMPILE_VERSION			= NTSC		; change to compile for different regions

	ENDIF

	IF COMPILE_VERSION != NTSC && COMPILE_VERSION != PAL50

	  echo ""
	  echo "*** ERROR: Invalid COMPILE_VERSION value"
	  echo "*** Valid values: NTSC = 0, PAL50 = 1"
	  echo ""
	  err

	ENDIF

;===============================================================================
; F R A M E - T I M I N G S
;===============================================================================

	IF COMPILE_VERSION = NTSC

VBLANK_TIME				= 44
OVERSCAN_TIME			= 36

	ELSE

VBLANK_TIME				= 78
OVERSCAN_TIME			= 72

	ENDIF
	
;===============================================================================
; C O L O R - C O N S T A N T S
;===============================================================================

	IF COMPILE_VERSION = NTSC

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

	ELSE

BLACK					= $00
WHITE					= $0E
LT_RED					= $20
RED						= $40
ORANGE					= RED + 2
LT_BROWN				= $50
DK_GREEN				= LT_BROWN
DK_BLUE					= $70
DK_PINK					= $80
LT_BLUE					= $90
BLUE					= $D0
GREEN					= $E0
BROWN					= $F0

	ENDIF

;===============================================================================
; T I A - M U S I C	 C O N S T A N T S
;===============================================================================

SOUND_CHANNEL_SAW		= 1			; sounds similar to a saw waveform
SOUND_CHANNEL_ENGINE	= 3			; many games use this for an engine sound
SOUND_CHANNEL_SQUARE	= 4			; a high pitched square waveform
SOUND_CHANNEL_BASS		= 6			; fat bass sound
SOUND_CHANNEL_PITFALL	= 7			; log sound in pitfall, low and buzzy
SOUND_CHANNEL_NOISE		= 8			; white noise
SOUND_CHANNEL_LEAD		= 12		; lower pitch square wave sound
SOUND_CHANNEL_BUZZ		= 15		; atonal buzz, good for percussion

LEAD_E4					= 15
LEAD_D4					= 17
LEAD_C4_SHARP			= 18
LEAD_A3					= 23
LEAD_E3_2				= 31
 
;===============================================================================
; U S E R - C O N S T A N T S
;===============================================================================

BANK0TOP				= $1000
BANK1TOP				= $2000

BANK0_REORG				= $D000
BANK1_REORG				= $F000

BANK0STROBE				= $FFF8
BANK1STROBE				= $FFF9

LDA_ABS					= $AD		; instruction to LDA $XXXX
JMP_ABS					= $4C		; instruction for JMP $XXXX

INIT_SCORE				= 100		; starting score

SET_PLAYER_0_COLOR		= %10000000
SET_PLAYER_0_HMOVE		= %10000001

XMAX					= 160
; screen id values

ID_TREASURE_ROOM		= 0 ;--
ID_MARKETPLACE			= 1 ; |
ID_ENTRANCE_ROOM		= 2 ; |
ID_BLACK_MARKET			= 3 ; | -- JumpIntoStationaryPlayerKernel
ID_MAP_ROOM				= 4 ; |
ID_MESA_SIDE			= 5 ;--

ID_TEMPLE_ENTRANCE		= 6 ;--
ID_SPIDER_ROOM			= 7 ; |
ID_ROOM_OF_SHINING_LIGHT = 8; | -- DrawPlayfieldKernel
ID_MESA_FIELD			= 9 ; |
ID_VALLEY_OF_POISON		= 10;--

ID_THIEVES_DEN			= 11;-- ThievesDenWellOfSoulsScanlineHandler
ID_WELL_OF_SOULS		= 12;-- ThievesDenWellOfSoulsScanlineHandler
ID_ARK_ROOM				= 13

H_ARK_OF_THE_COVENANT	= 7
H_PEDESTAL				= 15
H_INDY_SPRITE			= 11
H_INVENTORY_SPRITES		= 8
H_PARACHUTE_INDY_SPRITE = 15
H_THIEF					= 16
H_KERNEL				= 160

ENTRANCE_ROOM_CAVE_VERT_POS = 9
ENTRANCE_ROOM_ROCK_VERT_POS = 53

MAX_INVENTORY_ITEMS		= 6
;
; Inventory Sprite Ids
;
ID_INVENTORY_EMPTY		= (EmptySprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_FLUTE		= (InventoryFluteSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_PARACHUTE	= (InventoryParachuteSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_COINS		= (InventoryCoinsSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_MARKETPLACE_GRENADE	= (MarketplaceGrenadeSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_BLACK_MARKET_GRENADE = (BlackMarketGrenadeSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_KEY		= (InventoryKeySprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_WHIP		= (InventoryWhipSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_SHOVEL		= (InventoryShovelSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_REVOLVER	= (InventoryRevolverSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_HEAD_OF_RA = (InventoryHeadOfRaSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_TIME_PIECE = (InventoryTimepieceSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_ANKH		= (InventoryAnkhSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_CHAI		= (InventoryChaiSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_HOUR_GLASS = (InventoryHourGlassSprite - InventorySprites) / H_INVENTORY_SPRITES

;
; Room State Values
;

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

; bullet or whip status values
BULLET_OR_WHIP_ACTIVE = %10000000

USING_GRENADE_OR_PARACHUTE = %00000010

;============================================================================
; Z P - V A R I A B L E S
;============================================================================
	SEG.U variables
	.org $80
	
scanline				ds 1							;= $80
currentScreenId			ds 1							;= $81
frameCount				ds 1							;= $82
secondsTimer			ds 1							;= $83
bankSwitchingVariables	ds 6							;= $84($84 - $89)
;--------------------------------------
bankSwitchLDAInstruction = bankSwitchingVariables		;= $84
bankStrobeAddress		= bankSwitchingVariables + 1	;= $85
bankSwitchJMPInstruction = bankStrobeAddress + 2		;= $86
bankSwitchJMPAddress	= bankSwitchJMPInstruction + 1	;= $87
;--------------------------------------
loopCount				= bankSwitchingVariables		;= $84
tempCharHolder			= bankStrobeAddress				;= $85
zp_88					= $88							;= $88
zp_89					= $89							;= $89
playerInput					ds 1							;= $8A
zp_8B					= $8B							;= $89
zp_8C					= $8C							;= $89
zp_8D					= $8D							;= $89
zp_8E					= $8E							;= $89

bulletOrWhipStatus		= $8F

playfieldControl		= $94
pickupStatusFlags 		= $95

grenadeDetinationTime	= $9B
resetEnableFlag					= $9C
majorEventFlag			= $9D
adventurePoints			= $9E
lives					= $9F
numberOfBullets			= $A0

grenadeOpeningPenalty	= $A5
escapedShiningLightPenalty = $A6
findingArkBonus			= $A7
usingParachuteBonus		= $A8

skipToMesaFieldBonus	= $A9
findingYarEasterEggBonus = $AA
usingHeadOfRaInMapRoomBonus = $AB
shootingThiefPenalty	= $AC
landingInMesaBonus		= $AD

entranceRoomState		= $B1
blackMarketState		= $B2

inventoryGraphicPointers = $B7		; $B7 - $C2
selectedInventoryIndex	= $C3
numberOfInventoryItems	= $C4
selectedInventoryId		= $C5
basketItemsStatus		= $C6
pickupItemsStatus		= $C7
objectHorizPositions	= $C8
;--------------------------------------

indyHorizPos			= objectHorizPositions + 1 ;$C9

bulletOrWhipHorizPos	= objectHorizPositions + 3 ;$CB

objectVertPositions		= $CE
;--------------------------------------
topObjectVertPos		= objectVertPositions
;--------------------------------------
shiningLightVertPos		= objectVertPositions
indyVertPos				= objectVertPositions + 1 ;$CF
missile0VertPos			= objectVertPositions + 2 ;$D0
bulletOrWhipVertPos		= objectVertPositions + 3; $D1

snakeVertPos			= objectVertPositions + 7 ;$D5
timePieceGraphicPointers = $D6		; $D6 - D7
;--------------------------------------
player0ColorPointers	= timePieceGraphicPointers

indyGraphicPointers		= $D9		; $D9 - $DA
indySpriteHeight		= $DB
player0SpriteHeight		= $DC
player0GraphicPointers	= $DD		; $DD - $DE
thievesDirectionAndSize = $DF		; $DF - $E2
;--------------------------------------
bottomObjectVertPos		= thievesDirectionAndSize
;--------------------------------------
whipVertPos				= bottomObjectVertPos
;--------------------------------------
shovelVertPos			= whipVertPos
player0TIAPointers		= $E1		; $E1 - $E4
;--------------------------------------
player0ColorPointer		= player0TIAPointers
player0FineMotionPointer = player0ColorPointer + 2
;--------------------------------------
pf1GraphicPointers		= player0ColorPointer; $E1 - $E2
pf2GraphicPointers		= player0FineMotionPointer; $E3 - $E4
thievesHMOVEIndex		= $E5		; $E5 - $E8
;--------------------------------------
dungeonGraphics			= thievesHMOVEIndex ; $E5 - $EA
;--------------------------------------
topOfDungeonGraphic		= dungeonGraphics

thievesHorizPositions	= $EE		; $EE - $F1

	echo "***",(*-$80 - 2)d, "BYTES OF RAM USED", ($100 - * + 2)d, "BYTES FREE"
	
;===============================================================================
; R O M - C O D E  (BANK 0)
;===============================================================================

	SEG Bank0
	.org BANK0TOP
	.rorg BANK0_REORG
	
	lda BANK0STROBE
	jmp Start
	
HorizontallyPositionObjects
	ldx #<RESBL - RESP0
.moveObjectLoop
	sta WSYNC						; wait for next scan line
	lda objectHorizPositions,x		; get object's horizontal position
	tay
	lda HMOVETable,y				; get fine motion/coarse position value
	sta HMP0,x						; set object's fine motion value
	and #$0F						; mask off fine motion value
	tay								; move coarse move value to y
.coarseMoveObject
	dey
	bpl .coarseMoveObject
	sta RESP0,x						; set object's coarse position
	dex
	bpl .moveObjectLoop
	sta WSYNC						; wait for next scan line
	sta HMOVE
	jmp JumpToDisplayKernel
	
CheckObjectCollisions
	bit CXM1P						; check player collision with Indy bullet
	bpl .checkPlayfieldCollisionWithBulletOrWhip; branch if no player collision
	ldx currentScreenId				; get the current screen id
	cpx #ID_VALLEY_OF_POISON
	bcc .checkPlayfieldCollisionWithBulletOrWhip
	beq .indyShootHitThief			; branch if Indy in the Valley of Poison
	lda bulletOrWhipVertPos			; Indy in Theives Den or Well of Souls
	adc #2 - 1						; carry set here
	lsr								; divide value by 16 (i.e. H_THIEF)
	lsr
	lsr
	lsr
	tax
	lda #REFLECT
	eor thievesDirectionAndSize,x	; change the direction of the Thief
	sta thievesDirectionAndSize,x
.indyShootHitThief
	lda bulletOrWhipStatus			; get bullet or whip status
	bpl .setPenaltyForShootingThief	; branch if bullet or whip not active
	and #~BULLET_OR_WHIP_ACTIVE		;
	sta bulletOrWhipStatus			; clear BULLET_OR_WHIP_ACTIVE bit
	lda pickupStatusFlags 
	and #%00011111		  			;if 0,32,64,96,128,160,192,224 
	beq FinalizeItemPickup	  		;skip adding to inventory 
	jsr PlaceItemInInventory
	
FinalizeItemPickup:
	lda #%01000000		  ;2
	sta pickupStatusFlags 
.setPenaltyForShootingThief
	lda #~BULLET_OR_WHIP_ACTIVE		;
	sta bulletOrWhipVertPos			; clear BULLET_OR_WHIP_ACTIVE bit
	lda #PENALTY_SHOOTING_THIEF
	sta shootingThiefPenalty		; penalize player for shooting a thief
.checkPlayfieldCollisionWithBulletOrWhip
	bit CXM1FB						; check missile 1 and playfield collisions
	bpl CheckIfIndyShotSnake			; branch if no missile and playfield collision
	ldx currentScreenId				; get the current screen id
	cpx #ID_MESA_FIELD
	beq CheckIndyCollisionWithSnakeOrTimePiece; branch if in the Mesa field
	cpx #ID_TEMPLE_ENTRANCE
	beq impactOnDungeonWall	  ;2
	cpx #ID_ROOM_OF_SHINING_LIGHT
	bne CheckIfIndyShotSnake
impactOnDungeonWall:
	lda bulletOrWhipVertPos			; get bullet or whip vertical position
	sbc $D4							; subtract snake/dungeon Y
	lsr								; divide by 4 total
	lsr
	beq HandleWallImpactLeftSide	; branch if result is zero
	tax
	ldy bulletOrWhipHorizPos		; get bullet or whip horizontal position
	cpy #$12
	bcc ClearWhipBulletState						; branch if too far left
	cpy #141
	bcs ClearWhipBulletState						; branch if too far right
	lda #$00		
	sta thievesHMOVEIndex,x			; zero out thief movement
	beq ClearWhipBulletState						; unconditional branch
	
HandleWallImpactLeftSide:
	lda bulletOrWhipHorizPos	; get bullet or whip horizontal position
	cmp #48 					; Compare it to 48 (left side boundary threshold)
	bcs HandleWallImpactRighttSide					; If bullet is at or beyond 48, branch to right-side logic)
	sbc #16 					; Subtract 16 from position (adjusting to fit into the masking table index range)
	eor #$1F					; XOR with 31 to mirror or normalize the range (helps align to bitmask values)

MaskOutDungeonWallSegment:
	lsr			  ; Divide by 4 Total
	lsr			  ;
	tax			  ; Move result to X to use as index into mask table
	lda ItemStatusClearMaskTable,x	  ; Load a mask value from the ItemStatusClearMaskTable table (mask used to disable a wall segment)
	and topOfDungeonGraphic ; Apply the mask to the current dungeon graphic state (clear bits to "erase" part of it)
	sta topOfDungeonGraphic ; Store the updated graphic state back (modifying visual representation of the wall)
	jmp ClearWhipBulletState
	
HandleWallImpactRighttSide:
	sbc #113	; Subtract 113 from bullet/whip horizontal position
	cmp #32		; Compare result to 32
	bcc MaskOutDungeonWallSegment 	;apply wall mask
ClearWhipBulletState:
	ldy #~BULLET_OR_WHIP_ACTIVE		; Invert BULLET_OR_WHIP_ACTIVE	
	sty bulletOrWhipStatus			; clear BULLET_OR_WHIP_ACTIVE status
	sty bulletOrWhipVertPos			; set vertical position out of range
CheckIfIndyShotSnake
	bit CXM1FB						; check if snake hit with bullet or whip
	bvc CheckIndyCollisionWithSnakeOrTimePiece; branch if snake not hit
	bit $93		  ;3
	bvc CheckIndyCollisionWithSnakeOrTimePiece
	lda #$5A		  ;2
	sta $D2		  ;3
	sta $DC		  ;3
	sta bulletOrWhipStatus			; clear BULLET_OR_WHIP_ACTIVE status
	sta bulletOrWhipVertPos
CheckIndyCollisionWithSnakeOrTimePiece
	bit CXP1FB						; check Indy collision with ball
	bvc CheckIfIndyEnteringWellOfSouls; branch if Indy didn't collide with ball
	ldx currentScreenId				; get the current screen id
	cpx #ID_TEMPLE_ENTRANCE
	beq .indyTouchingTimePiece
	lda selectedInventoryId			; get the current selected inventory id
	cmp #ID_INVENTORY_FLUTE
	beq CheckIfIndyEnteringWellOfSouls; branch if the Flute is selected
	bit $93		  ;3
	bpl SetWellOfSoulsEntryFlag	  ;2
	lda secondsTimer			;3
	and #$07		  ;2
	ora #$80		  ;2
	sta $A1		  ;3
	bne CheckIfIndyEnteringWellOfSouls; unconditional branch
	
SetWellOfSoulsEntryFlag:
	bvc CheckIfIndyEnteringWellOfSouls
	lda #$80		  ;2
	sta majorEventFlag 	  ;3
	bne CheckIfIndyEnteringWellOfSouls; unconditional branch
	
.indyTouchingTimePiece
	lda timePieceGraphicPointers
	cmp #<TimeSprite
	bne CheckIfIndyEnteringWellOfSouls
	lda #ID_INVENTORY_TIME_PIECE
	jsr PlaceItemInInventory
CheckIfIndyEnteringWellOfSouls
	ldx #ID_MESA_SIDE
	cpx currentScreenId
	bne CheckAndDispatchCollisions						; branch if Indy not in MESA_SIDE
	bit CXM0P						; check missile 0 and player collisions
	bpl CheckIfIndyFallsIntoValley						; branch if Indy not entering WELL_OF_SOULS
	stx indyVertPos					; set Indy vertical position (i.e. x = 5)
	lda #ID_WELL_OF_SOULS
	sta currentScreenId				; move Indy to the Well of Souls
	jsr InitializeScreenState
	lda #(XMAX / 2) - 4
	sta indyHorizPos					; place Indy in horizontal middle
	bne .clearCollisionRegisters		; unconditional branch
	
CheckIfIndyFallsIntoValley:
	ldx indyVertPos					; get Indy's vertical position
	cpx #$4F		  ; Compare it to 0x4F (79 in decimal)
	bcc CheckAndDispatchCollisions	 ; If Indy is above this threshold, branch to CheckAndDispatchCollisions (don't fall)
	lda #ID_VALLEY_OF_POISON ; Otherwise, load the screen ID for the Valley of Poison
	sta currentScreenId ; Set the current screen to Valley of Poison
	jsr InitializeScreenState ; Initialize that screen's data (graphics, objects, etc.)
	lda $EB		  ; Load saved vertical position? (context-dependent, possibly return point)
	sta $DF		  ; Save it as object vertical state? Possibly thief state
	lda $EC		  ; Load saved vertical position (likely for Indy)
	sta indyVertPos		  ; Set Indy's vertical position
	lda $ED		  ; Load saved horizontal position
	sta indyHorizPos			; Set Indy's horizontal position
	lda #$FD		  ; Load bitmask value
	and $B4		  ; Apply bitmask to a status/control flag
	sta $B4		  ; Store the result back
	bmi .clearCollisionRegisters ; If the result has bit 7 set, skip setting major event flag
	lda #$80		  ; Otherwise, set major event flag
	sta majorEventFlag 	  ;3
.clearCollisionRegisters
	sta CXCLR						; clear all collisions
CheckAndDispatchCollisions:
	bit CXPPMM						; check player / missile collisions
	bmi .branchToPlayerCollisionRoutine			;branch if players collided
	ldx #$00		  ;2
	stx $91		  ; Clear temporary state or flags at $91
	dex			  ; X = $FF
	stx $97		  ; Set $97 to $FF
	rol pickupStatusFlags 
	clc			  ;2
	ror pickupStatusFlags 
ContinueToCollisionDispatch:
	jmp	 HandleScreenCollisions	  ;3
	
.branchToPlayerCollisionRoutine
	lda currentScreenId				; get the current screen id
	bne .jmpToPlayerCollisionRoutine ; branch if not Treasure Room
	lda $AF		  ;3
	and #7
	tax
	lda MarketBasketItems,x			; get items from market basket
	jsr PlaceItemInInventory			; place basket item in inventory
	bcc ContinueToCollisionDispatch	  ;2
	lda #$01		  ;2
	sta $DF		  ;3
	bne ContinueToCollisionDispatch						; unconditional branch
	
.jmpToPlayerCollisionRoutine
	asl								; multiply screen id by 2
	tax
	lda PlayerCollisionJumpTable + 1,x
	pha								; push MSB to stack
	lda PlayerCollisionJumpTable,x
	pha								; push LSB to stack
	rts								; jump to player collision routine

PlayerCollisionsInWellOfSouls
	lda indyVertPos					; get Indy's vertical position
	cmp #63   ; Compare it to 63
	bcc .takeAwayShovel				; If Indy is above this threshold, he hasn't reached the Ark yet � take away shovel
	lda $96		  ; Load ??? (likely object Y or frame state)
	cmp #$54		  ; Compare to $54 (possibly a specific animation frame or position)
	bne ResumeCollisionDispatch	  ; If not equal, nothing special happens
	lda $8C		  ; Load value at $8C (possibly Ark X position)
	cmp $8B		  ; Compare to Indy's X position (presumed)
	bne .arkNotFound   ; If not lined up with the Ark, skip the win logic
	lda #INIT_SCORE - 12   ; Load final score (INIT_SCORE minus penalty or adjustment)
	sta resetEnableFlag   ; Store it to temp score storage
	sta adventurePoints   ; Set the player�s final adventure score
	jsr DetermineFinalScore  ; Calculate ranking/title based on score
	lda #ID_ARK_ROOM  ; Set up transition to Ark Room
	sta currentScreenId
	jsr InitializeScreenState   ; Load new screen data for the Ark Room
	jmp VerticalSync   ; Finish frame cleanly and transition visually
	
.arkNotFound
	jmp PlaceIndyInMesaSide
	
.takeAwayShovel
	lda #ID_INVENTORY_SHOVEL
	bne .takeItemFromInventory		; check to remove shovel from inventory
	
PlayerCollisionsInThievesDen
	lda #ID_INVENTORY_KEY
	bne .takeItemFromInventory		; check to remove key from inventory
	
PlayerCollisionsInValleyOfPoison
	lda #ID_INVENTORY_COINS
.takeItemFromInventory
	bit pickupStatusFlags 
	bmi ResumeCollisionDispatch	  ;2
	clc
	jsr TakeItemFromInventory		; carry clear...take away specified item
	bcs UpdateStateAfterItemRemoval	  ;2
	sec
	jsr TakeItemFromInventory		; carry set...take away selected item
	bcc ResumeCollisionDispatch	  ;2
UpdateStateAfterItemRemoval:
	cpy #$0B		  ;2
	bne SetPickupProcessedFlag	  ;2
	ror blackMarketState				; rotate Black Market state right
	clc								; clear carry
	rol blackMarketState				; rotate left to show Indy not carrying Shovel
SetPickupProcessedFlag:
	lda pickupStatusFlags 
	jsr	 UpdateRoomEventState	  ;6
	tya			  ;2
	ora #$C0		  ;2
	sta pickupStatusFlags 
	bne ResumeCollisionDispatch						; unconditional branch
	
PlayerCollisionsInSpiderRoom
	ldx #$00		  ; Set X to 0
	stx $B6		  ; Clear memory location $B6 � likely a state tracker or script phase
	lda #$80		  ; Load A with 0x80 (10000000 binary)
	sta majorEventFlag 	  ; Set major event flag � likely triggers spider cutscene or scripted logic

ResumeCollisionDispatch:
	jmp	 HandleScreenCollisions	  ; Resume standard game logic by dispatching screen-specific behavior
	
PlayerCollisionsInMesaSide
	bit $B4		  ;Check event state flags
	bvs ContinueGameAfterParachute	  ;If bit 6 is set, skip parachute logic and resume normal game loop
	bpl ContinueGameAfterParachute	  ; If bit 7 is clear, also skip parachute logic
	lda indyHorizPos			; Get Indy's horizontal position
	cmp #$2B		  ; Check if Indy is within parachute landing zone (left bound)
	bcc RemoveParachuteAfterLanding	  ; If left of zone, remove parachute and exit
	ldx indyVertPos					; get Indy's vertical position
	cpx #39 ; Check if he is high enough
	bcc RemoveParachuteAfterLanding	  ; If not, remove parachute and exit
	cpx #43 ; Check if he is too low
	bcs RemoveParachuteAfterLanding	  ; If so, remove parachute and exit 
	lda #$40		  ; Bitmask to clear parachute state
	ora $B4		  ; Set that bit in event flag
	sta $B4		  ;  Store it back
	bne ContinueGameAfterParachute						; Unconditionally resume normal flow
RemoveParachuteAfterLanding:
	lda #ID_INVENTORY_PARACHUTE
	sec
	jsr TakeItemFromInventory		; carry set...take away selected item
ContinueGameAfterParachute:
	jmp	 HandleScreenCollisions	  ;3
	
PlayerCollisionsInMarketplace
	bit CXP1FB						; check Indy collision with playfield
	bpl .indyTouchingMarketplaceBaskets   ; If not colliding, skip handling basket logic
	ldy indyVertPos					; get Indy's vertical position
	cpy #$3A		  ; Is Indy above vertical threshold (row $3A)? 
	bcc CheckIndyVerticalForMarketplaceFlags	  ; If so, skip basket logic and jump to CheckIndyVerticalForMarketplaceFlags
	lda #$E0		  ;2
	and $91		  ; Mask $91 to clear bits 0�4 (preserve upper 3 bits)
	ora #$43		   ; Set bits 6, 1, and 0 (binary: 01000011)
	sta $91		  ; Update $91 with masked and set bits
	jmp	 HandleScreenCollisions	  ;3
	
CheckIndyVerticalForMarketplaceFlags:
	cpy #$20		  ; Compare Indy's vertical position to $20 (decimal 32)
	bcc SetMarketplaceFlagsIfInRange	  ; If Y < $20, jump to SetMarketplaceFlagsIfInRange (top of screen zone)
ClearMarketplaceFlags:
	lda #$00		  
	sta $91		   ; Clear all bits in status/control byte at $91
	jmp	 HandleScreenCollisions	  ; Resume main collision logic
	
SetMarketplaceFlagsIfInRange:
	cpy #$09		   ; Compare Indy's vertical position to $09
	bcc ClearMarketplaceFlags	  ; If Y < $09, also clear $91 and exit
	lda #$E0		  ;2
	and $91		  ; Mask out lower bits of $91 (preserve only top 3 bits)
	ora #$42		  ; Set bits 6 and 1 (binary 01000010)
	sta $91		  ; Write the updated value back to $91
	jmp	 HandleScreenCollisions	  ; Resume main collision logic
	
.indyTouchingMarketplaceBaskets
	lda indyVertPos					; get Indy's vertical position
	cmp #$3A		  ;2
	bcc .indyNotTouchingBottomBasket; branch if Indy not colliding with bottom basket
	ldx #ID_INVENTORY_KEY
	bne AttemptToAwardHeadOfRa						; unconditional branch
	
.indyNotTouchingBottomBasket
	lda indyHorizPos					; get Indy's horizontal position
	cmp #$4C		  ;2
	bcs .indyTouchingRightBasket		; branch if Indy collided with right basket
	ldx #ID_MARKETPLACE_GRENADE
	bne AttemptToAwardHeadOfRa						; unconditional branch
	
.indyTouchingRightBasket
	ldx #ID_INVENTORY_REVOLVER
AttemptToAwardHeadOfRa:
	lda #$40		  ;2
	sta $93		  ; Set $93 to $40 � likely a flag for screen-specific event (e.g. "Ra beam active")
	lda secondsTimer					; get the seconds timer value
	and #$1F		; Mask to 5 bits (mod 32) � repeat every 32 seconds
	cmp #2  ; Compare with 2 (trigger window)
	bcs .checkToAddItemToInventory  ; If >= 2, skip setting default item
	ldx #ID_INVENTORY_HEAD_OF_RA  ; If < 2, set item to "Head of Ra"
.checkToAddItemToInventory
	jsr DetermineIfItemAlreadyTaken  ; See if the selected item is already in the inventory
	bcs ExitGiveItemRoutine						; branch if item already taken
	txa								; move potential inventory item to accumualtor
	jsr PlaceItemInInventory
ExitGiveItemRoutine:
	jmp	 HandleScreenCollisions	  ;3

PlayerCollisionsInBlackMarket
	bit CXP1FB						; check Indy collision with playfield
	bmi CheckIndyPositionForMarketFlags						; branch if Indy collided with playfield
	lda indyHorizPos					; get Indy's horizontal position
	cmp #$50		  ;2
	bcs ChooseMarketplaceItemByTime	  ;2
	dec indyHorizPos					; move Indy left one pixel
	rol blackMarketState				; rotate Black Market state left
	clc								; clear carry
	ror blackMarketState				; rotate right to show Indy carrying coins
ResetScreenInteractionFlags:
	lda #$00		  ;2
	sta $91		  ;3
ResumeScreenLogic:
	jmp	 HandleScreenCollisions	  ;3
	
ChooseMarketplaceItemByTime:
	ldx #ID_BLACK_MARKET_GRENADE  ; Load X with the grenade item ID (for black market)
	lda secondsTimer  ; Load the global seconds timer
	cmp #$40		  ; Check if >= 64 seconds have passed
	bcs .checkToAddItemToInventory  ;If yes, continue with grenade
	ldx #ID_INVENTORY_KEY  ; If not, switch to the key as the item to give
	bne .checkToAddItemToInventory	; Always branch (unconditional jump)
	
CheckIndyPositionForMarketFlags:
	ldy indyVertPos					; get Indy's vertical position
	cpy #68
	bcc CheckMiddleMarketZone	  ; If Indy is above row 68, jump to alternate logic
	lda #$E0		  ;2
	and $91		  ; Mask $91 to preserve top 3 bits 
	ora #$0B		  ; Set bits 0, 1, and 3 (00001011) 
ApplyBlackMarketInteractionFlags:
	sta $91		  ; Store the updated value back into $91
	bne ResumeScreenLogic						 ; Always branch to resume game logic
	
CheckMiddleMarketZone:
	cpy #32
	bcs ResetScreenInteractionFlags	  ; If Y = 32, exit via reset logic
	cpy #11
	bcc ResetScreenInteractionFlags	  ; If Y < 11, exit via reset logic
	lda #$E0		  ;2
	and $91		  ;3
	ora #$41		   ; Set bits 6 and 0 (01000001)
	bne ApplyBlackMarketInteractionFlags						; Go apply and resume logic
	
PlayerCollisionsInTempleEntrance
	inc indyHorizPos			;5
	bne HandleScreenCollisions	  ;2
	
PlayerCollisionsInEntranceRoom
	lda indyVertPos					; get Indy's vertical position
	cmp #63
	bcc CheckVerticalTriggerRange						; branch if Indy above whip location
	lda #ID_INVENTORY_WHIP
	jsr PlaceItemInInventory
	bcc HandleScreenCollisions						; branch if no room to place item
	ror entranceRoomState			; rotate entrance room state right
	sec								; set carry flag
	rol entranceRoomState			; rotate left to show Whip taken by Indy
	lda #66
	sta whipVertPos
	bne HandleScreenCollisions						; unconditional branch
	
CheckVerticalTriggerRange:
	cmp #22  ; Compare A (probably Indy's vertical position) to 22
	bcc PushIndyLeftOutOfTriggerZone	  ; If A < 22, jump to PushIndyLeftOutOfTriggerZone 
	cmp #31  ; Compare A to 31
	bcc HandleScreenCollisions	 ; If A < 31, resume normal logic 
PushIndyLeftOutOfTriggerZone:
	dec indyHorizPos					; move Indy to the left one pixel
HandleScreenCollisions:
	lda currentScreenId				; get the current screen id
	asl								; multiply screen id by 2 (since each jump table entry is 2 bytes: low byte, high byte)
	tax  ; Move the result to X � now X is the index into a jump table
	bit CXP1FB						; check Indy collision with playfield
	bpl DispatchScreenIdleHandler						; If no collision (bit 7 is clear), branch to non-collision handler 
	lda PlayerPlayfieldCollisionJumpTable + 1,x  ; Load high byte of handler address
	pha  ; Push it to the return stack  
	lda PlayerPlayfieldCollisionJumpTable,x    ; Load low byte of handler address
	pha   ; Push it to the return stack
	rts								; jump to Player / Playfield collision strategy

DispatchScreenIdleHandler:
	lda RoomIdleHandlerJumpTable+1,x	; Load high byte of default screen behavior routine
	pha			  
	lda RoomIdleHandlerJumpTable,x	  ; Load low byte of default screen behavior routine
	pha			  ;3
	rts			  ; Indirect jump to it (no collision case)

WarpToMesaSide:
	lda $DF		  ; Load vertical position of an object (likely thief or Indy)
	sta $EB		  ; Store it to temp variable $EB (could be thief vertical position)
	lda indyVertPos					; get Indy's vertical position
	sta $EC		  ; Store to temp variable $EC
	lda indyHorizPos			;3
SaveIndyAndThiefPosition:
	sta $ED		  ; Store to temp variable $ED 
PlaceIndyInMesaSide
	lda #ID_MESA_SIDE ; Change screen to Mesa Side
	sta currentScreenId
	jsr InitializeScreenState
	lda #$05		  ;2
	sta indyVertPos		  ; Set Indy's vertical position on entry to Mesa Side
	lda #$50		  ;2
	sta indyHorizPos			; Set Indy's horizontal position on entry
	tsx			  ;2
	cpx #$FE		  ;2
	bcs FailSafeToCollisionCheck	   ;If X = $FE, jump to FailSafeToCollisionCheck (possibly collision or restore logic)
	rts			  ; Otherwise, return

FailSafeToCollisionCheck:
	jmp CheckIfIndyShotOrTouchedByTsetseFlies
	
InitFallbackEntryPosition:
	bit $B3		  ; Check status bits � unknown purpose, possibly related to event or room state
	bmi FailSafeToCollisionCheck	  ; If bit 7 of $B3 is set, jump to collision handler (fail-safe)
	lda #$50		  ;2
	sta $EB		  ; Store a fixed vertical position into $EB (likely a respawn or object Y pos)
	lda #$41		  ;2
	sta $EC		 ; Store a fixed vertical position for Indy
	lda #$4C		  ;2
	bne SaveIndyAndThiefPosition						; Store fixed horizontal position and continue to position saving logic
	
RestrictIndyMovementInTemple:
	ldy indyHorizPos			;3
	cpy #$2C		  ; Is Indy too far left? (< 44)
	bcc nudgeRight	  ; Yes, nudge him right
	cpy #$6B		  ; Is Indy too far right? (= 107)
	bcs nudgeLeft	  ; Yes, nudge him left
	ldy indyVertPos					; get Indy's vertical position
	iny			  ; Try to move Indy down 1 px
	cpy #$1E		 ; Cap at vertical position 30
	bcc setVert	   ; If not over, continue
	dey			  ;2
	dey			  ;2  ; Else, move Indy up 1 px instead
setVert:
	sty indyVertPos		  ; Apply vertical adjustment
	jmp	 SetIndyToNormalMovementState	  ; Continue to Indy-snake interaction check
	
nudgeRight:
	iny			   
	iny			  ; Nudge Indy right 2 px
nudgeLeft:
	dey			  
	sty indyHorizPos			; Apply horizontal adjustment
	bne SetIndyToNormalMovementState						; Continue
	
IndyPlayfieldCollisionInEntranceRoom
	lda #GRENADE_OPENING_IN_WALL
	and entranceRoomState
	beq .moveIndyLeftOnePixel		; branch if wall opeing not present
	lda indyVertPos					; get Indy's vertical position
	cmp #18
	bcc .moveIndyLeftOnePixel		; branch if Indy not entering opening
	cmp #36
	bcc SlowDownIndyMovement			; branch if Indy entering opening
.moveIndyLeftOnePixel
	dec indyHorizPos					; move Indy left one pixel
	bne SetIndyToNormalMovementState						; unconditional branch
	
PlayerCollisionsInRoomOfShiningLight
	ldx #26
	lda indyHorizPos					; get Indy horizontal position
	cmp #76
	bcc .setIndyInDungeon			; branch if Indy on left of screen
	ldx #125
.setIndyInDungeon
	stx indyHorizPos					; set Indy horizontal position
	ldx #64
	stx indyVertPos					; set Indy vertical position
	ldx #$FF
	stx topOfDungeonGraphic			; restore dungeon graphics
	ldx #1
	stx dungeonGraphics + 1
	stx dungeonGraphics + 2
	stx dungeonGraphics + 3
	stx dungeonGraphics + 4
	stx dungeonGraphics + 5
	bne SetIndyToNormalMovementState						; unconditional branch
	
MoveIndyBasedOnInput:
	lda $92		  ; Load movement direction from input flags
	and #$0F		   ; Isolate lower 4 bits (D-pad direction)
	tay			  ; Use as index
	lda IndyMovementDeltaTable,y	   ; Get movement delta from direction lookup table
	ldx #<indyVertPos - objectVertPositions ; X = offset to Indy in object array
	jsr DetermineDirectionToMoveObject ; Move Indy accordingly
SetIndyToNormalMovementState:
	lda #$05		  
	sta $A2		  ; Likely sets a status or mode flag
	bne CheckIfIndyShotOrTouchedByTsetseFlies; unconditional branch
	
SlowDownIndyMovement
	rol playerInput
	sec
	bcs UndoInputBitShift						; unconditional branch
	
SetIndyToTriggeredState:
	rol playerInput
	clc			  ;2
UndoInputBitShift:
	ror playerInput
CheckIfIndyShotOrTouchedByTsetseFlies
	bit CXM0P						; check player collisions with missile0
	bpl CheckGrenadeDetonation						; branch if didn't collide with Indy
	ldx currentScreenId				; get the current screen id
	cpx #ID_SPIDER_ROOM ; Are we in the Spider Room?
	beq ClearInputBit0ForSpiderRoom	  ; Yes,  go to ClearInputBit0ForSpiderRoom
	bcc CheckGrenadeDetonation	   ; If screen ID is lower than Spider Room, skip 
	lda #$80		  ; Trigger a major event
	sta majorEventFlag 	  ;3
	bne DespawnMissile0						; unconditional branch
	
ClearInputBit0ForSpiderRoom:
	rol playerInput  ; Rotate input left, bit 7 ? carry
	sec			  ; Set carry (overrides carry from rol)
	ror playerInput  ; Rotate right, carry -> bit 7 (bit 0 lost)
	rol $B6		  ; Rotate a status byte left (bit 7 ? carry)
	sec			  ; Set carry (again overrides whatever came before)
	ror $B6		  ; Rotate right, carry -> bit 7 (bit 0 lost)
DespawnMissile0:
	lda #$7F		 
	sta $8E		  ; Possibly related state or shadow position
	sta missile0VertPos; Move missile0 offscreen (to y=127)
CheckGrenadeDetonation:
	bit $9A		 ; Check status flags
	bpl VerticalSync  ; If bit 7 is clear, skip (no grenade active?)
	bvs ApplyGrenadeWallEffect	  ; If bit 6 is set, jump (special case, maybe already exploded)
	lda secondsTimer					; get seconds time value
	cmp grenadeDetinationTime		; compare with grenade detination time
	bne VerticalSync					; branch if not time to detinate grenade
	lda #$A0		  ;2
	sta bulletOrWhipVertPos    ; Move bullet/whip offscreen (simulate detonation?)
	sta majorEventFlag 	   ; Trigger major event (explosion happened?)
ApplyGrenadeWallEffect:
	lsr $9A		   ; Logical shift right: bit 0 -> carry
	bcc SkipUpdate	  ; If bit 0 was clear, skip this (grenade effect not triggered)
	lda #GRENADE_OPENING_IN_WALL
	sta grenadeOpeningPenalty		; Apply penalty (e.g., reduce score)
	ora entranceRoomState
	sta entranceRoomState    ; Mark the entrance room as having the grenade opening
	ldx #ID_ENTRANCE_ROOM
	cpx currentScreenId
	bne UpdateEntranceRoomEventState		; branch if not in the ENTRANCE_ROOM
	jsr InitializeScreenState   ; Update visuals/state to reflect the wall opening
UpdateEntranceRoomEventState:
	lda $B5		  ;3
	and #$0F		  
	beq SkipUpdate	  ; If no condition active, exit
	lda $B5		   
	and #$F0		  ; Clear lower nibble
	ora #$01		   ; Set bit 0 (indicate some triggered state)
	sta $B5		  ; Store updated state
	ldx #ID_ENTRANCE_ROOM
	cpx currentScreenId
	bne SkipUpdate						; branch if not in the ENTRANCE_ROOM
	jsr InitializeScreenState		; Refresh screen visuals
SkipUpdate:
	sec
	jsr TakeItemFromInventory		; carry set...take away selected item
VerticalSync
.waitTime
	lda INTIM
	bne .waitTime
StartNewFrame
	lda #START_VERT_SYNC
	sta WSYNC						; wait for next scan line
	sta VSYNC						; start vertical sync (D1 = 1)
	lda #$50
	cmp bulletOrWhipVertPos
	bcs UpdateFrameAndSecondsTimer
	sta bulletOrWhipHorizPos
UpdateFrameAndSecondsTimer:
	inc frameCount					; increment frame count
	lda #$3F
	and frameCount
	bne .firstLineOfVerticalSync		; branch if roughly 60 frames haven't passed
	inc secondsTimer					; increment every second
	lda $A1								; If $A1 is positive, skip
	bpl .firstLineOfVerticalSync
	dec $A1								; Else, decrement it
.firstLineOfVerticalSync
	sta WSYNC							; Wait for start of next scanline
	bit resetEnableFlag
	bpl .continueVerticalSync
	ror SWCHB						; rotate RESET to carry
	bcs .continueVerticalSync		; branch if RESET not pressed
	jmp Start						 ; If RESET was pressed, restart the game
	
.continueVerticalSync
	sta WSYNC						 ; Sync with scanline (safely time video registers)
	lda #STOP_VERT_SYNC
	ldx #VBLANK_TIME
	sta WSYNC						; last line of vertical sync
	sta VSYNC						; end vertical sync (D1 = 0)
	stx TIM64T						; set timer for vertical blanking period
	ldx $9D
	inx			   ; Increment counter
	bne CheckToShowDeveloperInitials  ; If not overflowed, check initials display
	stx majorEventFlag 	  ; Overflowed: zero -> set majorEventFlag to 0
	jsr DetermineFinalScore  ; Call final score calculation
	lda #ID_ARK_ROOM
	sta currentScreenId
	jsr InitializeScreenState ; Transition to Ark Room
GotoArkRoomLogic:
	jmp	 SetupScreenVisualsAndObjects	  ;3
	
CheckToShowDeveloperInitials
	lda currentScreenId				; get the current screen id
	cmp #ID_ARK_ROOM
	bne HandlePostEasterEggFlow						; branch if not in ID_ARK_ROOM
	lda #$9C		  
	sta $A3		  ; Likely sets a display timer or animation state
	ldy findingYarEasterEggBonus
	beq CheckArkRoomEasterEggFailConditions	  ; If not in Yar's Easter Egg mode, skip
	bit resetEnableFlag
	bmi CheckArkRoomEasterEggFailConditions	  ; If resetEnableFlag has bit 7 set, skip
	ldx #>HSWInitials_00
	stx inventoryGraphicPointers + 1
	stx inventoryGraphicPointers + 3
	lda #<HSWInitials_00
	sta inventoryGraphicPointers
	lda #<HSWInitials_01
	sta inventoryGraphicPointers + 2
CheckArkRoomEasterEggFailConditions:
	ldy indyVertPos					; get Indy's vertical position
	cpy #$7C		  ;124 dev
	bcs SetIndyToArkDescentState	  ; If Indy is below or at Y=$7C (124), skip
	cpy adventurePoints
	bcc SlowlyLowerIndy	  ; If Indy is higher up than his point score, skip
	bit INPT5						; read action button from right controller
	bmi GotoArkRoomLogic						; branch if action button not pressed
	jmp Start			; RESET game if button *is* pressed
	
SlowlyLowerIndy:
	lda frameCount					; get current frame count
	ror								; shift D0 to carry
	bcc GotoArkRoomLogic						; branch on even frame
	iny					; Move Indy down by 1 pixel
	sty indyVertPos		 
	bne GotoArkRoomLogic						; unconditional branch
	
SetIndyToArkDescentState:
	bit resetEnableFlag			; Check bit 7 of resetEnableFlag
	bmi EnableResetAndCheckArkInput	  ; If bit 7 is set, skip (reset enabled)
	lda #$0E		  
	sta $A2		   ; Set Indy�s state to 0E
EnableResetAndCheckArkInput:
	lda #$80		  
	sta resetEnableFlag				; Set bit 7 to enable reset logic
	bit INPT5						; Check action button on right controller
	bmi GotoArkRoomLogic						 ; If not pressed, skip
	lda frameCount					; get current frame count
	and #$0F		  ; Limit to every 16th frame
	bne StoreArkActionCode	   ; If not at correct frame, skip
	lda #$05		  
StoreArkActionCode:
	sta $8C		 ; Store action/state code
	jmp	 InitializeGameStartState	  ; Handle command
	
HandlePostEasterEggFlow:
	bit $93		  
	bvs AdvanceArkEntranceSequence	  ; If bit 6 set, jump to alternate path
ContinueArkSequence:
	jmp	 CheckMajorEventComplete	  ; Continue Ark Room or endgame logic
	
AdvanceArkEntranceSequence:
	lda frameCount					; get current frame count
	and #3						; Only act every 4 frames
	bne ConfigureSnakeGraphicsAndMovement	 ; If not, skip
	ldx $DC		  ;3
	cpx #$60		  ;2
	bcc IncrementArkSequenceStep	 ; If $DC < $60, branch (some kind of position or counter)
	bit majorEventFlag 	  
	bmi ContinueArkSequence	  ; If bit 7 is set, jump to continue logic
	ldx #$00		  ; Reset X 
	lda indyHorizPos			;3
	cmp #$20		  ;2
	bcs StoreArkEntrancePosition				; If Indy is right of x=$20, skip
	lda #$20		  ;2
StoreArkEntrancePosition:
	sta $CC		  ; Store Indy�s forced horizontal position?
IncrementArkSequenceStep:
	inx			  ;2
	stx $DC		   ; Increment and store progression step or counter
	txa			  ;2
	sec			  ;2
	sbc #$07		  ; Subtract 7 to control pacing
	bpl ControlSnakeBasedOnIndy	  ; If result = 0, continue
	lda #$00		 ; Otherwise, reset A to 0
ControlSnakeBasedOnIndy:
	sta $D2		  ; Store A (probably from LD4A5) into $D2 � possibly temporary Y position
	and #$F8		  ;2
	cmp snakeVertPos			;3
	beq ConfigureSnakeGraphicsAndMovement	  ; If vertical alignment hasn�t changed, skip update
	sta snakeVertPos			; Update snake�s vertical position
	lda $D4		  ;3
	and #$03		  ;2
	tax			  ;2
	lda $D4		  ;3
	lsr			  ;2
	lsr			  ;2
	tay			  ;2
	lda SnakeHorizontalOffsetTable,x	  ;4
	clc			  ;2
	adc SnakeHorizontalOffsetTable,y	  ; Add two offset values from table at SnakeHorizontalOffsetTable
	clc			  ;2
	adc $CC		  ; Add forced Indy X position
	ldx #$00		  
	cmp #$87		  ; Apply Horizontal Constraints
	bcs AdjustSnakeBehaviorByDistance	  ; If = $87, skip update
	cmp #$18		  ;2
	bcc FlipSnakeDirectionIfNeeded	  ; If < $18, also skip update
	sbc indyHorizPos			;3
	sbc #$03		  ;2
	bpl AdjustSnakeBehaviorByDistance	  ; If result = 0, skip
FlipSnakeDirectionIfNeeded:
	inx			   ; X = 1
	inx			  ; X = 2 (prepare alternate motion state)
	eor #$FF		 ; Flip delta (one�s complement)
AdjustSnakeBehaviorByDistance:
	cmp #$09		  
	bcc UpdateSnakeMotionState	  ; If too close, skip speed/direction adjustment
	inx			 ; Otherwise, refine behavior with additional increment
UpdateSnakeMotionState:
	txa			  ;2
	asl			  ;2
	asl			  ;2
	sta $84		  ; Multiply X by 4 -> store as upper bits of state
	lda $D4		  ;3
	and #$03		  ;2
	tax			  ;2
	lda SnakeHorizontalOffsetTable,x	  ;4
	clc			  ;2
	adc $CC		  ;3
	sta $CC		  ; Refine target horizontal position
	lda $D4		  ;3
	lsr			  ;2
	lsr			  ;2
	ora $84		  ;3
	sta $D4		  ; Store new composite motion/state byte
ConfigureSnakeGraphicsAndMovement:
	lda $D4		  ;3
	and #$03		  ;2
	tax			  ;2
	lda SnakeMotionTableLSB,x	  ;4
	sta $D6		  ; Store horizontal movement/frame data
	lda #>SnakeMotionTable_0
	sta $D7		  ; Store high byte of graphics or pointer address
	lda $D4		  ;3
	lsr			  ;2
	lsr			  ;2
	tax			  ;2
	lda SnakeMotionTableLSB,x	  ;4
	sec			  ;2
	sbc #$08		  ;2
	sta $D8		  ; Store vertical offset (with adjustment)
CheckMajorEventComplete:
	bit majorEventFlag 	  ;3
	bpl CheckGameScriptTimer	  ; If major event not complete, continue sequence
	jmp	 SwitchToBank1AndContinue	   ;Else, jump to end/cutscene logic
	
CheckGameScriptTimer:
	bit $A1		  ;3
	bpl BranchOnFrameParity	  ; If timer still counting or inactive, proceed
	jmp	 SetIndyStationarySprite	   ; Else, jump to alternate script path (failure/end?)
	
BranchOnFrameParity:
	lda frameCount					; get current frame count
	ror								;  ; Test even/odd frame
	bcc GatePlayerTriggeredEvent						; ; If even, continue next step
	jmp	 ClearItemUseOnButtonRelease	   ; If odd, do something else
	
GatePlayerTriggeredEvent:
	ldx currentScreenId				; get the current screen id
	cpx #ID_MESA_SIDE
	beq AbortProjectileDrivenEvent						; If on Mesa Side, use a different handler
	bit $8D
	bvc CheckInputAndStateForEvent						; If no event/collision flag set, skip
	ldx bulletOrWhipHorizPos			; get bullet or whip horizontal position
	txa			  ;2
	sec			  ;2
	sbc indyHorizPos			;3
	tay			  ; Y = horizontal distance between Indy and projectile
	lda SWCHA						; read joystick values
	ror								; shift right joystick UP value to carry
	bcc ValidateProjectileRangeAndDirection						; branch if right joystick pushing up
	ror								; shift right joystick DOWN value to carry
	bcs AbortProjectileDrivenEvent						; branch if right joystick not pushed down
	cpy #9
	bcc AbortProjectileDrivenEvent				 ; If too close to projectile, skip
	tya
	bpl NudgeProjectileLeft					; If projectile is to the right of Indy, continue
NudgeProjectileRight:
	inx			  ;2
	bne StoreProjectilePosition	  ;2
NudgeProjectileLeft:
	dex			  ;2
StoreProjectilePosition:
	stx bulletOrWhipHorizPos
	bne AbortProjectileDrivenEvent	   ; Exit if projectile has nonzero position
ValidateProjectileRangeAndDirection:
	cpx #$75		  ;2
	bcs AbortProjectileDrivenEvent	   ; Right bound check
	cpx #$1A		  ;2
	bcc AbortProjectileDrivenEvent	  ; Left bound check
	dey			  ;2
	dey			  ;2
	cpy #$07		  ;2
	bcc AbortProjectileDrivenEvent	  ; Too close vertically
	tya			  ;2
	bpl NudgeProjectileRight	   ; If projectile right of Indy, nudge right
	bmi NudgeProjectileLeft			 ; Else, nudge left
	
CheckInputAndStateForEvent:
	bit $B4		  ;3
	bmi AbortProjectileDrivenEvent	  ; If flag set, skip
	bit playerInput
	bpl HandleIndyMovementAndStartEventScan	   ; If no button, skip
	ror			  ;2
	bcc HandleIndyMovementAndStartEventScan	  ; If wrong button, skip
AbortProjectileDrivenEvent:
	jmp	 HandleInventoryButtonPress	  ;3
	
HandleIndyMovementAndStartEventScan:
	ldx #<indyVertPos - objectVertPositions  ; Get index of Indy in object list
	lda SWCHA						; read joystick values
	sta $85						; Store raw joystick input
	and #P1_NO_MOVE
	cmp #P1_NO_MOVE
	beq AbortProjectileDrivenEvent	  ; Skip if no movement
	sta $92		  ;3
	jsr DetermineDirectionToMoveObject  ; Move Indy according to input
	ldx currentScreenId				; get the current screen id
	ldy #$00		  ;2
	sty $84		  ; Reset scan index/counter 
	beq StoreIndyPositionForEvent	  ; Unconditional (Y=0, so BNE not taken)
	
IncrementEventScanIndex:
	tax			   ; Transfer A to X (probably to use as an object index or ID)
	inc $84		  ; Increment $84 � a general-purpose counter or index
StoreIndyPositionForEvent:
	lda indyHorizPos			;3
	pha			  ; Temporarily store horizontal position
	lda indyVertPos					; get Indy's vertical position
	ldy $84		  ; Load current scan/event index
	cpy #$02		  ;2
	bcs ReversePositionOrder	  ; If index >= 2, store in reverse order
	sta $86		  ; Vertical position
	pla			  
	sta $87		  ; Horizontal position
	jmp	 ApplyEventOffsetToIndy	  
	
ReversePositionOrder:
	sta $87		  ; Vertical -> $87
	pla			  
	sta $86		  ; Horizontal -> $86
ApplyEventOffsetToIndy:
	ror $85		  ; Rotate player input to extract direction
	bcs CheckScanBoundaryOrContinue	  ; If carry set, skip
	jsr	 CheckRoomOverrideCondition	  ; Run event/collision subroutine
	bcs TriggerScreenTransition	  ; If failed/blocked, exit
	bvc CheckScanBoundaryOrContinue	  ; If no vertical/horizontal event flag, skip
	ldy $84		   ; Event index
	lda RoomEventOffsetTable,y	  ; Get movement offset from table
	cpy #$02		  ;2
	bcs ApplyHorizontalOffset	 ; If index = 2, move horizontally
	adc indyVertPos		  ;3
	sta indyVertPos		  ;3
	jmp	 CheckScanBoundaryOrContinue	  ;3
	
ApplyHorizontalOffset:
	clc			  ;2
	adc indyHorizPos			;3
	sta indyHorizPos			;3
CheckScanBoundaryOrContinue:
	txa			  ;2
	clc			  ;2
	adc #$0D		   ; Offset for object range or screen width
	cmp #$34		  ;2
	bcc IncrementEventScanIndex	  ; If still within bounds, continue scanning
	bcs HandleInventoryButtonPress						; Else, exit
	
TriggerScreenTransition:
	sty currentScreenId		  ; Set new screen based on event result
	jsr InitializeScreenState ; Load new room or area
HandleInventoryButtonPress:
	bit INPT4						; read action button from left controller
	bmi NormalizePlayerInput						; branch if action button not pressed
	bit $9A		  ;3
	bmi ExitItemHandler	  ; If game state prevents interaction, skip
	lda playerInput
	ror			   ; Check bit 0 of input
	bcs HandleItemPickupAndInventoryUpdate	  ; If set, already mid-action, skip
	sec				 ; Prepare to take item
	jsr TakeItemFromInventory		; carry set...take away selected item
	inc playerInput					;  Advance to next inventory slot
	bne HandleItemPickupAndInventoryUpdate						; Always branch
	
NormalizePlayerInput:
	ror playerInput
	clc			  ;2
	rol playerInput
HandleItemPickupAndInventoryUpdate:
	lda $91		  ;3
	bpl ExitItemHandler	  ; If no item queued, exit
	and #$1F		  ; Mask to get item ID
	cmp #$01		  ;2
	bne CheckShovelPickup	  ;2
	inc numberOfBullets		; Give Indy 3 bullets
	inc numberOfBullets
	inc numberOfBullets
	bne ClearItemUseFlag						; unconditional branch
	
CheckShovelPickup:
	cmp #$0B		  ;2
	bne PlaceGenericItem	  ;2
	ror blackMarketState				; rotate Black Market state right
	sec								; set carry
	rol blackMarketState				; rotate left to show Indy carrying Shovel
	ldx #$45		  ;2
	stx shovelVertPos				 ; Set Y-pos for shovel on screen
	ldx #$7F		  ;2
	stx missile0VertPos
PlaceGenericItem:
	jsr PlaceItemInInventory
ClearItemUseFlag:
	lda #$00		  ;2
	sta $91		   ; Clear item pickup/use state
ExitItemHandler:
	jmp	 UpdateIndySpriteForParachute	  ;; Return from event handle
	
ClearItemUseOnButtonRelease:
	bit $9A		   ; Test game state flags
	bmi ExitItemHandler	  ; If bit 7 is set (N = 1), then a grenade or parachute event is in progress.
	bit INPT5						; read action button from right controller
	bpl HandleItemUseOnButtonPress						; branch if action button pressed
	lda #~USING_GRENADE_OR_PARACHUTE  ; Load inverse of USING_GRENADE_OR_PARACHUTE (i.e., clear bit 1)
	and playerInput ;; Clear the USING_GRENADE_OR_PARACHUTE bit from the player input state
	sta playerInput  ; Store the updated input state
	jmp	 UpdateIndySpriteForParachute	 
	
HandleItemUseOnButtonPress:
	lda #USING_GRENADE_OR_PARACHUTE ; Load the flag indicating item use (grenade/parachute)
	bit playerInput    ; Check if the flag is already set in player input
	bne ExitItemUseHandler	   ; If it's already set, skip re-setting (item already active)
	ora playerInput  ; Otherwise, set the USING_GRENADE_OR_PARACHUTE bit
	sta playerInput   ; Save the updated input state
	ldx selectedInventoryId			; get the current selected inventory id
	cpx #ID_MARKETPLACE_GRENADE  ; Is the selected item the marketplace grenade?
	beq StartGrenadeThrow	   ; If yes, jump to grenade activation logic
	cpx #ID_BLACK_MARKET_GRENADE   ; If not, is it the black market grenade?
	bne CheckToActivateParachute  ; If neither, check if it's a parachute
StartGrenadeThrow:
	ldx indyVertPos					; get Indy's vertical position
	stx bulletOrWhipVertPos		; Set grenade's starting vertical position
	ldy indyHorizPos					; get Indy horizontal position
	sty bulletOrWhipHorizPos			; Set grenade's starting horizontal position
	lda secondsTimer					; get the seconds timer
	adc #5 - 1						; increment value by 5...carry set
	sta grenadeDetinationTime		; detinate grenade 5 seconds from now
	lda #$80		   ; Prepare base grenade state value (bit 7 set)
	cpx #ENTRANCE_ROOM_ROCK_VERT_POS  ; Is Indy below the rock's vertical line?
	bcs StoreGrenadeState						; branch if Indy is under rock scanline
	cpy #$64		  ; Is Indy too far left?
	bcc StoreGrenadeState	 
	ldx currentScreenId				; get the current screen id
	cpx #ID_ENTRANCE_ROOM				; Are we in the Entrance Room?
	bne StoreGrenadeState						; branch if not in the ENTRANCE_ROOM
	ora #$01		  ; Set bit 0 to trigger wall explosion effect
StoreGrenadeState:
	sta $9A		  ; Store the grenade state flags: Bit 7 set: grenade is active - Bit 0 optionally set: triggers wall explosion if conditions were met
	jmp	 UpdateIndySpriteForParachute	  
	
CheckToActivateParachute
	cpx #ID_INVENTORY_PARACHUTE  ; Is the selected item the parachute?
	bne HandleSpecialItemUseCases	  ; If not, branch to other item handling
	stx usingParachuteBonus  ; Store the parachute usage flag for scoring bonus
	lda $B4		   ; Load major event and state flags
	bmi ExitItemUseHandler	   ; If bit 7 is set (already parachuting), skip reactivation
	ora #$80		   ; Set bit 7 to indicate parachute is now active
	sta $B4		  ; Save the updated event flags
	lda indyVertPos					; get Indy's vertical position
	sbc #6							; Subtract 6 (carry is set by default), to move him slightly up
	bpl SetAdjustedParachuteStartY	 ; If the result is positive, keep it
	lda #$01		  ; If subtraction underflows, cap position to 1
SetAdjustedParachuteStartY:
	sta indyVertPos		  ;3
	bpl FinalizeImpactEffect						; unconditional branch
	
HandleSpecialItemUseCases:
	bit $8D		  ; Check special state flags (likely related to scripted events)
	bvc AttemptDiggingForArk	  ; If bit 6 is clear (no vertical event active), skip to further checks
	bit CXM1FB	  ; Check collision between missile 1 and playfield
	bmi CalculateImpactRegionIndex	   ; If collision occurred (bit 7 set), go to handle collision impact
	jsr	 WarpToMesaSide	 ; No collision � warp Indy to Mesa Side (context-dependent event)
ExitItemUseHandler:
	jmp	 UpdateIndySpriteForParachute	  ;3
	
CalculateImpactRegionIndex:
	lda bulletOrWhipVertPos			; get bullet or whip vertical position
	lsr			  ; Divide by 2 (fine-tune for tile mapping)
	sec			  ; Set carry for subtraction
	sbc #$06		  ; Subtract 6 (offset to align to tile grid)
	clc			  ; Clear carry before next addition
	adc $DF		  ; Add reference vertical offset (likely floor or map tile start)
	lsr			  ; Divide by 16 total:
	lsr			  ; Effectively: (Y - 6 + $DF) / 16
	lsr			  
	lsr			  
	cmp #$08		  ; Check if the result fits within bounds (max 7)
	bcc ApplyImpactEffectsAndAdjustPlayer	  ; If less than 8, jump to store the index
	lda #$07		  ; Clamp to max value (7) if out of bounds
ApplyImpactEffectsAndAdjustPlayer:
	sta $84		  ; Store the region index calculated from vertical position
	lda bulletOrWhipHorizPos			; get bullet or whip horizontal position
	sec			  ;2
	sbc #$10		  ; Adjust for impact zone alignment
	and #$60		   ; Mask to relevant bits (coarse horizontal zone)
	lsr			  
	lsr			  ; Divide by 4 � convert to tile region
	adc $84		   ; Combine with vertical region index to form a unique map zone index
	tay			  ; Move index to Y
	lda ArkRoomImpactResponseTable,y	   ; Load impact response from lookup table
	sta $8B		   ; Store result � likely affects state or visual of game field
	ldx bulletOrWhipVertPos			; get bullet or whip vertical position
	dex			  ; Decrease projectile X by 2 � simulate impact offset
	stx bulletOrWhipVertPos
	stx indyVertPos		  ; Sync Indy's horizontal position to projectile�s new position
	ldx bulletOrWhipHorizPos			
	dex			  ; Decrease projectile X by 2 � simulate impact offset
	dex			  
	stx bulletOrWhipHorizPos
	stx indyHorizPos			; Sync Indy's horizontal position to projectile�s new position
	lda #$46		  ; Set special state value
	sta $8D		    ; Likely a flag used by event logic
FinalizeImpactEffect:
	jmp	 TriggerWhipEffect	  ; Jump to item-use or input continuation logic
	
AttemptDiggingForArk:
	cpx #ID_INVENTORY_SHOVEL	; Is the selected item the shovel?
	bne UseAnkhToWarpToMesaField	   ; If not, skip to other item handling
	lda indyVertPos					; get Indy's vertical position
	cmp #$41		   ;Is Indy deep enough to dig?
	bcc ExitItemUseHandler	  ; If not, exit (can't dig here)
	bit CXPPMM						; check player / missile collisions (probably shovel sprite contact with dig site)
	bpl ExitItemUseHandler						; branch if players didn't collide
	inc $97		  ; Increment dig attempt counter
	bne ExitItemUseHandler	  ; If not the first dig attempt, exit
	ldy $96		  ; Load current dig depth or animation frame
	dey			  ; Decrease depth
	cpy #$54		  ; Is it still within range?
	bcs ClampDigDepth	  ; If at or beyond max depth, cap it
	iny			  ; Otherwise restore it back (prevent negative values)
ClampDigDepth:
	sty $96		  ; Save the clamped or unchanged dig depth value
	lda #BONUS_FINDING_ARK
	sta findingArkBonus			; Set the bonus for having found the Ark
	bne ExitItemUseHandler						; unconditional branch
	
UseAnkhToWarpToMesaField:
	cpx #ID_INVENTORY_ANKH		; Is the selected item the Ankh?
	bne HandleWeaponUseOnMove	  ; If not, skip to next item handling
	ldx currentScreenId				; get the current screen id
	cpx #ID_TREASURE_ROOM		; Is Indy in the Treasure Room?
	beq ExitItemUseHandler						; If so, don't allow Ankh warp from here
	lda #ID_MESA_FIELD			; Mark this warp use (likely applies 9-point score penalty)
	sta skipToMesaFieldBonus			; set to reduce score by 9 points
	sta currentScreenId		  ; Change current screen to Mesa Field
	jsr InitializeScreenState ; Load the data for the new screen
	lda #$4C		  ; Prepare a flag or state value for later use (e.g., warp effect)
WarpPlayerToMesaFieldStart:
	sta indyHorizPos			; Set Indy's horizontal position
	sta bulletOrWhipHorizPos			; Set projectile's horizontal position (same as Indy)
	lda #$46		  ; Fixed vertical position value (start of Mesa Field?)
	sta indyVertPos		  ; Set Indy's vertical position
	sta bulletOrWhipVertPos		 ; Set projectile's vertical position
	sta $8D		  ; Set event/state flag (used later to indicate transition or animation)
	lda #$1D		  ; Set initial vertical scroll or map offset?
	sta $DF		  ; Likely adjusts tile map base Y
	bne UpdateIndySpriteForParachute						; Unconditional jump to common handler
	
HandleWeaponUseOnMove:
	lda SWCHA						; read joystick values
	and #P1_NO_MOVE				; Mask to isolate movement bits
	cmp #P1_NO_MOVE
	beq UpdateIndySpriteForParachute						; branch if right joystick not moved
	cpx #ID_INVENTORY_REVOLVER
	bne .checkForIndyUsingWhip		; check for Indy using whip
	bit bulletOrWhipStatus			; check bullet or whip status
	bmi UpdateIndySpriteForParachute						; branch if bullet active
	ldy numberOfBullets				; get number of bullets remaining
	bmi UpdateIndySpriteForParachute						; branch if no more bullets
	dec numberOfBullets				; reduce number of bullets
	ora #BULLET_OR_WHIP_ACTIVE
	sta bulletOrWhipStatus			; set BULLET_OR_WHIP_ACTIVE bit
	lda indyVertPos					; get Indy's vertical position
	adc #4							; Offset to spawn bullet slightly above Indy
	sta bulletOrWhipVertPos			; Set bullet Y position
	lda indyHorizPos				
	adc #4							; Offset to spawn bullet slightly ahead of Indy
	sta bulletOrWhipHorizPos		 ; Set bullet X position
	bne TriggerWhipEffect						; unconditional branch
	
.checkForIndyUsingWhip
	cpx #ID_INVENTORY_WHIP			; Is Indy using the whip?
	bne UpdateIndySpriteForParachute						; branch if Indy not using whip
	ora #$80		  ; Set a status bit (probably to indicate whip action)
	sta $8D		  ; Store it in the game state/event flags
	ldy #4		; Default vertical offset (X)
	ldx #5		; Default horizontal offset (Y)
	ror								; shift MOVE_UP to carry
	bcs CheckWhipDownDirection						; branch if not pushed up
	ldx #<-6						; If pressing up, set vertical offset
CheckWhipDownDirection:
	ror								; shift MOVE_DOWN to carry
	bcs CheckWhipLeftDirection						; branch if not pushed down
	ldx #15							; If pressing down, set vertical offset
CheckWhipLeftDirection:
	ror								; shift MOVE_LEFT to carry
	bcs CheckWhipRightDirection						; branch if not pushed left
	ldy #<-9						; If pressing left, set horizontal offset
CheckWhipRightDirection:
	ror								; shift MOVE_RIGHT to carry
	bcs ApplyWhipStrikePosition						; branch if not pushed right
	ldy #16							; If pressing right, set horizontal offset
ApplyWhipStrikePosition:
	tya								; Move horizontal offset (Y) into A
	clc
	adc indyHorizPos
	sta bulletOrWhipHorizPos		; Add to Indy�s current horizontal position
	txa			  ;2				 ; Move vertical offset (X) into A
	clc			  ;2
	adc indyVertPos		  ; Add to Indy�s current vertical position
	sta bulletOrWhipVertPos ; Set whip strike vertical position
TriggerWhipEffect:
	lda #$0F		  ; Set effect timer or flag for whip (e.g., 15 frames)
	sta $A3		  ; Likely used to animate or time whip visibility/effect
UpdateIndySpriteForParachute:
	bit $B4		  ; Check game status flags
	bpl SetIndySpriteIfStationary	  ; If parachute bit (bit 7) is clear, skip parachute rendering
	lda #<ParachutingIndySprite		; Load low byte of parachute sprite address
	sta indyGraphicPointers			; Set Indy's sprite pointer
	lda #H_PARACHUTE_INDY_SPRITE	; Load height for parachuting sprite
	bne .setIndySpriteHeight			; unconditional branch
	
SetIndySpriteIfStationary:
	lda SWCHA						; read joystick values
	and #P1_NO_MOVE					; Mask movement input
	cmp #P1_NO_MOVE
	bne UpdateIndyWalkingAnimation	  ; If any direction is pressed, skip (Indy is moving)
SetIndyStationarySprite:
	lda #<IndyStationarySprite		; Load low byte of pointer to stationary sprite
.setIndySpriteLSBValue
	sta indyGraphicPointers				  ; Store sprite pointer (low byte)
	lda #H_INDY_SPRITE					 ; Load height for standard Indy sprite
.setIndySpriteHeight
	sta indySpriteHeight				 ; Store sprite height
	bne HandleEnvironmentalSinkingEffect						; unconditional branch
	
UpdateIndyWalkingAnimation:
	lda #$03		   ; Mask to isolate movement input flags (e.g., up/down/left/right)
	bit playerInput
	bmi CheckAnimationTiming	  ; If bit 7 (UP) is set, skip right shift
	lsr			  ; Shift movement bits (to vary animation speed/direction)
CheckAnimationTiming:
	and frameCount		; Use frameCount to time animation updates
	bne HandleEnvironmentalSinkingEffect			 ; If result is non-zero, skip sprite update this frame
	lda #H_INDY_SPRITE		; Load base sprite height
	clc			  		
	adc indyGraphicPointers					; Advance to next sprite frame
	cmp #<IndyStationarySprite				 ; Check if we've reached the end of walking frames
	bcc .setIndySpriteLSBValue				; If not yet at stationary, update sprite pointer
	lda #$02								; Set a short animation timer
	sta $A3		  ;3
	lda #<Indy_0						;; Reset animation back to first walking frame
	bcs .setIndySpriteLSBValue		; Unconditional jump to store new sprite pointer
HandleEnvironmentalSinkingEffect:
	ldx currentScreenId				; get the current screen id
	cpx #ID_MESA_FIELD				 ; Load current screen ID
	beq CheckSinkingEligibility			; If yes, check sinking conditions
	cpx #ID_VALLEY_OF_POISON			; If yes, check sinking conditions
	bne SwitchToBank1AndContinue	 					 ; If neither, skip this routine
CheckSinkingEligibility:
	lda frameCount					; get current frame count
	bit playerInput
	bpl ApplySinkingIfInZone	   ; If bit 7 of playerInput is clear (not pushing up?), apply shift
	lsr			   					; Adjust animation or action pacing
ApplySinkingIfInZone:
	ldy indyVertPos					; get Indy's vertical position
	cpy #$27		  				; Is he at the sinking zone Y-level?
	beq SwitchToBank1AndContinue	  					; If so, skip (already sunk enough)
	ldx $DF		  					; Load terrain deformation or sink offset?
	bcs ReverseSinkingEffectIfApplicable						; If carry is set from earlier BIT, go to advanced sink
	beq SwitchToBank1AndContinue						; If $DF is 0, no further sinking
	inc indyVertPos					; Sink Indy vertically
	inc bulletOrWhipVertPos			; Sink the projectile too
	and #$02						; Control sinking frequency
	bne SwitchToBank1AndContinue						; Skip if odd/even frame constraint not me
	dec $DF							; Reduce sink counter
	inc $CE							; Possibly animation or game state flag
	inc missile0VertPos				; Sink a visible element (perhaps parachute/missile sprite)
	inc $D2							; Another state tracker
	inc $CE		
	inc missile0VertPos				; Repeated to simulate multi-phase sinking
	inc $D2		  ;5
	jmp	 SwitchToBank1AndContinue	  					; Continue normal processing
	
ReverseSinkingEffectIfApplicable:
	cpx #$50		  ; Check if Indy has reached the upper bound for rising
	bcs SwitchToBank1AndContinue	  ; If Indy is already high enough, skip
	dec indyVertPos		  			; Move Indy upward
	dec bulletOrWhipVertPos			; Move projectile upward as well
	and #$02		 				 ; Use timing mask to control frame-based rise rate
	bne SwitchToBank1AndContinue	  ; If not aligned, skip this update
	inc $DF		  ; Increase sink offset counter (reversing descent)
	dec $CE		  ; Adjust state/animation back
	dec missile0VertPos				; Move visible missile/sprite upward
	dec $D2		  ; Update related state
	dec $CE		  
	dec missile0VertPos
	dec $D2		  ; Mirror the changes made in the sinking routine
SwitchToBank1AndContinue:
	lda #<JumpToScreenHandlerFromBank1						; Load low byte of destination routine in Bank 1
	sta bankSwitchJMPAddress
	lda #>JumpToScreenHandlerFromBank1						; Load high byte of destination
	sta bankSwitchJMPAddress + 1
	jmp JumpToBank1					; Perform the bank switch and jump to new code
	
SetupScreenVisualsAndObjects:
	lda $99		  ; Check status flag (likely screen initialization)
	beq SetScreenControlsAndColor	  ; If zero, skip subroutine
	jsr	 UpdateRoomEventState	  ; Run special screen setup routine (e.g., reset state or clear screen)
	lda #$00		  ; Clear the flag afterward
SetScreenControlsAndColor:
	sta $99		  ; Store the updated flag
	ldx currentScreenId				; get the current screen id
	lda HMOVETable,x				
	sta NUSIZ0						; Set object sizing/horizontal motion control
	lda playfieldControl
	sta CTRLPF						; Set playfield control flags
	lda BackgroundColorTable,x
	sta COLUBK						; set current screen background color
	lda PlayfieldColorTable,x
	sta COLUPF						; set current screen playfield color
	lda Player0ColorTable,x
	sta COLUP0						; Set Player 0 (usually enemies or projectiles) color
	lda IndyColorValues,x
	sta COLUP1
	cpx #ID_THIEVES_DEN
	bcc .HorizontallyPositionObjects
	lda #$20
	sta $D4							; Possibly enemy counter, timer, or position marker
	ldx #4
SetupThievesDenObjects:
	ldy thievesHMOVEIndex,x
	lda HMOVETable,y
	sta thievesHorizPositions,x
	dex
	bpl SetupThievesDenObjects		 ; Loop through all Thieves' Den enemy positions
.HorizontallyPositionObjects
	jmp HorizontallyPositionObjects
	
.SetArkRoomInitialPositions
	lda #$4D		  ; Set Indy's horizontal position in the Ark Room
	sta indyHorizPos			;3
	lda #$48		  ;2
	sta $C8		  ; Unknown, likely related to screen offset or trigger state
	lda #$1F		  ;2
	sta indyVertPos		  ; Set Indy's vertical position in the Ark Room
	rts			  ; Return from subroutine

ClearGameStateMemory:
	ldx #$00		  ; Start at index 0
	txa			  ; A = 0 (will be used to clear memory)
WriteToStateMemoryLoop:
	sta $DF,x		; Clear/reset memory at $DF�$E4
	sta $E0,x	  
	sta $E1,x	  
	sta $E2,x	  
	sta $E3,x	  
	sta $E4,x	  
	txa				; Check accumulator value
	bne ExitMemoryClearRoutine 	  ; If A ? 0, exit (used for conditional init)
	ldx #$06		  ; Prepare to re-run loop with X = 6
	lda #$14		  ; Now set A = 20 (used for secondary initialization)
	bne WriteToStateMemoryLoop		; Unconditional loop to write new value
	
ExitMemoryClearRoutine:
	lda #$FC		  ; Load setup value (likely a countdown, position, or state flag)
	sta $D7		  ; Store it to a specific control variable
	rts			  ; Return from subroutine

InitializeScreenState
	lda $9A		   ; Load player item state / status flags
	bpl ResetRoomFlags	  ; If bit 7 is clear (no grenade/parachute active), skip flag set
	ora #$40		  ; Set bit 6: possibly "re-entering room" or "just warped"
	sta $9A		   ; Save updated status
ResetRoomFlags:
	lda #$5C		  ; Likely a vertical offset or a default Y-position baseline
	sta $96		  ; Used for digging or vertical alignment mechanics
	ldx #$00		  ; Clear various status bytes
	stx $93		  ; Could be a cutscene or transition state
	stx $B6		  ; Possibly enemy or item slot usage
	stx $8E		   ; May control animation phase or enemy flags
	stx $90		  ; Could be Indy or enemy action lock
	lda pickupStatusFlags			; Read item collection flags
	stx pickupStatusFlags 			; Clear them all (reset pickups for new screen)
	jsr	 UpdateRoomEventState	  ; General-purpose screen initialization/reset routine
	rol playerInput			; Rotate input flags � possibly to mask off an "item use" bit
	clc			  ;2
	ror playerInput					 ; Reverse the bit rotation; keeps input state consistent
	ldx currentScreenId				; Load which room Indy is in
	lda PlayfieldControlTable,x
	sta playfieldControl				 ; Set up playfield reflection, score display, priorities
	cpx #ID_ARK_ROOM
	beq .SetArkRoomInitialPositions			; Setup special Ark Room spawn point
	cpx #ID_MESA_SIDE
	beq LoadPlayerGraphicsForRoom
	cpx #ID_WELL_OF_SOULS
	beq LoadPlayerGraphicsForRoom
	lda #$00
	sta $8B									; General-purpose flag for room state, cleared by default
LoadPlayerGraphicsForRoom:
	lda RoomPlayer0LSBGraphicData,x	  ;4
	sta player0GraphicPointers					; Set low byte of sprite pointer for P0 (non-Indy)
	lda RoomPlayer0MSBGraphicData,x	  ;4
	sta player0GraphicPointers + 1				; Set high byte of sprite pointer for P0
	lda RoomPlayer0Height,x	  ;4
	sta player0SpriteHeight						; Set height of the sprite (e.g., enemy size)
	lda RoomTypeTable,x	  ;4
	sta $C8		  							; Likely a screen property (enemy group type, warp flag)
	lda RoomMissile0VertPosTable,x	  ;4
	sta $CA		  							 ; Possibly related to object spawning
	lda RoomMissile0InitVertPosTable,x	  ;4
	sta missile0VertPos						; Position for environmental object (missile0 = visual fx)
	cpx #ID_THIEVES_DEN
	bcs ClearGameStateMemory	   ; If this is Thieves Den or later, clear additional state
	adc RoomSpecialBehaviorTable,x	  ;4
	sta $E0		  ;3					; Special room behavior index or environmental parameter
	lda RoomPF1GraphicLSBTable,x	  ;4
	sta pf1GraphicPointers				; PF1 low byte
	lda RoomPF1GraphicMSBTable,x	  ;4
	sta pf1GraphicPointers + 1				; PF1 high byte
	lda RoomPF2GraphicLSBTable,x	  ;4
	sta pf2GraphicPointers					; PF2 low byte
	lda RoomPF2GraphicMSBTable,x	  ;4
	sta pf2GraphicPointers + 1					; PF2 high byte
	lda #$55		  ;2
	sta $D2		  ; Likely a default animation frame or sound cue value
	sta bulletOrWhipVertPos			; Default vertical position for bullets/whips
	cpx #ID_TEMPLE_ENTRANCE
	bcs InitializeTempleAndShiningLightRooms	  							; Jump past object position logic if in later screens
	lda #$00		 						; Clear out default vertical offset value
	cpx #ID_TREASURE_ROOM
	beq .setTreasureRoomObjectVertPos
	cpx #ID_ENTRANCE_ROOM
	beq .setEntranceRoomTopObjectVertPos
	sta $CE		  ; Default vertical position for objects (top of screen)
FinalizeScreenInitialization:
	ldy #$4F		 ; Default environmental sink or vertical state
	cpx #ID_ENTRANCE_ROOM
	bcc FinishScreenInitAndReturn	   ; If before Entrance Room, use default Y
	lda $AF,x	  ;4
	ror			   ; Check a control bit from table (could enable falling)
	bcc FinishScreenInitAndReturn	  ; If not set, use default
	ldy RoomObjectVertOffsetTable,x	  ;4					; Load alternate vertical offset from table
	cpx #ID_BLACK_MARKET
	bne FinishScreenInitAndReturn	   ; Only override object height if in Black Market
	lda #$FF		  ;2
	sta missile0VertPos					; Hide missile object by placing it off-screen
FinishScreenInitAndReturn:
	sty $DF		  					 ; Finalize vertical object/environment state
	rts			  						 ; Return from screen initialization

.setTreasureRoomObjectVertPos
	lda $AF		   ; Load screen control byte
	and #$78		  ; Mask off all but bits 3�6 (preserve mid flags, clear others)
	sta $AF		  ; Save the updated control state
	lda #$1A		
	sta topObjectVertPos			 ; Set vertical position for the top object
	lda #$26		  ;2
	sta bottomObjectVertPos			 ; Set vertical position for the bottom object
	rts			   ; Return 
	
.setEntranceRoomTopObjectVertPos
	lda entranceRoomState
	and #7
	lsr								; shift value right
	bne SetEntranceRoomTopObjectPosition						; branch if wall opening present in Entrance Room
	ldy #$FF		  ;2
	sty missile0VertPos
SetEntranceRoomTopObjectPosition:
	tay												; Transfer A (index) to Y
	lda EntranceRoomTopObjectVertPos,y				; Look up Y-position for Entrance Room's top object
	sta topObjectVertPos							; Set the object's vertical position
	jmp FinalizeScreenInitialization				; Continue the screen setup process
	
InitializeTempleAndShiningLightRooms:
	cpx #ID_ROOM_OF_SHINING_LIGHT				; Check if current room is "Room of Shining Light"
	beq InitRoomOfShiningLight	  								; If so, jump to its specific init routine
	cpx #ID_TEMPLE_ENTRANCE						; If not, is it the Temple Entrance?
	bne InitMesaFieldSinkingState									; If neither, skip this routine
	ldy #$00		  ;2
	sty $D8										; Clear some dungeon-related state variable
	ldy #$40		  ;2
	sty topOfDungeonGraphic						 ; Set visual reference for top-of-dungeon graphics
	bne ConfigureTempleOrShiningLightGraphics	   								;Always taken
	
InitRoomOfShiningLight:
	ldy #$FF		  ;2
	sty topOfDungeonGraphic						; Top of dungeon should render with full brightness/effect
	iny								; y = 0
	sty $D8										; Possibly clear temple or environmental state
	iny								; y = 1
ConfigureTempleOrShiningLightGraphics:
	sty dungeonGraphics + 1						; Set dungeon tiles to base values
	sty dungeonGraphics + 2
	sty dungeonGraphics + 3
	sty dungeonGraphics + 4
	sty dungeonGraphics + 5
	ldy #$39		  ;2
	sty $D4										; Likely a counter or timer
	sty snakeVertPos							; Set snake enemy Y-position baseline
InitMesaFieldSinkingState:
	cpx #ID_MESA_FIELD
	bne ReturnFromRoomSpecificInit 				; If not Mesa Field, skip
	ldy indyVertPos					; get Indy's vertical position
	cpy #$49		  ;2
	bcc ReturnFromRoomSpecificInit 	   ; If Indy is above threshold, no sinking
	lda #$50		  ;2
	sta $DF		  ; Set environmental sink value � starts Indy sinking
	rts			  ; return

ReturnFromRoomSpecificInit:
	lda #$00		 
	sta $DF		  ; Clear the environmental sink value (Indy won't sink)
	rts			  ; Return to caller (completes screen init)

CheckRoomOverrideCondition:
	ldy RoomOverrideKeyTable,x	  ; Load room override index based on current screen ID
	cpy $86		  ; Compare with current override key or control flag
	beq ApplyRoomOverridesIfMatched	  ; If it matches, apply special overrides
	clc			   ; Clear carry (no override occurred)
	clv			  ; Clear overflow (in case it�s used for flag-based branching)
	rts			  ; Exit with no overrides

ApplyRoomOverridesIfMatched:
	ldy RoomVerticalOverrideFlagTable,x	  ; Load vertical override flag
	bmi CheckAdvancedOverrideConditions	  ; If negative, skip overrides and return with SEC
CheckVerticalOverride:
	lda RoomVerticalPositionOverrideTable,x	  ; Load vertical position override (if any)
	beq ApplyHorizontalOverride	  ; If zero, skip vertical positioning
ApplyVerticalOverride:
	sta indyVertPos		  ; Apply vertical override to Indy
ApplyHorizontalOverride:
	lda RoomHorizontalPositionOverrideTable,x	  ; Load horizontal position override (if any)
	beq ReturnFromOverrideWithSEC	 ; If zero, skip horizontal positioning
	sta indyHorizPos			; Apply horizontal override to Indy
ReturnFromOverrideWithSEC:
	sec			  ; Set carry to indicate an override was applied
	rts			  ; Return to caller

CheckAdvancedOverrideConditions:
	iny                              ; Bump Y from previous RoomVerticalOverrideFlagTable value
	beq ReturnNoOverrideWithSideEffect  ; If it was $FF, return early

	iny
	bne EvaluateRangeBasedVerticalOverride  ; If not $FE, jump to advanced evaluation

	; Case where Y = $FE
	ldy RoomOverrideLowerHorizBoundaryTable,x                      ; Load lower horizontal boundary
	cpy $87                          ; Compare with current horizontal state
	bcc CompareWithExtendedRoomThresholds ; If below lower limit, use another check

	ldy RoomOverrideUpperHorizBoundaryTable,x                      ; Load upper horizontal boundary
	bmi CheckFlagOrApplyFixedVertical ; If negative, apply default vertical

	bpl CheckVerticalOverride        ; Always taken � go check vertical override normally
	
CompareWithExtendedRoomThresholds:
	ldy RoomAdvancedOverrideControlTable,x                      ; Load alternate override flag
	bmi CheckFlagOrApplyFixedVertical ; If negative, jump to handle special override
	bpl CheckVerticalOverride        ; Always taken
	
EvaluateRangeBasedVerticalOverride:
	lda $87                          ; Load current horizontal position
	cmp RoomOverrideLowerHorizBoundaryTable,x                      ; Compare with lower limit
	bcc ReturnNoOverrideWithSideEffect

	cmp RoomOverrideUpperHorizBoundaryTable,x                      ; Compare with upper limit
	bcs ReturnNoOverrideWithSideEffect

	ldy RoomAdvancedOverrideControlTable,x                      ; Load override control byte
	bpl CheckVerticalOverride        ; If positive, allow override

CheckFlagOrApplyFixedVertical:
	iny
	bmi ConditionalOverrideBasedOnB5_0                    ; If negative, special flag check

	ldy #$08                         ; Use a fixed override value
	bit $AF                          ; Check room flag register
	bpl CheckVerticalOverride        ; If bit 7 is clear, proceed

	lda #$41
	bne ApplyVerticalOverride        ; Always taken � apply forced vertical position
	
ConditionalOverrideBasedOnB5_0:
	iny			  ;2
	bne ConditionalOverrideIfB5LessThan0A	  ; Always taken unless overflowed
	lda $B5		  ;3
	and #$0F		  ; Mask to lower nibble
	bne ReturnNoOverrideWithSideEffect	  ; If any bits set, don't override
	ldy #$06		  ;2
	bne CheckVerticalOverride						 ; Always taken
	
ConditionalOverrideIfB5LessThan0A:
	iny			  ;2
	bne CheckInputForFinalOverride	  ; Continue check chain
	lda $B5		  ;3
	and #$0F		  ;2
	cmp #$0A		  ;2
	bcs ReturnNoOverrideWithSideEffect	  ;2
	ldy #$06		  ;2
	bne CheckVerticalOverride						; Always taken
	
CheckInputForFinalOverride:
	iny			  ;2
	bne CheckHeadOfRaAlignment	  ; Continue to final check
	ldy #$01		  ;2
	bit playerInput
	bmi CheckVerticalOverride	  ; If fire button pressed, allow override
	
ReturnNoOverrideWithSideEffect:
	clc			  ; Clear carry to signal no override
	bit	 NoOpRTS 	  ; Dummy BIT used for timing/padding
NoOpRTS:							; No-op subroutine � acts as placeholder or execution pad
	rts			  ;6

CheckHeadOfRaAlignment:
	iny			  ; Increment Y (used as a conditional trigger)
	bne ReturnNoOverrideWithSideEffect	  ; If Y was not zero before, exit ear
	ldy #$06		  ; Load override index value into Y (used if conditions match)
	lda #ID_INVENTORY_HEAD_OF_RA		; Load ID for the Head of Ra item
	cmp selectedInventoryId			; compare with current selected inventory id
	bne ReturnNoOverrideWithSideEffect						; branch if not holding Head of Ra
	bit INPT5						; read action button from right controller
	bmi ReturnNoOverrideWithSideEffect						; branch if action button not pressed
	jmp CheckVerticalOverride			 ; All conditions met: apply vertical override
	
TakeItemFromInventory SUBROUTINE
	ldy numberOfInventoryItems		; get number of inventory items
	bne .takeItemFromInventory		; branch if Indy carrying items
	clc				; Otherwise, clear carry (indicates no item removed)
	rts				; Return (nothing to do)

.takeItemFromInventory
	bcs .takeSelectedItemFromInventory
	tay								; move item id to be removed to y
	asl								; multiply value by 8 to get graphic LSB
	asl
	asl
	ldx #10							; Start from the last inventory slot (there are 6 slots, each 2 bytes)
.takeItemFromInventoryLoop
	cmp inventoryGraphicPointers,x	; Compare target LSB value to current inventory slot
	bne .checkNextItem				; If not a match, try the next slot
	cpx selectedInventoryIndex
	beq .checkNextItem
	dec numberOfInventoryItems		; reduce number of inventory items
	lda #<EmptySprite
	sta inventoryGraphicPointers,x	; place empty sprite in inventory
	cpy #$05						; If item index is less than 5, skip clearing pickup flag
	bcc FinalizeInventoryRemoval	  ;2
	; Remove pickup status bit if this is a non-basket item
	tya                                  ; Move item ID to A
	tax								; move item id to x
	jsr ShowItemAsNotTaken			; Update pickup/basket flags to show it's no longer taken
	txa			 ; X -> A
	tay			  ; And back to Y for further use
FinalizeInventoryRemoval:
	jmp	 FinalizeInventorySelection	  ;3
	
.checkNextItem
	dex									; Move to previous inventory slot
	dex									; Each slot is 2 bytes (pointer to sprite)
	bpl .takeItemFromInventoryLoop		; If still within bounds, continue checking
	clc									; Clear carry � no matching item was found/removed
	rts									; Return (nothing removed)

.takeSelectedItemFromInventory
	lda #ID_INVENTORY_EMPTY
	ldx selectedInventoryIndex
	sta inventoryGraphicPointers,x	; remove selected item from inventory
	ldx selectedInventoryId			; get current selected inventory id
	cpx #ID_INVENTORY_KEY
	bcc JumpToItemRemovalHandler	  ;2
	jsr ShowItemAsNotTaken
JumpToItemRemovalHandler:
	txa								; move inventory id to accumulator
	tay								; move inventory id to y
	asl								; multiple inventory id by 2
	tax
	lda RemoveItemFromInventoryJumpTable - 1,x
	pha								; push MSB to stack
	lda RemoveItemFromInventoryJumpTable - 2,x
	pha								; push LSB to stack
	ldx currentScreenId				; get the current screen id
	rts								; jump to Remove Item strategy

RemoveParachuteFromInventory
	lda #$3F		  ; Mask to clear bit 6 (parachute active flag)
	and $B4		  ; Remove parachute bit from game state flags
	sta $B4		  ; Store updated flags
FinalizeItemRemoval:
	jmp RemoveItemFromInventory		; Go to general item removal cleanup
	
RemoveAnkhOrHourGlassFromInventory
	stx $8D		   ; Store current screen ID (context-specific logic)
	lda #$70		  ; Set vertical position offscreen or special
	sta bulletOrWhipVertPos			; Move bullet/whip Y position (could represent effect trigger)
	bne FinalizeItemRemoval			; Unconditional jump to finalize removal
	
RemoveChaiFromInventory
	lda #$42		  ; Check for a specific condition in status byte $91
	cmp $91		  ;3
	bne checkMarketplaceYarEasterEgg	  ;2
	
	; If $91 == $42, warp Indy to Black Market and reset position
	lda #ID_BLACK_MARKET				; Set screen to Black Market
	sta currentScreenId		  ;3
	jsr InitializeScreenState			 ; Initialize Black Market screen
	lda #$15		  ; Set Indy X position (entry point)
	sta indyHorizPos			;3
	lda #$1C		   ; Set Indy Y position
	sta indyVertPos		  ;3
	bne RemoveItemFromInventory		; Always branch to general cleanup
	
checkMarketplaceYarEasterEgg:
	cpx #ID_MARKETPLACE_GRENADE			; Are we removing the Marketplace Grenade?
	bne RemoveItemFromInventory			; If not, do normal cleanup
	lda #BONUS_FINDING_YAR				; Check if we're triggering Yar Easter Egg bonus
	cmp $8B		  ;3
	bne RemoveItemFromInventory			; If not already triggered, exit
	; Award Yar Easter Egg bonus
	sta findingYarEasterEggBonus
	lda #$00		  ;2
	sta $CE		  						; Possibly clears a sprite or collision state
	lda #$02		  ;2
	ora $B4								; Set bit 1 in status flags
	sta $B4		  ;3
	bne RemoveItemFromInventory		 ; Always branch to final cleanup
	
RemoveWhipFromInventory
	ror entranceRoomState			; rotate entrance room state right
	clc								; clear carry
	rol entranceRoomState			; rotate left to show Whip not taken by Indy
	cpx #ID_ENTRANCE_ROOM
	bne .removeWhipFromInventory
	lda #78
	sta whipVertPos
.removeWhipFromInventory
	bne RemoveItemFromInventory		; unconditional branch
	
RemoveShovelFromInventory
	ror blackMarketState				; Clear lowest bit to indicate Indy is no longer carrying the shovel
	clc								 ; Clear carry (ensures bit 7 won't be set on next instruction)
	rol blackMarketState				; Restore original order of bits with bit 0 cleared
	cpx #ID_BLACK_MARKET				; Is Indy currently in the Black Market?
	bne .removeShovelFromInventory		; If not, skip visual update
	; Indy is in Black Market � reset visual positions of the shovel and missile
	lda #$4F
	sta shovelVertPos
	lda #$4B
	sta missile0VertPos
.removeShovelFromInventory
	bne RemoveItemFromInventory		; Unconditionally jump to finalize item removal
	
RemoveCoinsFromInventory
	ldx currentScreenId				; get the current screen id
	cpx #ID_BLACK_MARKET
	bne FinalizeCoinRemovalFlags						; branch if not in Black Market
	lda indyHorizPos					; get Indy's horizontal position
	cmp #$3C		  ;2
	bcs FinalizeCoinRemovalFlags
	rol blackMarketState				; rotate Black Market state left
	sec								; set carry
	ror blackMarketState				; rotate right to show Indy not carry coins
FinalizeCoinRemovalFlags:
	lda $91		  ;3
	clc			  ;2
	adc #$40		  ; Update UI/event state (e.g. to reflect coin removal)
	sta $91		  ;3
RemoveItemFromInventory
	dec numberOfInventoryItems		; reduce number of inventory items
	bne .selectNextAvailableInventoryItem; branch if Indy has remaining items
	lda #ID_INVENTORY_EMPTY
	sta selectedInventoryId			; clear the current selected invendory id
	beq FinalizeInventorySelection						; unconditional branch
	
.selectNextAvailableInventoryItem
	ldx selectedInventoryIndex		; get selected inventory index
.nextInventoryIndex
	inx								; increment by 2 to compensate for word pointer
	inx
	cpx #11
	bcc SelectNextInventoryItem
	ldx #0							; wrap around to the beginning
SelectNextInventoryItem:
	lda inventoryGraphicPointers,x	; get inventory graphic LSB value
	beq .nextInventoryIndex			; branch if nothing in the inventory location
	stx selectedInventoryIndex		; set inventory index
	lsr								; divide valye by 8 to set the inventory id
	lsr
	lsr
	sta selectedInventoryId			; set inventory id
FinalizeInventorySelection:
	lda #$0D		  ; Possibly sets UI state or inventory mode
	sta $A2		  ;3
	sec			  ; Set carry to indicate success
	rts			  ;6

	BOUNDARY 0
	
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
	
PlayfieldControlTable
	.byte MSBL_SIZE2 | PF_REFLECT
	.byte MSBL_SIZE2 | PF_REFLECT
	.byte MSBL_SIZE2 | PF_REFLECT
	.byte MSBL_SIZE2 | PF_REFLECT
	.byte MSBL_SIZE8 | PF_REFLECT
	.byte MSBL_SIZE2 | PF_REFLECT
	.byte MSBL_SIZE4 | PF_PRIORITY | PF_REFLECT
	.byte MSBL_SIZE1 | PF_PRIORITY | PF_REFLECT
	.byte MSBL_SIZE1 | PF_PRIORITY | PF_REFLECT
	.byte MSBL_SIZE1 | PF_REFLECT	
	.byte MSBL_SIZE1 | PF_REFLECT	
	.byte MSBL_SIZE1 | PF_PRIORITY | PF_REFLECT
	.byte MSBL_SIZE1 | PF_PRIORITY | PF_REFLECT
	.byte MSBL_SIZE1 | PF_REFLECT

BackgroundColorTable
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

PlayfieldColorTable
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
	
Player0ColorTable
	.byte BLUE + 8					; Treasure Room
	.byte LT_RED + 8				; Marketplace Room
	.byte BROWN + 8					; Entrance Room - Whip
	.byte ORANGE +10				; Black Market - Shovel
	.byte LT_RED + 6				; Map Room - Marker
	.byte GREEN_BLUE + 8			; Mesa Side - Indy Parachute
	
RoomPlayer0Height
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

RoomTypeTable:
	.byte $78,$4C,$5D,$4C,$4
	
RoomPlayer0MSBGraphicData
	.byte >TreasureRoomPlayerGraphics
	.byte >MarketplacePlayerGraphics
	.byte >EntranceRoomPlayerGraphics
	.byte >BlackMarketPlayerGraphics
	.byte >MapRoomPlayerGraphics
	.byte >MesaSidePlayerGraphics
	.byte $FA
	.byte $00
	.byte >ShiningLightSprites
	.byte >EmptySprite
	.byte >ThiefSprites
	.byte >ThiefSprites
	.byte >ThiefSprites
	
RoomPlayer0LSBGraphicData
	.byte <TreasureRoomPlayerGraphics
	.byte <MarketplacePlayerGraphics
	.byte <EntranceRoomPlayerGraphics
	.byte <BlackMarketPlayerGraphics
	.byte <MapRoomPlayerGraphics
	.byte <MesaSidePlayerGraphics
	.byte $C1
	.byte $E5
	.byte <ShiningLightSprites
	.byte <EmptySprite
	.byte <ThiefSprites
	.byte <ThiefSprites
	.byte <ThiefSprites
	
SnakeMotionTableLSB:
	.byte <SnakeMotionTable_0,<SnakeMotionTable_1,<SnakeMotionTable_3,<SnakeMotionTable_2
	
SnakeHorizontalOffsetTable:
	.byte $FE,$FA,$02,$06
	
RoomSpecialBehaviorTable:
	.byte $00,$00,$18,$04,$03,$03,$85,$85,$3B,$85,$85
	
RoomMissile0VertPosTable:
	.byte $20,$78,$85,$4D,$62,$17,$50,$50,$50,$50,$50,$12,$12
	
RoomMissile0InitVertPosTable:
	.byte $FF,$FF,$14,$4B,$4A,$44,$FF,$27,$FF,$FF,$FF,$F0,$F0
	
RoomPF1GraphicLSBTable:
	.byte <COLUP0,<COLUP0,<COLUP0,<COLUP0,<COLUP0,<COLUP0,<RoomPF1GraphicData_7,<RoomPF1GraphicData_8,<RoomPF1GraphicData_9,<RoomPF1GraphicData_10,<RoomPF1GraphicData_10
	
RoomPF1GraphicMSBTable:
	.byte >COLUP0,>COLUP0,>COLUP0,>COLUP0,>COLUP0,>COLUP0,>RoomPF1GraphicData_7,>RoomPF1GraphicData_8,>RoomPF1GraphicData_9,>RoomPF1GraphicData_10,>RoomPF1GraphicData_10
	
RoomPF2GraphicLSBTable:
	.byte <HMP0,<HMP0,<HMP0,<HMP0,<HMP0,<HMP0,<RoomPF1GraphicData_6,<RoomPF2GraphicData_7,<RoomPF2GraphicData_6,<RoomPF2GraphicData_9,<RoomPF2GraphicData_9
	
RoomPF2GraphicMSBTable:
	.byte >HMP0,>HMP0,>HMP0,>HMP0,>HMP0,>HMP0,>RoomPF1GraphicData_6,>RoomPF2GraphicData_7,>RoomPF2GraphicData_6,>RoomPF2GraphicData_9,>RoomPF2GraphicData_9
	
ItemStatusBitValues
	.byte BASKET_STATUS_MARKET_GRENADE | PICKUP_ITEM_STATUS_WHIP
	.byte BASKET_STATUS_BLACK_MARKET_GRENADE | PICKUP_ITEM_STATUS_SHOVEL
	.byte PICKUP_ITEM_STATUS_HEAD_OF_RA
	.byte BACKET_STATUS_REVOLVER | PICKUP_ITEM_STATUS_TIME_PIECE
	.byte BASKET_STATUS_COINS
	.byte BASKET_STATUS_KEY | PICKUP_ITEM_STATUS_HOUR_GLASS
	.byte PICKUP_ITEM_STATUS_ANKH
	.byte PICKUP_ITEM_STATUS_CHAI
	
ItemStatusClearMaskTable:
	.byte ~(BASKET_STATUS_MARKET_GRENADE | PICKUP_ITEM_STATUS_WHIP);$FE
	.byte ~(BASKET_STATUS_BLACK_MARKET_GRENADE | PICKUP_ITEM_STATUS_SHOVEL);$FD
	.byte ~PICKUP_ITEM_STATUS_HEAD_OF_RA;$FB
	.byte ~(BACKET_STATUS_REVOLVER | PICKUP_ITEM_STATUS_TIME_PIECE);$F7
	.byte ~BASKET_STATUS_COINS;$EF
	.byte ~(BASKET_STATUS_KEY | PICKUP_ITEM_STATUS_HOUR_GLASS);$DF
	.byte ~PICKUP_ITEM_STATUS_ANKH;$BF
	.byte ~PICKUP_ITEM_STATUS_CHAI;$7F
	
ItemIndexTable
	.byte $00						; empty
	.byte $00
	.byte $00						; flute
	.byte $00						; parachute
	.byte $08						; coins
	.byte $00						; grenade 0
	.byte $02						; grenade 1
	.byte $0A						; key
	.byte $0C
	.byte $0E
	.byte $01						; whip........C
	.byte $03						; shovel......C
	.byte $04
	.byte $06						; revolver
	.byte $05						; Ra..........C
	.byte $07						; Time piece..C
	.byte $0D						; Ankh........C
	.byte $0F						; Chai........C
	.byte $0B						; hour glass..C
	
RemoveItemFromInventoryJumpTable
	.word RemoveItemFromInventory - 1
	.word RemoveItemFromInventory - 1; remove Flute from inventory
	.word RemoveParachuteFromInventory - 1
	.word RemoveCoinsFromInventory - 1
	.word RemoveItemFromInventory - 1
	.word RemoveItemFromInventory - 1
	.word RemoveItemFromInventory - 1
	.word RemoveItemFromInventory - 1
	.word RemoveItemFromInventory - 1
	.word RemoveWhipFromInventory - 1
	.word RemoveShovelFromInventory - 1
	.word RemoveItemFromInventory - 1
	.word RemoveItemFromInventory - 1; remove revolver
	.word RemoveItemFromInventory - 1; remove Ra
	.word RemoveItemFromInventory - 1; remove time piece
	.word RemoveAnkhOrHourGlassFromInventory - 1
	.word RemoveChaiFromInventory - 1
	.word RemoveAnkhOrHourGlassFromInventory - 1
	
PlayerCollisionJumpTable
	.word HandleScreenCollisions - 1
	.word PlayerCollisionsInMarketplace - 1
	.word PlayerCollisionsInEntranceRoom - 1
	.word PlayerCollisionsInBlackMarket - 1
	.word HandleScreenCollisions - 1
	.word PlayerCollisionsInMesaSide - 1
	.word PlayerCollisionsInTempleEntrance - 1
	.word PlayerCollisionsInSpiderRoom - 1
	.word PlayerCollisionsInRoomOfShiningLight - 1
	.word HandleScreenCollisions - 1
	.word PlayerCollisionsInValleyOfPoison - 1
	.word PlayerCollisionsInThievesDen - 1
	.word PlayerCollisionsInWellOfSouls - 1
	
ID_TREASURE_ROOM		= 0 ;--
ID_MARKETPLACE			= 1 ; |
ID_ENTRANCE_ROOM		= 2 ; |
ID_BLACK_MARKET			= 3 ; | -- JumpIntoStationaryPlayerKernel
ID_MAP_ROOM				= 4 ; |
ID_MESA_SIDE			= 5 ;--

ID_TEMPLE_ENTRANCE		= 6 ;--
ID_SPIDER_ROOM			= 7 ; |
ID_ROOM_OF_SHINING_LIGHT = 8; | -- DrawPlayfieldKernel
ID_MESA_FIELD			= 9 ; |
ID_VALLEY_OF_POISON		= 10;--

ID_THIEVES_DEN			= 11;-- ThievesDenWellOfSoulsScanlineHandler
ID_WELL_OF_SOULS		= 12;-- ThievesDenWellOfSoulsScanlineHandler

ID_ARK_ROOM				= 13
	
PlayerPlayfieldCollisionJumpTable
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Treasure Room
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Marketplace
	.word IndyPlayfieldCollisionInEntranceRoom - 1  ; Entrance Room
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Black Market
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Map Room
	.word MoveIndyBasedOnInput - 1					; Mesa Side
	.word RestrictIndyMovementInTemple - 1			; Temple Entrance
	.word MoveIndyBasedOnInput - 1					; Spider Room
	.word PlayerCollisionsInRoomOfShiningLight - 1  ; Room of Shining Light
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Mesa Field
	.word SlowDownIndyMovement - 1					; Valley of Poison
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Thieves Den
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Well of Souls

RoomIdleHandlerJumpTable:
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	.word SetIndyToTriggeredState - 1
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	.word InitFallbackEntryPosition - 1
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	.word WarpToMesaSide - 1
	.word SetIndyToTriggeredState - 1
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	.word CheckIfIndyShotOrTouchedByTsetseFlies - 1
	
PlaceItemInInventory
	ldx numberOfInventoryItems		; get number of inventory items
	cpx #MAX_INVENTORY_ITEMS			; see if Indy carrying maximum number of items
	bcc .spaceAvailableForItem		; branch if Indy has room to carry more items
	clc
	rts

.spaceAvailableForItem
	ldx #10
.searchForEmptySpaceLoop
	ldy inventoryGraphicPointers,x	; get the LSB for the inventory graphic
	beq .addInventoryItem		; branch if nothing is in the inventory slot
	dex
	dex
	bpl .searchForEmptySpaceLoop
	brk								; break if no more items can be carried
.addInventoryItem
	tay								; move item number to y
	asl								; mutliply item number by 8 for graphic LSB
	asl
	asl
	sta inventoryGraphicPointers,x	; place graphic LSB in inventory
	lda numberOfInventoryItems		; get number of inventory items
	bne UpdateInventoryAfterPickup						; branch if Indy carrying items
	stx selectedInventoryIndex		; set index to newly picked up item
	sty selectedInventoryId			; set the current selected inventory id
UpdateInventoryAfterPickup:
	inc numberOfInventoryItems		; increment number of inventory items
	cpy #ID_INVENTORY_COINS
	bcc FinalizeInventoryAddition	  ;2
	tya								; move item number to accumulator
	tax								; move item number to x
	jsr ShowItemAsTaken
FinalizeInventoryAddition:
	lda #$0C
	sta $A2
	sec
	rts

ShowItemAsNotTaken
	lda ItemIndexTable,x				; get the item index value
	lsr								; shift D0 to carry
	tay
	lda ItemStatusClearMaskTable,y
	bcs .showPickUpItemAsNotTaken	; branch if item not a basket item
	and basketItemsStatus
	sta basketItemsStatus			; clear status bit showing item not taken
	rts

.showPickUpItemAsNotTaken
	and pickupItemsStatus
	sta pickupItemsStatus			; clear status bit showing item not taken
	rts

ShowItemAsTaken
	lda ItemIndexTable,x				; get the item index value
	lsr								; shift D0 to carry
	tax
	lda ItemStatusBitValues,x		; get item bit value
	bcs .pickUpItemTaken				; branch if item not a basket item
	ora basketItemsStatus
	sta basketItemsStatus			; show item taken
	rts

.pickUpItemTaken
	ora pickupItemsStatus
	sta pickupItemsStatus			; show item taken
	rts

DetermineIfItemAlreadyTaken
	lda ItemIndexTable,x				; get the item index value
	lsr								; shift D0 to carry
	tay
	lda ItemStatusBitValues,y		; get item bit value
	bcs .determineIfPickupItemTaken	; branch if item not a basket item
	and basketItemsStatus
	beq .doneDetermineIfItemAlreadyTaken; branch if item not taken from basket
	sec								; set carry for item taken already
.doneDetermineIfItemAlreadyTaken
	rts

.determineIfPickupItemTaken
	and pickupItemsStatus
	bne .doneDetermineIfItemAlreadyTaken
	clc								; clear carry for item not taken already
	rts

UpdateRoomEventState:
	and #$1F		  ;2
	tax			  ;2
	lda $98		  ;3
	cpx #$0C		  ;2
	bcs .doneUpdateRoomEventState	  ;2
	adc RoomEventStateOffsetTable,x	  ;4
	sta $98		  ;3
.doneUpdateRoomEventState:
	rts			  ;6
	
Start
;
; Set up everything so the power up state is known.
;
	sei								; disable interrupts
	cld								; clear decimal mode
	ldx #$FF
	txs								; set stack to the beginning
	inx								; x = 0
	txa
.clearLoop
	sta VSYNC,x
	dex
	bne .clearLoop
	dex								; x = -1
	stx adventurePoints
	lda #>InventorySprites
	sta inventoryGraphicPointers + 1
	sta inventoryGraphicPointers + 3
	sta inventoryGraphicPointers + 5
	sta inventoryGraphicPointers + 7
	sta inventoryGraphicPointers + 9
	sta inventoryGraphicPointers + 11
	lda #<Copyright_0
	sta inventoryGraphicPointers
	lda #<Copyright_1
	sta inventoryGraphicPointers + 2
	lda #<Copyright_2
	sta inventoryGraphicPointers + 6
	lda #<Copyright_3
	sta inventoryGraphicPointers + 4
	lda #<Copyright_4
	sta inventoryGraphicPointers + 8
	lda #ID_ARK_ROOM
	sta currentScreenId
	lsr
	sta numberOfBullets
	jsr InitializeScreenState
	jmp StartNewFrame
	
InitializeGameStartState:
	lda #<InventoryCoinsSprite
	sta inventoryGraphicPointers		; place coins in Indy's inventory
	lsr								; divide value by 8 to get the inventory id
	lsr
	lsr
	sta selectedInventoryId			; set the current selected inventory id
	inc numberOfInventoryItems		; increment number of inventory items
	lda #<EmptySprite
	sta inventoryGraphicPointers + 2 ; clear the remainder of Indy's inventory
	sta inventoryGraphicPointers + 4
	sta inventoryGraphicPointers + 6
	sta inventoryGraphicPointers + 8
	lda #INIT_SCORE
	sta adventurePoints
	lda #<IndyStationarySprite
	sta indyGraphicPointers
	lda #>IndySprites
	sta indyGraphicPointers + 1
	lda #$4C		  ;2
	sta indyHorizPos			;3
	lda #$0F		  ;2
	sta indyVertPos		  ;3
	lda #ID_ENTRANCE_ROOM
	sta currentScreenId
	sta lives
	jsr InitializeScreenState
	jmp	 SetupScreenVisualsAndObjects	  ;3
	
;------------------------------------------------------------DetermineFinalScore
;
; The player's progress is determined by Indy's height on the pedestal when the
; game is complete. The player wants to achieve the lowest adventure points
; possible to lower Indy's position on the pedestal.
;
DetermineFinalScore
	lda adventurePoints				; get current adventure points
	sec
	sbc findingArkBonus				; reduce for finding the Ark of the Covenant
	sbc usingParachuteBonus			; reduce for using the parachute
	sbc skipToMesaFieldBonus			; reduce if player skipped the Mesa field
	sbc findingYarEasterEggBonus		; reduce if player found Yar
	sbc lives						; reduce by remaining lives
	sbc usingHeadOfRaInMapRoomBonus	; reduce if player used the Head of Ra
	sbc landingInMesaBonus			; reduce if player landed in Mesa
	sbc $AE		  ;3
	clc
	adc grenadeOpeningPenalty		; add 2 if Entrance Room opening activated
	adc escapedShiningLightPenalty	; add 13 if escaped from Shining Light prison
	adc shootingThiefPenalty			; add 4 if shot a thief
	sta adventurePoints
	rts

RoomScratchpadTable:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
RoomOverrideKeyTable:
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$FF,$FF,$FF,$FF,$FF,$4F,$4F,$4F
	.byte $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F,$44,$44,$0F,$0F,$1C,$0F,$0F,$18
	.byte $0F,$0F,$0F,$0F,$0F,$12,$12,$89,$89,$8C,$89,$89,$86,$89,$89,$89
	.byte $89,$89,$86,$86
RoomVerticalOverrideFlagTable:
	.byte $FF,$FD,$FF,$FF,$FD,$FF,$FF,$FF,$FD,$01,$FD,$04,$FD,$FF,$FD,$01
	.byte $FF,$0B,$0A,$FF,$FF,$FF,$04,$FF,$FD,$FF,$FD,$FF,$FF,$FF,$FF,$FF
	.byte $FE,$FD,$FD,$FF,$FF,$FF,$FF,$FF,$FD,$FD,$FE,$FF,$FF,$FE,$FD,$FD
	.byte $FF,$FF,$FF,$FF
RoomOverrideLowerHorizBoundaryTable:
	.byte $00,$1E,$00,$00,$11,$00,$00,$00,$11,$00,$10,$00,$60,$00,$11,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$70,$00,$12,$00,$00,$00,$00,$00
	.byte $30,$15,$24,$00,$00,$00,$00,$00,$18,$03,$27,$00,$00,$30,$20,$12
	.byte $00,$00,$00,$00
RoomOverrideUpperHorizBoundaryTable:
	.byte $00,$7A,$00,$00,$88,$00,$00,$00,$88,$00,$80,$00,$65,$00,$88,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$72,$00,$16,$00,$00,$00,$00,$00
	.byte $02,$1F,$2F,$00,$00,$00,$00,$00,$1C,$40,$01,$00,$00,$07,$27,$16
	.byte $00,$00,$00,$00
RoomAdvancedOverrideControlTable:
	.byte $00,$02,$00,$00,$09,$00,$00,$00,$07,$00,$FC,$00,$05,$00,$09,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$FF,$00,$00,$00,$00,$00
	.byte $01,$06,$FE,$00,$00,$00,$00,$00,$FB,$FD,$0B,$00,$00,$08,$08,$00
	.byte $00,$00,$00,$00
RoomVerticalPositionOverrideTable:
	.byte $00,$4E,$00,$00,$4E,$00,$00,$00,$4D,$4E,$4E,$4E,$04,$01,$03,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$40,$00,$23,$00,$00,$00,$00,$00
	.byte $00,$00,$41,$00,$00,$00,$00,$00,$45,$00,$42,$00,$00,$00,$42,$23
	.byte $28,$00,$00,$00
RoomHorizontalPositionOverrideTable:
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$4C,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$86,$00,$00,$00,$00,$00
	.byte $80,$86,$80,$00,$00,$00,$00,$00,$12,$12,$4C,$00,$00,$16,$80,$12
	.byte $50,$00,$00,$00
RoomEventOffsetTable:
	.byte $01,$FF,$01,$FF
	
EntranceRoomTopObjectVertPos
	.byte ENTRANCE_ROOM_ROCK_VERT_POS
	.byte ENTRANCE_ROOM_CAVE_VERT_POS
	
RoomObjectVertOffsetTable:
	.byte $00,$00,$42,$45,$0C,$20
	
MarketBasketItems
	.byte ID_INVENTORY_COINS, ID_INVENTORY_CHAI
	.byte ID_INVENTORY_ANKH, ID_INVENTORY_HOUR_GLASS
	
ArkRoomImpactResponseTable:
	.byte $07,$03,$05,$06,$09,$0B,$0E,$00,$01,$03,$05,$00,$09,$0C,$0E,$00
	.byte $01,$04,$05,$00,$0A,$0C,$0F,$00,$02,$04,$05,$08,$0A,$0D,$0F,$00
	
JumpToDisplayKernel SUBROUTINE
.waitTime
	lda INTIM
	bne .waitTime
	sta WSYNC
	sta WSYNC
	lda #<DisplayKernel
	sta bankSwitchJMPAddress
	lda #>DisplayKernel
	sta bankSwitchJMPAddress + 1
JumpToBank1
	lda #LDA_ABS
	sta bankSwitchLDAInstruction
	lda #<BANK1STROBE
	sta bankStrobeAddress
	lda #>BANK1STROBE
	sta bankStrobeAddress + 1
	lda #JMP_ABS
	sta bankSwitchJMPInstruction
	jmp.w bankSwitchingVariables
	
DetermineDirectionToMoveObject
	ror
	bcs .checkToMoveObjectDown
	dec objectVertPositions,x		; move object up one pixel
.checkToMoveObjectDown
	ror
	bcs .checkToMoveObjectLeft
	inc objectVertPositions,x		; move object down one pixel
.checkToMoveObjectLeft
	ror
	bcs .checkToMoveObjectRight
	dec objectHorizPositions,x		; move object left one pixel
.checkToMoveObjectRight
	ror
	bcs .doneDetermineDirectionToMoveObject
	inc objectHorizPositions,x		; move object right one pixel
.doneDetermineDirectionToMoveObject
	rts

IndyMovementDeltaTable:
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
	
RoomEventStateOffsetTable:
	.byte $00,$06,$03,$03,$03,$00,$00,$06,$00,$00,$00,$06
	
	  .org BANK0TOP + 4096 - 6, 0
	  .word Start
	  .word Start
	  .word Start
	  
;============================================================================
; R O M - C O D E  (BANK 1)
;============================================================================

	SEG Bank1
	.org BANK1TOP
	.rorg BANK1_REORG

BANK1Start	 
	lda BANK0STROBE
	
DrawPlayfieldKernel
	cmp $E0		  ;3
	bcs DungeonWallScanlineHandler	  ;2
	lsr			  ;2
	clc			  ;2
	adc $DF		  ;3
	tay			  ;2
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3 = @03
	lda (pf1GraphicPointers),y ; 5
	sta PF1					  ; 3 = @11
	lda (pf2GraphicPointers),y ; 5
	sta PF2					  ; 3 = @19
	bcc .drawPlayerSprites	  ; 2�
DungeonWallScanlineHandler:
	sbc $D4		  ;3
	lsr			  ;2
	lsr			  ;2
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3 = @03
	tax						  ; 2
	cpx snakeVertPos			  ; 3
	bcc DrawDungeonWallScanline	  ;2
	ldx $D8		  ;3
	lda #$00		  ;2
	beq StoreDungeonWallScanline				  ; 3
	
DrawDungeonWallScanline:
	lda dungeonGraphics,x	  ; 4
	ldx $D8		  ;3
StoreDungeonWallScanline:
	sta PF1,x	  ;4
.drawPlayerSprites
	ldx #<ENAM1				  ; 2
	txs						  ; 2
	lda scanline				  ; 3
	sec						  ; 2
	sbc indyVertPos			  ; 3
	cmp indySpriteHeight		  ; 3
	bcs .skipIndyDraw		  ; 2�
	tay						  ; 2
	lda (indyGraphicPointers),y;5
	tax						  ; 2
DrawPlayer0Sprite:
	lda scanline				  ; 3
	sec						  ; 2
	sbc topObjectVertPos		  ; 3
	cmp player0SpriteHeight	  ; 3
	bcs .skipDrawingPlayer0	  ; 2�
	tay						  ; 2
	lda (player0GraphicPointers),y;5
	tay						  ; 2
.nextPlayfieldScanline
	lda scanline				  ; 3
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	cmp bulletOrWhipVertPos	  ; 3
	php						  ; 3 = @09	  enable / disable M1
	cmp missile0VertPos		  ; 3
	php						  ; 3 = @15	  enable / disable M0
	stx GRP1					  ; 3 = @18
	sty GRP0					  ; 3 = @21
	sec						  ; 2
	sbc $D2		  ;3
	cmp #$08		  ;2
	bcs AdvanceToNextPlayfieldScanline	  ;2
	tay						  ; 2
	lda (timePieceGraphicPointers),y;5
	sta ENABL				  ; 3 = @40
	sta HMBL					  ; 3 = @43
AdvanceToNextPlayfieldScanline:
	inc scanline				  ; 5		  increment scanline
	lda scanline				  ; 3
	cmp #(H_KERNEL / 2)		  ; 2
	bcc DrawPlayfieldKernel	  ; 2�
	jmp InventoryKernel		  ; 3
	
.skipIndyDraw
	ldx #0					  ; 2
	beq DrawPlayer0Sprite	  ;2
	
.skipDrawingPlayer0
	ldy #0					  ; 2
	beq .nextPlayfieldScanline ; 2�
	
DrawStationaryPlayerKernel SUBROUTINE
.checkToEndKernel
	cpx #(H_KERNEL / 2) - 1	  ; 2
	bcc .skipDrawingPlayer0	  ; 2�
	jmp InventoryKernel		  ; 3
	
.skipDrawingPlayer0
	lda #0					  ; 2
	beq .nextStationaryPlayerScanline;3	  unconditional branch
	
DrawStationaryPlayer0Sprite:
	lda (player0GraphicPointers),y;5
	bmi .setPlayer0Values	  ; 2�
	cpy bottomObjectVertPos	  ; 3
	bcs .checkToEndKernel	  ; 2�
	cpy topObjectVertPos		  ; 3
	bcc .skipDrawingPlayer0	  ; 2�
	sta GRP0					  ; 3
	bcs .nextStationaryPlayerScanline;3	  unconditional branch
	
.setPlayer0Values
	asl						  ; 2		  shift value left
	tay						  ; 2		  move value to y
	and #2					  ; 2		  value 0 || 2
	tax						  ; 2		  set for correct pointer index
	tya						  ; 2		  move value to accumulator
	sta (player0TIAPointers,x) ; 6		  set player 0 color or fine motion
.nextStationaryPlayerScanline
	inc scanline				  ; 5		  increment scan line
	ldx scanline				  ; 3		  get current scan line
	lda #ENABLE_BM			  ; 2
	cpx missile0VertPos		  ; 3
	bcc .skipDrawingMissile0	  ; 2�		 branch if not time to draw missile
	cpx $E0		  ;3
	bcc .setEnableMissileValue ; 2�
.skipDrawingMissile0
	ror						  ; 2		  shift ENABLE_BM right
.setEnableMissileValue
	sta ENAM0				  ; 3
JumpIntoStationaryPlayerKernel
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	txa						  ; 2		  move scan line count to accumulator
	sec						  ; 2
	sbc snakeVertPos			  ; 3		  subtract Snake vertical position
	cmp #16					  ; 2
	bcs .waste19Cycles		  ; 2�
	tay						  ; 2
	cmp #8					  ; 2
	bcc .waste05Cycles		  ; 2�
	lda $D8					  ; 3
	sta timePieceGraphicPointers;3
DrawTimepieceOrBallSprite:
	lda (timePieceGraphicPointers),y;5
	sta HMBL					  ; 3 = @34
SetMissile1EnableForScanline:
	ldy #DISABLE_BM			  ; 2
	txa						  ; 2		  move scanline count to accumulator
	cmp bulletOrWhipVertPos	  ; 3
	bne UpdateMissile1EnableForScanline				  ; 2�
	dey						  ; 2		  y = -1
UpdateMissile1EnableForScanline:
	sty ENAM1				  ; 3 = @48
	sec						  ; 2
	sbc indyVertPos			  ; 3
	cmp indySpriteHeight		  ;	 3
	bcs SkipDrawingStationaryPlayer1Sprite				  ; 2�+1
	tay						  ; 2
	lda (indyGraphicPointers),y; 5
DrawStationaryPlayer1Sprite:
	ldy scanline				  ; 3
	sta GRP1					  ; 3 = @71
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	lda #ENABLE_BM			  ; 2
	cpx $D2					  ; 3
	bcc SkipDrawingBall				  ; 2�
	cpx $DC					  ; 3
	bcc SetBallEnableForScanline				  ; 2�
.skipDrawingBall
	ror						  ; 2
SetBallEnableForScanline:
	sta ENABL				  ; 3 = @20
	bcc DrawStationaryPlayer0Sprite				  ; 3		  unconditional branch
	
SkipDrawingBall:
	bcc .skipDrawingBall		  ; 3		  unconditional branch
	
.waste05Cycles
	SLEEP 2					  ; 2
	jmp DrawTimepieceOrBallSprite				  ; 3
	
.waste19Cycles
	pha						  ; 3
	pla						  ; 4
	pha						  ; 3
	pla						  ; 4
	SLEEP 2					  ; 2
	jmp SetMissile1EnableForScanline				  ; 3
	
SkipDrawingStationaryPlayer1Sprite:
	lda #0					  ; 2
	beq DrawStationaryPlayer1Sprite				  ; 3+1		  unconditional branch
	
AdvanceStationaryKernelScanline:
	inx						  ; 2		  increment scanline
	sta HMCLR				  ; 3		  clear horizontal movement registers
	cpx #H_KERNEL			  ; 2
	bcc ThievesDenWellOfSoulsScanlineHandler				  ; 2�
	jmp InventoryKernel		  ; 3
	
ThievesDenOrWellOfTheSoulsKernel
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	inx						  ; 2		  increment scanline
	lda $84					  ; 3
	sta GRP0					  ; 3 = @11
	lda $85					  ; 3
	sta COLUP0				  ; 3 = @17
	txa						  ; 2		  move canline to accumulator
	ldx #<ENABL				  ; 2
	txs						  ; 2
	tax						  ; 2		  move scanline to x
	lsr						  ; 2		  divide scanline by 2
	cmp $D2					  ; 3
	php						  ; 3 = @33	  enable / disable BALL
	cmp bulletOrWhipVertPos	  ; 3
	php						  ; 3 = @39	  enable / disable M1
	cmp missile0VertPos		  ; 3
	php						  ; 3 = @45	  enable / disable M0
	sec						  ; 2
	sbc indyVertPos			  ; 3
	cmp indySpriteHeight		  ; 3
	bcs AdvanceStationaryKernelScanline				  ; 2�
	tay						  ; 2		  move scanline value to y
	lda (indyGraphicPointers),y; 5		  get Indy graphic data
	sta HMCLR				  ; 3 = @65	  clear horizontal movement registers
	inx						  ; 2		  increment scanline
	sta GRP1					  ; 3 = @70
ThievesDenWellOfSoulsScanlineHandler:
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	bit $D4					  ; 3
	bpl ThiefSpriteDrawAndAnimationHandler				  ; 2�
	ldy $89					  ; 3
	lda $88					  ; 3
	lsr $D4					  ; 5
ThiefSpritePositionTimingLoop:
	dey						  ; 2
	bpl ThiefSpritePositionTimingLoop				  ; 2�
	sta RESP0				  ; 3
	sta HMP0					  ; 3
	bmi ThievesDenOrWellOfTheSoulsKernel;3 unconditional branch
	
ThiefSpriteDrawAndAnimationHandler:
	bvc ThiefSpriteStateUpdateHandler				  ; 2�
	txa						  ; 2
	and #$0F					  ; 2
	tay						  ; 2
	lda (player0GraphicPointers),y;5
	sta GRP0					  ; 3 = @25
	lda (player0ColorPointers),y;5
	sta COLUP0				  ; 3 = @33
	iny						  ; 2
	lda (player0GraphicPointers),y;5
	sta $84					  ; 3
	lda (player0ColorPointers),y;5
	sta $85					  ; 3
	cpy player0SpriteHeight	  ; 3
	bcc ReturnToThievesDenKernel				  ; 2�
	lsr $D4					  ; 5
ReturnToThievesDenKernel:
	jmp ThievesDenOrWellOfTheSoulsKernel;3
	
ThiefSpriteStateUpdateHandler:
	lda #$20		  ;2
	bit $D4		  ;3
	beq ThiefSpriteAnimationFrameSetup	  ;2
	txa			  ;2
	lsr			  ;2
	lsr			  ;2
	lsr			  ;2
	lsr			  ;2
	lsr			  ;2
	bcs ThievesDenOrWellOfTheSoulsKernel;2�
	tay			  ;2
	sty $87		  ;3
	lda thievesDirectionAndSize,y;4
	sta REFP0	  ;3
	sta NUSIZ0	  ;3
	sta $86		  ;3
	bpl LF1A2	  ;2
	lda $96		  ;3
	sta player0GraphicPointers;3
	lda #$65		  ;2
	sta player0ColorPointers
	lda #$00		  ;2
	sta $D4		  ;3
	jmp ThievesDenOrWellOfTheSoulsKernel;3
	
LF1A2:
	lsr $D4		  ;5
	jmp ThievesDenOrWellOfTheSoulsKernel;3
	
ThiefSpriteAnimationFrameSetup:
	lsr			  ;2
	bit $D4		  ;3
	beq ThiefSpriteAnimationFrameSpecialCase	  ;2
	ldy $87		  ;3
	lda #$08		  ;2
	and $86		  ;3
	beq ThiefSpriteAnimationFrameSelect	  ;2
	lda #$03		  ;2
ThiefSpriteAnimationFrameSelect:
	eor thievesHMOVEIndex,y
	and #3							; 4 frames of animation for the Thief
	tay
	lda ThiefSpriteLSBValues,y
	sta player0GraphicPointers		; set Thief graphic LSB value
	lda #<ThiefColors
	sta player0ColorPointers
	lda #H_THIEF - 1
	sta player0SpriteHeight	  ; 3
	lsr $D4		  ;5
	jmp ThievesDenOrWellOfTheSoulsKernel;3
	
ThiefSpriteAnimationFrameSpecialCase:
	txa			  ;2
	and #$1F		  ;2
	cmp #$0C		  ;2
	beq ThiefSpriteSpecialFrameHandler	  ;2
	jmp ThievesDenOrWellOfTheSoulsKernel;3
	
ThiefSpriteSpecialFrameHandler:
	ldy $87		  ;3
	lda thievesHorizPositions,y; 4
	sta $88		  ;3
	and #$0F		  ;2
	sta $89		  ;3
	lda #$80		  ;2
	sta $D4		  ;3
	jmp ThievesDenOrWellOfTheSoulsKernel;3
	
InventoryKernel
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	ldx #$FF					  ; 2
	stx PF1					  ; 3 = @08
	stx PF2					  ; 3 = @11
	inx						  ; 2		  x = 0
	stx GRP0					  ; 3 = @16
	stx GRP1					  ; 3 = @19
	stx ENAM0				  ; 3 = @22
	stx ENAM1				  ; 3 = @25
	stx ENABL				  ; 3 = @28
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	lda #THREE_COPIES		  ; 2
	ldy #NO_REFLECT			  ; 2
	sty REFP1				  ; 3 = @10
	sta NUSIZ0				  ; 3 = @13
	sta NUSIZ1				  ; 3 = @16
	sta VDELP0				  ; 3 = @19
	sta VDELP1				  ; 3 = @22
	sty GRP0					  ; 3 = @25
	sty GRP1					  ; 3 = @28
	sty GRP0					  ; 3 = @31
	sty GRP1					  ; 3 = @34
	SLEEP 2					  ; 2
	sta RESP0				  ; 3 = @39
	sta RESP1				  ; 3 = @42
	sty HMP1					  ; 3 = @45
	lda #HMOVE_R1			  ; 2
	sta HMP0					  ; 3 = @50
	sty REFP0				  ; 3 = @53
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	lda #YELLOW + 10			  ; 2
	sta COLUP0				  ; 3 = @08
	sta COLUP1				  ; 3 = @11
	lda selectedInventoryIndex ; 3		  get selected inventory index
	lsr						  ; 2		  divide value by 2
	tay						  ; 2
	lda InventoryIndexHorizValues,y;4
	sta HMBL					  ; 3 = @25	  set fine motion for inventory indicator
	and #$0F					  ; 2		  keep coarse value
	tay						  ; 2
	ldx #HMOVE_0				  ; 2
	stx HMP0					  ; 3 = @34
	sta WSYNC
;--------------------------------------
	stx PF0					  ; 3 = @03
	stx COLUBK				  ; 3 = @06
	stx PF1					  ; 3 = @09
	stx PF2					  ; 3 = @12
.coarseMoveInventorySelector
	dey						  ; 2
	bpl .coarseMoveInventorySelector;2�
	sta RESBL				  ; 3
	stx CTRLPF				  ; 3
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	lda #$3F					  ; 2
	and frameCount			  ; 3
	bne UpdateInventoryDisplay	  ;2
	lda #$3F		  ;2
	and secondsTimer			;3
	bne UpdateInventoryDisplay	  ;2
	lda $B5		  ;3
	and #$0F		  ;2
	beq UpdateInventoryDisplay	  ;2
	cmp #$0F		  ;2
	beq UpdateInventoryDisplay	  ;2
	inc $B5		  ;5
UpdateInventoryDisplay:
	sta WSYNC
;--------------------------------------
	lda #ORANGE + 2			  ; 2
	sta COLUBK				  ; 3 = @05
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	lda #H_INVENTORY_SPRITES - 1;2
	sta loopCount			  ; 3
.drawInventorySprites
	ldy loopCount			  ; 3
	lda (inventoryGraphicPointers),y;5
	sta GRP0					  ; 3
	sta WSYNC
;--------------------------------------
	lda (inventoryGraphicPointers + 2),y;5
	sta GRP1					  ; 3 = @08
	lda (inventoryGraphicPointers + 4),y;5
	sta GRP0					  ; 3 = @16
	lda (inventoryGraphicPointers + 6),y;5
	sta tempCharHolder		  ; 3
	lda (inventoryGraphicPointers + 8),y;5
	tax						  ; 2
	lda (inventoryGraphicPointers + 10),y;5
	tay						  ; 2
	lda tempCharHolder		  ; 3
	sta GRP1					  ; 3 = @44
	stx GRP0					  ; 3 = @47
	sty GRP1					  ; 3 = @50
	sty GRP0					  ; 3 = @53
	dec loopCount			  ; 5
	bpl .drawInventorySprites  ; 2�
	lda #0					  ; 2
	sta WSYNC
;--------------------------------------
	sta GRP0					  ; 3 = @03
	sta GRP1					  ; 3 = @06
	sta GRP0					  ; 3 = @09
	sta GRP1					  ; 3 = @12
	sta NUSIZ0				  ; 3 = @15
	sta NUSIZ1				  ; 3 = @18
	sta VDELP0				  ; 3 = @21
	sta VDELP1				  ; 3 = @23
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	ldy #ENABLE_BM			  ; 2
	lda numberOfInventoryItems ; 3		  get number of inventory items
	bne UpdateInventoryBallAndPlayfield				  ; 2�		 branch if Indy carry items
	dey						  ; 2		  y = 1
UpdateInventoryBallAndPlayfield:
	sty ENABL				  ; 3 = @12
	ldy #BLACK + 8			  ; 2
	sty COLUPF				  ; 3 = @17
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	ldy #DISABLE_BM			  ; 2
	sty ENABL				  ; 3 = @05
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
Overscan
	ldx #$0F
	stx VBLANK						; turn off TIA (D1 = 1)
	ldx #OVERSCAN_TIME
	stx TIM64T						; set timer for overscan period
	ldx #$FF
	txs								; point stack to the beginning
	ldx #$01		  ;2
UpdateSoundRegistersDuringOverscan:
	lda $A2,x	  ;4
	sta AUDC0,x	  ;4
	sta AUDV0,x	  ;4
	bmi UpdateSpecialSoundEffectDuringOverscan	  ;2
	ldy #$00		  ;2
	sty $A2,x	  ;4
UpdateSoundFrequencyDuringOverscan:
	sta AUDF0,x	  ;4
	dex			  ;2
	bpl UpdateSoundRegistersDuringOverscan	  ;2
	bmi OverscanSoundUpdateDone						; unconditional branch
	
UpdateSpecialSoundEffectDuringOverscan:
	cmp #$9C		  ;2
	bne UpdateSoundEffectFromFrameCount	  ;2
	lda #$0F		  ;2
	and frameCount		 ;3
	bne UpdateSoundEffectTimerDuringOverscan	  ;2
	dec $A4		  ;5
	bpl UpdateSoundEffectTimerDuringOverscan	  ;2
	lda #$17		  ;2
	sta $A4		  ;3
UpdateSoundEffectTimerDuringOverscan:
	ldy $A4		  ;3
	lda OverscanSpecialSoundEffectTable,y	  ;4
	bne UpdateSoundFrequencyDuringOverscan	  ;2
UpdateSoundEffectFromFrameCount:
	lda frameCount					; get current frame count
	lsr			  ;2
	lsr			  ;2
	lsr			  ;2
	lsr			  ;2
	tay			  ;2
	lda OverscanSoundEffectTable,y	  ;4
	bne UpdateSoundFrequencyDuringOverscan	  ;2
OverscanSoundUpdateDone:
	lda selectedInventoryId			; get current selected inventory id
	cmp #ID_INVENTORY_TIME_PIECE
	beq UpdateInventoryTimepieceDisplay	  ;2
	cmp #ID_INVENTORY_FLUTE
	bne ResetInventoryDisplayState	  ;2
	lda #$84		  ;2
	sta $A3		  ;3
	bne UpdateInventoryAndEventStateAfterReset						; unconditional branch
	
UpdateInventoryTimepieceDisplay:
	bit INPT5						; read action button from right controller
	bpl UpdateTimepieceInventorySprite						; branch if action button pressed
	lda #<InventoryTimepieceSprite
	bne StoreTimepieceInventorySprite						; unconditional branch
	
UpdateTimepieceInventorySprite:
	lda secondsTimer			;3
	and #$E0		  ;2
	lsr			  ;2
	lsr			  ;2
	adc #<Inventory12_00
StoreTimepieceInventorySprite:
	ldx selectedInventoryIndex
	sta inventoryGraphicPointers,x		;4
ResetInventoryDisplayState:
	lda #$00		  ;2
	sta $A3		  ;3
UpdateInventoryAndEventStateAfterReset:
	bit $93		  ;3
	bpl UpdateInventoryObjectPositions	  ;2
	lda frameCount					; get current frame count
	and #$07		  ;2
	cmp #$05		  ;2
	bcc UpdateInventoryEventAnimationState	  ;2
	ldx #$04		  ;2
	ldy #$01		  ;2
	bit majorEventFlag 	  ;3
	bmi SetInventoryEventStateY03	  ;2
	bit $A1		  ;3
	bpl UpdateInventoryEventStateAfterYSet	  ;2
SetInventoryEventStateY03:
	ldy #$03		  ;2
UpdateInventoryEventStateAfterYSet:
	jsr	 UpdateObjectPositionHandler	  ;6
UpdateInventoryEventAnimationState:
	lda frameCount					; get current frame count
	and #$06		  ;2
	asl			  ;2
	asl			  ;2
	sta $D6		  ;3
	lda #$FD		  ;2
	sta $D7		  ;3
UpdateInventoryObjectPositions:
	ldx #$02		  ;2
UpdateInventoryObjectPositionsLoop:
	jsr	 UpdateInventoryObjectPositionHandler	  ;6
	inx			  ;2
	cpx #$05		  ;2
	bcc UpdateInventoryObjectPositionsLoop	  ;2
	bit majorEventFlag 	  ;3
	bpl HandleInventorySelectionCycling	  ;2
	lda frameCount					; get current frame count
	bvs UpdateInventoryEventStateAfterFrameCount	  ;2
	and #$0F		  ;2
	bne SwitchToVerticalSync	  ;2
	ldx indySpriteHeight			;3
	dex			  ;2
	stx $A3		  ;3
	cpx #$03		  ;2
	bcc UpdateInventoryEventFrameCount	  ;2
	lda #$8F		  ;2
	sta bulletOrWhipVertPos
	stx indySpriteHeight			;3
	bcs SwitchToVerticalSync						; unconditional branch
	
UpdateInventoryEventFrameCount:
	sta frameCount		 ;3
	sec			  ;2
	ror majorEventFlag 	  ;5
UpdateInventoryEventStateAfterFrameCount:
	cmp #$3C		  ;2
	bcc UpdateIndySpriteHeightAndEventState	  ;2
	bne ResetIndySpriteHeight	  ;2
	sta $A3		  ;3
ResetIndySpriteHeight:
	ldy #$00		  ;2
	sty indySpriteHeight
UpdateIndySpriteHeightAndEventState:
	cmp #$78		  ;2
	bcc SwitchToVerticalSync	  ;2
	lda #H_INDY_SPRITE
	sta indySpriteHeight
	sta $A3		  ;3
	sta majorEventFlag 	  ;3
	dec lives
	bpl SwitchToVerticalSync	  ;2
	lda #$FF		  ;2
	sta majorEventFlag 	  ;3
	bne SwitchToVerticalSync						; unconditional branch
	
HandleInventorySelectionCycling:
	lda currentScreenId				; get the current screen id
	cmp #ID_ARK_ROOM
	bne CheckForCyclingInventorySelection; branch if not in ID_ARK_ROOM
SwitchToVerticalSync:
	lda #<VerticalSync
	sta bankSwitchJMPAddress
	lda #>VerticalSync
	sta bankSwitchJMPAddress + 1
	jmp JumpToBank0
	
CheckForCyclingInventorySelection
	bit $8D		  ;3
	bvs .doneCyclingInventorySelection
	bit $B4		  ;3
	bmi .doneCyclingInventorySelection
	bit $9A		  ;3
	bmi .doneCyclingInventorySelection
	lda #7
	and frameCount
	bne .doneCyclingInventorySelection;check to move inventory selector ~8 frames
	lda numberOfInventoryItems		; get number of inventory items
	and #MAX_INVENTORY_ITEMS
	beq .doneCyclingInventorySelection; branch if Indy not carrying items
	ldx selectedInventoryIndex
	lda inventoryGraphicPointers,x	; get inventory graphic LSB value
	cmp #<Inventory12_00
	bcc CheckForChoosingInventoryItem; branch if the item is not a clock sprite
	lda #<InventoryTimepieceSprite	; reset inventory item to the time piece
CheckForChoosingInventoryItem
	bit SWCHA						; check joystick values
	bmi .checkForCyclingLeftThroughInventory;branch if left joystick not pushed right
	sta inventoryGraphicPointers,x	; set inventory graphic LSB value
.cycleThroughInventoryRight
	inx
	inx
	cpx #11
	bcc .continueCycleInventoryRight
	ldx #0
.continueCycleInventoryRight
	ldy inventoryGraphicPointers,x	; get inventory graphic LSB value
	beq .cycleThroughInventoryRight	; branch if no item present (i.e. Blank)
	bne .setSelectedInventoryIndex	; unconditional branch
	
.checkForCyclingLeftThroughInventory
	bvs .doneCyclingInventorySelection; branch if left joystick not pushed left
	sta inventoryGraphicPointers,x
.cycleThroughInventoryLeft
	dex
	dex
	bpl .continueCycleInventoryLeft
	ldx #10
.continueCycleInventoryLeft
	ldy inventoryGraphicPointers,x
	beq .cycleThroughInventoryLeft	; branch if no item present (i.e. Blank)
.setSelectedInventoryIndex
	stx selectedInventoryIndex
	tya								; move inventory graphic LSB to accumulator
	lsr								; divide value by 8 (i.e. H_INVENTORY_SPRITES)
	lsr
	lsr
	sta selectedInventoryId			; set selected inventory id
	cpy #<InventoryHourGlassSprite
	bne .doneCyclingInventorySelection; branch if the Hour Glass not selected
	ldy #ID_MESA_FIELD
	cpy currentScreenId
	bne .doneCyclingInventorySelection; branch if not in Mesa Field
	lda #$49		  ;2
	sta $8D		  ;3
	lda indyVertPos					; get Indy's vertical position
	adc #9
	sta bulletOrWhipVertPos
	lda indyHorizPos
	adc #9
	sta bulletOrWhipHorizPos
.doneCyclingInventorySelection
	lda $8D		  ;3
	bpl HandleInventorySelectionAdjustment	  ;2
	cmp #$BF		  ;2
	bcs HandleInventorySelectionEdgeCase	  ;2
	adc #$10		  ;2
	sta $8D		  ;3
	ldx #$03		  ;2
	jsr	 InventorySelectionAdjustmentHandler	  ;6
	jmp	 ReturnToObjectCollisionHandler	  ;3
	
HandleInventorySelectionEdgeCase:
	lda #$70		  ;2
	sta bulletOrWhipVertPos
	lsr			  ;2
	sta $8D		  ;3
	bne ReturnToObjectCollisionHandler	  ;2
	
HandleInventorySelectionAdjustment:
	bit $8D		  ;3
	bvc ReturnToObjectCollisionHandler	  ;2
	ldx #$03		  ;2
	jsr	 InventorySelectionAdjustmentHandler	  ;6
	lda bulletOrWhipHorizPos			; get bullet or whip horizontal position
	sec			  ;2
	sbc #$04		  ;2
	cmp indyHorizPos			;3
	bne HandleInventorySelectionPositionCheck	  ;2
	lda #$03		  ;2
	bne HandleInventorySelectionBitwiseUpdate						; unconditional branch
	
HandleInventorySelectionPositionCheck:
	cmp #$11		  ;2
	beq HandleInventorySelectionSpecialValue	  ;2
	cmp #$84		  ;2
	bne HandleInventorySelectionVerticalCheck	  ;2
HandleInventorySelectionSpecialValue:
	lda #$0F		  ;2
	bne HandleInventorySelectionBitwiseUpdate						; unconditional branch
	
HandleInventorySelectionVerticalCheck:
	lda bulletOrWhipVertPos			; get bullet or whip vertical position
	sec			  ;2
	sbc #$05		  ;2
	cmp indyVertPos		  ;3
	bne HandleInventorySelectionBoundaryCheck	  ;2
	lda #$0C		  ;2
HandleInventorySelectionBitwiseUpdate:
	eor $8D		  ;3
	sta $8D		  ;3
	bne ReturnToObjectCollisionHandler	  ;2
HandleInventorySelectionBoundaryCheck:
	cmp #$4A		  ;2
	bcs HandleInventorySelectionSpecialValue	  ;2
ReturnToObjectCollisionHandler:
	lda #<CheckObjectCollisions
	sta bankSwitchJMPAddress
	lda #>CheckObjectCollisions
	sta bankSwitchJMPAddress + 1
JumpToBank0
	lda #LDA_ABS
	sta bankSwitchLDAInstruction
	lda #<BANK0STROBE
	sta bankStrobeAddress
	lda #>BANK0STROBE
	sta bankStrobeAddress + 1
	lda #JMP_ABS
	sta bankSwitchJMPInstruction
	jmp.w bankSwitchingVariables

ArkRoomKernel
.arkRoomKernelLoop
	sta WSYNC
;--------------------------------------
	cpx #18					  ; 2
	bcc .checkToDrawArk		  ; 2�
	txa						  ; 2		  move scanline to accumulator
	sbc indyVertPos			  ; 3
	bmi AdvanceArkRoomKernelScanline				  ; 2�
	cmp #(H_INDY_SPRITE - 1) * 2;2
	bcs .drawLiftingPedestal	  ; 2�
	lsr						  ; 2
	tay						  ; 2
	lda IndyStationarySprite,y ; 4
	jmp .drawPlayer1Sprite	  ; 3
	
.drawLiftingPedestal
	and #3					  ; 2
	tay						  ; 2
	lda LiftingPedestalSprite,y; 4
.drawPlayer1Sprite
	sta GRP1					  ; 3 = @27
	lda indyVertPos			  ; 3		  get Indy's vertical position
	sta COLUP1				  ; 3 = @33
AdvanceArkRoomKernelScanline:
	inx						  ; 2		  increment scanline count
	cpx #144					  ; 2
	bcs ArkRoomPedestalAndPlayer0ScanlineHandler				  ; 2�
	bcc .arkRoomKernelLoop	  ; 3		  unconditional branch
	
.checkToDrawArk
	bit resetEnableFlag				  ; 3
	bmi .skipDrawingArk		  ; 2�
	txa						  ; 2		  move scanline to accumulator
	sbc #H_ARK_OF_THE_COVENANT ; 2
	bmi .skipDrawingArk		  ; 2�
	tay						  ; 2
	lda ArkOfTheCovenantSprite,y;4
	sta GRP1					  ; 3
	txa						  ; 2		  move scanline to accumulator
	adc frameCount			  ; 3		  increase value by current frame count
	asl						  ; 2		  multiply value by 2
	sta COLUP1				  ; 3		  color Ark of the Covenant sprite
.skipDrawingArk
	inx						  ; 2
	cpx #15					  ; 2
	bcc .arkRoomKernelLoop	  ; 2�
ArkRoomPedestalAndPlayer0ScanlineHandler:
	sta WSYNC
;--------------------------------------
	cpx #32					  ; 2
	bcs .checkToDrawPedestal	  ; 2�+1
	bit resetEnableFlag				  ; 3
	bmi ArkRoomPedestalScanlineLoop	  ;2
	txa						  ; 2		  move scanline to accumulator
	ldy #%01111110			  ; 2
	and #$0E		  ;2
	bne .drawPlayer0Sprite	  ; 2�
	ldy #%11111111			  ; 2
.drawPlayer0Sprite
	sty GRP0					  ; 3
	txa						  ; 2
	eor #$FF		  ;2
	sta COLUP0	  ;3
ArkRoomPedestalScanlineLoop:
	inx			  ;2
	cpx #29					  ;2
	bcc ArkRoomPedestalAndPlayer0ScanlineHandler	  ;2
	lda #0					  ; 2
	sta GRP0					  ; 3
	sta GRP1					  ; 3
	beq .arkRoomKernelLoop	  ; 2�+1		 unconditional branch
	
.checkToDrawPedestal
	txa						  ; 2 = @08
	sbc #144					  ; 2
	cmp #H_PEDESTAL			  ; 2
	bcc .drawPedestal		  ; 2�
	jmp InventoryKernel		  ; 3
	
.drawPedestal
	lsr						  ; 2		  divide by 4 to read graphic data
	lsr						  ; 2
	tay						  ; 2
	lda PedestalSprite,y		  ; 4
	sta GRP0					  ; 3 = @28
	stx COLUP0				  ; 3 = @31
	inx						  ; 2
	bne ArkRoomPedestalAndPlayer0ScanlineHandler				  ; 3		  unconditional branch
	
JumpToScreenHandlerFromBank1:
	lda currentScreenId				; get the current screen id
	asl								; multiply screen id by 2
	tax
	lda ScreenHandlerJumpTable + 1,x
	pha
	lda ScreenHandlerJumpTable,x
	pha
	rts

MesaFieldScreenHandler:
	lda #$7F		  ;2
	sta $CE		  ;3
	sta missile0VertPos
	sta $D2		  ;3
	bne ReturnToScreenHandlerFromSpiderRoom						; unconditional branch
	
SpiderRoomScreenHandler:
	ldx #$00		  ;2
	ldy #<indyVertPos - objectVertPositions
	bit CXP1FB						; check Indy collision with playfield
	bmi SpiderRoomObjectPositionHandler						; branch if Indy collided with playfield
	bit $B6		  ;3
	bmi SpiderRoomObjectPositionHandler	  ;2
	lda frameCount					; get the current frame count
	and #$07		  ;2
	bne SpiderRoomSpriteAndStateHandler	  ;2
	ldy #$05		  ;2
	lda #$4C		  ;2
	sta $CD		  ;3
	lda #$23		  ;2
	sta $D3		  ;3
SpiderRoomObjectPositionHandler:
	jsr	 UpdateObjectPositionHandler	  ;6
SpiderRoomSpriteAndStateHandler:
	lda #$80		  ;2
	sta $93		  ;3
	lda $CE		  ;3
	and #$01		  ;2
	ror $C8		  ;5
	rol			  ;2
	tay			  ;2
	ror			  ;2
	rol $C8		  ;5
	lda SpiderRoomPlayer0SpriteTable,y	  ;4
	sta player0GraphicPointers;3
	lda #$FC		  ;2
	sta player0GraphicPointers + 1;3
	lda $8E		  ;3
	bmi ReturnToScreenHandlerFromSpiderRoom	  ;2
	ldx #$50		  ;2
	stx $CA		  ;3
	ldx #$26		  ;2
	stx missile0VertPos
	lda $B6		  ;3
	bmi ReturnToScreenHandlerFromSpiderRoom	  ;2
	bit majorEventFlag 	  ;3
	bmi ReturnToScreenHandlerFromSpiderRoom	  ;2
	and #$07		  ;2
	bne SpiderRoomSpriteStateUpdate	  ;2
	ldy #$06		  ;2
	sty $B6		  ;3
SpiderRoomSpriteStateUpdate:
	tax			  ;2
	lda TreasureRoomPlayer0SpriteStateTable,x	  ;4
	sta $8E		  ;3
	dec $B6		  ;5
ReturnToScreenHandlerFromSpiderRoom:
	jmp	 ReturnToScreenHandlerFromBank1	  ;3
	
ValleyOfPoisonScreenHandler:
	lda #$80		  ;2
	sta $93		  ;3
	ldx #$00		  ;2
	bit majorEventFlag 	  ;3
	bmi ValleyOfPoisonObjectSetup	  ;2
	bit pickupStatusFlags 
	bvc ValleyOfPoisonObjectUpdateHandler	  ;2
ValleyOfPoisonObjectSetup:
	ldy #$05		  ;2
	lda #$55		  ;2
	sta $CD		  ;3
	sta $D3		  ;3
	lda #$01		  ;2
	bne ValleyOfPoisonObjectUpdateLoop						; unconditional branch
	
ValleyOfPoisonObjectUpdateHandler:
	ldy #<indyVertPos - objectVertPositions
	lda #$03		  ;2
ValleyOfPoisonObjectUpdateLoop:
	and frameCount		 ;3
	bne ValleyOfPoisonObjectBoundaryHandler	  ;2
	jsr	 UpdateObjectPositionHandler	  ;6
	lda $CE		  ;3
	bpl ValleyOfPoisonObjectBoundaryHandler	  ;2
	cmp #$A0		  ;2
	bcc ValleyOfPoisonObjectBoundaryHandler	  ;2
	inc $CE		  ;5
	inc $CE		  ;5
ValleyOfPoisonObjectBoundaryHandler:
	bvc ValleyOfPoisonObjectSpriteAndStateHandler	  ;2
	lda $CE		  ;3
	cmp #$51		  ;2
	bcc ValleyOfPoisonObjectSpriteAndStateHandler	  ;2
	lda pickupStatusFlags 
	sta $99		  ;3
	lda #$00		  ;2
	sta pickupStatusFlags 
ValleyOfPoisonObjectSpriteAndStateHandler:
	lda $C8		  ;3
	cmp indyHorizPos			;3
	bcs ValleyOfPoisonPlayer0SpriteUpdate	  ;2
	dex			  ;2
	eor #$03		  ;2
ValleyOfPoisonPlayer0SpriteUpdate:
	stx REFP0	  ;3
	and #$03		  ;2
	asl			  ;2
	asl			  ;2
	asl			  ;2
	asl			  ;2
	sta player0GraphicPointers;3
	lda frameCount					; get current frame count
	and #$7F		  ;2
	bne ValleyOfPoisonPlayer0SpriteBoundaryUpdate	  ;2
	lda $CE		  ;3
	cmp #$4A		  ;2
	bcs ValleyOfPoisonPlayer0SpriteBoundaryUpdate	  ;2
	ldy $98		  ;3
	beq ValleyOfPoisonPlayer0SpriteBoundaryUpdate	  ;2
	dey			  ;2
	sty $98		  ;3
	ldy #$8E		  ;2
	adc #$03		  ;2
	sta missile0VertPos
	cmp indyVertPos		  ;3
	bcs ValleyOfPoisonPlayer0SpriteMotionUpdate	  ;2
	dey			  ;2
ValleyOfPoisonPlayer0SpriteMotionUpdate:
	lda $C8		  ;3
	adc #$04		  ;2
	sta $CA		  ;3
	sty $8E		  ;3
ValleyOfPoisonPlayer0SpriteBoundaryUpdate:
	ldy #$7F		  ;2
	lda $8E		  ;3
	bmi ValleyOfPoisonBulletOrWhipBoundaryUpdate	  ;2
	sty missile0VertPos
ValleyOfPoisonBulletOrWhipBoundaryUpdate:
	lda bulletOrWhipVertPos			; get bullet or whip vertical position
	cmp #$52		  ;2
	bcc ReturnToScreenHandlerFromValleyOfPoison	  ;2
	sty bulletOrWhipVertPos
ReturnToScreenHandlerFromValleyOfPoison:
	jmp	 ReturnToScreenHandlerFromBank1	  ;3
	
WellOfSoulsScreenHandler:
	ldx #$3A		  ;2
	stx $E9		  ;3
	ldx #$85		  ;2
	stx $E3		  ;3
	ldx #BONUS_LANDING_IN_MESA
	stx landingInMesaBonus
	bne .checkToMoveThieves			; unconditional branch
	
ThievesDenScreenHandler:
	ldx #4		;2
.checkToMoveThieves
	lda ThiefMovementFrameDelayValues,x
	and frameCount
	bne .moveNextThief				; branch if not time to move
	ldy thievesHMOVEIndex,x			; get thief HMOVE index value
	lda #REFLECT
	and thievesDirectionAndSize,x
	bne ThievesDenThiefHMOVEIndexUpdate						; branch if thief not reflected
	dey								; reduce thief HMOVE index value
	cpy #20
	bcs .setThiefHMOVEIndexValue
.changeThiefDirection
	lda #REFLECT
	eor thievesDirectionAndSize,x
	sta thievesDirectionAndSize,x
.setThiefHMOVEIndexValue
	sty thievesHMOVEIndex,x
.moveNextThief
	dex
	bpl .checkToMoveThieves
	jmp	 ReturnToScreenHandlerFromBank1	  ;3
	
ThievesDenThiefHMOVEIndexUpdate:
	iny								; increment thief HMOVE index value
	cpy #133
	bcs .changeThiefDirection
	bcc .setThiefHMOVEIndexValue		; unconditional branch
	
ThievesDenScreenIdleHandler:
	bit $B4		  ;3
	bpl ThievesDenScreenUpdateState	  ;2
	bvc ThievesDenScreenInputHandler	  ;2
	dec indyHorizPos			;5
	bne ThievesDenScreenUpdateState						; unconditional branch
	
ThievesDenScreenInputHandler:
	lda frameCount					; get current frame count
	ror								; shift D0 to carry
	bcc ThievesDenScreenUpdateState						; branch on even frame
	lda SWCHA						; read joystick values
	sta $92
	ror
	ror
	ror
	bcs ThievesDenScreenRightInputHandler						; branch if right joystick not pushed left
	dec indyHorizPos
	bne ThievesDenScreenUpdateState						; unconditional branch
	
ThievesDenScreenRightInputHandler:
	ror
	bcs ThievesDenScreenUpdateState						; branch if right joystick not pushed right
	inc indyHorizPos
ThievesDenScreenUpdateState:
	lda #$02		  ;2
	and $B4		  ;3
	bne ThievesDenScreenVerticalStateHandler	  ;2
	sta $8D		  ;3
	lda #$0B		  ;2
	sta $CE		  ;3
ThievesDenScreenVerticalStateHandler:
	ldx indyVertPos					; get Indy's vertical position
	lda frameCount					; get current frame count
	bit $B4		  ;3
	bmi ThievesDenScreenVerticalStateUpdate	  ;2
	cpx #$15		  ;2
	bcc ThievesDenScreenVerticalStateUpdate	  ;2
	cpx #$30		  ;2
	bcc ThievesDenScreenVerticalPositionFinalize	  ;2
	bcs ThievesDenScreenVerticalPositionIncrement						; unconditional branch
	
ThievesDenScreenVerticalStateUpdate:
	ror			  ;2
	bcc ThievesDenScreenVerticalPositionFinalize	  ;2
ReturnToScreenHandlerFromThievesDen:
	jmp	 ReturnToScreenHandlerFromBank1	  ;3
	
ThievesDenScreenVerticalPositionIncrement:
	inx			  ;2
ThievesDenScreenVerticalPositionFinalize:
	inx			  ;2
	stx indyVertPos		  ;3
	bne ReturnToScreenHandlerFromThievesDen	  ;2
BlackMarketScreenHandler:
	lda indyHorizPos			;3
	cmp #$64		  ;2
	bcc BlackMarketScreenSpecialPositionHandler	  ;2
	rol blackMarketState				; rotate Black Market state left
	clc								; clear carry
	ror blackMarketState				; rotate right to show Indy carrying coins
	bpl ReturnToScreenHandlerFromBlackMarket						; unconditional branch
	
BlackMarketScreenSpecialPositionHandler:
	cmp #$2C		  ;2
	beq BlackMarketScreenSpecialStateHandler	  ;2
	lda #$7F		  ;2
	sta $D2		  ;3
	bne ReturnToScreenHandlerFromBlackMarket						; unconditional branch
	
BlackMarketScreenSpecialStateHandler:
	bit blackMarketState				; check Black Market state
	bmi ReturnToScreenHandlerFromBlackMarket						; branch if Indy not carrying coins
	lda #$30		  ;2
	sta $CC		  ;3
	ldy #$00		  ;2
	sty $D2		  ;3
	ldy #$7F		  ;2
	sty $DC		  ;3
	sty snakeVertPos			;3
	inc indyHorizPos			;5
	lda #$80		  ;2
	sta majorEventFlag 	  ;3
ReturnToScreenHandlerFromBlackMarket:
	jmp	 ReturnToScreenHandlerFromBank1	  ;3
	
TreasureRoomScreenHandler:
	ldy $DF		  ;3
	dey			  ;2
	bne ReturnToScreenHandlerFromBlackMarket	  ;2
	lda $AF		  ;3
	and #$07		  ;2
	bne TreasureRoomScreenStateFinalize	  ;2
	lda #$40		  ;2
	sta $93		  ;3
	lda secondsTimer			;3
	lsr			  ;2
	lsr			  ;2
	lsr			  ;2
	lsr			  ;2
	lsr			  ;2
	tax			  ;2
	ldy TreasureRoomScreenStateIndexLFCDC,x	  ;4
	ldx TreasureRoomScreenStateIndexTable,y	  ;4
	sty $84		  ;3
	jsr	 TreasureRoomBasketItemAwardHandler	  ;6
	bcc TreasureRoomScreenStateUpdate	  ;2
TreasureRoomScreenAdvanceState:
	inc $DF		  ;5
	bne ReturnToScreenHandlerFromBlackMarket	  ;2
	brk			  ;7
TreasureRoomScreenStateUpdate:
	ldy $84		  ;3
	tya			  ;2
	ora $AF		  ;3
	sta $AF		  ;3
	lda TreasureRoomScreenStateCEValues,y	  ;4
	sta $CE		  ;3
	lda TreasureRoomScreenStateDFValues,y	  ;4
	sta $DF		  ;3
	bne ReturnToScreenHandlerFromBlackMarket	  ;2
TreasureRoomScreenStateFinalize:
	cmp #$04		  ;2
	bcs TreasureRoomScreenAdvanceState	  ;2
	rol $AF		  ;5
	sec			  ;2
	ror $AF		  ;5
	bmi TreasureRoomScreenAdvanceState						; unconditional branch
	
MapRoomScreenHandler:
	ldy #$00		  ;2
	sty $D2		  ;3
	ldy #$7F		  ;2
	sty $DC		  ;3
	sty snakeVertPos			;3
	lda #$71		  ;2
	sta $CC		  ;3
	ldy #$4F		  ;2
	lda #$3A		  ;2
	cmp indyVertPos		  ;3
	bne MapRoomScreenSpecialStateHandler	  ;2
	lda selectedInventoryId
	cmp #ID_INVENTORY_KEY
	beq MapRoomScreenFinalizeState	  ;2
	lda #$5E		  ;2
	cmp indyHorizPos			;3
	beq MapRoomScreenFinalizeState	  ;2
MapRoomScreenSpecialStateHandler:
	ldy #$0D		  ;2
MapRoomScreenFinalizeState:
	sty $DF		  ;3
	lda secondsTimer			;3
	sec			  ;2
	sbc #$10		  ;2
	bpl MapRoomScreenSecondsTimerHandler	  ;2
	eor #$FF		  ;2
	sec			  ;2
	adc #$00		  ;2
MapRoomScreenSecondsTimerHandler:
	cmp #$0B		  ;2
	bcc MapRoomScreenFinalizeTimer	  ;2
	lda #$0B		  ;2
MapRoomScreenFinalizeTimer:
	sta $CE		  ;3
	bit $B3		  ;3
	bpl MapRoomScreenFinalizePositionState	  ;2
	cmp #$08		  ;2
	bcs MapRoomScreenFinalizeTimerValue	  ;2
	ldx selectedInventoryId
	cpx #ID_INVENTORY_HEAD_OF_RA
	bne MapRoomScreenFinalizeTimerValue	  ;2
	stx usingHeadOfRaInMapRoomBonus
	lda #$04		  ;2
	and frameCount		 ;3
	bne MapRoomScreenFinalizeTimerValue	  ;2
	lda $8C		  ;3
	and #$0F		  ;2
	tax			  ;2
	lda MapRoomBulletOrWhipHorizPosTable,x	  ;4
	sta bulletOrWhipHorizPos
	lda MapRoomBulletOrWhipVertPosTable,x	  ;4
	bne MapRoomScreenFinalizeBulletOrWhipPosition						; unconditional branch
	
MapRoomScreenFinalizeTimerValue:
	lda #$70		  ;2
MapRoomScreenFinalizeBulletOrWhipPosition:
	sta bulletOrWhipVertPos
MapRoomScreenFinalizePositionState:
	rol $B3		  ;5
	lda #$3A		  ;2
	cmp indyVertPos
	bne MapRoomScreenFinalizePositionFlags	  ;2
	cpy #$4F		  ;2
	beq MapRoomScreenFinalizePositionBoundary	  ;2
	lda #$5E		  ;2
	cmp indyHorizPos			;3
	bne MapRoomScreenFinalizePositionFlags	  ;2
MapRoomScreenFinalizePositionBoundary:
	sec			  ;2
	ror $B3		  ;5
	bmi ReturnToScreenHandlerFromMapRoom						; unconditional branch
	
MapRoomScreenFinalizePositionFlags:
	clc			  ;2
	ror $B3		  ;5
ReturnToScreenHandlerFromMapRoom:
	jmp	 ReturnToScreenHandlerFromBank1	  ;3
	
TempleEntranceScreenHandler:
	lda #PICKUP_ITEM_STATUS_TIME_PIECE
	and pickupItemsStatus
	bne TempleEntranceScreenTimePieceTakenHandler						; branch if Time Piece taken
	lda #$4C		  ;2
	sta $CC		  ;3
	lda #$2A		  ;2
	sta $D2		  ;3
	lda #<TimeSprite
	sta timePieceGraphicPointers
	lda #>TimeSprite
	sta timePieceGraphicPointers + 1
	bne TempleEntranceScreenFinalizeState	  ;2
	
TempleEntranceScreenTimePieceTakenHandler:
	lda #$F0		  ;2
	sta $D2		  ;3
TempleEntranceScreenFinalizeState:
	lda $B5		  ;3
	and #$0F		  ;2
	beq ReturnToScreenHandlerFromBank1	  ;2
	sta $DC		  ;3
	ldy #$14		  ;2
	sty $CE		  ;3
	ldy #$3B		  ;2
	sty $E0		  ;3
	iny			  ;2
	sty $D4		  ;3
	lda #$C1		  ;2
	sec			  ;2
	sbc $DC		  ;3
	sta player0GraphicPointers;3
	bne ReturnToScreenHandlerFromBank1						; unconditional branch
	
RoomOfShiningLightScreenHandler:
	lda frameCount					; get current frame count
	and #$18							; update every 8 frames
	adc #<ShiningLightSprites
	sta player0GraphicPointers		; set Shining Light graphic LSB value
	lda frameCount					; get current frame count
	and #7
	bne RoomOfShiningLightScreenFinalizeInput	  ;2
	ldx #<shiningLightVertPos - objectVertPositions
	ldy #<indyVertPos - objectVertPositions
	lda indyVertPos					; get Indy's vertical position
	cmp #58
	bcc RoomOfShiningLightScreenFinalizeState
	lda indyHorizPos					; get Indy's horizontal position
	cmp #$2B		  ;2
	bcc RoomOfShiningLightScreenSpecialStateHandler	  ;2
	cmp #$6D		  ;2
	bcc RoomOfShiningLightScreenFinalizeState	  ;2
RoomOfShiningLightScreenSpecialStateHandler:
	ldy #$05		  ;2
	lda #$4C		  ;2
	sta $CD		  ;3
	lda #$0B		  ;2
	sta $D3		  ;3
RoomOfShiningLightScreenFinalizeState:
	jsr	 UpdateObjectPositionHandler	  ;6
RoomOfShiningLightScreenFinalizeInput:
	ldx #$4E		  ;2
	cpx indyVertPos		  ;3
	bne ReturnToScreenHandlerFromBank1	  ;2
	ldx indyHorizPos			;3
	cpx #$76		  ;2
	beq RoomOfShiningLightScreenFinalizePenalty	  ;2
	cpx #$14		  ;2
	bne ReturnToScreenHandlerFromBank1	  ;2
RoomOfShiningLightScreenFinalizePenalty:
	lda SWCHA						; read joystick values
	and #P1_NO_MOVE
	cmp #(MOVE_DOWN >> 4)
	bne ReturnToScreenHandlerFromBank1						; branch if right joystick not pushed down
	sta escapedShiningLightPenalty	; place 13 in Shining Light penalty
	lda #$4C		  ;2
	sta indyHorizPos			;3
	ror $B5		  ;5
	sec			  ;2
	rol $B5		  ;5
ReturnToScreenHandlerFromBank1:
	lda #<SetupScreenVisualsAndObjects
	sta bankSwitchJMPAddress
	lda #>SetupScreenVisualsAndObjects
	sta bankSwitchJMPAddress + 1
	jmp JumpToBank0
	
EntranceRoomScreenHandler:	 
	lda #$40		  ;2
	sta $93		  ;3
	bne ReturnToScreenHandlerFromBank1	  ;2
	
DisplayKernel
	sta WSYNC
;--------------------------------------
	sta HMCLR				  ; 3 = @03	  clear horizontal motion
	sta CXCLR				  ; 3 = @06	  clear all collisions
	ldy #$FF					  ; 2
	sty PF1					  ; 3 = @11
	sty PF2					  ; 3 = @14
	ldx currentScreenId		  ; 3		  get the current screen id
	lda RoomPF0GraphicData,x	  ; 4
	sta PF0					  ; 3 = @24
	iny						  ; 2		  y = 0
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	sty VBLANK				  ; 3 = @06	  enable TIA (D1 = 0)
	sty scanline				  ; 3
	cpx #ID_MAP_ROOM			  ; 2
	bne DisplayKernelMapRoomHandler				  ; 2�		 branch if not in Map Room
	dey						  ; 2		  y = -1
DisplayKernelMapRoomHandler:
	sty ENABL				  ; 3 = @18
	cpx #ID_ARK_ROOM			  ; 2
	beq DisplayKernelArkRoomHandler				  ; 2�		 branch if in Ark Room
	bit majorEventFlag 				  ; 3
	bmi DisplayKernelArkRoomHandler				  ; 2�
	ldy SWCHA				  ; 4		  read joystick values
	sty REFP1				  ; 3 = @34
DisplayKernelArkRoomHandler:
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	ldy currentScreenId		  ; 3		  get the current screen id
	sta WSYNC
;--------------------------------------
	sta HMOVE				  ; 3
	lda RoomPF1GraphicData,y	  ; 4
	sta PF1					  ; 3 = @10
	lda RoomPF2GraphicData,y	  ; 4
	sta PF2					  ; 3 = @17
	ldx KernelJumpTableIndex,y ; 4
	lda KernelJumpTable + 1,x  ; 4
	pha						  ; 3
	lda KernelJumpTable,x	  ; 4
	pha						  ; 3
	lda #0					  ; 2
	tax						  ; 2
	sta $84					  ; 3
	rts						  ; 6		  jump to specified kernel

TreasureRoomBasketItemAwardHandler:
	lda TreasureRoomBasketItemAwardTable,x	  ;4
	lsr			  ;2
	tay			  ;2
	lda TreasureRoomBasketItemAwardBitMaskTable,y	  ;4
	bcs TreasureRoomBasketItemAwardPickupHandler	  ;2
	and basketItemsStatus
	beq TreasureRoomBasketItemAwardReturn	  ;2
	sec			  ;2
TreasureRoomBasketItemAwardReturn:
	rts			  ;6

TreasureRoomBasketItemAwardPickupHandler:
	and pickupItemsStatus
	bne TreasureRoomBasketItemAwardReturn	  ;2
	clc			  ;2
	rts			  ;6

UpdateObjectPositionHandler:
	cpy #<indyVertPos - objectVertPositions
	bne UpdateObjectVerticalPositionHandler	  ;2
	lda indyVertPos					; get Indy's vertical position
	bmi UpdateObjectVerticalPositionDecrementHandler	  ;2
UpdateObjectVerticalPositionHandler:
	lda objectVertPositions,x	  ;4
	cmp objectVertPositions,y	;4
	bne UpdateObjectVerticalPositionIncrementHandler	  ;2
	cpy #$05		  ;2
	bcs UpdateObjectHorizontalPositionHandler	  ;2
UpdateObjectVerticalPositionIncrementHandler:
	bcs UpdateObjectVerticalPositionDecrementHandler	  ;2
	inc objectVertPositions,x	  ;6
	bne UpdateObjectHorizontalPositionHandler	  ;2
UpdateObjectVerticalPositionDecrementHandler:
	dec objectVertPositions,x	  ;6
UpdateObjectHorizontalPositionHandler:
	lda objectHorizPositions,x		;4
	cmp objectHorizPositions,y	 ;4
	bne UpdateObjectHorizontalPositionIncrementHandler	  ;2
	cpy #$05		  ;2
	bcs UpdateObjectHorizontalPositionReturn	  ;2
UpdateObjectHorizontalPositionIncrementHandler:
	bcs UpdateObjectHorizontalPositionDecrementHandler	  ;2
	inc objectHorizPositions,x		;6
UpdateObjectHorizontalPositionReturn:
	rts			  ;6

UpdateObjectHorizontalPositionDecrementHandler:
	dec objectHorizPositions,x		;6
	rts			  ;6

UpdateObjectPositionBoundaryHandler:
	lda objectVertPositions,x	  ;4
	cmp #$53		  ;2
	bcc UpdateObjectPositionBoundaryClamp	  ;2
UpdateObjectPositionBoundaryClampHandler:
	rol $8C,x	  ;6
	clc			  ;2
	ror $8C,x	  ;6
	lda #$78		  ;2
	sta objectVertPositions,x	  ;4
	rts			  ;6

UpdateObjectPositionBoundaryClamp:
	lda objectHorizPositions,x		;4
	cmp #$10		  ;2
	bcc UpdateObjectPositionBoundaryClampHandler	  ;2
	cmp #$8E		  ;2
	bcs UpdateObjectPositionBoundaryClampHandler	  ;2
	rts			  ;6

	BOUNDARY 0
	
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
	
LiftingPedestalSprite
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
IndyStationarySprite
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
	
SnakeMotionTable_0:
	.byte HMOVE_L1
	.byte HMOVE_L1
	.byte HMOVE_0
	.byte HMOVE_R1
	.byte HMOVE_R1
	.byte HMOVE_0
	.byte HMOVE_L1
	.byte HMOVE_0
SnakeMotionTable_1:
	.byte HMOVE_L1
	.byte HMOVE_L1
	.byte HMOVE_0
	.byte HMOVE_R1
	.byte HMOVE_0
	.byte HMOVE_L1
	.byte HMOVE_L1
	.byte HMOVE_0
SnakeMotionTable_2:
	.byte HMOVE_L1
	.byte HMOVE_0
	.byte HMOVE_R1
	.byte HMOVE_R1
	.byte HMOVE_0
	.byte HMOVE_R1
	.byte HMOVE_R1
	.byte HMOVE_0
SnakeMotionTable_3:
	.byte HMOVE_R1
	.byte HMOVE_R1
	.byte HMOVE_0
	.byte HMOVE_L1
	.byte HMOVE_L1
	.byte HMOVE_0
	.byte HMOVE_R1
	
RoomPF1GraphicData
	.byte $00 ; |........| $FA91
	.byte $00 ; |........| $FA92
	.byte $E0 ; |XXX.....| $FA93
	.byte $00 ; |........| $FA94
	.byte $00 ; |........| $FA95
	.byte $C0 ; |XX......| $FA96
	.byte $FF ; |XXXXXXXX| $FA97
	.byte $FF ; |XXXXXXXX| $FA98
	.byte $00 ; |........| $FA99
	.byte $FF ; |XXXXXXXX| $FA9A
	.byte $FF ; |XXXXXXXX| $FA9B
	.byte $F0 ; |XXXX....| $FA9C
	.byte $F0 ; |XXXX....| $FA9D
;
; last byte	 shared with next table so don't cross page boundaries
;
RoomPF2GraphicData
	.byte $00 ; |........| $FA9E
	.byte $E0 ; |XXX.....| $FA9F
	.byte $00 ; |........| $FAA0
	.byte $E0 ; |XXX.....| $FAA1
	.byte $80 ; |X.......| $FAA2
	.byte $00 ; |........| $FAA3
	.byte $FF ; |XXXXXXXX| $FAA4
	.byte $FF ; |XXXXXXXX| $FAA5
	.byte $00 ; |........| $FAA6
	.byte $FF ; |XXXXXXXX| $FAA7
	.byte $FF ; |XXXXXXXX| $FAA8
	.byte $C0 ; |XX......| $FAA9
	.byte $00 ; |........| $FAAA
	.byte $00 ; |........| $FAAB
RoomPF0GraphicData
	.byte $C0 ; |XX......| $FAAC
	.byte $F0 ; |XXXX....| $FAAD
	.byte $F0 ; |XXXX....| $FAAE
	.byte $F0 ; |XXXX....| $FAAF
	.byte $F0 ; |XXXX....| $FAB0
	.byte $F0 ; |XXXX....| $FAB1
	.byte $C0 ; |XX......| $FAB2
	.byte $C0 ; |XX......| $FAB3
	.byte $C0 ; |XX......| $FAB4
	.byte $F0 ; |XXXX....| $FAB5
	.byte $F0 ; |XXXX....| $FAB6
	.byte $F0 ; |XXXX....| $FAB7
	.byte $F0 ; |XXXX....| $FAB8
	.byte $C0 ; |XX......| $FAB9
	
TimeSprite:
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_L3 | 7
	.byte HMOVE_L3 | 7
	.byte HMOVE_0  | 0
	
MapRoomBulletOrWhipHorizPosTable:
	.byte $63,$62,$6B,$5B,$6A,$5F,$5A,$5A,$6B,$5E,$67,$5A,$62,$6B,$5A,$6B
	
MapRoomBulletOrWhipVertPosTable:
	.byte $22,$13,$13,$18,$18,$1E,$21,$13,$21,$26,$26,$2B,$2A,$2B,$31,$31
	
KernelJumpTable
	.word JumpIntoStationaryPlayerKernel - 1
	.word DrawPlayfieldKernel - 1
	.word ThievesDenWellOfSoulsScanlineHandler - 1
	.word ArkRoomKernel - 1
	
SpiderRoomPlayer0SpriteTable:
	.byte $AE,$C0,$B7,$C9
	
OverscanSoundEffectTable:
	.byte $1B,$18,$17,$17,$18,$18,$1B,$1B,$1D,$18,$17,$12,$18,$17,$1B,$1D
	.byte $00,$00
	
InventorySprites

EmptySprite
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
Copyright_3
	.byte $71 ; |.XXX...X|
	.byte $41 ; |.X.....X|
	.byte $41 ; |.X.....X|
	.byte $71 ; |.XXX...X|
	.byte $11 ; |...X...X|
	.byte $51 ; |.X.X...X|
	.byte $70 ; |.XXX....|
	.byte $00 ; |........|

InventoryFluteSprite
	.byte $00 ; |........|
	.byte $01 ; |.......X|
	.byte $3F ; |..XXXXXX|
	.byte $6B ; |.XX.X.XX|
	.byte $7F ; |.XXXXXXX|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|

InventoryParachuteSprite
	.byte $77 ; |.XXX.XXX|
	.byte $77 ; |.XXX.XXX|
	.byte $77 ; |.XXX.XXX|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $77 ; |.XXX.XXX|
	.byte $77 ; |.XXX.XXX|
	.byte $77 ; |.XXX.XXX|

InventoryCoinsSprite
	.byte $1C ; |...XXX..|
	.byte $2A ; |..X.X.X.|
	.byte $55 ; |.X.X.X.X|
	.byte $2A ; |..X.X.X.|
	.byte $55 ; |.X.X.X.X|
	.byte $2A ; |..X.X.X.|
	.byte $1C ; |...XXX..|
	.byte $3E ; |..XXXXX.|

MarketplaceGrenadeSprite
	.byte $3A ; |..XXX.X.|
	.byte $01 ; |.......X|
	.byte $7D ; |.XXXXX.X|
	.byte $01 ; |.......X|
	.byte $39 ; |..XXX..X|
	.byte $02 ; |......X.|
	.byte $3C ; |..XXXX..|
	.byte $30 ; |..XX....|

BlackMarketGrenadeSprite
	.byte $2E ; |..X.XXX.|
	.byte $40 ; |.X......|
	.byte $5F ; |.X.XXXXX|
	.byte $40 ; |.X......|
	.byte $4E ; |.X..XXX.|
	.byte $20 ; |..X.....|
	.byte $1E ; |...XXXX.|
	.byte $06 ; |.....XX.|

InventoryKeySprite
	.byte $00 ; |........|
	.byte $25 ; |..X..X.X|
	.byte $52 ; |.X.X..X.|
	.byte $7F ; |.XXXXXXX|
	.byte $50 ; |.X.X....|
	.byte $20 ; |..X.....|
	.byte $00 ; |........|
	.byte $00 ; |........|
	
ArkOfTheCovenantSprite
	.byte $FF ; |XXXXXXXX| $FB40
	.byte $66 ; |.XX..XX.| $FB41
	.byte $24 ; |..X..X..| $FB42
	.byte $24 ; |..X..X..| $FB43
	.byte $66 ; |.XX..XX.| $FB44
	.byte $E7 ; |XXX..XXX| $FB45
	.byte $C3 ; |XX....XX| $FB46
	.byte $E7 ; |XXX..XXX| $FB47
Copyright_1
	.byte $17 ; |...X.XXX| $FB48
	.byte $15 ; |...X.X.X| $FB49
	.byte $15 ; |...X.X.X| $FB4A
	.byte $77 ; |.XXX.XXX| $FB4B
	.byte $55 ; |.X.X.X.X| $FB4C
	.byte $55 ; |.X.X.X.X| $FB4D
	.byte $77 ; |.XXX.XXX| $FB4E
	.byte $00 ; |........| $FB4F
InventoryWhipSprite
	.byte $21 ; |..X....X| $FB50
	.byte $11 ; |...X...X| $FB51
	.byte $09 ; |....X..X| $FB52
	.byte $11 ; |...X...X| $FB53
	.byte $22 ; |..X...X.| $FB54
	.byte $44 ; |.X...X..| $FB55
	.byte $28 ; |..X.X...| $FB56
	.byte $10 ; |...X....| $FB57
InventoryShovelSprite
	.byte $01 ; |.......X| $FB58
	.byte $03 ; |......XX| $FB59
	.byte $07 ; |.....XXX| $FB5A
	.byte $0F ; |....XXXX| $FB5B
	.byte $06 ; |.....XX.| $FB5C
	.byte $0C ; |....XX..| $FB5D
	.byte $18 ; |...XX...| $FB5E
	.byte $3C ; |..XXXX..| $FB5F
Copyright_0
	.byte $79 ; |.XXXX..X| $FB60
	.byte $85 ; |X....X.X| $FB61
	.byte $B5 ; |X.XX.X.X| $FB62
	.byte $A5 ; |X.X..X.X| $FB63
	.byte $B5 ; |X.XX.X.X| $FB64
	.byte $85 ; |X....X.X| $FB65
	.byte $79 ; |.XXXX..X| $FB66
	.byte $00 ; |........| $FB67
InventoryRevolverSprite
	.byte $00 ; |........| $FB68
	.byte $60 ; |.XX.....| $FB69
	.byte $60 ; |.XX.....| $FB6A
	.byte $78 ; |.XXXX...| $FB6B
	.byte $68 ; |.XX.X...| $FB6C
	.byte $3F ; |..XXXXXX| $FB6D
	.byte $5F ; |.X.XXXXX| $FB6E
	.byte $00 ; |........| $FB6F
InventoryHeadOfRaSprite	  
	.byte $08 ; |....X...| $FB70
	.byte $1C ; |...XXX..| $FB71
	.byte $22 ; |..X...X.| $FB72
	.byte $49 ; |.X..X..X| $FB73
	.byte $6B ; |.XX.X.XX| $FB74
	.byte $00 ; |........| $FB75
	.byte $1C ; |...XXX..| $FB76
	.byte $08 ; |....X...| $FB77
InventoryTimepieceSprite
	.byte $7F ; |.XXXXXXX| $FB78
	.byte $5D ; |.X.XXX.X| $FB79
	.byte $77 ; |.XXX.XXX| $FB7A
	.byte $77 ; |.XXX.XXX| $FB7B
	.byte $5D ; |.X.XXX.X| $FB7C
	.byte $7F ; |.XXXXXXX| $FB7D
	.byte $08 ; |....X...| $FB7E
	.byte $1C ; |...XXX..| $FB7F
InventoryAnkhSprite
	.byte $3E ; |..XXXXX.| $FB80
	.byte $1C ; |...XXX..| $FB81
	.byte $49 ; |.X..X..X| $FB82
	.byte $7F ; |.XXXXXXX| $FB83
	.byte $49 ; |.X..X..X| $FB84
	.byte $1C ; |...XXX..| $FB85
	.byte $36 ; |..XX.XX.| $FB86
	.byte $1C ; |...XXX..| $FB87
InventoryChaiSprite
	.byte $16 ; |...X.XX.| $FB88
	.byte $0B ; |....X.XX| $FB89
	.byte $0D ; |....XX.X| $FB8A
	.byte $05 ; |.....X.X| $FB8B
	.byte $17 ; |...X.XXX| $FB8C
	.byte $36 ; |..XX.XX.| $FB8D
	.byte $64 ; |.XX..X..| $FB8E
	.byte $04 ; |.....X..| $FB8F
InventoryHourGlassSprite
	.byte $77 ; |.XXX.XXX| $FB90
	.byte $36 ; |..XX.XX.| $FB91
	.byte $14 ; |...X.X..| $FB92
	.byte $22 ; |..X...X.| $FB93
	.byte $22 ; |..X...X.| $FB94
	.byte $14 ; |...X.X..| $FB95
	.byte $36 ; |..XX.XX.| $FB96
	.byte $77 ; |.XXX.XXX| $FB97
Inventory12_00
	.byte $3E ; |..XXXXX.| $FB98
	.byte $41 ; |.X.....X| $FB99
	.byte $41 ; |.X.....X| $FB9A
	.byte $49 ; |.X..X..X| $FB9B
	.byte $49 ; |.X..X..X| $FB9C
	.byte $49 ; |.X..X..X| $FB9D
	.byte $3E ; |..XXXXX.| $FB9E
	.byte $1C ; |...XXX..| $FB9F
Inventory01_00
	.byte $3E ; |..XXXXX.| $FBA0
	.byte $41 ; |.X.....X| $FBA1
	.byte $41 ; |.X.....X| $FBA2
	.byte $49 ; |.X..X..X| $FBA3
	.byte $45 ; |.X...X.X| $FBA4
	.byte $43 ; |.X....XX| $FBA5
	.byte $3E ; |..XXXXX.| $FBA6
	.byte $1C ; |...XXX..| $FBA7
Inventory03_00
	.byte $3E ; |..XXXXX.| $FBA8
	.byte $41 ; |.X.....X| $FBA9
	.byte $41 ; |.X.....X| $FBAA
	.byte $4F ; |.X..XXXX| $FBAB
	.byte $41 ; |.X.....X| $FBAC
	.byte $41 ; |.X.....X| $FBAD
	.byte $3E ; |..XXXXX.| $FBAE
	.byte $1C ; |...XXX..| $FBAF
Inventory05_00
	.byte $3E ; |..XXXXX.| $FBB0
	.byte $43 ; |.X....XX| $FBB1
	.byte $45 ; |.X...X.X| $FBB2
	.byte $49 ; |.X..X..X| $FBB3
	.byte $41 ; |.X.....X| $FBB4
	.byte $41 ; |.X.....X| $FBB5
	.byte $3E ; |..XXXXX.| $FBB6
	.byte $1C ; |...XXX..| $FBB7
Inventory06_00
	.byte $3E ; |..XXXXX.| $FBB8
	.byte $49 ; |.X..X..X| $FBB9
	.byte $49 ; |.X..X..X| $FBBA
	.byte $49 ; |.X..X..X| $FBBB
	.byte $41 ; |.X.....X| $FBBC
	.byte $41 ; |.X.....X| $FBBD
	.byte $3E ; |..XXXXX.| $FBBE
	.byte $1C ; |...XXX..| $FBBF
Inventory07_00
	.byte $3E ; |..XXXXX.| $FBC0
	.byte $61 ; |.XX....X| $FBC1
	.byte $51 ; |.X.X...X| $FBC2
	.byte $49 ; |.X..X..X| $FBC3
	.byte $41 ; |.X.....X| $FBC4
	.byte $41 ; |.X.....X| $FBC5
	.byte $3E ; |..XXXXX.| $FBC6
	.byte $1C ; |...XXX..| $FBC7
Inventory09_00
	.byte $3E ; |..XXXXX.| $FBC8
	.byte $41 ; |.X.....X| $FBC9
	.byte $41 ; |.X.....X| $FBCA
	.byte $79 ; |.XXXX..X| $FBCB
	.byte $41 ; |.X.....X| $FBCC
	.byte $41 ; |.X.....X| $FBCD
	.byte $3E ; |..XXXXX.| $FBCE
	.byte $1C ; |...XXX..| $FBCF
Inventory11_00
	.byte $3E ; |..XXXXX.| $FBD0
	.byte $41 ; |.X.....X| $FBD1
	.byte $41 ; |.X.....X| $FBD2
	.byte $49 ; |.X..X..X| $FBD3
	.byte $51 ; |.X.X...X| $FBD4
	.byte $61 ; |.XX....X| $FBD5
	.byte $3E ; |..XXXXX.| $FBD6
	.byte $1C ; |...XXX..| $FBD7
Copyright_2
	.byte $49 ; |.X..X..X| $FBD8
	.byte $49 ; |.X..X..X| $FBD9
	.byte $49 ; |.X..X..X| $FBDA
	.byte $C9 ; |XX..X..X| $FBDB
	.byte $49 ; |.X..X..X| $FBDC
	.byte $49 ; |.X..X..X| $FBDD
	.byte $BE ; |X.XXXXX.| $FBDE
	.byte $00 ; |........| $FBDF
Copyright_4
	.byte $55 ; |.X.X.X.X| $FBE0
	.byte $55 ; |.X.X.X.X| $FBE1
	.byte $55 ; |.X.X.X.X| $FBE2
	.byte $D9 ; |XX.XX..X| $FBE3
	.byte $55 ; |.X.X.X.X| $FBE4
	.byte $55 ; |.X.X.X.X| $FBE5
	.byte $99 ; |X..XX..X| $FBE6
	.byte $00 ; |........| $FBE7
	
OverscanSpecialSoundEffectTable:
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
	
ThiefSprites
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
		
ThiefSpriteLSBValues
	.byte <ThiefSprite_0, <ThiefSprite_1
	.byte <ThiefSprite_2, <ThiefSprite_3	  
	
ThiefColors
	.byte DK_BLUE + 12, WHITE + 1, DK_BLUE + 12, BLACK, BLACK + 10, BLACK + 2
	.byte BLACK + 4, BLACK + 6, BLACK + 8, BLACK + 10, BLACK + 8, BLACK + 6
	.byte LT_BLUE + 8, LT_BLUE + 8, LT_BLUE + 14, LT_BLUE + 14
	
	.byte $00 ; |........| $FC54
	.byte $00 ; |........| $FC55
	.byte $00 ; |........| $FC56
	.byte $00 ; |........| $FC57
	.byte $00 ; |........| $FC58
	.byte $00 ; |........| $FC59
	.byte $00 ; |........| $FC5A
	.byte $00 ; |........| $FC5B
	.byte $00 ; |........| $FC5C
	.byte $00 ; |........| $FC5D
	.byte $00 ; |........| $FC5E
	.byte $08 ; |....X...| $FC5F
	.byte $1C ; |...XXX..| $FC60
	.byte $3C ; |..XXXX..| $FC61
	.byte $3E ; |..XXXXX.| $FC62
	.byte $7F ; |.XXXXXXX| $FC63
	.byte $FF ; |XXXXXXXX| $FC64
	.byte $FF ; |XXXXXXXX| $FC65
	.byte $FF ; |XXXXXXXX| $FC66
	.byte $FF ; |XXXXXXXX| $FC67
	.byte $FF ; |XXXXXXXX| $FC68
	.byte $FF ; |XXXXXXXX| $FC69
	.byte $FF ; |XXXXXXXX| $FC6A
	.byte $FF ; |XXXXXXXX| $FC6B
	.byte $3E ; |..XXXXX.| $FC6C
	.byte $3C ; |..XXXX..| $FC6D
	.byte $3A ; |..XXX.X.| $FC6E
	.byte $38 ; |..XXX...| $FC6F
	.byte $36 ; |..XX.XX.| $FC70
	.byte $34 ; |..XX.X..| $FC71
	.byte $32 ; |..XX..X.| $FC72
	.byte $20 ; |..X.....| $FC73
	.byte $10 ; |...X....| $FC74
TreasureRoomBasketItemAwardTable:
	.byte $00 ; |........| $FC75
	.byte $00 ; |........| $FC76
	.byte $00 ; |........| $FC77
	.byte $00 ; |........| $FC78
	.byte $08 ; |....X...| $FC79
	.byte $00 ; |........| $FC7A
	.byte $02 ; |......X.| $FC7B
	.byte $0A ; |....X.X.| $FC7C
	.byte $0C ; |....XX..| $FC7D
	.byte $0E ; |....XXX.| $FC7E
	.byte $01 ; |.......X| $FC7F
	.byte $03 ; |......XX| $FC80
	.byte $04 ; |.....X..| $FC81
	.byte $06 ; |.....XX.| $FC82
	.byte $05 ; |.....X.X| $FC83
	.byte $07 ; |.....XXX| $FC84
	.byte $0D ; |....XX.X| $FC85
	.byte $0F ; |....XXXX| $FC86
	.byte $0B ; |....X.XX| $FC87
	
ScreenHandlerJumpTable:
	.word TreasureRoomScreenHandler - 1			  ; Treasure Room
	.word ReturnToScreenHandlerFromBank1 - 1			  ; Marketplace
	.word EntranceRoomScreenHandler - 1			  ; Entrance Room
	.word BlackMarketScreenHandler - 1			  ; Black Market
	.word MapRoomScreenHandler - 1			  ; Map room
	.word ThievesDenScreenIdleHandler - 1			  ; mesa side
	.word TempleEntranceScreenHandler - 1			  ; temple entrance
	.word SpiderRoomScreenHandler - 1			  ; spider room
	.word RoomOfShiningLightScreenHandler - 1			  ; room of shining light
	.word MesaFieldScreenHandler - 1			  ; mesa field
	.word ValleyOfPoisonScreenHandler - 1			  ; valley of poison
	.word ThievesDenScreenHandler - 1			  ; thieves den
	.word WellOfSoulsScreenHandler - 1			  ; well of souls
	
TreasureRoomScreenStateCEValues:
	.byte $1A,$38,$09,$26
	
TreasureRoomScreenStateDFValues:
	.byte $26,$46,$1A,$38
	
TreasureRoomScreenStateIndexTable:
	.byte $04,$11,$10,$12,$54,$FC,$5F,$FE,$7F,$FA,$3F,$2A,$00,$54,$5F,$FC
	.byte $7F,$FE,$3F,$FA,$2A,$00,$2A,$FA,$3F,$FE,$7F,$FA,$5F,$54,$00,$2A
	.byte $3F,$FA,$7F,$FE,$5F,$FC,$54,$00
	
TreasureRoomPlayer0SpriteStateTable:
	.byte $8B,$8A,$86,$87,$85,$89
	
ThiefMovementFrameDelayValues
	.byte $03,$01,$00,$01
	
TreasureRoomScreenStateIndexLFCDC:
	.byte $03,$02,$01,$03,$02,$03
	
TreasureRoomBasketItemAwardBitMaskTable:
	.byte $01,$02,$04,$08,$10,$20,$40,$80
	
InventorySelectionAdjustmentHandler:
	ror			  ;2
	bcs InventorySelectionAdjustmentIncrementVertHandler	  ;2
	dec objectVertPositions,x	  ;6
InventorySelectionAdjustmentIncrementVertHandler:
	ror			  ;2
	bcs InventorySelectionAdjustmentDecrementHorizHandler	  ;2
	inc objectVertPositions,x	  ;6
InventorySelectionAdjustmentDecrementHorizHandler:
	ror			  ;2
	bcs InventorySelectionAdjustmentIncrementHorizHandler	  ;2
	dec objectHorizPositions,x		;6
InventorySelectionAdjustmentIncrementHorizHandler:
	ror			  ;2
	bcs InventorySelectionAdjustmentReturn	  ;2
	inc objectHorizPositions,x		;6
InventorySelectionAdjustmentReturn:
	rts			  ;6

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
	
PedestalSprite
	.byte $3C ; |..XXXX..| $FEF0
	.byte $3C ; |..XXXX..| $FEF1
	.byte $7E ; |.XXXXXX.| $FEF2
	.byte $FF ; |XXXXXXXX| $FEF3
	
UpdateInventoryObjectPositionHandler:
	lda $8C,x	  ;4
	bmi UpdateInventoryObjectPositionBoundaryHandler	  ;2
	rts			  ;6

UpdateInventoryObjectPositionBoundaryHandler:
	jsr	 InventorySelectionAdjustmentHandler	  ;6
	jsr	 UpdateObjectPositionBoundaryHandler	  ;6
	rts			  ;6

TreasureRoomPlayerGraphics
	.byte SET_PLAYER_0_COLOR | BLACK >> 1
HSWInitials_01
	.byte $00 ; |........| $FF01
	.byte $07 ; |.....XXX| $FF02
	.byte $04 ; |.....X..| $FF03
	.byte $77 ; |.XXX.XXX| $FF04
	.byte $71 ; |.XXX...X| $FF05
	.byte $75 ; |.XXX.X.X| $FF06
	.byte $57 ; |.X.X.XXX| $FF07
	.byte $50 ; |.X.X....| $FF08
	.byte $00 ; |........| $FF09
	.byte SET_PLAYER_0_COLOR | (GREEN_BLUE + 12) >> 1 ; D6
	.byte $1C ; |...XXX..| $FF0B
	.byte $36 ; |..XX.XX.| $FF0C
	.byte $1C ; |...XXX..| $FF0D
	.byte $49 ; |.X..X..X| $FF0E
	.byte $7F ; |.XXXXXXX| $FF0F
	.byte $49 ; |.X..X..X| $FF10
	.byte $1C ; |...XXX..| $FF11
	.byte $3E ; |..XXXXX.| $FF12
	.byte $00 ; |........| $FF13
	.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1 ;$B9
	.byte SET_PLAYER_0_COLOR | (YELLOW + 4) >> 1;$8A
	.byte SET_PLAYER_0_HMOVE | HMOVE_L4 >> 1;$A1
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1;$81
	.byte $00 ; |........| $FF18
	.byte $00 ; |........| $FF19
	.byte $00 ; |........| $FF1A
	.byte $00 ; |........| $FF1B
	.byte $00 ; |........| $FF1C
	.byte $00 ; |........| $FF1D
	.byte $1C ; |...XXX..| $FF1E
	.byte $70 ; |.XXX....| $FF1F
	.byte $07 ; |.....XXX| $FF20
	.byte $70 ; |.XXX....| $FF21
	.byte $0E ; |....XXX.| $FF22
	.byte $00 ; |........| $FF23
	.byte SET_PLAYER_0_HMOVE | (HMOVE_R7 | 14) >> 1;$CF
	.byte SET_PLAYER_0_COLOR | (ORANGE + 12) >> 1;$A6
	.byte $00 ; |........| $FF26
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1;$81
	.byte $77 ; |.XXX.XXX| $FF28
	.byte $36 ; |..XX.XX.| $FF29
	.byte $14 ; |...X.X..| $FF2A
	.byte $22 ; |..X...X.| $FF2B
	.byte SET_PLAYER_0_COLOR | (DK_PINK + 12) >> 1;$AE
	.byte $14 ; |...X.X..| $FF2D
	.byte $36 ; |..XX.XX.| $FF2E
	.byte $77 ; |.XXX.XXX| $FF2F
	.byte $00 ; |........| $FF30
	.byte $BF ; |X.XXXXXX| $FF31
	.byte $CE ; |XX..XXX.| $FF32
	.byte $00 ; |........| $FF33
	.byte $EF ; |XXX.XXXX| $FF34
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1;$81
	.byte $00 ; |........| $FF36
	.byte $00 ; |........| $FF37
	.byte $00 ; |........| $FF38
	.byte $00 ; |........| $FF39
	.byte $00 ; |........| $FF3A
	.byte $00 ; |........| $FF3B
	.byte $68 ; |.XX.X...| $FF3C
	.byte $2F ; |..X.XXXX| $FF3D
	.byte $0A ; |....X.X.| $FF3E
	.byte $0C ; |....XX..| $FF3F
	.byte $08 ; |....X...| $FF40
	.byte $00 ; |........| $FF41
	.byte $80 ; |X.......| $FF42
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1;$81
	.byte $00 ; |........| $FF44
	.byte $00 ; |........| $FF45
HSWInitials_00
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
	.byte $00 ; |........|
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1
	.byte $70 ; |.XXX....|
	.byte $5F ; |.X.XXXXX|
	.byte $72 ; |.XXX..X.|
	.byte $05 ; |.....X.X|
	.byte $00 ; |........|
	.byte SET_PLAYER_0_HMOVE | HMOVE_R8 >> 1
	.byte $00 ; |........|
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
	
	.org BANK1TOP + 4096 - 6, 0
	.word BANK1Start
	.word BANK1Start
	.word BANK1Start
