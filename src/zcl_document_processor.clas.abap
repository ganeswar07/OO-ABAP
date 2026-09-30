CLASS zcl_document_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES: zif_document_processor.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_document_processor IMPLEMENTATION.
  METHOD zif_document_processor~process_document.
      rv_return =  io_doc->process(  ).
  ENDMETHOD.

ENDCLASS.
