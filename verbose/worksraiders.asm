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
resm0			= $12  ; (wi)
resm1			= $13  ; (wi)
resbl			= $14  ; (w)
audc0			= $15  ; (w)
audc1			= $16  ; (wi)
audf0			= $17  ; (w)
audf1			= $18  ; (wi)
audv0			= $19  ; (w)
audv1			= $1a  ; (wi)
grp0			= $1b  ; (w)
grp1			= $1c  ; (w)
enam0			= $1d  ; (w)
enam1			= $1e  ; (w)
enabl			= $1f  ; (w)
hmp0			= $20  ; (w)
hmp1			= $21  ; (w)
hmm0			= $22  ; (wi)
hmm1			= $23  ; (wi)
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
	ldx		#$04					
ld008
	sta		wsync					
;---------------------------------------
	lda		enemy_x,x				 
	tay								
	lda		room_miss0_size_tabl,y					
	sta		hmp0,x					
	and		#$0f					
	tay								
ld015
	dey								
	bpl		ld015					
	sta		resp0,x					
	dex								
	bpl		ld008					
	sta		wsync					
;---------------------------------------
	sta		hmove					
	jmp		ldf9c					

ld024:
	   bit	  cxm1p					  
	   bpl	  ld05c					  
	   ldx	  $81					  
	   cpx	  #$0a					  
	   bcc	  ld05c					  
	   beq	  ld03f					  
	   lda	  $d1					  
	   adc	  #$01					  
	   lsr							  
	   lsr							  
	   lsr							  
	   lsr							  
	   tax							  
	   lda	  #$08					  
	   eor	  $df,x					  
	   sta	  $df,x					  
ld03f:
	   lda	  $8f					  
	   bpl	  ld054					  
	   and	  #$7f					  
	   sta	  $8f					  
	   lda	  $95					  
	   and	  #$1f					  
	   beq	  ld050					  
	   jsr	  PlaceItemInInventory					  
ld050:
	   lda	  #$40					  
	   sta	  $95					  
ld054:
	   lda	  #$7f					  
	   sta	  $d1					  
	   lda	  #$04					  
	   sta	  thief_shot			  
ld05c:
	   bit	  cxm1fb				  
	   bpl	  ld0aa					  
	   ldx	  $81					  
	   cpx	  #$09					  
	   beq	  ld0bc					  
	   cpx	  #$06					  
	   beq	  ld06e					  
	   cpx	  #$08					  
	   bne	  ld0aa					  
ld06e:
	   lda	  $d1					  
	   sbc	  $d4					  
	   lsr							  
	   lsr							  
	   beq	  ld087					  
	   tax							  
	   ldy	  $cb					  
	   cpy	  #$12					  
	   bcc	  ld0a4					  
	   cpy	  #$8d					  
	   bcs	  ld0a4					  
	   lda	  #$00					  
	   sta	  $e5,x					  
	   beq	  ld0a4					  

ld087:
	   lda	  $cb					  
	   cmp	  #$30					  
	   bcs	  ld09e					  
	   sbc	  #$10					  
	   eor	  #$1f					  
ld091:
	   lsr							  
	   lsr							  
	   tax							  
	   lda	  ldc5c,x				  
	   and	  $e5					  
	   sta	  $e5					  
	   jmp	  ld0a4					  

ld09e:
	   sbc	  #$71					  
	   cmp	  #$20					  
	   bcc	  ld091					  
ld0a4:
	   ldy	  #$7f					  
	   sty	  $8f					  
	   sty	  $d1					  
ld0aa:
	   bit	  cxm1fb				  
	   bvc	  ld0bc					  
	   bit	  $93					  
	   bvc	  ld0bc					  
	   lda	  #$5a					  
	   sta	  $d2					  
	   sta	  $dc					  
	   sta	  $8f					  
	   sta	  $d1					  
ld0bc:
	   bit	  cxp1fb				  
	   bvc	  ld0ed					  
	   ldx	  $81					  
	   cpx	  #$06					  
	   beq	  ld0e2					  
	   lda	  current_object		  
	   cmp	  #$02					  
	   beq	  ld0ed					  
	   bit	  $93					  
	   bpl	  ld0da					  
	   lda	  $83					  
	   and	  #$07					  
	   ora	  #$80					  
	   sta	  $a1					  
	   bne	  ld0ed					  

ld0da:
	   bvc	  ld0ed					  
	   lda	  #$80					  
	   sta	  $9d					  
	   bne	  ld0ed					  

ld0e2:
	   lda	  $d6					  
	   cmp	  #$ba					  
	   bne	  ld0ed					  
	   lda	  #$0f					  
	   jsr	  PlaceItemInInventory					  
ld0ed:
	   ldx	  #$05					  
	   cpx	  $81					  
	   bne	  ld12d					  
	   bit	  cxm0p					  
	   bpl	  ld106					  
	   stx	  $cf					  
	   lda	  #$0c					  
	   sta	  $81					  
	   jsr	  InitializeScreenState					  
	   lda	  #$4c					  
	   sta	  $c9					  
	   bne	  ld12b					  

ld106:
	   ldx	  $cf					  
	   cpx	  #$4f					  
	   bcc	  ld12d					  
	   lda	  #$0a					  
	   sta	  $81					  
	   jsr	  InitializeScreenState					  
	   lda	  $eb					  
	   sta	  $df					  
	   lda	  $ec					  
	   sta	  $cf					  
	   lda	  $ed					  
	   sta	  $c9					  
	   lda	  #$fd					  
	   and	  $b4					  
	   sta	  $b4					  
	   bmi	  ld12b					  
	   lda	  #$80					  
	   sta	  $9d					  
ld12b:
	   sta	  cxclr					  
ld12d:
	   bit	  cxppmm				  
	   bmi	  ld140					  
	   ldx	  #$00					  
	   stx	  $91					  
	   dex							  
	   stx	  $97					  
	   rol	  $95					  
	   clc							  
	   ror	  $95					  
ld13d:
	   jmp	  ld2b4					  

ld140:
	   lda	  $81					  
	   bne	  ld157					  
	   lda	  $af					  
	   and	  #$07					  
	   tax							  
	   lda	  ldf78,x				  
	   jsr	  PlaceItemInInventory					  
	   bcc	  ld13d					  
	   lda	  #$01					  
	   sta	  $df					  
	   bne	  ld13d					  

ld157:
	   asl							  
	   tax							  
	   lda	  ldc9b+1,x				  
	   pha							  
	   lda	  ldc9b,x				  
	   pha							  
	   rts							  

ld162:
	   lda	  $cf					  
	   cmp	  #$3f					  
	   bcc	  ld18a					  
	   lda	  $96					  
	   cmp	  #$54					  
	   bne	  ld1c1					  
	   lda	  $8c					  
	   cmp	  $8b					  
	   bne	  ld187					  
	   lda	  #$58					  
	   sta	  $9c					  
	   sta	  $9e					  
	   jsr	  tally_score					  
	   lda	  #$0d					  
	   sta	  $81					  
	   jsr	  InitializeScreenState					  
	   jmp	  ld3d8					  

ld187:
	   jmp	  PlaceIndyInMesaSide					  

ld18a:
	   lda	  #$0b					  
	   bne	  ld194					  

ld18e:
	   lda	  #$07					  
	   bne	  ld194					  

ld192:
	   lda	  #$04					  
ld194:
	   bit	  $95					  
	   bmi	  ld1c1					  
	   clc							  
	   jsr	  TakeItemFromInventory					  
	   bcs	  ld1a4					  
	   sec							  
	   jsr	  TakeItemFromInventory					  
	   bcc	  ld1c1					  
ld1a4:
	   cpy	  #$0b					  
	   bne	  ld1ad					  
	   ror	  $b2					  
	   clc							  
	   rol	  $b2					  
ld1ad:
	   lda	  $95					  
	   jsr	  ldd59					 
	   tya							  
	   ora	  #$c0					  
	   sta	  $95					  
	   bne	  ld1c1					  

ld1b9:
	   ldx	  #$00					  
	   stx	  $b6					  
	   lda	  #$80					  
	   sta	  $9d					  
ld1c1:
	   jmp	  ld2b4					  

ld1c4:
	   bit	  $b4					  
	   bvs	  ld1e8					  
	   bpl	  ld1e8					  
	   lda	  $c9					  
	   cmp	  #$2b					  
	   bcc	  ld1e2					  
	   ldx	  $cf					  
	   cpx	  #$27					  
	   bcc	  ld1e2					  
	   cpx	  #$2b					  
	   bcs	  ld1e2					  
	   lda	  #$40					  
	   ora	  $b4					  
	   sta	  $b4					  
	   bne	  ld1e8					  
ld1e2:
	   lda	  #$03					  
	   sec							  
	   jsr	  TakeItemFromInventory					  
ld1e8:
	   jmp	  ld2b4					  

ld1eb:
	   bit	  cxp1fb				  
	   bpl	  ld21a					  
	   ldy	  $cf					  
	   cpy	  #$3a					  
	   bcc	  ld200					  
	   lda	  #$e0					  
	   and	  $91					  
	   ora	  #$43					  
	   sta	  $91					  
	   jmp	  ld2b4					  

ld200:
	   cpy	  #$20					  
	   bcc	  ld20b					  
ld204:
	   lda	  #$00					  
	   sta	  $91					  
	   jmp	  ld2b4					  

ld20b:
	   cpy	  #$09					  
	   bcc	  ld204					  
	   lda	  #$e0					  
	   and	  $91					  
	   ora	  #$42					  
	   sta	  $91					  
	   jmp	  ld2b4					  

ld21a:
	   lda	  $cf					  
	   cmp	  #$3a					  
	   bcc	  ld224					  
	   ldx	  #$07					  
	   bne	  ld230					  

ld224:
	   lda	  $c9					  
	   cmp	  #$4c					  
	   bcs	  ld22e					  
	   ldx	  #$05					  
	   bne	  ld230					  

ld22e:
	   ldx	  #$0d					  
ld230:
	   lda	  #$40					  
	   sta	  $93					  
	   lda	  $83					  
	   and	  #$1f					  
	   cmp	  #$02					  
	   bcs	  ld23e					  
	   ldx	  #$0e					  
ld23e:
	   jsr	  DetermineIfItemAlreadyTaken					  
	   bcs	  ld247					  
	   txa							  
	   jsr	  PlaceItemInInventory					  
ld247:
	   jmp	  ld2b4					  

ld24a:
	   bit	  cxp1fb				  
	   bmi	  ld26e					  
	   lda	  $c9					  
	   cmp	  #$50					  
	   bcs	  ld262					  
	   dec	  $c9					  
	   rol	  $b2					  
	   clc							  
	   ror	  $b2					  
ld25b:
	   lda	  #$00					  
	   sta	  $91					  
ld25f:
	   jmp	  ld2b4					  

ld262:
	   ldx	  #$06					  
	   lda	  $83					  
	   cmp	  #$40					  
	   bcs	  ld23e					  
	   ldx	  #$07					  
	   bne	  ld23e					  

ld26e:
	   ldy	  $cf					  
	   cpy	  #$44					  
	   bcc	  ld27e					  
	   lda	  #$e0					  
	   and	  $91					  
	   ora	  #$0b					  
ld27a:
	   sta	  $91					  
	   bne	  ld25f					  
ld27e:
	   cpy	  #$20					  
	   bcs	  ld25b					  
	   cpy	  #$0b					  
	   bcc	  ld25b					  
	   lda	  #$e0					  
	   and	  $91					  
	   ora	  #$41					  
	   bne	  ld27a					  

ld28e:
	   inc	  $c9					  
	   bne	  ld2b4					  

ld292:
	   lda	  $cf					  
	   cmp	  #$3f					  
	   bcc	  ld2aa					  
	   lda	  #$0a					  
	   jsr	  PlaceItemInInventory					  
	   bcc	  ld2b4					  
	   ror	  $b1					  
	   sec							  
	   rol	  $b1					  
	   lda	  #$42					  
	   sta	  $df					  
	   bne	  ld2b4					  

ld2aa:
	   cmp	  #$16					  
	   bcc	  ld2b2					  
	   cmp	  #$1f					  
	   bcc	  ld2b4					  
ld2b2:
	   dec	  $c9					  
ld2b4:
	   lda	  $81					  
	   asl							  
	   tax							  
	   bit	  cxp1fb				  
	   bpl	  ld2c5					  
	   lda	  ldcb5+1,x				  
	   pha							  
	   lda	  ldcb5,x				  
	   pha							  
	   rts							  

ld2c5:
	   lda	  ldccf+1,x				  
	   pha							  
	   lda	  ldccf,x				  
	   pha							  
	   rts							  

WarpToMesaSide
	lda		ram_df					
	sta		ram_eb					
	lda		indy_y					
	sta		ram_ec					
	lda		indy_x					
SaveIndyAndThiefPosition
	sta		ram_ed					
PlaceIndyInMesaSide
	lda		#cliff_room					
	sta		room_num				  
	jsr		InitializeScreenState					
	lda		#$05					
	sta		indy_y					
	lda		#$50					
	sta		indy_x					
	tsx								
	cpx		#$fe					
	bcs		FailSafeToCollisionCheck					
	rts								

FailSafeToCollisionCheck
	jmp		ld374					



ld2f2:
	   bit	  $b3					  
	   bmi	  FailSafeToCollisionCheck					  
	   lda	  #$50					  
	   sta	  $eb					  
	   lda	  #$41					  
	   sta	  $ec					  
	   lda	  #$4c					  
	   bne	  SaveIndyAndThiefPosition					  

ld302:
	   ldy	  $c9					  
	   cpy	  #$2c					  
	   bcc	  ld31a					  
	   cpy	  #$6b					  
	   bcs	  ld31c					  
	   ldy	  $cf					  
	   iny							  
	   cpy	  #$1e					  
	   bcc	  ld315					  
	   dey							  
	   dey							  
ld315:
	   sty	  $cf					  
	   jmp	  ld364					  

ld31a:
	   iny							  
	   iny							  
ld31c:
	   dey							  
	   sty	  $c9					  
	   bne	  ld364					  

ld321:
	   lda	  #$02					  
	   and	  $b1					  
	   beq	  ld331					  
	   lda	  $cf					  
	   cmp	  #$12					  
	   bcc	  ld331					  
	   cmp	  #$24					  
	   bcc	  ld36a					  
ld331:
	   dec	  $c9					  
	   bne	  ld364					  

ld335:
	   ldx	  #$1a					  
	   lda	  $c9					  
	   cmp	  #$4c					  
	   bcc	  ld33f					  
	   ldx	  #$7d					  
ld33f:
	   stx	  $c9					  
	   ldx	  #$40					  
	   stx	  $cf					  
	   ldx	  #$ff					  
	   stx	  $e5					  
	   ldx	  #$01					  
	   stx	  $e6					  
	   stx	  $e7					  
	   stx	  $e8					  
	   stx	  $e9					  
	   stx	  $ea					  
	   bne	  ld364					  

ld357:
	   lda	  $92					  
	   and	  #$0f					  
	   tay							  
	   lda	  ldfd5,y				  
	   ldx	  #$01					  
	   jsr	  move_enemy				  
ld364:
	   lda	  #$05					  
	   sta	  $a2					  
	   bne	  ld374					  

ld36a:
	   rol	  $8a					  
	   sec							  
	   bcs	  ld372					  

ld36f:
	   rol	  $8a					  
	   clc							  
ld372:
	   ror	  $8a					  

ld374
	bit		cxm0p|$30				
	bpl		ld396					
	ldx		room_num				  
	cpx		#spider_room					
	beq		ld386					
	bcc		ld396					
	lda		#$80					
	sta		ram_9d					
	bne		ld390					
ld386
	rol		ram_8a					
	sec								
	ror		ram_8a					
	rol		ram_b6					
	sec								
	ror		ram_b6					
ld390
	lda		#$7f					
	sta		ram_8e					
	sta		ram_d0					
ld396
	bit		ram_9a					
	bpl		ld3d8					
	bvs		ld3a8					
	lda		time_of_day					 
	cmp		ram_9b					
	bne		ld3d8					
	lda		#$a0					
	sta		ram_d1					
	sta		ram_9d					
ld3a8
	lsr		ram_9a					
	bcc		ld3d4					
	lda		#$02					
	sta		grenade_used				  
	ora		ram_b1					
	sta		ram_b1					
	ldx		#starting_room					
	cpx		room_num				  
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
	ldx		#starting_room					
	cpx		room_num				  
	bne		ld3d4					
	jsr		InitializeScreenState					
ld3d4
	sec								
	jsr		TakeItemFromInventory					
ld3d8
	lda		intim					
	bne		ld3d8					
ld3dd
	lda		#$02					
	sta		wsync					
;---------------------------------------
	sta		vsync					
	lda		#$50					
	cmp		ram_d1					
	bcs		ld3eb					
	sta		ram_cb					
ld3eb
	inc		frame_counter			;up the frame counter by 1
	lda		#$3f					;
	and		frame_counter			;every 63 frames (?)
	bne		ld3fb					;
	inc		time_of_day				;increse the time of day
	lda		ram_a1					
	bpl		ld3fb					
	dec		ram_a1					
ld3fb
	sta		wsync					
;---------------------------------------
	bit		ram_9c					
	bpl		frame_start					  
	ror		swchb					
	bcs		frame_start					  
	jmp		game_start					 

frame_start
	sta		wsync					;wait for first sync
;---------------------------------------
	lda		#$00					;load a for vsync pause
	ldx		#$2c					;load timer for
	sta		wsync					
;---------------------------------------
	sta		vsync					
	stx		tim64t					
	ldx		ram_9d					
	inx								
	bne		ld42a					
	stx		ram_9d					
	jsr		tally_score				; set score to minimum
	lda		#ark_room				; set ark title screen 
	sta		room_num				; to the current room
	jsr		InitializeScreenState					
ld427
	jmp		ld80d					

ld42a
	lda		room_num				; get teh room number
	cmp		#ark_room				; are we in the ark room? 
	bne		ld482					
	lda		#$9c					
	sta		ram_a3					
	ldy		yar_found				; check if yar was found
	beq		ld44a					; if not hold for button(?)
	bit		ram_9c					
	bmi		ld44a					
	ldx		#>dev_name_1_gfx		; get programmer 1 initials...
	stx		inv_slot_hi				; put in slot 1
	stx		inv_slot2_hi			
	lda		#<dev_name_1_gfx		
	sta		inv_slot_lo				
	lda		#<dev_name_2_gfx		; get programmer 2 initials...
	sta		inv_slot2_lo			; put in slot 2
ld44a
	ldy		indy_y					
	cpy		#$7c					
	bcs		ld465					
	cpy		score				   
	bcc		ld45b					
	bit		inpt5|$30				
	bmi		ld427					
	jmp		game_start					 

ld45b
	lda		frame_counter				   
	ror								
	bcc		ld427					
	iny								
	sty		indy_y					
	bne		ld427					
ld465
	bit		ram_9c					
	bmi		ld46d					
	lda		#$0e					
	sta		ram_a2					
ld46d
	lda		#$80					
	sta		ram_9c					
	bit		inpt5|$30				
	bmi		ld427					
	lda		frame_counter				   
	and		#$0f					
	bne		ld47d					
	lda		#$05					
ld47d
	sta		ram_8c					
	jmp		reset_vars					 

ld482
	bit		ram_93					
	bvs		ld489					
ld486
	jmp		ld51c					

ld489
	lda		frame_counter				   
	and		#$03					
	bne		ld501					
	ldx		snake_y					 
	cpx		#$60					
	bcc		ld4a5					
	bit		ram_9d					
	bmi		ld486					
	ldx		#$00					
	lda		indy_x					
	cmp		#$20					
	bcs		ld4a3					
	lda		#$20					
ld4a3
	sta		ram_cc					
ld4a5
	inx								
	stx		snake_y					 
	txa								
	sec								
	sbc		#$07					
	bpl		ld4b0					
	lda		#$00					
ld4b0
	sta		ram_d2					
	and		#$f8					
	cmp		ram_d5					
	beq		ld501					
	sta		ram_d5					
	lda		ram_d4					
	and		#$03					
	tax								
	lda		ram_d4					
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
	sbc		indy_x					
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
	lda		ram_d4					
	and		#$03					
	tax								
	lda		ldbff,x					
	clc								
	adc		ram_cc					
	sta		ram_cc					
	lda		ram_d4					
	lsr								
	lsr								
	ora		ram_84					
	sta		ram_d4					
ld501
	lda		ram_d4					
	and		#$03					
	tax								
	lda		ldbfb,x					
	sta		ram_d6					
	lda		#$fa					
	sta		ram_d7					
	lda		ram_d4					
	lsr								
	lsr								
	tax								
	lda		ldbfb,x					
	sec								
	sbc		#$08					
	sta		ram_d8					
ld51c
	bit		ram_9d					
	bpl		ld523					
	jmp		ld802					

ld523
	bit		ram_a1					
	bpl		ld52a					
	jmp		ld78c					

ld52a
	lda		frame_counter				   
	ror								
	bcc		ld532					
	jmp		ld627					

ld532
	ldx		room_num				  
	cpx		#cliff_room					
	beq		ld579					
	bit		ram_8d					
	bvc		ld56e					
	ldx		ram_cb					
	txa								
	sec								
	sbc		indy_x					
	tay								
	lda		swcha					
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
	stx		ram_cb					
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
	bit		ram_b4					
	bmi		ld579					
	bit		ram_8a					
	bpl		ld57c					
	ror								
	bcc		ld57c					
ld579
	jmp		ld5e0					

ld57c
	ldx		#$01					
	lda		swcha					
	sta		ram_85					
	and		#$0f					
	cmp		#$0f					
	beq		ld579					
	sta		indy_dir				  
	jsr		move_enemy					 
	ldx		room_num				  
	ldy		#$00					
	sty		ram_84					
	beq		ld599					
ld596
	tax								
	inc		ram_84					
ld599
	lda		indy_x					
	pha								
	lda		indy_y					
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
	adc		indy_y					
	sta		indy_y					
	jmp		ld5d1					

ld5cc
	clc								
	adc		indy_x					
	sta		indy_x					
ld5d1
	txa								
	clc								
	adc		#$0d					
	cmp		#$34					
	bcc		ld596					
	bcs		ld5e0					
ld5db
	sty		room_num				  
	jsr		InitializeScreenState					
ld5e0
	bit		inpt4|$30				
	bmi		ld5f5					
	bit		ram_9a					
	bmi		ld624					
	lda		ram_8a					
	ror								
	bcs		ld5fa					
	sec								
	jsr		TakeItemFromInventory					
	inc		ram_8a					
	bne		ld5fa					
ld5f5
	ror		ram_8a					
	clc								
	rol		ram_8a					
ld5fa
	lda		ram_91					
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
	ror		ram_b2					
	sec								
	rol		ram_b2					
	ldx		#$45					
	stx		ram_df					
	ldx		#$7f					
	stx		ram_d0					
ld61d
	jsr		PlaceItemInInventory					
ld620
	lda		#$00					
	sta		ram_91					
ld624
	jmp		ld777					

ld627
	bit		ram_9a					
	bmi		ld624					
	bit		inpt5|$30				
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
	ldx		current_object					
	cpx		#$05					
	beq		ld64c					
	cpx		#$06					
	bne		ld671					
ld64c
	ldx		indy_y					
	stx		ram_d1					
	ldy		indy_x					
	sty		ram_cb					
	lda		time_of_day					 
	adc		#$04					
	sta		ram_9b					
	lda		#$80					
	cpx		#$35					
	bcs		ld66c					
	cpy		#$64					
	bcc		ld66c					
	ldx		room_num				  
	cpx		#starting_room					
	bne		ld66c					
	ora		#$01					
ld66c
	sta		ram_9a					
	jmp		ld777					

ld671
	cpx		#$03					
	bne		ld68b					
	stx		parachute_used					
	lda		ram_b4					
	bmi		ld696					
	ora		#$80					
	sta		ram_b4					
	lda		indy_y					
	sbc		#$06					
	bpl		ld687					
	lda		#$01					
ld687
	sta		indy_y					
	bpl		ld6d2					
ld68b
	bit		ram_8d					
	bvc		ld6d5					
	bit		cxm1fb|$30				
	bmi		ld699					
	jsr		WarpToMesaSide					
ld696
	jmp		ld777					

ld699
	lda		ram_d1					
	lsr								
	sec								
	sbc		#$06					
	clc								
	adc		ram_df					
	lsr								
	lsr								
	lsr								
	lsr								
	cmp		#$08					
	bcc		ld6ac					
	lda		#$07					
ld6ac
	sta		ram_84					
	lda		ram_cb					
	sec								
	sbc		#$10					
	and		#$60					
	lsr								
	lsr								
	adc		ram_84					
	tay								
	lda		ldf7c,y					
	sta		ram_8b					
	ldx		ram_d1					
	dex								
	stx		ram_d1					
	stx		indy_y					
	ldx		ram_cb					
	dex								
	dex								
	stx		ram_cb					
	stx		indy_x					
	lda		#$46					
	sta		ram_8d					
ld6d2
	jmp		ld773					

ld6d5
	cpx		#$0b					
	bne		ld6f7					
	lda		indy_y					
	cmp		#$41					
	bcc		ld696					
	bit		cxppmm|$30				
	bpl		ld696					
	inc		ram_97					
	bne		ld696					
	ldy		ram_96					
	dey								
	cpy		#$54					
	bcs		ld6ef					
	iny								
ld6ef
	sty		ram_96					
	lda		#$0a					
	sta		shovel_used					 
	bne		ld696					
ld6f7
	cpx		#$10					
	bne		ld71e					
	ldx		room_num				  
	cpx		#treasure_room					
	beq		ld696					
	lda		#mesa_top_room					
	sta		ankh_used				   
	sta		room_num				  
	jsr		InitializeScreenState					
	lda		#$4c					
	sta		indy_x					
	sta		ram_cb					
	lda		#$46					
	sta		indy_y					
	sta		ram_d1					
	sta		ram_8d					
	lda		#$1d					
	sta		ram_df					
	bne		ld777					
ld71e
	lda		swcha					
	and		#$0f					
	cmp		#$0f					
	beq		ld777					
	cpx		#$0d					
	bne		ld747					
	bit		ram_8f					
	bmi		ld777					
	ldy		num_bullets					 
	bmi		ld777					
	dec		num_bullets					 
	ora		#$80					
	sta		ram_8f					
	lda		indy_y					
	adc		#$04					
	sta		ram_d1					
	lda		indy_x					
	adc		#$04					
	sta		ram_cb					
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
	adc		indy_x					
	sta		ram_cb					
	txa								
	clc								
	adc		indy_y					
	sta		ram_d1					
ld773
	lda		#$0f					
	sta		ram_a3					
ld777
	bit		ram_b4					
	bpl		ld783					
	lda		#$63					
	sta		indy_anim				   
	lda		#$0f					
	bne		ld792					
ld783
	lda		swcha					
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
	ldx		room_num				  
	cpx		#mesa_top_room					
	beq		ld7bc					
	cpx		#$0a					
	bne		ld802					
ld7bc
	lda		frame_counter				   
	bit		ram_8a					
	bpl		ld7c3					
	lsr								
ld7c3
	ldy		indy_y					
	cpy		#$27					
	beq		ld802					
	ldx		ram_df					
	bcs		ld7e8					
	beq		ld802					
	inc		indy_y					
	inc		ram_d1					
	and		#$02					
	bne		ld802					
	dec		ram_df					
	inc		enemy_y					 
	inc		ram_d0					
	inc		ram_d2					
	inc		enemy_y					 
	inc		ram_d0					
	inc		ram_d2					
	jmp		ld802					

ld7e8
	cpx		#$50					
	bcs		ld802					
	dec		indy_y					
	dec		ram_d1					
	and		#$02					
	bne		ld802					
	inc		ram_df					
	dec		enemy_y					 
	dec		ram_d0					
	dec		ram_d2					
	dec		enemy_y					 
	dec		ram_d0					
	dec		ram_d2					
ld802
	lda		#$28					
	sta		ram_88					
	lda		#$f5					
	sta		ram_89					
	jmp		ldfad					

ld80d
	lda		ram_99					
	beq		set_room_attr					
	jsr		ldd59				   
	lda		#$00					
set_room_attr
	sta		ram_99					
	ldx		room_num				  
	lda		room_miss0_size_tabl,x					
	sta		nusiz0					
	lda		room_pf_cfg					
	sta		ctrlpf					
	lda		room_bg_color_tbl,x					
	sta		colubk					
	lda		room_pf_color_tbl,x					
	sta		colupf					
	lda		room_p0_color_tbl,x					
	sta		colup0					
	lda		room_p1_color_tbl,x					
	sta		colup1					
	cpx		#$0b					
	bcc		ld84b					
	lda		#$20					
	sta		ram_d4					
	ldx		#$04					
ld841
	ldy		ram_e5,x				
	lda		room_miss0_size_tabl,y					
	sta		ram_ee,x				
	dex								
	bpl		ld841					
ld84b
	jmp		ld006					

ld84e
	lda		#$4d					
	sta		indy_x					
	lda		#$48					
	sta		enemy_x					 
	lda		#$1f					
	sta		indy_y					
	rts								

ld85b
	ldx		#$00					
	txa								
ld85e
	sta		ram_df,x				
	sta		ram_e0,x				
	sta		pf1_data,x				  
	sta		ram_e2,x				
	sta		pf2_data,x				  
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
	sta		ram_96					
	ldx		#$00					
	stx		ram_93					
	stx		ram_b6					
	stx		ram_8e					
	stx		ram_90					
	lda		ram_95					
	stx		ram_95					
	jsr		ldd59				   
	rol		ram_8a					
	clc								
	ror		ram_8a					
	ldx		room_num				  
	lda		ldb92,x					
	sta		room_pf_cfg					
	cpx		#$0d					
	beq		ld84e					
	cpx		#$05					
	beq		ld8b1					
	cpx		#$0c					
	beq		ld8b1					
	lda		#$00					
	sta		ram_8b					
ld8b1
	lda		ldbee,x					
	sta		emy_anim				  
	lda		ldbe1,x					
	sta		ram_de					
	lda		ldbc9,x					
	sta		snake_y					 
	lda		ldbd4,x					
	sta		enemy_x					 
	lda		ldc0e,x					
	sta		ram_ca					
	lda		ldc1b,x					
	sta		ram_d0					
	cpx		#$0b					
	bcs		ld85b					
	adc		ldc03,x					
	sta		ram_e0					
	lda		ldc28,x					
	sta		pf1_data				  
	lda		ldc33,x					
	sta		ram_e2					
	lda		ldc3e,x					
	sta		pf2_data				  
	lda		ldc49,x					
	sta		ram_e4					
	lda		#$55					
	sta		ram_d2					
	sta		ram_d1					
	cpx		#$06					
	bcs		ld93e					
	lda		#$00					
	cpx		#$00					
	beq		ld91b					
	cpx		#$02					
	beq		ld92a					
	sta		enemy_y					 
ld902
	ldy		#$4f					
	cpx		#$02					
	bcc		ld918					
	lda		ram_af,x				
	ror								
	bcc		ld918					
	ldy		ldf72,x					
	cpx		#$03					
	bne		ld918					
	lda		#$ff					
	sta		ram_d0					
ld918
	sty		ram_df					
	rts								

ld91b
	lda		ram_af					
	and		#$78					
	sta		ram_af					
	lda		#$1a					
	sta		enemy_y					 
	lda		#$26					
	sta		ram_df					
	rts								

ld92a
	lda		ram_b1					
	and		#$07					
	lsr								
	bne		ld935					
	ldy		#$ff					
	sty		ram_d0					
ld935
	tay								
	lda		ldf70,y					
	sta		enemy_y					 
	jmp		ld902					

ld93e
	cpx		#$08					
	beq		ld950					
	cpx		#$06					
	bne		ld968					
	ldy		#$00					
	sty		ram_d8					
	ldy		#$40					
	sty		ram_e5					
	bne		ld958					
ld950
	ldy		#$ff					
	sty		ram_e5					
	iny								
	sty		ram_d8					
	iny								
ld958
	sty		ram_e6					
	sty		ram_e7					
	sty		ram_e8					
	sty		ram_e9					
	sty		ram_ea					
	ldy		#$39					
	sty		ram_d4					
	sty		ram_d5					
ld968
	cpx		#$09					
	bne		ld977					
	ldy		indy_y					
	cpy		#$49					
	bcc		ld977					
	lda		#$50					
	sta		ram_df					
	rts								

ld977
	lda		#$00					
	sta		ram_df					
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
	sta		indy_y					
ld992
	lda		ldf38,x					
	beq		ld999					
	sta		indy_x					
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
	bit		ram_af					
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
	cmp		current_object					
	bne		ld9f9					
	bit		inpt5|$30				
	bmi		ld9f9					
	jmp		ld98b					

TakeItemFromInventory
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
	lda		#<blank_gfx				; load blank space
	ldx		cursor_pos				; get at current position
	sta		inv_slot_lo,x			; put in current slot
	ldx		current_object			; is the current object
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
	ldx		room_num				  
	rts								

lda5e:
	   lda	  #$3f					  
	   and	  $b4					  
	   sta	  $b4					  
lda64:
	   jmp	  ldad8					  

lda67:
	   stx	  $8d					  
	   lda	  #$70					  
	   sta	  $d1					  
	   bne	  lda64					  

lda6f:
	   lda	  #$42					  
	   cmp	  $91					  
	   bne	  lda86					  
	   lda	  #$03					  
	   sta	  $81					  
	   jsr	  InitializeScreenState					  
	   lda	  #$15					  
	   sta	  $c9					  
	   lda	  #$1c					  
	   sta	  $cf					  
	   bne	  ldad8					  

lda86:
	   cpx	  #$05					  
	   bne	  ldad8					  
	   lda	  #$05					  
	   cmp	  $8b					  
	   bne	  ldad8					  
	   sta	  yar_found				  
	   lda	  #$00					  
	   sta	  $ce					  
	   lda	  #$02					  
	   ora	  $b4					  
	   sta	  $b4					  
	   bne	  ldad8					  

lda9e:
	   ror	  $b1					  
	   clc							  
	   rol	  $b1					  
	   cpx	  #$02					  
	   bne	  ldaab					  
	   lda	  #$4e					  
	   sta	  $df					  
ldaab:
	   bne	  ldad8					  

ldaad:
	   ror	  $b2					  
	   clc							  
	   rol	  $b2					  
	   cpx	  #$03					  
	   bne	  ldabe					  
	   lda	  #$4f					  
	   sta	  $df					  
	   lda	  #$4b					  
	   sta	  $d0					  
ldabe:
	   bne	  ldad8					  

ldac0:
	   ldx	  $81					  
	   cpx	  #$03					  
	   bne	  ldad1					  
	   lda	  $c9					  
	   cmp	  #$3c					  
	   bcs	  ldad1					  
	   rol	  $b2					  
	   sec							  
	   ror	  $b2					  
ldad1:
	   lda	  $91					  
	   clc							  
	   adc	  #$40					  
	   sta	  $91					  
ldad8:
	   dec	  $c4					  
	   bne	  ldae2					  
	   lda	  #$00					  
	   sta	  current_object		  
	   beq	  ldaf7					  

ldae2:
	   ldx	  $c3					  
ldae4:
	   inx							  
	   inx							  
	   cpx	  #$0b					  
	   bcc	  ldaec					  
	   ldx	  #$00					  
ldaec:
	   lda	  inv_slot_lo,x		 
	   beq	  ldae4					  
	   stx	  $c3					  
	   lsr							  
	   lsr							  
	   lsr							  
	   sta	  current_object		  
ldaf7
	lda		#$0d					
	sta		ram_a2					
	sec								
	rts								

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
	   .word WarpToMesaSide-1 ; $dce1/e2
	   .word ld36f-1 ; $dce3/e4
	   .word ld374-1 ; $dce5/e6
	   .word ld374-1 ; $dce7/e8

PlaceItemInInventory
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
	sty		current_object					
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
	lda		ldc5c,y					
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

DetermineIfItemAlreadyTaken:
	   lda	  ldc64,x				  
	   lsr							  
	   tay							  
	   lda	  ldc54,y				  
	   bcs	  ldd53					  
	   and	  ram_c6					 
	   beq	  ldd52					  
	   sec							  
ldd52:
	   rts							  

ldd53:
	   and	  ram_c7					 
	   bne	  ldd52					  
	   clc							  
	   rts							  


ldd59
	and		#$1f					
	tax								
	lda		ram_98					
	cpx		#$0c					
	bcs		ldd67					
	adc		ldfe5,x					
	sta		ram_98					
ldd67
	rts								

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
	jsr		InitializeScreenState					
	jmp		ld3dd					

reset_vars
	lda		#$20					
	sta		inv_slot_lo				  
	lsr								
	lsr								
	lsr								
	sta		current_object					
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
	sta		indy_x					
	lda		#$0f					
	sta		indy_y					
	lda		#starting_room					
	sta		room_num				  
	sta		lives_left					
	jsr		InitializeScreenState					
	jmp		ld80d					

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
	lda		intim					
	bne		ldf9c					
	sta		wsync					
;---------------------------------------
	sta		wsync					
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

	lda		lfff8					
lf003
	cmp		ram_e0					
	bcs		lf01a					
	lsr								
	clc								
	adc		ram_df					
	tay								
	sta		wsync					
;---------------------------------------
	sta		hmove					
	lda		(pf1_data),y			  
	sta		pf1						
	lda		(pf2_data),y			  
	sta		pf2						
	bcc		lf033					
lf01a
	sbc		ram_d4					
	lsr								
	lsr								
	sta		wsync					
;---------------------------------------
	sta		hmove					
	tax								
	cpx		ram_d5					
	bcc		lf02d					
	ldx		ram_d8					
	lda		#$00					
	beq		lf031					
lf02d
	lda		ram_e5,x				
	ldx		ram_d8					
lf031
	sta		pf1,x					
lf033
	ldx		#$1e					
	txs								
	lda		scan_line				   
	sec								
	sbc		indy_y					
	cmp		indy_h					
	bcs		lf079					
	tay								
	lda		(indy_anim),y			   
	tax								
lf043
	lda		scan_line				   
	sec								
	sbc		enemy_y					 
	cmp		snake_y					 
	bcs		lf07d					
	tay								
	lda		(emy_anim),y			  
	tay								
lf050
	lda		scan_line				   
	sta		wsync					
;---------------------------------------
	sta		hmove					
	cmp		ram_d1					
	php								
	cmp		ram_d0					
	php								
	stx		grp1					
	sty		grp0					
	sec								
	sbc		ram_d2					
	cmp		#$08					
	bcs		lf06e					
	tay								
	lda		(ram_d6),y				
	sta		enabl					
	sta		hmbl					
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
	cpy		ram_df					
	bcs		lf081					
	cpy		enemy_y					 
	bcc		lf088					
	sta		grp0					
	bcs		lf0a4					
lf09c
	asl								
	tay								
	and		#$02					
	tax								
	tya								
	sta		(pf1_data,x)			  
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
	sta		enam0					
lf0b5
	sta		wsync					
;---------------------------------------
	sta		hmove					
	txa								
	sec								
	sbc		ram_d5					
	cmp		#$10					
	bcs		lf0ff					
	tay								
	cmp		#$08					
	bcc		lf0fb					
	lda		ram_d8					
	sta		ram_d6					
lf0ca
	lda		(ram_d6),y				
	sta		hmbl					
lf0ce
	ldy		#$00					
	txa								
	cmp		ram_d1					
	bne		lf0d6					
	dey								
lf0d6
	sty		enam1					
	sec								
	sbc		indy_y					
	cmp		indy_h					
	bcs		lf107					
	tay								
	lda		(indy_anim),y			   
lf0e2
	ldy		scan_line				   
	sta		grp1					
	sta		wsync					
;---------------------------------------
	sta		hmove					
	lda		#$02					
	cpx		ram_d2					
	bcc		lf0f9					
	cpx		snake_y					 
	bcc		lf0f5					
lf0f4
	ror								
lf0f5
	sta		enabl					
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
	sta		hmclr					
	cpx		#$a0					
	bcc		lf140					
	jmp		lf1ea					

lf115
	sta		wsync					
;---------------------------------------
	sta		hmove					
	inx								
	lda		ram_84					
	sta		grp0					
	lda		ram_85					
	sta		colup0					
	txa								
	ldx		#$1f					
	txs								
	tax								
	lsr								
	cmp		ram_d2					
	php								
	cmp		ram_d1					
	php								
	cmp		ram_d0					
	php								
	sec								
	sbc		indy_y					
	cmp		indy_h					
	bcs		lf10b					
	tay								
	lda		(indy_anim),y			   
	sta		hmclr					
	inx								
	sta		grp1					
lf140
	sta		wsync					
;---------------------------------------
	sta		hmove					
	bit		ram_d4					
	bpl		lf157					
	ldy		ram_89					
	lda		ram_88					
	lsr		ram_d4					
lf14e
	dey								
	bpl		lf14e					
	sta		resp0					
	sta		hmp0					
	bmi		lf115					
lf157
	bvc		lf177					
	txa								
	and		#$0f					
	tay								
	lda		(emy_anim),y			  
	sta		grp0					
	lda		(ram_d6),y				
	sta		colup0					
	iny								
	lda		(emy_anim),y			  
	sta		ram_84					
	lda		(ram_d6),y				
	sta		ram_85					
	cpy		snake_y					 
	bcc		lf174					
	lsr		ram_d4					
lf174
	jmp		lf115					

lf177
	lda		#$20					
	bit		ram_d4					
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
	lda.wy	ram_df,y				
	sta		refp0					
	sta		nusiz0					
	sta		ram_86					
	bpl		lf1a2					
	lda		ram_96					
	sta		emy_anim				  
	lda		#$65					
	sta		ram_d6					
	lda		#$00					
	sta		ram_d4					
	jmp		lf115					

lf1a2
	lsr		ram_d4					
	jmp		lf115					

lf1a7
	lsr								
	bit		ram_d4					
	beq		lf1ce					
	ldy		ram_87					
	lda		#$08					
	and		ram_86					
	beq		lf1b6					
	lda		#$03					
lf1b6
	eor.wy	ram_e5,y				
	and		#$03					
	tay								
	lda		lfc40,y					
	sta		emy_anim				  
	lda		#$44					
	sta		ram_d6					
	lda		#$0f					
	sta		snake_y					 
	lsr		ram_d4					
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
	sta		ram_d4					
	jmp		lf115					

lf1ea
	sta		wsync					
;---------------------------------------
	sta		hmove					
	ldx		#$ff					
	stx		pf1						
	stx		pf2						
	inx								
	stx		grp0					
	stx		grp1					
	stx		enam0					
	stx		enam1					
	stx		enabl					
	sta		wsync					
;---------------------------------------
	sta		hmove					
	lda		#$03					
	ldy		#$00					
	sty		refp1					
	sta		nusiz0					
	sta		nusiz1					
	sta		vdelp0					
	sta		vdelp1					
	sty		grp0					
	sty		grp1					
	sty		grp0					
	sty		grp1					
	nop								
	sta		resp0					
	sta		resp1					
	sty		hmp1					
	lda		#$f0					
	sta		hmp0					
	sty		refp0					
	sta		wsync					
;---------------------------------------
	sta		hmove					
	lda		#$1a					
	sta		colup0					
	sta		colup1					
	lda		cursor_pos					
	lsr								
	tay								
	lda		lfff2,y					
	sta		hmbl					
	and		#$0f					
	tay								
	ldx		#$00					
	stx		hmp0					
	sta		wsync					
;---------------------------------------
	stx		pf0						
	stx		colubk					
	stx		pf1						
	stx		pf2						
lf24a
	dey								
	bpl		lf24a					
	sta		resbl					
	stx		ctrlpf					
	sta		wsync					
;---------------------------------------
	sta		hmove					
	lda		#$3f					
	and		frame_counter				   
	bne		draw_menu					
	lda		#$3f					
	and		time_of_day					 
	bne		draw_menu					
	lda		ram_b5					
	and		#$0f					
	beq		draw_menu					
	cmp		#$0f					
	beq		draw_menu					
	inc		ram_b5					
draw_menu
	sta		wsync					; draw blank line
	lda		#$42					; set red...
	sta		colubk					; ...as the background color
	sta		wsync					; draw four more scanlines
	sta		wsync					;
	sta		wsync					;
	sta		wsync					;
	lda		#$07					
	sta		ram_84					
draw_inventory
	ldy		ram_84					
	lda		(inv_slot_lo),y			  
	sta		grp0					
	sta		wsync					
;---------------------------------------
	lda		(inv_slot2_lo),y			  
	sta		grp1					
	lda		(inv_slot3_lo),y			  
	sta		grp0					
	lda		(inv_slot4_lo),y			  
	sta		ram_85					
	lda		(inv_slot5_lo),y			  
	tax								
	lda		(inv_slot6_lo),y			  
	tay								
	lda		ram_85					
	sta		grp1					
	stx		grp0					
	sty		grp1					
	sty		grp0					
	dec		ram_84					
	bpl		draw_inventory					 
	lda		#$00					
	sta		wsync					
;---------------------------------------
	sta		grp0					
	sta		grp1					
	sta		grp0					
	sta		grp1					
	sta		nusiz0					
	sta		nusiz1					
	sta		vdelp0					
	sta		vdelp1					
	sta		wsync					
;---------------------------------------
	sta		wsync					
;---------------------------------------
	ldy		#$02					
	lda		ram_c4					
	bne		lf2c6					
	dey								
lf2c6
	sty		enabl					
	ldy		#$08					
	sty		colupf					
	sta		wsync					
;---------------------------------------
	sta		wsync					
;---------------------------------------
	ldy		#$00					
	sty		enabl					
	sta		wsync					
;---------------------------------------
	sta		wsync					
;---------------------------------------
	sta		wsync					
;---------------------------------------
	ldx		#$0f					
	stx		vblank					
	ldx		#$24					
	stx		tim64t					
	ldx		#$ff					
	txs								
	ldx		#$01					
lf2e8
	lda		ram_a2,x				
	sta		audc0,x					
	sta		audv0,x					
	bmi		lf2fb					
	ldy		#$00					
	sty		ram_a2,x				
lf2f4
	sta		audf0,x					
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
	lda		current_object					
	cmp		#$0f					
	beq		lf330					
	cmp		#$02					
	bne		lf344					
	lda		#$84					
	sta		ram_a3					
	bne		lf348					
lf330
	bit		inpt5|$30				
	bpl		lf338					
	lda		#$78					
	bne		lf340					
lf338
	lda		time_of_day					 
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
	bit		ram_93					
	bpl		lf371					
	lda		frame_counter				   
	and		#$07					
	cmp		#$05					
	bcc		lf365					
	ldx		#$04					
	ldy		#$01					
	bit		ram_9d					
	bmi		lf360					
	bit		ram_a1					
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
	sta		ram_d6					
	lda		#$fd					
	sta		ram_d7					
lf371
	ldx		#$02					
lf373
	jsr		lfef4					
	inx								
	cpx		#$05					
	bcc		lf373					
	bit		ram_9d					
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
	sta		ram_d1					
	stx		indy_h					
	bcs		lf3c5					
lf398
	sta		frame_counter				   
	sec								
	ror		ram_9d					
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
	sta		ram_9d					
	dec		lives_left					
	bpl		lf3c5					
	lda		#$ff					
	sta		ram_9d					
	bne		lf3c5					
lf3bf
	lda		room_num				  
	cmp		#ark_room					
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
	bit		ram_b4					
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
	bit		swcha					
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
	sta		current_object					
	cpy		#$90					
	bne		lf437					
	ldy		#mesa_top_room					
	cpy		room_num				  
	bne		lf437					
	lda		#$49					
	sta		ram_8d					
	lda		indy_y					
	adc		#$09					
	sta		ram_d1					
	lda		indy_x					
	adc		#$09					
	sta		ram_cb					
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
	sta		ram_d1					
	lsr								
	sta		ram_8d					
	bne		lf48b					
lf454
	bit		ram_8d					
	bvc		lf48b					
	ldx		#$03					
	jsr		lfcea					
	lda		ram_cb					
	sec								
	sbc		#$04					
	cmp		indy_x					
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
	lda		ram_d1					
	sec								
	sbc		#$05					
	cmp		indy_y					
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
	sta		wsync					
;---------------------------------------
	cpx		#$12					
	bcc		lf4d0					
	txa								
	sbc		indy_y					
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
	sta		grp1					
	lda		indy_y					
	sta		colup1					
lf4c9
	inx								
	cpx		#$90					
	bcs		lf4ea					
	bcc		lf4a6					
lf4d0
	bit		ram_9c					
	bmi		lf4e5					
	txa								
	sbc		#$07					
	bmi		lf4e5					
	tay								
	lda		lfb40,y					
	sta		grp1					
	txa								
	adc		frame_counter				   
	asl								
	sta		colup1					
lf4e5
	inx								
	cpx		#$0f					
	bcc		lf4a6					
lf4ea
	sta		wsync					
;---------------------------------------
	cpx		#$20					
	bcs		lf511					
	bit		ram_9c					
	bmi		lf504					
	txa								
	ldy		#$7e					
	and		#$0e					
	bne		lf4fd					
	ldy		#$ff					
lf4fd
	sty		grp0					
	txa								
	eor		#$ff					
	sta		colup0					
lf504
	inx								
	cpx		#$1d					
	bcc		lf4ea					
	lda		#$00					
	sta		grp0					
	sta		grp1					
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
	sta		grp0					
	stx		colup0					
	inx								
	bne		lf4ea					
	lda		room_num				  
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
       bit    cxp1fb                  
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
       stx    refp0                   
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
       lda    swcha                   
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
       lda    current_object          
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
       ldx    current_object          
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
       lda    swcha                   
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
	sta		wsync					
;---------------------------------------
	sta		hmclr					
	sta		cxclr					
	ldy		#$ff					
	sty		pf1						
	sty		pf2						
	ldx		room_num				  
	lda		room_pf0_gfx,x					
	sta		pf0						
	iny								
	sta		wsync					
;---------------------------------------
	sta		hmove					
	sty		vblank					
	sty		scan_line				   
	cpx		#$04					
	bne		lf865					
	dey								
lf865
	sty		enabl					
	cpx		#$0d					
	beq		lf874					
	bit		ram_9d					
	bmi		lf874					
	ldy		swcha					
	sty		refp1					
lf874
	sta		wsync					
;---------------------------------------
	sta		hmove					
	sta		wsync					
;---------------------------------------
	sta		hmove					
	ldy		room_num				  
	sta		wsync					
;---------------------------------------
	sta		hmove					
	lda		room_pf1_gfx,y					
	sta		pf1						
	lda		room_pf2_gfx,y					
	sta		pf2						
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
	lda		indy_y					
	bmi		lf8cc					
lf8bb
	lda		enemy_y,x				 
	cmp.wy	enemy_y,y				 
	bne		lf8c6					
	cpy		#$05					
	bcs		lf8ce					
lf8c6
	bcs		lf8cc					
	inc		enemy_y,x				 
	bne		lf8ce					
lf8cc
	dec		enemy_y,x				 
lf8ce
	lda		enemy_x,x				 
	cmp.wy	enemy_x,y				 
	bne		lf8d9					
	cpy		#$05					
	bcs		lf8dd					
lf8d9
	bcs		lf8de					
	inc		enemy_x,x				 
lf8dd
	rts								

lf8de
	dec		enemy_x,x				 
	rts								

lf8e1
	lda		enemy_y,x				 
	cmp		#$53					
	bcc		lf8f1					
lf8e7
	rol		ram_8c,x				
	clc								
	ror		ram_8c,x				
	lda		#$78					
	sta		enemy_y,x				 
	rts								

lf8f1
	lda		enemy_x,x				 
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
	ror								
	bcs		lfcef					
	dec		enemy_y,x				 
lfcef
	ror								
	bcs		lfcf4					
	inc		enemy_y,x				 
lfcf4
	ror								
	bcs		lfcf9					
	dec		enemy_x,x				 
lfcf9
	ror								
	bcs		lfcfe					
	inc		enemy_x,x				 
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
	lda		ram_8c,x				
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
