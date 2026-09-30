CLASS zcl_so_document DEFINITION
  PUBLIC
  INHERITING FROM zcl_document
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          document_id   TYPE string
          document_type TYPE ty_document_type
          created_by    TYPE syuname
          created_on    TYPE d
          status        TYPE ty_status
          amount        TYPE currencysap
          currency      TYPE waers
        RAISING
          zcx_document_error,

      process REDEFINITION.

  PROTECTED SECTION.
    METHODS: validate REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_so_document IMPLEMENTATION.
  METHOD constructor.

    super->constructor( document_id = document_id document_type = document_type created_by = created_by created_on = created_on status = status amount = amount currency = currency ).

    me->validate(  ).

  ENDMETHOD.

  METHOD validate.

    IF document_type <> 'SO'.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

    IF amount < 1000.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

  ENDMETHOD.

  METHOD process.
    rv_return =  |{ me->document_type } { me->get_document_id(  )  } processed successfully.|.
  ENDMETHOD.

ENDCLASS.
