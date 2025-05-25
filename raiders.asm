; disassembly of ~\projects\programming\reversing\6502\raiders\raiders.bin
; disassembled 07/02/23 15:14:09
; using stella 6.7
;
; rom properties name : raiders of the lost ark (1982) (atari)
; rom properties md5  : f724d3dd2471ed4cf5f191dbb724b69f
; bankswitch type	  : f8* (8k)
;
; legend: *	 = code not yet run (tentative code)
;		  d	 = data directive (referenced in some way)
;		  g	 = gfx directive, shown as '#' (stored in player, missile, ball)
;		  p	 = pgfx directive, shown as '*' (stored in playfield)
;		  c	 = col directive, shown as color constants (stored in player color)
;		  cp = pcol directive, shown as color constants (stored in playfield color)
;		  cb = bcol directive, shown as color constants (stored in background color)
;		  a	 = aud directive (stored in audio registers)
;		  i	 = indexed accessed only
;		  c	 = used by code executed in ram
;		  s	 = used by stack
;		  !	 = page crossed, 1 cycle penalty

	processor 6502


;-----------------------------------------------------------
;	   color constants
;-----------------------------------------------------------

;black			  = $00
;yellow			  = $10
;brown			  = $20
;orange			  = $30
;red			  = $40
;mauve			  = $50
;violet			  = $60
;purple			  = $70
;blue			  = $80
;blue_cyan		  = $90
;cyan			  = $a0
;cyan_green		  = $b0
;green			  = $c0
;green_yellow	  = $d0
;green_beige	  = $e0
;beige			  = $f0




;-----------------------------------------------------------
;	   tia and io constants accessed
;-----------------------------------------------------------

cxm0p			= $30  ; (r)
cxm1p			= $31  ; (r)
cxp1fb			= $33  ; (r)
cxm1fb			= $35  ; (r)
cxppmm			= $37  ; (r)
inpt4			= $0c  ; (r)
inpt5			= $0d  ; (r)

vsync			= $00  ; (w)
vblank			= $01  ; (w)
wsync			= $02  ; (w)
nusiz0			= $04  ; (w)
nusiz1			= $05  ; (w)
colup0			= $06  ; (w)
colup1			= $07  ; (w)
colupf			= $08  ; (w)
colubk			= $09  ; (w)
ctrlpf			= $0a  ; (w)
refp0			= $0b  ; (w)
refp1			= $0c  ; (w)
pf0				= $0d  ; (w)
pf1				= $0e  ; (w)
pf2				= $0f  ; (w)
resp0			= $10  ; (w)
resp1			= $11  ; (w)
;resm0			= $12  ; (wi)
;resm1			= $13  ; (wi)
resbl			= $14  ; (w)
audc0			= $15  ; (w)
;audc1			= $16  ; (wi)
audf0			= $17  ; (w)
;audf1			= $18  ; (wi)
audv0			= $19  ; (w)
;audv1			= $1a  ; (wi)
grp0			= $1b  ; (w)
grp1			= $1c  ; (w)
enam0			= $1d  ; (w)
enam1			= $1e  ; (w)
enabl			= $1f  ; (w)
hmp0			= $20  ; (w)
hmp1			= $21  ; (w)
;hmm0			= $22  ; (wi)
;hmm1			= $23  ; (wi)
hmbl			= $24  ; (w)
vdelp0			= $25  ; (w)
vdelp1			= $26  ; (w)
hmove			= $2a  ; (w)
hmclr			= $2b  ; (w)
cxclr			= $2c  ; (w)

swcha			= $0280
swchb			= $0282
intim			= $0284
tim64t			= $0296


;-----------------------------------------------------------
;	   riot ram (zero-page) labels
;-----------------------------------------------------------

zero_page		= $00
scan_line		= $80
room_num		= $81
frame_counter	= $82
time_of_day		= $83
ram_84			= $84; (c)
ram_85			= $85; (c)
ram_86			= $86; (c)
ram_87			= $87; (c)
ram_88			= $88; (c)
ram_89			= $89; (c)
ram_8a			= $8a
ram_8b			= $8b
ram_8c			= $8c
ram_8d			= $8d
ram_8e			= $8e
ram_8f			= $8f
ram_90			= $90
ram_91			= $91
indy_dir		= $92
ram_93			= $93
room_pf_cfg		= $94
ram_95			= $95
ram_96			= $96
ram_97			= $97
ram_98			= $98
ram_99			= $99
ram_9a			= $9a
ram_9b			= $9b
ram_9c			= $9c
ram_9d			= $9d
score			= $9e
lives_left		= $9f
num_bullets		= $a0
ram_a1			= $a1
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
thief_shot		= $ac
mesa_entered	= $ad
unknown_action	= $ae
ram_af			= $af

ram_b1			= $b1
ram_b2			= $b2

ram_b4			= $b4
ram_b5			= $b5
ram_b6			= $b6
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
current_object	= $c5
ram_c6			= $c6
ram_c7			= $c7
enemy_x			= $c8
indy_x			= $c9
ram_ca			= $ca
ram_cb			= $cb
ram_cc			= $cc

enemy_y			= $ce
indy_y			= $cf
ram_d0			= $d0
ram_d1			= $d1
ram_d2			= $d2

ram_d4			= $d4
ram_d5			= $d5
ram_d6			= $d6
ram_d7			= $d7
ram_d8			= $d8
indy_anim		= $d9
ram_da			= $da
indy_h			= $db
snake_y			= $dc
emy_anim		= $dd
ram_de			= $de
ram_df			= $df
ram_e0			= $e0
pf1_data		= $e1
ram_e2			= $e2
pf2_data		= $e3
ram_e4			= $e4
ram_e5			= $e5
ram_e6			= $e6
ram_e7			= $e7
ram_e8			= $e8
ram_e9			= $e9
ram_ea			= $ea
ram_eb			= $eb
ram_ec			= $ec
ram_ed			= $ed
ram_ee			= $ee
;				  $ef  (i)
;				  $f0  (i)
;				  $f1  (i)
;				  $f2  (i)

;				  $fc  (s)
;				  $fd  (s)
;				  $fe  (s)
;				  $ff  (s)




;--------------------
;objects
;---------------------
key_obj = $07

;--------------------
;rooms
;---------------------

treasure_room = $00
starting_room = $02
cliff_room = $05
spider_room = $07
mesa_top_room = $09
ark_room = $0d





;-----------------------------------------------------------
;	   user defined labels
;-----------------------------------------------------------

;break			 = $dd68


;***********************************************************
;	   bank 0 / 0..1
;***********************************************************

	seg		code
	org		$0000
	rorg	$d000

;note: 1st bank's vector points right at the cold start routine
	lda	   $fff8					;trigger 1st bank

cold_start
	jmp		game_start				;cold start

ld006
	ldx		#$04					;2	 =	 2
ld008
	sta		wsync					;3	 =	 3
;---------------------------------------
	lda		enemy_x,x				 ;4
	tay								;2
	lda		room_miss0_size_tabl,y					;4
	sta		hmp0,x					;4
	and		#$0f					;2
	tay								;2	 =	18
ld015
	dey								;2
	bpl		ld015					;2/3
	sta		resp0,x					;4
	dex								;2
	bpl		ld008					;2/3
	sta		wsync					;3	 =	15
;---------------------------------------
	sta		hmove					;3
	jmp		ldf9c					;3	 =	 6

ld024:
	   bit	  cxm1p					  ;3
	   bpl	  ld05c					  ;2
	   ldx	  $81					  ;3
	   cpx	  #$0a					  ;2
	   bcc	  ld05c					  ;2
	   beq	  ld03f					  ;2
	   lda	  $d1					  ;3
	   adc	  #$01					  ;2
	   lsr							  ;2
	   lsr							  ;2
	   lsr							  ;2
	   lsr							  ;2
	   tax							  ;2
	   lda	  #$08					  ;2
	   eor	  $df,x					  ;4
	   sta	  $df,x					  ;4
ld03f:
	   lda	  $8f					  ;3
	   bpl	  ld054					  ;2
	   and	  #$7f					  ;2
	   sta	  $8f					  ;3
	   lda	  $95					  ;3
	   and	  #$1f					  ;2
	   beq	  ld050					  ;2
	   jsr	  ldce9					  ;6
ld050:
	   lda	  #$40					  ;2
	   sta	  $95					  ;3
ld054:
	   lda	  #$7f					  ;2
	   sta	  $d1					  ;3
	   lda	  #$04					  ;2
	   sta	  thief_shot			  ;3 4 points (lost)
ld05c:
	   bit	  cxm1fb				  ;3
	   bpl	  ld0aa					  ;2
	   ldx	  $81					  ;3
	   cpx	  #$09					  ;2
	   beq	  ld0bc					  ;2
	   cpx	  #$06					  ;2
	   beq	  ld06e					  ;2
	   cpx	  #$08					  ;2
	   bne	  ld0aa					  ;2
ld06e:
	   lda	  $d1					  ;3
	   sbc	  $d4					  ;3
	   lsr							  ;2
	   lsr							  ;2
	   beq	  ld087					  ;2
	   tax							  ;2
	   ldy	  $cb					  ;3
	   cpy	  #$12					  ;2
	   bcc	  ld0a4					  ;2
	   cpy	  #$8d					  ;2
	   bcs	  ld0a4					  ;2
	   lda	  #$00					  ;2
	   sta	  $e5,x					  ;4
	   beq	  ld0a4					  ;2 always branch

ld087:
	   lda	  $cb					  ;3
	   cmp	  #$30					  ;2
	   bcs	  ld09e					  ;2
	   sbc	  #$10					  ;2
	   eor	  #$1f					  ;2
ld091:
	   lsr							  ;2
	   lsr							  ;2
	   tax							  ;2
	   lda	  ldc5c,x				  ;4
	   and	  $e5					  ;3
	   sta	  $e5					  ;3
	   jmp	  ld0a4					  ;3

ld09e:
	   sbc	  #$71					  ;2
	   cmp	  #$20					  ;2
	   bcc	  ld091					  ;2
ld0a4:
	   ldy	  #$7f					  ;2
	   sty	  $8f					  ;3
	   sty	  $d1					  ;3
ld0aa:
	   bit	  cxm1fb				  ;3
	   bvc	  ld0bc					  ;2
	   bit	  $93					  ;3
	   bvc	  ld0bc					  ;2
	   lda	  #$5a					  ;2
	   sta	  $d2					  ;3
	   sta	  $dc					  ;3
	   sta	  $8f					  ;3
	   sta	  $d1					  ;3
ld0bc:
	   bit	  cxp1fb				  ;3
	   bvc	  ld0ed					  ;2
	   ldx	  $81					  ;3
	   cpx	  #$06					  ;2
	   beq	  ld0e2					  ;2
	   lda	  current_object		  ;3
	   cmp	  #$02					  ;2 is object the flute?
	   beq	  ld0ed					  ;2  ...branch if so
	   bit	  $93					  ;3
	   bpl	  ld0da					  ;2
	   lda	  $83					  ;3
	   and	  #$07					  ;2
	   ora	  #$80					  ;2
	   sta	  $a1					  ;3
	   bne	  ld0ed					  ;2 always branch

ld0da:
	   bvc	  ld0ed					  ;2
	   lda	  #$80					  ;2
	   sta	  $9d					  ;3
	   bne	  ld0ed					  ;2 always branch

ld0e2:
	   lda	  $d6					  ;3
	   cmp	  #$ba					  ;2
	   bne	  ld0ed					  ;2
	   lda	  #$0f					  ;2
	   jsr	  ldce9					  ;6
ld0ed:
	   ldx	  #$05					  ;2
	   cpx	  $81					  ;3
	   bne	  ld12d					  ;2
	   bit	  cxm0p					  ;3
	   bpl	  ld106					  ;2
	   stx	  $cf					  ;3
	   lda	  #$0c					  ;2
	   sta	  $81					  ;3
	   jsr	  ld878					  ;6
	   lda	  #$4c					  ;2
	   sta	  $c9					  ;3
	   bne	  ld12b					  ;2 always branch

ld106:
	   ldx	  $cf					  ;3
	   cpx	  #$4f					  ;2
	   bcc	  ld12d					  ;2
	   lda	  #$0a					  ;2
	   sta	  $81					  ;3
	   jsr	  ld878					  ;6
	   lda	  $eb					  ;3
	   sta	  $df					  ;3
	   lda	  $ec					  ;3
	   sta	  $cf					  ;3
	   lda	  $ed					  ;3
	   sta	  $c9					  ;3
	   lda	  #$fd					  ;2
	   and	  $b4					  ;3
	   sta	  $b4					  ;3
	   bmi	  ld12b					  ;2
	   lda	  #$80					  ;2
	   sta	  $9d					  ;3
ld12b:
	   sta	  cxclr					  ;3
ld12d:
	   bit	  cxppmm				  ;3
	   bmi	  ld140					  ;2
	   ldx	  #$00					  ;2
	   stx	  $91					  ;3
	   dex							  ;2
	   stx	  $97					  ;3
	   rol	  $95					  ;5
	   clc							  ;2
	   ror	  $95					  ;5
ld13d:
	   jmp	  ld2b4					  ;3

ld140:
	   lda	  $81					  ;3
	   bne	  ld157					  ;2
	   lda	  $af					  ;3
	   and	  #$07					  ;2
	   tax							  ;2
	   lda	  ldf78,x				  ;4
	   jsr	  ldce9					  ;6
	   bcc	  ld13d					  ;2
	   lda	  #$01					  ;2
	   sta	  $df					  ;3
	   bne	  ld13d					  ;2 always branch

ld157:
	   asl							  ;2
	   tax							  ;2
	   lda	  ldc9b+1,x				  ;4
	   pha							  ;3
	   lda	  ldc9b,x				  ;4
	   pha							  ;3
	   rts							  ;6

ld162:
	   lda	  $cf					  ;3
	   cmp	  #$3f					  ;2
	   bcc	  ld18a					  ;2
	   lda	  $96					  ;3
	   cmp	  #$54					  ;2
	   bne	  ld1c1					  ;2
	   lda	  $8c					  ;3
	   cmp	  $8b					  ;3
	   bne	  ld187					  ;2
	   lda	  #$58					  ;2 lfa58 too?
	   sta	  $9c					  ;3
	   sta	  $9e					  ;3 game over...start with ped. height = #$88
	   jsr	  tally_score					  ;6 ...and tally the variables
	   lda	  #$0d					  ;2
	   sta	  $81					  ;3
	   jsr	  ld878					  ;6
	   jmp	  ld3d8					  ;3

ld187:
	   jmp	  ld2da					  ;3

ld18a:
	   lda	  #$0b					  ;2
	   bne	  ld194					  ;2 always branch

ld18e:
	   lda	  #$07					  ;2
	   bne	  ld194					  ;2 always branch

ld192:
	   lda	  #$04					  ;2
ld194:
	   bit	  $95					  ;3
	   bmi	  ld1c1					  ;2
	   clc							  ;2
	   jsr	  lda10					  ;6
	   bcs	  ld1a4					  ;2
	   sec							  ;2
	   jsr	  lda10					  ;6
	   bcc	  ld1c1					  ;2
ld1a4:
	   cpy	  #$0b					  ;2
	   bne	  ld1ad					  ;2
	   ror	  $b2					  ;5
	   clc							  ;2
	   rol	  $b2					  ;5
ld1ad:
	   lda	  $95					  ;3
	   jsr	  ldd59					 ;6
	   tya							  ;2
	   ora	  #$c0					  ;2
	   sta	  $95					  ;3
	   bne	  ld1c1					  ;2 always branch

ld1b9:
	   ldx	  #$00					  ;2
	   stx	  $b6					  ;3
	   lda	  #$80					  ;2
	   sta	  $9d					  ;3
ld1c1:
	   jmp	  ld2b4					  ;3

ld1c4:
	   bit	  $b4					  ;3
	   bvs	  ld1e8					  ;2
	   bpl	  ld1e8					  ;2
	   lda	  $c9					  ;3
	   cmp	  #$2b					  ;2
	   bcc	  ld1e2					  ;2
	   ldx	  $cf					  ;3
	   cpx	  #$27					  ;2
	   bcc	  ld1e2					  ;2
	   cpx	  #$2b					  ;2
	   bcs	  ld1e2					  ;2
	   lda	  #$40					  ;2
	   ora	  $b4					  ;3
	   sta	  $b4					  ;3
	   bne	  ld1e8					  ;2
ld1e2:
	   lda	  #$03					  ;2
	   sec							  ;2
	   jsr	  lda10					  ;6
ld1e8:
	   jmp	  ld2b4					  ;3

ld1eb:
	   bit	  cxp1fb				  ;3
	   bpl	  ld21a					  ;2
	   ldy	  $cf					  ;3
	   cpy	  #$3a					  ;2
	   bcc	  ld200					  ;2
	   lda	  #$e0					  ;2
	   and	  $91					  ;3
	   ora	  #$43					  ;2
	   sta	  $91					  ;3
	   jmp	  ld2b4					  ;3

ld200:
	   cpy	  #$20					  ;2
	   bcc	  ld20b					  ;2
ld204:
	   lda	  #$00					  ;2
	   sta	  $91					  ;3
	   jmp	  ld2b4					  ;3

ld20b:
	   cpy	  #$09					  ;2
	   bcc	  ld204					  ;2
	   lda	  #$e0					  ;2
	   and	  $91					  ;3
	   ora	  #$42					  ;2
	   sta	  $91					  ;3
	   jmp	  ld2b4					  ;3

ld21a:
	   lda	  $cf					  ;3
	   cmp	  #$3a					  ;2
	   bcc	  ld224					  ;2
	   ldx	  #$07					  ;2
	   bne	  ld230					  ;2 always branch

ld224:
	   lda	  $c9					  ;3
	   cmp	  #$4c					  ;2
	   bcs	  ld22e					  ;2
	   ldx	  #$05					  ;2
	   bne	  ld230					  ;2 always branch

ld22e:
	   ldx	  #$0d					  ;2
ld230:
	   lda	  #$40					  ;2
	   sta	  $93					  ;3
	   lda	  $83					  ;3
	   and	  #$1f					  ;2
	   cmp	  #$02					  ;2
	   bcs	  ld23e					  ;2
	   ldx	  #$0e					  ;2
ld23e:
	   jsr	  ldd43					  ;6
	   bcs	  ld247					  ;2
	   txa							  ;2
	   jsr	  ldce9					  ;6
ld247:
	   jmp	  ld2b4					  ;3

ld24a:
	   bit	  cxp1fb				  ;3
	   bmi	  ld26e					  ;2
	   lda	  $c9					  ;3
	   cmp	  #$50					  ;2
	   bcs	  ld262					  ;2
	   dec	  $c9					  ;5
	   rol	  $b2					  ;5
	   clc							  ;2
	   ror	  $b2					  ;5
ld25b:
	   lda	  #$00					  ;2
	   sta	  $91					  ;3
ld25f:
	   jmp	  ld2b4					  ;3

ld262:
	   ldx	  #$06					  ;2
	   lda	  $83					  ;3
	   cmp	  #$40					  ;2
	   bcs	  ld23e					  ;2
	   ldx	  #$07					  ;2
	   bne	  ld23e					  ;2 always branch

ld26e:
	   ldy	  $cf					  ;3
	   cpy	  #$44					  ;2
	   bcc	  ld27e					  ;2
	   lda	  #$e0					  ;2
	   and	  $91					  ;3
	   ora	  #$0b					  ;2
ld27a:
	   sta	  $91					  ;3
	   bne	  ld25f					  ;2
ld27e:
	   cpy	  #$20					  ;2
	   bcs	  ld25b					  ;2
	   cpy	  #$0b					  ;2
	   bcc	  ld25b					  ;2
	   lda	  #$e0					  ;2
	   and	  $91					  ;3
	   ora	  #$41					  ;2
	   bne	  ld27a					  ;2 always branch

ld28e:
	   inc	  $c9					  ;5
	   bne	  ld2b4					  ;2 always branch

ld292:
	   lda	  $cf					  ;3
	   cmp	  #$3f					  ;2
	   bcc	  ld2aa					  ;2
	   lda	  #$0a					  ;2
	   jsr	  ldce9					  ;6
	   bcc	  ld2b4					  ;2
	   ror	  $b1					  ;5
	   sec							  ;2
	   rol	  $b1					  ;5
	   lda	  #$42					  ;2
	   sta	  $df					  ;3
	   bne	  ld2b4					  ;2 always branch

ld2aa:
	   cmp	  #$16					  ;2
	   bcc	  ld2b2					  ;2
	   cmp	  #$1f					  ;2
	   bcc	  ld2b4					  ;2
ld2b2:
	   dec	  $c9					  ;5
ld2b4:
	   lda	  $81					  ;3
	   asl							  ;2
	   tax							  ;2
	   bit	  cxp1fb				  ;3
	   bpl	  ld2c5					  ;2
	   lda	  ldcb5+1,x				  ;4
	   pha							  ;3
	   lda	  ldcb5,x				  ;4
	   pha							  ;3
	   rts							  ;6

ld2c5:
	   lda	  ldccf+1,x				  ;4
	   pha							  ;3
	   lda	  ldccf,x				  ;4
	   pha							  ;3
	   rts							  ;6

ld2ce
	lda		ram_df					;3		   *
	sta		ram_eb					;3		   *
	lda		indy_y					;3		   *
	sta		ram_ec					;3		   *
	lda		indy_x					;3		   *
ld2d8
	sta		ram_ed					;3		   *
ld2da
	lda		#cliff_room					;2		   *
	sta		room_num				  ;3		 *
	jsr		ld878					;6		   *
	lda		#$05					;2		   *
	sta		indy_y					;3		   *
	lda		#$50					;2		   *
	sta		indy_x					;3		   *
	tsx								;2		   *
	cpx		#$fe					;2		   *
	bcs		ld2ef					;2/3	   *
	rts								;6	 =	51 *

ld2ef
	jmp		ld374					;3	 =	 3 *



ld2f2:
	   bit	  $b3					  ;3
	   bmi	  ld2ef					  ;2
	   lda	  #$50					  ;2
	   sta	  $eb					  ;3
	   lda	  #$41					  ;2
	   sta	  $ec					  ;3
	   lda	  #$4c					  ;2
	   bne	  ld2d8					  ;2 always branch

ld302:
	   ldy	  $c9					  ;3
	   cpy	  #$2c					  ;2
	   bcc	  ld31a					  ;2
	   cpy	  #$6b					  ;2
	   bcs	  ld31c					  ;2
	   ldy	  $cf					  ;3
	   iny							  ;2
	   cpy	  #$1e					  ;2
	   bcc	  ld315					  ;2
	   dey							  ;2
	   dey							  ;2
ld315:
	   sty	  $cf					  ;3
	   jmp	  ld364					  ;3

ld31a:
	   iny							  ;2
	   iny							  ;2
ld31c:
	   dey							  ;2
	   sty	  $c9					  ;3
	   bne	  ld364					  ;2 always branch

ld321:
	   lda	  #$02					  ;2
	   and	  $b1					  ;3
	   beq	  ld331					  ;2
	   lda	  $cf					  ;3
	   cmp	  #$12					  ;2
	   bcc	  ld331					  ;2
	   cmp	  #$24					  ;2
	   bcc	  ld36a					  ;2
ld331:
	   dec	  $c9					  ;5
	   bne	  ld364					  ;2 always branch

ld335:
	   ldx	  #$1a					  ;2
	   lda	  $c9					  ;3
	   cmp	  #$4c					  ;2
	   bcc	  ld33f					  ;2
	   ldx	  #$7d					  ;2
ld33f:
	   stx	  $c9					  ;3
	   ldx	  #$40					  ;2
	   stx	  $cf					  ;3
	   ldx	  #$ff					  ;2
	   stx	  $e5					  ;3
	   ldx	  #$01					  ;2
	   stx	  $e6					  ;3
	   stx	  $e7					  ;3
	   stx	  $e8					  ;3
	   stx	  $e9					  ;3
	   stx	  $ea					  ;3
	   bne	  ld364					  ;2 always branch

ld357:
	   lda	  $92					  ;3
	   and	  #$0f					  ;2
	   tay							  ;2
	   lda	  ldfd5,y				  ;4
	   ldx	  #$01					  ;2
	   jsr	  move_enemy				  ;6
ld364:
	   lda	  #$05					  ;2
	   sta	  $a2					  ;3
	   bne	  ld374					  ;2 always branch

ld36a:
	   rol	  $8a					  ;5
	   sec							  ;2
	   bcs	  ld372					  ;2 always branch

ld36f:
	   rol	  $8a					  ;5
	   clc							  ;2
ld372:
	   ror	  $8a					  ;5

ld374
	bit		cxm0p|$30				;3		   *
	bpl		ld396					;2/3	   *
	ldx		room_num				  ;3		 *
	cpx		#spider_room					;2		   *
	beq		ld386					;2/3	   *
	bcc		ld396					;2/3	   *
	lda		#$80					;2		   *
	sta		ram_9d					;3		   *
	bne		ld390					;2/3 =	21 *
ld386
	rol		ram_8a					;5		   *
	sec								;2		   *
	ror		ram_8a					;5		   *
	rol		ram_b6					;5		   *
	sec								;2		   *
	ror		ram_b6					;5	 =	24 *
ld390
	lda		#$7f					;2		   *
	sta		ram_8e					;3		   *
	sta		ram_d0					;3	 =	 8 *
ld396
	bit		ram_9a					;3		   *
	bpl		ld3d8					;2/3	   *
	bvs		ld3a8					;2/3	   *
	lda		time_of_day					 ;3			*
	cmp		ram_9b					;3		   *
	bne		ld3d8					;2/3	   *
	lda		#$a0					;2		   *
	sta		ram_d1					;3		   *
	sta		ram_9d					;3	 =	23 *
ld3a8
	lsr		ram_9a					;5		   *
	bcc		ld3d4					;2/3	   *
	lda		#$02					;2		   *
	sta		grenade_used				  ;3		 *
	ora		ram_b1					;3		   *
	sta		ram_b1					;3		   *
	ldx		#starting_room					;2		   *
	cpx		room_num				  ;3		 *
	bne		ld3bd					;2/3	   *
	jsr		ld878					;6	 =	31 *
ld3bd
	lda		ram_b5					;3		   *
	and		#$0f					;2		   *
	beq		ld3d4					;2/3	   *
	lda		ram_b5					;3		   *
	and		#$f0					;2		   *
	ora		#$01					;2		   *
	sta		ram_b5					;3		   *
	ldx		#starting_room					;2		   *
	cpx		room_num				  ;3		 *
	bne		ld3d4					;2/3	   *
	jsr		ld878					;6	 =	30 *
ld3d4
	sec								;2		   *
	jsr		lda10					;6	 =	 8 *
ld3d8
	lda		intim					;4
	bne		ld3d8					;2/3 =	 6
ld3dd
	lda		#$02					;2
	sta		wsync					;3	 =	 5
;---------------------------------------
	sta		vsync					;3
	lda		#$50					;2
	cmp		ram_d1					;3
	bcs		ld3eb					;2/3
	sta		ram_cb					;3	 =	13 *
ld3eb
	inc		frame_counter			;up the frame counter by 1
	lda		#$3f					;
	and		frame_counter			;every 63 frames (?)
	bne		ld3fb					;
	inc		time_of_day				;increse the time of day
	lda		ram_a1					;3
	bpl		ld3fb					;2/3
	dec		ram_a1					;5	 =	27 *
ld3fb
	sta		wsync					;3	 =	 3
;---------------------------------------
	bit		ram_9c					;3
	bpl		frame_start					  ;2/3
	ror		swchb					;6		   *
	bcs		frame_start					  ;2/3		 *
	jmp		game_start					 ;3	  =	 16 *

frame_start
	sta		wsync					;wait for first sync
;---------------------------------------
	lda		#$00					;load a for vsync pause
	ldx		#$2c					;load timer for
	sta		wsync					;3	 =	 7
;---------------------------------------
	sta		vsync					;3
	stx		tim64t					;4
	ldx		ram_9d					;3
	inx								;2
	bne		ld42a					;2/3
	stx		ram_9d					;3		   *
	jsr		tally_score				; set score to minimum
	lda		#ark_room				; set ark title screen 
	sta		room_num				; to the current room
	jsr		ld878					;6	 =	34 *
ld427
	jmp		ld80d					;3	 =	 3

ld42a
	lda		room_num				; get teh room number
	cmp		#ark_room				; are we in the ark room? 
	bne		ld482					;2/3
	lda		#$9c					;2
	sta		ram_a3					;3
	ldy		yar_found				; check if yar was found
	beq		ld44a					; if not hold for button(?)
	bit		ram_9c					;3		   *
	bmi		ld44a					;2/3	   *
	ldx		#>dev_name_1_gfx		; get programmer 1 initials...
	stx		inv_slot_hi				; put in slot 1
	stx		inv_slot2_hi			
	lda		#<dev_name_1_gfx		
	sta		inv_slot_lo				
	lda		#<dev_name_2_gfx		; get programmer 2 initials...
	sta		inv_slot2_lo			; put in slot 2
ld44a
	ldy		indy_y					;3
	cpy		#$7c					;2
	bcs		ld465					;2/3
	cpy		score				   ;3
	bcc		ld45b					;2/3
	bit		inpt5|$30				;3		   *
	bmi		ld427					;2/3	   *
	jmp		game_start					 ;3	  =	 20 *

ld45b
	lda		frame_counter				   ;3
	ror								;2
	bcc		ld427					;2/3
	iny								;2
	sty		indy_y					;3
	bne		ld427					;2/3 =	14
ld465
	bit		ram_9c					;3		   *
	bmi		ld46d					;2/3	   *
	lda		#$0e					;2		   *
	sta		ram_a2					;3	 =	10 *
ld46d
	lda		#$80					;2		   *
	sta		ram_9c					;3		   *
	bit		inpt5|$30				;3		   *
	bmi		ld427					;2/3	   *
	lda		frame_counter				   ;3		  *
	and		#$0f					;2		   *
	bne		ld47d					;2/3	   *
	lda		#$05					;2	 =	19 *
ld47d
	sta		ram_8c					;3		   *
	jmp		reset_vars					 ;3	  =	  6 *

ld482
	bit		ram_93					;3		   *
	bvs		ld489					;2/3 =	 5 *
ld486
	jmp		ld51c					;3	 =	 3 *

ld489
	lda		frame_counter				   ;3		  *
	and		#$03					;2		   *
	bne		ld501					;2/3!	   *
	ldx		snake_y					 ;3			*
	cpx		#$60					;2		   *
	bcc		ld4a5					;2/3	   *
	bit		ram_9d					;3		   *
	bmi		ld486					;2/3	   *
	ldx		#$00					;2		   *
	lda		indy_x					;3		   *
	cmp		#$20					;2		   *
	bcs		ld4a3					;2/3	   *
	lda		#$20					;2	 =	30 *
ld4a3
	sta		ram_cc					;3	 =	 3 *
ld4a5
	inx								;2		   *
	stx		snake_y					 ;3			*
	txa								;2		   *
	sec								;2		   *
	sbc		#$07					;2		   *
	bpl		ld4b0					;2/3	   *
	lda		#$00					;2	 =	15 *
ld4b0
	sta		ram_d2					;3		   *
	and		#$f8					;2		   *
	cmp		ram_d5					;3		   *
	beq		ld501					;2/3!	   *
	sta		ram_d5					;3		   *
	lda		ram_d4					;3		   *
	and		#$03					;2		   *
	tax								;2		   *
	lda		ram_d4					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	tay								;2		   *
	lda		ldbff,x					;4		   *
	clc								;2		   *
	adc		ldbff,y					;4		   *
	clc								;2		   *
	adc		ram_cc					;3		   *
	ldx		#$00					;2		   *
	cmp		#$87					;2		   *
	bcs		ld4e2					;2/3	   *
	cmp		#$18					;2		   *
	bcc		ld4de					;2/3	   *
	sbc		indy_x					;3		   *
	sbc		#$03					;2		   *
	bpl		ld4e2					;2/3 =	61 *
ld4de
	inx								;2		   *
	inx								;2		   *
	eor		#$ff					;2	 =	 6 *
ld4e2
	cmp		#$09					;2		   *
	bcc		ld4e7					;2/3	   *
	inx								;2	 =	 6 *
ld4e7
	txa								;2		   *
	asl								;2		   *
	asl								;2		   *
	sta		ram_84					;3		   *
	lda		ram_d4					;3		   *
	and		#$03					;2		   *
	tax								;2		   *
	lda		ldbff,x					;4		   *
	clc								;2		   *
	adc		ram_cc					;3		   *
	sta		ram_cc					;3		   *
	lda		ram_d4					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	ora		ram_84					;3		   *
	sta		ram_d4					;3	 =	41 *
ld501
	lda		ram_d4					;3		   *
	and		#$03					;2		   *
	tax								;2		   *
	lda		ldbfb,x					;4		   *
	sta		ram_d6					;3		   *
	lda		#$fa					;2		   *
	sta		ram_d7					;3		   *
	lda		ram_d4					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	tax								;2		   *
	lda		ldbfb,x					;4		   *
	sec								;2		   *
	sbc		#$08					;2		   *
	sta		ram_d8					;3	 =	39 *
ld51c
	bit		ram_9d					;3		   *
	bpl		ld523					;2/3	   *
	jmp		ld802					;3	 =	 8 *

ld523
	bit		ram_a1					;3		   *
	bpl		ld52a					;2/3	   *
	jmp		ld78c					;3	 =	 8 *

ld52a
	lda		frame_counter				   ;3		  *
	ror								;2		   *
	bcc		ld532					;2/3	   *
	jmp		ld627					;3	 =	10 *

ld532
	ldx		room_num				  ;3		 *
	cpx		#cliff_room					;2		   *
	beq		ld579					;2/3	   *
	bit		ram_8d					;3		   *
	bvc		ld56e					;2/3	   *
	ldx		ram_cb					;3		   *
	txa								;2		   *
	sec								;2		   *
	sbc		indy_x					;3		   *
	tay								;2		   *
	lda		swcha					;4		   *
	ror								;2		   *
	bcc		ld55b					;2/3	   *
	ror								;2		   *
	bcs		ld579					;2/3	   *
	cpy		#$09					;2		   *
	bcc		ld579					;2/3	   *
	tya								;2		   *
	bpl		ld556					;2/3 =	44 *
ld553
	inx								;2		   *
	bne		ld557					;2/3 =	 4 *
ld556
	dex								;2	 =	 2 *
ld557
	stx		ram_cb					;3		   *
	bne		ld579					;2/3 =	 5 *
ld55b
	cpx		#$75					;2		   *
	bcs		ld579					;2/3	   *
	cpx		#$1a					;2		   *
	bcc		ld579					;2/3	   *
	dey								;2		   *
	dey								;2		   *
	cpy		#$07					;2		   *
	bcc		ld579					;2/3	   *
	tya								;2		   *
	bpl		ld553					;2/3	   *
	bmi		ld556					;2/3 =	22 *
ld56e
	bit		ram_b4					;3		   *
	bmi		ld579					;2/3	   *
	bit		ram_8a					;3		   *
	bpl		ld57c					;2/3	   *
	ror								;2		   *
	bcc		ld57c					;2/3 =	14 *
ld579
	jmp		ld5e0					;3	 =	 3 *

ld57c
	ldx		#$01					;2		   *
	lda		swcha					;4		   *
	sta		ram_85					;3		   *
	and		#$0f					;2		   *
	cmp		#$0f					;2		   *
	beq		ld579					;2/3	   *
	sta		indy_dir				  ;3		 *
	jsr		move_enemy					 ;6			*
	ldx		room_num				  ;3		 *
	ldy		#$00					;2		   *
	sty		ram_84					;3		   *
	beq		ld599					;2/3 =	34 *
ld596
	tax								;2		   *
	inc		ram_84					;5	 =	 7 *
ld599
	lda		indy_x					;3		   *
	pha								;3		   *
	lda		indy_y					;3		   *
	ldy		ram_84					;3		   *
	cpy		#$02					;2		   *
	bcs		ld5ac					;2/3	   *
	sta		ram_86					;3		   *
	pla								;4		   *
	sta		ram_87					;3		   *
	jmp		ld5b1					;3	 =	29 *

ld5ac
	sta		ram_87					;3		   *
	pla								;4		   *
	sta		ram_86					;3	 =	10 *
ld5b1
	ror		ram_85					;5		   *
	bcs		ld5d1					;2/3	   *
	jsr		ld97c					;6		   *
	bcs		ld5db					;2/3	   *
	bvc		ld5d1					;2/3	   *
	ldy		ram_84					;3		   *
	lda		ldf6c,y					;4		   *
	cpy		#$02					;2		   *
	bcs		ld5cc					;2/3	   *
	adc		indy_y					;3		   *
	sta		indy_y					;3		   *
	jmp		ld5d1					;3	 =	37 *

ld5cc
	clc								;2		   *
	adc		indy_x					;3		   *
	sta		indy_x					;3	 =	 8 *
ld5d1
	txa								;2		   *
	clc								;2		   *
	adc		#$0d					;2		   *
	cmp		#$34					;2		   *
	bcc		ld596					;2/3	   *
	bcs		ld5e0					;2/3 =	12 *
ld5db
	sty		room_num				  ;3		 *
	jsr		ld878					;6	 =	 9 *
ld5e0
	bit		inpt4|$30				;3		   *
	bmi		ld5f5					;2/3	   *
	bit		ram_9a					;3		   *
	bmi		ld624					;2/3!	   *
	lda		ram_8a					;3		   *
	ror								;2		   *
	bcs		ld5fa					;2/3	   *
	sec								;2		   *
	jsr		lda10					;6		   *
	inc		ram_8a					;5		   *
	bne		ld5fa					;2/3 =	32 *
ld5f5
	ror		ram_8a					;5		   *
	clc								;2		   *
	rol		ram_8a					;5	 =	12 *
ld5fa
	lda		ram_91					;3		   *
	bpl		ld624					;2/3!	   *
	and		#$1f					;2		   *
	cmp		#$01					;2		   *
	bne		ld60c					;2/3	   *
	inc		num_bullets					 ;5			*
	inc		num_bullets					 ;5			*
	inc		num_bullets					 ;5			*
	bne		ld620					;2/3 =	28 *
ld60c
	cmp		#$0b					;2		   *
	bne		ld61d					;2/3	   *
	ror		ram_b2					;5		   *
	sec								;2		   *
	rol		ram_b2					;5		   *
	ldx		#$45					;2		   *
	stx		ram_df					;3		   *
	ldx		#$7f					;2		   *
	stx		ram_d0					;3	 =	26 *
ld61d
	jsr		ldce9					;6	 =	 6 *
ld620
	lda		#$00					;2		   *
	sta		ram_91					;3	 =	 5 *
ld624
	jmp		ld777					;3	 =	 3 *

ld627
	bit		ram_9a					;3		   *
	bmi		ld624					;2/3	   *
	bit		inpt5|$30				;3		   *
	bpl		ld638					;2/3	   *
	lda		#$fd					;2		   *
	and		ram_8a					;3		   *
	sta		ram_8a					;3		   *
	jmp		ld777					;3	 =	21 *

ld638
	lda		#$02					;2		   *
	bit		ram_8a					;3		   *
	bne		ld696					;2/3	   *
	ora		ram_8a					;3		   *
	sta		ram_8a					;3		   *
	ldx		current_object					;3		   *
	cpx		#$05					;2		   *
	beq		ld64c					;2/3	   *
	cpx		#$06					;2		   *
	bne		ld671					;2/3 =	24 *
ld64c
	ldx		indy_y					;3		   *
	stx		ram_d1					;3		   *
	ldy		indy_x					;3		   *
	sty		ram_cb					;3		   *
	lda		time_of_day					 ;3			*
	adc		#$04					;2		   *
	sta		ram_9b					;3		   *
	lda		#$80					;2		   *
	cpx		#$35					;2		   *
	bcs		ld66c					;2/3	   *
	cpy		#$64					;2		   *
	bcc		ld66c					;2/3	   *
	ldx		room_num				  ;3		 *
	cpx		#starting_room					;2		   *
	bne		ld66c					;2/3	   *
	ora		#$01					;2	 =	39 *
ld66c
	sta		ram_9a					;3		   *
	jmp		ld777					;3	 =	 6 *

ld671
	cpx		#$03					;2		   *
	bne		ld68b					;2/3	   *
	stx		parachute_used					;3		   *
	lda		ram_b4					;3		   *
	bmi		ld696					;2/3	   *
	ora		#$80					;2		   *
	sta		ram_b4					;3		   *
	lda		indy_y					;3		   *
	sbc		#$06					;2		   *
	bpl		ld687					;2/3	   *
	lda		#$01					;2	 =	26 *
ld687
	sta		indy_y					;3		   *
	bpl		ld6d2					;2/3 =	 5 *
ld68b
	bit		ram_8d					;3		   *
	bvc		ld6d5					;2/3	   *
	bit		cxm1fb|$30				;3		   *
	bmi		ld699					;2/3	   *
	jsr		ld2ce					;6	 =	16 *
ld696
	jmp		ld777					;3	 =	 3 *

ld699
	lda		ram_d1					;3		   *
	lsr								;2		   *
	sec								;2		   *
	sbc		#$06					;2		   *
	clc								;2		   *
	adc		ram_df					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	cmp		#$08					;2		   *
	bcc		ld6ac					;2/3	   *
	lda		#$07					;2	 =	28 *
ld6ac
	sta		ram_84					;3		   *
	lda		ram_cb					;3		   *
	sec								;2		   *
	sbc		#$10					;2		   *
	and		#$60					;2		   *
	lsr								;2		   *
	lsr								;2		   *
	adc		ram_84					;3		   *
	tay								;2		   *
	lda		ldf7c,y					;4		   *
	sta		ram_8b					;3		   *
	ldx		ram_d1					;3		   *
	dex								;2		   *
	stx		ram_d1					;3		   *
	stx		indy_y					;3		   *
	ldx		ram_cb					;3		   *
	dex								;2		   *
	dex								;2		   *
	stx		ram_cb					;3		   *
	stx		indy_x					;3		   *
	lda		#$46					;2		   *
	sta		ram_8d					;3	 =	57 *
ld6d2
	jmp		ld773					;3	 =	 3 *

ld6d5
	cpx		#$0b					;2		   *
	bne		ld6f7					;2/3	   *
	lda		indy_y					;3		   *
	cmp		#$41					;2		   *
	bcc		ld696					;2/3	   *
	bit		cxppmm|$30				;3		   *
	bpl		ld696					;2/3	   *
	inc		ram_97					;5		   *
	bne		ld696					;2/3	   *
	ldy		ram_96					;3		   *
	dey								;2		   *
	cpy		#$54					;2		   *
	bcs		ld6ef					;2/3	   *
	iny								;2	 =	34 *
ld6ef
	sty		ram_96					;3		   *
	lda		#$0a					;2		   *
	sta		shovel_used					 ;3			*
	bne		ld696					;2/3 =	10 *
ld6f7
	cpx		#$10					;2		   *
	bne		ld71e					;2/3!	   *
	ldx		room_num				  ;3		 *
	cpx		#treasure_room					;2		   *
	beq		ld696					;2/3!	   *
	lda		#mesa_top_room					;2		   *
	sta		ankh_used				   ;3		  *
	sta		room_num				  ;3		 *
	jsr		ld878					;6		   *
	lda		#$4c					;2		   *
	sta		indy_x					;3		   *
	sta		ram_cb					;3		   *
	lda		#$46					;2		   *
	sta		indy_y					;3		   *
	sta		ram_d1					;3		   *
	sta		ram_8d					;3		   *
	lda		#$1d					;2		   *
	sta		ram_df					;3		   *
	bne		ld777					;2/3 =	51 *
ld71e
	lda		swcha					;4		   *
	and		#$0f					;2		   *
	cmp		#$0f					;2		   *
	beq		ld777					;2/3	   *
	cpx		#$0d					;2		   *
	bne		ld747					;2/3	   *
	bit		ram_8f					;3		   *
	bmi		ld777					;2/3	   *
	ldy		num_bullets					 ;3			*
	bmi		ld777					;2/3	   *
	dec		num_bullets					 ;5			*
	ora		#$80					;2		   *
	sta		ram_8f					;3		   *
	lda		indy_y					;3		   *
	adc		#$04					;2		   *
	sta		ram_d1					;3		   *
	lda		indy_x					;3		   *
	adc		#$04					;2		   *
	sta		ram_cb					;3		   *
	bne		ld773					;2/3 =	52 *
ld747
	cpx		#$0a					;2		   *
	bne		ld777					;2/3	   *
	ora		#$80					;2		   *
	sta		ram_8d					;3		   *
	ldy		#$04					;2		   *
	ldx		#$05					;2		   *
	ror								;2		   *
	bcs		ld758					;2/3	   *
	ldx		#$fa					;2	 =	19 *
ld758
	ror								;2		   *
	bcs		ld75d					;2/3	   *
	ldx		#$0f					;2	 =	 6 *
ld75d
	ror								;2		   *
	bcs		ld762					;2/3	   *
	ldy		#$f7					;2	 =	 6 *
ld762
	ror								;2		   *
	bcs		ld767					;2/3	   *
	ldy		#$10					;2	 =	 6 *
ld767
	tya								;2		   *
	clc								;2		   *
	adc		indy_x					;3		   *
	sta		ram_cb					;3		   *
	txa								;2		   *
	clc								;2		   *
	adc		indy_y					;3		   *
	sta		ram_d1					;3	 =	20 *
ld773
	lda		#$0f					;2		   *
	sta		ram_a3					;3	 =	 5 *
ld777
	bit		ram_b4					;3		   *
	bpl		ld783					;2/3	   *
	lda		#$63					;2		   *
	sta		indy_anim				   ;3		  *
	lda		#$0f					;2		   *
	bne		ld792					;2/3 =	14 *
ld783
	lda		swcha					;4		   *
	and		#$0f					;2		   *
	cmp		#$0f					;2		   *
	bne		ld796					;2/3 =	10 *
ld78c
	lda		#$58					;2	 =	 2 *
ld78e
	sta		indy_anim				   ;3		  *
	lda		#$0b					;2	 =	 5 *
ld792
	sta		indy_h					;3		   *
	bne		ld7b2					;2/3 =	 5 *
ld796
	lda		#$03					;2		   *
	bit		ram_8a					;3		   *
	bmi		ld79d					;2/3	   *
	lsr								;2	 =	 9 *
ld79d
	and		frame_counter				   ;3		  *
	bne		ld7b2					;2/3	   *
	lda		#$0b					;2		   *
	clc								;2		   *
	adc		indy_anim				   ;3		  *
	cmp		#$58					;2		   *
	bcc		ld78e					;2/3	   *
	lda		#$02					;2		   *
	sta		ram_a3					;3		   *
	lda		#$00					;2		   *
	bcs		ld78e					;2/3 =	25 *
ld7b2
	ldx		room_num				  ;3		 *
	cpx		#mesa_top_room					;2		   *
	beq		ld7bc					;2/3	   *
	cpx		#$0a					;2		   *
	bne		ld802					;2/3!=	11 *
ld7bc
	lda		frame_counter				   ;3		  *
	bit		ram_8a					;3		   *
	bpl		ld7c3					;2/3	   *
	lsr								;2	 =	10 *
ld7c3
	ldy		indy_y					;3		   *
	cpy		#$27					;2		   *
	beq		ld802					;2/3!	   *
	ldx		ram_df					;3		   *
	bcs		ld7e8					;2/3	   *
	beq		ld802					;2/3!	   *
	inc		indy_y					;5		   *
	inc		ram_d1					;5		   *
	and		#$02					;2		   *
	bne		ld802					;2/3!	   *
	dec		ram_df					;5		   *
	inc		enemy_y					 ;5			*
	inc		ram_d0					;5		   *
	inc		ram_d2					;5		   *
	inc		enemy_y					 ;5			*
	inc		ram_d0					;5		   *
	inc		ram_d2					;5		   *
	jmp		ld802					;3	 =	66 *

ld7e8
	cpx		#$50					;2		   *
	bcs		ld802					;2/3!	   *
	dec		indy_y					;5		   *
	dec		ram_d1					;5		   *
	and		#$02					;2		   *
	bne		ld802					;2/3!	   *
	inc		ram_df					;5		   *
	dec		enemy_y					 ;5			*
	dec		ram_d0					;5		   *
	dec		ram_d2					;5		   *
	dec		enemy_y					 ;5			*
	dec		ram_d0					;5		   *
	dec		ram_d2					;5	 =	53 *
ld802
	lda		#$28					;2		   *
	sta		ram_88					;3		   *
	lda		#$f5					;2		   *
	sta		ram_89					;3		   *
	jmp		ldfad					;3	 =	13 *

ld80d
	lda		ram_99					;3
	beq		set_room_attr					;2/3
	jsr		ldd59				   ;6		  *
	lda		#$00					;2	 =	13 *
set_room_attr
	sta		ram_99					;3
	ldx		room_num				  ;3
	lda		room_miss0_size_tabl,x					;4
	sta		nusiz0					;3
	lda		room_pf_cfg					;3
	sta		ctrlpf					;3
	lda		room_bg_color_tbl,x					;4
	sta		colubk					;3
	lda		room_pf_color_tbl,x					;4
	sta		colupf					;3
	lda		room_p0_color_tbl,x					;4
	sta		colup0					;3
	lda		room_p1_color_tbl,x					;4
	sta		colup1					;3
	cpx		#$0b					;2
	bcc		ld84b					;2/3
	lda		#$20					;2
	sta		ram_d4					;3
	ldx		#$04					;2	 =	58
ld841
	ldy		ram_e5,x				;4
	lda		room_miss0_size_tabl,y					;4
	sta		ram_ee,x				;4
	dex								;2
	bpl		ld841					;2/3 =	16
ld84b
	jmp		ld006					;3	 =	 3

ld84e
	lda		#$4d					;2
	sta		indy_x					;3
	lda		#$48					;2
	sta		enemy_x					 ;3
	lda		#$1f					;2
	sta		indy_y					;3
	rts								;6	 =	21

ld85b
	ldx		#$00					;2		   *
	txa								;2	 =	 4 *
ld85e
	sta		ram_df,x				;4		   *
	sta		ram_e0,x				;4		   *
	sta		pf1_data,x				  ;4		 *
	sta		ram_e2,x				;4		   *
	sta		pf2_data,x				  ;4		 *
	sta		ram_e4,x				;4		   *
	txa								;2		   *
	bne		ld873					;2/3	   *
	ldx		#$06					;2		   *
	lda		#$14					;2		   *
	bne		ld85e					;2/3 =	34 *
ld873
	lda		#$fc					;2		   *
	sta		ram_d7					;3		   *
	rts								;6	 =	11 *

ld878
	lda		ram_9a					;3
	bpl		ld880					;2/3
	ora		#$40					;2		   *
	sta		ram_9a					;3	 =	10 *
ld880
	lda		#$5c					;2
	sta		ram_96					;3
	ldx		#$00					;2
	stx		ram_93					;3
	stx		ram_b6					;3
	stx		ram_8e					;3
	stx		ram_90					;3
	lda		ram_95					;3
	stx		ram_95					;3
	jsr		ldd59				   ;6
	rol		ram_8a					;5
	clc								;2
	ror		ram_8a					;5
	ldx		room_num				  ;3
	lda		ldb92,x					;4
	sta		room_pf_cfg					;3
	cpx		#$0d					;2
	beq		ld84e					;2/3
	cpx		#$05					;2		   *
	beq		ld8b1					;2/3	   *
	cpx		#$0c					;2		   *
	beq		ld8b1					;2/3	   *
	lda		#$00					;2		   *
	sta		ram_8b					;3	 =	70 *
ld8b1
	lda		ldbee,x					;4		   *
	sta		emy_anim				  ;3		 *
	lda		ldbe1,x					;4		   *
	sta		ram_de					;3		   *
	lda		ldbc9,x					;4		   *
	sta		snake_y					 ;3			*
	lda		ldbd4,x					;4		   *
	sta		enemy_x					 ;3			*
	lda		ldc0e,x					;4		   *
	sta		ram_ca					;3		   *
	lda		ldc1b,x					;4		   *
	sta		ram_d0					;3		   *
	cpx		#$0b					;2		   *
	bcs		ld85b					;2/3	   *
	adc		ldc03,x					;4		   *
	sta		ram_e0					;3		   *
	lda		ldc28,x					;4		   *
	sta		pf1_data				  ;3		 *
	lda		ldc33,x					;4		   *
	sta		ram_e2					;3		   *
	lda		ldc3e,x					;4		   *
	sta		pf2_data				  ;3		 *
	lda		ldc49,x					;4		   *
	sta		ram_e4					;3		   *
	lda		#$55					;2		   *
	sta		ram_d2					;3		   *
	sta		ram_d1					;3		   *
	cpx		#$06					;2		   *
	bcs		ld93e					;2/3!	   *
	lda		#$00					;2		   *
	cpx		#$00					;2		   *
	beq		ld91b					;2/3!	   *
	cpx		#$02					;2		   *
	beq		ld92a					;2/3	   *
	sta		enemy_y					 ;3	  = 106 *
ld902
	ldy		#$4f					;2		   *
	cpx		#$02					;2		   *
	bcc		ld918					;2/3	   *
	lda		ram_af,x				;4		   *
	ror								;2		   *
	bcc		ld918					;2/3	   *
	ldy		ldf72,x					;4		   *
	cpx		#$03					;2		   *
	bne		ld918					;2/3	   *
	lda		#$ff					;2		   *
	sta		ram_d0					;3	 =	27 *
ld918
	sty		ram_df					;3		   *
	rts								;6	 =	 9 *

ld91b
	lda		ram_af					;3		   *
	and		#$78					;2		   *
	sta		ram_af					;3		   *
	lda		#$1a					;2		   *
	sta		enemy_y					 ;3			*
	lda		#$26					;2		   *
	sta		ram_df					;3		   *
	rts								;6	 =	24 *

ld92a
	lda		ram_b1					;3		   *
	and		#$07					;2		   *
	lsr								;2		   *
	bne		ld935					;2/3	   *
	ldy		#$ff					;2		   *
	sty		ram_d0					;3	 =	14 *
ld935
	tay								;2		   *
	lda		ldf70,y					;4		   *
	sta		enemy_y					 ;3			*
	jmp		ld902					;3	 =	12 *

ld93e
	cpx		#$08					;2		   *
	beq		ld950					;2/3	   *
	cpx		#$06					;2		   *
	bne		ld968					;2/3	   *
	ldy		#$00					;2		   *
	sty		ram_d8					;3		   *
	ldy		#$40					;2		   *
	sty		ram_e5					;3		   *
	bne		ld958					;2/3 =	20 *
ld950
	ldy		#$ff					;2		   *
	sty		ram_e5					;3		   *
	iny								;2		   *
	sty		ram_d8					;3		   *
	iny								;2	 =	12 *
ld958
	sty		ram_e6					;3		   *
	sty		ram_e7					;3		   *
	sty		ram_e8					;3		   *
	sty		ram_e9					;3		   *
	sty		ram_ea					;3		   *
	ldy		#$39					;2		   *
	sty		ram_d4					;3		   *
	sty		ram_d5					;3	 =	23 *
ld968
	cpx		#$09					;2		   *
	bne		ld977					;2/3	   *
	ldy		indy_y					;3		   *
	cpy		#$49					;2		   *
	bcc		ld977					;2/3	   *
	lda		#$50					;2		   *
	sta		ram_df					;3		   *
	rts								;6	 =	22 *

ld977
	lda		#$00					;2		   *
	sta		ram_df					;3		   *
	rts								;6	 =	11 *

ld97c
	ldy		lde00,x					;4		   *
	cpy		ram_86					;3		   *
	beq		ld986					;2/3	   *
	clc								;2		   *
	clv								;2		   *
	rts								;6	 =	19 *

ld986
	ldy		lde34,x					;4		   *
	bmi		ld99b					;2/3 =	 6 *
ld98b
	lda		ldf04,x					;4		   *
	beq		ld992					;2/3 =	 6 *
ld990
	sta		indy_y					;3	 =	 3 *
ld992
	lda		ldf38,x					;4		   *
	beq		ld999					;2/3	   *
	sta		indy_x					;3	 =	 9 *
ld999
	sec								;2		   *
	rts								;6	 =	 8 *

ld99b
	iny								;2		   *
	beq		ld9f9					;2/3	   *
	iny								;2		   *
	bne		ld9b6					;2/3	   *
	ldy		lde68,x					;4		   *
	cpy		ram_87					;3		   *
	bcc		ld9af					;2/3	   *
	ldy		lde9c,x					;4		   *
	bmi		ld9c7					;2/3	   *
	bpl		ld98b					;2/3 =	25 *
ld9af
	ldy		lded0,x					;4		   *
	bmi		ld9c7					;2/3	   *
	bpl		ld98b					;2/3 =	 8 *
ld9b6
	lda		ram_87					;3		   *
	cmp		lde68,x					;4		   *
	bcc		ld9f9					;2/3	   *
	cmp		lde9c,x					;4		   *
	bcs		ld9f9					;2/3	   *
	ldy		lded0,x					;4		   *
	bpl		ld98b					;2/3 =	21 *
ld9c7
	iny								;2		   *
	bmi		ld9d4					;2/3	   *
	ldy		#$08					;2		   *
	bit		ram_af					;3		   *
	bpl		ld98b					;2/3	   *
	lda		#$41					;2		   *
	bne		ld990					;2/3 =	15 *
ld9d4
	iny								;2		   *
	bne		ld9e1					;2/3	   *
	lda		ram_b5					;3		   *
	and		#$0f					;2		   *
	bne		ld9f9					;2/3	   *
	ldy		#$06					;2		   *
	bne		ld98b					;2/3 =	15 *
ld9e1
	iny								;2		   *
	bne		ld9f0					;2/3	   *
	lda		ram_b5					;3		   *
	and		#$0f					;2		   *
	cmp		#$0a					;2		   *
	bcs		ld9f9					;2/3	   *
	ldy		#$06					;2		   *
	bne		ld98b					;2/3 =	17 *
ld9f0
	iny								;2		   *
	bne		ld9fe					;2/3	   *
	ldy		#$01					;2		   *
	bit		ram_8a					;3		   *
	bmi		ld98b					;2/3 =	11 *
ld9f9
	clc								;2		   *
	bit		ld9fd					;4	 =	 6 *

ld9fd
	.byte	$60								; $d9fd (d)

ld9fe
	iny								;2		   *
	bne		ld9f9					;2/3!	   *
	ldy		#$06					;2		   *
	lda		#$0e					;2		   *
	cmp		current_object					;3		   *
	bne		ld9f9					;2/3!	   *
	bit		inpt5|$30				;3		   *
	bmi		ld9f9					;2/3!	   *
	jmp		ld98b					;3	 =	21 *

lda10
	ldy		ram_c4					;3		   *
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
	dec		ram_c4					;5		   *
	lda		#$00					;2		   *
	sta		inv_slot_lo,x				  ;4		 *
	cpy		#$05					;2		   *
	bcc		lda37					;2/3	   *
	tya								;2		   *
	tax								;2		   *
	jsr		ldd1b					;6		   *
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
	lda		#<blank_gfx				; load blank space
	ldx		cursor_pos				; get at current position
	sta		inv_slot_lo,x			; put in current slot
	ldx		current_object			; is the current object
	cpx		#key_obj				; the key?
	bcc		lda4f					;2/3	   *
	jsr		ldd1b					;6	 =	22 *
lda4f
	txa								;2		   *
	tay								;2		   *
	asl								;2		   *
	tax								;2		   *
	lda		ldc76,x					;4		   *
	pha								;3		   *
	lda		ldc75,x					;4		   *
	pha								;3		   *
	ldx		room_num				  ;3		 *
	rts								;6	 =	31 *

lda5e:
	   lda	  #$3f					  ;2
	   and	  $b4					  ;3
	   sta	  $b4					  ;3
lda64:
	   jmp	  ldad8					  ;3

lda67:
	   stx	  $8d					  ;3
	   lda	  #$70					  ;2
	   sta	  $d1					  ;3
	   bne	  lda64					  ;2 always branch

lda6f:
	   lda	  #$42					  ;2
	   cmp	  $91					  ;3
	   bne	  lda86					  ;2
	   lda	  #$03					  ;2
	   sta	  $81					  ;3
	   jsr	  ld878					  ;6
	   lda	  #$15					  ;2
	   sta	  $c9					  ;3
	   lda	  #$1c					  ;2
	   sta	  $cf					  ;3
	   bne	  ldad8					  ;2 always branch

lda86:
	   cpx	  #$05					  ;2
	   bne	  ldad8					  ;2
	   lda	  #$05					  ;2
	   cmp	  $8b					  ;3
	   bne	  ldad8					  ;2
	   sta	  yar_found				  ;3 5 points (gained)...shared from existing compare value
	   lda	  #$00					  ;2
	   sta	  $ce					  ;3
	   lda	  #$02					  ;2
	   ora	  $b4					  ;3
	   sta	  $b4					  ;3
	   bne	  ldad8					  ;2 always branch

lda9e:
	   ror	  $b1					  ;5
	   clc							  ;2
	   rol	  $b1					  ;5
	   cpx	  #$02					  ;2
	   bne	  ldaab					  ;2
	   lda	  #$4e					  ;2
	   sta	  $df					  ;3
ldaab:
	   bne	  ldad8					  ;2 always branch

ldaad:
	   ror	  $b2					  ;5
	   clc							  ;2
	   rol	  $b2					  ;5
	   cpx	  #$03					  ;2
	   bne	  ldabe					  ;2
	   lda	  #$4f					  ;2
	   sta	  $df					  ;3
	   lda	  #$4b					  ;2
	   sta	  $d0					  ;3
ldabe:
	   bne	  ldad8					  ;2 always branch

ldac0:
	   ldx	  $81					  ;3
	   cpx	  #$03					  ;2
	   bne	  ldad1					  ;2
	   lda	  $c9					  ;3
	   cmp	  #$3c					  ;2
	   bcs	  ldad1					  ;2
	   rol	  $b2					  ;5
	   sec							  ;2
	   ror	  $b2					  ;5
ldad1:
	   lda	  $91					  ;3
	   clc							  ;2
	   adc	  #$40					  ;2
	   sta	  $91					  ;3
ldad8:
	   dec	  $c4					  ;5
	   bne	  ldae2					  ;2
	   lda	  #$00					  ;2
	   sta	  current_object		  ;3
	   beq	  ldaf7					  ;2 always branch

ldae2:
	   ldx	  $c3					  ;3
ldae4:
	   inx							  ;2
	   inx							  ;2
	   cpx	  #$0b					  ;2
	   bcc	  ldaec					  ;2
	   ldx	  #$00					  ;2
ldaec:
	   lda	  inv_slot_lo,x		 ;4
	   beq	  ldae4					  ;2 branch if current slot is free
	   stx	  $c3					  ;3  ...or store the slot number
	   lsr							  ;2
	   lsr							  ;2
	   lsr							  ;2
	   sta	  current_object		  ;3 ...and the object number
ldaf7
	lda		#$0d					;2		   *
	sta		ram_a2					;3		   *
	sec								;2		   *
	rts								;6	 =	13 *

	.byte	$00,$00,$00						; $dafd (*)
room_miss0_size_tabl
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
	.byte	$c0|$c						  ; $dbc9 (c)

	.byte	$ce,$4a,$98,$00,$00,$00			; $dbca (*)

	.byte	$00|$8						  ; $dbd0 (c)

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
ldc5c
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

ldc9b:
	   .word ld2b4-1 ; $dc9b/9c
	   .word ld1eb-1 ; $dc9d/9e
	   .word ld292-1 ; $dc9f/a0
	   .word ld24a-1 ; $dca1/a2
	   .word ld2b4-1 ; $dca3/a4
	   .word ld1c4-1 ; $dca5/a6
	   .word ld28e-1 ; $dca7/a8
	   .word ld1b9-1 ; $dca9/aa
	   .word ld335-1 ; $dcab/ac
	   .word ld2b4-1 ; $dcad/ae
	   .word ld192-1 ; $dcaf/b0
	   .word ld18e-1 ; $dcb1/b2
	   .word ld162-1 ; $dcb3/b4

ldcb5:
	   .word ld374-1 ; $dcb5/b6
	   .word ld374-1 ; $dcb7/b8
	   .word ld321-1 ; $dcb9/ba
	   .word ld374-1 ; $dcbb/bc
	   .word ld374-1 ; $dcbd/be
	   .word ld357-1 ; $dcbf/c0
	   .word ld302-1 ; $dcc1/c2
	   .word ld357-1 ; $dcc3/c4
	   .word ld335-1 ; $dcc5/c6
	   .word ld374-1 ; $dcc7/c8
	   .word ld36a-1 ; $dcc9/ca
	   .word ld374-1 ; $dccb/cc
	   .word ld374-1 ; $dccd/ce

ldccf:
	   .word ld374-1 ; $dccf/d0
	   .word ld374-1 ; $dcd1/d2
	   .word ld36f-1 ; $dcd3/d4
	   .word ld374-1 ; $dcd5/d6
	   .word ld2f2-1 ; $dcd7/d8
	   .word ld374-1 ; $dcd9/da
	   .word ld374-1 ; $dcdb/dc
	   .word ld374-1 ; $dcdd/de
	   .word ld374-1 ; $dcdf/e0
	   .word ld2ce-1 ; $dce1/e2
	   .word ld36f-1 ; $dce3/e4
	   .word ld374-1 ; $dce5/e6
	   .word ld374-1 ; $dce7/e8

ldce9
	ldx		ram_c4					;3		   *
	cpx		#$06					;2		   *
	bcc		ldcf1					;2/3	   *
	clc								;2		   *
	rts								;6	 =	15 *

ldcf1
	ldx		#$0a					;2	 =	 2 *
ldcf3
	ldy		inv_slot_lo,x				  ;4		 *
	beq		ldcfc					; branch if current slot is free
	dex								;2		   *
	dex								;2		   *
	bpl		ldcf3					;2/3	   *
	brk								; unused

ldcfc
	tay								;2		   *
	asl								; multiply object number by 8 for gfx
	asl								;...
	asl								;...
	sta		inv_slot_lo,x			; and store in current slot
	lda		ram_c4					;3		   *
	bne		ldd0a					;2/3	   *
	stx		cursor_pos					;3		   *
	sty		current_object					;3	 =	23 *
ldd0a
	inc		ram_c4					;5		   *
	cpy		#$04					;2		   *
	bcc		ldd15					;2/3	   *
	tya								;2		   *
	tax								;2		   *
	jsr		ldd2f					;6	 =	19 *
ldd15
	lda		#$0c					;2		   *
	sta		ram_a2					;3		   *
	sec								;2		   *
	rts								;6	 =	13 *

ldd1b
	lda		ldc64,x					;4		   *
	lsr								;2		   *
	tay								;2		   *
	lda		ldc5c,y					;4		   *
	bcs		ldd2a					;2/3	   *
	and		ram_c6					;3		   *
	sta		ram_c6					;3		   *
	rts								;6	 =	26 *

ldd2a
	and		ram_c7					;3		   *
	sta		ram_c7					;3		   *
	rts								;6	 =	12 *

ldd2f
	lda		ldc64,x					;4		   *
	lsr								;2		   *
	tax								;2		   *
	lda		ldc54,x					;4		   *
	bcs		ldd3e					;2/3	   *
	ora		ram_c6					;3		   *
	sta		ram_c6					;3		   *
	rts								;6	 =	26 *

ldd3e
	ora		ram_c7					;3		   *
	sta		ram_c7					;3		   *
	rts								;6	 =	12 *

ldd43:
	   lda	  ldc64,x				  ;4
	   lsr							  ;2
	   tay							  ;2
	   lda	  ldc54,y				  ;4
	   bcs	  ldd53					  ;2
	   and	  ram_c6					 ;3
	   beq	  ldd52					  ;2
	   sec							  ;2
ldd52:
	   rts							  ;6

ldd53:
	   and	  ram_c7					 ;3
	   bne	  ldd52					  ;2
	   clc							  ;2
	   rts							  ;6


ldd59
	and		#$1f					;2
	tax								;2
	lda		ram_98					;3
	cpx		#$0c					;2
	bcs		ldd67					;2/3
	adc		ldfe5,x					;4
	sta		ram_98					;3	 =	18
ldd67
	rts								;6	 =	 6

game_start
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
	lda		#>blank_gfx				; blank inventory
	sta		inv_slot_hi				; slot 1
	sta		inv_slot2_hi			; slot 2
	sta		inv_slot3_hi			; slot 3
	sta		inv_slot4_hi			; slot 4
	sta		inv_slot5_hi			; slot 5
	sta		inv_slot6_hi			; slot 6

	;fill with copyright text
	lda		#<copyright_gfx_1
	sta		inv_slot_lo
	lda		#<copyright_gfx_2
	sta		inv_slot2_lo
	lda		#<copyright_gfx_4
	sta		inv_slot4_lo
	lda		#<copyright_gfx_3
	sta		inv_slot3_lo
	lda		#<copyright_gfx_5
	sta		inv_slot5_lo
	lda		#ark_room				; set "ark elevator room" (room 13)
	sta		room_num				; as current room
	lsr								; divide 13 by 2 (round down)
	sta		num_bullets				; load 6 bullets
	jsr		ld878					;6
	jmp		ld3dd					;3	 =	77

reset_vars
	lda		#$20					;2		   *
	sta		inv_slot_lo				  ;3		 *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	sta		current_object					;3		   *
	inc		ram_c4					;5		   *
	lda		#$00					;2		   *
	sta		inv_slot2_lo				  ;3		 *
	sta		inv_slot3_lo				  ;3		 *
	sta		inv_slot4_lo				  ;3		 *
	sta		inv_slot5_lo				  ;3		 *
	lda		#$64					;2		   *
	sta		score				   ;3		  *
	lda		#$58					;2		   *
	sta		indy_anim				   ;3		  *
	lda		#$fa					;2		   *
	sta		ram_da					;3		   *
	lda		#$4c					;2		   *
	sta		indy_x					;3		   *
	lda		#$0f					;2		   *
	sta		indy_y					;3		   *
	lda		#starting_room					;2		   *
	sta		room_num				  ;3		 *
	sta		lives_left					;3		   *
	jsr		ld878					;6		   *
	jmp		ld80d					;3	 =	75 *

tally_score
	lda		score				   	; load score
	sec								; positve actions...
	sbc		shovel_used				; shovel used
	sbc		parachute_used			; parachute used
	sbc		ankh_used				; ankh used
	sbc		yar_found				; yar found
	sbc		lives_left				; lives left
	sbc		ark_found				; ark found
	sbc		mesa_entered		  	; mesa entered
	sbc		unknown_action			; never updated
	clc								; negitive actions...
	adc		grenade_used			; gernade used
	adc		escape_hatch_used		; escape hatch used
	adc		thief_shot				; thief shot
	sta		score				   	; store in final score
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

ldf78
	.byte $04 ; |	  x	 | $df78
	.byte $11 ; |	x	x| $df79
	.byte $10 ; |	x	 | $df7a
	.byte $12 ; |	x  x | $df7b


ldf7c
	.byte	$07,$03,$05,$06,$09,$0b,$0e,$00 ; $df7c (*)
	.byte	$01,$03,$05,$00,$09,$0c,$0e,$00 ; $df84 (*)
	.byte	$01,$04,$05,$00,$0a,$0c,$0f,$00 ; $df8c (*)
	.byte	$02,$04,$05,$08,$0a,$0d,$0f,$00 ; $df94 (*)

ldf9c
	lda		intim					;4
	bne		ldf9c					;2/3
	sta		wsync					;3	 =	 9
;---------------------------------------
	sta		wsync					;3	 =	 3
;---------------------------------------
	lda		#$44					;2
	sta		ram_88					;3
	lda		#$f8					;2
	sta		ram_89					;3	 =	10
ldfad
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
	ror								;move first bit into carry
	bcs		mov_emy_right			;if 1 check if enemy shoulld go right
	dec		enemy_y,x				;move enemy left 1 unit
mov_emy_right
	ror								;rotate next bit into carry
	bcs		mov_emy_down			  ;if 1 check if enemy should go up
	inc		enemy_y,x				;move enemy right 1 unit
mov_emy_down
	ror								;rotate next bit into carry
	bcs		mov_emy_up				;if 1 check if enemy should go up
	dec		enemy_x,x				;move enemy down 1 unit
mov_emy_up
	ror								;rotate next bit into carry
	bcs		mov_emy_finish			;if 1, moves are finished
	inc		enemy_x,x				;move enemy up 1 unit
mov_emy_finish
	rts								;return

ldfd5
	.byte	$00,$00,$00,$00,$00,$0a,$09,$0b ; $dfd5 (*)
	.byte	$00,$06,$05,$07,$00,$0e,$0d,$0f ; $dfdd (*)
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
;	   bank 1 / 0..1
;***********************************************************

	seg		code
	org		$1000
	rorg	$f000

	lda		lfff8					;4	 =	 4
lf003
	cmp		ram_e0					;3		   *
	bcs		lf01a					;2/3	   *
	lsr								;2		   *
	clc								;2		   *
	adc		ram_df					;3		   *
	tay								;2		   *
	sta		wsync					;3	 =	17 *
;---------------------------------------
	sta		hmove					;3		   *
	lda		(pf1_data),y			  ;5		 *
	sta		pf1						;3		   *
	lda		(pf2_data),y			  ;5		 *
	sta		pf2						;3		   *
	bcc		lf033					;2/3 =	21 *
lf01a
	sbc		ram_d4					;3		   *
	lsr								;2		   *
	lsr								;2		   *
	sta		wsync					;3	 =	10 *
;---------------------------------------
	sta		hmove					;3		   *
	tax								;2		   *
	cpx		ram_d5					;3		   *
	bcc		lf02d					;2/3	   *
	ldx		ram_d8					;3		   *
	lda		#$00					;2		   *
	beq		lf031					;2/3 =	17 *
lf02d
	lda		ram_e5,x				;4		   *
	ldx		ram_d8					;3	 =	 7 *
lf031
	sta		pf1,x					;4	 =	 4 *
lf033
	ldx		#$1e					;2		   *
	txs								;2		   *
	lda		scan_line				   ;3		  *
	sec								;2		   *
	sbc		indy_y					;3		   *
	cmp		indy_h					;3		   *
	bcs		lf079					;2/3	   *
	tay								;2		   *
	lda		(indy_anim),y			   ;5		  *
	tax								;2	 =	26 *
lf043
	lda		scan_line				   ;3		  *
	sec								;2		   *
	sbc		enemy_y					 ;3			*
	cmp		snake_y					 ;3			*
	bcs		lf07d					;2/3	   *
	tay								;2		   *
	lda		(emy_anim),y			  ;5		 *
	tay								;2	 =	22 *
lf050
	lda		scan_line				   ;3		  *
	sta		wsync					;3	 =	 6 *
;---------------------------------------
	sta		hmove					;3		   *
	cmp		ram_d1					;3		   *
	php								;3		   *
	cmp		ram_d0					;3		   *
	php								;3		   *
	stx		grp1					;3		   *
	sty		grp0					;3		   *
	sec								;2		   *
	sbc		ram_d2					;3		   *
	cmp		#$08					;2		   *
	bcs		lf06e					;2/3	   *
	tay								;2		   *
	lda		(ram_d6),y				;5		   *
	sta		enabl					;3		   *
	sta		hmbl					;3	 =	43 *
lf06e
	inc		scan_line				   ;5		  *
	lda		scan_line				   ;3		  *
	cmp		#$50					;2		   *
	bcc		lf003					;2/3	   *
	jmp		lf1ea					;3	 =	15 *

lf079
	ldx		#$00					;2		   *
	beq		lf043					;2/3 =	 4 *
lf07d
	ldy		#$00					;2		   *
	beq		lf050					;2/3 =	 4 *
lf081
	cpx		#$4f					;2		   *
	bcc		lf088					;2/3	   *
	jmp		lf1ea					;3	 =	 7 *

lf088
	lda		#$00					;2		   *
	beq		lf0a4					;2/3 =	 4 *
lf08c
	lda		(emy_anim),y			  ;5		 *
	bmi		lf09c					;2/3	   *
	cpy		ram_df					;3		   *
	bcs		lf081					;2/3	   *
	cpy		enemy_y					 ;3			*
	bcc		lf088					;2/3	   *
	sta		grp0					;3		   *
	bcs		lf0a4					;2/3 =	22 *
lf09c
	asl								;2		   *
	tay								;2		   *
	and		#$02					;2		   *
	tax								;2		   *
	tya								;2		   *
	sta		(pf1_data,x)			  ;6   =  16 *
lf0a4
	inc		scan_line				   ;5		  *
	ldx		scan_line				   ;3		  *
	lda		#$02					;2		   *
	cpx		ram_d0					;3		   *
	bcc		lf0b2					;2/3	   *
	cpx		ram_e0					;3		   *
	bcc		lf0b3					;2/3 =	20 *
lf0b2
	ror								;2	 =	 2 *
lf0b3
	sta		enam0					;3		   *
lf0b5
	sta		wsync					;3	 =	 6 *
;---------------------------------------
	sta		hmove					;3		   *
	txa								;2		   *
	sec								;2		   *
	sbc		ram_d5					;3		   *
	cmp		#$10					;2		   *
	bcs		lf0ff					;2/3	   *
	tay								;2		   *
	cmp		#$08					;2		   *
	bcc		lf0fb					;2/3	   *
	lda		ram_d8					;3		   *
	sta		ram_d6					;3	 =	26 *
lf0ca
	lda		(ram_d6),y				;5		   *
	sta		hmbl					;3	 =	 8 *
lf0ce
	ldy		#$00					;2		   *
	txa								;2		   *
	cmp		ram_d1					;3		   *
	bne		lf0d6					;2/3	   *
	dey								;2	 =	11 *
lf0d6
	sty		enam1					;3		   *
	sec								;2		   *
	sbc		indy_y					;3		   *
	cmp		indy_h					;3		   *
	bcs		lf107					;2/3!	   *
	tay								;2		   *
	lda		(indy_anim),y			   ;5	=  20 *
lf0e2
	ldy		scan_line				   ;3		  *
	sta		grp1					;3		   *
	sta		wsync					;3	 =	 9 *
;---------------------------------------
	sta		hmove					;3		   *
	lda		#$02					;2		   *
	cpx		ram_d2					;3		   *
	bcc		lf0f9					;2/3	   *
	cpx		snake_y					 ;3			*
	bcc		lf0f5					;2/3 =	15 *
lf0f4
	ror								;2	 =	 2 *
lf0f5
	sta		enabl					;3		   *
	bcc		lf08c					;2/3 =	 5 *
lf0f9
	bcc		lf0f4					;2/3 =	 2 *
lf0fb
	nop								;2		   *
	jmp		lf0ca					;3	 =	 5 *

lf0ff
	pha								;3		   *
	pla								;4		   *
	pha								;3		   *
	pla								;4		   *
	nop								;2		   *
	jmp		lf0ce					;3	 =	19 *

lf107
	lda		#$00					;2		   *
	beq		lf0e2					;2/3!=	 4 *
lf10b
	inx								;2		   *
	sta		hmclr					;3		   *
	cpx		#$a0					;2		   *
	bcc		lf140					;2/3	   *
	jmp		lf1ea					;3	 =	12 *

lf115
	sta		wsync					;3	 =	 3 *
;---------------------------------------
	sta		hmove					;3		   *
	inx								;2		   *
	lda		ram_84					;3		   *
	sta		grp0					;3		   *
	lda		ram_85					;3		   *
	sta		colup0					;3		   *
	txa								;2		   *
	ldx		#$1f					;2		   *
	txs								;2		   *
	tax								;2		   *
	lsr								;2		   *
	cmp		ram_d2					;3		   *
	php								;3		   *
	cmp		ram_d1					;3		   *
	php								;3		   *
	cmp		ram_d0					;3		   *
	php								;3		   *
	sec								;2		   *
	sbc		indy_y					;3		   *
	cmp		indy_h					;3		   *
	bcs		lf10b					;2/3	   *
	tay								;2		   *
	lda		(indy_anim),y			   ;5		  *
	sta		hmclr					;3		   *
	inx								;2		   *
	sta		grp1					;3	 =	70 *
lf140
	sta		wsync					;3	 =	 3 *
;---------------------------------------
	sta		hmove					;3		   *
	bit		ram_d4					;3		   *
	bpl		lf157					;2/3	   *
	ldy		ram_89					;3		   *
	lda		ram_88					;3		   *
	lsr		ram_d4					;5	 =	19 *
lf14e
	dey								;2		   *
	bpl		lf14e					;2/3	   *
	sta		resp0					;3		   *
	sta		hmp0					;3		   *
	bmi		lf115					;2/3 =	12 *
lf157
	bvc		lf177					;2/3	   *
	txa								;2		   *
	and		#$0f					;2		   *
	tay								;2		   *
	lda		(emy_anim),y			  ;5		 *
	sta		grp0					;3		   *
	lda		(ram_d6),y				;5		   *
	sta		colup0					;3		   *
	iny								;2		   *
	lda		(emy_anim),y			  ;5		 *
	sta		ram_84					;3		   *
	lda		(ram_d6),y				;5		   *
	sta		ram_85					;3		   *
	cpy		snake_y					 ;3			*
	bcc		lf174					;2/3	   *
	lsr		ram_d4					;5	 =	52 *
lf174
	jmp		lf115					;3	 =	 3 *

lf177
	lda		#$20					;2		   *
	bit		ram_d4					;3		   *
	beq		lf1a7					;2/3	   *
	txa								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	bcs		lf115					;2/3	   *
	tay								;2		   *
	sty		ram_87					;3		   *
	lda.wy	ram_df,y				;4		   *
	sta		refp0					;3		   *
	sta		nusiz0					;3		   *
	sta		ram_86					;3		   *
	bpl		lf1a2					;2/3	   *
	lda		ram_96					;3		   *
	sta		emy_anim				  ;3		 *
	lda		#$65					;2		   *
	sta		ram_d6					;3		   *
	lda		#$00					;2		   *
	sta		ram_d4					;3		   *
	jmp		lf115					;3	 =	60 *

lf1a2
	lsr		ram_d4					;5		   *
	jmp		lf115					;3	 =	 8 *

lf1a7
	lsr								;2		   *
	bit		ram_d4					;3		   *
	beq		lf1ce					;2/3	   *
	ldy		ram_87					;3		   *
	lda		#$08					;2		   *
	and		ram_86					;3		   *
	beq		lf1b6					;2/3	   *
	lda		#$03					;2	 =	19 *
lf1b6
	eor.wy	ram_e5,y				;4		   *
	and		#$03					;2		   *
	tay								;2		   *
	lda		lfc40,y					;4		   *
	sta		emy_anim				  ;3		 *
	lda		#$44					;2		   *
	sta		ram_d6					;3		   *
	lda		#$0f					;2		   *
	sta		snake_y					 ;3			*
	lsr		ram_d4					;5		   *
	jmp		lf115					;3	 =	33 *

lf1ce
	txa								;2		   *
	and		#$1f					;2		   *
	cmp		#$0c					;2		   *
	beq		lf1d8					;2/3	   *
	jmp		lf115					;3	 =	11 *

lf1d8
	ldy		ram_87					;3		   *
	lda.wy	ram_ee,y				;4		   *
	sta		ram_88					;3		   *
	and		#$0f					;2		   *
	sta		ram_89					;3		   *
	lda		#$80					;2		   *
	sta		ram_d4					;3		   *
	jmp		lf115					;3	 =	23 *

lf1ea
	sta		wsync					;3	 =	 3
;---------------------------------------
	sta		hmove					;3
	ldx		#$ff					;2
	stx		pf1						;3
	stx		pf2						;3
	inx								;2
	stx		grp0					;3
	stx		grp1					;3
	stx		enam0					;3
	stx		enam1					;3
	stx		enabl					;3
	sta		wsync					;3	 =	31
;---------------------------------------
	sta		hmove					;3
	lda		#$03					;2
	ldy		#$00					;2
	sty		refp1					;3
	sta		nusiz0					;3
	sta		nusiz1					;3
	sta		vdelp0					;3
	sta		vdelp1					;3
	sty		grp0					;3
	sty		grp1					;3
	sty		grp0					;3
	sty		grp1					;3
	nop								;2
	sta		resp0					;3
	sta		resp1					;3
	sty		hmp1					;3
	lda		#$f0					;2
	sta		hmp0					;3
	sty		refp0					;3
	sta		wsync					;3	 =	56
;---------------------------------------
	sta		hmove					;3
	lda		#$1a					;2
	sta		colup0					;3
	sta		colup1					;3
	lda		cursor_pos					;3
	lsr								;2
	tay								;2
	lda		lfff2,y					;4
	sta		hmbl					;3
	and		#$0f					;2
	tay								;2
	ldx		#$00					;2
	stx		hmp0					;3
	sta		wsync					;3	 =	37
;---------------------------------------
	stx		pf0						;3
	stx		colubk					;3
	stx		pf1						;3
	stx		pf2						;3	 =	12
lf24a
	dey								;2
	bpl		lf24a					;2/3
	sta		resbl					;3
	stx		ctrlpf					;3
	sta		wsync					;3	 =	13
;---------------------------------------
	sta		hmove					;3
	lda		#$3f					;2
	and		frame_counter				   ;3
	bne		draw_menu					;2/3
	lda		#$3f					;2
	and		time_of_day					 ;3
	bne		draw_menu					;2/3
	lda		ram_b5					;3		   *
	and		#$0f					;2		   *
	beq		draw_menu					;2/3	   *
	cmp		#$0f					;2		   *
	beq		draw_menu					;2/3	   *
	inc		ram_b5					;5	 =	33 *
draw_menu
	sta		wsync					; draw blank line
	lda		#$42					; set red...
	sta		colubk					; ...as the background color
	sta		wsync					; draw four more scanlines
	sta		wsync					;
	sta		wsync					;
	sta		wsync					;
	lda		#$07					;2
	sta		ram_84					;3	 =	 5
draw_inventory
	ldy		ram_84					;3
	lda		(inv_slot_lo),y			  ;5
	sta		grp0					;3
	sta		wsync					;3	 =	14
;---------------------------------------
	lda		(inv_slot2_lo),y			  ;5
	sta		grp1					;3
	lda		(inv_slot3_lo),y			  ;5
	sta		grp0					;3
	lda		(inv_slot4_lo),y			  ;5
	sta		ram_85					;3
	lda		(inv_slot5_lo),y			  ;5
	tax								;2
	lda		(inv_slot6_lo),y			  ;5
	tay								;2
	lda		ram_85					;3
	sta		grp1					;3
	stx		grp0					;3
	sty		grp1					;3
	sty		grp0					;3
	dec		ram_84					;5
	bpl		draw_inventory					 ;2/3
	lda		#$00					;2
	sta		wsync					;3	 =	65
;---------------------------------------
	sta		grp0					;3
	sta		grp1					;3
	sta		grp0					;3
	sta		grp1					;3
	sta		nusiz0					;3
	sta		nusiz1					;3
	sta		vdelp0					;3
	sta		vdelp1					;3
	sta		wsync					;3	 =	27
;---------------------------------------
	sta		wsync					;3	 =	 3
;---------------------------------------
	ldy		#$02					;2
	lda		ram_c4					;3
	bne		lf2c6					;2/3
	dey								;2	 =	 9
lf2c6
	sty		enabl					;3
	ldy		#$08					;2
	sty		colupf					;3
	sta		wsync					;3	 =	11
;---------------------------------------
	sta		wsync					;3	 =	 3
;---------------------------------------
	ldy		#$00					;2
	sty		enabl					;3
	sta		wsync					;3	 =	 8
;---------------------------------------
	sta		wsync					;3	 =	 3
;---------------------------------------
	sta		wsync					;3	 =	 3
;---------------------------------------
	ldx		#$0f					;2
	stx		vblank					;3
	ldx		#$24					;2
	stx		tim64t					;4
	ldx		#$ff					;2
	txs								;2
	ldx		#$01					;2	 =	17
lf2e8
	lda		ram_a2,x				;4
	sta		audc0,x					;4
	sta		audv0,x					;4
	bmi		lf2fb					;2/3
	ldy		#$00					;2
	sty		ram_a2,x				;4	 =	20
lf2f4
	sta		audf0,x					;4
	dex								;2
	bpl		lf2e8					;2/3
	bmi		lf320					;2/3!=	10
lf2fb
	cmp		#$9c					;2
	bne		lf314					;2/3!
	lda		#$0f					;2
	and		frame_counter				   ;3
	bne		lf30d					;2/3
	dec		diamond_h				   ;5
	bpl		lf30d					;2/3
	lda		#$17					;2
	sta		diamond_h				   ;3	=  23
lf30d
	ldy		diamond_h				   ;3
	lda		lfbe8,y					;4
	bne		lf2f4					;2/3!=	 9
lf314
	lda		frame_counter				   ;3		  *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	tay								;2		   *
	lda		lfaee,y					;4		   *
	bne		lf2f4					;2/3!=	19 *
lf320
	lda		current_object					;3
	cmp		#$0f					;2
	beq		lf330					;2/3
	cmp		#$02					;2
	bne		lf344					;2/3
	lda		#$84					;2		   *
	sta		ram_a3					;3		   *
	bne		lf348					;2/3 =	18 *
lf330
	bit		inpt5|$30				;3		   *
	bpl		lf338					;2/3	   *
	lda		#$78					;2		   *
	bne		lf340					;2/3 =	 9 *
lf338
	lda		time_of_day					 ;3			*
	and		#$e0					;2		   *
	lsr								;2		   *
	lsr								;2		   *
	adc		#$98					;2	 =	11 *
lf340
	ldx		cursor_pos					;3		   *
	sta		inv_slot_lo,x				  ;4   =   7 *
lf344
	lda		#$00					;2
	sta		ram_a3					;3	 =	 5
lf348
	bit		ram_93					;3
	bpl		lf371					;2/3
	lda		frame_counter				   ;3		  *
	and		#$07					;2		   *
	cmp		#$05					;2		   *
	bcc		lf365					;2/3	   *
	ldx		#$04					;2		   *
	ldy		#$01					;2		   *
	bit		ram_9d					;3		   *
	bmi		lf360					;2/3	   *
	bit		ram_a1					;3		   *
	bpl		lf362					;2/3 =	28 *
lf360
	ldy		#$03					;2	 =	 2 *
lf362
	jsr		lf8b3					;6	 =	 6 *
lf365
	lda		frame_counter				   ;3		  *
	and		#$06					;2		   *
	asl								;2		   *
	asl								;2		   *
	sta		ram_d6					;3		   *
	lda		#$fd					;2		   *
	sta		ram_d7					;3	 =	17 *
lf371
	ldx		#$02					;2	 =	 2
lf373
	jsr		lfef4					;6
	inx								;2
	cpx		#$05					;2
	bcc		lf373					;2/3
	bit		ram_9d					;3
	bpl		lf3bf					;2/3
	lda		frame_counter				   ;3		  *
	bvs		lf39d					;2/3	   *
	and		#$0f					;2		   *
	bne		lf3c5					;2/3	   *
	ldx		indy_h					;3		   *
	dex								;2		   *
	stx		ram_a3					;3		   *
	cpx		#$03					;2		   *
	bcc		lf398					;2/3	   *
	lda		#$8f					;2		   *
	sta		ram_d1					;3		   *
	stx		indy_h					;3		   *
	bcs		lf3c5					;2/3 =	48 *
lf398
	sta		frame_counter				   ;3		  *
	sec								;2		   *
	ror		ram_9d					;5	 =	10 *
lf39d
	cmp		#$3c					;2		   *
	bcc		lf3a9					;2/3	   *
	bne		lf3a5					;2/3	   *
	sta		ram_a3					;3	 =	 9 *
lf3a5
	ldy		#$00					;2		   *
	sty		indy_h					;3	 =	 5 *
lf3a9
	cmp		#$78					;2		   *
	bcc		lf3c5					;2/3	   *
	lda		#$0b					;2		   *
	sta		indy_h					;3		   *
	sta		ram_a3					;3		   *
	sta		ram_9d					;3		   *
	dec		lives_left					;5		   *
	bpl		lf3c5					;2/3	   *
	lda		#$ff					;2		   *
	sta		ram_9d					;3		   *
	bne		lf3c5					;2/3 =	29 *
lf3bf
	lda		room_num				  ;3
	cmp		#ark_room					;2
	bne		lf3d0					;2/3 =	 7
lf3c5
	lda		#$d8					;2
	sta		ram_88					;3
	lda		#$d3					;2
	sta		ram_89					;3
	jmp		lf493					;3	 =	13

lf3d0
	bit		ram_8d					;3		   *
	bvs		lf437					;2/3!	   *
	bit		ram_b4					;3		   *
	bmi		lf437					;2/3!	   *
	bit		ram_9a					;3		   *
	bmi		lf437					;2/3!	   *
	lda		#$07					;2		   *
	and		frame_counter				   ;3		  *
	bne		lf437					;2/3!	   *
	lda		ram_c4					;3		   *
	and		#$06					;2		   *
	beq		lf437					;2/3!	   *
	ldx		cursor_pos					;3		   *
	lda		inv_slot_lo,x				  ;4		 *
	cmp		#$98					;2		   *
	bcc		lf3f2					;2/3	   *
	lda		#$78					;2	 =	42 *
lf3f2
	bit		swcha					;4		   *
	bmi		lf407					;2/3!	   *
	sta		inv_slot_lo,x				  ;4   =  10 *
lf3f9
	inx								;2		   *
	inx								;2		   *
	cpx		#$0b					;2		   *
	bcc		lf401					;2/3!	   *
	ldx		#$00					;2	 =	10 *
lf401
	ldy		inv_slot_lo,x				  ;4		 *
	beq		lf3f9					;2/3!	   *
	bne		lf415					;2/3 =	 8 *
lf407
	bvs		lf437					;2/3	   *
	sta		inv_slot_lo,x				  ;4   =   6 *
lf40b
	dex								;2		   *
	dex								;2		   *
	bpl		lf411					;2/3	   *
	ldx		#$0a					;2	 =	 8 *
lf411
	ldy		inv_slot_lo,x				  ;4		 *
	beq		lf40b					;2/3 =	 6 *
lf415
	stx		cursor_pos					;3		   *
	tya								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	lsr								;2		   *
	sta		current_object					;3		   *
	cpy		#$90					;2		   *
	bne		lf437					;2/3	   *
	ldy		#mesa_top_room					;2		   *
	cpy		room_num				  ;3		 *
	bne		lf437					;2/3	   *
	lda		#$49					;2		   *
	sta		ram_8d					;3		   *
	lda		indy_y					;3		   *
	adc		#$09					;2		   *
	sta		ram_d1					;3		   *
	lda		indy_x					;3		   *
	adc		#$09					;2		   *
	sta		ram_cb					;3	 =	46 *
lf437
	lda		ram_8d					;3		   *
	bpl		lf454					;2/3	   *
	cmp		#$bf					;2		   *
	bcs		lf44b					;2/3	   *
	adc		#$10					;2		   *
	sta		ram_8d					;3		   *
	ldx		#$03					;2		   *
	jsr		lfcea					;6		   *
	jmp		lf48b					;3	 =	25 *

lf44b
	lda		#$70					;2		   *
	sta		ram_d1					;3		   *
	lsr								;2		   *
	sta		ram_8d					;3		   *
	bne		lf48b					;2/3 =	12 *
lf454
	bit		ram_8d					;3		   *
	bvc		lf48b					;2/3	   *
	ldx		#$03					;2		   *
	jsr		lfcea					;6		   *
	lda		ram_cb					;3		   *
	sec								;2		   *
	sbc		#$04					;2		   *
	cmp		indy_x					;3		   *
	bne		lf46a					;2/3	   *
	lda		#$03					;2		   *
	bne		lf481					;2/3 =	29 *
lf46a
	cmp		#$11					;2		   *
	beq		lf472					;2/3	   *
	cmp		#$84					;2		   *
	bne		lf476					;2/3 =	 8 *
lf472
	lda		#$0f					;2		   *
	bne		lf481					;2/3 =	 4 *
lf476
	lda		ram_d1					;3		   *
	sec								;2		   *
	sbc		#$05					;2		   *
	cmp		indy_y					;3		   *
	bne		lf487					;2/3	   *
	lda		#$0c					;2	 =	14 *
lf481
	eor		ram_8d					;3		   *
	sta		ram_8d					;3		   *
	bne		lf48b					;2/3 =	 8 *
lf487
	cmp		#$4a					;2		   *
	bcs		lf472					;2/3 =	 4 *
lf48b
	lda		#$24					;2		   *
	sta		ram_88					;3		   *
	lda		#$d0					;2		   *
	sta		ram_89					;3	 =	10 *
lf493
	lda		#$ad					;2
	sta		ram_84					;3
	lda		#$f8					;2
	sta		ram_85					;3
	lda		#$ff					;2
	sta		ram_86					;3
	lda		#$4c					;2
	sta		ram_87					;3
	jmp.w	ram_84					;3	 =	23

lf4a6
	sta		wsync					;3	 =	 3
;---------------------------------------
	cpx		#$12					;2
	bcc		lf4d0					;2/3
	txa								;2
	sbc		indy_y					;3
	bmi		lf4c9					;2/3
	cmp		#$14					;2
	bcs		lf4bd					;2/3
	lsr								;2
	tay								;2
	lda		indy_sprite,y				  ;4
	jmp		lf4c3					;3	 =	26

lf4bd
	and		#$03					;2
	tay								;2
	lda		lf9fc,y					;4	 =	 8
lf4c3
	sta		grp1					;3
	lda		indy_y					;3
	sta		colup1					;3	 =	 9
lf4c9
	inx								;2
	cpx		#$90					;2
	bcs		lf4ea					;2/3
	bcc		lf4a6					;2/3 =	 8
lf4d0
	bit		ram_9c					;3
	bmi		lf4e5					;2/3
	txa								;2
	sbc		#$07					;2
	bmi		lf4e5					;2/3
	tay								;2
	lda		lfb40,y					;4
	sta		grp1					;3
	txa								;2
	adc		frame_counter				   ;3
	asl								;2
	sta		colup1					;3	 =	30
lf4e5
	inx								;2
	cpx		#$0f					;2
	bcc		lf4a6					;2/3 =	 6
lf4ea
	sta		wsync					;3	 =	 3
;---------------------------------------
	cpx		#$20					;2
	bcs		lf511					;2/3!
	bit		ram_9c					;3
	bmi		lf504					;2/3!
	txa								;2
	ldy		#$7e					;2
	and		#$0e					;2
	bne		lf4fd					;2/3
	ldy		#$ff					;2	 =	19
lf4fd
	sty		grp0					;3
	txa								;2
	eor		#$ff					;2
	sta		colup0					;3	 =	10
lf504
	inx								;2
	cpx		#$1d					;2
	bcc		lf4ea					;2/3!
	lda		#$00					;2
	sta		grp0					;3
	sta		grp1					;3
	beq		lf4a6					;2/3!=	16
lf511
	txa								;2
	sbc		#$90					;2
	cmp		#$0f					;2
	bcc		lf51b					;2/3
	jmp		lf1ea					;3	 =	11

lf51b
	lsr								;2
	lsr								;2
	tay								;2
	lda		lfef0,y					;4
	sta		grp0					;3
	stx		colup0					;3
	inx								;2
	bne		lf4ea					;2/3!
	lda		room_num				  ;3		 *
	asl								;2		   *
	tax								;2		   *
	lda		lfc89,x					;4		   *
	pha								;3		   *
	lda		lfc88,x					;4		   *
	pha								;3		   *
	rts								;6	 =	47 *

lf535:
       lda    #$7f                    ;2
       sta    $ce                     ;3
       sta    $d0                     ;3
       sta    $d2                     ;3
       bne    lf59a                   ;2 always branch

lf53f
       ldx    #$00                    ;2
       ldy    #$01                    ;2
       bit    cxp1fb                  ;3
       bmi    lf55b                   ;2
       bit    $b6                     ;3
       bmi    lf55b                   ;2
       lda    $82                     ;3
       and    #$07                    ;2
       bne    lf55e                   ;2
       ldy    #$05                    ;2
       lda    #$4c                    ;2
       sta    $cd                     ;3
       lda    #$23                    ;2
       sta    $d3                     ;3
lf55b:
       jsr    lf8b3                   ;6
lf55e:
       lda    #$80                    ;2
       sta    $93                     ;3
       lda    $ce                     ;3
       and    #$01                    ;2
       ror    $c8                     ;5
       rol                            ;2
       tay                            ;2
       ror                            ;2
       rol    $c8                     ;5
       lda    lfaea,y                 ;4
       sta    $dd                     ;3
       lda    #$fc    ;2
       sta    $de                     ;3
       lda    $8e                     ;3
       bmi    lf59a                   ;2
       ldx    #$50                    ;2
       stx    $ca                     ;3
       ldx    #$26                    ;2
       stx    $d0                     ;3
       lda    $b6                     ;3
       bmi    lf59a                   ;2
       bit    $9d                     ;3
       bmi    lf59a                   ;2
       and    #$07                    ;2
       bne    lf592                   ;2
       ldy    #$06                    ;2
       sty    $b6                     ;3
lf592:
       tax                            ;2
       lda    lfcd2,x                 ;4
       sta    $8e                     ;3
       dec    $b6                     ;5
lf59a:
       jmp    lf833                   ;3

lf59d:
       lda    #$80                    ;2
       sta    $93                     ;3
       ldx    #$00                    ;2
       bit    $9d                     ;3
       bmi    lf5ab                   ;2
       bit    $95                     ;3
       bvc    lf5b7                   ;2
lf5ab:
       ldy    #$05                    ;2
       lda    #$55                    ;2
       sta    $cd                     ;3
       sta    $d3                     ;3
       lda    #$01                    ;2
       bne    lf5bb                   ;2 always branch

lf5b7:
       ldy    #$01                    ;2
       lda    #$03                    ;2
lf5bb:
       and    $82                     ;3
       bne    lf5ce                   ;2
       jsr    lf8b3                   ;6
       lda    $ce                     ;3
       bpl    lf5ce                   ;2
       cmp    #$a0                    ;2
       bcc    lf5ce                   ;2
       inc    $ce                     ;5
       inc    $ce                     ;5
lf5ce:
       bvc    lf5de                   ;2
       lda    $ce                     ;3
       cmp    #$51                    ;2
       bcc    lf5de                   ;2
       lda    $95                     ;3
       sta    $99                     ;3
       lda    #$00                    ;2
       sta    $95                     ;3
lf5de:
       lda    $c8                     ;3
       cmp    $c9                     ;3
       bcs    lf5e7                   ;2
       dex                            ;2
       eor    #$03                    ;2
lf5e7:
       stx    refp0                   ;3
       and    #$03                    ;2
       asl                            ;2
       asl                            ;2
       asl                            ;2
       asl                            ;2
       sta    $dd                     ;3
       lda    $82                     ;3
       and    #$7f                    ;2
       bne    lf617                   ;2
       lda    $ce                     ;3
       cmp    #$4a                    ;2
       bcs    lf617                   ;2
       ldy    $98                     ;3
       beq    lf617                   ;2
       dey                            ;2
       sty    $98                     ;3
       ldy    #$8e                    ;2
       adc    #$03                    ;2
       sta    $d0                     ;3
       cmp    $cf                     ;3
       bcs    lf60f                   ;2
       dey                            ;2
lf60f:
       lda    $c8                     ;3
       adc    #$04                    ;2
       sta    $ca                     ;3
       sty    $8e                     ;3
lf617:
       ldy    #$7f                    ;2
       lda    $8e                     ;3
       bmi    lf61f                   ;2
       sty    $d0                     ;3
lf61f:
       lda    $d1                     ;3
       cmp    #$52                    ;2
       bcc    lf627                   ;2
       sty    $d1                     ;3
lf627:
       jmp    lf833                   ;3

lf62a:
       ldx    #$3a                    ;2
       stx    $e9                     ;3
       ldx    #$85                    ;2
       stx    $e3                     ;3
       ldx    #$03                    ;2 3 points (gained)
       stx    mesa_entered            ;3
       bne    lf63a                   ;2 always branch

lf638
       ldx    #$04                    ;2
lf63a:
       lda    lfcd8,x                 ;4
       and    $82                     ;3
       bne    lf656                   ;2
       ldy    $e5,x                   ;4
       lda    #$08                    ;2
       and    $df,x                   ;4
       bne    lf65c                   ;2
       dey                            ;2
       cpy    #$14                    ;2
       bcs    lf654                   ;2
lf64e:
       lda    #$08                    ;2
       eor    $df,x                   ;4
       sta    $df,x                   ;4
lf654:
       sty    $e5,x                   ;4
lf656:
       dex                            ;2
       bpl    lf63a                   ;2
       jmp    lf833                   ;3

lf65c:
       iny                            ;2
       cpy    #$85                    ;2
       bcs    lf64e                   ;2
       bcc    lf654                   ;2 always branch

lf663
       bit    $b4                     ;3
       bpl    lf685                   ;2
       bvc    lf66d                   ;2
       dec    $c9                     ;5
       bne    lf685                   ;2
lf66d:
       lda    $82                     ;3
       ror                            ;2
       bcc    lf685                   ;2
       lda    swcha                   ;4
       sta    $92                     ;3
       ror                            ;2
       ror                            ;2
       ror                            ;2
       bcs    lf680                   ;2
       dec    $c9                     ;5
       bne    lf685                   ;2
lf680:
       ror                            ;2
       bcs    lf685                   ;2
       inc    $c9                     ;5
lf685:
       lda    #$02                    ;2
       and    $b4                     ;3
       bne    lf691                   ;2
       sta    $8d                     ;3
       lda    #$0b                    ;2
       sta    $ce                     ;3
lf691:
       ldx    $cf                     ;3
       lda    $82                     ;3
       bit    $b4                     ;3
       bmi    lf6a3                   ;2
       cpx    #$15                    ;2
       bcc    lf6a3                   ;2
       cpx    #$30                    ;2
       bcc    lf6aa                   ;2
       bcs    lf6a9                   ;2 always branch

lf6a3:
       ror                            ;2
       bcc    lf6aa                   ;2
lf6a6:
       jmp    lf833                   ;3

lf6a9:
       inx                            ;2
lf6aa:
       inx                            ;2
       stx    $cf                     ;3
       bne    lf6a6                   ;2 always branch

lf6af:
       lda    $c9                     ;3
       cmp    #$64                    ;2
       bcc    lf6bc                   ;2
       rol    $b2                     ;5
       clc                            ;2
       ror    $b2                     ;5
       bpl    lf6de                   ;2
lf6bc:
       cmp    #$2c                    ;2
       beq    lf6c6                   ;2
       lda    #$7f                    ;2
       sta    $d2                     ;3
       bne    lf6de                   ;2 always branch

lf6c6:
       bit    $b2                     ;3
       bmi    lf6de                   ;2
       lda    #$30                    ;2
       sta    $cc                     ;3
       ldy    #$00                    ;2
       sty    $d2                     ;3
       ldy    #$7f                    ;2
       sty    $dc                     ;3
       sty    $d5                     ;3
       inc    $c9                     ;5
       lda    #$80                    ;2
       sta    $9d                     ;3
lf6de:
       jmp    lf833                   ;3

lf6e1:
       ldy    $df                     ;3
       dey                            ;2
       bne    lf6de                   ;2
       lda    $af                     ;3
       and    #$07                    ;2
       bne    lf71d                   ;2
       lda    #$40                    ;2
       sta    $93                     ;3
       lda    $83                     ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       tax                            ;2
       ldy    lfcdc,x                 ;4
       ldx    lfcaa,y                 ;4
       sty    $84                     ;3
       jsr    lf89d                   ;6
       bcc    lf70a                   ;2
lf705:
       inc    $df                     ;5
       bne    lf6de                   ;2 always branch


       .byte $00 ; |        | $f709 unused


lf70a:
       ldy    $84                     ;3
       tya                            ;2
       ora    $af                     ;3
       sta    $af                     ;3
       lda    lfca2,y                 ;4
       sta    $ce                     ;3
       lda    lfca6,y                 ;4
       sta    $df                     ;3
       bne    lf6de                   ;2 always branch

lf71d:
       cmp    #$04                    ;2
       bcs    lf705                   ;2
       rol    $af                     ;5
       sec                            ;2
       ror    $af                     ;5
       bmi    lf705                   ;2 always branch

lf728: ;map room stuff...
       ldy    #$00                    ;2
       sty    $d2                     ;3
       ldy    #$7f                    ;2
       sty    $dc                     ;3
       sty    $d5                     ;3
       lda    #$71                    ;2
       sta    $cc                     ;3
       ldy    #$4f                    ;2
       lda    #$3a                    ;2
       cmp    $cf                     ;3
       bne    lf74a                   ;2
       lda    current_object          ;3
       cmp    #$07                    ;2 is object the key?
       beq    lf74c                   ;2  ...branch if so
       lda    #$5e                    ;2
       cmp    $c9                     ;3
       beq    lf74c                   ;2
lf74a:
       ldy    #$0d                    ;2
lf74c:
       sty    $df                     ;3
       lda    $83                     ;3
       sec                            ;2
       sbc    #$10                    ;2
       bpl    lf75a                   ;2
       eor    #$ff                    ;2
       sec                            ;2
       adc    #$00                    ;2
lf75a:
       cmp    #$0b                    ;2
       bcc    lf760                   ;2
       lda    #$0b                    ;2
lf760:
       sta    $ce                     ;3
       bit    $b3                     ;3
       bpl    lf78b                   ;2
       cmp    #$08                    ;2
       bcs    lf787                   ;2
       ldx    current_object          ;3
       cpx    #$0e                    ;2 is object the headpiece (revealing the ark's location)
       bne    lf787                   ;2  ...branch if not
       stx    ark_found               ;3 14 points (gained)...shared from existing compare val.
       lda    #$04                    ;2
       and    $82                     ;3
       bne    lf787                   ;2
       lda    $8c                     ;3
       and    #$0f                    ;2
       tax                            ;2
       lda    lfac2,x                 ;4
       sta    $cb                     ;3
       lda    lfad2,x                 ;4
       bne    lf789                   ;2 always branch

lf787:
       lda    #$70                    ;2
lf789:
       sta    $d1                     ;3
lf78b:
       rol    $b3                     ;5
       lda    #$3a                    ;2
       cmp    $cf                     ;3
       bne    lf7a2                   ;2
       cpy    #$4f                    ;2
       beq    lf79d                   ;2
       lda    #$5e                    ;2
       cmp    $c9                     ;3
       bne    lf7a2                   ;2
lf79d:
       sec                            ;2
       ror    $b3                     ;5
       bmi    lf7a5                   ;2
lf7a2:
       clc                            ;2
       ror    $b3                     ;5
lf7a5:
       jmp    lf833                   ;3

lf7a8:
       lda    #$08                    ;2
       and    $c7                     ;3
       bne    lf7c0                   ;2
       lda    #$4c                    ;2
       sta    $cc                     ;3
       lda    #$2a                    ;2
       sta    $d2                     ;3
       lda    #$ba                    ;2
       sta    $d6                     ;3
       lda    #$fa                    ;2
       sta    $d7                     ;3
       bne    lf7c4                   ;2 always branch

lf7c0:
       lda    #$f0                    ;2
       sta    $d2                     ;3
lf7c4:
       lda    $b5                     ;3
       and    #$0f                    ;2
       beq    lf833                   ;2
       sta    $dc                     ;3
       ldy    #$14                    ;2
       sty    $ce                     ;3
       ldy    #$3b                    ;2
       sty    $e0                     ;3
       iny                            ;2
       sty    $d4                     ;3
       lda    #$c1                    ;2
       sec                            ;2
       sbc    $dc                     ;3
       sta    $dd                     ;3
       bne    lf833                   ;2 always branch

lf7e0:
       lda    $82                     ;3
       and    #$18                    ;2
       adc    #$e0                    ;2
       sta    $dd                     ;3
       lda    $82                     ;3
       and    #$07                    ;2
       bne    lf80f                   ;2
       ldx    #$00                    ;2
       ldy    #$01                    ;2
       lda    $cf                     ;3
       cmp    #$3a                    ;2
       bcc    lf80c                   ;2
       lda    $c9                     ;3
       cmp    #$2b                    ;2
       bcc    lf802                   ;2
       cmp    #$6d                    ;2
       bcc    lf80c                   ;2
lf802:
       ldy    #$05                    ;2
       lda    #$4c                    ;2
       sta    $cd                     ;3
       lda    #$0b                    ;2
       sta    $d3                     ;3
lf80c:
       jsr    lf8b3                   ;6
lf80f:
       ldx    #$4e                    ;2 lowest spot of the screen
       cpx    $cf                     ;3 compare against player's vertical location
       bne    lf833                   ;2  ...branch if not the same
       ldx    $c9                     ;3 check horizontal location...
       cpx    #$76                    ;2
       beq    lf81f                   ;2
       cpx    #$14                    ;2
       bne    lf833                   ;2 skip if not over either escape hatch
lf81f:
       lda    swcha                   ;4
       and    #$0f                    ;2
       cmp    #$0d                    ;2 down pressed?
       bne    lf833                   ;2  ...branch if not
       sta    escape_hatch_used       ;3 13 points (lost)...shared from existing joystick dir.
       lda    #$4c                    ;2  reset horizontal location to center
       sta    $c9                     ;3
       ror    $b5                     ;5
       sec                            ;2
       rol    $b5                     ;5
lf833
       lda    #<ld80d                 ;2
       sta    $88                     ;3
       lda    #>ld80d                 ;2
       sta    $89                     ;3
       jmp    lf493                   ;3

lf83e
       lda    #$40                    ;2
       sta    $93                     ;3
       bne    lf833                   ;2 always branch

draw_field
	sta		wsync					;3	 =	 3
;---------------------------------------
	sta		hmclr					;3
	sta		cxclr					;3
	ldy		#$ff					;2
	sty		pf1						;3
	sty		pf2						;3
	ldx		room_num				  ;3
	lda		room_pf0_gfx,x					;4
	sta		pf0						;3
	iny								;2
	sta		wsync					;3	 =	29
;---------------------------------------
	sta		hmove					;3
	sty		vblank					;3
	sty		scan_line				   ;3
	cpx		#$04					;2
	bne		lf865					;2/3
	dey								;2	 =	15 *
lf865
	sty		enabl					;3
	cpx		#$0d					;2
	beq		lf874					;2/3
	bit		ram_9d					;3		   *
	bmi		lf874					;2/3	   *
	ldy		swcha					;4		   *
	sty		refp1					;3	 =	19 *
lf874
	sta		wsync					;3	 =	 3
;---------------------------------------
	sta		hmove					;3
	sta		wsync					;3	 =	 6
;---------------------------------------
	sta		hmove					;3
	ldy		room_num				  ;3
	sta		wsync					;3	 =	 9
;---------------------------------------
	sta		hmove					;3
	lda		room_pf1_gfx,y					;4
	sta		pf1						;3
	lda		room_pf2_gfx,y					;4
	sta		pf2						;3
	ldx		lf9ee,y					;4
	lda		lfae2+1,x				;4
	pha								;3
	lda		lfae2,x					;4
	pha								;3
	lda		#$00					;2
	tax								;2
	sta		ram_84					;3
	rts								;6	 =	48

lf89d:
       lda    lfc75,x                 ;4
       lsr                            ;2
       tay                            ;2
       lda    lfce2,y                 ;4
       bcs    lf8ad                   ;2
       and    $c6                     ;3
       beq    lf8ac                   ;2
       sec                            ;2
lf8ac
       rts                            ;6

lf8ad									;called dynamically 
       and    $c7                     ;and c7
       bne    lf8ac                   ;return if 0
       clc                            ;if not, clear carry
       rts                            ;return 



lf8b3
	cpy		#$01					;2		   *
	bne		lf8bb					;2/3	   *
	lda		indy_y					;3		   *
	bmi		lf8cc					;2/3 =	 9 *
lf8bb
	lda		enemy_y,x				 ;4			*
	cmp.wy	enemy_y,y				 ;4			*
	bne		lf8c6					;2/3	   *
	cpy		#$05					;2		   *
	bcs		lf8ce					;2/3 =	14 *
lf8c6
	bcs		lf8cc					;2/3	   *
	inc		enemy_y,x				 ;6			*
	bne		lf8ce					;2/3 =	10 *
lf8cc
	dec		enemy_y,x				 ;6	  =	  6 *
lf8ce
	lda		enemy_x,x				 ;4			*
	cmp.wy	enemy_x,y				 ;4			*
	bne		lf8d9					;2/3	   *
	cpy		#$05					;2		   *
	bcs		lf8dd					;2/3 =	14 *
lf8d9
	bcs		lf8de					;2/3	   *
	inc		enemy_x,x				 ;6	  =	  8 *
lf8dd
	rts								;6	 =	 6 *

lf8de
	dec		enemy_x,x				 ;6			*
	rts								;6	 =	12 *

lf8e1
	lda		enemy_y,x				 ;4			*
	cmp		#$53					;2		   *
	bcc		lf8f1					;2/3 =	 8 *
lf8e7
	rol		ram_8c,x				;6		   *
	clc								;2		   *
	ror		ram_8c,x				;6		   *
	lda		#$78					;2		   *
	sta		enemy_y,x				 ;4			*
	rts								;6	 =	26 *

lf8f1
	lda		enemy_x,x				 ;4			*
	cmp		#$10					;2		   *
	bcc		lf8e7					;2/3	   *
	cmp		#$8e					;2		   *
	bcs		lf8e7					;2/3	   *
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


;map room
	.byte	$94 ; |#  # #  |
	.byte	$00 ; |		   |
	.byte	$08 ; |	   #   |
	.byte	$1c ; |	  ###  |
	.byte	$3e ; |	 ##### |
	.byte	$3e ; |	 ##### |
	.byte	$3e ; |	 ##### |
	.byte	$3e ; |	 ##### |
	.byte	$1c ; |	  ###  |
	.byte	$08 ; |	   #   |
	.byte	$00 ; |		   |
	.byte	$8e ; |#   ### |
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$14 ; |	  # #  |
	.byte	$14 ; |	  # #  |
	.byte	$00 ; |		   |
	.byte	$00 ; |		   |
	.byte	$2a ; |	 # # # |
	.byte	$2a ; |	 # # # |
	.byte	$00 ; |		   |
	.byte	$00 ; |		   |
	.byte	$14 ; |	  # #  |
	.byte	$36 ; |	 ## ## |
	.byte	$22 ; |	 #	 # |
	.byte	$08 ; |	   #   |
	.byte	$08 ; |	   #   |
	.byte	$3e ; |	 ##### |
	.byte	$1c ; |	  ###  |
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
	.byte	$6b ; | ## # ##|
	.byte	$6b ; | ## # ##|
	.byte	$08 ; |	   #   |
	.byte	$00 ; |		   |
	.byte	$22 ; |	 #	 # |
	.byte	$22 ; |	 #	 # |
	.byte	$00 ; |		   |
	.byte	$00 ; |		   |
	.byte	$08 ; |	   #   |
	.byte	$1c ; |	  ###  |
	.byte	$1c ; |	  ###  |
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$e4 ; |###	#  |
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
	.byte	$7f ; | #######|
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
	.byte	$7f ; | #######|
	.byte	$7f ; | #######|
	.byte	$00 ; |		   |
	.byte	$86 ; |#	## |
	.byte	$24 ; |	 #	#  |
	.byte	$18 ; |	  ##   |
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
	.byte	$1c ; |	  ###  |			$f9fc (g)
	.byte	$36 ; |	 ## ## |			$f9fd (g)
	.byte	$63 ; | ##	 ##|			$f9fe (g)
	.byte	$36 ; |	 ## ## |			$f9ff (g)

	.byte	$18 ; |	  xx   |			$fa00 (g)
	.byte	$3c ; |	 xxxx  |			$fa01 (g)
	.byte	$00 ; |		   |			$fa02 (g)
	.byte	$18 ; |	  xx   |			$fa03 (g)
	.byte	$1c ; |	  xxx  |			$fa04 (g)
	.byte	$18 ; |	  xx   |			$fa05 (g)
	.byte	$18 ; |	  xx   |			$fa06 (g)
	.byte	$0c ; |	   xx  |			$fa07 (g)
	.byte	$62 ; | xx	 x |			$fa08 (g)
	.byte	$43 ; | x	 xx|			$fa09 (g)
	.byte	$00 ; |		   |			$fa0a (g)

	.byte	$18 ; |	  xx   |			$fa0b (g)
	.byte	$3c ; |	 xxxx  |			$fa0c (g)
	.byte	$00 ; |		   |			$fa0d (g)
	.byte	$18 ; |	  xx   |			$fa0e (g)
	.byte	$38 ; |	 xxx   |			$fa0f (g)
	.byte	$1c ; |	  xxx  |			$fa10 (g)
	.byte	$18 ; |	  xx   |			$fa11 (g)
	.byte	$14 ; |	  x x  |			$fa12 (g)
	.byte	$64 ; | xx	x  |			$fa13 (g)
	.byte	$46 ; | x	xx |			$fa14 (g)
	.byte	$00 ; |		   |			$fa15 (g)

	.byte	$18 ; |	  xx   |			$fa16 (g)
	.byte	$3c ; |	 xxxx  |			$fa17 (g)
	.byte	$00 ; |		   |			$fa18 (g)
	.byte	$38 ; |	 xxx   |			$fa19 (g)
	.byte	$38 ; |	 xxx   |			$fa1a (g)
	.byte	$18 ; |	  xx   |			$fa1b (g)
	.byte	$18 ; |	  xx   |			$fa1c (g)
	.byte	$28 ; |	 x x   |			$fa1d (g)
	.byte	$48 ; | x  x   |			$fa1e (g)
	.byte	$8c ; |x   xx  |			$fa1f (g)
	.byte	$00 ; |		   |			$fa20 (g)

	.byte	$18 ; |	  xx   |			$fa21 (g)
	.byte	$3c ; |	 xxxx  |			$fa22 (g)
	.byte	$00 ; |		   |			$fa23 (g)
	.byte	$38 ; |	 xxx   |			$fa24 (g)
	.byte	$58 ; | x xx   |			$fa25 (g)
	.byte	$38 ; |	 xxx   |			$fa26 (g)
	.byte	$10 ; |	  x	   |			$fa27 (g)
	.byte	$e8 ; |xxx x   |			$fa28 (g)
	.byte	$88 ; |x   x   |			$fa29 (g)
	.byte	$0c ; |	   xx  |			$fa2a (g)
	.byte	$00 ; |		   |			$fa2b (g)

	.byte	$18 ; |	  xx   |			$fa2c (g)
	.byte	$3c ; |	 xxxx  |			$fa2d (g)
	.byte	$00 ; |		   |			$fa2e (g)
	.byte	$30 ; |	 xx	   |			$fa2f (g)
	.byte	$78 ; | xxxx   |			$fa30 (g)
	.byte	$34 ; |	 xx x  |			$fa31 (g)
	.byte	$18 ; |	  xx   |			$fa32 (g)
	.byte	$60 ; | xx	   |			$fa33 (g)
	.byte	$50 ; | x x	   |			$fa34 (g)
	.byte	$18 ; |	  xx   |			$fa35 (g)
	.byte	$00 ; |		   |			$fa36 (g)

	.byte	$18 ; |	  xx   |			$fa37 (g)
	.byte	$3c ; |	 xxxx  |			$fa38 (g)
	.byte	$00 ; |		   |			$fa39 (g)
	.byte	$30 ; |	 xx	   |			$fa3a (g)
	.byte	$38 ; |	 xxx   |			$fa3b (g)
	.byte	$3c ; |	 xxxx  |			$fa3c (g)
	.byte	$18 ; |	  xx   |			$fa3d (g)
	.byte	$38 ; |	 xxx   |			$fa3e (g)
	.byte	$20 ; |	 x	   |			$fa3f (g)
	.byte	$30 ; |	 xx	   |			$fa40 (g)
	.byte	$00 ; |		   |			$fa41 (g)

	.byte	$18 ; |	  xx   |			$fa42 (g)
	.byte	$3c ; |	 xxxx  |			$fa43 (g)
	.byte	$00 ; |		   |			$fa44 (g)
	.byte	$18 ; |	  xx   |			$fa45 (g)
	.byte	$38 ; |	 xxx   |			$fa46 (g)
	.byte	$1c ; |	  xxx  |			$fa47 (g)
	.byte	$18 ; |	  xx   |			$fa48 (g)
	.byte	$2c ; |	 x xx  |			$fa49 (g)
	.byte	$20 ; |	 x	   |			$fa4a (g)
	.byte	$30 ; |	 xx	   |			$fa4b (g)
	.byte	$00 ; |		   |			$fa4c (g)

	.byte	$18 ; |	  xx   |			$fa4d (g)
	.byte	$3c ; |	 xxxx  |			$fa4e (g)
	.byte	$00 ; |		   |			$fa4f (g)
	.byte	$18 ; |	  xx   |			$fa50 (g)
	.byte	$18 ; |	  xx   |			$fa51 (g)
	.byte	$18 ; |	  xx   |			$fa52 (g)
	.byte	$08 ; |	   x   |			$fa53 (g)
	.byte	$16 ; |	  x xx |			$fa54 (g)
	.byte	$30 ; |	 xx	   |			$fa55 (g)
	.byte	$20 ; |	 x	   |			$fa56 (g)
	.byte	$00 ; |		   |			$fa57 (g)

indy_sprite
	.byte	$18 ; |	  ##   |			$fa58 (g)
	.byte	$3c ; |	 ####  |			$fa59 (g)
	.byte	$00 ; |		   |			$fa5a (g)
	.byte	$18 ; |	  ##   |			$fa5b (g)
	.byte	$3c ; |	 ####  |			$fa5c (g)
	.byte	$5a ; | # ## # |			$fa5d (g)
	.byte	$3c ; |	 ####  |			$fa5e (g)
	.byte	$18 ; |	  ##   |			$fa5f (g)
	.byte	$18 ; |	  ##   |			$fa60 (g)
	.byte	$3c ; |	 ####  |			$fa61 (g)
	.byte	$00 ; |		   |			$fa62 (g)

	.byte	$3c ; |	 ####  |			$fa63 (g)
	.byte	$7e ; | ###### |			$fa64 (g)
	.byte	$ff ; |########|			$fa65 (g)
	.byte	$a5 ; |# #	# #|			$fa66 (g)
	.byte	$42 ; | #	 # |			$fa67 (g)
	.byte	$42 ; | #	 # |			$fa68 (g)
	.byte	$18 ; |	  ##   |			$fa69 (g)
	.byte	$3c ; |	 ####  |			$fa6a (g)
	.byte	$81 ; |#	  #|			$fa6b (g)
	.byte	$5a ; | # ## # |			$fa6c (g)
	.byte	$3c ; |	 ####  |			$fa6d (g)
	.byte	$3c ; |	 ####  |			$fa6e (g)
	.byte	$38 ; |	 ###   |			$fa6f (g)
	.byte	$18 ; |	  ##   |			$fa70 (g)
	.byte	$00 ; |		   |			$fa71 (g)



	.byte	$10,$10,$00,$f0,$f0,$00,$10,$00 ; $fa72 (*)
	.byte	$10,$10,$00,$f0,$00,$10,$10,$00 ; $fa7a (*)
	.byte	$10,$00,$f0,$f0,$00,$f0,$f0,$00 ; $fa82 (*)
	.byte	$f0,$f0,$00,$10,$10,$00,$f0		; $fa8a (*)

room_pf1_gfx
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

room_pf2_gfx
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

room_pf0_gfx
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

	.byte	$f7,$f7,$f7,$f7,$f7,$37,$37,$00 ; $faba (*)
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
blank_gfx ; blank space
	.byte	$00 ; |		   |			$fb00 (g)
	.byte	$00 ; |		   |			$fb01 (g)
	.byte	$00 ; |		   |			$fb02 (g)
	.byte	$00 ; |		   |			$fb03 (g)
	.byte	$00 ; |		   |			$fb04 (g)
	.byte	$00 ; |		   |			$fb05 (g)
	.byte	$00 ; |		   |			$fb06 (g)
	.byte	$00 ; |		   |			$fb07 (g)

copyright_gfx_3: ;copyright3
	.byte	$71 ; | ###	  #|			$fb08 (g)
	.byte	$41 ; | #	  #|			$fb09 (g)
	.byte	$41 ; | #	  #|			$fb0a (g)
	.byte	$71 ; | ###	  #|			$fb0b (g)
	.byte	$11 ; |	  #	  #|			$fb0c (g)
	.byte	$51 ; | # #	  #|			$fb0d (g)
	.byte	$70 ; | ###	   |			$fb0e (g)
	.byte	$00 ; |		   |			$fb0f (g)

	.byte	$00 ; |		   |			$fb10 (g)
	.byte	$01 ; |		  #|			$fb11 (g)
	.byte	$3f ; |	 ######|			$fb12(g)
	.byte	$6b ; | ## # ##|			$fb12 (g)
	.byte	$7f ; | #######|			$fb13 (g)
	.byte	$01 ; |		  #|			$fb14 (g)
	.byte	$00 ; |		   |			$fb15 (g)
	.byte	$00 ; |		   |			$fb16 (g)

	.byte	$77 ; | ### ###|			$fb17 (g)
	.byte	$77 ; | ### ###|			$fb18 (g)
	.byte	$77 ; | ### ###|			$fb19 (g)
	.byte	$00 ; |		   |			$fb1a (g)
	.byte	$00 ; |		   |			$fb1b (g)
	.byte	$77 ; | ### ###|			$fb1c (g)
	.byte	$77 ; | ### ###|			$fb1d (g)
	.byte	$77 ; | ### ###|			$fb1e (g)

lfb20: ;bag of gold
	.byte	$1c ; |	  ###  |			$fb1f (g)
	.byte	$2a ; |	 # # # |			$fb20 (g)
	.byte	$55 ; | # # # #|			$fb21 (g)
	.byte	$2a ; |	 # # # |			$fb22 (g)
	.byte	$55 ; | # # # #|			$fb23 (g)
	.byte	$2a ; |	 # # # |			$fb24 (g)
	.byte	$1c ; |	  ###  |			$fb25 (g)
	.byte	$3e ; |	 ##### |			$fb26 (g)

	.byte	$3a ; |	 ### # |			$fb27 (g)
	.byte	$01 ; |		  #|			$fb28 (g)
	.byte	$7d ; | ##### #|			$fb29 (g)
	.byte	$01 ; |		  #|			$fb2a (g)
	.byte	$39 ; |	 ###  #|			$fb2b (g)
	.byte	$02 ; |		 # |			$fb2c (g)
	.byte	$3c ; |	 ####  |			$fb2d (g)
	.byte	$30 ; |	 ##	   |			$fb2e (g)

	.byte	$2e ; |	 # ### |			$fb2f (g)
	.byte	$40 ; | #	   |			$fb30 (g)
	.byte	$5f ; | # #####|			$fb31 (g)
	.byte	$40 ; | #	   |			$fb32 (g)
	.byte	$4e ; | #  ### |			$fb33 (g)
	.byte	$20 ; |	 #	   |			$fb34 (g)
	.byte	$1e ; |	  #### |			$fb35 (g)
	.byte	$06 ; |		## |			$fb36 (g)

	.byte	$00 ; |		   |			$fb37 (g)
	.byte	$25 ; |	 #	# #|			$fb38 (g)
	.byte	$52 ; | # #	 # |			$fb39 (g)
	.byte	$7f ; | #######|			$fb3a (g)
	.byte	$50 ; | # #	   |			$fb3b (g)
	.byte	$20 ; |	 #	   |			$fb3c (g)
	.byte	$00 ; |		   |			$fb3d (g)
	.byte	$00 ; |		   |			$fb3e (g)

lfb40
	.byte	$ff ; |########|			$fb40 (g)
	.byte	$66 ; | ##	## |			$fb41 (g)
	.byte	$24 ; |	 #	#  |			$fb42 (g)
	.byte	$24 ; |	 #	#  |			$fb43 (g)
	.byte	$66 ; | ##	## |			$fb44 (g)
	.byte	$e7 ; |###	###|			$fb45 (g)
	.byte	$c3 ; |##	 ##|			$fb46 (g)
	.byte	$e7 ; |###	###|			$fb47 (g)

copyright_gfx_2: ;copyright2
	.byte	$17 ; |	  # ###|			$fb48 (g)
	.byte	$15 ; |	  # # #|			$fb49 (g)
	.byte	$15 ; |	  # # #|			$fb4a (g)
	.byte	$77 ; | ### ###|			$fb4b (g)
	.byte	$55 ; | # # # #|			$fb4c (g)
	.byte	$55 ; | # # # #|			$fb4d (g)
	.byte	$77 ; | ### ###|			$fb4e (g)
	.byte	$00 ; |		   |			$fb4f (g)

	.byte	$21 ; |	 #	  #|			$fb50 (g)
	.byte	$11 ; |	  #	  #|			$fb51 (g)
	.byte	$09 ; |	   #  #|			$fb52 (g)
	.byte	$11 ; |	  #	  #|			$fb53 (g)
	.byte	$22 ; |	 #	 # |			$fb54 (g)
	.byte	$44 ; | #	#  |			$fb55 (g)
	.byte	$28 ; |	 # #   |			$fb56 (g)
	.byte	$10 ; |	  #	   |			$fb57 (g)

	.byte	$01 ; |		  #|			$fb58 (g)
	.byte	$03 ; |		 ##|			$fb59 (g)
	.byte	$07 ; |		###|			$fb5a (g)
	.byte	$0f ; |	   ####|			$fb5b (g)
	.byte	$06 ; |		## |			$fb5c (g)
	.byte	$0c ; |	   ##  |			$fb5d (g)
	.byte	$18 ; |	  ##   |			$fb5e (g)
	.byte	$3c ; |	 ####  |			$fb5f (g)

copyright_gfx_1: ;copyright1
	.byte	$79 ; | ####  #|			$fb60 (g)
	.byte	$85 ; |#	# #|			$fb61 (g)
	.byte	$b5 ; |# ## # #|			$fb62 (g)
	.byte	$a5 ; |# #	# #|			$fb63 (g)
	.byte	$b5 ; |# ## # #|			$fb64 (g)
	.byte	$85 ; |#	# #|			$fb65 (g)
	.byte	$79 ; | ####  #|			$fb66 (g)
	.byte	$00 ; |		   |			$fb67 (g)

	.byte	$00 ; |		   |			$fb68 (g)
	.byte	$60 ; | ##	   |			$fb69 (g)
	.byte	$60 ; | ##	   |			$fb6a (g)
	.byte	$78 ; | ####   |			$fb6b (g)
	.byte	$68 ; | ## #   |			$fb6c (g)
	.byte	$3f ; |	 ######|			$fb6d (g)
	.byte	$5f ; | # #####|			$fb6e (g)
	.byte	$00 ; |		   |			$fb6f (g)

	.byte	$08 ; |	   #   |			$fb70 (g)
	.byte	$1c ; |	  ###  |			$fb71 (g)
	.byte	$22 ; |	 #	 # |			$fb72 (g)
	.byte	$49 ; | #  #  #|			$fb73 (g)
	.byte	$6b ; | ## # ##|			$fb74 (g)
	.byte	$00 ; |		   |			$fb75 (g)
	.byte	$1c ; |	  ###  |			$fb76 (g)
	.byte	$08 ; |	   #   |			$fb77 (g)

lfb78: ; unopen pocket watch
	.byte	$7f ; | #######|			$fb78 (g)
	.byte	$5d ; | # ### #|			$fb79 (g)
	.byte	$77 ; | ### ###|			$fb7a (g)
	.byte	$77 ; | ### ###|			$fb7b (g)
	.byte	$5d ; | # ### #|			$fb7c (g)
	.byte	$7f ; | #######|			$fb7d (g)
	.byte	$08 ; |	   #   |			$fb7e (g)
	.byte	$1c ; |	  ###  |			$fb7f (g)

	.byte	$3e ; |	 ##### |			$fb80 (g)
	.byte	$1c ; |	  ###  |			$fb81 (g)
	.byte	$49 ; | #  #  #|			$fb82 (g)
	.byte	$7f ; | #######|			$fb83 (g)
	.byte	$49 ; | #  #  #|			$fb84 (g)
	.byte	$1c ; |	  ###  |			$fb85 (g)
	.byte	$36 ; |	 ## ## |			$fb86 (g)
	.byte	$1c ; |	  ###  |			$fb87 (g)

	.byte	$16 ; |	  # ## |			$fb88 (g)
	.byte	$0b ; |	   # ##|			$fb89 (g)
	.byte	$0d ; |	   ## #|			$fb8a (g)
	.byte	$05 ; |		# #|			$fb8b (g)
	.byte	$17 ; |	  # ###|			$fb8c (g)
	.byte	$36 ; |	 ## ## |			$fb8d (g)
	.byte	$64 ; | ##	#  |			$fb8e (g)
	.byte	$04 ; |		#  |			$fb8f (g)

	.byte	$77 ; | ### ###|			$fb90 (g)
	.byte	$36 ; |	 ## ## |			$fb91 (g)
	.byte	$14 ; |	  # #  |			$fb92 (g)
	.byte	$22 ; |	 #	 # |			$fb93 (g)
	.byte	$22 ; |	 #	 # |			$fb94 (g)
	.byte	$14 ; |	  # #  |			$fb95 (g)
	.byte	$36 ; |	 ## ## |			$fb96 (g)
	.byte	$77 ; | ### ###|			$fb97 (g)

lfb98: ;timepiece bitmaps...
	.byte	$3e ; |	 ##### |			$fb98 (g)
	.byte	$41 ; | #	  #|			$fb99 (g)
	.byte	$41 ; | #	  #|			$fb9a (g)
	.byte	$49 ; | #  #  #|			$fb9b (g)
	.byte	$49 ; | #  #  #|			$fb9c (g)
	.byte	$49 ; | #  #  #|			$fb9d (g)
	.byte	$3e ; |	 ##### |			$fb9e (g)
	.byte	$1c ; |	  ###  |			$fb9f (g)

	.byte	$3e ; |	 ##### |			$fba0 (g)
	.byte	$41 ; | #	  #|			$fba1 (g)
	.byte	$41 ; | #	  #|			$fba2 (g)
	.byte	$49 ; | #  #  #|			$fba3 (g)
	.byte	$45 ; | #	# #|			$fba4 (g)
	.byte	$43 ; | #	 ##|			$fba5 (g)
	.byte	$3e ; |	 ##### |			$fba6 (g)
	.byte	$1c ; |	  ###  |			$fba7 (g)

	.byte	$3e ; |	 ##### |			$fba8 (g)
	.byte	$41 ; | #	  #|			$fba9 (g)
	.byte	$41 ; | #	  #|			$fbaa (g)
	.byte	$4f ; | #  ####|			$fbab (g)
	.byte	$41 ; | #	  #|			$fbac (g)
	.byte	$41 ; | #	  #|			$fbad (g)
	.byte	$3e ; |	 ##### |			$fbae (g)
	.byte	$1c ; |	  ###  |			$fbaf (g)

	.byte	$3e ; |	 ##### |			$fbb0 (g)
	.byte	$43 ; | #	 ##|			$fbb1 (g)
	.byte	$45 ; | #	# #|			$fbb2 (g)
	.byte	$49 ; | #  #  #|			$fbb3 (g)
	.byte	$41 ; | #	  #|			$fbb4 (g)
	.byte	$41 ; | #	  #|			$fbb5 (g)
	.byte	$3e ; |	 ##### |			$fbb6 (g)
	.byte	$1c ; |	  ###  |			$fbb7 (g)

	.byte	$3e ; |	 ##### |			$fbb8 (g)
	.byte	$49 ; | #  #  #|			$fbb9 (g)
	.byte	$49 ; | #  #  #|			$fbba (g)
	.byte	$49 ; | #  #  #|			$fbbb (g)
	.byte	$41 ; | #	  #|			$fbbc (g)
	.byte	$41 ; | #	  #|			$fbbd (g)
	.byte	$3e ; |	 ##### |			$fbbe (g)
	.byte	$1c ; |	  ###  |			$fbbf (g)

	.byte	$3e ; |	 ##### |			$fbc0 (g)
	.byte	$61 ; | ##	  #|			$fbc1 (g)
	.byte	$51 ; | # #	  #|			$fbc2 (g)
	.byte	$49 ; | #  #  #|			$fbc3 (g)
	.byte	$41 ; | #	  #|			$fbc4 (g)
	.byte	$41 ; | #	  #|			$fbc5 (g)
	.byte	$3e ; |	 ##### |			$fbc6 (g)
	.byte	$1c ; |	  ###  |			$fbc7 (g)

	.byte	$3e ; |	 ##### |			$fbc8 (g)
	.byte	$41 ; | #	  #|			$fbc9 (g)
	.byte	$41 ; | #	  #|			$fbca (g)
	.byte	$79 ; | ####  #|			$fbcb (g)
	.byte	$41 ; | #	  #|			$fbcc (g)
	.byte	$41 ; | #	  #|			$fbcd (g)
	.byte	$3e ; |	 ##### |			$fbce (g)
	.byte	$1c ; |	  ###  |			$fbcf (g)

	.byte	$3e ; |	 ##### |			$fbd0 (g)
	.byte	$41 ; | #	  #|			$fbd1 (g)
	.byte	$41 ; | #	  #|			$fbd2 (g)
	.byte	$49 ; | #  #  #|			$fbd3 (g)
	.byte	$51 ; | # #	  #|			$fbd4 (g)
	.byte	$61 ; | ##	  #|			$fbd5 (g)
	.byte	$3e ; |	 ##### |			$fbd6 (g)
	.byte	$1c ; |	  ###  |			$fbd7 (g)

copyright_gfx_4: ;copyright4
	.byte	$49 ; | #  #  #|			$fbd8 (g)
	.byte	$49 ; | #  #  #|			$fbd9 (g)
	.byte	$49 ; | #  #  #|			$fbda (g)
	.byte	$c9 ; |##  #  #|			$fbdb (g)
	.byte	$49 ; | #  #  #|			$fbdc (g)
	.byte	$49 ; | #  #  #|			$fbdd (g)
	.byte	$be ; |# ##### |			$fbde (g)
	.byte	$00 ; |		   |			$fbdf (g)

copyright_gfx_5: ;copyright5
	.byte	$55 ; | # # # #|			$fbe0 (g)
	.byte	$55 ; | # # # #|			$fbe1 (g)
	.byte	$55 ; | # # # #|			$fbe2 (g)
	.byte	$d9 ; |## ##  #|			$fbe3 (g)
	.byte	$55 ; | # # # #|			$fbe4 (g)
	.byte	$55 ; | # # # #|			$fbe5 (g)
	.byte	$99 ; |#  ##  #|			$fbe6 (g)
	.byte	$00 ; |		   |			$fbe7 (g)

lfbe8
	.byte	$14								; $fbe8 (d)
	.byte	$14,$14,$0f,$10,$12,$0b,$0b,$0b ; $fbe9 (*)
	.byte	$10,$12,$14,$17,$17,$17,$17		; $fbf1 (*)
	.byte	$18,$1b,$0f,$0f,$0f,$14,$17,$18 ; $fbf8 (d)


	.byte	$14 ; |	  # #  |			$fc00 (g)
	.byte	$3c ; |	 ####  |			$fc01 (g)
	.byte	$7e ; | ###### |			$fc02 (g)
	.byte	$00 ; |		   |			$fc03 (g)
	.byte	$30 ; |	 ##	   |			$fc04 (g)
	.byte	$38 ; |	 ###   |			$fc05 (g)
	.byte	$3c ; |	 ####  |			$fc06 (g)
	.byte	$3e ; |	 ##### |			$fc07 (g)
	.byte	$3f ; |	 ######|			$fc08 (g)
	.byte	$7f ; | #######|			$fc09 (g)
	.byte	$7f ; | #######|			$fc0a (g)
	.byte	$7f ; | #######|			$fc0b (g)
	.byte	$11 ; |	  #	  #|			$fc0c (g)
	.byte	$11 ; |	  #	  #|			$fc0d (g)
	.byte	$33 ; |	 ##	 ##|			$fc0e (g)
	.byte	$00 ; |		   |			$fc0f (g)

	.byte	$14 ; |	  # #  |			$fc10 (g)
	.byte	$3c ; |	 ####  |			$fc11 (g)
	.byte	$7e ; | ###### |			$fc12 (g)
	.byte	$00 ; |		   |			$fc13 (g)
	.byte	$30 ; |	 ##	   |			$fc14 (g)
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
	.byte	$00 ; |		   |			$fc1f (g)

	.byte	$14 ; |	  # #  |			$fc20 (g)
	.byte	$3c ; |	 ####  |			$fc21 (g)
	.byte	$7e ; | ###### |			$fc22 (g)
	.byte	$00 ; |		   |			$fc23 (g)
	.byte	$30 ; |	 ##	   |			$fc24 (g)
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
	.byte	$00 ; |		   |			$fc2f (g)

	.byte	$14 ; |	  # #  |			$fc30 (g)
	.byte	$3c ; |	 ####  |			$fc31 (g)
	.byte	$7e ; | ###### |			$fc32 (g)
	.byte	$00 ; |		   |			$fc33 (g)
	.byte	$30 ; |	 ##	   |			$fc34 (g)
	.byte	$38 ; |	 ###   |			$fc35 (g)
	.byte	$3c ; |	 ####  |			$fc36 (g)
	.byte	$3e ; |	 ##### |			$fc37 (g)
	.byte	$3f ; |	 ######|			$fc38 (g)
	.byte	$7f ; | #######|			$fc39 (g)
	.byte	$7f ; | #######|			$fc3a (g)
	.byte	$7f ; | #######|			$fc3b (g)
	.byte	$08 ; |	   #   |			$fc3c (g)
	.byte	$08 ; |	   #   |			$fc3d (g)
	.byte	$18 ; |	  ##   |			$fc3e (g)
	.byte	$00 ; |		   |			$fc3f (g)


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
	.byte	$00 ; |		   |			$fcb6 (g)

spider_frame_3_gfx
	.byte	$54 ; | # # #  |			$fcb7 (g)
	.byte	$5f ; | # #####|			$fcb8 (g)
	.byte	$fc ; |######  |			$fcb9 (g)
	.byte	$7f ; | #######|			$fcba (g)
	.byte	$fe ; |####### |			$fcbb (g)
	.byte	$3f ; |	 ######|			$fcbc (g)
	.byte	$fa ; |##### # |			$fcbd (g)
	.byte	$2a ; |	 # # # |			$fcbe (g)
	.byte	$00 ; |		   |			$fcbf (g)

spider_frame_2_gfx
	.byte	$2a ; |	 # # # |			$fcc0 (g)
	.byte	$fa ; |##### # |			$fcc1 (g)
	.byte	$3f ; |	 ######|			$fcc2 (g)
	.byte	$fe ; |####### |			$fcc3 (g)
	.byte	$7f ; | #######|			$fcc4 (g)
	.byte	$fa ; |##### # |			$fcc5 (g)
	.byte	$5f ; | # #####|			$fcc6 (g)
	.byte	$54 ; | # # #  |			$fcc7 (g)
	.byte	$00 ; |		   |			$fcc8 (g)

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
	ror								;2		   *
	bcs		lfcef					;2/3	   *
	dec		enemy_y,x				 ;6	  =	 10 *
lfcef
	ror								;2		   *
	bcs		lfcf4					;2/3	   *
	inc		enemy_y,x				 ;6	  =	 10 *
lfcf4
	ror								;2		   *
	bcs		lfcf9					;2/3	   *
	dec		enemy_x,x				 ;6	  =	 10 *
lfcf9
	ror								;2		   *
	bcs		lfcfe					;2/3	   *
	inc		enemy_x,x				 ;6	  =	 10 *
lfcfe
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

lfef0
	.byte	$3c ; |	 ####  |			$fef0 (g)
	.byte	$3c ; |	 ####  |			$fef1 (g)
	.byte	$7e ; | ###### |			$fef2 (g)
	.byte	$ff ; |########|			$fef3 (g)

lfef4
	lda		ram_8c,x				;4
	bmi		lfef9					;2/3
	rts								;6	 =	12

lfef9
	jsr		lfcea					;6		   *
	jsr		lf8e1					;6		   *
	rts								;6	 =	18 *



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
