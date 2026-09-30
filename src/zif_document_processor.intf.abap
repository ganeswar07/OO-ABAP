INTERFACE zif_document_processor
  PUBLIC .

  METHODS: PROCESS_DOCUMENT
            IMPORTING
            Io_Doc TYPE REF TO zcl_document
            RETURNING VALUE(rv_return) TYPE String.


ENDINTERFACE.
