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

    DATA:
      lo_processor        TYPE REF TO zif_document_processor,
      lo_repository       TYPE REF TO zif_document_repository,
      lo_strategy         TYPE REF TO zif_approval_strategy,
      lo_document         TYPE REF TO zcl_document,
      lo_document_service TYPE REF TO zcl_document_service,
      lo_approval_service TYPE REF TO zcl_approval_service.

    "------------------------------------------------------------
    " 1. Create concrete dependencies
    "------------------------------------------------------------

    lo_processor =
      NEW zcl_logging_document_processor( ).

    lo_repository =
      NEW zcl_document_repository( ).

    lo_strategy =
      NEW zcl_high_val_approval_strategy( ).


    "------------------------------------------------------------
    " 2. Inject dependencies into services
    "------------------------------------------------------------

    TRY.

        lo_document_service =
          NEW zcl_document_service(
            io_processor  = lo_processor
            io_repository = lo_repository ).

        lo_approval_service =
          NEW zcl_approval_service(
            io_approval = lo_strategy ).

      CATCH zcx_document_error INTO DATA(lx_error).

        out->write(
          |Error while creating services: { lx_error->get_text( ) }| ).

        RETURN.

    ENDTRY.


    "------------------------------------------------------------
    " 3. Prepare document request
    "------------------------------------------------------------

    DATA(ls_document_request) =
      VALUE zcl_document_factory=>ty_document(
        document_id   = '900101'
        document_type = 'PR'
        status        = 'N'
        amount        = 75000
        currency      = 'INR'
        created_by    = sy-uname
        created_on    = cl_abap_context_info=>get_system_date( )
      ).


    "------------------------------------------------------------
    " 4. Create document through Factory
    "------------------------------------------------------------

    TRY.

        lo_document =
          zcl_document_factory=>create_document(
            ls_document_request ).

        out->write(
          |Document created: { lo_document->get_document_id( ) }| ).

      CATCH zcx_document_error INTO lx_error.

        out->write(
          |Document creation failed: { lx_error->get_text( ) }| ).

        RETURN.

    ENDTRY.


    "------------------------------------------------------------
    " 5. Process document through Document Service
    "------------------------------------------------------------

    TRY.

        DATA(lv_process_result) =
          lo_document_service->run(
            lo_document ).

        out->write( lv_process_result ).

        lo_document->set_status( 'P' ).

        out->write(
          |Document status: { lo_document->get_status( ) }| ).

      CATCH zcx_document_error INTO lx_error.

        out->write(
          |Document processing failed: { lx_error->get_text( ) }| ).

        RETURN.

    ENDTRY.


    "------------------------------------------------------------
    " 6. Approve through Approval Service
    "------------------------------------------------------------

    TRY.

        IF lo_approval_service->approve(
             lo_document ) = zif_approval_strategy=>c_approve.

          lo_document->set_status( 'C' ).

          out->write(
            |Document approved| ).

        ELSE.

          lo_document->set_status( 'R' ).

          out->write(
            |Document rejected| ).

        ENDIF.

        out->write(
          |Document status: { lo_document->get_status( ) }| ).

      CATCH zcx_document_error INTO lx_error.

        out->write(
          |Approval failed: { lx_error->get_text( ) }| ).

        RETURN.

    ENDTRY.


    "------------------------------------------------------------
    " 7. Save final document through Repository
    "------------------------------------------------------------

    TRY.

        lo_document_service->save_document(
          lo_document ).

        out->write(
          |Document saved successfully in repository| ).

      CATCH zcx_document_error INTO lx_error.

        out->write(
          |Repository save failed: { lx_error->get_text( ) }| ).

        RETURN.

    ENDTRY.


  ENDMETHOD.

ENDCLASS.


