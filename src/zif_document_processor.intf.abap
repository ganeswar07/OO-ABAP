INTERFACE zif_document_processor
  PUBLIC .

  METHODS: process_document
    IMPORTING
      Io_Doc           TYPE REF TO zcl_document
    RETURNING
      VALUE(rv_return) TYPE String
    RAISING
      zcx_document_error.

ENDINTERFACE.
