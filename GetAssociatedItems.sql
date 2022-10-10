
  select distinct  VariantCode = [Code]
		,[Type]
		, [CatalogRelationships].ProductCode
FROM [Cleaners_Cat].[dbo].[CatalogRelations]
join [dbo].[CatalogRelationships] on [CatalogRelations].[CatalogRelationshipId] = [CatalogRelationships].[CatalogRelationshipId]
order by [Code]


