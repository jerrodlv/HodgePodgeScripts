	--put the data we need into a temp table with distinct values, since we cant do a distinct when converting to XML in the CTE below. (SQL can't compare XML for distinct)
    drop table if exists #taxonomy_tmp
	SELECT distinct products.Code ProductCode,
		   FieldName = Replace(Replace(catalognodes.ParentNodeCode,'Thread_', '' ), '-', ''),
		   catalognodes.DisplayName
	into #taxonomy_tmp
     from products 
	 join [dbo].[CatalogNodeProductCodes] on Products.Code = CatalogNodeProductCodes.Value
	 join dbo.CatalogNodes on CatalogNodeProductCodes.CatalogNodeId = CatalogNodes.CatalogNodeId
	 where left(catalognodes.Catalog, 3)  = 'WAW'
		   and (Left(CatalogNodes.code, 6) = 'Thread') 
	 order by products.Code,Replace(Replace(catalognodes.ParentNodeCode,'Thread_', '' ), '-', ''), catalognodes.DisplayName



	 select  ProductCode
	        ,ThreadByBrand    = isnull(ThreadByBrand	   ,'')
			,ThreadByMaterial = isnull(ThreadByMaterial   ,'')
			,ThreadByUse	  = isnull(ThreadByUse		   ,'')
			,ThreadByWeight	  = isnull(ThreadByWeight	   ,'')
			,ThreadItems	  = isnull(ThreadItems		   ,'')
	   from (
			 select  ProductCode
			        ,FieldName
			        ,value = STRING_AGG(DisplayName, '; ')
			   from #taxonomy_tmp group by ProductCode, FieldName 
			) as x PIVOT (max(value) for FieldName in ([ThreadByBrand], ThreadByMaterial, ThreadByUse, ThreadByWeight, ThreadItems)) as pivottable