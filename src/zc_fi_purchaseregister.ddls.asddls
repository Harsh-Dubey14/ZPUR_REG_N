@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI : Purchase Register'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI: {
  headerInfo: {
    typeName: 'FI : Purchase Register',
    typeNamePlural: 'FI : Purchase Register',
    title: {
        type: #STANDARD,
        label: 'FI : Purchase Register',
        value: 'AccountingDocument' } },
        presentationVariant: [{ sortOrder: [{ by : 'PostingDate' , direction: #DESC },
                                            { by : 'AccountingDocument' , direction: #ASC },
                                            { by : 'AccountingDocumentItem', direction: #ASC }] }]}
@Search.searchable: true
define root view entity ZC_FI_PurchaseRegister
  provider contract transactional_query
  as projection on ZI_FI_PurchaseRegister
{

      @UI.facet: [
      { id : 'Document',
        position : 10,
        purpose : #STANDARD,
        type : #IDENTIFICATION_REFERENCE,
        label : 'Purchasing Details' }]

      @UI: { lineItem : [ { position: 10 } ],
             identification: [ { position: 10 } ],
             selectionField: [ { position: 10 } ] }
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Company Code'
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_CompanyCodeStdVH' , entity.element: 'CompanyCode' }]
  key CompanyCode                    as CompanyCode,

      @UI: { lineItem : [ { position: 20 } ],
             identification: [ { position: 20 } ],
             selectionField: [ { position: 20 } ] }
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear                     as FiscalYear,

      @UI: { lineItem : [ { position: 30 } ],
             identification: [ { position: 30 } ],
             selectionField: [ { position: 30 } ] }
      @Consumption.semanticObject: 'AccountingDocument'
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Accounting Document'
  key AccountingDocument             as AccountingDocument,

      @UI: { lineItem : [ { position: 40 } ],
             identification: [ { position: 40 } ] }
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Accounting Doc. Item'
  key AccountingDocumentItem         as AccountingDocumentItem,

      @UI: { lineItem : [ { position: 50 } ],
             identification: [ { position: 50 } ] }
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Invoice Reference No.'
      DocumentReferenceID            as DocumentReferenceID,

      @UI: { lineItem : [ { position: 60 } ],
             identification: [ { position: 60 } ] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_AccountingDocumentTypeText', entity.element: 'AccountingDocumentType' }]
      AccountingDocumentType         as AccountingDocumentType,

      @UI: { lineItem : [ { position: 70 } ],
             identification: [ { position: 70 } ] }
      @EndUserText.label: 'Document Type Name'
      AccountingDocumentTypeName     as AccountingDocumentTypeName,

      @UI: { lineItem : [ { position: 80 } ],
             identification: [ { position: 80 } ],
             selectionField: [ { position: 80 } ] }
      @EndUserText.label: 'Document Date'
      @Consumption.filter: {selectionType: #INTERVAL, multipleSelections: false, mandatory: false }
      DocumentDate                   as DocumentDate,

      @UI: { lineItem : [ { position: 90 } ],
             identification: [ { position: 90 } ],
             selectionField: [ { position: 90 } ] }
      @EndUserText.label: 'Posting Date'
      @Consumption.filter: {selectionType: #INTERVAL, multipleSelections: false, mandatory: true }
      PostingDate                    as PostingDate,

      @UI: { lineItem : [ { position: 100 } ],
             identification: [ { position: 100 } ] }
      @EndUserText.label: 'Net Due Date'
      @Consumption.filter: {selectionType: #INTERVAL, multipleSelections: false, mandatory: false }
      NetDueDate                     as NetDueDate,

      @UI: { lineItem : [ { position: 110 } ],
             identification: [ { position: 110 } ],
             selectionField: [ { position: 100 } ] }
      @EndUserText.label: 'Creation Date'
      @Consumption.filter: {selectionType: #INTERVAL, multipleSelections: false, mandatory: false }
      CreationDate                   as CreationDate,

      @UI: { lineItem : [ { position: 120 } ],
             identification: [ { position: 120 } ] }
      @EndUserText.label: 'Created By'
      CreatedBy                      as CreatedBy,

      @UI: { lineItem : [ { position: 130 } ],
             identification: [ { position: 130 } ] }
      @EndUserText.label: 'Is Reversed'
      //      @Consumption.valueHelpDefinition: [{ entity.name: 'ZVH_Flag', entity.element: 'Flag' }]
      IsReversed                     as IsReversed,

      @UI: { lineItem : [ { position: 140 } ],
             identification: [ { position: 140 } ] }
      @EndUserText.label: 'Reverse Document'
      ReverseDocument                as ReverseDocument,

      @UI: { lineItem : [ { position: 150 } ],
             identification: [ { position: 150 } ] }
      @EndUserText.label: 'Reverse Document Year'
      ReverseDocumentFiscalYear      as ReverseDocumentFiscalYear,

      @UI: { lineItem : [ { position: 160 } ],
             identification: [ { position: 160 } ] }
      @EndUserText.label: 'Clearing Doc. Year'
      ClearingJournalEntryFiscalYear as ClearingJournalEntryFiscalYear,

      @UI: { lineItem : [ { position: 170 } ],
             identification: [ { position: 170 } ] }
      @EndUserText.label: 'Clearing Document'
      ClearingJournalEntry           as ClearingJournalEntry,

      @UI: { lineItem : [ { position: 180 } ],
             identification: [ { position: 180 } ] }
      @EndUserText.label: 'Clearing Doc. Date'
      @Consumption.filter: {selectionType: #INTERVAL, multipleSelections: false, mandatory: false }
      ClearingDate                   as ClearingDate,

      @UI: { lineItem : [ { position: 190 } ],
             identification: [ { position: 190 } ],
             selectionField: [ { position: 190 } ] }
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Supplier'
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Supplier_VH', entity.element: 'Supplier' }]
      @Consumption.semanticObject: 'Supplier'
      Supplier                       as Supplier,

      @UI: { lineItem : [ { position: 200 } ],
             identification: [ { position: 200 } ] }
      @EndUserText.label: 'Supplier Name'
      SupplierName                   as SupplierName,

      @UI: { lineItem : [ { position: 210 } ],
             identification: [ { position: 210 } ] }
      @EndUserText.label: 'Supplier Region'
      SupplierRegion                 as SupplierRegion,

      @UI: { lineItem : [ { position: 220 } ],
             identification: [ { position: 220 } ] }
      @EndUserText.label: 'Supplier GSTIN'
      SupplierGSTIN                  as SupplierGSTIN,

      @UI: { lineItem : [ { position: 230 } ],
             identification: [ { position: 230 } ],
             selectionField: [ { position: 230 } ] }
      @EndUserText.label: 'GL Account'
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_GLAccountStdVH', entity.element: 'GLAccount' }]
      GLAccount                      as GLAccount,

      @UI: { lineItem : [ { position: 240 } ],
             identification: [ { position: 240 } ] }
      @EndUserText.label: 'GL Account Name'
      GLAccountName                  as GLAccountName,

      @UI: { lineItem : [ { position: 250 } ],
             identification: [ { position: 250 } ] }
      @EndUserText.label: 'GL Account in PO'
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_GLAccountStdVH', entity.element: 'GLAccount' }]
      POGLAccount                    as POGLAccount,

      @UI: { lineItem : [ { position: 260 } ],
             identification: [ { position: 260 } ] }
      @EndUserText.label: 'Cost Center'

      CostCenter                     as CostCenter,
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_CostCenterStdVH', entity.element: 'CostCenter' }]
      @UI: { lineItem : [ { position: 270 } ],
             identification: [ { position: 270 } ] }
      @EndUserText.label: 'Cost Center Name'
      CostCenterName                 as CostCenterName,

      @UI: { lineItem : [ { position: 280 } ],
             identification: [ { position: 280 } ] }
      @EndUserText.label: 'Profit Center'
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_ProfitCenterStdVH', entity.element: 'ProfitCenter' }]
      ProfitCenter                   as ProfitCenter,

      @UI: { lineItem : [ { position: 290 } ],
             identification: [ { position: 290 } ] }
      @EndUserText.label: 'Profit Center Name'
      ProfitCenterName               as ProfitCenterName,

      @UI: { lineItem : [ { position: 300 } ],
             identification: [ { position: 300 } ] }
      @EndUserText.label: 'Business Place'
      BusinessPlace                  as BusinessPlace,

      @UI: { lineItem : [ { position: 310 } ],
             identification: [ { position: 310 } ],
             selectionField: [ { position: 310 } ] }
      @EndUserText.label: 'Plant'
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_PlantStdVH', entity.element: 'Plant' }]
      Plant                          as Plant,

      @UI: { lineItem : [ { position: 320 } ],
             identification: [ { position: 320 } ] }
      @EndUserText.label: 'Purchasing Document'
      @Consumption.semanticObject: 'PurchaseOrder'
      PurchasingDocument             as PurchasingDocument,

      @UI: { lineItem : [ { position: 330 } ],
             identification: [ { position: 330 } ] }
      @EndUserText.label: 'Purchasing Document Item'
      PurchasingDocumentItem         as PurchasingDocumentItem,

      @UI: { lineItem : [ { position: 340 } ],
             identification: [ { position: 340 } ] }
      @EndUserText.label: 'GR Document Year'
      GRDocumentYear                 as GRDocumentYear,

      @UI: { lineItem : [ { position: 350 } ],
             identification: [ { position: 350 } ] }
      @EndUserText.label: 'GR Document'
      GRDocument                     as GRDocument,

      @UI: { lineItem : [ { position: 360 } ],
             identification: [ { position: 360 } ] }
      @EndUserText.label: 'GR Document Item'
      GRDocumentItem                 as GRDocumentItem,

      @UI: { lineItem : [ { position: 370 } ],
             identification: [ { position: 370 } ] }
      @EndUserText.label: 'MIRO Document'
      @Consumption.semanticObject: 'SupplierInvoice'
      MIRODocument                   as MIRODocument,

      @UI: { lineItem : [ { position: 380 } ],
             identification: [ { position: 380 } ] }
      @EndUserText.label: 'MIRO Document Item'
      MIRODocumentItem               as MIRODocumentItem,

      @UI: { lineItem : [ { position: 390 } ],
             identification: [ { position: 390 } ] }
      @EndUserText.label: 'Product Type'
      ProductType                    as ProductType,

      @UI: { lineItem : [ { position: 400 } ],
             identification: [ { position: 400 } ] }
      @EndUserText.label: 'HSN / SAC Code'
      HSNOrSACCode                   as HSNOrSACCode,

      @UI: { lineItem : [ { position: 410 } ],
             identification: [ { position: 410 } ] }
      @EndUserText.label: 'Product'
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_ProductStdVH', entity.element: 'Product' }]
      Product                        as Product,

      @UI: { lineItem : [ { position: 420 } ],
             identification: [ { position: 420 } ] }
      @EndUserText.label: 'Product Name'
      ProductName                    as ProductName,

      @UI: { lineItem : [ { position: 430 } ],
             identification: [ { position: 430 } ] }
      @EndUserText.label: 'Document Item Text'
      DocumentItemText               as DocumentItemText,

      @UI: { lineItem : [ { position: 440 } ],
             identification: [ { position: 440 } ] }
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      Quantity                       as Quantity,

      @UI: { lineItem : [ { position: 450 } ],
             identification: [ { position: 450 } ] }
      @EndUserText.label: 'Base Unit'
      BaseUnit                       as BaseUnit,

      @UI: { lineItem : [ { position: 460 } ],
             identification: [ { position: 460 } ] }
      @EndUserText.label: 'Tax Code'
      TaxCode                        as TaxCode,

      @UI: { lineItem : [ { position: 470 } ],
             identification: [ { position: 470 } ] }
      @EndUserText.label: 'Tax Code Name'
      TaxCodeName                    as TaxCodeName,

      @UI: { lineItem : [ { position: 480 } ],
             identification: [ { position: 480 } ] }
      @EndUserText.label: 'Amount In Trans. Currency'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency    as AmountInTransactionCurrency,

      @UI: { identification: [ { position: 490 } ] }
      @EndUserText.label: 'Transaction Currency'
      TransactionCurrency            as TransactionCurrency,

      @UI: { lineItem : [ { position: 500 } ],
             identification: [ { position: 500 } ] }
      @EndUserText.label: 'Amount In Company Currency'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency    as AmountInCompanyCodeCurrency,

      @UI: { identification: [ { position: 510 } ] }
      @EndUserText.label: 'Company Currency'
      CompanyCodeCurrency            as CompanyCodeCurrency,

      @UI: { lineItem : [ { position: 520 } ],
             identification: [ { position: 520 } ] }
      @EndUserText.label: 'Net Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      NetAmount                      as NetAmount,

      @UI: { lineItem : [ { position: 530 } ],
             identification: [ { position: 530 } ] }
      @EndUserText.label: 'G/L Account IGST'
      IGSTGLAccount                  as IGSTGLAccount,

      @UI: { lineItem : [ { position: 540 } ],
             identification: [ { position: 540 } ] }
      @EndUserText.label: 'IGST Rate'
      IGSTRate                       as IGSTRate,

      @UI: { lineItem : [ { position: 550 } ],
             identification: [ { position: 550 } ] }
      @EndUserText.label: 'IGST Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      IGSTAmount                     as IGSTAmount,

      @UI: { lineItem : [ { position: 560 } ],
             identification: [ { position: 560 } ] }
      @EndUserText.label: 'G/L Account CGST'
      CGSTGLAccount                  as CGSTGLAccount,

      @UI: { lineItem : [ { position: 570 } ],
             identification: [ { position: 570 } ] }
      @EndUserText.label: 'CGST Rate'
      CGSTRate                       as CGSTRate,

      @UI: { lineItem : [ { position: 580 } ],
             identification: [ { position: 580 } ] }
      @EndUserText.label: 'CGST Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      CGSTAmount                     as CGSTAmount,

      @UI: { lineItem : [ { position: 590 } ],
             identification: [ { position: 590 } ] }
      @EndUserText.label: 'G/L Account SGST'
      SGSTGLAccount                  as SGSTGLAccount,

      @UI: { lineItem : [ { position: 600 } ],
             identification: [ { position: 600 } ] }
      @EndUserText.label: 'SGST Rate'
      SGSTRate                       as SGSTRate,

      @UI: { lineItem : [ { position: 610 } ],
             identification: [ { position: 610 } ] }
      @EndUserText.label: 'SGST Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      SGSTAmount                     as SGSTAmount,

      @UI: { lineItem : [ { position: 620 } ],
             identification: [ { position: 620 } ] }
      @EndUserText.label: 'Supplier PAN'
      BusinessPartnerPANNumber       as BusinessPartnerPANNumber,

      @UI: { lineItem : [ { position: 630 } ],
             identification: [ { position: 630 } ] }
      @EndUserText.label: 'G/L Account TDS'
      TDSGLAccount                   as TDSGLAccount,

      @UI: { lineItem : [ { position: 640 } ],
             identification: [ { position: 640 } ] }
      @EndUserText.label: 'TDS Section Code'
      OfficialWhldgTaxCode           as OfficialWhldgTaxCode,

      @UI: { lineItem : [ { position: 650 } ],
             identification: [ { position: 650 } ] }
      @EndUserText.label: 'TDS Key'
      WithholdingTaxType             as WithholdingTaxType,

      @UI: { lineItem : [ { position: 660 } ],
             identification: [ { position: 660 } ] }
      @EndUserText.label: 'TDS Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      WhldgTaxAmtInCoCodeCrcy        as WhldgTaxAmtInCoCodeCrcy,

      @UI: { lineItem : [ { position: 670 } ],
             identification: [ { position: 670 } ] }
      @EndUserText.label: 'Tax Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      TaxAmount                      as TaxAmount,

      @UI: { lineItem : [ { position: 680 } ],
             identification: [ { position: 680 } ] }
      @EndUserText.label: 'Invoice Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      InvoiceAmount                  as InvoiceAmount,

      @UI: { lineItem : [ { position: 690 } ],
             identification: [ { position: 690 } ] }
      @EndUserText.label: 'G/L Account UGST'
      UGSTGLAccount                  as UGSTGLAccount,

      @UI: { lineItem : [ { position: 700 } ],
             identification: [ { position: 700 } ] }
      @EndUserText.label: 'UGST Rate'
      UGSTRate                       as UGSTRate,

      @UI: { lineItem : [ { position: 710 } ],
             identification: [ { position: 710 } ] }
      @EndUserText.label: 'UGST Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      UGSTAmount                     as UGSTAmount,

      @UI: { lineItem : [ { position: 720 } ],
             identification: [ { position: 720 } ] }
      @EndUserText.label: 'RCMIGST Rate'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMIGSTRATE                    as RCMIGSTRATE,

      @UI: { lineItem : [ { position: 730 } ],
             identification: [ { position: 730 } ] }
      @EndUserText.label: 'RCMIGST Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMIGSTAmount                  as RCMIGSTAmount,

      @UI: { lineItem : [ { position: 740 } ],
             identification: [ { position: 740 } ] }
      @EndUserText.label: 'RCMCGST Rate'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMCGSTRate                    as RCMCGSTRate,

      @UI: { lineItem : [ { position: 750 } ],
             identification: [ { position: 750 } ] }
      @EndUserText.label: 'RCMCGST Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMCGSTAmount                  as RCMCGSTAmount,

      @UI: { lineItem : [ { position: 760 } ],
             identification: [ { position: 760 } ] }
      @EndUserText.label: 'RCMSGST Rate'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMSGSTRate                    as RCMSGSTRate,

      @UI: { lineItem : [ { position: 770 } ],
             identification: [ { position: 770 } ] }
      @EndUserText.label: 'RCMSGST Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMSGSTAmount                  as RCMSGSTAmount,

      @UI: { lineItem : [ { position: 780 } ],
             identification: [ { position: 780 } ] }
      @EndUserText.label: 'RCMUGST Rate'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMUGSTRate                    as RCMUGSTRate,

      @UI: { lineItem : [ { position: 790 } ],
             identification: [ { position: 790 } ] }
      @EndUserText.label: 'RCMUGST Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      RCMUGSTAmount                  as RCMUGSTAmount

}
