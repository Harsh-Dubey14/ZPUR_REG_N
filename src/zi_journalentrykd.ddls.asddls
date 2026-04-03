@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI : Inv/Cr & Dr Note Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_JournalEntryKD
  as select from I_JournalEntry as _JournalEntry
    left outer join I_IN_BusinessPlaceTaxDetail as _BusinessPlace on _BusinessPlace.BusinessPlace = _JournalEntry.Branch
                                                                          and _BusinessPlace.CompanyCode = _JournalEntry.CompanyCode

    left outer join I_OperationalAcctgDocItem as _AcctgDocItem on _AcctgDocItem.CompanyCode = _JournalEntry.CompanyCode
                                                                          and _AcctgDocItem.FiscalYear = _JournalEntry.FiscalYear
                                                                          and _AcctgDocItem.AccountingDocument = _JournalEntry.AccountingDocument
                                                                          and (
                                                                             _AcctgDocItem.FinancialAccountType = 'K'
                                                                             or _AcctgDocItem.FinancialAccountType = 'D'
                                                                           )
    left outer join I_FinancialAccountTypeText as _FinancialAccountType on _FinancialAccountType.Language = $session.system_language
                                                                          and _FinancialAccountType.FinancialAccountType = _AcctgDocItem.FinancialAccountType

    left outer join I_AccountingDocumentODN as _AccountingDocumentODN on _AccountingDocumentODN.OfficialDocumentNumberType = 'ZZODN2'
                                                                          and _AccountingDocumentODN.CompanyCode = _JournalEntry.CompanyCode
                                                                          and _AccountingDocumentODN.FiscalYear = _JournalEntry.FiscalYear
                                                                          and _AccountingDocumentODN.AccountingDocument = _JournalEntry.AccountingDocument

  association [1..1] to I_BusinessPartner as _BusinessPartner on $projection.BusinessPartner = _BusinessPartner.BusinessPartner

  association [0..1] to ZI_JournalEntryKDWTTax as _JournalEntryKDWTTax on $projection.CompanyCode = _JournalEntryKDWTTax.CompanyCode
                                                                       and $projection.FiscalYear = _JournalEntryKDWTTax.FiscalYear
                                                                       and $projection.AccountingDocument = _JournalEntryKDWTTax.AccountingDocument
                                                                       and $projection.MainLineItem = _JournalEntryKDWTTax.AccountingDocumentItem
{
  key _JournalEntry.CompanyCode as CompanyCode,
  key _JournalEntry.FiscalYear as FiscalYear,
  key _JournalEntry.AccountingDocument as AccountingDocument,
      _JournalEntry.FiscalPeriod as FiscalPeriod,
//      _JournalEntry._FiscalPeriod._Text.FiscalPeriodName as FiscalPeriodName,
      _JournalEntry._FiscalPeriod._Text[ Language = $session.system_language ].FiscalPeriodName as FiscalPeriodName,
      _JournalEntry.AccountingDocumentType as AccountingDocumentType,
      _JournalEntry._AccountingDocumentType._Text[ Language = $session.system_language ].AccountingDocumentTypeName as AccountingDocumentTypeName,
      _JournalEntry.DocumentDate as DocumentDate,
      _JournalEntry.PostingDate as PostingDate,
      _AcctgDocItem.DueCalculationBaseDate as DueCalculationBaseDate,
      _AcctgDocItem.NetDueDate as NetDueDate,

      _JournalEntry._CompanyCode.CompanyCodeName as CompanyCodeName,
      _JournalEntry._CompanyCode.AddressID as CompanyCodeAddressID,

      case when _AccountingDocumentODN.OfficialDocumentNumber is not initial
        then _AccountingDocumentODN.OfficialDocumentNumber
        else _JournalEntry.DocumentReferenceID end as DocumentReferenceID,
      _AcctgDocItem.BillingDocument as BillingDocument,
      _AcctgDocItem.SalesDocument as SalesDocument,
      _AcctgDocItem.SalesDocumentItem as SalesDocumentItem,
      _AcctgDocItem.FinancialAccountType as FinancialAccountType,
      _FinancialAccountType.FinancialAccountTypeName as FinancialAccountTypeName,
      _AcctgDocItem.AccountingDocumentItem as MainLineItem,
      _AcctgDocItem.DebitCreditCode as DebitCreditCode,
      _AcctgDocItem._DebitCreditCode._Text[ Language = $session.system_language ].DebitCreditCodeName as DebitCreditCodeName,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier.SupplierAccountGroup
        else _AcctgDocItem._Customer.CustomerAccountGroup end as BusinessPartnerAccountGroup,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem.Supplier
        else _AcctgDocItem.Customer end as BusinessPartner,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier.SupplierName
        else _AcctgDocItem._Customer.CustomerName end as BusinessPartnerName,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier.AddressID
        else _AcctgDocItem._Customer.AddressID end as BusinessPartnerAddressID,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier.TaxNumber3
        else _AcctgDocItem._Customer.TaxNumber3 end as BusinessPartnerGSTIN,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier.BusinessPartnerPanNumber
        else substring( _AcctgDocItem._Customer.TaxNumber3, 3, 10 ) end as BusinessPartnerPANNumber,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier.Country
        else _AcctgDocItem._Customer.Country end as BusinessPartnerCountry,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier._AddressRepresentation._Country._Text[ Language = $session.system_language ].CountryName
        else _AcctgDocItem._Customer._AddressRepresentation._Country._Text[ Language = $session.system_language ].CountryName end as BusinessPartnerCountryName,

      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier.Region
        else _AcctgDocItem._Customer.Region end as BusinessPartnerRegion,
      
      case _AcctgDocItem.FinancialAccountType
        when 'K' then _AcctgDocItem._Supplier._AddressRepresentation._Region._RegionText[ Language = $session.system_language ].RegionName
        else _AcctgDocItem._Customer._AddressRepresentation._Region._RegionText[ Language = $session.system_language ].RegionName end as BusinessPartnerRegionName,  

      _JournalEntry.AccountingDocumentHeaderText as AccountingDocumentHeaderText,
      _AcctgDocItem.DocumentItemText as DocumentItemText,
      _JournalEntry.Branch as BusinessPlace,
      _BusinessPlace.IN_GSTIdentificationNumber as BusinessPlaceGSTIN,
      _AcctgDocItem.GLAccount as GLAccount,
      _AcctgDocItem._GLAccountInCompanyCode._Text[ Language = $session.system_language ].GLAccountName as GLAccountName,
      _AcctgDocItem._GLAccountInCompanyCode._Text[ Language = $session.system_language ].GLAccountLongName as GLAccountLongName,

      _JournalEntry.TransactionCurrency as TransactionCurrency,
      _JournalEntry.CompanyCodeCurrency as CompanyCodeCurrency,
      _JournalEntry.AbsoluteExchangeRate as AbsoluteExchangeRate,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ( _AcctgDocItem.AmountInTransactionCurrency + _AcctgDocItem.WithholdingTaxAmount ) as AmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ( _AcctgDocItem.AbsoluteAmountInTransacCrcy + _AcctgDocItem.WithholdingTaxAbsoluteAmount ) as AbsoluteAmountInTransacCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ( _AcctgDocItem.AmountInCompanyCodeCurrency + _AcctgDocItem.WithholdingTaxAmount ) as AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ( _AcctgDocItem.AbsoluteAmountInCoCodeCrcy + _AcctgDocItem.WithholdingTaxAbsoluteAmount ) as AbsoluteAmountInCoCodeCrcy,

      _JournalEntry.ReverseDocument as ReverseDocument,
      _JournalEntry.ReverseDocumentFiscalYear as ReverseDocumentFiscalYear,
      _JournalEntry.ReversalReferenceDocument as ReversalReferenceDocument,
      _JournalEntry.ReversalReferenceDocumentCntxt as ReversalReferenceDocumentCntxt,
      _JournalEntry.IsReversal as IsReversal,
      _JournalEntry.IsReversed as IsReversed,

      _JournalEntry.AccountingDocumentCreationDate as CreationDate,
      _JournalEntry.CreationTime as CreationTime,
      dats_tims_to_tstmp(
        _JournalEntry.AccountingDocumentCreationDate,
        _JournalEntry.CreationTime,
        abap_system_timezone( $session.client, 'NULL' ),
        $session.client, 'NULL' ) as CreationDateTime,
      _JournalEntry.AccountingDocCreatedByUser as CreatedBy,
      _JournalEntry._User.UserDescription as CreatedByName,

      _JournalEntry.ReferenceDocumentLogicalSystem as ReferenceDocumentLogicalSystem,
      _JournalEntry.ReferenceDocumentType as ReferenceDocumentType,
      _JournalEntry.OriginalReferenceDocument as OriginalReferenceDocument,
      _AcctgDocItem.ClearingJournalEntry as ClearingJournalEntry,
      _AcctgDocItem.ClearingDate as ClearingDate,
      _AcctgDocItem.ClearingJournalEntryFiscalYear as ClearingJournalEntryFiscalYear,

      //--- Associations ---//
      _BusinessPartner,
      _JournalEntryKDWTTax
}
where
  (
       // For Customer
       _JournalEntry.AccountingDocumentType = 'DR'
    or _JournalEntry.AccountingDocumentType = 'DG'
    or _JournalEntry.AccountingDocumentType = 'DN'

    // For Supplier
    or _JournalEntry.AccountingDocumentType = 'RE'
    or _JournalEntry.AccountingDocumentType = 'RT'
    or _JournalEntry.AccountingDocumentType = 'KR'
    or _JournalEntry.AccountingDocumentType = 'KG'

    or _JournalEntry.AccountingDocumentType = 'JV'
  )
