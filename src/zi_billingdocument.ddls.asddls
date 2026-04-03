@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD : Billing Document Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BillingDocument
  as select distinct from I_BillingDocumentBasic as _BillingDocument
    left outer join I_PaymentTermsText as _PaymentTermsText on _PaymentTermsText.Language = $session.system_language
                                                                           and _PaymentTermsText.PaymentTerms = _BillingDocument.CustomerPaymentTerms
    left outer join I_SDDocumentCategoryText as _SDDocumentCategory on _SDDocumentCategory.Language = $session.system_language
                                                                           and _SDDocumentCategory.SDDocumentCategory = _BillingDocument.SDDocumentCategory
    left outer join I_BillingDocumentODN as _BillingDocumentODN on _BillingDocumentODN.BillingDocument = _BillingDocument.BillingDocument
                                                                           and _BillingDocumentODN.OfficialDocumentNumberType = 'ZZODN2'
    left outer join I_BPFinancialServicesExtn as _BPFinancial on _BPFinancial.BusinessPartner = _BillingDocument.SoldToParty
    left outer join I_JournalEntry as _JournalEntry on _JournalEntry.CompanyCode = _BillingDocument.BillingDocument
                                                                           and _JournalEntry.FiscalYear = _BillingDocument.FiscalYear
                                                                           and _JournalEntry.AccountingDocument = _BillingDocument.AccountingDocument
    left outer join I_BillingDocumentBasic as _CancelledBillDoc on _CancelledBillDoc.CancelledBillingDocument = _BillingDocument.BillingDocument
  association [1..*] to ZI_BillingDocumentPartner as _PartnerFunction on $projection.BillingDocument = _PartnerFunction.BillingDocument
  association [1..*] to ZI_BillingDocumentItem as _BillingDocumentItem on $projection.BillingDocument = _BillingDocumentItem.BillingDocument
  association [0..1] to ZI_BillingDocFirstLine as _BillingDocFirstLine on $projection.BillingDocument = _BillingDocFirstLine.BillingDocument
{
  key _BillingDocument.BillingDocument as BillingDocument,
      _BillingDocument.SDDocumentCategory as SDDocumentCategory,
      _SDDocumentCategory.SDDocumentCategoryName as SDDocumentCategoryName,
      _BillingDocument.BillingDocumentType as BillingDocumentType,
      _BillingDocument._BillingDocumentType._Text[ Language = $session.system_language ].BillingDocumentTypeName as BillingDocumentTypeName,
      _BillingDocument.BillingDocumentIsCancelled as BillingDocumentIsCancelled,
      _BillingDocument.CancelledBillingDocument as CancelledBillingDocument,
      case when _BillingDocument.BillingDocumentIsCancelled is not initial
             or _BillingDocument.CancelledBillingDocument is not initial
           then 'Yes'
           else 'No' end as CancelledStatus,
      case when _BillingDocument.CancelledBillingDocument is not initial
        then _BillingDocument.CancelledBillingDocument
        else _CancelledBillDoc.CancelledBillingDocument end as CancelledRefDocument,
      @EndUserText.label: 'ODN Number'
      case when _BillingDocumentODN.OfficialDocumentNumber is not initial
        then _BillingDocumentODN.OfficialDocumentNumber
        else _BillingDocument.DocumentReferenceID end as DocumentReferenceID,
      _BillingDocument.AccountingDocument as AccountingDocument,
      _BillingDocument.AccountingExchangeRate as AccountingExchangeRate,
      _BillingDocument.FiscalYear as FiscalYear,
      _BillingDocument.BillingDocumentDate as BillingDocumentDate,
      _BillingDocument.CreationDate as CreationDate,
      _BillingDocument.CreationTime as CreationTime,
      concat(_BillingDocument.CreationDate,_BillingDocument.CreationTime) as CreationDateTime,
      _BillingDocument.LastChangeDateTime as LastChangeDateTime,
      _BillingDocument.CreatedByUser as CreatedByUser,
      _BillingDocument._CreatedByUser.UserDescription as CreatedByUserName,
      _BillingDocument.CompanyCode as CompanyCode,
      _BillingDocument._CompanyCode.CompanyCodeName as CompanyCodeName,
      _BillingDocument.SalesOrganization as SalesOrganization,
      _BillingDocument._SalesOrganization._Text[ Language = $session.system_language ].SalesOrganizationName as SalesOrganizationName,
      _BillingDocument.DistributionChannel as DistributionChannel,
      _BillingDocument._DistributionChannel._Text[ Language = $session.system_language ].DistributionChannelName as DistributionChannelName,
      _BillingDocument.Division as Division,
      _BillingDocument._Division._Text[ Language = $session.system_language ].DivisionName as DivisionName,
      _BPFinancial.BusinessPartnerIsVIP as SoldToPartyIsVIP,
      _BillingDocument.SoldToParty as SoldToParty,
      _BillingDocument._SoldToParty.CustomerName as SoldToPartyName,
      _BillingDocument._SoldToParty.TaxNumber3 as SoldToPartyGSTIN,
      _BillingDocument._SoldToParty.AddressID as SoldToPartyAddressID,
      _BillingDocument._SoldToParty._AddressDefaultRepresentation.CityName as SoldToPartyCityName,
      _BillingDocument._SoldToParty._AddressDefaultRepresentation.Region as SoldToPartyRegion,
      _BillingDocument._SoldToParty._AddressDefaultRepresentation._Region._RegionText[ Language = $session.system_language ].RegionName as SoldToPartyRegionName,
      _BillingDocument._SoldToParty._AddressDefaultRepresentation.Country as SoldToPartyCountry,
      _BillingDocument._SoldToParty._AddressDefaultRepresentation._Country._Text[ Language = $session.system_language ].CountryName as SoldToPartyCountryName,
      _BillingDocument._SoldToParty._AddressDefaultRepresentation.PostalCode as SoldToPartyPostalCode,
      _BillingDocument.CustomerPaymentTerms as CustomerPaymentTerms,
      @EndUserText.label: 'Customer Payment Terms Name'
      case when _PaymentTermsText.PaymentTermsName is not initial then _PaymentTermsText.PaymentTermsName
        else _PaymentTermsText.PaymentTermsDescription end as CustomerPaymentTermsName,
      _BillingDocument.IncotermsClassification as IncotermsClassification,
      _BillingDocument.IncotermsTransferLocation as IncotermsTransferLocation,
      case when
        _BillingDocument.CustomerTaxClassification1 = '2' or
        _BillingDocument.CustomerTaxClassification2 = '2' or
        _BillingDocument.CustomerTaxClassification3 = '2' or
        _BillingDocument.CustomerTaxClassification4 = '2' or
        _BillingDocument.CustomerTaxClassification5 = '2' then 'Yes'
        else 'No' end as SEZCustomer,
      _BillingDocument.TransactionCurrency as TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _BillingDocument.TotalNetAmount as TotalNetAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _BillingDocument.TotalTaxAmount as TotalTaxAmount,
      @EndUserText.label: 'Company Code Currency'
      cast('INR' as abap.cuky) as CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Total Net Amount in CoCode Currency'
      cast( _BillingDocument.TotalNetAmount as abap.dec(23,2) ) *
            _BillingDocument.AccountingExchangeRate as TotalNetAmountINR,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Total Net Amount in CoCode Currency'
      currency_conversion(
        amount => _BillingDocument.TotalNetAmount,
        source_currency => _BillingDocument.TransactionCurrency,
        target_currency => cast('INR' as abap.cuky),
        exchange_rate_date => _BillingDocument.BillingDocumentDate,
        exchange_rate_type => 'M',
        error_handling => 'FAIL_ON_ERROR'
      ) as TotalNetAmountINRPD,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Total Tax Amount in CoCode Currency'
      cast( _BillingDocument.TotalTaxAmount as abap.dec(23,2) ) *
            _BillingDocument.AccountingExchangeRate as TotalTaxAmountINR,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Total Tax Amount in CoCode Currency'
      currency_conversion(
        amount => _BillingDocument.TotalTaxAmount,
        source_currency => _BillingDocument.TransactionCurrency,
        target_currency => cast('INR' as abap.cuky),
        exchange_rate_date => _BillingDocument.BillingDocumentDate,
        exchange_rate_type => 'M',
        error_handling => 'FAIL_ON_ERROR'
      ) as TotalTaxAmountINRPD,
      //--- Association ---//
      _PartnerFunction,
      _BillingDocumentItem,
      _BillingDocFirstLine
}
