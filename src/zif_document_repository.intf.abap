INTERFACE zif_document_repository
  PUBLIC .

  METHODS:
    save_document
      IMPORTING io_document TYPE REF TO zcl_document
      RAISING   zcx_document_error,

    get_document
      IMPORTING iv_document_id     TYPE string
      RETURNING VALUE(ro_document) TYPE REF TO zcl_document
      RAISING   zcx_document_error,

    exists
      IMPORTING iv_document_id   TYPE string
      RETURNING VALUE(rv_result) TYPE abap_boolean.

ENDINTERFACE.
