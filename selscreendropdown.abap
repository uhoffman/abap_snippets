REPORT  ztest_uhpsl.


TYPE-POOLS vrm.

DATA: lt_data         TYPE          vrm_values,
      ls_data         LIKE LINE OF  lt_data,
      ls_some         TYPE          /glb/9gtt_pslcat,
      lv_id           TYPE          vrm_id.

SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE text-001.
SELECT-OPTIONS : s_porg       FOR     ls_some-company.
PARAMETERS: p_period LIKE /glb/9gtt_pslcat-text AS LISTBOX VISIBLE LENGTH 10.
SELECTION-SCREEN END OF BLOCK bk1.


INITIALIZATION.


  ls_data-key = '01'.
  ls_data-text = 'One month'.
  APPEND ls_data TO lt_data.

  ls_data-key = '02'.
  ls_data-text = 'Two months'.
  APPEND ls_data TO lt_data.

  ls_data-key = '023'.
  ls_data-text = 'Three months'.
  APPEND ls_data TO lt_data.

  MOVE 'P_PERIOD' TO lv_id.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = lv_id
      values = lt_data.
