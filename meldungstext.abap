   DATA:
    ls_edids      TYPE edids,
    lt_stati      TYPE TABLE OF docnum,
    lv_meld(255),
    lv_mid        LIKE  t100-arbgb,
    lv_mnr        LIKE  t100-msgnr,
    lv_mv1        LIKE  balm-msgv1,
    lv_mv2        LIKE  balm-msgv1,
    lv_mv3        LIKE  balm-msgv1,
    lv_mv4        LIKE  balm-msgv1.
 
 
 CALL FUNCTION 'MESSAGE_PREPARE'
      EXPORTING
        msg_id                 = lv_mid
        msg_no                 = lv_mnr
        msg_var1               = lv_mv1
        msg_var2               = lv_mv2
        msg_var3               = lv_mv3
        msg_var4               = lv_mv4
      IMPORTING
        msg_text               = lv_meld
      EXCEPTIONS
        function_not_completed = 1
        message_not_found      = 2
        OTHERS                 = 3.
