@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD : First Line of Billing Document'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BillingDocFirstLine
  as select from ZI_BillingDocumentItem as _BillingDocument
  association [1..1] to ZI_BillingDocumentItem as _BillingDocumentItem on $projection.BillingDocument = _BillingDocumentItem.BillingDocument
                                                                       and $projection.BillingDocumentItem = _BillingDocumentItem.BillingDocumentItem
{
  key _BillingDocument.BillingDocument as BillingDocument,
      min( _BillingDocument.BillingDocumentItem ) as BillingDocumentItem,
      //--- Association ---//
      _BillingDocumentItem
}
group by
  _BillingDocument.BillingDocument
