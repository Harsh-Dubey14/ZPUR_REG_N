@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI : Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_FI_PurchaseRegister
  as select from    ZI_JournalEntryKDItem          as _JournalEntryItem
    left outer join I_SuplrInvcItemPurOrdRefAPI01  as _SupplierInvoiceItem     on  _SupplierInvoiceItem.SupplierInvoice     = _JournalEntryItem.BillingDocument
                                                                               and _SupplierInvoiceItem.SupplierInvoiceItem = _JournalEntryItem.BillingDocumentItem

    left outer join I_PurOrdAccountAssignmentAPI01 as _PurOrdAccountAssignment on  _PurOrdAccountAssignment.PurchaseOrder           = _SupplierInvoiceItem.PurchaseOrder
                                                                               and _PurOrdAccountAssignment.PurchaseOrderItem       = _SupplierInvoiceItem.PurchaseOrderItem
                                                                               and _PurOrdAccountAssignment.AccountAssignmentNumber = '01'

    left outer join ZI_FI_PurchaseRegisterTAX      as _PurchaseRegisterTAX     on  _PurchaseRegisterTAX.CompanyCode            = _JournalEntryItem.CompanyCode
                                                                               and _PurchaseRegisterTAX.FiscalYear             = _JournalEntryItem.FiscalYear
                                                                               and _PurchaseRegisterTAX.AccountingDocument     = _JournalEntryItem.AccountingDocument
                                                                               and _PurchaseRegisterTAX.AccountingDocumentItem = _JournalEntryItem.AccountingDocumentItem
{
  key _JournalEntryItem.CompanyCode                                             as CompanyCode,
  key _JournalEntryItem.FiscalYear                                              as FiscalYear,
  key _JournalEntryItem.AccountingDocument                                      as AccountingDocument,
  key _JournalEntryItem.AccountingDocumentItem                                  as AccountingDocumentItem,

      _JournalEntryItem._JournalEntry.DocumentReferenceID                       as DocumentReferenceID,
      _JournalEntryItem._JournalEntry.AccountingDocumentType                    as AccountingDocumentType,
      _JournalEntryItem._JournalEntry.AccountingDocumentTypeName                as AccountingDocumentTypeName,
      _JournalEntryItem._JournalEntry.DocumentDate                              as DocumentDate,
      _JournalEntryItem._JournalEntry.PostingDate                               as PostingDate,
      _JournalEntryItem.TransactionTypeDetermination                            as TransactionTypeDetermination,
      _JournalEntryItem._JournalEntry.CreationDate                              as CreationDate,
      _JournalEntryItem._JournalEntry.NetDueDate                                as NetDueDate,
      _JournalEntryItem._JournalEntry.CreatedByName                             as CreatedBy,


      case
        when _JournalEntryItem._JournalEntry.IsReversal is not initial or _JournalEntryItem._JournalEntry.IsReversed is not initial
        then 'Yes' else 'No' end                                                as IsReversed,
      _JournalEntryItem._JournalEntry.ReversalReferenceDocument                 as ReverseDocument,
      _JournalEntryItem._JournalEntry.ReversalReferenceDocumentCntxt            as ReverseDocumentFiscalYear,

      _JournalEntryItem._JournalEntry.ClearingJournalEntryFiscalYear            as ClearingJournalEntryFiscalYear,
      _JournalEntryItem._JournalEntry.ClearingJournalEntry                      as ClearingJournalEntry,
      _JournalEntryItem._JournalEntry.ClearingDate                              as ClearingDate,

      cast( _JournalEntryItem._JournalEntry.BusinessPartner as lifnr )          as Supplier,
      _JournalEntryItem._JournalEntry.BusinessPartnerName                       as SupplierName,
      _JournalEntryItem._JournalEntry.BusinessPartnerRegionName                 as SupplierRegion,
      _JournalEntryItem._JournalEntry.BusinessPartnerGSTIN                      as SupplierGSTIN,

      _JournalEntryItem.GLAccount                                               as GLAccount,
      _JournalEntryItem.GLAccountName                                           as GLAccountName,

      _PurOrdAccountAssignment.GLAccount                                        as POGLAccount,

      _JournalEntryItem.CostCenter                                              as CostCenter,
      _JournalEntryItem.CostCenterName                                          as CostCenterName,
      _JournalEntryItem.ProfitCenter                                            as ProfitCenter,
      _JournalEntryItem.ProfitCenterName                                        as ProfitCenterName,

      _JournalEntryItem._JournalEntry.BusinessPlace                             as BusinessPlace,
      _JournalEntryItem.Plant                                                   as Plant,

      _JournalEntryItem.PurchasingDocument                                      as PurchasingDocument,
      _JournalEntryItem.PurchasingDocumentItem                                  as PurchasingDocumentItem,
      _SupplierInvoiceItem.ReferenceDocumentFiscalYear                          as GRDocumentYear,
      _SupplierInvoiceItem.ReferenceDocument                                    as GRDocument,
      _SupplierInvoiceItem.ReferenceDocumentItem                                as GRDocumentItem,
      _JournalEntryItem.BillingDocument                                         as MIRODocument,
      _JournalEntryItem.BillingDocumentItem                                     as MIRODocumentItem,

      _JournalEntryItem.ProductType                                             as ProductType,
      _JournalEntryItem.HSNOrSACCode                                            as HSNOrSACCode,
      _JournalEntryItem.Product                                                 as Product,
      _JournalEntryItem.ProductName                                             as ProductName,

      _JournalEntryItem.DocumentItemText                                        as DocumentItemText,

      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      case when _JournalEntryItem.AmountInCompanyCodeCurrency < 0
        then ( _JournalEntryItem.Quantity * -1 )
        else _JournalEntryItem.Quantity end                                     as Quantity,

      _JournalEntryItem.BaseUnit                                                as BaseUnit,

      _JournalEntryItem.TaxCode                                                 as TaxCode,
      _JournalEntryItem.TaxCodeName                                             as TaxCodeName,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _JournalEntryItem.AmountInTransactionCurrency                             as AmountInTransactionCurrency,
      _JournalEntryItem.TransactionCurrency                                     as TransactionCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _JournalEntryItem.AmountInCompanyCodeCurrency                             as AmountInCompanyCodeCurrency,
      _JournalEntryItem.CompanyCodeCurrency                                     as CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _JournalEntryItem.AmountInCompanyCodeCurrency                             as NetAmount,

      _PurchaseRegisterTAX.IGSTRate                                             as IGSTRate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PurchaseRegisterTAX.IGSTAmount                                           as IGSTAmount,

      _PurchaseRegisterTAX.IGSTGLAccount                                        as IGSTGLAccount,

      _PurchaseRegisterTAX.RCMIGSTRate                                          as RCMIGSTRATE,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PurchaseRegisterTAX.RCMIGSTAmount                                        as RCMIGSTAmount,
      _PurchaseRegisterTAX.CGSTRate                                             as CGSTRate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PurchaseRegisterTAX.CGSTAmount                                           as CGSTAmount,

      _PurchaseRegisterTAX.RCMCGSTRate                                          as RCMCGSTRate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PurchaseRegisterTAX.RCMCGSTAmount                                        as RCMCGSTAmount,

      _PurchaseRegisterTAX.CGSTGLAccount                                        as CGSTGLAccount,


      _PurchaseRegisterTAX.SGSTRate                                             as SGSTRate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PurchaseRegisterTAX.SGSTAmount                                           as SGSTAmount,

      _PurchaseRegisterTAX.SGSTGLAccount                                        as SGSTGLAccount,

      _PurchaseRegisterTAX.RCMSGSTRate                                          as RCMSGSTRate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PurchaseRegisterTAX.RCMSGSTAmount                                        as RCMSGSTAmount,

      _JournalEntryItem._JournalEntry.BusinessPartnerPANNumber                  as BusinessPartnerPANNumber,
      _JournalEntryItem._JournalEntry._JournalEntryKDWTTax.GLAccount            as TDSGLAccount,
      _JournalEntryItem._JournalEntry._JournalEntryKDWTTax.OfficialWhldgTaxCode as OfficialWhldgTaxCode,
      _JournalEntryItem._JournalEntry._JournalEntryKDWTTax.WithholdingTaxType   as WithholdingTaxType,
      //      **
      _PurchaseRegisterTAX.UGSTRate                                             as UGSTRate,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PurchaseRegisterTAX.UGSTAmount                                           as UGSTAmount,

      _PurchaseRegisterTAX.UGSTGLAccount                                        as UGSTGLAccount,

      _PurchaseRegisterTAX.RCMUGSTRate                                          as RCMUGSTRate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _PurchaseRegisterTAX.RCMUGSTAmount                                        as RCMUGSTAmount,


      //      **
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when _JournalEntryItem._JournalEntry._JournalEntryKDWTTax.WhldgTaxAmtInCoCodeCrcy is not initial
        then
          cast( _JournalEntryItem._JournalEntry._JournalEntryKDWTTax.WhldgTaxAmtInCoCodeCrcy as abap.dec(23,2) ) /
          cast( _JournalEntryItem._JournalEntry._JournalEntryKDWTTax.WhldgTaxBaseAmtInCoCodeCrcy as abap.dec(23,2) ) *
          cast( _JournalEntryItem.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else 0 end                                                              as WhldgTaxAmtInCoCodeCrcy,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      (

        case when _PurchaseRegisterTAX.IGSTAmount is not initial then _PurchaseRegisterTAX.IGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.CGSTAmount is not initial then _PurchaseRegisterTAX.CGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.SGSTAmount is not initial then _PurchaseRegisterTAX.SGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.UGSTAmount is not initial then _PurchaseRegisterTAX.UGSTAmount else 0 end +

        case when _PurchaseRegisterTAX.RCMIGSTAmount is not initial then _PurchaseRegisterTAX.RCMIGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.RCMCGSTAmount is not initial then _PurchaseRegisterTAX.RCMCGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.RCMSGSTAmount is not initial then _PurchaseRegisterTAX.RCMSGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.RCMUGSTAmount is not initial then _PurchaseRegisterTAX.RCMUGSTAmount else 0 end



        )                                                                       as TaxAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( _JournalEntryItem.AmountInCompanyCodeCurrency as abap.dec(23,2) ) +
      (

        case when _PurchaseRegisterTAX.IGSTAmount is not initial then _PurchaseRegisterTAX.IGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.CGSTAmount is not initial then _PurchaseRegisterTAX.CGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.SGSTAmount is not initial then _PurchaseRegisterTAX.SGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.UGSTAmount is not initial then _PurchaseRegisterTAX.UGSTAmount else 0 end +

        case when _PurchaseRegisterTAX.RCMIGSTAmount is not initial then _PurchaseRegisterTAX.RCMIGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.RCMCGSTAmount is not initial then _PurchaseRegisterTAX.RCMCGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.RCMSGSTAmount is not initial then _PurchaseRegisterTAX.RCMSGSTAmount else 0 end +
        case when _PurchaseRegisterTAX.RCMUGSTAmount is not initial then _PurchaseRegisterTAX.RCMUGSTAmount else 0 end


        )                                                                       as InvoiceAmount

}
where
  _JournalEntryItem._JournalEntry.FinancialAccountType = 'K'
