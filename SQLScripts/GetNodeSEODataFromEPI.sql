/****** Script for SelectTopNRows command from SSMS  ******/

select distinct ChannelNodeId = Code, 
       NodeSEOTitle = isnull(MetaTitle, ''), 
	   NodeSEODescription = isnull(MetaDescription,'')
  from (
			SELECT [Code]
				  ,[PropertyName]
				  ,[PropertyValue]
			  FROM [Cleaners_Cat2].[dbo].[EPI_catalognodeseodata]
		  ) as src PIVOT (max([PropertyValue]) for [PropertyName] in (MetaTitle,MetaDescription)) As PivotTable