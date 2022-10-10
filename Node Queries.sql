/*Get all catalog nodes and the parent channel*/
SELECT distinct 
	   'Channel' =  CASE WHEN isnull(ParentNodeCode, '') = ''  THEN left([Catalog],3) Else '' end
	   ,ParentNodeCode =CASE WHEN isnull(ParentNodeCode, '') != '' THEN Concat(left([Catalog],3), '_', ParentNodeCode) ELSE '' end
	  ,ChannelNodeId = Concat(left([Catalog],3), '_', [Code]) 
      ,NodeDisplayName = [DisplayName]
      ,NodeNameInURL = [RouteSegment] 
	  ,NodeDisplayInNavigation = CASE WHEN VisibleInMenu = 0 then 'FALSE' else 'TRUE' end
      ,NodeFeatureInMenu = case when [FeatureInMenu] = 1 then 'True' else 'False' end
      ,NodeFeatureMenuName = isnull([MenuName], '')
	  ,NodeFacetName = ''
      ,NodeFeatureMenuOrder = [MenuOrder]
      ,NodeSortOrder = [InternalSortOrder]
      ,NodeFeatureMenuHighlight = case when [FeatureMenuHighlight] = 1 then 'True' else 'False' end
      ,NodeDisplayInBothMenus =  case when [DisplayInBothMenus] = 1 then 'True' else 'False' end
	  ,NodeDisplayFeatureOnMobile = 'False'
	  ,NodeCategoryAttributes = ''
      ,NodeDisplayMode = [DisplayMode]
	  ,NodeSEOTitle = ''
	  ,NodeSEODescription = isnull([SeoDescription], '')
      ,NodeSEOKeywords = isnull([SeoKeywords], '')
      ,NodeDescription = [Description]
      ,NodeSectionDisplayMode = isnull([SectionDisplayMode],'')
  FROM [Cleaners_Cat3].[dbo].[CatalogNodes]
  --where isnull(ParentNodeCode, '') = ''
 order by channel desc, NodeSortOrder asc


 /*Get all catalog nodes and the parent channel*/
SELECT distinct 
		
	   
	  ChannelNodeId = Concat(left([Catalog],3), '_', [Code]) 
      ,entityType = 'Product'
	  
	  ,ProductCSIMainCategory = CASE WHEN LEN(Code) - Len(REPLACE(code, '_', '')) > 0 
						       THEN [dbo].[RemoveNonAlphaCharacters](SUBSTRING([Code], 0, charindex('_', Code))) 
					       Else [dbo].[RemoveNonAlphaCharacters](Code) END


	   ,ProductCSISubCategory1 = CASE WHEN LEN(Code) - Len(REPLACE(code, '_', '')) > 1 
						       THEN	[dbo].[RemoveNonAlphaCharacters](CONCAT(SUBSTRING([Code], 0, charindex('_', Code)),SUBSTRING([Code], charindex('_', Code, 1) + 1, charindex('_', Code,charindex('_', Code, 1)+ 1) - charindex('_', Code, 1) -1)))
						   WHEN LEN(Code) - Len(REPLACE(code, '_', '')) = 1 
						       THEN [dbo].[RemoveNonAlphaCharacters](Code) 
						   ELSE '' end


	   ,ProductCSISubCategory2 = CASE WHEN LEN(Code) - Len(REPLACE(code, '_', '')) > 1 
						       THEN [dbo].[RemoveNonAlphaCharacters]([Code]) 
						   ELSE '' end
	   
  FROM [dbo].[CatalogNodes]
  where left([Catalog],3) = 'CSI'

SELECT distinct 
		
	   
	  ChannelNodeId = Concat(left([Catalog],3), '_', [Code]) 
      ,entityType = 'Product'
	  
	  ,ProductWAWMainCategory = CASE WHEN LEN(Code) - Len(REPLACE(code, '_', '')) > 0 
						       THEN [dbo].[RemoveNonAlphaCharacters](SUBSTRING([Code], 0, charindex('_', Code))) 
					       Else [dbo].[RemoveNonAlphaCharacters](Code) END


	   ,ProductWAWSubCategory1 = CASE WHEN LEN(Code) - Len(REPLACE(code, '_', '')) > 1 
						       THEN	[dbo].[RemoveNonAlphaCharacters](CONCAT(SUBSTRING([Code], 0, charindex('_', Code)),SUBSTRING([Code], charindex('_', Code, 1) + 1, charindex('_', Code,charindex('_', Code, 1)+ 1) - charindex('_', Code, 1) -1)))
						   WHEN LEN(Code) - Len(REPLACE(code, '_', '')) = 1 
						       THEN [dbo].[RemoveNonAlphaCharacters](Code) 
						   ELSE '' end


	   ,ProductWAWSubCategory2 = CASE WHEN LEN(Code) - Len(REPLACE(code, '_', '')) > 1 
						       THEN [dbo].[RemoveNonAlphaCharacters]([Code]) 
						   ELSE '' end
	   
  FROM [dbo].[CatalogNodes]
  where left([Catalog],3) = 'WAW'

