

SPAN {
font-family: "Courier New";
font-size: 10pt;
color: #000000;
background: #FFFFFF;
}
.L0S31 {
font-style: italic;
color: #8B0000;
}
.L0S32 {
color: #3399FF;
}
.L0S33 {
color: #4DA619;
}
.L0S52 {
color: #0000FF;
}
.L0S55 {
color: #800080;
}
.L0S70 {
color: #808080;
}

METHOD onactiondo_upload.

  DATA lr_fp              TYPE REF TO       if_fp.
  DATA lo_nd_daten        TYPE REF TO       if_wd_context_node.
  DATA lo_el_daten        TYPE REF TO       if_wd_context_element.
  DATA ls_daten           TYPE              wd_this->element_rel_objects.
  DATA lv_bin             LIKE              ls_daten-data.
  DATA lv_pdf_form_data   TYPE              xstring.

  DATA: lv_file_name   TYPE                    string,
        lv_flag        TYPE                    boolean,
        lv_name        TYPE                    string,
        lv_string      TYPE                    string,
        lt_worksheets  TYPE STANDARD TABLE OF  string,
        lv_msg         TYPE                    string,
        lt_contents    TYPE                    string_table,
        lcx_excel_core TYPE REF TO             cx_fdt_excel_core,
        lo_data        TYPE REF TO             data,
        lo_excel       TYPE REF TO             cl_fdt_xl_spreadsheet.

  DATA lr_wd_node         TYPE REF TO if_wd_context_node.

  FIELD-SYMBOLS: <fs_table>    TYPE table,
                 <fs_data>     TYPE any,
                 <fs_data_str> TYPE any,
                 <fs_comp>     TYPE any,
                 <fs_output>   TYPE string.

*---- Read uploaded file
  lo_nd_daten = wd_context->get_child_node( name = wd_this->wdctx_rel_objects ).
*---- Get element via lead selection
  lo_el_daten = lo_nd_daten->get_element(  ).
*---- Get single attribute
  lo_el_daten->get_attribute( EXPORTING name  = `DATA`
                              IMPORTING value = lv_bin ).
  TRY.
      CREATE OBJECT lo_excel
        EXPORTING
          document_name = lv_file_name
          xdocument     = lv_bin.
    CATCH cx_fdt_excel_core INTO lcx_excel_core.
      CLEAR lv_msg.
      CALL METHOD lcx_excel_core->if_message~get_text
        RECEIVING
          result = lv_msg.
      RETURN.
  ENDTRY.

  lo_excel->if_fdt_doc_spreadsheet~get_worksheet_names( IMPORTING worksheet_names = lt_worksheets ).

  READ TABLE lt_worksheets INDEX 1 INTO lv_name.
  CHECK sy-subrc EQ 0.
  lo_data = lo_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( lv_name ).
  ASSIGN lo_data->* TO <fs_table>.
  IF <fs_table> IS NOT ASSIGNED.
    RETURN.
  ENDIF.
  LOOP AT <fs_table> ASSIGNING <fs_data>.
    lv_flag = abap_true.
    WHILE lv_flag = abap_true.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_data> TO <fs_comp>.
      IF <fs_comp> IS NOT ASSIGNED.
        lv_flag = abap_false. "Exit the loop when a row ends
        EXIT.
      ELSE.
        CONCATENATE lv_string <fs_comp> INTO lv_string SEPARATED BY '||'. "each cell separated by '||'
      ENDIF.
      UNASSIGN <fs_comp>.
    ENDWHILE.
    SHIFT lv_string LEFT BY 2 PLACES. "Shift to remove leading '||'
    APPEND lv_string TO lt_contents.
    CLEAR lv_string.
  ENDLOOP.

ENDMETHOD.
