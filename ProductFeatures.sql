/*GET TAXONOMY FLATTNED AND INTO TEMP TABLE*/
-------BEGIN TAXONOMY 
DROP TABLE IF EXISTS #taxonomy_tmp;
DROP TABLE IF EXISTS taxonomy_tmp;
DROP TABLE IF EXISTS #Features;
DROP TABLE IF EXISTS #Taxonomy;
DROP TABLE IF EXISTS #WAWProductInfo;
DROP TABLE IF EXISTS #CSIProductInfo;
DROP TABLE IF EXISTS #ProductSiteCodes;


	--put the data we need into a temp table with distinct values, since we cant do a distinct when converting to XML in the CTE below. (SQL can't compare XML for distinct)
    --insert into taxonomy_tmp
	SELECT distinct products.Code ProductCode,
		   left(catalognodes.Catalog, 3) MainCatalog,
		   CatalogNodes.Code,
		   catalognodes.InternalSortOrder,
		   --catalognodes.ParentNodeCode,
		   catalognodes.DisplayName
	into #taxonomy_tmp
     from products 
	 join [dbo].[CatalogNodeProductCodes] on Products.Code = CatalogNodeProductCodes.Value
	 join dbo.CatalogNodes on CatalogNodeProductCodes.CatalogNodeId = CatalogNodes.CatalogNodeId
	 --where  products.Code = 'ABR'
	 order by products.Code, /*catalognodes.ParentNodeCode,*/ catalognodes.InternalSortOrder , catalognodes.DisplayName;

--
WITH Split_Names (ProductCode,Taxonomy, Code, xmlname)
AS
(
    SELECT  ProductCode,
		    CONCAT(MainCatalog , ROW_NUMBER() OVER(Partition by ProductCode, MainCatalog Order by ProductCode, InternalSortOrder asc)) Taxonomy,
			Code,
		   CONVERT(XML,'<Taxs><tax>' + REPLACE(Code,'_', '</tax><tax>') + '</tax></Taxs>') AS xmlname
     from #taxonomy_tmp
	 where (Left(code, 6) != 'Thread')
)

 SELECT ProductCode,    
		Taxonomy,
		--Code,
		L1Cat = [dbo].[RemoveNonAlphaCharacters](xmlname.value('/Taxs[1]/tax[1]','varchar(100)')),    
		L2Cat = CASE WHEN len(xmlname.value('/Taxs[1]/tax[2]','varchar(100)'))  > 0   
					 THEN [dbo].[RemoveNonAlphaCharacters](CONCAT(xmlname.value('/Taxs[1]/tax[1]','varchar(100)'),xmlname.value('/Taxs[1]/tax[2]','varchar(100)')))
					 else '' 
			    end,
		L3Cat = CASE WHEN len(xmlname.value('/Taxs[1]/tax[3]','varchar(100)'))  > 0 
				     Then [dbo].[RemoveNonAlphaCharacters]( CONCAT(xmlname.value('/Taxs[1]/tax[1]','varchar(100)'), 
																   xmlname.value('/Taxs[1]/tax[2]','varchar(100)'),
																   xmlname.value('/Taxs[1]/tax[3]','varchar(100)')))								   
					 else '' 
			    end
 INTO #Taxonomy
 FROM Split_Names
 order by ProductCode asc 

-------END TAXONOMY


/*-------------pivot features into columns, since they are in ros currently*/
select * into #Features from 
	(
	SELECT [ProductId]
		  ,[Value]
		  ,CONCAT('Product Feature ',  row_number() OVER (partition by [ProductId] order by [ProductFeatureId] asc)) as FeatureNumber

	  FROM [dbo].[ProductFeatures]
	  ) as source_table PIVOT(MAX([Value]) FOR FeatureNumber in (
																 [Product Feature 1]
																,[Product Feature 2]
																,[Product Feature 3]
																,[Product Feature 4]
																,[Product Feature 5]
																,[Product Feature 6]
																,[Product Feature 7]
																,[Product Feature 8]
																	)) As PivotTable


/*------------PUT WAW Catalog stuff into temp table*/
select distinct [Code] 
      ,[Description]
	  ,DescriptionHeader
	  ,[Name]
      ,[DisplayName]
      ,[RouteSegment]
      ,[SeoDescription]
	  ,SeoKeywords
	  ,AdditionalProductContent
	  ,#Features.[Product Feature 1]
	  ,#Features.[Product Feature 2]
	  ,#Features.[Product Feature 3]
	  ,#Features.[Product Feature 4]
	  ,#Features.[Product Feature 5]
	  ,#Features.[Product Feature 6]
	  ,#Features.[Product Feature 7]
	  ,#Features.[Product Feature 8]
into #WAWProductInfo
from [Products]
join #Features on products.ProductId = #Features.ProductId
where products.MasterCatalog = 'WAW'
  --and products.Code in (select productcode from Temp_Products)

/*--------------PUT CSI Catalog stuff into temp table*/
select distinct [Code] 
      ,[Description]
	  ,DescriptionHeader
	  ,[Name]
      ,[DisplayName]
      ,[RouteSegment]
      ,[SeoDescription]
	  ,SeoKeywords
	  ,AdditionalProductContent
	  ,#Features.[Product Feature 1]
	  ,#Features.[Product Feature 2]
	  ,#Features.[Product Feature 3]
	  ,#Features.[Product Feature 4]
	  ,#Features.[Product Feature 5]
	  ,#Features.[Product Feature 6]
	  ,#Features.[Product Feature 7]
	  ,#Features.[Product Feature 8]
into #CSIProductInfo
from [Products]
join #Features on products.ProductId = #Features.ProductId
where products.MasterCatalog = 'CSI'
  --and products.Code in (select productcode from Temp_Products)


-------------- aggregate the various site codes into a string so we can load them into the multi-value CVL field
SELECT sitecodes.productcode, 
       String_agg(sitecodes.catalogs, '; ') 
         within GROUP (ORDER BY sitecodes.catalogs ASC) AS SiteCodeString 
into #ProductSiteCodes
FROM   (SELECT DISTINCT products.code        ProductCode, 
                        catalognodes.catalog catalogs 
        FROM   products 
               join catalognodeproductcodes 
                 ON products.code = catalognodeproductcodes.value 
               join catalognodes 
                 ON catalognodeproductcodes.catalognodeid = 
                    catalognodes.catalognodeid) 
       AS sitecodes 
GROUP  BY sitecodes.productcode 




/*-------------join products to get common product info, and get catalog specific info from each temp table*/
  select distinct
	     ProductCode = [Products].[Code]
		--,ProductCSIDisplayName = #CSIProductInfo.[DisplayName]
		--,ProductWAWDisplayName = #WAWProductInfo.[DisplayName]
		,ProductCSIDescription = dbo.replaceSpecialChar(#CSIProductInfo.Description)
		,ProductWAWDescription = dbo.replaceSpecialChar(#WAWProductInfo.Description)
		,ProductCSIDescriptionHeader = dbo.replaceSpecialChar(#CSIProductInfo.DescriptionHeader)
		,ProductWAWDescriptionHeader = dbo.replaceSpecialChar(#WAWProductInfo.DescriptionHeader)
		,ProductDisplayInNavigation = 'False'
		,ProductFeatureInMenu = CASE WHEN products.FeatureInMenu = 0 THEN 'False' else 'True' end
		,ProductFeatureMenuName = isnull(products.MenuName,'')
		,ProductFeatureMenuOrder = products.MenuOrder
		,ProductFeatureMenuHighlight = CASE WHEN products.FeatureMenuHighlight = 0 THEN 'False' ELSE 'True' end
		,ProductDisplayInBothMenus = CASE WHEN products.DisplayInBothMenus = 0 THEN 'False' ELSE 'True' end
		,ProductDisplayFeatureOnMobile = 'False'
		,ProductCSIAdditionalProductContent = isnull(dbo.replaceSpecialChar(#CSIProductInfo.AdditionalProductContent), '')
		,ProductWAWAdditionalProductContent = isnull(dbo.replaceSpecialChar(#WAWProductInfo.AdditionalProductContent), '')
		,ProductSiteCode = isnull(#ProductSiteCodes.SiteCodeString, '')
		--,ProductWAWRouteSegment = isnull(#WAWProductInfo.RouteSegment, '')
		--,ProductCSIRouteSegment = isnull(#CSIProductInfo.RouteSegment, '')
		,ProductCSISEODescription = isnull(dbo.replaceSpecialChar(#CSIProductInfo.[SeoDescription]), '')
		,ProductWAWSEODescription = isnull(dbo.replaceSpecialChar(#WAWProductInfo.[SeoDescription]), '')
		,CSIProductFeature1 = isnull(#CSIProductInfo.[Product Feature 1], '')
		,CSIProductFeature2 = isnull(#CSIProductInfo.[Product Feature 2], '')
		,CSIProductFeature3 = isnull(#CSIProductInfo.[Product Feature 3], '')
		,CSIProductFeature4 = isnull(#CSIProductInfo.[Product Feature 4], '')
		,CSIProductFeature5 = isnull(#CSIProductInfo.[Product Feature 5], '')
		,CSIProductFeature6 = isnull(#CSIProductInfo.[Product Feature 6], '')
		,CSIProductFeature7 = isnull(#CSIProductInfo.[Product Feature 7], '')
		,CSIProductFeature8 = isnull(#CSIProductInfo.[Product Feature 8], '')
		,WAWProductFeature1 = isnull(#WAWProductInfo.[Product Feature 1], '')
		,WAWProductFeature2 = isnull(#WAWProductInfo.[Product Feature 2], '')
		,WAWProductFeature3 = isnull(#WAWProductInfo.[Product Feature 3], '')
		,WAWProductFeature4 = isnull(#WAWProductInfo.[Product Feature 4], '')
		,WAWProductFeature5 = isnull(#WAWProductInfo.[Product Feature 5], '')
		,WAWProductFeature6 = isnull(#WAWProductInfo.[Product Feature 6], '')
		,WAWProductFeature7 = isnull(#WAWProductInfo.[Product Feature 7], '')
		,WAWProductFeature8 = isnull(#WAWProductInfo.[Product Feature 8], '')
		,ProductCSISEOTitle = ''
		,ProductWAWSEOTitle = ''
		,ProductWAWSEOKeywords = isnull(dbo.replaceSpecialChar(#WAWProductInfo.SeoKeywords), '')
		,ProductCSISEOKeywords = isnull(dbo.replaceSpecialChar(#CSIProductInfo.SeoKeywords), '')
		/*get the taxonomy fields*/
		,ProductCSIMainCategory = isnull(left(CSITax1.L1Cat,64), '')
		,ProductCSISubCategory1 = isnull(left(CSITax1.L2Cat,64), '')
		,ProductCSISubCategory2 = isnull(left(CSITax1.L3Cat,64), '')
		,ProductCSIMainCategoryTax2 = isnull(left(CSITax2.L1Cat,64), '')
		,ProductCSISubCategory1Tax2 = isnull(left(CSITax2.L2Cat,64), '')
		,ProductCSISubCategory2Tax2 = isnull(left(CSITax2.L3Cat,64), '')
		,ProductCSIMainCategoryTax3 = isnull(left(CSITax3.L1Cat,64), '')
		,ProductCSISubCategory1Tax3 = isnull(left(CSITax3.L2Cat,64), '')
		,ProductCSISubCategory2Tax3 = isnull(left(CSITax3.L3Cat,64), '')
		,ProductCSIMainCategoryTax4 = isnull(left(CSITax3.L1Cat,64), '')
		,ProductCSISubCategory1Tax4 = isnull(left(CSITax3.L2Cat,64), '')
		,ProductCSISubCategory2Tax4 = isnull(left(CSITax3.L3Cat,64), '')
		,ProductWAWMainCategory = isnull(left(WAWTax1.L1Cat,64), '')
		,ProductWAWSubCategory1 = isnull(left(WAWTax1.L2Cat,64), '')
		,ProductWAWSubCategory2 = isnull(left(WAWTax1.L3Cat,64), '')
		,ProductWAWMainCategoryTax2 = isnull(left(WAWTax2.L1Cat,64), '')
		,ProductWAWSubCategory1Tax2 = isnull(left(WAWTax2.L2Cat,64), '')
		,ProductWAWSubCategory2Tax2 = isnull(left(WAWTax2.L3Cat,64), '')
		,ProductWAWMainCategoryTax3 = isnull(left(WAWTax3.L1Cat,64), '')
		,ProductWAWSubCategory1Tax3 = isnull(left(WAWTax3.L2Cat,64), '')
		,ProductWAWSubCategory2Tax3 = isnull(left(WAWTax3.L3Cat,64), '')
		,ProductWAWMainCategoryTax4 = isnull(left(WAWTax3.L1Cat,64), '')
		,ProductWAWSubCategory1Tax4 = isnull(left(WAWTax3.L2Cat,64), '')
		,ProductWAWSubCategory2Tax4 = isnull(left(WAWTax3.L3Cat,64), '')
		--,ProductStatus = 'New'
  from [Products]
  left join #ProductSiteCodes on products.code = #ProductSiteCodes.ProductCode
  join #WAWProductInfo on products.Code = #WAWProductInfo.Code
  join #CSIProductInfo on products.Code = #CSIProductInfo.Code
  left join #Taxonomy as CSITax1 on products.code = CSITax1.ProductCode and CSITax1.Taxonomy = 'CSI1'
  left join #Taxonomy as CSITax2 on products.code = CSITax2.ProductCode and CSITax2.Taxonomy = 'CSI2'
  left join #Taxonomy as CSITax3 on products.code = CSITax3.ProductCode and CSITax3.Taxonomy = 'CSI3'
  left join #Taxonomy as CSITax4 on products.code = CSITax3.ProductCode and CSITax3.Taxonomy = 'CSI4'
  left join #Taxonomy as WAWTax1 on products.code = WAWTax1.ProductCode and WAWTax1.Taxonomy = 'WAW1'
  left join #Taxonomy as WAWTax2 on products.code = WAWTax2.ProductCode and WAWTax2.Taxonomy = 'WAW2'
  left join #Taxonomy as WAWTax3 on products.code = WAWTax3.ProductCode and WAWTax3.Taxonomy = 'WAW3'
  left join #Taxonomy as WAWTax4 on products.code = WAWTax3.ProductCode and WAWTax3.Taxonomy = 'WAW4'


  --select productcode, MainCatalog, count(*)  numrows
  --into #morethan3
  --from #taxonomy_tmp 
  --where code not like '%thread'
  --group by productcode, MainCatalog
  --having count(*) > 3

  --select * from #taxonomy_tmp where ProductCode in (select productcode from #morethan3 where code not like 'thread%')
