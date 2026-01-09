   LIST OFF
; ***  R A I D E R S  O F  T H E  L O S T  A R K  ***
; Copyright 1982 Atari, Inc.
; Designer: Howard Scott Warshaw
; Artist:   Jerome Domurat

; Analyzed, labeled and commented
;  by Dennis Debro
; Last Update: Aug. 8, 2018
;
;  *** ### BYTES OF RAM USED ### BYTES FREE
;  *** ### BYTES OF ROM FREE
;
; ==============================================================================
; = THIS REVERSE-ENGINEERING PROJECT IS BEING SUPPLIED TO THE PUBLIC DOMAIN    =
; = FOR EDUCATIONAL PURPOSES ONLY. THOUGH THE CODE WILL ASSEMBLE INTO THE      =
; = EXACT GAME ROM, THE LABELS AND COMMENTS ARE THE INTERPRETATION OF MY OWN   =
; = AND MAY NOT REPRESENT THE ORIGINAL VISION OF THE AUTHOR.                   =
; =                                                                            =
; = THE ASSEMBLED CODE IS © 1982, ATARI, INC.                                  =
; =                                                                            =
; ==============================================================================
;
; This is Howard Scott Warshaw's second game with Atari.

   processor 6502

;
; NOTE: You must compile this with vcs.h version 105 or greater.
;
TIA_BASE_READ_ADDRESS = $30         ; set the read address base so this runs on
                                    ; the real VCS and compiles to the exact
                                    ; ROM image

   include ..\..\..\..\macro.h
   include ..\..\..\..\tia_constants.h
   include ..\..\..\..\vcs.h

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

NTSC                    = 0
PAL50                   = 1

TRUE                    = 1
FALSE                   = 0

   IFNCONST COMPILE_VERSION

COMPILE_VERSION         = NTSC      ; change to compile for different regions

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

VBLANK_TIME             = 44
OVERSCAN_TIME           = 36

   ELSE

VBLANK_TIME             = 78
OVERSCAN_TIME           = 72

   ENDIF
   
;===============================================================================
; C O L O R - C O N S T A N T S
;===============================================================================

   IF COMPILE_VERSION = NTSC

BLACK                   = $00
WHITE                   = $0E
YELLOW                  = $10
LT_RED                  = $20
RED                     = $30
ORANGE                  = $40
DK_PINK                 = $50
DK_BLUE                 = $70
BLUE                    = $80
LT_BLUE                 = $90
GREEN_BLUE              = $A0
GREEN                   = $C0
DK_GREEN                = $D0
LT_BROWN                = $E0
BROWN                   = $F0

   ELSE

BLACK                   = $00
WHITE                   = $0E
LT_RED                  = $20
RED                     = $40
ORANGE                  = RED + 2
LT_BROWN                = $50
DK_GREEN                = LT_BROWN
DK_BLUE                 = $70
DK_PINK                 = $80
LT_BLUE                 = $90
BLUE                    = $D0
GREEN                   = $E0
BROWN                   = $F0

   ENDIF

;===============================================================================
; T I A - M U S I C  C O N S T A N T S
;===============================================================================

SOUND_CHANNEL_SAW       = 1         ; sounds similar to a saw waveform
SOUND_CHANNEL_ENGINE    = 3         ; many games use this for an engine sound
SOUND_CHANNEL_SQUARE    = 4         ; a high pitched square waveform
SOUND_CHANNEL_BASS      = 6         ; fat bass sound
SOUND_CHANNEL_PITFALL   = 7         ; log sound in pitfall, low and buzzy
SOUND_CHANNEL_NOISE     = 8         ; white noise
SOUND_CHANNEL_LEAD      = 12        ; lower pitch square wave sound
SOUND_CHANNEL_BUZZ      = 15        ; atonal buzz, good for percussion

LEAD_E4                 = 15
LEAD_D4                 = 17
LEAD_C4_SHARP           = 18
LEAD_A3                 = 23
LEAD_E3_2               = 31
 
;===============================================================================
; U S E R - C O N S T A N T S
;===============================================================================

BANK0TOP                = $1000
BANK1TOP                = $2000

BANK0_REORG             = $D000
BANK1_REORG             = $F000

BANK0STROBE             = $FFF8
BANK1STROBE             = $FFF9

LDA_ABS                 = $AD       ; instruction to LDA $XXXX
JMP_ABS                 = $4C       ; instruction for JMP $XXXX

INIT_SCORE              = 100       ; starting score

SET_PLAYER_0_COLOR      = %10000000
SET_PLAYER_0_HMOVE      = %10000001

XMAX                    = 160
; screen id values

ID_TREASURE_ROOM        = 0 ;--
ID_MARKETPLACE          = 1 ; |
ID_ENTRANCE_ROOM        = 2 ; |
ID_BLACK_MARKET         = 3 ; | -- JumpIntoStationaryPlayerKernel
ID_MAP_ROOM             = 4 ; |
ID_MESA_SIDE            = 5 ;--

ID_TEMPLE_ENTRANCE      = 6 ;--
ID_SPIDER_ROOM          = 7 ; |
ID_ROOM_OF_SHINING_LIGHT = 8; | -- DrawPlayfieldKernel
ID_MESA_FIELD           = 9 ; |
ID_VALLEY_OF_POISON     = 10;--

ID_THIEVES_DEN          = 11;-- LF140
ID_WELL_OF_SOULS        = 12;-- LF140
ID_ARK_ROOM             = 13

H_ARK_OF_THE_COVENANT   = 7
H_PEDESTAL              = 15
H_INDY_SPRITE           = 11
H_INVENTORY_SPRITES     = 8
H_PARACHUTE_INDY_SPRITE = 15
H_THIEF                 = 16
H_KERNEL                = 160

ENTRANCE_ROOM_CAVE_VERT_POS = 9
ENTRANCE_ROOM_ROCK_VERT_POS = 53

MAX_INVENTORY_ITEMS     = 6
;
; Inventory Sprite Ids
;
ID_INVENTORY_EMPTY      = (EmptySprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_FLUTE      = (InventoryFluteSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_PARACHUTE  = (InventoryParachuteSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_COINS      = (InventoryCoinsSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_MARKETPLACE_GRENADE  = (MarketplaceGrenadeSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_BLACK_MARKET_GRENADE = (BlackMarketGrenadeSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_KEY        = (InventoryKeySprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_WHIP       = (InventoryWhipSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_SHOVEL     = (InventoryShovelSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_REVOLVER   = (InventoryRevolverSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_HEAD_OF_RA = (InventoryHeadOfRaSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_TIME_PIECE = (InventoryTimepieceSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_ANKH       = (InventoryAnkhSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_CHAI       = (InventoryChaiSprite - InventorySprites) / H_INVENTORY_SPRITES
ID_INVENTORY_HOUR_GLASS = (InventoryHourGlassSprite - InventorySprites) / H_INVENTORY_SPRITES

;
; Room State Values
;

; Entrance Room status values
INDY_CARRYING_WHIP      = %00000001
GRENADE_OPENING_IN_WALL = %00000010

; Black Market status values
INDY_NOT_CARRYING_COINS = %10000000
INDY_CARRYING_SHOVEL    = %00000001

BASKET_STATUS_MARKET_GRENADE = %00000001
BASKET_STATUS_BLACK_MARKET_GRENADE = %00000010
BACKET_STATUS_REVOLVER  = %00001000
BASKET_STATUS_COINS     = %00010000
BASKET_STATUS_KEY       = %00100000

PICKUP_ITEM_STATUS_WHIP = %00000001
PICKUP_ITEM_STATUS_SHOVEL = %00000010
PICKUP_ITEM_STATUS_HEAD_OF_RA = %00000100
PICKUP_ITEM_STATUS_TIME_PIECE = %00001000
PICKUP_ITEM_STATUS_HOUR_GLASS = %00100000
PICKUP_ITEM_STATUS_ANKH = %01000000
PICKUP_ITEM_STATUS_CHAI = %10000000

PENALTY_GRENADE_OPENING = 2
PENALTY_SHOOTING_THIEF  = 4
PENALTY_ESCAPE_SHINING_LIGHT_PRISON = 13
BONUS_USING_PARACHUTE   = 3
BONUS_LANDING_IN_MESA   = 3
BONUS_FINDING_YAR       = 5
BONUS_SKIP_MESA_FIELD   = 9
BONUS_FINDING_ARK       = 10
BONUS_USING_HEAD_OF_RA_IN_MAPROOM = 14

; bullet or whip status values
BULLET_OR_WHIP_ACTIVE = %1000000

USING_GRENADE_OR_PARACHUTE = %00000010

;============================================================================
; Z P - V A R I A B L E S
;============================================================================
   SEG.U variables
   .org $80
   
scanline                ds 1;= $80
currentScreenId         ds 1;= $81
frameCount              ds 1;= $82
secondsTimer            ds 1;= $83
bankSwitchingVariables  ds 6;= $84       ; $84 - $89
;--------------------------------------
bankSwitchLDAInstruction = bankSwitchingVariables
bankStrobeAddress       = bankSwitchingVariables + 1
bankSwitchJMPInstruction = bankStrobeAddress + 2
bankSwitchJMPAddress    = bankSwitchJMPInstruction + 1
;--------------------------------------
loopCount               = bankSwitchingVariables
tempCharHolder          = bankStrobeAddress
zp_8A                   ds 1;= $8A

bulletOrWhipStatus      = $8F

playfieldControl        = $94
zp_95                   = $95

grenadeDetinationTime   = $9B
zp_9C                   = $9C
adventurePoints         = $9E
lives                   = $9F
numberOfBullets         = $A0

grenadeOpeningPenalty   = $A5
escapedShiningLightPenalty = $A6
findingArkBonus         = $A7
usingParachuteBonus     = $A8

skipToMesaFieldBonus    = $A9
findingYarEasterEggBonus = $AA
usingHeadOfRaInMapRoomBonus = $AB
shootingThiefPenalty    = $AC
landingInMesaBonus      = $AD

entranceRoomState       = $B1
blackMarketState        = $B2

inventoryGraphicPointers = $B7      ; $B7 - $C2
selectedInventoryIndex  = $C3
numberOfInventoryItems  = $C4
selectedInventoryId     = $C5
basketItemsStatus       = $C6
pickupItemsStatus       = $C7
objectHorizPositions    = $C8
;--------------------------------------

indyHorizPos            = objectHorizPositions + 1 ;$C9

bulletOrWhipHorizPos    = objectHorizPositions + 3 ;$CB

objectVertPositions     = $CE
;--------------------------------------
topObjectVertPos        = objectVertPositions
;--------------------------------------
shiningLightVertPos     = objectVertPositions
indyVertPos             = objectVertPositions + 1 ;$CF
missile0VertPos         = objectVertPositions + 2 ;$D0
bulletOrWhipVertPos     = objectVertPositions + 3; $D1

snakeVertPos            = objectVertPositions + 7 ;$D5
timePieceGraphicPointers = $D6      ; $D6 - D7
;--------------------------------------
player0ColorPointers    = timePieceGraphicPointers

indyGraphicPointers     = $D9       ; $D9 - $DA
indySpriteHeight        = $DB
player0SpriteHeight     = $DC
player0GraphicPointers  = $DD       ; $DD - $DE
thievesDirectionAndSize = $DF       ; $DF - $E2
;--------------------------------------
bottomObjectVertPos     = thievesDirectionAndSize
;--------------------------------------
whipVertPos             = bottomObjectVertPos
;--------------------------------------
shovelVertPos           = whipVertPos
player0TIAPointers      = $E1       ; $E1 - $E4
;--------------------------------------
player0ColorPointer     = player0TIAPointers
player0FineMotionPointer = player0ColorPointer + 2
;--------------------------------------
pf1GraphicPointers      = player0ColorPointer; $E1 - $E2
pf2GraphicPointers      = player0FineMotionPointer; $E3 - $E4
thievesHMOVEIndex       = $E5       ; $E5 - $E8
;--------------------------------------
dungeonGraphics         = thievesHMOVEIndex ; $E5 - $EA
;--------------------------------------
topOfDungeonGraphic     = dungeonGraphics

thievesHorizPositions   = $EE       ; $EE - $F1

   echo "***",(*-$80 - 2)d, "BYTES OF RAM USED", ($100 - * + 2)d, "BYTES FREE"
   
;===============================================================================
; R O M - C O D E  (BANK 0)
;===============================================================================

   SEG Bank0
   .org BANK0TOP
   .rorg BANK0_REORG
   
   lda BANK0STROBE
   jmp Start
   
HorizPositionObjects
   ldx #<RESBL - RESP0
.moveObjectLoop
   sta WSYNC                        ; wait for next scan line
   lda objectHorizPositions,x       ; get object's horizontal position
   tay
   lda HMOVETable,y                 ; get fine motion/coarse position value
   sta HMP0,x                       ; set object's fine motion value
   and #$0F                         ; mask off fine motion value
   tay                              ; move coarse move value to y
.coarseMoveObject
   dey
   bpl .coarseMoveObject
   sta RESP0,x                      ; set object's coarse position
   dex
   bpl .moveObjectLoop
   sta WSYNC                        ; wait for next scan line
   sta HMOVE
   jmp JumpToDisplayKernel
   
CheckObjectCollisions
   bit CXM1P                        ; check player collision with Indy bullet
   bpl .checkPlayfieldCollisionWithBulletOrWhip; branch if no player collision
   ldx currentScreenId              ; get the current screen id
   cpx #ID_VALLEY_OF_POISON
   bcc .checkPlayfieldCollisionWithBulletOrWhip
   beq .indyShootHitThief           ; branch if Indy in the Valley of Poison
   lda bulletOrWhipVertPos          ; Indy in Theives Den or Well of Souls
   adc #2 - 1                       ; carry set here
   lsr                              ; divide value by 16 (i.e. H_THIEF)
   lsr
   lsr
   lsr
   tax
   lda #REFLECT
   eor thievesDirectionAndSize,x    ; change the direction of the Thief
   sta thievesDirectionAndSize,x
.indyShootHitThief
   lda bulletOrWhipStatus           ; get bullet or whip status
   bpl .setPenaltyForShootingThief  ; branch if bullet or whip not active
   and #~BULLET_OR_WHIP_ACTIVE
   sta bulletOrWhipStatus           ; clear BULLET_OR_WHIP_ACTIVE bit
   lda zp_95
   and #$1F       ;2
   beq LD050      ;2
   jsr PlaceItemInInventory
LD050:
   lda #$40       ;2
   sta zp_95
.setPenaltyForShootingThief
   lda #~BULLET_OR_WHIP_ACTIVE
   sta bulletOrWhipVertPos          ; clear BULLET_OR_WHIP_ACTIVE bit
   lda #PENALTY_SHOOTING_THIEF
   sta shootingThiefPenalty         ; penalize player for shooting a thief
.checkPlayfieldCollisionWithBulletOrWhip
   bit CXM1FB                       ; check missile 1 and playfield collisions
   bpl CheckIfIndyShotSnake         ; branch if no missile and playfield collision
   ldx currentScreenId              ; get the current screen id
   cpx #ID_MESA_FIELD
   beq CheckIndyCollisionWithSnakeOrTimePiece; branch if in the Mesa field
   cpx #ID_TEMPLE_ENTRANCE
   beq LD06E      ;2
   cpx #ID_ROOM_OF_SHINING_LIGHT
   bne CheckIfIndyShotSnake
LD06E:
   lda bulletOrWhipVertPos          ; get bullet or whip vertical position
   sbc $D4
   lsr
   lsr
   beq LD087      ;2
   tax
   ldy bulletOrWhipHorizPos         ; get bullet or whip horizontal position
   cpy #24
   bcc LD0A4      ;2
   cpy #141
   bcs LD0A4      ;2
   lda #$00       ;2
   sta thievesHMOVEIndex,x      ;4
   beq LD0A4                        ; unconditional branch
   
LD087:
   lda bulletOrWhipHorizPos         ; get bullet or whip horizontal position
   cmp #48
   bcs LD09E      ;2
   sbc #16
   eor #$1F       ;2
LD091:
   lsr            ;2
   lsr            ;2
   tax            ;2
   lda LDC5C,x    ;4
   and topOfDungeonGraphic
   sta topOfDungeonGraphic
   jmp LD0A4
   
LD09E:
   sbc #113
   cmp #32
   bcc LD091      ;2
LD0A4:
   ldy #$7F       ;2
   sty bulletOrWhipStatus           ; clear BULLET_OR_WHIP_ACTIVE status
   sty bulletOrWhipVertPos          ; set vertical position out of range
CheckIfIndyShotSnake
   bit CXM1FB                       ; check if snake hit with bullet or whip
   bvc CheckIndyCollisionWithSnakeOrTimePiece; branch if snake not hit
   bit $93        ;3
   bvc CheckIndyCollisionWithSnakeOrTimePiece
   lda #$5A       ;2
   sta $D2        ;3
   sta $DC        ;3
   sta bulletOrWhipStatus           ; clear BULLET_OR_WHIP_ACTIVE status
   sta bulletOrWhipVertPos
CheckIndyCollisionWithSnakeOrTimePiece
   bit CXP1FB                       ; check Indy collision with ball
   bvc CheckIfIndyEnteringWellOfSouls; branch if Indy didn't collide with ball
   ldx currentScreenId              ; get the current screen id
   cpx #ID_TEMPLE_ENTRANCE
   beq .indyTouchingTimePiece
   lda selectedInventoryId          ; get the current selected inventory id
   cmp #ID_INVENTORY_FLUTE
   beq CheckIfIndyEnteringWellOfSouls; branch if the Flute is selected
   bit $93        ;3
   bpl LD0DA      ;2
   lda secondsTimer        ;3
   and #$07       ;2
   ora #$80       ;2
   sta $A1        ;3
   bne CheckIfIndyEnteringWellOfSouls; unconditional branch
   
LD0DA:
   bvc CheckIfIndyEnteringWellOfSouls
   lda #$80       ;2
   sta $9D        ;3
   bne CheckIfIndyEnteringWellOfSouls; unconditional branch
   
.indyTouchingTimePiece
   lda timePieceGraphicPointers
   cmp #<LFABA
   bne CheckIfIndyEnteringWellOfSouls
   lda #ID_INVENTORY_TIME_PIECE
   jsr PlaceItemInInventory
CheckIfIndyEnteringWellOfSouls
   ldx #ID_MESA_SIDE
   cpx currentScreenId
   bne LD12D                        ; branch if Indy not in MESA_SIDE
   bit CXM0P                        ; check missile 0 and player collisions
   bpl LD106                        ; branch if Indy not entering WELL_OF_SOULS
   stx indyVertPos                  ; set Indy vertical position (i.e. x = 5)
   lda #ID_WELL_OF_SOULS
   sta currentScreenId              ; move Indy to the Well of Souls
   jsr SetCurrentScreenData
   lda #(XMAX / 2) - 4
   sta indyHorizPos                 ; place Indy in horizontal middle
   bne .clearCollisionRegisters     ; unconditional branch
   
LD106:
   ldx indyVertPos                  ; get Indy's vertical position
   cpx #$4F       ;2
   bcc LD12D      ;2
   lda #ID_VALLEY_OF_POISON
   sta currentScreenId
   jsr SetCurrentScreenData
   lda $EB        ;3
   sta $DF        ;3
   lda $EC        ;3
   sta indyVertPos        ;3
   lda $ED        ;3
   sta indyHorizPos        ;3
   lda #$FD       ;2
   and $B4        ;3
   sta $B4        ;3
   bmi .clearCollisionRegisters
   lda #$80       ;2
   sta $9D        ;3
.clearCollisionRegisters
   sta CXCLR                        ; clear all collisions
LD12D:
   bit CXPPMM                       ; check player / missile collisions
   bmi .branchToPlayerCollisionRoutine;branch if players collided
   ldx #$00       ;2
   stx $91        ;3
   dex            ;2
   stx $97        ;3
   rol zp_95
   clc            ;2
   ror zp_95
LD13D:
   jmp   LD2B4    ;3
   
.branchToPlayerCollisionRoutine
   lda currentScreenId              ; get the current screen id
   bne .jmpToPlayerCollisionRoutine ; branch if not Treasure Room
   lda $AF        ;3
   and #7
   tax
   lda MarketBasketItems,x          ; get items from market basket
   jsr PlaceItemInInventory         ; place basket item in inventory
   bcc LD13D      ;2
   lda #$01       ;2
   sta $DF        ;3
   bne LD13D                        ; unconditional branch
   
.jmpToPlayerCollisionRoutine
   asl                              ; multiply screen id by 2
   tax
   lda PlayerCollisionJumpTable + 1,x
   pha                              ; push MSB to stack
   lda PlayerCollisionJumpTable,x
   pha                              ; push LSB to stack
   rts                              ; jump to player collision routine

PlayerCollisionsInWellOfSouls
   lda indyVertPos                  ; get Indy's vertical position
   cmp #63
   bcc .takeAwayShovel              ; take shovel away from Indy
   lda $96        ;3
   cmp #$54       ;2
   bne LD1C1      ;2
   lda $8C        ;3
   cmp $8B        ;3
   bne .arkNotFound
   lda #INIT_SCORE - 12
   sta zp_9C
   sta adventurePoints
   jsr DetermineFinalScore
   lda #ID_ARK_ROOM
   sta currentScreenId
   jsr SetCurrentScreenData
   jmp VerticalSync
   
.arkNotFound
   jmp PlaceIndyInMesaSide
   
.takeAwayShovel
   lda #ID_INVENTORY_SHOVEL
   bne .takeItemFromInventory       ; check to remove shovel from inventory
   
PlayerCollisionsInThievesDen
   lda #ID_INVENTORY_KEY
   bne .takeItemFromInventory       ; check to remove key from inventory
   
PlayerCollisionsInValleyOfPoison
   lda #ID_INVENTORY_COINS
.takeItemFromInventory
   bit zp_95
   bmi LD1C1      ;2
   clc
   jsr TakeItemFromInventory        ; carry clear...take away specified item
   bcs LD1A4      ;2
   sec
   jsr TakeItemFromInventory        ; carry set...take away selected item
   bcc LD1C1      ;2
LD1A4:
   cpy #$0B       ;2
   bne LD1AD      ;2
   ror blackMarketState             ; rotate Black Market state right
   clc                              ; clear carry
   rol blackMarketState             ; rotate left to show Indy not carrying Shovel
LD1AD:
   lda zp_95
   jsr   LDD59    ;6
   tya            ;2
   ora #$C0       ;2
   sta zp_95
   bne LD1C1                        ; unconditional branch
   
PlayerCollisionsInSpiderRoom
   ldx #$00       ;2
   stx $B6        ;3
   lda #$80       ;2
   sta $9D        ;3
LD1C1:
   jmp   LD2B4    ;3
   
PlayerCollisionsInMesaSide
   bit $B4        ;3
   bvs LD1E8      ;2
   bpl LD1E8      ;2
   lda indyHorizPos        ;3
   cmp #$2B       ;2
   bcc LD1E2      ;2
   ldx indyVertPos                  ; get Indy's vertical position
   cpx #39
   bcc LD1E2      ;2
   cpx #43
   bcs LD1E2      ;2
   lda #$40       ;2
   ora $B4        ;3
   sta $B4        ;3
   bne LD1E8                        ; unconditional branch
   
LD1E2:
   lda #ID_INVENTORY_PARACHUTE
   sec
   jsr TakeItemFromInventory        ; carry set...take away selected item
LD1E8:
   jmp   LD2B4    ;3
   
PlayerCollisionsInMarketplace
   bit CXP1FB                       ; check Indy collision with playfield
   bpl .indyTouchingMarketplaceBaskets;branch if Indy didn't collide with playfield
   ldy indyVertPos                  ; get Indy's vertical position
   cpy #$3A       ;2
   bcc LD200      ;2
   lda #$E0       ;2
   and $91        ;3
   ora #$43       ;2
   sta $91        ;3
   jmp   LD2B4    ;3
   
LD200:
   cpy #$20       ;2
   bcc LD20B      ;2
LD204:
   lda #$00       ;2
   sta $91        ;3
   jmp   LD2B4    ;3
   
LD20B:
   cpy #$09       ;2
   bcc LD204      ;2
   lda #$E0       ;2
   and $91        ;3
   ora #$42       ;2
   sta $91        ;3
   jmp   LD2B4    ;3
   
.indyTouchingMarketplaceBaskets
   lda indyVertPos                  ; get Indy's vertical position
   cmp #$3A       ;2
   bcc .indyNotTouchingBottomBasket; branch if Indy not colliding with bottom basket
   ldx #ID_INVENTORY_KEY
   bne LD230                        ; unconditional branch
   
.indyNotTouchingBottomBasket
   lda indyHorizPos                 ; get Indy's horizontal position
   cmp #$4C       ;2
   bcs .indyTouchingRightBasket     ; branch if Indy collided with right basket
   ldx #ID_MARKETPLACE_GRENADE
   bne LD230                        ; unconditional branch
   
.indyTouchingRightBasket
   ldx #ID_INVENTORY_REVOLVER
LD230:
   lda #$40       ;2
   sta $93        ;3
   lda secondsTimer                 ; get the seconds timer value
   and #$1F
   cmp #2
   bcs .checkToAddItemToInventory
   ldx #ID_INVENTORY_HEAD_OF_RA
.checkToAddItemToInventory
   jsr DetermineIfItemAlreadyTaken
   bcs LD247                        ; branch if item already taken
   txa                              ; move potential inventory item to accumualtor
   jsr PlaceItemInInventory
LD247:
   jmp   LD2B4    ;3

PlayerCollisionsInBlackMarket
   bit CXP1FB                       ; check Indy collision with playfield
   bmi LD26E                        ; branch if Indy collided with playfield
   lda indyHorizPos                 ; get Indy's horizontal position
   cmp #$50       ;2
   bcs LD262      ;2
   dec indyHorizPos                 ; move Indy left one pixel
   rol blackMarketState             ; rotate Black Market state left
   clc                              ; clear carry
   ror blackMarketState             ; rotate right to show Indy carrying coins
LD25B:
   lda #$00       ;2
   sta $91        ;3
LD25F:
   jmp   LD2B4    ;3
   
LD262:
   ldx #ID_BLACK_MARKET_GRENADE
   lda secondsTimer
   cmp #$40       ;2
   bcs .checkToAddItemToInventory
   ldx #ID_INVENTORY_KEY
   bne .checkToAddItemToInventory   ; unconditional branch
   
LD26E:
   ldy indyVertPos                  ; get Indy's vertical position
   cpy #68
   bcc LD27E      ;2
   lda #$E0       ;2
   and $91        ;3
   ora #$0B       ;2
LD27A:
   sta $91        ;3
   bne LD25F                        ; unconditional branch
   
LD27E:
   cpy #32
   bcs LD25B      ;2
   cpy #11
   bcc LD25B      ;2
   lda #$E0       ;2
   and $91        ;3
   ora #$41       ;2
   bne LD27A                        ; unconditional branch
   
PlayerCollisionsInTempleEntrance
   inc indyHorizPos        ;5
   bne LD2B4      ;2
   
PlayerCollisionsInEntranceRoom
   lda indyVertPos                  ; get Indy's vertical position
   cmp #63
   bcc LD2AA                        ; branch if Indy above whip location
   lda #ID_INVENTORY_WHIP
   jsr PlaceItemInInventory
   bcc LD2B4                        ; branch if no room to place item
   ror entranceRoomState            ; rotate entrance room state right
   sec                              ; set carry flag
   rol entranceRoomState            ; rotate left to show Whip taken by Indy
   lda #66
   sta whipVertPos
   bne LD2B4                        ; unconditional branch
   
LD2AA:
   cmp #22
   bcc LD2B2      ;2
   cmp #31
   bcc LD2B4      ;2
LD2B2:
   dec indyHorizPos                 ; move Indy to the left one pixel
LD2B4:
   lda currentScreenId              ; get the current screen id
   asl                              ; multiply screen id by 2
   tax
   bit CXP1FB                       ; check Indy collision with playfield
   bpl LD2C5                        ; branch if Indy didn't collide with playfield
   lda PlayerPlayfieldCollisionJumpTable + 1,x
   pha
   lda PlayerPlayfieldCollisionJumpTable,x
   pha
   rts                              ; jump to Player / Playfield collision strategy

LD2C5:
   lda LDCCF+1,x    ;4
   pha            ;3
   lda LDCCF,x    ;4
   pha            ;3
   rts            ;6

LD2CE:
   lda $DF        ;3
   sta $EB        ;3
   lda indyVertPos                  ; get Indy's vertical position
   sta $EC        ;3
   lda indyHorizPos        ;3
LD2D8:
   sta $ED        ;3
PlaceIndyInMesaSide
   lda #ID_MESA_SIDE
   sta currentScreenId
   jsr SetCurrentScreenData
   lda #$05       ;2
   sta indyVertPos        ;3
   lda #$50       ;2
   sta indyHorizPos        ;3
   tsx            ;2
   cpx #$FE       ;2
   bcs LD2EF      ;2
   rts            ;6

LD2EF:
   jmp CheckIfIndyShotOrTouchedByTsetseFlies
   
LD2F2:
   bit $B3        ;3
   bmi LD2EF      ;2
   lda #$50       ;2
   sta $EB        ;3
   lda #$41       ;2
   sta $EC        ;3
   lda #$4C       ;2
   bne LD2D8                        ; unconditional branch
   
LD302:
   ldy indyHorizPos        ;3
   cpy #$2C       ;2
   bcc LD31A      ;2
   cpy #$6B       ;2
   bcs LD31C      ;2
   ldy indyVertPos                  ; get Indy's vertical position
   iny            ;2
   cpy #$1E       ;2
   bcc LD315      ;2
   dey            ;2
   dey            ;2
LD315:
   sty indyVertPos        ;3
   jmp   LD364    ;3
   
LD31A:
   iny            ;2
   iny            ;2
LD31C:
   dey            ;2
   sty indyHorizPos        ;3
   bne LD364                        ; unconditional branch
   
IndyPlayfieldCollisionInEntranceRoom
   lda #GRENADE_OPENING_IN_WALL
   and entranceRoomState
   beq .moveIndyLeftOnePixel        ; branch if wall opeing not present
   lda indyVertPos                  ; get Indy's vertical position
   cmp #18
   bcc .moveIndyLeftOnePixel        ; branch if Indy not entering opening
   cmp #36
   bcc SlowDownIndyMovement         ; branch if Indy entering opening
.moveIndyLeftOnePixel
   dec indyHorizPos                 ; move Indy left one pixel
   bne LD364                        ; unconditional branch
   
PlayerCollisionsInRoomOfShiningLight
   ldx #26
   lda indyHorizPos                 ; get Indy horizontal position
   cmp #76
   bcc .setIndyInDungeon            ; branch if Indy on left of screen
   ldx #125
.setIndyInDungeon
   stx indyHorizPos                 ; set Indy horizontal position
   ldx #64
   stx indyVertPos                  ; set Indy vertical position
   ldx #$FF
   stx topOfDungeonGraphic          ; restore dungeon graphics
   ldx #1
   stx dungeonGraphics + 1
   stx dungeonGraphics + 2
   stx dungeonGraphics + 3
   stx dungeonGraphics + 4
   stx dungeonGraphics + 5
   bne LD364                        ; unconditional branch
   
LD357:
   lda $92        ;3
   and #$0F       ;2
   tay            ;2
   lda LDFD5,y    ;4
   ldx #<indyVertPos - objectVertPositions;$01       ;2
   jsr DetermineDirectionToMoveObject
LD364:
   lda #$05       ;2
   sta $A2        ;3
   bne CheckIfIndyShotOrTouchedByTsetseFlies; unconditional branch
   
SlowDownIndyMovement
   rol zp_8A
   sec
   bcs LD372                        ; unconditional branch
   
LD36F:
   rol zp_8A
   clc            ;2
LD372:
   ror zp_8A
CheckIfIndyShotOrTouchedByTsetseFlies
   bit CXM0P                        ; check player collisions with missile0
   bpl LD396                        ; branch if didn't collide with Indy
   ldx currentScreenId              ; get the current screen id
   cpx #ID_SPIDER_ROOM
   beq LD386      ;2
   bcc LD396      ;2
   lda #$80       ;2
   sta $9D        ;3
   bne LD390                        ; unconditional branch
   
LD386:
   rol zp_8A
   sec            ;2
   ror zp_8A
   rol $B6        ;5
   sec            ;2
   ror $B6        ;5
LD390:
   lda #$7F       ;2
   sta $8E        ;3
   sta missile0VertPos
LD396:
   bit $9A        ;3
   bpl VerticalSync
   bvs LD3A8      ;2
   lda secondsTimer                 ; get seconds time value
   cmp grenadeDetinationTime        ; compare with grenade detination time
   bne VerticalSync                 ; branch if not time to detinate grenade
   lda #$A0       ;2
   sta bulletOrWhipVertPos
   sta $9D        ;3
LD3A8:
   lsr $9A        ;5
   bcc LD3D4      ;2
   lda #GRENADE_OPENING_IN_WALL
   sta grenadeOpeningPenalty        ; increment final score by 2
   ora entranceRoomState
   sta entranceRoomState
   ldx #ID_ENTRANCE_ROOM
   cpx currentScreenId
   bne LD3BD                        ; branch if not in the ENTRANCE_ROOM
   jsr SetCurrentScreenData
LD3BD:
   lda $B5        ;3
   and #$0F       ;2
   beq LD3D4      ;2
   lda $B5        ;3
   and #$F0       ;2
   ora #$01       ;2
   sta $B5        ;3
   ldx #ID_ENTRANCE_ROOM
   cpx currentScreenId
   bne LD3D4                        ; branch if not in the ENTRANCE_ROOM
   jsr SetCurrentScreenData
LD3D4:
   sec
   jsr TakeItemFromInventory        ; carry set...take away selected item
VerticalSync
.waitTime
   lda INTIM
   bne .waitTime
StartNewFrame
   lda #START_VERT_SYNC
   sta WSYNC                        ; wait for next scan line
   sta VSYNC                        ; start vertical sync (D1 = 1)
   lda #$50
   cmp bulletOrWhipVertPos
   bcs LD3EB
   sta bulletOrWhipHorizPos
LD3EB:
   inc frameCount                   ; increment frame count
   lda #$3F
   and frameCount
   bne .firstLineOfVerticalSync     ; branch if roughly 60 frames haven't passed
   inc secondsTimer                 ; increment every second
   lda $A1
   bpl .firstLineOfVerticalSync
   dec $A1
.firstLineOfVerticalSync
   sta WSYNC
   bit zp_9C
   bpl .continueVerticalSync
   ror SWCHB                        ; rotate RESET to carry
   bcs .continueVerticalSync        ; branch if RESET not pressed
   jmp Start
   
.continueVerticalSync
   sta WSYNC
   lda #STOP_VERT_SYNC
   ldx #VBLANK_TIME
   sta WSYNC                        ; last line of vertical sync
   sta VSYNC                        ; end vertical sync (D1 = 0)
   stx TIM64T                       ; set timer for vertical blanking period
   ldx $9D
   inx            ;2
   bne CheckToShowDeveloperInitials
   stx $9D        ;3
   jsr DetermineFinalScore
   lda #ID_ARK_ROOM
   sta currentScreenId
   jsr SetCurrentScreenData
LD427:
   jmp   LD80D    ;3
   
CheckToShowDeveloperInitials
   lda currentScreenId              ; get the current screen id
   cmp #ID_ARK_ROOM
   bne LD482                        ; branch if not in ID_ARK_ROOM
   lda #$9C       ;2
   sta $A3        ;3
   ldy findingYarEasterEggBonus
   beq LD44A      ;2
   bit zp_9C
   bmi LD44A      ;2
   ldx #>HSWInitials_00
   stx inventoryGraphicPointers + 1
   stx inventoryGraphicPointers + 3
   lda #<HSWInitials_00
   sta inventoryGraphicPointers
   lda #<HSWInitials_01
   sta inventoryGraphicPointers + 2
LD44A:
   ldy indyVertPos                  ; get Indy's vertical position
   cpy #$7C       ;2
   bcs LD465      ;2
   cpy adventurePoints
   bcc LD45B      ;2
   bit INPT5                        ; read action button from right controller
   bmi LD427                        ; branch if action button not pressed
   jmp Start
   
LD45B:
   lda frameCount                   ; get current frame count
   ror                              ; shift D0 to carry
   bcc LD427                        ; branch on even frame
   iny            ;2
   sty indyVertPos       ;3
   bne LD427                        ; unconditional branch
   
LD465:
   bit zp_9C
   bmi LD46D      ;2
   lda #$0E       ;2
   sta $A2        ;3
LD46D:
   lda #$80       ;2
   sta zp_9C
   bit INPT5                        ; read action button from right controller
   bmi LD427                        ; branch if action button not pressed
   lda frameCount                   ; get current frame count
   and #$0F       ;2
   bne LD47D      ;2
   lda #$05       ;2
LD47D:
   sta $8C        ;3
   jmp   LDDA6    ;3
   
LD482:
   bit $93        ;3
   bvs LD489      ;2
LD486:
   jmp   LD51C    ;3
   
LD489:
   lda frameCount                   ; get current frame count
   and #3
   bne LD501      ;2
   ldx $DC        ;3
   cpx #$60       ;2
   bcc LD4A5      ;2
   bit $9D        ;3
   bmi LD486      ;2
   ldx #$00       ;2
   lda indyHorizPos        ;3
   cmp #$20       ;2
   bcs LD4A3      ;2
   lda #$20       ;2
LD4A3:
   sta $CC        ;3
LD4A5:
   inx            ;2
   stx $DC        ;3
   txa            ;2
   sec            ;2
   sbc #$07       ;2
   bpl LD4B0      ;2
   lda #$00       ;2
LD4B0:
   sta $D2        ;3
   and #$F8       ;2
   cmp snakeVertPos        ;3
   beq LD501      ;2
   sta snakeVertPos        ;3
   lda $D4        ;3
   and #$03       ;2
   tax            ;2
   lda $D4        ;3
   lsr            ;2
   lsr            ;2
   tay            ;2
   lda LDBFF,x    ;4
   clc            ;2
   adc LDBFF,y    ;4
   clc            ;2
   adc $CC        ;3
   ldx #$00       ;2
   cmp #$87       ;2
   bcs LD4E2      ;2
   cmp #$18       ;2
   bcc LD4DE      ;2
   sbc indyHorizPos        ;3
   sbc #$03       ;2
   bpl LD4E2      ;2
LD4DE:
   inx            ;2
   inx            ;2
   eor #$FF       ;2
LD4E2:
   cmp #$09       ;2
   bcc LD4E7      ;2
   inx            ;2
LD4E7:
   txa            ;2
   asl            ;2
   asl            ;2
   sta $84        ;3
   lda $D4        ;3
   and #$03       ;2
   tax            ;2
   lda LDBFF,x    ;4
   clc            ;2
   adc $CC        ;3
   sta $CC        ;3
   lda $D4        ;3
   lsr            ;2
   lsr            ;2
   ora $84        ;3
   sta $D4        ;3
LD501:
   lda $D4        ;3
   and #$03       ;2
   tax            ;2
   lda LDBFB,x    ;4
   sta $D6        ;3
   lda #>LFA72
   sta $D7        ;3
   lda $D4        ;3
   lsr            ;2
   lsr            ;2
   tax            ;2
   lda LDBFB,x    ;4
   sec            ;2
   sbc #$08       ;2
   sta $D8        ;3
LD51C:
   bit $9D        ;3
   bpl LD523      ;2
   jmp   LD802    ;3
   
LD523:
   bit $A1        ;3
   bpl LD52A      ;2
   jmp   LD78C    ;3
   
LD52A:
   lda frameCount                   ; get current frame count
   ror                              ; shift D0 to carry
   bcc LD532                        ; branch on even frame
   jmp   LD627    ;3
   
LD532:
   ldx currentScreenId              ; get the current screen id
   cpx #ID_MESA_SIDE
   beq LD579                        ; branch if falling by mesa side
   bit $8D
   bvc LD56E
   ldx bulletOrWhipHorizPos         ; get bullet or whip horizontal position
   txa            ;2
   sec            ;2
   sbc indyHorizPos        ;3
   tay            ;2
   lda SWCHA                        ; read joystick values
   ror                              ; shift right joystick UP value to carry
   bcc LD55B                        ; branch if right joystick pushing up
   ror                              ; shift right joystick DOWN value to carry
   bcs LD579                        ; branch if right joystick not pushed down
   cpy #9
   bcc LD579
   tya
   bpl LD556
LD553:
   inx            ;2
   bne LD557      ;2
LD556:
   dex            ;2
LD557:
   stx bulletOrWhipHorizPos
   bne LD579      ;2
LD55B:
   cpx #$75       ;2
   bcs LD579      ;2
   cpx #$1A       ;2
   bcc LD579      ;2
   dey            ;2
   dey            ;2
   cpy #$07       ;2
   bcc LD579      ;2
   tya            ;2
   bpl LD553      ;2
   bmi LD556                        ; unconditional branch
   
LD56E:
   bit $B4        ;3
   bmi LD579      ;2
   bit zp_8A
   bpl LD57C      ;2
   ror            ;2
   bcc LD57C      ;2
LD579:
   jmp   LD5E0    ;3
   
LD57C:
   ldx #<indyVertPos - objectVertPositions
   lda SWCHA                        ; read joystick values
   sta $85
   and #P1_NO_MOVE
   cmp #P1_NO_MOVE
   beq LD579      ;2
   sta $92        ;3
   jsr DetermineDirectionToMoveObject
   ldx currentScreenId              ; get the current screen id
   ldy #$00       ;2
   sty $84        ;3
   beq LD599      ;2
   
LD596:
   tax            ;2
   inc $84        ;5
LD599:
   lda indyHorizPos        ;3
   pha            ;3
   lda indyVertPos                  ; get Indy's vertical position
   ldy $84        ;3
   cpy #$02       ;2
   bcs LD5AC      ;2
   sta $86        ;3
   pla            ;4
   sta $87        ;3
   jmp   LD5B1    ;3
   
LD5AC:
   sta $87        ;3
   pla            ;4
   sta $86        ;3
LD5B1:
   ror $85        ;5
   bcs LD5D1      ;2
   jsr   LD97C    ;6
   bcs LD5DB      ;2
   bvc LD5D1      ;2
   ldy $84        ;3
   lda LDF6C,y    ;4
   cpy #$02       ;2
   bcs LD5CC      ;2
   adc indyVertPos        ;3
   sta indyVertPos        ;3
   jmp   LD5D1    ;3
   
LD5CC:
   clc            ;2
   adc indyHorizPos        ;3
   sta indyHorizPos        ;3
LD5D1:
   txa            ;2
   clc            ;2
   adc #$0D       ;2
   cmp #$34       ;2
   bcc LD596      ;2
   bcs LD5E0                        ; unconditional branch
   
LD5DB:
   sty currentScreenId        ;3
   jsr SetCurrentScreenData
LD5E0:
   bit INPT4                        ; read action button from left controller
   bmi LD5F5                        ; branch if action button not pressed
   bit $9A        ;3
   bmi LD624      ;2
   lda zp_8A
   ror            ;2
   bcs LD5FA      ;2
   sec
   jsr TakeItemFromInventory        ; carry set...take away selected item
   inc zp_8A
   bne LD5FA                        ; unconditional branch
   
LD5F5:
   ror zp_8A
   clc            ;2
   rol zp_8A
LD5FA:
   lda $91        ;3
   bpl LD624      ;2
   and #$1F       ;2
   cmp #$01       ;2
   bne LD60C      ;2
   inc numberOfBullets
   inc numberOfBullets
   inc numberOfBullets
   bne LD620                        ; unconditional branch
   
LD60C:
   cmp #$0B       ;2
   bne LD61D      ;2
   ror blackMarketState             ; rotate Black Market state right
   sec                              ; set carry
   rol blackMarketState             ; rotate left to show Indy carrying Shovel
   ldx #$45       ;2
   stx shovelVertPos
   ldx #$7F       ;2
   stx missile0VertPos
LD61D:
   jsr PlaceItemInInventory
LD620:
   lda #$00       ;2
   sta $91        ;3
LD624:
   jmp   LD777    ;3
   
LD627:
   bit $9A        ;3
   bmi LD624      ;2
   bit INPT5                        ; read action button from right controller
   bpl LD638                        ; branch if action button pressed
   lda #~USING_GRENADE_OR_PARACHUTE
   and zp_8A
   sta zp_8A
   jmp   LD777    ;3
   
LD638:
   lda #USING_GRENADE_OR_PARACHUTE
   bit zp_8A
   bne LD696      ;2
   ora zp_8A
   sta zp_8A
   ldx selectedInventoryId          ; get the current selected inventory id
   cpx #ID_MARKETPLACE_GRENADE
   beq LD64C      ;2
   cpx #ID_BLACK_MARKET_GRENADE
   bne CheckToActivateParachute
LD64C:
   ldx indyVertPos                  ; get Indy's vertical position
   stx bulletOrWhipVertPos
   ldy indyHorizPos                 ; get Indy horizontal position
   sty bulletOrWhipHorizPos
   lda secondsTimer                 ; get the seconds timer
   adc #5 - 1                       ; increment value by 5...carry set
   sta grenadeDetinationTime        ; detinate grenade 5 seconds from now
   lda #$80       ;2
   cpx #ENTRANCE_ROOM_ROCK_VERT_POS
   bcs LD66C                        ; branch if Indy is under rock scanline
   cpy #$64       ;2
   bcc LD66C      ;2
   ldx currentScreenId              ; get the current screen id
   cpx #ID_ENTRANCE_ROOM
   bne LD66C                        ; branch if not in the ENTRANCE_ROOM
   ora #$01       ;2
LD66C:
   sta $9A        ;3
   jmp   LD777    ;3
   
CheckToActivateParachute
   cpx #ID_INVENTORY_PARACHUTE
   bne LD68B      ;2
   stx usingParachuteBonus
   lda $B4        ;3
   bmi LD696      ;2
   ora #$80       ;2
   sta $B4        ;3
   lda indyVertPos                  ; get Indy's vertical position
   sbc #6                           ; carry set from compare
   bpl LD687      ;2
   lda #$01       ;2
LD687:
   sta indyVertPos        ;3
   bpl LD6D2                        ; unconditional branch
   
LD68B:
   bit $8D        ;3
   bvc LD6D5      ;2
   bit CXM1FB     ;3
   bmi LD699      ;2
   jsr   LD2CE    ;6
LD696:
   jmp   LD777    ;3
   
LD699:
   lda bulletOrWhipVertPos          ; get bullet or whip vertical position
   lsr            ;2
   sec            ;2
   sbc #$06       ;2
   clc            ;2
   adc $DF        ;3
   lsr            ;2
   lsr            ;2
   lsr            ;2
   lsr            ;2
   cmp #$08       ;2
   bcc LD6AC      ;2
   lda #$07       ;2
LD6AC:
   sta $84        ;3
   lda bulletOrWhipHorizPos         ; get bullet or whip horizontal position
   sec            ;2
   sbc #$10       ;2
   and #$60       ;2
   lsr            ;2
   lsr            ;2
   adc $84        ;3
   tay            ;2
   lda LDF7C,y    ;4
   sta $8B        ;3
   ldx bulletOrWhipVertPos          ; get bullet or whip vertical position
   dex            ;2
   stx bulletOrWhipVertPos
   stx indyVertPos        ;3
   ldx bulletOrWhipHorizPos         ; get bullet or whip horizontal position
   dex            ;2
   dex            ;2
   stx bulletOrWhipHorizPos
   stx indyHorizPos        ;3
   lda #$46       ;2
   sta $8D        ;3
LD6D2:
   jmp   LD773    ;3
   
LD6D5:
   cpx #ID_INVENTORY_SHOVEL
   bne LD6F7      ;2
   lda indyVertPos                  ; get Indy's vertical position
   cmp #$41       ;2
   bcc LD696      ;2
   bit CXPPMM                       ; check player / missile collisions
   bpl LD696                        ; branch if players didn't collide
   inc $97        ;5
   bne LD696      ;2
   ldy $96        ;3
   dey            ;2
   cpy #$54       ;2
   bcs LD6EF      ;2
   iny            ;2
LD6EF:
   sty $96        ;3
   lda #BONUS_FINDING_ARK
   sta findingArkBonus
   bne LD696                        ; unconditional branch
   
LD6F7:
   cpx #ID_INVENTORY_ANKH
   bne LD71E      ;2
   ldx currentScreenId              ; get the current screen id
   cpx #ID_TREASURE_ROOM
   beq LD696                        ; branch if in Treasure Room
   lda #ID_MESA_FIELD
   sta skipToMesaFieldBonus         ; set to reduce score by 9 points
   sta currentScreenId        ;3
   jsr SetCurrentScreenData
   lda #$4C       ;2
LD70C:
   sta indyHorizPos        ;3
   sta bulletOrWhipHorizPos
   lda #$46       ;2
   sta indyVertPos        ;3
   sta bulletOrWhipVertPos
   sta $8D        ;3
   lda #$1D       ;2
   sta $DF        ;3
   bne LD777                        ; unconditional branch
   
LD71E:
   lda SWCHA                        ; read joystick values
   and #P1_NO_MOVE
   cmp #P1_NO_MOVE
   beq LD777                        ; branch if right joystick not moved
   cpx #ID_INVENTORY_REVOLVER
   bne .checkForIndyUsingWhip       ; check for Indy using whip
   bit bulletOrWhipStatus           ; check bullet or whip status
   bmi LD777                        ; branch if bullet active
   ldy numberOfBullets              ; get number of bullets remaining
   bmi LD777                        ; branch if no more bullets
   dec numberOfBullets              ; reduce number of bullets
   ora #BULLET_OR_WHIP_ACTIVE
   sta bulletOrWhipStatus           ; set BULLET_OR_WHIP_ACTIVE bit
   lda indyVertPos                  ; get Indy's vertical position
   adc #4
   sta bulletOrWhipVertPos
   lda indyHorizPos
   adc #4
   sta bulletOrWhipHorizPos
   bne LD773                        ; unconditional branch
   
.checkForIndyUsingWhip
   cpx #ID_INVENTORY_WHIP
   bne LD777                        ; branch if Indy not using whip
   ora #$80       ;2
   sta $8D        ;3
   ldy #4
   ldx #5
   ror                              ; shift MOVE_UP to carry
   bcs LD758                        ; branch if not pushed up
   ldx #<-6
LD758:
   ror                              ; shift MOVE_DOWN to carry
   bcs LD75D                        ; branch if not pushed down
   ldx #15
LD75D:
   ror                              ; shift MOVE_LEFT to carry
   bcs LD762                        ; branch if not pushed left
   ldy #<-9
LD762:
   ror                              ; shift MOVE_RIGHT to carry
   bcs LD767                        ; branch if not pushed right
   ldy #16
LD767:
   tya
   clc
   adc indyHorizPos
   sta bulletOrWhipHorizPos
   txa            ;2
   clc            ;2
   adc indyVertPos        ;3
   sta bulletOrWhipVertPos
LD773:
   lda #$0F       ;2
   sta $A3        ;3
LD777:
   bit $B4        ;3
   bpl LD783      ;2
   lda #<ParachutingIndySprite
   sta indyGraphicPointers
   lda #H_PARACHUTE_INDY_SPRITE
   bne .setIndySpriteHeight         ; unconditional branch
   
LD783:
   lda SWCHA                        ; read joystick values
   and #P1_NO_MOVE
   cmp #P1_NO_MOVE
   bne LD796      ;2
LD78C:
   lda #<IndyStationarySprite
.setIndySpriteLSBValue
   sta indyGraphicPointers
   lda #H_INDY_SPRITE
.setIndySpriteHeight
   sta indySpriteHeight
   bne LD7B2                        ; unconditional branch
   
LD796:
   lda #$03       ;2
   bit zp_8A
   bmi LD79D      ;2
   lsr            ;2
LD79D:
   and frameCount
   bne LD7B2
   lda #H_INDY_SPRITE
   clc            ;2
   adc indyGraphicPointers
   cmp #<IndyStationarySprite
   bcc .setIndySpriteLSBValue
   lda #$02       ;2
   sta $A3        ;3
   lda #<Indy_0
   bcs .setIndySpriteLSBValue       ; unconditional branch
   
LD7B2:
   ldx currentScreenId              ; get the current screen id
   cpx #ID_MESA_FIELD
   beq LD7BC
   cpx #ID_VALLEY_OF_POISON
   bne LD802      ;2
LD7BC:
   lda frameCount                   ; get current frame count
   bit zp_8A
   bpl LD7C3      ;2
   lsr            ;2
LD7C3:
   ldy indyVertPos                  ; get Indy's vertical position
   cpy #$27       ;2
   beq LD802      ;2
   ldx $DF        ;3
   bcs LD7E8      ;2
   beq LD802      ;2
   inc indyVertPos        ;5
   inc bulletOrWhipVertPos
   and #$02       ;2
   bne LD802      ;2
   dec $DF        ;5
   inc $CE        ;5
   inc missile0VertPos
   inc $D2        ;5
   inc $CE        ;5
   inc missile0VertPos
   inc $D2        ;5
   jmp   LD802    ;3
   
LD7E8:
   cpx #$50       ;2
   bcs LD802      ;2
   dec indyVertPos        ;5
   dec bulletOrWhipVertPos
   and #$02       ;2
   bne LD802      ;2
   inc $DF        ;5
   dec $CE        ;5
   dec missile0VertPos
   dec $D2        ;5
   dec $CE        ;5
   dec missile0VertPos
   dec $D2        ;5
LD802:
   lda #<LF528
   sta bankSwitchJMPAddress
   lda #>LF528
   sta bankSwitchJMPAddress + 1
   jmp JumpToBank1
   
LD80D:
   lda $99        ;3
   beq LD816      ;2
   jsr   LDD59    ;6
   lda #$00       ;2
LD816:
   sta $99        ;3
   ldx currentScreenId              ; get the current screen id
   lda HMOVETable,x
   sta NUSIZ0
   lda playfieldControl
   sta CTRLPF
   lda BackgroundColorTable,x
   sta COLUBK                       ; set current screen background color
   lda PlayfieldColorTable,x
   sta COLUPF                       ; set current screen playfield color
   lda LDBC3,x
   sta COLUP0
   lda IndyColorValues,x
   sta COLUP1
   cpx #ID_THIEVES_DEN
   bcc .horizPositionObjects
   lda #$20
   sta $D4
   ldx #4
LD841:
   ldy thievesHMOVEIndex,x
   lda HMOVETable,y
   sta thievesHorizPositions,x
   dex
   bpl LD841
.horizPositionObjects
   jmp HorizPositionObjects
   
.setArkRoomScreenData
   lda #$4D       ;2
   sta indyHorizPos        ;3
   lda #$48       ;2
   sta $C8        ;3
   lda #$1F       ;2
   sta indyVertPos        ;3
   rts            ;6

LD85B:
   ldx #$00       ;2
   txa            ;2
LD85E:
   sta $DF,x      ;4
   sta $E0,x      ;4
   sta $E1,x      ;4
   sta $E2,x      ;4
   sta $E3,x      ;4
   sta $E4,x      ;4
   txa            ;2
   bne LD873      ;2
   ldx #$06       ;2
   lda #$14       ;2
   bne LD85E                        ; unconditional branch
   
LD873:
   lda #$FC       ;2
   sta $D7        ;3
   rts            ;6

SetCurrentScreenData
   lda $9A        ;3
   bpl LD880      ;2
   ora #$40       ;2
   sta $9A        ;3
LD880:
   lda #$5C       ;2
   sta $96        ;3
   ldx #$00       ;2
   stx $93        ;3
   stx $B6        ;3
   stx $8E        ;3
   stx $90        ;3
   lda zp_95
   stx zp_95
   jsr   LDD59    ;6
   rol zp_8A
   clc            ;2
   ror zp_8A
   ldx currentScreenId              ; get the current screen id
   lda PlayfieldControlTable,x
   sta playfieldControl
   cpx #ID_ARK_ROOM
   beq .setArkRoomScreenData
   cpx #ID_MESA_SIDE
   beq LD8B1
   cpx #ID_WELL_OF_SOULS
   beq LD8B1
   lda #$00
   sta $8B
LD8B1:
   lda RoomPlayer0LSBGraphicData,x    ;4
   sta player0GraphicPointers
   lda RoomPlayer0MSBGraphicData,x    ;4
   sta player0GraphicPointers + 1
   lda RoomPlayer0Height,x    ;4
   sta player0SpriteHeight
   lda LDBD4,x    ;4
   sta $C8        ;3
   lda LDC0E,x    ;4
   sta $CA        ;3
   lda LDC1B,x    ;4
   sta missile0VertPos
   cpx #ID_THIEVES_DEN
   bcs LD85B      ;2
   adc LDC03,x    ;4
   sta $E0        ;3
   lda LDC28,x    ;4
   sta pf1GraphicPointers
   lda LDC33,x    ;4
   sta pf1GraphicPointers + 1
   lda LDC3E,x    ;4
   sta pf2GraphicPointers
   lda LDC49,x    ;4
   sta pf2GraphicPointers + 1
   lda #$55       ;2
   sta $D2        ;3
   sta bulletOrWhipVertPos
   cpx #ID_TEMPLE_ENTRANCE
   bcs LD93E      ;2
   lda #$00       ;2
   cpx #ID_TREASURE_ROOM
   beq .setTreasureRoomObjectVertPos
   cpx #ID_ENTRANCE_ROOM
   beq .setEntranceRoomTopObjectVertPos
   sta $CE        ;3
LD902:
   ldy #$4F       ;2
   cpx #ID_ENTRANCE_ROOM
   bcc LD918      ;2
   lda $AF,x      ;4
   ror            ;2
   bcc LD918      ;2
   ldy LDF72,x    ;4
   cpx #ID_BLACK_MARKET
   bne LD918      ;2
   lda #$FF       ;2
   sta missile0VertPos
LD918:
   sty $DF        ;3
   rts            ;6

.setTreasureRoomObjectVertPos
   lda $AF        ;3
   and #$78       ;2
   sta $AF        ;3
   lda #$1A       ;2
   sta topObjectVertPos
   lda #$26       ;2
   sta bottomObjectVertPos
   rts            ;6

.setEntranceRoomTopObjectVertPos
   lda entranceRoomState
   and #7
   lsr                              ; shift value right
   bne LD935                        ; branch if wall opening present in Entrance Room
   ldy #$FF       ;2
   sty missile0VertPos
LD935:
   tay
   lda EntranceRoomTopObjectVertPos,y
   sta topObjectVertPos
   jmp LD902
   
LD93E:
   cpx #ID_ROOM_OF_SHINING_LIGHT
   beq LD950      ;2
   cpx #ID_TEMPLE_ENTRANCE
   bne LD968      ;2
   ldy #$00       ;2
   sty $D8        ;3
   ldy #$40       ;2
   sty topOfDungeonGraphic
   bne LD958      ;2
   
LD950:
   ldy #$FF       ;2
   sty topOfDungeonGraphic
   iny                              ; y = 0
   sty $D8        ;3
   iny                              ; y = 1
LD958:
   sty dungeonGraphics + 1
   sty dungeonGraphics + 2
   sty dungeonGraphics + 3
   sty dungeonGraphics + 4
   sty dungeonGraphics + 5
   ldy #$39       ;2
   sty $D4        ;3
   sty snakeVertPos        ;3
LD968:
   cpx #ID_MESA_FIELD
   bne LD977      ;2
   ldy indyVertPos                  ; get Indy's vertical position
   cpy #$49       ;2
   bcc LD977      ;2
   lda #$50       ;2
   sta $DF        ;3
   rts            ;6

LD977:
   lda #$00       ;2
   sta $DF        ;3
   rts            ;6

LD97C:
   ldy LDE00,x    ;4
   cpy $86        ;3
   beq LD986      ;2
   clc            ;2
   clv            ;2
   rts            ;6

LD986:
   ldy LDE34,x    ;4
   bmi LD99B      ;2
LD98B:
   lda LDF04,x    ;4
   beq LD992      ;2
LD990:
   sta indyVertPos        ;3
LD992:
   lda LDF38,x    ;4
   beq LD999      ;2
   sta indyHorizPos        ;3
LD999:
   sec            ;2
   rts            ;6

LD99B:
   iny            ;2
   beq LD9F9      ;2
   iny            ;2
   bne LD9B6      ;2
   ldy LDE68,x    ;4
   cpy $87        ;3
   bcc LD9AF      ;2
   ldy LDE9C,x    ;4
   bmi LD9C7      ;2
   bpl LD98B                        ; unconditional branch
   
LD9AF:
   ldy LDED0,x    ;4
   bmi LD9C7      ;2
   bpl LD98B                        ; unconditional branch
   
LD9B6:
   lda $87        ;3
   cmp LDE68,x    ;4
   bcc LD9F9      ;2
   cmp LDE9C,x    ;4
   bcs LD9F9      ;2
   ldy LDED0,x    ;4
   bpl LD98B      ;2
LD9C7:
   iny            ;2
   bmi LD9D4      ;2
   ldy #$08       ;2
   bit $AF        ;3
   bpl LD98B      ;2
   lda #$41       ;2
   bne LD990                        ; unconditional branch
   
LD9D4:
   iny            ;2
   bne LD9E1      ;2
   lda $B5        ;3
   and #$0F       ;2
   bne LD9F9      ;2
   ldy #$06       ;2
   bne LD98B                        ; unconditional branch
   
LD9E1:
   iny            ;2
   bne LD9F0      ;2
   lda $B5        ;3
   and #$0F       ;2
   cmp #$0A       ;2
   bcs LD9F9      ;2
   ldy #$06       ;2
   bne LD98B                        ; unconditional branch
   
LD9F0:
   iny            ;2
   bne LD9FE      ;2
   ldy #$01       ;2
   bit zp_8A
   bmi LD98B      ;2
LD9F9:
   clc            ;2
   bit   LD9FD    ;4
LD9FD:
   rts            ;6

LD9FE:
   iny            ;2
   bne LD9F9      ;2
   ldy #$06       ;2
   lda #ID_INVENTORY_HEAD_OF_RA
   cmp selectedInventoryId          ; compare with current selected inventory id
   bne LD9F9                        ; branch if not holding Head of Ra
   bit INPT5                        ; read action button from right controller
   bmi LD9F9                        ; branch if action button not pressed
   jmp LD98B
   
TakeItemFromInventory SUBROUTINE
   ldy numberOfInventoryItems       ; get number of inventory items
   bne .takeItemFromInventory       ; branch if Indy carrying items
   clc
   rts

.takeItemFromInventory
   bcs .takeSelectedItemFromInventory
   tay                              ; move item id to be removed to y
   asl                              ; multiply value by 8 to get graphic LSB
   asl
   asl
   ldx #10
.takeItemFromInventoryLoop
   cmp inventoryGraphicPointers,x
   bne .checkNextItem
   cpx selectedInventoryIndex
   beq .checkNextItem
   dec numberOfInventoryItems       ; reduce number of inventory items
   lda #<EmptySprite
   sta inventoryGraphicPointers,x   ; place empty sprite in inventory
   cpy #$05       ;2
   bcc LDA37      ;2
   tya                              ; move item id to accumulator
   tax                              ; move item id to x
   jsr ShowItemAsNotTaken
   txa            ;2
   tay            ;2
LDA37:
   jmp   LDAF7    ;3
   
.checkNextItem
   dex
   dex
   bpl .takeItemFromInventoryLoop
   clc
   rts

.takeSelectedItemFromInventory
   lda #ID_INVENTORY_EMPTY
   ldx selectedInventoryIndex
   sta inventoryGraphicPointers,x   ; remove selected item from inventory
   ldx selectedInventoryId          ; get current selected inventory id
   cpx #ID_INVENTORY_KEY
   bcc LDA4F      ;2
   jsr ShowItemAsNotTaken
LDA4F:
   txa                              ; move inventory id to accumulator
   tay                              ; move inventory id to y
   asl                              ; multiple inventory id by 2
   tax
   lda RemoveItemFromInventoryJumpTable - 1,x
   pha                              ; push MSB to stack
   lda RemoveItemFromInventoryJumpTable - 2,x
   pha                              ; push LSB to stack
   ldx currentScreenId              ; get the current screen id
   rts                              ; jump to Remove Item strategy

RemoveParachuteFromInventory
   lda #$3F       ;2
   and $B4        ;3
   sta $B4        ;3
LDA64:
   jmp RemoveItemFromInventory
   
RemoveAnkhOrHourGlassFromInventory
   stx $8D        ;3
   lda #$70       ;2
   sta bulletOrWhipVertPos
   bne LDA64                        ; unconditional branch
   
RemoveChaiFromInventory
   lda #$42       ;2
   cmp $91        ;3
   bne LDA86      ;2
   lda #ID_BLACK_MARKET
   sta currentScreenId        ;3
   jsr SetCurrentScreenData
   lda #$15       ;2
   sta indyHorizPos        ;3
   lda #$1C       ;2
   sta indyVertPos        ;3
   bne RemoveItemFromInventory      ; unconditional branch
   
LDA86:
   cpx #ID_MARKETPLACE_GRENADE
   bne RemoveItemFromInventory
   lda #BONUS_FINDING_YAR
   cmp $8B        ;3
   bne RemoveItemFromInventory
   sta findingYarEasterEggBonus
   lda #$00       ;2
   sta $CE        ;3
   lda #$02       ;2
   ora $B4        ;3
   sta $B4        ;3
   bne RemoveItemFromInventory      ; unconditional branch
   
RemoveWhipFromInventory
   ror entranceRoomState            ; rotate entrance room state right
   clc                              ; clear carry
   rol entranceRoomState            ; rotate left to show Whip not taken by Indy
   cpx #ID_ENTRANCE_ROOM
   bne .removeWhipFromInventory
   lda #78
   sta whipVertPos
.removeWhipFromInventory
   bne RemoveItemFromInventory      ; unconditional branch
   
RemoveShovelFromInventory
   ror blackMarketState             ; rotate Black Market state right
   clc                              ; clear carry
   rol blackMarketState             ; rotate left to show Indy not carrying Shovel
   cpx #ID_BLACK_MARKET
   bne .removeShovelFromInventory
   lda #$4F       ;2
   sta shovelVertPos
   lda #$4B       ;2
   sta missile0VertPos
.removeShovelFromInventory
   bne RemoveItemFromInventory      ; unconditional branch
   
RemoveCoinsFromInventory
   ldx currentScreenId              ; get the current screen id
   cpx #ID_BLACK_MARKET
   bne LDAD1                        ; branch if not in Black Market
   lda indyHorizPos                 ; get Indy's horizontal position
   cmp #$3C       ;2
   bcs LDAD1
   rol blackMarketState             ; rotate Black Market state left
   sec                              ; set carry
   ror blackMarketState             ; rotate right to show Indy not carry coins
LDAD1:
   lda $91        ;3
   clc            ;2
   adc #$40       ;2
   sta $91        ;3
RemoveItemFromInventory
   dec numberOfInventoryItems       ; reduce number of inventory items
   bne .selectNextAvailableInventoryItem; branch if Indy has remaining items
   lda #ID_INVENTORY_EMPTY
   sta selectedInventoryId          ; clear the current selected invendory id
   beq LDAF7                        ; unconditional branch
   
.selectNextAvailableInventoryItem
   ldx selectedInventoryIndex       ; get selected inventory index
.nextInventoryIndex
   inx                              ; increment by 2 to compensate for word pointer
   inx
   cpx #11
   bcc LDAEC
   ldx #0                           ; wrap around to the beginning
LDAEC:
   lda inventoryGraphicPointers,x   ; get inventory graphic LSB value
   beq .nextInventoryIndex          ; branch if nothing in the inventory location
   stx selectedInventoryIndex       ; set inventory index
   lsr                              ; divide valye by 8 to set the inventory id
   lsr
   lsr
   sta selectedInventoryId          ; set inventory id
LDAF7:
   lda #$0D       ;2
   sta $A2        ;3
   sec            ;2
   rts            ;6

   BOUNDARY 0
   
HMOVETable
   .byte MSBL_SIZE1 | ONE_COPY      ; Treasure Room
   .byte MSBL_SIZE1 | ONE_COPY      ; Marketplace
   .byte MSBL_SIZE8 | DOUBLE_SIZE   ; Entrance Room
   .byte MSBL_SIZE2 | ONE_COPY      ; Black Market
   .byte MSBL_SIZE2 | QUAD_SIZE     ; Map Room
   .byte MSBL_SIZE8 | ONE_COPY      ; Mesa Side
   .byte MSBL_SIZE1 | ONE_COPY      ; Temple Entrance
   .byte MSBL_SIZE1 | ONE_COPY      ; Spider Room
   .byte MSBL_SIZE1 | ONE_COPY      ; Room of Shining Light
   .byte MSBL_SIZE1 | ONE_COPY      ; Mesa Field
   .byte MSBL_SIZE1 | ONE_COPY      ; Valley of Poison
   .byte MSBL_SIZE1 | ONE_COPY      ; Thieves Den
   .byte MSBL_SIZE1 | ONE_COPY      ; Well of Souls
   .byte MSBL_SIZE1 | DOUBLE_SIZE   ; Ark Room

COARSE_MOTION SET 0

   .byte HMOVE_0  | COARSE_MOTION, HMOVE_0  | COARSE_MOTION, HMOVE_R1 | COARSE_MOTION
   .byte HMOVE_R2 | COARSE_MOTION, HMOVE_R3 | COARSE_MOTION, HMOVE_R4 | COARSE_MOTION
   .byte HMOVE_R5 | COARSE_MOTION, HMOVE_R6 | COARSE_MOTION, HMOVE_R7 | COARSE_MOTION

   REPEAT 8

COARSE_MOTION SET COARSE_MOTION + 1

   .byte HMOVE_L7 | COARSE_MOTION, HMOVE_L6 | COARSE_MOTION, HMOVE_L5 | COARSE_MOTION
   .byte HMOVE_L4 | COARSE_MOTION, HMOVE_L3 | COARSE_MOTION, HMOVE_L2 | COARSE_MOTION
   .byte HMOVE_L1 | COARSE_MOTION, HMOVE_0  | COARSE_MOTION, HMOVE_R1 | COARSE_MOTION
   .byte HMOVE_R2 | COARSE_MOTION, HMOVE_R3 | COARSE_MOTION, HMOVE_R4 | COARSE_MOTION
   .byte HMOVE_R5 | COARSE_MOTION, HMOVE_R6 | COARSE_MOTION, HMOVE_R7 | COARSE_MOTION   

   REPEND   
   
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
   .byte BLACK                      ; Treasure Room
   .byte LT_RED + 4                 ; Marketplace
   .byte LT_BLUE + 6                ; Entrance Room
   .byte LT_RED + 2                 ; Black Market
   .byte DK_BLUE + 2                ; Map Room
   .byte BROWN + 12                 ; Mesa Side
   .byte BLACK                      ; Temple Entrance
   .byte BLACK                      ; Spider Room
   .byte BLACK                      ; Room of the Shining Light
   .byte DK_BLUE + 2                ; Mesa Field
   .byte YELLOW + 2                 ; Valley of Poison
   .byte BLACK                      ; Thieves Den
   .byte BROWN + 8                  ; Well of Souls
   .byte BLACK                      ; Ark Room

PlayfieldColorTable
   .byte BLACK + 8                  ; Treasure Room
   .byte LT_RED + 2                 ; Marketplace
   .byte BLACK + 8                  ; Entrance Room
   .byte BLACK                      ; Black Market
   .byte YELLOW + 10                ; Map Room
   .byte LT_RED + 8                 ; Mesa Side
   .byte GREEN + 8                  ; Temple Entrance
   .byte LT_BROWN + 8               ; Spider Room
   .byte BLUE + 10                  ; Room of the Shining Light
   .byte YELLOW + 10                ; Mesa Field
   .byte GREEN + 6                  ; Valley of Poison
   .byte BLACK                      ; Thieves Den
   .byte LT_RED + 8                 ; Well of Souls
   .byte DK_BLUE + 8                ; Ark Room
   
IndyColorValues
   .byte GREEN + 12                 ; Treasure Room
   .byte LT_BROWN + 10              ; Marketplace Room
   .byte DK_PINK + 10               ; Entrance Room
   .byte LT_RED + 6                 ; Black Market
   .byte LT_BLUE + 14               ; Map Room
   .byte $A6                        ; Mesa Side
   .byte DK_BLUE + 12               ; Temple Entrance
   
LDBC3:
   .byte $88,$28,$F8,$4A,$26,$A8
   
RoomPlayer0Height
   .byte $CC,$CE,$4A,$98,$00,$00,$00,$08,$07,$01,$10
   
LDBD4:
   .byte $78,$4C,$5D,$4C,$4F,$4C,$12,$4C,$4C,$4C,$4C,$12,$12
   
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
   
LDBFB:
   .byte <LFA72,<LFA7A,<LFA8A,<LFA82
   
LDBFF:
   .byte $FE,$FA,$02,$06
   
LDC03:
   .byte $00,$00,$18,$04,$03,$03,$85,$85,$3B,$85,$85
   
LDC0E:
   .byte $20,$78,$85,$4D,$62,$17,$50,$50,$50,$50,$50,$12,$12
   
LDC1B:
   .byte $FF,$FF,$14,$4B,$4A,$44,$FF,$27,$FF,$FF,$FF,$F0,$F0
   
LDC28:
   .byte <COLUP0,<COLUP0,<COLUP0,<COLUP0,<COLUP0,<COLUP0,<LFD48,<LFD68,<LFD89,<LFE00,<LFE00
   
LDC33:
   .byte >COLUP0,>COLUP0,>COLUP0,>COLUP0,>COLUP0,>COLUP0,>LFD48,>LFD68,>LFD89,>LFE00,>LFE00
   
LDC3E:
   .byte <HMP0,<HMP0,<HMP0,<HMP0,<HMP0,<HMP0,<LFD20,<LFDB7,<LFD9B,<LFE78,<LFE78
   
LDC49:
   .byte >HMP0,>HMP0,>HMP0,>HMP0,>HMP0,>HMP0,>LFD20,>LFDB7,>LFD9B,>LFE78,>LFE78
   
ItemStatusBitValues
   .byte BASKET_STATUS_MARKET_GRENADE | PICKUP_ITEM_STATUS_WHIP
   .byte BASKET_STATUS_BLACK_MARKET_GRENADE | PICKUP_ITEM_STATUS_SHOVEL
   .byte PICKUP_ITEM_STATUS_HEAD_OF_RA
   .byte BACKET_STATUS_REVOLVER | PICKUP_ITEM_STATUS_TIME_PIECE
   .byte BASKET_STATUS_COINS
   .byte BASKET_STATUS_KEY | PICKUP_ITEM_STATUS_HOUR_GLASS
   .byte PICKUP_ITEM_STATUS_ANKH
   .byte PICKUP_ITEM_STATUS_CHAI
   
LDC5C:
   .byte ~(BASKET_STATUS_MARKET_GRENADE | PICKUP_ITEM_STATUS_WHIP);$FE
   .byte ~(BASKET_STATUS_BLACK_MARKET_GRENADE | PICKUP_ITEM_STATUS_SHOVEL);$FD
   .byte ~PICKUP_ITEM_STATUS_HEAD_OF_RA;$FB
   .byte ~(BACKET_STATUS_REVOLVER | PICKUP_ITEM_STATUS_TIME_PIECE);$F7
   .byte ~BASKET_STATUS_COINS;$EF
   .byte ~(BASKET_STATUS_KEY | PICKUP_ITEM_STATUS_HOUR_GLASS);$DF
   .byte ~PICKUP_ITEM_STATUS_ANKH;$BF
   .byte ~PICKUP_ITEM_STATUS_CHAI;$7F
   
ItemIndexTable
   .byte $00                        ; empty
   .byte $00
   .byte $00                        ; flute
   .byte $00                        ; parachute
   .byte $08                        ; coins
   .byte $00                        ; grenade 0
   .byte $02                        ; grenade 1
   .byte $0A                        ; key
   .byte $0C
   .byte $0E
   .byte $01                        ; whip........C
   .byte $03                        ; shovel......C
   .byte $04
   .byte $06                        ; revolver
   .byte $05                        ; Ra..........C
   .byte $07                        ; Time piece..C
   .byte $0D                        ; Ankh........C
   .byte $0F                        ; Chai........C
   .byte $0B                        ; hour glass..C
   
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
   .word LD2B4 - 1
   .word PlayerCollisionsInMarketplace - 1
   .word PlayerCollisionsInEntranceRoom - 1
   .word PlayerCollisionsInBlackMarket - 1
   .word LD2B4 - 1
   .word PlayerCollisionsInMesaSide - 1
   .word PlayerCollisionsInTempleEntrance - 1
   .word PlayerCollisionsInSpiderRoom - 1
   .word PlayerCollisionsInRoomOfShiningLight - 1
   .word LD2B4 - 1
   .word PlayerCollisionsInValleyOfPoison - 1
   .word PlayerCollisionsInThievesDen - 1
   .word PlayerCollisionsInWellOfSouls - 1
   
ID_TREASURE_ROOM        = 0 ;--
ID_MARKETPLACE          = 1 ; |
ID_ENTRANCE_ROOM        = 2 ; |
ID_BLACK_MARKET         = 3 ; | -- JumpIntoStationaryPlayerKernel
ID_MAP_ROOM             = 4 ; |
ID_MESA_SIDE            = 5 ;--

ID_TEMPLE_ENTRANCE      = 6 ;--
ID_SPIDER_ROOM          = 7 ; |
ID_ROOM_OF_SHINING_LIGHT = 8; | -- DrawPlayfieldKernel
ID_MESA_FIELD           = 9 ; |
ID_VALLEY_OF_POISON     = 10;--

ID_THIEVES_DEN          = 11;-- LF140
ID_WELL_OF_SOULS        = 12;-- LF140

ID_ARK_ROOM             = 13
   
PlayerPlayfieldCollisionJumpTable
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Treasure Room
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Marketplace
   .word IndyPlayfieldCollisionInEntranceRoom - 1  ; Entrance Room
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Black Market
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Map Room
   .word LD357 - 1                                 ; Mesa Side
   .word LD302 - 1                                 ; Temple Entrance
   .word LD357 - 1                                 ; Spider Room
   .word PlayerCollisionsInRoomOfShiningLight - 1  ; Room of Shining Light
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Mesa Field
   .word SlowDownIndyMovement - 1                  ; Valley of Poison
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Thieves Den
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1 ; Well of Souls

LDCCF:
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   .word LD36F - 1
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   .word LD2F2 - 1
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   .word LD2CE - 1
   .word LD36F - 1
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   .word CheckIfIndyShotOrTouchedByTsetseFlies - 1
   
PlaceItemInInventory
   ldx numberOfInventoryItems       ; get number of inventory items
   cpx #MAX_INVENTORY_ITEMS         ; see if Indy carrying maximum number of items
   bcc .spaceAvailableForItem       ; branch if Indy has room to carry more items
   clc
   rts

.spaceAvailableForItem
   ldx #10
.searchForEmptySpaceLoop
   ldy inventoryGraphicPointers,x   ; get the LSB for the inventory graphic
   beq .placeItemInInventory        ; branch if nothing is in the inventory slot
   dex
   dex
   bpl .searchForEmptySpaceLoop
   brk                              ; break if no more items can be carried
.placeItemInInventory
   tay                              ; move item number to y
   asl                              ; mutliply item number by 8 for graphic LSB
   asl
   asl
   sta inventoryGraphicPointers,x   ; place graphic LSB in inventory
   lda numberOfInventoryItems       ; get number of inventory items
   bne LDD0A                        ; branch if Indy carrying items
   stx selectedInventoryIndex       ; set index to newly picked up item
   sty selectedInventoryId          ; set the current selected inventory id
LDD0A:
   inc numberOfInventoryItems       ; increment number of inventory items
   cpy #ID_INVENTORY_COINS
   bcc LDD15      ;2
   tya                              ; move item number to accumulator
   tax                              ; move item number to x
   jsr ShowItemAsTaken
LDD15:
   lda #$0C
   sta $A2
   sec
   rts

ShowItemAsNotTaken
   lda ItemIndexTable,x             ; get the item index value
   lsr                              ; shift D0 to carry
   tay
   lda LDC5C,y
   bcs .showPickUpItemAsNotTaken    ; branch if item not a basket item
   and basketItemsStatus
   sta basketItemsStatus            ; clear status bit showing item not taken
   rts

.showPickUpItemAsNotTaken
   and pickupItemsStatus
   sta pickupItemsStatus            ; clear status bit showing item not taken
   rts

ShowItemAsTaken
   lda ItemIndexTable,x             ; get the item index value
   lsr                              ; shift D0 to carry
   tax
   lda ItemStatusBitValues,x        ; get item bit value
   bcs .pickUpItemTaken             ; branch if item not a basket item
   ora basketItemsStatus
   sta basketItemsStatus            ; show item taken
   rts

.pickUpItemTaken
   ora pickupItemsStatus
   sta pickupItemsStatus            ; show item taken
   rts

DetermineIfItemAlreadyTaken
   lda ItemIndexTable,x             ; get the item index value
   lsr                              ; shift D0 to carry
   tay
   lda ItemStatusBitValues,y        ; get item bit value
   bcs .determineIfPickupItemTaken  ; branch if item not a basket item
   and basketItemsStatus
   beq .doneDetermineIfItemAlreadyTaken; branch if item not taken from basket
   sec                              ; set carry for item taken already
.doneDetermineIfItemAlreadyTaken
   rts

.determineIfPickupItemTaken
   and pickupItemsStatus
   bne .doneDetermineIfItemAlreadyTaken
   clc                              ; clear carry for item not taken already
   rts

LDD59:
   and #$1F       ;2
   tax            ;2
   lda $98        ;3
   cpx #$0C       ;2
   bcs LDD67      ;2
   adc LDFE5,x    ;4
   sta $98        ;3
LDD67:
   rts            ;6
   
Start
;
; Set up everything so the power up state is known.
;
   sei                              ; disable interrupts
   cld                              ; clear decimal mode
   ldx #$FF
   txs                              ; set stack to the beginning
   inx                              ; x = 0
   txa
.clearLoop
   sta VSYNC,x
   dex
   bne .clearLoop
   dex                              ; x = -1
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
   jsr SetCurrentScreenData
   jmp StartNewFrame
   
LDDA6:
   lda #<InventoryCoinsSprite
   sta inventoryGraphicPointers     ; place coins in Indy's inventory
   lsr                              ; divide value by 8 to get the inventory id
   lsr
   lsr
   sta selectedInventoryId          ; set the current selected inventory id
   inc numberOfInventoryItems       ; increment number of inventory items
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
   lda #$4C       ;2
   sta indyHorizPos        ;3
   lda #$0F       ;2
   sta indyVertPos        ;3
   lda #ID_ENTRANCE_ROOM
   sta currentScreenId
   sta lives
   jsr SetCurrentScreenData
   jmp   LD80D    ;3
   
;------------------------------------------------------------DetermineFinalScore
;
; The player's progress is determined by Indy's height on the pedestal when the
; game is complete. The player wants to achieve the lowest adventure points
; possible to lower Indy's position on the pedestal.
;
DetermineFinalScore
   lda adventurePoints              ; get current adventure points
   sec
   sbc findingArkBonus              ; reduce for finding the Ark of the Covenant
   sbc usingParachuteBonus          ; reduce for using the parachute
   sbc skipToMesaFieldBonus         ; reduce if player skipped the Mesa field
   sbc findingYarEasterEggBonus     ; reduce if player found Yar
   sbc lives                        ; reduce by remaining lives
   sbc usingHeadOfRaInMapRoomBonus  ; reduce if player used the Head of Ra
   sbc landingInMesaBonus           ; reduce if player landed in Mesa
   sbc $AE        ;3
   clc
   adc grenadeOpeningPenalty        ; add 2 if Entrance Room opening activated
   adc escapedShiningLightPenalty   ; add 13 if escaped from Shining Light prison
   adc shootingThiefPenalty         ; add 4 if shot a thief
   sta adventurePoints
   rts

LDDF8:
   .byte $00,$00,$00,$00,$00,$00,$00,$00
LDE00:
   .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$FF,$FF,$FF,$FF,$FF,$4F,$4F,$4F
   .byte $4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F,$44,$44,$0F,$0F,$1C,$0F,$0F,$18
   .byte $0F,$0F,$0F,$0F,$0F,$12,$12,$89,$89,$8C,$89,$89,$86,$89,$89,$89
   .byte $89,$89,$86,$86
LDE34:
   .byte $FF,$FD,$FF,$FF,$FD,$FF,$FF,$FF,$FD,$01,$FD,$04,$FD,$FF,$FD,$01
   .byte $FF,$0B,$0A,$FF,$FF,$FF,$04,$FF,$FD,$FF,$FD,$FF,$FF,$FF,$FF,$FF
   .byte $FE,$FD,$FD,$FF,$FF,$FF,$FF,$FF,$FD,$FD,$FE,$FF,$FF,$FE,$FD,$FD
   .byte $FF,$FF,$FF,$FF
LDE68:
   .byte $00,$1E,$00,$00,$11,$00,$00,$00,$11,$00,$10,$00,$60,$00,$11,$00
   .byte $00,$00,$00,$00,$00,$00,$00,$00,$70,$00,$12,$00,$00,$00,$00,$00
   .byte $30,$15,$24,$00,$00,$00,$00,$00,$18,$03,$27,$00,$00,$30,$20,$12
   .byte $00,$00,$00,$00
LDE9C:
   .byte $00,$7A,$00,$00,$88,$00,$00,$00,$88,$00,$80,$00,$65,$00,$88,$00
   .byte $00,$00,$00,$00,$00,$00,$00,$00,$72,$00,$16,$00,$00,$00,$00,$00
   .byte $02,$1F,$2F,$00,$00,$00,$00,$00,$1C,$40,$01,$00,$00,$07,$27,$16
   .byte $00,$00,$00,$00
LDED0:
   .byte $00,$02,$00,$00,$09,$00,$00,$00,$07,$00,$FC,$00,$05,$00,$09,$00
   .byte $00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$FF,$00,$00,$00,$00,$00
   .byte $01,$06,$FE,$00,$00,$00,$00,$00,$FB,$FD,$0B,$00,$00,$08,$08,$00
   .byte $00,$00,$00,$00
LDF04:
   .byte $00,$4E,$00,$00,$4E,$00,$00,$00,$4D,$4E,$4E,$4E,$04,$01,$03,$01
   .byte $01,$01,$01,$01,$01,$01,$01,$01,$40,$00,$23,$00,$00,$00,$00,$00
   .byte $00,$00,$41,$00,$00,$00,$00,$00,$45,$00,$42,$00,$00,$00,$42,$23
   .byte $28,$00,$00,$00
LDF38:
   .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$4C,$00,$00,$00
   .byte $00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$86,$00,$00,$00,$00,$00
   .byte $80,$86,$80,$00,$00,$00,$00,$00,$12,$12,$4C,$00,$00,$16,$80,$12
   .byte $50,$00,$00,$00
LDF6C:
   .byte $01,$FF,$01,$FF
   
EntranceRoomTopObjectVertPos
   .byte ENTRANCE_ROOM_ROCK_VERT_POS
   .byte ENTRANCE_ROOM_CAVE_VERT_POS
   
LDF72:
   .byte $00,$00,$42,$45,$0C,$20
   
MarketBasketItems
   .byte ID_INVENTORY_COINS, ID_INVENTORY_CHAI
   .byte ID_INVENTORY_ANKH, ID_INVENTORY_HOUR_GLASS
   
LDF7C:
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
   dec objectVertPositions,x        ; move object up one pixel
.checkToMoveObjectDown
   ror
   bcs .checkToMoveObjectLeft
   inc objectVertPositions,x        ; move object down one pixel
.checkToMoveObjectLeft
   ror
   bcs .checkToMoveObjectRight
   dec objectHorizPositions,x       ; move object left one pixel
.checkToMoveObjectRight
   ror
   bcs .doneDetermineDirectionToMoveObject
   inc objectHorizPositions,x       ; move object right one pixel
.doneDetermineDirectionToMoveObject
   rts

LDFD5:
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
   
LDFE5:
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
   cmp $E0        ;3
   bcs LF01A      ;2
   lsr            ;2
   clc            ;2
   adc $DF        ;3
   tay            ;2
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3 = @03
   lda (pf1GraphicPointers),y ; 5
   sta PF1                    ; 3 = @11
   lda (pf2GraphicPointers),y ; 5
   sta PF2                    ; 3 = @19
   bcc .drawPlayerSprites     ; 2³
LF01A:
   sbc $D4        ;3
   lsr            ;2
   lsr            ;2
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3 = @03
   tax                        ; 2
   cpx snakeVertPos           ; 3
   bcc LF02D      ;2
   ldx $D8        ;3
   lda #$00       ;2
   beq LF031                  ; 3
   
LF02D:
   lda dungeonGraphics,x      ; 4
   ldx $D8        ;3
LF031:
   sta PF1,x      ;4
.drawPlayerSprites
   ldx #<ENAM1                ; 2
   txs                        ; 2
   lda scanline               ; 3
   sec                        ; 2
   sbc indyVertPos            ; 3
   cmp indySpriteHeight       ; 3
   bcs .skipIndyDraw          ; 2³
   tay                        ; 2
   lda (indyGraphicPointers),y;5
   tax                        ; 2
LF043:
   lda scanline               ; 3
   sec                        ; 2
   sbc topObjectVertPos       ; 3
   cmp player0SpriteHeight    ; 3
   bcs .skipDrawingPlayer0    ; 2³
   tay                        ; 2
   lda (player0GraphicPointers),y;5
   tay                        ; 2
.nextPlayfieldScanline
   lda scanline               ; 3
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   cmp bulletOrWhipVertPos    ; 3
   php                        ; 3 = @09   enable / disable M1
   cmp missile0VertPos        ; 3
   php                        ; 3 = @15   enable / disable M0
   stx GRP1                   ; 3 = @18
   sty GRP0                   ; 3 = @21
   sec                        ; 2
   sbc $D2        ;3
   cmp #$08       ;2
   bcs LF06E      ;2
   tay                        ; 2
   lda (timePieceGraphicPointers),y;5
   sta ENABL                  ; 3 = @40
   sta HMBL                   ; 3 = @43
LF06E:
   inc scanline               ; 5         increment scanline
   lda scanline               ; 3
   cmp #(H_KERNEL / 2)        ; 2
   bcc DrawPlayfieldKernel    ; 2³
   jmp InventoryKernel        ; 3
   
.skipIndyDraw
   ldx #0                     ; 2
   beq LF043      ;2
   
.skipDrawingPlayer0
   ldy #0                     ; 2
   beq .nextPlayfieldScanline ; 2³
   
DrawStationaryPlayerKernel SUBROUTINE
.checkToEndKernel
   cpx #(H_KERNEL / 2) - 1    ; 2
   bcc .skipDrawingPlayer0    ; 2³
   jmp InventoryKernel        ; 3
   
.skipDrawingPlayer0
   lda #0                     ; 2
   beq .nextStationaryPlayerScanline;3    unconditional branch
   
LF08C:
   lda (player0GraphicPointers),y;5
   bmi .setPlayer0Values      ; 2³
   cpy bottomObjectVertPos    ; 3
   bcs .checkToEndKernel      ; 2³
   cpy topObjectVertPos       ; 3
   bcc .skipDrawingPlayer0    ; 2³
   sta GRP0                   ; 3
   bcs .nextStationaryPlayerScanline;3    unconditional branch
   
.setPlayer0Values
   asl                        ; 2         shift value left
   tay                        ; 2         move value to y
   and #2                     ; 2         value 0 || 2
   tax                        ; 2         set for correct pointer index
   tya                        ; 2         move value to accumulator
   sta (player0TIAPointers,x) ; 6         set player 0 color or fine motion
.nextStationaryPlayerScanline
   inc scanline               ; 5         increment scan line
   ldx scanline               ; 3         get current scan line
   lda #ENABLE_BM             ; 2
   cpx missile0VertPos        ; 3
   bcc .skipDrawingMissile0   ; 2³        branch if not time to draw missile
   cpx $E0        ;3
   bcc .setEnableMissileValue ; 2³
.skipDrawingMissile0
   ror                        ; 2         shift ENABLE_BM right
.setEnableMissileValue
   sta ENAM0                  ; 3
JumpIntoStationaryPlayerKernel
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   txa                        ; 2         move scan line count to accumulator
   sec                        ; 2
   sbc snakeVertPos           ; 3         subtract Snake vertical position
   cmp #16                    ; 2
   bcs .waste19Cycles         ; 2³
   tay                        ; 2
   cmp #8                     ; 2
   bcc .waste05Cycles         ; 2³
   lda $D8                    ; 3
   sta timePieceGraphicPointers;3
LF0CA:
   lda (timePieceGraphicPointers),y;5
   sta HMBL                   ; 3 = @34
LF0CE:
   ldy #DISABLE_BM            ; 2
   txa                        ; 2         move scanline count to accumulator
   cmp bulletOrWhipVertPos    ; 3
   bne LF0D6                  ; 2³
   dey                        ; 2         y = -1
LF0D6:
   sty ENAM1                  ; 3 = @48
   sec                        ; 2
   sbc indyVertPos            ; 3
   cmp indySpriteHeight       ;  3
   bcs LF107                  ; 2³+1
   tay                        ; 2
   lda (indyGraphicPointers),y; 5
LF0E2:
   ldy scanline               ; 3
   sta GRP1                   ; 3 = @71
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   lda #ENABLE_BM             ; 2
   cpx $D2                    ; 3
   bcc LF0F9                  ; 2³
   cpx $DC                    ; 3
   bcc LF0F5                  ; 2³
.skipDrawingBall
   ror                        ; 2
LF0F5:
   sta ENABL                  ; 3 = @20
   bcc LF08C                  ; 3         unconditional branch
   
LF0F9:
   bcc .skipDrawingBall       ; 3         unconditional branch
   
.waste05Cycles
   SLEEP 2                    ; 2
   jmp LF0CA                  ; 3
   
.waste19Cycles
   pha                        ; 3
   pla                        ; 4
   pha                        ; 3
   pla                        ; 4
   SLEEP 2                    ; 2
   jmp LF0CE                  ; 3
   
LF107:
   lda #0                     ; 2
   beq LF0E2                  ; 3+1       unconditional branch
   
LF10B:
   inx                        ; 2         increment scanline
   sta HMCLR                  ; 3         clear horizontal movement registers
   cpx #H_KERNEL              ; 2
   bcc LF140                  ; 2³
   jmp InventoryKernel        ; 3
   
ThievesDenOrWellOfTheSoulsKernel
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   inx                        ; 2         increment scanline
   lda $84                    ; 3
   sta GRP0                   ; 3 = @11
   lda $85                    ; 3
   sta COLUP0                 ; 3 = @17
   txa                        ; 2         move canline to accumulator
   ldx #<ENABL                ; 2
   txs                        ; 2
   tax                        ; 2         move scanline to x
   lsr                        ; 2         divide scanline by 2
   cmp $D2                    ; 3
   php                        ; 3 = @33   enable / disable BALL
   cmp bulletOrWhipVertPos    ; 3
   php                        ; 3 = @39   enable / disable M1
   cmp missile0VertPos        ; 3
   php                        ; 3 = @45   enable / disable M0
   sec                        ; 2
   sbc indyVertPos            ; 3
   cmp indySpriteHeight       ; 3
   bcs LF10B                  ; 2³
   tay                        ; 2         move scanline value to y
   lda (indyGraphicPointers),y; 5         get Indy graphic data
   sta HMCLR                  ; 3 = @65   clear horizontal movement registers
   inx                        ; 2         increment scanline
   sta GRP1                   ; 3 = @70
LF140:
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   bit $D4                    ; 3
   bpl LF157                  ; 2³
   ldy $89                    ; 3
   lda $88                    ; 3
   lsr $D4                    ; 5
LF14E:
   dey                        ; 2
   bpl LF14E                  ; 2³
   sta RESP0                  ; 3
   sta HMP0                   ; 3
   bmi ThievesDenOrWellOfTheSoulsKernel;3 unconditional branch
   
LF157:
   bvc LF177                  ; 2³
   txa                        ; 2
   and #$0F                   ; 2
   tay                        ; 2
   lda (player0GraphicPointers),y;5
   sta GRP0                   ; 3 = @25
   lda (player0ColorPointers),y;5
   sta COLUP0                 ; 3 = @33
   iny                        ; 2
   lda (player0GraphicPointers),y;5
   sta $84                    ; 3
   lda (player0ColorPointers),y;5
   sta $85                    ; 3
   cpy player0SpriteHeight    ; 3
   bcc LF174                  ; 2³
   lsr $D4                    ; 5
LF174:
   jmp ThievesDenOrWellOfTheSoulsKernel;3
   
LF177:
   lda #$20       ;2
   bit $D4        ;3
   beq LF1A7      ;2
   txa            ;2
   lsr            ;2
   lsr            ;2
   lsr            ;2
   lsr            ;2
   lsr            ;2
   bcs ThievesDenOrWellOfTheSoulsKernel;2³
   tay            ;2
   sty $87        ;3
   lda thievesDirectionAndSize,y;4
   sta REFP0      ;3
   sta NUSIZ0     ;3
   sta $86        ;3
   bpl LF1A2      ;2
   lda $96        ;3
   sta player0GraphicPointers;3
   lda #$65       ;2
   sta player0ColorPointers
   lda #$00       ;2
   sta $D4        ;3
   jmp ThievesDenOrWellOfTheSoulsKernel;3
   
LF1A2:
   lsr $D4        ;5
   jmp ThievesDenOrWellOfTheSoulsKernel;3
   
LF1A7:
   lsr            ;2
   bit $D4        ;3
   beq LF1CE      ;2
   ldy $87        ;3
   lda #$08       ;2
   and $86        ;3
   beq LF1B6      ;2
   lda #$03       ;2
LF1B6:
   eor thievesHMOVEIndex,y
   and #3                           ; 4 frames of animation for the Thief
   tay
   lda ThiefSpriteLSBValues,y
   sta player0GraphicPointers       ; set Thief graphic LSB value
   lda #<ThiefColors
   sta player0ColorPointers
   lda #H_THIEF - 1
   sta player0SpriteHeight    ; 3
   lsr $D4        ;5
   jmp ThievesDenOrWellOfTheSoulsKernel;3
   
LF1CE:
   txa            ;2
   and #$1F       ;2
   cmp #$0C       ;2
   beq LF1D8      ;2
   jmp ThievesDenOrWellOfTheSoulsKernel;3
   
LF1D8:
   ldy $87        ;3
   lda thievesHorizPositions,y; 4
   sta $88        ;3
   and #$0F       ;2
   sta $89        ;3
   lda #$80       ;2
   sta $D4        ;3
   jmp ThievesDenOrWellOfTheSoulsKernel;3
   
InventoryKernel
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   ldx #$FF                   ; 2
   stx PF1                    ; 3 = @08
   stx PF2                    ; 3 = @11
   inx                        ; 2         x = 0
   stx GRP0                   ; 3 = @16
   stx GRP1                   ; 3 = @19
   stx ENAM0                  ; 3 = @22
   stx ENAM1                  ; 3 = @25
   stx ENABL                  ; 3 = @28
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   lda #THREE_COPIES          ; 2
   ldy #NO_REFLECT            ; 2
   sty REFP1                  ; 3 = @10
   sta NUSIZ0                 ; 3 = @13
   sta NUSIZ1                 ; 3 = @16
   sta VDELP0                 ; 3 = @19
   sta VDELP1                 ; 3 = @22
   sty GRP0                   ; 3 = @25
   sty GRP1                   ; 3 = @28
   sty GRP0                   ; 3 = @31
   sty GRP1                   ; 3 = @34
   SLEEP 2                    ; 2
   sta RESP0                  ; 3 = @39
   sta RESP1                  ; 3 = @42
   sty HMP1                   ; 3 = @45
   lda #HMOVE_R1              ; 2
   sta HMP0                   ; 3 = @50
   sty REFP0                  ; 3 = @53
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   lda #YELLOW + 10           ; 2
   sta COLUP0                 ; 3 = @08
   sta COLUP1                 ; 3 = @11
   lda selectedInventoryIndex ; 3         get selected inventory index
   lsr                        ; 2         divide value by 2
   tay                        ; 2
   lda InventoryIndexHorizValues,y;4
   sta HMBL                   ; 3 = @25   set fine motion for inventory indicator
   and #$0F                   ; 2         keep coarse value
   tay                        ; 2
   ldx #HMOVE_0               ; 2
   stx HMP0                   ; 3 = @34
   sta WSYNC
;--------------------------------------
   stx PF0                    ; 3 = @03
   stx COLUBK                 ; 3 = @06
   stx PF1                    ; 3 = @09
   stx PF2                    ; 3 = @12
.coarseMoveInventorySelector
   dey                        ; 2
   bpl .coarseMoveInventorySelector;2³
   sta RESBL                  ; 3
   stx CTRLPF                 ; 3
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   lda #$3F                   ; 2
   and frameCount             ; 3
   bne LF26D      ;2
   lda #$3F       ;2
   and secondsTimer        ;3
   bne LF26D      ;2
   lda $B5        ;3
   and #$0F       ;2
   beq LF26D      ;2
   cmp #$0F       ;2
   beq LF26D      ;2
   inc $B5        ;5
LF26D:
   sta WSYNC
;--------------------------------------
   lda #ORANGE + 2            ; 2
   sta COLUBK                 ; 3 = @05
   sta WSYNC
;--------------------------------------
   sta WSYNC
;--------------------------------------
   sta WSYNC
;--------------------------------------
   sta WSYNC
;--------------------------------------
   lda #H_INVENTORY_SPRITES - 1;2
   sta loopCount              ; 3
.drawInventorySprites
   ldy loopCount              ; 3
   lda (inventoryGraphicPointers),y;5
   sta GRP0                   ; 3
   sta WSYNC
;--------------------------------------
   lda (inventoryGraphicPointers + 2),y;5
   sta GRP1                   ; 3 = @08
   lda (inventoryGraphicPointers + 4),y;5
   sta GRP0                   ; 3 = @16
   lda (inventoryGraphicPointers + 6),y;5
   sta tempCharHolder         ; 3
   lda (inventoryGraphicPointers + 8),y;5
   tax                        ; 2
   lda (inventoryGraphicPointers + 10),y;5
   tay                        ; 2
   lda tempCharHolder         ; 3
   sta GRP1                   ; 3 = @44
   stx GRP0                   ; 3 = @47
   sty GRP1                   ; 3 = @50
   sty GRP0                   ; 3 = @53
   dec loopCount              ; 5
   bpl .drawInventorySprites  ; 2³
   lda #0                     ; 2
   sta WSYNC
;--------------------------------------
   sta GRP0                   ; 3 = @03
   sta GRP1                   ; 3 = @06
   sta GRP0                   ; 3 = @09
   sta GRP1                   ; 3 = @12
   sta NUSIZ0                 ; 3 = @15
   sta NUSIZ1                 ; 3 = @18
   sta VDELP0                 ; 3 = @21
   sta VDELP1                 ; 3 = @23
   sta WSYNC
;--------------------------------------
   sta WSYNC
;--------------------------------------
   ldy #ENABLE_BM             ; 2
   lda numberOfInventoryItems ; 3         get number of inventory items
   bne LF2C6                  ; 2³        branch if Indy carry items
   dey                        ; 2         y = 1
LF2C6:
   sty ENABL                  ; 3 = @12
   ldy #BLACK + 8             ; 2
   sty COLUPF                 ; 3 = @17
   sta WSYNC
;--------------------------------------
   sta WSYNC
;--------------------------------------
   ldy #DISABLE_BM            ; 2
   sty ENABL                  ; 3 = @05
   sta WSYNC
;--------------------------------------
   sta WSYNC
;--------------------------------------
   sta WSYNC
;--------------------------------------
Overscan
   ldx #$0F
   stx VBLANK                       ; turn off TIA (D1 = 1)
   ldx #OVERSCAN_TIME
   stx TIM64T                       ; set timer for overscan period
   ldx #$FF
   txs                              ; point stack to the beginning
   ldx #$01       ;2
LF2E8:
   lda $A2,x      ;4
   sta AUDC0,x    ;4
   sta AUDV0,x    ;4
   bmi LF2FB      ;2
   ldy #$00       ;2
   sty $A2,x      ;4
LF2F4:
   sta AUDF0,x    ;4
   dex            ;2
   bpl LF2E8      ;2
   bmi LF320                        ; unconditional branch
   
LF2FB:
   cmp #$9C       ;2
   bne LF314      ;2
   lda #$0F       ;2
   and frameCount        ;3
   bne LF30D      ;2
   dec $A4        ;5
   bpl LF30D      ;2
   lda #$17       ;2
   sta $A4        ;3
LF30D:
   ldy $A4        ;3
   lda LFBE8,y    ;4
   bne LF2F4      ;2
LF314:
   lda frameCount                   ; get current frame count
   lsr            ;2
   lsr            ;2
   lsr            ;2
   lsr            ;2
   tay            ;2
   lda LFAEE,y    ;4
   bne LF2F4      ;2
LF320:
   lda selectedInventoryId          ; get current selected inventory id
   cmp #ID_INVENTORY_TIME_PIECE
   beq LF330      ;2
   cmp #ID_INVENTORY_FLUTE
   bne LF344      ;2
   lda #$84       ;2
   sta $A3        ;3
   bne LF348                        ; unconditional branch
   
LF330:
   bit INPT5                        ; read action button from right controller
   bpl LF338                        ; branch if action button pressed
   lda #<InventoryTimepieceSprite
   bne LF340                        ; unconditional branch
   
LF338:
   lda secondsTimer        ;3
   and #$E0       ;2
   lsr            ;2
   lsr            ;2
   adc #<Inventory12_00
LF340:
   ldx selectedInventoryIndex
   sta inventoryGraphicPointers,x      ;4
LF344:
   lda #$00       ;2
   sta $A3        ;3
LF348:
   bit $93        ;3
   bpl LF371      ;2
   lda frameCount                   ; get current frame count
   and #$07       ;2
   cmp #$05       ;2
   bcc LF365      ;2
   ldx #$04       ;2
   ldy #$01       ;2
   bit $9D        ;3
   bmi LF360      ;2
   bit $A1        ;3
   bpl LF362      ;2
LF360:
   ldy #$03       ;2
LF362:
   jsr   LF8B3    ;6
LF365:
   lda frameCount                   ; get current frame count
   and #$06       ;2
   asl            ;2
   asl            ;2
   sta $D6        ;3
   lda #$FD       ;2
   sta $D7        ;3
LF371:
   ldx #$02       ;2
LF373:
   jsr   LFEF4    ;6
   inx            ;2
   cpx #$05       ;2
   bcc LF373      ;2
   bit $9D        ;3
   bpl LF3BF      ;2
   lda frameCount                   ; get current frame count
   bvs LF39D      ;2
   and #$0F       ;2
   bne LF3C5      ;2
   ldx indySpriteHeight        ;3
   dex            ;2
   stx $A3        ;3
   cpx #$03       ;2
   bcc LF398      ;2
   lda #$8F       ;2
   sta bulletOrWhipVertPos
   stx indySpriteHeight        ;3
   bcs LF3C5                        ; unconditional branch
   
LF398:
   sta frameCount        ;3
   sec            ;2
   ror $9D        ;5
LF39D:
   cmp #$3C       ;2
   bcc LF3A9      ;2
   bne LF3A5      ;2
   sta $A3        ;3
LF3A5:
   ldy #$00       ;2
   sty indySpriteHeight
LF3A9:
   cmp #$78       ;2
   bcc LF3C5      ;2
   lda #H_INDY_SPRITE
   sta indySpriteHeight
   sta $A3        ;3
   sta $9D        ;3
   dec lives
   bpl LF3C5      ;2
   lda #$FF       ;2
   sta $9D        ;3
   bne LF3C5                        ; unconditional branch
   
LF3BF:
   lda currentScreenId              ; get the current screen id
   cmp #ID_ARK_ROOM
   bne CheckForCyclingInventorySelection; branch if not in ID_ARK_ROOM
LF3C5:
   lda #<VerticalSync
   sta bankSwitchJMPAddress
   lda #>VerticalSync
   sta bankSwitchJMPAddress + 1
   jmp JumpToBank0
   
CheckForCyclingInventorySelection
   bit $8D        ;3
   bvs .doneCyclingInventorySelection
   bit $B4        ;3
   bmi .doneCyclingInventorySelection
   bit $9A        ;3
   bmi .doneCyclingInventorySelection
   lda #7
   and frameCount
   bne .doneCyclingInventorySelection;check to move inventory selector ~8 frames
   lda numberOfInventoryItems       ; get number of inventory items
   and #MAX_INVENTORY_ITEMS
   beq .doneCyclingInventorySelection; branch if Indy not carrying items
   ldx selectedInventoryIndex
   lda inventoryGraphicPointers,x   ; get inventory graphic LSB value
   cmp #<Inventory12_00
   bcc CheckForChoosingInventoryItem; branch if the item is not a clock sprite
   lda #<InventoryTimepieceSprite   ; reset inventory item to the time piece
CheckForChoosingInventoryItem
   bit SWCHA                        ; check joystick values
   bmi .checkForCyclingLeftThroughInventory;branch if left joystick not pushed right
   sta inventoryGraphicPointers,x   ; set inventory graphic LSB value
.cycleThroughInventoryRight
   inx
   inx
   cpx #11
   bcc .continueCycleInventoryRight
   ldx #0
.continueCycleInventoryRight
   ldy inventoryGraphicPointers,x   ; get inventory graphic LSB value
   beq .cycleThroughInventoryRight  ; branch if no item present (i.e. Blank)
   bne .setSelectedInventoryIndex   ; unconditional branch
   
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
   beq .cycleThroughInventoryLeft   ; branch if no item present (i.e. Blank)
.setSelectedInventoryIndex
   stx selectedInventoryIndex
   tya                              ; move inventory graphic LSB to accumulator
   lsr                              ; divide value by 8 (i.e. H_INVENTORY_SPRITES)
   lsr
   lsr
   sta selectedInventoryId          ; set selected inventory id
   cpy #<InventoryHourGlassSprite
   bne .doneCyclingInventorySelection; branch if the Hour Glass not selected
   ldy #ID_MESA_FIELD
   cpy currentScreenId
   bne .doneCyclingInventorySelection; branch if not in Mesa Field
   lda #$49       ;2
   sta $8D        ;3
   lda indyVertPos                  ; get Indy's vertical position
   adc #9
   sta bulletOrWhipVertPos
   lda indyHorizPos
   adc #9
   sta bulletOrWhipHorizPos
.doneCyclingInventorySelection
   lda $8D        ;3
   bpl LF454      ;2
   cmp #$BF       ;2
   bcs LF44B      ;2
   adc #$10       ;2
   sta $8D        ;3
   ldx #$03       ;2
   jsr   LFCEA    ;6
   jmp   LF48B    ;3
   
LF44B:
   lda #$70       ;2
   sta bulletOrWhipVertPos
   lsr            ;2
   sta $8D        ;3
   bne LF48B      ;2
   
LF454:
   bit $8D        ;3
   bvc LF48B      ;2
   ldx #$03       ;2
   jsr   LFCEA    ;6
   lda bulletOrWhipHorizPos         ; get bullet or whip horizontal position
   sec            ;2
   sbc #$04       ;2
   cmp indyHorizPos        ;3
   bne LF46A      ;2
   lda #$03       ;2
   bne LF481                        ; unconditional branch
   
LF46A:
   cmp #$11       ;2
   beq LF472      ;2
   cmp #$84       ;2
   bne LF476      ;2
LF472:
   lda #$0F       ;2
   bne LF481                        ; unconditional branch
   
LF476:
   lda bulletOrWhipVertPos          ; get bullet or whip vertical position
   sec            ;2
   sbc #$05       ;2
   cmp indyVertPos        ;3
   bne LF487      ;2
   lda #$0C       ;2
LF481:
   eor $8D        ;3
   sta $8D        ;3
   bne LF48B      ;2
LF487:
   cmp #$4A       ;2
   bcs LF472      ;2
LF48B:
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
   cpx #18                    ; 2
   bcc .checkToDrawArk        ; 2³
   txa                        ; 2         move scanline to accumulator
   sbc indyVertPos            ; 3
   bmi LF4C9                  ; 2³
   cmp #(H_INDY_SPRITE - 1) * 2;2
   bcs .drawLiftingPedestal   ; 2³
   lsr                        ; 2
   tay                        ; 2
   lda IndyStationarySprite,y ; 4
   jmp .drawPlayer1Sprite     ; 3
   
.drawLiftingPedestal
   and #3                     ; 2
   tay                        ; 2
   lda LiftingPedestalSprite,y; 4
.drawPlayer1Sprite
   sta GRP1                   ; 3 = @27
   lda indyVertPos            ; 3         get Indy's vertical position
   sta COLUP1                 ; 3 = @33
LF4C9:
   inx                        ; 2         increment scanline count
   cpx #144                   ; 2
   bcs LF4EA                  ; 2³
   bcc .arkRoomKernelLoop     ; 3         unconditional branch
   
.checkToDrawArk
   bit zp_9C                  ; 3
   bmi .skipDrawingArk        ; 2³
   txa                        ; 2         move scanline to accumulator
   sbc #H_ARK_OF_THE_COVENANT ; 2
   bmi .skipDrawingArk        ; 2³
   tay                        ; 2
   lda ArkOfTheCovenantSprite,y;4
   sta GRP1                   ; 3
   txa                        ; 2         move scanline to accumulator
   adc frameCount             ; 3         increase value by current frame count
   asl                        ; 2         multiply value by 2
   sta COLUP1                 ; 3         color Ark of the Covenant sprite
.skipDrawingArk
   inx                        ; 2
   cpx #15                    ; 2
   bcc .arkRoomKernelLoop     ; 2³
LF4EA:
   sta WSYNC
;--------------------------------------
   cpx #32                    ; 2
   bcs .checkToDrawPedestal   ; 2³+1
   bit zp_9C                  ; 3
   bmi LF504      ;2
   txa                        ; 2         move scanline to accumulator
   ldy #%01111110             ; 2
   and #$0E       ;2
   bne .drawPlayer0Sprite     ; 2³
   ldy #%11111111             ; 2
.drawPlayer0Sprite
   sty GRP0                   ; 3
   txa                        ; 2
   eor #$FF       ;2
   sta COLUP0     ;3
LF504:
   inx            ;2
   cpx #29                    ;2
   bcc LF4EA      ;2
   lda #0                     ; 2
   sta GRP0                   ; 3
   sta GRP1                   ; 3
   beq .arkRoomKernelLoop     ; 2³+1      unconditional branch
   
.checkToDrawPedestal
   txa                        ; 2 = @08
   sbc #144                   ; 2
   cmp #H_PEDESTAL            ; 2
   bcc .drawPedestal          ; 2³
   jmp InventoryKernel        ; 3
   
.drawPedestal
   lsr                        ; 2         divide by 4 to read graphic data
   lsr                        ; 2
   tay                        ; 2
   lda PedestalSprite,y       ; 4
   sta GRP0                   ; 3 = @28
   stx COLUP0                 ; 3 = @31
   inx                        ; 2
   bne LF4EA                  ; 3         unconditional branch
   
LF528:
   lda currentScreenId              ; get the current screen id
   asl                              ; multiply screen id by 2
   tax
   lda LFC88 + 1,x
   pha
   lda LFC88,x
   pha
   rts

LF535:
   lda #$7F       ;2
   sta $CE        ;3
   sta missile0VertPos
   sta $D2        ;3
   bne LF59A                        ; unconditional branch
   
LF53F:
   ldx #$00       ;2
   ldy #<indyVertPos - objectVertPositions
   bit CXP1FB                       ; check Indy collision with playfield
   bmi LF55B                        ; branch if Indy collided with playfield
   bit $B6        ;3
   bmi LF55B      ;2
   lda frameCount                   ; get the current frame count
   and #$07       ;2
   bne LF55E      ;2
   ldy #$05       ;2
   lda #$4C       ;2
   sta $CD        ;3
   lda #$23       ;2
   sta $D3        ;3
LF55B:
   jsr   LF8B3    ;6
LF55E:
   lda #$80       ;2
   sta $93        ;3
   lda $CE        ;3
   and #$01       ;2
   ror $C8        ;5
   rol            ;2
   tay            ;2
   ror            ;2
   rol $C8        ;5
   lda LFAEA,y    ;4
   sta player0GraphicPointers;3
   lda #$FC       ;2
   sta player0GraphicPointers + 1;3
   lda $8E        ;3
   bmi LF59A      ;2
   ldx #$50       ;2
   stx $CA        ;3
   ldx #$26       ;2
   stx missile0VertPos
   lda $B6        ;3
   bmi LF59A      ;2
   bit $9D        ;3
   bmi LF59A      ;2
   and #$07       ;2
   bne LF592      ;2
   ldy #$06       ;2
   sty $B6        ;3
LF592:
   tax            ;2
   lda LFCD2,x    ;4
   sta $8E        ;3
   dec $B6        ;5
LF59A:
   jmp   LF833    ;3
   
LF59D:
   lda #$80       ;2
   sta $93        ;3
   ldx #$00       ;2
   bit $9D        ;3
   bmi LF5AB      ;2
   bit zp_95
   bvc LF5B7      ;2
LF5AB:
   ldy #$05       ;2
   lda #$55       ;2
   sta $CD        ;3
   sta $D3        ;3
   lda #$01       ;2
   bne LF5BB                        ; unconditional branch
   
LF5B7:
   ldy #<indyVertPos - objectVertPositions
   lda #$03       ;2
LF5BB:
   and frameCount        ;3
   bne LF5CE      ;2
   jsr   LF8B3    ;6
   lda $CE        ;3
   bpl LF5CE      ;2
   cmp #$A0       ;2
   bcc LF5CE      ;2
   inc $CE        ;5
   inc $CE        ;5
LF5CE:
   bvc LF5DE      ;2
   lda $CE        ;3
   cmp #$51       ;2
   bcc LF5DE      ;2
   lda zp_95
   sta $99        ;3
   lda #$00       ;2
   sta zp_95
LF5DE:
   lda $C8        ;3
   cmp indyHorizPos        ;3
   bcs LF5E7      ;2
   dex            ;2
   eor #$03       ;2
LF5E7:
   stx REFP0      ;3
   and #$03       ;2
   asl            ;2
   asl            ;2
   asl            ;2
   asl            ;2
   sta player0GraphicPointers;3
   lda frameCount                   ; get current frame count
   and #$7F       ;2
   bne LF617      ;2
   lda $CE        ;3
   cmp #$4A       ;2
   bcs LF617      ;2
   ldy $98        ;3
   beq LF617      ;2
   dey            ;2
   sty $98        ;3
   ldy #$8E       ;2
   adc #$03       ;2
   sta missile0VertPos
   cmp indyVertPos        ;3
   bcs LF60F      ;2
   dey            ;2
LF60F:
   lda $C8        ;3
   adc #$04       ;2
   sta $CA        ;3
   sty $8E        ;3
LF617:
   ldy #$7F       ;2
   lda $8E        ;3
   bmi LF61F      ;2
   sty missile0VertPos
LF61F:
   lda bulletOrWhipVertPos          ; get bullet or whip vertical position
   cmp #$52       ;2
   bcc LF627      ;2
   sty bulletOrWhipVertPos
LF627:
   jmp   LF833    ;3
   
LF62A:
   ldx #$3A       ;2
   stx $E9        ;3
   ldx #$85       ;2
   stx $E3        ;3
   ldx #BONUS_LANDING_IN_MESA
   stx landingInMesaBonus
   bne .checkToMoveThieves          ; unconditional branch
   
LF638:
   ldx #4       ;2
.checkToMoveThieves
   lda ThiefMovementFrameDelayValues,x
   and frameCount
   bne .moveNextThief               ; branch if not time to move
   ldy thievesHMOVEIndex,x          ; get thief HMOVE index value
   lda #REFLECT
   and thievesDirectionAndSize,x
   bne LF65C                        ; branch if thief not reflected
   dey                              ; reduce thief HMOVE index value
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
   jmp   LF833    ;3
   
LF65C:
   iny                              ; increment thief HMOVE index value
   cpy #133
   bcs .changeThiefDirection
   bcc .setThiefHMOVEIndexValue     ; unconditional branch
   
LF663:
   bit $B4        ;3
   bpl LF685      ;2
   bvc LF66D      ;2
   dec indyHorizPos        ;5
   bne LF685                        ; unconditional branch
   
LF66D:
   lda frameCount                   ; get current frame count
   ror                              ; shift D0 to carry
   bcc LF685                        ; branch on even frame
   lda SWCHA                        ; read joystick values
   sta $92
   ror
   ror
   ror
   bcs LF680                        ; branch if right joystick not pushed left
   dec indyHorizPos
   bne LF685                        ; unconditional branch
   
LF680:
   ror
   bcs LF685                        ; branch if right joystick not pushed right
   inc indyHorizPos
LF685:
   lda #$02       ;2
   and $B4        ;3
   bne LF691      ;2
   sta $8D        ;3
   lda #$0B       ;2
   sta $CE        ;3
LF691:
   ldx indyVertPos                  ; get Indy's vertical position
   lda frameCount                   ; get current frame count
   bit $B4        ;3
   bmi LF6A3      ;2
   cpx #$15       ;2
   bcc LF6A3      ;2
   cpx #$30       ;2
   bcc LF6AA      ;2
   bcs LF6A9                        ; unconditional branch
   
LF6A3:
   ror            ;2
   bcc LF6AA      ;2
LF6A6:
   jmp   LF833    ;3
   
LF6A9:
   inx            ;2
LF6AA:
   inx            ;2
   stx indyVertPos        ;3
   bne LF6A6      ;2
LF6AF:
   lda indyHorizPos        ;3
   cmp #$64       ;2
   bcc LF6BC      ;2
   rol blackMarketState             ; rotate Black Market state left
   clc                              ; clear carry
   ror blackMarketState             ; rotate right to show Indy carrying coins
   bpl LF6DE                        ; unconditional branch
   
LF6BC:
   cmp #$2C       ;2
   beq LF6C6      ;2
   lda #$7F       ;2
   sta $D2        ;3
   bne LF6DE                        ; unconditional branch
   
LF6C6:
   bit blackMarketState             ; check Black Market state
   bmi LF6DE                        ; branch if Indy not carrying coins
   lda #$30       ;2
   sta $CC        ;3
   ldy #$00       ;2
   sty $D2        ;3
   ldy #$7F       ;2
   sty $DC        ;3
   sty snakeVertPos        ;3
   inc indyHorizPos        ;5
   lda #$80       ;2
   sta $9D        ;3
LF6DE:
   jmp   LF833    ;3
   
LF6E1:
   ldy $DF        ;3
   dey            ;2
   bne LF6DE      ;2
   lda $AF        ;3
   and #$07       ;2
   bne LF71D      ;2
   lda #$40       ;2
   sta $93        ;3
   lda secondsTimer        ;3
   lsr            ;2
   lsr            ;2
   lsr            ;2
   lsr            ;2
   lsr            ;2
   tax            ;2
   ldy LFCDC,x    ;4
   ldx LFCAA,y    ;4
   sty $84        ;3
   jsr   LF89D    ;6
   bcc LF70A      ;2
LF705:
   inc $DF        ;5
   bne LF6DE      ;2
   brk            ;7
LF70A:
   ldy $84        ;3
   tya            ;2
   ora $AF        ;3
   sta $AF        ;3
   lda LFCA2,y    ;4
   sta $CE        ;3
   lda LFCA6,y    ;4
   sta $DF        ;3
   bne LF6DE      ;2
LF71D:
   cmp #$04       ;2
   bcs LF705      ;2
   rol $AF        ;5
   sec            ;2
   ror $AF        ;5
   bmi LF705                        ; unconditional branch
   
LF728:
   ldy #$00       ;2
   sty $D2        ;3
   ldy #$7F       ;2
   sty $DC        ;3
   sty snakeVertPos        ;3
   lda #$71       ;2
   sta $CC        ;3
   ldy #$4F       ;2
   lda #$3A       ;2
   cmp indyVertPos        ;3
   bne LF74A      ;2
   lda selectedInventoryId
   cmp #ID_INVENTORY_KEY
   beq LF74C      ;2
   lda #$5E       ;2
   cmp indyHorizPos        ;3
   beq LF74C      ;2
LF74A:
   ldy #$0D       ;2
LF74C:
   sty $DF        ;3
   lda secondsTimer        ;3
   sec            ;2
   sbc #$10       ;2
   bpl LF75A      ;2
   eor #$FF       ;2
   sec            ;2
   adc #$00       ;2
LF75A:
   cmp #$0B       ;2
   bcc LF760      ;2
   lda #$0B       ;2
LF760:
   sta $CE        ;3
   bit $B3        ;3
   bpl LF78B      ;2
   cmp #$08       ;2
   bcs LF787      ;2
   ldx selectedInventoryId
   cpx #ID_INVENTORY_HEAD_OF_RA
   bne LF787      ;2
   stx usingHeadOfRaInMapRoomBonus
   lda #$04       ;2
   and frameCount        ;3
   bne LF787      ;2
   lda $8C        ;3
   and #$0F       ;2
   tax            ;2
   lda LFAC2,x    ;4
   sta bulletOrWhipHorizPos
   lda LFAD2,x    ;4
   bne LF789                        ; unconditional branch
   
LF787:
   lda #$70       ;2
LF789:
   sta bulletOrWhipVertPos
LF78B:
   rol $B3        ;5
   lda #$3A       ;2
   cmp indyVertPos
   bne LF7A2      ;2
   cpy #$4F       ;2
   beq LF79D      ;2
   lda #$5E       ;2
   cmp indyHorizPos        ;3
   bne LF7A2      ;2
LF79D:
   sec            ;2
   ror $B3        ;5
   bmi LF7A5                        ; unconditional branch
   
LF7A2:
   clc            ;2
   ror $B3        ;5
LF7A5:
   jmp   LF833    ;3
   
LF7A8:
   lda #PICKUP_ITEM_STATUS_TIME_PIECE
   and pickupItemsStatus
   bne LF7C0                        ; branch if Time Piece taken
   lda #$4C       ;2
   sta $CC        ;3
   lda #$2A       ;2
   sta $D2        ;3
   lda #<LFABA
   sta timePieceGraphicPointers
   lda #>LFABA
   sta timePieceGraphicPointers + 1
   bne LF7C4      ;2
   
LF7C0:
   lda #$F0       ;2
   sta $D2        ;3
LF7C4:
   lda $B5        ;3
   and #$0F       ;2
   beq LF833      ;2
   sta $DC        ;3
   ldy #$14       ;2
   sty $CE        ;3
   ldy #$3B       ;2
   sty $E0        ;3
   iny            ;2
   sty $D4        ;3
   lda #$C1       ;2
   sec            ;2
   sbc $DC        ;3
   sta player0GraphicPointers;3
   bne LF833                        ; unconditional branch
   
LF7E0:
   lda frameCount                   ; get current frame count
   and #$18                         ; update every 8 frames
   adc #<ShiningLightSprites
   sta player0GraphicPointers       ; set Shining Light graphic LSB value
   lda frameCount                   ; get current frame count
   and #7
   bne LF80F      ;2
   ldx #<shiningLightVertPos - objectVertPositions
   ldy #<indyVertPos - objectVertPositions
   lda indyVertPos                  ; get Indy's vertical position
   cmp #58
   bcc LF80C
   lda indyHorizPos                 ; get Indy's horizontal position
   cmp #$2B       ;2
   bcc LF802      ;2
   cmp #$6D       ;2
   bcc LF80C      ;2
LF802:
   ldy #$05       ;2
   lda #$4C       ;2
   sta $CD        ;3
   lda #$0B       ;2
   sta $D3        ;3
LF80C:
   jsr   LF8B3    ;6
LF80F:
   ldx #$4E       ;2
   cpx indyVertPos        ;3
   bne LF833      ;2
   ldx indyHorizPos        ;3
   cpx #$76       ;2
   beq LF81F      ;2
   cpx #$14       ;2
   bne LF833      ;2
LF81F:
   lda SWCHA                        ; read joystick values
   and #P1_NO_MOVE
   cmp #(MOVE_DOWN >> 4)
   bne LF833                        ; branch if right joystick not pushed down
   sta escapedShiningLightPenalty   ; place 13 in Shining Light penalty
   lda #$4C       ;2
   sta indyHorizPos        ;3
   ror $B5        ;5
   sec            ;2
   rol $B5        ;5
LF833:
   lda #<LD80D
   sta bankSwitchJMPAddress
   lda #>LD80D
   sta bankSwitchJMPAddress + 1
   jmp JumpToBank0
   
LF83E:   
   lda #$40       ;2
   sta $93        ;3
   bne LF833      ;2
   
DisplayKernel
   sta WSYNC
;--------------------------------------
   sta HMCLR                  ; 3 = @03   clear horizontal motion
   sta CXCLR                  ; 3 = @06   clear all collisions
   ldy #$FF                   ; 2
   sty PF1                    ; 3 = @11
   sty PF2                    ; 3 = @14
   ldx currentScreenId        ; 3         get the current screen id
   lda RoomPF0GraphicData,x   ; 4
   sta PF0                    ; 3 = @24
   iny                        ; 2         y = 0
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   sty VBLANK                 ; 3 = @06   enable TIA (D1 = 0)
   sty scanline               ; 3
   cpx #ID_MAP_ROOM           ; 2
   bne LF865                  ; 2³        branch if not in Map Room
   dey                        ; 2         y = -1
LF865:
   sty ENABL                  ; 3 = @18
   cpx #ID_ARK_ROOM           ; 2
   beq LF874                  ; 2³        branch if in Ark Room
   bit $9D                    ; 3
   bmi LF874                  ; 2³
   ldy SWCHA                  ; 4         read joystick values
   sty REFP1                  ; 3 = @34
LF874:
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   ldy currentScreenId        ; 3         get the current screen id
   sta WSYNC
;--------------------------------------
   sta HMOVE                  ; 3
   lda RoomPF1GraphicData,y   ; 4
   sta PF1                    ; 3 = @10
   lda RoomPF2GraphicData,y   ; 4
   sta PF2                    ; 3 = @17
   ldx KernelJumpTableIndex,y ; 4
   lda KernelJumpTable + 1,x  ; 4
   pha                        ; 3
   lda KernelJumpTable,x      ; 4
   pha                        ; 3
   lda #0                     ; 2
   tax                        ; 2
   sta $84                    ; 3
   rts                        ; 6         jump to specified kernel

LF89D:
   lda LFC75,x    ;4
   lsr            ;2
   tay            ;2
   lda LFCE2,y    ;4
   bcs LF8AD      ;2
   and basketItemsStatus
   beq LF8AC      ;2
   sec            ;2
LF8AC:
   rts            ;6

LF8AD:
   and pickupItemsStatus
   bne LF8AC      ;2
   clc            ;2
   rts            ;6

LF8B3:
   cpy #<indyVertPos - objectVertPositions
   bne LF8BB      ;2
   lda indyVertPos                  ; get Indy's vertical position
   bmi LF8CC      ;2
LF8BB:
   lda objectVertPositions,x      ;4
   cmp objectVertPositions,y    ;4
   bne LF8C6      ;2
   cpy #$05       ;2
   bcs LF8CE      ;2
LF8C6:
   bcs LF8CC      ;2
   inc objectVertPositions,x      ;6
   bne LF8CE      ;2
LF8CC:
   dec objectVertPositions,x      ;6
LF8CE:
   lda objectHorizPositions,x      ;4
   cmp objectHorizPositions,y    ;4
   bne LF8D9      ;2
   cpy #$05       ;2
   bcs LF8DD      ;2
LF8D9:
   bcs LF8DE      ;2
   inc objectHorizPositions,x      ;6
LF8DD:
   rts            ;6

LF8DE:
   dec objectHorizPositions,x      ;6
   rts            ;6

LF8E1:
   lda objectVertPositions,x      ;4
   cmp #$53       ;2
   bcc LF8F1      ;2
LF8E7:
   rol $8C,x      ;6
   clc            ;2
   ror $8C,x      ;6
   lda #$78       ;2
   sta objectVertPositions,x      ;4
   rts            ;6

LF8F1:
   lda objectHorizPositions,x      ;4
   cmp #$10       ;2
   bcc LF8E7      ;2
   cmp #$8E       ;2
   bcs LF8E7      ;2
   rts            ;6

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
   
LFA72:
   .byte HMOVE_L1
   .byte HMOVE_L1
   .byte HMOVE_0
   .byte HMOVE_R1
   .byte HMOVE_R1
   .byte HMOVE_0
   .byte HMOVE_L1
   .byte HMOVE_0
LFA7A:
   .byte HMOVE_L1
   .byte HMOVE_L1
   .byte HMOVE_0
   .byte HMOVE_R1
   .byte HMOVE_0
   .byte HMOVE_L1
   .byte HMOVE_L1
   .byte HMOVE_0
LFA82:
   .byte HMOVE_L1
   .byte HMOVE_0
   .byte HMOVE_R1
   .byte HMOVE_R1
   .byte HMOVE_0
   .byte HMOVE_R1
   .byte HMOVE_R1
   .byte HMOVE_0
LFA8A:
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
; last byte  shared with next table so don't cross page boundaries
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
   
LFABA:
   .byte HMOVE_R1 | 7
   .byte HMOVE_R1 | 7
   .byte HMOVE_R1 | 7
   .byte HMOVE_R1 | 7
   .byte HMOVE_R1 | 7
   .byte HMOVE_L3 | 7
   .byte HMOVE_L3 | 7
   .byte HMOVE_0  | 0
   
LFAC2:
   .byte $63,$62,$6B,$5B,$6A,$5F,$5A,$5A,$6B,$5E,$67,$5A,$62,$6B,$5A,$6B
   
LFAD2:
   .byte $22,$13,$13,$18,$18,$1E,$21,$13,$21,$26,$26,$2B,$2A,$2B,$31,$31
   
KernelJumpTable
   .word JumpIntoStationaryPlayerKernel - 1
   .word DrawPlayfieldKernel - 1
   .word LF140 - 1
   .word ArkRoomKernel - 1
   
LFAEA:
   .byte $AE,$C0,$B7,$C9
   
LFAEE:
   .byte $1B,$18,$17,$17,$18,$18,$1B,$1B,$1D,$18,$17,$12,$18,$17,$1B,$1D
   .byte $00,$00
   
InventorySprites
LFB00:
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
LFB10:
InventoryFluteSprite
   .byte $00 ; |........|
   .byte $01 ; |.......X|
   .byte $3F ; |..XXXXXX|
   .byte $6B ; |.XX.X.XX|
   .byte $7F ; |.XXXXXXX|
   .byte $01 ; |.......X|
   .byte $00 ; |........|
   .byte $00 ; |........|
LFB18:
InventoryParachuteSprite
   .byte $77 ; |.XXX.XXX|
   .byte $77 ; |.XXX.XXX|
   .byte $77 ; |.XXX.XXX|
   .byte $00 ; |........|
   .byte $00 ; |........|
   .byte $77 ; |.XXX.XXX|
   .byte $77 ; |.XXX.XXX|
   .byte $77 ; |.XXX.XXX|
LFB20:
InventoryCoinsSprite
   .byte $1C ; |...XXX..|
   .byte $2A ; |..X.X.X.|
   .byte $55 ; |.X.X.X.X|
   .byte $2A ; |..X.X.X.|
   .byte $55 ; |.X.X.X.X|
   .byte $2A ; |..X.X.X.|
   .byte $1C ; |...XXX..|
   .byte $3E ; |..XXXXX.|
LFB28:
MarketplaceGrenadeSprite
   .byte $3A ; |..XXX.X.|
   .byte $01 ; |.......X|
   .byte $7D ; |.XXXXX.X|
   .byte $01 ; |.......X|
   .byte $39 ; |..XXX..X|
   .byte $02 ; |......X.|
   .byte $3C ; |..XXXX..|
   .byte $30 ; |..XX....|
LFB30:
BlackMarketGrenadeSprite
   .byte $2E ; |..X.XXX.|
   .byte $40 ; |.X......|
   .byte $5F ; |.X.XXXXX|
   .byte $40 ; |.X......|
   .byte $4E ; |.X..XXX.|
   .byte $20 ; |..X.....|
   .byte $1E ; |...XXXX.|
   .byte $06 ; |.....XX.|
LFB38:
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
   
LFBE8:
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
LFC75:
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
   
LFC88:
   .word LF6E1 - 1            ; Treasure Room
   .word LF833 - 1            ; Marketplace
   .word LF83E - 1            ; Entrance Room
   .word LF6AF - 1            ; Black Market
   .word LF728 - 1            ; Map room
   .word LF663 - 1            ; mesa side
   .word LF7A8 - 1            ; temple entrance
   .word LF53F - 1            ; spider room
   .word LF7E0 - 1            ; room of shining light
   .word LF535 - 1            ; mesa field
   .word LF59D - 1            ; valley of poison
   .word LF638 - 1            ; thieves den
   .word LF62A - 1            ; well of souls
   
LFCA2:
   .byte $1A,$38,$09,$26
   
LFCA6:
   .byte $26,$46,$1A,$38
   
LFCAA:
   .byte $04,$11,$10,$12,$54,$FC,$5F,$FE,$7F,$FA,$3F,$2A,$00,$54,$5F,$FC
   .byte $7F,$FE,$3F,$FA,$2A,$00,$2A,$FA,$3F,$FE,$7F,$FA,$5F,$54,$00,$2A
   .byte $3F,$FA,$7F,$FE,$5F,$FC,$54,$00
   
LFCD2:
   .byte $8B,$8A,$86,$87,$85,$89
   
ThiefMovementFrameDelayValues
   .byte $03,$01,$00,$01
   
LFCDC:
   .byte $03,$02,$01,$03,$02,$03
   
LFCE2:
   .byte $01,$02,$04,$08,$10,$20,$40,$80
   
LFCEA:
   ror            ;2
   bcs LFCEF      ;2
   dec objectVertPositions,x      ;6
LFCEF:
   ror            ;2
   bcs LFCF4      ;2
   inc objectVertPositions,x      ;6
LFCF4:
   ror            ;2
   bcs LFCF9      ;2
   dec objectHorizPositions,x      ;6
LFCF9:
   ror            ;2
   bcs LFCFE      ;2
   inc objectHorizPositions,x      ;6
LFCFE:
   rts            ;6

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
   
LFD20:
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
   
LFD48:
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
   
LFD68:
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
   
LFD89:
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
   
LFD9B:
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
   
LFDB7:
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
   
LFE00:
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
   
LFE78:
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
   
LFEF4:
   lda $8C,x      ;4
   bmi LFEF9      ;2
   rts            ;6

LFEF9:
   jsr   LFCEA    ;6
   jsr   LF8E1    ;6
   rts            ;6

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
