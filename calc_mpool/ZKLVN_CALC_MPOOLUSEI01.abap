*&---------------------------------------------------------------------*
*& Include          ZKLVN_CALC_MPOOLUSEI01
*&---------------------------------------------------------------------*

MODULE ZKLVN_CALC_MPOOLUSEI01 INPUT.
  CASE vg_okcode.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      CLEAR vg_okcode.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.