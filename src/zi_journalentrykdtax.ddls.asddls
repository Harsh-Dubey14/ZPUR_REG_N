@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI : Inv/Cr & Dr Note Tax'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_JournalEntryKDTax
  as select from    I_OperationalAcctgDocItem as _AcctgDocItem
    left outer join I_OperationalAcctgDocItem as _AcctgDocTax on  _AcctgDocTax.CompanyCode                = _AcctgDocItem.CompanyCode
                                                              and _AcctgDocTax.FiscalYear                 = _AcctgDocItem.FiscalYear
                                                              and _AcctgDocTax.AccountingDocument         = _AcctgDocItem.AccountingDocument
                                                              and _AcctgDocTax.TaxItemGroup               = _AcctgDocItem.TaxItemGroup
                                                              and _AcctgDocTax.AccountingDocumentItemType = 'T'
{
  key _AcctgDocItem.CompanyCode                                                                          as CompanyCode,
  key _AcctgDocItem.FiscalYear                                                                           as FiscalYear,
  key _AcctgDocItem.AccountingDocument                                                                   as AccountingDocument,
  key _AcctgDocItem.AccountingDocumentItem                                                               as MainItemNumber,
  key _AcctgDocTax.AccountingDocumentItem                                                                as TaxItemNumber,
      _AcctgDocTax.TaxItemGroup                                                                          as TaxItemGroup,
      _AcctgDocTax.GLAccount                                                                             as GLAccount,
      _AcctgDocTax._GLAccountInCompanyCode._Text[ Language = $session.system_language ].GLAccountName    as GLAccountName,
      _AcctgDocTax.TransactionTypeDetermination                                                          as TransactionTypeDetermination,
      _AcctgDocTax.TransactionCurrency                                                                   as TransactionCurrency,
      _AcctgDocTax.CompanyCodeCurrency                                                                   as CompanyCodeCurrency,

      // Calculate Tax Rate Base On Values
      cast( ( cast( _AcctgDocTax.AbsoluteAmountInTransacCrcy as abap.dec(23,2) ) /
        cast( _AcctgDocTax.TaxAbsltBaseAmountInTransCrcy as abap.dec(23,2) ) ) * 100 as abap.dec(23,2) ) as TaxRate,

      // Calculate Tax Rate Base On Values + Roundoff the Rate
      case
        when cast( _AcctgDocTax.TaxAbsltBaseAmountInTransCrcy as abap.dec(23,2) ) = 0
          then cast( 0 as abap.dec(23,1) )
        when round(
               round(
                 cast( _AcctgDocTax.AbsoluteAmountInTransacCrcy as abap.dec(23,2) )
                 / cast( _AcctgDocTax.TaxAbsltBaseAmountInTransCrcy as abap.dec(23,2) )
                 * 100, 1
               ), 0
             )
             =
             round(
               cast( _AcctgDocTax.AbsoluteAmountInTransacCrcy as abap.dec(23,2) )
               / cast( _AcctgDocTax.TaxAbsltBaseAmountInTransCrcy as abap.dec(23,2) )
               * 100, 1
             )
          then cast(
                 round(
                   cast( _AcctgDocTax.AbsoluteAmountInTransacCrcy as abap.dec(23,2) )
                   / cast( _AcctgDocTax.TaxAbsltBaseAmountInTransCrcy as abap.dec(23,2) )
                   * 100, 0
                 ) as abap.dec(23,1)
               )
        else cast(
               round(
                 cast( _AcctgDocTax.AbsoluteAmountInTransacCrcy as abap.dec(23,2) )
                 / cast( _AcctgDocTax.TaxAbsltBaseAmountInTransCrcy as abap.dec(23,2) )
                 * 100, 1
               ) as abap.dec(23,1)
             )
      end                                                                                                as TaxPercentage,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _AcctgDocTax.AmountInTransactionCurrency                                                           as AmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _AcctgDocTax.AbsoluteAmountInTransacCrcy                                                           as AbsoluteAmountInTransacCrcy,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _AcctgDocTax.TaxAbsltBaseAmountInTransCrcy                                                         as TaxAbsltBaseAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _AcctgDocTax.AmountInCompanyCodeCurrency                                                           as AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _AcctgDocTax.AbsoluteAmountInCoCodeCrcy                                                            as AbsoluteAmountInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _AcctgDocTax.TaxAbsltBaseAmountInCoCodeCrcy                                                        as TaxAbsltBaseAmountInCoCodeCrcy
}
where
          _AcctgDocItem.AccountingDocumentItemType           <> 'T'
  and(
          _AcctgDocItem.FinancialAccountType                 =  'S'
    or    _AcctgDocItem.FinancialAccountType                 =  'A'

    or(
          _AcctgDocItem.FinancialAccountType                 =  'M'
      and _AcctgDocItem._JournalEntry.AccountingDocumentType =  'RE'
    )

  )
  and     _AcctgDocItem.WithholdingTaxCode                   =  ''
  // and _AcctgDocItem.ProfitLossAccountType = 'X'
  and(
          // For Customer
          _AcctgDocItem._JournalEntry.AccountingDocumentType =  'DR'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'DG'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'DN'
    // or _AcctgDocItem._JournalEntry.AccountingDocumentType = 'RV'

    // For Supplier
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'RE'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'RT'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'KR'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'KG'

    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'JV'
  )
