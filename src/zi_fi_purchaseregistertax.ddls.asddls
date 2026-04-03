@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI : Purchase Register Tax Data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_FI_PurchaseRegisterTAX
  as select from ZI_JournalEntryKDItem as _JournalEntryItem
{
  key _JournalEntryItem.CompanyCode                                                                                     as CompanyCode,
  key _JournalEntryItem.FiscalYear                                                                                      as FiscalYear,
  key _JournalEntryItem.AccountingDocument                                                                              as AccountingDocument,
  key _JournalEntryItem.AccountingDocumentItem                                                                          as AccountingDocumentItem,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JII' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIM'
            then _JournalEntryItem._JournalEntryTax.TaxPercentage else 0 end )                                          as IGSTRate,
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JII' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIM'
            then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end )  as IGSTAmount,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JII' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIM'
            then  _JournalEntryItem._JournalEntryTax.GLAccount  else '' end )                                           as IGSTGLAccount,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIN' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JRI'
            then _JournalEntryItem._JournalEntryTax.TaxPercentage else 0 end )                                          as RCMIGSTRate,
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIN' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JRI'
            then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end )  as RCMIGSTAmount,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIC'
            then _JournalEntryItem._JournalEntryTax.TaxPercentage else 0 end )                                          as CGSTRate,
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIC'
      //            then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 1 end ) as CGSTAmount,
            then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end )  as CGSTAmount,
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIC'
      //                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIM'
            then  _JournalEntryItem._JournalEntryTax.GLAccount  else '' end )                                           as CGSTGLAccount,


      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JCN' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JRC'
            then _JournalEntryItem._JournalEntryTax.TaxPercentage else 0 end )                                          as RCMCGSTRate,
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JCN' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JRC'
            then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end )  as RCMCGSTAmount,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIS'
            then _JournalEntryItem._JournalEntryTax.TaxPercentage else 0 end )                                          as SGSTRate,
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIS'
            then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end )  as SGSTAmount,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIS'
           then  _JournalEntryItem._JournalEntryTax.GLAccount  else '' end )                                            as SGSTGLAccount,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JSN' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JRS'
            then _JournalEntryItem._JournalEntryTax.TaxPercentage else 0 end )                                          as RCMSGSTRate,
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JSN' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JRS'
            then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end )  as RCMSGSTAmount,
      //     ***********
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIU'
             then _JournalEntryItem._JournalEntryTax.TaxPercentage else 0 end )                                         as UGSTRate,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIU'
             then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end ) as UGSTAmount,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JIU'
           then  _JournalEntryItem._JournalEntryTax.GLAccount  else '' end )                                            as UGSTGLAccount,

      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JUN' or
                    _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JRU'
           then _JournalEntryItem._JournalEntryTax.TaxPercentage else 0 end )                                           as RCMUGSTRate,
      max( case when _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JUN' or
                     _JournalEntryItem._JournalEntryTax.TransactionTypeDetermination = 'JRU'
            then cast( _JournalEntryItem._JournalEntryTax.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end )  as RCMUGSTAmount

}
group by
  _JournalEntryItem.CompanyCode,
  _JournalEntryItem.FiscalYear,
  _JournalEntryItem.AccountingDocument,
  _JournalEntryItem.AccountingDocumentItem
