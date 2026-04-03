@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD : Billing Document Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BillingDocumentItem
  as select from I_BillingDocumentItemBasic as _BillingDocumentItem
 
    inner join I_Plant as _Plant on _Plant.Plant = _BillingDocumentItem.Plant
 
    left outer join I_IN_BusinessPlaceTaxDetail as _BusinessPlace on _BusinessPlace.BusinessPlace = _Plant.BusinessPlace
 
    inner join I_ProductPlantBasic as _ProductPlant on _ProductPlant.Product = _BillingDocumentItem.Product
                                                                       and _ProductPlant.Plant = _BillingDocumentItem.Plant
 
    left outer join I_ProductText as _ProductText on _ProductText.Language = $session.system_language
                                                                       and _ProductText.Product = _BillingDocumentItem.Product
 
  association [1..1] to ZI_BillingDocument as _BillingDocument on $projection.BillingDocument = _BillingDocument.BillingDocument
 
  association [1..*] to ZI_BillingDocItemPrcgElmnt as _BillingDocItemPrcgElmnt on $projection.BillingDocument = _BillingDocItemPrcgElmnt.BillingDocument
                                                                               and $projection.BillingDocumentItem = _BillingDocItemPrcgElmnt.BillingDocumentItem
 
  association [0..1] to I_MaterialDocumentItem_2 as _SubConMaterialDoc on $projection.SubConMaterialDocument = _SubConMaterialDoc.MaterialDocument
                                                                               and $projection.SubConMaterialDocumentItem = _SubConMaterialDoc.MaterialDocumentItem
 
{
  key _BillingDocumentItem.BillingDocument as BillingDocument,
  key _BillingDocumentItem.BillingDocumentItem as BillingDocumentItem,
      _BillingDocumentItem._BillingDocumentBasic.BillingDocumentDate as BillingDocumentDate,
      _BillingDocumentItem._BillingDocumentBasic.FiscalYear as FiscalYear,
      _BillingDocumentItem.SalesOffice as SalesOffice,
      _BillingDocumentItem._SalesOffice._Text[ Language = $session.system_language ].SalesOfficeName as SalesOfficeName,
      _BillingDocumentItem._Plant.BusinessPlace as BusinessPlace,
      _BusinessPlace.IN_GSTIdentificationNumber as BusinessPlaceGSTIN,
      _BillingDocumentItem.Plant as Plant,
      _BillingDocumentItem._Plant.PlantName as PlantName,
      _BillingDocumentItem._Plant.AddressID as PlantAddressID,
      _BillingDocumentItem._Plant._StandardOrganizationAddress.CityName as PlantCityName,
      _BillingDocumentItem._Plant._StandardOrganizationAddress.Region as PlantRegion,
      _BillingDocumentItem.TransactionCurrency,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
      @EndUserText.label: 'Net Amount in CoCode Currency'
      cast( _BillingDocumentItem.NetAmount as abap.dec(23,2) ) *
            _BillingDocumentItem._BillingDocumentBasic.AccountingExchangeRate as NetAmountINR,
 
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @EndUserText.label: 'Net Amount in CoCode Currency (PD)'
      currency_conversion(
        amount => _BillingDocumentItem.NetAmount,
        source_currency => _BillingDocumentItem.TransactionCurrency,
        target_currency => cast('INR' as abap.cuky),
        exchange_rate_date => _BillingDocumentItem.PricingDate,
        exchange_rate_type => 'M',
        error_handling => 'FAIL_ON_ERROR'
      ) as NetAmountINRPD,
 
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @EndUserText.label: 'Tax Amount in CoCode Currency'
      cast( _BillingDocumentItem.TaxAmount as abap.dec(23,2) ) *
            _BillingDocumentItem._BillingDocumentBasic.AccountingExchangeRate as TaxAmountINR,
 
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @EndUserText.label: 'Tax Amount in CoCode Currency (PD)'
      currency_conversion(
        amount => _BillingDocumentItem.TaxAmount,
        source_currency => _BillingDocumentItem.TransactionCurrency,
        target_currency => cast('INR' as abap.cuky),
        exchange_rate_date => _BillingDocumentItem.PricingDate,
        exchange_rate_type => 'M',
        error_handling => 'FAIL_ON_ERROR'
      ) as TaxAmountINRPD,
 
      _BillingDocumentItem._BillingDocumentBasic.SoldToParty as SoldToParty,
      _BillingDocumentItem._BillingDocumentBasic._SoldToParty.CustomerName as SoldToPartyName,
      _BillingDocumentItem.SalesDocument as SalesOrder,
      _BillingDocumentItem.SalesDocumentItem as SalesOrderItem,
      _BillingDocumentItem._SalesDocument.SalesDocumentType as SalesOrderType,
      _BillingDocumentItem._SalesDocument._SalesDocumentType._Text[ Language = $session.system_language ].SalesDocumentTypeName as SalesOrderTypeName,
      _BillingDocumentItem._SalesDocument.SalesDocumentDate as SalesOrderDate,
      _BillingDocumentItem._SalesDocument.PurchaseOrderByCustomer as CustomerPurchaseOrderNumber,
      _BillingDocumentItem._SalesDocument.CustomerPurchaseOrderDate as CustomerPurchaseOrderDate,
      _BillingDocumentItem.ReferenceSDDocument as DeliveryDocument,
      _BillingDocumentItem.ReferenceSDDocumentItem as DeliveryDocumentItem,
      _BillingDocumentItem._ReferenceDeliveryDocumentItem._DeliveryDocument.DeliveryDate as DeliveryDate,
 
      case when _BillingDocumentItem._BillingDocumentBasic.BillingDocumentType = 'JSN'
      then _BillingDocumentItem.ReferenceSDDocument
      else '' end as SubConMaterialDocument,
 
      case when _BillingDocumentItem._BillingDocumentBasic.BillingDocumentType = 'JSN'
      then substring(_BillingDocumentItem.ReferenceSDDocumentItem,3,4)
      else '' end as SubConMaterialDocumentItem,
 
      _BillingDocumentItem.CreationDate as CreationDate,
      _BillingDocumentItem.CreationTime as CreationTime,
 
      //--- Association ---//
      _BillingDocument,
      _SubConMaterialDoc,
      _BillingDocItemPrcgElmnt
 
}
