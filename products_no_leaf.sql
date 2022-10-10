/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  distinct pc1.sku
      --,c1.[Category_FullPath]
FROM [NDC].[dbo].[Categories] c1
join Categories_active  pc1               on c1.Category_FullPath = pc1.category
	and sku not in (select distinct sku
							--,c2.Category_FullPath, c2.isleaf
						FROM Categories_active pc2 
						join Categories c2 on pc2.category = c2.Category_FullPath
					  where c2.isleaf = 1
						)

/*
select * from Categories where Category_FullPath = 'Wolf-Pak Products/WOLF-PAK IV Extension Sets'



select sku
,c2.Category_FullPath, c2.isleaf
FROM prod_cat   pc2
join Categories c2  on pc2.category = c2.Category_FullPath
where sku = 'BI8002'*/