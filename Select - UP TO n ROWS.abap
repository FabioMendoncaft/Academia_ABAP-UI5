REPORT ZRMAY16_ATIVIDADE2 NO STANDARD PAGE HEADING.


SELECTION-SCREEN BEGIN OF BLOCK c01 WITH FRAME TITLE TEXT-t01.

  PARAMETERS: p_origem  TYPE FCURR_CURR OBLIGATORY,
              p_dest TYPE TCURR_CURR OBLIGATORY.

SELECTION-SCREEN END OF BLOCK c01.

SELECTION-SCREEN BEGIN OF BLOCK c02 WITH FRAME TITLE TEXT-t02.

 PARAMETERS p_conv TYPE DMBTR OBLIGATORY.

SELECTION-SCREEN END OF BLOCK c02.

SELECTION-SCREEN BEGIN OF BLOCK c03 WITH FRAME TITLE TEXT-t03.

  PARAMETERS p_taxa TYPE DMBTR OBLIGATORY.

SELECTION-SCREEN END OF BLOCK c03.



TYPES: BEGIN OF ty_tcurr,
        fcurr TYPE FCURR_CURR,
        tcurr TYPE TCURR_CURR,
        gdatu TYPE GDATU_INV,
        ukurs TYPE UKURS_CURR,
       END OF ty_tcurr.

DATA: wa_tcurr TYPE ty_tcurr,
      v_data   TYPE SYDATUM,
      v_dia    TYPE i,
      v_result TYPE menge_d.
	  
	  
	  
  SELECT FCURR
         TCURR
         GDATU
         UKURS
    FROM TCURR UP TO 1 ROWS
    INTO wa_tcurr
   WHERE FCURR eq p_origem
     AND TCURR eq p_dest.

  ENDSELECT.

  IF sy-subrc eq 0.

    CONVERT INVERTED-DATE wa_tcurr-gdatu INTO DATE v_data.

      IF sy-subrc eq 0.

        v_dia = sy-datlo - v_data.

        IF v_dia < 30.
          v_result = p_conv * wa_tcurr-ukurs.
        ELSE.
          v_result = p_conv * p_taxa.
        ENDIF.

      ENDIF.

  ENDIF.	  
	  
	  
  IF v_dia < 30.

    ULINE AT 1(80).
    WRITE: / sy-vline, TEXT-c01, sy-uname,              80 sy-vline,
           / sy-vline, TEXT-c02, sy-datum,              80 sy-vline,
           / sy-vline, TEXT-c03, sy-uzeit,              80 sy-vline,
           / sy-vline, '',                              80 sy-vline.
    ULINE AT 1(80).

    WRITE: / sy-vline,TEXT-e01, p_origem,               80 sy-vline,
           / sy-vline,TEXT-e02, p_dest,                 80 sy-vline,
           / sy-vline,TEXT-e03, p_conv,                 80 sy-vline,
           / sy-vline,TEXT-e04, wa_tcurr-ukurs,         80 sy-vline,
           / sy-vline,TEXT-e05, p_dest, '):', v_result, 80 sy-vline,
           / sy-vline, '',                              80 sy-vline.
    ULINE AT 1(80).

  ELSE.

    ULINE AT 1(80).
    WRITE: / sy-vline, TEXT-c01, sy-uname,              80 sy-vline,
           / sy-vline, TEXT-c02, sy-datum,              80 sy-vline,
           / sy-vline, TEXT-c03, sy-uzeit,              80 sy-vline,
           / sy-vline, '',                              80 sy-vline.
    ULINE AT 1(80).

    WRITE: / sy-vline,TEXT-e01, p_origem,               80 sy-vline,
           / sy-vline,TEXT-e02, p_dest,                 80 sy-vline,
           / sy-vline,TEXT-e03, p_conv,                 80 sy-vline,
           / sy-vline,TEXT-e06, p_taxa,                 80 sy-vline,
           / sy-vline,TEXT-e05, p_dest, '):', v_result, 80 sy-vline,
           / sy-vline, '',                              80 sy-vline.
    ULINE AT 1(80).

  ENDIF.
  