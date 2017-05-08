  TYPES: BEGIN OF tys_endkennzeichen,
           ebeln TYPE    ebeln,
           ebelp TYPE    ebelp,
           elikz TYPE    elikz,
           eglkz TYPE    eglkz,
         END OF tys_endkennzeichen.


  DATA: lt_seltab         TYPE STANDARD TABLE OF  rsparams,
        l_bestellung_id   TYPE                    ebeln,
        lt_endkennzeichen TYPE STANDARD TABLE OF  tys_endkennzeichen,
        lrt_bestellpos    TYPE                    ebelp_range_tty.

  LOOP AT it_positionen ASSIGNING FIELD-SYMBOL(<ls_positionen>).
    l_bestellung_id = <ls_positionen>-blnra.
    APPEND INITIAL LINE TO lrt_bestellpos ASSIGNING FIELD-SYMBOL(<lrs_bestellpos>).
    <lrs_bestellpos>-sign   = 'I'.
    <lrs_bestellpos>-option = 'EQ'.
    <lrs_bestellpos>-low    = <ls_positionen>-bposa.
  ENDLOOP.

  SELECT ebeln ebelp elikz eglkz FROM ekpo INTO CORRESPONDING FIELDS OF TABLE lt_endkennzeichen WHERE ebeln EQ l_bestellung_id
                                                                                                  AND ebelp IN lrt_bestellpos.
  LOOP AT lt_endkennzeichen ASSIGNING FIELD-SYMBOL(<ls_endkennzeichen>).
    IF <ls_endkennzeichen>-elikz IS NOT INITIAL.
      "P_ELIKZ
      APPEND INITIAL LINE TO lt_seltab ASSIGNING FIELD-SYMBOL(<ls_seltab>).
      <ls_seltab>-selname = 'P_ELIKZ'.
      <ls_seltab>-sign    = 'I'.
      <ls_seltab>-option  = 'EQ'.
      <ls_seltab>-low     = space.
      "P_ELI_UP
      APPEND INITIAL LINE TO lt_seltab ASSIGNING <ls_seltab>.
      <ls_seltab>-selname = 'P_ELI_UP'.
      <ls_seltab>-sign    = 'I'.
      <ls_seltab>-option  = 'EQ'.
      <ls_seltab>-low     = abap_true.
    ENDIF.
    IF <ls_endkennzeichen>-eglkz IS NOT INITIAL.
      "P_EALKZ
      APPEND INITIAL LINE TO lt_seltab ASSIGNING <ls_seltab>.
      <ls_seltab>-selname = 'P_EALKZ'.
      <ls_seltab>-sign    = 'I'.
      <ls_seltab>-option  = 'EQ'.
      <ls_seltab>-low     = space.
      "P_EAK_UP
      APPEND INITIAL LINE TO lt_seltab ASSIGNING <ls_seltab>.
      <ls_seltab>-selname = 'P_EAK_UP'.
      <ls_seltab>-sign    = 'I'.
      <ls_seltab>-option  = 'EQ'.
      <ls_seltab>-low     = abap_true.
    ENDIF.
    IF <ls_endkennzeichen>-eglkz IS NOT INITIAL OR <ls_endkennzeichen>-elikz IS NOT INITIAL.
      "S_EBELP-LOW
      APPEND INITIAL LINE TO lt_seltab ASSIGNING <ls_seltab>.
      <ls_seltab>-selname = 'S_EBELP'.
      <ls_seltab>-sign    = 'I'.
      <ls_seltab>-option  = 'EQ'.
      <ls_seltab>-low     = <ls_endkennzeichen>-ebelp.
    ENDIF.
  ENDLOOP.
  IF lt_seltab IS NOT INITIAL.
    APPEND INITIAL LINE TO lt_seltab ASSIGNING <ls_seltab>.
    <ls_seltab>-selname = 'S_EBELN'.
    <ls_seltab>-sign    = 'I'.
    <ls_seltab>-option  = 'EQ'.
    <ls_seltab>-low     = l_bestellung_id.

    APPEND INITIAL LINE TO lt_seltab ASSIGNING <ls_seltab>.
    <ls_seltab>-selname = 'P_TEST'.
    <ls_seltab>-sign    = 'I'.
    <ls_seltab>-option  = 'EQ'.
    <ls_seltab>-low     = p_test.

    SUBMIT z_some_report WITH SELECTION-TABLE lt_seltab AND RETURN.
  ENDIF.
