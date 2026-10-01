CLASS zcl_approval_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS
      constructor
        IMPORTING
          io_approval TYPE REF TO zif_approval_strategy
        RAISING
          zcx_document_error.
    .

    METHODS approve
      IMPORTING
        io_document        TYPE REF TO zcl_document
      RETURNING
        VALUE(rv_approved) TYPE abap_boolean
      RAISING
        zcx_document_error.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA : approval TYPE REF TO zif_approval_strategy.

ENDCLASS.




CLASS zcl_approval_service IMPLEMENTATION.

  METHOD constructor.

    IF io_approval IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

    me->approval = io_approval.

  ENDMETHOD.

  METHOD approve.
    rv_approved = approval->approve( io_document ).
  ENDMETHOD.

ENDCLASS.
