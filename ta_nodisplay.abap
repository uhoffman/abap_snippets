REPORT  z_call_ta.

TABLES: df14l, tstc.

SELECT-OPTIONS:
  s_comp FOR df14l-ps_posid,
  s_trans FOR tstc-tcode.

PARAMETERS p_max TYPE i DEFAULT 100 OBLIGATORY.

TYPES: BEGIN OF tys_devclass,
         devclass TYPE devclass,
         ps_posid TYPE df14l-ps_posid,
       END OF tys_devclass,

       tyt_devclass TYPE TABLE OF tys_devclass.

DATA lt_devclass  TYPE tyt_devclass.
DATA lt_tadir     TYPE TABLE OF tadir.
DATA lt_bdc       TYPE TABLE OF bdcdata.
DATA lt_mess      TYPE TABLE OF bdcmsgcoll.
DATA l_msg        TYPE string.

FIELD-SYMBOLS <ls_tadir> LIKE LINE OF lt_tadir.
FIELD-SYMBOLS <ls_mess> LIKE LINE OF lt_mess.

INITIALIZATION.
  s_comp = 'ICPLE*'.
  APPEND s_comp.

START-OF-SELECTION.
  SELECT devclass ps_posid FROM tdevc AS a INNER JOIN df14l AS b
                            ON a~component = b~fctr_id
                            INTO TABLE lt_devclass
                            WHERE  b~ps_posid IN s_comp.

  IF lt_devclass IS NOT INITIAL.
    SELECT * FROM tadir
      INTO TABLE lt_tadir
      FOR ALL ENTRIES IN lt_devclass
      WHERE object = 'TRAN'
*    AND obj_name LIKE 'VT0%'
*      AND srcsystem = 'SAP'
      AND devclass = lt_devclass-devclass.

    DELETE lt_tadir WHERE obj_name NOT IN s_trans.
  ENDIF.
  LOOP AT lt_tadir ASSIGNING <ls_tadir> TO p_max.
    CLEAR lt_mess.
    CALL TRANSACTION <ls_tadir>-obj_name WITHOUT AUTHORITY-CHECK USING lt_bdc MODE 'N' MESSAGES INTO lt_mess.
    READ TABLE lt_mess ASSIGNING <ls_mess> WITH KEY msgtyp = 'A'.
    IF sy-subrc = 0.
      MESSAGE ID <ls_mess>-msgid TYPE <ls_mess>-msgtyp NUMBER <ls_mess>-msgnr
      WITH <ls_mess>-msgv1 <ls_mess>-msgv2 <ls_mess>-msgv3 <ls_mess>-msgv4 INTO l_msg.

      WRITE:/ <ls_tadir>-obj_name, l_msg.
    ELSE.
      WRITE:/ <ls_tadir>-obj_name.
    ENDIF.
 ENDLOOP.
