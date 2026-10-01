CLASS zcl_standard_approval_strategy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_approval_strategy .
  PROTECTED SECTION.
  PRIVATE SECTION.



ENDCLASS.



CLASS zcl_standard_approval_strategy IMPLEMENTATION.


  METHOD zif_approval_strategy~approve.

    IF io_document IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF..

    rv_approved = COND #(
        WHEN io_document->get_amount(  ) <= conv z_de_amount( '50000' ) THEN zif_approval_strategy=>c_approve
        ELSE zif_approval_strategy=>c_reject
     ).

  ENDMETHOD.
ENDCLASS.
