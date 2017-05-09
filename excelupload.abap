TYPES: BEGIN OF ts_excel,
        smtp       TYPE  string,
        name       TYPE  string,
        data1      TYPE  string,
        data2      TYPE  string,
       END OF ts_excel.

DATA:  lt_file_tab      TYPE      filetable,
       gd_subrc         TYPE      i.
DATA   lv_file          TYPE                    string.
DATA   lv_filepath      TYPE                    localfile.
DATA   lt_xls           TYPE STANDARD TABLE OF  alsmex_tabline.
DATA   ls_xls           TYPE                    alsmex_tabline.
DATA   ls_excel         TYPE                    ts_excel.
DATA   lt_excel         TYPE STANDARD TABLE OF  ts_excel.
DATA   lv_dummy         TYPE                    string.
DATA   lv_count         TYPE                    i.
DATA   lt_list          TYPE                    string_table.

FIELD-SYMBOLS: <fs_comp>            TYPE   any,
               <fs_excel>           TYPE   ts_excel.

CLEAR: lt_file_tab, lt_xls, lv_count.

CALL METHOD cl_gui_frontend_services=>file_open_dialog
  EXPORTING
    window_title     = 'Select File'
    default_filename = '*.xls'
*   multiselection   = 'X'
  CHANGING
    file_table       = lt_file_tab
    rc               = gd_subrc.

READ TABLE lt_file_tab INTO lv_filepath INDEX 1.
IF sy-subrc EQ 0.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = lv_filepath
      i_begin_col             = 1
      i_begin_row             = 2
      i_end_col               = 4
      i_end_row               = 65535
    TABLES
      intern                  = lt_xls
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*----- Tabelle gemäß Excel-Datei aufbauen
  LOOP AT lt_xls INTO ls_xls.
    ASSIGN COMPONENT ls_xls-col OF STRUCTURE ls_excel TO <fs_comp>.
    <fs_comp> = ls_xls-value.
    AT END OF row.

      READ TABLE lt_excel ASSIGNING <fs_excel> WITH KEY smtp = ls_excel-smtp.
      IF sy-subrc EQ 0.
        APPEND <fs_excel>-smtp TO lt_list.
        lv_count = lv_count + 1.
      ENDIF.
      APPEND ls_excel TO lt_excel.
      CLEAR ls_excel.
    ENDAT.
  ENDLOOP.

**  SORT lt_excel BY smtp.
**  LOOP AT lt_excel ASSIGNING <fs_excel>.
**READ TABLE lt_excel TRANSPORTING NO FIELDS with key smtp
**
**
**
**  ENDLOOP.

ENDIF.

LOOP AT lt_list INTO lv_dummy.

  WRITE: lv_dummy.
  NEW-LINE.
ENDLOOP.

******----- Daten übernehmen
*****        CLEAR: lv_records, ls_zb2c_osdispo.
*****        LOOP AT lt_dispoexcel INTO ls_dispoexcel.
*****          lv_index = sy-tabix + 1.
*****          IF ls_dispoexcel-menge EQ '0' OR ls_dispoexcel-menge IS INITIAL.
*****            IF 1 = 2. MESSAGE e045(zsst_b2c). ENDIF.
*****            MESSAGE ID 'ZSST_B2C' TYPE 'E' NUMBER '045' WITH lv_index.
*****            EXIT.
*****          ENDIF.
*****          READ TABLE gt_osdispo_out ASSIGNING <fs_osdispo_out> WITH KEY tnr = ls_dispoexcel-matnr.
*****          IF sy-subrc EQ 0.
*****            CONDENSE ls_dispoexcel-menge NO-GAPS.
*****            <fs_osdispo_out>-nschdispo = ls_dispoexcel-menge.
******------ Summe VK
*****            IF <fs_osdispo_out>-vkpreis_int IS NOT INITIAL.
*****              lv_sumvk = <fs_osdispo_out>-nschdispo * <fs_osdispo_out>-vkpreis_int.
*****              SPLIT lv_sumvk AT '.' INTO lv_sumvk lv_dec.
*****              CONCATENATE lv_sumvk ',' lv_dec INTO <fs_osdispo_out>-disposumvk.
*****            ENDIF.
*****            IF ls_dispoexcel-glc EQ 'X' OR ls_dispoexcel-glc EQ 'true' OR ls_dispoexcel-glc EQ 'TRUE'
*****                                                                       OR ls_dispoexcel-glc EQ 'x'.
*****              <fs_osdispo_out>-glc   = 'X'.
*****              <fs_osdispo_out>-lifnr = gc_glc_lifnr.
*****            ELSE.
*****              CLEAR <fs_osdispo_out>-glc.
*****              <fs_osdispo_out>-lifnr = <fs_osdispo_out>-lifnr_noglc.
*****            ENDIF.
*****            IF ls_dispoexcel-lifdat IS NOT INITIAL.
*****              CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
*****                EXPORTING
*****                  date_external            = ls_dispoexcel-lifdat
*****                IMPORTING
*****                  date_internal            = <fs_osdispo_out>-lieftermin
*****                EXCEPTIONS
*****                  date_external_is_invalid = 1
*****                  OTHERS                   = 2.
*****              IF sy-subrc <> 0.
*****                <fs_osdispo_out>-lieftermin = '9999'.
*****              ENDIF.
*****            ENDIF.
*****          ENDIF.
*****        ENDLOOP.
*****        lv_records_str = lv_index - 1.
*****        MESSAGE ID 'ZSST_B2C' TYPE 'S' NUMBER '038' WITH lv_records_str.
*****        rs_selfield-refresh = 'X'."refresh ALV
*****      ENDIF.
