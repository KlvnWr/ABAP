*&---------------------------------------------------------------------*
*& Include ZKLVN_CALC_MPOOLTOP                      - PoolMóds.        ZKLVN_CALCULADORA_MPOOL
*&---------------------------------------------------------------------*
PROGRAM zklvn_calculadora_mpool.

TABLES: icon.

"Variáveis

DATA: vg_okcode(4) TYPE c, "Ações de usuário
      vg_num1(32)  TYPE c, "Primeiro número
      vg_num2(32)  TYPE c, "Segundo número
      vg_sinal     TYPE char01. " Operação

" Campo para mostrar o que está sendo digitado

DATA: display      TYPE char34. " campo que exibe os números.
