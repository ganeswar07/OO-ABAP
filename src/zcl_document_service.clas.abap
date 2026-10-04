CLASS zcl_document_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:

      constructor
        IMPORTING
          io_processor  TYPE REF TO zif_document_processor
          io_repository TYPE REF TO zif_document_repository
        RAISING
          zcx_document_error ,

      run
        IMPORTING io_document      TYPE REF TO zcl_document
        RETURNING VALUE(rv_return) TYPE String
        RAISING
                  zcx_document_error ,


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



  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: doc_processor  TYPE REF TO zif_document_processor,
          doc_repository TYPE REF TO zif_document_repository.

ENDCLASS.



CLASS zcl_document_service IMPLEMENTATION.

  METHOD constructor.

    IF io_processor IS NOT BOUND
       OR io_repository IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

    me->doc_processor = io_processor.
    me->doc_repository = io_repository.

  ENDMETHOD.

  METHOD run.

    rv_return = doc_processor->process_document( io_document ).

  ENDMETHOD.

  METHOD exists.

    rv_result = doc_repository->exists( iv_document_id ).

  ENDMETHOD.

  METHOD get_document.

    ro_document = doc_repository->get_document( iv_document_id ).

  ENDMETHOD.

  METHOD save_document.

    doc_repository->save_document( io_document ).

  ENDMETHOD.

ENDCLASS.
