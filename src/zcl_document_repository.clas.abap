CLASS zcl_document_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_document_repository .

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_document_ref,
        document_id TYPE string,
        lo_doc      TYPE REF TO zcl_document,
      END OF ty_document_ref,

      tt_document_ref TYPE HASHED TABLE OF ty_document_ref
                       WITH UNIQUE KEY document_id.

    DATA:

       mt_document_refs TYPE  tt_document_ref.


ENDCLASS.



CLASS zcl_document_repository IMPLEMENTATION.


  METHOD zif_document_repository~exists.


    rv_result = xsdbool(
     line_exists(
       mt_document_refs[
         document_id = iv_document_id
       ]
     )
   ).

  ENDMETHOD.


  METHOD zif_document_repository~get_document.
    TRY.
        ro_document =
          mt_document_refs[
            document_id = iv_document_id
          ]-lo_doc.

      CATCH cx_sy_itab_line_not_found.
        RAISE EXCEPTION TYPE zcx_document_error.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_document_repository~save_document.

    IF io_document IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

    DATA(lv_document_id) =
      io_document->get_document_id( ).

    IF me->zif_document_repository~exists(
         iv_document_id = lv_document_id
       ) = abap_true.

      RAISE EXCEPTION TYPE zcx_document_error.
    ENDIF.

    INSERT VALUE #(
      document_id = lv_document_id
      lo_doc      = io_document
    ) INTO TABLE mt_document_refs.


  ENDMETHOD.


ENDCLASS.
