
---------Item Facet Filters------------------------------------------------------------
/*
only need to run this commented section if we need to refresh this table.
Don't want to keep changing this since we dont want to generate newID each time, 
since that is what we are keying on when upserting using the upload to inriver
if we do this the GUIDS wont match. Might want to get the GUIDS from the existing data in an export and incorporate. 
*/
/*
drop table if exists temp_FacetSelectors2;

select * 
into temp_FacetSelectors2
from temp_FacetSelectors;

drop table if exists temp_FacetSelectors;


------
create table temp_FacetSelectors
				(
					DisplayName nvarchar(100),
					FacetAttribute nvarchar(100),
					SelectorType  nvarchar(100),
					DependentAttribute nvarchar(100),
					FacetGUID nvarchar(100)
				);

update temp_FacetSelectors
   set temp_FacetSelectors.FacetGUID = NEWID()
  from temp_FacetSelectors
join temp_FacetSelectors2
  on temp_FacetSelectors.DisplayName = temp_FacetSelectors2.DisplayName
 and temp_FacetSelectors.FacetAttribute = CONCAT('Item',temp_FacetSelectors2.FacetAttribute)
 and temp_FacetSelectors.SelectorType = temp_FacetSelectors2.SelectorType
 and temp_FacetSelectors.DependentAttribute = temp_FacetSelectors2.DependentAttribute;




insert into temp_FacetSelectors (DisplayName, FacetAttribute, SelectorType, DependentAttribute)
SELECT distinct 
       FacetFilters.DisplayName,
	   FacetAttribute = CASE WHEN FacetFilters.Attribute in ('Category', 'Design', 'Style', 'Product', 'type', 'brand') 
							 THEN (select CONCAT('ItemCSI', Attribute)) 
							 else CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute))
							 end,
	   FacetFilters.SelectorType,
	   FacetFilters.DependentAttribute
FROM FacetFilters
  where  ProductId is null
union 
SELECT distinct 
       FacetFilters.DisplayName,
	   FacetAttribute = CASE WHEN FacetFilters.Attribute in ('Category', 'Design', 'Style', 'Product', 'type', 'brand') 
							 THEN (select CONCAT('ItemWAW', Attribute)) 
							 else CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute))
							 end,
	   FacetFilters.SelectorType,
	   FacetFilters.DependentAttribute
FROM FacetFilters
  where  ProductId is null
Union
 select DisplayName = 'Extendable Handle' ,FacetAttribute = 'ItemExtendableHandle'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
 Union
 select DisplayName = 'Front Print' ,FacetAttribute = 'ItemFrontPrint'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Header Style' ,FacetAttribute = 'ItemHeaderStyle'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Hoses' ,FacetAttribute = 'ItemHoses'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Loop Spacing' ,FacetAttribute = 'ItemLoopSpacing'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Loop Style' ,FacetAttribute = 'ItemLoopStyle'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Material Type' ,FacetAttribute = 'ItemMaterialType'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Number' ,FacetAttribute = 'ItemNumber'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Pocket' ,FacetAttribute = 'ItemPocket'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Printer' ,FacetAttribute = 'ItemPrinter'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Product Style' ,FacetAttribute = 'ItemProductStyle'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''
Union
 select DisplayName = 'Spacing' ,FacetAttribute = 'ItemSpacing'	,SelectorType = 'CheckboxListMultiSelect' ,DependentAttribute = ''



update temp_FacetSelectors
   set temp_FacetSelectors.FacetGUID = NEWID()
  where FacetGUID is null;
  ;
  */
drop table cleaners.dbo.dm_Node_facet_links
  select * into cleaners.dbo.dm_Node_facet_links from(
select distinct 
	     FacetFilters.facetfilterid
		,DisplayName = temp_FacetSelectors.DisplayName
		,FacetAttribute =  temp_FacetSelectors.FacetAttribute 
		,SelectorType = temp_FacetSelectors.SelectorType
		,DependentAttribute = temp_FacetSelectors.DependentAttribute
		,temp_FacetSelectors.FacetGUID
	    ,ChannelNodeId = CASE WHEN CatalogNodes.Catalog is null then '' ELSE Concat(left(CatalogNodes.Catalog,3), '_', CatalogNodes.Code) end
  from temp_FacetSelectors
  left join FacetFilters on  FacetFilters.DisplayName = temp_FacetSelectors.DisplayName
				
					and ( 	CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute)) = temp_FacetSelectors.FacetAttribute
					     or CONCAT('ItemWAW',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute)) = temp_FacetSelectors.FacetAttribute) 

					and FacetFilters.SelectorType = temp_FacetSelectors.SelectorType
					and isnull(facetfilters.DependentAttribute, '') = isnull(temp_FacetSelectors.DependentAttribute, '')
  left join CatalogNodes on FacetFilters.CatalogNodeId = catalognodes.CatalogNodeId
  	where left(CatalogNodes.Catalog,3) = 'WAW'
	 and  FacetFilterId not in (select max(FacetFilterId) 
									from FacetFilters
									join CatalogNodes on FacetFilters.CatalogNodeId = catalognodes.CatalogNodeId
									group by FacetFilters.DisplayName
											,CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute))
											,FacetFilters.SelectorType
											,facetfilters.DependentAttribute
											,Concat(left(CatalogNodes.Catalog,3), '_', CatalogNodes.Code))
UNION 

select distinct 
	     FacetFilters.facetfilterid
		,DisplayName = temp_FacetSelectors.DisplayName
		,FacetAttribute =  temp_FacetSelectors.FacetAttribute 
		,SelectorType = temp_FacetSelectors.SelectorType
		,DependentAttribute = temp_FacetSelectors.DependentAttribute
		,temp_FacetSelectors.FacetGUID
	    ,ChannelNodeId = CASE WHEN CatalogNodes.Catalog is null then '' ELSE Concat(left(CatalogNodes.Catalog,3), '_', CatalogNodes.Code) end
  from temp_FacetSelectors
  left join FacetFilters on  FacetFilters.DisplayName = temp_FacetSelectors.DisplayName
					and (   CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute)) = temp_FacetSelectors.FacetAttribute
						 or CONCAT('ItemCSI',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute)) = temp_FacetSelectors.FacetAttribute)
					and FacetFilters.SelectorType = temp_FacetSelectors.SelectorType
					and isnull(facetfilters.DependentAttribute, '') = isnull(temp_FacetSelectors.DependentAttribute, '')
  left join CatalogNodes on FacetFilters.CatalogNodeId = catalognodes.CatalogNodeId
  	where left(CatalogNodes.Catalog,3) = 'CSI'
	 and  FacetFilterId not in (select max(FacetFilterId) 
									from FacetFilters
									join CatalogNodes on FacetFilters.CatalogNodeId = catalognodes.CatalogNodeId
									group by FacetFilters.DisplayName
											,CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute))
											,FacetFilters.SelectorType
											,facetfilters.DependentAttribute
											,Concat(left(CatalogNodes.Catalog,3), '_', CatalogNodes.Code))
  
  union 
  
select distinct 
	     facetfilterid = ''
		,DisplayName = temp_FacetSelectors.DisplayName
		,FacetAttribute = temp_FacetSelectors.FacetAttribute
		,SelectorType = temp_FacetSelectors.SelectorType
		,DependentAttribute = temp_FacetSelectors.DependentAttribute
		,temp_FacetSelectors.FacetGUID
	    ,ChannelNodeId = ''
  from temp_FacetSelectors
    left join FacetFilters on  FacetFilters.DisplayName = temp_FacetSelectors.DisplayName
					and (   CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute)) = temp_FacetSelectors.FacetAttribute
						 or CONCAT('ItemCSI',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute)) = temp_FacetSelectors.FacetAttribute
						 or CONCAT('ItemWAW',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute)) = temp_FacetSelectors.FacetAttribute)
					and FacetFilters.SelectorType = temp_FacetSelectors.SelectorType
					and isnull(facetfilters.DependentAttribute, '') = isnull(temp_FacetSelectors.DependentAttribute, '')
  left join CatalogNodes on FacetFilters.CatalogNodeId = catalognodes.CatalogNodeId
  where isnull(left(CatalogNodes.Catalog,3),'') = ''

  union

    --temp - get just the producttype facets because the attribute in DM is actually type..
select distinct 
	     FacetFilters.facetfilterid
		,DisplayName = temp_FacetSelectors.DisplayName
		,FacetAttribute =  temp_FacetSelectors.FacetAttribute 
		--,FacetAttribute = case when temp_FacetSelectors.FacetAttribute = 'ItemType' 
		--					   then 'ItemWAWProductType'
		--				  else temp_FacetSelectors.FacetAttribute end
		,SelectorType = temp_FacetSelectors.SelectorType
		,DependentAttribute = temp_FacetSelectors.DependentAttribute
		,temp_FacetSelectors.FacetGUID
	    ,ChannelNodeId = CASE WHEN CatalogNodes.Catalog is null then '' ELSE Concat(left(CatalogNodes.Catalog,3), '_', CatalogNodes.Code) end
  from temp_FacetSelectors
  left join FacetFilters on  FacetFilters.DisplayName = temp_FacetSelectors.DisplayName
				    and FacetFilters.Attribute = 'Type'
					and FacetFilters.SelectorType = temp_FacetSelectors.SelectorType
					and isnull(facetfilters.DependentAttribute, '') = isnull(temp_FacetSelectors.DependentAttribute, '')
  left join CatalogNodes on FacetFilters.CatalogNodeId = catalognodes.CatalogNodeId
  	where left(CatalogNodes.Catalog,3) = 'WAW'
	  union

    --temp - get just the producttype facets because the attribute in DM is actually type..
select distinct 
	     FacetFilters.facetfilterid
		,DisplayName = temp_FacetSelectors.DisplayName
		,FacetAttribute =  temp_FacetSelectors.FacetAttribute 
		--,FacetAttribute = case when temp_FacetSelectors.FacetAttribute = 'ItemType' 
		--					   then 'ItemWAWProductType'
		--				  else temp_FacetSelectors.FacetAttribute end
		,SelectorType = temp_FacetSelectors.SelectorType
		,DependentAttribute = temp_FacetSelectors.DependentAttribute
		,temp_FacetSelectors.FacetGUID
	    ,ChannelNodeId = CASE WHEN CatalogNodes.Catalog is null then '' ELSE Concat(left(CatalogNodes.Catalog,3), '_', CatalogNodes.Code) end
  from temp_FacetSelectors
  left join FacetFilters on  FacetFilters.DisplayName = temp_FacetSelectors.DisplayName
				    and FacetFilters.Attribute = 'Type'
					and FacetFilters.SelectorType = temp_FacetSelectors.SelectorType
					and isnull(facetfilters.DependentAttribute, '') = isnull(temp_FacetSelectors.DependentAttribute, '')
  left join CatalogNodes on FacetFilters.CatalogNodeId = catalognodes.CatalogNodeId
  	where left(CatalogNodes.Catalog,3) = 'CSI') a

  order by  CASE WHEN CatalogNodes.Catalog is null then '' ELSE Concat(left(CatalogNodes.Catalog,3), '_', CatalogNodes.Code) end asc,   FacetFilters.facetfilterid asc




---------Variant Selectors------------------------------------------------------------

  select distinct FacetFilterId,
				   ProductCode = products.code,
				   VariantSelectorDisplayName = FacetFilters.DisplayName,
				   VariantSelectorAttribute = CASE WHEN [dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute) in ('Category', 'Design', 'Style', 'Product')  
									THEN CONCAT('ItemCSI',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute))
									ELSE CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute))
									END,
				   VariantSelectorType = FacetFilters.SelectorType,
				   VariantSelectorID = CASE WHEN [dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute) in ('Category', 'Design', 'Style', 'Product')  
									THEN CONCAT('ItemCSI',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute),FacetFilters.SelectorType)
									ELSE CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute),FacetFilters.SelectorType)
									END		   
    from Products 
    join FacetFilters on Products.ProductId = FacetFilters.ProductId
	where FacetFilterId not in (select max(FacetFilterId) 
									from FacetFilters join Products on FacetFilters.ProductId = Products.ProductId
								  group by [FacetFilters].[DisplayName]
									  ,[FacetFilters].[Attribute]
									  ,[FacetFilters].[AttributeLevel]
									  ,[FacetFilters].[SelectorType]
									  ,[FacetFilters].[DependentAttribute]
									  ,[FacetFilters].[SiteSpecificAttribute]
									  ,Products.Code)
UNION
  select distinct  
				FacetFilterId,
				  ProductCode = products.code,
				   VariantSelectorDisplayName = FacetFilters.DisplayName,
				   VariantSelectorAttribute = CASE WHEN [dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute) in ('Category', 'Design', 'Style', 'Product')  
									THEN CONCAT('ItemWAW',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute))
									ELSE CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute))
									END,
				   VariantSelectorType = FacetFilters.SelectorType,
				   VariantSelectorID = CASE WHEN [dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute) in ('Category', 'Design', 'Style', 'Product')  
									THEN CONCAT('ItemWAW',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute),FacetFilters.SelectorType)
									ELSE CONCAT('Item',[dbo].[RemoveNonAlphaCharacters](FacetFilters.Attribute),FacetFilters.SelectorType)
									END
    from Products 
    join FacetFilters on Products.ProductId = FacetFilters.ProductId
	  where FacetFilterId not in (select max(FacetFilterId) 
									from FacetFilters join Products on FacetFilters.ProductId = Products.ProductId
								  group by [FacetFilters].[DisplayName]
									  ,[FacetFilters].[Attribute]
									  ,[FacetFilters].[AttributeLevel]
									  ,[FacetFilters].[SelectorType]
									  ,[FacetFilters].[DependentAttribute]
									  ,[FacetFilters].[SiteSpecificAttribute]
									  ,Products.Code)


order by products.code asc, FacetFilterId asc


 

 
  

