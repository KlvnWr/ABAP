*&---------------------------------------------------------------------*
*& Include          ZKLVN_CALC_MPOOLF01
*&---------------------------------------------------------------------*

FORM zf_calcular.

  DATA(lf_icon) = ICON_MESSAGE_WARNING.
  DATA(lv_error_message) = lf_icon && ' Formato inválido! Preencha ambos os números.'.

  IF display CA '+'.
    SPLIT display AT '+' INTO
          vg_num1
          vg_num2.

    IF vg_num1 IS INITIAL OR vg_num2 IS INITIAL.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel  = 'Erro'
          txt1   = lv_error_message
          txt2   = ''
        EXCEPTIONS
          OTHERS = 1.
      CALL SELECTION-SCREEN 9000.
      RETURN.
    ENDIF.

    display = vg_num1 + vg_num2.
    CONDENSE display NO-GAPS.

  ELSEIF display CA '-'.
    SPLIT display AT '-' INTO
          vg_num1
          vg_num2.

    IF vg_num1 IS INITIAL OR vg_num2 IS INITIAL.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel  = 'Erro'
          txt1   = lv_error_message
          txt2   = ''
        EXCEPTIONS
          OTHERS = 1.
      CALL SELECTION-SCREEN 9000.
      RETURN.
    ENDIF.

    display = vg_num1 - vg_num2.
    CONDENSE display NO-GAPS.

  ELSEIF display CA '*'.
    SPLIT display AT '*' INTO
          vg_num1
          vg_num2.

    IF vg_num1 IS INITIAL OR vg_num2 IS INITIAL.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel  = 'Erro'
          txt1   = lv_error_message
          txt2   = ''
        EXCEPTIONS
          OTHERS = 1.
      CALL SELECTION-SCREEN 9000.
      RETURN.
    ENDIF.

    display = vg_num1 * vg_num2.
    CONDENSE display NO-GAPS.

  ELSEIF display CA '/'.
    SPLIT display AT '/' INTO
          vg_num1
          vg_num2.

    IF vg_num1 IS INITIAL OR vg_num2 IS INITIAL.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel  = 'Erro'
          txt1   = lv_error_message
          txt2   = ''
        EXCEPTIONS
          OTHERS = 1.
      CALL SELECTION-SCREEN 9000.
      RETURN.
    ENDIF.

    IF vg_num2 EQ 0.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel  = 'Erro'
          txt1   = lf_icon && ' Vai com calma meu amigo, pode isso não'
          txt2   = ''
        EXCEPTIONS
          OTHERS = 1.
      CALL SELECTION-SCREEN 9000.
      RETURN.
    ENDIF.

    display = vg_num1 / vg_num2.
    CONDENSE display NO-GAPS.

  ENDIF.

ENDFORM.