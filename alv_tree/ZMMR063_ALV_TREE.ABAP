************************************************************************
*                                                                      *
*             ********************************************             *
*             *                     >                    *             *
*             *                Decathlon                 *             *
*             *        CONFIDENCIAL E PROPRIETÁRIO       *             *
*             *       TODOS OS DIREITOS RESERVADOS       *             *
*             ********************************************             *
*                                                                      *
************************************************************************
* NOME DO PROGRAMA    : ZMMR063                                        *
* TÍTULO DO PROGRAMA  : Visibilidade abastecimento lojas               *
* DESCRIÇÃO           : Visibilidade abastecimento lojas               *
* PROGRAMADOR         : Daniel Takase                                  *
* DATA                : 08/09/2025                                     *
* REQUEST             : DB6K917695                                     *
* JIRA                : ITSPLYBR-258                                   *
*----------------------------------------------------------------------*
*                  Histórico das Modificações                          *
*----------------------------------------------------------------------*
* ID         | Data       | Nome          | Descrição                  *
* Z25DTAKA   | 08/09/2025 | Daniel Takase | Início de Desenvolvimento  *
*----------------------------------------------------------------------*
REPORT zmmr063.

************************************************************************
*** TABLES                                                           ***
************************************************************************
TABLES: mara, "Dados gerais de material
        marc. "Dados de centro para material

TYPE-POOLS: icon.

************************************************************************
*** TIPOS                                                            ***
************************************************************************
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         satnr TYPE mara-satnr.
TYPES: expand TYPE char1,
       END OF ty_mara,

       BEGIN OF ty_marc,
         matnr TYPE marc-matnr,
         werks TYPE marc-werks,
         mmsta TYPE marc-mmsta,
         dismm TYPE marc-dismm,
         indus TYPE marc-indus,
         steuc TYPE marc-steuc,
         eislo TYPE marc-eislo,
       END OF ty_marc,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         lfgja TYPE mard-lfgja,
         lfmon TYPE mard-lfmon,
         labst TYPE mard-labst,
       END OF ty_mard,

       BEGIN OF ty_saida,
         satnr     TYPE mara-satnr,
         matnr     TYPE marc-matnr,
         loja      TYPE marc-werks,
         armaz     TYPE mard-werks,
         lgort     TYPE mard-lgort,
         lfgja     TYPE mard-lfgja,
         lfmon     TYPE mard-lfmon,
         mmsta     TYPE marc-mmsta,
         semaforo1 TYPE char4,
         dismm     TYPE marc-dismm,
         semaforo2 TYPE char4,
         indus     TYPE marc-indus,
         semaforo3 TYPE char4,
         steuc     TYPE marc-steuc,
         semaforo4 TYPE char4,
         eislo     TYPE marc-eislo,
         semaforo5 TYPE char4,
         labst     TYPE mard-labst,
         semaforo6 TYPE char4,
       END OF ty_saida.

************************************************************************
*** TABELAS INTERNAS GLOBAIS                                         ***
************************************************************************
DATA ##NEEDED:
      gt_mara     TYPE TABLE OF ty_mara,
      gt_mara_aux TYPE TABLE OF ty_mara,
      gt_marc     TYPE TABLE OF ty_marc,
      gt_mard     TYPE TABLE OF ty_mard,
      gt_saida    TYPE TABLE OF ty_saida,
      gt_fieldcat TYPE slis_t_fieldcat_alv.

************************************************************************
*** ESTRUTURAS GLOBAIS                                               ***
************************************************************************
DATA ##NEEDED:
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_keyinfo  TYPE slis_keyinfo_alv,
      gs_layout   TYPE slis_layout_alv.

************************************************************************
*** TELA DE SELEÇÃO                                                ***
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1.
SELECT-OPTIONS:
  s_satnr   FOR mara-satnr OBLIGATORY,
  s_werk_l  FOR marc-werks OBLIGATORY.
PARAMETERS:
  p_werk_a TYPE mard-werks DEFAULT 'W041' OBLIGATORY,
  p_lgort  TYPE mard-lgort DEFAULT 'NORM' OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

************************************************************************
*** Evento: START-OF-SELECTION                                       ***
************************************************************************
START-OF-SELECTION.
  PERFORM f_select.
********** FIM DO EVENTO START-OF-SELECTION ************

************************************************************************
*** Evento: START-OF-SELECTION                                       ***
************************************************************************
END-OF-SELECTION.
  PERFORM f_processa.
  PERFORM f_organiza_alv.

*&---------------------------------------------------------------------*
*&      Form f_select.
*&---------------------------------------------------------------------*
*       Selecionar os dados nas tabelas
*-----------------------------------------------------------------------*
FORM f_select.

  SELECT matnr
         satnr
  FROM mara
  INTO TABLE gt_mara ##TOO_MANY_ITAB_FIELDS
  WHERE satnr IN s_satnr.

  IF sy-subrc = 0.

    SELECT  matnr
            werks
            mmsta
            dismm
            indus
            steuc
            eislo
    FROM marc
    INTO TABLE gt_marc
    FOR ALL ENTRIES IN gt_mara
    WHERE matnr EQ gt_mara-matnr
    AND werks IN s_werk_l.

    IF sy-subrc = 0.

      SELECT matnr
             werks
             lgort
             lfgja
             lfmon
             labst
      FROM mard
      INTO TABLE gt_mard
      FOR ALL ENTRIES IN gt_marc
      WHERE matnr EQ gt_marc-matnr
      AND werks EQ  p_werk_a
      AND lgort EQ p_lgort.

    ELSE.
      MESSAGE: TEXT-e02 TYPE 'S' DISPLAY LIKE 'E'. "Não foi encontrado dado de acordo com a condição
      LEAVE LIST-PROCESSING.
    ENDIF.

  ELSE.
    MESSAGE: TEXT-e03 TYPE 'S' DISPLAY LIKE 'E'. "Não foi encontrado nenhum material
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.       "f_select

*&---------------------------------------------------------------------*
*&      Form f_processa.
*&---------------------------------------------------------------------*
*       Passa os dados e organiza nas estruturas atribuindo os icones
*-----------------------------------------------------------------------*
FORM f_processa.
  SORT: gt_mara  BY matnr,
        gt_mard  BY matnr,
        gt_saida BY satnr.

  LOOP AT gt_marc INTO DATA(ls_marc).

    DATA(ls_saida) = VALUE ty_saida( matnr = |{ ls_marc-matnr ALPHA = OUT }|
                                     loja  = ls_marc-werks
                                     mmsta = ls_marc-mmsta
                                     dismm = ls_marc-dismm
                                     indus = ls_marc-indus
                                     steuc = ls_marc-steuc
                                     eislo = ls_marc-eislo ).
    CASE ls_marc-mmsta.
      WHEN space.
        ls_saida-semaforo1 = '@08@'.
      WHEN OTHERS.
        ls_saida-semaforo1 = '@09@'.
    ENDCASE.

    CASE ls_marc-dismm.
      WHEN '11'.
        ls_saida-semaforo2 = '@08@'.
      WHEN '13'.
        ls_saida-semaforo2 = '@09@'.
      WHEN OTHERS.
        ls_saida-semaforo2 = '@0A@'.
    ENDCASE.

    CASE ls_marc-indus.
      WHEN space.
        ls_saida-semaforo3 = '@0A@'.
      WHEN OTHERS.
        ls_saida-semaforo3 = '@08@'.
    ENDCASE.

    CASE ls_marc-steuc.
      WHEN space.
        ls_saida-semaforo4 = '@0A@'.
      WHEN OTHERS.
        ls_saida-semaforo4 = '@08@'.
    ENDCASE.

    CASE ls_marc-eislo.
      WHEN space.
        ls_saida-semaforo5 = '@0A@'.
      WHEN OTHERS.
        ls_saida-semaforo5 = '@08@'.
    ENDCASE.

    READ TABLE gt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_marc-matnr BINARY SEARCH.
    IF sy-subrc = 0.
      ls_saida-satnr = |{ ls_mara-satnr ALPHA = OUT }|.
      ls_mara-satnr =  |{ ls_mara-satnr ALPHA = OUT }|.
      ls_mara-matnr =  |{ ls_mara-matnr ALPHA = OUT }|.


      READ TABLE gt_mard INTO DATA(ls_mard) WITH KEY matnr = ls_marc-matnr BINARY SEARCH.
      IF sy-subrc = 0.
        ls_saida = VALUE #( BASE ls_saida  armaz = ls_mard-werks
                                           lgort = ls_mard-lgort
                                           lfgja = ls_mard-lfgja
                                           lfmon = ls_mard-lfmon
                                           labst = ls_mard-labst ).
        IF ls_mard-labst > 0.
          ls_saida-semaforo6 = '@08@'.
        ELSE.
          ls_saida-semaforo6 = '@0A@'.
        ENDIF.


      ENDIF.

      APPEND ls_saida TO gt_saida.
      APPEND ls_mara TO gt_mara_aux.
      CLEAR: ls_marc, ls_mara, ls_saida.

    ENDIF.

  ENDLOOP.

  SORT gt_mara_aux BY satnr.

  DELETE ADJACENT DUPLICATES FROM gt_mara_aux COMPARING satnr.

ENDFORM.      "f_processa.

*&---------------------------------------------------------------------*
*&      Form f_organiza_alv.
*&---------------------------------------------------------------------*
*       Organiza como o cabeçalho vai ser exibido no ALV
*-----------------------------------------------------------------------*
FORM f_organiza_alv.

  FREE gt_fieldcat.

  PERFORM f_montar_fieldcat USING:
        'SATNR    ' 'GT_MARA_AUX' space  space   TEXT-010  ''  ''  '1', "Material (Modelo)
        'SATNR    ' 'GT_SAIDA'    space  space   TEXT-010  ''  ''  '1', "Material (Modelo)
        'MATNR    ' 'GT_SAIDA'    'MARC' 'MATNR' ''        ''  ''  '2',
        'LOJA     ' 'GT_SAIDA'    space  space   TEXT-007  ''  ''  '3', "Centro L
        'ARMAZ    ' 'GT_SAIDA'    space  space   TEXT-008  ''  ''  '4', "Centro A
        'LGORT    ' 'GT_SAIDA'    'MARD' 'LGORT' ''        ''  ''  '5',
        'LFGJA    ' 'GT_SAIDA'    'MARD' 'LFGJA' ''        ''  ''  '6',
        'LFMON    ' 'GT_SAIDA'    'MARD' 'LFMON' ''        ''  ''  '7',
        'MMSTA    ' 'GT_SAIDA'    'MARC' 'MMSTA' ''        ''  ''  '8',
        'SEMAFORO1' 'GT_SAIDA'    space  space   TEXT-001  'X' '4' '9', "Status Bloqueio
        'DISMM    ' 'GT_SAIDA'    'MARC' 'DISMM' ''        ''  ''  '10',
        'SEMAFORO2' 'GT_SAIDA'    space  space   TEXT-002  'X' '4' '11', "Status MRP
        'INDUS    ' 'GT_SAIDA'    'MARC' 'INDUS' ''        ''  ''  '12',
        'SEMAFORO3' 'GT_SAIDA'    space  space   TEXT-003  'X' '4' '13', "Status CFOP
        'STEUC    ' 'GT_SAIDA'    'MARC' 'STEUC' ''        ''  ''  '14',
        'SEMAFORO4' 'GT_SAIDA'    space  space   TEXT-004  'X' '4' '15', "Status NCM
        'EISLO    ' 'GT_SAIDA'    'MARC' 'EISLO' ''        ''  ''  '16',
        'SEMAFORO5' 'GT_SAIDA'    space  space   TEXT-005  'X' '4' '17', "Status Estoque
        'LABST    ' 'GT_SAIDA'    'MARD' 'LABST' ''        ''  ''  '18',
        'SEMAFORO6' 'GT_SAIDA'    space  space   TEXT-006  'X' '4' '19'. "Status Utilização

  PERFORM f_gerar_alv.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_montar_fieldcat.
*&---------------------------------------------------------------------*
*       Monta o ALV e organiza
*-----------------------------------------------------------------------*
FORM f_montar_fieldcat USING p_fname     TYPE any
                             p_tname     TYPE any
                             p_reftab    TYPE any
                             p_reffield  TYPE any
                             p_seltext   TYPE any
                             p_icon      TYPE any
                             p_outputlen TYPE any
                             p_pos       TYPE any.

  gs_fieldcat-fieldname     = p_fname.
  gs_fieldcat-tabname       = p_tname.
  gs_fieldcat-ref_tabname   = p_reftab.
  gs_fieldcat-ref_fieldname = p_reffield.
  gs_fieldcat-seltext_l     = p_seltext.
  gs_fieldcat-just          = 'C'.
  gs_fieldcat-icon          = p_icon.
  gs_fieldcat-outputlen     = p_outputlen.
  gs_fieldcat-col_pos       = p_pos.
  IF p_fname = 'SATNR' AND p_tname = 'GT_SAIDA'.
    gs_fieldcat-no_out        = 'X'.
  ENDIF.

  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_gerar_alv.
*&---------------------------------------------------------------------*
*       Gera o ALV através da função
*-----------------------------------------------------------------------*
FORM f_gerar_alv.

  gs_layout-expand_all = 'X'.
  gs_layout-expand_fieldname = 'EXPAND'.

  gs_keyinfo-header01 = 'SATNR'.
  gs_keyinfo-item01   = 'SATNR'.

  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
      i_tabname_header   = 'GT_MARA_AUX'
      i_tabname_item     = 'GT_SAIDA'
      is_keyinfo         = gs_keyinfo
    TABLES
      t_outtab_header    = gt_mara_aux
      t_outtab_item      = gt_saida
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
   LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
