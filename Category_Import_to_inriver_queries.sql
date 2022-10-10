/*Get CVL keys with their parents for category nodes to load to inriver*/

--L1 CVL records
  select 'Key' = grouped.[Key]
		,ParentKey = ''
		,SortOrder = row_number() over (order by grouped.[Key] asc) * 10
		,Deactivated = 'False'
		,en = grouped.Value
  from (  
		select 'Key' = Level1_Key
			   ,'Value' = Level1_Val
				from 		[CategoriesWithKeys2]
				where Level1_Key is not null 
				group by Level1_Key, Level1_Val
		) as grouped


--L2 CVL records
  select 'Key' = grouped.[Key]
		,ParentKey = Parent
		,SortOrder = row_number() over (order by grouped.[Key] asc) * 10
		,Deactivated = 'False'
		,en = grouped.Value
  from (  
		select 'Key' = Level2_Key
			   ,'Value' = Level2_Val
               ,'Parent' = Level1_Key
				from 		[CategoriesWithKeys2]
				where Level2_Key is not null 
				group by Level2_Key, Level2_Val, Level1_Key
		) as grouped
  where grouped.[Key] is not null


 --L3 CVL records
  select 'Key' = grouped.[Key]
		,ParentKey = Parent
		,SortOrder = row_number() over (order by grouped.[Key] asc) * 10
		,Deactivated = 'False'
		,en = grouped.Value
  from (  
		select 'Key' = Level3_Key
			   ,'Value' = Level3_Val
               ,'Parent' = Level2_Key
				from 		[CategoriesWithKeys2]
				where Level3_Key is not null 
				group by Level3_Key, Level3_Val, Level2_Key
		) as grouped
  where grouped.[Key] is not null

--L4 CVL records
  select 'Key' = grouped.[Key]
		,ParentKey = Parent
		,SortOrder = row_number() over (order by grouped.[Key] asc) * 10
		,Deactivated = 'False'
		,en = grouped.Value
  from (  
		select 'Key' = Level4_Key
			   ,'Value' = Level4_Val
               ,'Parent' = Level3_Key
				from 		[CategoriesWithKeys2]
				where Level4_Key is not null 
				group by Level4_Key, Level4_Val, Level3_Key
		) as grouped
  where grouped.[Key] is not null



/*get the catgory nodes and their parents*/
select  ChannelNodeID					= CONCAT('PM-', a.NodeID)
	   ,ChannelNodeName					= a.NodeName
	   ,ChannelNodeCategoryTitle		= a.NodeName
	   ,ChannelNodeActivateOn			= ''
	   ,ChannelNodeDeactivateOn			= '' 
	   ,ChannelNodeSEOTitle				= ''
	   ,ChannelNodeSEODescription		= ''
	   ,ChannelNodeSEOKeywords			= ''
	   ,ChannelNodeOpenGraphTitle		= ''
	   ,ChannelNodeOpenGraphURL			= ''
	   ,ChannelNodeCategoryDescription	= ''
	   ,ChannelNodeParentNode			= case when isnull(a.ParentNode, '') != '' then CONCAT('PM-', a.ParentNode) else '' end
	   ,ChannelNodeParentChannel		= a.ParentChannel
	from 
	(
	SELECT  'NodeName' = Level1_Val
		   ,'NodeID' = Level1_Key 
		   ,'ParentNode' = ''
		   ,'ParentChannel' = 'Preferred Medical'
		   ,sort = 1
	  FROM [Test].[dbo].[CategoriesWithKeys2]
	  where Level1_Val is not null and Level1_Key is not null
	  group by Level1_Val
		   ,Level1_Key 
	union
	SELECT  'NodeName' = Level2_Val
		   ,'NodeID' = Level2_Key 
		   ,'ParentNode' = Level1_Key
		   ,'ParentChannel' = ''
		   ,sort = 2
	  FROM [Test].[dbo].[CategoriesWithKeys2]
	   where Level2_Val is not null and Level2_Key is not null
	  group by Level2_Val
		   ,Level2_Key 
		   ,Level1_Key
	union
	SELECT  'NodeName' = Level3_Val
		   ,'NodeID' = Level3_Key 
		   ,'ParentNode' = Level2_Key
		   ,'ParentChannel' = ''
		   ,sort = 3
	  FROM [Test].[dbo].[CategoriesWithKeys2]
	   where Level3_Val is not null and Level3_Key is not null
	  group by Level3_Val
		   ,Level3_Key 
		   ,Level2_Key
	union
	SELECT  'NodeName' = Level4_Val
		   ,'NodeID' = Level4_Key 
		   ,'ParentNode' = Level3_Key
		   ,'ParentChannel' = ''
		   ,sort = 4
	  FROM [Test].[dbo].[CategoriesWithKeys2]
	   where Level4_Val is not null and Level4_Key is not null
	  group by Level4_Val
		   ,Level4_Key 
		   ,Level3_Key
	)  a
order by sort asc , [NodeName] asc




/*----------------------
	Get the node rules for leaf categories. Dont get them for non-leaf
-----------------------*/

Select * from (
SELECT ChannelNodeID = CONCAT('PM-', Level1_Key)
	  ,Field = 'ProductCat1'
	  ,Equals = Level1_Key
  FROM [Test].[dbo].[CategoriesWithKeys2]
  where Level1_Key is not null and Level2_Key is null
union
SELECT ChannelNodeID = CONCAT('PM-', Level2_Key)
	  ,Field = 'ProductCat2'
	  ,Equals = Level2_Key
  FROM [Test].[dbo].[CategoriesWithKeys2] 
  where Level2_Key is not null and Level3_Key is null
 union
SELECT ChannelNodeID = CONCAT('PM-', Level3_Key)
	  ,Field = 'ProductCat3'
	  ,Equals = Level3_Key
  FROM [Test].[dbo].[CategoriesWithKeys2] 
  where Level3_Key is not null and Level4_Key is null
   union
SELECT ChannelNodeID = CONCAT('PM-', Level4_Key)
	  ,Field = 'ProductCat4'
	  ,Equals = Level4_Key
  FROM [Test].[dbo].[CategoriesWithKeys2] 
  where Level4_Key is not null 
  ) a
  order by field asc




--  with fullcatted (catted)
--	as ( 
--							select  TRIM(concat(TRIM(level1_val), TRIM(level2_val), TRIM(Level3_val), TRIM(Level4_val))) as 'catted' 	
--							from CategoriesWithKeys2
--					) 
--select * from fullcatted



