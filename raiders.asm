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
; = THIS REVERSE-ENGINEERING PROJECT IS BEING SUPPLIED TO THE PUBLIC DOMAIN     =
; = FOR EDUCATIONAL PURPOSES ONLY. THOUGH THE CODE WILL ASSEMBLE INTO THE       =
; = EXACT GAME ROM, THE LABELS AND COMMENTS ARE THE INTERPRETATION OF MY OWN   =
; = AND MAY NOT REPRESENT THE ORIGINAL VISION OF THE AUTHOR.                    =
; =                                                                             =
; = THE ASSEMBLED CODE IS  1982, ATARI, INC.                                   =
; =                                                                             =
; ==============================================================================
;
; Disassembly of ~\Projects\Programming\reversing\6502\raiders\raiders.bin
; Disassembled 07/02/23 15:14:09
; Using Stella 6.7
;
; ROM properties name : Raiders of the Lost Ark (1982) (Atari)
; ROM properties MD5  : f724d3dd2471ed4cf5f191dbb724b69f
; Bankswitch type     : F8* (8K) 
;
; Updated: Halkun
; Legend: *  = CODE not yet run (tentative code)
;         D  = DATA directive (referenced in some way)
;         G  = GFX directive, shown as '#' (stored in player, missile, ball)
;         P  = PGFX directive, shown as '*' (stored in playfield)
;         C  = COL directive, shown as color constants (stored in player color)
;         CP = PCOL directive, shown as color constants (stored in playfield color)
;         CB = BCOL directive, shown as color constants (stored in background color)
;         A  = AUD directive (stored in audio registers)
;         i  = indexed accessed only
;         c  = used by code executed in RAM
;         s  = used by stack
;         !  = page crossed, 1 cycle penalty

    processor 6502


;-----------------------------------------------------------
;      Color constants
;-----------------------------------------------------------

;BLACK            = $00
;YELLOW           = $10
;BROWN            = $20
;ORANGE           = $30
;RED              = $40
;MAUVE            = $50
;VIOLET           = $60
;PURPLE           = $70
;BLUE             = $80
;BLUE_CYAN        = $90
;CYAN             = $a0
;CYAN_GREEN       = $b0
;GREEN            = $c0
;GREEN_YELLOW     = $d0
;GREEN_BEIGE      = $e0
;BEIGE            = $f0


;-----------------------------------------------------------
;      TIA and IO constants accessed
;-----------------------------------------------------------

CXM0P           = $00  ; (R)
CXM1FB          = $05  ; (R)
CXPPMM          = $07  ; (R)
INPT4           = $0c  ; (R)
INPT5           = $0d  ; (R)

VSYNC           = $00  ; (W)
VBLANK          = $01  ; (W)
WSYNC           = $02  ; (W)
NUSIZ0          = $04  ; (W)
NUSIZ1          = $05  ; (W)
COLUP0          = $06  ; (W)
COLUP1          = $07  ; (W)
COLUPF          = $08  ; (W)
COLUBK          = $09  ; (W)
CTRLPF          = $0a  ; (W)
REFP0           = $0b  ; (W)
REFP1           = $0c  ; (W)
PF0             = $0d  ; (W)
PF1             = $0e  ; (W)
PF2             = $0f  ; (W)
RESP0           = $10  ; (W)
RESP1           = $11  ; (W)
;RESM0          = $12  ; (Wi)
;RESM1          = $13  ; (Wi)
RESBL           = $14  ; (W)
AUDC0           = $15  ; (W)
;AUDC1          = $16  ; (Wi)
AUDF0           = $17  ; (W)
;AUDF1          = $18  ; (Wi)
AUDV0           = $19  ; (W)
;AUDV1          = $1a  ; (Wi)
GRP0            = $1b  ; (W)
GRP1            = $1c  ; (W)
ENAM0           = $1d  ; (W)
ENAM1           = $1e  ; (W)
ENABL           = $1f  ; (W)
HMP0            = $20  ; (W)
HMP1            = $21  ; (W)
;HMM0           = $22  ; (Wi)
;HMM1           = $23  ; (Wi)
HMBL            = $24  ; (W)
VDELP0          = $25  ; (W)
VDELP1          = $26  ; (W)
HMOVE           = $2a  ; (W)
HMCLR           = $2b  ; (W)
CXCLR           = $2c  ; (W)

SWCHA           = $0280
SWCHB           = $0282
INTIM           = $0284
TIM64T          = $0296


;-----------------------------------------------------------
;      Additional constants from verboseraiders.asm
;-----------------------------------------------------------

SOUND_CHANNEL_SAW              = 1
SOUND_CHANNEL_ENGINE           = 3
SOUND_CHANNEL_SQUARE           = 4
SOUND_CHANNEL_BASS             = 6
SOUND_CHANNEL_PITFALL          = 7
SOUND_CHANNEL_NOISE            = 8
SOUND_CHANNEL_LEAD             = 12
SOUND_CHANNEL_BUZZ             = 15

LEAD_E4                         = 15
LEAD_D4                         = 17
LEAD_C4_SHARP                   = 18
LEAD_A3                         = 23
LEAD_E3_2                       = 31

BANK0TOP                       = $1000
BANK1TOP                       = $2000
BANK0_REORG                    = $d000
BANK1_REORG                    = $f000
BANK0STROBE                    = $fff8
BANK1STROBE                    = $fff9

LDA_ABS                        = $ad
JMP_ABS                        = $4c

INIT_SCORE                     = 100

SET_PLAYER_0_COLOR             = %10000000
SET_PLAYER_0_HMOVE             = %10000001

XMAX                           = 160

ID_TREASURE_ROOM               = 0
ID_MARKETPLACE                 = 1
ID_ENTRANCE_ROOM               = 2
ID_BLACK_MARKET                = 3
ID_MAP_ROOM                    = 4
ID_MESA_SIDE                   = 5
ID_TEMPLE_ENTRANCE             = 6
ID_SPIDER_ROOM                 = 7
ID_ROOM_OF_SHINING_LIGHT       = 8
ID_MESA_FIELD                  = 9
ID_VALLEY_OF_POISON            = 10
ID_THIEVES_DEN                 = 11
ID_WELL_OF_SOULS               = 12
ID_ARK_ROOM                    = 13

H_ARK_OF_THE_COVENANT          = 7
H_PEDESTAL                     = 15
H_INDY_SPRITE                  = 11
H_INVENTORY_SPRITES            = 8
H_PARACHUTE_INDY_SPRITE        = 15
H_THIEF                        = 16
H_KERNEL                       = 160

ENTRANCE_ROOM_CAVE_VERT_POS    = 9
ENTRANCE_ROOM_ROCK_VERT_POS    = 53

MAX_INVENTORY_ITEMS            = 6

INDY_CARRYING_WHIP             = %00000001
GRENADE_OPENING_IN_WALL        = %00000010
INDY_NOT_CARRYING_COINS        = %10000000
INDY_CARRYING_SHOVEL           = %00000001

BASKET_STATUS_MARKET_GRENADE   = %00000001
BASKET_STATUS_BLACK_MARKET_GRENADE = %00000010
BACKET_STATUS_REVOLVER         = %00001000
BASKET_STATUS_REVOLVER         = BACKET_STATUS_REVOLVER
BASKET_STATUS_COINS            = %00010000
BASKET_STATUS_KEY              = %00100000

PICKUP_ITEM_STATUS_WHIP        = %00000001
PICKUP_ITEM_STATUS_SHOVEL      = %00000010
PICKUP_ITEM_STATUS_HEAD_OF_RA  = %00000100
PICKUP_ITEM_STATUS_TIME_PIECE  = %00001000
PICKUP_ITEM_STATUS_HOUR_GLASS  = %00100000
PICKUP_ITEM_STATUS_ANKH        = %01000000
PICKUP_ITEM_STATUS_CHAI        = %10000000

PENALTY_GRENADE_OPENING        = 2
PENALTY_SHOOTING_THIEF         = 4
PENALTY_ESCAPE_SHINING_LIGHT_PRISON = 13
BONUS_USING_PARACHUTE          = 3
BONUS_LANDING_IN_MESA          = 3
BONUS_FINDING_YAR              = 5
BONUS_SKIP_MESA_FIELD          = 9
BONUS_FINDING_ARK              = 10
BONUS_USING_HEAD_OF_RA_IN_MAPROOM = 14

BULLET_OR_WHIP_ACTIVE          = %10000000
USING_GRENADE_OR_PARACHUTE     = %00000010


;-----------------------------------------------------------
;      RIOT RAM (zero-page) labels
;-----------------------------------------------------------

zero_page		= $00
scan_line          = $80 ; scanline
room_num          = $81 ; current screen id
frame_counter   = $82 ; frame count
time_of_day          = $83 ; seconds timer
ram_84          = $84; (c) ; bank switch LDA/loop count
ram_85          = $85; (c) ; bank strobe address/temp char
ram_86          = $86; (c) ; bank switch JMP instruction
ram_87          = $87; (c) ; bank switch JMP address
ram_88          = $88; (c) ; zp_88
ram_89          = $89; (c) ; zp_89
ram_8A          = $8a ; player input
ram_8B          = $8b ; zp_8B
ram_8C          = $8c ; zp_8C/action code
ram_8D          = $8d ; zp_8D
ram_8E          = $8e ; zp_8E
ram_8F          = $8f ; bullet/whip status
ram_90          = $90
ram_91          = $91
indy_dir          = $92
ram_93          = $93
ram_94          = $94 ; playfield control
ram_95          = $95 ; pickup status flags
ram_96          = $96
ram_97          = $97
ram_98          = $98
ram_99          = $99
ram_9A          = $9a
ram_9B          = $9b ; grenade detonation time
ram_9C          = $9c ; reset enable flag
ram_9D          = $9d ; major event flag
ram_9E          = $9e ; adventure points
lives_left      = $9f ; lives
num_bullets     = $a0 ; number of bullets
ram_A1          = $a1
ram_A2          = $a2
ram_A3          = $a3
diamond_h  = $a4
grenade_used          = $a5 ; grenade opening penalty
escape_hatch_used           = $a6 ; escaped shining light penalty
shovel_used          = $a7 ; finding ark bonus
parachute_used          = $a8 ; using parachute bonus
ankh_used          = $a9 ; skip to mesa field bonus
yar_found          = $aa ; finding Yar Easter egg bonus
ark_found          = $ab ; using Head of Ra in map room bonus
thief_shot          = $ac ; shooting thief penalty
mesa_entered          = $ad ; landing in mesa bonus
unknown_action          = $ae
ram_AF          = $af

ram_B1          = $b1 ; entrance room state
ram_B2          = $b2 ; black market state

ram_B4          = $b4
ram_B5          = $b5
ram_B6          = $b6
inv_slot1_lo          = $b7 ; inventory graphics pointer lo ($b7-$c2)
inv_slot1_hi          = $b8
inv_slot2_lo          = $b9
inv_slot2_hi          = $ba
inv_slot3_lo          = $bb
inv_slot3_hi          = $bc
inv_slot4_lo          = $bd
inv_slot4_hi          = $be
pwatch_state          = $bf
pwatch_Addr          = $c0
inv_slot6_lo          = $c1
inv_slot6_hi          = $c2
cursor_pos          = $c3 ; selected inventory index
ram_C4          = $c4 ; number of inventory items
current_inv          = $c5 ; selected inventory id
ram_C6          = $c6 ; basket items status
ram_C7          = $c7 ; pickup items status
enemy_x          = $c8 ; object horizontal positions
indy_x          = $c9 ; Indy horizontal position
ram_CA          = $ca
ram_CB          = $cb ; bullet/whip horizontal position
ram_CC          = $cc

enemy_y          = $ce ; object vertical positions
indy_y          = $cf ; Indy vertical position
ram_D0          = $d0 ; missile 0 vertical position
ram_D1          = $d1 ; bullet/whip vertical position
ram_D2          = $d2

ram_D4          = $d4
ram_D5          = $d5 ; snake vertical position
ram_D6          = $d6 ; timepiece graphic pointers ($d6-$d7)
ram_D7          = $d7
ram_D8          = $d8
indy_anim          = $d9 ; Indy graphic pointers ($d9-$da)
ram_DA          = $da
indy_h          = $db ; Indy sprite height
snake_y          = $dc ; player0 sprite height
emy_anim          = $dd ; player0 graphic pointers ($dd-$de)
ram_DE          = $de
ram_DF          = $df ; thieves direction and size ($df-$e2)
ram_E0          = $e0
PF1_data          = $e1 ; player0 TIA pointers / PF1 graphics
ram_E2          = $e2
PF2_data          = $e3 ; PF2 graphics / fine motion pointer
ram_E4          = $e4
ram_E5          = $e5 ; thieves HMOVE index / dungeon graphics
ram_E6          = $e6
ram_E7          = $e7
ram_E8          = $e8
ram_E9          = $e9
ram_EA          = $ea
ram_EB          = $eb
ram_EC          = $ec
ram_ED          = $ed
ram_EE          = $ee ; thieves horizontal positions ($ee-$f1)
;                 $ef  (i)
;                 $f0  (i)
;                 $f1  (i)
;                 $f2  (i)


;-----------------------------------------------------------
;      Label aliases from verboseraiders.asm
;-----------------------------------------------------------

scanline                        = scan_line
currentScreenId                 = room_num
frameCount                      = frame_counter
secondsTimer                    = time_of_day
bankSwitchingVariables          = ram_84
bankSwitchLDAInstruction        = bankSwitchingVariables
bankStrobeAddress               = ram_85
bankSwitchJMPInstruction        = ram_86
bankSwitchJMPAddress            = ram_87
loopCount                       = ram_84
tempCharHolder                  = ram_85
zp_88                           = ram_88
zp_89                           = ram_89
playerInput                     = ram_8A
zp_8B                           = ram_8B
zp_8C                           = ram_8C
zp_8D                           = ram_8D
zp_8E                           = ram_8E
bulletOrWhipStatus              = ram_8F
playfieldControl                = ram_94
pickupStatusFlags               = ram_95
grenadeDetinationTime           = ram_9B
grenadeDetonationTime           = ram_9B
resetEnableFlag                 = ram_9C
majorEventFlag                  = ram_9D
adventurePoints                 = ram_9E
lives                           = lives_left
numberOfBullets                 = num_bullets
grenadeOpeningPenalty           = grenade_used
escapedShiningLightPenalty      = escape_hatch_used
findingArkBonus                 = shovel_used
usingParachuteBonus             = parachute_used
skipToMesaFieldBonus            = ankh_used
findingYarEasterEggBonus        = yar_found
usingHeadOfRaInMapRoomBonus     = ark_found
shootingThiefPenalty            = thief_shot
landingInMesaBonus              = mesa_entered
entranceRoomState               = ram_B1
blackMarketState                = ram_B2
inventoryGraphicPointers        = inv_slot1_lo
selectedInventoryIndex          = cursor_pos
numberOfInventoryItems          = ram_C4
selectedInventoryId             = current_inv
basketItemsStatus               = ram_C6
pickupItemsStatus               = ram_C7
objectHorizPositions            = enemy_x
indyHorizPos                    = indy_x
bulletOrWhipHorizPos            = ram_CB
objectVertPositions             = enemy_y
topObjectVertPos                = enemy_y
shiningLightVertPos             = enemy_y
indyVertPos                     = indy_y
missile0VertPos                 = ram_D0
bulletOrWhipVertPos             = ram_D1
snakeVertPos                    = ram_D5
timePieceGraphicPointers        = ram_D6
player0ColorPointers            = timePieceGraphicPointers
indyGraphicPointers             = indy_anim
indySpriteHeight                = indy_h
player0SpriteHeight             = snake_y
player0GraphicPointers          = emy_anim
thievesDirectionAndSize         = ram_DF
bottomObjectVertPos             = ram_DF
whipVertPos                     = ram_DF
shovelVertPos                   = ram_DF
player0TIAPointers              = PF1_data
player0ColorPointer             = PF1_data
player0FineMotionPointer        = PF2_data
pf1GraphicPointers              = PF1_data
pf2GraphicPointers              = PF2_data
thievesHMOVEIndex               = ram_E5
dungeonGraphics                 = ram_E5
topOfDungeonGraphic             = ram_E5
thievesHorizPositions           = ram_EE

;                 $fc  (s)
;                 $fd  (s)
;                 $fe  (s)
;                 $ff  (s)


;-----------------------------------------------------------
;      User Defined Labels
;-----------------------------------------------------------

;Break           = $dd68


;***********************************************************
;      Bank 0 / 0..1
;***********************************************************

    SEG     CODE
    ORG     $0000
    RORG    $d000

;NOTE: 1st bank's vector points right at the cold start routine
    lda    $FFF8                   ;4 trigger 1st bank (no effect here, matching LDA in 2nd)
    
Ld003
    jmp     game_start                   ;3   =   3
    
Ld006
    ldx     #$04                    ;2   =   2
Ld008
    sta     WSYNC                   ;3   =   3 ; wait for next scan line
;---------------------------------------
    lda     enemy_x,x                ;4         ; get object's horizontal position
    tay                             ;2        
    lda     Ldb00,y                 ;4         ; get fine motion/coarse position value
    sta     HMP0,x                  ;4         ; set object's fine motion value
    and     #$0f                    ;2         ; mask off fine motion value
    tay                             ;2   =  18 ; move coarse move value to y
Ld015
    dey                             ;2        
    bpl     Ld015                   ;2/3      
    sta     RESP0,x                 ;4         ; set object's coarse position
    dex                             ;2        
    bpl     Ld008                   ;2/3      
    sta     WSYNC                   ;3   =  15 ; wait for next scan line
;---------------------------------------
    sta     HMOVE                   ;3        
    jmp     Ldf9c                   ;3   =   6
    
    .byte   $24,$31,$10,$34,$a6,$81,$e0,$0a ; $d024 (*)
    .byte   $90,$2e,$f0,$0f,$a5,$d1,$69,$01 ; $d02c (*)
    .byte   $4a,$4a,$4a,$4a,$aa,$a9,$08,$55 ; $d034 (*)
    .byte   $df,$95,$df,$a5,$8f,$10,$11,$29 ; $d03c (*)
    .byte   $7f,$85,$8f,$a5,$95,$29,$1f,$f0 ; $d044 (*)
    .byte   $03,$20,$e9,$dc,$a9,$40,$85,$95 ; $d04c (*)
    .byte   $a9,$7f,$85,$d1,$a9,$04,$85,$ac ; $d054 (*)
    .byte   $24,$35,$10,$4a,$a6,$81,$e0,$09 ; $d05c (*)
    .byte   $f0,$56,$e0,$06,$f0,$04,$e0,$08 ; $d064 (*)
    .byte   $d0,$3c,$a5,$d1,$e5,$d4,$4a,$4a ; $d06c (*)
    .byte   $f0,$11,$aa,$a4,$cb,$c0,$12,$90 ; $d074 (*)
    .byte   $27,$c0,$8d,$b0,$23,$a9,$00,$95 ; $d07c (*)
    .byte   $e5,$f0,$1d,$a5,$cb,$c9,$30,$b0 ; $d084 (*)
    .byte   $11,$e9,$10,$49,$1f,$4a,$4a,$aa ; $d08c (*)
    .byte   $bd,$5c,$dc,$25,$e5,$85,$e5,$4c ; $d094 (*)
    .byte   $a4,$d0,$e9,$71,$c9,$20,$90,$ed ; $d09c (*)
    .byte   $a0,$7f,$84,$8f,$84,$d1,$24,$35 ; $d0a4 (*)
    .byte   $50,$0e,$24,$93,$50,$0a,$a9,$5a ; $d0ac (*)
    .byte   $85,$d2,$85,$dc,$85,$8f,$85,$d1 ; $d0b4 (*)
    .byte   $24,$33,$50,$2d,$a6,$81,$e0,$06 ; $d0bc (*)
    .byte   $f0,$1c,$a5,$c5,$c9,$02,$f0,$21 ; $d0c4 (*)
    .byte   $24,$93,$10,$0a,$a5,$83,$29,$07 ; $d0cc (*)
    .byte   $09,$80,$85,$a1,$d0,$13,$50,$11 ; $d0d4 (*)
    .byte   $a9,$80,$85,$9d,$d0,$0b,$a5,$d6 ; $d0dc (*)
    .byte   $c9,$ba,$d0,$05,$a9,$0f,$20,$e9 ; $d0e4 (*)
    .byte   $dc,$a2,$05,$e4,$81,$d0,$3a,$24 ; $d0ec (*)
    .byte   $30,$10,$0f,$86,$cf,$a9,$0c,$85 ; $d0f4 (*)
    .byte   $81,$20,$78,$d8,$a9,$4c,$85,$c9 ; $d0fc (*)
    .byte   $d0,$25,$a6,$cf,$e0,$4f,$90,$21 ; $d104 (*)
    .byte   $a9,$0a,$85,$81,$20,$78,$d8,$a5 ; $d10c (*)
    .byte   $eb,$85,$df,$a5,$ec,$85,$cf,$a5 ; $d114 (*)
    .byte   $ed,$85,$c9,$a9,$fd,$25,$b4,$85 ; $d11c (*)
    .byte   $b4,$30,$04,$a9,$80,$85,$9d,$85 ; $d124 (*)
    .byte   $2c,$24,$37,$30,$0f,$a2,$00,$86 ; $d12c (*)
    .byte   $91,$ca,$86,$97,$26,$95,$18,$66 ; $d134 (*)
    .byte   $95,$4c,$b4,$d2,$a5,$81,$d0,$13 ; $d13c (*)
    .byte   $a5,$af,$29,$07,$aa,$bd,$78,$df ; $d144 (*)
    .byte   $20,$e9,$dc,$90,$ec,$a9,$01,$85 ; $d14c (*)
    .byte   $df,$d0,$e6,$0a,$aa,$bd,$9c,$dc ; $d154 (*)
    .byte   $48,$bd,$9b,$dc,$48,$60,$a5,$cf ; $d15c (*)
    .byte   $c9,$3f,$90,$22,$a5,$96,$c9,$54 ; $d164 (*)
    .byte   $d0,$53,$a5,$8c,$c5,$8b,$d0,$13 ; $d16c (*)
    .byte   $a9,$58,$85,$9c,$85,$9e,$20,$db ; $d174 (*)
    .byte   $dd,$a9,$0d,$85,$81,$20,$78,$d8 ; $d17c (*)
    .byte   $4c,$d8,$d3,$4c,$da,$d2,$a9,$0b ; $d184 (*)
    .byte   $d0,$06,$a9,$07,$d0,$02,$a9,$04 ; $d18c (*)
    .byte   $24,$95,$30,$29,$18,$20,$10,$da ; $d194 (*)
    .byte   $b0,$06,$38,$20,$10,$da,$90,$1d ; $d19c (*)
    .byte   $c0,$0b,$d0,$05,$66,$b2,$18,$26 ; $d1a4 (*)
    .byte   $b2,$a5,$95,$20,$59,$dd,$98,$09 ; $d1ac (*)
    .byte   $c0,$85,$95,$d0,$08,$a2,$00,$86 ; $d1b4 (*)
    .byte   $b6,$a9,$80,$85,$9d,$4c,$b4,$d2 ; $d1bc (*)
    .byte   $24,$b4,$70,$20,$10,$1e,$a5,$c9 ; $d1c4 (*)
    .byte   $c9,$2b,$90,$12,$a6,$cf,$e0,$27 ; $d1cc (*)
    .byte   $90,$0c,$e0,$2b,$b0,$08,$a9,$40 ; $d1d4 (*)
    .byte   $05,$b4,$85,$b4,$d0,$06,$a9,$03 ; $d1dc (*)
    .byte   $38,$20,$10,$da,$4c,$b4,$d2,$24 ; $d1e4 (*)
    .byte   $33,$10,$2b,$a4,$cf,$c0,$3a,$90 ; $d1ec (*)
    .byte   $0b,$a9,$e0,$25,$91,$09,$43,$85 ; $d1f4 (*)
    .byte   $91,$4c,$b4,$d2,$c0,$20,$90,$07 ; $d1fc (*)
    .byte   $a9,$00,$85,$91,$4c,$b4,$d2,$c0 ; $d204 (*)
    .byte   $09,$90,$f5,$a9,$e0,$25,$91,$09 ; $d20c (*)
    .byte   $42,$85,$91,$4c,$b4,$d2,$a5,$cf ; $d214 (*)
    .byte   $c9,$3a,$90,$04,$a2,$07,$d0,$0c ; $d21c (*)
    .byte   $a5,$c9,$c9,$4c,$b0,$04,$a2,$05 ; $d224 (*)
    .byte   $d0,$02,$a2,$0d,$a9,$40,$85,$93 ; $d22c (*)
    .byte   $a5,$83,$29,$1f,$c9,$02,$b0,$02 ; $d234 (*)
    .byte   $a2,$0e,$20,$43,$dd,$b0,$04,$8a ; $d23c (*)
    .byte   $20,$e9,$dc,$4c,$b4,$d2,$24,$33 ; $d244 (*)
    .byte   $30,$20,$a5,$c9,$c9,$50,$b0,$0e ; $d24c (*)
    .byte   $c6,$c9,$26,$b2,$18,$66,$b2,$a9 ; $d254 (*)
    .byte   $00,$85,$91,$4c,$b4,$d2,$a2,$06 ; $d25c (*)
    .byte   $a5,$83,$c9,$40,$b0,$d4,$a2,$07 ; $d264 (*)
    .byte   $d0,$d0,$a4,$cf,$c0,$44,$90,$0a ; $d26c (*)
    .byte   $a9,$e0,$25,$91,$09,$0b,$85,$91 ; $d274 (*)
    .byte   $d0,$e1,$c0,$20,$b0,$d9,$c0,$0b ; $d27c (*)
    .byte   $90,$d5,$a9,$e0,$25,$91,$09,$41 ; $d284 (*)
    .byte   $d0,$ec,$e6,$c9,$d0,$22,$a5,$cf ; $d28c (*)
    .byte   $c9,$3f,$90,$12,$a9,$0a,$20,$e9 ; $d294 (*)
    .byte   $dc,$90,$15,$66,$b1,$38,$26,$b1 ; $d29c (*)
    .byte   $a9,$42,$85,$df,$d0,$0a,$c9,$16 ; $d2a4 (*)
    .byte   $90,$04,$c9,$1f,$90,$02,$c6,$c9 ; $d2ac (*)
    .byte   $a5,$81,$0a,$aa,$24,$33,$10,$09 ; $d2b4 (*)
    .byte   $bd,$b6,$dc,$48,$bd,$b5,$dc,$48 ; $d2bc (*)
    .byte   $60,$bd,$d0,$dc,$48,$bd,$cf,$dc ; $d2c4 (*)
    .byte   $48,$60                         ; $d2cc (*)
    
Ld2ce
    lda     ram_DF                  ;3         * ; Load vertical position of an object (likely thief or Indy)
    sta     ram_EB                  ;3         * ; Store it to temp variable $EB (could be thief vertical position)
    lda     indy_y                  ;3         * ; get Indy's vertical position
    sta     ram_EC                  ;3         * ; Store to temp variable $EC
    lda     indy_x                  ;3         * ; 3
    sta     ram_ED                  ;3         * ; Store to temp variable $ED
    lda     #$05                    ;2         * ; Change screen to Mesa Side
    sta     room_num                  ;3         *
    jsr     Ld878                   ;6         *
    lda     #$05                    ;2         * ; 2
    sta     indy_y                  ;3         * ; Set Indy's vertical position on entry to Mesa Side
    lda     #$50                    ;2         * ; 2
    sta     indy_x                  ;3         * ; Set Indy's horizontal position on entry
    tsx                             ;2         * ; 2
    cpx     #$fe                    ;2         * ; 2
    bcs     Ld2ef                   ;2/3       * ; If X = $FE, jump to FailSafeToCollisionCheck (possibly collision or restore logic)
    rts                             ;6   =  51 * ; Otherwise, return
    
Ld2ef
    jmp     Ld374                   ;3   =   3 *
    
    .byte   $24,$b3,$30,$f9,$a9,$50,$85,$eb ; $d2f2 (*)
    .byte   $a9,$41,$85,$ec,$a9,$4c,$d0,$d6 ; $d2fa (*)
    .byte   $a4,$c9,$c0,$2c,$90,$12,$c0,$6b ; $d302 (*)
    .byte   $b0,$10,$a4,$cf,$c8,$c0,$1e,$90 ; $d30a (*)
    .byte   $02,$88,$88,$84,$cf,$4c,$64,$d3 ; $d312 (*)
    .byte   $c8,$c8,$88,$84,$c9,$d0,$43,$a9 ; $d31a (*)
    .byte   $02,$25,$b1,$f0,$0a,$a5,$cf,$c9 ; $d322 (*)
    .byte   $12,$90,$04,$c9,$24,$90,$39,$c6 ; $d32a (*)
    .byte   $c9,$d0,$2f,$a2,$1a,$a5,$c9,$c9 ; $d332 (*)
    .byte   $4c,$90,$02,$a2,$7d,$86,$c9,$a2 ; $d33a (*)
    .byte   $40,$86,$cf,$a2,$ff,$86,$e5,$a2 ; $d342 (*)
    .byte   $01,$86,$e6,$86,$e7,$86,$e8,$86 ; $d34a (*)
    .byte   $e9,$86,$ea,$d0,$0d,$a5,$92,$29 ; $d352 (*)
    .byte   $0f,$a8,$b9,$d5,$df,$a2,$01,$20 ; $d35a (*)
    .byte   $c0,$df,$a9,$05,$85,$a2,$d0,$0a ; $d362 (*)
    .byte   $26,$8a,$38,$b0,$03,$26,$8a,$18 ; $d36a (*)
    .byte   $66,$8a                         ; $d372 (*)
    
Ld374
    bit     CXM0P|$30               ;3         * ; check player collisions with missile0
    bpl     Ld396                   ;2/3       * ; branch if didn't collide with Indy
    ldx     room_num                  ;3         * ; get the current screen id
    cpx     #$07                    ;2         * ; Are we in the Spider Room?
    beq     Ld386                   ;2/3       * ; Yes,  go to ClearInputBit0ForSpiderRoom
    bcc     Ld396                   ;2/3       * ; If screen ID is lower than Spider Room, skip
    lda     #$80                    ;2         * ; Trigger a major event
    sta     ram_9D                  ;3         * ; 3
    bne     Ld390                   ;2/3 =  21 * ; unconditional branch
Ld386
    rol     ram_8A                  ;5         * ; Rotate input left, bit 7 ? carry
    sec                             ;2         * ; Set carry (overrides carry from rol)
    ror     ram_8A                  ;5         * ; Rotate right, carry -> bit 7 (bit 0 lost)
    rol     ram_B6                  ;5         * ; Rotate a status byte left (bit 7 ? carry)
    sec                             ;2         * ; Set carry (again overrides whatever came before)
    ror     ram_B6                  ;5   =  24 * ; Rotate right, carry -> bit 7 (bit 0 lost)
Ld390
    lda     #$7f                    ;2         *
    sta     ram_8E                  ;3         * ; Possibly related state or shadow position
    sta     ram_D0                  ;3   =   8 * ; Move missile0 offscreen (to y=127)
Ld396
    bit     ram_9A                  ;3         * ; Check status flags
    bpl     Ld3d8                   ;2/3       * ; If bit 7 is clear, skip (no grenade active?)
    bvs     Ld3a8                   ;2/3       * ; If bit 6 is set, jump (special case, maybe already exploded)
    lda     time_of_day                  ;3         * ; get seconds time value
    cmp     ram_9B                  ;3         * ; compare with grenade detination time
    bne     Ld3d8                   ;2/3       * ; branch if not time to detinate grenade
    lda     #$a0                    ;2         * ; 2
    sta     ram_D1                  ;3         * ; Move bullet/whip offscreen (simulate detonation?)
    sta     ram_9D                  ;3   =  23 * ; Trigger major event (explosion happened?)
Ld3a8
    lsr     ram_9A                  ;5         * ; Logical shift right: bit 0 -> carry
    bcc     Ld3d4                   ;2/3       * ; If bit 0 was clear, skip this (grenade effect not triggered)
    lda     #$02                    ;2         *
    sta     grenade_used                  ;3         * ; Apply penalty (e.g., reduce score)
    ora     ram_B1                  ;3         *
    sta     ram_B1                  ;3         * ; Mark the entrance room as having the grenade opening
    ldx     #$02                    ;2         *
    cpx     room_num                  ;3         *
    bne     Ld3bd                   ;2/3       * ; branch if not in the ENTRANCE_ROOM
    jsr     Ld878                   ;6   =  31 * ; Update visuals/state to reflect the wall opening
Ld3bd
    lda     ram_B5                  ;3         * ; 3
    and     #$0f                    ;2         *
    beq     Ld3d4                   ;2/3       * ; If no condition active, exit
    lda     ram_B5                  ;3         *
    and     #$f0                    ;2         * ; Clear lower nibble
    ora     #$01                    ;2         * ; Set bit 0 (indicate some triggered state)
    sta     ram_B5                  ;3         * ; Store updated state
    ldx     #$02                    ;2         *
    cpx     room_num                  ;3         *
    bne     Ld3d4                   ;2/3       * ; branch if not in the ENTRANCE_ROOM
    jsr     Ld878                   ;6   =  30 * ; Refresh screen visuals
Ld3d4
    sec                             ;2         *
    jsr     Lda10                   ;6   =   8 * ; carry set...take away selected item
Ld3d8
    lda     INTIM                   ;4        
    bne     Ld3d8                   ;2/3 =   6
Ld3dd
    lda     #$02                    ;2        
    sta     WSYNC                   ;3   =   5 ; wait for next scan line
;---------------------------------------
    sta     VSYNC                   ;3         ; start vertical sync (D1 = 1)
    lda     #$50                    ;2        
    cmp     ram_D1                  ;3        
    bcs     Ld3eb                   ;2/3      
    sta     ram_CB                  ;3   =  13 *
Ld3eb
    inc     frame_counter           ;Up the frame counter by 1        ; increment frame count
    lda     #$3f                    ;    
    and     frame_counter           ;Every 63 frames (?)    
    bne     Ld3fb                   ;      ; branch if roughly 60 frames haven't passed
    inc     time_of_day             ;Increse the time of day       ; increment every second
    lda     ram_A1                  ;3         ; If $A1 is positive, skip
    bpl     Ld3fb                   ;2/3      
    dec     ram_A1                  ;5   =  27 * ; Else, decrement it
Ld3fb
    sta     WSYNC                   ;3   =   3 ; Wait for start of next scanline
;---------------------------------------
    bit     ram_9C                  ;3        
    bpl     frame_start                   ;2/3      
    ror     SWCHB                   ;6         * ; rotate RESET to carry
    bcs     frame_start                   ;2/3       * ; branch if RESET not pressed
    jmp     game_start                   ;3   =  16 * ; If RESET was pressed, restart the game
    
frame_start
    sta     WSYNC                   ;Wait for first Sync  ; Sync with scanline (safely time video registers)
;---------------------------------------
    lda     #$00                    ;Load A for VSYNC pause    
    ldx     #$2c                    ;Load Timer for 
    sta     WSYNC                   ;3   =   7 ; last line of vertical sync
;---------------------------------------
    sta     VSYNC                   ;3         ; end vertical sync (D1 = 0)
    stx     TIM64T                  ;4         ; set timer for vertical blanking period
    ldx     ram_9D                  ;3        
    inx                             ;2         ; Increment counter
    bne     Ld42a                   ;2/3       ; If not overflowed, check initials display
    stx     ram_9D                  ;3         * ; Overflowed: zero -> set majorEventFlag to 0
    jsr     Ldddb                   ;6         * ; Call final score calculation
    lda     #$0d                    ;2         *
    sta     room_num                  ;3         *
    jsr     Ld878                   ;6   =  34 * ; Transition to Ark Room
Ld427
    jmp     Ld80d                   ;3   =   3 ; 3
    
Ld42a
    lda     room_num                  ;3         ; get the current screen id
    cmp     #$0d                    ;2        
    bne     Ld482                   ;2/3       ; branch if not in ID_ARK_ROOM
    lda     #$9c                    ;2        
    sta     ram_A3                  ;3         ; Likely sets a display timer or animation state
    ldy     yar_found                  ;3        
    beq     Ld44a                   ;2/3       ; If not in Yar's Easter Egg mode, skip
    bit     ram_9C                  ;3         *
    bmi     Ld44a                   ;2/3       * ; If resetEnableFlag has bit 7 set, skip
    ldx     #$ff                    ;2         *
    stx     inv_slot1_hi                  ;3         *
    stx     inv_slot2_hi                  ;3         *
    lda     #$46                    ;2         *
    sta     inv_slot1_lo                  ;3         *
    lda     #$01                    ;2         *
    sta     inv_slot2_lo                  ;3   =  40 *
Ld44a
    ldy     indy_y                  ;3         ; get Indy's vertical position
    cpy     #$7c                    ;2         ; 124 dev
    bcs     Ld465                   ;2/3       ; If Indy is below or at Y=$7C (124), skip
    cpy     ram_9E                  ;3        
    bcc     Ld45b                   ;2/3       ; If Indy is higher up than his point score, skip
    bit     INPT5|$30               ;3         * ; read action button from right controller
    bmi     Ld427                   ;2/3       * ; branch if action button not pressed
    jmp     game_start                   ;3   =  20 * ; RESET game if button *is* pressed
    
Ld45b
    lda     frame_counter                  ;3         ; get current frame count
    ror                             ;2         ; shift D0 to carry
    bcc     Ld427                   ;2/3       ; branch on even frame
    iny                             ;2         ; Move Indy down by 1 pixel
    sty     indy_y                  ;3        
    bne     Ld427                   ;2/3 =  14 ; unconditional branch
Ld465
    bit     ram_9C                  ;3         * ; Check bit 7 of resetEnableFlag
    bmi     Ld46d                   ;2/3       * ; If bit 7 is set, skip (reset enabled)
    lda     #$0e                    ;2         *
    sta     ram_A2                  ;3   =  10 * ; Set Indys state to 0E
Ld46d
    lda     #$80                    ;2         *
    sta     ram_9C                  ;3         * ; Set bit 7 to enable reset logic
    bit     INPT5|$30               ;3         * ; Check action button on right controller
    bmi     Ld427                   ;2/3       * ; If not pressed, skip
    lda     frame_counter                  ;3         * ; get current frame count
    and     #$0f                    ;2         * ; Limit to every 16th frame
    bne     Ld47d                   ;2/3       * ; If not at correct frame, skip
    lda     #$05                    ;2   =  19 *
Ld47d
    sta     ram_8C                  ;3         * ; Store action/state code
    jmp     reset_vars                   ;3   =   6 * ; Handle command
    
Ld482
    bit     ram_93                  ;3         *
    bvs     Ld489                   ;2/3 =   5 * ; If bit 6 set, jump to alternate path
Ld486
    jmp     Ld51c                   ;3   =   3 * ; Continue Ark Room or endgame logic
    
Ld489
    lda     frame_counter                  ;3         * ; get current frame count
    and     #$03                    ;2         * ; Only act every 4 frames
    bne     Ld501                   ;2/3!      * ; If not, skip
    ldx     snake_y                  ;3         * ; 3
    cpx     #$60                    ;2         * ; 2
    bcc     Ld4a5                   ;2/3       * ; If $DC < $60, branch (some kind of position or counter)
    bit     ram_9D                  ;3         *
    bmi     Ld486                   ;2/3       * ; If bit 7 is set, jump to continue logic
    ldx     #$00                    ;2         * ; Reset X
    lda     indy_x                  ;3         * ; 3
    cmp     #$20                    ;2         * ; 2
    bcs     Ld4a3                   ;2/3       * ; If Indy is right of x=$20, skip
    lda     #$20                    ;2   =  30 * ; 2
Ld4a3
    sta     ram_CC                  ;3   =   3 * ; Store Indys forced horizontal position?
Ld4a5
    inx                             ;2         * ; 2
    stx     snake_y                  ;3         * ; Increment and store progression step or counter
    txa                             ;2         * ; 2
    sec                             ;2         * ; 2
    sbc     #$07                    ;2         * ; Subtract 7 to control pacing
    bpl     Ld4b0                   ;2/3       * ; If result = 0, continue
    lda     #$00                    ;2   =  15 * ; Otherwise, reset A to 0
Ld4b0
    sta     ram_D2                  ;3         * ; Store A (probably from LD4A5) into $D2  possibly temporary Y position
    and     #$f8                    ;2         * ; 2
    cmp     ram_D5                  ;3         * ; 3
    beq     Ld501                   ;2/3!      * ; If vertical alignment hasnt changed, skip update
    sta     ram_D5                  ;3         * ; Update snakes vertical position
    lda     ram_D4                  ;3         * ; 3
    and     #$03                    ;2         * ; 2
    tax                             ;2         * ; 2
    lda     ram_D4                  ;3         * ; 3
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    tay                             ;2         * ; 2
    lda     Ldbff,x                 ;4         * ; 4
    clc                             ;2         * ; 2
    adc     Ldbff,y                 ;4         * ; Add two offset values from table at LDBFF
    clc                             ;2         * ; 2
    adc     ram_CC                  ;3         * ; Add forced Indy X position
    ldx     #$00                    ;2         *
    cmp     #$87                    ;2         * ; Apply Horizontal Constraints
    bcs     Ld4e2                   ;2/3       * ; If = $87, skip update
    cmp     #$18                    ;2         * ; 2
    bcc     Ld4de                   ;2/3       * ; If < $18, also skip update
    sbc     indy_x                  ;3         * ; 3
    sbc     #$03                    ;2         * ; 2
    bpl     Ld4e2                   ;2/3 =  61 * ; If result = 0, skip
Ld4de
    inx                             ;2         * ; X = 1
    inx                             ;2         * ; X = 2 (prepare alternate motion state)
    eor     #$ff                    ;2   =   6 * ; Flip delta (ones complement)
Ld4e2
    cmp     #$09                    ;2         *
    bcc     Ld4e7                   ;2/3       * ; If too close, skip speed/direction adjustment
    inx                             ;2   =   6 * ; Otherwise, refine behavior with additional increment
Ld4e7
    txa                             ;2         * ; 2
    asl                             ;2         * ; 2
    asl                             ;2         * ; 2
    sta     ram_84                  ;3         * ; Multiply X by 4 -> store as upper bits of state
    lda     ram_D4                  ;3         * ; 3
    and     #$03                    ;2         * ; 2
    tax                             ;2         * ; 2
    lda     Ldbff,x                 ;4         * ; 4
    clc                             ;2         * ; 2
    adc     ram_CC                  ;3         * ; 3
    sta     ram_CC                  ;3         * ; Refine target horizontal position
    lda     ram_D4                  ;3         * ; 3
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    ora     ram_84                  ;3         * ; 3
    sta     ram_D4                  ;3   =  41 * ; Store new composite motion/state byte
Ld501
    lda     ram_D4                  ;3         * ; 3
    and     #$03                    ;2         * ; 2
    tax                             ;2         * ; 2
    lda     Ldbfb,x                 ;4         * ; 4
    sta     ram_D6                  ;3         * ; Store horizontal movement/frame data
    lda     #$fa                    ;2         *
    sta     ram_D7                  ;3         * ; Store high byte of graphics or pointer address
    lda     ram_D4                  ;3         * ; 3
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    tax                             ;2         * ; 2
    lda     Ldbfb,x                 ;4         * ; 4
    sec                             ;2         * ; 2
    sbc     #$08                    ;2         * ; 2
    sta     ram_D8                  ;3   =  39 * ; Store vertical offset (with adjustment)
Ld51c
    bit     ram_9D                  ;3         * ; 3
    bpl     Ld523                   ;2/3       * ; If major event not complete, continue sequence
    jmp     Ld802                   ;3   =   8 * ; Else, jump to end/cutscene logic
    
Ld523
    bit     ram_A1                  ;3         * ; 3
    bpl     Ld52a                   ;2/3       * ; If timer still counting or inactive, proceed
    jmp     Ld78c                   ;3   =   8 * ; Else, jump to alternate script path (failure/end?)
    
Ld52a
    lda     frame_counter                  ;3         * ; get current frame count
    ror                             ;2         * ; ; Test even/odd frame
    bcc     Ld532                   ;2/3       * ; ; If even, continue next step
    jmp     Ld627                   ;3   =  10 * ; If odd, do something else
    
Ld532
    ldx     room_num                  ;3         * ; get the current screen id
    cpx     #$05                    ;2         *
    beq     Ld579                   ;2/3       * ; If on Mesa Side, use a different handler
    bit     ram_8D                  ;3         *
    bvc     Ld56e                   ;2/3       * ; If no event/collision flag set, skip
    ldx     ram_CB                  ;3         * ; get bullet or whip horizontal position
    txa                             ;2         * ; 2
    sec                             ;2         * ; 2
    sbc     indy_x                  ;3         * ; 3
    tay                             ;2         * ; Y = horizontal distance between Indy and projectile
    lda     SWCHA                   ;4         * ; read joystick values
    ror                             ;2         * ; shift right joystick UP value to carry
    bcc     Ld55b                   ;2/3       * ; branch if right joystick pushing up
    ror                             ;2         * ; shift right joystick DOWN value to carry
    bcs     Ld579                   ;2/3       * ; branch if right joystick not pushed down
    cpy     #$09                    ;2         *
    bcc     Ld579                   ;2/3       * ; If too close to projectile, skip
    tya                             ;2         *
    bpl     Ld556                   ;2/3 =  44 * ; If projectile is to the right of Indy, continue
Ld553
    inx                             ;2         * ; 2
    bne     Ld557                   ;2/3 =   4 * ; 2
Ld556
    dex                             ;2   =   2 * ; 2
Ld557
    stx     ram_CB                  ;3         *
    bne     Ld579                   ;2/3 =   5 * ; Exit if projectile has nonzero position
Ld55b
    cpx     #$75                    ;2         * ; 2
    bcs     Ld579                   ;2/3       * ; Right bound check
    cpx     #$1a                    ;2         * ; 2
    bcc     Ld579                   ;2/3       * ; Left bound check
    dey                             ;2         * ; 2
    dey                             ;2         * ; 2
    cpy     #$07                    ;2         * ; 2
    bcc     Ld579                   ;2/3       * ; Too close vertically
    tya                             ;2         * ; 2
    bpl     Ld553                   ;2/3       * ; If projectile right of Indy, nudge right
    bmi     Ld556                   ;2/3 =  22 * ; Else, nudge left
Ld56e
    bit     ram_B4                  ;3         * ; 3
    bmi     Ld579                   ;2/3       * ; If flag set, skip
    bit     ram_8A                  ;3         *
    bpl     Ld57c                   ;2/3       * ; If no button, skip
    ror                             ;2         * ; 2
    bcc     Ld57c                   ;2/3 =  14 * ; If wrong button, skip
Ld579
    jmp     Ld5e0                   ;3   =   3 * ; 3
    
Ld57c
    ldx     #$01                    ;2         * ; Get index of Indy in object list
    lda     SWCHA                   ;4         * ; read joystick values
    sta     ram_85                  ;3         * ; Store raw joystick input
    and     #$0f                    ;2         *
    cmp     #$0f                    ;2         *
    beq     Ld579                   ;2/3       * ; Skip if no movement
    sta     indy_dir                  ;3         * ; 3
    jsr     move_enemy                   ;6         * ; Move Indy according to input
    ldx     room_num                  ;3         * ; get the current screen id
    ldy     #$00                    ;2         * ; 2
    sty     ram_84                  ;3         * ; Reset scan index/counter
    beq     Ld599                   ;2/3 =  34 * ; Unconditional (Y=0, so BNE not taken)
Ld596
    tax                             ;2         * ; Transfer A to X (probably to use as an object index or ID)
    inc     ram_84                  ;5   =   7 * ; Increment $84  a general-purpose counter or index
Ld599
    lda     indy_x                  ;3         * ; 3
    pha                             ;3         * ; Temporarily store horizontal position
    lda     indy_y                  ;3         * ; get Indy's vertical position
    ldy     ram_84                  ;3         * ; Load current scan/event index
    cpy     #$02                    ;2         * ; 2
    bcs     Ld5ac                   ;2/3       * ; If index >= 2, store in reverse order
    sta     ram_86                  ;3         * ; Vertical position
    pla                             ;4         *
    sta     ram_87                  ;3         * ; Horizontal position
    jmp     Ld5b1                   ;3   =  29 *
    
Ld5ac
    sta     ram_87                  ;3         * ; Vertical -> $87
    pla                             ;4         *
    sta     ram_86                  ;3   =  10 * ; Horizontal -> $86
Ld5b1
    ror     ram_85                  ;5         * ; Rotate player input to extract direction
    bcs     Ld5d1                   ;2/3       * ; If carry set, skip
    jsr     Ld97c                   ;6         * ; Run event/collision subroutine
    bcs     Ld5db                   ;2/3       * ; If failed/blocked, exit
    bvc     Ld5d1                   ;2/3       * ; If no vertical/horizontal event flag, skip
    ldy     ram_84                  ;3         * ; Event index
    lda     Ldf6c,y                 ;4         * ; Get movement offset from table
    cpy     #$02                    ;2         * ; 2
    bcs     Ld5cc                   ;2/3       * ; If index = 2, move horizontally
    adc     indy_y                  ;3         * ; 3
    sta     indy_y                  ;3         * ; 3
    jmp     Ld5d1                   ;3   =  37 * ; 3
    
Ld5cc
    clc                             ;2         * ; 2
    adc     indy_x                  ;3         * ; 3
    sta     indy_x                  ;3   =   8 * ; 3
Ld5d1
    txa                             ;2         * ; 2
    clc                             ;2         * ; 2
    adc     #$0d                    ;2         * ; Offset for object range or screen width
    cmp     #$34                    ;2         * ; 2
    bcc     Ld596                   ;2/3       * ; If still within bounds, continue scanning
    bcs     Ld5e0                   ;2/3 =  12 * ; Else, exit
Ld5db
    sty     room_num                  ;3         * ; Set new screen based on event result
    jsr     Ld878                   ;6   =   9 * ; Load new room or area
Ld5e0
    bit     INPT4|$30               ;3         * ; read action button from left controller
    bmi     Ld5f5                   ;2/3       * ; branch if action button not pressed
    bit     ram_9A                  ;3         * ; 3
    bmi     Ld624                   ;2/3!      * ; If game state prevents interaction, skip
    lda     ram_8A                  ;3         *
    ror                             ;2         * ; Check bit 0 of input
    bcs     Ld5fa                   ;2/3       * ; If set, already mid-action, skip
    sec                             ;2         * ; Prepare to take item
    jsr     Lda10                   ;6         * ; carry set...take away selected item
    inc     ram_8A                  ;5         * ; Advance to next inventory slot
    bne     Ld5fa                   ;2/3 =  32 * ; Always branch
Ld5f5
    ror     ram_8A                  ;5         *
    clc                             ;2         * ; 2
    rol     ram_8A                  ;5   =  12 *
Ld5fa
    lda     ram_91                  ;3         * ; 3
    bpl     Ld624                   ;2/3!      * ; If no item queued, exit
    and     #$1f                    ;2         * ; Mask to get item ID
    cmp     #$01                    ;2         * ; 2
    bne     Ld60c                   ;2/3       * ; 2
    inc     num_bullets                  ;5         * ; Give Indy 3 bullets
    inc     num_bullets                  ;5         *
    inc     num_bullets                  ;5         *
    bne     Ld620                   ;2/3 =  28 * ; unconditional branch
Ld60c
    cmp     #$0b                    ;2         * ; 2
    bne     Ld61d                   ;2/3       * ; 2
    ror     ram_B2                  ;5         * ; rotate Black Market state right
    sec                             ;2         * ; set carry
    rol     ram_B2                  ;5         * ; rotate left to show Indy carrying Shovel
    ldx     #$45                    ;2         * ; 2
    stx     ram_DF                  ;3         * ; Set Y-pos for shovel on screen
    ldx     #$7f                    ;2         * ; 2
    stx     ram_D0                  ;3   =  26 *
Ld61d
    jsr     Ldce9                   ;6   =   6 *
Ld620
    lda     #$00                    ;2         * ; 2
    sta     ram_91                  ;3   =   5 * ; Clear item pickup/use state
Ld624
    jmp     Ld777                   ;3   =   3 * ; ; Return from event handle
    
Ld627
    bit     ram_9A                  ;3         * ; Test game state flags
    bmi     Ld624                   ;2/3       * ; If bit 7 is set (N = 1), then a grenade or parachute event is in progress.
    bit     INPT5|$30               ;3         * ; read action button from right controller
    bpl     Ld638                   ;2/3       * ; branch if action button pressed
    lda     #$fd                    ;2         * ; Load inverse of USING_GRENADE_OR_PARACHUTE (i.e., clear bit 1)
    and     ram_8A                  ;3         * ; ; Clear the USING_GRENADE_OR_PARACHUTE bit from the player input state
    sta     ram_8A                  ;3         * ; Store the updated input state
    jmp     Ld777                   ;3   =  21 *
    
Ld638
    lda     #$02                    ;2         * ; Load the flag indicating item use (grenade/parachute)
    bit     ram_8A                  ;3         * ; Check if the flag is already set in player input
    bne     Ld696                   ;2/3       * ; If it's already set, skip re-setting (item already active)
    ora     ram_8A                  ;3         * ; Otherwise, set the USING_GRENADE_OR_PARACHUTE bit
    sta     ram_8A                  ;3         * ; Save the updated input state
    ldx     current_inv                  ;3         * ; get the current selected inventory id
    cpx     #$05                    ;2         * ; Is the selected item the marketplace grenade?
    beq     Ld64c                   ;2/3       * ; If yes, jump to grenade activation logic
    cpx     #$06                    ;2         * ; If not, is it the black market grenade?
    bne     Ld671                   ;2/3 =  24 * ; If neither, check if it's a parachute
Ld64c
    ldx     indy_y                  ;3         * ; get Indy's vertical position
    stx     ram_D1                  ;3         * ; Set grenade's starting vertical position
    ldy     indy_x                  ;3         * ; get Indy horizontal position
    sty     ram_CB                  ;3         * ; Set grenade's starting horizontal position
    lda     time_of_day                  ;3         * ; get the seconds timer
    adc     #$04                    ;2         * ; increment value by 5...carry set
    sta     ram_9B                  ;3         * ; detinate grenade 5 seconds from now
    lda     #$80                    ;2         * ; Prepare base grenade state value (bit 7 set)
    cpx     #$35                    ;2         * ; Is Indy below the rock's vertical line?
    bcs     Ld66c                   ;2/3       * ; branch if Indy is under rock scanline
    cpy     #$64                    ;2         * ; Is Indy too far left?
    bcc     Ld66c                   ;2/3       *
    ldx     room_num                  ;3         * ; get the current screen id
    cpx     #$02                    ;2         * ; Are we in the Entrance Room?
    bne     Ld66c                   ;2/3       * ; branch if not in the ENTRANCE_ROOM
    ora     #$01                    ;2   =  39 * ; Set bit 0 to trigger wall explosion effect
Ld66c
    sta     ram_9A                  ;3         * ; Store the grenade state flags: Bit 7 set: grenade is active - Bit 0 optionally set: triggers wall explosion if conditions were met
    jmp     Ld777                   ;3   =   6 *
    
Ld671
    cpx     #$03                    ;2         * ; Is the selected item the parachute?
    bne     Ld68b                   ;2/3       * ; If not, branch to other item handling
    stx     parachute_used                  ;3         * ; Store the parachute usage flag for scoring bonus
    lda     ram_B4                  ;3         * ; Load major event and state flags
    bmi     Ld696                   ;2/3       * ; If bit 7 is set (already parachuting), skip reactivation
    ora     #$80                    ;2         * ; Set bit 7 to indicate parachute is now active
    sta     ram_B4                  ;3         * ; Save the updated event flags
    lda     indy_y                  ;3         * ; get Indy's vertical position
    sbc     #$06                    ;2         * ; Subtract 6 (carry is set by default), to move him slightly up
    bpl     Ld687                   ;2/3       * ; If the result is positive, keep it
    lda     #$01                    ;2   =  26 * ; If subtraction underflows, cap position to 1
Ld687
    sta     indy_y                  ;3         * ; 3
    bpl     Ld6d2                   ;2/3 =   5 * ; unconditional branch
Ld68b
    bit     ram_8D                  ;3         * ; Check special state flags (likely related to scripted events)
    bvc     Ld6d5                   ;2/3       * ; If bit 6 is clear (no vertical event active), skip to further checks
    bit     CXM1FB|$30              ;3         * ; Check collision between missile 1 and playfield
    bmi     Ld699                   ;2/3       * ; If collision occurred (bit 7 set), go to handle collision impact
    jsr     Ld2ce                   ;6   =  16 * ; No collision  warp Indy to Mesa Side (context-dependent event)
Ld696
    jmp     Ld777                   ;3   =   3 * ; 3
    
Ld699
    lda     ram_D1                  ;3         * ; get bullet or whip vertical position
    lsr                             ;2         * ; Divide by 2 (fine-tune for tile mapping)
    sec                             ;2         * ; Set carry for subtraction
    sbc     #$06                    ;2         * ; Subtract 6 (offset to align to tile grid)
    clc                             ;2         * ; Clear carry before next addition
    adc     ram_DF                  ;3         * ; Add reference vertical offset (likely floor or map tile start)
    lsr                             ;2         * ; Divide by 16 total:
    lsr                             ;2         * ; Effectively: (Y - 6 + $DF) / 16
    lsr                             ;2         *
    lsr                             ;2         *
    cmp     #$08                    ;2         * ; Check if the result fits within bounds (max 7)
    bcc     Ld6ac                   ;2/3       * ; If less than 8, jump to store the index
    lda     #$07                    ;2   =  28 * ; Clamp to max value (7) if out of bounds
Ld6ac
    sta     ram_84                  ;3         * ; Store the region index calculated from vertical position
    lda     ram_CB                  ;3         * ; get bullet or whip horizontal position
    sec                             ;2         * ; 2
    sbc     #$10                    ;2         * ; Adjust for impact zone alignment
    and     #$60                    ;2         * ; Mask to relevant bits (coarse horizontal zone)
    lsr                             ;2         *
    lsr                             ;2         * ; Divide by 4  convert to tile region
    adc     ram_84                  ;3         * ; Combine with vertical region index to form a unique map zone index
    tay                             ;2         * ; Move index to Y
    lda     Ldf7c,y                 ;4         * ; Load impact response from lookup table
    sta     ram_8B                  ;3         * ; Store result  likely affects state or visual of game field
    ldx     ram_D1                  ;3         * ; get bullet or whip vertical position
    dex                             ;2         * ; Decrease projectile X by 2  simulate impact offset
    stx     ram_D1                  ;3         *
    stx     indy_y                  ;3         * ; Sync Indy's horizontal position to projectiles new position
    ldx     ram_CB                  ;3         *
    dex                             ;2         * ; Decrease projectile X by 2  simulate impact offset
    dex                             ;2         *
    stx     ram_CB                  ;3         *
    stx     indy_x                  ;3         * ; Sync Indy's horizontal position to projectiles new position
    lda     #$46                    ;2         * ; Set special state value
    sta     ram_8D                  ;3   =  57 * ; Likely a flag used by event logic
Ld6d2
    jmp     Ld773                   ;3   =   3 * ; Jump to item-use or input continuation logic
    
Ld6d5
    cpx     #$0b                    ;2         * ; Is the selected item the shovel?
    bne     Ld6f7                   ;2/3       * ; If not, skip to other item handling
    lda     indy_y                  ;3         * ; get Indy's vertical position
    cmp     #$41                    ;2         * ; Is Indy deep enough to dig?
    bcc     Ld696                   ;2/3       * ; If not, exit (can't dig here)
    bit     CXPPMM|$30              ;3         * ; check player / missile collisions (probably shovel sprite contact with dig site)
    bpl     Ld696                   ;2/3       * ; branch if players didn't collide
    inc     ram_97                  ;5         * ; Increment dig attempt counter
    bne     Ld696                   ;2/3       * ; If not the first dig attempt, exit
    ldy     ram_96                  ;3         * ; Load current dig depth or animation frame
    dey                             ;2         * ; Decrease depth
    cpy     #$54                    ;2         * ; Is it still within range?
    bcs     Ld6ef                   ;2/3       * ; If at or beyond max depth, cap it
    iny                             ;2   =  34 * ; Otherwise restore it back (prevent negative values)
Ld6ef
    sty     ram_96                  ;3         * ; Save the clamped or unchanged dig depth value
    lda     #$0a                    ;2         *
    sta     shovel_used                  ;3         * ; Set the bonus for having found the Ark
    bne     Ld696                   ;2/3 =  10 * ; unconditional branch
Ld6f7
    cpx     #$10                    ;2         * ; Is the selected item the Ankh?
    bne     Ld71e                   ;2/3!      * ; If not, skip to next item handling
    ldx     room_num                  ;3         * ; get the current screen id
    cpx     #$00                    ;2         * ; Is Indy in the Treasure Room?
    beq     Ld696                   ;2/3!      * ; If so, don't allow Ankh warp from here
    lda     #$09                    ;2         * ; Mark this warp use (likely applies 9-point score penalty)
    sta     ankh_used                  ;3         * ; set to reduce score by 9 points
    sta     room_num                  ;3         * ; Change current screen to Mesa Field
    jsr     Ld878                   ;6         * ; Load the data for the new screen
    lda     #$4c                    ;2         * ; Prepare a flag or state value for later use (e.g., warp effect)
    sta     indy_x                  ;3         * ; Set Indy's horizontal position
    sta     ram_CB                  ;3         * ; Set projectile's horizontal position (same as Indy)
    lda     #$46                    ;2         * ; Fixed vertical position value (start of Mesa Field?)
    sta     indy_y                  ;3         * ; Set Indy's vertical position
    sta     ram_D1                  ;3         * ; Set projectile's vertical position
    sta     ram_8D                  ;3         * ; Set event/state flag (used later to indicate transition or animation)
    lda     #$1d                    ;2         * ; Set initial vertical scroll or map offset?
    sta     ram_DF                  ;3         * ; Likely adjusts tile map base Y
    bne     Ld777                   ;2/3 =  51 * ; Unconditional jump to common handler
Ld71e
    lda     SWCHA                   ;4         * ; read joystick values
    and     #$0f                    ;2         * ; Mask to isolate movement bits
    cmp     #$0f                    ;2         *
    beq     Ld777                   ;2/3       * ; branch if right joystick not moved
    cpx     #$0d                    ;2         *
    bne     Ld747                   ;2/3       * ; check for Indy using whip
    bit     ram_8F                  ;3         * ; check bullet or whip status
    bmi     Ld777                   ;2/3       * ; branch if bullet active
    ldy     num_bullets                  ;3         * ; get number of bullets remaining
    bmi     Ld777                   ;2/3       * ; branch if no more bullets
    dec     num_bullets                  ;5         * ; reduce number of bullets
    ora     #$80                    ;2         *
    sta     ram_8F                  ;3         * ; set BULLET_OR_WHIP_ACTIVE bit
    lda     indy_y                  ;3         * ; get Indy's vertical position
    adc     #$04                    ;2         * ; Offset to spawn bullet slightly above Indy
    sta     ram_D1                  ;3         * ; Set bullet Y position
    lda     indy_x                  ;3         *
    adc     #$04                    ;2         * ; Offset to spawn bullet slightly ahead of Indy
    sta     ram_CB                  ;3         * ; Set bullet X position
    bne     Ld773                   ;2/3 =  52 * ; unconditional branch
Ld747
    cpx     #$0a                    ;2         * ; Is Indy using the whip?
    bne     Ld777                   ;2/3       * ; branch if Indy not using whip
    ora     #$80                    ;2         * ; Set a status bit (probably to indicate whip action)
    sta     ram_8D                  ;3         * ; Store it in the game state/event flags
    ldy     #$04                    ;2         * ; Default vertical offset (X)
    ldx     #$05                    ;2         * ; Default horizontal offset (Y)
    ror                             ;2         * ; shift MOVE_UP to carry
    bcs     Ld758                   ;2/3       * ; branch if not pushed up
    ldx     #$fa                    ;2   =  19 * ; If pressing up, set vertical offset
Ld758
    ror                             ;2         * ; shift MOVE_DOWN to carry
    bcs     Ld75d                   ;2/3       * ; branch if not pushed down
    ldx     #$0f                    ;2   =   6 * ; If pressing down, set vertical offset
Ld75d
    ror                             ;2         * ; shift MOVE_LEFT to carry
    bcs     Ld762                   ;2/3       * ; branch if not pushed left
    ldy     #$f7                    ;2   =   6 * ; If pressing left, set horizontal offset
Ld762
    ror                             ;2         * ; shift MOVE_RIGHT to carry
    bcs     Ld767                   ;2/3       * ; branch if not pushed right
    ldy     #$10                    ;2   =   6 * ; If pressing right, set horizontal offset
Ld767
    tya                             ;2         * ; Move horizontal offset (Y) into A
    clc                             ;2         *
    adc     indy_x                  ;3         *
    sta     ram_CB                  ;3         * ; Add to Indys current horizontal position
    txa                             ;2         * ; 2				 ; Move vertical offset (X) into A
    clc                             ;2         * ; 2
    adc     indy_y                  ;3         * ; Add to Indys current vertical position
    sta     ram_D1                  ;3   =  20 * ; Set whip strike vertical position
Ld773
    lda     #$0f                    ;2         * ; Set effect timer or flag for whip (e.g., 15 frames)
    sta     ram_A3                  ;3   =   5 * ; Likely used to animate or time whip visibility/effect
Ld777
    bit     ram_B4                  ;3         * ; Check game status flags
    bpl     Ld783                   ;2/3       * ; If parachute bit (bit 7) is clear, skip parachute rendering
    lda     #$63                    ;2         * ; Load low byte of parachute sprite address
    sta     indy_anim                  ;3         * ; Set Indy's sprite pointer
    lda     #$0f                    ;2         * ; Load height for parachuting sprite
    bne     Ld792                   ;2/3 =  14 * ; unconditional branch
Ld783
    lda     SWCHA                   ;4         * ; read joystick values
    and     #$0f                    ;2         * ; Mask movement input
    cmp     #$0f                    ;2         *
    bne     Ld796                   ;2/3 =  10 * ; If any direction is pressed, skip (Indy is moving)
Ld78c
    lda     #$58                    ;2   =   2 * ; Load low byte of pointer to stationary sprite
Ld78e
    sta     indy_anim                  ;3         * ; Store sprite pointer (low byte)
    lda     #$0b                    ;2   =   5 * ; Load height for standard Indy sprite
Ld792
    sta     indy_h                  ;3         * ; Store sprite height
    bne     Ld7b2                   ;2/3 =   5 * ; unconditional branch
Ld796
    lda     #$03                    ;2         * ; Mask to isolate movement input flags (e.g., up/down/left/right)
    bit     ram_8A                  ;3         *
    bmi     Ld79d                   ;2/3       * ; If bit 7 (UP) is set, skip right shift
    lsr                             ;2   =   9 * ; Shift movement bits (to vary animation speed/direction)
Ld79d
    and     frame_counter                  ;3         * ; Use frameCount to time animation updates
    bne     Ld7b2                   ;2/3       * ; If result is non-zero, skip sprite update this frame
    lda     #$0b                    ;2         * ; Load base sprite height
    clc                             ;2         *
    adc     indy_anim                  ;3         * ; Advance to next sprite frame
    cmp     #$58                    ;2         * ; Check if we've reached the end of walking frames
    bcc     Ld78e                   ;2/3       * ; If not yet at stationary, update sprite pointer
    lda     #$02                    ;2         * ; Set a short animation timer
    sta     ram_A3                  ;3         * ; 3
    lda     #$00                    ;2         * ; ; Reset animation back to first walking frame
    bcs     Ld78e                   ;2/3 =  25 * ; Unconditional jump to store new sprite pointer
Ld7b2
    ldx     room_num                  ;3         * ; get the current screen id
    cpx     #$09                    ;2         * ; Load current screen ID
    beq     Ld7bc                   ;2/3       * ; If yes, check sinking conditions
    cpx     #$0a                    ;2         * ; If yes, check sinking conditions
    bne     Ld802                   ;2/3!=  11 * ; If neither, skip this routine
Ld7bc
    lda     frame_counter                  ;3         * ; get current frame count
    bit     ram_8A                  ;3         *
    bpl     Ld7c3                   ;2/3       * ; If bit 7 of playerInput is clear (not pushing up?), apply shift
    lsr                             ;2   =  10 * ; Adjust animation or action pacing
Ld7c3
    ldy     indy_y                  ;3         * ; get Indy's vertical position
    cpy     #$27                    ;2         * ; Is he at the sinking zone Y-level?
    beq     Ld802                   ;2/3!      * ; If so, skip (already sunk enough)
    ldx     ram_DF                  ;3         * ; Load terrain deformation or sink offset?
    bcs     Ld7e8                   ;2/3       * ; If carry is set from earlier BIT, go to advanced sink
    beq     Ld802                   ;2/3!      * ; If $DF is 0, no further sinking
    inc     indy_y                  ;5         * ; Sink Indy vertically
    inc     ram_D1                  ;5         * ; Sink the projectile too
    and     #$02                    ;2         * ; Control sinking frequency
    bne     Ld802                   ;2/3!      * ; Skip if odd/even frame constraint not me
    dec     ram_DF                  ;5         * ; Reduce sink counter
    inc     enemy_y                  ;5         * ; Possibly animation or game state flag
    inc     ram_D0                  ;5         * ; Sink a visible element (perhaps parachute/missile sprite)
    inc     ram_D2                  ;5         * ; Another state tracker
    inc     enemy_y                  ;5         *
    inc     ram_D0                  ;5         * ; Repeated to simulate multi-phase sinking
    inc     ram_D2                  ;5         * ; 5
    jmp     Ld802                   ;3   =  66 * ; Continue normal processing
    
Ld7e8
    cpx     #$50                    ;2         * ; Check if Indy has reached the upper bound for rising
    bcs     Ld802                   ;2/3!      * ; If Indy is already high enough, skip
    dec     indy_y                  ;5         * ; Move Indy upward
    dec     ram_D1                  ;5         * ; Move projectile upward as well
    and     #$02                    ;2         * ; Use timing mask to control frame-based rise rate
    bne     Ld802                   ;2/3!      * ; If not aligned, skip this update
    inc     ram_DF                  ;5         * ; Increase sink offset counter (reversing descent)
    dec     enemy_y                  ;5         * ; Adjust state/animation back
    dec     ram_D0                  ;5         * ; Move visible missile/sprite upward
    dec     ram_D2                  ;5         * ; Update related state
    dec     enemy_y                  ;5         *
    dec     ram_D0                  ;5         *
    dec     ram_D2                  ;5   =  53 * ; Mirror the changes made in the sinking routine
Ld802
    lda     #$28                    ;2         * ; Load low byte of destination routine in Bank 1
    sta     ram_88                  ;3         *
    lda     #$f5                    ;2         * ; Load high byte of destination
    sta     ram_89                  ;3         *
    jmp     Ldfad                   ;3   =  13 * ; Perform the bank switch and jump to new code
    
Ld80d
    lda     ram_99                  ;3         ; Check status flag (likely screen initialization)
    beq     Ld816                   ;2/3       ; If zero, skip subroutine
    jsr     Ldd59                   ;6         * ; Run special screen setup routine (e.g., reset state or clear screen)
    lda     #$00                    ;2   =  13 * ; Clear the flag afterward
Ld816
    sta     ram_99                  ;3         ; Store the updated flag
    ldx     room_num                  ;3         ; get the current screen id
    lda     Ldb00,x                 ;4        
    sta     NUSIZ0                  ;3         ; Set object sizing/horizontal motion control
    lda     ram_94                  ;3        
    sta     CTRLPF                  ;3         ; Set playfield control flags
    lda     Ldba0,x                 ;4        
    sta     COLUBK                  ;3         ; set current screen background color
    lda     Ldbae,x                 ;4        
    sta     COLUPF                  ;3         ; set current screen playfield color
    lda     Ldbc3,x                 ;4        
    sta     COLUP0                  ;3         ; Set Player 0 (usually enemies or projectiles) color
    lda     Ldbbc,x                 ;4        
    sta     COLUP1                  ;3        
    cpx     #$0b                    ;2        
    bcc     Ld84b                   ;2/3      
    lda     #$20                    ;2        
    sta     ram_D4                  ;3         ; Possibly enemy counter, timer, or position marker
    ldx     #$04                    ;2   =  58
Ld841
    ldy     ram_E5,x                ;4        
    lda     Ldb00,y                 ;4        
    sta     ram_EE,x                ;4        
    dex                             ;2        
    bpl     Ld841                   ;2/3 =  16 ; Loop through all Thieves' Den enemy positions
Ld84b
    jmp     Ld006                   ;3   =   3
    
Ld84e
    lda     #$4d                    ;2         ; Set Indy's horizontal position in the Ark Room
    sta     indy_x                  ;3         ; 3
    lda     #$48                    ;2         ; 2
    sta     enemy_x                  ;3         ; Unknown, likely related to screen offset or trigger state
    lda     #$1f                    ;2         ; 2
    sta     indy_y                  ;3         ; Set Indy's vertical position in the Ark Room
    rts                             ;6   =  21 ; Return from subroutine
    
Ld85b
    ldx     #$00                    ;2         * ; Start at index 0
    txa                             ;2   =   4 * ; A = 0 (will be used to clear memory)
Ld85e
    sta     ram_DF,x                ;4         * ; Clear/reset memory at $DF$E4
    sta     ram_E0,x                ;4         *
    sta     PF1_data,x                ;4         *
    sta     ram_E2,x                ;4         *
    sta     PF2_data,x                ;4         *
    sta     ram_E4,x                ;4         *
    txa                             ;2         * ; Check accumulator value
    bne     Ld873                   ;2/3       * ; If A ? 0, exit (used for conditional init)
    ldx     #$06                    ;2         * ; Prepare to re-run loop with X = 6
    lda     #$14                    ;2         * ; Now set A = 20 (used for secondary initialization)
    bne     Ld85e                   ;2/3 =  34 * ; Unconditional loop to write new value
Ld873
    lda     #$fc                    ;2         * ; Load setup value (likely a countdown, position, or state flag)
    sta     ram_D7                  ;3         * ; Store it to a specific control variable
    rts                             ;6   =  11 * ; Return from subroutine
    
Ld878
    lda     ram_9A                  ;3         ; Load player item state / status flags
    bpl     Ld880                   ;2/3       ; If bit 7 is clear (no grenade/parachute active), skip flag set
    ora     #$40                    ;2         * ; Set bit 6: possibly "re-entering room" or "just warped"
    sta     ram_9A                  ;3   =  10 * ; Save updated status
Ld880
    lda     #$5c                    ;2         ; Likely a vertical offset or a default Y-position baseline
    sta     ram_96                  ;3         ; Used for digging or vertical alignment mechanics
    ldx     #$00                    ;2         ; Clear various status bytes
    stx     ram_93                  ;3         ; Could be a cutscene or transition state
    stx     ram_B6                  ;3         ; Possibly enemy or item slot usage
    stx     ram_8E                  ;3         ; May control animation phase or enemy flags
    stx     ram_90                  ;3         ; Could be Indy or enemy action lock
    lda     ram_95                  ;3         ; Read item collection flags
    stx     ram_95                  ;3         ; Clear them all (reset pickups for new screen)
    jsr     Ldd59                   ;6         ; General-purpose screen initialization/reset routine
    rol     ram_8A                  ;5         ; Rotate input flags  possibly to mask off an "item use" bit
    clc                             ;2         ; 2
    ror     ram_8A                  ;5         ; Reverse the bit rotation; keeps input state consistent
    ldx     room_num                  ;3         ; Load which room Indy is in
    lda     Ldb92,x                 ;4        
    sta     ram_94                  ;3         ; Set up playfield reflection, score display, priorities
    cpx     #$0d                    ;2        
    beq     Ld84e                   ;2/3       ; Setup special Ark Room spawn point
    cpx     #$05                    ;2         *
    beq     Ld8b1                   ;2/3       *
    cpx     #$0c                    ;2         *
    beq     Ld8b1                   ;2/3       *
    lda     #$00                    ;2         *
    sta     ram_8B                  ;3   =  70 * ; General-purpose flag for room state, cleared by default
Ld8b1
    lda     Ldbee,x                 ;4         * ; 4
    sta     emy_anim                  ;3         * ; Set low byte of sprite pointer for P0 (non-Indy)
    lda     Ldbe1,x                 ;4         * ; 4
    sta     ram_DE                  ;3         * ; Set high byte of sprite pointer for P0
    lda     Ldbc9,x                 ;4         * ; 4
    sta     snake_y                  ;3         * ; Set height of the sprite (e.g., enemy size)
    lda     Ldbd4,x                 ;4         * ; 4
    sta     enemy_x                  ;3         * ; Likely a screen property (enemy group type, warp flag)
    lda     Ldc0e,x                 ;4         * ; 4
    sta     ram_CA                  ;3         * ; Possibly related to object spawning
    lda     Ldc1b,x                 ;4         * ; 4
    sta     ram_D0                  ;3         * ; Position for environmental object (missile0 = visual fx)
    cpx     #$0b                    ;2         *
    bcs     Ld85b                   ;2/3       * ; If this is Thieves Den or later, clear additional state
    adc     Ldc03,x                 ;4         * ; 4
    sta     ram_E0                  ;3         * ; 3					; Special room behavior index or environmental parameter
    lda     Ldc28,x                 ;4         * ; 4
    sta     PF1_data                  ;3         * ; PF1 low byte
    lda     Ldc33,x                 ;4         * ; 4
    sta     ram_E2                  ;3         * ; PF1 high byte
    lda     Ldc3e,x                 ;4         * ; 4
    sta     PF2_data                  ;3         * ; PF2 low byte
    lda     Ldc49,x                 ;4         * ; 4
    sta     ram_E4                  ;3         * ; PF2 high byte
    lda     #$55                    ;2         * ; 2
    sta     ram_D2                  ;3         * ; Likely a default animation frame or sound cue value
    sta     ram_D1                  ;3         * ; Default vertical position for bullets/whips
    cpx     #$06                    ;2         *
    bcs     Ld93e                   ;2/3!      * ; Jump past object position logic if in later screens
    lda     #$00                    ;2         * ; Clear out default vertical offset value
    cpx     #$00                    ;2         *
    beq     Ld91b                   ;2/3!      *
    cpx     #$02                    ;2         *
    beq     Ld92a                   ;2/3       *
    sta     enemy_y                  ;3   = 106 * ; Default vertical position for objects (top of screen)
Ld902
    ldy     #$4f                    ;2         * ; Default environmental sink or vertical state
    cpx     #$02                    ;2         *
    bcc     Ld918                   ;2/3       * ; If before Entrance Room, use default Y
    lda     ram_AF,x                ;4         * ; 4
    ror                             ;2         * ; Check a control bit from table (could enable falling)
    bcc     Ld918                   ;2/3       * ; If not set, use default
    ldy     Ldf72,x                 ;4         * ; 4					; Load alternate vertical offset from table
    cpx     #$03                    ;2         *
    bne     Ld918                   ;2/3       * ; Only override object height if in Black Market
    lda     #$ff                    ;2         * ; 2
    sta     ram_D0                  ;3   =  27 * ; Hide missile object by placing it off-screen
Ld918
    sty     ram_DF                  ;3         * ; Finalize vertical object/environment state
    rts                             ;6   =   9 * ; Return from screen initialization
    
Ld91b
    lda     ram_AF                  ;3         * ; Load screen control byte
    and     #$78                    ;2         * ; Mask off all but bits 36 (preserve mid flags, clear others)
    sta     ram_AF                  ;3         * ; Save the updated control state
    lda     #$1a                    ;2         *
    sta     enemy_y                  ;3         * ; Set vertical position for the top object
    lda     #$26                    ;2         * ; 2
    sta     ram_DF                  ;3         * ; Set vertical position for the bottom object
    rts                             ;6   =  24 * ; Return
    
Ld92a
    lda     ram_B1                  ;3         *
    and     #$07                    ;2         *
    lsr                             ;2         * ; shift value right
    bne     Ld935                   ;2/3       * ; branch if wall opening present in Entrance Room
    ldy     #$ff                    ;2         * ; 2
    sty     ram_D0                  ;3   =  14 *
Ld935
    tay                             ;2         * ; Transfer A (index) to Y
    lda     Ldf70,y                 ;4         * ; Look up Y-position for Entrance Room's top object
    sta     enemy_y                  ;3         * ; Set the object's vertical position
    jmp     Ld902                   ;3   =  12 * ; Continue the screen setup process
    
Ld93e
    cpx     #$08                    ;2         * ; Check if current room is "Room of Shining Light"
    beq     Ld950                   ;2/3       * ; If so, jump to its specific init routine
    cpx     #$06                    ;2         * ; If not, is it the Temple Entrance?
    bne     Ld968                   ;2/3       * ; If neither, skip this routine
    ldy     #$00                    ;2         * ; 2
    sty     ram_D8                  ;3         * ; Clear some dungeon-related state variable
    ldy     #$40                    ;2         * ; 2
    sty     ram_E5                  ;3         * ; Set visual reference for top-of-dungeon graphics
    bne     Ld958                   ;2/3 =  20 * ; Always taken
Ld950
    ldy     #$ff                    ;2         * ; 2
    sty     ram_E5                  ;3         * ; Top of dungeon should render with full brightness/effect
    iny                             ;2         * ; y = 0
    sty     ram_D8                  ;3         * ; Possibly clear temple or environmental state
    iny                             ;2   =  12 * ; y = 1
Ld958
    sty     ram_E6                  ;3         * ; Set dungeon tiles to base values
    sty     ram_E7                  ;3         *
    sty     ram_E8                  ;3         *
    sty     ram_E9                  ;3         *
    sty     ram_EA                  ;3         *
    ldy     #$39                    ;2         * ; 2
    sty     ram_D4                  ;3         * ; Likely a counter or timer
    sty     ram_D5                  ;3   =  23 * ; Set snake enemy Y-position baseline
Ld968
    cpx     #$09                    ;2         *
    bne     Ld977                   ;2/3       * ; If not Mesa Field, skip
    ldy     indy_y                  ;3         * ; get Indy's vertical position
    cpy     #$49                    ;2         * ; 2
    bcc     Ld977                   ;2/3       * ; If Indy is above threshold, no sinking
    lda     #$50                    ;2         * ; 2
    sta     ram_DF                  ;3         * ; Set environmental sink value  starts Indy sinking
    rts                             ;6   =  22 * ; return
    
Ld977
    lda     #$00                    ;2         *
    sta     ram_DF                  ;3         * ; Clear the environmental sink value (Indy won't sink)
    rts                             ;6   =  11 * ; Return to caller (completes screen init)
    
Ld97c
    ldy     Lde00,x                 ;4         * ; Load room override index based on current screen ID
    cpy     ram_86                  ;3         * ; Compare with current override key or control flag
    beq     Ld986                   ;2/3       * ; If it matches, apply special overrides
    clc                             ;2         * ; Clear carry (no override occurred)
    clv                             ;2         * ; Clear overflow (in case its used for flag-based branching)
    rts                             ;6   =  19 * ; Exit with no overrides
    
Ld986
    ldy     Lde34,x                 ;4         * ; Load vertical override flag
    bmi     Ld99b                   ;2/3 =   6 * ; If negative, skip overrides and return with SEC
Ld98b
    lda     Ldf04,x                 ;4         * ; Load vertical position override (if any)
    beq     Ld992                   ;2/3 =   6 * ; If zero, skip vertical positioning
Ld990
    sta     indy_y                  ;3   =   3 * ; Apply vertical override to Indy
Ld992
    lda     Ldf38,x                 ;4         * ; Load horizontal position override (if any)
    beq     Ld999                   ;2/3       * ; If zero, skip horizontal positioning
    sta     indy_x                  ;3   =   9 * ; Apply horizontal override to Indy
Ld999
    sec                             ;2         * ; Set carry to indicate an override was applied
    rts                             ;6   =   8 * ; Return to caller
    
Ld99b
    iny                             ;2         * ; Bump Y from previous LDE34 value
    beq     Ld9f9                   ;2/3       * ; If it was $FF, return early
    iny                             ;2         *
    bne     Ld9b6                   ;2/3       * ; If not $FE, jump to advanced evaluation
	; Case where Y = $FE
    ldy     Lde68,x                 ;4         * ; Load lower horizontal boundary
    cpy     ram_87                  ;3         * ; Compare with current horizontal state
    bcc     Ld9af                   ;2/3       * ; If below lower limit, use another check
    ldy     Lde9c,x                 ;4         * ; Load upper horizontal boundary
    bmi     Ld9c7                   ;2/3       * ; If negative, apply default vertical
    bpl     Ld98b                   ;2/3 =  25 * ; Always taken  go check vertical override normally
Ld9af
    ldy     Lded0,x                 ;4         * ; Load alternate override flag
    bmi     Ld9c7                   ;2/3       * ; If negative, jump to handle special override
    bpl     Ld98b                   ;2/3 =   8 * ; Always taken
Ld9b6
    lda     ram_87                  ;3         * ; Load current horizontal position
    cmp     Lde68,x                 ;4         * ; Compare with lower limit
    bcc     Ld9f9                   ;2/3       *
    cmp     Lde9c,x                 ;4         * ; Compare with upper limit
    bcs     Ld9f9                   ;2/3       *
    ldy     Lded0,x                 ;4         * ; Load override control byte
    bpl     Ld98b                   ;2/3 =  21 * ; If positive, allow override
Ld9c7
    iny                             ;2         *
    bmi     Ld9d4                   ;2/3       * ; If negative, special flag check
    ldy     #$08                    ;2         * ; Use a fixed override value
    bit     ram_AF                  ;3         * ; Check room flag register
    bpl     Ld98b                   ;2/3       * ; If bit 7 is clear, proceed
    lda     #$41                    ;2         *
    bne     Ld990                   ;2/3 =  15 * ; Always taken  apply forced vertical position
Ld9d4
    iny                             ;2         * ; 2
    bne     Ld9e1                   ;2/3       * ; Always taken unless overflowed
    lda     ram_B5                  ;3         * ; 3
    and     #$0f                    ;2         * ; Mask to lower nibble
    bne     Ld9f9                   ;2/3       * ; If any bits set, don't override
    ldy     #$06                    ;2         * ; 2
    bne     Ld98b                   ;2/3 =  15 * ; Always taken
Ld9e1
    iny                             ;2         * ; 2
    bne     Ld9f0                   ;2/3       * ; Continue check chain
    lda     ram_B5                  ;3         * ; 3
    and     #$0f                    ;2         * ; 2
    cmp     #$0a                    ;2         * ; 2
    bcs     Ld9f9                   ;2/3       * ; 2
    ldy     #$06                    ;2         * ; 2
    bne     Ld98b                   ;2/3 =  17 * ; Always taken
Ld9f0
    iny                             ;2         * ; 2
    bne     Ld9fe                   ;2/3       * ; Continue to final check
    ldy     #$01                    ;2         * ; 2
    bit     ram_8A                  ;3         *
    bmi     Ld98b                   ;2/3 =  11 * ; If fire button pressed, allow override
Ld9f9
    clc                             ;2         * ; Clear carry to signal no override
    bit     Ld9fd                   ;4   =   6 * ; Dummy BIT used for timing/padding
    
Ld9fd
    .byte   $60                             ; $d9fd (D)
    
Ld9fe
    iny                             ;2         * ; Increment Y (used as a conditional trigger)
    bne     Ld9f9                   ;2/3!      * ; If Y was not zero before, exit ear
    ldy     #$06                    ;2         * ; Load override index value into Y (used if conditions match)
    lda     #$0e                    ;2         * ; Load ID for the Head of Ra item
    cmp     current_inv                  ;3         * ; compare with current selected inventory id
    bne     Ld9f9                   ;2/3!      * ; branch if not holding Head of Ra
    bit     INPT5|$30               ;3         * ; read action button from right controller
    bmi     Ld9f9                   ;2/3!      * ; branch if action button not pressed
    jmp     Ld98b                   ;3   =  21 * ; All conditions met: apply vertical override
    
Lda10
    ldy     ram_C4                  ;3         * ; get number of inventory items
    bne     Lda16                   ;2/3       * ; branch if Indy carrying items
    clc                             ;2         * ; Otherwise, clear carry (indicates no item removed)
    rts                             ;6   =  13 * ; Return (nothing to do)
    
Lda16
    bcs     Lda40                   ;2/3       *
    tay                             ;2         * ; move item id to be removed to y
    asl                             ;2         * ; multiply value by 8 to get graphic LSB
    asl                             ;2         *
    asl                             ;2         *
    ldx     #$0a                    ;2   =  12 * ; Start from the last inventory slot (there are 6 slots, each 2 bytes)
Lda1e
    cmp     inv_slot1_lo,x                ;4         * ; Compare target LSB value to current inventory slot
    bne     Lda3a                   ;2/3       * ; If not a match, try the next slot
    cpx     cursor_pos                  ;3         *
    beq     Lda3a                   ;2/3       *
    dec     ram_C4                  ;5         * ; reduce number of inventory items
    lda     #$00                    ;2         *
    sta     inv_slot1_lo,x                ;4         * ; place empty sprite in inventory
    cpy     #$05                    ;2         * ; If item index is less than 5, skip clearing pickup flag
    bcc     Lda37                   ;2/3       * ; 2
	; Remove pickup status bit if this is a non-basket item
    tya                             ;2         * ; Move item ID to A
    tax                             ;2         * ; move item id to x
    jsr     Ldd1b                   ;6         * ; Update pickup/basket flags to show it's no longer taken
    txa                             ;2         * ; X -> A
    tay                             ;2   =  40 * ; And back to Y for further use
Lda37
    jmp     Ldaf7                   ;3   =   3 * ; 3
    
Lda3a
    dex                             ;2         * ; Move to previous inventory slot
    dex                             ;2         * ; Each slot is 2 bytes (pointer to sprite)
    bpl     Lda1e                   ;2/3       * ; If still within bounds, continue checking
    clc                             ;2         * ; Clear carry  no matching item was found/removed
    rts                             ;6   =  14 * ; Return (nothing removed)
    
Lda40
    lda     #$00                    ;2         *
    ldx     cursor_pos                  ;3         *
    sta     inv_slot1_lo,x                ;4         * ; remove selected item from inventory
    ldx     current_inv                  ;3         * ; get current selected inventory id
    cpx     #$07                    ;2         *
    bcc     Lda4f                   ;2/3       * ; 2
    jsr     Ldd1b                   ;6   =  22 *
Lda4f
    txa                             ;2         * ; move inventory id to accumulator
    tay                             ;2         * ; move inventory id to y
    asl                             ;2         * ; multiple inventory id by 2
    tax                             ;2         *
    lda     Ldc76,x                 ;4         *
    pha                             ;3         * ; push MSB to stack
    lda     Ldc75,x                 ;4         *
    pha                             ;3         * ; push LSB to stack
    ldx     room_num                  ;3         * ; get the current screen id
    rts                             ;6   =  31 * ; jump to Remove Item strategy
    
    .byte   $a9,$3f,$25,$b4,$85,$b4,$4c,$d8 ; $da5e (*)
    .byte   $da,$86,$8d,$a9,$70,$85,$d1,$d0 ; $da66 (*)
    .byte   $f5,$a9,$42,$c5,$91,$d0,$11,$a9 ; $da6e (*)
    .byte   $03,$85,$81,$20,$78,$d8,$a9,$15 ; $da76 (*)
    .byte   $85,$c9,$a9,$1c,$85,$cf,$d0,$52 ; $da7e (*)
    .byte   $e0,$05,$d0,$4e,$a9,$05,$c5,$8b ; $da86 (*)
    .byte   $d0,$48,$85,$aa,$a9,$00,$85,$ce ; $da8e (*)
    .byte   $a9,$02,$05,$b4,$85,$b4,$d0,$3a ; $da96 (*)
    .byte   $66,$b1,$18,$26,$b1,$e0,$02,$d0 ; $da9e (*)
    .byte   $04,$a9,$4e,$85,$df,$d0,$2b,$66 ; $daa6 (*)
    .byte   $b2,$18,$26,$b2,$e0,$03,$d0,$08 ; $daae (*)
    .byte   $a9,$4f,$85,$df,$a9,$4b,$85,$d0 ; $dab6 (*)
    .byte   $d0,$18,$a6,$81,$e0,$03,$d0,$0b ; $dabe (*)
    .byte   $a5,$c9,$c9,$3c,$b0,$05,$26,$b2 ; $dac6 (*)
    .byte   $38,$66,$b2,$a5,$91,$18,$69,$40 ; $dace (*)
    .byte   $85,$91,$c6,$c4,$d0,$06,$a9,$00 ; $dad6 (*)
    .byte   $85,$c5,$f0,$15,$a6,$c3,$e8,$e8 ; $dade (*)
    .byte   $e0,$0b,$90,$02,$a2,$00,$b5,$b7 ; $dae6 (*)
    .byte   $f0,$f4,$86,$c3,$4a,$4a,$4a,$85 ; $daee (*)
    .byte   $c5                             ; $daf6 (*)
    
Ldaf7
    lda     #$0d                    ;2         * ; Mask to clear bit 6 (parachute active flag)
    sta     ram_A2                  ;3         * ; 3
    sec                             ;2         * ; Set carry to indicate success
    rts                             ;6   =  13 * ; 6
    
    .byte   $00,$00,$00                     ; $dafd (*)
Ldb00
    .byte   $00                             ; $db00 (D)
    .byte   $00,$35,$10,$17,$30,$00,$00,$00 ; $db01 (*)
    .byte   $00,$00,$00,$00                 ; $db09 (*)
    .byte   $05                             ; $db0d (D)
    .byte   $00,$00,$f0,$e0,$d0,$c0,$b0,$a0 ; $db0e (*)
    .byte   $90,$71,$61,$51,$41,$31,$21,$11 ; $db16 (*)
    .byte   $01,$f1,$e1,$d1,$c1,$b1,$a1,$91 ; $db1e (*)
    .byte   $72,$62,$52,$42,$32,$22,$12,$02 ; $db26 (*)
    .byte   $f2,$e2,$d2,$c2,$b2,$a2,$92,$73 ; $db2e (*)
    .byte   $63,$53,$43,$33,$23,$13,$03,$f3 ; $db36 (*)
    .byte   $e3,$d3,$c3,$b3,$a3,$93,$74,$64 ; $db3e (*)
    .byte   $54,$44                         ; $db46 (*)
    .byte   $34                             ; $db48 (D)
    .byte   $24,$14,$04,$f4                 ; $db49 (*)
    .byte   $e4                             ; $db4d (D)
    .byte   $d4,$c4,$b4,$a4,$94,$75,$65,$55 ; $db4e (*)
    .byte   $45,$35,$25,$15,$05,$f5,$e5,$d5 ; $db56 (*)
    .byte   $c5,$b5,$a5,$95,$76,$66,$56,$46 ; $db5e (*)
    .byte   $36,$26,$16,$06,$f6,$e6,$d6,$c6 ; $db66 (*)
    .byte   $b6,$a6,$96,$77,$67,$57,$47,$37 ; $db6e (*)
    .byte   $27,$17,$07,$f7,$e7,$d7,$c7,$b7 ; $db76 (*)
    .byte   $a7,$97,$78,$68,$58,$48,$38,$28 ; $db7e (*)
    .byte   $18,$08,$f8,$e8,$d8,$c8,$b8,$a8 ; $db86 (*)
    .byte   $98,$79,$69,$59                 ; $db8e (*)
Ldb92
    .byte   $11,$11,$11,$11,$31,$11,$25,$05 ; $db92 (*)
    .byte   $05,$01,$01,$05,$05             ; $db9a (*)
    .byte   $01                             ; $db9f (D)
Ldba0
    .byte   $00,$24,$96,$22,$72,$fc,$00,$00 ; $dba0 (*)
    .byte   $00,$72,$12,$00,$f8             ; $dba8 (*)
    
    .byte   $00|$0                        ; $dbad (CB)
    
Ldbae
    .byte   $08,$22,$08,$00,$1a,$28,$c8,$e8 ; $dbae (*)
    .byte   $8a,$1a,$c6,$00,$28             ; $dbb6 (*)
    
    .byte   $70|$8                       ; $dbbb (CP)
    
Ldbbc
    .byte   $cc,$ea,$5a,$26,$9e,$a6,$7c     ; $dbbc (*)
Ldbc3
    .byte   $88,$28,$f8,$4a,$26,$a8         ; $dbc3 (*)
    
Ldbc9
    .byte   $c0|$c                        ; $dbc9 (C)
    
    .byte   $ce,$4a,$98,$00,$00,$00         ; $dbca (*)
    
    .byte   $00|$8                        ; $dbd0 (C)
    
    .byte   $07,$01,$10                     ; $dbd1 (*)
Ldbd4
    .byte   $78,$4c,$5d,$4c,$4f,$4c,$12,$4c ; $dbd4 (*)
    .byte   $4c,$4c,$4c,$12,$12             ; $dbdc (*)
Ldbe1
    .byte   $ff,$ff,$ff,$f9,$f9,$f9,$fa,$00 ; $dbe1 (*)
    .byte   $fd,$fb,$fc,$fc,$fc             ; $dbe9 (*)
Ldbee
    .byte   $00,$51,$a1,$00,$51,$a2,$c1,$e5 ; $dbee (*)
    .byte   $e0,$00,$00,$00,$00             ; $dbf6 (*)
Ldbfb
    .byte   $72,$7a,$8a,$82                 ; $dbfb (*)
Ldbff
    .byte   $fe,$fa,$02,$06                 ; $dbff (*)
Ldc03
    .byte   $00,$00,$18,$04,$03,$03,$85,$85 ; $dc03 (*)
    .byte   $3b,$85,$85                     ; $dc0b (*)
Ldc0e
    .byte   $20,$78,$85,$4d,$62,$17,$50,$50 ; $dc0e (*)
    .byte   $50,$50,$50,$12,$12             ; $dc16 (*)
Ldc1b
    .byte   $ff,$ff,$14,$4b,$4a,$44,$ff,$27 ; $dc1b (*)
    .byte   $ff,$ff,$ff,$f0,$f0             ; $dc23 (*)
Ldc28
    .byte   $06,$06,$06,$06,$06,$06,$48,$68 ; $dc28 (*)
    .byte   $89,$00,$00                     ; $dc30 (*)
Ldc33
    .byte   $00,$00,$00,$00,$00,$00,$fd,$fd ; $dc33 (*)
    .byte   $fd,$fe,$fe                     ; $dc3b (*)
Ldc3e
    .byte   $20,$20,$20,$20,$20,$20,$20,$b7 ; $dc3e (*)
    .byte   $9b,$78,$78                     ; $dc46 (*)
Ldc49
    .byte   $00,$00,$00,$00,$00,$00,$fd,$fd ; $dc49 (*)
    .byte   $fd,$fe,$fe                     ; $dc51 (*)
Ldc54
    .byte   $01,$02,$04,$08,$10,$20,$40,$80 ; $dc54 (*)
Ldc5c
    .byte   $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f ; $dc5c (*)
Ldc64
    .byte   $00,$00,$00,$00,$08,$00,$02,$0a ; $dc64 (*)
    .byte   $0c,$0e,$01,$03,$04,$06,$05,$07 ; $dc6c (*)
    .byte   $0d                             ; $dc74 (*)
Ldc75
    .byte   $0f                             ; $dc75 (*)
Ldc76
    .byte   $0b,$d7,$da,$d7,$da,$5d,$da,$bf ; $dc76 (*)
    .byte   $da,$d7,$da,$d7,$da,$d7,$da,$d7 ; $dc7e (*)
    .byte   $da,$d7,$da,$9d,$da,$ac,$da,$d7 ; $dc86 (*)
    .byte   $da,$d7,$da,$d7,$da,$d7,$da,$66 ; $dc8e (*)
    .byte   $da,$6e,$da,$66,$da,$b3,$d2,$ea ; $dc96 (*)
    .byte   $d1,$91,$d2,$49,$d2,$b3,$d2,$c3 ; $dc9e (*)
    .byte   $d1,$8d,$d2,$b8,$d1,$34,$d3,$b3 ; $dca6 (*)
    .byte   $d2,$91,$d1,$8d,$d1,$61,$d1,$73 ; $dcae (*)
    .byte   $d3,$73,$d3,$20,$d3,$73,$d3,$73 ; $dcb6 (*)
    .byte   $d3,$56,$d3,$01,$d3,$56,$d3,$34 ; $dcbe (*)
    .byte   $d3,$73,$d3,$69,$d3,$73,$d3,$73 ; $dcc6 (*)
    .byte   $d3,$73,$d3,$73,$d3,$6e,$d3,$73 ; $dcce (*)
    .byte   $d3,$f1,$d2,$73,$d3,$73,$d3,$73 ; $dcd6 (*)
    .byte   $d3,$73,$d3,$cd,$d2,$6e,$d3,$73 ; $dcde (*)
    .byte   $d3,$73,$d3                     ; $dce6 (*)
    
Ldce9
    ldx     ram_C4                  ;3         * ; get number of inventory items
    cpx     #$06                    ;2         * ; see if Indy carrying maximum number of items
    bcc     Ldcf1                   ;2/3       * ; branch if Indy has room to carry more items
    clc                             ;2         *
    rts                             ;6   =  15 *
    
Ldcf1
    ldx     #$0a                    ;2   =   2 *
Ldcf3
    ldy     inv_slot1_lo,x                ;4         * ; get the LSB for the inventory graphic
    beq     Ldcfc                   ;2/3       * ; branch if nothing is in the inventory slot
    dex                             ;2         *
    dex                             ;2         *
    bpl     Ldcf3                   ;2/3       *
    brk                             ;7   =  19 * ; break if no more items can be carried
    
Ldcfc
    tay                             ;2         * ; move item number to y
    asl                             ;2         * ; mutliply item number by 8 for graphic LSB
    asl                             ;2         *
    asl                             ;2         *
    sta     inv_slot1_lo,x                ;4         * ; place graphic LSB in inventory
    lda     ram_C4                  ;3         * ; get number of inventory items
    bne     Ldd0a                   ;2/3       * ; branch if Indy carrying items
    stx     cursor_pos                  ;3         * ; set index to newly picked up item
    sty     current_inv                  ;3   =  23 * ; set the current selected inventory id
Ldd0a
    inc     ram_C4                  ;5         * ; increment number of inventory items
    cpy     #$04                    ;2         *
    bcc     Ldd15                   ;2/3       * ; 2
    tya                             ;2         * ; move item number to accumulator
    tax                             ;2         * ; move item number to x
    jsr     Ldd2f                   ;6   =  19 *
Ldd15
    lda     #$0c                    ;2         *
    sta     ram_A2                  ;3         *
    sec                             ;2         *
    rts                             ;6   =  13 *
    
Ldd1b
    lda     Ldc64,x                 ;4         * ; get the item index value
    lsr                             ;2         * ; shift D0 to carry
    tay                             ;2         *
    lda     Ldc5c,y                 ;4         *
    bcs     Ldd2a                   ;2/3       * ; branch if item not a basket item
    and     ram_C6                  ;3         *
    sta     ram_C6                  ;3         * ; clear status bit showing item not taken
    rts                             ;6   =  26 *
    
Ldd2a
    and     ram_C7                  ;3         *
    sta     ram_C7                  ;3         * ; clear status bit showing item not taken
    rts                             ;6   =  12 *
    
Ldd2f
    lda     Ldc64,x                 ;4         * ; get the item index value
    lsr                             ;2         * ; shift D0 to carry
    tax                             ;2         *
    lda     Ldc54,x                 ;4         * ; get item bit value
    bcs     Ldd3e                   ;2/3       * ; branch if item not a basket item
    ora     ram_C6                  ;3         *
    sta     ram_C6                  ;3         * ; show item taken
    rts                             ;6   =  26 *
    
Ldd3e
    ora     ram_C7                  ;3         *
    sta     ram_C7                  ;3         * ; show item taken
    rts                             ;6   =  12 *
    
    .byte   $bd,$64,$dc,$4a,$a8,$b9,$54,$dc ; $dd43 (*)
    .byte   $b0,$06,$25,$c6,$f0,$01,$38,$60 ; $dd4b (*)
    .byte   $25,$c7,$d0,$fb,$18,$60         ; $dd53 (*)
    
Ldd59
    and     #$1f                    ;2         ; 2
    tax                             ;2         ; 2
    lda     ram_98                  ;3         ; 3
    cpx     #$0c                    ;2         ; 2
    bcs     Ldd67                   ;2/3       ; 2
    adc     Ldfe5,x                 ;4         ; 4
    sta     ram_98                  ;3   =  18 ; 3
Ldd67
    rts                             ;6   =   6 ; 6
    
game_start
;
; Set up everything so the power up state is known.
;
    sei                             ;Turn off interrupts         ; disable interrupts
    cld                             ;Clear Decimal flag (No BCD)         ; clear decimal mode
    ldx     #$ff                    ;        
    txs                             ;Reset the stack pointer         ; set stack to the beginning
    inx                             ;Clear X         ; x = 0
    txa                             ;Clear A 
clear_zp
    sta     zero_page,x                  
    dex                                    
    bne     clear_zp                      

    dex                             ;x = $FF         ; x = -1
    stx     ram_9E                  ;3        
    lda     #$fb                    ;2        
    sta     inv_slot1_hi                  ;3        
    sta     inv_slot2_hi                  ;3        
    sta     inv_slot3_hi                  ;3        
    sta     inv_slot4_hi                  ;3        
    sta     pwatch_Addr                  ;3        
    sta     inv_slot6_hi                  ;3        
    lda     #$60                    ;2        
    sta     inv_slot1_lo                  ;3        
    lda     #$48                    ;2        
    sta     inv_slot2_lo                  ;3        
    lda     #$d8                    ;2        
    sta     inv_slot4_lo                  ;3        
    lda     #$08                    ;2        
    sta     inv_slot3_lo                  ;3        
    lda     #$e0                    ;2        
    sta     pwatch_state                  ;3        
    lda     #$0d                    ;2        
    sta     room_num                  ;3        
    lsr                             ;2        
    sta     num_bullets             ; Load 6 bullets         
    jsr     Ld878                   ;6        
    jmp     Ld3dd                   ;3   =  77
    
reset_vars
    lda     #$20                    ;2         *
    sta     inv_slot1_lo                  ;3         * ; place coins in Indy's inventory
    lsr                             ;2         * ; divide value by 8 to get the inventory id
    lsr                             ;2         *
    lsr                             ;2         *
    sta     current_inv                  ;3         * ; set the current selected inventory id
    inc     ram_C4                  ;5         * ; increment number of inventory items
    lda     #$00                    ;2         *
    sta     inv_slot2_lo                  ;3         * ; clear the remainder of Indy's inventory
    sta     inv_slot3_lo                  ;3         *
    sta     inv_slot4_lo                  ;3         *
    sta     pwatch_state                  ;3         *
    lda     #$64                    ;2         *
    sta     ram_9E                  ;3         *
    lda     #$58                    ;2         *
    sta     indy_anim                  ;3         *
    lda     #$fa                    ;2         *
    sta     ram_DA                  ;3         *
    lda     #$4c                    ;2         * ; 2
    sta     indy_x                  ;3         * ; 3
    lda     #$0f                    ;2         * ; 2
    sta     indy_y                  ;3         * ; 3
    lda     #$02                    ;2         *
    sta     room_num                  ;3         *
    sta     lives_left                  ;3         *
    jsr     Ld878                   ;6         *
    jmp     Ld80d                   ;3   =  75 * ; 3
    
Ldddb
    lda     ram_9E                  ;3         * ; get current adventure points
    sec                             ;2         *
    sbc     shovel_used                  ;3         * ; reduce for finding the Ark of the Covenant
    sbc     parachute_used                  ;3         * ; reduce for using the parachute
    sbc     ankh_used                  ;3         * ; reduce if player skipped the Mesa field
    sbc     yar_found                  ;3         * ; reduce if player found Yar
    sbc     lives_left                  ;3         * ; reduce by remaining lives
    sbc     ark_found                  ;3         * ; reduce if player used the Head of Ra
    sbc     mesa_entered                  ;3         * ; reduce if player landed in Mesa
    sbc     unknown_action                  ;3         * ; 3
    clc                             ;2         *
    adc     grenade_used                  ;3         * ; add 2 if Entrance Room opening activated
    adc     escape_hatch_used                   ;3         * ; add 13 if escaped from Shining Light prison
    adc     thief_shot                  ;3         * ; add 4 if shot a thief
    sta     ram_9E                  ;3         *
    rts                             ;6   =  49 *
    
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ddf8 (*)
Lde00
    .byte   $ff,$ff,$ff,$ff,$ff,$ff,$ff,$f8 ; $de00 (*)
    .byte   $ff,$ff,$ff,$ff,$ff,$4f,$4f,$4f ; $de08 (*)
    .byte   $4f,$4f,$4f,$4f,$4f,$4f,$4f,$4f ; $de10 (*)
    .byte   $44,$44,$0f,$0f,$1c,$0f,$0f,$18 ; $de18 (*)
    .byte   $0f,$0f,$0f,$0f,$0f,$12,$12,$89 ; $de20 (*)
    .byte   $89,$8c,$89,$89,$86,$89,$89,$89 ; $de28 (*)
    .byte   $89,$89,$86,$86                 ; $de30 (*)
Lde34
    .byte   $ff,$fd,$ff,$ff,$fd,$ff,$ff,$ff ; $de34 (*)
    .byte   $fd,$01,$fd,$04,$fd,$ff,$fd,$01 ; $de3c (*)
    .byte   $ff,$0b,$0a,$ff,$ff,$ff,$04,$ff ; $de44 (*)
    .byte   $fd,$ff,$fd,$ff,$ff,$ff,$ff,$ff ; $de4c (*)
    .byte   $fe,$fd,$fd,$ff,$ff,$ff,$ff,$ff ; $de54 (*)
    .byte   $fd,$fd,$fe,$ff,$ff,$fe,$fd,$fd ; $de5c (*)
    .byte   $ff,$ff,$ff,$ff                 ; $de64 (*)
Lde68
    .byte   $00,$1e,$00,$00,$11,$00,$00,$00 ; $de68 (*)
    .byte   $11,$00,$10,$00,$60,$00,$11,$00 ; $de70 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $de78 (*)
    .byte   $70,$00,$12,$00,$00,$00,$00,$00 ; $de80 (*)
    .byte   $30,$15,$24,$00,$00,$00,$00,$00 ; $de88 (*)
    .byte   $18,$03,$27,$00,$00,$30,$20,$12 ; $de90 (*)
    .byte   $00,$00,$00,$00                 ; $de98 (*)
Lde9c
    .byte   $00,$7a,$00,$00,$88,$00,$00,$00 ; $de9c (*)
    .byte   $88,$00,$80,$00,$65,$00,$88,$00 ; $dea4 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $deac (*)
    .byte   $72,$00,$16,$00,$00,$00,$00,$00 ; $deb4 (*)
    .byte   $02,$1f,$2f,$00,$00,$00,$00,$00 ; $debc (*)
    .byte   $1c,$40,$01,$00,$00,$07,$27,$16 ; $dec4 (*)
    .byte   $00,$00,$00,$00                 ; $decc (*)
Lded0
    .byte   $00,$02,$00,$00,$09,$00,$00,$00 ; $ded0 (*)
    .byte   $07,$00,$fc,$00,$05,$00,$09,$00 ; $ded8 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $dee0 (*)
    .byte   $03,$00,$ff,$00,$00,$00,$00,$00 ; $dee8 (*)
    .byte   $01,$06,$fe,$00,$00,$00,$00,$00 ; $def0 (*)
    .byte   $fb,$fd,$0b,$00,$00,$08,$08,$00 ; $def8 (*)
    .byte   $00,$00,$00,$00                 ; $df00 (*)
Ldf04
    .byte   $00,$4e,$00,$00,$4e,$00,$00,$00 ; $df04 (*)
    .byte   $4d,$4e,$4e,$4e,$04,$01,$03,$01 ; $df0c (*)
    .byte   $01,$01,$01,$01,$01,$01,$01,$01 ; $df14 (*)
    .byte   $40,$00,$23,$00,$00,$00,$00,$00 ; $df1c (*)
    .byte   $00,$00,$41,$00,$00,$00,$00,$00 ; $df24 (*)
    .byte   $45,$00,$42,$00,$00,$00,$42,$23 ; $df2c (*)
    .byte   $28,$00,$00,$00                 ; $df34 (*)
Ldf38
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $df38 (*)
    .byte   $00,$00,$00,$00,$4c,$00,$00,$00 ; $df40 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $df48 (*)
    .byte   $80,$00,$86,$00,$00,$00,$00,$00 ; $df50 (*)
    .byte   $80,$86,$80,$00,$00,$00,$00,$00 ; $df58 (*)
    .byte   $12,$12,$4c,$00,$00,$16,$80,$12 ; $df60 (*)
    .byte   $50,$00,$00,$00                 ; $df68 (*)
Ldf6c
    .byte   $01,$ff,$01,$ff                 ; $df6c (*)
Ldf70
    .byte   $35,$09                         ; $df70 (*)
Ldf72
    .byte   $00,$00,$42,$45,$0c,$20,$04,$11 ; $df72 (*)
    .byte   $10,$12                         ; $df7a (*)
Ldf7c
    .byte   $07,$03,$05,$06,$09,$0b,$0e,$00 ; $df7c (*)
    .byte   $01,$03,$05,$00,$09,$0c,$0e,$00 ; $df84 (*)
    .byte   $01,$04,$05,$00,$0a,$0c,$0f,$00 ; $df8c (*)
    .byte   $02,$04,$05,$08,$0a,$0d,$0f,$00 ; $df94 (*)
    
Ldf9c
    lda     INTIM                   ;4        
    bne     Ldf9c                   ;2/3      
    sta     WSYNC                   ;3   =   9
;---------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    lda     #$44                    ;2        
    sta     ram_88                  ;3        
    lda     #$f8                    ;2        
    sta     ram_89                  ;3   =  10
Ldfad
    lda     #$ad                    ;2        
    sta     ram_84                  ;3        
    lda     #$f9                    ;2        
    sta     ram_85                  ;3        
    lda     #$ff                    ;2        
    sta     ram_86                  ;3        
    lda     #$4c                    ;2        
    sta     ram_87                  ;3        
    jmp.w   ram_84                  ;3   =  23
    
move_enemy
    ror                             ;Move first bit into carry
    bcs     mov_emy_right           ;If 1 check if enemy shoulld go right
    dec     enemy_y,x               ;Move enemy left 1 unit ; move object up one pixel
mov_emy_right
    ror                             ;Rotate next bit into carry
    bcs     mov_emy_down              ;if 1 check if enemy should go up
    inc     enemy_y,x               ;Move enemy right 1 unit ; move object down one pixel
mov_emy_down
    ror                             ;Rotate next bit into carry
    bcs     mov_emy_up              ;if 1 check if enemy should go up
    dec     enemy_x,x               ;Move enemy down 1 unit ; move object left one pixel
mov_emy_up
    ror                             ;Rotate next bit into carry
    bcs     mov_eny_finish          ;if 1, moves are finished
    inc     enemy_x,x               ;Move enemy up 1 unit ; move object right one pixel
mov_eny_finish
    rts                             ;return
    
    .byte   $00,$00,$00,$00,$00,$0a,$09,$0b ; $dfd5 (*)
    .byte   $00,$06,$05,$07,$00,$0e,$0d,$0f ; $dfdd (*)
Ldfe5
    .byte   $00                             ; $dfe5 (D)
    .byte   $06,$03,$03,$03,$00,$00,$06,$00 ; $dfe6 (*)
    .byte   $00,$00,$06,$00,$00,$00,$00,$00 ; $dfee (*)
    .byte   $00,$00,$00                     ; $dff6 (*)
    .byte   $00                             ; $dff9 (D)
    .byte   $68,$dd,$68,$dd                 ; $dffa (*)
    .byte   $68                             ; $dffe (D)
    .byte   $dd                             ; $dfff (*)


;***********************************************************
;      Bank 1 / 0..1
;***********************************************************

    SEG     CODE
    ORG     $1000
    RORG    $f000

    lda     Lfff8                   ;4   =   4
Lf003
    cmp     ram_E0                  ;3         * ; 3
    bcs     Lf01a                   ;2/3       * ; 2
    lsr                             ;2         * ; 2
    clc                             ;2         * ; 2
    adc     ram_DF                  ;3         * ; 3
    tay                             ;2         * ; 2
    sta     WSYNC                   ;3   =  17 *
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         * ; 3 = @03
    lda     (PF1_data),y              ;5         * ; 5
    sta     PF1                     ;3         * ; 3 = @11
    lda     (PF2_data),y              ;5         * ; 5
    sta     PF2                     ;3         * ; 3 = @19
    bcc     Lf033                   ;2/3 =  21 * ; 2
Lf01a
    sbc     ram_D4                  ;3         * ; 3
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    sta     WSYNC                   ;3   =  10 *
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         * ; 3 = @03
    tax                             ;2         * ; 2
    cpx     ram_D5                  ;3         * ; 3
    bcc     Lf02d                   ;2/3       * ; 2
    ldx     ram_D8                  ;3         * ; 3
    lda     #$00                    ;2         * ; 2
    beq     Lf031                   ;2/3 =  17 * ; 3
Lf02d
    lda     ram_E5,x                ;4         * ; 4
    ldx     ram_D8                  ;3   =   7 * ; 3
Lf031
    sta     PF1,x                   ;4   =   4 * ; 4
Lf033
    ldx     #$1e                    ;2         * ; 2
    txs                             ;2         * ; 2
    lda     scan_line                  ;3         * ; 3
    sec                             ;2         * ; 2
    sbc     indy_y                  ;3         * ; 3
    cmp     indy_h                  ;3         * ; 3
    bcs     Lf079                   ;2/3       * ; 2
    tay                             ;2         * ; 2
    lda     (indy_anim),y              ;5         * ; 5
    tax                             ;2   =  26 * ; 2
Lf043
    lda     scan_line                  ;3         * ; 3
    sec                             ;2         * ; 2
    sbc     enemy_y                  ;3         * ; 3
    cmp     snake_y                  ;3         * ; 3
    bcs     Lf07d                   ;2/3       * ; 2
    tay                             ;2         * ; 2
    lda     (emy_anim),y              ;5         * ; 5
    tay                             ;2   =  22 * ; 2
Lf050
    lda     scan_line                  ;3         * ; 3
    sta     WSYNC                   ;3   =   6 *
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         * ; 3
    cmp     ram_D1                  ;3         * ; 3
    php                             ;3         * ; 3 = @09	  enable / disable M1
    cmp     ram_D0                  ;3         * ; 3
    php                             ;3         * ; 3 = @15	  enable / disable M0
    stx     GRP1                    ;3         * ; 3 = @18
    sty     GRP0                    ;3         * ; 3 = @21
    sec                             ;2         * ; 2
    sbc     ram_D2                  ;3         * ; 3
    cmp     #$08                    ;2         * ; 2
    bcs     Lf06e                   ;2/3       * ; 2
    tay                             ;2         * ; 2
    lda     (ram_D6),y              ;5         * ; 5
    sta     ENABL                   ;3         * ; 3 = @40
    sta     HMBL                    ;3   =  43 * ; 3 = @43
Lf06e
    inc     scan_line                  ;5         * ; 5		  increment scanline
    lda     scan_line                  ;3         * ; 3
    cmp     #$50                    ;2         * ; 2
    bcc     Lf003                   ;2/3       * ; 2
    jmp     Lf1ea                   ;3   =  15 * ; 3
    
Lf079
    ldx     #$00                    ;2         * ; 2
    beq     Lf043                   ;2/3 =   4 * ; 2
Lf07d
    ldy     #$00                    ;2         * ; 2
    beq     Lf050                   ;2/3 =   4 * ; 2
Lf081
    cpx     #$4f                    ;2         * ; 2
    bcc     Lf088                   ;2/3       * ; 2
    jmp     Lf1ea                   ;3   =   7 * ; 3
    
Lf088
    lda     #$00                    ;2         * ; 2
    beq     Lf0a4                   ;2/3 =   4 * ; 3	  unconditional branch
Lf08c
    lda     (emy_anim),y              ;5         * ; 5
    bmi     Lf09c                   ;2/3       * ; 2
    cpy     ram_DF                  ;3         * ; 3
    bcs     Lf081                   ;2/3       * ; 2
    cpy     enemy_y                  ;3         * ; 3
    bcc     Lf088                   ;2/3       * ; 2
    sta     GRP0                    ;3         * ; 3
    bcs     Lf0a4                   ;2/3 =  22 * ; 3	  unconditional branch
Lf09c
    asl                             ;2         * ; 2		  shift value left
    tay                             ;2         * ; 2		  move value to y
    and     #$02                    ;2         * ; 2		  value 0 || 2
    tax                             ;2         * ; 2		  set for correct pointer index
    tya                             ;2         * ; 2		  move value to accumulator
    sta     (PF1_data,x)              ;6   =  16 * ; 6		  set player 0 color or fine motion
Lf0a4
    inc     scan_line                  ;5         * ; 5		  increment scan line
    ldx     scan_line                  ;3         * ; 3		  get current scan line
    lda     #$02                    ;2         * ; 2
    cpx     ram_D0                  ;3         * ; 3
    bcc     Lf0b2                   ;2/3       * ; 2		 branch if not time to draw missile
    cpx     ram_E0                  ;3         * ; 3
    bcc     Lf0b3                   ;2/3 =  20 * ; 2
Lf0b2
    ror                             ;2   =   2 * ; 2		  shift ENABLE_BM right
Lf0b3
    sta     ENAM0                   ;3         * ; 3
    sta     WSYNC                   ;3   =   6 *
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         * ; 3
    txa                             ;2         * ; 2		  move scan line count to accumulator
    sec                             ;2         * ; 2
    sbc     ram_D5                  ;3         * ; 3		  subtract Snake vertical position
    cmp     #$10                    ;2         * ; 2
    bcs     Lf0ff                   ;2/3       * ; 2
    tay                             ;2         * ; 2
    cmp     #$08                    ;2         * ; 2
    bcc     Lf0fb                   ;2/3       * ; 2
    lda     ram_D8                  ;3         * ; 3
    sta     ram_D6                  ;3   =  26 * ; 3
Lf0ca
    lda     (ram_D6),y              ;5         * ; 5
    sta     HMBL                    ;3   =   8 * ; 3 = @34
Lf0ce
    ldy     #$00                    ;2         * ; 2
    txa                             ;2         * ; 2		  move scanline count to accumulator
    cmp     ram_D1                  ;3         * ; 3
    bne     Lf0d6                   ;2/3       * ; 2
    dey                             ;2   =  11 * ; 2		  y = -1
Lf0d6
    sty     ENAM1                   ;3         * ; 3 = @48
    sec                             ;2         * ; 2
    sbc     indy_y                  ;3         * ; 3
    cmp     indy_h                  ;3         * ; 3
    bcs     Lf107                   ;2/3!      * ; 2+1
    tay                             ;2         * ; 2
    lda     (indy_anim),y              ;5   =  20 * ; 5
Lf0e2
    ldy     scan_line                  ;3         * ; 3
    sta     GRP1                    ;3         * ; 3 = @71
    sta     WSYNC                   ;3   =   9 *
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         * ; 3
    lda     #$02                    ;2         * ; 2
    cpx     ram_D2                  ;3         * ; 3
    bcc     Lf0f9                   ;2/3       * ; 2
    cpx     snake_y                  ;3         * ; 3
    bcc     Lf0f5                   ;2/3 =  15 * ; 2
Lf0f4
    ror                             ;2   =   2 * ; 2
Lf0f5
    sta     ENABL                   ;3         * ; 3 = @20
    bcc     Lf08c                   ;2/3 =   5 * ; 3		  unconditional branch
Lf0f9
    bcc     Lf0f4                   ;2/3 =   2 * ; 3		  unconditional branch
Lf0fb
    nop                             ;2         *
    jmp     Lf0ca                   ;3   =   5 * ; 3
    
Lf0ff
    pha                             ;3         * ; 3
    pla                             ;4         * ; 4
    pha                             ;3         * ; 3
    pla                             ;4         * ; 4
    nop                             ;2         *
    jmp     Lf0ce                   ;3   =  19 * ; 3
    
Lf107
    lda     #$00                    ;2         * ; 2
    beq     Lf0e2                   ;2/3!=   4 * ; 3+1		  unconditional branch
Lf10b
    inx                             ;2         * ; 2		  increment scanline
    sta     HMCLR                   ;3         * ; 3		  clear horizontal movement registers
    cpx     #$a0                    ;2         * ; 2
    bcc     Lf140                   ;2/3       * ; 2
    jmp     Lf1ea                   ;3   =  12 * ; 3
    
Lf115
    sta     WSYNC                   ;3   =   3 *
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         * ; 3
    inx                             ;2         * ; 2		  increment scanline
    lda     ram_84                  ;3         * ; 3
    sta     GRP0                    ;3         * ; 3 = @11
    lda     ram_85                  ;3         * ; 3
    sta     COLUP0                  ;3         * ; 3 = @17
    txa                             ;2         * ; 2		  move canline to accumulator
    ldx     #$1f                    ;2         * ; 2
    txs                             ;2         * ; 2
    tax                             ;2         * ; 2		  move scanline to x
    lsr                             ;2         * ; 2		  divide scanline by 2
    cmp     ram_D2                  ;3         * ; 3
    php                             ;3         * ; 3 = @33	  enable / disable BALL
    cmp     ram_D1                  ;3         * ; 3
    php                             ;3         * ; 3 = @39	  enable / disable M1
    cmp     ram_D0                  ;3         * ; 3
    php                             ;3         * ; 3 = @45	  enable / disable M0
    sec                             ;2         * ; 2
    sbc     indy_y                  ;3         * ; 3
    cmp     indy_h                  ;3         * ; 3
    bcs     Lf10b                   ;2/3       * ; 2
    tay                             ;2         * ; 2		  move scanline value to y
    lda     (indy_anim),y              ;5         * ; 5		  get Indy graphic data
    sta     HMCLR                   ;3         * ; 3 = @65	  clear horizontal movement registers
    inx                             ;2         * ; 2		  increment scanline
    sta     GRP1                    ;3   =  70 * ; 3 = @70
Lf140
    sta     WSYNC                   ;3   =   3 *
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         * ; 3
    bit     ram_D4                  ;3         * ; 3
    bpl     Lf157                   ;2/3       * ; 2
    ldy     ram_89                  ;3         * ; 3
    lda     ram_88                  ;3         * ; 3
    lsr     ram_D4                  ;5   =  19 * ; 5
Lf14e
    dey                             ;2         * ; 2
    bpl     Lf14e                   ;2/3       * ; 2
    sta     RESP0                   ;3         * ; 3
    sta     HMP0                    ;3         * ; 3
    bmi     Lf115                   ;2/3 =  12 * ; 3 unconditional branch
Lf157
    bvc     Lf177                   ;2/3       * ; 2
    txa                             ;2         * ; 2
    and     #$0f                    ;2         * ; 2
    tay                             ;2         * ; 2
    lda     (emy_anim),y              ;5         * ; 5
    sta     GRP0                    ;3         * ; 3 = @25
    lda     (ram_D6),y              ;5         * ; 5
    sta     COLUP0                  ;3         * ; 3 = @33
    iny                             ;2         * ; 2
    lda     (emy_anim),y              ;5         * ; 5
    sta     ram_84                  ;3         * ; 3
    lda     (ram_D6),y              ;5         * ; 5
    sta     ram_85                  ;3         * ; 3
    cpy     snake_y                  ;3         * ; 3
    bcc     Lf174                   ;2/3       * ; 2
    lsr     ram_D4                  ;5   =  52 * ; 5
Lf174
    jmp     Lf115                   ;3   =   3 * ; 3
    
Lf177
    lda     #$20                    ;2         * ; 2
    bit     ram_D4                  ;3         * ; 3
    beq     Lf1a7                   ;2/3       * ; 2
    txa                             ;2         * ; 2
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    bcs     Lf115                   ;2/3       * ; 2
    tay                             ;2         * ; 2
    sty     ram_87                  ;3         * ; 3
    lda.wy  ram_DF,y                ;4         *
    sta     REFP0                   ;3         * ; 3
    sta     NUSIZ0                  ;3         * ; 3
    sta     ram_86                  ;3         * ; 3
    bpl     Lf1a2                   ;2/3       * ; 2
    lda     ram_96                  ;3         * ; 3
    sta     emy_anim                  ;3         * ; 3
    lda     #$65                    ;2         * ; 2
    sta     ram_D6                  ;3         *
    lda     #$00                    ;2         * ; 2
    sta     ram_D4                  ;3         * ; 3
    jmp     Lf115                   ;3   =  60 * ; 3
    
Lf1a2
    lsr     ram_D4                  ;5         * ; 5
    jmp     Lf115                   ;3   =   8 * ; 3
    
Lf1a7
    lsr                             ;2         * ; 2
    bit     ram_D4                  ;3         * ; 3
    beq     Lf1ce                   ;2/3       * ; 2
    ldy     ram_87                  ;3         * ; 3
    lda     #$08                    ;2         * ; 2
    and     ram_86                  ;3         * ; 3
    beq     Lf1b6                   ;2/3       * ; 2
    lda     #$03                    ;2   =  19 * ; 2
Lf1b6
    eor.wy  ram_E5,y                ;4         *
    and     #$03                    ;2         * ; 4 frames of animation for the Thief
    tay                             ;2         *
    lda     Lfc40,y                 ;4         *
    sta     emy_anim                  ;3         * ; set Thief graphic LSB value
    lda     #$44                    ;2         *
    sta     ram_D6                  ;3         *
    lda     #$0f                    ;2         *
    sta     snake_y                  ;3         * ; 3
    lsr     ram_D4                  ;5         * ; 5
    jmp     Lf115                   ;3   =  33 * ; 3
    
Lf1ce
    txa                             ;2         * ; 2
    and     #$1f                    ;2         * ; 2
    cmp     #$0c                    ;2         * ; 2
    beq     Lf1d8                   ;2/3       * ; 2
    jmp     Lf115                   ;3   =  11 * ; 3
    
Lf1d8
    ldy     ram_87                  ;3         * ; 3
    lda.wy  ram_EE,y                ;4         *
    sta     ram_88                  ;3         * ; 3
    and     #$0f                    ;2         * ; 2
    sta     ram_89                  ;3         * ; 3
    lda     #$80                    ;2         * ; 2
    sta     ram_D4                  ;3         * ; 3
    jmp     Lf115                   ;3   =  23 * ; 3
    
Lf1ea
    sta     WSYNC                   ;3   =   3
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         ; 3
    ldx     #$ff                    ;2         ; 2
    stx     PF1                     ;3         ; 3 = @08
    stx     PF2                     ;3         ; 3 = @11
    inx                             ;2         ; 2		  x = 0
    stx     GRP0                    ;3         ; 3 = @16
    stx     GRP1                    ;3         ; 3 = @19
    stx     ENAM0                   ;3         ; 3 = @22
    stx     ENAM1                   ;3         ; 3 = @25
    stx     ENABL                   ;3         ; 3 = @28
    sta     WSYNC                   ;3   =  31
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         ; 3
    lda     #$03                    ;2         ; 2
    ldy     #$00                    ;2         ; 2
    sty     REFP1                   ;3         ; 3 = @10
    sta     NUSIZ0                  ;3         ; 3 = @13
    sta     NUSIZ1                  ;3         ; 3 = @16
    sta     VDELP0                  ;3         ; 3 = @19
    sta     VDELP1                  ;3         ; 3 = @22
    sty     GRP0                    ;3         ; 3 = @25
    sty     GRP1                    ;3         ; 3 = @28
    sty     GRP0                    ;3         ; 3 = @31
    sty     GRP1                    ;3         ; 3 = @34
    nop                             ;2        
    sta     RESP0                   ;3         ; 3 = @39
    sta     RESP1                   ;3         ; 3 = @42
    sty     HMP1                    ;3         ; 3 = @45
    lda     #$f0                    ;2         ; 2
    sta     HMP0                    ;3         ; 3 = @50
    sty     REFP0                   ;3         ; 3 = @53
    sta     WSYNC                   ;3   =  56
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         ; 3
    lda     #$1a                    ;2         ; 2
    sta     COLUP0                  ;3         ; 3 = @08
    sta     COLUP1                  ;3         ; 3 = @11
    lda     cursor_pos                  ;3         ; 3		  get selected inventory index
    lsr                             ;2         ; 2		  divide value by 2
    tay                             ;2         ; 2
    lda     Lfff2,y                 ;4         ; 4
    sta     HMBL                    ;3         ; 3 = @25	  set fine motion for inventory indicator
    and     #$0f                    ;2         ; 2		  keep coarse value
    tay                             ;2         ; 2
    ldx     #$00                    ;2         ; 2
    stx     HMP0                    ;3         ; 3 = @34
    sta     WSYNC                   ;3   =  37
;---------------------------------------
;--------------------------------------
    stx     PF0                     ;3         ; 3 = @03
    stx     COLUBK                  ;3         ; 3 = @06
    stx     PF1                     ;3         ; 3 = @09
    stx     PF2                     ;3   =  12 ; 3 = @12
Lf24a
    dey                             ;2         ; 2
    bpl     Lf24a                   ;2/3       ; 2
    sta     RESBL                   ;3         ; 3
    stx     CTRLPF                  ;3         ; 3
    sta     WSYNC                   ;3   =  13
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         ; 3
    lda     #$3f                    ;2         ; 2
    and     frame_counter                  ;3         ; 3
    bne     draw_menu                   ;2/3       ; 2
    lda     #$3f                    ;2         ; 2
    and     time_of_day                  ;3         ; 3
    bne     draw_menu                   ;2/3       ; 2
    lda     ram_B5                  ;3         * ; 3
    and     #$0f                    ;2         * ; 2
    beq     draw_menu                   ;2/3       * ; 2
    cmp     #$0f                    ;2         * ; 2
    beq     draw_menu                   ;2/3       * ; 2
    inc     ram_B5                  ;5   =  33 * ; 5
draw_menu
    sta     WSYNC                   ;Draw Blank Line
;--------------------------------------
    lda     #$42                    ;Set red... ; 2
    sta     COLUBK                  ;...as the background color ; 3 = @05
    sta     WSYNC                   ;Draw four more scanlines
;--------------------------------------
    sta     WSYNC                   ;
;--------------------------------------
    sta     WSYNC                   ;
;--------------------------------------
    sta     WSYNC                   ;
;--------------------------------------
    lda     #$07                    ;2         ; 2
    sta     ram_84                  ;3   =   5 ; 3
draw_inventory
    ldy     ram_84                  ;3         ; 3
    lda     (inv_slot1_lo),y              ;5         ; 5
    sta     GRP0                    ;3         ; 3
    sta     WSYNC                   ;3   =  14
;---------------------------------------
;--------------------------------------
    lda     (inv_slot2_lo),y              ;5         ; 5
    sta     GRP1                    ;3         ; 3 = @08
    lda     (inv_slot3_lo),y              ;5         ; 5
    sta     GRP0                    ;3         ; 3 = @16
    lda     (inv_slot4_lo),y              ;5         ; 5
    sta     ram_85                  ;3         ; 3
    lda     (pwatch_state),y              ;5         ; 5
    tax                             ;2         ; 2
    lda     (inv_slot6_lo),y              ;5         ; 5
    tay                             ;2         ; 2
    lda     ram_85                  ;3         ; 3
    sta     GRP1                    ;3         ; 3 = @44
    stx     GRP0                    ;3         ; 3 = @47
    sty     GRP1                    ;3         ; 3 = @50
    sty     GRP0                    ;3         ; 3 = @53
    dec     ram_84                  ;5         ; 5
    bpl     draw_inventory                   ;2/3       ; 2
    lda     #$00                    ;2         ; 2
    sta     WSYNC                   ;3   =  65
;---------------------------------------
;--------------------------------------
    sta     GRP0                    ;3         ; 3 = @03
    sta     GRP1                    ;3         ; 3 = @06
    sta     GRP0                    ;3         ; 3 = @09
    sta     GRP1                    ;3         ; 3 = @12
    sta     NUSIZ0                  ;3         ; 3 = @15
    sta     NUSIZ1                  ;3         ; 3 = @18
    sta     VDELP0                  ;3         ; 3 = @21
    sta     VDELP1                  ;3         ; 3 = @23
    sta     WSYNC                   ;3   =  27
;---------------------------------------
;--------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
;--------------------------------------
    ldy     #$02                    ;2         ; 2
    lda     ram_C4                  ;3         ; 3		  get number of inventory items
    bne     Lf2c6                   ;2/3       ; 2		 branch if Indy carry items
    dey                             ;2   =   9 ; 2		  y = 1
Lf2c6
    sty     ENABL                   ;3         ; 3 = @12
    ldy     #$08                    ;2         ; 2
    sty     COLUPF                  ;3         ; 3 = @17
    sta     WSYNC                   ;3   =  11
;---------------------------------------
;--------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
;--------------------------------------
    ldy     #$00                    ;2         ; 2
    sty     ENABL                   ;3         ; 3 = @05
    sta     WSYNC                   ;3   =   8
;---------------------------------------
;--------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
;--------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    ldx     #$0f                    ;2        
    stx     VBLANK                  ;3         ; turn off TIA (D1 = 1)
    ldx     #$24                    ;2        
    stx     TIM64T                  ;4         ; set timer for overscan period
    ldx     #$ff                    ;2        
    txs                             ;2         ; point stack to the beginning
    ldx     #$01                    ;2   =  17 ; 2
Lf2e8
    lda     ram_A2,x                ;4         ; 4
    sta     AUDC0,x                 ;4         ; 4
    sta     AUDV0,x                 ;4         ; 4
    bmi     Lf2fb                   ;2/3       ; 2
    ldy     #$00                    ;2         ; 2
    sty     ram_A2,x                ;4   =  20 ; 4
Lf2f4
    sta     AUDF0,x                 ;4         ; 4
    dex                             ;2         ; 2
    bpl     Lf2e8                   ;2/3       ; 2
    bmi     Lf320                   ;2/3!=  10 ; unconditional branch
Lf2fb
    cmp     #$9c                    ;2         ; 2
    bne     Lf314                   ;2/3!      ; 2
    lda     #$0f                    ;2         ; 2
    and     frame_counter                  ;3         ; 3
    bne     Lf30d                   ;2/3       ; 2
    dec     diamond_h                  ;5         ; 5
    bpl     Lf30d                   ;2/3       ; 2
    lda     #$17                    ;2         ; 2
    sta     diamond_h                  ;3   =  23 ; 3
Lf30d
    ldy     diamond_h                  ;3         ; 3
    lda     Lfbe8,y                 ;4         ; 4
    bne     Lf2f4                   ;2/3!=   9 ; 2
Lf314
    lda     frame_counter                  ;3         * ; get current frame count
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    tay                             ;2         * ; 2
    lda     Lfaee,y                 ;4         * ; 4
    bne     Lf2f4                   ;2/3!=  19 * ; 2
Lf320
    lda     current_inv                  ;3         ; get current selected inventory id
    cmp     #$0f                    ;2        
    beq     Lf330                   ;2/3       ; 2
    cmp     #$02                    ;2        
    bne     Lf344                   ;2/3       ; 2
    lda     #$84                    ;2         * ; 2
    sta     ram_A3                  ;3         * ; 3
    bne     Lf348                   ;2/3 =  18 * ; unconditional branch
Lf330
    bit     INPT5|$30               ;3         * ; read action button from right controller
    bpl     Lf338                   ;2/3       * ; branch if action button pressed
    lda     #$78                    ;2         *
    bne     Lf340                   ;2/3 =   9 * ; unconditional branch
Lf338
    lda     time_of_day                  ;3         * ; 3
    and     #$e0                    ;2         * ; 2
    lsr                             ;2         * ; 2
    lsr                             ;2         * ; 2
    adc     #$98                    ;2   =  11 *
Lf340
    ldx     cursor_pos                  ;3         *
    sta     inv_slot1_lo,x                ;4   =   7 * ; 4
Lf344
    lda     #$00                    ;2         ; 2
    sta     ram_A3                  ;3   =   5 ; 3
Lf348
    bit     ram_93                  ;3         ; 3
    bpl     Lf371                   ;2/3       ; 2
    lda     frame_counter                  ;3         * ; get current frame count
    and     #$07                    ;2         * ; 2
    cmp     #$05                    ;2         * ; 2
    bcc     Lf365                   ;2/3       * ; 2
    ldx     #$04                    ;2         * ; 2
    ldy     #$01                    ;2         * ; 2
    bit     ram_9D                  ;3         * ; 3
    bmi     Lf360                   ;2/3       * ; 2
    bit     ram_A1                  ;3         * ; 3
    bpl     Lf362                   ;2/3 =  28 * ; 2
Lf360
    ldy     #$03                    ;2   =   2 * ; 2
Lf362
    jsr     Lf8b3                   ;6   =   6 * ; 6
Lf365
    lda     frame_counter                  ;3         * ; get current frame count
    and     #$06                    ;2         * ; 2
    asl                             ;2         * ; 2
    asl                             ;2         * ; 2
    sta     ram_D6                  ;3         * ; 3
    lda     #$fd                    ;2         * ; 2
    sta     ram_D7                  ;3   =  17 * ; 3
Lf371
    ldx     #$02                    ;2   =   2 ; 2
Lf373
    jsr     Lfef4                   ;6         ; 6
    inx                             ;2         ; 2
    cpx     #$05                    ;2         ; 2
    bcc     Lf373                   ;2/3       ; 2
    bit     ram_9D                  ;3         ; 3
    bpl     Lf3bf                   ;2/3       ; 2
    lda     frame_counter                  ;3         * ; get current frame count
    bvs     Lf39d                   ;2/3       * ; 2
    and     #$0f                    ;2         * ; 2
    bne     Lf3c5                   ;2/3       * ; 2
    ldx     indy_h                  ;3         * ; 3
    dex                             ;2         * ; 2
    stx     ram_A3                  ;3         * ; 3
    cpx     #$03                    ;2         * ; 2
    bcc     Lf398                   ;2/3       * ; 2
    lda     #$8f                    ;2         * ; 2
    sta     ram_D1                  ;3         *
    stx     indy_h                  ;3         * ; 3
    bcs     Lf3c5                   ;2/3 =  48 * ; unconditional branch
Lf398
    sta     frame_counter                  ;3         * ; 3
    sec                             ;2         * ; 2
    ror     ram_9D                  ;5   =  10 * ; 5
Lf39d
    cmp     #$3c                    ;2         * ; 2
    bcc     Lf3a9                   ;2/3       * ; 2
    bne     Lf3a5                   ;2/3       * ; 2
    sta     ram_A3                  ;3   =   9 * ; 3
Lf3a5
    ldy     #$00                    ;2         * ; 2
    sty     indy_h                  ;3   =   5 *
Lf3a9
    cmp     #$78                    ;2         * ; 2
    bcc     Lf3c5                   ;2/3       * ; 2
    lda     #$0b                    ;2         *
    sta     indy_h                  ;3         *
    sta     ram_A3                  ;3         * ; 3
    sta     ram_9D                  ;3         * ; 3
    dec     lives_left                  ;5         *
    bpl     Lf3c5                   ;2/3       * ; 2
    lda     #$ff                    ;2         * ; 2
    sta     ram_9D                  ;3         * ; 3
    bne     Lf3c5                   ;2/3 =  29 * ; unconditional branch
Lf3bf
    lda     room_num                  ;3         ; get the current screen id
    cmp     #$0d                    ;2        
    bne     Lf3d0                   ;2/3 =   7 ; branch if not in ID_ARK_ROOM
Lf3c5
    lda     #$d8                    ;2        
    sta     ram_88                  ;3        
    lda     #$d3                    ;2        
    sta     ram_89                  ;3        
    jmp     Lf493                   ;3   =  13
    
Lf3d0
    bit     ram_8D                  ;3         * ; 3
    bvs     Lf437                   ;2/3!      *
    bit     ram_B4                  ;3         * ; 3
    bmi     Lf437                   ;2/3!      *
    bit     ram_9A                  ;3         * ; 3
    bmi     Lf437                   ;2/3!      *
    lda     #$07                    ;2         *
    and     frame_counter                  ;3         *
    bne     Lf437                   ;2/3!      * ; check to move inventory selector ~8 frames
    lda     ram_C4                  ;3         * ; get number of inventory items
    and     #$06                    ;2         *
    beq     Lf437                   ;2/3!      * ; branch if Indy not carrying items
    ldx     cursor_pos                  ;3         *
    lda     inv_slot1_lo,x                ;4         * ; get inventory graphic LSB value
    cmp     #$98                    ;2         *
    bcc     Lf3f2                   ;2/3       * ; branch if the item is not a clock sprite
    lda     #$78                    ;2   =  42 * ; reset inventory item to the time piece
Lf3f2
    bit     SWCHA                   ;4         * ; check joystick values
    bmi     Lf407                   ;2/3!      * ; branch if left joystick not pushed right
    sta     inv_slot1_lo,x                ;4   =  10 * ; set inventory graphic LSB value
Lf3f9
    inx                             ;2         *
    inx                             ;2         *
    cpx     #$0b                    ;2         *
    bcc     Lf401                   ;2/3!      *
    ldx     #$00                    ;2   =  10 *
Lf401
    ldy     inv_slot1_lo,x                ;4         * ; get inventory graphic LSB value
    beq     Lf3f9                   ;2/3!      * ; branch if no item present (i.e. Blank)
    bne     Lf415                   ;2/3 =   8 * ; unconditional branch
Lf407
    bvs     Lf437                   ;2/3       * ; branch if left joystick not pushed left
    sta     inv_slot1_lo,x                ;4   =   6 *
Lf40b
    dex                             ;2         *
    dex                             ;2         *
    bpl     Lf411                   ;2/3       *
    ldx     #$0a                    ;2   =   8 *
Lf411
    ldy     inv_slot1_lo,x                ;4         *
    beq     Lf40b                   ;2/3 =   6 * ; branch if no item present (i.e. Blank)
Lf415
    stx     cursor_pos                  ;3         *
    tya                             ;2         * ; move inventory graphic LSB to accumulator
    lsr                             ;2         * ; divide value by 8 (i.e. H_INVENTORY_SPRITES)
    lsr                             ;2         *
    lsr                             ;2         *
    sta     current_inv                  ;3         * ; set selected inventory id
    cpy     #$90                    ;2         *
    bne     Lf437                   ;2/3       * ; branch if the Hour Glass not selected
    ldy     #$09                    ;2         *
    cpy     room_num                  ;3         *
    bne     Lf437                   ;2/3       * ; branch if not in Mesa Field
    lda     #$49                    ;2         * ; 2
    sta     ram_8D                  ;3         * ; 3
    lda     indy_y                  ;3         * ; get Indy's vertical position
    adc     #$09                    ;2         *
    sta     ram_D1                  ;3         *
    lda     indy_x                  ;3         *
    adc     #$09                    ;2         *
    sta     ram_CB                  ;3   =  46 *
Lf437
    lda     ram_8D                  ;3         * ; 3
    bpl     Lf454                   ;2/3       * ; 2
    cmp     #$bf                    ;2         * ; 2
    bcs     Lf44b                   ;2/3       * ; 2
    adc     #$10                    ;2         * ; 2
    sta     ram_8D                  ;3         * ; 3
    ldx     #$03                    ;2         * ; 2
    jsr     Lfcea                   ;6         * ; 6
    jmp     Lf48b                   ;3   =  25 * ; 3
    
Lf44b
    lda     #$70                    ;2         * ; 2
    sta     ram_D1                  ;3         *
    lsr                             ;2         * ; 2
    sta     ram_8D                  ;3         * ; 3
    bne     Lf48b                   ;2/3 =  12 * ; 2
Lf454
    bit     ram_8D                  ;3         * ; 3
    bvc     Lf48b                   ;2/3       * ; 2
    ldx     #$03                    ;2         * ; 2
    jsr     Lfcea                   ;6         * ; 6
    lda     ram_CB                  ;3         * ; get bullet or whip horizontal position
    sec                             ;2         * ; 2
    sbc     #$04                    ;2         * ; 2
    cmp     indy_x                  ;3         * ; 3
    bne     Lf46a                   ;2/3       * ; 2
    lda     #$03                    ;2         * ; 2
    bne     Lf481                   ;2/3 =  29 * ; unconditional branch
Lf46a
    cmp     #$11                    ;2         * ; 2
    beq     Lf472                   ;2/3       * ; 2
    cmp     #$84                    ;2         * ; 2
    bne     Lf476                   ;2/3 =   8 * ; 2
Lf472
    lda     #$0f                    ;2         * ; 2
    bne     Lf481                   ;2/3 =   4 * ; unconditional branch
Lf476
    lda     ram_D1                  ;3         * ; get bullet or whip vertical position
    sec                             ;2         * ; 2
    sbc     #$05                    ;2         * ; 2
    cmp     indy_y                  ;3         * ; 3
    bne     Lf487                   ;2/3       * ; 2
    lda     #$0c                    ;2   =  14 * ; 2
Lf481
    eor     ram_8D                  ;3         * ; 3
    sta     ram_8D                  ;3         * ; 3
    bne     Lf48b                   ;2/3 =   8 * ; 2
Lf487
    cmp     #$4a                    ;2         * ; 2
    bcs     Lf472                   ;2/3 =   4 * ; 2
Lf48b
    lda     #$24                    ;2         *
    sta     ram_88                  ;3         *
    lda     #$d0                    ;2         *
    sta     ram_89                  ;3   =  10 *
Lf493
    lda     #$ad                    ;2        
    sta     ram_84                  ;3        
    lda     #$f8                    ;2        
    sta     ram_85                  ;3        
    lda     #$ff                    ;2        
    sta     ram_86                  ;3        
    lda     #$4c                    ;2        
    sta     ram_87                  ;3        
    jmp.w   ram_84                  ;3   =  23
    
Lf4a6
    sta     WSYNC                   ;3   =   3
;---------------------------------------
;--------------------------------------
    cpx     #$12                    ;2         ; 2
    bcc     Lf4d0                   ;2/3       ; 2
    txa                             ;2         ; 2		  move scanline to accumulator
    sbc     indy_y                  ;3         ; 3
    bmi     Lf4c9                   ;2/3       ; 2
    cmp     #$14                    ;2         ; 2
    bcs     Lf4bd                   ;2/3       ; 2
    lsr                             ;2         ; 2
    tay                             ;2         ; 2
    lda     indy_sprite,y                 ;4         ; 4
    jmp     Lf4c3                   ;3   =  26 ; 3
    
Lf4bd
    and     #$03                    ;2         ; 2
    tay                             ;2         ; 2
    lda     Lf9fc,y                 ;4   =   8 ; 4
Lf4c3
    sta     GRP1                    ;3         ; 3 = @27
    lda     indy_y                  ;3         ; 3		  get Indy's vertical position
    sta     COLUP1                  ;3   =   9 ; 3 = @33
Lf4c9
    inx                             ;2         ; 2		  increment scanline count
    cpx     #$90                    ;2         ; 2
    bcs     Lf4ea                   ;2/3       ; 2
    bcc     Lf4a6                   ;2/3 =   8 ; 3		  unconditional branch
Lf4d0
    bit     ram_9C                  ;3         ; 3
    bmi     Lf4e5                   ;2/3       ; 2
    txa                             ;2         ; 2		  move scanline to accumulator
    sbc     #$07                    ;2         ; 2
    bmi     Lf4e5                   ;2/3       ; 2
    tay                             ;2         ; 2
    lda     Lfb40,y                 ;4         ; 4
    sta     GRP1                    ;3         ; 3
    txa                             ;2         ; 2		  move scanline to accumulator
    adc     frame_counter                  ;3         ; 3		  increase value by current frame count
    asl                             ;2         ; 2		  multiply value by 2
    sta     COLUP1                  ;3   =  30 ; 3		  color Ark of the Covenant sprite
Lf4e5
    inx                             ;2         ; 2
    cpx     #$0f                    ;2         ; 2
    bcc     Lf4a6                   ;2/3 =   6 ; 2
Lf4ea
    sta     WSYNC                   ;3   =   3
;---------------------------------------
;--------------------------------------
    cpx     #$20                    ;2         ; 2
    bcs     Lf511                   ;2/3!      ; 2+1
    bit     ram_9C                  ;3         ; 3
    bmi     Lf504                   ;2/3!      ; 2
    txa                             ;2         ; 2		  move scanline to accumulator
    ldy     #$7e                    ;2         ; 2
    and     #$0e                    ;2         ; 2
    bne     Lf4fd                   ;2/3       ; 2
    ldy     #$ff                    ;2   =  19 ; 2
Lf4fd
    sty     GRP0                    ;3         ; 3
    txa                             ;2         ; 2
    eor     #$ff                    ;2         ; 2
    sta     COLUP0                  ;3   =  10 ; 3
Lf504
    inx                             ;2         ; 2
    cpx     #$1d                    ;2         ; 2
    bcc     Lf4ea                   ;2/3!      ; 2
    lda     #$00                    ;2         ; 2
    sta     GRP0                    ;3         ; 3
    sta     GRP1                    ;3         ; 3
    beq     Lf4a6                   ;2/3!=  16 ; 2+1		 unconditional branch
Lf511
    txa                             ;2         ; 2 = @08
    sbc     #$90                    ;2         ; 2
    cmp     #$0f                    ;2         ; 2
    bcc     Lf51b                   ;2/3       ; 2
    jmp     Lf1ea                   ;3   =  11 ; 3
    
Lf51b
    lsr                             ;2         ; 2		  divide by 4 to read graphic data
    lsr                             ;2         ; 2
    tay                             ;2         ; 2
    lda     Lfef0,y                 ;4         ; 4
    sta     GRP0                    ;3         ; 3 = @28
    stx     COLUP0                  ;3         ; 3 = @31
    inx                             ;2         ; 2
    bne     Lf4ea                   ;2/3!      ; 3		  unconditional branch
    lda     room_num                  ;3         * ; get the current screen id
    asl                             ;2         * ; multiply screen id by 2
    tax                             ;2         *
    lda     Lfc89,x                 ;4         *
    pha                             ;3         *
    lda     Lfc88,x                 ;4         *
    pha                             ;3         *
    rts                             ;6   =  47 *
    
    .byte   $a9,$7f,$85,$ce,$85,$d0,$85,$d2 ; $f535 (*)
    .byte   $d0,$5b,$a2,$00,$a0,$01,$24,$33 ; $f53d (*)
    .byte   $30,$14,$24,$b6,$30,$10,$a5,$82 ; $f545 (*)
    .byte   $29,$07,$d0,$0d,$a0,$05,$a9,$4c ; $f54d (*)
    .byte   $85,$cd,$a9,$23,$85,$d3,$20,$b3 ; $f555 (*)
    .byte   $f8,$a9,$80,$85,$93,$a5,$ce,$29 ; $f55d (*)
    .byte   $01,$66,$c8,$2a,$a8,$6a,$26,$c8 ; $f565 (*)
    .byte   $b9,$ea,$fa,$85,$dd,$a9,$fc,$85 ; $f56d (*)
    .byte   $de,$a5,$8e,$30,$20,$a2,$50,$86 ; $f575 (*)
    .byte   $ca,$a2,$26,$86,$d0,$a5,$b6,$30 ; $f57d (*)
    .byte   $14,$24,$9d,$30,$10,$29,$07,$d0 ; $f585 (*)
    .byte   $04,$a0,$06,$84,$b6,$aa,$bd,$d2 ; $f58d (*)
    .byte   $fc,$85,$8e,$c6,$b6,$4c,$33,$f8 ; $f595 (*)
    .byte   $a9,$80,$85,$93,$a2,$00,$24,$9d ; $f59d (*)
    .byte   $30,$04,$24,$95,$50,$0c,$a0,$05 ; $f5a5 (*)
    .byte   $a9,$55,$85,$cd,$85,$d3,$a9,$01 ; $f5ad (*)
    .byte   $d0,$04,$a0,$01,$a9,$03,$25,$82 ; $f5b5 (*)
    .byte   $d0,$0f,$20,$b3,$f8,$a5,$ce,$10 ; $f5bd (*)
    .byte   $08,$c9,$a0,$90,$04,$e6,$ce,$e6 ; $f5c5 (*)
    .byte   $ce,$50,$0e,$a5,$ce,$c9,$51,$90 ; $f5cd (*)
    .byte   $08,$a5,$95,$85,$99,$a9,$00,$85 ; $f5d5 (*)
    .byte   $95,$a5,$c8,$c5,$c9,$b0,$03,$ca ; $f5dd (*)
    .byte   $49,$03,$86,$0b,$29,$03,$0a,$0a ; $f5e5 (*)
    .byte   $0a,$0a,$85,$dd,$a5,$82,$29,$7f ; $f5ed (*)
    .byte   $d0,$20,$a5,$ce,$c9,$4a,$b0,$1a ; $f5f5 (*)
    .byte   $a4,$98,$f0,$16,$88,$84,$98,$a0 ; $f5fd (*)
    .byte   $8e,$69,$03,$85,$d0,$c5,$cf,$b0 ; $f605 (*)
    .byte   $01,$88,$a5,$c8,$69,$04,$85,$ca ; $f60d (*)
    .byte   $84,$8e,$a0,$7f,$a5,$8e,$30,$02 ; $f615 (*)
    .byte   $84,$d0,$a5,$d1,$c9,$52,$90,$02 ; $f61d (*)
    .byte   $84,$d1,$4c,$33,$f8,$a2,$3a,$86 ; $f625 (*)
    .byte   $e9,$a2,$85,$86,$e3,$a2,$03,$86 ; $f62d (*)
    .byte   $ad,$d0,$02,$a2,$04,$bd,$d8,$fc ; $f635 (*)
    .byte   $25,$82,$d0,$15,$b4,$e5,$a9,$08 ; $f63d (*)
    .byte   $35,$df,$d0,$13,$88,$c0,$14,$b0 ; $f645 (*)
    .byte   $06,$a9,$08,$55,$df,$95,$df,$94 ; $f64d (*)
    .byte   $e5,$ca,$10,$e1,$4c,$33,$f8,$c8 ; $f655 (*)
    .byte   $c0,$85,$b0,$ed,$90,$f1,$24,$b4 ; $f65d (*)
    .byte   $10,$1e,$50,$04,$c6,$c9,$d0,$18 ; $f665 (*)
    .byte   $a5,$82,$6a,$90,$13,$ad,$80,$02 ; $f66d (*)
    .byte   $85,$92,$6a,$6a,$6a,$b0,$04,$c6 ; $f675 (*)
    .byte   $c9,$d0,$05,$6a,$b0,$02,$e6,$c9 ; $f67d (*)
    .byte   $a9,$02,$25,$b4,$d0,$06,$85,$8d ; $f685 (*)
    .byte   $a9,$0b,$85,$ce,$a6,$cf,$a5,$82 ; $f68d (*)
    .byte   $24,$b4,$30,$0a,$e0,$15,$90,$06 ; $f695 (*)
    .byte   $e0,$30,$90,$09,$b0,$06,$6a,$90 ; $f69d (*)
    .byte   $04,$4c,$33,$f8,$e8,$e8,$86,$cf ; $f6a5 (*)
    .byte   $d0,$f7,$a5,$c9,$c9,$64,$90,$07 ; $f6ad (*)
    .byte   $26,$b2,$18,$66,$b2,$10,$22,$c9 ; $f6b5 (*)
    .byte   $2c,$f0,$06,$a9,$7f,$85,$d2,$d0 ; $f6bd (*)
    .byte   $18,$24,$b2,$30,$14,$a9,$30,$85 ; $f6c5 (*)
    .byte   $cc,$a0,$00,$84,$d2,$a0,$7f,$84 ; $f6cd (*)
    .byte   $dc,$84,$d5,$e6,$c9,$a9,$80,$85 ; $f6d5 (*)
    .byte   $9d,$4c,$33,$f8,$a4,$df,$88,$d0 ; $f6dd (*)
    .byte   $f8,$a5,$af,$29,$07,$d0,$31,$a9 ; $f6e5 (*)
    .byte   $40,$85,$93,$a5,$83,$4a,$4a,$4a ; $f6ed (*)
    .byte   $4a,$4a,$aa,$bc,$dc,$fc,$be,$aa ; $f6f5 (*)
    .byte   $fc,$84,$84,$20,$9d,$f8,$90,$05 ; $f6fd (*)
    .byte   $e6,$df,$d0,$d5,$00,$a4,$84,$98 ; $f705 (*)
    .byte   $05,$af,$85,$af,$b9,$a2,$fc,$85 ; $f70d (*)
    .byte   $ce,$b9,$a6,$fc,$85,$df,$d0,$c1 ; $f715 (*)
    .byte   $c9,$04,$b0,$e4,$26,$af,$38,$66 ; $f71d (*)
    .byte   $af,$30,$dd,$a0,$00,$84,$d2,$a0 ; $f725 (*)
    .byte   $7f,$84,$dc,$84,$d5,$a9,$71,$85 ; $f72d (*)
    .byte   $cc,$a0,$4f,$a9,$3a,$c5,$cf,$d0 ; $f735 (*)
    .byte   $0c,$a5,$c5,$c9,$07,$f0,$08,$a9 ; $f73d (*)
    .byte   $5e,$c5,$c9,$f0,$02,$a0,$0d,$84 ; $f745 (*)
    .byte   $df,$a5,$83,$38,$e9,$10,$10,$05 ; $f74d (*)
    .byte   $49,$ff,$38,$69,$00,$c9,$0b,$90 ; $f755 (*)
    .byte   $02,$a9,$0b,$85,$ce,$24,$b3,$10 ; $f75d (*)
    .byte   $25,$c9,$08,$b0,$1d,$a6,$c5,$e0 ; $f765 (*)
    .byte   $0e,$d0,$17,$86,$ab,$a9,$04,$25 ; $f76d (*)
    .byte   $82,$d0,$0f,$a5,$8c,$29,$0f,$aa ; $f775 (*)
    .byte   $bd,$c2,$fa,$85,$cb,$bd,$d2,$fa ; $f77d (*)
    .byte   $d0,$02,$a9,$70,$85,$d1,$26,$b3 ; $f785 (*)
    .byte   $a9,$3a,$c5,$cf,$d0,$0f,$c0,$4f ; $f78d (*)
    .byte   $f0,$06,$a9,$5e,$c5,$c9,$d0,$05 ; $f795 (*)
    .byte   $38,$66,$b3,$30,$03,$18,$66,$b3 ; $f79d (*)
    .byte   $4c,$33,$f8,$a9,$08,$25,$c7,$d0 ; $f7a5 (*)
    .byte   $12,$a9,$4c,$85,$cc,$a9,$2a,$85 ; $f7ad (*)
    .byte   $d2,$a9,$ba,$85,$d6,$a9,$fa,$85 ; $f7b5 (*)
    .byte   $d7,$d0,$04,$a9,$f0,$85,$d2,$a5 ; $f7bd (*)
    .byte   $b5,$29,$0f,$f0,$69,$85,$dc,$a0 ; $f7c5 (*)
    .byte   $14,$84,$ce,$a0,$3b,$84,$e0,$c8 ; $f7cd (*)
    .byte   $84,$d4,$a9,$c1,$38,$e5,$dc,$85 ; $f7d5 (*)
    .byte   $dd,$d0,$53,$a5,$82,$29,$18,$69 ; $f7dd (*)
    .byte   $e0,$85,$dd,$a5,$82,$29,$07,$d0 ; $f7e5 (*)
    .byte   $21,$a2,$00,$a0,$01,$a5,$cf,$c9 ; $f7ed (*)
    .byte   $3a,$90,$14,$a5,$c9,$c9,$2b,$90 ; $f7f5 (*)
    .byte   $04,$c9,$6d,$90,$0a,$a0,$05,$a9 ; $f7fd (*)
    .byte   $4c,$85,$cd,$a9,$0b,$85,$d3,$20 ; $f805 (*)
    .byte   $b3,$f8,$a2,$4e,$e4,$cf,$d0,$1e ; $f80d (*)
    .byte   $a6,$c9,$e0,$76,$f0,$04,$e0,$14 ; $f815 (*)
    .byte   $d0,$14,$ad,$80,$02,$29,$0f,$c9 ; $f81d (*)
    .byte   $0d,$d0,$0b,$85,$a6,$a9,$4c,$85 ; $f825 (*)
    .byte   $c9,$66,$b5,$38,$26,$b5,$a9,$0d ; $f82d (*)
    .byte   $85,$88,$a9,$d8,$85,$89,$4c,$93 ; $f835 (*)
    .byte   $f4,$a9,$40,$85,$93,$d0,$ef     ; $f83d (*)
    
draw_field
    sta     WSYNC                   ;3   =   3
;---------------------------------------
;--------------------------------------
    sta     HMCLR                   ;3         ; 3 = @03	  clear horizontal motion
    sta     CXCLR                   ;3         ; 3 = @06	  clear all collisions
    ldy     #$ff                    ;2         ; 2
    sty     PF1                     ;3         ; 3 = @11
    sty     PF2                     ;3         ; 3 = @14
    ldx     room_num                  ;3         ; 3		  get the current screen id
    lda     Lfaac,x                 ;4         ; 4
    sta     PF0                     ;3         ; 3 = @24
    iny                             ;2         ; 2		  y = 0
    sta     WSYNC                   ;3   =  29
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         ; 3
    sty     VBLANK                  ;3         ; 3 = @06	  enable TIA (D1 = 0)
    sty     scan_line                  ;3         ; 3
    cpx     #$04                    ;2         ; 2
    bne     Lf865                   ;2/3       ; 2		 branch if not in Map Room
    dey                             ;2   =  15 * ; 2		  y = -1
Lf865
    sty     ENABL                   ;3         ; 3 = @18
    cpx     #$0d                    ;2         ; 2
    beq     Lf874                   ;2/3       ; 2		 branch if in Ark Room
    bit     ram_9D                  ;3         * ; 3
    bmi     Lf874                   ;2/3       * ; 2
    ldy     SWCHA                   ;4         * ; 4		  read joystick values
    sty     REFP1                   ;3   =  19 * ; 3 = @34
Lf874
    sta     WSYNC                   ;3   =   3
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         ; 3
    sta     WSYNC                   ;3   =   6
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         ; 3
    ldy     room_num                  ;3         ; 3		  get the current screen id
    sta     WSYNC                   ;3   =   9
;---------------------------------------
;--------------------------------------
    sta     HMOVE                   ;3         ; 3
    lda     Lfa91,y                 ;4         ; 4
    sta     PF1                     ;3         ; 3 = @10
    lda     Lfa9e,y                 ;4         ; 4
    sta     PF2                     ;3         ; 3 = @17
    ldx     Lf9ee,y                 ;4         ; 4
    lda     Lfae3,x                 ;4         ; 4
    pha                             ;3         ; 3
    lda     Lfae2,x                 ;4         ; 4
    pha                             ;3         ; 3
    lda     #$00                    ;2         ; 2
    tax                             ;2         ; 2
    sta     ram_84                  ;3         ; 3
    rts                             ;6   =  48 ; 6		  jump to specified kernel


    .byte   $bd,$75,$fc,$4a,$a8,$b9,$e2,$fc ; $f89d (*)
    .byte   $b0,$06,$25,$c6,$f0,$01,$38,$60 ; $f8a5 (*)
    .byte   $25,$c7,$d0,$fb,$18,$60         ; $f8ad (*)
    
Lf8b3
    cpy     #$01                    ;2         *
    bne     Lf8bb                   ;2/3       * ; 2
    lda     indy_y                  ;3         * ; get Indy's vertical position
    bmi     Lf8cc                   ;2/3 =   9 * ; 2
Lf8bb
    lda     enemy_y,x                ;4         * ; 4
    cmp.wy  enemy_y,y                ;4         *
    bne     Lf8c6                   ;2/3       * ; 2
    cpy     #$05                    ;2         * ; 2
    bcs     Lf8ce                   ;2/3 =  14 * ; 2
Lf8c6
    bcs     Lf8cc                   ;2/3       * ; 2
    inc     enemy_y,x                ;6         * ; 6
    bne     Lf8ce                   ;2/3 =  10 * ; 2
Lf8cc
    dec     enemy_y,x                ;6   =   6 * ; 6
Lf8ce
    lda     enemy_x,x                ;4         * ; 4
    cmp.wy  enemy_x,y                ;4         *
    bne     Lf8d9                   ;2/3       * ; 2
    cpy     #$05                    ;2         * ; 2
    bcs     Lf8dd                   ;2/3 =  14 * ; 2
Lf8d9
    bcs     Lf8de                   ;2/3       * ; 2
    inc     enemy_x,x                ;6   =   8 * ; 6
Lf8dd
    rts                             ;6   =   6 * ; 6
    
Lf8de
    dec     enemy_x,x                ;6         * ; 6
    rts                             ;6   =  12 * ; 6
    
Lf8e1
    lda     enemy_y,x                ;4         * ; 4
    cmp     #$53                    ;2         * ; 2
    bcc     Lf8f1                   ;2/3 =   8 * ; 2
Lf8e7
    rol     ram_8C,x                ;6         * ; 6
    clc                             ;2         * ; 2
    ror     ram_8C,x                ;6         * ; 6
    lda     #$78                    ;2         * ; 2
    sta     enemy_y,x                ;4         * ; 4
    rts                             ;6   =  26 * ; 6
    
Lf8f1
    lda     enemy_x,x                ;4         * ; 4
    cmp     #$10                    ;2         * ; 2
    bcc     Lf8e7                   ;2/3       * ; 2
    cmp     #$8e                    ;2         * ; 2
    bcs     Lf8e7                   ;2/3       * ; 2
    rts                             ;6   =  18 * ; 6
    
    .byte   $00,$00,$00,$00,$00,$e4,$7e,$9a ; $f8fc (*)
    .byte   $e4,$a6,$5a,$7e,$e4,$7f,$00,$00 ; $f904 (*)
    .byte   $84,$08,$2a,$22,$00,$22,$2a,$08 ; $f90c (*)
    .byte   $00,$b9,$d4,$89,$6c,$7b,$7f,$81 ; $f914 (*)
    .byte   $a6,$3f,$77,$07,$7f,$86,$89,$3f ; $f91c (*)
    .byte   $1f,$0e,$0c,$00,$c1,$b6,$00,$00 ; $f924 (*)
    .byte   $00,$81,$1c,$2a,$55,$2a,$14,$3e ; $f92c (*)
    .byte   $00,$a9,$00,$e4,$89,$81,$7e,$9a ; $f934 (*)
    .byte   $e4,$a6,$5a,$7e,$e4,$7f,$00,$c9 ; $f93c (*)
    .byte   $89,$82,$00,$7c,$18,$18,$92,$7f ; $f944 (*)
    .byte   $1f,$07,$00,$00,$00             ; $f94c (*)
	
	
;Map Room
    .byte   $94 ; |#  # #  |
    .byte   $00 ; |        |
    .byte   $08 ; |    #   |
    .byte   $1C ; |   ###  |
    .byte   $3E ; |  ##### |
    .byte   $3E ; |  ##### |
    .byte   $3E ; |  ##### |
    .byte   $3E ; |  ##### |
    .byte   $1C ; |   ###  |
    .byte   $08 ; |    #   |
    .byte   $00 ; |        |
    .byte   $8E ; |#   ### |
    .byte   $7F ; | #######|
    .byte   $7F ; | #######|
    .byte   $7F ; | #######|
    .byte   $14 ; |   # #  |
    .byte   $14 ; |   # #  |
    .byte   $00 ; |        |
    .byte   $00 ; |        |
    .byte   $2A ; |  # # # |
    .byte   $2A ; |  # # # |
    .byte   $00 ; |        |
    .byte   $00 ; |        |
    .byte   $14 ; |   # #  |
    .byte   $36 ; |  ## ## |
    .byte   $22 ; |  #   # |
    .byte   $08 ; |    #   |
    .byte   $08 ; |    #   |
    .byte   $3E ; |  ##### |
    .byte   $1C ; |   ###  |
    .byte   $08 ; |    #   |
    .byte   $00 ; |        |
    .byte   $41 ; | #     #|
    .byte   $63 ; | ##   ##|
    .byte   $49 ; | #  #  #|
    .byte   $08 ; |    #   |
    .byte   $00 ; |        |
    .byte   $00 ; |        |
    .byte   $14 ; |   # #  |
    .byte   $14 ; |   # #  |
    .byte   $00 ; |        |
    .byte   $00 ; |        |
    .byte   $08 ; |    #   |
    .byte   $6B ; | ## # ##|
    .byte   $6B ; | ## # ##|
    .byte   $08 ; |    #   |
    .byte   $00 ; |        |
    .byte   $22 ; |  #   # |
    .byte   $22 ; |  #   # |
    .byte   $00 ; |        |
    .byte   $00 ; |        |
    .byte   $08 ; |    #   |
    .byte   $1C ; |   ###  |
    .byte   $1C ; |   ###  |
    .byte   $7F ; | #######|
    .byte   $7F ; | #######|
    .byte   $7F ; | #######|
    .byte   $E4 ; |###  #  |
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $41 ; | #     #|
    .byte   $7F ; | #######|
    .byte   $92 ; |#  #  # |
    .byte   $77 ; | ### ###|
    .byte   $77 ; | ### ###|
    .byte   $63 ; | ##   ##|
    .byte   $77 ; | ### ###|
    .byte   $14 ; |   # #  |
    .byte   $36 ; |  ## ## |
    .byte   $55 ; | # # # #|
    .byte   $63 ; | ##   ##|
    .byte   $77 ; | ### ###|
    .byte   $7F ; | #######|
    .byte   $7F ; | #######|
    .byte   $00 ; |        |
    .byte   $86 ; |#    ## |
    .byte   $24 ; |  #  #  |
    .byte   $18 ; |   ##   |
    .byte   $24 ; |  #  #  |
    .byte   $24 ; |  #  #  |
    .byte   $7E ; | ###### |
    .byte   $5A ; | # ## # |
    .byte   $5B ; | # ## ##|
    .byte   $3C ; |  ####  |


;	.byte   $94,$00,$08 ; $f94c (*)
;    .byte   $1c,$3e,$3e,$3e,$3e,$1c,$08,$00 ; $f954 (*)
;    .byte   $8e,$7f,$7f,$7f,$14,$14,$00,$00 ; $f95c (*)
;    .byte   $2a,$2a,$00,$00,$14,$36,$22,$08 ; $f964 (*)
;    .byte   $08,$3e,$1c,$08,$00,$41,$63,$49 ; $f96c (*)
;    .byte   $08,$00,$00,$14,$14,$00,$00,$08 ; $f974 (*)
;    .byte   $6b,$6b,$08,$00,$22,$22,$00,$00 ; $f97c (*)
;   .byte   $08,$1c,$1c,$7f,$7f,$7f,$e4,$41 ; $f984 (*)
;    .byte   $41,$41,$41,$41,$41,$41,$41,$41 ; $f98c (*)
;    .byte   $41,$7f,$92,$77,$77,$63,$77,$14 ; $f994 (*)
;    .byte   $36,$55,$63,$77,$7f,$7f,$00,$86 ; $f99c (*)
;    .byte   $24,$18,$24,$24,$7e,$5a,$5b,$3c ; $f9a4 (*)





    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f9ac (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f9b4 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f9bc (*)
    .byte   $00,$b9,$e4,$81,$89,$55,$f9,$89 ; $f9c4 (*)
    .byte   $f9,$81,$fa,$32,$1c,$89,$3e,$91 ; $f9cc (*)
    .byte   $7f,$7f,$7f,$7f,$89,$1f,$07,$01 ; $f9d4 (*)
    .byte   $00,$e9,$fe,$89,$3f,$7f,$f9,$91 ; $f9dc (*)
    .byte   $f9,$89,$3f,$f9,$7f,$3f,$7f,$7f ; $f9e4 (*)
    .byte   $00,$00                         ; $f9ec (*)
Lf9ee
    .byte   $00,$00,$00,$00,$00,$00,$02,$02 ; $f9ee (*)
    .byte   $02,$02,$02,$04,$04             ; $f9f6 (*)
    .byte   $06                             ; $f9fb (D)
    
Lf9fc
    .byte   $1c ; |   ###  |            $f9fc (G)
    .byte   $36 ; |  ## ## |            $f9fd (G)
    .byte   $63 ; | ##   ##|            $f9fe (G)
    .byte   $36 ; |  ## ## |            $f9ff (G)
    
    .byte   $18 ; |   XX   |            $fa00 (G)
    .byte   $3C ; |  XXXX  |            $fa01 (G)
    .byte   $00 ; |        |            $fa02 (G)
    .byte   $18 ; |   XX   |            $fa03 (G)
    .byte   $1C ; |   XXX  |            $fa04 (G)
    .byte   $18 ; |   XX   |            $fa05 (G)
    .byte   $18 ; |   XX   |            $fa06 (G)
    .byte   $0C ; |    XX  |            $fa07 (G)
    .byte   $62 ; | XX   X |            $fa08 (G)
    .byte   $43 ; | X    XX|            $fa09 (G)
    .byte   $00 ; |        |            $fa0a (G)

    .byte   $18 ; |   XX   |            $fa0b (G)
    .byte   $3C ; |  XXXX  |            $fa0c (G)
    .byte   $00 ; |        |            $fa0d (G)
    .byte   $18 ; |   XX   |            $fa0e (G)
    .byte   $38 ; |  XXX   |            $fa0f (G)
    .byte   $1C ; |   XXX  |            $fa10 (G)
    .byte   $18 ; |   XX   |            $fa11 (G)
    .byte   $14 ; |   X X  |            $fa12 (G)
    .byte   $64 ; | XX  X  |            $fa13 (G)
    .byte   $46 ; | X   XX |            $fa14 (G)
    .byte   $00 ; |        |            $fa15 (G)

    .byte   $18 ; |   XX   |            $fa16 (G)
    .byte   $3C ; |  XXXX  |            $fa17 (G)
    .byte   $00 ; |        |            $fa18 (G)
    .byte   $38 ; |  XXX   |            $fa19 (G)
    .byte   $38 ; |  XXX   |            $fa1a (G)
    .byte   $18 ; |   XX   |            $fa1b (G)
    .byte   $18 ; |   XX   |            $fa1c (G)
    .byte   $28 ; |  X X   |            $fa1d (G)
    .byte   $48 ; | X  X   |            $fa1e (G)
    .byte   $8C ; |X   XX  |            $fa1f (G)
    .byte   $00 ; |        |            $fa20 (G)

    .byte   $18 ; |   XX   |            $fa21 (G)
    .byte   $3C ; |  XXXX  |            $fa22 (G)
    .byte   $00 ; |        |            $fa23 (G)
    .byte   $38 ; |  XXX   |            $fa24 (G)
    .byte   $58 ; | X XX   |            $fa25 (G)
    .byte   $38 ; |  XXX   |            $fa26 (G)
    .byte   $10 ; |   X    |            $fa27 (G)
    .byte   $E8 ; |XXX X   |            $fa28 (G)
    .byte   $88 ; |X   X   |            $fa29 (G)
    .byte   $0C ; |    XX  |            $fa2a (G)
    .byte   $00 ; |        |            $fa2b (G)

    .byte   $18 ; |   XX   |            $fa2c (G)
    .byte   $3C ; |  XXXX  |            $fa2d (G)
    .byte   $00 ; |        |            $fa2e (G)
    .byte   $30 ; |  XX    |            $fa2f (G)
    .byte   $78 ; | XXXX   |            $fa30 (G)
    .byte   $34 ; |  XX X  |            $fa31 (G)
    .byte   $18 ; |   XX   |            $fa32 (G)
    .byte   $60 ; | XX     |            $fa33 (G)
    .byte   $50 ; | X X    |            $fa34 (G)
    .byte   $18 ; |   XX   |            $fa35 (G)
    .byte   $00 ; |        |            $fa36 (G)

    .byte   $18 ; |   XX   |            $fa37 (G)
    .byte   $3C ; |  XXXX  |            $fa38 (G)
    .byte   $00 ; |        |            $fa39 (G)
    .byte   $30 ; |  XX    |            $fa3a (G)
    .byte   $38 ; |  XXX   |            $fa3b (G)
    .byte   $3C ; |  XXXX  |            $fa3c (G)
    .byte   $18 ; |   XX   |            $fa3d (G)
    .byte   $38 ; |  XXX   |            $fa3e (G)
    .byte   $20 ; |  X     |            $fa3f (G)
    .byte   $30 ; |  XX    |            $fa40 (G)
    .byte   $00 ; |        |            $fa41 (G)

    .byte   $18 ; |   XX   |            $fa42 (G)
    .byte   $3C ; |  XXXX  |            $fa43 (G)
    .byte   $00 ; |        |            $fa44 (G)
    .byte   $18 ; |   XX   |            $fa45 (G)
    .byte   $38 ; |  XXX   |            $fa46 (G)
    .byte   $1C ; |   XXX  |            $fa47 (G)
    .byte   $18 ; |   XX   |            $fa48 (G)
    .byte   $2C ; |  X XX  |            $fa49 (G)
    .byte   $20 ; |  X     |            $fa4a (G)
    .byte   $30 ; |  XX    |            $fa4b (G)
    .byte   $00 ; |        |            $fa4c (G)

    .byte   $18 ; |   XX   |            $fa4d (G)
    .byte   $3C ; |  XXXX  |            $fa4e (G)
    .byte   $00 ; |        |            $fa4f (G)
    .byte   $18 ; |   XX   |            $fa50 (G)
    .byte   $18 ; |   XX   |            $fa51 (G)
    .byte   $18 ; |   XX   |            $fa52 (G)
    .byte   $08 ; |    X   |            $fa53 (G)
    .byte   $16 ; |   X XX |            $fa54 (G)
    .byte   $30 ; |  XX    |            $fa55 (G)
    .byte   $20 ; |  X     |            $fa56 (G)
    .byte   $00 ; |        |            $fa57 (G)

indy_sprite
    .byte   $18 ; |   ##   |            $fa58 (G)
    .byte   $3c ; |  ####  |            $fa59 (G)
    .byte   $00 ; |        |            $fa5a (G)
    .byte   $18 ; |   ##   |            $fa5b (G)
    .byte   $3c ; |  ####  |            $fa5c (G)
    .byte   $5a ; | # ## # |            $fa5d (G)
    .byte   $3c ; |  ####  |            $fa5e (G)
    .byte   $18 ; |   ##   |            $fa5f (G)
    .byte   $18 ; |   ##   |            $fa60 (G)
    .byte   $3c ; |  ####  |            $fa61 (G)
    .byte   $00 ; |        |            $fa62 (G)

    .byte   $3C ; |  ####  |            $fa63 (G)
    .byte   $7E ; | ###### |            $fa64 (G)
    .byte   $FF ; |########|            $fa65 (G)
    .byte   $A5 ; |# #  # #|            $fa66 (G)
    .byte   $42 ; | #    # |            $fa67 (G)
    .byte   $42 ; | #    # |            $fa68 (G)
    .byte   $18 ; |   ##   |            $fa69 (G)
    .byte   $3C ; |  ####  |            $fa6a (G)
    .byte   $81 ; |#      #|            $fa6b (G)
    .byte   $5A ; | # ## # |            $fa6c (G)
    .byte   $3C ; |  ####  |            $fa6d (G)
    .byte   $3C ; |  ####  |            $fa6e (G)
    .byte   $38 ; |  ###   |            $fa6f (G)
    .byte   $18 ; |   ##   |            $fa70 (G)
    .byte   $00 ; |        |            $fa71 (G)



    .byte   $10,$10,$00,$f0,$f0,$00,$10,$00 ; $fa72 (*)
    .byte   $10,$10,$00,$f0,$00,$10,$10,$00 ; $fa7a (*)
    .byte   $10,$00,$f0,$f0,$00,$f0,$f0,$00 ; $fa82 (*)
    .byte   $f0,$f0,$00,$10,$10,$00,$f0     ; $fa8a (*)
Lfa91
    .byte   $00,$00,$e0,$00,$00,$c0,$ff,$ff ; $fa91 (*)
    .byte   $00,$ff,$ff,$f0,$f0             ; $fa99 (*)
    
Lfa9e
    .byte   $00 ; |        |            $fa9e (P)
    
    .byte   $e0,$00,$e0,$80,$00,$ff,$ff,$00 ; $fa9f (*)
    .byte   $ff,$ff,$c0,$00                 ; $faa7 (*)
    
    .byte   $00 ; |        |            $faab (P)
    
Lfaac
    .byte   $c0,$f0,$f0,$f0,$f0,$f0,$c0,$c0 ; $faac (*)
    .byte   $c0,$f0,$f0,$f0,$f0             ; $fab4 (*)
    
    .byte   $c0 ; |**      |            $fab9 (P)
    
    .byte   $f7,$f7,$f7,$f7,$f7,$37,$37,$00 ; $faba (*)
    .byte   $63,$62,$6b,$5b,$6a,$5f,$5a,$5a ; $fac2 (*)
    .byte   $6b,$5e,$67,$5a,$62,$6b,$5a,$6b ; $faca (*)
    .byte   $22,$13,$13,$18,$18,$1e,$21,$13 ; $fad2 (*)
    .byte   $21,$26,$26,$2b,$2a,$2b,$31,$31 ; $fada (*)
Lfae2
    .byte   $b4                             ; $fae2 (*)
Lfae3
    .byte   $f0,$02,$f0,$3f,$f1             ; $fae3 (*)
    .byte   $a5,$f4                         ; $fae8 (D)
    .byte   $ae,$c0,$b7,$c9                 ; $faea (*)
Lfaee
    .byte   $1b,$18,$17,$17,$18,$18,$1b,$1b ; $faee (*)
    .byte   $1d,$18,$17,$12,$18,$17,$1b,$1d ; $faf6 (*)
    .byte   $00,$00                         ; $fafe (*)
    
    .byte   $00 ; |        |            $fb00 (G)
    .byte   $00 ; |        |            $fb01 (G)
    .byte   $00 ; |        |            $fb02 (G)
    .byte   $00 ; |        |            $fb03 (G)
    .byte   $00 ; |        |            $fb04 (G)
    .byte   $00 ; |        |            $fb05 (G)
    .byte   $00 ; |        |            $fb06 (G)
    .byte   $00 ; |        |            $fb07 (G)

    .byte   $71 ; | ###   #|            $fb08 (G)
    .byte   $41 ; | #     #|            $fb09 (G)
    .byte   $41 ; | #     #|            $fb0a (G)
    .byte   $71 ; | ###   #|            $fb0b (G)
    .byte   $11 ; |   #   #|            $fb0c (G)
    .byte   $51 ; | # #   #|            $fb0d (G)
    .byte   $70 ; | ###    |            $fb0e (G)
    .byte   $00 ; |        |            $fb0f (G)

    .byte   $00 ; |        |            $fb10 (G)
    .byte   $01 ; |       #|            $fb11 (G)
    .byte   $3F ; |  ######|            $fb12(G)
    .byte   $6B ; | ## # ##|            $fb12 (G)
    .byte   $7F ; | #######|            $fb13 (G)
    .byte   $01 ; |       #|            $fb14 (G)
    .byte   $00 ; |        |            $fb15 (G)
    .byte   $00 ; |        |            $fb16 (G)

    .byte   $77 ; | ### ###|            $fb17 (G)
    .byte   $77 ; | ### ###|            $fb18 (G)
    .byte   $77 ; | ### ###|            $fb19 (G)
    .byte   $00 ; |        |            $fb1a (G)
    .byte   $00 ; |        |            $fb1b (G)
    .byte   $77 ; | ### ###|            $fb1c (G)
    .byte   $77 ; | ### ###|            $fb1d (G)
    .byte   $77 ; | ### ###|            $fb1e (G)

    .byte   $1C ; |   ###  |            $fb1f (G)
    .byte   $2A ; |  # # # |            $fb20 (G)
    .byte   $55 ; | # # # #|            $fb21 (G)
    .byte   $2A ; |  # # # |            $fb22 (G)
    .byte   $55 ; | # # # #|            $fb23 (G)
    .byte   $2A ; |  # # # |            $fb24 (G)
    .byte   $1C ; |   ###  |            $fb25 (G)
    .byte   $3E ; |  ##### |            $fb26 (G)

    .byte   $3A ; |  ### # |            $fb27 (G)
    .byte   $01 ; |       #|            $fb28 (G)
    .byte   $7D ; | ##### #|            $fb29 (G)
    .byte   $01 ; |       #|            $fb2a (G)
    .byte   $39 ; |  ###  #|            $fb2b (G)
    .byte   $02 ; |      # |            $fb2c (G)
    .byte   $3C ; |  ####  |            $fb2d (G)
    .byte   $30 ; |  ##    |            $fb2e (G)

    .byte   $2E ; |  # ### |            $fb2f (G)
    .byte   $40 ; | #      |            $fb30 (G)
    .byte   $5F ; | # #####|            $fb31 (G)
    .byte   $40 ; | #      |            $fb32 (G)
    .byte   $4E ; | #  ### |            $fb33 (G)
    .byte   $20 ; |  #     |            $fb34 (G)
    .byte   $1E ; |   #### |            $fb35 (G)
    .byte   $06 ; |     ## |            $fb36 (G)

    .byte   $00 ; |        |            $fb37 (G)
    .byte   $25 ; |  #  # #|            $fb38 (G)
    .byte   $52 ; | # #  # |            $fb39 (G)
    .byte   $7F ; | #######|            $fb3a (G)
    .byte   $50 ; | # #    |            $fb3b (G)
    .byte   $20 ; |  #     |            $fb3c (G)
    .byte   $00 ; |        |            $fb3d (G)
    .byte   $00 ; |        |            $fb3e (G)

Lfb40
    .byte   $ff ; |########|            $fb40 (G)
    .byte   $66 ; | ##  ## |            $fb41 (G)
    .byte   $24 ; |  #  #  |            $fb42 (G)
    .byte   $24 ; |  #  #  |            $fb43 (G)
    .byte   $66 ; | ##  ## |            $fb44 (G)
    .byte   $e7 ; |###  ###|            $fb45 (G)
    .byte   $c3 ; |##    ##|            $fb46 (G)

    .byte   $e7 ; |###  ###|            $fb47 (G)
    
    .byte   $17 ; |   # ###|            $fb48 (G)
    .byte   $15 ; |   # # #|            $fb49 (G)
    .byte   $15 ; |   # # #|            $fb4a (G)
    .byte   $77 ; | ### ###|            $fb4b (G)
    .byte   $55 ; | # # # #|            $fb4c (G)
    .byte   $55 ; | # # # #|            $fb4d (G)
    .byte   $77 ; | ### ###|            $fb4e (G)
    .byte   $00 ; |        |            $fb4f (G)

    .byte   $21 ; |  #    #|            $fb50 (G)
    .byte   $11 ; |   #   #|            $fb51 (G)
    .byte   $09 ; |    #  #|            $fb52 (G)
    .byte   $11 ; |   #   #|            $fb53 (G)
    .byte   $22 ; |  #   # |            $fb54 (G)
    .byte   $44 ; | #   #  |            $fb55 (G)
    .byte   $28 ; |  # #   |            $fb56 (G)
    .byte   $10 ; |   #    |            $fb57 (G)

    .byte   $01 ; |       #|            $fb58 (G)
    .byte   $03 ; |      ##|            $fb59 (G)
    .byte   $07 ; |     ###|            $fb5a (G)
    .byte   $0F ; |    ####|            $fb5b (G)
    .byte   $06 ; |     ## |            $fb5c (G)
    .byte   $0C ; |    ##  |            $fb5d (G)
    .byte   $18 ; |   ##   |            $fb5e (G)
    .byte   $3C ; |  ####  |            $fb5f (G)
    
    .byte   $79 ; | ####  #|            $fb60 (G)
    .byte   $85 ; |#    # #|            $fb61 (G)
    .byte   $b5 ; |# ## # #|            $fb62 (G)
    .byte   $a5 ; |# #  # #|            $fb63 (G)
    .byte   $b5 ; |# ## # #|            $fb64 (G)
    .byte   $85 ; |#    # #|            $fb65 (G)
    .byte   $79 ; | ####  #|            $fb66 (G)
    .byte   $00 ; |        |            $fb67 (G)
 
    .byte   $00 ; |        |            $fb68 (G)
    .byte   $60 ; | ##     |            $fb69 (G)
    .byte   $60 ; | ##     |            $fb6a (G)
    .byte   $78 ; | ####   |            $fb6b (G)
    .byte   $68 ; | ## #   |            $fb6c (G)
    .byte   $3F ; |  ######|            $fb6d (G)
    .byte   $5F ; | # #####|            $fb6e (G)
    .byte   $00 ; |        |            $fb6f (G)

    .byte   $08 ; |    #   |            $fb70 (G)
    .byte   $1C ; |   ###  |            $fb71 (G)
    .byte   $22 ; |  #   # |            $fb72 (G)
    .byte   $49 ; | #  #  #|            $fb73 (G)
    .byte   $6B ; | ## # ##|            $fb74 (G)
    .byte   $00 ; |        |            $fb75 (G)
    .byte   $1C ; |   ###  |            $fb76 (G)
    .byte   $08 ; |    #   |            $fb77 (G)

    .byte   $7F ; | #######|            $fb78 (G)
    .byte   $5D ; | # ### #|            $fb79 (G)
    .byte   $77 ; | ### ###|            $fb7a (G)
    .byte   $77 ; | ### ###|            $fb7b (G)
    .byte   $5D ; | # ### #|            $fb7c (G)
    .byte   $7F ; | #######|            $fb7d (G)
    .byte   $08 ; |    #   |            $fb7e (G)
    .byte   $1C ; |   ###  |            $fb7f (G)

    .byte   $3E ; |  ##### |            $fb80 (G)
    .byte   $1C ; |   ###  |            $fb81 (G)
    .byte   $49 ; | #  #  #|            $fb82 (G)
    .byte   $7F ; | #######|            $fb83 (G)
    .byte   $49 ; | #  #  #|            $fb84 (G)
    .byte   $1C ; |   ###  |            $fb85 (G)
    .byte   $36 ; |  ## ## |            $fb86 (G)
    .byte   $1C ; |   ###  |            $fb87 (G)

    .byte   $16 ; |   # ## |            $fb88 (G)
    .byte   $0B ; |    # ##|            $fb89 (G)
    .byte   $0D ; |    ## #|            $fb8a (G)
    .byte   $05 ; |     # #|            $fb8b (G)
    .byte   $17 ; |   # ###|            $fb8c (G)
    .byte   $36 ; |  ## ## |            $fb8d (G)
    .byte   $64 ; | ##  #  |            $fb8e (G)
    .byte   $04 ; |     #  |            $fb8f (G)

    .byte   $77 ; | ### ###|            $fb90 (G)
    .byte   $36 ; |  ## ## |            $fb91 (G)
    .byte   $14 ; |   # #  |            $fb92 (G)
    .byte   $22 ; |  #   # |            $fb93 (G)
    .byte   $22 ; |  #   # |            $fb94 (G)
    .byte   $14 ; |   # #  |            $fb95 (G)
    .byte   $36 ; |  ## ## |            $fb96 (G)
    .byte   $77 ; | ### ###|            $fb97 (G)

    .byte   $3E ; |  ##### |            $fb98 (G)
    .byte   $41 ; | #     #|            $fb99 (G)
    .byte   $41 ; | #     #|            $fb9a (G)
    .byte   $49 ; | #  #  #|            $fb9b (G)
    .byte   $49 ; | #  #  #|            $fb9c (G)
    .byte   $49 ; | #  #  #|            $fb9d (G)
    .byte   $3E ; |  ##### |            $fb9e (G)
    .byte   $1C ; |   ###  |            $fb9f (G)

    .byte   $3E ; |  ##### |            $fba0 (G)
    .byte   $41 ; | #     #|            $fba1 (G)
    .byte   $41 ; | #     #|            $fba2 (G)
    .byte   $49 ; | #  #  #|            $fba3 (G)
    .byte   $45 ; | #   # #|            $fba4 (G)
    .byte   $43 ; | #    ##|            $fba5 (G)
    .byte   $3E ; |  ##### |            $fba6 (G)
    .byte   $1C ; |   ###  |            $fba7 (G)

    .byte   $3E ; |  ##### |            $fba8 (G)
    .byte   $41 ; | #     #|            $fba9 (G)
    .byte   $41 ; | #     #|            $fbaa (G)
    .byte   $4F ; | #  ####|            $fbab (G)
    .byte   $41 ; | #     #|            $fbac (G)
    .byte   $41 ; | #     #|            $fbad (G)
    .byte   $3E ; |  ##### |            $fbae (G)
    .byte   $1C ; |   ###  |            $fbaf (G)

    .byte   $3E ; |  ##### |            $fbb0 (G)
    .byte   $43 ; | #    ##|            $fbb1 (G)
    .byte   $45 ; | #   # #|            $fbb2 (G)
    .byte   $49 ; | #  #  #|            $fbb3 (G)
    .byte   $41 ; | #     #|            $fbb4 (G)
    .byte   $41 ; | #     #|            $fbb5 (G)
    .byte   $3E ; |  ##### |            $fbb6 (G)
    .byte   $1C ; |   ###  |            $fbb7 (G)

    .byte   $3E ; |  ##### |            $fbb8 (G)
    .byte   $49 ; | #  #  #|            $fbb9 (G)
    .byte   $49 ; | #  #  #|            $fbba (G)
    .byte   $49 ; | #  #  #|            $fbbb (G)
    .byte   $41 ; | #     #|            $fbbc (G)
    .byte   $41 ; | #     #|            $fbbd (G)
    .byte   $3E ; |  ##### |            $fbbe (G)
    .byte   $1C ; |   ###  |            $fbbf (G)

    .byte   $3E ; |  ##### |            $fbc0 (G)
    .byte   $61 ; | ##    #|            $fbc1 (G)
    .byte   $51 ; | # #   #|            $fbc2 (G)
    .byte   $49 ; | #  #  #|            $fbc3 (G)
    .byte   $41 ; | #     #|            $fbc4 (G)
    .byte   $41 ; | #     #|            $fbc5 (G)
    .byte   $3E ; |  ##### |            $fbc6 (G)
    .byte   $1C ; |   ###  |            $fbc7 (G)

    .byte   $3E ; |  ##### |            $fbc8 (G)
    .byte   $41 ; | #     #|            $fbc9 (G)
    .byte   $41 ; | #     #|            $fbca (G)
    .byte   $79 ; | ####  #|            $fbcb (G)
    .byte   $41 ; | #     #|            $fbcc (G)
    .byte   $41 ; | #     #|            $fbcd (G)
    .byte   $3E ; |  ##### |            $fbce (G)
    .byte   $1C ; |   ###  |            $fbcf (G)

    .byte   $3E ; |  ##### |            $fbd0 (G)
    .byte   $41 ; | #     #|            $fbd1 (G)
    .byte   $41 ; | #     #|            $fbd2 (G)
    .byte   $49 ; | #  #  #|            $fbd3 (G)
    .byte   $51 ; | # #   #|            $fbd4 (G)
    .byte   $61 ; | ##    #|            $fbd5 (G)
    .byte   $3E ; |  ##### |            $fbd6 (G)
    .byte   $1C ; |   ###  |            $fbd7 (G)

    .byte   $49 ; | #  #  #|            $fbd8 (G)
    .byte   $49 ; | #  #  #|            $fbd9 (G)
    .byte   $49 ; | #  #  #|            $fbda (G)
    .byte   $C9 ; |##  #  #|            $fbdb (G)
    .byte   $49 ; | #  #  #|            $fbdc (G)
    .byte   $49 ; | #  #  #|            $fbdd (G)
    .byte   $BE ; |# ##### |            $fbde (G)
    .byte   $00 ; |        |            $fbdf (G) 

    .byte   $55 ; | # # # #|            $fbe0 (G)
    .byte   $55 ; | # # # #|            $fbe1 (G)
    .byte   $55 ; | # # # #|            $fbe2 (G)
    .byte   $d9 ; |## ##  #|            $fbe3 (G)
    .byte   $55 ; | # # # #|            $fbe4 (G)
    .byte   $55 ; | # # # #|            $fbe5 (G)
    .byte   $99 ; |#  ##  #|            $fbe6 (G)
    .byte   $00 ; |        |            $fbe7 (G)
    
Lfbe8
    .byte   $14                             ; $fbe8 (D)
    .byte   $14,$14,$0f,$10,$12,$0b,$0b,$0b ; $fbe9 (*)
    .byte   $10,$12,$14,$17,$17,$17,$17     ; $fbf1 (*)
    .byte   $18,$1b,$0f,$0f,$0f,$14,$17,$18 ; $fbf8 (D)


    .byte   $14 ; |   # #  |            $fc00 (G)
    .byte   $3C ; |  ####  |            $fc01 (G)
    .byte   $7E ; | ###### |            $fc02 (G)
    .byte   $00 ; |        |            $fc03 (G)
    .byte   $30 ; |  ##    |            $fc04 (G)
    .byte   $38 ; |  ###   |            $fc05 (G)
    .byte   $3C ; |  ####  |            $fc06 (G)
    .byte   $3E ; |  ##### |            $fc07 (G)
    .byte   $3F ; |  ######|            $fc08 (G)
    .byte   $7F ; | #######|            $fc09 (G)
    .byte   $7F ; | #######|            $fc0a (G)
    .byte   $7F ; | #######|            $fc0b (G)
    .byte   $11 ; |   #   #|            $fc0c (G)
    .byte   $11 ; |   #   #|            $fc0d (G)
    .byte   $33 ; |  ##  ##|            $fc0e (G)
    .byte   $00 ; |        |            $fc0f (G)

    .byte   $14 ; |   # #  |            $fc10 (G)
    .byte   $3C ; |  ####  |            $fc11 (G)
    .byte   $7E ; | ###### |            $fc12 (G)
    .byte   $00 ; |        |            $fc13 (G)
    .byte   $30 ; |  ##    |            $fc14 (G)
    .byte   $38 ; |  ###   |            $fc15 (G)
    .byte   $3C ; |  ####  |            $fc16 (G)
    .byte   $3E ; |  ##### |            $fc17 (G)
    .byte   $3F ; |  ######|            $fc18 (G)
    .byte   $7F ; | #######|            $fc19 (G)
    .byte   $7F ; | #######|            $fc1a (G)
    .byte   $7F ; | #######|            $fc1b (G)
    .byte   $22 ; |  #   # |            $fc1c (G)
    .byte   $22 ; |  #   # |            $fc1d (G)
    .byte   $66 ; | ##  ## |            $fc1e (G)
    .byte   $00 ; |        |            $fc1f (G)

    .byte   $14 ; |   # #  |            $fc20 (G)
    .byte   $3C ; |  ####  |            $fc21 (G)
    .byte   $7E ; | ###### |            $fc22 (G)
    .byte   $00 ; |        |            $fc23 (G)
    .byte   $30 ; |  ##    |            $fc24 (G)
    .byte   $38 ; |  ###   |            $fc25 (G)
    .byte   $3C ; |  ####  |            $fc26 (G)
    .byte   $3E ; |  ##### |            $fc27 (G)
    .byte   $3F ; |  ######|            $fc28 (G)
    .byte   $7F ; | #######|            $fc29 (G)
    .byte   $7F ; | #######|            $fc2a (G)
    .byte   $7F ; | #######|            $fc2b (G)
    .byte   $44 ; | #   #  |            $fc2c (G)
    .byte   $44 ; | #   #  |            $fc2d (G)
    .byte   $CC ; |##  ##  |            $fc2e (G)
    .byte   $00 ; |        |            $fc2f (G)

    .byte   $14 ; |   # #  |            $fc30 (G)
    .byte   $3C ; |  ####  |            $fc31 (G)
    .byte   $7E ; | ###### |            $fc32 (G)
    .byte   $00 ; |        |            $fc33 (G)
    .byte   $30 ; |  ##    |            $fc34 (G)
    .byte   $38 ; |  ###   |            $fc35 (G)
    .byte   $3C ; |  ####  |            $fc36 (G)
    .byte   $3E ; |  ##### |            $fc37 (G)
    .byte   $3F ; |  ######|            $fc38 (G)
    .byte   $7F ; | #######|            $fc39 (G)
    .byte   $7F ; | #######|            $fc3a (G)
    .byte   $7F ; | #######|            $fc3b (G)
    .byte   $08 ; |    #   |            $fc3c (G)
    .byte   $08 ; |    #   |            $fc3d (G)
    .byte   $18 ; |   ##   |            $fc3e (G)
    .byte   $00 ; |        |            $fc3f (G)
	
	

Lfc40
    .byte   $00,$10,$20,$30,$7c,$0f,$7c,$00 ; $fc40 (*)
    .byte   $0a,$02,$04,$06,$08,$0a,$08,$06 ; $fc48 (*)
    .byte   $98,$98,$9e,$9e,$00,$00,$00,$00 ; $fc50 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$08 ; $fc58 (*)
    .byte   $1c,$3c,$3e,$7f,$ff,$ff,$ff,$ff ; $fc60 (*)
    .byte   $ff,$ff,$ff,$ff,$3e,$3c,$3a,$38 ; $fc68 (*)
    .byte   $36,$34,$32,$20,$10,$00,$00,$00 ; $fc70 (*)
    .byte   $00,$08,$00,$02,$0a,$0c,$0e,$01 ; $fc78 (*)
    .byte   $03,$04,$06,$05,$07,$0d,$0f,$0b ; $fc80 (*)
Lfc88
    .byte   $e0                             ; $fc88 (*)
Lfc89
    .byte   $f6,$32,$f8,$3d,$f8,$ae,$f6,$27 ; $fc89 (*)
    .byte   $f7,$62,$f6,$a7,$f7,$3e,$f5,$df ; $fc91 (*)
    .byte   $f7,$34,$f5,$9c,$f5,$37,$f6,$29 ; $fc99 (*)
    .byte   $f6,$1a,$38,$09,$26,$26,$46,$1a ; $fca1 (*)
    .byte   $38,$04,$11,$10,$12             ; $fca9 (*)
	
	
    .byte   $54 ; | # # #  |            $fcae (G)
    .byte   $FC ; |######  |            $fcaf (G)
    .byte   $5F ; | # #####|            $fcb0 (G)
    .byte   $FE ; |####### |            $fcb1 (G)
    .byte   $7F ; | #######|            $fcb2 (G)
    .byte   $FA ; |##### # |            $fcb3 (G)
    .byte   $3F ; |  ######|            $fcb4 (G)
    .byte   $2A ; |  # # # |            $fcb5 (G)
    .byte   $00 ; |        |            $fcb6 (G)
    .byte   $54 ; | # # #  |            $fcb7 (G)
    .byte   $5F ; | # #####|            $fcb8 (G)
    .byte   $FC ; |######  |            $fcb9 (G)
    .byte   $7F ; | #######|            $fcba (G)
    .byte   $FE ; |####### |            $fcbb (G)
    .byte   $3F ; |  ######|            $fcbc (G)
    .byte   $FA ; |##### # |            $fcbd (G)
    .byte   $2A ; |  # # # |            $fcbe (G)
    .byte   $00 ; |        |            $fcbf (G)
    .byte   $2A ; |  # # # |            $fcc0 (G)
    .byte   $FA ; |##### # |            $fcc1 (G)
    .byte   $3F ; |  ######|            $fcc2 (G)
    .byte   $FE ; |####### |            $fcc3 (G)
    .byte   $7F ; | #######|            $fcc4 (G)
    .byte   $FA ; |##### # |            $fcc5 (G)
    .byte   $5F ; | # #####|            $fcc6 (G)
    .byte   $54 ; | # # #  |            $fcc7 (G)
    .byte   $00 ; |        |            $fcc8 (G)
    .byte   $2A ; |  # # # |            $fcc9 (G)
    .byte   $3F ; |  ######|            $fcca (G)
    .byte   $FA ; |##### # |            $fccb (G)
    .byte   $7F ; | #######|            $fccc (G)
    .byte   $FE ; |####### |            $fccd (G)
    .byte   $5F ; | # #####|            $fcce (G)
    .byte   $FC ; |######  |            $fccf (G)
    .byte   $54 ; | # # #  |            $fcd0 (G)


    .byte   $00,$8b,$8a,$86,$87,$85,$89,$03 ; $fcd1 (*)
    .byte   $01,$00,$01,$03,$02,$01,$03,$02 ; $fcd9 (*)
    .byte   $03,$01,$02,$04,$08,$10,$20,$40 ; $fce1 (*)
    .byte   $80                             ; $fce9 (*)
    
Lfcea
    ror                             ;2         * ; 2
    bcs     Lfcef                   ;2/3       * ; 2
    dec     enemy_y,x                ;6   =  10 * ; 6
Lfcef
    ror                             ;2         * ; 2
    bcs     Lfcf4                   ;2/3       * ; 2
    inc     enemy_y,x                ;6   =  10 * ; 6
Lfcf4
    ror                             ;2         * ; 2
    bcs     Lfcf9                   ;2/3       * ; 2
    dec     enemy_x,x                ;6   =  10 * ; 6
Lfcf9
    ror                             ;2         * ; 2
    bcs     Lfcfe                   ;2/3       * ; 2
    inc     enemy_x,x                ;6   =  10 * ; 6
Lfcfe
    rts                             ;6   =   6 * ; 6
    
    .byte   $00,$f2,$40,$f2,$c0,$12,$10,$f2 ; $fcff (*)
    .byte   $00,$12,$20,$02,$b0,$f2,$30,$12 ; $fd07 (*)
    .byte   $00,$f2,$40,$f2,$d0,$12,$10,$02 ; $fd0f (*)
    .byte   $00,$02,$30,$12,$b0,$02,$20,$12 ; $fd17 (*)
    .byte   $00,$ff,$ff,$fc,$f0,$e0,$e0,$c0 ; $fd1f (*)
    .byte   $80,$00,$00,$00,$00,$00,$00,$00 ; $fd27 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fd2f (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fd37 (*)
    .byte   $00,$00,$80,$80,$c0,$e0,$e0,$f0 ; $fd3f (*)
    .byte   $fe,$ff,$ff,$ff,$ff,$fc,$f0,$e0 ; $fd47 (*)
    .byte   $e0,$c0,$80,$00,$00,$00,$00,$00 ; $fd4f (*)
    .byte   $00,$00,$00,$00,$00,$00,$c0,$f0 ; $fd57 (*)
    .byte   $f8,$fe,$fe,$f8,$f0,$e0,$c0,$80 ; $fd5f (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fd67 (*)
    .byte   $00,$02,$07,$07,$0f,$0f,$0f,$07 ; $fd6f (*)
    .byte   $07,$02,$00,$00,$00,$00,$00,$00 ; $fd77 (*)
    .byte   $00,$00,$04,$0e,$0e,$0f,$0e,$06 ; $fd7f (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fd87 (*)
    .byte   $00,$00,$02,$07,$07,$0f,$1f,$0f ; $fd8f (*)
    .byte   $07,$07,$02,$00,$00,$00,$00,$00 ; $fd97 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$01 ; $fd9f (*)
    .byte   $03,$01,$00,$00,$00,$00,$00,$80 ; $fda7 (*)
    .byte   $80,$c0,$e0,$f8,$e0,$c0,$80,$80 ; $fdaf (*)
    .byte   $00,$00,$00,$c0,$e0,$e0,$c0,$00 ; $fdb7 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fdbf (*)
    .byte   $00,$80,$80,$80,$80,$80,$80,$00 ; $fdc7 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fdcf (*)
    .byte   $00,$c0,$e0,$e0,$c0,$00,$00,$00 ; $fdd7 (*)
    .byte   $00,$22,$41,$08,$14,$08,$41,$22 ; $fddf (*)
    .byte   $00,$41,$08,$14,$2a,$14,$08,$41 ; $fde7 (*)
    .byte   $00,$08,$14,$3e,$55,$3e,$14,$08 ; $fdef (*)
    .byte   $00,$14,$3e,$63,$2a,$63,$3e,$14 ; $fdf7 (*)
    .byte   $00,$07,$07,$07,$03,$03,$03,$01 ; $fdff (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fe07 (*)
    .byte   $30,$78,$7c,$3c,$3c,$18,$08,$00 ; $fe0f (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fe17 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fe1f (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$01 ; $fe27 (*)
    .byte   $0f,$01,$00,$00,$00,$00,$00,$00 ; $fe2f (*)
    .byte   $00,$80,$c0,$e0,$f8,$fc,$fe,$fc ; $fe37 (*)
    .byte   $f0,$e0,$c0,$c0,$80,$80,$00,$00 ; $fe3f (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fe47 (*)
    .byte   $00,$03,$07,$03,$01,$00,$00,$00 ; $fe4f (*)
    .byte   $00,$00,$80,$e0,$f8,$f8,$f8,$f8 ; $fe57 (*)
    .byte   $f0,$c0,$80,$00,$00,$00,$00,$00 ; $fe5f (*)
    .byte   $00,$00,$00,$03,$0f,$1f,$3f,$3e ; $fe67 (*)
    .byte   $3c,$38,$30,$00,$00,$00,$00,$00 ; $fe6f (*)
    .byte   $00,$07,$07,$07,$03,$03,$03,$01 ; $fe77 (*)
    .byte   $00,$00,$00,$00,$00,$00,$80,$80 ; $fe7f (*)
    .byte   $c0,$e0,$e0,$c0,$c0,$80,$00,$00 ; $fe87 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fe8f (*)
    .byte   $30,$38,$1c,$1e,$0e,$0c,$0c,$00 ; $fe97 (*)
    .byte   $00,$00,$80,$80,$c0,$f0,$fc,$ff ; $fe9f (*)
    .byte   $ff,$ff,$ff,$fe,$fc,$f8,$f0,$e0 ; $fea7 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $feaf (*)
    .byte   $00,$00,$80,$e0,$f0,$e0,$80,$00 ; $feb7 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $febf (*)
    .byte   $03,$07,$03,$03,$01,$01,$00,$00 ; $fec7 (*)
    .byte   $00,$80,$c0,$f0,$f0,$e0,$e0,$c0 ; $fecf (*)
    .byte   $c0,$80,$80,$00,$00,$00,$00,$00 ; $fed7 (*)
    .byte   $00,$00,$03,$07,$07,$03,$01,$00 ; $fedf (*)
    .byte   $00,$c0,$e0,$f0,$f8,$f8,$fc,$fc ; $fee7 (*)
    .byte   $fc                             ; $feef (*)
    
Lfef0
    .byte   $3c ; |  ####  |            $fef0 (G)
    .byte   $3c ; |  ####  |            $fef1 (G)
    .byte   $7e ; | ###### |            $fef2 (G)
    .byte   $ff ; |########|            $fef3 (G)
    
Lfef4
    lda     ram_8C,x                ;4         ; 4
    bmi     Lfef9                   ;2/3       ; 2
    rts                             ;6   =  12 ; 6
    
Lfef9
    jsr     Lfcea                   ;6         * ; 6
    jsr     Lf8e1                   ;6         * ; 6
    rts                             ;6   =  18 * ; 6
    
    .byte   $80,$00,$07,$04,$77,$71,$75,$57 ; $ff00 (*)
    .byte   $50,$00,$d6,$1c,$36,$1c,$49,$7f ; $ff08 (*)
    .byte   $49,$1c,$3e,$00,$b9,$8a,$a1,$81 ; $ff10 (*)
    .byte   $00,$00,$00,$00,$00,$00,$1c,$70 ; $ff18 (*)
    .byte   $07,$70,$0e,$00,$cf,$a6,$00,$81 ; $ff20 (*)
    .byte   $77,$36,$14,$22,$ae,$14,$36,$77 ; $ff28 (*)
    .byte   $00,$bf,$ce,$00,$ef,$81,$00,$00 ; $ff30 (*)
    .byte   $00,$00,$00,$00,$68,$2f,$0a,$0c ; $ff38 (*)
    .byte   $08,$00,$80,$81,$00,$00,$07,$01 ; $ff40 (*)
    .byte   $57,$54,$77,$50,$50,$00,$00,$00 ; $ff48 (*)
    .byte   $00,$80,$7e,$86,$80,$a6,$5a,$7e ; $ff50 (*)
    .byte   $80,$7f,$00,$b1,$f9,$f6,$06,$1e ; $ff58 (*)
    .byte   $12,$1e,$12,$1e,$7f,$00,$b9,$00 ; $ff60 (*)
    .byte   $d4,$00,$81,$1c,$2a,$55,$2a,$14 ; $ff68 (*)
    .byte   $3e,$00,$c1,$e6,$00,$00,$00,$81 ; $ff70 (*)
    .byte   $7f,$55,$2a,$55,$2a,$3e,$00,$b9 ; $ff78 (*)
    .byte   $86,$91,$81,$7e,$80,$86,$a6,$5a ; $ff80 (*)
    .byte   $7e,$86,$7f,$00,$d6,$77,$77,$80 ; $ff88 (*)
    .byte   $d6,$77,$00,$c1,$b6,$a1,$81,$1c ; $ff90 (*)
    .byte   $2a,$55,$2a,$14,$3e,$00,$00,$00 ; $ff98 (*)
    .byte   $00,$00,$86,$70,$5f,$72,$05,$00 ; $ffa0 (*)
    .byte   $c1,$00,$81,$84,$1f,$89,$f9,$91 ; $ffa8 (*)
    .byte   $f9,$18,$81,$80,$1c,$1f,$f1,$7f ; $ffb0 (*)
    .byte   $89,$f9,$f9,$89,$91,$f1,$f9,$89 ; $ffb8 (*)
    .byte   $f9,$f9,$89,$f9,$89,$f9,$89,$3f ; $ffc0 (*)
    .byte   $91,$81,$70,$40,$84,$89,$7e,$f9 ; $ffc8 (*)
    .byte   $91,$f9,$f1,$00,$b9,$84,$00,$00 ; $ffd0 (*)
    .byte   $89,$38,$78,$7b,$f9,$89,$f9,$6f ; $ffd8 (*)
    .byte   $00,$b1,$92,$e9,$f9,$00,$30,$30 ; $ffe0 (*)
    .byte   $30,$e9,$30,$30,$30,$10,$00,$00 ; $ffe8 (*)
    .byte   $00,$00                         ; $fff0 (*)
Lfff2
    .byte   $a4                             ; $fff2 (D)
    .byte   $15,$95,$06,$86,$f7             ; $fff3 (*)
Lfff8
    .byte   $00                             ; $fff8 (D)
    .byte   $00,$00,$f0                     ; $fff9 (*)
    .byte   $00,$f0                         ; $fffc (D)
    .byte   $00                             ; $fffe (*)
    .byte   $f0                             ; $ffff (*)
