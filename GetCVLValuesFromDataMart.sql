/****** Script for SelectTopNRows command from SSMS  ******/
--   drop table [#AttributeTemp]

SELECT distinct [Key]
	   ,AttributeValues.Value
	   ,dbo.[RemoveNonAlphaCharacters](AttributeValues.Value) ValueKey
   into #AttributeTemp
  FROM [Cleaners_Cat].[dbo].[AttributeKeys] 
  join dbo.AttributeValues on AttributeKeys.AttributeKeyId = AttributeValues.AttributeKeyId
  where [key] in 
				  (
					'Brand'
					,'Color Group'
					,'Part'
					,'Printer'
					,'Slider Style'
					,'Tag Number'
					,'Teeth Size'
					,'Tex'
				  )


select [key]
		,[value]
		,ValueKey
		,row_number() OVER (Partition by [Key] order by [Value]) * 10
		from #AttributeTemp
		  where [key] in 
				  (
					'Color Group'
					,'Part'
					,'Printer'
					,'Slider Style'
					,'Tag Number'
					,'Teeth Size'
					,'Tex'
				  )