@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD : Billing Document Pricing Elements'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BillingDocItemPrcgElmnt
  as select from I_BillingDocItemPrcgElmntBasic as _BillingDocItemPrcgElmnt
{
  key _BillingDocItemPrcgElmnt.BillingDocument as BillingDocument,
  key _BillingDocItemPrcgElmnt.BillingDocumentItem as BillingDocumentItem,
  key _BillingDocItemPrcgElmnt.PricingProcedureStep as PricingProcedureStep,
  key _BillingDocItemPrcgElmnt.PricingProcedureCounter as PricingProcedureCounter,
      _BillingDocItemPrcgElmnt.ConditionClass as ConditionClass,
      // _BillingDocItemPrcgElmnt._ConditionClass._Text.ConditionClassName as ConditionClassName,
      _BillingDocItemPrcgElmnt.ConditionCategory as ConditionCategory,
      // _BillingDocItemPrcgElmnt._ConditionCategory._Text.ConditionCategoryName as ConditionCategoryName,
      _BillingDocItemPrcgElmnt.ConditionCalculationType as ConditionCalculationType,
      // _BillingDocItemPrcgElmnt._ConditionCalculationType._Text.ConditionCalculationTypeName as ConditionCalculationTypeName,
      _BillingDocItemPrcgElmnt.ConditionIsForStatistics as ConditionIsForStatistics,
      _BillingDocItemPrcgElmnt.ConditionInactiveReason as ConditionInactiveReason,
      _BillingDocItemPrcgElmnt.ConditionIsManuallyChanged as ConditionIsManuallyChanged,
      _BillingDocItemPrcgElmnt.ConditionType as ConditionType,
      _BillingDocItemPrcgElmnt._PricingConditionType._Text[ Language = $session.system_language ].ConditionTypeName as ConditionTypeName,
      _BillingDocItemPrcgElmnt.ConditionQuantity as ConditionQuantity,
      _BillingDocItemPrcgElmnt.ConditionQuantityUnit as ConditionQuantityUnit,
      _BillingDocItemPrcgElmnt.ConditionRateValue as ConditionRateValue,
      _BillingDocItemPrcgElmnt.ConditionCurrency as ConditionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _BillingDocItemPrcgElmnt.ConditionAmount as ConditionAmount,
      _BillingDocItemPrcgElmnt.TransactionCurrency as TransactionCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      currency_conversion(
          amount => _BillingDocItemPrcgElmnt.ConditionAmount,
          source_currency => _BillingDocItemPrcgElmnt.TransactionCurrency,
          target_currency => cast('INR' as abap.cuky),
          exchange_rate_date => _BillingDocItemPrcgElmnt.PriceConditionDeterminationDte,
          exchange_rate_type => 'M',
          error_handling => 'FAIL_ON_ERROR'
      ) as ConditionAmountINR,
      @EndUserText.label: 'Company Code Currency'
      cast('INR' as abap.cuky) as CompanyCodeCurrency
}
