*&---------------------------------------------------------------------*
*& Include          ZKLVN_CALC_MPOOLUSEI01
*&---------------------------------------------------------------------*

MODULE ZKLVN_CALC_MPOOLUSEI01 INPUT.
  "Ação do usuario
  CASE vg_okcode.

    WHEN 'BACK' OR 'EXIT' OR 'CANC'. "Três botões para sair
      CLEAR vg_okcode.
      LEAVE PROGRAM. " Sai do programa

  ENDCASE.

ENDMODULE.
