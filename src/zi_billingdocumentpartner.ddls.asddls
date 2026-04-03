@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document Partner Funcation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BillingDocumentPartner
  as select from I_BillingDocumentPartnerBasic as _Part
    inner join I_Customer as _Cust on _Cust.Customer = _Part.Customer
    inner join I_Address_2 as _Address on _Address.AddressID = _Part.AddressID
    left outer join I_RegionText as _Regi on _Regi.Country = _Address.Country
                                                              and _Regi.Region = _Address.Region
                                                              and _Regi.Language = $session.system_language
    left outer join I_CountryText as _Cont on _Cont.Country = _Address.Country
                                                              and _Cont.Language = $session.system_language
{
  key _Part.BillingDocument as BillingDocument,
  key cast( _Part.PartnerFunction as abap.char(2) ) as PartnerFunction,
      _Part._PartnerFunction._Text[ Language = $session.system_language ].PartnerFunctionName as PartnerFunctionName,
      _Part.Customer as Customer,
      _Part.AddressID as AddressID,
      _Cust.CustomerName as CustomerName,
      _Cust.TaxNumber3 as CustomerGSTIN,
      _Address.Street as Street,
      _Address.HouseNumber as HouseNumber,
      _Address.StreetName as StreetName,
      _Address.StreetPrefixName1 as Street1,
      _Address.StreetPrefixName2 as Street2,
      _Address.StreetSuffixName1 as Street3,
      _Address.StreetSuffixName2 as Street4,
      _Address.CityName as CityName,
      _Address.Region as Region,
      _Regi.RegionName as RegionName,
      _Address.Country as Country,
      _Cont.CountryName as CountryName,
      _Address.PostalCode as PostalCode,
      _Cust._AddressRepresentation._PhoneNumber._AddressCommunicationRemark.CommunicationRemarkText as ContactPerson,
      _Cust._AddressRepresentation._CurrentDfltMobilePhoneNumber.InternationalMobileNumber as MobileNumber
}
union select from I_BillingDocItemPartnerBasic as _Part2
  inner join I_Customer as _Cust2 on _Cust2.Customer = _Part2.Customer
  inner join I_Address_2 as _Address2 on _Address2.AddressID = _Part2.AddressID
  left outer join I_RegionText as _Regi2 on _Regi2.Country = _Address2.Country
                                                            and _Regi2.Region = _Address2.Region
                                                            and _Regi2.Language = $session.system_language
  left outer join I_CountryText as _Cont2 on _Cont2.Country = _Address2.Country
                                                            and _Cont2.Language = $session.system_language
{
  key _Part2.BillingDocument as BillingDocument,
  key _Part2.PartnerFunction as PartnerFunction,
      _Part2._PartnerFunction._Text[ Language = $session.system_language ].PartnerFunctionName as PartnerFunctionName,
      _Part2.Customer as Customer,
      _Part2.AddressID as AddressID,
      _Cust2.CustomerName as CustomerName,
      _Cust2.TaxNumber3 as CustomerGSTIN,
      _Address2.Street as Street,
      _Address2.HouseNumber as HouseNumber,
      _Address2.StreetName as StreetName,
      _Address2.StreetPrefixName1 as Street1,
      _Address2.StreetPrefixName2 as Street2,
      _Address2.StreetSuffixName1 as Street3,
      _Address2.StreetSuffixName2 as Street4,
      _Address2.CityName as CityName,
      _Address2.Region as Region,
      _Regi2.RegionName as RegionName,
      _Address2.Country as Country,
      _Cont2.CountryName as CountryName,
      _Address2.PostalCode as PostalCode,
      _Cust2._AddressRepresentation._PhoneNumber._AddressCommunicationRemark.CommunicationRemarkText as ContactPerson,
      _Cust2._AddressRepresentation._CurrentDfltMobilePhoneNumber.InternationalPhoneNumber as MobileNumber
}
union select from I_BillingDocumentPartnerBasic as _Part3
  inner join I_Supplier as _Supplier on _Supplier.Supplier = _Part3.Supplier
  inner join I_Address_2 as _Address3 on _Address3.AddressID = _Part3.AddressID
  left outer join I_RegionText as _Regi3 on _Regi3.Country = _Address3.Country
                                                             and _Regi3.Region = _Address3.Region
                                                             and _Regi3.Language = $session.system_language
  left outer join I_CountryText as _Cont3 on _Cont3.Country = _Address3.Country
                                                             and _Cont3.Language = $session.system_language
{
  key _Part3.BillingDocument as BillingDocument,
  key _Part3.PartnerFunction as PartnerFunction,
      _Part3._PartnerFunction._Text[ Language = $session.system_language ].PartnerFunctionName as PartnerFunctionName,
      _Part3.Supplier as Customer,
      _Supplier.AddressID as AddressID,
      _Supplier.SupplierName as CustomerName,
      _Supplier.TaxNumber3 as CustomerGSTIN,
      _Address3.Street as Street,
      _Address3.HouseNumber as HouseNumber,
      _Address3.StreetName as StreetName,
      _Address3.StreetPrefixName1 as Street1,
      _Address3.StreetPrefixName2 as Street2,
      _Address3.StreetSuffixName1 as Street3,
      _Address3.StreetSuffixName2 as Street4,
      _Address3.CityName as CityName,
      _Address3.Region as Region,
      _Regi3.RegionName as RegionName,
      _Address3.Country as Country,
      _Cont3.CountryName as CountryName,
      _Address3.PostalCode as PostalCode,
      _Supplier._AddressRepresentation._PhoneNumber._AddressCommunicationRemark.CommunicationRemarkText as ContactPerson,
      _Supplier._AddressRepresentation._CurrentDfltMobilePhoneNumber.InternationalPhoneNumber as MobileNumber
}
where
  _Part3.Supplier is not initial
union select from I_BillingDocumentPartnerBasic as _Part4
  left outer join I_BusinessPartner as _BusinessPartner on _BusinessPartner.BusinessPartner = _Part4.ReferenceBusinessPartner
{
  key _Part4.BillingDocument as BillingDocument,
  key _Part4.PartnerFunction as PartnerFunction,
      _Part4._PartnerFunction._Text[ Language = $session.system_language ].PartnerFunctionName as PartnerFunctionName,
      _Part4.ReferenceBusinessPartner as Customer,
      _BusinessPartner._CurrentDefaultAddress.AddressID as AddressID,
      _BusinessPartner.BusinessPartnerFullName as CustomerName,
      cast( '' as abap.char(15) ) as CustomerGSTIN,
      _Part4._DfltAddrRprstn.Street as Street,
      _Part4._DfltAddrRprstn.HouseNumber as HouseNumber,
      _Part4._DfltAddrRprstn.StreetName as StreetName,
      _Part4._DfltAddrRprstn.StreetPrefixName1 as Street1,
      _Part4._DfltAddrRprstn.StreetPrefixName2 as Street2,
      _Part4._DfltAddrRprstn.StreetSuffixName1 as Street3,
      _Part4._DfltAddrRprstn.StreetSuffixName2 as Street4,
      _Part4._DfltAddrRprstn.CityName as CityName,
      _Part4._DfltAddrRprstn.Region as Region,
      _Part4._DfltAddrRprstn._Region._RegionText[ Language = $session.system_language ].RegionName as RegionName,
      _Part4._DfltAddrRprstn.Country as Country,
      _Part4._DfltAddrRprstn._Country._Text[ Language = $session.system_language ].CountryName as CountryName,
      _Part4._DfltAddrRprstn.PostalCode as PostalCode,
      _Part4._DfltAddrRprstn._PhoneNumber._AddressCommunicationRemark.CommunicationRemarkText as ContactPerson,
      _Part4._DfltAddrRprstn._CurrentDfltMobilePhoneNumber.InternationalMobileNumber as MobileNumber
}
where
  _Part4.Personnel is not initial
