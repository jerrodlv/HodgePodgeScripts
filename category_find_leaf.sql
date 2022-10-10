drop table if exists #Cat_temp
drop table if exists #Cat_concat_temp
drop table if exists Categories

CREATE TABLE Categories (
    Category_FullPath nvarchar(255),
    Cat_L1 nvarchar(255),
    Cat_L2 nvarchar(255),
    Cat_L3 nvarchar(255),
    Cat_L4 nvarchar(255),
    Cat_L5 nvarchar(255),
	isleaf bit
);

--split categories by "/" delimiter, putting into XML and then selecting values from it seems to work... put those split into a table
;WITH Split_Names (category, xmlname)
AS
(
    SELECT    category,
   CONVERT(XML,'<Names><name><![CDATA[' + REPLACE(category,'/', ']]></name><name><![CDATA[') + ']]></name></Names>') AS xmlname
      FROM Categories_active
)

SELECT distinct category,      
xmlname.value('/Names[1]/name[1]','varchar(100)') AS Cat_l1,    
xmlname.value('/Names[1]/name[2]','varchar(100)') AS Cat_L2,   
xmlname.value('/Names[1]/name[3]','varchar(100)') AS Cat_L3,   
xmlname.value('/Names[1]/name[4]','varchar(100)') AS Cat_L4,   
xmlname.value('/Names[1]/name[5]','varchar(100)') AS Cat_L5
 into #Cat_temp
 FROM Split_Names



 
select t.*
		,concat_ws('->', Cat_l1, Cat_L2, Cat_L3, Cat_L4, Cat_L5) as groups
into #Cat_concat_temp
from #cat_temp t
     

--find categories that are a leaf
insert into Categories (Category_FullPath, Cat_L1, Cat_L2, Cat_L3, Cat_L4, Cat_L5, isleaf)
select t.Category, Cat_l1, Cat_L2, Cat_L3, Cat_L4, Cat_L5, 1
from #Cat_concat_temp t
where not exists (select 1
                  from #Cat_concat_temp t2
                  where t2.groups like concat(t.groups, '->%')
                 );

 --find categories that are not a leaf



--insert into Categories (Category_FullPath, Cat_L1, Cat_L2, Cat_L3, Cat_L4, Cat_L5, isleaf)
insert into Categories (Category_FullPath, Cat_L1, Cat_L2, Cat_L3, Cat_L4, Cat_L5, isleaf)
select t.Category, Cat_l1, Cat_L2, Cat_L3, Cat_L4, Cat_L5, 0
from #Cat_concat_temp t
where  exists (select 1
                  from #Cat_concat_temp t2
                  where t2.groups like concat(t.groups, '->%')
                 );
