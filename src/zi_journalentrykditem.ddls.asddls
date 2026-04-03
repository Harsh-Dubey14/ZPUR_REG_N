@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI : Inv/Cr & Dr Note Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_JournalEntryKDItem
  as select from    I_OperationalAcctgDocItem as _AcctgDocItem
    left outer join I_JournalEntryItem        as _JournalEntryItem on  _JournalEntryItem.CompanyCode            = _AcctgDocItem.CompanyCode
                                                                   and _JournalEntryItem.FiscalYear             = _AcctgDocItem.FiscalYear
                                                                   and _JournalEntryItem.AccountingDocument     = _AcctgDocItem.AccountingDocument
                                                                   and _JournalEntryItem.AccountingDocumentItem = _AcctgDocItem.AccountingDocumentItem
                                                                   and _JournalEntryItem.Ledger                 = '0L'

  association [1..1] to ZI_JournalEntryKD             as _JournalEntry          on  $projection.CompanyCode        = _JournalEntry.CompanyCode
                                                                                and $projection.FiscalYear         = _JournalEntry.FiscalYear
                                                                                and $projection.AccountingDocument = _JournalEntry.AccountingDocument

  association [0..*] to ZI_JournalEntryKDTax          as _JournalEntryTax       on  $projection.CompanyCode            = _JournalEntryTax.CompanyCode
                                                                                and $projection.FiscalYear             = _JournalEntryTax.FiscalYear
                                                                                and $projection.AccountingDocument     = _JournalEntryTax.AccountingDocument
                                                                                and $projection.AccountingDocumentItem = _JournalEntryTax.MainItemNumber

  association [0..1] to I_ProductPlantBasic           as _ProductPlant          on  $projection.Plant   = _ProductPlant.Plant
                                                                                and $projection.Product = _ProductPlant.Product

  association [0..1] to ZI_BillingDocumentItem        as _BillingDocumentItem   on  $projection.BillingDocument     = _BillingDocumentItem.BillingDocument
                                                                                and $projection.BillingDocumentItem = _BillingDocumentItem.BillingDocumentItem

  association [0..1] to I_SuplrInvcItemPurOrdRefAPI01 as _SuplrInvcItem         on  $projection.BillingDocument     = _SuplrInvcItem.SupplierInvoice
                                                                                and $projection.BillingDocumentItem = _SuplrInvcItem.SupplierInvoiceItem

  association [0..1] to I_MaterialDocumentItem_2      as _MaterialDocumentItem  on  $projection.GRIRDocumentYear = _MaterialDocumentItem.MaterialDocumentYear
                                                                                and $projection.GRIRDocument     = _MaterialDocumentItem.MaterialDocument
                                                                                and $projection.GRIRDocumentItem = _MaterialDocumentItem.MaterialDocumentItem

  association [0..1] to I_ServiceEntrySheetItemAPI01  as _ServiceEntrySheetItem on  $projection.GRIRDocument = _ServiceEntrySheetItem.ServiceEntrySheet
                                                                                and $projection.SrvEntryLine = _ServiceEntrySheetItem.ServiceEntrySheetItem

  association [0..1] to I_MaterialDocumentItem_2      as _SrvEntryMatDocItem    on  $projection.GRIRDocumentYear = _SrvEntryMatDocItem.ReferenceDocumentFiscalYear
                                                                                and $projection.GRIRDocument     = _SrvEntryMatDocItem.InvtryMgmtReferenceDocument
                                                                                and $projection.GRIRDocumentItem = _SrvEntryMatDocItem.InvtryMgmtRefDocumentItem

{
  key _AcctgDocItem.CompanyCode                                                                            as CompanyCode,
  key _AcctgDocItem.FiscalYear                                                                             as FiscalYear,
  key _AcctgDocItem.AccountingDocument                                                                     as AccountingDocument,
  key _AcctgDocItem.AccountingDocumentItem                                                                 as AccountingDocumentItem,
      _AcctgDocItem.LedgerGLLineItem                                                                       as LedgerGLLineItem,

      _AcctgDocItem.TaxItemGroup                                                                           as TaxItemGroup,
      _AcctgDocItem.GLAccount                                                                              as GLAccount,
      _AcctgDocItem._GLAccountInCompanyCode._Text[ Language = $session.system_language ].GLAccountName     as GLAccountName,
      _AcctgDocItem._GLAccountInCompanyCode._Text[ Language = $session.system_language ].GLAccountLongName as GLAccountLongName,
      _AcctgDocItem.PurchasingDocument                                                                     as PurchasingDocument,
      _AcctgDocItem.PurchasingDocumentItem                                                                 as PurchasingDocumentItem,
      _AcctgDocItem.TransactionTypeDetermination                                                           as TransactionTypeDetermination,
      _JournalEntryItem.Plant                                                                              as Plant,
      _JournalEntryItem.ReferenceDocument                                                                  as BillingDocument,
      _JournalEntryItem.ReferenceDocumentItem                                                              as BillingDocumentItem,
      _SuplrInvcItem.ReferenceDocumentFiscalYear                                                           as GRIRDocumentYear,
      _SuplrInvcItem.ReferenceDocument                                                                     as GRIRDocument,
      _SuplrInvcItem.ReferenceDocumentItem                                                                 as GRIRDocumentItem,
      cast( concat( '0' , _SuplrInvcItem.ReferenceDocumentItem ) as ebelp )                                as SrvEntryLine,

      _JournalEntryItem._Product.ProductType                                                               as ProductType,
      _JournalEntryItem._Product.ProductGroup                                                              as ProductGroup,
      _JournalEntryItem.Product                                                                            as Product,
      _JournalEntryItem._Product._Text[ Language = $session.system_language ].ProductName                  as ProductName,
      _JournalEntryItem.DocumentItemText                                                                   as DocumentItemText,

      _JournalEntryItem.CostCenter                                                                         as CostCenter,
      _JournalEntryItem._CostCenterText[ Language = $session.system_language ].CostCenterName              as CostCenterName,
      _JournalEntryItem._CostCenterText[ Language = $session.system_language ].CostCenterDescription       as CostCenterDescription,
      _JournalEntryItem.ProfitCenter                                                                       as ProfitCenter,
      _JournalEntryItem._ProfitCenterText[ Language = $session.system_language ].ProfitCenterName          as ProfitCenterName,
      _JournalEntryItem._ProfitCenterText[ Language = $session.system_language ].ProfitCenterLongName      as ProfitCenterLongName,

      case when _AcctgDocItem.IN_HSNOrSACCode is initial
        then _ProductPlant.ConsumptionTaxCtrlCode
        else _AcctgDocItem.IN_HSNOrSACCode end                                                             as HSNOrSACCode,

      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      _AcctgDocItem.Quantity                                                                               as Quantity,
      _AcctgDocItem.BaseUnit                                                                               as BaseUnit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _AcctgDocItem.AmountInTransactionCurrency                                                            as AmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _AcctgDocItem.AbsoluteAmountInTransacCrcy                                                            as AbsoluteAmountInTransacCrcy,
      _AcctgDocItem.TransactionCurrency                                                                    as TransactionCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _AcctgDocItem.AmountInCompanyCodeCurrency                                                            as AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _AcctgDocItem.AbsoluteAmountInCoCodeCrcy                                                             as AbsoluteAmountInCoCodeCrcy,
      _AcctgDocItem.CompanyCodeCurrency                                                                    as CompanyCodeCurrency,
      _AcctgDocItem.TaxCode                                                                                as TaxCode,
      _AcctgDocItem._TaxCode._Text[ Language = $session.system_language ].TaxCodeName                      as TaxCodeName,


      //--- Associations ---//
      _JournalEntry,
      _ProductPlant,
      _JournalEntryTax,
      _BillingDocumentItem,
      _SuplrInvcItem,
      _MaterialDocumentItem,
      _ServiceEntrySheetItem,
      _SrvEntryMatDocItem

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
  and(
          // For Customer
          _AcctgDocItem._JournalEntry.AccountingDocumentType =  'DR'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'DG'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'DN'

    // For Supplier
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'RE'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'RT'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'KR'
    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'KG'

    or    _AcctgDocItem._JournalEntry.AccountingDocumentType =  'JV'
  )
