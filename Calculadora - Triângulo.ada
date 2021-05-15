REPORT ZRMAY16_PROVA NO STANDARD PAGE HEADING.


SELECTION-SCREEN BEGIN OF BLOCK main WITH FRAME TITLE TEXT-h01.

  PARAMETERS: p_a TYPE menge_d OBLIGATORY,
              p_b TYPE menge_d OBLIGATORY,
              p_c TYPE menge_d OBLIGATORY.

SELECTION-SCREEN END OF BLOCK main.


DATA: v_alpha  TYPE CPET_FACTOR1,
      v_beta   TYPE CPET_FACTOR1,
      v_gama   TYPE CPET_FACTOR1,
      v_tipo   TYPE char20,
      v_tp_tri TYPE char20,
      v_status TYPE boolean.
	  
	  
IF ( p_a + p_b ) > p_c AND ( p_a + p_c ) > p_b AND ( p_b + p_c ) > p_a.

    v_alpha = acos( ( ( p_b * p_b ) + ( p_c * p_c ) - ( p_a * p_a ) ) / ( 2 * p_b * p_c ) ).
    v_beta  = acos( ( ( p_a * p_a ) + ( p_c * p_c ) - ( p_b * p_b ) ) / ( 2 * p_a * p_c ) ).

    v_alpha = ( v_alpha * 180 ) / '3.141592'.
    v_beta  = ( v_beta  * 180 ) / '3.141592'.
    v_gama  = 180 - v_alpha - v_beta.

    IF ( p_a = p_b ) 
		AND ( p_a = p_c ) 
			AND ( p_b = p_c ).
      
	  v_tipo = TEXT-i01.
    
	ELSEIF ( p_a = p_b ) 
		OR ( p_a = p_c ) 
			OR ( p_b = p_c ).
      
	  v_tipo = TEXT-i02.
	  
    ELSE.
	
      v_tipo = TEXT-i03.
	  
    ENDIF.

    IF ( v_alpha = '90.000000' ) 
		OR  ( v_beta = '90.000000' ) 
			OR ( v_gama = '90.000000' ).
			
      v_tp_tri = TEXT-i04.
	  
    ELSEIF ( v_alpha < '90.000000' ) 
		AND  ( v_beta < '90.000000' ) 
			AND ( v_gama < '90.000000' ).
			
      v_tp_tri = TEXT-i05.
	  
    ELSEIF ( ( v_alpha > '90.000000'  
		AND  v_alpha < '180.000000' )  
			OR  ( v_beta > '90.000000'  
				AND  v_beta < '180.000000' ) 
					OR ( v_gama > '90.000000'  
						AND  v_gama < '180.000000' ) ).
						
      v_tp_tri = TEXT-i06.
	  
    ENDIF.

  ELSE.

    v_status = abap_true.

  ENDIF.
  
  

IF v_status = abap_false.

    WRITE: TEXT-s01,
         /,/,/ TEXT-r01, p_a,
         /     TEXT-r02, p_b,
         /     TEXT-r03, p_c,
         /,/,/ TEXT-r04, v_alpha,
         /     TEXT-r05, v_beta,
         /     TEXT-r06, v_gama,
         /,/,/ TEXT-r07, v_tipo,
         /     TEXT-r08, v_tp_tri.

  ELSE.

    WRITE: TEXT-e01.

  ENDIF.  
	  
	  