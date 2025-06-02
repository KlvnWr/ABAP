*&---------------------------------------------------------------------*
*& Include ZKLVN_CALC_MPOOLTOP                      - PoolMóds.        ZKLVN_CALCULADORA_MPOOL
*&---------------------------------------------------------------------*
PROGRAM zklvn_calculadora_mpool.

TABLES: icon.

"Variáveis

DATA: vg_okcode(4) TYPE c, "Ações de usuário
      vg_num1(32)  TYPE c,
      vg_num2(32)  TYPE c,
      vg_sinal     TYPE char01,
      vg_result    TYPE c,
      vg_operacao  TYPE c VALUE ''.

" Campo para mostrar o que está sendo digitado

DATA: display      TYPE char34.