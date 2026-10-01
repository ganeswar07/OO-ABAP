CLASS zcl_logging_document_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_document_processor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA id TYPE string VALUE '2345678'.
ENDCLASS.



CLASS zcl_logging_document_processor IMPLEMENTATION.
  METHOD zif_document_processor~process_document.

    IF io_doc IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

    rv_return =  |{ io_doc->process(  ) } by { me->id }  | .
  ENDMETHOD.

ENDCLASS.
