
--compare selectors in inRiver that are not in the datamart
select *
from [inriver_selectors] inr
FULL join VariantSelectors_source dm 
  on inr.productcode = dm.Product 
 and (case when inr.VariantSelectorAttribute like '%CSI%' then replace(inr.VariantSelectorAttribute, 'CSI', '')
		  when inr.VariantSelectorAttribute like '%WAW%' then replace(inr.VariantSelectorAttribute, 'WAW', '')
	else inr.VariantSelectorAttribute end)  = dm.Attribute
 and inr.VariantSelectorDisplayName_en = dm.[Display Name] 
 and (case when inr.VariantSelectorID like '%CSI%' then replace(inr.VariantSelectorID, 'CSI', '')
		  when inr.VariantSelectorID like '%WAW%' then replace(inr.VariantSelectorID, 'WAW', '')
	else inr.VariantSelectorID end) = dm.SelectorID
 and inr.VariantSelectorType = dm.SelectorType
 where (
		dm.Product is null 
		or 
		inr.ProductCode is null
		)
   and isnull(inr.VariantSelectorAttribute, '') != 'ItemCustomPrinting'
   and isnull(dm.Attribute, '') != 'ItemCustomPrinting'





 --compare product:Variant links 
 select inr.ProductCode inr_productCode, inr.ItemVariantCode inr_variant, dm.ProductCode dm_ProductCode, dm.VariantCode dm_variant
 from cleaners.[dbo].[inriver_Product_variant] inr
 full outer join ProdVariants_Source dm
			 on inr.ProductCode = dm.ProductCode
			and inr.ItemVariantCode = dm.VariantCode
	where (inr.ProductCode is null or dm.ProductCode is null)  --missing in one or the other
	  and isnull(right(dm.VariantCode,3),'') != 'SP1'  --get rid of Custom Variants, since those are not actual variants in inriver
	  order by inr_productCode , dm_ProductCode 
/*
select  *
from Cleaners_cat3.dbo.Products       
left join Cleaners_cat3.dbo.VariantProducts on products.ProductId = VariantProducts.Product_ProductId
left join Cleaners_cat3.dbo.Variants on VariantProducts.Variant_VariantId = variants.VariantId
where products.code = 'SOHLF'

*/





 --compare Node:facet links


 select distinct inr.*, dm.*, CatalogNodes.VisibleInMenu --inr.ChannelNodeId, inr.ItemFacetDisplayName_en, inr.ItemFacetFacetAttribute 
 from cleaners..inriver_node_facet_links inr
 full join (select DisplayName, FacetAttribute, SelectorType, DependentAttribute,FacetGUID, ChannelNodeId
			 from [dbo].[dm_Node_facet_links] 
			 where facetfilterid != 0 ) dm
	 on inr.ChannelNodeId = dm.ChannelNodeId
	and inr.ItemFacetFacetGUID = dm.FacetGUID
left join Cleaners_cat3..CatalogNodes on CatalogNodes.code = RIGHT(dm.ChannelNodeId, LEN(dm.ChannelNodeId) - 4)
--join Cleaners_cat3..CatalogNodeProductCodes on CatalogNodes.CatalogNodeId = CatalogNodeProductCodes.CatalogNodeId

where inr.ChannelNodeId is null or dm.ChannelNodeId is null



--select * from cleaners..inriver_node_facet_links where ChannelNodeId = 'WAW_Thread-By-Use'
--select * from cleaners..[dm_Node_facet_links] where ChannelNodeId = 'WAW_Thread-By-Use'