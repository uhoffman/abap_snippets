  TRY.
 *------
    CATCH ycx_something INTO lo_exc.
      CALL FUNCTION 'RS_EXCEPTION_TO_BAPIRET2'
        EXPORTING
          i_r_exception = lo_exc
        CHANGING
          c_t_bapiret2  = et_return.
      RETURN.
  ENDTRY.
