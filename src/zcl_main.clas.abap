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

    DATA status TYPE zcl_document=>ty_status.
    DATA(lo_standard) =
      NEW zcl_standard_approval_strategy( ).

    DATA(lo_high_value) =
      NEW zcl_high_val_approval_strategy( ).

    TRY.
        DATA(lo_standard_service) =
          NEW zcl_approval_service(
            io_approval = lo_standard
          ).

      CATCH zcx_document_error INTO DATA(lx_error).
        out->write( |Error while creating standand Service  : { lx_error->get_text(  ) }| ).
    ENDTRY.

    TRY.
        DATA(lo_high_value_service) =
          NEW zcl_approval_service(
            io_approval = lo_high_value
          ).
      CATCH zcx_document_error INTO lx_error.
        out->write( |Error while creating value High Service  : { lx_error->get_text(  ) }| ).
    ENDTRY.


    TRY.
        " TC01: Standard approves 30,000
        DATA(lo_doc1) =
          zcl_document_factory=>create_document(
            VALUE zcl_document_factory=>ty_document(
              document_id   = '900001'
              document_type = 'PR'
              created_by    = sy-uname
              created_on    = cl_abap_context_info=>get_system_date( )
              status        = 'N'
              amount        = 30000
              currency      = 'INR'
            )
          ).

      CATCH zcx_document_error INTO lx_error.
        out->write( |Error while creating document : 900001  : { lx_error->get_text(  ) }| ).
    ENDTRY.


    TRY.
        IF lo_standard_service->approve( lo_doc1 )
        = zif_approval_strategy=>c_approve.
          out->write( 'TC01 PASS: Standard approved 30000' ).
        ELSE.
          out->write( 'TC01 FAIL' ).
        ENDIF.
      CATCH zcx_document_error INTO lx_error.

        out->write( |Error while approving  : { lx_error->get_text(  ) }| ).
    ENDTRY.


    TRY.
        " TC02: Standard rejects 75,000
        DATA(lo_doc2) =
          zcl_document_factory=>create_document(
            VALUE zcl_document_factory=>ty_document(
              document_id   = '900002'
              document_type = 'PR'
              created_by    = sy-uname
              created_on    = cl_abap_context_info=>get_system_date( )
              status        = 'N'
              amount        = 75000
              currency      = 'INR'
            )
          ).

      CATCH zcx_document_error INTO lx_error.
        out->write( |Error while creating document : 900002 : { lx_error->get_text(  ) }| ).
    ENDTRY.


    TRY.

        IF lo_standard_service->approve( lo_doc2 )
            = zif_approval_strategy=>c_reject.
          out->write( 'TC02 PASS: Standard rejected 75000' ).
        ELSE.
          out->write( 'TC02 FAIL' ).
        ENDIF.




        " TC03: High-value approves 75,000
        IF lo_high_value_service->approve( lo_doc2 )
            = zif_approval_strategy=>c_approve.
          out->write( 'TC03 PASS: High-value approved 75000' ).
        ELSE.
          out->write( 'TC03 FAIL' ).
        ENDIF.

      CATCH zcx_document_error INTO lx_error.

        out->write( |Error while approving  : { lx_error->get_text(  ) }| ).
    ENDTRY.

    TRY.
        " TC04: High-value rejects 120,000
        DATA(lo_doc4) =
          zcl_document_factory=>create_document(
            VALUE zcl_document_factory=>ty_document(
              document_id   = '900004'
              document_type = 'SO'
              created_by    = sy-uname
              created_on    = cl_abap_context_info=>get_system_date( )
              status        = 'N'
              amount        =  120000
              currency      = 'INR'
            )
          ).


      CATCH zcx_document_error INTO lx_error.
        out->write( |Error while creating document : 900004 : { lx_error->get_text(  ) }| ).
    ENDTRY.



    TRY.
        IF lo_high_value_service->approve( lo_doc4 )
            = zif_approval_strategy=>c_reject.
          out->write( 'TC04 PASS: High-value rejected 120000' ).
        ELSE.
          out->write( |TC04 FAIL : { lo_doc4->get_amount( ) } | ).
        ENDIF.


      CATCH zcx_document_error INTO lx_error.

        out->write( |Error while approving  : { lx_error->get_text(  ) }| ).
    ENDTRY.


    TRY.
        " TC05: Both approve exactly 50,000
        DATA(lo_doc5) =
          zcl_document_factory=>create_document(
            VALUE zcl_document_factory=>ty_document(
              document_id   = '900005'
              document_type = 'PR'
              created_by    = sy-uname
              created_on    = cl_abap_context_info=>get_system_date( )
              status        = 'N'
              amount        = 50000
              currency      = 'INR'
            )
          ).

      CATCH zcx_document_error INTO lx_error.
        out->write( |Error while creating document : 900005 : { lx_error->get_text(  ) }| ).
    ENDTRY.

    TRY.
        IF lo_standard_service->approve( lo_doc5 )
            = zif_approval_strategy=>c_approve
           AND
           lo_high_value_service->approve( lo_doc5 )
            = zif_approval_strategy=>c_approve.
          out->write( 'TC05 PASS: Both approved 50000' ).
        ELSE.
          out->write( 'TC05 FAIL' ).
        ENDIF.

      CATCH zcx_document_error INTO lx_error.

        out->write( |Error while approving  : { lx_error->get_text(  ) }| ).
    ENDTRY.


  ENDMETHOD.
ENDCLASS.


