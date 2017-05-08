  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar        = 'Wirklich beenden'(021)
      diagnose_object = '//'
      text_question   = 'Wollen Sie die Änderungen sichern?'(022)
    IMPORTING
      answer          = ev_ant
    EXCEPTIONS
      OTHERS          = 2.

  IF ev_ant = '1'.
    ev_ant = 'S'.
  ELSEIF ev_ant = 'A'.
    ev_ant = space.
  ELSE.
    ev_ant = 'E'.
  ENDIF.
