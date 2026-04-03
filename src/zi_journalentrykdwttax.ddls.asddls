@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI : Inv/Cr & Dr Not Withholding Tax'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_JournalEntryKDWTTax
  as select from I_Withholdingtaxitem as _Withholdingtaxitem
    left outer join I_GLAccountInCompanyCode as _GLAccnt on _GLAccnt.CompanyCode = _Withholdingtaxitem.CompanyCode
                                                        and _GLAccnt.GLAccount = _Withholdingtaxitem.GLAccount
{
  key _Withholdingtaxitem.CompanyCode as CompanyCode,
  key _Withholdingtaxitem.AccountingDocument as AccountingDocument,
  key _Withholdingtaxitem.FiscalYear as FiscalYear,
  key _Withholdingtaxitem.AccountingDocumentItem as AccountingDocumentItem,
      _Withholdingtaxitem.WithholdingTaxType as WithholdingTaxType,
      _Withholdingtaxitem.WithholdingTaxCode as WithholdingTaxCode,
      _Withholdingtaxitem._WithholdingTaxCode.OfficialWhldgTaxCode as OfficialWhldgTaxCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _Withholdingtaxitem.WhldgTaxBaseAmtInCoCodeCrcy as WhldgTaxBaseAmtInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      _Withholdingtaxitem.WhldgTaxBaseAmtInTransacCrcy as WhldgTaxBaseAmtInTransacCrcy,
      _Withholdingtaxitem.WhldgTaxBaseIsEnteredManually as WhldgTaxBaseIsEnteredManually,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _Withholdingtaxitem.WhldgTaxAmtInCoCodeCrcy as WhldgTaxAmtInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      _Withholdingtaxitem.WhldgTaxAmtInTransacCrcy as WhldgTaxAmtInTransacCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _Withholdingtaxitem.WhldgTaxExmptAmtInCoCodeCrcy as WhldgTaxExmptAmtInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      _Withholdingtaxitem.WhldgTaxExmptAmtInTransacCrcy as WhldgTaxExmptAmtInTransacCrcy,
      _Withholdingtaxitem.WhldgTaxExmptCertificate as WhldgTaxExmptCertificate,
      _Withholdingtaxitem.FinancialAccountType as FinancialAccountType,
      _Withholdingtaxitem.CustomerSupplierAccount as CustomerSupplierAccount,
      _Withholdingtaxitem.GLAccount as GLAccount,
      _GLAccnt._Text[ Language = $session.system_language ].GLAccountName as GLAccountName,
      _GLAccnt._Text[ Language = $session.system_language ].GLAccountLongName as GLAccountLongName,
      _Withholdingtaxitem.SupplierRecipientType as SupplierRecipientType,
      _Withholdingtaxitem.WithholdingTaxExmptPercent as WithholdingTaxExmptPercent,
      _Withholdingtaxitem.WithholdingTaxPercent as WithholdingTaxPercent,
      _Withholdingtaxitem.Country as Country,
      _Withholdingtaxitem.CompanyCodeCurrency as CompanyCodeCurrency,
      _Withholdingtaxitem.DocumentCurrency as DocumentCurrency
}
where _Withholdingtaxitem.WhldgTaxAmtInCoCodeCrcy <> 0
