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
; = THE ASSEMBLED CODE IS  1982, ATARI, INC.								  =
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

	include "macro.h"
	include "tia_constants.h"
	include "vcs.h"

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
	
scanlineCounter			ds 1						;= $80 ; Counts scanlines in Kernels (used for vertical drawing)
currentRoomId			ds 1						;= $81 ; ID of the current room (0-16 typically)
frameCount				ds 1						;= $82 ; Global frame counter (used for animation, timing, RNG)
secondsTimer			ds 1						;= $83 ; Timer for game seconds (and grenade countdowns)
bankSwitchVars			ds 6						;= $84($84 - $89) Region used for banking boilerplate or temp vars
;--------------------------------------
bankSwitchLDAOpcode = bankSwitchVars				;= $84 ; Holds opcode for LDA (part of bankswitch trampoline)
bankSwitchAddr		= bankSwitchVars + 1			;= $85 ; Target address for bank switch
bankSwitchJMPOpcode = bankSwitchAddr + 2			;= $86 ; Holds opcode for JMP
bankSwitchJMPAddr	= bankSwitchJMPOpcode + 1		;= $87 ; Jump target address
;--------------------------------------
loopCounter				= bankSwitchVars			;= $84 ; Reused as loop counter in various routines
tempGfxHolder			= bankSwitchAddr			;= $85 ; Reused for temporary graphics data storage
thiefHorizPosCoarse		ds 1						;= $88 ; Thief X Position (Coarse/Grid)
thiefHorizPosFine		ds 1						;= $89 ; Thief X Position (Fine pixel offset)
playerInputState		ds 1						;= $8A ; Tracks input history/debounce state
arkImpactRegionId		ds 1						;= $8B ; Calculated region ID where Indy *is* currently
arkLocationRegionId		ds 1						;= $8C ; Secret region ID where the Ark *is hidden*
eventState				ds 1						;= $8D ; General state machine for room-specific events
m0VertPosShadow			ds 1						;= $8E ; Shadow copy of Missile 0 Vertical Position
weaponStatus			ds 1						;= $8F ; Tracks Whip/Revolver state (Active/Inactive)
unused_90				ds 1						;= $90 ; Unused / Padding
movementDirection		ds 1   						;= $91 ; Current movement direction for objects (0-3 usually)
inputFlags				ds 1  						;= $92 ; Processed input flags (Up/Down/Left/Right)
screenEventState		ds 1 						;= $93 ; State for screen transitions or major visual changes
playfieldControlFlags	ds 1 						;= $94 ; Flags controlling playfield rendering (Walls/Obstacles)
pickupStatusFlags 		ds 1 						;= $95 ; Bitmask of items picked up (Timepiece, Coins, etc.)
diggingState			ds 1 						;= $96 ; Tracks digging progress/shovel animation state
digAttemptCounter		ds 1 						;= $97 ; Number of times shovel has been used?
roomEventStateOffset	ds 1 						;= $98 ; Offset index for room-specific event tables
screenInitFlag			ds 1						;= $99 ; Flag set when a screen is first initialized (0=Init)
grenadeState			ds 1 						;= $9A ; Grenade Active/Exploding state flags
grenadeDetinationTime	ds 1 						;= $9B ; Timestamp when grenade should explode
resetEnableFlag			ds 1 						;= $9C (Positive = Win/Found Ark, Negative = Playing/Hidden)
majorEventFlag			ds 1 						;= $9D ; Flag for major events (Death, Capture, End Game)
adventurePoints			ds 1 						;= $9E ; Current Score (affecting rank)
lives					ds 1 						;= $9F ; Remaining Lives
bulletCount				ds 1 						;= $A0 ; Remaining Bullets ($80 = Infinite?)
snakeTimer				ds 1 						;= $A1 ; Timer for Snake movement/spawning
soundChan0_IndyState	ds 1 						;= $A2 ; Audio Ch 0 Control & Indy Animation State
soundChan1_WhipTimer	ds 1 						;= $A3 ; Audio Ch 1 Control & Whip Effect Timer
soundEffectTimer		ds 1 						;= $A4 ; Timer for sustained sound effects (Music/Mystery)
grenadeOpeningPenalty	ds 1 						;= $A5 ; Score Modifier: Penalties
shiningLightPenalty 	ds 1 						;= $A6 ; Score Modifier: Penalties
findingArkBonus			ds 1 						;= $A7 ; Score Modifier: Bonus
usingParachuteBonus		ds 1 						;= $A8 ; Score Modifier: Bonus
skipToMesaFieldBonus	ds 1 						;= $A9 ; Score Modifier: Bonus
yarEasterEggBonus 		ds 1 						;= $AA ; Score Modifier: Bonus
headOfRaMapRoomBonus 	ds 1 						;= $AB ; Score Modifier: Bonus
shootingThiefPenalty	ds 1 						;= $AC ; Score Modifier: Penalties
landingInMesaBonus		ds 1 						;= $AD
unusedScoreAdjustment	ds 1 						;= $AE
treasureIndex			ds 1 						;= $AF
unused_B0				ds 1 						;= $B0
entranceRoomState		ds 1 						;= $B1
blackMarketState		ds 1 						;= $B2
mapRoomState			ds 1 						;= $B3
mesaSideState			ds 1 						;= $B4
entranceRoomEventState	ds 1 						;= $B5
spiderRoomState			ds 1 						;= $B6
inventoryGfxPtrs 		ds 12						;= $B7 - $C2
selectedInventorySlot	ds 1						;= $C3	
inventoryItemCount		ds 1						;= $C4
selectedInventoryId		ds 1						;= $C5
basketItemsStatus		ds 1						;= $C6
pickupItemsStatus		ds 1						;= $C7
objectHorizPositions	ds 4						;= $C8
;--------------------------------------
p0HorizPos				= objectHorizPositions		;= $C8
indyHorizPos			= objectHorizPositions + 1 	;= $C9
m0HorizPos				= objectHorizPositions + 2	;= $CA
weaponHorizPos			= objectHorizPositions + 3 	;= $CB
;--------------------------------------
indyHorizPosForced		ds 1 						;= $CC
unused_CD_WriteOnly		ds 1 						;= $CD

objectVertPositions
p0VertPos				ds 1 		;= $CE	
indyVertPos				ds 1 	    ;= $CF
m0VertPos				ds 1 	    ;= $D0
weaponVertPos			ds 1 	    ;= $D1
snakeDungeonY			ds 1 		;= $D2
targetVertPos			ds 1 		;= $D3
snakeDungeonState		ds 1 		;= $D4
snakeVertPos			ds 1 	    ;= $D5
timepieceGfxPtrs		ds 2 						;= $D6 - $D7
;--------------------------------------
p0ColorPtrs	= timepieceGfxPtrs			;= $D6
timepieceSpriteDataPtr	ds 1						;= $D8
;--------------------------------------
indyGfxPtrs				ds 2						;= $D9 - $DA
indySpriteHeight		ds 1						;= $DB
p0SpriteHeight			ds 1						;= $DC
p0GfxPtrs				ds 2						;= $DD - $DE
thiefState				ds 4						;= $DF - $E2
;--------------------------------------
objectVertOffset		= thiefState				;= $DF
p0GfxData				= thiefState + 1			;= $E0
p0TiaPtrs				= thiefState + 2			;= $E1 - $E4
;--------------------------------------
whipVertPos				= objectVertOffset			;= $DF
;--------------------------------------
shovelVertPos			= whipVertPos				;= $DF
;--------------------------------------
p0ColorPtr				= p0TiaPtrs					;= $E1
pf1GfxPtrs				= p0ColorPtr				;= $E1 - $E2
p0FineMotionPtr 		= p0ColorPtr + 2			;= $E3
pf2GfxPtrs				= p0FineMotionPtr			;= $E3 - $E4
;--------------------------------------
thiefHmoveIndices		ds 6						; $E5 - $EA			
;--------------------------------------
dungeonGfxData			= thiefHmoveIndices 		; $E5 - $EA
topOfDungeonGfx			= dungeonGfxData			; $E5
;--------------------------------------
savedThiefVertPos		ds 1						;= $EB
savedIndyVertPos		ds 1						;= $EC
savedIndyHorizPos		ds 1						;= $ED
thiefHorizPositions		ds 4						;= $EE - $F1

	echo "***",(*-$80 - 2)d, "BYTES OF RAM USED", ($100 - * + 2)d, "BYTES FREE"
	
;===============================================================================
; R O M - C O D E  (BANK 0)
;===============================================================================

	SEG Bank0
	.org BANK0TOP
	.rorg BANK0_REORG
	
	lda BANK0STROBE
	jmp startGame
	
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
	ldx currentRoomId				; get the current screen id
	cpx #ID_VALLEY_OF_POISON
	bcc .checkPlayfieldCollisionWithBulletOrWhip
	beq .indyShootHitThief			; branch if Indy in the Valley of Poison
	
	; --------------------------------------------------------------------------
	; CALCULATE STRUCK THIEF INDEX
	; The screen is divided vertically. We use Weapon Y to determine which thief (0-4) was hit.
	; Formula: Index = ((WeaponY + 1) / 16)
	; --------------------------------------------------------------------------
	lda weaponVertPos				; Load Weapon Vertical Position.
	adc #2 - 1						; Adjust for offset (Carry set assumed).
	lsr								; Divide by 2.
	lsr								; Divide by 4.
	lsr								; Divide by 8.
	lsr								; Divide by 16.
	tax								; Move result (Index 0-3?) to X.
	
	; --------------------------------------------------------------------------
	; FLIP THIEF DIRECTION
	; Hitting a thief makes them reverse direction.
	; --------------------------------------------------------------------------
	lda #REFLECT					; Load Reflect Bit.
	eor thiefState,x				; XOR with current state (Toggle Direction).
	sta thiefState,x				; Save new state.

.indyShootHitThief
	lda weaponStatus				; get bullet or whip status
	bpl .setPenaltyForShootingThief	; branch if bullet or whip not active
	and #~BULLET_OR_WHIP_ACTIVE		;
	sta weaponStatus				; clear BULLET_OR_WHIP_ACTIVE bit
	lda pickupStatusFlags 
	and #%00011111		  			; Mask check.
	beq FinalizeItemPickup	  		; skip adding to inventory 
	jsr PlaceItemInInventory
	
FinalizeItemPickup:
	lda #%01000000		  			; Set Bit 6.
	sta pickupStatusFlags 

.setPenaltyForShootingThief
	; --------------------------------------------------------------------------
	; PENALTY FOR SHOOTING THIEF
	; Killing a thief is dishonorable (or noise?). Deducts score.
	; --------------------------------------------------------------------------
	lda #~BULLET_OR_WHIP_ACTIVE		; Clear Active Bit mask.
	sta weaponVertPos				; Invalidates weapon Y (effectively removing it).
	lda #PENALTY_SHOOTING_THIEF		; Load Penalty Value.
	sta shootingThiefPenalty		; Apply penalty.

.checkPlayfieldCollisionWithBulletOrWhip
	bit CXM1FB						; check missile 1 and playfield collisions
	bpl HandleWeaponVsSnakeCollision; branch if no missile and playfield collision
	ldx currentRoomId				; get the current screen id
	cpx #ID_MESA_FIELD
	beq HandleIndyVsSnakeOrItemCollision; branch if in the Mesa field
	cpx #ID_TEMPLE_ENTRANCE
	beq impactOnDungeonWall			; branch if Temple Entrance.
	cpx #ID_ROOM_OF_SHINING_LIGHT
	bne HandleWeaponVsSnakeCollision; Unconditional branch.
impactOnDungeonWall:
	lda weaponVertPos				; get bullet or whip vertical position
	sbc snakeDungeonState			; subtract snake/dungeon Y
	lsr								; divide by 4 total
	lsr
	beq HandleWallImpactLeftSide	; branch if result is zero
	tax
	ldy weaponHorizPos		; get bullet or whip horizontal position
	cpy #$12
	bcc ClearWhipBulletState						; branch if too far left
	cpy #141
	bcs ClearWhipBulletState						; branch if too far right
	lda #$00		
	sta thiefHmoveIndices,x			; zero out thief movement
	beq ClearWhipBulletState						; unconditional branch
	
HandleWallImpactLeftSide:
	lda weaponHorizPos	; get bullet or whip horizontal position
	cmp #48 					; Compare it to 48 (left side boundary threshold)
	bcs HandleWallImpactRighttSide					; If bullet is at or beyond 48, branch to right-side logic)
	sbc #16 					; Subtract 16 from position (adjusting to fit into the masking table index range)
	eor #$1F					; XOR with 31 to mirror or normalize the range (helps align to bitmask values)

MaskOutDungeonWallSegment:
	lsr			  ; Divide by 4 Total
	lsr			  ;
	tax			  ; Move result to X to use as index into mask table
	lda ItemStatusClearMaskTable,x	  ; Load a mask value from the ItemStatusClearMaskTable table (mask used to disable a wall segment)
	and topOfDungeonGfx ; Apply the mask to the current dungeon graphic state (clear bits to "erase" part of it)
	sta topOfDungeonGfx ; Store the updated graphic state back (modifying visual representation of the wall)
	jmp ClearWhipBulletState
	
HandleWallImpactRighttSide:
	sbc #113	; Subtract 113 from bullet/whip horizontal position
	cmp #32		; Compare result to 32
	bcc MaskOutDungeonWallSegment 	;apply wall mask
ClearWhipBulletState:
	ldy #~BULLET_OR_WHIP_ACTIVE		; Invert BULLET_OR_WHIP_ACTIVE	
	sty weaponStatus			; clear BULLET_OR_WHIP_ACTIVE status
	sty weaponVertPos			; set vertical position out of range
HandleWeaponVsSnakeCollision:
	bit CXM1FB						; check if snake hit with bullet or whip
	bvc HandleIndyVsSnakeOrItemCollision; branch if snake not hit
	bit screenEventState		  ;3
	bvc HandleIndyVsSnakeOrItemCollision
	lda #$5A						; Load $5A.
	sta snakeDungeonY				; Kill Snake? (Move offscreen).
	sta $DC							; Temp.
	sta weaponStatus				; clear BULLET_OR_WHIP_ACTIVE status
	sta weaponVertPos

HandleIndyVsSnakeOrItemCollision:
	; Handles collision with Snakes, Tsetse Flies, or Items (Time Piece).
	bit CXP1FB						; Check P1 (Indy) vs Playfield/Ball Collision.
	bvc HandleMesaSideSecretExit	; Branch if no collision (Bit 6 clear).
	
	ldx currentRoomId				; Get Room ID.
	cpx #ID_TEMPLE_ENTRANCE			; Are we in Temple Entrance?
	beq .indyTouchingTimePiece		; If yes, handle Time Piece pickup.
	
	; --- Flute Immunity Check ---
	lda selectedInventoryId			; Get currently selected item.
	cmp #ID_INVENTORY_FLUTE			; Is it the Flute?
	beq HandleMesaSideSecretExit	; If Flute is selected, IGNORE collision (Immunity to Snakes/Flies).
	
	; --- Damage / Effect Logic ---
	bit screenEventState			; Check Event State (Distinguishes Snakes vs Flies?).
	bpl SetWellOfSoulsEntryEvent	; If Bit 7 is CLEAR, it's a Snake/Lethal -> Jump to Death Logic.
	
	; --- Tsetse Fly Paralysis ---
	; If Bit 7 is SET, it implies Tsetse Flies (Spider Room / Valley).
	lda secondsTimer				; Get Timer.
	and #$07						; Mask for random duration?
	ora #$80						; Set Bit 7.
	sta snakeTimer					; Set "Paralysis" Timer (Indy freezes/turns color).
	bne HandleMesaSideSecretExit	; Return.

SetWellOfSoulsEntryEvent:
	; --- Snake / Lethal Death ---
	bvc HandleMesaSideSecretExit	; Fail-safe?
	lda #$80						; Set Bit 7.
	sta majorEventFlag 				; Trigger Major Event (Death Sequence).
	bne HandleMesaSideSecretExit	; Return.

.indyTouchingTimePiece:
	lda timepieceGfxPtrs
	cmp #<TimeSprite
	bne HandleMesaSideSecretExit
	lda #ID_INVENTORY_TIME_PIECE
	jsr PlaceItemInInventory

HandleMesaSideSecretExit:
	ldx #ID_MESA_SIDE
	cpx currentRoomId
	bne CheckAndDispatchCollisions	; branch if Indy not in MESA_SIDE
	bit CXM0P						; check missile 0 and player collisions
	bpl HandleMesaSideFallCheck		; branch if Indy not entering WELL_OF_SOULS
	stx indyVertPos					; set Indy vertical position (i.e. x = 5)
	lda #ID_WELL_OF_SOULS
	sta currentRoomId				; move Indy to the Well of Souls
	jsr InitializeScreenState
	lda #(XMAX / 2) - 4
	sta indyHorizPos				; place Indy in horizontal middle
	bne .clearCollisionRegisters	; unconditional branch

HandleMesaSideFallCheck:
	ldx indyVertPos					; get Indy's vertical position
	cpx #$4F						; Compare it to 0x4F (79 in decimal)
	bcc CheckAndDispatchCollisions	; If Indy is above this threshold, branch to CheckAndDispatchCollisions (don't fall)
	lda #ID_VALLEY_OF_POISON ; Otherwise, load the screen ID for the Valley of Poison
	sta currentRoomId ; Set the current screen to Valley of Poison
	jsr InitializeScreenState ; Initialize that screen's data (graphics, objects, etc.)
	lda savedThiefVertPos		  ; Load saved vertical position? (context-dependent, possibly return point)
	sta objectVertOffset		  ; Save it as object vertical state? Possibly thief state
	lda savedIndyVertPos		  ; Load saved vertical position (likely for Indy)
	sta indyVertPos		  ; Set Indy's vertical position
	lda savedIndyHorizPos		  ; Load saved horizontal position
	sta indyHorizPos			; Set Indy's horizontal position
	lda #$FD		  ; Load bitmask value
	and mesaSideState		  ; Apply bitmask to a status/control flag
	sta mesaSideState		  ; Store the result back
	bmi .clearCollisionRegisters ; If the result has bit 7 set, skip setting major event flag
	lda #$80		  ; Otherwise, set major event flag
	sta majorEventFlag 	  ;3
.clearCollisionRegisters
	sta CXCLR						; clear all collisions
CheckAndDispatchCollisions:
	bit CXPPMM						; check player / missile collisions
	bmi .branchToPlayerCollisionRoutine			;branch if players collided
	ldx #$00		  ;2
	stx movementDirection		  ; Clear temporary state or flags at movementDirection
	dex			  ; X = $FF
	stx digAttemptCounter		  ; Set digAttemptCounter to $FF
	rol pickupStatusFlags 
	clc			  ;2
	ror pickupStatusFlags 
ContinueToCollisionDispatch:
	jmp	 ScreenLogicDispatcher	  ;3
	
.branchToPlayerCollisionRoutine
	lda currentRoomId				; get the current screen id
	bne .jmpToPlayerCollisionRoutine ; branch if not Treasure Room
	lda treasureIndex		  ;3
	and #7
	tax
	lda MarketBasketItems,x			; get items from market basket
	jsr PlaceItemInInventory			; place basket item in inventory
	bcc ContinueToCollisionDispatch	  ;2
	lda #$01		  ;2
	sta objectVertOffset		  ;3
	bne ContinueToCollisionDispatch						; unconditional branch
	
.jmpToPlayerCollisionRoutine
	asl								; multiply screen id by 2
	tax
	lda PlayerCollisionJumpTable + 1,x
	pha								; push MSB to stack
	lda PlayerCollisionJumpTable,x
	pha								; push LSB to stack
	rts								; jump to player collision routine

;------------------------------------------------------------PlayerCollisionsInWellOfSouls
;
; Handles logic when Indy is in the Well of Souls (Room ID 11).
; This is where the GAME WIN condition is triggered.
;
; Win Logic:
; 1. Checks if Indy is at the correct vertical depth (Y >= 63).
; 2. Checks if a specific "digging/action" state is active ($54).
; 3. Checks if Indy is aligned with the Ark's position (arkLocationRegionId == arkImpactRegionId).
; 4. If all true, sets resetEnableFlag to a positive value, which triggers the End Game sequence.
;
PlayerCollisionsInWellOfSouls
	lda indyVertPos					; get Indy's vertical position
	cmp #63   ; Compare it to 63 (Depth Threshold)
	bcc .takeAwayShovel				; If Indy is above this threshold, he hasn't reached the Ark yet  take away shovel
	lda diggingState		  ; Load action/state variable
	cmp #$54		  ; Compare to $54 (Required State/Frame to trigger)
	bne ResumeCollisionDispatch	  ; If not equal, nothing special happens
	lda arkLocationRegionId	  ; Load Ark's Position State
	cmp arkImpactRegionId	  ; Compare to Indy's calculated region
	bne .arkNotFound   ; If not lined up with the Ark, skip the win logic
	
	; --- WIN CONDITION MET ---
	lda #INIT_SCORE - 12   ; Load final score modifier ($58 = Positive)
	sta resetEnableFlag   ; Store it. This Positive value signals ArkRoomKernel to DRAW the Ark.

	sta adventurePoints   ; Set the players final adventure score
	jsr DetermineFinalScore  ; Calculate ranking/title based on score
	lda #ID_ARK_ROOM  ; Set up transition to Ark Room
	sta currentRoomId
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
	stx spiderRoomState		  ; Clear memory location spiderRoomState  likely a state tracker or script phase
	lda #$80		  ; Load A with 0x80 (10000000 binary)
	sta majorEventFlag 	  ; Set major event flag  likely triggers spider cutscene or scripted logic

ResumeCollisionDispatch:
	jmp	 ScreenLogicDispatcher	  ; Resume standard game logic by dispatching screen-specific behavior
	
PlayerCollisionsInMesaSide
	bit mesaSideState		  ;Check event state flags
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
	ora mesaSideState		  ; Set that bit in event flag
	sta mesaSideState		  ;  Store it back
	bne ContinueGameAfterParachute						; Unconditionally resume normal flow
RemoveParachuteAfterLanding:
	lda #ID_INVENTORY_PARACHUTE
	sec
	jsr TakeItemFromInventory		; carry set...take away selected item
ContinueGameAfterParachute:
	jmp	 ScreenLogicDispatcher	  ;3
	
PlayerCollisionsInMarketplace
	; This handles collision with the 3 Baskets in the Marketplace.
	; It also handles wall collisions (which might represent people or stalls).
	
	bit CXP1FB						; Check P1 (Indy) vs Playfield (Walls/People)
	bpl .indyTouchingMarketplaceBaskets   ; If NO wall collision, check if he's touching baskets.
	
	; --- Wall/Crowd Interaction Logic ---
	; If Indy walks into the "Walls" (likely the decorative stalls or crowd):
	ldy indyVertPos					; get Indy's vertical position
	cpy #$3A		  				; Check Vertical Zone (Row $3A)
	bcc CheckIndyVerticalForMarketplaceFlags	; If Y < $3A, Check specific "shoving" zones.
	
	; Zone 1: Below $3A (Bottom of screen)
	lda #$E0		  				; Mask Top 3 bits
	and movementDirection		  	; Preserve current movement
	ora #$43		   				; Force bits 6, 1, and 0 ($43).
	sta movementDirection		  	; This likely sets "Bumping/Shoving" flags or modifies movement vector.
	jmp	 ScreenLogicDispatcher	  	; Resume
	
CheckIndyVerticalForMarketplaceFlags:
	cpy #$20		  				; Check Zone (Row $20)
	bcc SetMarketplaceFlagsIfInRange; If Y < $20, check top zone.
	
ClearMarketplaceFlags:
	; Zone 2: Between $20 and $3A (Middle "Clear" path?)
	lda #$00		  
	sta movementDirection		   	; Clear movement modification flags.
	jmp	 ScreenLogicDispatcher	  	; Resume
	
SetMarketplaceFlagsIfInRange:
	cpy #$09		   				; Check Topmost Boundary ($09)
	bcc ClearMarketplaceFlags	  	; If Y < $09 (Very top), clear flags.
	
	; Zone 3: Between $09 and $20 (Top Stalls?)
	lda #$E0		  				; Mask Top 3 bits
	and movementDirection		  	
	ora #$42		  				; Force bits 6 and 1 ($42).
	sta movementDirection		  	; Apply "Shove" physics.
	jmp	 ScreenLogicDispatcher	  	; Resume
	
.indyTouchingMarketplaceBaskets
	; --- Basket Content Logic ---
	; If we're not touching walls, we check which basket Indy is touching.
	; The item received depends on WHICH basket (Position) and WHEN (Timer? for Ra).

	lda indyVertPos					; get Indy's vertical position
	cmp #$3A		  				; Check Y-pos against Basket Row
	bcc .indyNotTouchingBottomBasket; If Y < $3A, check Top Baskets.
	
	; Bottom Basket: Contains the KEY
	ldx #ID_INVENTORY_KEY			; Pre-load Key ID
	bne AttemptToAwardHeadOfRa		; Go to award logic (Unconditional branch)
	
.indyNotTouchingBottomBasket
	; Top Row Baskets (check X position)
	lda indyHorizPos				; get Indy's horizontal position
	cmp #$4C		  				; Check Middle/Right boundary
	bcs .indyTouchingRightBasket	; If X >= $4C, it's the Right Basket.
	
	; Left Basket: Contains GRENADES
	ldx #ID_MARKETPLACE_GRENADE		; Pre-load Grenade ID
	bne AttemptToAwardHeadOfRa		; Go to award logic (Unconditional branch)
	
.indyTouchingRightBasket
	; Right Basket: Contains REVOLVER (usually)
	ldx #ID_INVENTORY_REVOLVER		; Pre-load Revolver ID

AttemptToAwardHeadOfRa:
	; --- head of Ra Easter Egg? ---
	; Sometimes, a basket contains the Head of Ra instead of its usual item.
	
	lda #$40		  				
	sta screenEventState		  	; Set flag (maybe visual feedback?)
	
	lda secondsTimer				; get global timer
	and #$1F						; Mask to 0-31 seconds cycle
	cmp #2  						; Check if time is < 2 (Small window at start of cycle?)
	bcs .checkToAddItemToInventory  ; If Time >= 2, give the standard item (Key/Grenade/Revolver).
	
	ldx #ID_INVENTORY_HEAD_OF_RA  	; If Time < 2, swap prize to HEAD OF RA!

.checkToAddItemToInventory
	jsr DetermineIfItemAlreadyTaken ; Check if we already have this specific item
	bcs ExitGiveItemRoutine			; If taken, do nothing.
	
	txa								; Move Item ID to A
	jsr PlaceItemInInventory		; Add to inventory
	
ExitGiveItemRoutine:
	jmp	 ScreenLogicDispatcher	  ; Resume

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
	sta movementDirection		  ;3
ResumeScreenLogic:
	jmp	 ScreenLogicDispatcher	  ;3
	
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
	and movementDirection		  ; Mask movementDirection to preserve top 3 bits 
	ora #$0B		  ; Set bits 0, 1, and 3 (00001011) 
ApplyBlackMarketInteractionFlags:
	sta movementDirection		  ; Store the updated value back into movementDirection
	bne ResumeScreenLogic						 ; Always branch to resume game logic
	
CheckMiddleMarketZone:
	cpy #32
	bcs ResetScreenInteractionFlags	  ; If Y = 32, exit via reset logic
	cpy #11
	bcc ResetScreenInteractionFlags	  ; If Y < 11, exit via reset logic
	lda #$E0		  ;2
	and movementDirection		  ;3
	ora #$41		   ; Set bits 6 and 0 (01000001)
	bne ApplyBlackMarketInteractionFlags						; Go apply and resume logic
	
PlayerCollisionsInTempleEntrance
	inc indyHorizPos			; Push Indy right (prevent entry or simulate barrier?)
	bne ScreenLogicDispatcher	  ; Resume
	
PlayerCollisionsInEntranceRoom
	; This routine handles interactions with the central Rock object.
	; The Rock serves two purposes:
	; 1. A physical obstacle (Collision pushes Indy left).
	; 2. A pedestal for the Whip (Y >= 63 triggers pickup).

	lda indyVertPos					; get Indy's vertical position
	cmp #63							; Check Pickup Threshold (Is Indy "below" the main rock body?)
	bcc CheckVerticalTriggerRange	; If Y < 63, treat as physical collision (Rock)
	
	; --- Whip Pickup Logic ---
	lda #ID_INVENTORY_WHIP			; Load Whip Item ID
	jsr PlaceItemInInventory		; Attempt to add to inventory
	bcc ScreenLogicDispatcher		; If inventory full (Carry Clear), exit
	
	ror entranceRoomState			; Update Room State:
	sec								;   Set High Bit of rotated value (becomes Bit 0 after roll)
	rol entranceRoomState			;   Rotate Left: Bit 0 = 1 (Whip Taken)
	
	lda #66							; Move the Whip visuals (or related object) to Y=66
	sta whipVertPos					; (Note: whipVertPos aliases objectVertOffset, may affect dungeon rendering or logical pos)
	bne ScreenLogicDispatcher		; Resume
	
CheckVerticalTriggerRange:
	; --- Rock Collision Logic ---
	; Determines if Indy is hitting the solid part of the rock.
	; The Rock seems to have a "safe hole" or "pass-through" zone between Y=22 and Y=31?
	; Or perhaps the geometry suggests a specific shape.
	
	cmp #22  						; Top Bound
	bcc PushIndyLeftOutOfTriggerZone; If Y < 22, Push Left (Hit Rock Top)
	cmp #31  						; Bottom Bound of Top Segment?
	bcc ScreenLogicDispatcher	 	; If 22 <= Y < 31, pass-through (Safe Zone?)
	
	; If Y >= 31 (and < 63 from earlier check), fall through to push left.
	
PushIndyLeftOutOfTriggerZone:
	dec indyHorizPos				; Push Indy Left (Oppose movement into rock from right?)
									; Effectively makes the rock solid.

ScreenLogicDispatcher:
	lda currentRoomId				; get the current screen id
	asl								; multiply screen id by 2 (since each jump table entry is 2 bytes: low byte, high byte)
	tax  ; Move the result to X  now X is the index into a jump table
	bit CXP1FB						; check Indy collision with playfield
	bpl ScreenIdleLogicDispatcher						; If no collision (bit 7 is clear), branch to non-collision handler 
	lda PlayerPlayfieldCollisionJumpTable + 1,x  ; Load high byte of handler address
	pha  ; Push it to the return stack  
	lda PlayerPlayfieldCollisionJumpTable,x    ; Load low byte of handler address
	pha   ; Push it to the return stack
	rts								; jump to Player / Playfield collision strategy

ScreenIdleLogicDispatcher:
	lda RoomIdleHandlerJumpTable+1,x	; Load high byte of default screen behavior routine
	pha			  
	lda RoomIdleHandlerJumpTable,x	  ; Load low byte of default screen behavior routine
	pha			  ;3
	rts			  ; Indirect jump to it (no collision case)

WarpToMesaSide:
	lda objectVertOffset		  ; Load vertical position of an object (likely thief or Indy)
	sta savedThiefVertPos		  ; Store it to temp variable savedThiefVertPos (could be thief vertical position)
	lda indyVertPos					; get Indy's vertical position
	sta savedIndyVertPos		  ; Store to temp variable savedIndyVertPos
	lda indyHorizPos			;3
SaveIndyAndThiefPosition:
	sta savedIndyHorizPos		  ; Store to temp variable savedIndyHorizPos 
PlaceIndyInMesaSide
	lda #ID_MESA_SIDE ; Change screen to Mesa Side
	sta currentRoomId
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
	jmp StandardRoomIdleHandler

InitFallbackEntryPosition:
	bit mapRoomState		  ; Check status bits  unknown purpose, possibly related to event or room state
	bmi FailSafeToCollisionCheck	  ; If bit 7 of mapRoomState is set, jump to collision handler (fail-safe)
	lda #$50		  ;2
	sta savedThiefVertPos		  ; Store a fixed vertical position into savedThiefVertPos (likely a respawn or object Y pos)
	lda #$41		  ;2
	sta savedIndyVertPos		 ; Store a fixed vertical position for Indy
	lda #$4C		  ;2
	bne SaveIndyAndThiefPosition						; Store fixed horizontal position and continue to position saving logic
	
RestrictIndyMovementInTemple:
	ldy indyHorizPos			;3
	cpy #$2C		  ; Is Indy too far left? (< 44)
	bcc .nudgeIndyRight	  ; Yes, nudge him right
	cpy #$6B		  ; Is Indy too far right? (= 107)
	bcs .nudgeIndyLeft	  ; Yes, nudge him left
	ldy indyVertPos					; get Indy's vertical position
	iny			  ; Try to move Indy down 1 px
	cpy #$1E		 ; Cap at vertical position 30
	bcc .setRestrictedVertPos	   ; If not over, continue
	dey			  ;2
	dey			  ;2  ; Else, move Indy up 1 px instead
.setRestrictedVertPos:
	sty indyVertPos		  ; Apply vertical adjustment
	jmp	 SetIndyToNormalMovementState	  ; Continue to Indy-snake interaction check
	
.nudgeIndyRight:
	iny			   
	iny			  ; Nudge Indy right 2 px
.nudgeIndyLeft:
	dey			  
	sty indyHorizPos			; Apply horizontal adjustment
	bne SetIndyToNormalMovementState						; Continue
	
IndyPlayfieldCollisionInEntranceRoom
	; Handles collision with Room Walls.
	; Specifically handles the "Grenade Opening" mechanism to the Marketplace? (Left Wall)
	
	lda #GRENADE_OPENING_IN_WALL	; check flag: Is the wall blown open? ($02)
	and entranceRoomState
	beq .moveIndyLeftOnePixel		; If not blown, treat as solid wall (Push Left)

	; Wall is Blown Open - check if Indy is passing through the hole.
	lda indyVertPos					; get Indy's vertical position
	cmp #18
	bcc .moveIndyLeftOnePixel		; If Y < 18 (Above Hole), Hit Wall.
	cmp #36
	bcc SlowDownIndyMovement		; If 18 <= Y < 36 (Inside Hole), Allow movement but Slow Down?
									; (SlowDownIndyMovement usually simulates "difficult terrain" or transition)

.moveIndyLeftOnePixel
	dec indyHorizPos				; Push Indy Left (Solid Wall)
	bne SetIndyToNormalMovementState; Resume

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
	stx topOfDungeonGfx			; restore dungeon graphics
	ldx #1
	stx dungeonGfxData + 1
	stx dungeonGfxData + 2
	stx dungeonGfxData + 3
	stx dungeonGfxData + 4
	stx dungeonGfxData + 5
	bne SetIndyToNormalMovementState						; unconditional branch
	
MoveIndyBasedOnInput:
	lda inputFlags		  ; Load movement direction from input flags
	and #$0F		   ; Isolate lower 4 bits (D-pad direction)
	tay			  ; Use as index
	lda IndyMovementDeltaTable,y	   ; Get movement delta from direction lookup table
	ldx #<indyVertPos - objectVertPositions ; X = offset to Indy in object array
	jsr DetermineDirectionToMoveObject ; Move Indy accordingly
SetIndyToNormalMovementState:
	lda #$05		  
	sta soundChan0_IndyState		  ; Likely sets a status or mode flag
	bne StandardRoomIdleHandler; unconditional branch
	
SlowDownIndyMovement
	rol playerInputState
	sec
	bcs UndoInputBitShift						; unconditional branch
	
SetIndyToTriggeredState:
	rol playerInputState
	clc			  ;2
UndoInputBitShift:
	ror playerInputState
StandardRoomIdleHandler:
	bit CXM0P						; check player collisions with missile0
	bpl CheckGrenadeDetonation		; branch if didn't collide with Indy
	ldx currentRoomId				; get the current screen id
	cpx #ID_SPIDER_ROOM				; Are we in the Spider Room?
	beq ClearInputBit0ForSpiderRoom	; Yes, go to ClearInputBit0ForSpiderRoom
	bcc CheckGrenadeDetonation		; If screen ID is lower than Spider Room, skip 
	lda #$80						; Trigger a major event (Death/Capture)
	sta majorEventFlag				; Set flag.
	bne DespawnMissile0				; unconditional branch
	
ClearInputBit0ForSpiderRoom:
	rol playerInputState			; Rotate input left, bit 7 ? carry
	sec								; Set carry (overrides carry from rol)
	ror playerInputState			; Rotate right, carry -> bit 7 (bit 0 lost)
	rol spiderRoomState				; Rotate a status byte left (bit 7 ? carry)
	sec								; Set carry (again overrides whatever came before)
	ror spiderRoomState				; Rotate right, carry -> bit 7 (bit 0 lost)

DespawnMissile0:
	lda #$7F		 
	sta m0VertPosShadow				; Possibly related state or shadow position
	sta m0VertPos					; Move missile0 offscreen (to y=127)

CheckGrenadeDetonation:
	bit grenadeState				; Check status flags
	bpl VerticalSync  ; If bit 7 is clear, skip (no grenade active?)
	bvs ApplyGrenadeWallEffect	  ; If bit 6 is set, jump (special case, maybe already exploded)
	lda secondsTimer					; get seconds time value
	cmp grenadeDetinationTime		; compare with grenade detination time
	bne VerticalSync					; branch if not time to detinate grenade
	lda #$A0		  ;2
	sta weaponVertPos    ; Move bullet/whip offscreen (simulate detonation?)
	sta majorEventFlag 	   ; Trigger major event (explosion happened?)
ApplyGrenadeWallEffect:
	lsr grenadeState		   ; Logical shift right: bit 0 -> carry
	bcc SkipUpdate	  ; If bit 0 was clear, skip this (grenade effect not triggered)
	lda #GRENADE_OPENING_IN_WALL
	sta grenadeOpeningPenalty		; Apply penalty (e.g., reduce score)
	ora entranceRoomState
	sta entranceRoomState    ; Mark the entrance room as having the grenade opening
	ldx #ID_ENTRANCE_ROOM
	cpx currentRoomId
	bne UpdateEntranceRoomEventState		; branch if not in the ENTRANCE_ROOM
	jsr InitializeScreenState   ; Update visuals/state to reflect the wall opening
UpdateEntranceRoomEventState:
	lda entranceRoomEventState		  ;3
	and #$0F		  
	beq SkipUpdate	  ; If no condition active, exit
	lda entranceRoomEventState		   
	and #$F0		  ; Clear lower nibble
	ora #$01		   ; Set bit 0 (indicate some triggered state)
	sta entranceRoomEventState		  ; Store updated state
	ldx #ID_ENTRANCE_ROOM
	cpx currentRoomId
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
	cmp weaponVertPos
	bcs UpdateFrameAndSecondsTimer
	sta weaponHorizPos
UpdateFrameAndSecondsTimer:
	inc frameCount					; increment frame count
	lda #$3F
	and frameCount
	bne .firstLineOfVerticalSync		; branch if roughly 60 frames haven't passed
	inc secondsTimer					; increment every second
	lda snakeTimer								; If snakeTimer is positive, skip
	bpl .firstLineOfVerticalSync
	dec snakeTimer								; Else, decrement it
.firstLineOfVerticalSync
	sta WSYNC							; Wait for start of next scanlineCounter
	bit resetEnableFlag
	bpl .continueVerticalSync
	ror SWCHB						; rotate RESET to carry
	bcs .continueVerticalSync		; branch if RESET not pressed
	jmp startGame						 ; If RESET was pressed, restart the game
	
.continueVerticalSync
	sta WSYNC						 ; Sync with scanlineCounter (safely time video registers)
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
	sta currentRoomId
	jsr InitializeScreenState ; Transition to Ark Room
GotoArkRoomLogic:
	jmp	 SetupScreenVisualsAndObjects	  ;3
	
CheckToShowDeveloperInitials
	lda currentRoomId				; get the current screen id
	cmp #ID_ARK_ROOM
	bne HandlePostEasterEggFlow						; branch if not in ID_ARK_ROOM
	lda #$9C		  
	sta soundChan1_WhipTimer		  ; Likely sets a display timer or animation state
	ldy yarEasterEggBonus
	beq CheckArkRoomEasterEggFailConditions	  ; If not in Yar's Easter Egg mode, skip
	bit resetEnableFlag
	bmi CheckArkRoomEasterEggFailConditions	  ; If resetEnableFlag has bit 7 set, skip
	ldx #>HSWInitials_00
	stx inventoryGfxPtrs + 1
	stx inventoryGfxPtrs + 3
	lda #<HSWInitials_00
	sta inventoryGfxPtrs
	lda #<HSWInitials_01
	sta inventoryGfxPtrs + 2
CheckArkRoomEasterEggFailConditions:
	ldy indyVertPos					; get Indy's vertical position
	cpy #$7C		  ;124 dev
	bcs SetIndyToArkDescentState	  ; If Indy is below or at Y=$7C (124), skip
	cpy adventurePoints
	bcc SlowlyLowerIndy	  ; If Indy is higher up than his point score, skip
	bit INPT5						; read action button from right controller
	bmi GotoArkRoomLogic						; branch if action button not pressed
	jmp startGame			; RESET game if button *is* pressed
	
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
	sta soundChan0_IndyState		   ; Set Indys state to 0E
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
	sta arkLocationRegionId	 ; Store action/state code
	jmp	 InitializeGameStartState	  ; Handle command
	
HandlePostEasterEggFlow:
	bit screenEventState		  
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
	sta indyHorizPos		  ; Store Indys forced horizontal position?
IncrementArkSequenceStep:
	inx			  ;2
	stx digAttemptCounter		  ; Increment and store progression step or counter (used for speed/timing)
	txa			  ;2
	sec			  ;2
	sbc #$07		  ; Subtract 7 to control pacing (Snake updates every 7th frame?)
	bpl SnakeMovementController	  ; If result >= 0, branch to Logic
	lda #$00		 ; Otherwise, reset A to 0
	
SnakeMovementController:
	; This routine controls the Snake (or Dungeon Entrance Guardian).
	; The Snake is drawn using the BALL sprite (`ENABL`).
	; Its "Shape" is created by modifying the Horizontal Motion (`HMBL`) 
	; on every scanline, causing the ball to "wiggle" as it is drawn.
	
	sta snakeDungeonY		  ; Store A (Timer/Counter-based Y) into snakeDungeonY
	and #$F8		  		  ; Mask to coarse vertical steps
	cmp snakeVertPos			; Compare with current visual Y
	beq ConfigureSnakeGraphicsAndMovement	  ; If vertical alignment hasn't changed, skip movement update
	
	sta snakeVertPos			; Update snake's vertical position
	
	; --- Calculate Horizontal Steering ---
	; The snake steers towards Indy.
	lda snakeDungeonState		  ; Load state (movement/animation frame)
	and #$03		  			  ; Mask low 2 bits (Animation Frame 0-3)
	tax			  				  ; X = Frame ID
	
	lda snakeDungeonState		  ; Load state again
	lsr			  				  ; Shift 4 times to get upper nibble (Direction/Mode?)
	lsr			  
	tay			  				  ; Y = Steering Mode
	
	lda SnakeHorizontalOffsetTable,x	  ; Get base sway offset
	clc			  
	adc SnakeHorizontalOffsetTable,y	  ; Add Steering offset
	clc			  
	adc indyHorizPos		  	  ; Add Indy's X position (Snake follows Indy)
	
	; --- Check Boundaries and Distance ---
	ldx #$00		  			  ; Default Steering Adjustment
	cmp #$87		  			  ; Right Boundary Check
	bcs AdjustSnakeBehaviorByDistance	  ; If > $87, skip logic
	cmp #$18		  			  ; Left Boundary Check
	bcc FlipSnakeDirectionIfNeeded	  ; If < $18, force flip
	
	sbc indyHorizPos			; Calculate distance to Indy
	sbc #$03		  			; Minus 3 pixels
	bpl AdjustSnakeBehaviorByDistance	  ; If positive (Snake is to the right of Indy?), skip
	
FlipSnakeDirectionIfNeeded:
	inx			   				; X = 1
	inx			  				; X = 2 (Reverse direction/sway)
	eor #$FF		 			; Invert delta
	
AdjustSnakeBehaviorByDistance:
	cmp #$09		  			; Check proximity to Indy
	bcc UpdateSnakeMotionState	; If < 9 pixels away (Very Close), don't change state height
	inx			 				; Else increments X (Change Sway intensity)
	
UpdateSnakeMotionState:
	txa			  				; Move Sway/Steering Factor to A
	asl			  
	asl			  
	sta $84		  				; Store in Temp ($84) as Upper Nibble
	
	; --- Update Indy's Forced Position (Simulate Push?) ---
	; Or update Snake's target position?
	lda snakeDungeonState		  
	and #$03		  
	tax			  
	lda SnakeHorizontalOffsetTable,x	  
	clc			  
	adc indyHorizPos		  
	sta indyHorizPos		  ; Note: This seems to modify Indy's position? 
							  ; (Could be subtle nudge or actually just writing back to a temp variable 
							  ;  misnamed indyHorizPos in previous refactors? No, it's $C9)
							  
	; --- Resolve Final State ---
	lda snakeDungeonState		  
	lsr			  
	lsr			  
	ora $84		  				; Combine new Steering Factor (High Nibble) with old state
	sta snakeDungeonState		; Save
	
ConfigureSnakeGraphicsAndMovement:
	; Sets up the pointers for the Bank 1 Kernel to draw the "Wiggling Ball".
	lda snakeDungeonState		  
	and #$03		  			; Frame 0-3
	tax			  
	lda SnakeMotionTableLSB,x	  ; Get Low Byte of Motion Table for this frame
	sta timepieceGfxPtrs		  ; Store in Pointer (reused $D6)
	
	lda #>SnakeMotionTable_0	  ; High Byte is fixed (Page $FA?)
	sta $D7		  				  ; Store High Byte
	
	; Calculate Vertical Offset/Sprite Index
	lda snakeDungeonState		  
	lsr			  
	lsr			  
	tax			  
	lda SnakeMotionTableLSB,x	  ; Look up another table value?
	sec			  
	sbc #$08		  			  ; Subtract 8 lines (Height of snake)
	sta timepieceSpriteDataPtr	  ; Store as Sprite Data Pointer (used for rendering loop limits)
	
CheckMajorEventComplete:
	bit majorEventFlag 	  ;3
	bpl CheckGameScriptTimer	  ; If major event not complete, continue sequence
	jmp	 SwitchToBank1AndContinue	   ;Else, jump to end/cutscene logic
	
CheckGameScriptTimer:
	bit snakeTimer		  ;3
	bpl BranchOnFrameParity	  ; If timer still counting or inactive, proceed
	jmp	 SetIndyStationarySprite	   ; Else, jump to alternate script path (failure/end?)
	
BranchOnFrameParity:
	lda frameCount					; get current frame count
	ror								;  ; Test even/odd frame
	bcc GatePlayerTriggeredEvent						; ; If even, continue next step
	jmp	 ClearItemUseOnButtonRelease	   ; If odd, do something else
	
GatePlayerTriggeredEvent:
	ldx currentRoomId				; get the current screen id
	cpx #ID_MESA_SIDE
	beq AbortProjectileDrivenEvent						; If on Mesa Side, use a different handler
	bit eventState
	bvc CheckInputAndStateForEvent						; If no event/collision flag set, skip
	ldx weaponHorizPos			; get bullet or whip horizontal position
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
	stx weaponHorizPos
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
	bit mesaSideState		  ;3
	bmi AbortProjectileDrivenEvent	  ; If flag set, skip
	bit playerInputState
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
	sta inputFlags		  ;3
	jsr DetermineDirectionToMoveObject  ; Move Indy according to input
	ldx currentRoomId				; get the current screen id
	ldy #$00		  ;2
	sty $84		  ; Reset scan index/counter 
	beq StoreIndyPositionForEvent	  ; Unconditional (Y=0, so BNE not taken)
	
IncrementEventScanIndex:
	tax			   ; Transfer A to X (probably to use as an object index or ID)
	inc $84		  ; Increment $84  a general-purpose counter or index
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
	sty currentRoomId		  ; Set new screen based on event result
	jsr InitializeScreenState ; Load new room or area
HandleInventoryButtonPress:
	bit INPT4						; read action button from left controller
	bmi NormalizeplayerInputState						; branch if action button not pressed
	bit grenadeState		  ;3
	bmi ExitItemHandler	  ; If game state prevents interaction, skip
	lda playerInputState
	ror			   ; Check bit 0 of input
	bcs HandleItemPickupAndInventoryUpdate	  ; If set, already mid-action, skip
	sec				 ; Prepare to take item
	jsr TakeItemFromInventory		; carry set...take away selected item
	inc playerInputState					;  Advance to next inventory slot
	bne HandleItemPickupAndInventoryUpdate						; Always branch
	
NormalizeplayerInputState:
	ror playerInputState
	clc			  ;2
	rol playerInputState
HandleItemPickupAndInventoryUpdate:
	lda movementDirection		  ;3
	bpl ExitItemHandler	  ; If no item queued, exit
	and #$1F		  ; Mask to get item ID
	cmp #$01		  ;2
	bne CheckShovelPickup	  ;2
	inc bulletCount		; Give Indy 3 bullets
	inc bulletCount
	inc bulletCount
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
	stx m0VertPos
PlaceGenericItem:
	jsr PlaceItemInInventory
ClearItemUseFlag:
	lda #$00		  ;2
	sta movementDirection		   ; Clear item pickup/use state
ExitItemHandler:
	jmp	 UpdateIndySpriteForParachute	  ;; Return from event handle
	
ClearItemUseOnButtonRelease:
	bit grenadeState		   ; Test game state flags
	bmi ExitItemHandler	  ; If bit 7 is set (N = 1), then a grenade or parachute event is in progress.
	bit INPT5						; read action button from right controller
	bpl HandleItemUseOnButtonPress						; branch if action button pressed
	lda #~USING_GRENADE_OR_PARACHUTE  ; Load inverse of USING_GRENADE_OR_PARACHUTE (i.e., clear bit 1)
	and playerInputState ;; Clear the USING_GRENADE_OR_PARACHUTE bit from the player input state
	sta playerInputState  ; Store the updated input state
	jmp	 UpdateIndySpriteForParachute	 
	
HandleItemUseOnButtonPress:
	lda #USING_GRENADE_OR_PARACHUTE ; Load the flag indicating item use (grenade/parachute)
	bit playerInputState    ; Check if the flag is already set in player input
	bne ExitItemUseHandler	   ; If it's already set, skip re-setting (item already active)
	ora playerInputState  ; Otherwise, set the USING_GRENADE_OR_PARACHUTE bit
	sta playerInputState   ; Save the updated input state
	ldx selectedInventoryId			; get the current selected inventory id
	cpx #ID_MARKETPLACE_GRENADE  ; Is the selected item the marketplace grenade?
	beq StartGrenadeThrow	   ; If yes, jump to grenade activation logic
	cpx #ID_BLACK_MARKET_GRENADE   ; If not, is it the black market grenade?
	bne CheckToActivateParachute  ; If neither, check if it's a parachute
StartGrenadeThrow:
	ldx indyVertPos					; get Indy's vertical position
	stx weaponVertPos		; Set grenade's starting vertical position
	ldy indyHorizPos					; get Indy horizontal position
	sty weaponHorizPos			; Set grenade's starting horizontal position
	lda secondsTimer					; get the seconds timer
	adc #5 - 1						; increment value by 5...carry set
	sta grenadeDetinationTime		; detinate grenade 5 seconds from now
	lda #$80		   ; Prepare base grenade state value (bit 7 set)
	cpx #ENTRANCE_ROOM_ROCK_VERT_POS  ; Is Indy below the rock's vertical line?
	bcs StoreGrenadeState						; branch if Indy is under rock scanlineCounter
	cpy #$64		  ; Is Indy too far left?
	bcc StoreGrenadeState	 
	ldx currentRoomId				; get the current screen id
	cpx #ID_ENTRANCE_ROOM				; Are we in the Entrance Room?
	bne StoreGrenadeState						; branch if not in the ENTRANCE_ROOM
	ora #$01		  ; Set bit 0 to trigger wall explosion effect
StoreGrenadeState:
	sta grenadeState		  ; Store the grenade state flags: Bit 7 set: grenade is active - Bit 0 optionally set: triggers wall explosion if conditions were met
	jmp	 UpdateIndySpriteForParachute	  
	
CheckToActivateParachute
	cpx #ID_INVENTORY_PARACHUTE  ; Is the selected item the parachute?
	bne HandleSpecialItemUseCases	  ; If not, branch to other item handling
	stx usingParachuteBonus  ; Store the parachute usage flag for scoring bonus
	lda mesaSideState		   ; Load major event and state flags
	bmi ExitItemUseHandler	   ; If bit 7 is set (already parachuting), skip reactivation
	ora #$80		   ; Set bit 7 to indicate parachute is now active
	sta mesaSideState		  ; Save the updated event flags
	lda indyVertPos					; get Indy's vertical position
	sbc #6							; Subtract 6 (carry is set by default), to move him slightly up
	bpl SetAdjustedParachuteStartY	 ; If the result is positive, keep it
	lda #$01		  ; If subtraction underflows, cap position to 1
SetAdjustedParachuteStartY:
	sta indyVertPos		  ;3
	bpl FinalizeImpactEffect						; unconditional branch
	
HandleSpecialItemUseCases:
	bit eventState	  ; Check special state flags (likely related to scripted events)
	bvc AttemptDiggingForArk	  ; If bit 6 is clear (no vertical event active), skip to further checks
	bit CXM1FB	  ; Check collision between missile 1 and playfield
	bmi CalculateImpactRegionIndex	   ; If collision occurred (bit 7 set), go to handle collision impact
	jsr	 WarpToMesaSide	 ; No collision  warp Indy to Mesa Side (context-dependent event)
ExitItemUseHandler:
	jmp	 UpdateIndySpriteForParachute	  ;3
	
CalculateImpactRegionIndex:
	lda weaponVertPos			; get bullet or whip vertical position
	lsr			  ; Divide by 2 (fine-tune for tile mapping)
	sec			  ; Set carry for subtraction
	sbc #$06		  ; Subtract 6 (offset to align to tile grid)
	clc			  ; Clear carry before next addition
	adc objectVertOffset		  ; Add reference vertical offset (likely floor or map tile start)
	lsr			  ; Divide by 16 total:
	lsr			  ; Effectively: (Y - 6 + objectVertOffset) / 16
	lsr			  
	lsr			  
	cmp #$08		  ; Check if the result fits within bounds (max 7)
	bcc ApplyImpactEffectsAndAdjustPlayer	  ; If less than 8, jump to store the index
	lda #$07		  ; Clamp to max value (7) if out of bounds
ApplyImpactEffectsAndAdjustPlayer:
	sta $84		  ; Store the region index calculated from vertical position
	lda weaponHorizPos			; get bullet or whip horizontal position
	sec			  ;2
	sbc #$10		  ; Adjust for impact zone alignment
	and #$60		   ; Mask to relevant bits (coarse horizontal zone)
	lsr			  
	lsr			  ; Divide by 4  convert to tile region
	adc $84		   ; Combine with vertical region index to form a unique map zone index
	tay			  ; Move index to Y
	lda ArkRoomImpactResponseTable,y	   ; Load impact response from lookup table
	sta arkImpactRegionId	   ; Store result  likely affects state or visual of game field
	ldx weaponVertPos			; get bullet or whip vertical position
	dex			  ; Decrease projectile X by 2  simulate impact offset
	stx weaponVertPos
	stx indyVertPos		  ; Sync Indy's horizontal position to projectiles new position
	ldx weaponHorizPos			
	dex			  ; Decrease projectile X by 2  simulate impact offset
	dex			  
	stx weaponHorizPos
	stx indyHorizPos			; Sync Indy's horizontal position to projectiles new position
	lda #$46		  ; Set special state value
	sta eventState	    ; Likely a flag used by event logic
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
	inc digAttemptCounter		  ; Increment dig attempt counter
	bne ExitItemUseHandler	  ; If not the first dig attempt, exit
	ldy diggingState		  ; Load current dig depth or animation frame
	dey			  ; Decrease depth
	cpy #$54		  ; Is it still within range?
	bcs ClampDigDepth	  ; If at or beyond max depth, cap it
	iny			  ; Otherwise restore it back (prevent negative values)
ClampDigDepth:
	sty diggingState		  ; Save the clamped or unchanged dig depth value
	lda #BONUS_FINDING_ARK
	sta findingArkBonus			; Set the bonus for having found the Ark
	bne ExitItemUseHandler						; unconditional branch
	
UseAnkhToWarpToMesaField:
	cpx #ID_INVENTORY_ANKH		; Is the selected item the Ankh?
	bne HandleWeaponUseOnMove	  ; If not, skip to next item handling
	ldx currentRoomId				; get the current screen id
	cpx #ID_TREASURE_ROOM		; Is Indy in the Treasure Room?
	beq ExitItemUseHandler						; If so, don't allow Ankh warp from here
	lda #ID_MESA_FIELD			; Mark this warp use (likely applies 9-point score penalty)
	sta skipToMesaFieldBonus			; set to reduce score by 9 points
	sta currentRoomId		  ; Change current screen to Mesa Field
	jsr InitializeScreenState ; Load the data for the new screen
	lda #$4C		  ; Prepare a flag or state value for later use (e.g., warp effect)
WarpPlayerToMesaFieldStart:
	sta indyHorizPos			; Set Indy's horizontal position
	sta weaponHorizPos			; Set projectile's horizontal position (same as Indy)
	lda #$46		  ; Fixed vertical position value (start of Mesa Field?)
	sta indyVertPos		  ; Set Indy's vertical position
	sta weaponVertPos		 ; Set projectile's vertical position
	sta eventState	  ; Set event/state flag (used later to indicate transition or animation)
	lda #$1D		  ; Set initial vertical scroll or map offset?
	sta objectVertOffset		  ; Likely adjusts tile map base Y
	bne UpdateIndySpriteForParachute						; Unconditional jump to common handler
	
HandleWeaponUseOnMove:
	lda SWCHA						; read joystick values
	and #P1_NO_MOVE				; Mask to isolate movement bits
	cmp #P1_NO_MOVE
	beq UpdateIndySpriteForParachute						; branch if right joystick not moved
	cpx #ID_INVENTORY_REVOLVER
	bne .checkForIndyUsingWhip		; check for Indy using whip
	bit weaponStatus			; check bullet or whip status
	bmi UpdateIndySpriteForParachute						; branch if bullet active
	ldy bulletCount				; get number of bullets remaining
	bmi UpdateIndySpriteForParachute						; branch if no more bullets
	dec bulletCount				; reduce number of bullets
	ora #BULLET_OR_WHIP_ACTIVE
	sta weaponStatus			; set BULLET_OR_WHIP_ACTIVE bit
	lda indyVertPos					; get Indy's vertical position
	adc #4							; Offset to spawn bullet slightly above Indy
	sta weaponVertPos			; Set bullet Y position
	lda indyHorizPos				
	adc #4							; Offset to spawn bullet slightly ahead of Indy
	sta weaponHorizPos		 ; Set bullet X position
	bne TriggerWhipEffect						; unconditional branch
	
.checkForIndyUsingWhip
	cpx #ID_INVENTORY_WHIP			; Is Indy using the whip?
	bne UpdateIndySpriteForParachute						; branch if Indy not using whip
	ora #$80		  ; Set a status bit (probably to indicate whip action)
	sta eventState		  ; Store it in the game state/event flags
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
	sta weaponHorizPos		; Add to Indys current horizontal position
	txa			  ;2				 ; Move vertical offset (X) into A
	clc			  ;2
	adc indyVertPos		  ; Add to Indys current vertical position
	sta weaponVertPos ; Set whip strike vertical position
TriggerWhipEffect:
	lda #$0F		  ; Set effect timer or flag for whip (e.g., 15 frames)
	sta soundChan1_WhipTimer		  ; Likely used to animate or time whip visibility/effect
UpdateIndySpriteForParachute:
	bit mesaSideState		  ; Check game status flags
	bpl SetIndySpriteIfStationary	  ; If parachute bit (bit 7) is clear, skip parachute rendering
	lda #<ParachutingIndySprite		; Load low byte of parachute sprite address
	sta indyGfxPtrs			; Set Indy's sprite pointer
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
	sta indyGfxPtrs				  ; Store sprite pointer (low byte)
	lda #H_INDY_SPRITE					 ; Load height for standard Indy sprite
.setIndySpriteHeight
	sta indySpriteHeight				 ; Store sprite height
	bne HandleEnvironmentalSinkingEffect						; unconditional branch
	
UpdateIndyWalkingAnimation:
	lda #$03		   ; Mask to isolate movement input flags (e.g., up/down/left/right)
	bit playerInputState
	bmi CheckAnimationTiming	  ; If bit 7 (UP) is set, skip right shift
	lsr			  ; Shift movement bits (to vary animation speed/direction)
CheckAnimationTiming:
	and frameCount		; Use frameCount to time animation updates
	bne HandleEnvironmentalSinkingEffect			 ; If result is non-zero, skip sprite update this frame
	lda #H_INDY_SPRITE		; Load base sprite height
	clc			  		
	adc indyGfxPtrs					; Advance to next sprite frame
	cmp #<IndyStationarySprite				 ; Check if we've reached the end of walking frames
	bcc .setIndySpriteLSBValue				; If not yet at stationary, update sprite pointer
	lda #$02								; Set a short animation timer
	sta soundChan1_WhipTimer		  ;3
	lda #<Indy_0						;; Reset animation back to first walking frame
	bcs .setIndySpriteLSBValue		; Unconditional jump to store new sprite pointer
HandleEnvironmentalSinkingEffect:
	; --------------------------------------------------------------------------
	; MESA FIELD / VALLEY SINKING STATE MACHINE
	; --------------------------------------------------------------------------
	; This routine simulates vertical movement (Sinking/Rising) relative to the 
	; environmental background.
	;
	; Note on Mechanics:
	; The Bank 1 Screen Handler (MesaFieldScreenHandler) pins key objects (M0, Snake)
	; to center screen ($7F). This routine Modifies Indy's position relative to them.
	; - If Sinking: Indy moves DOWN (inc indyVertPos), Objects nominally move UP relative
	;   to him, but code here increments their variables? 
	;   Wait, if Bank 1 force-sets them to $7F, these increments to m0VertPos might be 
	;   for "flicker" effects or are overridden immediately in the next frame display,
	;   implying the "Sink" is entirely visually driven by Indy moving down and the 
	;   Background (controlled by objectVertOffset) shifting.
	;
	ldx currentRoomId				; get the current screen id
	cpx #ID_MESA_FIELD				 ; Load current screen ID
	beq CheckSinkingEligibility			; If yes, check sinking conditions
	cpx #ID_VALLEY_OF_POISON			; If yes, check sinking conditions
	bne SwitchToBank1AndContinue	 					 ; If neither, skip this routine

CheckSinkingEligibility:
	lda frameCount					; get current frame count
	bit playerInputState
	bpl ApplySinkingIfInZone	   ; If bit 7 of playerInputState is clear (Input Idle/Not Pushing Up), sink naturally.
	lsr			   					; If pushing Up, slow down the sink rate (by shifting frame mask capability?)

ApplySinkingIfInZone:
	ldy indyVertPos					; get Indy's vertical position
	cpy #$27		  				; Check Lower Bound (Bottom of Sinking Zone)
	beq SwitchToBank1AndContinue	  					; If at bottom, stop sinking.
	
	ldx objectVertOffset		  					; Load "Sink Depth/Scroll" Offset
	bcs ReverseSinkingEffectIfApplicable						; If Input Active (Pushing Up? via Carry from LSR?), perform Rise logic.
	
	; === SINKING LOGIC (Gravity/Quicksand) ===
	beq SwitchToBank1AndContinue						; If objectVertOffset is 0 (Solid Ground or Max Sink?), stop.
	
	inc indyVertPos					; Move Indy DOWN
	inc weaponVertPos			; Move Weapon DOWN with him
	
	and #$02						; Check Frame Timing (Every 2nd frame?)
	bne SwitchToBank1AndContinue						; Skip update if not frame aligned
	
	dec objectVertOffset							; Decrease Scroll/Sink Offset (Background moves?)
	
	; These variables are modified but overridden in Bank 1 for display.
	; They might be used for collision detection or logic state before the Screen Handler runs.
	inc $CE							
	inc m0VertPos				
	inc snakeDungeonY							
	inc $CE		
	inc m0VertPos				
	inc snakeDungeonY		  ;5
	jmp	 SwitchToBank1AndContinue	  					

ReverseSinkingEffectIfApplicable:
	; === RISING LOGIC (Fighting the sink) ===
	cpx #$50		  ; Check Upper Bound (Top of Sink Zone)
	bcs SwitchToBank1AndContinue	  ; If at top, stop rising.
	
	dec indyVertPos		  			; Move Indy UP
	dec weaponVertPos			; Move Weapon UP
	
	and #$02		 				 ; Frame Timer check
	bne SwitchToBank1AndContinue	  
	
	inc objectVertOffset		  ; Increase Scroll/Sink Offset
	
	dec $CE		  
	dec m0VertPos				
	dec snakeDungeonY		  
	dec $CE		  
	dec m0VertPos
	dec snakeDungeonY		  

SwitchToBank1AndContinue:
	lda #<JumpToScreenHandlerFromBank1						; Load low byte of destination routine in Bank 1
	sta bankSwitchJMPAddr
	lda #>JumpToScreenHandlerFromBank1						; Load high byte of destination
	sta bankSwitchJMPAddr + 1
	jmp JumpToBank1					; Perform the bank switch and jump to new code
	
SetupScreenVisualsAndObjects:
	lda screenInitFlag		  ; Check status flag (likely screen initialization)
	beq SetScreenControlsAndColor	  ; If zero, skip subroutine
	jsr	 UpdateRoomEventState	  ; Run special screen setup routine (e.g., reset state or clear screen)
	lda #$00		  ; Clear the flag afterward
SetScreenControlsAndColor:
	sta screenInitFlag		  ; Store the updated flag
	ldx currentRoomId				; get the current screen id
	lda HMOVETable,x				
	sta NUSIZ0						; Set object sizing/horizontal motion control
	lda  playfieldControlFlags
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
	sta snakeDungeonState							; Possibly enemy counter, timer, or position marker
	ldx #4
SetupThievesDenObjects:
	; --------------------------------------------------------------------------
	; INITIALIZE THIEVES POSITIONS
	; Uses a lookup table to set initial HMOVE values for 5 thieves.
	; --------------------------------------------------------------------------
	ldy thiefHmoveIndices,x			; Get index.
	lda HMOVETable,y				; Load visual position from table.
	sta thiefHorizPositions,x		; Store.
	dex								; Next thief.
	bpl SetupThievesDenObjects		; Loop through all Thieves' Den enemy positions

.HorizontallyPositionObjects
	jmp HorizontallyPositionObjects
	
.SetArkRoomInitialPositions
	lda #$4D		  ; Set Indy's horizontal position in the Ark Room
	sta indyHorizPos			;3
	lda #$48		  ;2
	sta p0HorizPos		  ; Unknown, likely related to screen offset or trigger state
	lda #$1F		  ;2
	sta indyVertPos		  ; Set Indy's vertical position in the Ark Room
	rts			  ; Return from subroutine

ClearGameStateMemory:
	ldx #$00		  ; Start at index 0
	txa			  ; A = 0 (will be used to clear memory)
WriteToStateMemoryLoop:
	sta objectVertOffset,x		; Clear/reset memory at objectVertOffset$E4
	sta p0GfxData,x	  
	sta p0TiaPtrs,x	  
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
;
; Initialize the screen state, loading graphics, setting positions, and resetting flags.
; This is called when entering a new room or restarting a room.
;
	lda grenadeState		   ; Load grenade/parachute state.
	bpl ResetRoomFlags	  ; If bit 7 is clear (not active), skip setting the "warped/re-entered" flag.
	ora #$40		  ; Set bit 6 to indicate re-entry or warp status.
	sta grenadeState		   ; Update the state.
ResetRoomFlags:
	lda #$5C		  ; Load default value for digging state (or vertical offset).
	sta diggingState
	ldx #$00		  ; Initialize X to 0 for clearing.
	stx screenEventState		  ; Clear screen event state.
	stx spiderRoomState		  ; Clear spider room state.
	stx m0VertPosShadow		   ; Clear shadow variable for missile 0 vertical position.
	stx $90		  ; Clear unknown flag at $90.
	lda pickupStatusFlags			; Load pickup flags.
	stx pickupStatusFlags 			; Clear pickup flags (resetting temporary room pickups).
	jsr	 UpdateRoomEventState	  ; Call subroutine to update room event counters/offsets.
	rol playerInputState			; Rotate input flags  possibly to mask off an "item use" bit
	clc			  ;2
	ror playerInputState					 ; Reverse the bit rotation; keeps input state consistent
	ldx currentRoomId				; Load the current room ID into X.
	lda PlayfieldControlTable,x
	sta  playfieldControlFlags				 ; Set playfield control flags (reflection, priority) based on table.
	cpx #ID_ARK_ROOM
	beq .SetArkRoomInitialPositions			; If Ark Room, jump to special setup.
	cpx #ID_MESA_SIDE
	beq LoadPlayerGraphicsForRoom			; If Mesa Side, skip clearing temp pos and go to load graphics.
	cpx #ID_WELL_OF_SOULS
	beq LoadPlayerGraphicsForRoom			; If Well of Souls, skip clearing temp pos and go to load graphics.
	lda #$00
	sta arkImpactRegionId								; Clear temporary horizontal position flag for other rooms.
LoadPlayerGraphicsForRoom:
	lda RoomPlayer0LSBGraphicData,x	  ;4
	sta p0GfxPtrs					; Set low byte of sprite pointer for P0 (non-Indy)
	lda RoomPlayer0MSBGraphicData,x	  ;4
	sta p0GfxPtrs + 1				; Set high byte of sprite pointer for P0
	lda RoomPlayer0Height,x	  ; Load height of P0 sprite.
	sta p0SpriteHeight
	lda RoomTypeTable,x	  ; Load room type / object configuration data.
	sta p0HorizPos		  							; Store for P0 horizontal position or type.
	lda Roomm0VertPosTable,x	  ; Load initial horizontal position for Missile 0 (or object).
	sta m0HorizPos
	lda RoomMissile0InitVertPosTable,x	  ; Load initial vertical position for Missile 0.
	sta m0VertPos
	cpx #ID_THIEVES_DEN
	bcs ClearGameStateMemory	   ; If room ID >= Thieves Den, jump to clear game state memory.
	adc RoomSpecialBehaviorTable,x	  ; Add special behavior offset (A likely held something relevant).
	sta p0GfxData		  ; Store result in P0 graphics data / state.
	lda RoomPF1GraphicLSBTable,x	  ; Load PF1 graphics pointer LSB.
	sta pf1GfxPtrs
	lda RoomPF1GraphicMSBTable,x	  ; Load PF1 graphics pointer MSB.
	sta pf1GfxPtrs + 1
	lda RoomPF2GraphicLSBTable,x	  ; Load PF2 graphics pointer LSB.
	sta pf2GfxPtrs
	lda RoomPF2GraphicMSBTable,x	  ; Load PF2 graphics pointer MSB.
	sta pf2GfxPtrs + 1
	lda #$55		  ; Load default value ($55).
	sta snakeDungeonY		  ; Initialize snake/dungeon vertical parameter.
	sta weaponVertPos			; Reset weapon vertical position.
	cpx #ID_TEMPLE_ENTRANCE
	bcs InitializeTempleAndShiningLightRooms	  							; If Temple Entrance or later, jump to specific initialization.
	lda #$00		 						; Load 0.
	cpx #ID_TREASURE_ROOM
	beq .setTreasureRoomObjectVertPos	; Special setup for Treasure Room.
	cpx #ID_ENTRANCE_ROOM
	beq .setEntranceRoomTopObjectVertPos	; Special setup for Entrance Room.
	sta $CE		  ; Clear $CE (vertical position default).
FinalizeScreenInitialization:
	ldy #$4F		 ; Load default vertical offset ($4F).
	cpx #ID_ENTRANCE_ROOM
	bcc FinishScreenInitAndReturn	   ; If ID < Entrance Room (Treasure/Marketplace), keep default and return.
	lda treasureIndex,x	  ; Load treasure index / control byte.
	ror			   ; Rotate bit 0 into carry.
	bcc FinishScreenInitAndReturn	  ; If carry clear, use default offset and return.
	ldy RoomObjectVertOffsetTable,x	  ; Load room-specific vertical offset.
	cpx #ID_BLACK_MARKET
	bne FinishScreenInitAndReturn	   ; If not Black Market, use loaded offset and return.
	lda #$FF		  ; Load $FF.
	sta m0VertPos					; Hide Missile 0 (off-screen).
FinishScreenInitAndReturn:
	sty objectVertOffset		  					 ; Store the final vertical object/environment offset.
	rts			  						 ; Return from subroutine.

.setTreasureRoomObjectVertPos
	lda treasureIndex		   ; Load screen control byte
	and #$78		  ; Mask off all but bits 36 (preserve mid flags, clear others)
	sta treasureIndex		  ; Save the updated control state
	lda #$1A		
	sta p0VertPos			 ; Set vertical position for the top object
	lda #$26		  ;2
	sta objectVertOffset			 ; Set vertical position for the bottom object
	rts			   ; Return 
	
.setEntranceRoomTopObjectVertPos
	lda entranceRoomState
	and #7
	lsr								; shift value right
	bne SetEntranceRoomTopObjectPosition						; branch if wall opening present in Entrance Room
	ldy #$FF		  ;2
	sty m0VertPos
SetEntranceRoomTopObjectPosition:
	tay												; Transfer A (index) to Y
	lda EntranceRoomTopObjectVertPos,y				; Look up Y-position for Entrance Room's top object
	sta p0VertPos							; Set the object's vertical position
	jmp FinalizeScreenInitialization				; Continue the screen setup process
	
InitializeTempleAndShiningLightRooms:
	cpx #ID_ROOM_OF_SHINING_LIGHT				; Check if current room is "Room of Shining Light"
	beq InitRoomOfShiningLight	  								; If so, jump to its specific init routine
	cpx #ID_TEMPLE_ENTRANCE						; If not, is it the Temple Entrance?
	bne InitMesaFieldSinkingState									; If neither, skip this routine
	ldy #$00		  ;2
	sty timepieceSpriteDataPtr										; Clear some dungeon-related state variable
	ldy #$40		  ;2
	sty topOfDungeonGfx						 ; Set visual reference for top-of-dungeon graphics
	bne ConfigureTempleOrShiningLightGraphics	   								;Always taken
	
InitRoomOfShiningLight:
	ldy #$FF		  ;2
	sty topOfDungeonGfx						; Top of dungeon should render with full brightness/effect
	iny								; y = 0
	sty timepieceSpriteDataPtr										; Possibly clear temple or environmental state
	iny								; y = 1
ConfigureTempleOrShiningLightGraphics:
	sty dungeonGfxData + 1						; Set dungeon tiles to base values
	sty dungeonGfxData + 2
	sty dungeonGfxData + 3
	sty dungeonGfxData + 4
	sty dungeonGfxData + 5
	ldy #$39		  ;2
	sty snakeDungeonState										; Likely a counter or timer
	sty snakeVertPos							; Set snake enemy Y-position baseline
InitMesaFieldSinkingState:
	cpx #ID_MESA_FIELD
	bne ReturnFromRoomSpecificInit 				; If not Mesa Field, skip
	ldy indyVertPos					; get Indy's vertical position
	cpy #$49		  
	bcc ReturnFromRoomSpecificInit 	   ; If Indy is "Above" the quicksand/sink line ($49), Initialize with 0 Offset.
	lda #$50		  
	sta objectVertOffset		  ; Initialize to Sinking Bottom? or Start Depth?
	rts			  ; return

ReturnFromRoomSpecificInit:
	lda #$00		 
	sta objectVertOffset		  ; Clear Sink/Scroll Offset (Solid Ground/Normal Rooms)
	rts			  ; Return to caller (completes screen init)

CheckRoomOverrideCondition:
	ldy RoomOverrideKeyTable,x	  ; Load room override index based on current screen ID
	cpy $86		  ; Compare with current override key or control flag
	beq ApplyRoomOverridesIfMatched	  ; If it matches, apply special overrides
	clc			   ; Clear carry (no override occurred)
	clv			  ; Clear overflow (in case its used for flag-based branching)
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

	bpl CheckVerticalOverride        ; Always taken  go check vertical override normally
	
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
	bit treasureIndex                          ; Check room flag register
	bpl CheckVerticalOverride        ; If bit 7 is clear, proceed

	lda #$41
	bne ApplyVerticalOverride        ; Always taken  apply forced vertical position
	
ConditionalOverrideBasedOnB5_0:
	iny			  ;2
	bne ConditionalOverrideIfB5LessThan0A	  ; Always taken unless overflowed
	lda entranceRoomEventState		  ;3
	and #$0F		  ; Mask to lower nibble
	bne ReturnNoOverrideWithSideEffect	  ; If any bits set, don't override
	ldy #$06		  ;2
	bne CheckVerticalOverride						 ; Always taken
	
ConditionalOverrideIfB5LessThan0A:
	iny			  ;2
	bne CheckInputForFinalOverride	  ; Continue check chain
	lda entranceRoomEventState		  ;3
	and #$0F		  ;2
	cmp #$0A		  ;2
	bcs ReturnNoOverrideWithSideEffect	  ;2
	ldy #$06		  ;2
	bne CheckVerticalOverride						; Always taken
	
CheckInputForFinalOverride:
	iny			  ;2
	bne CheckHeadOfRaAlignment	  ; Continue to final check
	ldy #$01		  ;2
	bit playerInputState
	bmi CheckVerticalOverride	  ; If fire button pressed, allow override
	
ReturnNoOverrideWithSideEffect:
	clc			  ; Clear carry to signal no override
	bit	 NoOpRTS 	  ; Dummy BIT used for timing/padding
NoOpRTS:							; No-op subroutine  acts as placeholder or execution pad
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
	ldy inventoryItemCount		; get number of inventory items
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
	cmp inventoryGfxPtrs,x	; Compare target LSB value to current inventory slot
	bne .checkNextItem				; If not a match, try the next slot
	cpx selectedInventorySlot
	beq .checkNextItem
	dec inventoryItemCount		; reduce number of inventory items
	lda #<EmptySprite
	sta inventoryGfxPtrs,x	; place empty sprite in inventory
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
	clc									; Clear carry  no matching item was found/removed
	rts									; Return (nothing removed)

.takeSelectedItemFromInventory
	lda #ID_INVENTORY_EMPTY
	ldx selectedInventorySlot
	sta inventoryGfxPtrs,x	; remove selected item from inventory (Clear slot pointer to 0)
	ldx selectedInventoryId			; get current selected inventory id
	cpx #ID_INVENTORY_KEY
	bcc JumpToItemRemovalHandler	  ; If ID < Key (e.g., Flute, Coins), jump to handler
	jsr ShowItemAsNotTaken      ; Else, mark as "Not Taken" so it respawns in original room
JumpToItemRemovalHandler:
	txa								; move inventory id to accumulator
	tay								; move inventory id to y
	asl								; multiple inventory id by 2
	tax
	lda RemoveItemFromInventoryJumpTable - 1,x ; Load specific drop handler High Byte
	pha								; push MSB to stack
	lda RemoveItemFromInventoryJumpTable - 2,x ; Load specific drop handler Low Byte
	pha								; push LSB to stack
	ldx currentRoomId				; get the current screen id
	rts								; jump to Remove Item strategy (via RTS trick)

RemoveParachuteFromInventory
	lda #$3F		  ; Mask to clear bit 6 (parachute active flag)
	and mesaSideState		  ; Remove parachute bit from game state flags
	sta mesaSideState		  ; Store updated flags
FinalizeItemRemoval:
	jmp RemoveItemFromInventory		; Go to general item removal cleanup
	
RemoveAnkhOrHourGlassFromInventory
	stx eventState	   ; Store current screen ID (context-specific logic: Mesa Field Check?)
	lda #$70		  ; Set vertical position offscreen or special
	sta weaponVertPos			; Move bullet/whip Y position (could represent effect trigger)
	bne FinalizeItemRemoval			; Unconditional jump to finalize removal
	
RemoveChaiFromInventory:
	; --------------------------------------------------------------------------
	; CHAI DROP HANDLER
	; The Chai is part of the "Yar's Revenge" Easter Egg.
	; If dropped with a specific movement vector ($42), it triggers a warp and bonuses.
	; --------------------------------------------------------------------------
	lda #$42						; Check for specific movement direction command.
									; This value ($42) is set in the Marketplace when Indy
									; hits the invisible "Stalls" at the top (Y >= $09).
	cmp movementDirection			; Check if player is pushing against that boundary?
	bne checkMarketplaceYarEasterEgg; If not $42, skip the main warp.
	
	; --------------------------------------------------------------------------
	; MARKETPLACE / BLACK MARKET WARP
	; If the $42 condition is met, Indy is warped to the Black Market.
	; --------------------------------------------------------------------------
	lda #ID_BLACK_MARKET			; Load Black Market ID.
	sta currentRoomId				; Change Room.
	jsr InitializeScreenState		; Init Screen.
	lda #$15						; Set Indy X (Entrance).
	sta indyHorizPos				
	lda #$1C						; Set Indy Y.
	sta indyVertPos		  
	bne RemoveItemFromInventory		; Always branch to cleanup (remove Chai).
	
checkMarketplaceYarEasterEgg:
	; --------------------------------------------------------------------------
	; YAR'S REVENGE EASTER EGG
	; Trigger: Dropping the Chai in the Black Market while "flying"?
	; Or perhaps checkMarketplaceYarEasterEgg suggests this runs IN the Marketplace?
	; Actually the code below checks if we are removing a *Grenade*, not Chai?
	; But the label says RemoveChaiFromInventory falls through to here.
	;
	; Wait, the `bne checkMarketplaceYarEasterEgg` above jumps here if NOT $42.
	; But if we are dropping Chai, X contains ID_INVENTORY_CHAI.
	; --------------------------------------------------------------------------
	cpx #ID_MARKETPLACE_GRENADE		; Are we removing a Grenade?
	bne RemoveItemFromInventory		; If NOT Grenade (e.g. it IS Chai), exit and just remove item.
	
	; Note: This block seems to be labeled confusingly or acts as a shared handler.
	; If we successfully drop a Grenade here, we check for the Yar Bonus.
	lda #BONUS_FINDING_YAR			
	cmp arkImpactRegionId	  		; Check if Bonus already awarded?
	bne RemoveItemFromInventory		
	
	; Award Yar Bonus
	sta yarEasterEggBonus
	lda #$00		  
	sta $CE		  					; Clear sprite?
	lda #$02		  
	ora mesaSideState				; Set Mesa Side State Bit 1?
	sta mesaSideState		  
	bne RemoveItemFromInventory		; Exit.
	
RemoveWhipFromInventory
	ror entranceRoomState			; rotate entrance room state right
	clc								; clear carry
	rol entranceRoomState			; rotate left to show Whip not taken by Indy (Restore State)
	cpx #ID_ENTRANCE_ROOM
	bne .removeWhipFromInventory    ; If not in Entrance Room, done
	lda #78
	sta whipVertPos                 ; Reset Whip position on the Rock
.removeWhipFromInventory
	bne RemoveItemFromInventory		; unconditional branch
	
RemoveShovelFromInventory
	ror blackMarketState				; Clear lowest bit to indicate Indy is no longer carrying the shovel
	clc								 ; Clear carry (ensures bit 7 won't be set on next instruction)
	rol blackMarketState				; Restore original order of bits with bit 0 cleared
	cpx #ID_BLACK_MARKET				; Is Indy currently in the Black Market?
	bne .removeShovelFromInventory		; If not, skip visual update
	; Indy is in Black Market  reset visual positions of the shovel and missile
	lda #$4F
	sta shovelVertPos               ; Reset Shovel position
	lda #$4B
	sta m0VertPos
.removeShovelFromInventory
	bne RemoveItemFromInventory		; Unconditionally jump to finalize item removal
	
RemoveCoinsFromInventory
	ldx currentRoomId				; get the current screen id
	cpx #ID_BLACK_MARKET
	bne FinalizeCoinRemovalFlags						; branch if not in Black Market
	lda indyHorizPos					; get Indy's horizontal position
	cmp #$3C		  ; Check if Indy is on the Left side (Sheik/Merchant area)
	bcs FinalizeCoinRemovalFlags
	rol blackMarketState				; rotate Black Market state left
	sec								; set carry (Successful Purchase)
	ror blackMarketState				; rotate right to show Indy not carry coins (Update Merchant State)
FinalizeCoinRemovalFlags:
	lda movementDirection		  ;3
	clc			  ;2
	adc #$40		  ; Update UI/event state (Trigger Purchase effect?)
	sta movementDirection		  ;3
RemoveItemFromInventory
	dec inventoryItemCount		; reduce number of inventory items
	bne .selectNextAvailableInventoryItem; branch if Indy has remaining items
	lda #ID_INVENTORY_EMPTY
	sta selectedInventoryId			; clear the current selected invendory id
	beq FinalizeInventorySelection						; unconditional branch
	
.selectNextAvailableInventoryItem
	ldx selectedInventorySlot		; get selected inventory index
.nextInventoryIndex
	inx								; increment by 2 to compensate for word pointer
	inx
	cpx #11
	bcc SelectNextInventoryItem
	ldx #0							; wrap around to the beginning
SelectNextInventoryItem:
	lda inventoryGfxPtrs,x	; get inventory graphic LSB value
	beq .nextInventoryIndex			; branch if nothing in the inventory location
	stx selectedInventorySlot		; set inventory index
	lsr								; divide valye by 8 to set the inventory id
	lsr
	lsr
	sta selectedInventoryId			; set inventory id
FinalizeInventorySelection:
	lda #$0D		  ; Possibly sets UI state or inventory mode
	sta soundChan0_IndyState		  ;3
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
	
Roomm0VertPosTable:
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
	.word RemoveItemFromInventory - 1           ; ID 0: Empty/Default
	.word RemoveItemFromInventory - 1           ; ID 1: Copyright (Shown at Start Screen)
	.word RemoveItemFromInventory - 1           ; ID 2: Flute (Generic Drop)
	.word RemoveParachuteFromInventory - 1      ; ID 3: Parachute (Clear mesaSideState bit)
	.word RemoveCoinsFromInventory - 1          ; ID 4: Coins (Check Black Market Purchase)
	.word RemoveItemFromInventory - 1           ; ID 5: Marketplace Grenade
	.word RemoveItemFromInventory - 1           ; ID 6: Black Market Grenade
	.word RemoveItemFromInventory - 1           ; ID 7: Key
	.word RemoveItemFromInventory - 1           ; ID 8: Ark (Unused in Inventory)
	.word RemoveItemFromInventory - 1           ; ID 9: Copyright (Shown at Start Screen)
	.word RemoveWhipFromInventory - 1           ; ID 10: Whip (Restore to Entrance Room Rock)
	.word RemoveShovelFromInventory - 1         ; ID 11: Shovel (Restore to Black Market)
	.word RemoveItemFromInventory - 1           ; ID 12: Copyright (Shown at Start Screen)
	.word RemoveItemFromInventory - 1           ; ID 13: Revolver
	.word RemoveItemFromInventory - 1           ; ID 14: Head of Ra
	.word RemoveItemFromInventory - 1           ; ID 15: Time Piece
	.word RemoveAnkhOrHourGlassFromInventory - 1; ID 16: Ankh
	.word RemoveChaiFromInventory - 1           ; ID 17: Chai (Yar's Revenge Check)
	.word RemoveAnkhOrHourGlassFromInventory - 1; ID 18: Hourglass
	
PlayerCollisionJumpTable
	.word ScreenLogicDispatcher - 1
	.word PlayerCollisionsInMarketplace - 1
	.word PlayerCollisionsInEntranceRoom - 1
	.word PlayerCollisionsInBlackMarket - 1
	.word ScreenLogicDispatcher - 1
	.word PlayerCollisionsInMesaSide - 1
	.word PlayerCollisionsInTempleEntrance - 1
	.word PlayerCollisionsInSpiderRoom - 1
	.word PlayerCollisionsInRoomOfShiningLight - 1
	.word ScreenLogicDispatcher - 1
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
	.word StandardRoomIdleHandler - 1			; Treasure Room
	.word StandardRoomIdleHandler - 1			; Marketplace
	.word IndyPlayfieldCollisionInEntranceRoom - 1	; Entrance Room
	.word StandardRoomIdleHandler - 1			; Black Market
	.word StandardRoomIdleHandler - 1			; Map Room
	.word MoveIndyBasedOnInput - 1					; Mesa Side
	.word RestrictIndyMovementInTemple - 1			; Temple Entrance
	.word MoveIndyBasedOnInput - 1					; Spider Room
	.word PlayerCollisionsInRoomOfShiningLight - 1	; Room of Shining Light
	.word StandardRoomIdleHandler - 1			; Mesa Field
	.word SlowDownIndyMovement - 1					; Valley of Poison
	.word StandardRoomIdleHandler - 1			; Thieves Den
	.word StandardRoomIdleHandler - 1			; Well of Souls

RoomIdleHandlerJumpTable:
	.word StandardRoomIdleHandler - 1
	.word StandardRoomIdleHandler - 1
	.word SetIndyToTriggeredState - 1
	.word StandardRoomIdleHandler - 1
	.word InitFallbackEntryPosition - 1
	.word StandardRoomIdleHandler - 1
	.word StandardRoomIdleHandler - 1
	.word StandardRoomIdleHandler - 1
	.word StandardRoomIdleHandler - 1
	.word WarpToMesaSide - 1
	.word SetIndyToTriggeredState - 1
	.word StandardRoomIdleHandler - 1
	.word StandardRoomIdleHandler - 1
	
PlaceItemInInventory
	ldx inventoryItemCount		; get number of inventory items
	cpx #MAX_INVENTORY_ITEMS			; see if Indy carrying maximum number of items (6)
	bcc .spaceAvailableForItem		; branch if Indy has room to carry more items
	clc
	rts

.spaceAvailableForItem
	ldx #10             ; Start at the last inventory slot (Index 10, since 6 items * 2 bytes = 12 bytes total, 0-10)
.searchForEmptySpaceLoop
	ldy inventoryGfxPtrs,x	; get the LSB for the inventory graphic (LSB = 0 implies Empty)
	beq .addInventoryItem		; branch if nothing is in the inventory slot
	dex
	dex                 ; Move to the previous slot (2-byte stride)
	bpl .searchForEmptySpaceLoop
	brk								; break if no more items can be carried (Should not happen if ItemCount < Max)
.addInventoryItem
	tay								; move item number to y
	asl								; mutliply item number by 8 for graphic LSB (Bit 0-2 represent offset in sprite table)
	asl
	asl
	sta inventoryGfxPtrs,x	; place graphic LSB in inventory
	lda inventoryItemCount		; get number of inventory items
	bne UpdateInventoryAfterPickup						; branch if Indy carrying items
	stx selectedInventorySlot		; set index to newly picked up item (Auto-select first item)
	sty selectedInventoryId			; set the current selected inventory id
UpdateInventoryAfterPickup:
	inc inventoryItemCount		; increment number of inventory items
	cpy #ID_INVENTORY_COINS
	bcc FinalizeInventoryAddition	  ; If ID < Coins (e.g., Flute, Parachute), skip marking as "Taken"
	tya								; move item number to accumulator
	tax								; move item number to x
	jsr ShowItemAsTaken         ; Mark item as taken in global bitmasks (Basket or Pickup)
FinalizeInventoryAddition:
	lda #$0C
	sta soundChan0_IndyState               ; Set Indy state to 0C (Item Pickup Animation/State)
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
	lda roomEventStateOffset		  ;3
	cpx #$0C		  ;2
	bcs .doneUpdateRoomEventState	  ;2
	adc RoomEventStateOffsetTable,x	  ;4
	sta roomEventStateOffset		  ;3
.doneUpdateRoomEventState:
	rts			  ;6
	
startGame
;
; Set up everything so the power up state is known.
;
	sei								; Disable interrupts to ensure atomic initialization.
	cld								; Clear decimal mode, as all arithmetic is binary.
	ldx #$FF						; Load X with $FF.
	txs								; Transfer X to the stack pointer, initializing it to $01FF.
	inx								; X becomes 0.
	txa								; A becomes 0.
.clearLoop
	sta VSYNC,x						; Clear TIA registers by writing 0 from address $00 to $FF.
	dex								; Decrement X.
	bne .clearLoop					; Loop until all 256 bytes are cleared.
	dex								; X becomes -1 ($FF).
	stx adventurePoints				; Initialize adventurePoints to -1.
	
	; -------------------------------------------------------------------------
	; INITIALIZE INVENTORY WITH COPYRIGHT
	;
	; The game displays the Copyright Notice ("(c) 1982 Atari Inc") inside the 
	; Inventory Strip at the very beginning of the game or after a reset.
	; It manually populates the `inventoryGfxPtrs` with the Copyright_X sprites.
	; -------------------------------------------------------------------------
	lda #>InventorySprites			; Load the high byte of the InventorySprites address.
	sta inventoryGfxPtrs + 1		; Set the high byte for all inventory sprite pointers.
	sta inventoryGfxPtrs + 3
	sta inventoryGfxPtrs + 5
	sta inventoryGfxPtrs + 7
	sta inventoryGfxPtrs + 9
	sta inventoryGfxPtrs + 11
	
	lda #<Copyright_0				; Load the low byte of the first copyright line sprite.
	sta inventoryGfxPtrs			; Set the first inventory slot to display it.
	lda #<Copyright_1				; Load the low byte of the second copyright line sprite.
	sta inventoryGfxPtrs + 2		; Set the second inventory slot.
	lda #<Copyright_2
	sta inventoryGfxPtrs + 6
	lda #<Copyright_3
	sta inventoryGfxPtrs + 4
	lda #<Copyright_4
	sta inventoryGfxPtrs + 8
	
	lda #ID_ARK_ROOM				; Load the Ark Room ID.
	sta currentRoomId				; Set the starting room to the Ark Room.
	lsr								; A = ID_ARK_ROOM / 2.
	sta bulletCount					; Initialize bulletCount.
	jsr InitializeScreenState		; Initialize various screen and game state variables.
	jmp StartNewFrame				; Jump to the main game loop.
	
InitializeGameStartState:
	lda #<InventoryCoinsSprite
	sta inventoryGfxPtrs		; place coins in Indy's inventory
	lsr								; divide value by 8 to get the inventory id
	lsr
	lsr
	sta selectedInventoryId			; set the current selected inventory id
	inc inventoryItemCount		; increment number of inventory items
	lda #<EmptySprite
	sta inventoryGfxPtrs + 2 ; clear the remainder of Indy's inventory
	sta inventoryGfxPtrs + 4
	sta inventoryGfxPtrs + 6
	sta inventoryGfxPtrs + 8
	lda #INIT_SCORE
	sta adventurePoints
	lda #<IndyStationarySprite
	sta indyGfxPtrs
	lda #>IndySprites
	sta indyGfxPtrs + 1
	lda #$4C		  ;2
	sta indyHorizPos			;3
	lda #$0F		  ;2
	sta indyVertPos		  ;3
	lda #ID_ENTRANCE_ROOM
	sta currentRoomId
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
	sbc yarEasterEggBonus		; reduce if player found Yar
	sbc lives						; reduce by remaining lives
	sbc headOfRaMapRoomBonus	; reduce if player used the Head of Ra
	sbc landingInMesaBonus			; reduce if player landed in Mesa
	sbc unusedScoreAdjustment		  
	clc
	adc grenadeOpeningPenalty		; add 2 if Entrance Room opening activated
	adc shiningLightPenalty	; add 13 if escaped from Shining Light prison
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
	sta bankSwitchJMPAddr
	lda #>DisplayKernel
	sta bankSwitchJMPAddr + 1
JumpToBank1
	lda #LDA_ABS
	sta bankSwitchLDAOpcode
	lda #<BANK1STROBE
	sta bankSwitchAddr
	lda #>BANK1STROBE
	sta bankSwitchAddr + 1
	lda #JMP_ABS
	sta bankSwitchJMPOpcode
	jmp.w bankSwitchVars
	
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
	  .word startGame
	  .word startGame
	  .word startGame
	  
;============================================================================
; R O M - C O D E  (BANK 1)
;============================================================================

	SEG Bank1
	.org BANK1TOP
	.rorg BANK1_REORG

BANK1Start	 
	lda BANK0STROBE
	
DrawPlayfieldKernel
;
; This kernel loop draws the main playfield area.
; It handles walls, background graphics, and player sprites.
;
	cmp p0GfxData					; Check against graphics data/state.
	bcs DungeonWallScanlineHandler	; Branch if carry set.
	lsr								; Divide by 2.
	clc								; Clear carry.
	adc objectVertOffset			; Add vertical offset.
	tay								; Transfer to Y index.
	sta WSYNC						; Wait for Horizontal Sync.
;--------------------------------------
	sta HMOVE						; Apply horizontal motion.
	lda (pf1GfxPtrs),y				; Load PF1 graphics data.
	sta PF1							; Store in PF1.
	lda (pf2GfxPtrs),y				; Load PF2 graphics data.
	sta PF2							; Store in PF2.
	bcc .drawPlayerSprites			; Branch to draw player sprites.

DungeonWallScanlineHandler:
	sbc snakeDungeonState			; Adjust for snake/dungeon state.
	lsr								; Divide by 4.
	lsr
	sta WSYNC						; Wait for Horizontal Sync.
;--------------------------------------
	sta HMOVE						; Apply horizontal motion.
	tax								; Transfer A to X.
	cpx snakeVertPos				; Compare with Snake vertical position.
	bcc DrawDungeonWallScanline		; Branch if X < Snake Pos.
	ldx timepieceSpriteDataPtr		; Load Timepiece sprite data pointer.
	lda #$00						; Load 0.
	beq StoreDungeonWallScanline	; Unconditional branch to store 0.

DrawDungeonWallScanline:
	lda dungeonGfxData,x			; Load dungeon graphics data.
	ldx timepieceSpriteDataPtr		; Restore X.
StoreDungeonWallScanline:
	sta PF1,x						; Store graphics (or 0) to PF1 (using X as index or offset).
.drawPlayerSprites
	ldx #<ENAM1						; Load address of ENAM1 (or related value).
	txs								; Set Stack Pointer (used for timing or special stack trick).
	lda scanlineCounter				; Load current scanline.
	sec								; Set carry.
	sbc indyVertPos					; Subtract Indy's vertical position.
	cmp indySpriteHeight			; Compare with Indy's height.
	bcs .skipIndyDraw				; Skip if outside drawing range.
	tay								; Transfer index to Y.
	lda (indyGfxPtrs),y				; Load Indy graphics.
	tax								; Transfer to X.

DrawPlayer0Sprite:
	lda scanlineCounter				; Reload scanline.
	sec								; Set carry.
	sbc p0VertPos					; Subtract Player 0 vertical position.
	cmp p0SpriteHeight				; Compare with P0 height.
	bcs .skipDrawingPlayer0			; Skip if outside drawing range.
	tay								; Transfer index to Y.
	lda (p0GfxPtrs),y				; Load P0 graphics.
	tay								; Transfer to Y.

.nextPlayfieldScanline
	lda scanlineCounter				; Reload scanline.
	sta WSYNC						; Wait for Horizontal Sync.
;--------------------------------------
	sta HMOVE						; Apply horizontal motion.
	cmp weaponVertPos				; Check weapon (M1) vertical position.
	php								; Push status (Timing/Enable logic).
	cmp m0VertPos					; Check missile 0 (M0) vertical position.
	php								; Push status (Timing/Enable logic).
	stx GRP1						; Update GRP1 (Indy graphics).
	sty GRP0						; Update GRP0 (P0 graphics).
	sec								; Set carry.
	sbc snakeDungeonY				; Adjust for object Y.
	cmp #$08						; Check height range.
	bcs AdvanceToNextPlayfieldScanline ; Skip if outside range.
	tay								; Transfer to Y.
	lda (timepieceGfxPtrs),y		; Load timepiece graphics.
	sta ENABL						; Enable/Disable Ball.
	sta HMBL						; Set Horizontal Motion for Ball.

AdvanceToNextPlayfieldScanline:
	inc scanlineCounter				; Increment scanline counter.
	lda scanlineCounter
	cmp #(H_KERNEL / 2)				; Check if reached half kernel height.
	bcc DrawPlayfieldKernel			; Loop if not done.
	jmp InventoryKernel				; Jump to Inventory Kernel.

.skipIndyDraw
	ldx #0							; Load 0.
	beq DrawPlayer0Sprite			; Proceed to check Player 0.

.skipDrawingPlayer0
	ldy #0							; Load 0.
	beq .nextPlayfieldScanline		; Proceed to next scanline.
	
DrawStationaryPlayerKernel SUBROUTINE
;
; This kernel is used when the player is stationary (or fewer sprites moving).
; Optimizes TIA updates.
;
.checkToEndKernel
	cpx #(H_KERNEL / 2) - 1			; Check if kernel scanlines complete.
	bcc .skipDrawingPlayer0			; If not done, skip drawing player 0.
	jmp InventoryKernel				; Jump to Inventory Kernel.
	
.skipDrawingPlayer0
	lda #0							; Load 0.
	beq .nextStationaryPlayerScanline; Unconditional branch.
	
DrawStationaryPlayer0Sprite:
	lda (p0GfxPtrs),y				; Load P0 graphics.
	bmi .setPlayer0Values			; If negative (special flag bit 7 set?), jump to setting values.
	cpy objectVertOffset			; Compare Y with offset.
	bcs .checkToEndKernel			; Branch if greater or equal.
	cpy p0VertPos					; Compare Y with P0 vertical position.
	bcc .skipDrawingPlayer0			; Skip if below.
	sta GRP0						; Store to GRP0.
	bcs .nextStationaryPlayerScanline; Unconditional branch.

.setPlayer0Values
	asl								; Shift left.
	tay								; Transfer to Y.
	and #2							; Mask bit 1.
	tax								; Transfer to X.
	tya								; Transfer to A.
	sta (p0TiaPtrs,x)				; Store to TIA pointer address.

.nextStationaryPlayerScanline
	inc scanlineCounter				; Increment scanline counter.
	ldx scanlineCounter				; Load to X.
	lda #ENABLE_BM					; Load Enable Missile mask value.
	cpx m0VertPos					; Compare with M0 position.
	bcc .skipDrawingMissile0		; Branch if not reached.
	cpx p0GfxData					; Compare with P0 Graphics Data.
	bcc .setEnableMissileValue		; Enable missile.
.skipDrawingMissile0
	ror								; Rotate right.
.setEnableMissileValue
	sta ENAM0						; Store to ENAM0.
JumpIntoStationaryPlayerKernel
	sta WSYNC
;--------------------------------------
	sta HMOVE						; Execute horizontal move.
	txa								; Move scanline count to A.
	sec								; Set carry for subtraction.
	sbc snakeVertPos				; Subtract Snake vertical position.
	cmp #16							; Compare with 16.
	bcs .waste19Cycles				; Branch if snake not active here.
	tay								; Transfer to Y.
	cmp #8							; Compare with 8.
	bcc .waste05Cycles				; Branch if < 8.
	lda timepieceSpriteDataPtr		; Load pointer to timepiece sprite data.
	sta timepieceGfxPtrs			; Store in graphics pointer.

DrawTimepieceOrBallSprite:
	lda (timepieceGfxPtrs),y		; Load timepiece graphics.
	sta HMBL						; Store in Ball Horizontal Motion check.

SetMissile1EnableForScanline:
	ldy #DISABLE_BM					; Default to disable missile.
	txa								; Move scanlineCounter to A.
	cmp weaponVertPos				; Compare with weapon position.
	bne UpdateMissile1EnableForScanline ; If not weapon pos, skip enable.
	dey								; Enable missile (Y becomes $FF/Enable).

UpdateMissile1EnableForScanline:
	sty ENAM1						; Update Missile 1 Enable.
	sec								; Set carry.
	sbc indyVertPos					; Subtract Indy vertical position.
	cmp indySpriteHeight			; Compare with sprite height.
	bcs SkipDrawingStationaryPlayer1Sprite; Skip if outside sprite.
	tay								; Transfer to Y (sprite index).
	lda (indyGfxPtrs),y				; Load Indy graphics.

DrawStationaryPlayer1Sprite:
	ldy scanlineCounter				; Restore scanline counter to Y.
	sta GRP1						; Store in GRP1.
	sta WSYNC
;--------------------------------------
	sta HMOVE						; Execute HMOVE.
	lda #ENABLE_BM					; Load Enable value.
	cpx snakeDungeonY				; Compare scanline with Snake Y.
	bcc SkipDrawingBall				; Branch if below.
	cpx $DC							; Compare with $DC (End of ball range?).
	bcc SetBallEnableForScanline	; Enable ball.

.skipDrawingBall
	ror								; Rotate right.
	
SetBallEnableForScanline:
	sta ENABL						; Update Ball Enable.
	bcc DrawStationaryPlayer0Sprite	; Unconditional branch back to loop start.
	
SkipDrawingBall:
	bcc .skipDrawingBall			; Unconditional branch.
	
.waste05Cycles
	SLEEP 2							; Burn cycles.
	jmp DrawTimepieceOrBallSprite	; Jump back.
	
.waste19Cycles
	pha								; Burn cycles.
	pla
	pha
	pla
	SLEEP 2
	jmp SetMissile1EnableForScanline; Jump back.
	
SkipDrawingStationaryPlayer1Sprite:
	lda #0							; Load 0 (clear graphics).
	beq DrawStationaryPlayer1Sprite	; Jump back to store 0 in GRP1.
	
AdvanceStationaryKernelScanline:
	inx								; Increment scanline counter.
	sta HMCLR						; Clear horizontal motion.
	cpx #H_KERNEL					; Check limit.
	bcc ThievesDenWellOfSoulsScanlineHandler; Branch if not done.
	jmp InventoryKernel				; Jump to Inventory Kernel.
	
ThievesDenOrWellOfTheSoulsKernel
	sta WSYNC
;--------------------------------------
	sta HMOVE						; Execute HMOVE.
	inx								; Increment scanline counter.
	lda $84							; Load value from temp $84.
	sta GRP0						; Store to GRP0 (Thief/Player 0).
	lda $85							; Load value from temp $85.
	sta COLUP0						; Store to COLUP0.
	txa								; Move scanline to A.
	ldx #<ENABL						; Load address of ENABL ($1F).
	txs								; Set Stack Pointer to $1F.
									; This allows PHP to write to TIA registers via stack mirror $01xx -> $00xx.
	tax								; Move scanline to X.
	lsr								; Divide Scanline by 2.
	cmp snakeDungeonY				; Compare with Ball Y.
	php								; Push Status (Writes P to ENABL @ $1F). If Equal (Z=1), Bit 1 is set -> Enabled.
	cmp weaponVertPos				; Compare with Missile 1 Y.
	php								; Push Status (Writes P to ENAM1 @ $1E).
	cmp m0VertPos					; Compare with Missile 0 Y.
	php								; Push Status (Writes P to ENAM0 @ $1D).
	sec								; Set Carry.
	sbc indyVertPos					; Subtract Indy Y.
	cmp indySpriteHeight			; Compare with Height.
	bcs AdvanceStationaryKernelScanline; If outside (Carry Set), branch back.
	tay								; Use result as Y index.
	lda (indyGfxPtrs),y				; Load Indy graphics.
	sta HMCLR						; Clear horizontal motion.
	inx								; Increment scanline.
	sta GRP1						; Store Indy graphics.

ThievesDenWellOfSoulsScanlineHandler:
	sta WSYNC
;--------------------------------------
	sta HMOVE						; Execute HMOVE.
	bit snakeDungeonState			; Check state flag to determine if we are positioning or drawing/updating.
	bpl ThiefSpriteDrawAndAnimationHandler; If bit 7 is clear, jump to Drawing/Animation Logic.
	
	; --------------------------------------------------------------------------
	; THIEF/SNAKE POSITIONING LOGIC
	; If Bit 7 of snakeDungeonState is SET, we are in the "Positioning" phase.
	; --------------------------------------------------------------------------
	ldy thiefHorizPosFine			; Load Fine position timing value (calculated earlier).
	lda thiefHorizPosCoarse			; Load Coarse position value (HMOVE).
	lsr snakeDungeonState			; Shift state right (clears Bit 7, moves to next state).

ThiefSpritePositionTimingLoop:
	dey								; Delay loop for horizontal positioning.
	bpl ThiefSpritePositionTimingLoop; Loop until Y < 0.
	sta RESP0						; Strobe Reset Player 0 to set coarse horizontal position.
	sta HMP0						; Set Fine Motion Player 0 (High nibble of A).
	bmi ThievesDenOrWellOfTheSoulsKernel; Unconditional branch (A is neg from Coarse pos).

ThiefSpriteDrawAndAnimationHandler:
	bvc ThiefSpriteStateUpdateHandler; If Bit 6 is clear, jump to State Update logic.

	; --------------------------------------------------------------------------
	; THIEF/SNAKE DRAWING LOGIC
	; If Bit 6 of snakeDungeonState is SET, we are drawing the sprite.
	; --------------------------------------------------------------------------
	txa								; Move current scanline count to A.
	and #$0F						; Mask to lower 4 bits (16 lines per sprite block?).
	tay								; Transfer directly to Y index for graphics.
	lda (p0GfxPtrs),y				; Load P0 Graphics data (Indirect Y).
	sta GRP0						; Store to GRP0 (Draw).
	lda (p0ColorPtrs),y				; Load P0 Color data.
	sta COLUP0						; Store to COLUP0.
	iny								; Next line of sprite data.
	lda (p0GfxPtrs),y				; Look ahead: Load next graphics line.
	sta $84							; Store in temp $84 for next scanline/loop.
	lda (p0ColorPtrs),y				; Look ahead: Load next color line.
	sta $85							; Store in temp $85 for next scanline/loop.
	cpy p0SpriteHeight				; Check if we have drawn the full height of the sprite.
	bcc ReturnToThievesDenKernel	; If Y < Height, continue drawing next line.
	lsr snakeDungeonState			; If done, Shift state right (Clear Bit 6).

ReturnToThievesDenKernel:
	jmp ThievesDenOrWellOfTheSoulsKernel; Jump back to main kernel loop.

ThiefSpriteStateUpdateHandler:
	; --------------------------------------------------------------------------
	; THIEF/SNAKE STATE & ANIMATION SELECTION
	; Determines which thief/snake is active based on scanline height.
	; --------------------------------------------------------------------------
	lda #$20						; Load Bit 5 mask.
	bit snakeDungeonState			; Check Bit 5 of state.
	beq ThiefSpriteAnimationFrameSetup; If Bit 5 clear, proceed to Frame Setup.

	; Calculate which Thief/Snake Index (0-4) based on Scanline
	txa								; Move scanline to A.
	lsr								; Shift right 5 times (Divide by 32).
									; 32 scanlines allocated per thief zone?
	lsr
	lsr
	lsr
	lsr
	bcs ThievesDenOrWellOfTheSoulsKernel; If Carry Set (scanline count odd/high?), skip.
	tay								; Y = Thief Index (0-4).
	sty $87							; Store Index in temp $87.
	lda thiefState,y				; Load State for this Thief.
	sta REFP0						; Set Reflection (Direction).
	sta NUSIZ0						; Set Number/Size (Also likely encoded in state).
	sta $86							; Store State in temp $86.
	bpl LF1A2						; If Bit 7 clear, jump (Standard Thief?).

	; Special "Digging" or inactive state?
	lda diggingState				; Load digging state.
	sta p0GfxPtrs					; Update pointers.
	lda #$65						; Load Color.
	sta p0ColorPtrs					; Update color pointer.
	lda #$00						; Clear A.
	sta snakeDungeonState			; Clear state completely.
	jmp ThievesDenOrWellOfTheSoulsKernel; Return.

LF1A2:
	lsr snakeDungeonState			; Shift state (Bit 5 cleared).
	jmp ThievesDenOrWellOfTheSoulsKernel; Return.
	
ThiefSpriteAnimationFrameSetup:
	; --------------------------------------------------------------------------
	; ANIMATION FRAME SELECTION
	; Calculates the correct animation frame based on movement.
	; --------------------------------------------------------------------------
	lsr								; Shift A (from previous logic or scanline?).
	bit snakeDungeonState			; Check state (Bit 4?).
	beq ThiefSpriteAnimationFrameSpecialCase; If zero, jump to Special Case.
	ldy $87							; Restore Thief Index.
	lda #$08						; Load Bit 3 mask.
	and $86							; Check temp state $86.
	beq ThiefSpriteAnimationFrameSelect; If Bit 3 clear, jump.
	lda #$03						; Load Offset 3.

ThiefSpriteAnimationFrameSelect:
	eor thiefHmoveIndices,y			; XOR with HMOVE index (Position-based animation).
	and #3							; Mask to 2 bits (4 frames).
	tay								; Use as index.
	lda ThiefSpriteLSBValues,y		; Load LSB for Sprite Graphic.
	sta p0GfxPtrs					; Set Graphic Pointer LSB.
	lda #<ThiefColors				; Load Colors Base Address.
	sta p0ColorPtrs					; Set Color Pointer LSB.
	lda #H_THIEF - 1				; Load Height for Thief (-1).
	sta p0SpriteHeight				; Set Height.
	lsr snakeDungeonState			; Shift state.
	jmp ThievesDenOrWellOfTheSoulsKernel; Return.
	
ThiefSpriteAnimationFrameSpecialCase:
	txa								; Move scanline to A.
	and #$1F						; Mask.
	cmp #$0C						; Compare.
	beq ThiefSpriteSpecialFrameHandler; Branch if equal.
	jmp ThievesDenOrWellOfTheSoulsKernel; Jump back.
	
ThiefSpriteSpecialFrameHandler:
	ldy $87							; Load temp $87.
	lda thiefHorizPositions,y		; Load horizontal position.
	sta thiefHorizPosCoarse			; Store coarse.
	and #$0F						; Mask low nibble.
	sta thiefHorizPosFine			; Store fine.
	lda #$80						; Load $80.
	sta snakeDungeonState			; Store state.
	jmp ThievesDenOrWellOfTheSoulsKernel; Jump back.
	
InventoryKernel
	sta WSYNC
;--------------------------------------
	sta HMOVE						; Execute HMOVE.
	ldx #$FF						; Load $FF (Solid).
	stx PF1							; Set PF1.
	stx PF2							; Set PF2.
	inx								; Increment X to 0.
	stx GRP0						; Clear GRP0.
	stx GRP1						; Clear GRP1.
	stx ENAM0						; Disable Missile 0.
	stx ENAM1						; Disable Missile 1.
	stx ENABL						; Disable Ball.
	sta WSYNC
;--------------------------------------
	sta HMOVE						; Execute HMOVE.
	lda #THREE_COPIES				; Three copies close.
	ldy #NO_REFLECT					; No reflection.
	sty REFP1						; Set REFP1.
	sta NUSIZ0						; Set NUSIZ0.
	sta NUSIZ1						; Set NUSIZ1.
	sta VDELP0						; Vertical Delay P0 (Copies update).
	sta VDELP1						; Vertical Delay P1.
	sty GRP0						; Clear GRP0 (Y=0).
	sty GRP1						; Clear GRP1.
	sty GRP0						; Clear GRP0.
	sty GRP1						; Clear GRP1.
	SLEEP 2							; Wait.
	sta RESP0						; Reset Player 0.
	sta RESP1						; Reset Player 1.
	sty HMP1						; Set Fine Motion P1 (Y=0).
	lda #HMOVE_R1					; Load right motion.
	sta HMP0						; Set HMP0.
	sty REFP0						; Set REFP0 (Y=0).
	sta WSYNC
;--------------------------------------
	sta HMOVE						; Execute HMOVE.
	lda #YELLOW + 10				; Golden color.
	sta COLUP0						; Set Color P0.
	sta COLUP1						; Set Color P1.
	lda selectedInventorySlot		; Get selected inventory index.
	lsr								; Divide by 2.
	tay								; Transfer to Y.
	lda InventoryIndexHorizValues,y	; Load Horizontal value for indicator.
	sta HMBL						; Set Ball Fine Motion.
	and #$0F						; Keep coarse value.
	tay								; Transfer to Y.
	ldx #HMOVE_0					; No motion.
	stx HMP0						; Set HMP0.
	sta WSYNC
;--------------------------------------
	stx PF0							; Clear PF0 (X=0/HMOVE_0?). Wait, X loaded HMOVE_0 which is likely $80 or similar.
									; Check previous context. #HMOVE_0 is usually 0 motion ($00 or $80 depending on shift).
									; If it's a constant, I should trust it.
									; Ah, HMOVE_0 is usually a value for HMxx registers ($00, $10, etc.)
									; Using it for PF0/COLUBK might be clearing if it's 0.
									; Assuming X is 0 based on usage later?
	stx COLUBK						; Set Background Color.
	stx PF1							; Set PF1.
	stx PF2							; Set PF2.
.coarseMoveInventorySelector
	dey								; Decrement coarse counter.
	bpl .coarseMoveInventorySelector; Loop until done.
	sta RESBL						; Reset Ball (Inventory Selector).
	stx CTRLPF						; Set CTRLPF.
	sta WSYNC
;--------------------------------------
	sta HMOVE						; Execute HMOVE.
	lda #$3F						; Mask.
	and frameCount					; Check frame count.
	bne UpdateInventoryDisplay		; Skip if not 0.
	lda #$3F						; Mask.
	and secondsTimer				; Check timer.
	bne UpdateInventoryDisplay		; Skip if not 0.
	lda entranceRoomEventState		; Load event state.
	and #$0F						; Mask low nibble.
	beq UpdateInventoryDisplay		; Skip if 0.
	cmp #$0F						; Compare with Max.
	beq UpdateInventoryDisplay		; Skip if Max.
	inc entranceRoomEventState		; Increment state.

UpdateInventoryDisplay:
	sta WSYNC
;--------------------------------------
	lda #ORANGE + 2					; Background Color (Inventory Bar).
	sta COLUBK						; Set COLUBK.
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	lda #H_INVENTORY_SPRITES - 1	; Load Height-1.
	sta loopCounter					; Set loop counter.

.drawInventorySprites
	ldy loopCounter					; Load Y with index.
	lda (inventoryGfxPtrs),y		; Load inv item 1.
	sta GRP0						; Store GRP0.
	sta WSYNC
;--------------------------------------
	lda (inventoryGfxPtrs + 2),y	; Load inv item 2.
	sta GRP1						; Store GRP1.
	lda (inventoryGfxPtrs + 4),y	; Load inv item 3.
	sta GRP0						; Store GRP0 (overwrites previous, due to copies?).
	lda (inventoryGfxPtrs + 6),y	; Load inv item 4.
	sta tempGfxHolder				; Save to temp.
	lda (inventoryGfxPtrs + 8),y	; Load inv item 5.
	tax								; Save to X.
	lda (inventoryGfxPtrs + 10),y	; Load inv item 6.
	tay								; Save to Y (note: invalidates Y loop index?).
									; Wait! Y is loop counter. 
									; `lda (...,y)` uses Y.
									; `tay` overwrites Y with item 6 data.
									; But next usage is `sty GRP1`.
									; Then `dec loopCounter` accesses `loopCounter` RAM, not Y.
									; `ldy loopCounter` at top of loop restores it.
									; So this is safe.
	lda tempGfxHolder				; Restore item 4.
	sta GRP1						; Store GRP1.
	stx GRP0						; Store item 5 to GRP0.
	sty GRP1						; Store item 6 to GRP1.
	sty GRP0						; Store item 6 to GRP0 (Reflect/Copy?).
	dec loopCounter					; Decrement counter.
	bpl .drawInventorySprites		; Loop.

	lda #0							; Load 0.
	sta WSYNC
;--------------------------------------
	sta GRP0						; Clear GRP0.
	sta GRP1						; Clear GRP1.
	sta GRP0						; Clear GRP0.
	sta GRP1						; Clear GRP1.
	sta NUSIZ0						; Reset NUSIZ0.
	sta NUSIZ1						; Reset NUSIZ1.
	sta VDELP0						; Reset VDELP0.
	sta VDELP1						; Reset VDELP1.
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	ldy #ENABLE_BM					; Load Enable Ball Mask.
	lda inventoryItemCount			; Get item count.
	bne UpdateInventoryBallAndPlayfield; Branch if items exist.
	dey								; Disable Ball (Y becomes $FF, or if ENABLE_BM is $02, this might not work as expected).
									; ENABLE_BM is usually $02 (Bit 1).
									; `dey` from $02 -> $01. Bit 1 is 0. Disabled. Correct.
UpdateInventoryBallAndPlayfield:
	sty ENABL						; Update ENABL.
	ldy #BLACK + 8					; Load color.
	sty COLUPF						; Set COLUPF.
	sta WSYNC
;--------------------------------------
	sta WSYNC
;--------------------------------------
	ldy #DISABLE_BM					; Disable Ball.
	sty ENABL						; Store ENABL.
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
;-------------------------------------------------------------------------------
; UpdateSoundRegistersDuringOverscan
;
; This routine drives the TIA audio registers (AUDC0/1, AUDV0/1, AUDF0/1) based on
; the values in `soundChan0_IndyState` (Channel 0) and `soundChan1_WhipTimer` (Channel 1).
;
; AUDIO ENGINE ARCHITECTURE:
; To save RAM and ROM, this engine couples the Audio Control (Timbre) and Volume.
; It writes the SAME 4-bit value to both AUDCx and AUDVx.
;
; The source byte (soundChan0_IndyState or soundChan1_WhipTimer) is interpreted as follows:
;   Bit 7 (Sign): 
;       0 (Positive): Play sound for ONE frame, then clear the source byte (Silence).
;                     Used for short blips or status-based sounds.
;       1 (Negative): SUSTAIN sound. Do not clear variable. 
;                     Triggers special sequence logic if specific values are met.
;   Bits 0-3 (Low Nibble):
;       Determines BOTH the Distortion Type (AUDC) and Volume (AUDV).
;       Example: $4 (Square Wave, Vol 4/15)
;       Example: $C (Pure Tone, Vol 12/15)
;       Example: $8 (White Noise, Vol 8/15)
;
UpdateSoundRegistersDuringOverscan:
	lda soundChan0_IndyState,x	  ; Load Sound Control Byte (Chan 0: soundChan0_IndyState, Chan 1: soundChan1_WhipTimer)
	sta AUDC0,x	  ; Set Distortion Type (Uses Low Nibble)
	sta AUDV0,x	  ; Set Volume (Uses Low Nibble)
	bmi UpdateSpecialSoundEffectDuringOverscan	  ; If Bit 7 Set -> Sustain/Sequence Logic
	
	; --- One-Shot / Decay Logic ---
	ldy #$00		  ; Prepare 0
	sty soundChan0_IndyState,x	  ; Clear the source variable (stop sound next frame)
	
UpdateSoundFrequencyDuringOverscan:
	sta AUDF0,x	  ; Set Frequency (Wait, this uses existing A? Or re-loads?)
				  ; Optimisation: Check if A is preserved. In 'UpdateSpecial...', A is loaded/calculated.
				  ; In fall-through (One-Shot), A holds the Control Byte.
				  ; So Frequency = Control Byte? That seems odd for a blip.
				  ; A blip of Freq $0C is very high pitch.
	dex			  ; Decrement Channel Index
	bpl UpdateSoundRegistersDuringOverscan	  ; Loop for next channel
	bmi OverscanSoundUpdateDone						; All channels done

;-------------------------------------------------------------------------------
; UpdateSpecialSoundEffectDuringOverscan
;
; Handles sustained sounds and musical sequences.
; Triggered if Bit 7 of the control byte is SET.
;
; Magic Values:
;   $9C (1001 1100): Triggers "Mystery Effect" (Pure Tone, Vol 12).
;                    Uses `soundEffectTimer` and `OverscanSpecialSoundEffectTable`.
;   $84 (1000 0100): Triggers "Main Theme" (Square Wave, Vol 4).
;                    Uses `frameCount` and `OverscanSoundEffectTable`.
;
UpdateSpecialSoundEffectDuringOverscan:
	cmp #$9C		  ; Check for "Main Theme" Sound ID
	bne UpdateSoundEffectFromFrameCount	  ; If not $9C, check for "Snake Charmer Song"
	
	; --- Main Theme (Raiders March) Logic (Timer Based) ---
	lda #$0F
	and frameCount		 ; Slow tick (every 16 frames?)
	bne UpdateSoundEffectTimerDuringOverscan	  ; If not tick, just verify timer
	dec soundEffectTimer		  ; Decrement timer
	bpl UpdateSoundEffectTimerDuringOverscan	  ; If still positive, play
	lda #$17		  ; Reset timer to start (Looping?)
	sta soundEffectTimer		  ;3
	
UpdateSoundEffectTimerDuringOverscan:
	ldy soundEffectTimer		  ; Get timer value
	lda OverscanSpecialSoundEffectTable,y	  ; Look up Frequency from Table
	bne UpdateSoundFrequencyDuringOverscan	  ; Go to write Frequency
	
	; --- Snake Charmer Song Logic (Frame Based) ---
UpdateSoundEffectFromFrameCount:
	lda frameCount					; get global frame counter
	lsr			  ; Divide by 16 (Plays note for ~16 frames)
	lsr			  ; .
	lsr			  ; .
	lsr			  ; .
	tay			  ; Use as index
	lda OverscanSoundEffectTable,y	  ; Look up Note/Frequency
	bne UpdateSoundFrequencyDuringOverscan	  ; Go to write Frequency (Note: If 0, no write? No, bne jumps)

OverscanSoundUpdateDone:

	lda selectedInventoryId			; Get current selected inventory id.
	cmp #ID_INVENTORY_TIME_PIECE	; Is it the Time Piece?
	beq UpdateInventoryTimepieceDisplay; Check for Time Piece display action.
	
	cmp #ID_INVENTORY_FLUTE			; Is it the Flute?
	bne ResetInventoryDisplayState	; If NOT Flute, skip music.
	
	; --- Flute Music Logic ---
	lda #$84						; Load Sound/Frequency Value?
	sta soundChan1_WhipTimer				; Store in effect timer (activates music routine).
	bne UpdateInventoryAndEventStateAfterReset; Unconditional branch.
	
UpdateInventoryTimepieceDisplay:
	bit INPT5						; read action button from right controller
	bpl UpdateTimepieceInventorySprite						; branch if action button pressed
	lda #<InventoryTimepieceSprite
	bne StoreTimepieceInventorySprite						; unconditional branch
	
UpdateTimepieceInventorySprite:
	; --------------------------------------------------------------------------
	; UPDATE TIMEPIECE GRAPHIC
	; The timepiece in the inventory shows the passing of time (hand rotation?).
	; Uses secondsTimer to select the correct graphic frame.
	; --------------------------------------------------------------------------
	lda secondsTimer				; Load seconds counter.
	and #$E0						; Keep top 3 bits (8 frames?).
	lsr								; Shift right 2 times to create offset.
	lsr
	adc #<Inventory12_00			; Add Base Address of Timepiece Graphics.
	
StoreTimepieceInventorySprite:
	ldx selectedInventorySlot		; Get the current slot for the timepiece.
	sta inventoryGfxPtrs,x			; Update the graphics pointer (Low Byte).

ResetInventoryDisplayState:
	lda #$00						; Clear A.
	sta soundChan1_WhipTimer		; Reset Timer (Reused as generic timer?).

UpdateInventoryAndEventStateAfterReset:
	bit screenEventState			; Check for special inventory event.
	bpl UpdateInventoryObjectPositions; If Bit 7 clear, skip to standard update.

	; --------------------------------------------------------------------------
	; INVENTORY EVENT ANIMATION
	; Likely handles the "Map opening" or finding an item sequence.
	; --------------------------------------------------------------------------
	lda frameCount					; Get current frame count.
	and #$07						; Mask lower 3 bits.
	cmp #$05						; Compare with 5.
	bcc UpdateInventoryEventAnimationState; If < 5, Update Animation State.

	ldx #$04						; X = 4.
	ldy #$01						; Y = 1.
	bit majorEventFlag 				; Check Major Event Flag (Death/EndGame).
	bmi SetInventoryEventStateY03	; If Set (Minus), Set Y=3.
	bit snakeTimer					; Check Snake Timer (Event Timer?).
	bpl UpdateInventoryEventStateAfterYSet; If positive, skip.

SetInventoryEventStateY03:
	ldy #$03						; Set Y = 3.

UpdateInventoryEventStateAfterYSet:
	jsr	 UpdateObjectPositionHandler; Call Object Position Handler.

UpdateInventoryEventAnimationState:
	lda frameCount					; Get current frame count.
	and #$06						; Mask bits 1 and 2.
	asl								; Shift left (Multiply by 4?).
	asl
	sta timepieceGfxPtrs			; Update Timepiece Graphics Pointer (Why Timepiece?).
	lda #$FD						; Load $FD.
	sta $D7							; Set Unknown ZP $D7.

UpdateInventoryObjectPositions:
	; --------------------------------------------------------------------------
	; POSITION INVENTORY OBJECTS
	; Positions the strip of 3 items visible in the inventory.
	; --------------------------------------------------------------------------
	ldx #$02						; Start at Index 2.

UpdateInventoryObjectPositionsLoop:
	jsr	 UpdateInventoryObjectPositionHandler; Update Position for Item X.
	inx								; Next Item.
	cpx #$05						; Loop until 5.
	bcc UpdateInventoryObjectPositionsLoop; Loop.

	bit majorEventFlag 				; Check Major Event (Death).
	bpl HandleInventorySelectionCycling; If Clear, Normal Gameplay (Selection Allowed).

	; --------------------------------------------------------------------------
	; DEATH / MAJOR EVENT SEQUENCE
	; Handles Indy shrinking/dissolving upon death.
	; --------------------------------------------------------------------------
	lda frameCount					; Get current frame count.
	bvs UpdateInventoryEventStateAfterFrameCount; Branch if Overflow Set.
	and #$0F						; Mask lower 4 bits.
	bne SwitchToVerticalSync		; If not 0 (Speed control), Skip.

	ldx indySpriteHeight			; Load Indy Height.
	dex								; Decrease Height (Shrink Indy).
	stx soundChan1_WhipTimer		; Debug/Sound Timer update.
	cpx #$03						; Check if height is very small (3 lines).
	bcc UpdateInventoryEventFrameCount; If < 3, Death Complete?
	lda #$8F						; Load Y Position?
	sta weaponVertPos				; Reset Weapon/Effect Position.
	stx indySpriteHeight			; Save new Height.
	bcs SwitchToVerticalSync		; Always branch.
	
UpdateInventoryEventFrameCount:
	sta frameCount					; Reset Frame Count (A was likely modified earlier? Or A=$0F).
	sec								; Set Carry.
	ror majorEventFlag 				; Rotate Major Event Flag (updates state?).

UpdateInventoryEventStateAfterFrameCount:
	cmp #$3C						; Compare A (FrameCount?) with 60.
	bcc UpdateIndySpriteHeightAndEventState; If < 60, Continue.
	bne ResetIndySpriteHeight		; If != 60, Reset.
	sta soundChan1_WhipTimer		; Store in Timer.

ResetIndySpriteHeight:
	ldy #$00						; Clear Y.
	sty indySpriteHeight			; Set Height 0 (Invisible?).

UpdateIndySpriteHeightAndEventState:
	cmp #$78						; Compare with 120.
	bcc SwitchToVerticalSync		; If < 120, Exit.

	; --------------------------------------------------------------------------
	; LIFE LOSS / RESPAWN
	; --------------------------------------------------------------------------
	lda #H_INDY_SPRITE				; Reset Height default.
	sta indySpriteHeight			; Store.
	sta soundChan1_WhipTimer		; Store.
	sta majorEventFlag 				; Reset Flag.
	dec lives						; Decrement Lives.
	bpl SwitchToVerticalSync		; If Lives >= 0, Continue Game.

	lda #$FF						; Game Over State?
	sta majorEventFlag 				; Set Flag.
	bne SwitchToVerticalSync		; Exit.
	
HandleInventorySelectionCycling:
	; --------------------------------------------------------------------------
	; INVENTORY SELECTION
	; Check inputs to cycle through inventory items.
	; --------------------------------------------------------------------------
	lda currentRoomId				; Get the current screen id.
	cmp #ID_ARK_ROOM				; Check if in Ark Room.
	bne CheckForCyclingInventorySelection; If not, allow selection.

SwitchToVerticalSync:
	lda #<VerticalSync
	sta bankSwitchJMPAddr
	lda #>VerticalSync
	sta bankSwitchJMPAddr + 1
	jmp JumpToBank0
	
CheckForCyclingInventorySelection
	bit eventState					; Check general event state.
	bvs .doneCyclingInventorySelection; If Overflow Set (Bit 6?), Block Selection.
	bit mesaSideState				; Check Mesa State.
	bmi .doneCyclingInventorySelection; If Bit 7 Set (Parachuting?), Block.
	bit grenadeState				; Check Grenade State.
	bmi .doneCyclingInventorySelection; If Bit 7 Set (Thrown?), Block.
	lda #7
	and frameCount
	bne .doneCyclingInventorySelection;check to move inventory selector ~8 frames
	lda inventoryItemCount		; get number of inventory items
	and #MAX_INVENTORY_ITEMS
	beq .doneCyclingInventorySelection; branch if Indy not carrying items
	ldx selectedInventorySlot
	lda inventoryGfxPtrs,x	; get inventory graphic LSB value
	cmp #<Inventory12_00
	bcc CheckForChoosingInventoryItem; branch if the item is not a clock sprite
	lda #<InventoryTimepieceSprite	; reset inventory item to the time piece
CheckForChoosingInventoryItem
	bit SWCHA						; check joystick values
	bmi .checkForCyclingLeftThroughInventory;branch if left joystick not pushed right
	sta inventoryGfxPtrs,x	; set inventory graphic LSB value
.cycleThroughInventoryRight
	inx
	inx                 ; Move to next slot (2-byte stride)
	cpx #11
	bcc .continueCycleInventoryRight
	ldx #0              ; Wrap around to first slot if > 10
.continueCycleInventoryRight
	ldy inventoryGfxPtrs,x	; get inventory graphic LSB value
	beq .cycleThroughInventoryRight	; If empty (0), skip and keep searching Right
	bne .setselectedInventorySlot	; Found an item, select it
	
.checkForCyclingLeftThroughInventory
	bvs .doneCyclingInventorySelection; branch if left joystick not pushed left
	sta inventoryGfxPtrs,x
.cycleThroughInventoryLeft
	dex
	dex                 ; Move to previous slot
	bpl .continueCycleInventoryLeft
	ldx #10             ; Wrap around to last slot if < 0
.continueCycleInventoryLeft
	ldy inventoryGfxPtrs,x
	beq .cycleThroughInventoryLeft	; If empty (0), skip and keep searching Left
.setselectedInventorySlot
	stx selectedInventorySlot       ; Update the active slot index
	tya								; move inventory graphic LSB to accumulator
	lsr								; divide value by 8 (i.e. H_INVENTORY_SPRITES)
	lsr
	lsr
	sta selectedInventoryId			; Convert Sprite Pointer LSB -> Item ID
	cpy #<InventoryHourGlassSprite
	bne .doneCyclingInventorySelection; branch if the Hour Glass not selected
	ldy #ID_MESA_FIELD
	cpy currentRoomId
	bne .doneCyclingInventorySelection; Branch if not in Mesa Field context.
	
	; --------------------------------------------------------------------------
	; INITIALIZE DROP/EVENT IN MESA
	; Sets up a specific event (Ark opening or dropping?) in the Mesa Field.
	; Positions the "Weapon" (Object) relative to Indy.
	; --------------------------------------------------------------------------
	lda #$49						; Load Event State value.
	sta eventState					; Set State.
	lda indyVertPos					; Get Indy's vertical position.
	adc #9							; Add Offset.
	sta weaponVertPos				; Set Object Y to Indy Y + 9.
	lda indyHorizPos				; Get Indy X.
	adc #9							; Add Offset.
	sta weaponHorizPos				; Set Object X to Indy X + 9.

.doneCyclingInventorySelection
	lda eventState					; Check Event State.
	bpl HandleInventorySelectionAdjustment; If Bit 7 Clear, go to standard adjustment/collision.
	
	; --------------------------------------------------------------------------
	; EVENT STATE UPDATE
	; If Bit 7 is set, we are in an active sequence (Opening Ark?).
	; Increments the state value (Timer/Stage).
	; --------------------------------------------------------------------------
	cmp #$BF						; Check if state has reached terminal value.
	bcs HandleInventorySelectionEdgeCase; If >= $BF, handle end case.
	adc #$10						; Increment High Nibble (Timer/Stage).
	sta eventState					; Update State.
	ldx #$03						; Load Index 3.
	jsr	 InventorySelectionAdjustmentHandler; Call Handler.
	jmp	 ReturnToObjectCollisionHandler; Return.
	
HandleInventorySelectionEdgeCase:
	lda #$70						; Load $70.
	sta weaponVertPos				; Reset Object Y.
	lsr								; Divide by 2 -> $38.
	sta eventState					; Set Event State to $38 (Bit 7 Clear).
	bne ReturnToObjectCollisionHandler; Return.
	
HandleInventorySelectionAdjustment:
	; --------------------------------------------------------------------------
	; INVENTORY SELECTION / CURSOR ALIGNMENT
	; Checks if Indy's position aligns with the selection cursor or object.
	; Used to determine if Indy has "Selected" the item.
	; --------------------------------------------------------------------------
	bit eventState					; Check State.
	bvc ReturnToObjectCollisionHandler; If Bit 6 Clear, Exit.
	ldx #$03						; Load Index 3.
	jsr	 InventorySelectionAdjustmentHandler; Update Cursor/Object Position logic?

	; Check Horizontal Alignment
	lda weaponHorizPos				; Get Object/Cursor X.
	sec								; Set Carry.
	sbc #$04						; Subtract offset.
	cmp indyHorizPos				; Compare with Indy X.
	bne HandleInventorySelectionPositionCheck; If not equal, check boundaries.
	
	lda #$03						; Load Mask $03 (Bits 0, 1).
	bne HandleInventorySelectionBitwiseUpdate; Jump to Update State.

HandleInventorySelectionPositionCheck:
	cmp #$11						; Check Left Boundary/Specific X.
	beq HandleInventorySelectionSpecialValue; If equal, handle.
	cmp #$84						; Check Right Boundary/Specific X.
	bne HandleInventorySelectionVerticalCheck; If not equal, check Vertical.

HandleInventorySelectionSpecialValue:
	lda #$0F						; Load Mask $0F.
	bne HandleInventorySelectionBitwiseUpdate; Jump to Update State.
	
HandleInventorySelectionVerticalCheck:
	; Check Vertical Alignment
	lda weaponVertPos				; Get Object/Cursor Y.
	sec								; Set Carry.
	sbc #$05						; Subtract offset.
	cmp indyVertPos					; Compare with Indy Y.
	bne HandleInventorySelectionBoundaryCheck; If not equal, check boundary.
	lda #$0C						; Load Mask $0C (Bits 2, 3).

HandleInventorySelectionBitwiseUpdate:
	eor eventState					; Toggle State Bits based on alignment.
	sta eventState					; Store State.
	bne ReturnToObjectCollisionHandler; Return.

HandleInventorySelectionBoundaryCheck:
	cmp #$4A						; Check Y Boundary.
	bcs HandleInventorySelectionSpecialValue; If >= $4A, trigger special value update.

ReturnToObjectCollisionHandler:
	; --------------------------------------------------------------------------
	; BANK SWITCH RETURN
	; Return to CheckObjectCollisions in Bank 0.
	; --------------------------------------------------------------------------
	lda #<CheckObjectCollisions
	sta bankSwitchJMPAddr
	lda #>CheckObjectCollisions
	sta bankSwitchJMPAddr + 1
JumpToBank0
	lda #LDA_ABS
	sta bankSwitchLDAOpcode
	lda #<BANK0STROBE
	sta bankSwitchAddr
	lda #>BANK0STROBE
	sta bankSwitchAddr + 1
	lda #JMP_ABS
	sta bankSwitchJMPOpcode
	jmp.w bankSwitchVars

;------------------------------------------------------------ArkRoomKernel
;
; This kernel handles the visuals for the "Ark Room" (Room ID 13).
; This room serves as both the Start Screen (Indy on Pedestal) and the End Screen (Winning Animation).
; Unlike standard rooms, it uses a dedicated scanline loop to draw the Ark (Top) and Pedestal (Bottom).
;
; Visual Logic:
; 1. Top Section (Scanlines 0-18 approx): Checks logic to draw the Ark of the Covenant.
;    - The Ark is only drawn if resetEnableFlag is positive (indicating Win State).
; 2. Mid/Bottom Section: Draws Indy standing on the Lifting Pedestal.
;
ArkRoomKernel
.arkRoomKernelLoop
	sta WSYNC
;--------------------------------------
	cpx #18							; Compare scanline with 18.
	bcc .checkToDrawArk				; Branch if < 18 (Ark Zone).
	txa								; Move scanline to A.
	sbc indyVertPos					; Subtract Indy Y to check relative position
	bmi AdvanceArkRoomKernelScanline; If negative, skip drawing Indy line
	cmp #(H_INDY_SPRITE - 1) * 2	; Compare with Height*2 (Double-height sprite check)
	bcs .drawLiftingPedestal		; If > Height*2, draw pedestal bits instead
	lsr								; Divide by 2 (Sprite shift)
	tay								; Transfer to Y index
	lda IndyStationarySprite,y		; Load Indy sprite data
	jmp .drawPlayer1Sprite			; Jump to common draw routine
	
.drawLiftingPedestal
	and #3							; Mask low 2 bits for Pedestal pattern
	tay								; Transfer to Y
	lda LiftingPedestalSprite,y		; Load Pedestal Sprite data

.drawPlayer1Sprite
	sta GRP1						; Store in GRP1 (Player 1 Graphics)
	lda indyVertPos					; Load Indy Y Position
	sta COLUP1						; Set Color P1 (matches Indy's Y?)

AdvanceArkRoomKernelScanline:
	inx								; Increment scanline counter
	cpx #144						; check if kernel finished (144 scanlines)
	bcs ArkRoomPedestalAndPlayer0ScanlineHandler; Branch if >= 144 to finish up
	bcc .arkRoomKernelLoop			; Loop back if not done
	
.checkToDrawArk
	bit resetEnableFlag				; Check Game State Flag
	bmi .skipDrawingArk				; Branch if Minus (Bit 7 Set). If Set, Ark is HIDDEN.
									; Note: Win Logic sets this to Positive ($58), enabling the Ark.
	txa								; Move scanline to A.
	sbc #H_ARK_OF_THE_COVENANT		; Subtract Ark Height/Offset
	bmi .skipDrawingArk				; Skip if outside Ark bounds
	tay								; Transfer to Y
	lda ArkOfTheCovenantSprite,y	; Load Ark Sprite data
	sta GRP1						; Draw Ark in GRP1
	txa								; Move scanline to A.
	adc frameCount					; Add frame count for color cycling
	asl								; Shift left
	sta COLUP1						; Set Ark Color (Rainbow effect)

.skipDrawingArk
	inx								; Increment scanline
	cpx #15							; Compare with 15
	bcc .arkRoomKernelLoop			; Loop


ArkRoomPedestalAndPlayer0ScanlineHandler:
	sta WSYNC
;--------------------------------------
	cpx #32							; Compare with 32.
	bcs .checkToDrawPedestal		; Branch if >= 32.
	bit resetEnableFlag				; Check flag.
	bmi ArkRoomPedestalScanlineLoop	; Skip.
	txa								; Move scanline to A.
	ldy #%01111110					; Load pattern.
	and #$0E						; Mask bits 1-3.
	bne .drawPlayer0Sprite			; If not 0...
	ldy #%11111111					; Load solid pattern.
.drawPlayer0Sprite
	sty GRP0						; Store to GRP0 (Effect?).
	txa								; Move scanline to A.
	eor #$FF						; Invert.
	sta COLUP0						; Set Color P0.

ArkRoomPedestalScanlineLoop:
	inx								; Increment scanline.
	cpx #29							; Compare with 29.
	bcc ArkRoomPedestalAndPlayer0ScanlineHandler; Loop.
	lda #0							; Load 0.
	sta GRP0						; Clear GRP0.
	sta GRP1						; Clear GRP1.
	beq .arkRoomKernelLoop			; Jump back to main loop.
	
.checkToDrawPedestal
	txa								; Move scanline to A.
	sbc #144						; Subtract 144 (Y start).
	cmp #H_PEDESTAL					; Compare height.
	bcc .drawPedestal				; Draw.
	jmp InventoryKernel				; Jump to Inventory.
	
.drawPedestal
	lsr								; Divide by 4.
	lsr
	tay								; Transfer to Y.
	lda PedestalSprite,y			; Load Pedestal Sprite.
	sta GRP0						; Store to GRP0.
	stx COLUP0						; Set Color P0.
	inx								; Increment Scanline.
	bne ArkRoomPedestalAndPlayer0ScanlineHandler; Unconditional branch (X!=0).
	
JumpToScreenHandlerFromBank1:
	lda currentRoomId				; get the current screen id
	asl								; multiply screen id by 2
	tax
	lda ScreenHandlerJumpTable + 1,x
	pha
	lda ScreenHandlerJumpTable,x
	pha
	rts

MesaFieldScreenHandler:
	; --------------------------------------------------------------------------
	; MESA FIELD / VALLEY OF POISON (Bank 1 Logic)
	; --------------------------------------------------------------------------
	; This handler ensures that specific objects (P0, M0, Snake/Ball) are "pinned"
	; to the vertical center of the screen ($7F). 
	;
	; Combined with the "Sinking" logic in Bank 0 (HandleEnvironmentalSinkingEffect),
	; which manipulates offsets and other positions, this likely creates the 
	; relative motion effect of sinking or stabilizing the view.
	;
	; Effectively, these objects act as a fixed reference point (Horizon?) while
	; the environment (Background) shifts around them during sinking.
	; --------------------------------------------------------------------------
	lda #$7F						
	sta p0VertPos					; Pin Player 0 (Sun/Marker) to Center Y
	sta m0VertPos					; Pin Missile 0 (Hook/Web?) to Center Y
	sta snakeDungeonY				; Pin Snake/Ball to Center Y
	
	bne ReturnToScreenHandlerFromSpiderRoom; Exit
	
SpiderRoomScreenHandler:
	ldx #$00						; X = 0 (Spider Object / Player 0 Index)
	ldy #<indyVertPos - objectVertPositions; Y = Offset to Indy's Vertical Position in array
	bit CXP1FB						; Check P1 (Indy) vs Playfield (Walls) Collision
	bmi SpiderRoomObjectPositionHandler; If Indy touches walls, Spider enters "Aggressive Mode" (Chases Indy)
	bit spiderRoomState				; Check bit 7 of spiderRoomState (Set if Indy touches the Web/Ms0)
	bmi SpiderRoomObjectPositionHandler	; If Indy trapped in web, Spider enters "Aggressive Mode" (Chases Indy)
	
	; Mode: Passive (Guard Nest)
	; Spider moves slowly (once every 8 frames) back to the top of the screen.
	lda frameCount					; Get global frame counter
	and #$07						; check every 8th frame
	bne SpiderRoomSpriteAndStateHandler	; If not the 8th frame, skip movement update

	ldy #$05						; Set Target Index to 5 (a unused/static slot?) 
	lda #$4C						; Load Passive Target X? (Though p0VertPosTemp seems unused for Logic)
	sta unused_CD_WriteOnly				; (Unused write)
	lda #$23						; Set Passive Target Y = $23 (Top of screen/Nest position)
	sta targetVertPos				; Store in target variable for UpdateObjectPositionHandler

SpiderRoomObjectPositionHandler:
	; Calls generic handler to move Object[X] towards Object[Y].
	; Valid inputs at this point:
	;   Aggressive: X=0(Spider), Y=Indy Offset. Result: Spider moves to Indy.
	;   Passive:    X=0(Spider), Y=5(Static).   Result: Spider moves to Static Pos ($23).
	jsr	 UpdateObjectPositionHandler; Execute movement logic

SpiderRoomSpriteAndStateHandler:
	lda #$80						; Set bit 7
	sta screenEventState			; Update screen event flags (Trigger collision logic elsewhere?)
	
	; Animation Logic
	; Calculates a sprite frame based on position to simulate leg movement/scuttling.
	lda objectVertPositions			; Load Spider Vertical Position (p0VertPos) ($CE)
	and #$01						; Check LSB (Odd/Even pixel)
	ror p0HorizPos					; Rotate Spider X into Carry (Modifying X pos momentarily)
	rol								; Rotate Carry into A (Combines Y-bit and X-bit info)
	tay								; Use result as index into sprite table
	ror								; Restore Carry
	rol p0HorizPos					; Restore Spider X Position
	lda SpiderRoomPlayer0SpriteTable,y; Load the appropriate Spider Sprite frame
	sta p0GfxPtrs					; Store Low Byte of sprite pointer
	lda #$FC						; Sprites are in Page $FC
	sta p0GfxPtrs + 1				; Store High Byte of sprite pointer
	
	; Web (Missile 0) Logic
	; The "Web" is represented by Missile 0 held in a fixed position.
	lda m0VertPosShadow				; Check Shadow Variable for M0
	bmi ReturnToScreenHandlerFromSpiderRoom; If negative (disabled/offscreen), exit
	ldx #$50						; Set Web Horizontal Position to $50 (Center-ish)
	stx m0HorizPos					
	ldx #$26						; Set Web Vertical Position to $26 (Near top)
	stx m0VertPos					
	
	; State / Animation Timer Logic
	lda spiderRoomState				; Check main state
	bmi ReturnToScreenHandlerFromSpiderRoom; If Bit 7 set (Aggressive/Caught), skip passive animation updates
	bit majorEventFlag 				; Check if a major event (Correction/Cutscene) is active
	bmi ReturnToScreenHandlerFromSpiderRoom; If so, skip
	and #$07						; Mask lower 3 bits (Animation Timer)
	bne SpiderRoomSpriteStateUpdate	; If timer != 0, go update sprite state shadow
	ldy #$06						; Reset timer/state to 6
	sty spiderRoomState				; Store back

SpiderRoomSpriteStateUpdate:
	tax								; Use A (masked spiderRoomState) as index
	lda TreasureRoomPlayer0SpriteStateTable,x; Load a value from table (likely a pattern for the web or effect)
	sta m0VertPosShadow				; Update the shadow variable
	dec spiderRoomState				; Decrement the timer/state counter

ReturnToScreenHandlerFromSpiderRoom:
	jmp	 ReturnToScreenHandlerFromBank1	; Return to Bank 0 Dispatcher
	
ValleyOfPoisonScreenHandler:; Screen ID 06: Valley of Poison
	lda #$80						; Set Bit 7 ($80) in Screen Event State.
	sta screenEventState			; screenEventState = $80 (Active).
	ldx #$00						; X = 0.
	bit majorEventFlag 				; Check Major Event Flag (Death, Cutscene).
	bmi ValleyOfPoisonEscapeModeSetup; If Major Event Set (Negative), Enter Escape Mode.
	bit pickupStatusFlags 			; Check Pickup Status (Bit 6 = Overflow).
	bvc ValleyOfPoisonChaseModeHandler; If Overflow Clear (No Item Stolen), Enter Chase Mode.

ValleyOfPoisonEscapeModeSetup:
	; Mode: Thief Escape (Man in Black leaves with item or during death)
	ldy #$05						; Target Index = 5.
	lda #$55						; Target Y = $55 (Escape Point).
	sta unused_CD_WriteOnly				; Store temp.
	sta targetVertPos				; Set Target Vertical Position to $55.
	lda #$01						; Speed Mask = 1 (Update every ODD frame - Fast).
	bne ValleyOfPoisonObjectUpdateLoop; Unconditional branch.
	
ValleyOfPoisonChaseModeHandler:
	; Mode: Thief Chase (Man in Black chases Indy)
	ldy #<indyVertPos - objectVertPositions			; Target Index = Indy's Vertical Position.
	lda #$03						; Speed Mask = 3 (Update every 4th frame - Slow).

ValleyOfPoisonObjectUpdateLoop:
	and frameCount					; Apply Speed Mask.
	bne ValleyOfPoisonCheckSinking	; If Mask != 0 (Skip Frame), Check Sinking/Boundary.
	jsr	 UpdateObjectPositionHandler; Update Object Position (Move P0 towards Target).
	
ValleyOfPoisonCheckSinking:
	; Check if Thief is in the "Mud" / "Bog"?
	; Or ensures the Thief stays within certain bounds ($A0).
	lda p0VertPos					; Load Thief Vertical Position ($CE).
	bpl ValleyOfPoisonEscapeCheck	; If Positive (On Screen?), Skip.
	cmp #$A0						; Check against $A0.
	bcc ValleyOfPoisonEscapeCheck	; If < $A0, Skip.
	inc p0VertPos					; Nudge Up (Sinking Effect?).
	inc p0VertPos					; Nudge Up.

ValleyOfPoisonEscapeCheck:
	bvc ValleyOfPoisonSpriteLogic	; If Overflow Clear (Chase Mode), Skip Escape Check.
	lda p0VertPos					; Load Thief Vertical Position.
	cmp #$51						; Check against Escape Line ($51).
	bcc ValleyOfPoisonSpriteLogic	; If < $51 (Not there yet), Continue.
	
	; Thief has escaped with the item.
	lda pickupStatusFlags 			; Load Flags.
	sta screenInitFlag				; Trigger initialization/state change?
	lda #$00						; Clear A.
	sta pickupStatusFlags 			; Clear Stolen Status (Reset Theft).

ValleyOfPoisonSpriteLogic:
	lda p0HorizPos					; Load Thief X.
	cmp indyHorizPos				; Compare with Indy X.
	bcs ValleyOfPoisonFaceLeft		; If Thief >= Indy, Face Left.
	dex								; Decrement X (0->FF).
	eor #$03						; Toggle bits.

ValleyOfPoisonFaceLeft:
	stx REFP0						; Set P0 Reflection.
	and #$03						; Mask Low bits of X-Diff.
	asl								; Shift Left x3 (Multiply by 8).
	asl
	asl
	asl								; Calculate Animation Offset.
	sta p0GfxPtrs					; Store P0 Graphics Pointer.
	
	; Missile 0 (Swarm) Update
	lda frameCount
	and #$7F
	bne ValleyOfPoisonM0Offscreen	; Skip update most frames (Slow update).
	lda p0VertPos					; Load Thief Y ($CE).
	cmp #$4A						; Check Bound.
	bcs ValleyOfPoisonM0Offscreen	; If >= $4A, Skip.
	ldy roomEventStateOffset		; Load Swarm Timer/State.
	beq ValleyOfPoisonM0Offscreen	; If 0, Skip.
	dey								; Decrement.
	sty roomEventStateOffset		; Update State.
	ldy #$8E						; Default Y.
	adc #$03						; Add 3 to p0VertPos.
	sta m0VertPos					; Set M0 Y near Thief.
	cmp indyVertPos					; Compare M0 Y vs Indy Y.
	bcs ValleyOfPoisonM0UpdateX		; If M0 >= Indy, Face/Move X.
	dey								; Adjust Y?

ValleyOfPoisonM0UpdateX:
	lda p0HorizPos					; Load Thief X.
	adc #$04						; Add Offset.
	sta m0HorizPos					; Set M0 X.
	sty m0VertPosShadow				; Store Y to Shadow.

ValleyOfPoisonM0Offscreen:
	ldy #$7F						; Load $7F.
	lda m0VertPosShadow				; Load shadow.
	bmi ValleyOfPoisonBulletOrWhipBoundaryUpdate; Branch if negative.
	sty m0VertPos					; Set M0 to $7F (Offscreen?).

ValleyOfPoisonBulletOrWhipBoundaryUpdate:
	lda weaponVertPos				; Get bullet/whip vertical position.
	cmp #$52						; Compare.
	bcc ReturnToScreenHandlerFromValleyOfPoison; Branch if <.
	sty weaponVertPos				; Store Y (likely $7F) to weapon pos.

ReturnToScreenHandlerFromValleyOfPoison:
	jmp	 ReturnToScreenHandlerFromBank1	; Return.
	
WellOfSoulsScreenHandler:
	; --------------------------------------------------------------------------
	; WELL OF SOULS (Screen ID 12)
	; Controls the Snakes (?) using the same logic as the Thieves.
	; --------------------------------------------------------------------------
	ldx #$3A						; Load Initial X Position ($3A = 58).
	stx thiefHmoveIndices + 4		; Set Position of Object 4 (Snake?).
	ldx #$85						; Load Initial Value ($85).
	stx $E3							; Set unknown state/pointer ($E3).
	ldx #BONUS_LANDING_IN_MESA		; Load Value 3.
	stx landingInMesaBonus			; Set Flag (Reused variable to indicate Well of Souls state?).
	bne .checkToMoveThieves			; Unconditional branch to Shared Movement Logic.
	
ThievesDenScreenHandler:
	; --------------------------------------------------------------------------
	; THIEVES' DEN (Screen ID 7)
	; Controls the movement of 5 Thieves patroling the screen.
	; --------------------------------------------------------------------------
	ldx #4							; Load loop counter (5 thieves, Indices 4 down to 0).

.checkToMoveThieves:
	; --------------------------------------------------------------------------
	; THIEF SPEED CHECK
	; Each thief has a different speed defined by ThiefMovementFrameDelayValues.
	; --------------------------------------------------------------------------
	lda ThiefMovementFrameDelayValues,x; Get speed mask for Thief X.
	and frameCount					; Apply mask.
	bne .moveNextThief				; If result != 0, skip movement this frame.
	
	ldy thiefHmoveIndices,x			; Get current horizontal position (Index).
	lda #REFLECT					; Load Reflect Bit (Direction Check).
	and thiefState,x				; Check thief state.
	bne ThievesDenThiefHMOVEIndexUpdate; If Bit Set (Reflected), Moving Right.
	
	; --------------------------------------------------------------------------
	; MOVING LEFT
	; --------------------------------------------------------------------------
	dey								; Decrement position (Move Left).
	cpy #20							; Check Left Boundary (X=20).
	bcs .setThiefHMOVEIndexValue	; If >= 20, still in bounds. Update Position.
	; Else, fall through to Change Direction.

.changeThiefDirection:
	; --------------------------------------------------------------------------
	; CHANGE DIRECTION
	; Toggles the REFLECT bit to flip the sprite and reverse direction.
	; --------------------------------------------------------------------------
	lda #REFLECT					; Load Reflect mask.
	eor thiefState,x				; XOR with current state (Toggle bit).
	sta thiefState,x				; Update state.

.setThiefHMOVEIndexValue:
	sty thiefHmoveIndices,x			; Save new Horizontal Position.

.moveNextThief:
	dex								; Decrement thief index.
	bpl .checkToMoveThieves			; If X >= 0, Loop for next thief.
	jmp	 ReturnToScreenHandlerFromBank1; All thieves done. Return.
	
ThievesDenThiefHMOVEIndexUpdate:
	; --------------------------------------------------------------------------
	; MOVING RIGHT
	; --------------------------------------------------------------------------
	iny								; Increment position (Move Right).
	cpy #133						; Check Right Boundary (X=133).
	bcs .changeThiefDirection		; If >= 133, Hit edge. Change Direction.
	bcc .setThiefHMOVEIndexValue	; Else, Update Position.
	
MesaSideScreenHandler:
	bit mesaSideState				; Check Mesa Side State.
									; Bit 7 = Parachute Active.
	bpl MesaSideScreenUpdateState	; Branch if Bit 7 clear (Parachute NOT active -> Freefall).
									; In Freefall, input is skipped (No Control).
	bvc MesaSideScreenInputHandler	; Branch if Overflow clear (Bit 6?).
	dec indyHorizPos				; Decrement Indy X (Slide left?).
	bne MesaSideScreenUpdateState	; Unconditional branch.

MesaSideScreenInputHandler:
	lda frameCount					; Get current frame count.
	ror								; Rotate bit 0 into Carry.
	bcc MesaSideScreenUpdateState	; Branch on even frame (Limit speed).
									; Parachute allows steering!
	lda SWCHA						; Get Joystick Inputs (Right Joystick controls Indy).
	sta inputFlags					; Store input.
	ror								; Bit 0 (P1 Up) -> Carry.
	ror								; Bit 1 (P1 Down) -> Carry.
	ror								; Bit 2 (P1 Left) -> Carry.
	bcs MesaSideScreenRightInputHandler; Branch if Left NOT pressed (Active Low, Carry Set = 1).
	dec indyHorizPos				; Move Left.
	bne MesaSideScreenUpdateState	; Unconditional branch.

MesaSideScreenRightInputHandler:
	ror								; Bit 3 (P1 Right) -> Carry.
	bcs MesaSideScreenUpdateState	; Branch if Right NOT pressed.
	inc indyHorizPos				; Move Right.

MesaSideScreenUpdateState:
	lda #$02						; Load 2.
	and mesaSideState				; Check Bit 1 of state.
	bne MesaSideScreenVerticalStateHandler; Branch if set.
	sta eventState					; Clear eventState if bit 1 was clear (A is 0).
	lda #$0B						; Load $0B.
	sta p0VertPos					; Set Object Vertical Position? (Previously $CE).

MesaSideScreenVerticalStateHandler:
	ldx indyVertPos					; Get Indy Vertical.
	lda frameCount					; Get Frame Count.
	bit mesaSideState				; Check state.
	bmi MesaSideScreenParachuteDescentUpdate; Branch if Bit 7 set (Parachute Active = Slow Fall).
	cpx #$15						; Compare Y with $15.
	bcc MesaSideScreenParachuteDescentUpdate; Branch if Y < $15 (Top Zone - Fall slow initially?).
	cpx #$30						; Compare Y with $30.
	bcc MesaSideScreenVerticalPositionFinalize; Branch if Y < $30.
	bcs MesaSideScreenVerticalPositionIncrement; Unconditional branch (>= $30).

MesaSideScreenParachuteDescentUpdate:
	ror								; Rotate A (Frame Count).
	bcc MesaSideScreenVerticalPositionFinalize; Branch on even frames (Slower fall: 0.5px/frame).

ReturnToScreenHandlerFromMesaSide:
	jmp	 ReturnToScreenHandlerFromBank1; Return.

MesaSideScreenVerticalPositionIncrement:
	inx								; Increment Y (Accel/Faster fall?).

MesaSideScreenVerticalPositionFinalize:
	inx								; Increment Y (Move Down).
	stx indyVertPos					; Update Indy Y.
	bne ReturnToScreenHandlerFromMesaSide; Return.

BlackMarketScreenHandler:
	lda indyHorizPos				; Get Indy X.
	cmp #$64						; Compare $64 (Decimal 100).
	bcc BlackMarketScreenLunaticZoneHandler; Branch if < 100 (Left Side/Lunatic Zone).
	rol blackMarketState			; Rotate Black Market state left.
	clc								; Clear Carry.
	ror blackMarketState			; Rotate right (preserves high bit?).
	bpl ReturnToScreenHandlerFromBlackMarket; Branch if positive.
	
BlackMarketScreenLunaticZoneHandler:
	cmp #$2C						; Compare $2C (Decimal 44). The "Invisible Line".
	beq BlackMarketScreenBribeCheck	; Branch if equal (Indy is exactly at the line).
	lda #$7F						; Load $7F.
	sta snakeDungeonY				; Set Lunatic/Blocker Y to Center ($7F).
	bne ReturnToScreenHandlerFromBlackMarket; Return.
	
BlackMarketScreenBribeCheck:
	bit blackMarketState			; Check Black Market state (Did we drop Gold?).
	bmi ReturnToScreenHandlerFromBlackMarket; Branch if Bit 7 set (Condition not met/No Bribe?).
	lda #$30						; Load $30 (Decimal 48).
	sta indyHorizPos				; Teleport Indy to X=48 (Past the Lunatic/Line!).
	ldy #$00						; Clear Y.
	sty snakeDungeonY				; Clear Lunatic Y (Remove Lunatic?).
	ldy #$7F						; Load $7F.
	sty $DC							; Set temp DC.
	sty snakeVertPos				; Set snakeVertPos.
	inc indyHorizPos				; Increment Indy X (49).
	lda #$80						; Set Bit 7.
	sta majorEventFlag 				; Trigger Major Event (Won Black Market / Bribed Lunatic).
ReturnToScreenHandlerFromBlackMarket:
	jmp	 ReturnToScreenHandlerFromBank1; Return.
	
TreasureRoomScreenHandler:
	; --------------------------------------------------------------------------
	; TREASURE ROOM HANDLER
	; Handles the appearance of items (Medallion, Key, etc.) in the baskets.
	; --------------------------------------------------------------------------
	ldy objectVertOffset			; Get Offset (Used as a state/delay counter?).
	dey								; Decrement.
	bne ReturnToScreenHandlerFromTreasureRoom; If not 1, return (Delay loop).
	
	lda treasureIndex				; Get Treasure Index/State.
	and #$07						; Mask bits 0-2.
	bne TreasureRoomScreenStateFinalize; Branch if not 0 (Item processing active).

	; --------------------------------------------------------------------------
	; ITEM CYCLE LOGIC
	; Uses the game timer to cycle through potential items to display.
	; --------------------------------------------------------------------------
	lda #$40						; Load Bit 6 ($40).
	sta screenEventState			; Update screen event state.
	
	lda secondsTimer				; Get Global Timer.
	lsr								; Divide by 32 (Shift Right 5 times).
	lsr
	lsr
	lsr
	lsr
	tax								; Use result as Index.
	ldy TreasureRoomScreenStateIndexLFCDC,x; Lookup Index from table.
	ldx TreasureRoomScreenStateIndexTable,y; Lookup "Basket State" / Item ID.
	sty $84							; Store Y in temp $84.
	
	jsr	 TreasureRoomBasketItemAwardHandler; Check if Item is Valid/Available.
	bcc TreasureRoomScreenStateUpdate; If Carry Clear (Valid), Update State.

TreasureRoomScreenAdvanceState:
	inc objectVertOffset			; Increment offset (skip/reset).
	bne ReturnToScreenHandlerFromTreasureRoom; Return.
	brk								; Break (Should not happen if logic holds).

TreasureRoomScreenStateUpdate:
	ldy $84							; Restore Y (Table Index).
	tya								; Move to A.
	ora treasureIndex				; Combine with current Index.
	sta treasureIndex				; Update Treasure Index.
	
	lda TreasureRoomScreenStateCEValues,y; Get Vertical Position for Item.
	sta p0VertPos					; Set P0 Vertical Position (Item).
	
	lda TreasureRoomScreenStateDFValues,y; Get Graphic Offset for Item.
	sta objectVertOffset			; Set Graphic Offset.
	bne ReturnToScreenHandlerFromTreasureRoom; Return.

TreasureRoomScreenStateFinalize:
	cmp #$04						; Check State Phase.
	bcs TreasureRoomScreenAdvanceState; Branch if >= 4 (Reset).
	rol treasureIndex				; Rotate State.
	sec								; Set Carry.
	ror treasureIndex				; Rotate State.
	bmi TreasureRoomScreenAdvanceState; Branch if Negative.

ReturnToScreenHandlerFromTreasureRoom:
	jmp	 ReturnToScreenHandlerFromBank1; Return.
	
MapRoomScreenHandler:
	; --------------------------------------------------------------------------
	; MAP ROOM / ROOM OF SHINING LIGHT SCENE
	; --------------------------------------------------------------------------
	ldy #$00						; Initialize Y (loop/index).
	sty snakeDungeonY				; Clear snake vertical position (Snakes don't appear in Map Room).
	ldy #$7F						; Initialize Y to Off-screen/Default value.
	sty p0SpriteHeight				; Reset Player 0 sprite height.
	sty snakeVertPos				; Ensure snake is off-screen.
	
	; Lock Indy's Horizontal Position
	; In this screen, the player controls the "Staff" placement vertically.
	; X is fixed to the center ($71).
	lda #$71
	sta indyHorizPos				
	
	ldy #$4F						; Load "Correct Alignment" Object Offset (Visual state for correct placement).
	lda #$3A
	cmp indyVertPos					; Check if Indy (Staff) is at Y = $3A (The Hole).
	bne MapRoomScreenSpecialStateHandler; If not at correct height, branch to failure case.
	
	lda selectedInventoryId			; Check current inventory.
	cmp #ID_INVENTORY_KEY			; Is the Key/Staff selected?
	beq MapRoomScreenFinalizeState	; If YES, jump to Success graphics state.
	
	; Secondary check (Logic unreachable if X forced to $71?)
	lda #$5E						
	cmp indyHorizPos				
	beq MapRoomScreenFinalizeState	

MapRoomScreenSpecialStateHandler:
	ldy #$0D						; Load "Failure/Empty" Object Offset.

MapRoomScreenFinalizeState:
	sty objectVertOffset			; Update graphic offset based on placement check (Hole vs Staff?).
	
	; --------------------------------------------------------------------------
	; SUN / TIME OF DAY CYCLE
	; --------------------------------------------------------------------------
	; Uses secondsTimer to simulate the sun moving/intensity changing.
	; Creates a ping-pong value 0..15..0 for P0 Vertical Position (Sun Object).
	lda secondsTimer				
	sec
	sbc #$10						; Subtract 16.
	bpl MapRoomScreenSecondsTimerHandler; If Timer >= 16, skip inversion (Phase 2).
	eor #$FF						; Invert bits (Phase 1: 0..15 -> becomes 15..0 descent).
	sec
	adc #$00						; 2's complement adjust.

MapRoomScreenSecondsTimerHandler:
	cmp #$0B						; Cap the sun value at 11.
	bcc MapRoomScreenFinalizeTimer	
	lda #$0B						

MapRoomScreenFinalizeTimer:
	sta p0VertPos					; Set Sun vertical position ($CE).
	
	bit mapRoomState				; Check State Flags.
	bpl MapRoomScreenFinalizePositionState; Branch if Bit 7 clear (Not active?).
	
	; --------------------------------------------------------------------------
	; REVEAL ARK LOCATION (THE BEAM)
	; --------------------------------------------------------------------------
	; If the Sun is at the correct angle (< 8) and the Head of Ra is equipped:
	cmp #$08						; Check Sun "Height" / Time.
	bcs MapRoomScreenFinalizeTimerValue; If Sun is too "high" (>=8), skip reveal (No Beam).
	
	ldx selectedInventoryId
	cpx #ID_INVENTORY_HEAD_OF_RA	; Is the Head of Ra selected?
	bne MapRoomScreenFinalizeTimerValue; If not, skip reveal.
	
	stx headOfRaMapRoomBonus		; Set Flag: Player used Head of Ra (Bonus!).
	
	lda #$04						; Flicker/Shimmer Mask.
	and frameCount
	bne MapRoomScreenFinalizeTimerValue; Skip 3 out of 4 frames (Shimmer effect).
	
	; Calculate Beam Endpoint based on Secret Ark Location.
	lda arkLocationRegionId				; Get Ark Location ID (Randomized at start).
	and #$0F						; Mask lower nibble.
	tax								; Use as index.
	lda MapRoomweaponHorizPosTable,x; Lookup Beam X Coordinate from table.
	sta weaponHorizPos				; Set "Weapon" (Beam) X.
	lda MapRoomweaponVertPosTable,x	; Lookup Beam Y Coordinate from table.
	bne MapRoomScreenFinalizeBulletOrWhipPosition; Branch to set Y and Draw.

MapRoomScreenFinalizeTimerValue:
	lda #$70						; Default Y position (off screen or neutral?)

MapRoomScreenFinalizeBulletOrWhipPosition:
	sta weaponVertPos				; Update Beam/Weapon Y Position

MapRoomScreenFinalizePositionState:
	; --------------------------------------------------------------------------
	; STATE TRACKING
	; Debounces or tracks if the player is consistently in the slot
	; --------------------------------------------------------------------------
	rol mapRoomState				; Shift old state
	lda #$3A
	cmp indyVertPos					; Check Y again
	bne MapRoomScreenFinalizePositionFlags
	cpy #$4F						; Check if we were in "Success" graphics mode
	beq MapRoomScreenFinalizePositionBoundary
	lda #$5E
	cmp indyHorizPos				; Check X
	bne MapRoomScreenFinalizePositionFlags

MapRoomScreenFinalizePositionBoundary:
	sec								; Set Carry (Input Present)
	ror mapRoomState				; Shift into State
	bmi ReturnToScreenHandlerFromMapRoom; If result is Negative (Bit 7 set), Return
	
MapRoomScreenFinalizePositionFlags:
	clc								; Clear Carry (Input Absent)
	ror mapRoomState				; Shift into State

ReturnToScreenHandlerFromMapRoom:
	jmp	 ReturnToScreenHandlerFromBank1; Return.
	
TempleEntranceScreenHandler:
	; --------------------------------------------------------------------------
	; TEMPLE ENTRANCE / TIMEPIECE ROOM
	; --------------------------------------------------------------------------
	lda #PICKUP_ITEM_STATUS_TIME_PIECE ; Load Time Piece mask.
	and pickupItemsStatus			; Check if player already has it.
	bne TempleEntranceScreenTimePieceTakenHandler; Branch if Time Piece taken.
	
	; --------------------------------------------------------------------------
	; TIMEPIECE PRESENT STATE
	; --------------------------------------------------------------------------
	; Force Indy ($C9) to Center Screen ($4C).
	; Note: This effectively snaps the player to the center upon entry/frame.
	; Since the Timepiece is also positioned here, this likely ensures instant
	; interaction/pickup or guides the player to it.
	lda #$4C						
	sta indyHorizPos				

	; Reuse snakeDungeonY ($D2) for Timepiece Vertical Position ($2A)
	lda #$2A						
	sta snakeDungeonY				
	
	; Set Timepiece Graphics (Ball Sprite)
	; The DrawPlayfieldKernel uses these pointers to modulate ENABL/HMBL
	lda #<TimeSprite				
	sta timepieceGfxPtrs			
	lda #>TimeSprite				
	sta timepieceGfxPtrs + 1		
	bne TempleEntranceScreenFinalizeState; Continue
	
TempleEntranceScreenTimePieceTakenHandler:
	lda #$F0						; Move "Timepiece/Snake" Offscreen vertically
	sta snakeDungeonY				

TempleEntranceScreenFinalizeState:
	; --------------------------------------------------------------------------
	; ROOM GRAPHICS SETUP
	; Uses entranceRoomEventState to determine the graphical layout (Doors?)
	; Maps state to P0 Graphics Pointers (Walls/Doors).
	; --------------------------------------------------------------------------
	lda entranceRoomEventState		; Get event state.
	and #$0F						; Mask lower nibble.
	beq ReturnToScreenHandlerFromBank1; Branch if 0 (Invalid?).
	sta $DC							; Store state.
	ldy #$14						; P0 Height/Timing constant?
	sty p0VertPos					; Set P0 Vertical Position (Top of walls?) (Label was $CE)
									; FIX_ME: Previous labels called this $CE, usually p0VertPos.
	ldy #$3B						; P0 Graphics Data Threshold/Setup?
	sty p0GfxData					
	iny								; $3C
	sty snakeDungeonState			; Reuse snake variable for room state?
	
	; Calculate P0 Graphics Pointer based on State
	; $C1 - State -> P0 Ptr Low
	lda #$C1						
	sec								
	sbc $DC							
	sta p0GfxPtrs					; Set P0 Graphics Pointer Low ($DD)
	bne ReturnToScreenHandlerFromBank1; Return via standard exit

	
RoomOfShiningLightScreenHandler:
	lda frameCount					; Get current frame count.
	and #$18						; Mask for update rate.
	adc #<ShiningLightSprites		; Add sprite base.
	sta p0GfxPtrs					; Set P0 GFX Low.
	lda frameCount					; Get frame count.
	and #7							; Screen update every 8 frames?
	bne RoomOfShiningLightScreenFinalizeInput; Branch if not frame.
	ldx #<p0VertPos - objectVertPositions; Index X for P0.
	ldy #<indyVertPos - objectVertPositions; Index Y for Indy.
	lda indyVertPos					; Get Indy's vertical position.
	cmp #58							; Compare 58.
	bcc RoomOfShiningLightScreenFinalizeState; Branch if Y < 58.
	lda indyHorizPos				; Get Indy's horizontal position.
	cmp #$2B						; Compare $2B.
	bcc RoomOfShiningLightScreenSpecialStateHandler; Branch if < $2B.
	cmp #$6D						; Compare $6D.
	bcc RoomOfShiningLightScreenFinalizeState; Branch if < $6D.

RoomOfShiningLightScreenSpecialStateHandler:
	ldy #$05						; Load 5.
	lda #$4C						; Load $4C.
	sta unused_CD_WriteOnly				; Set Temp.
	lda #$0B						; Load $0B.
	sta targetVertPos				; Set Temp 2.

RoomOfShiningLightScreenFinalizeState:
	jsr	 UpdateObjectPositionHandler; Update Position.

RoomOfShiningLightScreenFinalizeInput:
	ldx #$4E						; Load $4E.
	cpx indyVertPos					; Compare Indy Y.
	bne ReturnToScreenHandlerFromBank1; Branch if !=.
	ldx indyHorizPos				; Get Indy X.
	cpx #$76						; Compare $76.
	beq RoomOfShiningLightScreenFinalizePenalty; Branch if == $76.
	cpx #$14						; Compare $14.
	bne ReturnToScreenHandlerFromBank1; Branch if != $14.

RoomOfShiningLightScreenFinalizePenalty:
	lda SWCHA						; Read joystick.
	and #P1_NO_MOVE					; Mask non-move bits (actually check if P1 is moving?).
	cmp #(MOVE_DOWN >> 4)			; Check Down. (Shifted because P1 is high nibble?).
	bne ReturnToScreenHandlerFromBank1; Branch if not Down.
	sta shiningLightPenalty			; Set penalty.
	lda #$4C						; Load $4C.
	sta indyHorizPos				; Reset Indy X?
	ror entranceRoomEventState		; Rotate Event State (Modify flags).
	sec								; Set Carry.
	rol entranceRoomEventState		; Rotate Left (Set bit 0?).

ReturnToScreenHandlerFromBank1:
	lda #<SetupScreenVisualsAndObjects; Load Return Address Low.
	sta bankSwitchJMPAddr			; Store Return Addr Low.
	lda #>SetupScreenVisualsAndObjects; Load Return Address High.
	sta bankSwitchJMPAddr + 1		; Store Return Addr High.
	jmp JumpToBank0					; Jump to Bank 0.
	
EntranceRoomScreenHandler:	 
	lda #$40						; Load $40.
	sta screenEventState			; Set screenEventState.
	bne ReturnToScreenHandlerFromBank1; Unconditional branch.
	
DisplayKernel:
	sta WSYNC						; Wait for Sync.
;--------------------------------------
	sta HMCLR						; Clear Horizontal Motion.
	sta CXCLR						; Clear Collisions.
	ldy #$FF						; Load $FF.
	sty PF1							; Set PF1 (Full Right).
	sty PF2							; Set PF2 (Full Left).
	ldx currentRoomId				; Get Room ID.
	lda RoomPF0GraphicData,x		; Get PF0 Data.
	sta PF0							; Set PF0.
	iny								; Y=0.
	sta WSYNC						; Wait for Sync.
;--------------------------------------
	sta HMOVE						; Move Objects.
	sty VBLANK						; Enable TIA (Y=0, VBLANK Off).
	sty scanlineCounter				; Zero Scanline Counter.
	cpx #ID_MAP_ROOM				; Check Map Room.
	bne DisplayKernelMapRoomHandler	; Branch if not Map Room.
	dey								; Y=$FF.
	
DisplayKernelMapRoomHandler:
	sty ENABL						; Enable Ball (If Y=$FF).
	cpx #ID_ARK_ROOM				; Check Ark Room.
	beq DisplayKernelArkRoomHandler	; Branch if Ark Room.
	bit majorEventFlag 				; Check Major Event.
	bmi DisplayKernelArkRoomHandler	; Branch if Negative (Bit 7 Set).
	ldy SWCHA						; Read Joystick.
	sty REFP1						; Set Reflection P1 (Why? Control P1 direction maybe).

DisplayKernelArkRoomHandler:
	sta WSYNC						; Wait for Sync.
;--------------------------------------
	sta HMOVE						; Move Objects.
	sta WSYNC						; Wait for Sync.
;--------------------------------------
	sta HMOVE						; Move Objects.
	ldy currentRoomId				; Get Room ID.
	sta WSYNC						; Wait for Sync.
;--------------------------------------
	sta HMOVE						; Move Objects.
	lda RoomPF1GraphicData,y		; Get PF1 Data.
	sta PF1							; Set PF1.
	lda RoomPF2GraphicData,y		; Get PF2 Data.
	sta PF2							; Set PF2.
	ldx KernelJumpTableIndex,y		; Get Kernel Index.
	lda KernelJumpTable + 1,x		; Get High Byte.
	pha								; Push High.
	lda KernelJumpTable,x			; Get Low Byte.
	pha								; Push Low.
	lda #0							; Load 0.
	tax								; X = 0.
	sta $84							; Clear $84 (Maybe some temp?).
	rts								; Jump to Kernel (RTS pops address-1, so table should be address-1).

TreasureRoomBasketItemAwardHandler:
	; --------------------------------------------------------------------------
	; BASKET CHECKER
	; Checks if an item (indexed by X) can be displayed/picked up.
	; --------------------------------------------------------------------------
	lda TreasureRoomBasketItemAwardTable,x; Get possible Item ID for this slot.
	lsr								; Shift Right (Bit 0 into Carry -> Odd/Even check).
	tay								; Transfer to Y (Index for Mask Table).
	lda TreasureRoomBasketItemAwardBitMaskTable,y; Get Bitmask for this item type.
	bcs TreasureRoomBasketItemAwardPickupHandler; If Carry Set (Odd Index?), check Pickup Status.
	
	; Even Index? Check Basket Availability status.
	and basketItemsStatus			; Check if the item is essentially "in stock".
	beq TreasureRoomBasketItemAwardReturn; If 0 (Not in basket), Return Failure.
	sec								; Set Carry (Success - Item Available).

TreasureRoomBasketItemAwardReturn:
	rts								; Return.

TreasureRoomBasketItemAwardPickupHandler:
	; Check if Player already has the item.
	and pickupItemsStatus			; Mask with Pickup Status.
	bne TreasureRoomBasketItemAwardReturn; If result != 0 (Already have it), Return Failure.
	clc								; Clear Carry (Success - Item Available to take).
	rts								; Return.

UpdateObjectPositionHandler:
	cpy #<indyVertPos - objectVertPositions; Check if Target is Indy (Offset).
	bne UpdateObjectVerticalPositionHandler; Branch if not Indy.
	lda indyVertPos					; Get Indy's Vertical Position.
	bmi UpdateObjectVerticalPositionDecrementHandler; Branch if negative (or > 127).

UpdateObjectVerticalPositionHandler:
	lda objectVertPositions,x		; Get Follower Y.
	cmp objectVertPositions,y		; Compare Target Y.
	bne UpdateObjectVerticalPositionIncrementHandler; Branch if different.
	cpy #$05						; Check Bounds/Type?
	bcs UpdateObjectHorizontalPositionHandler; Branch if >= 5.

UpdateObjectVerticalPositionIncrementHandler:
	bcs UpdateObjectVerticalPositionDecrementHandler; Branch if Follower > Target (Move Up/Dec).
	inc objectVertPositions,x		; Increment Follower Y (Move Down).
	bne UpdateObjectHorizontalPositionHandler; Unconditional branch (unless 0).

UpdateObjectVerticalPositionDecrementHandler:
	dec objectVertPositions,x		; Decrement Follower Y (Move Up).

UpdateObjectHorizontalPositionHandler:
	lda objectHorizPositions,x		; Get Follower X.
	cmp objectHorizPositions,y		; Compare Target X.
	bne UpdateObjectHorizontalPositionIncrementHandler; Branch if different.
	cpy #$05						; Check Bounds?
	bcs UpdateObjectHorizontalPositionReturn; Branch if >= 5.

UpdateObjectHorizontalPositionIncrementHandler:
	bcs UpdateObjectHorizontalPositionDecrementHandler; Branch if Follower > Target (Move Left/Dec).
	inc objectHorizPositions,x		; Increment Follower X (Move Right).

UpdateObjectHorizontalPositionReturn:
	rts								; Return.

UpdateObjectHorizontalPositionDecrementHandler:
	dec objectHorizPositions,x		; Decrement Follower X (Move Left).
	rts								; Return.

UpdateObjectPositionBoundaryHandler:
	lda objectVertPositions,x		; Get Object Y.
	cmp #$53						; Compare $53 (Bottom/Top Boundary?).
	bcc UpdateObjectPositionBoundaryClamp; Branch if < $53.

UpdateObjectPositionBoundaryClampHandler:
	rol arkLocationRegionId,x				; Rotate State/Flags.
	clc								; Clear Carry.
	ror arkLocationRegionId,x				; Rotate Back (Clear Bit 7?).
	lda #$78						; Load $78.
	sta objectVertPositions,x		; Reset Object Y.
	rts								; Return.

UpdateObjectPositionBoundaryClamp:
	lda objectHorizPositions,x		; Get Object X.
	cmp #$10						; Compare $10 (Left Boundary?).
	bcc UpdateObjectPositionBoundaryClampHandler; Branch if < $10.
	cmp #$8E						; Compare $8E (Right Boundary?).
	bcs UpdateObjectPositionBoundaryClampHandler; Branch if >= $8E.
	rts								; Return.

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
	
MapRoomweaponHorizPosTable:
	.byte $63,$62,$6B,$5B,$6A,$5F,$5A,$5A,$6B,$5E,$67,$5A,$62,$6B,$5A,$6B
	
MapRoomweaponVertPosTable:
	.byte $22,$13,$13,$18,$18,$1E,$21,$13,$21,$26,$26,$2B,$2A,$2B,$31,$31
	
KernelJumpTable
	.word JumpIntoStationaryPlayerKernel - 1
	.word DrawPlayfieldKernel - 1
	.word ThievesDenWellOfSoulsScanlineHandler - 1
	.word ArkRoomKernel - 1
	
SpiderRoomPlayer0SpriteTable:
	.byte $AE,$C0,$B7,$C9
	
;------------------------------------------------------------
; OverscanSoundEffectTable
;
; Frequency data for the "Snake Charmer Song".
; Played when channel control is $84 (Square Wave).
; Indexed by (frameCount / 16).
;
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
	
Copyright_3
	; Used to display "(c) 1982 Atari" in the inventory strip
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
	; Used to display "Inc. All Rights" (or similar) in the inventory strip
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
	; The top line of the copyright notice
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
	
;------------------------------------------------------------
; OverscanSpecialSoundEffectTable
;
; Frequency data for the "Main Theme" (Raiders March).
; Played when channel control is $9C (Pure Tone).
; Indexed by `soundEffectTimer` (counts down from $17).
;
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
	.word MesaSideScreenHandler - 1			  ; mesa side  (Fixed: Was ThievesDenScreenIdleHandler)
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
	lda arkLocationRegionId,x	  ;4
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
	; --------------------------------------------------------------------------
	; ENTRANCE ROOM PLAYER 0 GRAPHICS (THE ROCK)
	; Format: Command Stream.
	; - Bytes with Bit 7 CLEAR ($00-$7F) are drawn as Graphics (GRP0).
	; - Bytes with Bit 7 SET ($80-$FF) are Commands:
	;   - $80 | (Color >> 1): Set COLUP0.
	;   - $81 | (HMOVE >> 1): Set HMP0.
	;
	; Note: The bit pattern ($70, $5F, $72, $05) creates the "Rock" sprite.
	; While some may see this resembling a key side-on or abstractly, 
	; the color is explicitly set to Grey (Black+12), and the game documentation
	; identifies the stationary object in the Entrance Room as a rock covering the whip.
	; The Whip itself is likely either part of this sprite (hidden or state-changed)
	; or rendered via another mechanism (missiles or playfield).
	; But given the grey color, this specific table entry is the Rock.
	; --------------------------------------------------------------------------
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
	
	.org BANK1TOP + 4096 - 6, 0
	.word BANK1Start
	.word BANK1Start
	.word BANK1Start
