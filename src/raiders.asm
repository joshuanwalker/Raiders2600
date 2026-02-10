
; ***  R A I D E R S  O F  T H E  L O S T  A R K  ***
; Copyright 1982 Atari, Inc.
; Designer: Howard Scott Warshaw
; Artist:	Jerome Domurat

; Originally Analyzed, labeled and commented
;  by Dennis Debro - Aug. 8, 2018
; Furthur coding and comments
;  by Halkun
;	Last Update: Feb. 9th, 2026
;
;
; ==============================================================================
; = THIS REVERSE-ENGINEERING PROJECT IS BEING SUPPLIED TO THE PUBLIC DOMAIN		=
; = FOR EDUCATIONAL PURPOSES ONLY. THOUGH THE CODE WILL ASSEMBLE INTO THE		=
; = EXACT GAME ROM, THE LABELS AND COMMENTS ARE THE INTERPRETATION OF MY OWN	=
; = AND MAY NOT REPRESENT THE ORIGINAL VISION OF THE AUTHOR.					=
; =																				=
; = THE ASSEMBLED CODE IS  1982, ATARI, INC.									=
; =																				=
; ==============================================================================
;
; This is Howard Scott Warshaw's second game with Atari.

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
PURPLE					= $60
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

SWCHA			= $0280 ; 11111111	Port A; input or output	 (read or write)
SWCHB			= $0282 ; 11111111	Port B; console switches (read only)
INTIM			= $0284 ; 11111111	Timer output (read only)
TIM64T			= $0296 ; 11111111	set 64 clock interval (53.6 usec/interval)


;===============================================================================
; F R A M E - T I M I N G S
;===============================================================================
;	NTSC version for now

VBLANK_TIME				= 44
OVERSCAN_TIME			= 36

;===============================================================================
; M U S I C
;===============================================================================
RAIDERS_MARCH			= $9C
SNAKE_CHARM_SONG		= $84

;============================================================================
; Z P - V A R I A B L E S
;============================================================================

;----------------------------------------------------------------------------
; System & Timers
;----------------------------------------------------------------------------
scanline				= $80	; Current scanline counter for the kernel
currentRoomId			= $81	; ID of the room Indy is currently in (e.g., ID_ENTRANCE_ROOM)
frameCount				= $82	; Master frame counter, used for animation timing and random seeds
timeOfDay				= $83	; Clock/Sun position (Manual: "Timepiece... shows you the current time")

; ---- General Purpose Temps / Bank-Switch Trampoline ----
; $84-$89 serve as general-purpose scratch registers throughout the code.
; They are also used as a 6-byte executable RAM stub for bank switching:
;   $84: LDA opcode ($AD)     $87: JMP opcode ($4C)
;   $85: strobe addr lo       $88: jump target lo
;   $86: strobe addr hi       $89: jump target hi
; The trampoline is only constructed immediately before execution,
; so these locations are safely reused between bank switches.
temp0					= $84	; (c) General purpose temp
temp1					= $85	; (c) General purpose temp
temp2					= $86	; (c) General purpose temp
temp3					= $87	; (c) General purpose temp
temp4					= $88	; (c) General purpose temp
temp5					= $89	; (c) General purpose temp

playerInputState		= $8a	; Input flags (Direction + Button state processing)

;----------------------------------------------------------------------------
; Game Logic & State
;----------------------------------------------------------------------------
activeMesaID			= $8b	; The ID of the Mesa the player is currently exploring/grappled to.
secretArkMesaID			= $8c	; The specific Mesa ID where the Ark is hidden.
grappleWhipState		= $8d	; State machine for grapple swing / whip attack sequence
m0PosYShadow			= $8e	; Shadow copy of Missile 0 Y position (Webs/Swarm)
weaponStatus			= $8f	; Status of Indy's weapon (Bit 7: Active/Cooldown)
unused90				= $90	; Screen flags cleared on room change (result unused)
inputActionState		= $91	; Combined joystick direction + collision response flags
indyDir					= $92	; Direction Indy is facing (for Sprite selection)
screenEventState		= $93	; Flags for screen events (e.g., Snake/Fly active)
roomPFControlFlags		= $94	; Playfield priority and reflection flags (CTRLPF)
pickupStatusFlags		= $95	; Bitmask: Items taken in current room (prevents infinite pickup)
dirtPileGfxState		= $96	; Graphics pointer offset for dirt pile sprite (shrinks as Indy digs)
digSpeedLimiter			= $97	; Overflow counter limiting dig speed (digs only on wrap to 0)
swarmEventCounter		= $98	; Countdown for tsetse swarm spawns in Valley of Poison
screenInitFlag			= $99	; Non-zero if the screen needs initialization logic
grenadeState			= $9a	; Status: Bit 7=Active, Bit 6=Wall Effect Trigger
grenadeDetonateTime		= $9b	; timeOfDay value at which active grenade detonates
arkRoomStateFlag		= $9c	; bit7 = RESET enabled & Ark hidden; bit7 clear = Ark visible & RESET ignored.
indyStatus				= $9d	; Flag bits for Indy's current status and major events:
adventurePoints			= $9e	; (Manual: "Adventure Points") Score/Pedestal Height
livesLeft				= $9f	; (Manual: Starts with 3 lives)
bulletCount				= $a0	; (Manual: Max 6 bullets)
eventTimer				= $a1	; General event timer (Tsetse paralysis / Cutscene delays)
soundChan0Effect		= $a2	; Sound effect control byte for TIA channel 0
soundChan1Effect		= $a3	; Sound effect control byte for TIA channel 1
musicNoteIndex			= $a4	; Index into Raiders March frequency table (counts down)

;----------------------------------------------------------------------------
; Scoring & Bonuses (Used in getFinalScore)
; Lower adventurePoints = better ranking on the pedestal.
; Bonuses are SUBTRACTED (reward), penalties are ADDED (punishment).
;----------------------------------------------------------------------------
grenadeOpeningPenalty	= $a5	; Penalty: Blasted Entrance Room wall open (2 pts)
escapePrisonPenalty		= $a6	; Penalty: Used secret exit in Shining Light dungeon (13 pts)
findingArkBonus			= $a7	; Bonus: Found the Ark (10 pts)
usingParachuteBonus		= $a8	; Bonus: Successfully used Parachute (3 pts)
ankhUsedBonus			= $a9	; Bonus: Warped to Mesa via Ankh (9 pts)
yarFoundBonus			= $aa	; Bonus: Found Yar Easter Egg (5 pts, also gates HSW initials)
mapRoomBonus			= $ab	; Bonus: Used Head of Ra in Map Room (14 pts)
thiefShotPenalty		= $ac	; Penalty: Shot the thief (4 pts)
mesaLandingBonus		= $ad	; Bonus: Reached Well of Souls via Mesa (3 pts)
unusedBonus				= $ae	; Unused scoring slot (never written, always 0)

; ---- Per-Room State Array ----
; $af-$b6 form an indexed array: roomStateBase + roomId
; Accessed as treasureRoomState,x where x = room ID.
treasureRoomState		= $af	; State: Treasure Room item cycle (bits 0-2=phase, bit 7=spawned)
marketplaceState		= $b0	; Marketplace room state (unused, no persistent state needed)
entranceRoomState		= $b1	; State: Whip taken (bit 0), wall blown open (bit 1)
blackMarketState		= $b2	; State: Bribe status (bit 7), coin/shovel carrying flags
mapRoomState			= $b3	; State: Indy in view zone (bit 7) / Head of Ra beam activation
mesaSideState			= $b4	; State: Parachute (bit 7), landing (bit 6), gravity/grapple (bit 1)
entranceRoomEventState	= $b5	; State: Entrance Room wall debris animation (lower nibble)
spiderRoomState			= $b6	; State: Animation timer (bits 0-2) / Aggressive mode (bit 7)

;----------------------------------------------------------------------------
; Inventory System
; Indy carries up to 6 items. Each slot is a 16-bit pointer to an
; 8-byte sprite in ROM. The Lo byte encodes item identity:
;   itemId = (slotLo - <inventorySprites) / HEIGHT_ITEM_SPRITES
; Slots are accessed two ways:
;   Rendering:  (invSlotLo),y / (invSlotLo2),y  — indirect indexed per-slot
;   Management: invSlotLo,x  (x = 0,2,4,6,8,10) — array base with byte offset
;----------------------------------------------------------------------------
invSlotLo				= $b7	; Inventory Slot 1 (Sprite Ptr Low)  — also array base
invSlotHi				= $b8	; Inventory Slot 1 (Sprite Ptr High)
invSlotLo2				= $b9	; Inventory Slot 2 (Sprite Ptr Low)
invSlotHi2				= $ba	; Inventory Slot 2 (Sprite Ptr High)
invSlotLo3				= $bb	; Inventory Slot 3 (Sprite Ptr Low)
invSlotHi3				= $bc	; Inventory Slot 3 (Sprite Ptr High)
invSlotLo4				= $bd	; Inventory Slot 4 (Sprite Ptr Low)
invSlotHi4				= $be	; Inventory Slot 4 (Sprite Ptr High)
invSlotLo5				= $bf	; Inventory Slot 5 (Sprite Ptr Low)
invSlotHi5				= $c0	; Inventory Slot 5 (Sprite Ptr High)
invSlotLo6				= $c1	; Inventory Slot 6 (Sprite Ptr Low)
invSlotHi6				= $c2	; Inventory Slot 6 (Sprite Ptr High)
selectedItemSlot		= $c3	; Byte offset (0,2,4,6,8,10) into invSlot array for selected item
inventoryItemCount		= $c4	; Number of items currently held (0-6)
selectedInventoryId		= $c5	; ID of the item currently selected (e.g. ID_INVENTORY_WHIP)
basketItemStatus		= $c6	; Bitmask: spawnable item collection state (1=taken, 0=available)
									;   "Basket" items are those found at fixed world locations:
									;   Marketplace baskets (grenade, revolver, key) and the
									;   Treasure Room cycling item. These can respawn when dropped.
pickupItemStatus		= $c7	; Bitmask: unique item collection state (1=found)
									;   "Pickup" items are one-of-a-kind items found in the world:
									;   whip, shovel, head of Ra, timepiece, hourglass, ankh, chai.

;----------------------------------------------------------------------------
; Object Positioning (Kernel Variables)
; Two parallel arrays for TIA object positions:
;   X array: p0PosX[0..4] = $c8-$cc  (P0, P1, M0, M1, BL)
;   Y array: p0PosY[0..4] = $ce-$d2  (P0, P1, M0, M1, BL)
; Index 5 ($cd/$d3) is a virtual slot — the static AI chase target
; used by updateMoveToTarget when Y=5.
;----------------------------------------------------------------------------
p0PosX					= $c8	; [0] Player 0 (Enemy/Object) X Position
indyPosX				= $c9	; [1] Player 1 (Indy) X Position
m0PosX					= $ca	; [2] Missile 0 (Web/Swarm) X Position
weaponPosX				= $cb	; [3] Missile 1 (Whip/Bullet/Grapple) X Position
ballPosX				= $cc	; [4] Ball X Position (Snake body / Timepiece / Blocker)
targetPosX				= $cd	; [5] AI chase target X (static waypoint for updateMoveToTarget)
p0PosY					= $ce	; [0] Player 0 Y Position
indyPosY				= $cf	; [1] Player 1 (Indy) Y Position
m0PosY					= $d0	; [2] Missile 0 Y Position
weaponPosY				= $d1	; [3] Missile 1 (Weapon) Y Position
ballPosY				= $d2	; [4] Ball Y Position (Snake body / Timepiece / Blocker)
targetPosY				= $d3	; [5] AI chase target Y (static waypoint for updateMoveToTarget)
kernelRenderState		= $d4	; Room-specific render state (snake wiggle / dungeon wall offset / thief FSM)
snakePosY				= $d5	; Snake/Ball coarse-Y draw threshold for kernel scanline check
kernelDataPtrLo			= $d6	; Kernel secondary data pointer Lo (snake motion / thief color / timepiece gfx)
kernelDataPtrHi			= $d7	; Kernel secondary data pointer Hi
kernelDataIndex			= $d8	; Kernel data index (snake motion offset / PF register selector)

;----------------------------------------------------------------------------
; Graphics Pointers & Buffers
;----------------------------------------------------------------------------
indyGfxPtrLo			= $d9	; Indy Sprite Pointer Low
indyGfxPtrHi			= $da	; Indy Sprite Pointer High
indySpriteHeight		= $db	; Height of Indy sprite (Walking vs Standing); 0 = invisible
p0SpriteHeight			= $dc	; Height of Player 0 sprite (overloaded per room)
p0GfxPtrLo				= $dd	; Player 0 Sprite Pointer Low
p0GfxPtrHi				= $de	; Player 0 Sprite Pointer High
roomObjectVar			= $df	; Multi-purpose per-room variable:
								;   Mesa: world scroll offset (camera pan Y)
								;   Thieves' Den: thief state array base ($df-$e3, indexed ,x)
								;   Static rooms: P0 object Y draw boundary
								;   Treasure Room: item cycle countdown
p0DrawStartLine			= $e0	; Scanline boundary for P0 / kernel zone transition
pf1GfxPtrLo				= $e1	; Playfield 1 Graphics Pointer Low
pf1GfxPtrHi				= $e2	; Playfield 1 Graphics Pointer High
pf2GfxPtrLo				= $e3	; Playfield 2 Graphics Pointer Low
pf2GfxPtrHi				= $e4	; Playfield 2 Graphics Pointer High
; ---- Dynamic Graphics Array ($e5-$ea) ----
; 6-byte array with dual purpose:
;   Dungeon rooms: wall segment bitmasks (shot out by weapon)
;   Thief rooms:   per-thief HMOVE X position indices
dynamicGfxData			= $e5	; [0] Dungeon left-wall mask / Thief 0 HMOVE X
dungeonBlock1			= $e6	; [1] Dungeon wall segment 1 / Thief 1 HMOVE X
dungeonBlock2			= $e7	; [2] Dungeon wall segment 2 / Thief 2 HMOVE X
dungeonBlock3			= $e8	; [3] Dungeon wall segment 3 / Thief 3 HMOVE X
dungeonBlock4			= $e9	; [4] Dungeon wall segment 4 / Thief 4 HMOVE X
dungeonBlock5			= $ea	; [5] Dungeon wall segment 5

;----------------------------------------------------------------------------
; Temporary / Room Specific (Context saves for Mesa transitions)
;----------------------------------------------------------------------------
savedScrollOffset		= $eb	; Context save: roomObjectVar (scroll offset) during Mesa transition
savedIndyPosY			= $ec	; Context save: Indy Y position
savedIndyPosX			= $ed	; Context save: Indy X position
thiefPosX				= $ee	; Thief coarse X position array base (5 bytes: $ee-$f2)
; 						  $ef
; 						  $f0
; 						  $f1
; 						  $f2

;--------------------
;sprite heights
;--------------------
HEIGHT_ARK					= 7
HEIGHT_PEDESTAL				= 15
HEIGHT_INDY_SPRITE			= 11
HEIGHT_ITEM_SPRITES			= 8
HEIGHT_PARACHUTING_SPRITE	= 15
HEIGHT_THIEF				= 16
HEIGHT_KERNEL				= 160

;--------------------
; Mesa Consts
;--------------------
MESA_SCROLL_TRIGGER_BOTTOM	= $27
MESA_MAP_MAX_HEIGHT			= $50

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
INDY_CARRYING_WHIP					= %00000001
GRENADE_OPENING_IN_WALL				= %00000010

; Black Market status values
INDY_NOT_CARRYING_COINS				= %10000000
INDY_CARRYING_SHOVEL				= %00000001

; Spawnable item status bits (basketItemStatus)
; These track items found at fixed world locations (marketplace baskets,
; treasure room). Bit set = Indy has taken the item.
BASKET_STATUS_MARKET_GRENADE		= %00000001
BASKET_STATUS_BLACK_MARKET_GRENADE	= %00000010
BASKET_STATUS_REVOLVER				= %00001000
BASKET_STATUS_COINS					= %00010000
BASKET_STATUS_KEY					= %00100000

; Unique item status bits (pickupItemStatus)
; These track one-of-a-kind items placed in the world.
; Bit set = Indy has found/taken the item.
PICKUP_ITEM_STATUS_WHIP				= %00000001
PICKUP_ITEM_STATUS_SHOVEL			= %00000010
PICKUP_ITEM_STATUS_HEAD_OF_RA		= %00000100
PICKUP_ITEM_STATUS_TIME_PIECE		= %00001000
PICKUP_ITEM_STATUS_HOUR_GLASS		= %00100000
PICKUP_ITEM_STATUS_ANKH				= %01000000
PICKUP_ITEM_STATUS_CHAI				= %10000000

PENALTY_GRENADE_OPENING				= 2
PENALTY_SHOOTING_THIEF				= 4
PENALTY_ESCAPE_SHINING_LIGHT_PRISON = 13
BONUS_USING_PARACHUTE				= 3
BONUS_LANDING_IN_MESA				= 3
BONUS_FINDING_YAR					= 5
BONUS_SKIP_MESA_FIELD				= 9
BONUS_FINDING_ARK					= 10
BONUS_USING_HEAD_OF_RA_IN_MAPROOM	= 14

;--------------------
;rooms
;---------------------

ID_TREASURE_ROOM		 = $00 ;--
ID_MARKETPLACE			 = $01 ; |
ID_ENTRANCE_ROOM		 = $02 ; |
ID_BLACK_MARKET			 = $03 ; | -- staticSpriteKernel
ID_MAP_ROOM				 = $04 ; |
ID_MESA_SIDE			 = $05 ;--
ID_TEMPLE_ENTRANCE		 = $06 ;--
ID_SPIDER_ROOM			 = $07 ;  |
ID_ROOM_OF_SHINING_LIGHT = $08 ;  | -- scrollingPlayfieldKernel
ID_MESA_FIELD			 = $09 ;  |
ID_VALLEY_OF_POISON		 = $0A ;--
ID_THIEVES_DEN			 = $0B ;-- multiplexedSpriteKernel
ID_WELL_OF_SOULS		 = $0C ;-- multiplexedSpriteKernel
ID_ARK_ROOM				 = $0D

;--------------------
;Indy State
;---------------------

INDY_DEAD				= $80 ; Indy is dead
INDY_GAMEOVER			= $FF ; Game over state


;===============================================================================
; U S E R - C O N S T A N T S
;===============================================================================

BANK0STROBE					= $FFF8		; Bank 0 strobe address (triggers 1st bank when read)
BANK1STROBE					= $FFF9		; Bank 1 strobe address (triggers 2nd bank when read)

BANK0TOP					= $0000		; Physical start of 1st bank in ROM
BANK1TOP					= $1000		; Physical start of 2nd bank in ROM

BANK0_REORG					= $D000		; Logical start of 1st bank in Atari address space
BANK1_REORG					= $F000		; Logical start of 2nd bank in Atari address space

LDA_ABS						= $AD		; instruction to LDA $XXXX
JMP_ABS						= $4C		; instruction for JMP $XXXX

INIT_SCORE					= 100		; starting adventurePoints

SET_PLAYER_0_COLOR			= %10000000
SET_PLAYER_0_HMOVE			= %10000001

XMAX						= 160

BULLET_OR_WHIP_ACTIVE		= %10000000
USING_GRENADE_OR_PARACHUTE	= %00000010

ENTRANCE_ROOM_CAVE_VERT_POS = 9
ENTRANCE_ROOM_ROCK_VERT_POS = 53

MAX_INVENTORY_ITEMS			= 6
INVENTORY_SLOT_LIMIT		= (MAX_INVENTORY_ITEMS * 2) - 1 ; $0B — one past last valid 2-byte slot index
SCREEN_CENTER_X				= (XMAX / 2) - 4               ; $4C — standard centered X position

;--------------------
; PLACEHOLDERS 
; The following is a dummy addresss that is replaced
; by the spider room's handler. (ZP address at one time?)
;---------------------
spiderRoomPlayerGraphics	= $00E5


;***********************************************************
;	bank 0 / (First bank)
;***********************************************************

	seg		bank0						; Bank 0 Segement
	org		BANK0TOP					; Physical address of 1st bank in ROM   ($0000-$1FFF)
	rorg	BANK0_REORG					; Shift to logical address for 1st bank ($D000-$EFFF)

;note: 1st bank's vector points right at the cold start routine
	lda		BANK0STROBE					;trigger 1st bank

coldStart
	jmp		startGame					;cold start


;-------------------------------------
; setThievesPosX
; set Thieves' horizontal position in Thieves' Den
;-------------------------------------
setThievesPosX:
	ldx		#<RESBL - RESP0
moveObjectLoop
	sta		WSYNC						; wait for next scan line
	lda		p0PosX,x					; get Thief's horizontal position
	tay
	lda		hmoveTable,y				; get fine motion/coarse position value
	sta		HMP0,x						; set Thief's fine motion value
	and		#$0f						; mask off fine motion value
	tay									; move coarse move value to y
coarseMoveObj
	dey
	bpl		coarseMoveObj				; set Thief's coarse position
	sta		RESP0,x
	dex
	bpl		moveObjectLoop
	sta		WSYNC						; wait for next scan line
	sta		HMOVE
	jmp		jmpDisplayKernel


checkForObjHit:
; -----------------------------------------------------------------------
; MAIN GAME COLLISION HANDLER
; -----------------------------------------------------------------------
; This is the object collision routine, it checks all of the possible collisions
; between things on the screen.
; -----------------------------------------------------------------------


; --------------------------------------------------------------------------
; DID WEAPON HIT A THIEF?
; First we check if the weapon (M1) hit a player sprite (thief). This is only relevant
; in rooms with thieves (Valley of Poison, Thieves' Den, Well of Souls
; Check if weapon (M1) hit a player sprite (thief).
; --------------------------------------------------------------------------
	bit		CXM1P						; check weapon (M1) vs player collision
	bpl		checkWeaponPFHit			; branch to next check if no collision
	ldx		currentRoomId				; get the current room id
	cpx		#ID_VALLEY_OF_POISON		; rooms with thieves are >= Valley of Poison
	bcc		checkWeaponPFHit			; branch to next check if room has no thieves
	beq		weaponHitThief				; Valley of Poison has only one thief

	; --------------------------------------------------------------------------
	; CALCULATE STRUCK THIEF INDEX
	; The screen is divided vertically. We use Weapon Y to determine which thief (0-4) was hit.
	; Formula: Index = ((WeaponY + 1) / 16)
	; --------------------------------------------------------------------------
	lda		weaponPosY					; Load Weapon Vertical Position.
	adc		#$01						; Adjust for offset (Carry set assumed).
	lsr									; Divide by 2.
	lsr									; Divide by 4.
	lsr									; Divide by 8.
	lsr									; Divide by 16.
	tax									; Move result (Index 0-3?) to X.

	; --------------------------------------------------------------------------
	; FLIP THIEF DIRECTION
	; Hitting a thief makes them reverse direction.
	; --------------------------------------------------------------------------
	lda		#REFLECT					; Load Reflect Bit.
	eor		roomObjectVar,x				; XOR with current state (Toggle Direction).
	sta		roomObjectVar,x				; Save new state.
weaponHitThief:
	lda		weaponStatus				; get bullet or whip status
	bpl		setThiefShotPenalty			; branch if bullet or whip not active
	and		#~BULLET_OR_WHIP_ACTIVE
	sta		weaponStatus				; clear BULLET_OR_WHIP_ACTIVE bit
	lda		pickupStatusFlags
	and		#%00011111					; Mask check.
	beq		markPickupProcessed
	jsr		placeItemInInventory
markPickupProcessed:
	lda		#%01000000					; Set Bit 6.
	sta		pickupStatusFlags


	; --------------------------------------------------------------------------
	; PENALTY FOR SHOOTING THIEF
	; Killing a thief is dishonorable. Deducts adventurePoints.
	; --------------------------------------------------------------------------
setThiefShotPenalty
	lda		#~BULLET_OR_WHIP_ACTIVE		; Clear Active Bit mask.
	sta		weaponPosY					; Invalidates weapon Y (effectively removing it).
	lda		#PENALTY_SHOOTING_THIEF		; Load Penalty Value.
	sta		thiefShotPenalty			; Apply penalty.


; --------------------------------------------------------------------------
; DID WEAPON HIT THE PLAYFIELD? (WALLS)
; Check if weapon (M1) hit the playfield. In dungeon rooms (Temple Entrance,
; Room of Shining Light), this destroys wall segments. In Mesa Field, skip
; to Indy's ball collision check instead.
; --------------------------------------------------------------------------
checkWeaponPFHit:
	bit		CXM1FB						; check weapon (M1) vs playfield/ball collision
	bpl		checkWeaponBallHit			; branch if no playfield hit — check ball next
	ldx		currentRoomId				; get the current room id
	cpx		#ID_MESA_FIELD				; Mesa Field has no destructible walls
	beq		checkIndyBallHit			; skip wall logic, check Indy vs ball
	cpx		#ID_TEMPLE_ENTRANCE			; Temple Entrance has dungeon walls
	beq		checkDungeonWallHit			; handle wall destruction
	cpx		#ID_ROOM_OF_SHINING_LIGHT	; Room of Shining Light also has dungeon walls
	bne		checkWeaponBallHit			; no destructible walls in other rooms
checkDungeonWallHit:
	lda		weaponPosY					; get bullet or whip vertical position
	sbc		kernelRenderState			; subtract dungeon wall height
	lsr									; divide by 4 total
	lsr
	beq		handleLeftWall				; if zero, left wall hit
	tax
	ldy		weaponPosX					; get weapon horizontal position
	cpy		#$12						; if 18 
	bcc		clearWeaponState			; branch if too far left
	cpy		#$8d						; if 141
	bcs		clearWeaponState			; branch if too far right
	lda		#$00
	sta		dynamicGfxData,x			; zero out dungeon gfx data for wall hit
	beq		clearWeaponState			; unconditional branch

handleLeftWall:
	lda		weaponPosX					; get bullet or whip horizontal position
	cmp		#$30						; Compare it to 48 (left side boundary threshold)
	bcs		handleRightWall				; If bullet is at or beyond 48, branch to right-side logic
	sbc		#$10						; Subtract 16 from position
										; (adjusting to fit into the masking table index range)
	eor		#$1f						; XOR with 31 to mirror or normalize the range
										; (helps align to bitmask values)

maskDungeonWall:
	lsr									; Divide by 4 Total
	lsr									;
	tax									; Move result to X to use as index into mask table
	lda		itemStatusMaskTable,x		; Load a mask value from the
										; itemStatusMaskTable table
										; (mask used to disable a wall segment)
	and		dynamicGfxData				; Apply the mask to the current
										; dungeon graphic state
										; (clear bits to "erase" part of it)
	sta		dynamicGfxData				; Store the updated graphic
										; state back (modifying visual representation
										; of the wall)
	jmp		clearWeaponState			; unconditional branch

handleRightWall:
	sbc		#$71						; Subtract 113 from bullet/whip horizontal position
	cmp		#$20						; Compare result to 32
	bcc		maskDungeonWall				; apply wall mask
clearWeaponState:
	ldy		#~BULLET_OR_WHIP_ACTIVE		; deactivate weapon
	sty		weaponStatus				; clear BULLET_OR_WHIP_ACTIVE status
	sty		weaponPosY					; move weapon off-screen


; --------------------------------------------------------------------------
; DID WEAPON HIT THE BALL SPRITE? (SNAKE)
; Check if weapon (M1) hit the ball sprite (snake).
; Bit 6 of CXM1FB indicates M1-ball collision.
; --------------------------------------------------------------------------
checkWeaponBallHit:
	bit		CXM1FB						; check weapon (M1) vs ball (snake) collision
	bvc		checkIndyBallHit			; branch if no ball hit (bit 6 clear)
	bit		screenEventState			; is snake active on screen?
	bvc		checkIndyBallHit			; branch if no snake present
	lda		#$5a						; kill the snake — move everything off-screen (Y=90)
	sta		ballPosY					; move ball (snake body) off-screen
	sta		p0SpriteHeight				; collapse snake sprite height
	sta		weaponStatus				; deactivate weapon
	sta		weaponPosY					; move weapon off-screen


; --------------------------------------------------------------------------
; DID INDY HIT THE BALL SPRITE? (SNAKE, TSETSE FLIES, TIMEPIECE)
; Check if Indy (P1) collided with the ball sprite.
; The ball represents different things per room: snake, tsetse flies, or timepiece.
; Bit 6 of CXP1FB indicates P1-ball collision.
; --------------------------------------------------------------------------
checkIndyBallHit:
	bit		CXP1FB						; check Indy (P1) vs ball collision
	bvc		checkMesaSideExit			; branch if no ball collision (bit 6 clear)
	ldx		currentRoomId				; get current room id
	cpx		#ID_TEMPLE_ENTRANCE			; in Temple Entrance, ball = timepiece
	beq		timePieceTouch				; handle timepiece pickup

	; --- Flute Immunity Check ---
	lda		selectedInventoryId			; Get currently selected item.
	cmp		#ID_INVENTORY_FLUTE			; Is it the Flute?
	beq		checkMesaSideExit			; If Flute is selected, IGNORE
										; and check next collision
										;(Immunity to Snakes/Flies)

	; --- Determine collision type: snake or tsetse fly ---
	bit		screenEventState			; bit 7: 0 = snake (lethal), 1 = tsetse fly
	bpl		triggerSnakeDeathEvent		; bit 7 clear → snake contact → death

	; --- Tsetse Fly Paralysis ---
	; Bit 7 set means tsetse flies (Spider Room / Valley of Poison).
	lda		timeOfDay					; Get Timer.
	and		#$07						; Mask for random duration
	ora		#$80						; Set Bit 7.
	sta		eventTimer					; Set "Paralysis" Timer (Indy freezes).
	bne		checkMesaSideExit			; Return.

triggerSnakeDeathEvent:
	bvc		checkMesaSideExit			; bit 6 must be set (snake visible) or skip
	lda		#INDY_DEAD					; set death flag
	sta		indyStatus					; trigger Indy death sequence
	bne		checkMesaSideExit			; continue collision chain

timePieceTouch:
	lda		kernelDataPtrLo
	cmp		#<timeSprite
	bne		checkMesaSideExit
	lda		#ID_INVENTORY_TIME_PIECE
	jsr		placeItemInInventory


; --------------------------------------------------------------------------
; WHICH EXIT DID INDY HIT ON MESA SIDE?
; Mesa Side has two exits: M0 collision (cave under tree) enters Well of Souls,
; falling off the bottom (Indy Y >= 79 [$4F]) enters Valley of Poison.
; --------------------------------------------------------------------------
checkMesaSideExit:
	ldx		#ID_MESA_SIDE
	cpx		currentRoomId				; are we on the Mesa Side?
	bne		checkPlayerCollision		; branch if not — skip to player-player check
	bit		CXM0P						; check M0 (cave under tree) vs Indy collision
	bpl		handleMesaFall				; no M0 hit — check if Indy fell to bottom of screen
	stx		indyPosY					; set Indy vertical position (i.e. x = 5)
	lda		#ID_WELL_OF_SOULS
	sta		currentRoomId				; move Indy to the Well of Souls
	jsr		initRoomState
	lda		#SCREEN_CENTER_X
	sta		indyPosX					; place Indy in horizontal middle
	bne		clearCollisionLatches		; unconditional branch

handleMesaFall:
	ldx		indyPosY					; get Indy vertical position
	cpx		#$4f						; has Indy reached the bottom? (Y >= 79)
	bcc		checkPlayerCollision		; not at bottom yet — continue collision chain
	lda		#ID_VALLEY_OF_POISON		; Otherwise, load Valley of Poison
	sta		currentRoomId				; Set the current screen to Valley of Poison
	jsr		initRoomState				; initialize rooom state
	lda		savedScrollOffset			; Restore saved scroll offset
	sta		roomObjectVar				; Restore roomObjectVar from save
	lda		savedIndyPosY				; get saved Indy vertical position
	sta		indyPosY					; set Indy vertical position
	lda		savedIndyPosX				; get saved Indy horizontal position
	sta		indyPosX					; set Indy horizontal position
	lda		#$fd						; Load bitmask value
	and		mesaSideState				; Apply bitmask to a status/control flag
	sta		mesaSideState				; Store the result back
	bmi		clearCollisionLatches		; If the result has bit 7 set,
										; skip setting major event
	lda		#INDY_DEAD					; Otherwise, Indy has fallen to his death
	sta		indyStatus
clearCollisionLatches:
	sta		CXCLR						; clear all collision latches


; --------------------------------------------------------------------------
; DID INDY HIT THE PLAYER 0 SPRITE? (ROOM OBJECT, TREASURE, THIEF)
; Bit 7 of CXPPMM indicates player-player collision.
; --------------------------------------------------------------------------
checkPlayerCollision:
	bit		CXPPMM						; check player-player (P0 vs P1) collision
	bmi		dispatchPlayerHit			; branch if collision detected
	ldx		#$00
	stx		inputActionState			; Clear input action state
	dex									; X = $FF
	stx		digSpeedLimiter				; Reset dig speed limiter to $FF
	rol		pickupStatusFlags
	clc
	ror		pickupStatusFlags
continueToPlayerHitDefault:
	jmp		playerHitDefault

	; --------------------------------------------------------------------------
	; Dispatch to room-specific player-player collision handler via playerHitJumpTable.
	; Treasure Room (ID 0) is handled inline; all others jump through the table.
	; --------------------------------------------------------------------------
dispatchPlayerHit:

	lda		currentRoomId				; get the current room id
	bne		jumpPlayerHit				; branch if not Treasure Room (use jump table)
	; --- Treasure Room: inline item pickup ---
	; The Treasure Room cycles through items via treasureRoomState.
	; P0 displays the current item; touching it picks it up.
	lda		treasureRoomState
	and		#$07						; item index (0-7)
	tax
	lda		marketBasketItems,x			; get the cycling item's inventory ID
	jsr		placeItemInInventory		; attempt to add to Indy's inventory
	bcc		continueToPlayerHitDefault	; carry clear = inventory full, skip
	lda		#$01
	sta		roomObjectVar				; mark item as collected (hides P0)
	bne		continueToPlayerHitDefault		; unconditional branch

jumpPlayerHit:
	asl									; multiply room id by 2 (word table index)
	tax
	lda		playerHitJumpTable+1,x
	pha									; push handler address MSB
	lda		playerHitJumpTable,x
	pha									; push handler address LSB
	rts									; dispatch to room-specific collision handler

;-playerHitInWellOfSouls
;
; Handles logic when Indy is in the Well of Souls (Room ID 11).
; This is where the GAME WIN condition is triggered.
;
; Win Logic:
; 1. Checks if Indy is at the correct vertical depth (Y >= 63).
; 2. Checks if a specific "digging/action" state is active ($54).
; 3. Checks if Indy is aligned with the Ark's position (secretArkMesaID == activeMesaID).
; 4. If all true, sets arkRoomStateFlag to a positive value, which triggers the End Game sequence.


playerHitInWellOfSouls:
	lda		indyPosY					; get Indy's vertical position
	cmp		#$3f						; Depth Threshold
	bcc		takeAwayShovel				; If Indy is above this threshold,

	lda		dirtPileGfxState			; Load dirt pile graphics state
	cmp		#<clearedDirtPile			; Is the pile fully cleared?
	bne		resumeCollisionChain			; If not cleared, you can't find Ark yet.
	lda		secretArkMesaID				; Load Secret Ark Location (Game RNG)
	cmp		activeMesaID				; Compare to Current Mesa Region
	bne		arkNotFound					; If wrong mesa, nothing is here.

	; --- WIN CONDITION MET ---
	lda		#INIT_SCORE - 12			; Load final adventurePoints modifier ($58 = Positive)
	sta		arkRoomStateFlag			; Store it. This Positive value signals
										; ArkRoomKernel to DRAW the Ark.
	sta		adventurePoints				; Set the players final adventure adventurePoints
	jsr		getFinalScore				; Calculate ranking/title based on adventurePoints
	lda		#ID_ARK_ROOM				; Set up transition to Ark Room
	sta		currentRoomId
	jsr		initRoomState				; Load new screen data for the Ark Room
	jmp		newFrame					; Finish frame cleanly and transition visually

arkNotFound:
	jmp		enterMesaSide

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
	bmi		resumeCollisionChain
	clc									; Carry clear
	jsr		removeItem					; take away specified item
	bcs		updateAfterItemRemove
	sec									; Carry set
	jsr		removeItem
	bcc		resumeCollisionChain
updateAfterItemRemove:
	cpy		#ID_INVENTORY_SHOVEL
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
	bne		resumeCollisionChain		; unconditional branch

playerHitInSpiderRoom:
	ldx		#$00						; Set X to 0
	stx		spiderRoomState				; Clear spider room state
	lda		#INDY_DEAD					; Touching spiders is deadly, set death flag
	sta		indyStatus					; Trigger major event flag
resumeCollisionChain:
	jmp		playerHitDefault

playerHitInMesaSide:
	bit		mesaSideState				;Check event state flags
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
	jmp		playerHitDefault

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
	and		inputActionState			; Preserve current movement
	ora		#$43						; Force bits 6, 1, and 0 ($43).
	sta		inputActionState			; Set "Bumping/Shoving"
	jmp		playerHitDefault		; Resume

checkIndyYForMarketFlags:
	cpy		#$20						; Check Zone (Row $20)
	bcc		setMarketFlags				; If Y < $20, check top zone.

clearMarketFlags:
	; Zone 2: Between $20 and $3A (Middle path)
	lda		#$00
	sta		inputActionState			; Clear movement modification flags.
	jmp		playerHitDefault		; Resume

setMarketFlags:
	cpy		#$09						; Check Topmost Boundary ($09)
	bcc		clearMarketFlags			; If Y < $09 (Very top), clear flags.
	lda		#$e0						; Mask Top 3 bits
	and		inputActionState
	ora		#$42						; Force bits 6 and 1 ($42).
	sta		inputActionState			; Apply "Shove" physics.
	jmp		playerHitDefault		; Resume

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
	cmp		#SCREEN_CENTER_X			; Check Middle/Right boundary
	bcs		touchingRightBasket			; If X >= center, it's the Right Basket.

	; Left Basket: Contains GRENADES
	ldx		#ID_MARKETPLACE_GRENADE		; Pre-load Grenade ID
	bne		tryAwardHeadOfRa			; Go to award logic (Unconditional branch)

touchingRightBasket:
	; Right Basket: Contains REVOLVER (usually)
	ldx		#ID_INVENTORY_REVOLVER		; Pre-load Revolver ID

tryAwardHeadOfRa:
	; --- head of Ra ---
	; Sometimes, a basket contains the Head of Ra instead of its usual item.
	lda		#$40
	sta		screenEventState			; Set flag
	lda		timeOfDay					; get global timer
	and		#$1f						; Mask to 0-31 seconds cycle
	cmp		#$02						; Check if time is < 2
	bcs		checkAddItemToInv			; If Time >= 2, give the standard item
										; (Key/Grenade/Revolver)
	ldx		#ID_INVENTORY_HEAD_OF_RA	; If Time < 2, swap prize to HEAD OF RA!
checkAddItemToInv:
	jsr		isItemAlreadyTaken			; Check if we already have this specific item
	bcs		exitGiveItem				; If taken, do nothing.
	txa									; Move Item ID to A
	jsr		placeItemInInventory		; Add to inventory
exitGiveItem:
	jmp		playerHitDefault		; Resume


playerHitInBlackMarket:
	bit		CXP1FB						; check Indy collision with playfield
	bmi		checkIndyPosForMarketFlags	; branch if Indy collided with playfield
	lda		indyPosX					; get Indy's horizontal position
	cmp		#XMAX / 2
	bcs		pickMarketItemByTime
	dec		indyPosX					; move Indy left one pixel
	rol		blackMarketState			; rotate Black Market state left
	clc									; clear carry
	ror		blackMarketState			; rotate right to show Indy carrying coins
resetInteractionFlags:
	lda		#$00
	sta		inputActionState

exitToPlayerHitDefault:
	jmp		playerHitDefault

pickMarketItemByTime:
	ldx		#ID_BLACK_MARKET_GRENADE	; Load X with the grenade item ID (for black market)
	lda		timeOfDay					; Load the global seconds timer
	cmp		#$40						; Check if >= 64 seconds have passed
	bcs		checkAddItemToInv			; If yes, continue with grenade
	ldx		#ID_INVENTORY_KEY			; If not, switch to the key as the item to give
	bne		checkAddItemToInv			; Always branch (unconditional jump)

checkIndyPosForMarketFlags:
	ldy		indyPosY					; get Indy's vertical position
	cpy		#$44
	bcc		checkMiddleMarketZone		; If Indy is above row 68, jump to alternate logic
	lda		#$e0
	and		inputActionState			; Mask inputActionState to preserve top 3 bits
	ora		#%00001011					; Set bits 0, 1, and 3
setBlackMarketFlags:
	sta		inputActionState			; Store the updated value back into inputActionState
	bne		exitToPlayerHitDefault			; Always branch to resume game logic

checkMiddleMarketZone:
	cpy		#$20
	bcs		resetInteractionFlags		; If Y = 32, exit via reset logic
	cpy		#$0b
	bcc		resetInteractionFlags		; If Y < 11, exit via reset logic
	lda		#$e0
	and		inputActionState
	ora		#%01000001					; Set bits 7 and 0
	bne		setBlackMarketFlags			; Go apply and resume logic

playerHitInTempleEntrance:
	inc		indyPosX					; Push Indy right
	bne		playerHitDefault				; Resume

playerHitInEntranceRoom:
	; -----------------------------------------------------------------------
	; ENTRANCE ROOM COLLISION HANDLER
	; -----------------------------------------------------------------------
	; The "Yellow Object" (Player 0) represents both the Rock and the Whip.
	; The code strictly checks Y position to see what Indy touched.
	; -----------------------------------------------------------------------
	lda		indyPosY					; get Indy's vertical position
	cmp		#$3f						; Check Pickup Threshold >= 63
	bcc		checkRockRange

	; --- Whip Pickup Logic ---
	lda		#ID_INVENTORY_WHIP			; Load Whip Item ID
	jsr		placeItemInInventory		; Attempt to add to inventory
	bcc		playerHitDefault				; If inventory full (Carry Clear), exit

	; Update Room State to remove Whip graphic
	ror		entranceRoomState
	sec
	rol		entranceRoomState			; Rotate bit to mark "Whip Taken"
	lda		#$42						; Set High Bit of rotated value
										; Reset P0 object vertical pos
	sta		$df							; (Move it out of reach)
	bne		playerHitDefault				; Resume

checkRockRange:
	; --- Rock Collision Logic ---
	; Determines if Indy is hitting the solid part of the rock.
	cmp		#$16						; Top Boundary Check (22)
	bcc		pushIndyOutOfRock			; If Y < 22, Hit "Top Edge" of Rock
	cmp		#$1f						; Bottom Bound
	bcc		playerHitDefault				; If 22 <= Y < 31, WALK THROUGH

	; If Y >= 31 (and < 63 from earlier check), fall through to push left.
pushIndyOutOfRock:
	dec		indyPosX					; Push Indy Left

playerHitDefault:
; Secondary collision dispatch. Checks Indy (P1) vs playfield (bit 7 of CXP1FB).
; If collision: dispatch via playfieldHitJumpTable (wall/boundary reactions).
; If no collision: dispatch via roomIdleHandlerJmpTable (room idle behavior).
	lda		currentRoomId				; get the current room id
	asl									; multiply by 2 (word table index)
	tax
	bit		CXP1FB						; check Indy (P1) vs playfield collision
	bpl		dispatchRoomIdleHandler		; no collision — dispatch idle handler
	lda		playfieldHitJumpTable+1,x	; load handler address MSB
	pha
	lda		playfieldHitJumpTable,x		; load handler address LSB
	pha
	rts									; dispatch to playfield collision handler

dispatchRoomIdleHandler:
; No playfield collision — dispatch via roomIdleHandlerJmpTable for
; room-specific idle/background behavior (warp logic, state checks, etc.).
	lda		roomIdleHandlerJmpTable+1,x	; load handler address MSB
	pha
	lda		roomIdleHandlerJmpTable,x	; load handler address LSB
	pha
	rts									; dispatch to room idle handler

warpToMesaSide:
; Save current position state and transition to Mesa Side.
; Called from Mesa Field and Valley of Poison idle handlers.
	lda		roomObjectVar				; save current scroll offset
	sta		savedScrollOffset
	lda		indyPosY					; save Indy's vertical position
	sta		savedIndyPosY
	lda		indyPosX
saveIndyPosAndEnterMesa:
	sta		savedIndyPosX				; save Indy's horizontal position
enterMesaSide:
; Transition to Mesa Side room and place Indy at the top.
	lda		#ID_MESA_SIDE
	sta		currentRoomId
	jsr		initRoomState
	lda		#$05
	sta		indyPosY					; place Indy near top of screen
	lda		#XMAX / 2
	sta		indyPosX					; center Indy horizontally
	tsx
	cpx		#$fe						; check if stack is nearly empty (called via jmp)
	bcs		fallThroughToMissile0Check	; if so, can't rts — jump to collision chain tail
	rts									; otherwise return normally

fallThroughToMissile0Check:
; Safety net: when enterMesaSide was reached via jmp (not jsr),
; the stack has no return address. Jump directly to checkMissile0Hit
; to continue the collision chain.
	jmp		checkMissile0Hit


initFallbackEntryPosition:
; Map Room idle handler: if mapRoomState bit 7 is clear, save a default
; position and transition to Mesa Side.
	bit		mapRoomState
	bmi		fallThroughToMissile0Check	; bit 7 set — skip (already transitioning)
	lda		#MESA_MAP_MAX_HEIGHT
	sta		savedScrollOffset			; default scroll offset
	lda		#$41
	sta		savedIndyPosY				; default vertical position
	lda		#SCREEN_CENTER_X
	bne		saveIndyPosAndEnterMesa		; save horizontal position and enter Mesa Side

stopIndyMovInTemple:
	; --------------------------------------------------------------------------
	; HALLWAY CONSTRAINT LOGIC
	; --------------------------------------------------------------------------
	; The Temple Entrance is a narrow corridor. If Indy touches the walls (Playfield),
	; this routine forces his X/Y coordinates back into the safe "Hallway" zone.
	; --------------------------------------------------------------------------
	ldy		indyPosX
	cpy		#$2c						; Is Indy too far left? (< 44)
	bcc		nudgeIndyRight				; Yes, nudge him right

	cpy		#$6b						; Is Indy too far right? (= 107)
	bcs		nudgeIndyLeft				; Yes, nudge him left

		; --- Vertical Entrance Constraint ---
	ldy		indyPosY					; get Indy's vertical position
	iny									; Try to move Indy down 1 px (Reject Up movement)
	cpy		#$1e						; Top of Corridor Entrance ($1E)
	bcc		setFrozenPosY				; If Y < 30, keep the downward nudge.
	dey
	dey									; Else, move Indy up 1 px instead.

setFrozenPosY:
	sty		indyPosY					; Apply vertical adjustment (Sliding along wall)
	jmp		playWalkSoundAndContinue		; apply walk sound, then continue to M0 check

nudgeIndyRight:
	iny
	iny									; nudge Indy right 2 px (bounce off wall)
nudgeIndyLeft:
	dey
	sty		indyPosX					; apply horizontal adjustment
	bne		playWalkSoundAndContinue	; continue to M0 check

exitToTempleEntrance:
	; -----------------------------------------------------------------------
	; RIGHT WALL COLLISION (EXIT TO TEMPLE ENTRANCE)
	; -----------------------------------------------------------------------
	lda		#GRENADE_OPENING_IN_WALL	; check flag: Is the wall blown open? ($02)
	and		entranceRoomState
	beq		indyPixelLeft				; If Bit 1 is 0 (Wall Intact), Physics Push Left.

	; --- Wall is Blown Open ---
	lda		indyPosY					; Check if Indy is aligned with the hole.
	cmp		#$12
	bcc		indyPixelLeft				; Too High (Y < 18) -> Hit Wall
	cmp		#$24
	bcc		indyEnterHole				; Correct Height (18 <= Y < 36) -> EXIT ROOM

indyPixelLeft:
	dec		$c9							; Push Indy Left
	bne		playWalkSoundAndContinue

playerHitInRoomOfShiningLight:
	ldx		#$1a
	lda		indyPosX					; get Indy horizontal position
	cmp		#SCREEN_CENTER_X
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
	bne		playWalkSoundAndContinue	; unconditional — play walk sound, continue chain

indyMoveOnInput:
	lda		indyDir						; Load movement direction from Indy's direction state
	and		#$0f						; Isolate lower 4 bits (D-pad direction)
	tay									; Use as index
	lda		indyMoveDeltaTable,y		; Get movement delta from direction lookup table
	ldx		#<indyPosY - p0PosY			; X = offset to Indy in object array
	jsr		getMoveDir					; Move Indy accordingly

playWalkSoundAndContinue:
; Play walk/movement sound effect, then fall through to checkMissile0Hit.
	lda		#$05
	sta		soundChan0Effect			; trigger walk sound effect
	bne		checkMissile0Hit			; unconditional — continue to M0 collision check

indyEnterHole:
	rol		playerInputState
	sec
	bcs		undoInputBitShift			; unconditional branch

setIndyToTriggeredState:
	rol		playerInputState
	clc

undoInputBitShift:
	ror		playerInputState

checkMissile0Hit:
; Check if M0 (spider web / tsetse swarm) hit Indy.
; In Spider Room: sets capture state. In rooms above Spider Room ID: triggers death.
	bit		CXM0P						; check M0 vs Indy (P1) collision
	bpl		checkGrenadeDetonation		; no M0 collision — check grenade timer
	ldx		currentRoomId				; get the current room id
	cpx		#ID_SPIDER_ROOM				; Spider Room?
	beq		clearInputBit0ForSpiderRoom	; handle spider web capture
	bcc		checkGrenadeDetonation		; rooms below Spider Room have no M0 hazard
	lda		#INDY_DEAD					; rooms above Spider Room: M0 is lethal
	sta		indyStatus				; trigger Indy death
	bne		despawnMissile0				; unconditional — remove M0 from screen

clearInputBit0ForSpiderRoom:
	rol		playerInputState			; Rotate input left, bit 7 ? carry
	sec									; Set carry (overrides carry from rol)
	ror		playerInputState			; Rotate right, carry -> bit 7 (bit 0 lost)
	rol		spiderRoomState				; Rotate a status byte left (bit 7 ? carry)
	sec									; Set carry (again overrides whatever came before)
	ror		spiderRoomState				; Rotate right, carry -> bit 7 (bit 0 lost)
despawnMissile0:
	lda		#$7f
	sta		m0PosYShadow				; update shadow position
	sta		m0PosY						; move M0 off-screen (Y = 127)

checkGrenadeDetonation:
; Check if an active grenade has reached its detonation time.
; grenadeState bit 7: grenade active. bit 6: wall effect pending.
	bit		grenadeState				; check grenade status flags
	bpl		newFrame					; bit 7 clear — no active grenade
	bvs		applyGrenadeWallEffect		; bit 6 set — wall destruction already triggered
	lda		timeOfDay					; get current time
	cmp		grenadeDetonateTime			; has detonation time been reached?
	bne		newFrame					; not yet — wait
	lda		#INDY_DEAD | $20
	sta		weaponPosY					; move grenade sprite off-screen
	sta		indyStatus				; trigger explosion event (Indy death)
applyGrenadeWallEffect:
	lsr		grenadeState				; Logical shift right: bit 0 -> carry
	bcc		skipUpdate					; If bit 0 was clear, skip this
										; (grenade effect not triggered)
	lda		#GRENADE_OPENING_IN_WALL
	sta		grenadeOpeningPenalty		; Apply penalty (e.g., reduce adventurePoints)
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
	jsr		initRoomState				; Refresh screen visuals
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
	inc		timeOfDay					; increment every second
	lda		eventTimer					; If eventTimer is positive, skip
	bpl		firstLineOfVerticalSync
	dec		eventTimer					; Else, decrement it
firstLineOfVerticalSync
	sta		WSYNC						; Wait for start of next scanlineCounter
	bit		arkRoomStateFlag
	bpl		checkGameOver
	ror		SWCHB						; rotate RESET to carry
	bcs		checkGameOver				; branch if RESET not pressed
	jmp		startGame					; If RESET was pressed, restart the game

checkGameOver
	sta		WSYNC						; wait for first sync
	lda		#STOP_VERT_SYNC				;load a for VSYNC pause
	ldx		#VBLANK_TIME
	sta		WSYNC						; last line of vertical sync
	sta		VSYNC						; end vertical sync (D1 = 0)
	stx		TIM64T						; set timer for vertical blanking period
	ldx		indyStatus
	inx									; Increment counter
	bne		checkForArkRoom			; If not overflowed, continue normal frame
	stx		indyStatus					; Overflowed: zero -> set indyStatus to 0
	jsr		getFinalScore				; set adventurePoints to minimum
	lda		#ID_ARK_ROOM				; set ark title screen
	sta		currentRoomId				; to the current room
	jsr		initRoomState				; Transition to Ark Room
gotoArkRoomLogic:
	jmp		setupNewRoom

checkForArkRoom:
	lda		currentRoomId				; get the room number
	cmp		#ID_ARK_ROOM				; are we in the ark room?
	bne		checkScreenEvent			; branch if not in ID_ARK_ROOM
	lda		#RAIDERS_MARCH				; Ch1 control = distortion + volume, signals "Raiders March"
	sta		soundChan1Effect
	ldy		yarFoundBonus				; check if yar was found
	beq		checkEasterEggFail			; If not in Yar's Easter Egg mode, skip
	bit		arkRoomStateFlag
	bmi		checkEasterEggFail			; If arkRoomStateFlag has bit 7 set, skip
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
	cpy		adventurePoints
	bcc		slowlyLowerIndy				; If Indy is higher up than his point adventurePoints, skip
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
	bit		arkRoomStateFlag			; Check bit 7 of arkRoomStateFlag
	bmi		checkArkInput				; If bit 7 is set, skip (reset enabled)
	lda		#$0e
	sta		soundChan0Effect			; Set Indy's state to 0E

checkArkInput
	lda		#$80
	sta		arkRoomStateFlag			; Set bit 7 to enable reset logic
	bit		INPT5|$30					; Check action button on right controller
	bmi		gotoArkRoomLogic			; If not pressed, skip
	lda		frameCount					; get current frame count
	and		#$0f						; Limit to every 16th frame
	bne		setArkActionCode			; If not at correct frame, skip
	lda		#$05
setArkActionCode
	sta		secretArkMesaID				; Store action/state code
	jmp		initGameVars				; Clear game variables

checkScreenEvent
	bit		screenEventState
	bvs		updateSnakeAI				; If bit 6 set, advance snake/cutscene
continueArkSeq
	jmp		checkIndyStatus

updateSnakeAI
	lda		frameCount					; get current frame count
	and		#$03						; Only act every 4 frames
	bne		configSnake					; If not, skip
	ldx		p0SpriteHeight
	cpx		#$60
	bcc		incrementArkSeq				; If sprite height < $60, branch
	bit		indyStatus
	bmi		continueArkSeq				; If bit 7 is set, jump to continue logic
	ldx		#$00						; Reset X
	lda		indyPosX
	cmp		#$20
	bcs		setIndyArkLevel				; If Indy is right of x=$20, skip
	lda		#$20
setIndyArkLevel
	sta		ballPosX					; Set snake/ball center X position
incrementArkSeq
	inx
	stx		p0SpriteHeight				; Increment and store progression
	txa
	sec
	sbc		#$07						; Subtract 7 to control pacing
	bpl		snakeMove
	lda		#$00
snakeMove
	; -----------------------------------------------------------------------
	; SNAKE MOVEMENT AI
	; -----------------------------------------------------------------------

	sta		ballPosY					; Update Snake Vertical Position
	and		#$f8						; Mask for coarse alignment
	cmp		snakePosY					; Has visual Y changed?
	beq		configSnake					; If not, skip position logic
	sta		snakePosY					; Update internal Y

	; --- Steering Calculation ---
	; The snake "Steers" by adding offsets to the 'ballPosX' variable.
	; It tries to align its center column with Indy.
	lda		kernelRenderState			; Load current Wiggle Frame
	and		#$03
	tax
	lda		kernelRenderState			; Load state again
	lsr									; Get top nibble (Direction/Intensity)
	lsr
	tay									; Y = Steering Mode
	lda		snakePosXOffsetTable,x		; Load Base Wiggle
	clc
	adc		snakePosXOffsetTable,y		; Add Steering offset
	clc
	adc		ballPosX					; Add to Snake's Center X Position
										; (follows Indy)

	; --- Boundary & Proximity Checks ---
	ldx		#$00						; Default: "Straight" steering
	cmp		#$87						; Hit Right Wall?
	bcs		adjSnakePosByDistance
	cmp		#$18						; Hit Left Wall?
	bcc		flipSnakeDirection			; If < $18, force flip
	sbc		indyPosX					; Calculate distance to Indy
	sbc		#$03
	bpl		adjSnakePosByDistance		; If Positive, Indy is to the Left

flipSnakeDirection
	inx									; X = 1
	inx									; X=2 -> Reverse steering intensity
	eor		#$ff						; Invert result

adjSnakePosByDistance:
	cmp		#$09						; Check proximity to Indy
	bcc		updateSnakeMove				; If < 9 pixels away (Very Close),
										; don't change state height
	inx									; Else increments X (Change Sway intensity)

updateSnakeMove
	txa									; Move Sway/Steering Factor to A
	asl
	asl
	sta		temp0						; Store steering factor upper nibble
	lda		kernelRenderState
	and		#$03
	tax
	lda		snakePosXOffsetTable,x
	clc
	adc		ballPosX					; Set base position towards Indy
	sta		ballPosX

	; --- Resolve Final State ---
	lda		kernelRenderState
	lsr
	lsr
	ora		temp0						; Combine new Steering Factor
										; (High Nibble) with old state
	sta		kernelRenderState			; Save

configSnake
	; -----------------------------------------------------------------------
	; SNAKE / BALL GRAPHICS SETUP
	; -----------------------------------------------------------------------
	; The Snake is not a standard sprite. It is the "Ball" object drawn on
	; every scanline. To make it look like a snake, we change the
	; Horizontal Motion (HMBL) register on every single line.
	;
	; This routine sets up the pointer to the "Wiggle Table" (snakeMotionTable)
	; so the Kernel knows how much to shift the ball left/right.
	; -----------------------------------------------------------------------
	lda		kernelRenderState
	and		#$03						; Mask Frame (0-3)
	tax
	lda		snakeMoveTableLSB,x			; Get Low Byte of Motion Table
	sta		kernelDataPtrLo				; Store snake motion table Lo
	lda		#>snakeMotionTable0			; High Byte is fixed (Page $FA/FB)
	sta		kernelDataPtrHi				; Store High Byte

	; -----------------------------------------------------------------------
	; CALCULATE VERTICAL OFFSET
	; -----------------------------------------------------------------------
	; Determine where in the table to start reading based on animation state.
	lda		kernelRenderState
	lsr
	lsr
	tax
	lda		snakeMoveTableLSB,x			; Look up animation offset
	sec
	sbc		#HEIGHT_ITEM_SPRITES		; Subtract 8 (Snake Height correction)
	sta		kernelDataIndex				; Store snake motion start offset

checkIndyStatus
	bit		indyStatus
	bpl		checkGameScriptTimer		; If major event not complete
										; continue sequence
	jmp		dispatchRoomHandler			; Else, jump to end

checkGameScriptTimer
	bit		eventTimer
	bpl		branchOnFrameParity			; If timer still counting or inactive, proceed
	jmp		setIndyStandSprite			; Else, jump to alternate script path

branchOnFrameParity
	lda		frameCount					; get current frame count
	ror									; Test even/odd frame
	bcc		handleWeaponAim				; If even, continue next step
	jmp		clearItemUseOnButtonRelease	; If odd, do something else

handleWeaponAim
	ldx		currentRoomId				; get the current screen id
	cpx		#ID_MESA_SIDE
	beq		stopWeaponEvent				; If on Mesa Side, use a different handler
	bit		grappleWhipState
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
	jmp		handleInventorySelect

handleIndyMove
	ldx		#<indyPosY - p0PosY			; Get index of Indy in object list
	lda		SWCHA						; read joystick values
	sta		temp1						; Store raw joystick input
	and		#P1_NO_MOVE
	cmp		#P1_NO_MOVE
	beq		stopWeaponEvent				; Skip if no movement
	sta		indyDir
	jsr		getMoveDir					; Move Indy according to input
	ldx		currentRoomId				; get the current screen id
	ldy		#$00
	sty		temp0						; Reset scan index/counter
	beq		setIndyPosForEvent			; Unconditional (Y=0, so BNE not taken)
incEventScanIndex
	tax									; Transfer A to X
	inc		temp0						; increase index
setIndyPosForEvent
	lda		indyPosX
	pha									; Temporarily store horizontal position
	lda		indyPosY					; get Indy's vertical position
	ldy		temp0						; Load current scan/event index
	cpy		#$02
	bcs		reversePosOrder				; If index >= 2, store in reverse order
	sta		temp2						; Vertical position
	pla
	sta		temp3						; Horizontal position
	jmp		applyEventOffsetToIndy

reversePosOrder
	sta		temp3						; Vertical -> $87
	pla
	sta		temp2						; Horizontal -> $86
applyEventOffsetToIndy
	ror		temp1						; Rotate player input to extract direction
	bcs		checkScanBoundaryOrContinue	; If carry set, skip
	jsr		checkRoomOverrideCondition	; Run event/collision subroutine
	bcs		triggerScreenTransition		; If failed/blocked, exit
	bvc		checkScanBoundaryOrContinue	; If no vertical/horizontal event flag, skip
	ldy		temp0						; Event index
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
	bcs		handleInventorySelect		; Else, exit

triggerScreenTransition
	sty		currentRoomId				; Set new screen based on event result
	jsr		initRoomState				; Load new room or area

handleInventorySelect
	bit		INPT4|$30					; read action button from left controller
	bmi		normalizeplayerInput		; branch if action button not pressed
	bit		grenadeState
	bmi		exitItemHandler				; If game state prevents interaction, skip
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
	lda		inputActionState
	bpl		exitItemHandler				; If no item queued, exit
	and		#$1f
	cmp		#$01
	bne		checkShovelPickup
	inc		bulletCount					; Give Indy 3 bullets
	inc		bulletCount
	inc		bulletCount
	bne		clearItemUseFlag
checkShovelPickup
	cmp		#ID_INVENTORY_SHOVEL
	bne		placeGenericItem
	ror		blackMarketState			; rotate Black Market state right
	sec									; set carry
	rol		blackMarketState			; rotate left to show Indy carrying Shovel
	ldx		#$45
	stx		roomObjectVar				; Set Y-pos for shovel on screen
	ldx		#$7f
	stx		m0PosY
placeGenericItem
	jsr		placeItemInInventory
clearItemUseFlag
	lda		#$00
	sta		inputActionState			; Clear item pickup/use state
exitItemHandler
	jmp		selectIndySprite

clearItemUseOnButtonRelease
	bit		grenadeState				; Test game state flags
	bmi		exitItemHandler				; If bit 7 is set (N = 1),
										; then a grenade or parachute event
										; is in progress.
	bit		INPT5|$30					; read action button from right controller
	bpl		handleItemUse				; branch if action button pressed
	lda		#~USING_GRENADE_OR_PARACHUTE ; Load inverse of USING_GRENADE_OR_PARACHUTE
										;(i.e., clear bit 1)
	and		playerInputState			; Clear the USING_GRENADE_OR_PARACHUTE bit
										; from the player input state
	sta		playerInputState			; Store the updated input state
	jmp		selectIndySprite

handleItemUse
	lda		#USING_GRENADE_OR_PARACHUTE ; Load the flag indicating item use
										; (grenade/parachute)
	bit		playerInputState			; Check if the flag is already set in player input
	bne		exitItemUseHandler			; If it's already set, skip re-setting (item already active)
	ora		playerInputState			; Otherwise, set the USING_GRENADE_OR_PARACHUTE bit
	sta		playerInputState			; Save the updated input state
	ldx		selectedInventoryId			; get the current selected inventory id
	cpx		#ID_MARKETPLACE_GRENADE		; Is the selected item the marketplace grenade?
	beq		startGrenadeThrow			; If yes, jump to grenade activation logic
	cpx		#ID_BLACK_MARKET_GRENADE	; If not, is it the black market grenade?
	bne		checkToActivateParachute	; If neither, check if it's a parachute
startGrenadeThrow
	ldx		indyPosY					; get Indy's vertical position
	stx		weaponPosY					; Set grenade's starting vertical position
	ldy		indyPosX					; get Indy horizontal position
	sty		weaponPosX					; Set grenade's starting horizontal position
	lda		timeOfDay					; get the seconds timer
	adc		#5 - 1						; increment value by 5...carry set
	sta		grenadeDetonateTime			; Detonate grenade 5 seconds from now
	lda		#$80						; Prepare base grenade state value (bit 7 set)
	cpx		#ENTRANCE_ROOM_ROCK_VERT_POS  ; Is Indy below the rock's vertical line?
	bcs		setGrenadeState
	cpy		#$64						; Is Indy too far left?
	bcc		setGrenadeState
	ldx		currentRoomId				; get the current screen id
	cpx		#ID_ENTRANCE_ROOM			; Are we in the Entrance Room?
	bne		setGrenadeState				; branch if not in the ENTRANCE_ROOM
	ora		#$01						; Set bit 0 to trigger wall explosion effect
setGrenadeState
	sta		grenadeState				; Store the grenade state flags:
										; Bit 7 set: grenade is active
										; Bit 0 optionally set: triggers
										; wall explosion if conditions were met
	jmp		selectIndySprite

checkToActivateParachute
	cpx		#ID_INVENTORY_PARACHUTE		; Is the selected item the parachute?
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
	bpl		finishGrapple				; unconditional branch
handleSpecialItemUseCases
	bit		grappleWhipState			; Check grapple/whip state flags
	bvc		attemptArkDig				; If bit 6 is clear , skip to further checks
	bit		CXM1FB|$30					; Check collision between missile 1 and playfield
	bmi		calculateMesaGrapple		; If collision occurred (bit 7 set),
										; go to handle collision impact
	jsr		warpToMesaSide				; No collision	warp Indy to Mesa Side
exitItemUseHandler
	jmp		selectIndySprite

calculateMesaGrapple
	; -----------------------------------------------------------------------
	; GRAPPLE LANDING CALCULATOR
	; -----------------------------------------------------------------------
	; Converts the Hook's Screen Position (Pixels) into a Map Grid ID.
	; The Mesa Field is essentially a grid of regions.
	;
	; Formula:
	; RegionY = ((HookY - 6) + WorldScrollOffset) / 16
	; RegionX = ((HookX - 16) / 32)
	; TableIndex = RegionY + RegionX
	; -----------------------------------------------------------------------
	lda		weaponPosY					; get bullet or whip vertical position
	lsr									; Divide by 2 (fine-tune for tile mapping)
	sec									; Set carry for subtraction
	sbc		#$06						; Subtract 6 (Align key point)
	clc									; Clear carry before next addition
	adc		roomObjectVar				; Add the Camera/Scroll Offset
										; (This accounts for how far down we scrolled)
	lsr									; Divide by 16 total:
	lsr									; Effectively: (Y - 6 + objectVertOffset) / 16
	lsr
	lsr
	cmp		#$08						; Bound Check (Max 8 rows)
	bcc		hookAndMoveIndy				; If less than 8, jump to store the index
	lda		#$07						; Clamp to max value (7) if out of bounds

hookAndMoveIndy
	sta		temp0						; Store Row Index (0-7)
	lda		weaponPosX					; Get Hook Horizontal Position
	sec
	sbc		#$10						; Left Margin Offset
	and		#$60						; Mask bits 5/6 (Coarse X bucket)
	lsr
	lsr									; Shift to get Column Index (0, 8, 16...)
	adc		temp0						; Add Row Index to Column Offset
	tay									; Y = Final Grid Index

	; -----------------------------------------------------------------------
	; DETERMINE DESTINATION
	; -----------------------------------------------------------------------
	lda		mesaGridMapTable,y			; Look up the "Region ID" for this grid cell.
	sta		activeMesaID				; Store logical location (Used for
										; determining if we found the target mesa)

	; -----------------------------------------------------------------------
	; "SWINGING" INDY TO THE HOOK
	; -----------------------------------------------------------------------
	ldx		weaponPosY					; Get Hook position
	dex									; Adjust slightly
	stx		weaponPosY
	stx		indyPosY					; TELEPORT INDY to Hook Y

	ldx		weaponPosX					; Get Hook Position
	dex
	dex
	stx		weaponPosX
	stx		indyPosX					; TELEPORT INDY to Hook X

	lda		#$46						; Re-assert Grapple Mode state
	sta		grappleWhipState			; Set grapple swing active state
finishGrapple
	jmp		triggerWhipEffect			; Clean up frame

attemptArkDig
	cpx		#ID_INVENTORY_SHOVEL		; Is the selected item the shovel?
	bne		ankhWarpToMesa				; If not, skip.

	; 1. Position Check (Must be in middle of room)
	lda		indyPosY					; get Indy's vertical position
	cmp		#$41						; Is Indy deep enough?
	bcc		exitItemUseHandler			; If not, exit (can't dig here)

	; 2. Collision Check (Must be touching the Dirt Pile)
	; The Dirt Pile is Player 0. Indy is Player 1.
	bit		CXPPMM|$30					; Check P0-P1 Collision (Bit 7)
	bpl		exitItemUseHandler			; If no collision, exit.

	; 3. Dig Speed Limiter
	inc		digSpeedLimiter				; Increment counter
	bne		exitItemUseHandler			; Only dig on overflow (0) to slow animation.

	; 4. Update Dirt Pile "Frame"
	; The state variable acts as the Low Byte for the graphics pointer.
	; Decrementing it moves the pointer to the "Smaller Pile" sprite data.
	ldy		dirtPileGfxState			; Load current graphics offset ($5C start)
	dey									; Shrink pile
	cpy		#<clearedDirtPile			; Have we reached the "Cleared" state?
	bcs		clampDigDepth				; If State >= cleared, save it.
	iny									; If past cleared, limit it (Don't over-dig).


clampDigDepth
	sty		dirtPileGfxState			; Save new appearance.
	lda		#BONUS_FINDING_ARK
	sta		findingArkBonus				; Set bonus flag
	bne		exitItemUseHandler			; Resume.
ankhWarpToMesa
	cpx		#ID_INVENTORY_ANKH			; Is the selected item the Ankh?
	bne		handleWeaponUseOnMove		; If not, skip to next item handling
	ldx		currentRoomId				; get the current screen id
	cpx		#ID_TREASURE_ROOM			; Is Indy in the Treasure Room?
	beq		exitItemUseHandler			; If so, don't allow Ankh warp from here
	lda		#ID_MESA_FIELD				; Mark this warp use
	sta		ankhUsedBonus				; set to reduce adventurePoints by 9 points
	sta		currentRoomId				; Change current screen to Mesa Field
	jsr		initRoomState				; Load the data for the new screen
	lda		#SCREEN_CENTER_X			; Prepare a flag or state value for later use
	;Warp Indy to center of Mesa Field
	sta		indyPosX					; Set Indy's horizontal position
	sta		weaponPosX					; Set projectile's horizontal position
	lda		#$46						; Fixed vertical position value (mesa starting Y)
	sta		indyPosY					; Set Indy's vertical position
	sta		weaponPosY					; Set projectile's vertical position
	sta		grappleWhipState			; Set grapple state for mesa warp
	lda		#$1d						; Set initial Y for object
	sta		roomObjectVar				; set object vertical position
	bne		selectIndySprite	; Unconditional jump to common handler

handleWeaponUseOnMove
	lda		SWCHA						; read joystick values
	and		#P1_NO_MOVE					; Mask to isolate movement bits
	cmp		#P1_NO_MOVE
	beq		selectIndySprite	; branch if right joystick not moved
	cpx		#ID_INVENTORY_REVOLVER
	bne		checkUsingWhip				; check for Indy using whip
	bit		weaponStatus				; check bullet or whip status
	bmi		selectIndySprite	; branch if bullet active
	ldy		bulletCount					; get number of bullets remaining
	bmi		selectIndySprite	; branch if no more bullets
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
	bne		selectIndySprite	; branch if Indy not using whip
	ora		#$80						; Set a status bit (bit 7) to indicate whip is active
	sta		grappleWhipState			; Set whip active in grapple/whip state
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
	sta		soundChan1Effect			; Animate or time whip
selectIndySprite
	bit		mesaSideState				; Check game status flags
	bpl		setIndySpriteIfStill		; If parachute bit (bit 7) is clear,
										; skip parachute rendering
	lda		#<parachutingIndySprite		; Load low byte of parachute sprite address
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
	lda		#<indyStandSprite			; Load low byte of pointer to stationary sprite
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
	adc		indyGfxPtrLo				; Advance to next sprite frame
	cmp		#<indyStandSprite			; Check if we've reached the end of walkcycle
	bcc		setIndySpriteLSBValue		; If not, update walking frame
	lda		#$02						; Set a short animation timer
	sta		soundChan1Effect
	lda		#<indyWalk0					; Reset animation back to first walking frame
	bcs		setIndySpriteLSBValue		; Unconditional jump to store new sprite pointer


handleMesaScroll
	ldx		currentRoomId				; get the current screen id
	cpx		#ID_MESA_FIELD				; are we on the Mesa Field?
	beq		checkMesaCameraUpdate		; Yes, check if we need to scroll
	cpx		#ID_VALLEY_OF_POISON		; Do check if we are in Valley of Poison too
	bne		dispatchRoomHandler				; If neither, continue to Bank 1 routines

checkMesaCameraUpdate
	; -----------------------------------------------------------------------
	; MESA SCROLLING LOGIC (CAMERA PAN)
	; -----------------------------------------------------------------------
	; This routine handles the vertical scrolling. It creates the illusion
	; of a larger map by shifting the "World Offset" (roomObjectVar) and
	; all relative object positions when Indy pushes against the top or
	; bottom edges of the screen.
	; -----------------------------------------------------------------------
	lda		frameCount					; get current frame count
	bit		playerInputState			; Check movement input flags
	bpl		tryScrollSouth				; If bit 7 of playerInputState is clear
	lsr									; (Speed throttle for scroll)

tryScrollSouth
	ldy		indyPosY					; get Indy's vertical position
	cpy		#MESA_SCROLL_TRIGGER_BOTTOM	; Check Lower Scroll Boundary
										; (Bottom of screen)
	beq		dispatchRoomHandler					; If at bottom, stop scrolling

	ldx		roomObjectVar				; Load the current World Background Offset.
	bcs		tryScrollNorth				; If Indy Y >= $27, he is near the bottom.
										; (Carry Set = Check Downward Scroll/Reverse)

	; --- SCROLLING DOWN (Walking towards bottom) ---
	beq		dispatchRoomHandler			; If Offset is 0, we are at
										; the very bottom of the map.
										; Stop scrolling.

	; Perform the "Camera Move":
	inc		indyPosY					; Nudge Indy Down (Keep him pinned to edge)
	inc		weaponPosY					; Move Weapon DOWN with him
	and		#$02						; Check Frame Timing every 2 frames
										; (scroll speed)
	bne		dispatchRoomHandler					; if not time to scroll, skip

	; Shift all other objects DOWN to match the camera movement:
	dec		roomObjectVar
	inc		p0PosY
	inc		m0PosY
	inc		ballPosY
	inc		p0PosY
	inc		m0PosY
	inc		ballPosY
	jmp		dispatchRoomHandler

tryScrollNorth
	; --- SCROLLING UP (Walking towards top) ---
	cpx		#MESA_MAP_MAX_HEIGHT		; Check Upper World Limit (Offset $50)
	bcs		dispatchRoomHandler			; If at top of map, Stop scrolling.
	dec		indyPosY					; Nudge Indy UP (Keep him pinned to edge)
	dec		weaponPosY					; Move Weapon UP
	and		#$02						; Frame Timer check
	bne		dispatchRoomHandler

	; Shift the World DOWN relative to Indy:
	inc		roomObjectVar
	dec		p0PosY
	dec		m0PosY
	dec		ballPosY
	dec		p0PosY
	dec		m0PosY
	dec		ballPosY

dispatchRoomHandler
	lda		#<selectRoomHandler			; Load low byte of Bank 1 Kernel address
	sta		temp4						; Store bank-switch jump target lo
	lda		#>selectRoomHandler			; Load high byte of Bank 1 Kernel address
	sta		temp5						; Store bank-switch jump target hi
	jmp		jumpToBank1					; Jump to Bank 1 Kernel

setupNewRoom
	lda		screenInitFlag				; Check status flag
	beq		setRoomAttr					; If zero, skip subroutine
	jsr		updateRoomEventState		; Run special screen setup routine
	lda		#$00						; Clear the flag afterward
setRoomAttr
	sta		screenInitFlag				; Store the updated flag
	ldx		currentRoomId				; get the current room id
	lda		hmoveTable,x
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
	sta		kernelRenderState			; set object state value
	ldx		#$04

setupThievesDenObjects
	; --------------------------------------------------------------------------
	; INITIALIZE THIEVES POSITIONS
	; Uses a lookup table to set initial HMOVE values for 5 thieves.
	; --------------------------------------------------------------------------
	ldy		dynamicGfxData,x			; Get index.
	lda		hmoveTable,y				; Load X position from table.
	sta		thiefPosX,x					; Store
	dex									; Next thief.
	bpl		setupThievesDenObjects		; Loop through all Thieves' Den
										; enemy positions
placeObjectPosX
	jmp		setThievesPosX

initArkRoomObjPos
	lda		#$4d						; Set Indy's X position in the Ark Room
	sta		indyPosX
	lda		#$48
	sta		p0PosX						; Set object X position
	lda		#$1f
	sta		indyPosY					; Set Indy's Y position in the Ark Room
	rts

clearGameStateMem
	ldx		#$00						; Start at index 0
	txa									; A also 0
clearStateLoop
	sta		roomObjectVar,x				; Clear object state array
	sta		p0DrawStartLine,x
	sta		pf1GfxPtrLo,x
	sta		pf1GfxPtrHi,x
	sta		pf2GfxPtrLo,x
	sta		pf2GfxPtrHi,x
	txa									; Check accumulator value
	bne		exitStateClear				; If A ? 0, exit
	ldx		#$06						; Prepare to re-run loop with X = 6
	lda		#$14						; Now set A = 20
	bne		clearStateLoop				; Unconditional loop to write new value
exitStateClear
	lda		#>thiefSprites				; Hi byte for thief/dirt pile color pointer
	sta		kernelDataPtrHi				; Set color data page ($FC)
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
	lda		#<fullDirtPile			; Full pile (topmost read window position)
	sta		dirtPileGfxState
	ldx		#$00						; Initialize X to 0 for clearing.
	stx		screenEventState			; Clear screen event state.
	stx		spiderRoomState				; Clear spider room state.
	stx		m0PosYShadow				; Clear shadow variable for missile Y Position
	stx		unused90					; Clear unknown flag at $90
	lda		pickupStatusFlags			; Load pickup flags.
	stx		pickupStatusFlags			; Clear pickup flags.
	jsr		updateRoomEventState		; Update room event counters/offsets.
	rol		playerInputState			; Rotate input flags
	clc
	ror		playerInputState			; Reverse the bit rotation
										; keeps input state consistent
	ldx		currentRoomId				; Load the current room ID into X.
	lda		pfControlTable,x			; Set playfield control flags
										; (reflection, priority) based on table.
	sta		roomPFControlFlags
	cpx		#ID_ARK_ROOM				; Is this the Ark Room?
	beq		initArkRoomObjPos			; then jump to special setup
	cpx		#ID_MESA_SIDE				; Is this the Mesa Side?
	beq		loadRoomGfx					; skip clear and go to load graphics.
	cpx		#ID_WELL_OF_SOULS			; Is this the Well of Souls?
	beq		loadRoomGfx					; skip clear and go to load graphics.
	lda		#$00
	sta		activeMesaID				; CLear Ark location

loadRoomGfx
	;Load the graphics for the current room
	lda		p0GfxDataLo,x
	sta		p0GfxPtrLo					; Set low byte of sprite pointer for P0
	lda		p0GfxDataHi,x
	sta		p0GfxPtrHi					; Set high byte of sprite pointer for P0
	lda		p0SpriteHeightData,x
	sta		p0SpriteHeight				; Set sprite height for P0
	lda		objectPosXTable,x
	sta		p0PosX						; Set default object X position
	lda		m0PosXTable,x
	sta		m0PosX						; Set default missile X position
	lda		m0PosYTable,x
	sta		m0PosY						; Set default missile Y position
	cpx		#ID_THIEVES_DEN				; Are we in the Thieves' Den?
	bcs		clearGameStateMem			; jump to clear game state memory.
	adc		roomSpecialTable,x			; set special behavior flags for room
	sta		p0DrawStartLine					; Set kernel scanline boundary
	lda		pf1GfxDataLo,x
	sta		pf1GfxPtrLo					; Store PF1 graphics pointer LSB.
	lda		pf1GfxDataHi,x
	sta		pf1GfxPtrHi					; Store PF1 graphics pointer MSB.
	lda		pf2GfxDataLo,x
	sta		pf2GfxPtrLo					; Store PF2 graphics pointer LSB.
	lda		pf2GfxDataHi,x
	sta		pf2GfxPtrHi					; Store PF2 graphics pointer MSB.
	lda		#$55
	sta		ballPosY					; Init object vertical parameter
	sta		weaponPosY					; Reset Weapon vertical parameter
	cpx		#ID_TEMPLE_ENTRANCE			; If Temple Entrance or later,
	bcs		initTempleAndShiningLight	; jump to specific initialization.
	lda		#$00						; Load 0
	cpx		#ID_TREASURE_ROOM			; Is this the Treasure Room?
	beq		initTreasureRoom			; Special setup for Treasure Room.
	cpx		#ID_ENTRANCE_ROOM
	beq		setEntranceRoomObjPosY		; Special setup for Enterance Room.
	sta		p0PosY
setObjPosY
	ldy		#$4f						; Load default vertical offset ($4F).
	cpx		#ID_ENTRANCE_ROOM			; If ID < Entrance Room
	bcc		finishScreenInit			; keep default and return.
	lda		treasureRoomState,x			; Load per-room state byte
	ror									; Rotate bit 0 into carry.
	bcc		finishScreenInit			; If carry clear, use default offset.
	ldy		roomObjPosYTable,x			; Load room-specific vertical offset.
	cpx		#ID_BLACK_MARKET			; if Black Market or later,
	bne		finishScreenInit			; use loaded offset and return.
	lda		#$ff						; Load $FF
	sta		m0PosY						; Hide Missile 0 (off-screen).
finishScreenInit
	sty		roomObjectVar					; Store the final vertical object
	rts									; Return from subroutine.

initTreasureRoom
	lda		treasureRoomState			; Load treasure room state
	and		#$78						; Mask off all but bits 3-6
	sta		treasureRoomState			; Save the updated state
	lda		#$1a
	sta		p0PosY						; Set Y Pos for the top object
	lda		#$26
	sta		roomObjectVar				; Set vertical position for the bottom object
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
	; --------------------------------------------------------------------------
	; TEMPLE GRAPHICS INIT
	; --------------------------------------------------------------------------
	cpx		#ID_TEMPLE_ENTRANCE			; If not, is it the Temple Entrance?
	bne		initMesaFieldScrollState	; If neither, skip this routine

	ldy		#$00
	sty		kernelDataIndex				; Clear Timepiece Sprite Index

	ldy		#$40
	sty		dynamicGfxData				; Set visual reference
	bne		enableDungeonWalls			;Always taken

initRoomOfShiningLight
	ldy		#$ff
	sty		dynamicGfxData				; Set mask to FF (Draw full bars)
	iny									; y = 0
	sty		kernelDataIndex				; Clear pointers
	iny									; y = 1
enableDungeonWalls
	sty		dungeonBlock1				; Enable Dungeon Wall Segments
	sty		dungeonBlock2
	sty		dungeonBlock3
	sty		dungeonBlock4
	sty		dungeonBlock5
	ldy		#$39
	sty		kernelRenderState			; Set Animation State for the Light
	sty		snakePosY					; Set snake enemy Y-position baseline
initMesaFieldScrollState
	cpx		#ID_MESA_FIELD				; Is this the Mesa Field?
	bne		finishRoomSpecificInit		; If not Mesa Field, skip
	ldy		indyPosY					; get Indy's vertical position
	cpy		#$49						; If Indy is "Above" the scroll line
	bcc		finishRoomSpecificInit
	lda		#MESA_MAP_MAX_HEIGHT
	sta		roomObjectVar				; start scrolling from bottom
	rts									; return

finishRoomSpecificInit
	lda		#$00
	sta		roomObjectVar				; Clear Scroll Offset
	rts									; complete screen init

checkRoomOverrideCondition
	ldy		roomOverrideTable,x			; Load room override index based on
										; current screen ID
	cpy		temp2						; Compare with current override
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
	cpy		temp3						; Compare with current horizontal state
	bcc		cmpWithExtRoomThreshold		; If below lower limit, use another check
	ldy		overrideHighXBoundTable,x	; Load upper horizontal boundary
	bmi		checkFlagforFixedY			; If negative, apply default vertical
	bpl		checkPosYlOverride			; Always taken	go check vertical override

cmpWithExtRoomThreshold
	ldy		advOverrideControlTable,x	; Load alternate override flag
	bmi		checkFlagforFixedY			; If negative, jump to handle special override
	bpl		checkPosYlOverride			; Always taken
evalRangeXOverride
	lda		temp3						; Load current horizontal position
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
	bit		treasureRoomState			; Check treasure room state flags
	bpl		checkPosYlOverride			; If bit 7 is clear, proceed
	lda		#$41
	bne		applyPosYOverride			; Always taken	apply forced vertical position
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
	bit		noOpRTS						; Dummy BIT used for timing/padding

noOpRTS
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
	bcc		finishItemRemoval
; Remove pickup status bit if this is a non-basket item
	tya									; Move item ID to A
	tax									; move item id to x
	jsr		setItemAsNotTaken			; Update pickup/basket flags to
										; show it's no longer taken
	txa									; X -> A
	tay									; And back to Y for further use
finishItemRemoval
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
	jmp		dropItem					; Go to general item removal cleanup

dropGrappleItem:
	stx		grappleWhipState			; Clear grapple state (drop grapple item)
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
	lda		#$42						; Check for specific movement direction command.
	cmp		inputActionState			; Check if player is pushing against boundary?
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
	cmp		activeMesaID				; Check if Yar bonus already awarded.
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
	sta		roomObjectVar				; Reset Whip position below rock
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
	sta		roomObjectVar				; Reset Shovel position
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
	lda		inputActionState
	clc
	adc		#$40						; Update UI/event state
	sta		inputActionState

dropItem:
	dec		inventoryItemCount			; reduce number of inventory items
	bne		selectNextAvailableItem		; branch if Indy has remaining items
	lda		#ID_INVENTORY_EMPTY
	sta		selectedInventoryId			; clear the current selected invendory id
	beq		finishInventorySelect		; unconditional branch

selectNextAvailableItem:
	ldx		selectedItemSlot			; get selected inventory index
nextItemIndex:
	inx									; increment by 2 to compensate for word pointer
	inx
	cpx		#INVENTORY_SLOT_LIMIT
	bcc		selectNextItem
	ldx		#$00						; wrap around to the beginning
selectNextItem:
	lda		invSlotLo,x					; get inventory graphic LSB value
	beq		nextItemIndex				; branch if nothing in the inventory location
	stx		selectedItemSlot			; set inventory index
	lsr
	lsr
	lsr
	sta		selectedInventoryId			; set inventory id
finishInventorySelect
	lda		#$0d						; Possibly sets UI state
	sta		soundChan0Effect
	sec									; Set carry to indicate success
	rts

	.byte	$00,$00,$00					; $dafd (*)


hmoveTable
	.byte MSBL_SIZE1 | ONE_COPY			; Treasure Room
	.byte MSBL_SIZE1 | ONE_COPY			; Marketplace
	.byte MSBL_SIZE8 | DOUBLE_SIZE		; Entrance Room
	.byte MSBL_SIZE2 | ONE_COPY			; Black Market
	.byte MSBL_SIZE2 | QUAD_SIZE		; Map Room
	.byte MSBL_SIZE8 | ONE_COPY			; Mesa Side
	.byte MSBL_SIZE1 | ONE_COPY			; Temple Entrance
	.byte MSBL_SIZE1 | ONE_COPY			; Spider Room
	.byte MSBL_SIZE1 | ONE_COPY			; Room of Shining Light
	.byte MSBL_SIZE1 | ONE_COPY			; Mesa Field
	.byte MSBL_SIZE1 | ONE_COPY			; Valley of Poison
	.byte MSBL_SIZE1 | ONE_COPY			; Thieves Den
	.byte MSBL_SIZE1 | ONE_COPY			; Well of Souls
	.byte MSBL_SIZE1 | DOUBLE_SIZE		; Ark Room

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




pfControlTable
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
	.byte $CE						; Marketplace
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
	.byte >treasureRoomPlayerGraphics
	.byte >marketplacePlayerGraphics
	.byte >entranceRoomPlayerGraphics
	.byte >blackMarketPlayerGraphics
	.byte >mapRoomPlayerGraphics
	.byte >mesaSidePlayerGraphics
	.byte >templeEntrancePlayerGraphics	
	.byte >spiderRoomPlayerGraphics				; Spider Room has placeholder value; handler overrides
	.byte >shiningLightSprites
	.byte >emptySprite
	.byte >thiefSprites
	.byte >thiefSprites
	.byte >thiefSprites

p0GfxDataLo
	.byte <treasureRoomPlayerGraphics
	.byte <marketplacePlayerGraphics
	.byte <entranceRoomPlayerGraphics
	.byte <blackMarketPlayerGraphics
	.byte <mapRoomPlayerGraphics
	.byte <mesaSidePlayerGraphics
	.byte <templeEntrancePlayerGraphics
	.byte <spiderRoomPlayerGraphics				; Spider Room has placeholder value; handler overrides
	.byte <shiningLightSprites
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


pf1GfxDataLo
	.byte <COLUP0,<COLUP0,<COLUP0,<COLUP0,<COLUP0,<COLUP0,<roomPF1GraphicData7,<roomPF1GraphicData8,<roomPF1GraphicData9,<roomPF1GraphicData10,<roomPF1GraphicData10

pf1GfxDataHi
	.byte >COLUP0,>COLUP0,>COLUP0,>COLUP0,>COLUP0,>COLUP0,>roomPF1GraphicData7,>roomPF1GraphicData8,>roomPF1GraphicData9,>roomPF1GraphicData10,>roomPF1GraphicData10

pf2GfxDataLo
	.byte <HMP0,<HMP0,<HMP0,<HMP0,<HMP0,<HMP0,<roomPF1GraphicData6,<roomPF2GraphicData7,<roomPF2GraphicData6,<roomPF2GraphicData9,<roomPF2GraphicData9

pf2GfxDataHi
	.byte >HMP0,>HMP0,>HMP0,>HMP0,>HMP0,>HMP0,>roomPF1GraphicData6,>roomPF2GraphicData7,>roomPF2GraphicData6,>roomPF2GraphicData9,>roomPF2GraphicData9

itemStatusBitValues
	.byte BASKET_STATUS_MARKET_GRENADE | PICKUP_ITEM_STATUS_WHIP
	.byte BASKET_STATUS_BLACK_MARKET_GRENADE | PICKUP_ITEM_STATUS_SHOVEL
	.byte PICKUP_ITEM_STATUS_HEAD_OF_RA
	.byte BASKET_STATUS_REVOLVER | PICKUP_ITEM_STATUS_TIME_PIECE
	.byte BASKET_STATUS_COINS
	.byte BASKET_STATUS_KEY | PICKUP_ITEM_STATUS_HOUR_GLASS
	.byte PICKUP_ITEM_STATUS_ANKH
	.byte PICKUP_ITEM_STATUS_CHAI


itemStatusMaskTable
	.byte ~(BASKET_STATUS_MARKET_GRENADE | PICKUP_ITEM_STATUS_WHIP);$FE
	.byte ~(BASKET_STATUS_BLACK_MARKET_GRENADE | PICKUP_ITEM_STATUS_SHOVEL);$FD
	.byte ~PICKUP_ITEM_STATUS_HEAD_OF_RA;$FB
	.byte ~(BASKET_STATUS_REVOLVER | PICKUP_ITEM_STATUS_TIME_PIECE);$F7
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


dropItemTable:						; ID 0: Empty/Default (No Action)
	.word dropItem-1				; ID 1: Copyright 1 (Shown at Start Screen)
	.word dropItem-1				; ID 2: Flute (Generic Drop)
	.word dropParachute-1			; ID 3: Parachute (Clear mesaSideState bit)
	.word dropCoins-1				; ID 4: Coins (Check Black Market Purchase)
	.word dropItem-1				; ID 5: Marketplace Grenade
	.word dropItem-1				; ID 6: Black Market Grenade
	.word dropItem-1				; ID 7: Key
	.word dropItem-1				; ID 8: Ark (Unused in Inventory)
	.word dropItem-1				; ID 9: Copyright 2 (Shown at Start Screen)
	.word dropWhip-1				; ID 10: Whip (put in Entrance Room)
	.word dropShovel-1				; ID 11: Shovel (Restore to Black Market)
	.word dropItem-1				; ID 12: Copyright 3 (Shown at Start Screen)
	.word dropItem-1				; ID 13: Revolver
	.word dropItem-1				; ID 14: Head of Ra
	.word dropItem-1				; ID 15: Time Piece
	.word dropGrappleItem-1			; ID 16: Ankh
	.word dropChai-1				; ID 17: Chai (Yar's Revenge Check)
	.word dropGrappleItem-1			; ID 18: Hourglass

playerHitJumpTable
	.word playerHitDefault-1				; Treasure Room
	.word playerHitInMarket-1				; Marketplace
	.word playerHitInEntranceRoom-1			; Entrance Room
	.word playerHitInBlackMarket-1			; Black Market
	.word playerHitDefault-1				; Map Room
	.word playerHitInMesaSide-1				; Mesa Side
	.word playerHitInTempleEntrance-1		; Temple Entrance
	.word playerHitInSpiderRoom-1			; Spider Room
	.word playerHitInRoomOfShiningLight-1	; Room of the Shining Light
	.word playerHitDefault-1				; Mesa Field
	.word playerHitInValleyOfPoison-1		; Valley of Poison
	.word playerHitInThievesDen-1			; Thieves Den
	.word playerHitInWellOfSouls-1			; Well of Souls

playfieldHitJumpTable:
	.word checkMissile0Hit-1				; Treasure Room
	.word checkMissile0Hit-1				; Marketplace
	.word exitToTempleEntrance-1			; Entrance Room
	.word checkMissile0Hit-1				; Black Market
	.word checkMissile0Hit-1				; Map Room
	.word indyMoveOnInput-1					; Mesa Side
	.word stopIndyMovInTemple-1				; Temple Entrance
	.word indyMoveOnInput-1					; Spider Room
	.word playerHitInRoomOfShiningLight-1	; Room of the Shining Light
	.word checkMissile0Hit-1				; Mesa Field
	.word indyEnterHole-1					; Valley of Poison
	.word checkMissile0Hit-1				; Thieves Den
	.word checkMissile0Hit-1				; Well of Souls

roomIdleHandlerJmpTable:
	.word checkMissile0Hit-1				; Treasure Room
	.word checkMissile0Hit-1				; Marketplace
	.word setIndyToTriggeredState-1			; Entrance Room
	.word checkMissile0Hit-1				; Black Market
	.word initFallbackEntryPosition-1		; Map Room
	.word checkMissile0Hit-1				; Mesa Side
	.word checkMissile0Hit-1				; Temple Entrance
	.word checkMissile0Hit-1				; Spider Room
	.word checkMissile0Hit-1				; Room of the Shining Light
	.word warpToMesaSide-1					; Mesa Field
	.word setIndyToTriggeredState-1			; Valley of Poison
	.word checkMissile0Hit-1				; Thieves Den
	.word checkMissile0Hit-1				; Well of Souls

placeItemInInventory
	ldx		inventoryItemCount				; get number of inventory items
	cpx		#MAX_INVENTORY_ITEMS			; is Indy carrying fill inventory? (6)
	bcc		getSpaceForItem					; branch if Indy has room to carry more items
	clc
	rts

getSpaceForItem
	ldx		#$0a							; start from last inventory slot (10)
invSearchLoop
	ldy		invSlotLo,x						; get the LSB for the inventory graphic
	beq		addItem							; branch if current slot is free
	dex
	dex										; Move to the previous slot
	bpl		invSearchLoop
	brk										; break if no more items can be carried
											; (Should never happen -- if ItemCount < Max)

addItem
	tay										; move item number to y
	asl										; multiply object number by 8 for gfx
	asl										;...
	asl										;...
	sta		invSlotLo,x						; place graphic LSB in inventory
	lda		inventoryItemCount				; get number of inventory items
	bne		updateInventory					; branch if Indy carrying items
	stx		selectedItemSlot				; set index to newly picked up item
	sty		selectedInventoryId				; set the current selected inventory id
updateInventory
	inc		inventoryItemCount				; increment number of inventory items
	cpy		#ID_INVENTORY_COINS				; If ID < Coins'
	bcc		finishInventoryUpdate			; ex Flute, Parachute, skip marking as "Taken"
	tya										; move item number to accumulator
	tax										; move item number to x
	jsr		showItemAsTaken					; Mark item as taken in global bitmasks
finishInventoryUpdate
	lda		#$0c							; Make sound
	sta		soundChan0Effect				; play with Indy's footstep sound
	sec
	rts

setItemAsNotTaken
; Mark an item as available again (not taken). Uses itemIndexTable bit 0
; to determine which bitmask: even index = basketItemStatus (spawnable),
; odd index = pickupItemStatus (unique).
	lda		itemIndexTable,x				; get the item index value
	lsr										; shift bit 0 to carry (even=basket, odd=pickup)
	tay
	lda		itemStatusMaskTable,y			; load clear-mask for this item
	bcs		showItemAsNotTaken				; carry set = unique pickup item
	and		basketItemStatus
	sta		basketItemStatus				; clear bit — item available at world location again
	rts

showItemAsNotTaken
	and		pickupItemStatus
	sta		pickupItemStatus				; clear bit — unique item returned to world
	rts

showItemAsTaken
; Mark an item as taken. Uses itemIndexTable bit 0 to select bitmask.
	lda		itemIndexTable,x				; get the item index value
	lsr										; shift bit 0 to carry (even=basket, odd=pickup)
	tax
	lda		itemStatusBitValues,x			; get item's status bit
	bcs		pickUpItemTaken					; carry set = unique pickup item
	ora		basketItemStatus
	sta		basketItemStatus				; set bit — item taken from world location
	rts

pickUpItemTaken
	ora		pickupItemStatus
	sta		pickupItemStatus				; set bit — unique item collected
	rts

isItemAlreadyTaken:
; Check if an item has already been collected. Returns carry set if taken.
	lda		itemIndexTable,x				; get the item index value
	lsr										; shift bit 0 to carry (even=basket, odd=pickup)
	tay
	lda		itemStatusBitValues,y			; get item's status bit
	bcs		isItemTaken						; carry set = unique pickup item
	and		basketItemStatus				; check if spawnable item was taken
	beq		finishIsItemTaken				; zero = not taken
	sec										; set carry = item already taken
finishIsItemTaken:
	rts

isItemTaken:
	and		pickupItemStatus				; check if unique item was collected
	bne		finishIsItemTaken				; nonzero = already taken
	clc										; clear carry = item not yet taken
	rts


updateRoomEventState
	and		#$1f
	tax
	lda		swarmEventCounter
	cpx		#$0c
	bcs		doneRoomEventState
	adc		swarmEventCounterTable,x
	sta		swarmEventCounter
doneRoomEventState
	rts

startGame
; Set up everything so the power up state is known.
;
	sei										; turn off interrupts
	cld										; clear decimal flag (no bcd)
	ldx		#$ff							; Load X with $FF.
	txs										; reset the stack pointer
	inx										; clear x
	txa										; clear a
clearZeroPage
	sta		VSYNC,x							; clear zero page variables and TIA regs
	dex										; Decrement X.
	bne		clearZeroPage					; Loop until all 256 bytes are cleared.
	dex										; x = $ff
	stx		adventurePoints					; reset adventurePoints
	; -------------------------------------------------------------------------
	; INITIALIZE INVENTORY WITH COPYRIGHT
	;
	; The game displays the Copyright Notice ("(c) 1982 Atari Inc") inside the
	; Inventory Strip at the very beginning of the game or after a reset.
	; It manually populates the `inventoryGfxPtrs` with the Copyright_X sprites.
	; -------------------------------------------------------------------------
	lda		#>emptySprite					; blank inventory
	sta		invSlotHi						; slot 1
	sta		invSlotHi2						; slot 2
	sta		invSlotHi3						; slot 3
	sta		invSlotHi4						; slot 4
	sta		invSlotHi5						; slot 5
	sta		invSlotHi6						; slot 6

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
	lda		#ID_ARK_ROOM					; set "ark elevator room" (room 13)
	sta		currentRoomId					; as current room
	lsr										; A = ID_ARK_ROOM / 2 (becomes 6)
	sta		bulletCount						; load 6 bullets
	jsr		initRoomState					; Init various screen and game state
	jmp		startNewFrame					; Jump to the main game loop.

initGameVars:
	lda		#<invCoinsSprite
	sta		invSlotLo						; place coins in Indy's inventory
	lsr										; divide by 8 to get the inventory id
	lsr
	lsr
	sta		selectedInventoryId				; set the current selected inventory id
	inc		inventoryItemCount				; increment number of inventory items
	lda		#<emptySprite
	sta		invSlotLo2						; clear the remainder of Indy's inventory
	sta		invSlotLo3
	sta		invSlotLo4
	sta		invSlotLo5
	lda		#INIT_SCORE						; set initial adventurePoints
	sta		adventurePoints
	lda		#<indyStandSprite				; set Indy's initial sprite (standing)
	sta		indyGfxPtrLo
	lda		#>indySprites
	sta		indyGfxPtrHi
	lda		#SCREEN_CENTER_X
	sta		indyPosX						; set Indy's initial X position
	lda		#$0f
	sta		indyPosY						; set Indy's initial Y position
	lda		#ID_ENTRANCE_ROOM
	sta		currentRoomId					; set current room to Entrance Room
	sta		livesLeft						; set initial number of lives
	jsr		initRoomState					; Initialize new room state.
	jmp		setupNewRoom					; Setup the screen and objects for the
											; entrance room.

;------------------------------------------------------------
; getFinalScore
; The player's progress is determined by Indy's height on the pedestal when the
; game is complete. The player wants to achieve the lowest adventure points
; possible to lower Indy's position on the pedestal.
;
getFinalScore
	lda		adventurePoints					; load adventurePoints
	sec										; positve actions...
	sbc		findingArkBonus					; found the ark
	sbc		usingParachuteBonus				; parachute used
	sbc		ankhUsedBonus					; ankh used (Mesa Skip)
	sbc		yarFoundBonus					; yar found
	sbc		livesLeft						; lives left
	sbc		mapRoomBonus					; used the Head of Ra in the Map Room
	sbc		mesaLandingBonus				; landed in Mesa
	sbc		unusedBonus						; never used (always 0)
	clc										; negitive actions...
	adc		grenadeOpeningPenalty			; gernade used on wall (2 points)
	adc		escapePrisonPenalty				; escape hatch used (13 points)
	adc		thiefShotPenalty				; thief shot (4 points)
	sta		adventurePoints					; store in final adventurePoints
	rts										; return

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


mesaGridMapTable
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
	sta		temp4
	lda		#>drawScreen
	sta		temp5
jumpToBank1
	lda		#LDA_ABS
	sta		temp0
	lda		#<BANK1STROBE
	sta		temp1
	lda		#>BANK1STROBE
	sta		temp2
	lda		#JMP_ABS
	sta		temp3
	jmp.w	temp0

getMoveDir
	ror								;move first bit into carry
	bcs		movEmyRight			;if 1 check if enemy shoulld go right
	dec		p0PosY,x				;move enemy left 1 unit
movEmyRight
	ror								;rotate next bit into carry
	bcs		movEmyDown				;if 1 check if enemy should go up
	inc		p0PosY,x				;move enemy right 1 unit
movEmyDown
	ror								;rotate next bit into carry
	bcs		movEmyUp				;if 1 check if enemy should go up
	dec		p0PosX,x				;move enemy down 1 unit
movEmyUp
	ror								;rotate next bit into carry
	bcs		movEmyFinish			;if 1, moves are finished
	inc		p0PosX,x				;move enemy up 1 unit
movEmyFinish
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


swarmEventCounterTable
	.byte $00,$06,$03,$03,$03,$00,$00,$06,$00,$00,$00,$06


	.org BANK0TOP + 4096 - 6, 0

	;Vector Table
	.word startGame							;NMI
	.word startGame							;RESET
	.word startGame							;IRQ/BRK


;***********************************************************
;	bank 1 / (Second bank)
;***********************************************************


	seg		bank1						; Bank 1 Segment
	org		BANK1TOP					; Physical address of 2nd bank in ROM   ($1000-$1FFF)
	rorg	BANK1_REORG					; Shift to logical address for 2nd bank ($F000-$FFFF)

bank1Start
	lda		BANK0STROBE

scrollingPlayfieldKernel
; This loop draws the main playfield area.
; It handles walls, background graphics, and player sprites.
	cmp		p0DrawStartLine				; Check against graphics data/state.
	bcs		dungeonWallScanlineHandler	; Branch if carry set.
	lsr									; Divide by 2.
	clc									; Clear carry
	adc		roomObjectVar				; Add vertical offset.
	tay									; Transfer to Y index.
	sta		WSYNC						; Wait for Horizontal Sync.
;---------------------------------------
	sta		HMOVE						; Apply horizontal motion.
	lda		(pf1GfxPtrLo),y				; Load PF1 graphics data.
	sta		PF1							; Store in PF1.
	lda		(pf2GfxPtrLo),y				; Load PF2 graphics data.
	sta		PF2							; Store in PF2.
	bcc		drawIndySprite				; Branch to draw player sprites.
dungeonWallScanlineHandler
	sbc		kernelRenderState			; Adjust for snake/dungeon state.
	lsr									; Divide by 4.
	lsr
	sta		WSYNC						; Wait for Horizontal Sync.
;---------------------------------------
	sta		HMOVE						; Apply horizontal motion.
	tax									; Transfer A to X.
	cpx		snakePosY					; Compare with Snake vertical position.
	bcc		drawDungeonWall				; Branch if X < Snake Pos.
	ldx		kernelDataIndex				; Load Timepiece sprite data pointer.
	lda		#$00
	beq		setDungeonWall				; Unconditional branch to store 0.
drawDungeonWall
	lda		dynamicGfxData,x			; Load dungeon graphics data.
	ldx		kernelDataIndex				; Restore X.
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
	sbc		p0PosY						; Subtract Player 0 vertical position.
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
	sbc		ballPosY					; Adjust for object Y.
	cmp		#HEIGHT_ITEM_SPRITES		; Check height range
	bcs		goNextPFScanline			; Skip if outside range.
	tay									; Transfer to Y.
	lda		(kernelDataPtrLo),y			; Load timepiece graphics.
	sta		ENABL						; Enable/Disable Ball.
	sta		HMBL						; Set Horizontal Motion for Ball.
goNextPFScanline
	inc		scanline					; Increment scanline counter.
	lda		scanline
	cmp		#(HEIGHT_KERNEL / 2)		; Compare with kernel height/2.
	bcc		scrollingPlayfieldKernel	; Loop if not done.
	jmp		drawInventoryKernel			; jump to draw the inventory zone.

skipIndyDraw
	ldx		#$00						; Load 0.
	beq		drawP0Sprite				; Proceed to check Player 0.

skipDrawP0Sprite
	ldy		#$00						; Load 0.
	beq		nextPFScanline				; Proceed to next scanline.

staticSpriteKernelCheck
;
; This is used when the player is stationary (or fewer sprites moving).
; Optimizes TIA updates.
;
	cpx		#(HEIGHT_KERNEL / 2) - 1	; Check if kernel scanlines complete.
	bcc		skipP0Draw					; If not done, skip drawing player 0.
	jmp		drawInventoryKernel			; Jump to draw inventory zone.

skipP0Draw
	lda		#$00						; Clear GRP0 (blank scanline).
	beq		nextStillPlayerScanline		; Unconditional branch.

; ---------------------------------------------------------------------------
; drawP0GraphicsStream
;
; Reads bytes from the P0 graphics data stream one per scanline.
; Each byte is either sprite pixel data or an inline command:
;
;   Bit 7 clear: The byte is written directly to GRP0 as sprite pixels.
;   Bit 7 set:   The byte is a command that modifies P0's color or position:
;                  ASL shifts out bit 7, leaving a 7-bit payload.
;                  Bit 0 (original bit 1) selects the target TIA register:
;                    0 → COLUP0  (change P0 color)
;                    1 → HMP0    (apply horizontal motion on next HMOVE)
;                  The remaining bits are the value written.
;
; This works because pf1GfxPtrLo/Hi for rooms 0-5 point to COLUP0 ($06),
; and pf2GfxPtrLo/Hi point to HMP0 ($20). The indexed indirect addressing
; (pf1GfxPtrLo,x) with X=0 writes to COLUP0, X=2 writes to HMP0.
;
; GRP0 retains its last value across command-only scanlines, so filled
; regions persist while color/position changes reshape the sprite.
; HMOVE is strobed every scanline, so accumulated HMP0 writes produce
; diagonal or curved edges (e.g., the Mesa Side tree trunk/branches).
; ---------------------------------------------------------------------------
drawP0GraphicsStream
	lda		(p0GfxPtrLo),y				; Load next byte from P0 data stream.
	bmi		setP0Values					; Bit 7 set → decode as command byte.
	cpy		roomObjectVar				; Past end of drawable region?
	bcs		staticSpriteKernelCheck		; Yes → exit P0 drawing loop.
	cpy		p0PosY						; Above P0 start position?
	bcc		skipP0Draw					; Yes → skip (not in sprite range yet).
	sta		GRP0						; Write pixel data to GRP0.
	bcs		nextStillPlayerScanline		; Unconditional → advance scanline.

setP0Values
; Decode command byte: bit 7 was set, so ASL shifts it out.
; After ASL, bit 0 (originally bit 1) selects the target register.
	asl									; Shift out bit 7; payload in bits 7-1.
	tay									; Save shifted value in Y.
	and		#$02						; Isolate bit 1 (register select).
	tax									; X=0 → COLUP0, X=2 → HMP0.
	tya									; Restore shifted value (payload + select bit).
	sta		(pf1GfxPtrLo,x)			; Write to selected TIA register.

nextStillPlayerScanline
	inc		scanline					; Increment scanline counter.
	ldx		scanline					; Load to X.
	lda		#ENABLE_BM					; Load Enable Missile mask value.
	cpx		m0PosY						; Compare with M0 vertical position.
	bcc		skipM0Draw					; Branch if not reached.
	cpx		p0DrawStartLine					; Compare with P0 Graphics Data.
	bcc		setMissleEnable				; Enable missile.

skipM0Draw
	ror									; Rotate right.

setMissleEnable
	sta		ENAM0						; Store to ENAM0.

staticSpriteKernel
	sta		WSYNC
;---------------------------------------
	sta		HMOVE						; Execute horizontal move.
	txa									; Move scanline count to A.
	sec									; Set carry for subtraction.
	sbc		snakePosY					; Subtract Snake vertical position.
	cmp		#$10						; Compare with 16.
	bcs		burn19Cycles				; Branch if snake not active here.
	tay									; Transfer to Y.
	cmp		#HEIGHT_ITEM_SPRITES		; Compare with 8 (upper/lower half split).
	bcc		burn5Cycles					; Branch if < 8.
	lda		kernelDataIndex				; Load pointer to timepiece sprite data.
	sta		kernelDataPtrLo				; Store in graphics pointer.
drawTimepieceSprite
	lda		(kernelDataPtrLo),y			; Load timepiece graphics.
	sta		HMBL						; Store in Ball Horizontal Motion check.

setMissile1Enable
	ldy		#DISABLE_BM					; Default to disable missile.
	txa									; Move scanlineCounter to A.
	cmp		weaponPosY					; Compare with weapon position.
	bne		updateMissile1Enable		; If not weapon pos, skip enable.
	dey									; Enable missile (Y becomes $FF/Enable).
updateMissile1Enable
	sty		ENAM1						; Update Missile 1 Enable.
	sec									; Set carry.
	sbc		indyPosY					; Subtract Indy vertical position.
	cmp		indySpriteHeight			; Compare with sprite height.
	bcs		skipStaticPlayer1Sprite		; Skip if outside sprite.
	tay									; Transfer to Y (sprite index).
	lda		(indyGfxPtrLo),y			; Load Indy graphics.

staticPlayer1Sprite
	ldy		scanline					; Restore scanline counter to Y.
	sta		GRP1						; Store in GRP1.
	sta		WSYNC
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	lda		#ENABLE_BM					; Load Enable Ball value.
	cpx		ballPosY					; Compare scanline with Snake Y.
	bcc		skipDrawingTheBall			; Branch if below.
	cpx		p0SpriteHeight				; Compare with p0SpriteHeight
	bcc		setBallEnable				; Enable ball.

skipBallDraw
	ror									; Rotate right.

setBallEnable
	sta		ENABL						; Update Ball Enable.
	bcc		drawP0GraphicsStream		; Loop back to process next data byte.

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

skipStaticPlayer1Sprite
	lda		#$00						; Load 0 (clear graphics).
	beq		staticPlayer1Sprite			; Jump back to store 0 in GRP1.

advanceStillKernelScanline
	inx									; Increment scanline counter.
	sta		HMCLR						; Clear horizontal motion.
	cpx		#HEIGHT_KERNEL				; Check limit.
	bcc		multiplexedSpriteKernel		; Branch if not done.
	jmp		drawInventoryKernel			; Jump to Inventory Kernel.

thiefKernel
	sta		WSYNC
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	inx									; Increment scanline counter.
	lda		temp0						; Load thief gfx line.
	sta		GRP0						; Store to GRP0 (Thief/Player 0).
	lda		temp1						; Load thief color line
	sta		COLUP0						; Store to COLUP0.
	txa									; Move scanline to A.
	ldx		#<ENABL						; Load address of ENABL
	txs									; Set Stack Pointer to $1F.
										; This allows PHP to write to
										; TIA registers via stack mirror
										; $01xx -> $00xx.
	tax									; Move scanline to X.
	lsr									; Divide Scanline by 2.
	cmp		ballPosY					; Compare with Ball Y.
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
	bcs		advanceStillKernelScanline	; If outside (Carry Set), branch back.
	tay									; Use result as Y index.
	lda		(indyGfxPtrLo),y			; Load Indy graphics.
	sta		HMCLR						; Clear horizontal motion.
	inx									; Increment scanline.
	sta		GRP1						; Store Indy graphics.

multiplexedSpriteKernel
	sta		WSYNC
;---------------------------------------
	sta		HMOVE						; Execute HMOVE.
	bit		kernelRenderState			; Check state flag to determine
										; if we are positioning or
										; drawing/updating.
	bpl		animateThieves				; If bit 7 is clear, jump to Animation Logic.
	; --------------------------------------------------------------------------
	; THIEF POSITIONING LOGIC
	; If Bit 7 of snakeDungeonState is SET, we are in the "Positioning" phase.
	; --------------------------------------------------------------------------
	ldy		temp5						; Load Fine position timing value
	lda		temp4						; Load Coarse position value (HMOVE).
	lsr		kernelRenderState			; Shift state right (clears Bit 7,
										; moves to next state).
thiefPosTimingLoop
	dey									; Delay loop for horizontal positioning.
	bpl		thiefPosTimingLoop			; Loop until Y < 0.
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
	; If Bit 6 of kernelRenderState is SET, we are drawing the sprite.
	; --------------------------------------------------------------------------
	txa									; Move current scanline count to A.
	and		#$0f						; Mask to lower 4 bits
	tay									; Transfer directly to Y index for graphics.
	lda		(p0GfxPtrLo),y				; Load P0 Graphics data (Indirect Y).
	sta		GRP0						; Store to GRP0 (Draw).
	lda		(kernelDataPtrLo),y			; Load P0 Color data.
	sta		COLUP0						; Store to COLUP0.
	iny									; Next line of sprite data.
	lda		(p0GfxPtrLo),y				; Look ahead: Load next graphics line.
	sta		temp0						; Store next thief gfx line
	lda		(kernelDataPtrLo),y			; Look ahead: Load next color line.
	sta		temp1						; Store next thief color line
	cpy		p0SpriteHeight				; Check if we have drawn the full
										; height of the sprite.
	bcc		returnToThiefKernel			; If Y < Height, continue drawing next line.
	lsr		kernelRenderState			; If done, Shift state right (Clear Bit 6).
returnToThiefKernel
	jmp		thiefKernel					; Jump back to main kernel loop.

updateThiefAnimation
	; --------------------------------------------------------------------------
	; THIEF STATE & ANIMATION SELECTION
	; Determines which thief is active based on scanline height.
	; --------------------------------------------------------------------------
	lda		#$20						; Load Bit 5 mask.
	bit		kernelRenderState			; Check Bit 5 of state.
	beq		thiefFrameSetup				; If Bit 5 clear, proceed to Frame Setup.
	txa									; Move scanline to A.
	lsr									; Shift right 5 times (Divide by 32)
	lsr									; 32 scanlines allocated per thief zone?
	lsr
	lsr
	lsr
	bcs		thiefKernel					; If Carry Set
	tay									; Y = Thief Index (0-4).
	sty		temp3						; Store thief index
	lda.wy	roomObjectVar,y				; Load State for this Thief.
	sta		REFP0						; Set Reflection (Direction).
	sta		NUSIZ0						; Set Number/Size
	sta		temp2						; Store thief state
	bpl		finishThiefAnimate			; If Bit 7 clear, jump

	; Special "Digging" state - removes pile of dirt
	; This block replaces the Thief Sprite with the Dirt Pile Sprite.
	lda		dirtPileGfxState			; Load the dirt pile offset modified by Shovel.
										; (e.g., $5C, $5B, ... $54)
	sta		p0GfxPtrLo					; Set as Low Byte of Sprite Pointer.
										; High Byte is inherited from current context
										; (Thief Page or specific override)
	lda		#<dirtPileColorBase			; Dirt pile color data (reads 16 bytes:
										; 7 × $FF from fullDirtPile as BROWN+15,
										; then dirtPileColorGradient RED→YELLOW)
	sta		kernelDataPtrLo				; Set Color Pointer Low Byte.
	lda		#$00						; Clear A.
	sta		kernelRenderState			; Ensure state stays in "Dig Mode".
	jmp		thiefKernel					; Return.

finishThiefAnimate
	lsr		kernelRenderState					; Shift state (Bit 5 cleared).
	jmp		thiefKernel					; Return.

thiefFrameSetup
	; --------------------------------------------------------------------------
	; ANIMATION FRAME SELECTION
	; Calculates the correct animation frame based on movement.
	; --------------------------------------------------------------------------
	lsr									; Shift A
	bit		kernelRenderState			; Check state (Bit 4?).
	beq		thiefSpecialAnimate			; If zero, jump to Special Case.
	ldy		temp3						; Restore Thief Index.
	lda		#REFLECT					; Load Reflect bit mask.
	and		temp2						; Check thief state
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
	sta		kernelDataPtrLo				; Set Color Pointer LSB.
	lda		#HEIGHT_THIEF - 1			; Load Height for Thief (-1).
	sta		p0SpriteHeight				; Set Height.
	lsr		kernelRenderState			; Shift state.
	jmp		thiefKernel					; Return.

thiefSpecialAnimate
	txa
	and		#$1f						; Move scanline to A.
	cmp		#$0c						; Compare
	beq		thiefSpriteHandeler			; Branch if equal.
	jmp		thiefKernel					; Jump back.

thiefSpriteHandeler
	ldy		temp3						; Load thief index
	lda.wy	thiefPosX,y					; Load horizontal position.
	sta		temp4						; Store coarse position.
	and		#$0f						; Mask low nibble.
	sta		temp5						; Store fine position.
	lda		#$80						; Load $80.
	sta		kernelRenderState			; Store state.
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
	ldx		#HMOVE_0					; No motion.
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
	and		timeOfDay					; Check timer.
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
	sta		temp0						; Set loop counter.

drawInventoryItems
	ldy		temp0						; Load Y with index.
	lda		(invSlotLo),y				; Load inv item 1.
	sta		GRP0						; Store GRP0.
	sta		WSYNC
;---------------------------------------
	lda		(invSlotLo2),y				; Load inv item 2.
	sta		GRP1						; Store GRP1.
	lda		(invSlotLo3),y				; Load inv item 3.
	sta		GRP0						; Store GRP0
	lda		(invSlotLo4),y				; Load inv item 4.
	sta		temp1						; Save to temp.
	lda		(invSlotLo5),y				; Load inv item 5.
	tax									; Save to X.
	lda		(invSlotLo6),y				; Load inv item 6.
	tay									; Save to Y
	lda		temp1						; Restore item 4.
	sta		GRP1						; Store GRP1
	stx		GRP0						; Store item 5 to GRP0.
	sty		GRP1						; Store item 6 to GRP1.
	sty		GRP0						; Store item 6 to GRP0
	dec		temp0						; Decrement counter.
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
	lda		soundChan0Effect,x			; Load sound control byte
	sta		AUDC0,x						; Set Distortion Type (Uses Low Nibble)
	sta		AUDV0,x						; Set Volume (Uses Low Nibble)
	bmi		dispatchMusicType			; If Bit 7 Set -> Sustain/Sequence Logic
	; --- One-Shot / Decay Logic ---
	ldy		#$00						; Prepare 0
	sty		soundChan0Effect,x			; Clear the source variable

updateSoundFreq
	sta		AUDF0,x						; Set Frequency
	dex									; Decrement Channel Index
	bpl		updateSoundRegisters		; Loop for next channel
	bmi		finishUpdateSound			; All channels done

dispatchMusicType
	cmp		#RAIDERS_MARCH				; Check for "Main Theme" Sound ID
	bne		playFluteMelody				; If not $9C, play "Snake Charmer Song"

	; -----------------------------------------------------------------------
	; RAIDERS MARCH (Title Screen / End Game)
	; -----------------------------------------------------------------------
	; The theme loops based on a timer ($A4) that counts down.
	; -----------------------------------------------------------------------
	lda		#$0f
	and		frameCount					; Slow tick
	bne		playRaidersMarch			; If not tick, just verify timer
	dec		musicNoteIndex				; Decrement note index
	bpl		playRaidersMarch			; If still positive, play
	lda		#$17						; Reset timer to start (Loop)
	sta		musicNoteIndex

playRaidersMarch
	ldy		musicNoteIndex				; Get current note index
	lda		raidersMarchFreqTable ,y	; Look up Frequency from Table
	bne		updateSoundFreq				; Go to write Frequency

	; -----------------------------------------------------------------------
	; FLUTE MELODY (Snake Charmer)
	; -----------------------------------------------------------------------
	; Procedurally generates music based on the master frame counter.
	; -----------------------------------------------------------------------
playFluteMelody							; get global frame counter
	lda		frameCount
	lsr									; Divide by 16 (Plays note for ~16 frames)
	lsr
	lsr
	lsr
	tay									; Use as index
	lda		snakeCharmFreqTable,y		; Look up Note/Frequency
	bne		updateSoundFreq				; Go to write Frequency

finishUpdateSound
	lda		selectedInventoryId			; Get current selected inventory id.
	cmp		#ID_INVENTORY_TIME_PIECE	; Is it the Time Piece?
	beq		openTimepiece				; Check for Time Piece display action.
	cmp		#ID_INVENTORY_FLUTE			; Is it the Flute?
	bne		resetInventoryState			; If NOT Flute, skip music.

	; --- Flute Music Logic ---
	lda		#SNAKE_CHARM_SONG			; Load Sound/Frequency Value
	sta		soundChan1Effect			; Store sound effect control
	bne		updateEventState			; Unconditional branch.

openTimepiece
	bit		INPT5|$30					; read action button from right controller
	bpl		updateTimepieceSprite		; branch if action button pressed
	lda		#<closedTimepieceSprite
	bne		storeTimepieceSprite		; unconditional branch

updateTimepieceSprite
	; --------------------------------------------------------------------------
	; UPDATE TIMEPIECE GRAPHIC
	; The timepiece in the inventory shows the passing of time by hand rotation.
	; Uses timeOfDay to select the correct graphic frame.
	; --------------------------------------------------------------------------
	lda		timeOfDay					; Load seconds counter.
	and		#$e0						; Keep top 3 bits for the 8 sprites
	lsr
	lsr
	adc		#<timepiece1200			; Add Base Address of Timepiece Graphics.

storeTimepieceSprite
	ldx		selectedItemSlot			; Get the current slot for the timepiece.
	sta		invSlotLo,x					; Update the graphics pointer (Low Byte).

resetInventoryState
	lda		#$00						; Clear A.
	sta		soundChan1Effect			; Reset sound effect

updateEventState
	bit		screenEventState			; Check for special inventory event.
	bpl		updateInvItemPos			; If Bit 7 clear, skip to standard update.

	; --------------------------------------------------------------------------
	; INVENTORY EVENT ANIMATION
	; --------------------------------------------------------------------------
	lda		frameCount					; Get current frame coun
	and		#$07						; Mask lower 3 bits.
	cmp		#$05						; Compare with 5.
	bcc		updateInvEventState			; If < 5, Update Animation State.
	ldx		#$04						; X = 4.
	ldy		#$01						; Y = 1.
	bit		indyStatus				; Check major event flag
	bmi		setInvEventStateTo3			; If Set (Minus), Set Y=3.
	bit		eventTimer					; Check event Timer
	bpl		updateInvEventStateAfterYSet	; If positive, skip.

setInvEventStateTo3
	ldy		#$03						; Set Y = 3.

updateInvEventStateAfterYSet
	jsr		updateMoveToTarget			; Call Object Position Handler.

updateInvEventState
	lda		frameCount					; Get current frame count.
	and		#$06						; Mask bits 1 and 2.
	asl									; Shift left
	asl
	sta		kernelDataPtrLo				; Update Timepiece Graphics Pointer
	lda		#>timepieceBallFrame0	; Timepiece ball animation data page
	sta		kernelDataPtrHi				; Set timepiece gfx page

updateInvItemPos
	; --------------------------------------------------------------------------
	; POSITION INVENTORY OBJECTS
	; Positions the strip of 3 items visible in the inventory.
	; --------------------------------------------------------------------------
	ldx		#$02						; Start at Index 2.

invObjPosLoop
	jsr		updateInvObjPos				; Update Position for Item X.
	inx									; Next Item.
	cpx		#$05						; Loop until 5.
	bcc		invObjPosLoop				; Loop.
	bit		indyStatus				; Check major event (death).
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
	stx		soundChan1Effect			; Sound update (death sequence)
	cpx		#$03						; Check if height is at hat (3 lines).
	bcc		removeIndySpriteLine		; If < 3, delete hat
	lda		#$8f						; Load Y Position?
	sta		weaponPosY					; Reset Weapon Y Position.
	stx		indySpriteHeight			; Save new Height.
	bcs		jmpToNewFrame				; Always branch.
removeIndySpriteLine
	sta		frameCount					; Reset Frame Count
	sec									; Set Carry
	ror		indyStatus					; remove one line from sprite height
indyHatPause
	cmp		#$3c						; Compare A with 60
	bcc		resetIndyAfterDeath			; If < 60, Continue.
	bne		indyvanish					; If != 60, Reset.
	sta		soundChan1Effect			; Store sound effect.
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
	sta		soundChan1Effect			; Store sound effect.
	sta		indyStatus					; Reset flag.
	dec		livesLeft					; Decrement Lives.
	bpl		jmpToNewFrame				; If Lives >= 0, Continue Game.
	lda		#INDY_GAMEOVER				; Game Over State
	sta		indyStatus					; Set flag (game over).
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
	sta		temp4						; Store bank-switch jump target lo
	lda		#>newFrame					; Load MSB address to start new frame
	sta		temp5						; Store bank-switch jump target hi
	jmp		jumpToBank0					; Jump to routine in Bank 0

checkInvCycle
	bit		grappleWhipState			; Check grapple/whip state.
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
	cmp		#<timepiece1200
	bcc		checkInvItemChoice			; branch if the item is not open clock sprite
	lda		#<closedTimepieceSprite		; close the timepiece

checkInvItemChoice
	bit		SWCHA						; check joystick values
	bmi		checkInvCycleLeft			; branch if left joystick not pushed right
	sta		invSlotLo,x					; set inventory graphic LSB value

checkInvCycleRight
	inx
	inx									; Move to next slot (2-byte stride)
	cpx		#INVENTORY_SLOT_LIMIT
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
	sta		grappleWhipState			; Set grapple state.
	lda		indyPosY					; Get Indy's vertical position.
	adc		#$09						; Add Offset for crosshair.
	sta		weaponPosY					; Set Object Y to Indy Y + 9.
	lda		indyPosX					; Get Indy's horizontal position.
	adc		#$09						; Add Offset for crosshair.
	sta		weaponPosX					; Set Object X to Indy X + 9.

finishInvCycle
	lda		grappleWhipState			; Check grapple/whip state.
	bpl		handleInvSelectAdj			; If Bit 7 Clear, go to standard collision.

	; --------------------------------------------------------------------------
	; EVENT STATE UPDATE
	; If Bit 7 is set, we are in an active sequence (swinging grapple).
	; Increments the state value (Timer/Stage).
	; --------------------------------------------------------------------------
	cmp		#$bf						; Check if state has reached terminal value.
	bcs		handleInvSelEdgeCase		; If >= $BF, handle end case.
	adc		#$10						; Increment High Nibble (Timer/Stage).
	sta		grappleWhipState			; Update grapple stage.
	ldx		#$03						; Load Index 3.
	jsr		invSelectAdjHandler			; Call Handler.
	jmp		jmpObjHitHandeler			; Return.

handleInvSelEdgeCase
	lda		#$70						; Load $70.
	sta		weaponPosY					; Reset Object Y.
	lsr									; Divide by 2 -> $38.
	sta		grappleWhipState			; Set grapple state to $38 (Bit 7 Clear).
	bne		jmpObjHitHandeler			; Return.

handleInvSelectAdj
	; --------------------------------------------------------------------------
	; INVENTORY SELECTION / CURSOR ALIGNMENT
	; Checks if Indy's position aligns with the crosshair cursor.
	; Used to determine if Indy has "hit" the target when using the grapple.
	; --------------------------------------------------------------------------
	bit		grappleWhipState			; Check grapple state.
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
	eor		grappleWhipState			; Toggle state bits based on alignment.
	sta		grappleWhipState			; Store state.
	bne		jmpObjHitHandeler			; Return.

checkBoundary
	cmp		#$4a						; Check Y Boundary.
	bcs		handleLeftBoundary			; If >= $4A, trigger special value update.

jmpObjHitHandeler
	; --------------------------------------------------------------------------
	; BANK SWITCH RETURN
	; Return to checkForObjHit in Bank 0.
	; --------------------------------------------------------------------------
	lda		#<checkForObjHit
	sta		temp4
	lda		#>checkForObjHit
	sta		temp5
jumpToBank0
	lda		#LDA_ABS
	sta		temp0
	lda		#<BANK0STROBE
	sta		temp1
	lda		#>BANK0STROBE
	sta		temp2
	lda		#JMP_ABS
	sta		temp3
	jmp.w	temp0


;
; This kernel handles the visuals for the "Ark Room" (Room ID 13).
; This room serves as both the Start Screen (Indy on Pedestal) and the End Screen (Winning Animation).
; Unlike standard rooms, it uses a dedicated scanline loop to draw the Ark (Top) and Pedestal (Bottom).
;
; Visual Logic:
; 1. Top Section (Scanlines 0-18 approx): Checks logic to draw the Ark of the Covenant.
;	 - The Ark is only drawn if arkRoomStateFlag is positive (indicating Win State).
; 2. Mid/Bottom Section: Draws Indy standing on the Lifting Pedestal.

arkPedestalKernel
	sta		WSYNC
;---------------------------------------
	cpx		#$12						; Compare scanline with 18.
	bcc		checkToDrawArk				; Branch if < 18 (Ark area).
	txa									; Move scanline to A.
	sbc		indyPosY					; Subtract Indy Y to check relative position
	bmi		nextArkRoomScanline			; If negative, skip drawing Indy line
	cmp		#(HEIGHT_INDY_SPRITE-1)*2	; Compare with Height*2
										; (Double-height sprite check)
	bcs		drawLiftingPedestal			; If > Height*2, draw pedestal bits instead
	lsr									; Divide by 2 (Sprite shift)
	tay									; Transfer to Y index
	lda		indyStandSprite,y			; Load Indy standing sprite data
	jmp		drawPlayer1Sprite			; Jump to common draw routine

drawLiftingPedestal
	and		#$03						; Mask low 2 bits for Pedestal pattern
	tay									; Transfer to Y
	lda		pedestalLiftSprite,y		; Load Pedestal lift diamond Sprite data

drawPlayer1Sprite
	sta		GRP1						; Store in GRP1 (Player 1 Graphics)
	lda		indyPosY					; Load Indy Y Position
	sta		COLUP1						; Set Color P1 (flash indy sprite colors)

nextArkRoomScanline
	inx									; Increment scanline counter
	cpx		#$90						; check if kernel finished (144 scanlines)
	bcs		drawArkBody					; Branch if >= 144 to finish up
	bcc		arkPedestalKernel			; Loop back if not done

checkToDrawArk
	bit		arkRoomStateFlag				; Check Game State Flag
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
	bcc		arkPedestalKernel			; Loop

drawArkBody
	sta		WSYNC
;---------------------------------------
	cpx		#$20						; Compare with 32.
	bcs		checkToDrawPedestal			; Branch if >= 32.
	bit		arkRoomStateFlag			; Check flag.
	bmi		arkDrawLoop					; Skip.
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
	beq		arkPedestalKernel			; Jump back to main loop.

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
	lda		roomHandlerJmpTable + 1 ,x	; get room handeler from jump table
	pha									; push MSB
	lda		roomHandlerJmpTable,x		; Get LSB
	pha									; push to stack too
	rts									; return

mesaFieldRoomHandler:
	; --------------------------------------------------------------------------
	; MESA FIELD / VALLEY OF POISON (Bank 1 Logic)
	; --------------------------------------------------------------------------
	; This makes sure that everything is "pinned"
	; to the vertical center of the screen ($7F) during a scroll
	; --------------------------------------------------------------------------
		lda		#$7f						; Y screen center
		sta		p0PosY						; Pin Player 0 to Center Y
		sta		m0PosY						; Pin Missile 0 to Center Y
		sta		ballPosY					; Pin Ball to Center Y
		bne		finishRoomHandle			; Exit

spiderRoomHandler:
		ldx		#$00						; X = 0 (Spider Object / Player 0 Index)
		ldy		#$01						; Y = Offset to Indy's Y Position in array
		bit		CXP1FB						; Check P1 (Indy) vs Playfield (Walls) hit
		bmi		updateMoveSpider			; If Indy touches walls, Agro Spider
		bit		spiderRoomState				; Check bit 7 of spiderRoomState
											; (Set if Indy touches the Web/M0)
		bmi		updateMoveSpider			; If Indy trapped in web, Spider
											; enters "Aggressive Mode" (Chases Indy)
	; Mode: Passive (Guard Nest)
	; Spider moves slowly (once every 8 frames) back to the top of the screen.
		lda		frameCount					; Get global frame counter
		and		#$07						; check every 8th frame
		bne		animateSpider				; If not the 8th frame, skip movement update
		ldy		#$05						; Set Target Index to 5 (a unused/static slot?)
		lda		#SCREEN_CENTER_X			; Passive target X = center
		sta		targetPosX					; Set AI chase target X
		lda		#$23						; Set Passive home Target Y = $23
		sta		targetPosY					; Store in target variable for
updateMoveSpider:
	; Calls generic handler to move Object[X] towards Object[Y].
	; Valid inputs at this point:
	;	Aggressive: X=0(Spider), Y=Indy Offset. Result: Spider moves to Indy.
	;	Passive:	X=0(Spider), Y=5(Static).	Result: Spider moves to Home ($23)
		jsr		updateMoveToTarget			; Execute movement logic
animateSpider:
		lda		#$80						; Set bit 7
		sta		screenEventState			; Update screen event flags
	; Animation Logic
	; Calculates a sprite frame based on position to simulate scuttling.
		lda		p0PosY						; Load Spider Vertical Position
		and		#$01						; Check LSB (Odd/Even pixel)
		ror		p0PosX						; Rotate Spider X into Carry
		rol									; Rotate Carry into A
		tay									; Use result as index into sprite table
		ror									; Restore Carry
		rol		p0PosX						; Restore Spider X Position
		lda		spiderSpriteTable,y			; Load the appropriate Spider Sprite frame
		sta		p0GfxPtrLo					; Store Low Byte of sprite pointer
		lda		#>spiderSprites				; Start at first spider frame
		sta		p0GfxPtrHi					; Store High Byte of sprite pointer

	; Web (Missile 0) Logic
	; The "Web" is represented by Missile 0 held in a fixed position.
		lda		m0PosYShadow				; Check Shadow Variable for M0
		bmi		finishRoomHandle			; If negative (disabled/offscreen), exit
		ldx		#XMAX / 2					; Set Web Horizontal Position to center
		stx		m0PosX
		ldx		#$26						; Set Web Vertical Position to $26
		stx		m0PosY

		; State / Animation Timer Logic
		lda		spiderRoomState				; Check main state
		bmi		finishRoomHandle			; If Bit 7 set (Aggressive/Caught),
											; skip passive animation updates
		bit		indyStatus				; Check if a major event
		bmi		finishRoomHandle			; If so, skip
		and		#$07						; Mask lower 3 bits (Animation Timer)
		bne		updateSpiderSpriteState	; If timer != 0, go update sprite state shadow
		ldy		#$06						; Reset timer/state to 6
		sty		spiderRoomState				; Store back

updateSpiderSpriteState:
		tax									; Use A (masked spiderRoomState) as index
		lda		treasureRoomItemStateTable,x	; Load a value from table
		sta		m0PosYShadow				; Update the shadow variable
		dec		spiderRoomState				; Decrement the timer/state counter

finishRoomHandle:
		jmp		jmpSetupNewRoom				; Return to Bank 0 Dispatcher

; Screen ID 06: Valley of Poison
valleyOfPoisonRoomHandler:
		lda		#$80						; Set Bit 7 ($80) in Screen Event State.
		sta		screenEventState			; screenEventState = $80 (Active).
		ldx		#$00						; X = 0.
		bit		indyStatus				; Check major event flag
		bmi		thiefEscape					;  If Major Event Set (Negative),
											; Enter thief escape mode.
		bit		pickupStatusFlags			; Check Pickup Status (Bit 6 = Overflow).
		bvc		thiefChase					; If Overflow Clear (No Item Stolen),
											; Enter thief chase Mode.
thiefEscape:
	; Mode: Thief Escape (Man in Black leaves with item or during death)
		ldy		#$05						; Target Index = 5.
		lda		#$55						; Target Y = $55 (Escape Point).
		sta		targetPosX					; Set AI chase target X (thief escape point)
		sta		targetPosY					; Set Target Vertical Position to $55.
		lda		#$01						; Speed Mask = 1
											; (Update every ODD frame - Fast).
		bne		updateThiefMove				; Unconditional branch.

thiefChase:
	; Mode: Thief Chase (Man in Black chases Indy)
		ldy		#<indyPosY - p0PosY			; Target Index = Indy's Y Position.
		lda		#$03						; Speed Mask = 3
											; (Update every 4th frame - Slow).
updateThiefMove:
		and		frameCount					; Apply Speed Mask.
		bne		checkEscape					; If Mask != 0 (Skip Frame),
											; Check Scrolling/Boundary
		jsr		updateMoveToTarget			; Update Object Position
											; (Move P0 towards Target).
		lda		p0PosY						; Load Thief Vertical Position
		bpl		checkEscape					; If Positive, Skip.
		cmp		#$a0						; Check against 16
		bcc		checkEscape					; If < 16, Skip.
		inc		p0PosY						; Nudge Up (for scrolling effect)
		inc		p0PosY						; Nudge Up again
checkEscape:
		bvc		updateThiefDirection		; If Overflow Clear (Chase Mode),
											; Skip Escape Check
		lda		p0PosY						; Load Thief Vertical Position.
		cmp		#$51						; Check against Escape Line
		bcc		updateThiefDirection		; If < $51 (Not there yet), Continue.

		; Thief has escaped with the item.
		lda		pickupStatusFlags			; Load Flags.
		sta		screenInitFlag				; Trigger initialization/state change?
		lda		#$00						; Clear A.
		sta		pickupStatusFlags			; Clear Stolen Status (Reset Theft)

updateThiefDirection:
		lda		p0PosX						; Load Thief X.
		cmp		indyPosX					; Compare with Indy X.
		bcs		faceThiefLeft				; If Thief >= Indy, Face Left.
		dex									; Decrement X (0->FF).
		eor		#$03						; Toggle bits.

faceThiefLeft:
		stx		REFP0						; Set P0 Reflection.
		and		#$03						; Mask Low bits of X-Diff.
		asl									; Shift Left x3 (Multiply by 8).
		asl
		asl
		asl									; Calculate Animation Offset.
		sta		p0GfxPtrLo					; Store P0 Graphics Pointer.

		; Missile 0 (Swarm) Update
		lda		frameCount
		and		#$7f
		bne		swarmOffscreen				; Skip update most frames (Slow update).
		lda		p0PosY						; Load Thief Y
		cmp		#$4a						; Check Bound.
		bcs		swarmOffscreen				; If >= $4A, Skip.
		ldy		swarmEventCounter			; Load swarm spawn counter.
		beq		swarmOffscreen				; If 0, Skip.
		dey									; Decrement.
		sty		swarmEventCounter			; Update counter.
		ldy		#$8e						; Default Y.
		adc		#$03						; Add 3 to thief Y location
		sta		m0PosY						; Set swarm Y near Thief.
		cmp		indyPosY					; Compare swarm Y vs Indy Y.
		bcs		updateSwarm					; If swarm >= Indy, Move X.
		dey									; Adjust Y

updateSwarm:
		lda		p0PosX						; Load Thief X.
		adc		#$04						; Add Offset.
		sta		m0PosX						; Set swarm X.
		sty		m0PosYShadow				; Store Y to Shadow.

swarmOffscreen:
		ldy		#$7f						; Load $7F.
		lda		m0PosYShadow				; Load shadow.
		bmi		weaponUse					; Branch if negative.
		sty		m0PosY						; Set M0 to $7F (offscreen)

weaponUse:
		lda		weaponPosY					; Get bullet/whip vertical position.
		cmp		#$52						; Compare.
		bcc		finishValleyOfPoison		; Branch if <.
		sty		weaponPosY					; Store Y to weapon pos.

finishValleyOfPoison:
		jmp		jmpSetupNewRoom		; Return.

wellOfSoulsRoomHandler:
	; --------------------------------------------------------------------------
	; WELL OF SOULS (Screen ID 12)
	; Uses Thief logic to drive Thieves here too.
	; --------------------------------------------------------------------------
		ldx		#$3a						; Load Initial X Position ($3A = 58).
		stx		dungeonBlock4				; Set Position of Object 4
		ldx		#$85						; Load Initial Value
		stx		pf2GfxPtrLo					; Set playfield graphics pointer
		ldx		#BONUS_LANDING_IN_MESA		; Load Value 3.
		stx		mesaLandingBonus			; Set Flag
		bne		checkToMoveThieves

thievesDenRoomHandler
	; --------------------------------------------------------------------------
	; THIEVES' DEN (Screen ID 7)
	; Controls the movement of 5 Thieves patroling the screen.
	; --------------------------------------------------------------------------
		ldx		#$04						; Load loop counter
											; (5 thieves, Indices 4 down to 0).
checkToMoveThieves:
		lda		thiefMoveDelayTable,x		; Get speed mask for Thief X.
		and		frameCount					; Apply mask.
		bne		moveNextThief				;  If result != 0, skip this frame.
		ldy		dynamicGfxData,x			; Get current horizontal position
		lda		#REFLECT					; Load Reflect Bit (Direction Check).
		and		roomObjectVar,x				; Check thief state.
		bne		moveThiefRight				; If Bit Set (Reflected), Moving Right.
	; Moving left
		dey									; Decrement position (Move Left).
		cpy		#$14						; Check Left Boundary (X=20).
		bcs		setNewThiefPosX				; If >= 20, still in bounds, update Position.
											; Else, fall through to Change Direction.
changeThiefDirection:
		lda		#REFLECT					; Load Reflect mask.
		eor		roomObjectVar,x				; XOR with current state
		sta		roomObjectVar,x				; Update state.

setNewThiefPosX:
		sty		dynamicGfxData,x			; Save new Horizontal Position.

moveNextThief:
		dex									; Decrement thief index.
		bpl		checkToMoveThieves			; If X >= 0, Loop for next thief.
		jmp		jmpSetupNewRoom				; All thieves done. Return.

moveThiefRight:
		iny									; Increment position (Move Right).
		cpy		#$85						; Check Right Boundary (X=133).
		bcs		changeThiefDirection		; If >= 133, Hit edge. Change Direction.
		bcc		setNewThiefPosX				; Else, Update Position.


mesaSideRoomHandler
	; --------------------------------------------------------------------------
	; MESA SIDE
	; Controls the movement of 5 Thieves patroling the screen.
	; --------------------------------------------------------------------------
		bit		mesaSideState				; Check Mesa Side State.
											; Bit 7 = Parachute Active.
		bpl		updateMesaSideRoom			; Branch if Bit 7 clear
											; (Parachute NOT active -> Freefall).
		bvc		getMesaSideRoomInput		; Branch if Overflow clear (Bit 6?).
		dec		indyPosX					; Decrement Indy X
		bne		updateMesaSideRoom			; Unconditional branch.

getMesaSideRoomInput:
		lda		frameCount					; Get current frame count.
		ror									; Rotate bit 0 into Carry.
		bcc		updateMesaSideRoom			; Branch on even frame (Limit speed).
		lda		SWCHA						; Get Joystick Inputs
		sta		indyDir						; Store input.
		ror									; Bit 0 (P1 Up) -> Carry.
		ror									; Bit 1 (P1 Down) -> Carry.
		ror									; Bit 2 (P1 Left) -> Carry.
		bcs		ifRightInput				; Branch if Left NOT pressed

; If Left Input
		dec		indyPosX					; Move Left.
		bne		updateMesaSideRoom			; Unconditional branch.

ifRightInput:
		ror									; Bit 3 (P1 Right) -> Carry.
		bcs		updateMesaSideRoom			; Branch if Right NOT pressed.
		inc		indyPosX					; Move Right.

updateMesaSideRoom:
		lda		#$02						; Load 2.
		and		mesaSideState				; Check Bit 1 of state.
		bne		indyVsGravity				; Branch if set.
		sta		grappleWhipState			; Clear grapple state if bit 1 was clear
		lda		#$0b						; Load $0B.
		sta		p0PosY						; Set Object Vertical Position?

indyVsGravity:
		ldx		indyPosY					; Get Indy Vertical.
		lda		frameCount					; Get Frame Count.
		bit		mesaSideState				; Check state.
		bmi		updateParachuteFall			; Branch if Bit 7 set
											; (Parachute Active = Slow Fall).
		cpx		#$15						; Compare Y with $15.
		bcc		updateParachuteFall			; Branch if Y < $15
											; (slow fall initially)
		cpx		#$30						; Compare Y with $30.
		bcc		finshMesaGravity			; Branch if Y < $30.
		bcs		increaseFall				; Unconditional branch (>= $30).

updateParachuteFall:
		ror									; Rotate A (Frame Count - slow decent)
		bcc		finshMesaGravity			; Branch on even frames
											; (Slower fall: 0.5px/frame).

finishMesaSide:
		jmp		jmpSetupNewRoom				; Return.

increaseFall:
		inx									; Increment Y (Accel fall).

finshMesaGravity:
		inx									; Increment Y (Move Down).
		stx		indyPosY					; Update Indy Y.
		bne		finishMesaSide				; Return.


blackMarketRoomHandler:
	; --------------------------------------------------------------------------
	; BLACK MARKET
	; --------------------------------------------------------------------------
		lda		indyPosX					; Get Indy X.
		cmp		#$64						; Compare 100.
		bcc		inLunaticZone				; Branch if < 100 (Left Side/Lunatic Zone).
		rol		blackMarketState			; Rotate Black Market state left.
		clc									; Clear Carry.
		ror		blackMarketState			; Rotate right (preserves high bit).
		bpl		finishRoomHandler			; Branch if positive.

inLunaticZone:
		cmp		#$2c						; Compare Decimal 44. The "Lunatic LOS".
		beq		bribeCheck					; Branch if equal (Indy is exactly at the line).
		lda		#$7f						; Screen center
		sta		ballPosY					; Set Lunatic/Blocker Y to Center
		bne		finishRoomHandler			; Return.

bribeCheck:
		bit		blackMarketState			; Check Black Market state
											; (Did we drop Gold?)
		bmi		finishRoomHandler			; Branch if Bit 7 set (No Bribe).
		lda		#$30						; Load 48.
		sta		ballPosX					; Set Ball/Blocker X to 48
		ldy		#$00
		sty		ballPosY					; Clear Lunatic Y  (Remove Lunatic).
		ldy		#$7f						; Load $7F.
		sty		p0SpriteHeight				; set p0SpriteHeight
		sty		snakePosY					; Set snakeVertPos.
		inc		indyPosX					; Increment Indy X (49).
		lda		#INDY_DEAD					; Lunatic kills Indy
		sta		indyStatus					; (but removes Lunatic permanently)

finishRoomHandler:
		jmp		jmpSetupNewRoom				; Return.

treasureRoomHandler:
	; --------------------------------------------------------------------------
	; TREASURE ROOM HANDLER
	; Handles the appearance of items (Medallion, Key, etc.) in the baskets.
	; --------------------------------------------------------------------------
		ldy		roomObjectVar				; Get Offset (Used as a state counter)
		dey									; Decrement.
		bne		finishRoomHandler			; If not 1, return (Delay loop).

		lda		treasureRoomState			; Get treasure room state.
		and		#$07						; Mask bits 0-2.
		bne		advanceTreasureState		; Branch if not 0
											; (Item processing active).
; ITEM CYCLE LOGIC
		lda		#$40						; Load Bit 6 ($40).
		sta		screenEventState			; Update screen event state.
		lda		timeOfDay					; Divide by 32 (Shift Right 5 times).
		lsr
		lsr
		lsr
		lsr
		lsr
		tax									; Use result as Index.
		ldy		treasureRoomStateIndex,x	; Lookup Index from table.
		ldx		treasureRoomStateTable,y	; Lookup "Basket State" / Item ID.
		sty		temp0						; Save Y index
		jsr		checkBaskets				; Check if Item is Valid/Available.
		bcc		spawnTreasureItem			; If Carry Clear (Valid), spawn treasre.
resetTreasureCountdown:
		inc		roomObjectVar				; Increment offset
		bne		finishRoomHandler			; Return.

		brk									; Break (Should not happen).

spawnTreasureItem:
		ldy		temp0						; Restore Y index
		tya									; Move to A.
		ora		treasureRoomState			; Combine with current state.
		sta		treasureRoomState			; Update treasure room state.
		lda		treasureRoomItemPosY,y		; Get Vertical Position for Item.
		sta		p0PosY						; Set P0 Vertical Position (Item).
		lda		treasureRoomItemOffset,y	; Get Graphic Offset for Item.
		sta		roomObjectVar				; Set Graphic Offset.
		bne		finishRoomHandler			; Return.

advanceTreasureState:
		cmp		#$04						; Check State Phase.
		bcs		resetTreasureCountdown			; Branch if >= 4 (Reset).
		rol		treasureRoomState			; Rotate state left
		sec									; Set Carry.
		ror		treasureRoomState			; Rotate state right (set bit 7).
		bmi		resetTreasureCountdown			; Branch if Negative.

mapRoomHandler:
	; --------------------------------------------------------------------------
	; MAP ROOM LOGIC (Room ID 04)
	; --------------------------------------------------------------------------
	; The Map Room contains the core puzzle of the game.
	; 1.  Movement Lock: Indy is constrained to specific paths.
	; 2.  Day/Night Cycle: The "Sun" (Player 0 Object) rises and sets based on
	;	  the 'timeOfDay' variable.
	; 3.  The Reveal: If Indy holds the Head of Ra at the right time (Sun is high),
	;	  a beam of light (Missile 1) points to the location of the Ark.
	; --------------------------------------------------------------------------
		ldy		#$00
		sty		ballPosY					; Clear Ball (Snake/Timepiece not used here)
		ldy		#$7f						; Initialize Y to Off-screen
		sty		p0SpriteHeight				; Reset Sun height logic
		sty		snakePosY					; Ensure snake is off-screen.

	; --------------------------------------------------------------------------
	; MOVEMENT CONSTRAINTS
	; --------------------------------------------------------------------------
	; Indy cannot walk freely horizontally here. His X position is snapped
	; to center ($71) unless specific conditions are met.
		lda		#$71
		sta		ballPosX					; Force Ball X to center
		ldy		#$4f						; Default Graphic Offset (Inactive State)

		; Check if Indy is standing on the correct "Plinth" (Y=$3A)
		lda		#$3a						; Default Graphic Offset (Inactive State)
		cmp		indyPosY					; Check if Indyis at Y = $3A (room enterance).
		bne		checkMapRoomEntry			; If not at Plinth Y, check entry logic.

		; Check Inventory for Puzzle Triggers
		lda		selectedInventoryId
		cmp		#ID_INVENTORY_KEY			; Is Key selected?
		beq		mapRoomActive				; If Key, Grant Access.

		; Check if Indy is already positioned correctly (X=$5E)
		lda		#$5e
		cmp		indyPosX
		beq		mapRoomActive

checkMapRoomEntry:
		ldy		#$0d						; Load "Empty/Inactive" Graphic Offset.

mapRoomActive:
	; --------------------------------------------------------------------------
	; SUN HEIGHT CALCULATION (TIME OF DAY)
	; --------------------------------------------------------------------------
	; This routine converts the linear 'timeOfDay' counter (0-255) into a
	; "Ping-Pong" value to simulate the Sun rising and setting.
	; --------------------------------------------------------------------------
		sty		roomObjectVar				; Set graphic offset based on active check.
		lda		timeOfDay					; Load Global Timer.
		sec
		sbc		#$10						; Subtract 16.
		bpl		mapRoomTimer				; If Timer >= 16,  Sun is "Rising/High"

		; Time is < 16 (0-15). Create rising edge.
		eor		#$ff						; Invert bits to flip curve.
		sec									; (0..15 -> becomes 15..0 - Sunset).
		adc		#$00
mapRoomTimer:
		cmp		#$0b						; Is Sun "Height" > 11?
		bcc		updateSunPos				; If < 11, use value.
		lda		#$0b

updateSunPos:
		sta		p0PosY						; Set Sun Object Verification Position.

		bit		mapRoomState				; Check "Eye State"
											; (Is Indy standing in the right spot to see?)
		bpl		viewAreaActive				; If Bit 7 Clear, Sun doesn't reveal anything.

	; --------------------------------------------------------------------------
	; THE REVEAL (BEAM OF LIGHT)
	; --------------------------------------------------------------------------
	; If Sun Height < 8 AND Player is holding Head of Ra...
	; Draw the Beam (Missile 1) pointing to the secret Mesa.
	; --------------------------------------------------------------------------

		cmp		#$08						; Compare Sun Height.
		bcs		hideBeam					; If >= 8 (Too Low/Night), Hide Beam.

		ldx		selectedInventoryId
		cpx		#ID_INVENTORY_HEAD_OF_RA	; Is Player holding Head of Ra?
		bne		hideBeam					; If not, Hide Beam.
		stx		mapRoomBonus				; Set Flag: Player used Head of Ra (Bonus!)

		; Flicker Effect
		lda		#$04
		and		frameCount
		bne		hideBeam					; Flicker beam (draw 3 of 4 frames).

		; -----------------------------------------------------------------------
		; CALCULATE BEAM TARGET
		; -----------------------------------------------------------------------
		; Uses the secret 'secretArkMesaID' to look up X/Y coordinates
		; on the map wall where the beam should point to.
		lda		secretArkMesaID				; Load Secret Ark ID.
		and		#$0f						; Mask ID.
		tax									; Use as index.
		lda		mapRoomArkLocX,x			; Lookup Beam X Coordinate from table.
		sta		weaponPosX					; Set Beam (Missile 1) X.
		lda		mapRoomArkLocY,x			; Lookup target Y on map.
		bne		updateBeamPos				; Update Beam Position.

hideBeam:
		lda		#$70						; Move Beam Offscreen.

updateBeamPos:
		sta		weaponPosY					; Set Beam Y.

	; --------------------------------------------------------------------------
	; VIEW AREA VALIDATION
	; --------------------------------------------------------------------------
	; Updates 'mapRoomState' bit 7. This flag indicates if Indy is standing
	; in the correct "View Zone" to activate the puzzle logic next frame.
viewAreaActive:
		rol		mapRoomState				; Roll State (History).

		; Check Alignment Y
		lda		#$3a
		cmp		indyPosY
		bne		invalidateView				; If Y != $3A, Invalid.

		; Check Graphic State
		cpy		#$4f
		beq		confirmView					; If Offset == $4F (Active), Valid.

		; Check Alignment X
		lda		#$5e
		cmp		indyPosX					; Check X if Indy is in the view room
		bne		invalidateView

confirmView:
		sec									; Set Carry (Valid!).
		ror		mapRoomState				; Rotate into State (Bit 7 becomes 1).
		bmi		finishMapRoom				; Done.

invalidateView:
		clc									; Clear Carry (Invalid).
		ror		mapRoomState				; Rotate into State (Bit 7 becomes 0).
finishMapRoom:
		jmp		jmpSetupNewRoom				; Return.

templeEntranceRoomHandler:
	; --------------------------------------------------------------------------
	; TEMPLE ENTRANCE / TIMEPIECE ROOM (Bank 1)
	; --------------------------------------------------------------------------
	; This room contains the Time Piece (displayed as the Ball object).
	; If the item has been taken, we must hide the graphic.
	; --------------------------------------------------------------------------
		lda		#PICKUP_ITEM_STATUS_TIME_PIECE	; Load Time Piece mask.
		and		pickupItemStatus			; Check if player already has it.

		bne		timepieceTaken				; If Result != 0 (Item Taken), hide it.
	; --------------------------------------------------------------------------
	; TIMEPIECE PRESENT STATE
	; --------------------------------------------------------------------------
	; Use default Ball Position (set in initRoomState or loadRoomGfx)
		lda		#SCREEN_CENTER_X
		sta		ballPosX					; Set Ball/Timepiece X to center
		lda		#$2a
		sta		ballPosY					; Set Timepiece Graphics (Ball Sprite)
		lda		#<timeSprite
		sta		kernelDataPtrLo
		lda		#>timeSprite
		sta		kernelDataPtrLo + 1
		bne		finishTempleEntrance

timepieceTaken:
		lda		#$f0						; Move "Timepiece" Offscreen vertically
		sta		ballPosY
finishTempleEntrance:
	; --------------------------------------------------------------------------
	; ROOM GRAPHICS SETUP
	; Uses entranceRoomEventState to determine the graphical layout
	; --------------------------------------------------------------------------
		lda		entranceRoomEventState		; Get event state.
		and		#$0f						; Mask lower nibble.
		beq		jmpSetupNewRoom				; Branch if 0 (Invalid?).
		sta		p0SpriteHeight				; Store state.
		ldy		#$14						; P0 Height
		sty		p0PosY						; Set P0 Vertical Position
		ldy		#$3b						; P0 Graphics Data
		sty		p0DrawStartLine				; Set kernel scanline boundary
		iny									; becomes $3C
		sty		kernelRenderState			; Store state

		; Calculate P0 Graphics Pointer based on State
		; Offset backward from end of timeSprite data
		lda		#<templeEntrancePlayerGraphics
		sec
		sbc		p0SpriteHeight
		sta		p0GfxPtrLo					; Set P0 Graphics Pointer Low
		bne		jmpSetupNewRoom				; Return via standard exit

roomOfShiningLightHandler:
	; --------------------------------------------------------------------------
	; ROOM OF SHINING LIGHT SCENE LOGIC
	; --------------------------------------------------------------------------
	; This room contains the "Shining Light" object (Player 0).
	; It also hides the secret "Dungeon" exit interaction.
	; --------------------------------------------------------------------------
		lda		frameCount					; Get current frame count.
		and		#$18						; Mask for update rate.
		adc		#<shiningLightSprites		; Add sprite base.
		sta		p0GfxPtrLo					; Set P0 GFX Low.
		lda		frameCount					; Get frame count.
		and		#$07						; Screen update every 8 frames
		bne		dungeonCheck				; Branch if not frame.
		ldx		#$00						; Index X for P0.
		ldy		 #<indyPosY - p0PosY		; Index Y for Indy.
		lda		indyPosY					; Get Indy's vertical position.
		cmp		#$3a						; Compare 58.
		bcc		moveShiningLight			; Branch if Y < 58.
		lda		indyPosX					; Get Indy's horizontal position.
		cmp		#$2b						; Compare $2B.
		bcc		roslStateHandeler			; Branch if < $2B.
		cmp		#$6d						; Compare $6D.
		bcc		moveShiningLight			; Branch if < $6D.

roslStateHandeler:
		ldy		#$05						; Set Y to 5 so updateMoveToTarget
											; keeps light static
		lda		#SCREEN_CENTER_X			; X target = center
		sta		targetPosX					; Set AI chase target X (shining light)
		lda		#$0b						; Y Target
		sta		targetPosY					; Set Temp Y

moveShiningLight:
		jsr		updateMoveToTarget			; Keep the Shining Light object positioned.

dungeonCheck:
	; --------------------------------------------------------------------------
	; DUNGEON ENTRANCE CHECK
	; --------------------------------------------------------------------------
	; Checks if Indy is standing in the correct spot to find the secret exit.
	; --------------------------------------------------------------------------
		ldx		#$4e						; Target Y Position
		cpx		indyPosY					; Is Indy at the correct vertical line?
		bne		jmpSetupNewRoom				; If not, exit.

		ldx		indyPosX					; Get Indy's X.
		cpx		#$76						; Check Right Wall boundary?
		beq		dungeonWallHit				; If touching right wall, check input.
		cpx		#$14						; Check Left Wall boundary?
		bne		jmpSetupNewRoom				; If neither, exit.

dungeonWallHit:
		lda		SWCHA						; Read joystick.
		and		#P1_NO_MOVE					; Mask for movement.
		cmp		#(MOVE_DOWN >> 4)			; Is Player pressing DOWN?
		bne		jmpSetupNewRoom				; If not pressing Down, no interaction.

		; --- Trigger Secret Exit ---
		sta		escapePrisonPenalty			; Apply Penalty (13 points).
		lda		#SCREEN_CENTER_X			; Teleport Indy to center.
		sta		indyPosX					; Teleport Indy to Center X.

		ror		entranceRoomEventState		; Rotate Event State (Modify flags).
		sec									; Set Carry.
		rol		entranceRoomEventState		; Rotate Event State

jmpSetupNewRoom
		lda		#<setupNewRoom				; Load Return Address Low.
		sta		temp4						; Store bank-switch jump target lo.
		lda		#>setupNewRoom				; Load Return Address High.
		sta		temp5						; Store bank-switch jump target hi.
		jmp		jumpToBank0					; Jump to Bank 0.

entranceRoomHandler
	; --------------------------------------------------------------------------
	; Enterance Room
	; --------------------------------------------------------------------------
		lda		#$40						; Load $40.
		sta		screenEventState			; Set screenEventState.
		bne		jmpSetupNewRoom				; Unconditional branch.

drawScreen
		sta		WSYNC						; Wait for Sync.
;---------------------------------------
		sta		HMCLR						; Clear Horizontal Motion.
		sta		CXCLR						; Clear Collisions.
		ldy		#$ff						; Load $FF.
		sty		PF1							; Set playfield 1 (Full Right).
		sty		PF2							; Set playfiled 2 (Full Left).
		ldx		currentRoomId				; Get Room ID.
		lda		roomPF0Gfx,x				; Get PF0 Data.
		sta		PF0							; Set PF0.
		iny									; Y=0
		sta		WSYNC						; Wait for Sync.
;---------------------------------------
		sta		HMOVE						; Move Objects.
		sty		VBLANK						; Enable TIA (Y=0, VBLANK Off).
		sty		scanline					; Zero Scanline Counter.
		cpx		#ID_MAP_ROOM				; Check Map Room.
		bne		enableBall					; If not Map Room, enable ball
		dey
enableBall
		sty		ENABL

		cpx		#ID_ARK_ROOM				; Check Ark Room.
		beq		initKernalJumps				; Branch if Ark Room.
		bit		indyStatus				; Check major event.
		bmi		initKernalJumps				; Branch if Negative (Bit 7 Set).
		ldy		SWCHA						; Read Joystick.
		sty		REFP1						; Set Reflection P1
initKernalJumps
		sta		WSYNC						; Wait for Sync.
;--------------------------------------
		sta		HMOVE						; Move Objects.
		sta		WSYNC						; Wait for Sync.
;--------------------------------------
		sta		HMOVE						; Move Objects.
		ldy		currentRoomId				; Get Room ID.
		sta		WSYNC						; Wait for Sync.
;--------------------------------------
		sta		HMOVE						; Move Objects.
		lda		roomPF1Gfx,y				; Get PF1 Data.
		sta		PF1							; Set PF1
		lda		roomPF2Gfx,y				; Get PF2 Data.
		sta		PF2							; Set PF2
		ldx		kernelJumpTableIndex,y		; Get Kernel Index.
		lda		kernelJumpTable+1,x			; Get High Byte.
		pha									; Push High.
		lda		kernelJumpTable,x			; Get Low Byte.
		pha									; Push Low.
		lda		#$00						; Clear A
		tax									; Clear X
		sta		temp0						; Clear temp
		rts									; Jump to Kernel section

checkBaskets:
	; --------------------------------------------------------------------------
	; BASKET CHECKER
	; Checks if an item (indexed by X) can be displayed/picked up.
	; --------------------------------------------------------------------------
		lda		possibleTreasureItemID,x	; Get possible Item ID for this slot.
		lsr									; Shift Right
											; (Bit 0 into Carry -> Odd/Even check).
		tay									; Transfer to Y (Index for Mask Table).
		lda		itemMaskTable,y	; Get Bitmask for this item type.

		; Even Index? Check spawnable item availability.
		bcs		checkPickupStatus			; If Carry Set (Odd Index),
											; check unique pickup status.
		and		basketItemStatus			; Check if this spawnable item has been taken
		beq		notInBasket					; If 0 (not yet taken), item is still available
		sec									; Set Carry (item already taken).
notInBasket
		rts									; Return.

checkPickupStatus
		; Check if player already has this unique item.
		and		pickupItemStatus			; Mask with unique item status.
		bne		notInBasket					; If nonzero (already collected),
											; Return Failure.
		clc									; Clear Carry
											; (Success - Item Available to take).
		rts									;return


; Chase Logic
updateMoveToTarget
	cpy		#<indyPosY - p0PosY				; Check if Target is Indy (Offset).
	bne		updateP0PosY
	lda		indyPosY						; Get Indy's Vertical Position.
	bmi		moveP0PosYUp					; Branch if negative (or > 127).
updateP0PosY
	lda		p0PosY,x						; Get Follower Y.
	cmp.wy	p0PosY,y						; Compare Target Y.
	bne		moveP0PosYDown					; Branch if different.
	cpy		#$05							; Check bounds
	bcs		updateP0PosX					; Branch if >= 5.
moveP0PosYDown
	bcs		moveP0PosYUp					;Branch if Follower > Target (Move Up).
	inc		p0PosY,x						; Increment Follower Y (Move Down).
	bne		updateP0PosX					; Unconditional branch (unless 0).
moveP0PosYUp
	dec		p0PosY,x						; Decrement Follower Y (Move Up).
updateP0PosX
	lda		p0PosX,x						; Get Follower X.
	cmp.wy	p0PosX,y						; Compare Target X.
	bne		moveP0PosXRight					; Branch if different.
	cpy		#$05							; Check Bounds
	bcs		finishFollow					; Branch if >= 5.
moveP0PosXRight
	bcs		moveP0PosXLeft					; Branch if Follower > Target (Move Left).
	inc		p0PosX,x						; Increment Follower X (Move Right).
finishFollow
	rts										; Return.
moveP0PosXLeft
	dec		p0PosX,x						; Decrement Follower X (Move Left).
	rts										; Return.

updateObjBoundPos
	lda		p0PosY,x						; Get Object Y.
	cmp		#$53							; Compare $53 (Bottom/Top Boundary).
	bcc		updateObjClampPos				; Branch if < $53.
updateObjBoundClamp
	rol		secretArkMesaID,x				; Rotate State/Flags.
	clc										; Clear Carry.
	ror		secretArkMesaID,x				; Rotate Back (Clear Bit 7).
	lda		#$78							; Load $78.
	sta		p0PosY,x						; into p0 Y Position
	rts										; Return.
updateObjClampPos
	lda		p0PosX,x						; Get Object X.
	cmp		#$10							; Compare $10 (Left Boundary).
	bcc		updateObjBoundClamp				; Branch if < $10.
	cmp		#$8e							; Compare $8E (Right Boundary).
	bcs		updateObjBoundClamp				; Branch if >= $8E.
	rts		; Branch if >= $8E.

	;padding to $F900
	.byte	$00,$00,$00,$00

blackMarketPlayerGraphics
	; ---------------------------------------------------------------
	; First seller — green turban with colored face bands
	; (initial P0 color = ORANGE + 10 from roomP0ColorTable)
	; GRP0 retains last value across command scanlines, so the $7E
	; turban shape persists while color commands create stripes.
	; ---------------------------------------------------------------
	.byte $00 ; |........| $F900  Blank top
	.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1	; $F901  Turban color (green)
	.byte $7E ; |.XXXXXX.| $F902  Turban (drawn in green)
	.byte SET_PLAYER_0_COLOR | (RED + 4) >> 1		; $F903  Red headband
	.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1	; $F904  Green band
	.byte SET_PLAYER_0_COLOR | (ORANGE + 12) >> 1	; $F905  Flesh tone (face)
	.byte $5A ; |.X.XX.X.| $F906  Face (eyes)
	.byte $7E ; |.XXXXXX.| $F907  Chin / jaw
	.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1	; $F908  Robe color (green)
	.byte $7F ; |.XXXXXXX| $F909  Body / robe
	; ---------------------------------------------------------------
	; Gap between first seller and bullets
	; ---------------------------------------------------------------
	.byte $00 ; |........| $F90A
	.byte $00 ; |........| $F90B
	; ---------------------------------------------------------------
	; Six bullets for sale (grey)
	; Symmetric diamond arrangement of 6 dots.
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (BLACK + 8) >> 1	; $F90C  Set grey for bullets
	.byte $08 ; |....X...| $F90D  Top bullet
	.byte $2A ; |..X.X.X.| $F90E  Three bullets
	.byte $22 ; |..X...X.| $F90F  Two outer bullets
	.byte $00 ; |........| $F910  Center gap
	.byte $22 ; |..X...X.| $F911  Two outer bullets
	.byte $2A ; |..X.X.X.| $F912  Three bullets
	.byte $08 ; |....X...| $F913  Bottom bullet
	.byte $00 ; |........| $F914  Blank
	; ---------------------------------------------------------------
	; Reposition P0 far left — draw Lunatic 
	; (HMOVE_L7 persists through the next COLUP0 command, so P0
	; shifts left 7 on TWO consecutive scanlines before L1 kicks in)
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1		; $F915  Shift left 7
	.byte SET_PLAYER_0_COLOR | (GREEN_BLUE + 8) >> 1	; $F916  Set teal color
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F917  Nudge left 1
	.byte $6C ; |.XX.XX..| $F918  Item top (teal, drifting L1)
	.byte $7B ; |.XXXX.XX| $F919  Item body (drifting L1)
	.byte $7F ; |.XXXXXXX| $F91A  Item base (drifting L1)
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; $F91B  Stop horizontal motion
	.byte SET_PLAYER_0_COLOR | (ORANGE + 12) >> 1	; $F91C  Switch to orange
	.byte $3F ; |..XXXXXX| $F91D  Item midsection (orange)
	.byte $77 ; |.XXX.XXX| $F91E  Item detail
	.byte $07 ; |.....XXX| $F91F  Narrow section
	.byte $7F ; |.XXXXXXX| $F920  Wide base
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1	; $F921  Switch to grey
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F922  Drift left (diagonal)
	.byte $3F ; |..XXXXXX| $F923  Tapered shape (grey, drifting L1)
	.byte $1F ; |...XXXXX| $F924  Narrowing
	.byte $0E ; |....XXX.| $F925  Narrowing
	.byte $0C ; |....XX..| $F926  Tip
	.byte $00 ; |........| $F927  Blank
	; ---------------------------------------------------------------
	; Reposition P0 far right — draw basket
	; (HMOVE_R8 persists across 5 scanlines for large repositioning)
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_R8 >> 1		; $F928  Shift right 8
	.byte SET_PLAYER_0_COLOR | (PURPLE + 12) >> 1				; $F929  Set purple ($6C)
	.byte $00 ; |........| $F92A  Blank (repositioning R8)
	.byte $00 ; |........| $F92B  Blank (repositioning R8)
	.byte $00 ; |........| $F92C  Blank (repositioning R8)
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; $F92D  Stop horizontal motion
	.byte $1C ; |...XXX..| $F92E  Basket top (purple)
	.byte $2A ; |..X.X.X.| $F92F  Basket weave
	.byte $55 ; |.X.X.X.X| $F930  Basket weave (widest)
	.byte $2A ; |..X.X.X.| $F931  Basket weave
	.byte $14 ; |...X.X..| $F932  Basket weave (narrow)
	.byte $3E ; |..XXXXX.| $F933  Basket rim
	.byte $00 ; |........| $F934  Blank
	; ---------------------------------------------------------------
	; Reposition P0 left for second seller
	; (HMOVE_L5 persists across 3 scanlines: L5+L5+L5 = 15 left)
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L5 >> 1		; $F935  Shift left 5
	.byte $00 ; |........| $F936  Blank (repositioning L5)
	; ---------------------------------------------------------------
	; Second seller — same design as first seller
	; (green turban, red/green/orange face stripes)
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1	; $F937  Turban color (green)
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F938  Nudge left 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; $F939  Stop motion
	.byte $7E ; |.XXXXXX.| $F93A  Turban (drawn in green)
	.byte SET_PLAYER_0_COLOR | (RED + 4) >> 1		; $F93B  Red headband
	.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1	; $F93C  Green band
	.byte SET_PLAYER_0_COLOR | (ORANGE + 12) >> 1	; $F93D  Flesh tone (face)
	.byte $5A ; |.X.XX.X.| $F93E  Face (eyes)
	.byte $7E ; |.XXXXXX.| $F93F  Chin / jaw
	.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1	; $F940  Robe color (green)
	.byte $7F ; |.XXXXXXX| $F941  Body / robe
	; ---------------------------------------------------------------
	; Gap between second seller and shovel
	; ---------------------------------------------------------------
	.byte $00 ; |........| $F942  Blank
	; ---------------------------------------------------------------
	; Reposition P0 right — draw shovel for sale
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_R7 >> 1		; $F943  Shift right 7
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F944  Adjust left 1
	.byte SET_PLAYER_0_COLOR | (BLACK + 4) >> 1	; $F945  Dark grey (shovel metal)
	.byte $00 ; |........| $F946  Blank
	.byte $7C ; |.XXXXX..| $F947  Shovel blade
	.byte $18 ; |...XX...| $F948  Shovel handle
	.byte $18 ; |...XX...| $F949  Shovel handle
	.byte SET_PLAYER_0_COLOR | (LT_RED + 4) >> 1	; $F94A  Warm brown (handle)
	.byte $7F ; |.XXXXXXX| $F94B  Handle base
	.byte $1F ; |...XXXXX| $F94C  Ground taper
	.byte $07 ; |.....XXX| $F94D  Ground taper (narrow)
	; ---------------------------------------------------------------
	; Bottom padding
	; ---------------------------------------------------------------
	.byte $00 ; |........| $F94E
	.byte $00 ; |........| $F94F
	.byte $00 ; |........| $F950

mapRoomPlayerGraphics
	; ---------------------------------------------------------------
	; The Map Room (Room 4) P0 data stream.
	; P0 stays at initial X=$4F throughout (no HMOVE commands).
	; The sun's vertical position is controlled by mapRoomHandler via
	; p0PosY based on timeOfDay — it rises and sets in a ping-pong
	; cycle. When the room is "closed" (Indy has no key), roomObjectVar
	; limits how much of this data is drawn, showing only solid walls.
	;
	; Visual layout (top to bottom):
	;   1. Sun disc (LT_RED+8)
	;   2. Mesa Map(YELLOW+12)
	;   3. Model chamber doorway (GREEN+8)
	;   4. Eye of Ra (LT_RED+4)
	; ---------------------------------------------------------------
	; Sun disc — diamond shape, appears as rising/setting sun
	; (initial P0 color = LT_RED + 6 from roomP0ColorTable;
	;  overridden immediately by this color command)
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (LT_RED + 8) >> 1	; $F951  Sun color (orange-red)
	.byte $00 ; |........| $F952  Blank above sun
	.byte $08 ; |....X...| $F953  Sun top point
	.byte $1C ; |...XXX..| $F954  Sun expanding
	.byte $3E ; |..XXXXX.| $F955  Sun widest
	.byte $3E ; |..XXXXX.| $F956  Sun widest
	.byte $3E ; |..XXXXX.| $F957  Sun widest
	.byte $3E ; |..XXXXX.| $F958  Sun widest
	.byte $1C ; |...XXX..| $F959  Sun contracting
	.byte $08 ; |....X...| $F95A  Sun bottom point
	.byte $00 ; |........| $F95B  Gap below sun
	; ---------------------------------------------------------------
	; Mesa Map
	; (YELLOW+12 on dark blue background)
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (YELLOW + 12) >> 1	; $F95C  Golden glyph color
	.byte $7F ; |.XXXXXXX| $F95D  Top wall edge
	.byte $7F ; |.XXXXXXX| $F95E  Top wall edge
	.byte $7F ; |.XXXXXXX| $F95F  Top wall edge
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
	; --- Floor bar (also ceiling of chamber below) ---
	.byte $7F ; |.XXXXXXX| $F987  Bottom wall edge
	.byte $7F ; |.XXXXXXX| $F988  Bottom wall edge
	.byte $7F ; |.XXXXXXX| $F989  Bottom wall edge
	; ---------------------------------------------------------------
	; Model chamber doorway — the room where the beam reveals
	; the Ark location. Green rectangle with open interior.
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1	; $F98A  Chamber color (green)
	.byte $41 ; |.X.....X| $F98B  Chamber left/right walls
	.byte $41 ; |.X.....X| $F98C  Chamber walls
	.byte $41 ; |.X.....X| $F98D  Chamber walls
	.byte $41 ; |.X.....X| $F98E  Chamber walls
	.byte $41 ; |.X.....X| $F98F  Chamber walls
	.byte $41 ; |.X.....X| $F990  Chamber walls
	.byte $41 ; |.X.....X| $F991  Chamber walls
	.byte $41 ; |.X.....X| $F992  Chamber walls
	.byte $41 ; |.X.....X| $F993  Chamber walls
	.byte $41 ; |.X.....X| $F994  Chamber walls
	.byte $7F ; |.XXXXXXX| $F995  Chamber floor
	; ---------------------------------------------------------------
	; Eye of Ra
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (LT_RED + 4) >> 1	; $F996  Floor color (tan/earth)
	.byte $77 ; |.XXX.XXX| $F997  Floor pattern
	.byte $77 ; |.XXX.XXX| $F998  Floor pattern
	.byte $63 ; |.XX...XX| $F999  Floor pattern (narrower)
	.byte $77 ; |.XXX.XXX| $F99A  Floor pattern
	.byte $14 ; |...X.X..| $F99B  Base detail (cross top)
	.byte $36 ; |..XX.XX.| $F99C  Base detail (cross arms)
	.byte $55 ; |.X.X.X.X| $F99D  Base detail (widest)
	.byte $63 ; |.XX...XX| $F99E  Base detail
	.byte $77 ; |.XXX.XXX| $F99F  Base detail
	.byte $7F ; |.XXXXXXX| $F9A0  Solid floor
	.byte $7F ; |.XXXXXXX| $F9A1  Solid floor

mesaSidePlayerGraphics
	; ---------------------------------------------------------------
	; Parachute figure (initial color = GREEN_BLUE + 8 from roomP0ColorTable)
	; Drawn at the top of the screen; visible when Indy is parachuting in.
	; ---------------------------------------------------------------
	.byte $00 ; |........| $F9A2
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1	; $F9A3  Set color to grey
	.byte $24 ; |..X..X..| $F9A4  Parachute cords
	.byte $18 ; |...XX...| $F9A5  Body
	.byte $24 ; |..X..X..| $F9A6  Arms
	.byte $24 ; |..X..X..| $F9A7  Legs
	.byte $7E ; |.XXXXXX.| $F9A8  Canopy bottom
	.byte $5A ; |.X.XX.X.| $F9A9  Canopy middle
	.byte $5B ; |.X.XX.XX| $F9AA  Canopy middle
	.byte $3C ; |..XXXX..| $F9AB  Canopy top
	; ---------------------------------------------------------------
	; Empty sky (25 blank scanlines between parachute and tree)
	; ---------------------------------------------------------------
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
	; ---------------------------------------------------------------
	; Tree canopy top — reposition P0 left and set leaf color
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1		; $F9C5  Shift P0 left 7
	.byte SET_PLAYER_0_COLOR | (GREEN + 8) >> 1	; $F9C6  Set color to green
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; $F9C7  Stop horizontal motion
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F9C8  Nudge left 1
	.byte $55 ; |.X.X.X.X| $F9C9  Sparse leaf top
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; $F9CA  Nudge right 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F9CB  Nudge left 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; $F9CC  Nudge right 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; $F9CD  Stop motion
	; ---------------------------------------------------------------
	; Tree branches — switch to brown, draw branch shapes
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (BROWN + 4) >> 1	; $F9CE  Set color to brown
	.byte $32 ; |..XX..X.| $F9CF  Branch
	.byte $1C ; |...XXX..| $F9D0  Branch
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F9D1  Shift left 1
	.byte $3E ; |..XXXXX.| $F9D2  Wider branch
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1		; $F9D3  Shift left 2
	; ---------------------------------------------------------------
	; Tree canopy/foliage — dense leaf region
	; ---------------------------------------------------------------
	.byte $7F ; |.XXXXXXX| $F9D4  Full foliage
	.byte $7F ; |.XXXXXXX| $F9D5  Full foliage
	.byte $7F ; |.XXXXXXX| $F9D6  Full foliage
	.byte $7F ; |.XXXXXXX| $F9D7  Full foliage
	; ---------------------------------------------------------------
	; Tree trunk — narrowing downward
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F9D8  Shift left 1
	.byte $1F ; |...XXXXX| $F9D9  Upper trunk
	.byte $07 ; |.....XXX| $F9DA  Mid trunk
	.byte $01 ; |.......X| $F9DB  Lower trunk
	.byte $00 ; |........| $F9DC  Gap
	; ---------------------------------------------------------------
	; Mesa ground — reposition right, change to ground color
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_R3 >> 1		; $F9DD  Shift right 3
	.byte SET_PLAYER_0_COLOR | (BROWN + 12) >> 1	; $F9DE  Set color to tan
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F9DF  Shift left 1
	.byte $3F ; |..XXXXXX| $F9E0  Mesa surface
	.byte $7F ; |.XXXXXXX| $F9E1  Mesa surface
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; $F9E2  Nudge right 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1		; $F9E3  Shift left 2
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; $F9E4  Nudge right 1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; $F9E5  Shift left 1
	.byte $3F ; |..XXXXXX| $F9E6  Mesa ledge
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; $F9E7  Nudge right 1
	.byte $7F ; |.XXXXXXX| $F9E8  Mesa base
	.byte $3F ; |..XXXXXX| $F9E9  Mesa base
	.byte $7F ; |.XXXXXXX| $F9EA  Mesa base
	.byte $7F ; |.XXXXXXX| $F9EB  Mesa base
	; ---------------------------------------------------------------
	; Bottom padding
	; ---------------------------------------------------------------
	.byte $00 ; |........| $F9EC
	.byte $00 ; |........| $F9ED

kernelJumpTableIndex
	.byte 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 4, 6

pedestalLiftSprite
	.byte $1C ; |...XXX..| $F9FC
	.byte $36 ; |..XX.XX.| $F9FD
	.byte $63 ; |.XX...XX| $F9FE
	.byte $36 ; |..XX.XX.| $F9FF

indySprites
indyWalk0
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

indyWalk1
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

indyWalk2
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

indyWalk3
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

indyWalk4
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

indyWalk5
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

indyWalk6
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

indyWalk7
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

indyStandSprite
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

parachutingIndySprite
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


roomPF1Gfx
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

roomPF2Gfx
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

roomPF0Gfx
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

timeSprite
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_R1 | 7
	.byte HMOVE_L3 | 7
	.byte HMOVE_L3 | 7
templeEntrancePlayerGraphics
	.byte HMOVE_0  | 0


	; Location of the Ark in Map Room
mapRoomArkLocX
	.byte	$63,$62,$6b,$5b,$6a,$5f,$5a,$5a ; $fac2 (*)
	.byte	$6b,$5e,$67,$5a,$62,$6b,$5a,$6b ; $faca (*)
mapRoomArkLocY
	.byte	$22,$13,$13,$18,$18,$1e,$21,$13 ; $fad2 (*)
	.byte	$21,$26,$26,$2b,$2a,$2b,$31,$31 ; $fada (*)

kernelJumpTable:
	.word staticSpriteKernel-1
	.word scrollingPlayfieldKernel-1
	.word multiplexedSpriteKernel-1
	.word arkPedestalKernel-1

spiderSpriteTable: ;tarantula animation table
	.byte <spiderGfxFrame1
	.byte <spiderGfxFrame2
	.byte <spiderGfxFrame3
	.byte <spiderGfxFrame4

; ---------------------------------------------------------------------------
; SNAKE CHARMER SONG DATA (FLUTE)
; ---------------------------------------------------------------------------
; This table contains the TIA frequency values for the flute melody.
; The values are read by 'playFluteMelody' based on the frame counter.
; Lower values = Higher Pitch.
; ---------------------------------------------------------------------------
snakeCharmFreqTable
	.byte	$1b,$18,$17,$17,$18,$18,$1b,$1b
	.byte	$1d,$18,$17,$12,$18,$17,$1b,$1d
	.byte	$00,$00


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

timepiece1200: ;timepiece bitmaps...
	.byte $3E ; |..XXXXX.| $FB98
	.byte $41 ; |.X.....X| $FB99
	.byte $41 ; |.X.....X| $FB9A
	.byte $49 ; |.X..X..X| $FB9B
	.byte $49 ; |.X..X..X| $FB9C
	.byte $49 ; |.X..X..X| $FB9D
	.byte $3E ; |..XXXXX.| $FB9E
	.byte $1C ; |...XXX..| $FB9F

timepiece0100
	.byte $3E ; |..XXXXX.| $FBA0
	.byte $41 ; |.X.....X| $FBA1
	.byte $41 ; |.X.....X| $FBA2
	.byte $49 ; |.X..X..X| $FBA3
	.byte $45 ; |.X...X.X| $FBA4
	.byte $43 ; |.X....XX| $FBA5
	.byte $3E ; |..XXXXX.| $FBA6
	.byte $1C ; |...XXX..| $FBA7

timepiece0300
	.byte $3E ; |..XXXXX.| $FBA8
	.byte $41 ; |.X.....X| $FBA9
	.byte $41 ; |.X.....X| $FBAA
	.byte $4F ; |.X..XXXX| $FBAB
	.byte $41 ; |.X.....X| $FBAC
	.byte $41 ; |.X.....X| $FBAD
	.byte $3E ; |..XXXXX.| $FBAE
	.byte $1C ; |...XXX..| $FBAF

timepiece0500
	.byte $3E ; |..XXXXX.| $FBB0
	.byte $43 ; |.X....XX| $FBB1
	.byte $45 ; |.X...X.X| $FBB2
	.byte $49 ; |.X..X..X| $FBB3
	.byte $41 ; |.X.....X| $FBB4
	.byte $41 ; |.X.....X| $FBB5
	.byte $3E ; |..XXXXX.| $FBB6
	.byte $1C ; |...XXX..| $FBB7

timepiece0600
	.byte $3E ; |..XXXXX.| $FBB8
	.byte $49 ; |.X..X..X| $FBB9
	.byte $49 ; |.X..X..X| $FBBA
	.byte $49 ; |.X..X..X| $FBBB
	.byte $41 ; |.X.....X| $FBBC
	.byte $41 ; |.X.....X| $FBBD
	.byte $3E ; |..XXXXX.| $FBBE
	.byte $1C ; |...XXX..| $FBBF

timepiece0700
	.byte $3E ; |..XXXXX.| $FBC0
	.byte $61 ; |.XX....X| $FBC1
	.byte $51 ; |.X.X...X| $FBC2
	.byte $49 ; |.X..X..X| $FBC3
	.byte $41 ; |.X.....X| $FBC4
	.byte $41 ; |.X.....X| $FBC5
	.byte $3E ; |..XXXXX.| $FBC6
	.byte $1C ; |...XXX..| $FBC7

timepiece0900
	.byte $3E ; |..XXXXX.| $FBC8
	.byte $41 ; |.X.....X| $FBC9
	.byte $41 ; |.X.....X| $FBCA
	.byte $79 ; |.XXXX..X| $FBCB
	.byte $41 ; |.X.....X| $FBCC
	.byte $41 ; |.X.....X| $FBCD
	.byte $3E ; |..XXXXX.| $FBCE
	.byte $1C ; |...XXX..| $FBCF

timepiece1100
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
; raidersMarchFreqTable

; Frequency data for the "Main Theme" (Raiders March).
; Played when channel control is $9C (Pure Tone).
; Indexed by `soundEffectTimer` (counts down from $17).
;

raidersMarchFreqTable
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
thiefSprite0
	.byte $14 ; |...X.X..|
	.byte $3C ; |..XXXX..|
	.byte $7E ; |.XXXXXX.|
	.byte $00 ; |........|
	.byte $30 ; |..XX....|
	.byte $38 ; |..XXX...|
	.byte $3C ; |..XXXX..|
	.byte $3E ; |..XXXXX.|
	.byte $3F ; |..XXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $11 ; |...X...X|
	.byte $11 ; |...X...X|
	.byte $33 ; |..XX..XX|
	.byte $00 ; |........|
thiefSprite1
	.byte $14 ; |...X.X..|
	.byte $3C ; |..XXXX..|
	.byte $7E ; |.XXXXXX.|
	.byte $00 ; |........|
	.byte $30 ; |..XX....|
	.byte $38 ; |..XXX...|
	.byte $3C ; |..XXXX..|
	.byte $3E ; |..XXXXX.|
	.byte $3F ; |..XXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $22 ; |..X...X.|
	.byte $22 ; |..X...X.|
	.byte $66 ; |.XX..XX.|
	.byte $00 ; |........|
thiefSprite2
	.byte $14 ; |...X.X..|
	.byte $3C ; |..XXXX..|
	.byte $7E ; |.XXXXXX.|
	.byte $00 ; |........|
	.byte $30 ; |..XX....|
	.byte $38 ; |..XXX...|
	.byte $3C ; |..XXXX..|
	.byte $3E ; |..XXXXX.|
	.byte $3F ; |..XXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $44 ; |.X...X..|
	.byte $44 ; |.X...X..|
	.byte $CC ; |XX..XX..|
	.byte $00 ; |........|
thiefSprite3
	.byte $14 ; |...X.X..|
	.byte $3C ; |..XXXX..|
	.byte $7E ; |.XXXXXX.|
	.byte $00 ; |........|
	.byte $30 ; |..XX....|
	.byte $38 ; |..XXX...|
	.byte $3C ; |..XXXX..|
	.byte $3E ; |..XXXXX.|
	.byte $3F ; |..XXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $7F ; |.XXXXXXX|
	.byte $08 ; |....X...|
	.byte $08 ; |....X...|
	.byte $18 ; |...XX...|
	.byte $00 ; |........|

thiefSpriteValueLo
	.byte <thiefSprite0, <thiefSprite1
	.byte <thiefSprite2, <thiefSprite3


thiefColors
	.byte DK_BLUE + 12, WHITE + 1, DK_BLUE + 12, BLACK, BLACK + 10, BLACK + 2
	.byte BLACK + 4, BLACK + 6, BLACK + 8, BLACK + 10, BLACK + 8, BLACK + 6
	.byte LT_BLUE + 8, LT_BLUE + 8, LT_BLUE + 14, LT_BLUE + 14

; Dirt pile sprite for the Well of Souls.
; Used as P0 graphics via dirtPileGfxState (low byte of pointer).
; As Indy digs with the shovel, dirtPileGfxState decrements from
; <fullDirtPile  down to <clearedDirtPile 
; sliding the 16-byte read window through this data so the pile
; visually shrinks from the top.
clearedDirtPile
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	
fullDirtPile
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $08 ; |....X...|
	.byte $1C ; |...XXX..|
	.byte $3C ; |..XXXX..|
	.byte $3E ; |..XXXXX.|
	.byte $7F ; |.XXXXXXX|
	.byte $FF ; |XXXXXXXX|
dirtPileColorBase
	.byte $FF ; |XXXXXXXX|	; ← kernelDataPtrLo points here for color data
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|

; Dirt pile COLUP0 color gradient (bottom 9 scanlines).
; kernelDataPtrLo is set to <dirtPileColorBase, with kernelDataPtrHi = $FC.
; Reading 16 bytes: the first 7 reuse fullDirtPile's $FF bytes (BROWN+15).
; These 9 bytes provide the remaining gradient: RED fading to dark YELLOW.
dirtPileColorGradient
	.byte $3E ; |..XXXXX.| $FC6C  RED + 14
	.byte $3C ; |..XXXX..| $FC6D  RED + 12
	.byte $3A ; |..XXX.X.| $FC6E  RED + 10
	.byte $38 ; |..XXX...| $FC6F  RED + 8
	.byte $36 ; |..XX.XX.| $FC70  RED + 6
	.byte $34 ; |..XX.X..| $FC71  RED + 4
	.byte $32 ; |..XX..X.| $FC72  RED + 2
	.byte $20 ; |..X.....| $FC73  LT_RED + 0
	.byte $10 ; |...X....| $FC74  YELLOW + 0

possibleTreasureItemID
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $08 ; |....X...|
	.byte $00 ; |........|
	.byte $02 ; |......X.|
	.byte $0A ; |....X.X.|
	.byte $0C ; |....XX..|
	.byte $0E ; |....XXX.|
	.byte $01 ; |.......X|
	.byte $03 ; |......XX|
	.byte $04 ; |.....X..|
	.byte $06 ; |.....XX.|
	.byte $05 ; |.....X.X|
	.byte $07 ; |.....XXX|
	.byte $0D ; |....XX.X|
	.byte $0F ; |....XXXX|
	.byte $0B ; |....X.XX|

roomHandlerJmpTable:
		.word treasureRoomHandler-1
		.word jmpSetupNewRoom -1 ; $fc8a/b
		.word entranceRoomHandler-1 ; $fc8c/d
		.word blackMarketRoomHandler-1 ; $fc8e/f
		.word mapRoomHandler-1 ; $fc90/1
		.word mesaSideRoomHandler-1 ; $fc92/3
		.word templeEntranceRoomHandler-1 ; $fc94/5
		.word spiderRoomHandler-1 ; $fc96/7
		.word roomOfShiningLightHandler-1 ; $fc98/9
		.word mesaFieldRoomHandler-1 ; $fc9a/b
		.word valleyOfPoisonRoomHandler-1 ; $fc9c/d
		.word thievesDenRoomHandler-1 ; $fc9e/f
		.word wellOfSoulsRoomHandler-1 ; $fca0/1

treasureRoomItemPosY
	.byte $1A,$38,$09,$26

treasureRoomItemOffset
	.byte $26,$46,$1A,$38

treasureRoomStateTable
	.byte $04,$11,$10,$12


spiderSprites
spiderGfxFrame1
	.byte	$54 ; |.#.#.#..|
	.byte	$fc ; |######..|
	.byte	$5f ; |.#.#####|
	.byte	$fe ; |#######.|
	.byte	$7f ; |.#######|
	.byte	$fa ; |#####.#.|
	.byte	$3f ; |..######|
	.byte	$2a ; |..#.#.#.|
	.byte	$00 ; |........|

spiderGfxFrame3
	.byte	$54 ; |.#.#.#..|
	.byte	$5f ; |.#.#####|
	.byte	$fc ; |######..|
	.byte	$7f ; |.#######|
	.byte	$fe ; |#######.|
	.byte	$3f ; |..######|
	.byte	$fa ; |#####.#.|
	.byte	$2a ; |..#.#.#.|
	.byte	$00 ; |........|

spiderGfxFrame2
	.byte	$2a ; |..#.#.#.|
	.byte	$fa ; |#####.#.|
	.byte	$3f ; |..######|
	.byte	$fe ; |#######.|
	.byte	$7f ; |.#######|
	.byte	$fa ; |#####.#.|
	.byte	$5f ; |.#.#####|
	.byte	$54 ; |.#.# #..|
	.byte	$00 ; |........|

spiderGfxFrame4
	.byte	$2a ; |..#.#.#.|
	.byte	$3f ; |..######|
	.byte	$fa ; |#####.#.|
	.byte	$7f ; |.#######|
	.byte	$fe ; |#######.|
	.byte	$5f ; |.#.#####|
	.byte	$fc ; |######..|
	.byte	$54 ; |.#.#.#..|
	.byte	$00 ; |........|

treasureRoomItemStateTable
	.byte $8B,$8A,$86,$87,$85,$89

thiefMoveDelayTable
	.byte $03,$01,$00,$01

treasureRoomStateIndex
	.byte $03,$02,$01,$03,$02,$03

itemMaskTable
	.byte $01,$02,$04,$08,$10,$20,$40,$80

invSelectAdjHandler
;invDecP0PosY
	ror
	bcs		invIncP0PosY
	dec		p0PosY,x
invIncP0PosY
	ror
	bcs		invDecP0PosX
	inc		p0PosY,x
invDecP0PosX
	ror
	bcs		invIncP0PosX
	dec		p0PosX,x
invIncP0PosX
	ror
	bcs		finishInvSelectAdj
	inc		p0PosX,x
finishInvSelectAdj
	rts

; Timepiece ball sprite animation data — 4 frames of 8 HMBL/ENABL values.
; Referenced via computed pointer at updateInvEventState:
;   kernelDataPtrLo = (frameCount AND #$06) << 2  → $00/$08/$10/$18
;   kernelDataPtrHi = $FD
; The scrolling playfield kernel writes each value to both ENABL (bit 1 =
; ball visible) and HMBL (bits 4-7 = horizontal motion), rendering the
; timepiece as across 8 scanlines per frame.
	.byte $00 ; |........| $FCFF  (padding/boundary)
timepieceBallFrame0
	.byte $F2 ; |XXXX..X.| $FD00  HMOVE R1, ball ON
	.byte $40 ; |.X......| $FD01
	.byte $F2 ; |XXXX..X.| $FD02
	.byte $C0 ; |XX......| $FD03
	.byte $12 ; |...X..X.| $FD04
	.byte $10 ; |...X....| $FD05
	.byte $F2 ; |XXXX..X.| $FD06
	.byte $00 ; |........| $FD07
timepieceBallFrame1
	.byte $12 ; |...X..X.| $FD08
	.byte $20 ; |..X.....| $FD09
	.byte $02 ; |......X.| $FD0A
	.byte $B0 ; |X.XX....| $FD0B
	.byte $F2 ; |XXXX..X.| $FD0C
	.byte $30 ; |..XX....| $FD0D
	.byte $12 ; |...X..X.| $FD0E
	.byte $00 ; |........| $FD0F
timepieceBallFrame2
	.byte $F2 ; |XXXX..X.| $FD10
	.byte $40 ; |.X......| $FD11
	.byte $F2 ; |XXXX..X.| $FD12
	.byte $D0 ; |XX.X....| $FD13
	.byte $12 ; |...X..X.| $FD14
	.byte $10 ; |...X....| $FD15
	.byte $02 ; |......X.| $FD16
	.byte $00 ; |........| $FD17
timepieceBallFrame3
	.byte $02 ; |......X.| $FD18
	.byte $30 ; |..XX....| $FD19
	.byte $12 ; |...X..X.| $FD1A
	.byte $B0 ; |X.XX....| $FD1B
	.byte $02 ; |......X.| $FD1C
	.byte $20 ; |..X.....| $FD1D
	.byte $12 ; |...X..X.| $FD1E
	.byte $00 ; |........| $FD1F

roomPF1GraphicData6:
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FC ; |XXXXXX..|
	.byte $F0 ; |XXXX....|
	.byte $E0 ; |XXX.....|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $80 ; |X.......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $C0 ; |XX......|
	.byte $E0 ; |XXX.....|
	.byte $E0 ; |XXX.....|
	.byte $F0 ; |XXXX....|
	.byte $FE ; |XXXXXXX.|

roomPF1GraphicData7:
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FC ; |XXXXXX..|
	.byte $F0 ; |XXXX....|
	.byte $E0 ; |XXX.....|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $80 ; |X.......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $C0 ; |XX......|
	.byte $F0 ; |XXXX....|
	.byte $F8 ; |XXXXX...|
	.byte $FE ; |XXXXXXX.|
	.byte $FE ; |XXXXXXX.|
	.byte $F8 ; |XXXXX...|
	.byte $F0 ; |XXXX....|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $80 ; |X.......|
	.byte $00 ; |........|

roomPF1GraphicData8:
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $02 ; |......X.|
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $0F ; |....XXXX|
	.byte $0F ; |....XXXX|
	.byte $0F ; |....XXXX|
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $02 ; |......X.|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $04 ; |.....X..|
	.byte $0E ; |....XXX.|
	.byte $0E ; |....XXX.|
	.byte $0F ; |....XXXX|
	.byte $0E ; |....XXX.|
	.byte $06 ; |.....XX.|
	.byte $00 ; |........|
	.byte $00 ; |........|

roomPF1GraphicData9:
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $02 ; |......X.|
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $0F ; |....XXXX|
	.byte $1F ; |...XXXXX|
	.byte $0F ; |....XXXX|
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $02 ; |......X.|
	.byte $00 ; |........|

roomPF2GraphicData6:
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $01 ; |.......X|
	.byte $03 ; |......XX|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $C0 ; |XX......|
	.byte $E0 ; |XXX.....|
	.byte $F8 ; |XXXXX...|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|

roomPF2GraphicData7:
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $C0 ; |XX......|
	.byte $E0 ; |XXX.....|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $C0 ; |XX......|
	.byte $E0 ; |XXX.....|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|

shiningLightSprites
shiningLightFrame0
	.byte $22 ; |..X...X.|
	.byte $41 ; |.X.....X|
	.byte $08 ; |....X...|
	.byte $14 ; |...X.X..|
	.byte $08 ; |....X...|
	.byte $41 ; |.X.....X|
	.byte $22 ; |..X...X.|
	.byte $00 ; |........|
shiningLightFrame1
	.byte $41 ; |.X.....X|
	.byte $08 ; |....X...|
	.byte $14 ; |...X.X..|
	.byte $2A ; |..X.X.X.|
	.byte $14 ; |...X.X..|
	.byte $08 ; |....X...|
	.byte $41 ; |.X.....X|
	.byte $00 ; |........|
shiningLightFrame2
	.byte $08 ; |....X...|
	.byte $14 ; |...X.X..|
	.byte $3E ; |..XXXXX.|
	.byte $55 ; |.X.X.X.X|
	.byte $3E ; |..XXXXX.|
	.byte $14 ; |...X.X..|
	.byte $08 ; |....X...|
	.byte $00 ; |........|
shiningLightFrame3
	.byte $14 ; |...X.X..|
	.byte $3E ; |..XXXXX.|
	.byte $63 ; |.XX...XX|
	.byte $2A ; |..X.X.X.|
	.byte $63 ; |.XX...XX|
	.byte $3E ; |..XXXXX.|
	.byte $14 ; |...X.X..|
	.byte $00 ; |........|


roomPF1GraphicData10:
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $03 ; |......XX|
	.byte $03 ; |......XX|
	.byte $03 ; |......XX|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $30 ; |..XX....|
	.byte $78 ; |.XXXX...|
	.byte $7C ; |.XXXXX..|
	.byte $3C ; |..XXXX..|
	.byte $3C ; |..XXXX..|
	.byte $18 ; |...XX...|
	.byte $08 ; |....X...|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $01 ; |.......X|
	.byte $0F ; |....XXXX|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $C0 ; |XX......|
	.byte $E0 ; |XXX.....|
	.byte $F8 ; |XXXXX...|
	.byte $FC ; |XXXXXX..|
	.byte $FE ; |XXXXXXX.|
	.byte $FC ; |XXXXXX..|
	.byte $F0 ; |XXXX....|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $C0 ; |XX......|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $03 ; |......XX|
	.byte $07 ; |.....XXX|
	.byte $03 ; |......XX|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $E0 ; |XXX.....|
	.byte $F8 ; |XXXXX...|
	.byte $F8 ; |XXXXX...|
	.byte $F8 ; |XXXXX...|
	.byte $F8 ; |XXXXX...|
	.byte $F0 ; |XXXX....|
	.byte $C0 ; |XX......|
	.byte $80 ; |X.......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $03 ; |......XX|
	.byte $0F ; |....XXXX|
	.byte $1F ; |...XXXXX|
	.byte $3F ; |..XXXXXX|
	.byte $3E ; |..XXXXX.|
	.byte $3C ; |..XXXX..|
	.byte $38 ; |..XXX...|
	.byte $30 ; |..XX....|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|

roomPF2GraphicData9:
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $03 ; |......XX|
	.byte $03 ; |......XX|
	.byte $03 ; |......XX|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $C0 ; |XX......|
	.byte $E0 ; |XXX.....|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $C0 ; |XX......|
	.byte $80 ; |X.......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $30 ; |..XX....|
	.byte $38 ; |..XXX...|
	.byte $1C ; |...XXX..|
	.byte $1E ; |...XXXX.|
	.byte $0E ; |....XXX.|
	.byte $0C ; |....XX..|
	.byte $0C ; |....XX..|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $C0 ; |XX......|
	.byte $F0 ; |XXXX....|
	.byte $FC ; |XXXXXX..|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FF ; |XXXXXXXX|
	.byte $FE ; |XXXXXXX.|
	.byte $FC ; |XXXXXX..|
	.byte $F8 ; |XXXXX...|
	.byte $F0 ; |XXXX....|
	.byte $E0 ; |XXX.....|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $E0 ; |XXX.....|
	.byte $F0 ; |XXXX....|
	.byte $E0 ; |XXX.....|
	.byte $80 ; |X.......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $03 ; |......XX|
	.byte $07 ; |.....XXX|
	.byte $03 ; |......XX|
	.byte $03 ; |......XX|
	.byte $01 ; |.......X|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $80 ; |X.......|
	.byte $C0 ; |XX......|
	.byte $F0 ; |XXXX....|
	.byte $F0 ; |XXXX....|
	.byte $E0 ; |XXX.....|
	.byte $E0 ; |XXX.....|
	.byte $C0 ; |XX......|
	.byte $C0 ; |XX......|
	.byte $80 ; |X.......|
	.byte $80 ; |X.......|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $03 ; |......XX|
	.byte $07 ; |.....XXX|
	.byte $07 ; |.....XXX|
	.byte $03 ; |......XX|
	.byte $01 ; |.......X|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $C0 ; |XX......|
	.byte $E0 ; |XXX.....|
	.byte $F0 ; |XXXX....|
	.byte $F8 ; |XXXXX...|
	.byte $F8 ; |XXXXX...|
	.byte $FC ; |XXXXXX..|
	.byte $FC ; |XXXXXX..|
	.byte $FC ; |XXXXXX..|

pedestalSprite
	.byte $3C ; |..XXXX..|
	.byte $3C ; |..XXXX..|
	.byte $7E ; |.XXXXXX.|
	.byte $FF ; |XXXXXXXX|

updateInvObjPos
	lda		secretArkMesaID,x
	bmi		updateInvObjPosBound
	rts

updateInvObjPosBound
	jsr		invSelectAdjHandler
	jsr		updateObjBoundPos
	rts



treasureRoomPlayerGraphics
	; ---------------------------------------------------------------
	; Treasure Room (Room 0) P0 data stream.
	; P0 starts at X=$78. The treasureRoomHandler cycles through
	; basket states based on timeOfDay, setting roomObjectVar to
	; control which portion of this data is visible.
	;
	; This data contains 4 treasure items that appear in the baskets,
	; separated by HMOVE repositioning commands. The items cycle
	; through based on the time of day. P0 is repositioned horizontally
	; between items to place them at the correct basket locations.
	;
	; The devInitialsGfx1 label overlaps — the initials data doubles
	; as the first few bytes of this stream (easter egg: HSW's
	; initials displayed via the inventory strip).
	;
	; Visual layout (top to bottom):
	;   1. Developer initials (HSW) — Not used
	;   2. Ankh (GREEN_BLUE + 12)
	;   3. Coins (YELLOW + 4) — repositioned far left
	;   4. Hourglass (ORANGE + 12 top / DK_PINK + 12 bottom)
	;   5. Chai (DK_PINK + 12, persists from hourglass)
	;   6. Developer initials (HSW) part 1 — Not used
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | BLACK >> 1			; Set color to black

devInitialsGfx1 ; Programmer's initials (HSW) part 2
	; (Also serves as top of Treasure Room P0 stream —
	;  dual-use data, referenced by checkForArkRoom)
	.byte $00 ; |........| $FF01
	.byte $07 ; |.....XXX| $FF02
	.byte $04 ; |.....X..| $FF03
	.byte $77 ; |.XXX.XXX| $FF04
	.byte $71 ; |.XXX...X| $FF05
	.byte $75 ; |.XXX.X.X| $FF06
	.byte $57 ; |.X.X.XXX| $FF07
	.byte $50 ; |.X.X....| $FF08
	.byte $00 ; |........| $FF09

	; ---------------------------------------------------------------
	; Ankh — Egyptian cross with looped top
	; (teal/cyan color, appears in one of the baskets)
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (GREEN_BLUE + 12) >> 1	; Set color to teal
	.byte $1C ; |...XXX..|  Loop top
	.byte $36 ; |..XX.XX.|  Loop sides
	.byte $1C ; |...XXX..|  Loop bottom
	.byte $49 ; |.X..X..X|  Cross arms
	.byte $7F ; |.XXXXXXX|  Cross bar (widest)
	.byte $49 ; |.X..X..X|  Cross arms
	.byte $1C ; |...XXX..|  Shaft
	.byte $3E ; |..XXXXX.|  Base
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Coins — stack of gold coins
	; Repositions P0 left (L7 persists through color cmd, then L4, then stop)
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1		; Shift P0 left 7
	.byte SET_PLAYER_0_COLOR | (YELLOW + 4) >> 1	; Set color to gold
	.byte SET_PLAYER_0_HMOVE | HMOVE_L4 >> 1		; Shift P0 left 4
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|  Gap (repositioning scanlines)
	.byte $00 ; |........|
	.byte $1C ; |...XXX..|  Top coin
	.byte $70 ; |.XXX....|  Second coin (offset left)
	.byte $07 ; |.....XXX|  Third coin (offset right)
	.byte $70 ; |.XXX....|  Fourth coin (offset left)
	.byte $0E ; |....XXX.|  Bottom coin
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Hourglass — two triangles meeting at center
	; Repositions P0 far right (R7+14 clocks combined), then stops.
	; Top half is orange, bottom half is dark pink (sand color).
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | (HMOVE_R7 | 14) >> 1	; Shift P0 right (combined)
	.byte SET_PLAYER_0_COLOR | (ORANGE + 12) >> 1	; Set color to orange (top half)
	.byte $00 ; |........|
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $77 ; |.XXX.XXX|  Top frame (wide)
	.byte $36 ; |..XX.XX.|  Narrowing
	.byte $14 ; |...X.X..|  Waist
	.byte $22 ; |..X...X.|  Center pinch
	.byte SET_PLAYER_0_COLOR | (DK_PINK + 12) >> 1	; Set color to pink (bottom half)
	.byte $14 ; |...X.X..|  Waist (expanding)
	.byte $36 ; |..XX.XX.|  Widening
	.byte $77 ; |.XXX.XXX|  Bottom frame (wide)
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Chai — Hebrew letter ח (symbol of life)
	; Color persists from hourglass (DK_PINK + 12).
	; These bytes have bit 7 set so they act as command+graphics
	; interleaved — $BF, $CE, $EF encode both HMOVE/color and
	; are also written to GRP0 on their respective scanlines.
	; ---------------------------------------------------------------
	.byte $BF ; |X.XXXXXX|  Chai top (also cmd: odd = HMOVE)
	.byte $CE ; |XX..XXX.|  Chai mid-top (also cmd: even = COLUP0)
	.byte $00 ; |........|
	.byte $EF ; |XXX.XXXX|  Chai body (also cmd: odd = HMOVE)
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|  Gap
	.byte $00 ; |........|
	.byte $68 ; |.XX.X...|  Chai bottom stroke (left arm)
	.byte $2F ; |..X.XXXX|  Chai connecting bar
	.byte $0A ; |....X.X.|  Chai right post
	.byte $0C ; |....XX..|  Chai right post base
	.byte $08 ; |....X...|  Chai base
	.byte $00 ; |........|
	.byte $80 ; |X.......|  (cmd: even = COLUP0, sets new color)
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $00 ; |........|
	.byte $00 ; |........|



devInitialsGfx0
	.byte $07 ; |.....XXX|
	.byte $01 ; |.......X|
	.byte $57 ; |.X.X.XXX|
	.byte $54 ; |.X.X.X..|
	.byte $77 ; |.XXX.XXX|
	.byte $50 ; |.X.X....|
	.byte $50 ; |.X.X....|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|



marketplacePlayerGraphics
	; ---------------------------------------------------------------
	; Marketplace (Room 1) P0 data stream.
	; Initial P0 color: LT_RED + 8 (from roomP0ColorTable),
	; immediately overridden by BLACK.
	;
	; This stream draws the marketplace scene's static elements:
	; two sellers (merchants), a flute for sale, three baskets
	; (blue, green, purple), and a parachute pack display.
	; HMOVE commands reposition P0 horizontally between items.
	;
	; GRP0 persists through command scanlines — color commands
	; create multi-colored horizontal bands from the same sprite
	; shape without rewriting GRP0 (e.g., the sellers' striped
	; hat/face/body appearance).
	;
	; Visual layout (top to bottom):
	;   1. Seller 1 — black hat, grey stripe, pink face, black robes
	;   2. Flute — diagonal (HMOVE_R1 drift), yellow
	;   3. Blue basket — shifted far left (cyan checkerboard)
	;   4. Green basket — shifted far right (green checkerboard)
	;   5. Seller 2 — grey hat, black stripe, pink face, grey robes
	;   6. Parachute pack — teal two-column blocks
	;   7. Purple basket — shifted right (purple checkerboard)
	; ---------------------------------------------------------------

	; ---------------------------------------------------------------
	; Seller 1 — merchant with black hat, grey stripe, pink face
	; GRP0 shape $7E persists through color changes, creating
	; horizontal color bands (hat → stripe → face → body).
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | BLACK >> 1			; Set color to black (hat)
	.byte $7E ; |.XXXXXX.|  Hat top
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1	; Set color to grey (hat stripe)
	.byte SET_PLAYER_0_COLOR | BLACK >> 1			; Set color to black (hat band)
	.byte SET_PLAYER_0_COLOR | (ORANGE + 12) >> 1	; Set color to pink (face)
	.byte $5A ; |.X.XX.X.|  Face features (eyes)
	.byte $7E ; |.XXXXXX.|  Face fill
	.byte SET_PLAYER_0_COLOR | BLACK >> 1			; Set color to black (body)
	.byte $7F ; |.XXXXXXX|  Body/robes
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Flute — diagonal staff/instrument for sale
	; HMOVE_L6 repositions P0 left, then HMOVE_R1 drifts P0 right
	; 1 pixel per scanline, creating the diagonal angle visible
	; in the screenshot.
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L6 >> 1		; Shift P0 left 6 (reposition)
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Shift P0 right 1/line (diagonal)
	.byte SET_PLAYER_0_COLOR | (LT_BROWN + 12) >> 1	; Set color to yellow
	.byte $06 ; |.....XX.|  Flute tip
	.byte $1E ; |...XXXX.|  Flute body
	.byte $12 ; |...X..X.|  Flute holes
	.byte $1E ; |...XXXX.|  Flute body
	.byte $12 ; |...X..X.|  Flute holes
	.byte $1E ; |...XXXX.|  Flute body
	.byte $7F ; |.XXXXXXX|  Flute base (wide)
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Blue basket — shifted far left
	; Cyan/teal checkerboard pattern (marketplace item basket).
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1		; Shift P0 left 7 (reposition)
	.byte $00 ; |........|  (repositioning scanline)
	.byte SET_PLAYER_0_COLOR | (GREEN_BLUE + 8) >> 1	; Set color to cyan
	.byte $00 ; |........|
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $1C ; |...XXX..|  Basket top
	.byte $2A ; |..X.X.X.|  Basket weave
	.byte $55 ; |.X.X.X.X|  Basket weave
	.byte $2A ; |..X.X.X.|  Basket weave
	.byte $14 ; |...X.X..|  Basket bottom
	.byte $3E ; |..XXXXX.|  Basket base
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Green basket — shifted far right
	; Green checkerboard pattern (marketplace item basket).
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_R8 >> 1		; Shift P0 right 8 (reposition)
	.byte SET_PLAYER_0_COLOR | (GREEN + 12) >> 1	; Set color to green
	.byte $00 ; |........|  (repositioning scanline)
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $7F ; |.XXXXXXX|  Basket rim (wide)
	.byte $55 ; |.X.X.X.X|  Basket weave
	.byte $2A ; |..X.X.X.|  Basket weave
	.byte $55 ; |.X.X.X.X|  Basket weave
	.byte $2A ; |..X.X.X.|  Basket weave
	.byte $3E ; |..XXXXX.|  Basket base
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Seller 2 — merchant with grey hat, pink face, grey robes
	; Same GRP0 shapes as seller 1 ($7E/$5A/$7E/$7F) but
	; different color ordering produces a lighter appearance.
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1		; Shift P0 left 7 (reposition)
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1	; Set color to grey (hat)
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1		; Shift P0 left 2 (fine-tune)
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $7E ; |.XXXXXX.|  Hat/head (grey)
	.byte SET_PLAYER_0_COLOR | BLACK >> 1			; Set color to black (hat band)
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1	; Set color to grey (hat stripe)
	.byte SET_PLAYER_0_COLOR | (ORANGE + 12) >> 1	; Set color to pink (face)
	.byte $5A ; |.X.XX.X.|  Face features (eyes)
	.byte $7E ; |.XXXXXX.|  Face fill
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1	; Set color to grey (body)
	.byte $7F ; |.XXXXXXX|  Body/robes
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Parachute pack — teal two-column block display
	; GRP0 $77 persists through color commands, creating a
	; striped block pattern (teal → black strap → teal).
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_COLOR | (GREEN_BLUE + 12) >> 1	; Set color to teal
	.byte $77 ; |.XXX.XXX|  Pack top
	.byte $77 ; |.XXX.XXX|  Pack middle
	.byte SET_PLAYER_0_COLOR | BLACK >> 1			; Set color to black (strap)
	.byte SET_PLAYER_0_COLOR | (GREEN_BLUE + 12) >> 1	; Set color to teal
	.byte $77 ; |.XXX.XXX|  Pack bottom
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Purple basket — shifted right
	; Purple/magenta checkerboard pattern (marketplace item basket).
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_R8 >> 1		; Shift P0 right 8 (reposition)
	.byte SET_PLAYER_0_COLOR | (PURPLE + 12) >> 1	; Set color to purple
	.byte SET_PLAYER_0_HMOVE | HMOVE_L4 >> 1		; Shift P0 left 4 (fine-tune)
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $1C ; |...XXX..|  Basket top
	.byte $2A ; |..X.X.X.|  Basket weave
	.byte $55 ; |.X.X.X.X|  Basket weave
	.byte $2A ; |..X.X.X.|  Basket weave
	.byte $14 ; |...X.X..|  Basket bottom
	.byte $3E ; |..XXXXX.|  Basket base
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|
	.byte $00 ; |........|




entranceRoomPlayerGraphics
	; ---------------------------------------------------------------
	; Entrance Room (Room 2) P0 data stream.
	; Initial P0 color: BROWN + 8 (from roomP0ColorTable),
	; immediately overridden by grey (BLACK + 12).
	;
	; This stream draws four elements in the Entrance Room:
	;   1. A key near the top (unused, but data still present)
	;   2. The temple cave entrance (right wall opening) — a tall
	;      jagged silhouette using extensive HMOVE jitter (L1/R1)
	;      to produce a natural, rough stone edge
	;   3. A rock/boulder (center-left)
	;   4. The whip lying on the ground (diagonal via HMOVE drift)
	;
	; The cave entrance is the dominant feature. P0 draws the LEFT
	; edge of the opening; the GRP0 pixel pattern ($1F/$7F/$3F)
	; persists through many HMOVE-only command scanlines, shifting
	; left and right each line to create the irregular stone wall.
	; ---------------------------------------------------------------

	; ---------------------------------------------------------------
	; Key - Unused
	; ---------------------------------------------------------------
	.byte $00						; Padding
	.byte SET_PLAYER_0_COLOR | (BLACK + 12) >> 1	; Set color to grey

	.byte $70						; |.XXX....|  
	.byte $5F						; |.X.XXXXX| 
	.byte $72						; |.XXX..X.| 
	.byte $05						; |.....X.X| 

	.byte $00						; |........|	; padding

	; ---------------------------------------------------------------
	; Temple cave entrance — left edge of opening on right wall
	; Repositions P0 far right (HMOVE_R8) to align with right wall.
	; Three zones: grey stone top lip, black interior depth with
	; jagged HMOVE edge, grey stone bottom lip.
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_R8 >> 1		; Shift P0 right 8 (to right wall)
	.byte $00						; (repositioning scanline)
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion

	; --- Entrance top lip (grey stone edge) ---
	.byte SET_PLAYER_0_COLOR | (BLACK + 8) >> 1	; Set color to dark grey (stone)
	.byte $1F ; |...XXXXX|  Stone lip (wide)
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Stagger edge left
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Stagger edge right
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1		; Stagger edge left 2
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Stagger edge right
	.byte $18 ; |...XX...|  Stone lip narrows
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion

	; --- Entrance interior (black cave depth, jagged edge) ---
	; GRP0 shapes ($1C→$1F→$7F) persist through HMOVE commands.
	; Each HMOVE shifts the sprite 1-2 pixels left or right per
	; scanline, creating the rough/natural stone wall silhouette.
	.byte SET_PLAYER_0_COLOR | BLACK >> 1			; Set color to black (cave depth)
	.byte $1C ; |...XXX..|  Opening top
	.byte $1F ; |...XXXXX|  Opening widens
	.byte SET_PLAYER_0_HMOVE | HMOVE_R2 >> 1		; Jag right 2
	.byte $7F ; |.XXXXXXX|  Interior (widest)
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Jagged edge: L1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Jagged edge: R1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Jagged edge: R1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Jagged edge: L1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1		; Jagged edge: L2
	.byte SET_PLAYER_0_HMOVE | HMOVE_R2 >> 1		; Jagged edge: R2
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Jagged edge: R1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Jagged edge: L1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Jagged edge: R1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Jagged edge: R1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Jagged edge: L1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Jagged edge: R1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Jagged edge: L1
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Jagged edge: R1
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Jagged edge: L1
	.byte $3F ; |..XXXXXX|  Opening narrows
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1		; Pull edge left 2
	.byte SET_PLAYER_0_HMOVE | HMOVE_0 >> 1		; Stop horizontal motion
	.byte $70 ; |.XXX....|  Opening bottom
	.byte $40 ; |.X......|  Opening tip

	; --- Entrance bottom lip (grey stone edge) ---
	.byte SET_PLAYER_0_COLOR | (BLACK + 8) >> 1	; Set color to dark grey (stone)
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Stagger left
	.byte $7E ; |.XXXXXX.|  Bottom stone lip (wide)
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Stagger right
	.byte SET_PLAYER_0_HMOVE | HMOVE_L2 >> 1		; Stagger left 2
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Stagger right
	.byte SET_PLAYER_0_HMOVE | HMOVE_R2 >> 1		; Stagger right 2
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Rock/boulder — grey stone, repositioned to center-left
	; Irregular shape with HMOVE wobble for natural appearance.
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L7 >> 1		; Shift P0 left 7 (reposition)
	.byte SET_PLAYER_0_COLOR | (BLACK + 8) >> 1	; Set color to dark grey
	.byte $00 ; |........|  (repositioning scanline)
	.byte $00 ; |........|  (repositioning scanline)
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Fine-tune left
	.byte $38 ; |..XXX...|  Boulder top
	.byte $78 ; |.XXXX...|  Boulder widening
	.byte $7B ; |.XXXX.XX|  Boulder body (irregular)
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Wobble right
	.byte SET_PLAYER_0_HMOVE | HMOVE_L1 >> 1		; Wobble left
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Wobble right
	.byte $6F ; |.XX.XXXX|  Boulder base (irregular)
	.byte $00 ; |........|

	; ---------------------------------------------------------------
	; Whip — Indy's whip lying on the ground
	; Repositions P0 far left (HMOVE_L6), then drifts right
	; (R3, R1) each scanline to create the diagonal angle.
	; Color is orange/brown (LT_RED + 4).
	; ---------------------------------------------------------------
	.byte SET_PLAYER_0_HMOVE | HMOVE_L6 >> 1		; Shift P0 left 6 (reposition)
	.byte SET_PLAYER_0_COLOR | (LT_RED + 4) >> 1	; Set color to orange/brown

	; --- Whip handle ---
	.byte SET_PLAYER_0_HMOVE | HMOVE_R3 >> 1		; Drift right 3 (angle start)
	.byte SET_PLAYER_0_HMOVE | HMOVE_R1 >> 1		; Drift right 1
	.byte $00 ; |........|
	.byte $30 ; |..XX....|  Handle segment
	.byte $30 ; |..XX....|  Handle segment
	.byte $30 ; |..XX....|  Handle segment

	; --- Whip lash ---
	.byte SET_PLAYER_0_HMOVE | HMOVE_R3 >> 1		; Drift right 3 (steeper angle)
	.byte $30 ; |..XX....|  Lash segment
	.byte $30 ; |..XX....|  Lash segment
	.byte $30 ; |..XX....|  Lash segment
	.byte $10 ; |...X....|  Lash tip (tapers)
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
	.word bank1Start	; NMI
	.word bank1Start	; RESET
	.word bank1Start	; IRQ/BRK
