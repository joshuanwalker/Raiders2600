;==============================================================================
; T I A - C O N S T A N T S
;==============================================================================

HMOVE_L7          =  $70
HMOVE_L6          =  $60
HMOVE_L5          =  $50
HMOVE_L4          =  $40
HMOVE_L3          =  $30
HMOVE_L2          =  $20
HMOVE_L1          =  $10
HMOVE_0           =  $00
HMOVE_R1          =  $F0
HMOVE_R2          =  $E0
HMOVE_R3          =  $D0
HMOVE_R4          =  $C0
HMOVE_R5          =  $B0
HMOVE_R6          =  $A0
HMOVE_R7          =  $90
HMOVE_R8          =  $80

; values for ENAMx and ENABL
DISABLE_BM        = %00
ENABLE_BM         = %10

; values for RESMPx
LOCK_MISSILE      = %10
UNLOCK_MISSILE    = %00

; values for REFPx:
NO_REFLECT        = %0000
REFLECT           = %1000

; values for NUSIZx:
ONE_COPY          = %000
TWO_COPIES        = %001
TWO_MED_COPIES    = %010
THREE_COPIES      = %011
TWO_WIDE_COPIES   = %100
DOUBLE_SIZE       = %101
THREE_MED_COPIES  = %110
QUAD_SIZE         = %111
MSBL_SIZE1        = %000000
MSBL_SIZE2        = %010000
MSBL_SIZE4        = %100000
MSBL_SIZE8        = %110000

; values for CTRLPF:
PF_PRIORITY       = %100
PF_SCORE          = %10
PF_REFLECT        = %01
PF_NO_REFLECT     = %00

; values for SWCHB
P1_DIFF_MASK      = %10000000
P0_DIFF_MASK      = %01000000
BW_MASK           = %00001000
SELECT_MASK       = %00000010
RESET_MASK        = %00000001

VERTICAL_DELAY    = 1

; SWCHA joystick bits:
MOVE_RIGHT        = %01111111
MOVE_LEFT         = %10111111
MOVE_DOWN         = %11011111
MOVE_UP           = %11101111
P0_JOYSTICK_MASK  = %11110000
P1_JOYSTICK_MASK  = %00001111
P0_NO_MOVE        = P0_JOYSTICK_MASK
P1_NO_MOVE        = P1_JOYSTICK_MASK
NO_MOVE           = P0_NO_MOVE | P1_NO_MOVE
P0_HORIZ_MOVE     = MOVE_RIGHT & MOVE_LEFT & P0_NO_MOVE
P0_VERT_MOVE      = MOVE_UP & MOVE_DOWN & P0_NO_MOVE
P1_HORIZ_MOVE     = [(MOVE_RIGHT & MOVE_LEFT) >> 4] & P1_NO_MOVE
P1_VERT_MOVE      = [(MOVE_UP & MOVE_DOWN) >> 4] & P1_NO_MOVE

; SWCHA paddle bits:
P0_TRIGGER_PRESSED = %01111111
P1_TRIGGER_PRESSED = %10111111
P2_TRIGGER_PRESSED = %11110111
P3_TRIGGER_PRESSED = %11111011

; values for VBLANK:
DUMP_PORTS        = %10000000
ENABLE_LATCHES    = %01000000
DISABLE_TIA       = %00000010
ENABLE_TIA        = %00000000

;values for VSYNC:
START_VERT_SYNC   = %10
STOP_VERT_SYNC    = %00