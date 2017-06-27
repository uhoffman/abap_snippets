  DATA lt_edidd TYPE STANDARD TABLE OF edidd.


  CONSTANTS:
    con_segment_lieferungskopf     TYPE edilsegtyp    VALUE 'E1EDL20',
    con_segment_refdaten_besteller TYPE edilsegtyp    VALUE 'E1EDL41',
    con_segment_lieferungspos      TYPE edilsegtyp    VALUE 'E1EDL24',
    con_adresse_hauptsegment       TYPE edilsegtyp    VALUE 'E1ADRM1',
    con_adresse_zusatzsegment      TYPE edilsegtyp    VALUE 'E1ADRE1',
    con_segment_allgem_textkopf    TYPE edilsegtyp    VALUE 'E1TXTH8',
    con_segment_allgem_text        TYPE edilsegtyp    VALUE 'E1TXTP8',
    con_segment_hu_kopf            TYPE edilsegtyp    VALUE 'E1EDL37',
    con_segment_hu_position        TYPE edilsegtyp    VALUE 'E1EDL44',
    con_partnerart_lieferant       TYPE char3 VALUE 'LF',
    con_qualifier_gln	             TYPE	char3	VALUE	'100',
    con_textid_gln_warenempfaenger TYPE tdid  VALUE 'ZZZZ',

    con_docnum                     TYPE edi_dc40-docnum VALUE '9000000000000001'.


  DATA: lt_edi_dc40    TYPE    edi_dc40_tt,
        lt_edi_dd40    TYPE    edi_dd40_tt,
        ls_e1edl20     TYPE    e1edl20,
        ls_e1adrm1     TYPE    e1adrm1,
        ls_e1adre1     TYPE    e1adre1,
        ls_e1edt13     TYPE    e1edt13,
        ls_e1edl24     TYPE    e1edl24,
        ls_e1edl41     TYPE    e1edl41,
        ls_e1txth8     TYPE    e1txth8,
        ls_e1txtp8     TYPE    e1txtp8,
        l_sgnum_kopf   TYPE    edi4psgnuc,
        l_sgnum_hs     TYPE    edi4psgnuc,
        l_sgnum_txtall TYPE    edi4psgnuc,
        l_sgnum_lfpos  TYPE    edi4psgnuc,
        l_segnum       TYPE    edi4segnuc.

  APPEND INITIAL LINE TO lt_edi_dc40 ASSIGNING FIELD-SYMBOL(<ls_edi_dc40>).
  <ls_edi_dc40>-tabnam = 'EDI_DC40'.
  <ls_edi_dc40>-mandt  = '501'.
  <ls_edi_dc40>-docnum = con_docnum.
  <ls_edi_dc40>-docrel = sy-saprl.
  <ls_edi_dc40>-status = '03'.
  <ls_edi_dc40>-idoctyp = 'DELVRY03'.
  <ls_edi_dc40>-mestyp = 'DESADV'.
  <ls_edi_dc40>-direct = '1'.
  <ls_edi_dc40>-rcvpor = 'SAPZE1'.
  <ls_edi_dc40>-rcvprt = 'LS'.
  <ls_edi_dc40>-rcvprn = 'ZE1CLNT501'.
  <ls_edi_dc40>-sndpor = 'SAPZE1'.
  <ls_edi_dc40>-sndprt = 'LS'.
  <ls_edi_dc40>-sndprn = 'SEEBURGER'.
  <ls_edi_dc40>-outmod = '2'.
  <ls_edi_dc40>-credat = sy-datum.
  <ls_edi_dc40>-cretim = sy-uzeit.
*-----------------------
  ADD 1 TO l_segnum.
  ls_e1edl20-vbeln = 'EDI'."ext. Lieferscheinummer
  APPEND INITIAL LINE TO lt_edi_dd40 ASSIGNING FIELD-SYMBOL(<ls_edi_dd40>).
  <ls_edi_dd40>-docnum = <ls_edi_dc40>-docnum.
  <ls_edi_dd40>-segnam = con_segment_lieferungskopf."'E1EDL20'.
  <ls_edi_dd40>-mandt  = '501'.
  <ls_edi_dd40>-segnum = l_segnum.
  <ls_edi_dd40>-psgnum = ''.
  <ls_edi_dd40>-hlevel = '001'.
  <ls_edi_dd40>-sdata  = ls_e1edl20.
  l_sgnum_kopf = l_segnum.
*-----------------------
  ADD 1 TO l_segnum.
  ls_e1adrm1-partner_q = 'LF'.
  APPEND INITIAL LINE TO lt_edi_dd40 ASSIGNING <ls_edi_dd40>.
  <ls_edi_dd40>-docnum = <ls_edi_dc40>-docnum.
  <ls_edi_dd40>-segnam = con_adresse_hauptsegment.
  <ls_edi_dd40>-mandt  = '501'.
  <ls_edi_dd40>-segnum = l_segnum.
  <ls_edi_dd40>-psgnum = l_sgnum_kopf.
  <ls_edi_dd40>-hlevel = '002'.
  <ls_edi_dd40>-sdata  = ls_e1adrm1.
  l_sgnum_hs = l_segnum.
*-----------------------
  ADD 1 TO l_segnum.
  ls_e1adre1-extend_d = '11111111'.
  APPEND INITIAL LINE TO lt_edi_dd40 ASSIGNING <ls_edi_dd40>.
  <ls_edi_dd40>-docnum = <ls_edi_dc40>-docnum.
  <ls_edi_dd40>-segnam = con_adresse_zusatzsegment.
  <ls_edi_dd40>-mandt  = '501'.
  <ls_edi_dd40>-segnum = l_segnum.
  <ls_edi_dd40>-psgnum = l_sgnum_hs.
  <ls_edi_dd40>-hlevel = '003'.
  <ls_edi_dd40>-sdata  = ls_e1adre1.
*-----------------------
  ADD 1 TO l_segnum.
  ls_e1txth8-tdid = 'XX01'.
  APPEND INITIAL LINE TO lt_edi_dd40 ASSIGNING <ls_edi_dd40>.
  <ls_edi_dd40>-docnum = <ls_edi_dc40>-docnum.
  <ls_edi_dd40>-segnam = con_segment_allgem_textkopf.
  <ls_edi_dd40>-mandt  = '501'.
  <ls_edi_dd40>-segnum = l_segnum.
  <ls_edi_dd40>-psgnum = l_sgnum_kopf.
  <ls_edi_dd40>-hlevel = '002'.
  <ls_edi_dd40>-sdata  = ls_e1txth8.
  l_sgnum_txtall       = l_segnum.
*-----------------------
  ADD 1 TO l_segnum.
  ls_e1txtp8-tdline = '979797'.
  APPEND INITIAL LINE TO lt_edi_dd40 ASSIGNING <ls_edi_dd40>.
  <ls_edi_dd40>-docnum = <ls_edi_dc40>-docnum.
  <ls_edi_dd40>-segnam = con_segment_allgem_text.
  <ls_edi_dd40>-mandt  = '501'.
  <ls_edi_dd40>-segnum = l_segnum.
  <ls_edi_dd40>-psgnum = l_sgnum_txtall.
  <ls_edi_dd40>-hlevel = '003'.
  <ls_edi_dd40>-sdata  = ls_e1txtp8.
*-----------------------
  ADD 1 TO l_segnum.
  ls_e1edl24-posnr = '000001'.
**  ls_e1edl24-matnr =
  ls_e1edl24-lfimg = '20'.
  ls_e1edl24-vrkme = 'PAK'.
  ls_e1edl24-ean11 = 'EAN111111'.
  ls_e1edl24-usr01 = 'PAK'.

*  ls_e1edl24-kdmat = '000000000005073805'.
*  ls_e1edl24-mfrpn =
  APPEND INITIAL LINE TO lt_edi_dd40 ASSIGNING <ls_edi_dd40>.
  <ls_edi_dd40>-docnum = <ls_edi_dc40>-docnum.
  <ls_edi_dd40>-segnam = con_segment_lieferungspos.
  <ls_edi_dd40>-mandt  = '501'.
  <ls_edi_dd40>-segnum = l_segnum.
  <ls_edi_dd40>-psgnum = l_sgnum_kopf.
  <ls_edi_dd40>-hlevel = '002'.
  <ls_edi_dd40>-sdata  = ls_e1edl24.
  l_sgnum_lfpos = l_segnum.
*-----------------------
  ADD 1 TO l_segnum.
  ls_e1edl41-bstnr = '3333333'.
  ls_e1edl41-posex = '555555'.
  APPEND INITIAL LINE TO lt_edi_dd40 ASSIGNING <ls_edi_dd40>.
  <ls_edi_dd40>-docnum = <ls_edi_dc40>-docnum.
  <ls_edi_dd40>-segnam = con_segment_refdaten_besteller.
  <ls_edi_dd40>-mandt  = '501'.
  <ls_edi_dd40>-segnum = l_segnum.
  <ls_edi_dd40>-psgnum = l_sgnum_lfpos.
  <ls_edi_dd40>-hlevel = '003'.
  <ls_edi_dd40>-sdata  = ls_e1edl41.


  CALL FUNCTION 'IDOC_INBOUND_ASYNCHRONOUS'
    TABLES
      idoc_control_rec_40 = lt_edi_dc40
      idoc_data_rec_40    = lt_edi_dd40.
