CLASS zcl_document DEFINITION
  PUBLIC
  CREATE PUBLIC ABSTRACT.

  PUBLIC SECTION.

    TYPES:
      ty_document_type TYPE c LENGTH 2,
      ty_status        TYPE c LENGTH 1,
      ty_amount        TYPE  z_de_amount.

    METHODS:
      constructor
        IMPORTING
          document_id   TYPE string
          document_type TYPE ty_document_type
          created_by    TYPE syuname
          created_on    TYPE d
          status        TYPE ty_status
          amount        TYPE ty_amount
          currency      TYPE waers
        RAISING
          zcx_document_error,

      get_document_id
        RETURNING
          VALUE(rv_document_id) TYPE string,

      get_status
        RETURNING
          VALUE(rv_status) TYPE ty_status,

      get_amount
        RETURNING
          VALUE(rv_amount) TYPE ty_amount ,

      set_status
        IMPORTING
          iv_status TYPE ty_status
        RAISING
          zcx_document_error,

      process  ABSTRACT
        RETURNING
          VALUE(rv_return) TYPE string .

  PROTECTED SECTION.

    DATA:
      document_type TYPE ty_document_type,
      amount        TYPE ty_amount.

    METHODS validate  ABSTRACT
      RAISING
        zcx_document_error .
  PRIVATE       SECTION.
    DATA:
      document_id TYPE string,
      status      TYPE ty_status,
      currency    TYPE waers,
      created_by  TYPE syuname,
      created_on  TYPE d.


ENDCLASS.



CLASS zcl_document IMPLEMENTATION.
  METHOD constructor.

    IF document_id IS INITIAL
     OR document_type IS INITIAL
     OR created_by IS INITIAL
     OR created_on IS INITIAL
     OR status IS INITIAL
     OR currency IS INITIAL.

      RAISE EXCEPTION TYPE zcx_document_error.

    ENDIF.

    CASE document_type.
      WHEN 'PR' OR 'PO' OR 'SO' .

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_document_error.

    ENDCASE.

    CASE status.
      WHEN 'N' OR 'P' OR 'C'.

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_document_error.

    ENDCASE.

    IF amount < 0.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

    me->document_id = document_id.
    me->document_type = document_type.
    me->created_by = created_by.
    me->created_on = created_on.
    me->status = status.
    me->amount =  amount .
    me->currency = currency.

  ENDMETHOD.

  METHOD get_amount.

    rv_amount =  me->amount.

  ENDMETHOD.

  METHOD get_document_id.
    rv_document_id = me->document_id.
  ENDMETHOD.

  METHOD get_status.
    rv_status = me->status.

  ENDMETHOD.

  METHOD set_status.

    CASE iv_status.
      WHEN 'N' OR 'P' OR 'C'.
        me->status = iv_status.

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_document_error.
    ENDCASE.

  ENDMETHOD.


ENDCLASS.
