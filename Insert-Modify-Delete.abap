REPORT ZRMAY16_INSERT_MODIFY.


SELECTION-SCREEN BEGIN OF BLOCK main WITH FRAME TITLE TEXT-t01.

  PARAMETERS: p_file TYPE STRING.

SELECTION-SCREEN END OF BLOCK main.

  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
    CALL FUNCTION '/SAPDMC/LSM_F4_FRONTEND_FILE'
      CHANGING
        pathfile               = p_file
     EXCEPTIONS
       CANCELED_BY_USER       = 1
       SYSTEM_ERROR           = 2
       OTHERS                 = 3.

    IF sy-subrc <> 0.

    ENDIF.
	
	
TYPES: BEGIN OF ty_file,
        COD_CLIENTE TYPE Z16COD_CLIENTE,
        NOME        TYPE Z16NOME,
        SOBRENOME   TYPE Z16SOBRENOME,
        PAIS        TYPE t001,
        TIPO        TYPE ZXX_TIPO_TELEFONE,
        TELEFONE    TYPE AD_TLNMBR1,
       END OF ty_file.


DATA:
  t_file     TYPE TABLE OF ty_file,
  t_client   TYPE TABLE OF ZTMAY16_CLIENTES,
  t_cli_tele TYPE TABLE OF ZTMAY16_CLI_TELE.	


DATA:
  wa_file     TYPE ty_file,
  wa_client   TYPE ZTMAY16_CLIENTES,
  wa_cli_tele TYPE ZTMAY16_CLI_TELE. 


START-OF-SELECTION.

	CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = p_file
      FILETYPE                = 'ASC'
      HAS_FIELD_SEPARATOR     = 'X'
    TABLES
      data_tab                = t_file
*   CHANGING
*     ISSCANPERFORMED         = ' '
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.

  ENDIF.

  IF t_file IS NOT INITIAL.

    LOOP AT t_file INTO wa_file.

      wa_client-mandt       = sy-mandt.
      wa_client-cod_cliente = wa_file-cod_cliente.
      wa_client-nome        = wa_file-nome.
      wa_client-sobrenome   = wa_file-sobrenome.
      wa_client-pais        = wa_file-pais.

      APPEND wa_client TO t_client.
      CLEAR  wa_client.

      wa_cli_tele-mandt       = sy-mandt.
      wa_cli_tele-cod_cliente = wa_file-cod_cliente.
      wa_cli_tele-tipo        = wa_file-tipo.
      wa_cli_tele-telefone    = wa_file-telefone.

      APPEND wa_cli_tele TO t_cli_tele.
      CLEAR  wa_client.

    ENDLOOP.

*****************************INSERT*************************
*
*    INSERT ztmay16_clientes FROM TABLE t_client.
*
*    INSERT ztmay16_cli_tele FROM TABLE t_cli_tele.
*
*    IF sy-subrc IS INITIAL.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*
*************************************************************


**************************MODIFY*****************************
*
*    MODIFY ztmay16_clientes FROM TABLE t_client.
*
*    MODIFY ztmay16_cli_tele FROM TABLE t_cli_tele.
*
*    IF sy-subrc is INITIAL.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*
*************************************************************


***************************DELETE****************************
*
*    DELETE ztmay16_clientes FROM TABLE t_client.
*
*    DELETE ztmay16_cli_tele FROM TABLE t_cli_tele.
*
*    IF sy-subrc is INITIAL.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*
*************************************************************
  ENDIF.

END-OF-SELECTION.  
  
  
  