; DisassembLy of ~\Projects\Programming\reversing\6502\raiders\raiders.bin
; DisassembLed 07/02/23 15:14:09
; Using SteLLa 6.7
;
; ROM properties name : Raiders of the Lost Ark (1982) (Atari)
; ROM properties MD5  : f724d3dd2471ed4cf5f191dbb724b69f
; Bankswitch type	  : F8* (8K)
;
; Legend: *	 = CODE not yet run (tentative code)
;		  D	 = DATA directive (referenced in some way)
;		  G	 = GFX directive, shown as '#' (stored in pLayer, missiLe, baLL)
;		  P	 = PGFX directive, shown as '*' (stored in pLayfieLd)
;		  C	 = COL directive, shown as coLor constants (stored in pLayer coLor)
;		  CP = PCOL directive, shown as coLor constants (stored in pLayfieLd coLor)
;		  CB = BCOL directive, shown as coLor constants (stored in background coLor)
;		  A	 = AUD directive (stored in audio registers)
;		  i	 = indexed accessed onLy
;		  c	 = used by code executed in RAM
;		  s	 = used by stack
;		  !	 = page crossed, 1 cycLe penaLty

	processor 6502


;-----------------------------------------------------------
;	   CoLor constants
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


;--------------------
;Const Experiment
;---------------------
key_obj = $07

;-----------------------------------------------------------
;	   TIA and IO constants accessed
;-----------------------------------------------------------

CXM0P			= $30  ; (R)
CXM1P			= $31  ; (R)
CXP1FB			= $33  ; (R)
CXM1FB			= $35  ; (R)
CXPPMM			= $37  ; (R)
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
;RESM0			= $12  ; (Wi)
;RESM1			= $13  ; (Wi)
RESBL			= $14  ; (W)
AUDC0			= $15  ; (W)
;AUDC1			= $16  ; (Wi)
AUDF0			= $17  ; (W)
;AUDF1			= $18  ; (Wi)
AUDV0			= $19  ; (W)
;AUDV1			= $1a  ; (Wi)
GRP0			= $1b  ; (W)
GRP1			= $1c  ; (W)
ENAM0			= $1d  ; (W)
ENAM1			= $1e  ; (W)
ENABL			= $1f  ; (W)
HMP0			= $20  ; (W)
HMP1			= $21  ; (W)
;HMM0			= $22  ; (Wi)
;HMM1			= $23  ; (Wi)
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
;	   RIOT RAM (zero-page) LabeLs
;-----------------------------------------------------------

zero_page		= $00
scan_Line		= $80
room_num		= $81
frame_counter	= $82
time_of_day		= $83
ram_84			= $84; (c)
ram_85			= $85; (c)
ram_86			= $86; (c)
ram_87			= $87; (c)
ram_88			= $88; (c)
ram_89			= $89; (c)
ram_8A			= $8a
ram_8B			= $8b
ram_8C			= $8c
ram_8D			= $8d
ram_8E			= $8e
ram_8F			= $8f
ram_90			= $90
ram_91			= $91
indy_dir		= $92
ram_93			= $93
room_pf_cfg			= $94
ram_95			= $95
ram_96			= $96
ram_97			= $97
ram_98			= $98
ram_99			= $99
ram_9A			= $9a
ram_9B			= $9b
ram_9C			= $9c
ram_9D			= $9d
score			= $9e
lives_left		= $9f
num_buLLets		= $a0
ram_A1			= $a1
ram_A2			= $a2
ram_A3			= $a3
diamond_h		= $a4
grenade_used	= $a5
escape_hatch_used		= $a6
shovel_used		= $a7
parachute_used	= $a8
ankh_used		= $a9
yar_found		= $aa
ark_found		= $ab
thief_shot		= $ac
mesa_entered	= $ad
unknown_action	= $ae
ram_AF			= $af

ram_B1			= $b1
ram_B2			= $b2

ram_B4			= $b4
ram_B5			= $b5
ram_B6			= $b6
inv_slot_lo	= $b7
inv_slot_hi	= $b8
inv_slot2_lo	= $b9
inv_slot2_hi	= $ba
inv_slot3_lo	= $bb
inv_slot3_hi	= $bc
inv_slot4_Lo	= $bd
inv_slot4_hi	= $be
inv_slot5_lo	= $bf
inv_slot5_hi	= $c0
inv_slot6_Lo	= $c1
inv_slot6_hi	= $c2
cursor_pos		= $c3
ram_C4			= $c4
current_object	= $c5
ram_C6			= $c6
ram_C7			= $c7
enemy_x			= $c8
indy_x			= $c9
ram_CA			= $ca
ram_CB			= $cb
ram_CC			= $cc

enemy_y			= $ce
indy_y			= $cf
ram_D0			= $d0
ram_D1			= $d1
ram_D2			= $d2

ram_D4			= $d4
ram_D5			= $d5
ram_D6			= $d6
ram_D7			= $d7
ram_D8			= $d8
indy_anim		= $d9
ram_DA			= $da
indy_h			= $db
snake_y			= $dc
emy_anim		= $dd
ram_DE			= $de
ram_DF			= $df
ram_E0			= $e0
PF1_data		= $e1
ram_E2			= $e2
PF2_data		= $e3
ram_E4			= $e4
ram_E5			= $e5
ram_E6			= $e6
ram_E7			= $e7
ram_E8			= $e8
ram_E9			= $e9
ram_EA			= $ea
ram_EB			= $eb
ram_EC			= $ec
ram_ED			= $ed
ram_EE			= $ee
;				  $ef  (i)
;				  $f0  (i)
;				  $f1  (i)
;				  $f2  (i)

;				  $fc  (s)
;				  $fd  (s)
;				  $fe  (s)
;				  $ff  (s)


;-----------------------------------------------------------
;	   User Defined LabeLs
;-----------------------------------------------------------

;Break			 = $dd68


;***********************************************************
;	   Bank 0 / 0..1
;***********************************************************

	SEG		CODE
	ORG		$0000
	RORG	$d000

;NOTE: 1st bank's vector points right at the coLd start routine
	lda	   $FFF8					;trigger 1st bank

Ld003
	jmp		game_start				;cold start

Ld006
	ldx		#$04					;2	 =	 2
Ld008
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	lda		enemy_x,x				 ;4
	tay								;2
	lda		room_miss0_size_tabl,y					;4
	sta		HMP0,x					;4
	and		#$0f					;2
	tay								;2	 =	18
Ld015
	dey								;2
	bpl		Ld015					;2/3
	sta		RESP0,x					;4
	dex								;2
	bpl		Ld008					;2/3
	sta		WSYNC					;3	 =	15
;---------------------------------------
	sta		HMOVE					;3
	jmp		Ldf9c					;3	 =	 6

LD024:
	   bit	  CXM1P					  ;3
	   bpl	  LD05C					  ;2
	   ldx	  $81					  ;3
	   cpx	  #$0A					  ;2
	   bcc	  LD05C					  ;2
	   beq	  LD03F					  ;2
	   lda	  $D1					  ;3
	   adc	  #$01					  ;2
	   lsr							  ;2
	   lsr							  ;2
	   lsr							  ;2
	   lsr							  ;2
	   tax							  ;2
	   lda	  #$08					  ;2
	   eor	  $DF,X					  ;4
	   sta	  $DF,X					  ;4
LD03F:
	   lda	  $8F					  ;3
	   bpl	  LD054					  ;2
	   and	  #$7F					  ;2
	   sta	  $8F					  ;3
	   lda	  $95					  ;3
	   and	  #$1F					  ;2
	   beq	  LD050					  ;2
	   jsr	  Ldce9					  ;6
LD050:
	   lda	  #$40					  ;2
	   sta	  $95					  ;3
LD054:
	   lda	  #$7F					  ;2
	   sta	  $D1					  ;3
	   lda	  #$04					  ;2
	   sta	  thief_shot			  ;3 4 points (Lost)
LD05C:
	   bit	  CXM1FB				  ;3
	   bpl	  LD0AA					  ;2
	   ldx	  $81					  ;3
	   cpx	  #$09					  ;2
	   beq	  LD0BC					  ;2
	   cpx	  #$06					  ;2
	   beq	  LD06E					  ;2
	   cpx	  #$08					  ;2
	   bne	  LD0AA					  ;2
LD06E:
	   lda	  $D1					  ;3
	   sbc	  $D4					  ;3
	   lsr							  ;2
	   lsr							  ;2
	   beq	  LD087					  ;2
	   tax							  ;2
	   ldy	  $CB					  ;3
	   cpy	  #$12					  ;2
	   bcc	  LD0A4					  ;2
	   cpy	  #$8D					  ;2
	   bcs	  LD0A4					  ;2
	   lda	  #$00					  ;2
	   sta	  $E5,X					  ;4
	   beq	  LD0A4					  ;2 aLways branch

LD087:
	   lda	  $CB					  ;3
	   cmp	  #$30					  ;2
	   bcs	  LD09E					  ;2
	   sbc	  #$10					  ;2
	   eor	  #$1F					  ;2
LD091:
	   lsr							  ;2
	   lsr							  ;2
	   tax							  ;2
	   lda	  Ldc5c,X				  ;4
	   and	  $E5					  ;3
	   sta	  $E5					  ;3
	   jmp	  LD0A4					  ;3

LD09E:
	   sbc	  #$71					  ;2
	   cmp	  #$20					  ;2
	   bcc	  LD091					  ;2
LD0A4:
	   ldy	  #$7F					  ;2
	   sty	  $8F					  ;3
	   sty	  $D1					  ;3
LD0AA:
	   bit	  CXM1FB				  ;3
	   bvc	  LD0BC					  ;2
	   bit	  $93					  ;3
	   bvc	  LD0BC					  ;2
	   lda	  #$5A					  ;2
	   sta	  $D2					  ;3
	   sta	  $DC					  ;3
	   sta	  $8F					  ;3
	   sta	  $D1					  ;3
LD0BC:
	   bit	  CXP1FB				  ;3
	   bvc	  LD0ED					  ;2
	   ldx	  $81					  ;3
	   cpx	  #$06					  ;2
	   beq	  LD0E2					  ;2
	   lda	  current_object		  ;3
	   cmp	  #$02					  ;2 is object the fLute?
	   beq	  LD0ED					  ;2  ...branch if so
	   bit	  $93					  ;3
	   bpl	  LD0DA					  ;2
	   lda	  $83					  ;3
	   and	  #$07					  ;2
	   ora	  #$80					  ;2
	   sta	  $A1					  ;3
	   bne	  LD0ED					  ;2 aLways branch

LD0DA:
	   bvc	  LD0ED					  ;2
	   lda	  #$80					  ;2
	   sta	  $9D					  ;3
	   bne	  LD0ED					  ;2 aLways branch

LD0E2:
	   lda	  $D6					  ;3
	   cmp	  #$BA					  ;2
	   bne	  LD0ED					  ;2
	   lda	  #$0F					  ;2
	   jsr	  Ldce9					  ;6
LD0ED:
	   ldx	  #$05					  ;2
	   cpx	  $81					  ;3
	   bne	  LD12D					  ;2
	   bit	  CXM0P					  ;3
	   bpl	  LD106					  ;2
	   stx	  $CF					  ;3
	   lda	  #$0C					  ;2
	   sta	  $81					  ;3
	   jsr	  Ld878					  ;6
	   lda	  #$4C					  ;2
	   sta	  $C9					  ;3
	   bne	  LD12B					  ;2 aLways branch

LD106:
	   ldx	  $CF					  ;3
	   cpx	  #$4F					  ;2
	   bcc	  LD12D					  ;2
	   lda	  #$0A					  ;2
	   sta	  $81					  ;3
	   jsr	  Ld878					  ;6
	   lda	  $EB					  ;3
	   sta	  $DF					  ;3
	   lda	  $EC					  ;3
	   sta	  $CF					  ;3
	   lda	  $ED					  ;3
	   sta	  $C9					  ;3
	   lda	  #$FD					  ;2
	   and	  $B4					  ;3
	   sta	  $B4					  ;3
	   bmi	  LD12B					  ;2
	   lda	  #$80					  ;2
	   sta	  $9D					  ;3
LD12B:
	   sta	  CXCLR					  ;3
LD12D:
	   bit	  CXPPMM				  ;3
	   bmi	  LD140					  ;2
	   ldx	  #$00					  ;2
	   stx	  $91					  ;3
	   dex							  ;2
	   stx	  $97					  ;3
	   roL	  $95					  ;5
	   clc							  ;2
	   ror	  $95					  ;5
LD13D:
	   jmp	  Ld2b4					  ;3

LD140:
	   lda	  $81					  ;3
	   bne	  LD157					  ;2
	   lda	  $AF					  ;3
	   and	  #$07					  ;2
	   tax							  ;2
	   lda	  Ldf78,X				  ;4
	   jsr	  Ldce9					  ;6
	   bcc	  LD13D					  ;2
	   lda	  #$01					  ;2
	   sta	  $DF					  ;3
	   bne	  LD13D					  ;2 aLways branch

LD157:
	   asl							  ;2
	   tax							  ;2
	   lda	  Ldc9b+1,X				  ;4
	   pha							  ;3
	   lda	  Ldc9b,X				  ;4
	   pha							  ;3
	   rts							  ;6

Ld162:
	   lda	  $CF					  ;3
	   cmp	  #$3F					  ;2
	   bcc	  LD18A					  ;2
	   lda	  $96					  ;3
	   cmp	  #$54					  ;2
	   bne	  LD1C1					  ;2
	   lda	  $8C					  ;3
	   cmp	  $8B					  ;3
	   bne	  LD187					  ;2
	   lda	  #$58					  ;2 LFA58 too?
	   sta	  $9C					  ;3
	   sta	  $9E					  ;3 game over...start with ped. height = #$88
	   jsr	  tally_score					  ;6 ...and taLLy the variabLes
	   lda	  #$0D					  ;2
	   sta	  $81					  ;3
	   jsr	  Ld878					  ;6
	   jmp	  Ld3d8					  ;3

LD187:
	   jmp	  Ld2da					  ;3

LD18A:
	   lda	  #$0B					  ;2
	   bne	  LD194					  ;2 aLways branch

Ld18e:
	   lda	  #$07					  ;2
	   bne	  LD194					  ;2 aLways branch

Ld192:
	   lda	  #$04					  ;2
LD194:
	   bit	  $95					  ;3
	   bmi	  LD1C1					  ;2
	   clc							  ;2
	   jsr	  lda10					  ;6
	   bcs	  LD1A4					  ;2
	   sec							  ;2
	   jsr	  lda10					  ;6
	   bcc	  LD1C1					  ;2
LD1A4:
	   cpy	  #$0B					  ;2
	   bne	  LD1AD					  ;2
	   ror	  $B2					  ;5
	   clc							  ;2
	   roL	  $B2					  ;5
LD1AD:
	   lda	  $95					  ;3
	   jsr	  Ldd59					 ;6
	   tya							  ;2
	   ora	  #$C0					  ;2
	   sta	  $95					  ;3
	   bne	  LD1C1					  ;2 aLways branch

Ld1b9:
	   ldx	  #$00					  ;2
	   stx	  $B6					  ;3
	   lda	  #$80					  ;2
	   sta	  $9D					  ;3
LD1C1:
	   jmp	  Ld2b4					  ;3

Ld1c4:
	   bit	  $B4					  ;3
	   bvs	  LD1E8					  ;2
	   bpl	  LD1E8					  ;2
	   lda	  $C9					  ;3
	   cmp	  #$2B					  ;2
	   bcc	  LD1E2					  ;2
	   ldx	  $CF					  ;3
	   cpx	  #$27					  ;2
	   bcc	  LD1E2					  ;2
	   cpx	  #$2B					  ;2
	   bcs	  LD1E2					  ;2
	   lda	  #$40					  ;2
	   ora	  $B4					  ;3
	   sta	  $B4					  ;3
	   bne	  LD1E8					  ;2
LD1E2:
	   lda	  #$03					  ;2
	   sec							  ;2
	   jsr	  lda10					  ;6
LD1E8:
	   jmp	  Ld2b4					  ;3

Ld1eb:
	   bit	  CXP1FB				  ;3
	   bpl	  LD21A					  ;2
	   ldy	  $CF					  ;3
	   cpy	  #$3A					  ;2
	   bcc	  LD200					  ;2
	   lda	  #$E0					  ;2
	   and	  $91					  ;3
	   ora	  #$43					  ;2
	   sta	  $91					  ;3
	   jmp	  Ld2b4					  ;3

LD200:
	   cpy	  #$20					  ;2
	   bcc	  LD20B					  ;2
LD204:
	   lda	  #$00					  ;2
	   sta	  $91					  ;3
	   jmp	  Ld2b4					  ;3

LD20B:
	   cpy	  #$09					  ;2
	   bcc	  LD204					  ;2
	   lda	  #$E0					  ;2
	   and	  $91					  ;3
	   ora	  #$42					  ;2
	   sta	  $91					  ;3
	   jmp	  Ld2b4					  ;3

LD21A:
	   lda	  $CF					  ;3
	   cmp	  #$3A					  ;2
	   bcc	  LD224					  ;2
	   ldx	  #$07					  ;2
	   bne	  LD230					  ;2 aLways branch

LD224:
	   lda	  $C9					  ;3
	   cmp	  #$4C					  ;2
	   bcs	  LD22E					  ;2
	   ldx	  #$05					  ;2
	   bne	  LD230					  ;2 aLways branch

LD22E:
	   ldx	  #$0D					  ;2
LD230:
	   lda	  #$40					  ;2
	   sta	  $93					  ;3
	   lda	  $83					  ;3
	   and	  #$1F					  ;2
	   cmp	  #$02					  ;2
	   bcs	  LD23E					  ;2
	   ldx	  #$0E					  ;2
LD23E:
	   jsr	  Ldd43					  ;6
	   bcs	  LD247					  ;2
	   txa							  ;2
	   jsr	  Ldce9					  ;6
LD247:
	   jmp	  Ld2b4					  ;3

Ld24a:
	   bit	  CXP1FB				  ;3
	   bmi	  LD26E					  ;2
	   lda	  $C9					  ;3
	   cmp	  #$50					  ;2
	   bcs	  LD262					  ;2
	   dec	  $C9					  ;5
	   roL	  $B2					  ;5
	   clc							  ;2
	   ror	  $B2					  ;5
LD25B:
	   lda	  #$00					  ;2
	   sta	  $91					  ;3
LD25F:
	   jmp	  Ld2b4					  ;3

LD262:
	   ldx	  #$06					  ;2
	   lda	  $83					  ;3
	   cmp	  #$40					  ;2
	   bcs	  LD23E					  ;2
	   ldx	  #$07					  ;2
	   bne	  LD23E					  ;2 aLways branch

LD26E:
	   ldy	  $CF					  ;3
	   cpy	  #$44					  ;2
	   bcc	  LD27E					  ;2
	   lda	  #$E0					  ;2
	   and	  $91					  ;3
	   ora	  #$0B					  ;2
LD27A:
	   sta	  $91					  ;3
	   bne	  LD25F					  ;2
LD27E:
	   cpy	  #$20					  ;2
	   bcs	  LD25B					  ;2
	   cpy	  #$0B					  ;2
	   bcc	  LD25B					  ;2
	   lda	  #$E0					  ;2
	   and	  $91					  ;3
	   ora	  #$41					  ;2
	   bne	  LD27A					  ;2 aLways branch

Ld28e:
	   inc	  $C9					  ;5
	   bne	  Ld2b4					  ;2 aLways branch

Ld292:
	   lda	  $CF					  ;3
	   cmp	  #$3F					  ;2
	   bcc	  LD2AA					  ;2
	   lda	  #$0A					  ;2
	   jsr	  Ldce9					  ;6
	   bcc	  Ld2b4					  ;2
	   ror	  $B1					  ;5
	   sec							  ;2
	   roL	  $B1					  ;5
	   lda	  #$42					  ;2
	   sta	  $DF					  ;3
	   bne	  Ld2b4					  ;2 aLways branch

LD2AA:
	   cmp	  #$16					  ;2
	   bcc	  LD2B2					  ;2
	   cmp	  #$1F					  ;2
	   bcc	  Ld2b4					  ;2
LD2B2:
	   dec	  $C9					  ;5
Ld2b4:
	   lda	  $81					  ;3
	   asl							  ;2
	   tax							  ;2
	   bit	  CXP1FB				  ;3
	   bpl	  LD2C5					  ;2
	   lda	  Ldcb5+1,X				  ;4
	   pha							  ;3
	   lda	  Ldcb5,X				  ;4
	   pha							  ;3
	   rts							  ;6

LD2C5:
	   lda	  Ldccf+1,X				  ;4
	   pha							  ;3
	   lda	  Ldccf,X				  ;4
	   pha							  ;3
	   rts							  ;6

Ld2ce
	lda		ram_DF					;3		   *
	sta		ram_EB					;3		   *
	lda		indy_y					;3		   *
	sta		ram_EC					;3		   *
	lda		indy_x					;3		   *
Ld2d8
	sta		ram_ED					;3		   *
Ld2da
	lda		#$05					;2		   *
	sta		room_num				  ;3		 *
	jsr		Ld878					;6		   *
	lda		#$05					;2		   *
	sta		indy_y					;3		   *
	lda		#$50					;2		   *
	sta		indy_x					;3		   *
	tsx								;2		   *
	cpx		#$fe					;2		   *
	bcs		Ld2ef					;2/3	   *
	rts								;6	 =	51 *

Ld2ef
	jmp		Ld374					;3	 =	 3 *



Ld2f2:
	   bit	  $B3					  ;3
	   bmi	  Ld2ef					  ;2
	   lda	  #$50					  ;2
	   sta	  $EB					  ;3
	   lda	  #$41					  ;2
	   sta	  $EC					  ;3
	   lda	  #$4C					  ;2
	   bne	  Ld2d8					  ;2 aLways branch

Ld302:
	   ldy	  $C9					  ;3
	   cpy	  #$2C					  ;2
	   bcc	  LD31A					  ;2
	   cpy	  #$6B					  ;2
	   bcs	  LD31C					  ;2
	   ldy	  $CF					  ;3
	   iny							  ;2
	   cpy	  #$1E					  ;2
	   bcc	  LD315					  ;2
	   dey							  ;2
	   dey							  ;2
LD315:
	   sty	  $CF					  ;3
	   jmp	  LD364					  ;3

LD31A:
	   iny							  ;2
	   iny							  ;2
LD31C:
	   dey							  ;2
	   sty	  $C9					  ;3
	   bne	  LD364					  ;2 aLways branch

Ld321:
	   lda	  #$02					  ;2
	   and	  $B1					  ;3
	   beq	  LD331					  ;2
	   lda	  $CF					  ;3
	   cmp	  #$12					  ;2
	   bcc	  LD331					  ;2
	   cmp	  #$24					  ;2
	   bcc	  Ld36a					  ;2
LD331:
	   dec	  $C9					  ;5
	   bne	  LD364					  ;2 aLways branch

Ld335:
	   ldx	  #$1A					  ;2
	   lda	  $C9					  ;3
	   cmp	  #$4C					  ;2
	   bcc	  LD33F					  ;2
	   ldx	  #$7D					  ;2
LD33F:
	   stx	  $C9					  ;3
	   ldx	  #$40					  ;2
	   stx	  $CF					  ;3
	   ldx	  #$FF					  ;2
	   stx	  $E5					  ;3
	   ldx	  #$01					  ;2
	   stx	  $E6					  ;3
	   stx	  $E7					  ;3
	   stx	  $E8					  ;3
	   stx	  $E9					  ;3
	   stx	  $EA					  ;3
	   bne	  LD364					  ;2 aLways branch

Ld357:
	   lda	  $92					  ;3
	   and	  #$0F					  ;2
	   tay							  ;2
	   lda	  Ldfd5,Y				  ;4
	   ldx	  #$01					  ;2
	   jsr	  move_enemy				  ;6
LD364:
	   lda	  #$05					  ;2
	   sta	  $A2					  ;3
	   bne	  Ld374					  ;2 aLways branch

Ld36a:
	   roL	  $8A					  ;5
	   sec							  ;2
	   bcs	  LD372					  ;2 aLways branch

Ld36f:
	   roL	  $8A					  ;5
	   clc							  ;2
LD372:
	   ror	  $8A					  ;5

Ld374
	bit		CXM0P|$30				;3		   *
	bpl		Ld396					;2/3	   *
	ldx		room_num				  ;3		 *
	cpx		#$07					;2		   *
	beq		Ld386					;2/3	   *
	bcc		Ld396					;2/3	   *
	lda		#$80					;2		   *
	sta		ram_9D					;3		   *
	bne		Ld390					;2/3 =	21 *
Ld386
	roL		ram_8A					;5		   *
	sec								;2		   *
	ror		ram_8A					;5		   *
	roL		ram_B6					;5		   *
	sec								;2		   *
	ror		ram_B6					;5	 =	24 *
Ld390
	lda		#$7f					;2		   *
	sta		ram_8E					;3		   *
	sta		ram_D0					;3	 =	 8 *
Ld396
	bit		ram_9A					;3		   *
	bpl		Ld3d8					;2/3	   *
	bvs		Ld3a8					;2/3	   *
	lda		time_of_day					 ;3			*
	cmp		ram_9B					;3		   *
	bne		Ld3d8					;2/3	   *
	lda		#$a0					;2		   *
	sta		ram_D1					;3		   *
	sta		ram_9D					;3	 =	23 *
Ld3a8
	lsr		ram_9A					;5		   *
	bcc		Ld3d4					;2/3	   *
	lda		#$02					;2		   *
	sta		grenade_used				  ;3		 *
	ora		ram_B1					;3		   *
	sta		ram_B1					;3		   *
	ldx		#$02					;2		   *
	cpx		room_num				  ;3		 *
	bne		Ld3bd					;2/3	   *
	jsr		Ld878					;6	 =	31 *
Ld3bd
	lda		ram_B5					;3		   *
	and		#$0f					;2		   *
	beq		Ld3d4					;2/3	   *
	lda		ram_B5					;3		   *
	and		#$f0					;2		   *
	ora		#$01					;2		   *
	sta		ram_B5					;3		   *
	ldx		#$02					;2		   *
	cpx		room_num				  ;3		 *
	bne		Ld3d4					;2/3	   *
	jsr		Ld878					;6	 =	30 *
Ld3d4
	sec								;2		   *
	jsr		lda10					;6	 =	 8 *
Ld3d8
	lda		INTIM					;4
	bne		Ld3d8					;2/3 =	 6
Ld3dd
	lda		#$02					;2
	sta		WSYNC					;3	 =	 5
;---------------------------------------
	sta		VSYNC					;3
	lda		#$50					;2
	cmp		ram_D1					;3
	bcs		Ld3eb					;2/3
	sta		ram_CB					;3	 =	13 *
Ld3eb
	inc		frame_counter			;Up the frame counter by 1
	lda		#$3f					;
	and		frame_counter			;Every 63 frames (?)
	bne		Ld3fb					;
	inc		time_of_day				;Increse the time of day
	lda		ram_A1					;3
	bpl		Ld3fb					;2/3
	dec		ram_A1					;5	 =	27 *
Ld3fb
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	bit		ram_9C					;3
	bpl		frame_start					  ;2/3
	ror		SWCHB					;6		   *
	bcs		frame_start					  ;2/3		 *
	jmp		game_start					 ;3	  =	 16 *

frame_start
	sta		WSYNC					;Wait for first Sync
;---------------------------------------
	lda		#$00					;Load A for VSYNC pause
	ldx		#$2c					;Load Timer for
	sta		WSYNC					;3	 =	 7
;---------------------------------------
	sta		VSYNC					;3
	stx		TIM64T					;4
	ldx		ram_9D					;3
	inx								;2
	bne		Ld42a					;2/3
	stx		ram_9D					;3		   *
	jsr		tally_score				; Set score to minimum
	lda		#$0d					; Set Ark title screen 
	sta		room_num				; to the current room
	jsr		Ld878					;6	 =	34 *
Ld427
	jmp		Ld80d					;3	 =	 3

Ld42a
	lda		room_num				; Get teh room number
	cmp		#$0d					; are we in the ark room? 
	bne		Ld482					;2/3
	lda		#$9c					;2
	sta		ram_A3					;3
	ldy		yar_found				; Check if yar was found
	beq		Ld44a					; If not hold for button(?)
	bit		ram_9C					;3		   *
	bmi		Ld44a					;2/3	   *
	ldx		#>dev_name_1_gfx		; get programmer 1 initials...
	stx		inv_slot_hi				; put in slot 1
	stx		inv_slot2_hi			
	lda		#<dev_name_1_gfx		
	sta		inv_slot_lo				
	lda		#<dev_name_2_gfx		; get programmer 2 initials...
	sta		inv_slot2_lo			; put in slot 2
Ld44a
	ldy		indy_y					;3
	cpy		#$7c					;2
	bcs		Ld465					;2/3
	cpy		score				   ;3
	bcc		Ld45b					;2/3
	bit		INPT5|$30				;3		   *
	bmi		Ld427					;2/3	   *
	jmp		game_start					 ;3	  =	 20 *

Ld45b
	lda		frame_counter				   ;3
	ror								;2
	bcc		Ld427					;2/3
	iny								;2
	sty		indy_y					;3
	bne		Ld427					;2/3 =	14
Ld465
	bit		ram_9C					;3		   *
	bmi		Ld46d					;2/3	   *
	lda		#$0e					;2		   *
	sta		ram_A2					;3	 =	10 *
Ld46d
	lda		#$80					;2		   *
	sta		ram_9C					;3		   *
	bit		INPT5|$30				;3		   *
	bmi		Ld427					;2/3	   *
	lda		frame_counter				   ;3		  *
	and		#$0f					;2		   *
	bne		Ld47d					;2/3	   *
	lda		#$05					;2	 =	19 *
Ld47d
	sta		ram_8C					;3		   *
	jmp		reset_vars					 ;3	  =	  6 *

Ld482
	bit		ram_93					;3		   *
	bvs		Ld489					;2/3 =	 5 *
Ld486
	jmp		Ld51c					;3	 =	 3 *

Ld489
	lda		frame_counter				   ;3		  *
	and		#$03					;2		   *
	bne		Ld501					;2/3!	   *
	ldx		snake_y					 ;3			*
	cpx		#$60					;2		   *
	bcc		Ld4a5					;2/3	   *
	bit		ram_9D					;3		   *
	bmi		Ld486					;2/3	   *
	ldx		#$00					;2		   *
	lda		indy_x					;3		   *
	cmp		#$20					;2		   *
	bcs		Ld4a3					;2/3	   *
	lda		#$20					;2	 =	30 *
Ld4a3
	sta		ram_CC					;3	 =	 3 *
Ld4a5
	inx								;2		   *
	stx		snake_y					 ;3			*
	txa								;2		   *
	sec								;2		   *
	sbc		#$07					;2		   *
	bpl		Ld4b0					;2/3	   *
	lda		#$00					;2	 =	15 *
Ld4b0
	sta		ram_D2					;3		   *
	and		#$f8					;2		   *
	cmp		ram_D5					;3		   *
	beq		Ld501					;2/3!	   *
	sta		ram_D5					;3		   *
	lda		ram_D4					;3		   *
	and		#$03					;2		   *
	tax								;2		   *
	lda		ram_D4					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	tay								;2		   *
	lda		Ldbff,x					;4		   *
	clc								;2		   *
	adc		Ldbff,y					;4		   *
	clc								;2		   *
	adc		ram_CC					;3		   *
	ldx		#$00					;2		   *
	cmp		#$87					;2		   *
	bcs		Ld4e2					;2/3	   *
	cmp		#$18					;2		   *
	bcc		Ld4de					;2/3	   *
	sbc		indy_x					;3		   *
	sbc		#$03					;2		   *
	bpl		Ld4e2					;2/3 =	61 *
Ld4de
	inx								;2		   *
	inx								;2		   *
	eor		#$ff					;2	 =	 6 *
Ld4e2
	cmp		#$09					;2		   *
	bcc		Ld4e7					;2/3	   *
	inx								;2	 =	 6 *
Ld4e7
	txa								;2		   *
	asl								;2		   *
	asl								;2		   *
	sta		ram_84					;3		   *
	lda		ram_D4					;3		   *
	and		#$03					;2		   *
	tax								;2		   *
	lda		Ldbff,x					;4		   *
	clc								;2		   *
	adc		ram_CC					;3		   *
	sta		ram_CC					;3		   *
	lda		ram_D4					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	ora		ram_84					;3		   *
	sta		ram_D4					;3	 =	41 *
Ld501
	lda		ram_D4					;3		   *
	and		#$03					;2		   *
	tax								;2		   *
	lda		Ldbfb,x					;4		   *
	sta		ram_D6					;3		   *
	lda		#$fa					;2		   *
	sta		ram_D7					;3		   *
	lda		ram_D4					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	tax								;2		   *
	lda		Ldbfb,x					;4		   *
	sec								;2		   *
	sbc		#$08					;2		   *
	sta		ram_D8					;3	 =	39 *
Ld51c
	bit		ram_9D					;3		   *
	bpl		Ld523					;2/3	   *
	jmp		Ld802					;3	 =	 8 *

Ld523
	bit		ram_A1					;3		   *
	bpl		Ld52a					;2/3	   *
	jmp		Ld78c					;3	 =	 8 *

Ld52a
	lda		frame_counter				   ;3		  *
	ror								;2		   *
	bcc		Ld532					;2/3	   *
	jmp		Ld627					;3	 =	10 *

Ld532
	ldx		room_num				  ;3		 *
	cpx		#$05					;2		   *
	beq		Ld579					;2/3	   *
	bit		ram_8D					;3		   *
	bvc		Ld56e					;2/3	   *
	ldx		ram_CB					;3		   *
	txa								;2		   *
	sec								;2		   *
	sbc		indy_x					;3		   *
	tay								;2		   *
	lda		SWCHA					;4		   *
	ror								;2		   *
	bcc		Ld55b					;2/3	   *
	ror								;2		   *
	bcs		Ld579					;2/3	   *
	cpy		#$09					;2		   *
	bcc		Ld579					;2/3	   *
	tya								;2		   *
	bpl		Ld556					;2/3 =	44 *
Ld553
	inx								;2		   *
	bne		Ld557					;2/3 =	 4 *
Ld556
	dex								;2	 =	 2 *
Ld557
	stx		ram_CB					;3		   *
	bne		Ld579					;2/3 =	 5 *
Ld55b
	cpx		#$75					;2		   *
	bcs		Ld579					;2/3	   *
	cpx		#$1a					;2		   *
	bcc		Ld579					;2/3	   *
	dey								;2		   *
	dey								;2		   *
	cpy		#$07					;2		   *
	bcc		Ld579					;2/3	   *
	tya								;2		   *
	bpl		Ld553					;2/3	   *
	bmi		Ld556					;2/3 =	22 *
Ld56e
	bit		ram_B4					;3		   *
	bmi		Ld579					;2/3	   *
	bit		ram_8A					;3		   *
	bpl		Ld57c					;2/3	   *
	ror								;2		   *
	bcc		Ld57c					;2/3 =	14 *
Ld579
	jmp		Ld5e0					;3	 =	 3 *

Ld57c
	ldx		#$01					;2		   *
	lda		SWCHA					;4		   *
	sta		ram_85					;3		   *
	and		#$0f					;2		   *
	cmp		#$0f					;2		   *
	beq		Ld579					;2/3	   *
	sta		indy_dir				  ;3		 *
	jsr		move_enemy					 ;6			*
	ldx		room_num				  ;3		 *
	ldy		#$00					;2		   *
	sty		ram_84					;3		   *
	beq		Ld599					;2/3 =	34 *
Ld596
	tax								;2		   *
	inc		ram_84					;5	 =	 7 *
Ld599
	lda		indy_x					;3		   *
	pha								;3		   *
	lda		indy_y					;3		   *
	ldy		ram_84					;3		   *
	cpy		#$02					;2		   *
	bcs		Ld5ac					;2/3	   *
	sta		ram_86					;3		   *
	pLa								;4		   *
	sta		ram_87					;3		   *
	jmp		Ld5b1					;3	 =	29 *

Ld5ac
	sta		ram_87					;3		   *
	pLa								;4		   *
	sta		ram_86					;3	 =	10 *
Ld5b1
	ror		ram_85					;5		   *
	bcs		Ld5d1					;2/3	   *
	jsr		Ld97c					;6		   *
	bcs		Ld5db					;2/3	   *
	bvc		Ld5d1					;2/3	   *
	ldy		ram_84					;3		   *
	lda		Ldf6c,y					;4		   *
	cpy		#$02					;2		   *
	bcs		Ld5cc					;2/3	   *
	adc		indy_y					;3		   *
	sta		indy_y					;3		   *
	jmp		Ld5d1					;3	 =	37 *

Ld5cc
	clc								;2		   *
	adc		indy_x					;3		   *
	sta		indy_x					;3	 =	 8 *
Ld5d1
	txa								;2		   *
	clc								;2		   *
	adc		#$0d					;2		   *
	cmp		#$34					;2		   *
	bcc		Ld596					;2/3	   *
	bcs		Ld5e0					;2/3 =	12 *
Ld5db
	sty		room_num				  ;3		 *
	jsr		Ld878					;6	 =	 9 *
Ld5e0
	bit		INPT4|$30				;3		   *
	bmi		Ld5f5					;2/3	   *
	bit		ram_9A					;3		   *
	bmi		Ld624					;2/3!	   *
	lda		ram_8A					;3		   *
	ror								;2		   *
	bcs		Ld5fa					;2/3	   *
	sec								;2		   *
	jsr		lda10					;6		   *
	inc		ram_8A					;5		   *
	bne		Ld5fa					;2/3 =	32 *
Ld5f5
	ror		ram_8A					;5		   *
	clc								;2		   *
	roL		ram_8A					;5	 =	12 *
Ld5fa
	lda		ram_91					;3		   *
	bpl		Ld624					;2/3!	   *
	and		#$1f					;2		   *
	cmp		#$01					;2		   *
	bne		Ld60c					;2/3	   *
	inc		num_buLLets					 ;5			*
	inc		num_buLLets					 ;5			*
	inc		num_buLLets					 ;5			*
	bne		Ld620					;2/3 =	28 *
Ld60c
	cmp		#$0b					;2		   *
	bne		Ld61d					;2/3	   *
	ror		ram_B2					;5		   *
	sec								;2		   *
	roL		ram_B2					;5		   *
	ldx		#$45					;2		   *
	stx		ram_DF					;3		   *
	ldx		#$7f					;2		   *
	stx		ram_D0					;3	 =	26 *
Ld61d
	jsr		Ldce9					;6	 =	 6 *
Ld620
	lda		#$00					;2		   *
	sta		ram_91					;3	 =	 5 *
Ld624
	jmp		Ld777					;3	 =	 3 *

Ld627
	bit		ram_9A					;3		   *
	bmi		Ld624					;2/3	   *
	bit		INPT5|$30				;3		   *
	bpl		Ld638					;2/3	   *
	lda		#$fd					;2		   *
	and		ram_8A					;3		   *
	sta		ram_8A					;3		   *
	jmp		Ld777					;3	 =	21 *

Ld638
	lda		#$02					;2		   *
	bit		ram_8A					;3		   *
	bne		Ld696					;2/3	   *
	ora		ram_8A					;3		   *
	sta		ram_8A					;3		   *
	ldx		current_object					;3		   *
	cpx		#$05					;2		   *
	beq		Ld64c					;2/3	   *
	cpx		#$06					;2		   *
	bne		Ld671					;2/3 =	24 *
Ld64c
	ldx		indy_y					;3		   *
	stx		ram_D1					;3		   *
	ldy		indy_x					;3		   *
	sty		ram_CB					;3		   *
	lda		time_of_day					 ;3			*
	adc		#$04					;2		   *
	sta		ram_9B					;3		   *
	lda		#$80					;2		   *
	cpx		#$35					;2		   *
	bcs		Ld66c					;2/3	   *
	cpy		#$64					;2		   *
	bcc		Ld66c					;2/3	   *
	ldx		room_num				  ;3		 *
	cpx		#$02					;2		   *
	bne		Ld66c					;2/3	   *
	ora		#$01					;2	 =	39 *
Ld66c
	sta		ram_9A					;3		   *
	jmp		Ld777					;3	 =	 6 *

Ld671
	cpx		#$03					;2		   *
	bne		Ld68b					;2/3	   *
	stx		parachute_used					;3		   *
	lda		ram_B4					;3		   *
	bmi		Ld696					;2/3	   *
	ora		#$80					;2		   *
	sta		ram_B4					;3		   *
	lda		indy_y					;3		   *
	sbc		#$06					;2		   *
	bpl		Ld687					;2/3	   *
	lda		#$01					;2	 =	26 *
Ld687
	sta		indy_y					;3		   *
	bpl		Ld6d2					;2/3 =	 5 *
Ld68b
	bit		ram_8D					;3		   *
	bvc		Ld6d5					;2/3	   *
	bit		CXM1FB|$30				;3		   *
	bmi		Ld699					;2/3	   *
	jsr		Ld2ce					;6	 =	16 *
Ld696
	jmp		Ld777					;3	 =	 3 *

Ld699
	lda		ram_D1					;3		   *
	lsr								;2		   *
	sec								;2		   *
	sbc		#$06					;2		   *
	clc								;2		   *
	adc		ram_DF					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	cmp		#$08					;2		   *
	bcc		Ld6ac					;2/3	   *
	lda		#$07					;2	 =	28 *
Ld6ac
	sta		ram_84					;3		   *
	lda		ram_CB					;3		   *
	sec								;2		   *
	sbc		#$10					;2		   *
	and		#$60					;2		   *
	lsr								;2		   *
	lsr								;2		   *
	adc		ram_84					;3		   *
	tay								;2		   *
	lda		Ldf7c,y					;4		   *
	sta		ram_8B					;3		   *
	ldx		ram_D1					;3		   *
	dex								;2		   *
	stx		ram_D1					;3		   *
	stx		indy_y					;3		   *
	ldx		ram_CB					;3		   *
	dex								;2		   *
	dex								;2		   *
	stx		ram_CB					;3		   *
	stx		indy_x					;3		   *
	lda		#$46					;2		   *
	sta		ram_8D					;3	 =	57 *
Ld6d2
	jmp		Ld773					;3	 =	 3 *

Ld6d5
	cpx		#$0b					;2		   *
	bne		Ld6f7					;2/3	   *
	lda		indy_y					;3		   *
	cmp		#$41					;2		   *
	bcc		Ld696					;2/3	   *
	bit		CXPPMM|$30				;3		   *
	bpl		Ld696					;2/3	   *
	inc		ram_97					;5		   *
	bne		Ld696					;2/3	   *
	ldy		ram_96					;3		   *
	dey								;2		   *
	cpy		#$54					;2		   *
	bcs		Ld6ef					;2/3	   *
	iny								;2	 =	34 *
Ld6ef
	sty		ram_96					;3		   *
	lda		#$0a					;2		   *
	sta		shovel_used					 ;3			*
	bne		Ld696					;2/3 =	10 *
Ld6f7
	cpx		#$10					;2		   *
	bne		Ld71e					;2/3!	   *
	ldx		room_num				  ;3		 *
	cpx		#$00					;2		   *
	beq		Ld696					;2/3!	   *
	lda		#$09					;2		   *
	sta		ankh_used				   ;3		  *
	sta		room_num				  ;3		 *
	jsr		Ld878					;6		   *
	lda		#$4c					;2		   *
	sta		indy_x					;3		   *
	sta		ram_CB					;3		   *
	lda		#$46					;2		   *
	sta		indy_y					;3		   *
	sta		ram_D1					;3		   *
	sta		ram_8D					;3		   *
	lda		#$1d					;2		   *
	sta		ram_DF					;3		   *
	bne		Ld777					;2/3 =	51 *
Ld71e
	lda		SWCHA					;4		   *
	and		#$0f					;2		   *
	cmp		#$0f					;2		   *
	beq		Ld777					;2/3	   *
	cpx		#$0d					;2		   *
	bne		Ld747					;2/3	   *
	bit		ram_8F					;3		   *
	bmi		Ld777					;2/3	   *
	ldy		num_buLLets					 ;3			*
	bmi		Ld777					;2/3	   *
	dec		num_buLLets					 ;5			*
	ora		#$80					;2		   *
	sta		ram_8F					;3		   *
	lda		indy_y					;3		   *
	adc		#$04					;2		   *
	sta		ram_D1					;3		   *
	lda		indy_x					;3		   *
	adc		#$04					;2		   *
	sta		ram_CB					;3		   *
	bne		Ld773					;2/3 =	52 *
Ld747
	cpx		#$0a					;2		   *
	bne		Ld777					;2/3	   *
	ora		#$80					;2		   *
	sta		ram_8D					;3		   *
	ldy		#$04					;2		   *
	ldx		#$05					;2		   *
	ror								;2		   *
	bcs		Ld758					;2/3	   *
	ldx		#$fa					;2	 =	19 *
Ld758
	ror								;2		   *
	bcs		Ld75d					;2/3	   *
	ldx		#$0f					;2	 =	 6 *
Ld75d
	ror								;2		   *
	bcs		Ld762					;2/3	   *
	ldy		#$f7					;2	 =	 6 *
Ld762
	ror								;2		   *
	bcs		Ld767					;2/3	   *
	ldy		#$10					;2	 =	 6 *
Ld767
	tya								;2		   *
	clc								;2		   *
	adc		indy_x					;3		   *
	sta		ram_CB					;3		   *
	txa								;2		   *
	clc								;2		   *
	adc		indy_y					;3		   *
	sta		ram_D1					;3	 =	20 *
Ld773
	lda		#$0f					;2		   *
	sta		ram_A3					;3	 =	 5 *
Ld777
	bit		ram_B4					;3		   *
	bpl		Ld783					;2/3	   *
	lda		#$63					;2		   *
	sta		indy_anim				   ;3		  *
	lda		#$0f					;2		   *
	bne		Ld792					;2/3 =	14 *
Ld783
	lda		SWCHA					;4		   *
	and		#$0f					;2		   *
	cmp		#$0f					;2		   *
	bne		Ld796					;2/3 =	10 *
Ld78c
	lda		#$58					;2	 =	 2 *
Ld78e
	sta		indy_anim				   ;3		  *
	lda		#$0b					;2	 =	 5 *
Ld792
	sta		indy_h					;3		   *
	bne		Ld7b2					;2/3 =	 5 *
Ld796
	lda		#$03					;2		   *
	bit		ram_8A					;3		   *
	bmi		Ld79d					;2/3	   *
	lsr								;2	 =	 9 *
Ld79d
	and		frame_counter				   ;3		  *
	bne		Ld7b2					;2/3	   *
	lda		#$0b					;2		   *
	clc								;2		   *
	adc		indy_anim				   ;3		  *
	cmp		#$58					;2		   *
	bcc		Ld78e					;2/3	   *
	lda		#$02					;2		   *
	sta		ram_A3					;3		   *
	lda		#$00					;2		   *
	bcs		Ld78e					;2/3 =	25 *
Ld7b2
	ldx		room_num				  ;3		 *
	cpx		#$09					;2		   *
	beq		Ld7bc					;2/3	   *
	cpx		#$0a					;2		   *
	bne		Ld802					;2/3!=	11 *
Ld7bc
	lda		frame_counter				   ;3		  *
	bit		ram_8A					;3		   *
	bpl		Ld7c3					;2/3	   *
	lsr								;2	 =	10 *
Ld7c3
	ldy		indy_y					;3		   *
	cpy		#$27					;2		   *
	beq		Ld802					;2/3!	   *
	ldx		ram_DF					;3		   *
	bcs		Ld7e8					;2/3	   *
	beq		Ld802					;2/3!	   *
	inc		indy_y					;5		   *
	inc		ram_D1					;5		   *
	and		#$02					;2		   *
	bne		Ld802					;2/3!	   *
	dec		ram_DF					;5		   *
	inc		enemy_y					 ;5			*
	inc		ram_D0					;5		   *
	inc		ram_D2					;5		   *
	inc		enemy_y					 ;5			*
	inc		ram_D0					;5		   *
	inc		ram_D2					;5		   *
	jmp		Ld802					;3	 =	66 *

Ld7e8
	cpx		#$50					;2		   *
	bcs		Ld802					;2/3!	   *
	dec		indy_y					;5		   *
	dec		ram_D1					;5		   *
	and		#$02					;2		   *
	bne		Ld802					;2/3!	   *
	inc		ram_DF					;5		   *
	dec		enemy_y					 ;5			*
	dec		ram_D0					;5		   *
	dec		ram_D2					;5		   *
	dec		enemy_y					 ;5			*
	dec		ram_D0					;5		   *
	dec		ram_D2					;5	 =	53 *
Ld802
	lda		#$28					;2		   *
	sta		ram_88					;3		   *
	lda		#$f5					;2		   *
	sta		ram_89					;3		   *
	jmp		Ldfad					;3	 =	13 *

Ld80d
	lda		ram_99					;3
	beq		set_room_attr					;2/3
	jsr		Ldd59				   ;6		  *
	lda		#$00					;2	 =	13 *
set_room_attr
	sta		ram_99					;3
	ldx		room_num				  ;3
	lda		room_miss0_size_tabl,x					;4
	sta		NUSIZ0					;3
	lda		room_pf_cfg					;3
	sta		CTRLPF					;3
	lda		room_bg_color_tbl,x					;4
	sta		COLUBK					;3
	lda		room_pf_color_tbl,x					;4
	sta		COLUPF					;3
	lda		room_p0_color_tbl,x					;4
	sta		COLUP0					;3
	lda		room_p1_color_tbl,x					;4
	sta		COLUP1					;3
	cpx		#$0b					;2
	bcc		Ld84b					;2/3
	lda		#$20					;2
	sta		ram_D4					;3
	ldx		#$04					;2	 =	58
Ld841
	ldy		ram_E5,x				;4
	lda		room_miss0_size_tabl,y					;4
	sta		ram_EE,x				;4
	dex								;2
	bpl		Ld841					;2/3 =	16
Ld84b
	jmp		Ld006					;3	 =	 3

Ld84e
	lda		#$4d					;2
	sta		indy_x					;3
	lda		#$48					;2
	sta		enemy_x					 ;3
	lda		#$1f					;2
	sta		indy_y					;3
	rts								;6	 =	21

Ld85b
	ldx		#$00					;2		   *
	txa								;2	 =	 4 *
Ld85e
	sta		ram_DF,x				;4		   *
	sta		ram_E0,x				;4		   *
	sta		PF1_data,x				  ;4		 *
	sta		ram_E2,x				;4		   *
	sta		PF2_data,x				  ;4		 *
	sta		ram_E4,x				;4		   *
	txa								;2		   *
	bne		Ld873					;2/3	   *
	ldx		#$06					;2		   *
	lda		#$14					;2		   *
	bne		Ld85e					;2/3 =	34 *
Ld873
	lda		#$fc					;2		   *
	sta		ram_D7					;3		   *
	rts								;6	 =	11 *

Ld878
	lda		ram_9A					;3
	bpl		Ld880					;2/3
	ora		#$40					;2		   *
	sta		ram_9A					;3	 =	10 *
Ld880
	lda		#$5c					;2
	sta		ram_96					;3
	ldx		#$00					;2
	stx		ram_93					;3
	stx		ram_B6					;3
	stx		ram_8E					;3
	stx		ram_90					;3
	lda		ram_95					;3
	stx		ram_95					;3
	jsr		Ldd59				   ;6
	roL		ram_8A					;5
	clc								;2
	ror		ram_8A					;5
	ldx		room_num				  ;3
	lda		Ldb92,x					;4
	sta		room_pf_cfg					;3
	cpx		#$0d					;2
	beq		Ld84e					;2/3
	cpx		#$05					;2		   *
	beq		Ld8b1					;2/3	   *
	cpx		#$0c					;2		   *
	beq		Ld8b1					;2/3	   *
	lda		#$00					;2		   *
	sta		ram_8B					;3	 =	70 *
Ld8b1
	lda		Ldbee,x					;4		   *
	sta		emy_anim				  ;3		 *
	lda		Ldbe1,x					;4		   *
	sta		ram_DE					;3		   *
	lda		Ldbc9,x					;4		   *
	sta		snake_y					 ;3			*
	lda		Ldbd4,x					;4		   *
	sta		enemy_x					 ;3			*
	lda		Ldc0e,x					;4		   *
	sta		ram_CA					;3		   *
	lda		Ldc1b,x					;4		   *
	sta		ram_D0					;3		   *
	cpx		#$0b					;2		   *
	bcs		Ld85b					;2/3	   *
	adc		Ldc03,x					;4		   *
	sta		ram_E0					;3		   *
	lda		Ldc28,x					;4		   *
	sta		PF1_data				  ;3		 *
	lda		Ldc33,x					;4		   *
	sta		ram_E2					;3		   *
	lda		Ldc3e,x					;4		   *
	sta		PF2_data				  ;3		 *
	lda		Ldc49,x					;4		   *
	sta		ram_E4					;3		   *
	lda		#$55					;2		   *
	sta		ram_D2					;3		   *
	sta		ram_D1					;3		   *
	cpx		#$06					;2		   *
	bcs		Ld93e					;2/3!	   *
	lda		#$00					;2		   *
	cpx		#$00					;2		   *
	beq		Ld91b					;2/3!	   *
	cpx		#$02					;2		   *
	beq		Ld92a					;2/3	   *
	sta		enemy_y					 ;3	  = 106 *
Ld902
	ldy		#$4f					;2		   *
	cpx		#$02					;2		   *
	bcc		Ld918					;2/3	   *
	lda		ram_AF,x				;4		   *
	ror								;2		   *
	bcc		Ld918					;2/3	   *
	ldy		Ldf72,x					;4		   *
	cpx		#$03					;2		   *
	bne		Ld918					;2/3	   *
	lda		#$ff					;2		   *
	sta		ram_D0					;3	 =	27 *
Ld918
	sty		ram_DF					;3		   *
	rts								;6	 =	 9 *

Ld91b
	lda		ram_AF					;3		   *
	and		#$78					;2		   *
	sta		ram_AF					;3		   *
	lda		#$1a					;2		   *
	sta		enemy_y					 ;3			*
	lda		#$26					;2		   *
	sta		ram_DF					;3		   *
	rts								;6	 =	24 *

Ld92a
	lda		ram_B1					;3		   *
	and		#$07					;2		   *
	lsr								;2		   *
	bne		Ld935					;2/3	   *
	ldy		#$ff					;2		   *
	sty		ram_D0					;3	 =	14 *
Ld935
	tay								;2		   *
	lda		Ldf70,y					;4		   *
	sta		enemy_y					 ;3			*
	jmp		Ld902					;3	 =	12 *

Ld93e
	cpx		#$08					;2		   *
	beq		Ld950					;2/3	   *
	cpx		#$06					;2		   *
	bne		Ld968					;2/3	   *
	ldy		#$00					;2		   *
	sty		ram_D8					;3		   *
	ldy		#$40					;2		   *
	sty		ram_E5					;3		   *
	bne		Ld958					;2/3 =	20 *
Ld950
	ldy		#$ff					;2		   *
	sty		ram_E5					;3		   *
	iny								;2		   *
	sty		ram_D8					;3		   *
	iny								;2	 =	12 *
Ld958
	sty		ram_E6					;3		   *
	sty		ram_E7					;3		   *
	sty		ram_E8					;3		   *
	sty		ram_E9					;3		   *
	sty		ram_EA					;3		   *
	ldy		#$39					;2		   *
	sty		ram_D4					;3		   *
	sty		ram_D5					;3	 =	23 *
Ld968
	cpx		#$09					;2		   *
	bne		Ld977					;2/3	   *
	ldy		indy_y					;3		   *
	cpy		#$49					;2		   *
	bcc		Ld977					;2/3	   *
	lda		#$50					;2		   *
	sta		ram_DF					;3		   *
	rts								;6	 =	22 *

Ld977
	lda		#$00					;2		   *
	sta		ram_DF					;3		   *
	rts								;6	 =	11 *

Ld97c
	ldy		Lde00,x					;4		   *
	cpy		ram_86					;3		   *
	beq		Ld986					;2/3	   *
	clc								;2		   *
	cLv								;2		   *
	rts								;6	 =	19 *

Ld986
	ldy		Lde34,x					;4		   *
	bmi		Ld99b					;2/3 =	 6 *
Ld98b
	lda		Ldf04,x					;4		   *
	beq		Ld992					;2/3 =	 6 *
Ld990
	sta		indy_y					;3	 =	 3 *
Ld992
	lda		Ldf38,x					;4		   *
	beq		Ld999					;2/3	   *
	sta		indy_x					;3	 =	 9 *
Ld999
	sec								;2		   *
	rts								;6	 =	 8 *

Ld99b
	iny								;2		   *
	beq		Ld9f9					;2/3	   *
	iny								;2		   *
	bne		Ld9b6					;2/3	   *
	ldy		Lde68,x					;4		   *
	cpy		ram_87					;3		   *
	bcc		Ld9af					;2/3	   *
	ldy		Lde9c,x					;4		   *
	bmi		Ld9c7					;2/3	   *
	bpl		Ld98b					;2/3 =	25 *
Ld9af
	ldy		Lded0,x					;4		   *
	bmi		Ld9c7					;2/3	   *
	bpl		Ld98b					;2/3 =	 8 *
Ld9b6
	lda		ram_87					;3		   *
	cmp		Lde68,x					;4		   *
	bcc		Ld9f9					;2/3	   *
	cmp		Lde9c,x					;4		   *
	bcs		Ld9f9					;2/3	   *
	ldy		Lded0,x					;4		   *
	bpl		Ld98b					;2/3 =	21 *
Ld9c7
	iny								;2		   *
	bmi		Ld9d4					;2/3	   *
	ldy		#$08					;2		   *
	bit		ram_AF					;3		   *
	bpl		Ld98b					;2/3	   *
	lda		#$41					;2		   *
	bne		Ld990					;2/3 =	15 *
Ld9d4
	iny								;2		   *
	bne		Ld9e1					;2/3	   *
	lda		ram_B5					;3		   *
	and		#$0f					;2		   *
	bne		Ld9f9					;2/3	   *
	ldy		#$06					;2		   *
	bne		Ld98b					;2/3 =	15 *
Ld9e1
	iny								;2		   *
	bne		Ld9f0					;2/3	   *
	lda		ram_B5					;3		   *
	and		#$0f					;2		   *
	cmp		#$0a					;2		   *
	bcs		Ld9f9					;2/3	   *
	ldy		#$06					;2		   *
	bne		Ld98b					;2/3 =	17 *
Ld9f0
	iny								;2		   *
	bne		Ld9fe					;2/3	   *
	ldy		#$01					;2		   *
	bit		ram_8A					;3		   *
	bmi		Ld98b					;2/3 =	11 *
Ld9f9
	clc								;2		   *
	bit		Ld9fd					;4	 =	 6 *

Ld9fd
	.byte	$60								; $d9fd (D)

Ld9fe
	iny								;2		   *
	bne		Ld9f9					;2/3!	   *
	ldy		#$06					;2		   *
	lda		#$0e					;2		   *
	cmp		current_object					;3		   *
	bne		Ld9f9					;2/3!	   *
	bit		INPT5|$30				;3		   *
	bmi		Ld9f9					;2/3!	   *
	jmp		Ld98b					;3	 =	21 *

lda10
	ldy		ram_C4					;3		   *
	bne		lda16					;2/3	   *
	clc								;2		   *
	rts								;6	 =	13 *

lda16
	bcs		check_key					;2/3	   *
	tay								;2		   *
	asl								;2		   *
	asl								;2		   *
	asl								;2		   *
	ldx		#$0a					;2	 =	12 *
lda1e
	cmp		inv_slot_lo,x				  ;4		 *
	bne		lda3a					;2/3	   *
	cpx		cursor_pos					;3		   *
	beq		lda3a					;2/3	   *
	dec		ram_C4					;5		   *
	lda		#$00					;2		   *
	sta		inv_slot_lo,x				  ;4		 *
	cpy		#$05					;2		   *
	bcc		lda37					;2/3	   *
	tya								;2		   *
	tax								;2		   *
	jsr		Ldd1b					;6		   *
	txa								;2		   *
	tay								;2	 =	40 *
lda37
	jmp		ldaf7					;3	 =	 3 *

lda3a
	dex								;2		   *
	dex								;2		   *
	bpl		lda1e					;2/3	   *
	clc								;2		   *
	rts								;6	 =	14 *

check_key
	lda		#<blank_gfx				; Load blank space
	ldx		cursor_pos				; get at current position
	sta		inv_slot_lo,x			; put in current slot
	ldx		current_object			; is the current object
	cpx		#key_obj				; the key?
	bcc		lda4f					;2/3	   *
	jsr		Ldd1b					;6	 =	22 *
lda4f
	txa								;2		   *
	tay								;2		   *
	asl								;2		   *
	tax								;2		   *
	lda		Ldc76,x					;4		   *
	pha								;3		   *
	lda		Ldc75,x					;4		   *
	pha								;3		   *
	ldx		room_num				  ;3		 *
	rts								;6	 =	31 *

lda5e:
	   lda	  #$3F					  ;2
	   and	  $B4					  ;3
	   sta	  $B4					  ;3
lda64:
	   jmp	  ldad8					  ;3

lda67:
	   stx	  $8D					  ;3
	   lda	  #$70					  ;2
	   sta	  $D1					  ;3
	   bne	  lda64					  ;2 aLways branch

lda6f:
	   lda	  #$42					  ;2
	   cmp	  $91					  ;3
	   bne	  lda86					  ;2
	   lda	  #$03					  ;2
	   sta	  $81					  ;3
	   jsr	  Ld878					  ;6
	   lda	  #$15					  ;2
	   sta	  $C9					  ;3
	   lda	  #$1C					  ;2
	   sta	  $CF					  ;3
	   bne	  ldad8					  ;2 aLways branch

lda86:
	   cpx	  #$05					  ;2
	   bne	  ldad8					  ;2
	   lda	  #$05					  ;2
	   cmp	  $8B					  ;3
	   bne	  ldad8					  ;2
	   sta	  yar_found				  ;3 5 points (gained)...shared from existing compare vaLue
	   lda	  #$00					  ;2
	   sta	  $CE					  ;3
	   lda	  #$02					  ;2
	   ora	  $B4					  ;3
	   sta	  $B4					  ;3
	   bne	  ldad8					  ;2 aLways branch

lda9e:
	   ror	  $B1					  ;5
	   clc							  ;2
	   roL	  $B1					  ;5
	   cpx	  #$02					  ;2
	   bne	  ldaAB					  ;2
	   lda	  #$4E					  ;2
	   sta	  $DF					  ;3
ldaAB:
	   bne	  ldad8					  ;2 aLways branch

ldaad:
	   ror	  $B2					  ;5
	   clc							  ;2
	   roL	  $B2					  ;5
	   cpx	  #$03					  ;2
	   bne	  ldaBE					  ;2
	   lda	  #$4F					  ;2
	   sta	  $DF					  ;3
	   lda	  #$4B					  ;2
	   sta	  $D0					  ;3
ldaBE:
	   bne	  ldad8					  ;2 aLways branch

ldac0:
	   ldx	  $81					  ;3
	   cpx	  #$03					  ;2
	   bne	  ldaD1					  ;2
	   lda	  $C9					  ;3
	   cmp	  #$3C					  ;2
	   bcs	  ldaD1					  ;2
	   roL	  $B2					  ;5
	   sec							  ;2
	   ror	  $B2					  ;5
ldaD1:
	   lda	  $91					  ;3
	   clc							  ;2
	   adc	  #$40					  ;2
	   sta	  $91					  ;3
ldad8:
	   dec	  $C4					  ;5
	   bne	  ldaE2					  ;2
	   lda	  #$00					  ;2
	   sta	  current_object		  ;3
	   beq	  ldaf7					  ;2 aLways branch

ldaE2:
	   ldx	  $C3					  ;3
ldaE4:
	   inx							  ;2
	   inx							  ;2
	   cpx	  #$0B					  ;2
	   bcc	  ldaEC					  ;2
	   ldx	  #$00					  ;2
ldaEC:
	   lda	  inv_slot_lo,X		 ;4
	   beq	  ldaE4					  ;2 branch if current sLot is free
	   stx	  $C3					  ;3  ...or store the sLot number
	   lsr							  ;2
	   lsr							  ;2
	   lsr							  ;2
	   sta	  current_object		  ;3 ...and the object number
ldaf7
	lda		#$0d					;2		   *
	sta		ram_A2					;3		   *
	sec								;2		   *
	rts								;6	 =	13 *

	.byte	$00,$00,$00						; $dafd (*)
room_miss0_size_tabl
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

room_bg_color_tbl
    .byte $00 ; |        | $DBA0 - Room $00 - Black #000000
    .byte $24 ; |  X  X  | $DBA1 - Room $01 - Paarl #985C28
    .byte $96 ; |X  X XX | $DBA2 - Room $02 
    .byte $22 ; |  X   X | $DBA3 - Room $03 
    .byte $72 ; | XXX  X | $DBA4 - Room $04 
    .byte $FC ; |XXXXXX  | $DBA5 - Room $05 
    .byte $00 ; |        | $DBA6 - Room $06 - Black #000000
    .byte $00 ; |        | $DBA7 - Room $07 - Black #000000 
    .byte $00 ; |        | $DBA8 - Room $08 - Black #000000 
    .byte $72 ; | XXX  X | $DBA9 - Room $09 
    .byte $12 ; |   X  X | $DBAA - Room $0a 
    .byte $00 ; |        | $DBAB - Room $0b - Black #000000 
    .byte $F8 ; |XXXXX   | $DBAC - Room $0c 
    .byte $00 ; |        | $DBAD - Room $0d - Black #000000 

room_pf_color_tbl
    .byte $08 ; |    X   | $DBAE - Room $00
    .byte $22 ; |  X   X | $DBAF - Room $01
    .byte $08 ; |    X   | $DBB0 - Room $02
    .byte $00 ; |        | $DBB1 - Room $03 - Black #000000
    .byte $1A ; |   XX X | $DBB2 - Room $04
    .byte $28 ; |  X X   | $DBB3 - Room $05
    .byte $C8 ; |XX  X   | $DBB4 - Room $06
    .byte $E8 ; |XXX X   | $DBB5 - Room $07
	.byte $8A ; |X   X X | $DBB6 - Room $08
    .byte $1A ; |   XX X | $DBB7 - Room $09
    .byte $C6 ; |XX   XX | $DBB8 - Room $0a
    .byte $00 ; |        | $DBB9 - Room $0b - Black #000000
    .byte $28 ; |  X X   | $DBBA - Room $0c
    .byte $78 ; | XXXX   | $DBBB - Room $0d

room_p1_color_tbl
	.byte $CC ; |XX  XX  | $DBBC
    .byte $EA ; |XXX X X | $DBBD
    .byte $5A ; | X XX X | $DBBE
    .byte $26 ; |  X  XX | $DBBF
    .byte $9E ; |X  XXXX | $DBC0
    .byte $A6 ; |X X  XX | $DBC1
    .byte $7C ; | XXXXX  | $DBC2

room_p0_color_tbl
	.byte $88 ; |X   X   | $DBC3
    .byte $28 ; |  X X   | $DBC4
    .byte $F8 ; |XXXXX   | $DBC5
    .byte $4A ; | X  X X | $DBC6
    .byte $26 ; |  X  XX | $DBC7
    .byte $A8 ; |X X X   | $DBC8

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
	.byte	$0b




Ldc77: ;read from 2 bytes eaLier (index >=2)
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

Ldc9b:
	   .word Ld2b4-1 ; $dc9b/9c
	   .word Ld1eb-1 ; $dc9d/9e
	   .word Ld292-1 ; $dc9f/a0
	   .word Ld24a-1 ; $dca1/a2
	   .word Ld2b4-1 ; $dca3/a4
	   .word Ld1c4-1 ; $dca5/a6
	   .word Ld28e-1 ; $dca7/a8
	   .word Ld1b9-1 ; $dca9/aa
	   .word Ld335-1 ; $dcab/ac
	   .word Ld2b4-1 ; $dcad/ae
	   .word Ld192-1 ; $dcaf/b0
	   .word Ld18e-1 ; $dcb1/b2
	   .word Ld162-1 ; $dcb3/b4

Ldcb5:
	   .word Ld374-1 ; $dcb5/b6
	   .word Ld374-1 ; $dcb7/b8
	   .word Ld321-1 ; $dcb9/ba
	   .word Ld374-1 ; $dcbb/bc
	   .word Ld374-1 ; $dcbd/be
	   .word Ld357-1 ; $dcbf/c0
	   .word Ld302-1 ; $dcc1/c2
	   .word Ld357-1 ; $dcc3/c4
	   .word Ld335-1 ; $dcc5/c6
	   .word Ld374-1 ; $dcc7/c8
	   .word Ld36a-1 ; $dcc9/ca
	   .word Ld374-1 ; $dccb/cc
	   .word Ld374-1 ; $dccd/ce

Ldccf:
	   .word Ld374-1 ; $dccf/d0
	   .word Ld374-1 ; $dcd1/d2
	   .word Ld36f-1 ; $dcd3/d4
	   .word Ld374-1 ; $dcd5/d6
	   .word Ld2f2-1 ; $dcd7/d8
	   .word Ld374-1 ; $dcd9/da
	   .word Ld374-1 ; $dcdb/dc
	   .word Ld374-1 ; $dcdd/de
	   .word Ld374-1 ; $dcdf/e0
	   .word Ld2ce-1 ; $dce1/e2
	   .word Ld36f-1 ; $dce3/e4
	   .word Ld374-1 ; $dce5/e6
	   .word Ld374-1 ; $dce7/e8

Ldce9
	ldx		ram_C4					;3		   *
	cpx		#$06					;2		   *
	bcc		Ldcf1					;2/3	   *
	clc								;2		   *
	rts								;6	 =	15 *

Ldcf1
	ldx		#$0a					;2	 =	 2 *
Ldcf3
	ldy		inv_slot_lo,x				  ;4		 *
	beq		Ldcfc					; branch if current slot is free
	dex								;2		   *
	dex								;2		   *
	bpl		Ldcf3					;2/3	   *
	brk								; unused

Ldcfc
	tay								;2		   *
	asl								; Multiply object number by 8 for gfx
	asl								;...
	asl								;...
	sta		inv_slot_lo,x			; and store in current slot
	lda		ram_C4					;3		   *
	bne		Ldd0a					;2/3	   *
	stx		cursor_pos					;3		   *
	sty		current_object					;3	 =	23 *
Ldd0a
	inc		ram_C4					;5		   *
	cpy		#$04					;2		   *
	bcc		Ldd15					;2/3	   *
	tya								;2		   *
	tax								;2		   *
	jsr		Ldd2f					;6	 =	19 *
Ldd15
	lda		#$0c					;2		   *
	sta		ram_A2					;3		   *
	sec								;2		   *
	rts								;6	 =	13 *

Ldd1b
	lda		Ldc64,x					;4		   *
	lsr								;2		   *
	tay								;2		   *
	lda		Ldc5c,y					;4		   *
	bcs		Ldd2a					;2/3	   *
	and		ram_C6					;3		   *
	sta		ram_C6					;3		   *
	rts								;6	 =	26 *

Ldd2a
	and		ram_C7					;3		   *
	sta		ram_C7					;3		   *
	rts								;6	 =	12 *

Ldd2f
	lda		Ldc64,x					;4		   *
	lsr								;2		   *
	tax								;2		   *
	lda		Ldc54,x					;4		   *
	bcs		Ldd3e					;2/3	   *
	ora		ram_C6					;3		   *
	sta		ram_C6					;3		   *
	rts								;6	 =	26 *

Ldd3e
	ora		ram_C7					;3		   *
	sta		ram_C7					;3		   *
	rts								;6	 =	12 *

Ldd43:
	   lda	  Ldc64,x				  ;4
	   lsr							  ;2
	   tay							  ;2
	   lda	  Ldc54,y				  ;4
	   bcs	  Ldd53					  ;2
	   and	  ram_C6					 ;3
	   beq	  Ldd52					  ;2
	   sec							  ;2
Ldd52:
	   rts							  ;6

Ldd53:
	   and	  ram_C7					 ;3
	   bne	  Ldd52					  ;2
	   clc							  ;2
	   rts							  ;6


Ldd59
	and		#$1f					;2
	tax								;2
	lda		ram_98					;3
	cpx		#$0c					;2
	bcs		Ldd67					;2/3
	adc		Ldfe5,x					;4
	sta		ram_98					;3	 =	18
Ldd67
	rts								;6	 =	 6

game_start
	sei								; Turn off interrupts
	cLd								; Clear DecimaL fLag (No BCD)
	ldx		#$ff					;
	txs								; Reset the stack pointer
	inx								; Clear X
	txa								; Clear A
clear_zp
	sta		zero_page,x
	dex
	bne		clear_zp

	dex								; x = $FF
	stx		score					; reset score
	lda		#>blank_gfx				; Blank inventory
	sta		inv_slot_hi				; slot 1
	sta		inv_slot2_hi			; slot 2
	sta		inv_slot3_hi			; slot 3
	sta		inv_slot4_hi			; slot 4
	sta		inv_slot5_hi			; slot 5
	sta		inv_slot6_hi			; slot 6

	;Fill with copyright text
	lda		#<copyright_gfx_1
	sta		inv_slot_lo
	lda		#<copyright_gfx_2
	sta		inv_slot2_lo
	lda		#<copyright_gfx_4
	sta		inv_slot4_Lo
	lda		#<copyright_gfx_3
	sta		inv_slot3_lo
	lda		#<copyright_gfx_5
	sta		inv_slot5_lo
	lda		#$0d					; Set "Ark Elevator Room" (Room 13)
	sta		room_num				; as current room
	lsr								; divide 13 by 2 (round down)
	sta		num_buLLets				; Load 6 buLLets
	jsr		Ld878					;6
	jmp		Ld3dd					;3	 =	77

reset_vars
	lda		#$20					;2		   *
	sta		inv_slot_lo				  ;3		 *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	sta		current_object					;3		   *
	inc		ram_C4					;5		   *
	lda		#$00					;2		   *
	sta		inv_slot2_lo				  ;3		 *
	sta		inv_slot3_lo				  ;3		 *
	sta		inv_slot4_Lo				  ;3		 *
	sta		inv_slot5_lo				  ;3		 *
	lda		#$64					;2		   *
	sta		score				   ;3		  *
	lda		#$58					;2		   *
	sta		indy_anim				   ;3		  *
	lda		#$fa					;2		   *
	sta		ram_DA					;3		   *
	lda		#$4c					;2		   *
	sta		indy_x					;3		   *
	lda		#$0f					;2		   *
	sta		indy_y					;3		   *
	lda		#$02					;2		   *
	sta		room_num				  ;3		 *
	sta		lives_left					;3		   *
	jsr		Ld878					;6		   *
	jmp		Ld80d					;3	 =	75 *

tally_score
	lda		score				   	; Load score
	sec								; Positve actions...
	sbc		shovel_used				; Shovel used
	sbc		parachute_used			; Parachute used
	sbc		ankh_used				; ankh used
	sbc		yar_found				; yar found
	sbc		lives_left				; lives left
	sbc		ark_found				; ark found
	sbc		mesa_entered		  	; mesa entered
	sbc		unknown_action			; never updated
	clc								; Negitive actions...
	adc		grenade_used			; gernade used
	adc		escape_hatch_used		; escape hatch used
	adc		thief_shot				; thief shot
	sta		score				   	; store in final score
	rts								; return

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
	.byte	$00,$00,$42,$45,$0c,$20

Ldf78
	.byte $04 ; |	  X	 | $DF78
	.byte $11 ; |	X	X| $DF79
	.byte $10 ; |	X	 | $DF7A
	.byte $12 ; |	X  X | $DF7B


Ldf7c
	.byte	$07,$03,$05,$06,$09,$0b,$0e,$00 ; $df7c (*)
	.byte	$01,$03,$05,$00,$09,$0c,$0e,$00 ; $df84 (*)
	.byte	$01,$04,$05,$00,$0a,$0c,$0f,$00 ; $df8c (*)
	.byte	$02,$04,$05,$08,$0a,$0d,$0f,$00 ; $df94 (*)

Ldf9c
	lda		INTIM					;4
	bne		Ldf9c					;2/3
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
	sta		ram_84					;3
	lda		#$f9					;2
	sta		ram_85					;3
	lda		#$ff					;2
	sta		ram_86					;3
	lda		#$4c					;2
	sta		ram_87					;3
	jmp.w	ram_84					;3	 =	23

move_enemy
	ror								;Move first bit into carry
	bcs		mov_emy_right			;If 1 check if enemy shouLLd go right
	dec		enemy_y,x				;Move enemy Left 1 unit
mov_emy_right
	ror								;Rotate next bit into carry
	bcs		mov_emy_down			  ;if 1 check if enemy shouLd go up
	inc		enemy_y,x				;Move enemy right 1 unit
mov_emy_down
	ror								;Rotate next bit into carry
	bcs		mov_emy_up				;if 1 check if enemy shouLd go up
	dec		enemy_x,x				;Move enemy down 1 unit
mov_emy_up
	ror								;Rotate next bit into carry
	bcs		mov_emy_finish			;if 1, moves are finished
	inc		enemy_x,x				;Move enemy up 1 unit
mov_emy_finish
	rts								;return

Ldfd5
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
	cmp		ram_E0					;3		   *
	bcs		Lf01a					;2/3	   *
	lsr								;2		   *
	clc								;2		   *
	adc		ram_DF					;3		   *
	tay								;2		   *
	sta		WSYNC					;3	 =	17 *
;---------------------------------------
	sta		HMOVE					;3		   *
	lda		(PF1_data),y			  ;5		 *
	sta		PF1						;3		   *
	lda		(PF2_data),y			  ;5		 *
	sta		PF2						;3		   *
	bcc		Lf033					;2/3 =	21 *
Lf01a
	sbc		ram_D4					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	sta		WSYNC					;3	 =	10 *
;---------------------------------------
	sta		HMOVE					;3		   *
	tax								;2		   *
	cpx		ram_D5					;3		   *
	bcc		Lf02d					;2/3	   *
	ldx		ram_D8					;3		   *
	lda		#$00					;2		   *
	beq		Lf031					;2/3 =	17 *
Lf02d
	lda		ram_E5,x				;4		   *
	ldx		ram_D8					;3	 =	 7 *
Lf031
	sta		PF1,x					;4	 =	 4 *
Lf033
	ldx		#$1e					;2		   *
	txs								;2		   *
	lda		scan_Line				   ;3		  *
	sec								;2		   *
	sbc		indy_y					;3		   *
	cmp		indy_h					;3		   *
	bcs		Lf079					;2/3	   *
	tay								;2		   *
	lda		(indy_anim),y			   ;5		  *
	tax								;2	 =	26 *
Lf043
	lda		scan_Line				   ;3		  *
	sec								;2		   *
	sbc		enemy_y					 ;3			*
	cmp		snake_y					 ;3			*
	bcs		Lf07d					;2/3	   *
	tay								;2		   *
	lda		(emy_anim),y			  ;5		 *
	tay								;2	 =	22 *
Lf050
	lda		scan_Line				   ;3		  *
	sta		WSYNC					;3	 =	 6 *
;---------------------------------------
	sta		HMOVE					;3		   *
	cmp		ram_D1					;3		   *
	php								;3		   *
	cmp		ram_D0					;3		   *
	php								;3		   *
	stx		GRP1					;3		   *
	sty		GRP0					;3		   *
	sec								;2		   *
	sbc		ram_D2					;3		   *
	cmp		#$08					;2		   *
	bcs		Lf06e					;2/3	   *
	tay								;2		   *
	lda		(ram_D6),y				;5		   *
	sta		ENABL					;3		   *
	sta		HMBL					;3	 =	43 *
Lf06e
	inc		scan_Line				   ;5		  *
	lda		scan_Line				   ;3		  *
	cmp		#$50					;2		   *
	bcc		Lf003					;2/3	   *
	jmp		Lf1ea					;3	 =	15 *

Lf079
	ldx		#$00					;2		   *
	beq		Lf043					;2/3 =	 4 *
Lf07d
	ldy		#$00					;2		   *
	beq		Lf050					;2/3 =	 4 *
Lf081
	cpx		#$4f					;2		   *
	bcc		Lf088					;2/3	   *
	jmp		Lf1ea					;3	 =	 7 *

Lf088
	lda		#$00					;2		   *
	beq		Lf0a4					;2/3 =	 4 *
Lf08c
	lda		(emy_anim),y			  ;5		 *
	bmi		Lf09c					;2/3	   *
	cpy		ram_DF					;3		   *
	bcs		Lf081					;2/3	   *
	cpy		enemy_y					 ;3			*
	bcc		Lf088					;2/3	   *
	sta		GRP0					;3		   *
	bcs		Lf0a4					;2/3 =	22 *
Lf09c
	asl								;2		   *
	tay								;2		   *
	and		#$02					;2		   *
	tax								;2		   *
	tya								;2		   *
	sta		(PF1_data,x)			  ;6   =  16 *
Lf0a4
	inc		scan_Line				   ;5		  *
	ldx		scan_Line				   ;3		  *
	lda		#$02					;2		   *
	cpx		ram_D0					;3		   *
	bcc		Lf0b2					;2/3	   *
	cpx		ram_E0					;3		   *
	bcc		Lf0b3					;2/3 =	20 *
Lf0b2
	ror								;2	 =	 2 *
Lf0b3
	sta		ENAM0					;3		   *
Lf0b5
	sta		WSYNC					;3	 =	 6 *
;---------------------------------------
	sta		HMOVE					;3		   *
	txa								;2		   *
	sec								;2		   *
	sbc		ram_D5					;3		   *
	cmp		#$10					;2		   *
	bcs		Lf0ff					;2/3	   *
	tay								;2		   *
	cmp		#$08					;2		   *
	bcc		Lf0fb					;2/3	   *
	lda		ram_D8					;3		   *
	sta		ram_D6					;3	 =	26 *
Lf0ca
	lda		(ram_D6),y				;5		   *
	sta		HMBL					;3	 =	 8 *
Lf0ce
	ldy		#$00					;2		   *
	txa								;2		   *
	cmp		ram_D1					;3		   *
	bne		Lf0d6					;2/3	   *
	dey								;2	 =	11 *
Lf0d6
	sty		ENAM1					;3		   *
	sec								;2		   *
	sbc		indy_y					;3		   *
	cmp		indy_h					;3		   *
	bcs		Lf107					;2/3!	   *
	tay								;2		   *
	lda		(indy_anim),y			   ;5	=  20 *
Lf0e2
	ldy		scan_Line				   ;3		  *
	sta		GRP1					;3		   *
	sta		WSYNC					;3	 =	 9 *
;---------------------------------------
	sta		HMOVE					;3		   *
	lda		#$02					;2		   *
	cpx		ram_D2					;3		   *
	bcc		Lf0f9					;2/3	   *
	cpx		snake_y					 ;3			*
	bcc		Lf0f5					;2/3 =	15 *
Lf0f4
	ror								;2	 =	 2 *
Lf0f5
	sta		ENABL					;3		   *
	bcc		Lf08c					;2/3 =	 5 *
Lf0f9
	bcc		Lf0f4					;2/3 =	 2 *
Lf0fb
	nop								;2		   *
	jmp		Lf0ca					;3	 =	 5 *

Lf0ff
	pha								;3		   *
	pLa								;4		   *
	pha								;3		   *
	pLa								;4		   *
	nop								;2		   *
	jmp		Lf0ce					;3	 =	19 *

Lf107
	lda		#$00					;2		   *
	beq		Lf0e2					;2/3!=	 4 *
Lf10b
	inx								;2		   *
	sta		HMCLR					;3		   *
	cpx		#$a0					;2		   *
	bcc		Lf140					;2/3	   *
	jmp		Lf1ea					;3	 =	12 *

Lf115
	sta		WSYNC					;3	 =	 3 *
;---------------------------------------
	sta		HMOVE					;3		   *
	inx								;2		   *
	lda		ram_84					;3		   *
	sta		GRP0					;3		   *
	lda		ram_85					;3		   *
	sta		COLUP0					;3		   *
	txa								;2		   *
	ldx		#$1f					;2		   *
	txs								;2		   *
	tax								;2		   *
	lsr								;2		   *
	cmp		ram_D2					;3		   *
	php								;3		   *
	cmp		ram_D1					;3		   *
	php								;3		   *
	cmp		ram_D0					;3		   *
	php								;3		   *
	sec								;2		   *
	sbc		indy_y					;3		   *
	cmp		indy_h					;3		   *
	bcs		Lf10b					;2/3	   *
	tay								;2		   *
	lda		(indy_anim),y			   ;5		  *
	sta		HMCLR					;3		   *
	inx								;2		   *
	sta		GRP1					;3	 =	70 *
Lf140
	sta		WSYNC					;3	 =	 3 *
;---------------------------------------
	sta		HMOVE					;3		   *
	bit		ram_D4					;3		   *
	bpl		Lf157					;2/3	   *
	ldy		ram_89					;3		   *
	lda		ram_88					;3		   *
	lsr		ram_D4					;5	 =	19 *
Lf14e
	dey								;2		   *
	bpl		Lf14e					;2/3	   *
	sta		RESP0					;3		   *
	sta		HMP0					;3		   *
	bmi		Lf115					;2/3 =	12 *
Lf157
	bvc		Lf177					;2/3	   *
	txa								;2		   *
	and		#$0f					;2		   *
	tay								;2		   *
	lda		(emy_anim),y			  ;5		 *
	sta		GRP0					;3		   *
	lda		(ram_D6),y				;5		   *
	sta		COLUP0					;3		   *
	iny								;2		   *
	lda		(emy_anim),y			  ;5		 *
	sta		ram_84					;3		   *
	lda		(ram_D6),y				;5		   *
	sta		ram_85					;3		   *
	cpy		snake_y					 ;3			*
	bcc		Lf174					;2/3	   *
	lsr		ram_D4					;5	 =	52 *
Lf174
	jmp		Lf115					;3	 =	 3 *

Lf177
	lda		#$20					;2		   *
	bit		ram_D4					;3		   *
	beq		Lf1a7					;2/3	   *
	txa								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	bcs		Lf115					;2/3	   *
	tay								;2		   *
	sty		ram_87					;3		   *
	lda.wy	ram_DF,y				;4		   *
	sta		REFP0					;3		   *
	sta		NUSIZ0					;3		   *
	sta		ram_86					;3		   *
	bpl		Lf1a2					;2/3	   *
	lda		ram_96					;3		   *
	sta		emy_anim				  ;3		 *
	lda		#$65					;2		   *
	sta		ram_D6					;3		   *
	lda		#$00					;2		   *
	sta		ram_D4					;3		   *
	jmp		Lf115					;3	 =	60 *

Lf1a2
	lsr		ram_D4					;5		   *
	jmp		Lf115					;3	 =	 8 *

Lf1a7
	lsr								;2		   *
	bit		ram_D4					;3		   *
	beq		Lf1ce					;2/3	   *
	ldy		ram_87					;3		   *
	lda		#$08					;2		   *
	and		ram_86					;3		   *
	beq		Lf1b6					;2/3	   *
	lda		#$03					;2	 =	19 *
Lf1b6
	eor.wy	ram_E5,y				;4		   *
	and		#$03					;2		   *
	tay								;2		   *
	lda		Lfc40,y					;4		   *
	sta		emy_anim				  ;3		 *
	lda		#$44					;2		   *
	sta		ram_D6					;3		   *
	lda		#$0f					;2		   *
	sta		snake_y					 ;3			*
	lsr		ram_D4					;5		   *
	jmp		Lf115					;3	 =	33 *

Lf1ce
	txa								;2		   *
	and		#$1f					;2		   *
	cmp		#$0c					;2		   *
	beq		Lf1d8					;2/3	   *
	jmp		Lf115					;3	 =	11 *

Lf1d8
	ldy		ram_87					;3		   *
	lda.wy	ram_EE,y				;4		   *
	sta		ram_88					;3		   *
	and		#$0f					;2		   *
	sta		ram_89					;3		   *
	lda		#$80					;2		   *
	sta		ram_D4					;3		   *
	jmp		Lf115					;3	 =	23 *

Lf1ea
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	sta		HMOVE					;3
	ldx		#$ff					;2
	stx		PF1						;3
	stx		PF2						;3
	inx								;2
	stx		GRP0					;3
	stx		GRP1					;3
	stx		ENAM0					;3
	stx		ENAM1					;3
	stx		ENABL					;3
	sta		WSYNC					;3	 =	31
;---------------------------------------
	sta		HMOVE					;3
	lda		#$03					;2
	ldy		#$00					;2
	sty		REFP1					;3
	sta		NUSIZ0					;3
	sta		NUSIZ1					;3
	sta		VDELP0					;3
	sta		VDELP1					;3
	sty		GRP0					;3
	sty		GRP1					;3
	sty		GRP0					;3
	sty		GRP1					;3
	nop								;2
	sta		RESP0					;3
	sta		RESP1					;3
	sty		HMP1					;3
	lda		#$f0					;2
	sta		HMP0					;3
	sty		REFP0					;3
	sta		WSYNC					;3	 =	56
;---------------------------------------
	sta		HMOVE					;3
	lda		#$1a					;2
	sta		COLUP0					;3
	sta		COLUP1					;3
	lda		cursor_pos					;3
	lsr								;2
	tay								;2
	lda		Lfff2,y					;4
	sta		HMBL					;3
	and		#$0f					;2
	tay								;2
	ldx		#$00					;2
	stx		HMP0					;3
	sta		WSYNC					;3	 =	37
;---------------------------------------
	stx		PF0						;3
	stx		COLUBK					;3
	stx		PF1						;3
	stx		PF2						;3	 =	12
Lf24a
	dey								;2
	bpl		Lf24a					;2/3
	sta		RESBL					;3
	stx		CTRLPF					;3
	sta		WSYNC					;3	 =	13
;---------------------------------------
	sta		HMOVE					;3
	lda		#$3f					;2
	and		frame_counter				   ;3
	bne		draw_menu					;2/3
	lda		#$3f					;2
	and		time_of_day					 ;3
	bne		draw_menu					;2/3
	lda		ram_B5					;3		   *
	and		#$0f					;2		   *
	beq		draw_menu					;2/3	   *
	cmp		#$0f					;2		   *
	beq		draw_menu					;2/3	   *
	inc		ram_B5					;5	 =	33 *
draw_menu
	sta		WSYNC					; Draw BLank Line
	lda		#$42					; Set red...
	sta		COLUBK					; ...as the background color
	sta		WSYNC					; Draw four more scanlines
	sta		WSYNC					;
	sta		WSYNC					;
	sta		WSYNC					;
	lda		#$07					;2
	sta		ram_84					;3	 =	 5
draw_inventory
	ldy		ram_84					;3
	lda		(inv_slot_lo),y			  ;5
	sta		GRP0					;3
	sta		WSYNC					;3	 =	14
;---------------------------------------
	lda		(inv_slot2_lo),y			  ;5
	sta		GRP1					;3
	lda		(inv_slot3_lo),y			  ;5
	sta		GRP0					;3
	lda		(inv_slot4_Lo),y			  ;5
	sta		ram_85					;3
	lda		(inv_slot5_lo),y			  ;5
	tax								;2
	lda		(inv_slot6_Lo),y			  ;5
	tay								;2
	lda		ram_85					;3
	sta		GRP1					;3
	stx		GRP0					;3
	sty		GRP1					;3
	sty		GRP0					;3
	dec		ram_84					;5
	bpl		draw_inventory					 ;2/3
	lda		#$00					;2
	sta		WSYNC					;3	 =	65
;---------------------------------------
	sta		GRP0					;3
	sta		GRP1					;3
	sta		GRP0					;3
	sta		GRP1					;3
	sta		NUSIZ0					;3
	sta		NUSIZ1					;3
	sta		VDELP0					;3
	sta		VDELP1					;3
	sta		WSYNC					;3	 =	27
;---------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	ldy		#$02					;2
	lda		ram_C4					;3
	bne		Lf2c6					;2/3
	dey								;2	 =	 9
Lf2c6
	sty		ENABL					;3
	ldy		#$08					;2
	sty		COLUPF					;3
	sta		WSYNC					;3	 =	11
;---------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	ldy		#$00					;2
	sty		ENABL					;3
	sta		WSYNC					;3	 =	 8
;---------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	ldx		#$0f					;2
	stx		VBLANK					;3
	ldx		#$24					;2
	stx		TIM64T					;4
	ldx		#$ff					;2
	txs								;2
	ldx		#$01					;2	 =	17
Lf2e8
	lda		ram_A2,x				;4
	sta		AUDC0,x					;4
	sta		AUDV0,x					;4
	bmi		Lf2fb					;2/3
	ldy		#$00					;2
	sty		ram_A2,x				;4	 =	20
Lf2f4
	sta		AUDF0,x					;4
	dex								;2
	bpl		Lf2e8					;2/3
	bmi		Lf320					;2/3!=	10
Lf2fb
	cmp		#$9c					;2
	bne		Lf314					;2/3!
	lda		#$0f					;2
	and		frame_counter				   ;3
	bne		Lf30d					;2/3
	dec		diamond_h				   ;5
	bpl		Lf30d					;2/3
	lda		#$17					;2
	sta		diamond_h				   ;3	=  23
Lf30d
	ldy		diamond_h				   ;3
	lda		Lfbe8,y					;4
	bne		Lf2f4					;2/3!=	 9
Lf314
	lda		frame_counter				   ;3		  *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	tay								;2		   *
	lda		Lfaee,y					;4		   *
	bne		Lf2f4					;2/3!=	19 *
Lf320
	lda		current_object					;3
	cmp		#$0f					;2
	beq		Lf330					;2/3
	cmp		#$02					;2
	bne		Lf344					;2/3
	lda		#$84					;2		   *
	sta		ram_A3					;3		   *
	bne		Lf348					;2/3 =	18 *
Lf330
	bit		INPT5|$30				;3		   *
	bpl		Lf338					;2/3	   *
	lda		#$78					;2		   *
	bne		Lf340					;2/3 =	 9 *
Lf338
	lda		time_of_day					 ;3			*
	and		#$e0					;2		   *
	lsr								;2		   *
	lsr								;2		   *
	adc		#$98					;2	 =	11 *
Lf340
	ldx		cursor_pos					;3		   *
	sta		inv_slot_lo,x				  ;4   =   7 *
Lf344
	lda		#$00					;2
	sta		ram_A3					;3	 =	 5
Lf348
	bit		ram_93					;3
	bpl		Lf371					;2/3
	lda		frame_counter				   ;3		  *
	and		#$07					;2		   *
	cmp		#$05					;2		   *
	bcc		Lf365					;2/3	   *
	ldx		#$04					;2		   *
	ldy		#$01					;2		   *
	bit		ram_9D					;3		   *
	bmi		Lf360					;2/3	   *
	bit		ram_A1					;3		   *
	bpl		Lf362					;2/3 =	28 *
Lf360
	ldy		#$03					;2	 =	 2 *
Lf362
	jsr		Lf8b3					;6	 =	 6 *
Lf365
	lda		frame_counter				   ;3		  *
	and		#$06					;2		   *
	asl								;2		   *
	asl								;2		   *
	sta		ram_D6					;3		   *
	lda		#$fd					;2		   *
	sta		ram_D7					;3	 =	17 *
Lf371
	ldx		#$02					;2	 =	 2
Lf373
	jsr		Lfef4					;6
	inx								;2
	cpx		#$05					;2
	bcc		Lf373					;2/3
	bit		ram_9D					;3
	bpl		Lf3bf					;2/3
	lda		frame_counter				   ;3		  *
	bvs		Lf39d					;2/3	   *
	and		#$0f					;2		   *
	bne		Lf3c5					;2/3	   *
	ldx		indy_h					;3		   *
	dex								;2		   *
	stx		ram_A3					;3		   *
	cpx		#$03					;2		   *
	bcc		Lf398					;2/3	   *
	lda		#$8f					;2		   *
	sta		ram_D1					;3		   *
	stx		indy_h					;3		   *
	bcs		Lf3c5					;2/3 =	48 *
Lf398
	sta		frame_counter				   ;3		  *
	sec								;2		   *
	ror		ram_9D					;5	 =	10 *
Lf39d
	cmp		#$3c					;2		   *
	bcc		Lf3a9					;2/3	   *
	bne		Lf3a5					;2/3	   *
	sta		ram_A3					;3	 =	 9 *
Lf3a5
	ldy		#$00					;2		   *
	sty		indy_h					;3	 =	 5 *
Lf3a9
	cmp		#$78					;2		   *
	bcc		Lf3c5					;2/3	   *
	lda		#$0b					;2		   *
	sta		indy_h					;3		   *
	sta		ram_A3					;3		   *
	sta		ram_9D					;3		   *
	dec		lives_left					;5		   *
	bpl		Lf3c5					;2/3	   *
	lda		#$ff					;2		   *
	sta		ram_9D					;3		   *
	bne		Lf3c5					;2/3 =	29 *
Lf3bf
	lda		room_num				  ;3
	cmp		#$0d					;2
	bne		Lf3d0					;2/3 =	 7
Lf3c5
	lda		#$d8					;2
	sta		ram_88					;3
	lda		#$d3					;2
	sta		ram_89					;3
	jmp		Lf493					;3	 =	13

Lf3d0
	bit		ram_8D					;3		   *
	bvs		Lf437					;2/3!	   *
	bit		ram_B4					;3		   *
	bmi		Lf437					;2/3!	   *
	bit		ram_9A					;3		   *
	bmi		Lf437					;2/3!	   *
	lda		#$07					;2		   *
	and		frame_counter				   ;3		  *
	bne		Lf437					;2/3!	   *
	lda		ram_C4					;3		   *
	and		#$06					;2		   *
	beq		Lf437					;2/3!	   *
	ldx		cursor_pos					;3		   *
	lda		inv_slot_lo,x				  ;4		 *
	cmp		#$98					;2		   *
	bcc		Lf3f2					;2/3	   *
	lda		#$78					;2	 =	42 *
Lf3f2
	bit		SWCHA					;4		   *
	bmi		Lf407					;2/3!	   *
	sta		inv_slot_lo,x				  ;4   =  10 *
Lf3f9
	inx								;2		   *
	inx								;2		   *
	cpx		#$0b					;2		   *
	bcc		Lf401					;2/3!	   *
	ldx		#$00					;2	 =	10 *
Lf401
	ldy		inv_slot_lo,x				  ;4		 *
	beq		Lf3f9					;2/3!	   *
	bne		Lf415					;2/3 =	 8 *
Lf407
	bvs		Lf437					;2/3	   *
	sta		inv_slot_lo,x				  ;4   =   6 *
Lf40b
	dex								;2		   *
	dex								;2		   *
	bpl		Lf411					;2/3	   *
	ldx		#$0a					;2	 =	 8 *
Lf411
	ldy		inv_slot_lo,x				  ;4		 *
	beq		Lf40b					;2/3 =	 6 *
Lf415
	stx		cursor_pos					;3		   *
	tya								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	sta		current_object					;3		   *
	cpy		#$90					;2		   *
	bne		Lf437					;2/3	   *
	ldy		#$09					;2		   *
	cpy		room_num				  ;3		 *
	bne		Lf437					;2/3	   *
	lda		#$49					;2		   *
	sta		ram_8D					;3		   *
	lda		indy_y					;3		   *
	adc		#$09					;2		   *
	sta		ram_D1					;3		   *
	lda		indy_x					;3		   *
	adc		#$09					;2		   *
	sta		ram_CB					;3	 =	46 *
Lf437
	lda		ram_8D					;3		   *
	bpl		Lf454					;2/3	   *
	cmp		#$bf					;2		   *
	bcs		Lf44b					;2/3	   *
	adc		#$10					;2		   *
	sta		ram_8D					;3		   *
	ldx		#$03					;2		   *
	jsr		Lfcea					;6		   *
	jmp		Lf48b					;3	 =	25 *

Lf44b
	lda		#$70					;2		   *
	sta		ram_D1					;3		   *
	lsr								;2		   *
	sta		ram_8D					;3		   *
	bne		Lf48b					;2/3 =	12 *
Lf454
	bit		ram_8D					;3		   *
	bvc		Lf48b					;2/3	   *
	ldx		#$03					;2		   *
	jsr		Lfcea					;6		   *
	lda		ram_CB					;3		   *
	sec								;2		   *
	sbc		#$04					;2		   *
	cmp		indy_x					;3		   *
	bne		Lf46a					;2/3	   *
	lda		#$03					;2		   *
	bne		Lf481					;2/3 =	29 *
Lf46a
	cmp		#$11					;2		   *
	beq		Lf472					;2/3	   *
	cmp		#$84					;2		   *
	bne		Lf476					;2/3 =	 8 *
Lf472
	lda		#$0f					;2		   *
	bne		Lf481					;2/3 =	 4 *
Lf476
	lda		ram_D1					;3		   *
	sec								;2		   *
	sbc		#$05					;2		   *
	cmp		indy_y					;3		   *
	bne		Lf487					;2/3	   *
	lda		#$0c					;2	 =	14 *
Lf481
	eor		ram_8D					;3		   *
	sta		ram_8D					;3		   *
	bne		Lf48b					;2/3 =	 8 *
Lf487
	cmp		#$4a					;2		   *
	bcs		Lf472					;2/3 =	 4 *
Lf48b
	lda		#$24					;2		   *
	sta		ram_88					;3		   *
	lda		#$d0					;2		   *
	sta		ram_89					;3	 =	10 *
Lf493
	lda		#$ad					;2
	sta		ram_84					;3
	lda		#$f8					;2
	sta		ram_85					;3
	lda		#$ff					;2
	sta		ram_86					;3
	lda		#$4c					;2
	sta		ram_87					;3
	jmp.w	ram_84					;3	 =	23

Lf4a6
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	cpx		#$12					;2
	bcc		Lf4d0					;2/3
	txa								;2
	sbc		indy_y					;3
	bmi		Lf4c9					;2/3
	cmp		#$14					;2
	bcs		Lf4bd					;2/3
	lsr								;2
	tay								;2
	lda		indy_sprite,y				  ;4
	jmp		Lf4c3					;3	 =	26

Lf4bd
	and		#$03					;2
	tay								;2
	lda		Lf9fc,y					;4	 =	 8
Lf4c3
	sta		GRP1					;3
	lda		indy_y					;3
	sta		COLUP1					;3	 =	 9
Lf4c9
	inx								;2
	cpx		#$90					;2
	bcs		Lf4ea					;2/3
	bcc		Lf4a6					;2/3 =	 8
Lf4d0
	bit		ram_9C					;3
	bmi		Lf4e5					;2/3
	txa								;2
	sbc		#$07					;2
	bmi		Lf4e5					;2/3
	tay								;2
	lda		Lfb40,y					;4
	sta		GRP1					;3
	txa								;2
	adc		frame_counter				   ;3
	asl								;2
	sta		COLUP1					;3	 =	30
Lf4e5
	inx								;2
	cpx		#$0f					;2
	bcc		Lf4a6					;2/3 =	 6
Lf4ea
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	cpx		#$20					;2
	bcs		Lf511					;2/3!
	bit		ram_9C					;3
	bmi		Lf504					;2/3!
	txa								;2
	ldy		#$7e					;2
	and		#$0e					;2
	bne		Lf4fd					;2/3
	ldy		#$ff					;2	 =	19
Lf4fd
	sty		GRP0					;3
	txa								;2
	eor		#$ff					;2
	sta		COLUP0					;3	 =	10
Lf504
	inx								;2
	cpx		#$1d					;2
	bcc		Lf4ea					;2/3!
	lda		#$00					;2
	sta		GRP0					;3
	sta		GRP1					;3
	beq		Lf4a6					;2/3!=	16
Lf511
	txa								;2
	sbc		#$90					;2
	cmp		#$0f					;2
	bcc		Lf51b					;2/3
	jmp		Lf1ea					;3	 =	11

Lf51b
	lsr								;2
	lsr								;2
	tay								;2
	lda		Lfef0,y					;4
	sta		GRP0					;3
	stx		COLUP0					;3
	inx								;2
	bne		Lf4ea					;2/3!
	lda		room_num				  ;3		 *
	asl								;2		   *
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

draw_fieLd
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	sta		HMCLR					;3
	sta		CXCLR					;3
	ldy		#$ff					;2
	sty		PF1						;3
	sty		PF2						;3
	ldx		room_num				  ;3
	lda		Lfaac,x					;4
	sta		PF0						;3
	iny								;2
	sta		WSYNC					;3	 =	29
;---------------------------------------
	sta		HMOVE					;3
	sty		VBLANK					;3
	sty		scan_Line				   ;3
	cpx		#$04					;2
	bne		Lf865					;2/3
	dey								;2	 =	15 *
Lf865
	sty		ENABL					;3
	cpx		#$0d					;2
	beq		Lf874					;2/3
	bit		ram_9D					;3		   *
	bmi		Lf874					;2/3	   *
	ldy		SWCHA					;4		   *
	sty		REFP1					;3	 =	19 *
Lf874
	sta		WSYNC					;3	 =	 3
;---------------------------------------
	sta		HMOVE					;3
	sta		WSYNC					;3	 =	 6
;---------------------------------------
	sta		HMOVE					;3
	ldy		room_num				  ;3
	sta		WSYNC					;3	 =	 9
;---------------------------------------
	sta		HMOVE					;3
	lda		Lfa91,y					;4
	sta		PF1						;3
	lda		Lfa9e,y					;4
	sta		PF2						;3
	ldx		Lf9ee,y					;4
	lda		Lfae2+1,x				;4
	pha								;3
	lda		Lfae2,x					;4
	pha								;3
	lda		#$00					;2
	tax								;2
	sta		ram_84					;3
	rts								;6	 =	48


	.byte	$bd,$75,$fc,$4a,$a8,$b9,$e2,$fc ; $f89d (*)
	.byte	$b0,$06,$25,$c6,$f0,$01,$38,$60 ; $f8a5 (*)
	.byte	$25,$c7,$d0,$fb,$18,$60			; $f8ad (*)

Lf8b3
	cpy		#$01					;2		   *
	bne		Lf8bb					;2/3	   *
	lda		indy_y					;3		   *
	bmi		Lf8cc					;2/3 =	 9 *
Lf8bb
	lda		enemy_y,x				 ;4			*
	cmp.wy	enemy_y,y				 ;4			*
	bne		Lf8c6					;2/3	   *
	cpy		#$05					;2		   *
	bcs		Lf8ce					;2/3 =	14 *
Lf8c6
	bcs		Lf8cc					;2/3	   *
	inc		enemy_y,x				 ;6			*
	bne		Lf8ce					;2/3 =	10 *
Lf8cc
	dec		enemy_y,x				 ;6	  =	  6 *
Lf8ce
	lda		enemy_x,x				 ;4			*
	cmp.wy	enemy_x,y				 ;4			*
	bne		Lf8d9					;2/3	   *
	cpy		#$05					;2		   *
	bcs		Lf8dd					;2/3 =	14 *
Lf8d9
	bcs		Lf8de					;2/3	   *
	inc		enemy_x,x				 ;6	  =	  8 *
Lf8dd
	rts								;6	 =	 6 *

Lf8de
	dec		enemy_x,x				 ;6			*
	rts								;6	 =	12 *

Lf8e1
	lda		enemy_y,x				 ;4			*
	cmp		#$53					;2		   *
	bcc		Lf8f1					;2/3 =	 8 *
Lf8e7
	roL		ram_8C,x				;6		   *
	clc								;2		   *
	ror		ram_8C,x				;6		   *
	lda		#$78					;2		   *
	sta		enemy_y,x				 ;4			*
	rts								;6	 =	26 *

Lf8f1
	lda		enemy_x,x				 ;4			*
	cmp		#$10					;2		   *
	bcc		Lf8e7					;2/3	   *
	cmp		#$8e					;2		   *
	bcs		Lf8e7					;2/3	   *
	rts								;6	 =	18 *

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

Lfae2:
	   .word Lf0b5-1 ; $fae2/3
	   .word Lf003-1 ; $fae4/5
	   .word Lf140-1 ; $fae6/7
	   .word Lf4a6-1 ; $fae8/9

Lfaea: ;tarantuLa animation tabLe
	   .byte <spider_frame_1_gfx ; $faea
	   .byte <spider_frame_2_gfx ; $faeb
	   .byte <spider_frame_3_gfx ; $faec
	   .byte <spider_frame_4_gfx ; $faed
Lfaee
	.byte	$1b,$18,$17,$17,$18,$18,$1b,$1b ; $faee (*)
	.byte	$1d,$18,$17,$12,$18,$17,$1b,$1d ; $faf6 (*)
	.byte	$00,$00							; $fafe (*)


;Inventory gfx...
blank_gfx ; Blank space
	.byte	$00 ; |		   |			$fb00 (G)
	.byte	$00 ; |		   |			$fb01 (G)
	.byte	$00 ; |		   |			$fb02 (G)
	.byte	$00 ; |		   |			$fb03 (G)
	.byte	$00 ; |		   |			$fb04 (G)
	.byte	$00 ; |		   |			$fb05 (G)
	.byte	$00 ; |		   |			$fb06 (G)
	.byte	$00 ; |		   |			$fb07 (G)

copyright_gfx_3: ;copyright3
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

Lfb20: ;bag of gold
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

copyright_gfx_2: ;copyright2
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

copyright_gfx_1: ;copyright1
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

Lfb78: ; unopen pocket watch
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

Lfb98: ;timepiece bitmaps...
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

copyright_gfx_4: ;copyright4
	.byte	$49 ; | #  #  #|			$fbd8 (G)
	.byte	$49 ; | #  #  #|			$fbd9 (G)
	.byte	$49 ; | #  #  #|			$fbda (G)
	.byte	$C9 ; |##  #  #|			$fbdb (G)
	.byte	$49 ; | #  #  #|			$fbdc (G)
	.byte	$49 ; | #  #  #|			$fbdd (G)
	.byte	$BE ; |# ##### |			$fbde (G)
	.byte	$00 ; |		   |			$fbdf (G)

copyright_gfx_5: ;copyright5
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


spider_frame_1_gfx
	.byte	$54 ; | # # #  |			$fcae (G)
	.byte	$FC ; |######  |			$fcaf (G)
	.byte	$5F ; | # #####|			$fcb0 (G)
	.byte	$FE ; |####### |			$fcb1 (G)
	.byte	$7F ; | #######|			$fcb2 (G)
	.byte	$FA ; |##### # |			$fcb3 (G)
	.byte	$3F ; |	 ######|			$fcb4 (G)
	.byte	$2A ; |	 # # # |			$fcb5 (G)
	.byte	$00 ; |		   |			$fcb6 (G)

spider_frame_3_gfx
	.byte	$54 ; | # # #  |			$fcb7 (G)
	.byte	$5F ; | # #####|			$fcb8 (G)
	.byte	$FC ; |######  |			$fcb9 (G)
	.byte	$7F ; | #######|			$fcba (G)
	.byte	$FE ; |####### |			$fcbb (G)
	.byte	$3F ; |	 ######|			$fcbc (G)
	.byte	$FA ; |##### # |			$fcbd (G)
	.byte	$2A ; |	 # # # |			$fcbe (G)
	.byte	$00 ; |		   |			$fcbf (G)

spider_frame_2_gfx
	.byte	$2A ; |	 # # # |			$fcc0 (G)
	.byte	$FA ; |##### # |			$fcc1 (G)
	.byte	$3F ; |	 ######|			$fcc2 (G)
	.byte	$FE ; |####### |			$fcc3 (G)
	.byte	$7F ; | #######|			$fcc4 (G)
	.byte	$FA ; |##### # |			$fcc5 (G)
	.byte	$5F ; | # #####|			$fcc6 (G)
	.byte	$54 ; | # # #  |			$fcc7 (G)
	.byte	$00 ; |		   |			$fcc8 (G)

spider_frame_4_gfx
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

Lfcea
	ror								;2		   *
	bcs		Lfcef					;2/3	   *
	dec		enemy_y,x				 ;6	  =	 10 *
Lfcef
	ror								;2		   *
	bcs		Lfcf4					;2/3	   *
	inc		enemy_y,x				 ;6	  =	 10 *
Lfcf4
	ror								;2		   *
	bcs		Lfcf9					;2/3	   *
	dec		enemy_x,x				 ;6	  =	 10 *
Lfcf9
	ror								;2		   *
	bcs		Lfcfe					;2/3	   *
	inc		enemy_x,x				 ;6	  =	 10 *
Lfcfe
	rts								;6	 =	 6 *

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

Lfef4
	lda		ram_8C,x				;4
	bmi		Lfef9					;2/3
	rts								;6	 =	12

Lfef9
	jsr		Lfcea					;6		   *
	jsr		Lf8e1					;6		   *
	rts								;6	 =	18 *



    .byte $80 ; |X       | $FF00

dev_name_2_gfx ;programmer's initials #2
    .byte $00 ; |        | $FF01
    .byte $07 ; |     XXX| $FF02
    .byte $04 ; |     X  | $FF03
    .byte $77 ; | XXX XXX| $FF04
    .byte $71 ; | XXX   X| $FF05
    .byte $75 ; | XXX X X| $FF06
    .byte $57 ; | X X XXX| $FF07
    .byte $50 ; | X X    | $FF08



	.byte	$00,$d6,$1c,$36,$1c,$49,$7f ; $ff09 (*)
	.byte	$49,$1c,$3e,$00,$b9,$8a,$a1,$81 ; $ff10 (*)
	.byte	$00,$00,$00,$00,$00,$00,$1c,$70 ; $ff18 (*)
	.byte	$07,$70,$0e,$00,$cf,$a6,$00,$81 ; $ff20 (*)
	.byte	$77,$36,$14,$22,$ae,$14,$36,$77 ; $ff28 (*)
	.byte	$00,$bf,$ce,$00,$ef,$81,$00,$00 ; $ff30 (*)
	.byte	$00,$00,$00,$00,$68,$2f,$0a,$0c ; $ff38 (*)
	.byte	$08,$00,$80,$81,$00,$00
	
	
dev_name_1_gfx
	.byte $07 ; |     XXX| $FF46
    .byte $01 ; |       X| $FF47
    .byte $57 ; | X X XXX| $FF48
    .byte $54 ; | X X X  | $FF49
    .byte $77 ; | XXX XXX| $FF4A
    .byte $50 ; | X X    | $FF4B
    .byte $50 ; | X X    | $FF4C

	
	

	.byte	$00,$00,$00 ; $ff4D (*)
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
