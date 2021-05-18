REPORT ZRMAY16_RT_LOOP.


TABLES: ZTMAY16_CLIENTES.


SELECTION-SCREEN BEGIN OF BLOCK main WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: s_client FOR ZTMAY16_CLIENTES-COD_CLIENTE.
  PARAMETERS      p_nome TYPE Z16NOME.
SELECTION-SCREEN END OF BLOCK main.


TYPES: BEGIN OF ty_client,
         COD_CLIENTE TYPE Z16COD_CLIENTE,   "ZTMAY16_CLIENTES
         NOME        TYPE Z16NOME,          "ZTMAY16_CLIENTES
         SOBRENOME   TYPE Z16SOBRENOME,     "ZTMAY16_CLIENTES
         TIPO        TYPE ZXX_TIPO_TELEFONE,"ZTMAY16_CLI_TELE
         TELEFONE    TYPE AD_TLNMBR1,       "ZTMAY16_CLI_TELE
         PAIS        TYPE LAND1,            "ZTMAY16_CLIENTES
       END OF ty_client,

       BEGIN OF ty_pais,
          land1      TYPE land1,
          landx      TYPE landx,
       END OF ty_pais,

       BEGIN OF ty_output,
         COD_CLIENTE TYPE Z16COD_CLIENTE,   "ZTMAY16_CLIENTES
         NOME        TYPE Z16NOME,          "ZTMAY16_CLIENTES
         SOBRENOME   TYPE Z16SOBRENOME,     "ZTMAY16_CLIENTES
         TIPO        TYPE ZXX_TIPO_TELEFONE,"ZTMAY16_CLI_TELE
         TELEFONE    TYPE AD_TLNMBR1,       "ZTMAY16_CLI_TELE
         PAIS        TYPE LAND1,            "ZTMAY16_CLIENTES
         landx       TYPE landx,            "t005t
       END OF ty_output.
	   

DATA:
  t_client  TYPE TABLE OF ty_client,
  wa_client TYPE          ty_client,
  t_pais    TYPE TABLE OF ty_pais,
  wa_pais   TYPE          ty_pais,
  t_output  TYPE TABLE OF ty_output,
  wa_output TYPE          ty_output.


SELECT a~cod_cliente
           a~nome
           a~sobrenome
           b~tipo
           b~telefone
           a~pais
      FROM ztmay16_clientes AS a
INNER JOIN ztmay16_cli_tele AS b
        ON a~cod_cliente EQ b~cod_cliente
INTO TABLE t_client
     WHERE a~cod_cliente IN s_client.

  IF sy-subrc = 0.
    "cl_demo_output=>display( t_client ).
    SORT t_client BY nome.

            SELECT land1
                   landx
              FROM t005t
        INTO TABLE t_pais
FOR ALL ENTRIES IN t_client
             WHERE spras = sy-langu
               AND land1 = t_client-pais.

    IF sy-subrc IS INITIAL.
      SORT t_pais BY land1.
    ENDIF.
  ENDIF.

**************************************************************
  READ TABLE t_client INTO wa_client WITH KEY nome = 'Fabio'
                                     BINARY SEARCH.

  IF sy-subrc IS INITIAL.
    WRITE: TEXT-m01, /, wa_client-cod_cliente,
                        wa_client-nome,
                        wa_client-sobrenome,
                        wa_client-tipo,
                        wa_client-telefone.
  ENDIF.
**************************************************************

  SKIP 3.

**************************************************************
  READ TABLE t_client INTO wa_client INDEX 2.

  IF sy-subrc IS INITIAL.
    WRITE: TEXT-m02, /, wa_client-cod_cliente,
                        wa_client-nome,
                        wa_client-sobrenome,
                        wa_client-tipo,
                        wa_client-telefone.
  ENDIF.
**************************************************************

  SKIP 3.

**************************************************************
  WRITE TEXT-m03.
  LOOP AT t_client INTO wa_client.

    WRITE: /, wa_client-cod_cliente,
              wa_client-nome,
              wa_client-sobrenome,
              wa_client-tipo,
              wa_client-telefone.

  ENDLOOP.
**************************************************************

  SKIP 3.

**************************************************************
  WRITE TEXT-m04.
  LOOP AT t_client INTO wa_client WHERE nome = 'Pedro'
                                    AND tipo = 'C'.

    WRITE: /, wa_client-cod_cliente,
              wa_client-nome,
              wa_client-sobrenome,
              wa_client-tipo,
              wa_client-telefone.

  ENDLOOP.
**************************************************************

  SKIP 3.

**************************************************************
  WRITE TEXT-m05.
  LOOP AT t_client INTO wa_client.

    IF wa_client-nome = 'Maria'.
      WRITE: /, wa_client-cod_cliente,
                wa_client-nome,
                wa_client-sobrenome,
                wa_client-tipo,
                wa_client-telefone.
    ENDIF.

  ENDLOOP.
**************************************************************

  SKIP 3.

**************************************************************
  WRITE TEXT-m06.
  LOOP AT t_client INTO wa_client.

    IF wa_client-nome = p_nome.
      WRITE: /, wa_client-cod_cliente,
                wa_client-nome,
                wa_client-sobrenome,
                wa_client-tipo,
                wa_client-telefone.
    ENDIF.

  ENDLOOP.
**************************************************************

  SKIP 3.

**************************************************************
  WRITE TEXT-m07.
  LOOP AT t_client INTO wa_client WHERE nome = p_nome.

    WRITE: /, wa_client-cod_cliente,
              wa_client-nome,
              wa_client-sobrenome,
              wa_client-tipo,
              wa_client-telefone.
  ENDLOOP.

  SKIP 3.

**************************************************************
  WRITE TEXT-m08.
  LOOP AT t_client INTO wa_client.

     WRITE: /, wa_client-cod_cliente,
               wa_client-nome,
               wa_client-sobrenome,
               wa_client-tipo,
               wa_client-telefone.

     READ TABLE t_pais INTO wa_pais WITH KEY land1 = wa_client-pais
                                    BINARY SEARCH.

     IF sy-subrc is INITIAL.
       WRITE: wa_pais-land1,
              wa_pais-landx.
     ENDIF.

  ENDLOOP.

  SKIP 3.

**************************************************************
  WRITE TEXT-m09.
  LOOP AT t_client INTO wa_client.

     wa_output-cod_cliente = wa_client-cod_cliente.
     wa_output-nome        = wa_client-nome.
     wa_output-sobrenome   = wa_client-sobrenome.
     wa_output-tipo        = wa_client-tipo.
     wa_output-telefone    = wa_client-telefone.
     wa_output-pais        = wa_client-pais.

         READ TABLE t_pais INTO wa_pais WITH KEY land1 = wa_client-pais.

          IF sy-subrc is INITIAL.
             wa_output-landx      = wa_pais-landx.
          ENDIF.

          APPEND wa_output TO t_output. "Atribui os dados da WA para a tabela interna t_output.
          CLEAR wa_output.              "Limpa os dados da WA.

  ENDLOOP.

  cl_demo_output=>display( t_output ).
**************************************************************

