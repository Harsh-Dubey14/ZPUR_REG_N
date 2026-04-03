@ObjectModel: {
query: {
   implementedBy: 'ABAP:ZCL_PURCHASE_FI'
}
}

@UI.headerInfo: { typeName: 'Purchase Register FI' ,
                  typeNamePlural: 'Purchase Register FI' }


@EndUserText.label: 'Purchase Register FI'
define custom entity ZCE_PUR_REG_FI
{

      /* ======================= FACETS ======================= */
      @UI.facet                    : [{
        id                         : 'Document',
        position                   : 10,
        purpose                    : #STANDARD,
        type                       : #IDENTIFICATION_REFERENCE,
        label                      : 'Purchasing Details'
      }]

      /* ======================= KEYS ======================= */

      @UI                          : {
        lineItem                   : [{ position: 10 }],
        identification             : [{ position: 10 }],
        selectionField             : [{ position: 10 }]
      }
      @Search.defaultSearchElement : true
      @EndUserText.label           : 'Company Code'
      @Consumption.valueHelpDefinition: [{
          entity.name              : 'I_CompanyCodeStdVH',
          entity.element           : 'CompanyCode'
      }]
  key CompanyCode                  : bukrs;

      @UI                          : {
        lineItem                   : [{ position: 20 }],
        identification             : [{ position: 20 }],
        selectionField             : [{ position: 20 }]
      }
      @EndUserText.label           : 'Fiscal Year'
  key FiscalYear                   : gjahr;

      @UI                          : {
        lineItem                   : [{ position: 30 }],
        identification             : [{ position: 30 }],
        selectionField             : [{ position: 30 }]
      }
      @EndUserText.label           : 'Accounting Document'
      @Consumption.semanticObject  : 'AccountingDocument'
  key AccountingDocument           : belnr_d;

      @UI                          : {
        lineItem                   : [{ position: 40 }],
        identification             : [{ position: 40 }]
      }
      @EndUserText.label           : 'Accounting Doc Item'
  key AccountingDocumentItem       : buzei;

      /* ======================= HEADER DATA ======================= */

      @UI.lineItem                 : [{ position: 50 }]
      @EndUserText.label           : 'Invoice Reference No.'
      DocumentReferenceID          : awkey;

      @UI.lineItem                 : [{ position: 60 }]
      @EndUserText.label           : 'Document Type'
      @Consumption.valueHelpDefinition: [{
          entity.name              : 'I_AccountingDocumentTypeText',
          entity.element           : 'AccountingDocumentType'
      }]
      AccountingDocumentType       : blart;

      @UI.lineItem                 : [{ position: 70 }]
      @EndUserText.label           : 'Document Type Name'
      AccountingDocumentTypeName   : abap.char(20);

      /* ======================= DATES ======================= */

      @UI                          : {
        lineItem                   : [{ position: 80 }],
        selectionField             : [{ position: 80 }]
      }
      @Consumption.filter          : { selectionType: #INTERVAL }
      @EndUserText.label           : 'Document Date'
      DocumentDate                 : bldat;

      @UI                          : {
        lineItem                   : [{ position: 90 }],
        selectionField             : [{ position: 90 }]
      }
      @Consumption.filter          : { selectionType: #INTERVAL, mandatory: true }
      @EndUserText.label           : 'Posting Date'
      PostingDate                  : budat;

      @UI.lineItem                 : [{ position: 100 }]
      @EndUserText.label           : 'Net Due Date'
      NetDueDate                   : datum;

      @UI.lineItem                 : [{ position: 110 }]
      @EndUserText.label           : 'Creation Date'
      CreationDate                 : erdat;

      @UI.lineItem                 : [{ position: 120 }]
      @EndUserText.label           : 'Created By'
      CreatedBy                    : ernam;

      /* ======================= SUPPLIER ======================= */

      @UI                          : {
        lineItem                   : [{ position: 130 }],
        selectionField             : [{ position: 130 }]
      }
      @Consumption.valueHelpDefinition: [{
          entity.name              : 'I_Supplier_VH',
          entity.element           : 'Supplier'
      }]
      @Consumption.semanticObject  : 'Supplier'
      @EndUserText.label           : 'Supplier'
      Supplier                     : lifnr;

      @UI.lineItem                 : [{ position: 140 }]
      @EndUserText.label           : 'Supplier Name'
      SupplierName                 : abap.char(40);

      @UI.lineItem                 : [{ position: 150 }]
      @EndUserText.label           : 'Supplier GSTIN'
      SupplierGSTIN                : stceg;

      /* ===================== SUPPLIER PAN ===================== */

      @UI                          : { lineItem: [{ position: 160 }], identification: [{ position: 160 }] }
      @EndUserText.label           : 'Supplier PAN'
      BusinessPartnerPANNumber     : abap.char(10);

      /* ======================= ACCOUNTING ======================= */

      @UI.lineItem                 : [{ position: 170 }]
      @EndUserText.label           : 'GL Account'
      @Consumption.valueHelpDefinition: [{
          entity.name              : 'I_GLAccountStdVH',
          entity.element           : 'GLAccount'
      }]
      GLAccount                    : saknr;

      @UI.lineItem                 : [{ position: 180 }]
      @EndUserText.label           : 'GL Account Name'
      GLAccountName                : abap.char(50);

      @UI.lineItem                 : [{ position: 190 }]
      @EndUserText.label           : 'Cost Center'
      @Consumption.valueHelpDefinition: [{
          entity.name              : 'I_CostCenterStdVH',
          entity.element           : 'CostCenter'
      }]
      CostCenter                   : kostl;

      /* ======================= MATERIAL ======================= */

      @UI.lineItem                 : [{ position: 200 }]
      @EndUserText.label           : 'Product'
      @Consumption.valueHelpDefinition: [{
          entity.name              : 'I_ProductStdVH',
          entity.element           : 'Product'
      }]
      Product                      : matnr;

      @UI.lineItem                 : [{ position: 210 }]
      @EndUserText.label           : 'Product Name'
      ProductName                  : maktx;

      /* ======================= QUANTITY ======================= */

      @UI.lineItem                 : [{ position: 220 }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @EndUserText.label           : 'Quantity'
      Quantity                     : menge_d;

      @UI.lineItem                 : [{ position: 230 }]
      @EndUserText.label           : 'Base Unit'
      BaseUnit                     : meins;

      /* ======================= AMOUNTS ======================= */

      @UI.lineItem                 : [{ position: 240 }]
      @Semantics.amount.currencyCode:'TransactionCurrency'
      @EndUserText.label           : 'Amount in Trans Currency'
      AmountInTransactionCurrency  : wrbtr;

      @UI.identification           : [{ position: 250 }]
      TransactionCurrency          : waers;


      @UI.identification           : [{ position: 251 }]
      TransactionTypeDetermination : ktosl;



      @UI.lineItem                 : [{ position: 260 }]
      @Semantics.amount.currencyCode:'CompanyCodeCurrency'
      @EndUserText.label           : 'Amount in Company Currency'
      AmountInCompanyCodeCurrency  : dmbtr;

      @UI.identification           : [{ position: 270 }]
      CompanyCodeCurrency          : waers;

      /* ======================= IGST ======================= */

      @UI.lineItem                 : [{ position: 280 }]
      @EndUserText.label           : 'IGST GL'
      IGSTGLAccount                : saknr;

      @UI.lineItem                 : [{ position: 290 }]
      @EndUserText.label           : 'IGST Rate'
      IGSTRate                     : abap.dec(5,2);

      @UI.lineItem                 : [{ position: 300 }]
      @Semantics.amount.currencyCode:'CompanyCodeCurrency'
      @EndUserText.label           : 'IGST Amount'
      IGSTAmount                   : dmbtr;

      /* ===================== CGST ===================== */

      @UI                          : { lineItem: [{ position: 310 }], identification: [{ position: 310 }] }
      @EndUserText.label           : 'G/L Account CGST'
      CGSTGLAccount                : abap.char(10);

      @UI                          : { lineItem: [{ position: 320 }], identification: [{ position: 320 }] }
      @EndUserText.label           : 'CGST Rate'
      CGSTRate                     : abap.dec(5,2);

      @UI                          : { lineItem: [{ position: 330 }], identification: [{ position: 330 }] }
      @EndUserText.label           : 'CGST Amount'
      @Semantics.amount.currencyCode:'CompanyCodeCurrency'
      CGSTAmount                   : abap.curr(15,2);

      /* ===================== SGST ===================== */

      @UI                          : { lineItem: [{ position: 340 }], identification: [{ position: 340 }] }
      @EndUserText.label           : 'G/L Account SGST'
      SGSTGLAccount                : abap.char(10);

      @UI                          : { lineItem: [{ position: 350 }], identification: [{ position: 350 }] }
      @EndUserText.label           : 'SGST Rate'
      SGSTRate                     : abap.dec(5,2);

      @UI                          : { lineItem: [{ position: 360 }], identification: [{ position: 360 }] }
      @EndUserText.label           : 'SGST Amount'
      @Semantics.amount.currencyCode:'CompanyCodeCurrency'
      SGSTAmount                   : abap.curr(15,2);

      /* ===================== UGST ===================== */

      @UI                          : { lineItem: [{ position: 370 }], identification: [{ position: 370 }] }
      @EndUserText.label           : 'G/L Account UGST'
      UGSTGLAccount                : abap.char(10);

      @UI                          : { lineItem: [{ position: 380 }], identification: [{ position: 380 }] }
      @EndUserText.label           : 'UGST Rate'
      UGSTRate                     : abap.dec(5,2);

      @UI                          : { lineItem: [{ position: 390 }], identification: [{ position: 390 }] }
      @EndUserText.label           : 'UGST Amount'
      @Semantics.amount.currencyCode:'CompanyCodeCurrency'
      UGSTAmount                   : abap.curr(15,2);

      /* ===================== TDS ===================== */

      @UI                          : { lineItem: [{ position: 400 }], identification: [{ position: 400 }] }
      @EndUserText.label           : 'G/L Account TDS'
      TDSGLAccount                 : abap.char(10);

      @UI                          : { lineItem: [{ position: 410 }], identification: [{ position: 410 }] }
      @EndUserText.label           : 'TDS Section Code'
      OfficialWhldgTaxCode         : abap.char(4);

      @UI                          : { lineItem: [{ position: 420 }], identification: [{ position: 420 }] }
      @EndUserText.label           : 'TDS Key'
      WithholdingTaxType           : abap.char(2);

      @UI                          : { lineItem: [{ position: 430 }], identification: [{ position: 430 }] }
      @EndUserText.label           : 'TDS Amount'
      @Semantics.amount.currencyCode:'CompanyCodeCurrency'
      WhldgTaxAmtInCoCodeCrcy      : abap.curr(15,2);

      /* ===================== TOTALS ===================== */

      @UI                          : { lineItem: [{ position: 440 }], identification: [{ position: 440 }] }
      @EndUserText.label           : 'Tax Amount'
      @Semantics.amount.currencyCode:'CompanyCodeCurrency'
      TaxAmount                    : abap.curr(15,2);

      @UI                          : { lineItem: [{ position: 450 }], identification: [{ position: 450 }] }
      @EndUserText.label           : 'Invoice Amount'
      @Semantics.amount.currencyCode:'CompanyCodeCurrency'
      InvoiceAmount                : abap.curr(15,2);

}
