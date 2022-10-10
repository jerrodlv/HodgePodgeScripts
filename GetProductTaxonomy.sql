
	--put the data we need into a temp table with distinct values, since we cant do a distinct when converting to XML in the CTE below. (SQL can't compare XML for distinct)
    SELECT distinct products.Code ProductCode,
		   left(catalognodes.Catalog, 3) MainCatalog,
		   CatalogNodes.Code
		into #taxonomy_tmp
     from products 
	 join [dbo].[CatalogNodeProductCodes] on Products.Code = CatalogNodeProductCodes.Value
	 join dbo.CatalogNodes on CatalogNodeProductCodes.CatalogNodeId = CatalogNodes.CatalogNodeId;

--Need to run this chunk 9 times, for each potential Taxonomy, changing the where clause
WITH Split_Names (ProductCode,Taxonomy, Code, xmlname)
AS
(
    SELECT  ProductCode,
		    CONCAT(MainCatalog , ROW_NUMBER() OVER(Partition by ProductCode, MainCatalog Order by ProductCode)) Taxonomy,
			Code,
		   CONVERT(XML,'<Taxs><tax>' + REPLACE(Code,'_', '</tax><tax>') + '</tax></Taxs>') AS xmlname
     from #taxonomy_tmp
)

 SELECT ProductCode,    
		Taxonomy,
		--Code,
		L1Cat = [dbo].[RemoveNonAlphaCharacters](xmlname.value('/Taxs[1]/tax[1]','varchar(100)')),    
		L2Cat = [dbo].[RemoveNonAlphaCharacters](CONCAT(xmlname.value('/Taxs[1]/tax[1]','varchar(100)'),xmlname.value('/Taxs[1]/tax[2]','varchar(100)'))),
		L3Cat = CASE WHEN len(xmlname.value('/Taxs[1]/tax[3]','varchar(100)'))  > 0 
				     Then [dbo].[RemoveNonAlphaCharacters]( CONCAT(xmlname.value('/Taxs[1]/tax[1]','varchar(100)'), 
																   xmlname.value('/Taxs[1]/tax[2]','varchar(100)'),
																   xmlname.value('/Taxs[1]/tax[3]','varchar(100)')))								   
					 else '' 
			    end
 INTO #CSITaxonomy
 FROM Split_Names
 order by ProductCode asc 













 	
	/*
	and ProductCode in (select ProductCode from Temp_Products)
	--maybe need to exclude WAW thread L1 Cat, since that wil be handled differently..
	--and L1Cat != 'Thread' 
	and CASE WHEN len(xmlname.value('/Taxs[1]/tax[3]','varchar(100)'))  > 0 
				     Then [dbo].[RemoveNonAlphaCharacters]( CONCAT(xmlname.value('/Taxs[1]/tax[1]','varchar(100)'), 
																   xmlname.value('/Taxs[1]/tax[2]','varchar(100)'),
																   xmlname.value('/Taxs[1]/tax[3]','varchar(100)')
																   ) 
													      )
					 else '' 
			    end = 'TailoringZippersJacket' --PressingSpottingFabricCareLintRemoval*/

 

/*
OLD -probably dont need, but save in case need to reference
select ProductCode, 
	   CONCAT([Catalog],ROW_NUMBER() OVER(Partition by ProductCode, [Catalog] Order by ProductCode)) Taxonomy,
	   L1Cat,
	   L2Cat,
	   case when L2Cat = L3Cat Then '' else L3Cat end L3Cat
	from (
		select  distinct products.Code ProductCode, 
					left(catalognodes.Catalog, 3) as 'Catalog',
					[dbo].[RemoveNonAlphaCharacters](dbo.UFN_SEPARATES_COLUMNS(CatalogNodes.Code, 1, '_')) as L1Cat,
					[dbo].[RemoveNonAlphaCharacters](CONCAT(dbo.UFN_SEPARATES_COLUMNS(CatalogNodes.Code, 1, '_'), dbo.UFN_SEPARATES_COLUMNS(CatalogNodes.Code, 2, '_'))) as L2Cat,
					L3Cat= CASE WHEN len(dbo.UFN_SEPARATES_COLUMNS(CatalogNodes.Code, 2, '_')) > 0 
						then  [dbo].[RemoveNonAlphaCharacters](CONCAT(dbo.UFN_SEPARATES_COLUMNS(CatalogNodes.Code, 1, '_'), dbo.UFN_SEPARATES_COLUMNS(CatalogNodes.Code, 2, '_'), dbo.UFN_SEPARATES_COLUMNS(CatalogNodes.Code, 2, '_'))) 
						Else ''
						end
		from products 
		join [dbo].[CatalogNodeProductCodes] on Products.Code = CatalogNodeProductCodes.Value
		join dbo.CatalogNodes on CatalogNodeProductCodes.CatalogNodeId = CatalogNodes.CatalogNodeId
		) as src

*/