CLASS zcl_document_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    TYPES:
      ty_document_type TYPE c LENGTH 2,
      ty_status        TYPE c LENGTH 1,
      ty_amount        TYPE z_de_amount.

    TYPES: BEGIN OF ty_document,
             document_id   TYPE string,
             document_type TYPE ty_document_type,
             status        TYPE ty_status,
             amount        TYPE ty_amount,
             currency      TYPE waers,
             created_by    TYPE syuname,
             created_on    TYPE d,
           END OF ty_document.


    CLASS-METHODS
      create_document
        IMPORTING is_document        TYPE ty_document
        RETURNING VALUE(ro_Document) TYPE REF TO zcl_document
        RAISING   zcx_document_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_document_factory IMPLEMENTATION.


  METHOD create_document.

    CASE is_document-document_type.

      WHEN 'PR'.
        ro_document = NEW zcl_pr_document(
          document_id   = is_document-document_id
          document_type = is_document-document_type
          created_by    = is_document-created_by
          created_on    = is_document-created_on
          status        = is_document-status
          amount        = is_document-amount
          currency      = is_document-currency ).

      WHEN 'PO'.
        ro_document = NEW zcl_po_document(
          document_id   = is_document-document_id
          document_type = is_document-document_type
          created_by    = is_document-created_by
          created_on    = is_document-created_on
          status        = is_document-status
          amount        = is_document-amount
          currency      = is_document-currency ).

      WHEN 'SO'.
        ro_document = NEW zcl_so_document(
          document_id   = is_document-document_id
          document_type = is_document-document_type
          created_by    = is_document-created_by
          created_on    = is_document-created_on
          status        = is_document-status
          amount        = is_document-amount
          currency      = is_document-currency ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_document_error.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
