REPORT ZRMAY16_FOR_ALL_ENTRIES.


TABLES: ZTMAY16_CLIENTES. "Dados básicos de clientes


SELECTION-SCREEN BEGIN OF BLOCK main WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: s_client FOR ZTMAY16_CLIENTES-COD_CLIENTE. "DESCRIÇÃO DO PARÂMETRO

SELECTION-SCREEN END OF BLOCK main.


TYPES: BEGIN OF ty_client,
         COD_CLIENTE   TYPE Z16COD_CLIENTE,
         NOME          TYPE Z16NOME,
         SOBRENOME     TYPE Z16SOBRENOME,
       END OF  ty_client,

       BEGIN OF ty_endereco,
         CEP           TYPE Z16COD_ENDERENCO,
         CIDADE        TYPE Z16CEP,
         BAIRRO        TYPE Z16BAIRRO,
         LOGRADOURO    TYPE Z16LOGRADOURO,
         NUMERO        TYPE Z16NUMERO,
       END OF  ty_endereco.
	   

DATA:
  t_client   TYPE TABLE OF ty_client,
  t_end      TYPE TABLE OF ty_endereco.
  

    SELECT COD_CLIENTE
           NOME
           SOBRENOME
      FROM ZTMAY16_CLIENTES
INTO TABLE t_client
     WHERE COD_CLIENTE IN s_client.

     IF sy-subrc = 0.

             SELECT CEP
                    CIDADE
                    BAIRRO
                    LOGRADOURO
                    NUMERO
               FROM ZTMAY16_ENDERECO
         INTO TABLE t_end
 FOR ALL ENTRIES IN t_client
              WHERE COD_ENDERENCO EQ t_client-COD_CLIENTE.

              IF sy-subrc = 0.

              ENDIF.
     ENDIF.  


	  
	  