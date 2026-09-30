CLASS zcl_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.



    DATA(lo_normal_service) = NEW zcl_document_service(
     io_processor = NEW zcl_document_processor( )
     io_repository = NEW zcl_document_repository(  )
    ).

    " TC01: ID does not exist before saving
    IF lo_normal_service->exists(
         iv_document_id = '100001'
       ) = abap_false.

      out->write( 'TC01 PASS: ID not found initially' ).

    ELSE.
      out->write( 'TC01 FAIL' ).
    ENDIF.

    TRY.
        " TC02: Save PR

        lo_normal_service->save_document(
          zcl_document_factory=>create_document(
             VALUE zcl_document_factory=>ty_document(
              document_id   = '100001'
                document_type = 'PR'
                created_by    = sy-uname
                created_on    = cl_abap_context_info=>get_system_date( )
                status        = 'N'
                amount        = 50000
                currency      = 'INR'
            )
         )
        ).

        out->write( 'TC02 PASS: PR saved' ).

      CATCH zcx_document_error INTO DATA(lx_error).
        out->write( |TC02 FAIL: { lx_error->get_text( ) }| ).
    ENDTRY.


    " TC03: ID exists after saving
    IF lo_normal_service->exists(
         iv_document_id = '100001'
       ) = abap_true.

      out->write( 'TC03 PASS: ID exists' ).

    ELSE.
      out->write( 'TC03 FAIL' ).
    ENDIF.


    " TC04 and TC05: Retrieve and process PR
    TRY.
        DATA(lo_pr) = lo_normal_service->get_document(
          '100001'
        ).

        out->write( 'TC04 PASS: PR retrieved' ).

        out->write(
          |TC05: { lo_normal_service->run( lo_pr ) }|
        ).

      CATCH zcx_document_error INTO lx_error.
        out->write( |TC04/05 FAIL: { lx_error->get_text( ) }| ).
    ENDTRY.


    " TC06: Save P0
    TRY.
        lo_normal_service->save_document(
            zcl_document_factory=>create_document(
             VALUE zcl_document_factory=>ty_document(
        document_id   = '100123'
        document_type = 'PO'
        created_by    = sy-uname
        created_on    = cl_abap_context_info=>get_system_date( )
        status        = 'P'
        amount        = 50000
        currency      = 'INR'
      )
     )
    ).

        out->write( 'TC06 PASS: PO saved' ).

      CATCH zcx_document_error INTO lx_error.
        out->write( |TC06 FAIL: { lx_error->get_text( ) }| ).
    ENDTRY.

    " TC07: Save SO
    TRY.
        lo_normal_service->save_document(
           zcl_document_factory=>create_document(
             VALUE zcl_document_factory=>ty_document(
              document_id   = '1000100'
            document_type = 'SO'
            created_by    = sy-uname
            created_on    = cl_abap_context_info=>get_system_date( )
            status        = 'N'
            amount        = 50000
            currency      = 'INR'
          )
         )
        ).

        out->write( 'TC07 PASS: SO saved' ).

      CATCH zcx_document_error INTO lx_error.
        out->write( |TC07 FAIL: { lx_error->get_text( ) }| ).
    ENDTRY.


    " TC08: Duplicate ID
    TRY.
        lo_normal_service->save_document(
           zcl_document_factory=>create_document(
             VALUE zcl_document_factory=>ty_document(
            document_id   = '100001'
            document_type = 'PR'
            created_by    = sy-uname
            created_on    = cl_abap_context_info=>get_system_date( )
            status        = 'N'
            amount        = 50000
            currency      = 'INR'
          )
         )
        ).

        out->write( 'TC08 FAIL: Duplicate was accepted' ).

      CATCH zcx_document_error INTO lx_error.
        out->write( 'TC08 PASS: Duplicate rejected' ).
    ENDTRY.


    " TC09: Unknown document
    TRY.
        DATA(lo_missing) = lo_normal_service->get_document(
          '3456789'
        ).

        out->write( 'TC09 FAIL: Unknown ID retrieved' ).

      CATCH zcx_document_error INTO lx_error.
        out->write( 'TC09 PASS: Unknown ID rejected' ).
    ENDTRY.


    " TC10: Unknown document
    DATA lo_empty_doc TYPE REF TO zcl_document.

    TRY.
        lo_normal_service->save_document(
          io_document = lo_empty_doc
        ).

        out->write(
          'TC10 FAIL: Initial reference was accepted'
        ).

      CATCH zcx_document_error INTO lx_error.
        out->write(
          'TC10 PASS: Initial reference rejected'
        ).
    ENDTRY.

    " TC11: Unsupported document type
    TRY.
        DATA(lo_invalid) =
          zcl_document_factory=>create_document(
            VALUE #(
              document_id   = '900001'
              document_type = 'XX'
              created_by    = sy-uname
              created_on    = cl_abap_context_info=>get_system_date( )
              status        = 'N'
              amount        = 50000
              currency      = 'INR'
            )
          ).

        out->write( 'TC11 FAIL: Unsupported type accepted' ).

      CATCH zcx_document_error.
        out->write( 'TC11 PASS: Unsupported type rejected' ).
    ENDTRY.



  ENDMETHOD.
ENDCLASS.


