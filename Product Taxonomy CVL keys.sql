/*CSI L1 CVL List*/
select 
	   [Drop Down Name]  = 'ProductCSIMainCategory'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSIMainCategory'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = ''
	  from (
			SELECT distinct
				   [Key] = [dbo].[RemoveNonAlphaCharacters](Code)
				  ,ParentKey = ParentNodeCode
				  ,Deactivated = 'False'
				  ,Value = [DisplayName]
			  FROM [dbo].[CatalogNodes]
			  where catalog = 'CSIUS'
				and ParentNodeCode = ''
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductCSIMainCategoryTax2'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSIMainCategoryTax2'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = ''
	  from (
			SELECT distinct
				   [Key] = [dbo].[RemoveNonAlphaCharacters](Code)
				  ,ParentKey = ParentNodeCode
				  ,Deactivated = 'False'
				  ,Value = [DisplayName]
			  FROM [dbo].[CatalogNodes]
			  where catalog = 'CSIUS'
				and ParentNodeCode = ''
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductCSIMainCategoryTax3'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSIMainCategoryTax3'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = ''
	  from (
			SELECT distinct
				   [Key] = [dbo].[RemoveNonAlphaCharacters](Code)
				  ,ParentKey = ParentNodeCode
				  ,Deactivated = 'False'
				  ,Value = [DisplayName]
			  FROM .[dbo].[CatalogNodes]
			  where catalog = 'CSIUS'
				and ParentNodeCode = ''
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductCSIMainCategoryTax4'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSIMainCategoryTax4'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = ''
	  from (
			SELECT distinct
				   [Key] = [dbo].[RemoveNonAlphaCharacters](Code)
				  ,ParentKey = ParentNodeCode
				  ,Deactivated = 'False'
				  ,Value = [DisplayName]
			  FROM .[dbo].[CatalogNodes]
			  where catalog = 'CSIUS'
				and ParentNodeCode = ''
		) x
---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------


UNION All



---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------
	/*CSI L2 CVL List*/
select 
	   [Drop Down Name]  = 'ProductCSISubCategory1'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSISubCategory1'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductCSIMainCategory'
	  from (
			SELECT distinct
				  [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
				  ,ParentKey = [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
				  ,Deactivated = 'False'
				  ,Value = CONCAT(cn_parent.displayName, ' --> ',  cn.DisplayName)
			  FROM CatalogNodes cn
			  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
			  where cn.catalog = 'CSIUS'
				and cn.ParentNodeCode != ''
				and CHARINDEX('_', cn.ParentNodeCode) = 0
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductCSISubCategory1Tax2'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSISubCategory1Tax2'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductCSIMainCategoryTax2'
	  from (
			SELECT distinct
				  [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
				  ,ParentKey = [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
				  ,Deactivated = 'False'
				  ,Value = CONCAT(cn_parent.displayName, ' --> ',  cn.DisplayName)
			  FROM CatalogNodes cn
			  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
			  where cn.catalog = 'CSIUS'
				and cn.ParentNodeCode != ''
				and CHARINDEX('_', cn.ParentNodeCode) = 0
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductCSISubCategory1Tax3'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSISubCategory1Tax3'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductCSIMainCategoryTax3'
	  from (
			SELECT distinct
				  [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
				  ,ParentKey = [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
				  ,Deactivated = 'False'
				  ,Value = CONCAT(cn_parent.displayName, ' --> ',  cn.DisplayName)
			  FROM CatalogNodes cn
			  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
			  where cn.catalog = 'CSIUS'
				and cn.ParentNodeCode != ''
				and CHARINDEX('_', cn.ParentNodeCode) = 0
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductCSISubCategory1Tax4'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSISubCategory1Tax4'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductCSIMainCategoryTax4'
	  from (
			SELECT distinct
				  [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
				  ,ParentKey = [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
				  ,Deactivated = 'False'
				  ,Value = CONCAT(cn_parent.displayName, ' --> ',  cn.DisplayName)
			  FROM CatalogNodes cn
			  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
			  where cn.catalog = 'CSIUS'
				and cn.ParentNodeCode != ''
				and CHARINDEX('_', cn.ParentNodeCode) = 0
		) x
---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------
UNION ALL

---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------
/*CSI L3 CVL List*/
select 
	   [Drop Down Name]  = 'ProductCSISubCategory2'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSISubCategory2'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductCSISubCategory1'
	  from (
		SELECT distinct
		   [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
		  ,ParentKey =  [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
		  ,Deactivated = 'False'
		  ,Value = CONCAT(cn_parent2.DisplayName, ' --> ' ,cn_parent.displayName, ' --> ',  cn.DisplayName)
	  FROM CatalogNodes cn
	  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
	  join CatalogNodes cn_parent2 on cn_parent.ParentNodeCode = cn_parent2.Code
	  where cn.catalog = 'CSIUS'
		and cn.ParentNodeCode != ''
		and CHARINDEX('_', cn.ParentNodeCode) > 1
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductCSISubCategory2Tax2'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSISubCategory2Tax2'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductCSISubCategory1Tax2'
	  from (
		SELECT distinct
		   [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
		  ,ParentKey =  [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
		  ,Deactivated = 'False'
		  ,Value = CONCAT(cn_parent2.DisplayName, ' --> ' ,cn_parent.displayName, ' --> ',  cn.DisplayName)
	  FROM CatalogNodes cn
	  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
	  join CatalogNodes cn_parent2 on cn_parent.ParentNodeCode = cn_parent2.Code
	  where cn.catalog = 'CSIUS'
		and cn.ParentNodeCode != ''
		and CHARINDEX('_', cn.ParentNodeCode) > 1
		) x
UNION ALL
select
	   [Drop Down Name]  = 'ProductCSISubCategory2Tax3'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSISubCategory2Tax3'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductCSISubCategory2Tax3'
	  from (
		SELECT distinct
		   [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
		  ,ParentKey =  [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
		  ,Deactivated = 'False'
		  ,Value = CONCAT(cn_parent2.DisplayName, ' --> ' ,cn_parent.displayName, ' --> ',  cn.DisplayName)
	  FROM CatalogNodes cn
	  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
	  join CatalogNodes cn_parent2 on cn_parent.ParentNodeCode = cn_parent2.Code
	  where cn.catalog = 'CSIUS'
		and cn.ParentNodeCode != ''
		and CHARINDEX('_', cn.ParentNodeCode) > 1
		) x
UNION ALL
select
	   [Drop Down Name]  = 'ProductCSISubCategory2Tax4'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductCSISubCategory2Tax4'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductCSISubCategory2Tax4'
	  from (
		SELECT distinct
		   [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
		  ,ParentKey =  [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
		  ,Deactivated = 'False'
		  ,Value = CONCAT(cn_parent2.DisplayName, ' --> ' ,cn_parent.displayName, ' --> ',  cn.DisplayName)
	  FROM CatalogNodes cn
	  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
	  join CatalogNodes cn_parent2 on cn_parent.ParentNodeCode = cn_parent2.Code
	  where cn.catalog = 'CSIUS'
		and cn.ParentNodeCode != ''
		and CHARINDEX('_', cn.ParentNodeCode) > 1
		) x
---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------

UNION ALL

---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------
/*WAW L1 CVL List*/
select 
	   [Drop Down Name]  = 'ProductWAWMainCategory'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWMainCategory'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = ''
	  from (
			SELECT distinct
				   [Key] = [dbo].[RemoveNonAlphaCharacters](Code)
				  ,ParentKey = ParentNodeCode
				  ,Deactivated = 'False'
				  ,Value = [DisplayName]
			  FROM .[dbo].[CatalogNodes]
			  where catalog = 'WAWUS'
				and ParentNodeCode = ''
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductWAWMainCategoryTax2'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWMainCategoryTax2'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = ''
	  from (
			SELECT distinct
				   [Key] = [dbo].[RemoveNonAlphaCharacters](Code)
				  ,ParentKey = ParentNodeCode
				  ,Deactivated = 'False'
				  ,Value = [DisplayName]
			  FROM .[dbo].[CatalogNodes]
			  where catalog = 'WAWUS'
				and ParentNodeCode = ''
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductWAWMainCategoryTax3'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWMainCategoryTax3'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = ''
	  from (
			SELECT distinct
				   [Key] = [dbo].[RemoveNonAlphaCharacters](Code)
				  ,ParentKey = ParentNodeCode
				  ,Deactivated = 'False'
				  ,Value = [DisplayName]
			  FROM .[dbo].[CatalogNodes]
			  where catalog = 'WAWUS'
				and ParentNodeCode = ''
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductWAWMainCategoryTax4'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWMainCategoryTax4'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = ''
	  from (
			SELECT distinct
				   [Key] = [dbo].[RemoveNonAlphaCharacters](Code)
				  ,ParentKey = ParentNodeCode
				  ,Deactivated = 'False'
				  ,Value = [DisplayName]
			  FROM .[dbo].[CatalogNodes]
			  where catalog = 'WAWUS'
				and ParentNodeCode = ''
		) x
---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------


UNION All



---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------
	/*CSI L2 CVL List*/
select 
	   [Drop Down Name]  = 'ProductWAWSubCategory1'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWSubCategory1'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductWAWMainCategory'
	  from (
			SELECT distinct
				  [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
				  ,ParentKey = [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
				  ,Deactivated = 'False'
				  ,Value = CONCAT(cn_parent.displayName, ' --> ',  cn.DisplayName)
			  FROM CatalogNodes cn
			  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
			  where cn.catalog = 'WAWUS'
				and cn.ParentNodeCode != ''
				and CHARINDEX('_', cn.ParentNodeCode) = 0
		) x
UNION ALL
	/*CSI L2 CVL List*/
select 
	   [Drop Down Name]  = 'ProductWAWSubCategory1Tax2'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWSubCategory1Tax2'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductWAWMainCategoryTax2'
	  from (
			SELECT distinct
				  [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
				  ,ParentKey = [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
				  ,Deactivated = 'False'
				  ,Value = CONCAT(cn_parent.displayName, ' --> ',  cn.DisplayName)
			  FROM CatalogNodes cn
			  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
			  where cn.catalog = 'WAWUS'
				and cn.ParentNodeCode != ''
				and CHARINDEX('_', cn.ParentNodeCode) = 0
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductWAWSubCategory1Tax3'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWSubCategory1Tax3'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductWAWMainCategoryTax3'
	  from (
			SELECT distinct
				  [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
				  ,ParentKey = [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
				  ,Deactivated = 'False'
				  ,Value = CONCAT(cn_parent.displayName, ' --> ',  cn.DisplayName)
			  FROM CatalogNodes cn
			  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
			  where cn.catalog = 'WAWUS'
				and cn.ParentNodeCode != ''
				and CHARINDEX('_', cn.ParentNodeCode) = 0
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductWAWSubCategory1Tax4'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWSubCategory1Tax4'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductWAWMainCategoryTax4'
	  from (
			SELECT distinct
				  [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
				  ,ParentKey = [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
				  ,Deactivated = 'False'
				  ,Value = CONCAT(cn_parent.displayName, ' --> ',  cn.DisplayName)
			  FROM CatalogNodes cn
			  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
			  where cn.catalog = 'WAWUS'
				and cn.ParentNodeCode != ''
				and CHARINDEX('_', cn.ParentNodeCode) = 0
		) x
---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------
UNION ALL

---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------
/*CSI L3 CVL List*/
select 
	   [Drop Down Name]  = 'ProductWAWSubCategory2'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWSubCategory2'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductWAWSubCategory1'
	  from (
		SELECT distinct
		   [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
		  ,ParentKey =  [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
		  ,Deactivated = 'False'
		  ,Value = CONCAT(cn_parent2.DisplayName, ' --> ' ,cn_parent.displayName, ' --> ',  cn.DisplayName)
	  FROM CatalogNodes cn
	  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
	  join CatalogNodes cn_parent2 on cn_parent.ParentNodeCode = cn_parent2.Code
	  where cn.catalog = 'WAWUS'
		and cn.ParentNodeCode != ''
		and CHARINDEX('_', cn.ParentNodeCode) > 1
		) x
UNION ALL
select 
	   [Drop Down Name]  = 'ProductWAWSubCategory2Tax2'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWSubCategory2Tax2'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductWAWSubCategory1Tax2'
	  from (
		SELECT distinct
		   [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
		  ,ParentKey =  [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
		  ,Deactivated = 'False'
		  ,Value = CONCAT(cn_parent2.DisplayName, ' --> ' ,cn_parent.displayName, ' --> ',  cn.DisplayName)
	  FROM CatalogNodes cn
	  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
	  join CatalogNodes cn_parent2 on cn_parent.ParentNodeCode = cn_parent2.Code
	  where cn.catalog = 'WAWUS'
		and cn.ParentNodeCode != ''
		and CHARINDEX('_', cn.ParentNodeCode) > 1
		) x
UNION ALL
select
	   [Drop Down Name]  = 'ProductWAWSubCategory2Tax3'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWSubCategory2Tax3'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductWAWSubCategory1Tax3'
	  from (
		SELECT distinct
		   [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
		  ,ParentKey =  [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
		  ,Deactivated = 'False'
		  ,Value = CONCAT(cn_parent2.DisplayName, ' --> ' ,cn_parent.displayName, ' --> ',  cn.DisplayName)
	  FROM CatalogNodes cn
	  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
	  join CatalogNodes cn_parent2 on cn_parent.ParentNodeCode = cn_parent2.Code
	  where cn.catalog = 'WAWUS'
		and cn.ParentNodeCode != ''
		and CHARINDEX('_', cn.ParentNodeCode) > 1
		) x
UNION ALL
select
	   [Drop Down Name]  = 'ProductWAWSubCategory2Tax4'
	  ,[Data Type] = 'String'
	  ,[Drop Down ID] = 'ProductWAWSubCategory2Tax4'
	  ,[Drop Down Key] = left([Key],64)
	  ,[Sort Order] = ROW_NUMBER() over (order by x.[key]) * 10 
	  ,[Drop Down Display Value] = Value
	  ,[Parent Value Key] = ParentKey
	  ,[Parent CVL Id] = 'ProductWAWSubCategory1Tax4'
	  from (
		SELECT distinct
		   [Key] = [dbo].[RemoveNonAlphaCharacters](cn.Code)
		  ,ParentKey =  [dbo].[RemoveNonAlphaCharacters](cn.ParentNodeCode)
		  ,Deactivated = 'False'
		  ,Value = CONCAT(cn_parent2.DisplayName, ' --> ' ,cn_parent.displayName, ' --> ',  cn.DisplayName)
	  FROM CatalogNodes cn
	  join CatalogNodes cn_parent on cn.ParentNodeCode = cn_parent.Code
	  join CatalogNodes cn_parent2 on cn_parent.ParentNodeCode = cn_parent2.Code
	  where cn.catalog = 'WAWUS'
		and cn.ParentNodeCode != ''
		and CHARINDEX('_', cn.ParentNodeCode) > 1
		) x
---------------------------------------------------------------
/*****************************************************************/
---------------------------------------------------------------


