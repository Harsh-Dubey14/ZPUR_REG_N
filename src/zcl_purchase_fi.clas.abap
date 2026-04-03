CLASS zcl_purchase_fi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_purchase_fi IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA: lt_response TYPE TABLE OF zce_pur_reg_fi,
          ls_response TYPE zce_pur_reg_fi.

    " Pagination parameters from request
    DATA(lv_top)    = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)   = io_request->get_paging( )->get_offset( ).

    " Handle invalid pagination inputs
    IF lv_top < 0.
      lv_top = 1.
    ENDIF.

    " Filter and sort details
    DATA(lt_clause) = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields) = io_request->get_requested_elements( ).
    DATA(lt_sort)   = io_request->get_sort_elements( ).

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

    " Extract filter ranges
    DATA(lr_fkdat) = VALUE #( lt_filter_cond[ name = 'FISCALYEAR' ]-range OPTIONAL ).
    DATA(lr_bukrs) = VALUE #( lt_filter_cond[ name = 'COMPANYCODE' ]-range OPTIONAL ).
    DATA(lr_acc)   = VALUE #( lt_filter_cond[ name = 'ACCOUNTINGDOCUMENT' ]-range OPTIONAL ).
    DATA(lr_date)  = VALUE #( lt_filter_cond[ name = 'POSTINGDATE' ]-range OPTIONAL ).

    SELECT *
        FROM zi_fi_purchaseregister
        WHERE companycode IN @lr_bukrs
          AND fiscalyear IN @lr_fkdat
          AND accountingdocument IN @lr_acc
          AND postingdate IN @lr_date
        INTO TABLE @DATA(it_final).

    MOVE-CORRESPONDING it_final TO lt_response.

    SORT lt_response BY companycode fiscalyear accountingdocument accountingdocumentitem.
    DELETE ADJACENT DUPLICATES FROM lt_response COMPARING companycode fiscalyear accountingdocument accountingdocumentitem.


    SORT lt_response BY accountingdocument accountingdocumentitem ASCENDING.
    DATA lv_total_count TYPE int8.
    lv_total_count = lines( lt_response ).

    DATA lt_paged TYPE TABLE OF zce_pur_reg_fi."zce_salesregister_summary.
    DATA lv_index TYPE i VALUE 0.

    IF lt_response[] IS NOT INITIAL.

      "" For Missing Amounts.
      SELECT * FROM zi_journalentrykdtax
      FOR ALL ENTRIES IN @lt_response WHERE accountingdocument = @lt_response-accountingdocument
      INTO TABLE @DATA(lt_zi_journalentrykdtax).

      "" For STO.
      SELECT FROM i_journalentry AS h
        INNER JOIN i_journalentryitem AS i
          ON  h~companycode        = i~companycode
          AND h~fiscalyear         = i~fiscalyear
          AND h~accountingdocument = i~accountingdocument
        FIELDS
          h~companycode,
          h~fiscalyear,
          h~accountingdocument,
          h~accountingdocumenttype,
          h~postingdate,
          h~documentdate,
          h~companycodecurrency,
          i~ledgergllineitem,
          i~accountingdocumentitem,
          i~glaccount,
          i~amountincompanycodecurrency,
          i~taxcode,
          i~plant
        FOR ALL ENTRIES IN @lt_response
        WHERE h~accountingdocument = @lt_response-accountingdocument
        AND h~fiscalyear = @lt_response-fiscalyear
          AND i~ledger             = '0L'
          AND i~sourceledger       = '0L'
          AND h~transactioncode    = 'J_1IG_INV'
        INTO TABLE @DATA(it_journal).

    ENDIF.

    LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<fs_response>).
      "" Clear GST Values for Price Diff
      IF <fs_response>-transactiontypedetermination = 'PRD'.
        CLEAR:
          <fs_response>-cgstrate,
          <fs_response>-cgstamount,
          <fs_response>-sgstrate,
          <fs_response>-sgstamount,
          <fs_response>-ugstrate,
          <fs_response>-ugstamount,
          <fs_response>-igstrate,
          <fs_response>-igstamount.
      ENDIF.

      IF <fs_response>-transactiontypedetermination = 'BSX'.

        IF line_exists( lt_response[ accountingdocument = <fs_response>-accountingdocument
         fiscalyear = <fs_response>-fiscalyear
         transactiontypedetermination = 'WRX' ] ).

          CLEAR:
            <fs_response>-cgstrate,
            <fs_response>-cgstamount,
            <fs_response>-sgstrate,
            <fs_response>-sgstamount,
            <fs_response>-ugstrate,
            <fs_response>-ugstamount,
            <fs_response>-igstrate,
            <fs_response>-igstamount.

        ENDIF.
      ENDIF.


      "" To fill missing STO GST Amounts.
      IF line_exists( it_journal[ accountingdocument = <fs_response>-accountingdocument ] ).
        " line found
        IF <fs_response>-accountingdocumentitem = '002'.
          READ TABLE it_journal ASSIGNING FIELD-SYMBOL(<fs_journal>) WITH KEY accountingdocument = <fs_response>-accountingdocument
          glaccount = '0000148000'. "IGST GL.
          IF sy-subrc IS INITIAL.
            <fs_response>-igstrate = 18.
            <fs_response>-igstglaccount = '0000148000'.
            <fs_response>-igstamount = <fs_journal>-amountincompanycodecurrency.

            <fs_response>-taxamount =  <fs_response>-igstamount.
            <fs_response>-invoiceamount = <fs_response>-invoiceamount + <fs_response>-igstamount.

          ENDIF.
        ENDIF.

      ENDIF.

      "" To fill missing GST Amounts.
      IF ( <fs_response>-cgstrate IS NOT INITIAL AND <fs_response>-cgstamount IS INITIAL ) OR
         ( <fs_response>-sgstrate IS NOT INITIAL AND <fs_response>-sgstamount IS INITIAL ) OR
         ( <fs_response>-ugstrate IS NOT INITIAL AND <fs_response>-ugstamount IS INITIAL ) OR
         ( <fs_response>-igstrate IS NOT INITIAL AND <fs_response>-igstamount IS INITIAL ).

        DATA(lv_flag) = 'X'.

      ENDIF.


      IF lv_flag = 'X'.

        " CGST
        READ TABLE lt_zi_journalentrykdtax ASSIGNING FIELD-SYMBOL(<fs_zi_journalentrykdtax>)
          WITH KEY accountingdocument = <fs_response>-accountingdocument
                   mainitemnumber    = <fs_response>-accountingdocumentitem
                   transactiontypedetermination = 'JIC'.
        IF sy-subrc IS INITIAL.
          <fs_response>-cgstamount = <fs_zi_journalentrykdtax>-amountincompanycodecurrency.
        ENDIF.

        " SGST
        READ TABLE lt_zi_journalentrykdtax ASSIGNING <fs_zi_journalentrykdtax>
          WITH KEY accountingdocument = <fs_response>-accountingdocument
                   mainitemnumber    = <fs_response>-accountingdocumentitem
                   transactiontypedetermination = 'JIS'.
        IF sy-subrc IS INITIAL.
          <fs_response>-sgstamount = <fs_zi_journalentrykdtax>-amountincompanycodecurrency.
        ENDIF.

        " IGST
        READ TABLE lt_zi_journalentrykdtax ASSIGNING <fs_zi_journalentrykdtax>
          WITH KEY accountingdocument = <fs_response>-accountingdocument
                   mainitemnumber    = <fs_response>-accountingdocumentitem
                   transactiontypedetermination = 'JII'.
        IF sy-subrc IS INITIAL.
          <fs_response>-igstamount = <fs_zi_journalentrykdtax>-amountincompanycodecurrency.
        ENDIF.

        " UGST
        READ TABLE lt_zi_journalentrykdtax ASSIGNING <fs_zi_journalentrykdtax>
          WITH KEY accountingdocument = <fs_response>-accountingdocument
                   mainitemnumber    = <fs_response>-accountingdocumentitem
                   transactiontypedetermination = 'JIU'.
        IF sy-subrc IS INITIAL.
          <fs_response>-ugstamount = <fs_zi_journalentrykdtax>-amountincompanycodecurrency.
        ENDIF.

        <fs_response>-taxamount = <fs_response>-cgstamount + <fs_response>-sgstamount + <fs_response>-igstamount + <fs_response>-ugstamount.
        <fs_response>-invoiceamount = <fs_response>-amountincompanycodecurrency + <fs_response>-cgstamount + <fs_response>-sgstamount + <fs_response>-igstamount + <fs_response>-ugstamount.

        CLEAR lv_flag.
      ENDIF.


      """" For Pagination.
      lv_index = lv_index + 1.
      IF lv_index > lv_skip AND lv_index <= lv_skip + lv_top.
        APPEND <fs_response> TO lt_paged.
      ENDIF.

    ENDLOOP.

*    LOOP AT lt_response INTO DATA(ls_row).
*      lv_index = lv_index + 1.
*      IF lv_index > lv_skip AND lv_index <= lv_skip + lv_top.
*        APPEND ls_row TO lt_paged.
*      ENDIF.
*    ENDLOOP.

    io_response->set_total_number_of_records( lv_total_count ).
    io_response->set_data( lt_paged ).


  ENDMETHOD.
ENDCLASS.
