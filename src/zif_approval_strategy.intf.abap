INTERFACE zif_approval_strategy
  PUBLIC .


  CONSTANTS : c_approve type abap_boolean VALUE abap_true,
              c_reject type abap_boolean VALUE abap_false.

  METHODS approve
    IMPORTING
      io_document        TYPE REF TO zcl_document
    RETURNING
      VALUE(rv_approved) TYPE abap_boolean
    RAISING
      zcx_document_error.

ENDINTERFACE.
