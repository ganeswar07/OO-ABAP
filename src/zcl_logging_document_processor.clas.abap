CLASS zcl_logging_document_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_document_processor.

    METHODS constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA id TYPE string.
ENDCLASS.



CLASS zcl_logging_document_processor IMPLEMENTATION.
  METHOD zif_document_processor~process_document.

    IF io_doc IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

    rv_return =  |{ io_doc->process(  ) } by { me->id }  | .
  ENDMETHOD.

  METHOD constructor.

    me->id = cl_abap_context_info=>get_user_technical_name( ).

  ENDMETHOD.

ENDCLASS.
