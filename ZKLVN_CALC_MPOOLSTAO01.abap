*&---------------------------------------------------------------------*
*& Include          ZKLVN_CALC_MPOOLSTAO01
*&---------------------------------------------------------------------*

MODULE ZKLVN_CALC_MPOOLUSEO01 OUTPUT.

  SET PF-STATUS '00000001'.
  SET TITLEBAR '001'.

  CASE sy-ucomm.
    WHEN 'APAGAR'.
    display = ''.

  WHEN 'PONTO'.
    DATA(valor) = '.'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'ZERO'.
    valor = '0'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'UM'.
    valor = '1'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'DOIS'.
    valor = '2'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'TRES'.
    valor = '3'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'QUATRO'.
    valor = '4'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'CINCO'.
    valor = '5'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'SEIS'.
    valor = '6'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'SETE'.
    valor = '7'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'OITO'.
    valor = '8'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'NOVE'.
    valor = '9'.
    display = |{ display }{ valor }|.
    CONDENSE display NO-GAPS.

  WHEN 'MAIS'.
    valor = '+'.
    display = |{ display }{ valor }|.

  WHEN 'MENOS'.
    valor = '-'.
    display = |{ display }{ valor }|.

  WHEN 'MULTIPLICAR'.
    valor = '*'.
    display = |{ display }{ valor }|.

  WHEN 'DIVIDIR'.
    valor = '/'.
    display = |{ display }{ valor }|.

  WHEN 'RESULTADO'.
    PERFORM zf_calcular.
  ENDCASE.

ENDMODULE.