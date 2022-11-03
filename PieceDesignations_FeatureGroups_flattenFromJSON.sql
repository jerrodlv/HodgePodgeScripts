
 Declare @JSON varchar(max);
 Declare @JSON_Designations varchar(max);


SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK '<filepath>', SINGLE_CLOB) as j;
SELECT @JSON_Designations = BulkColumn
FROM OPENROWSET (BULK '<filepath>', SINGLE_CLOB) as j;

select * 
into #designation_temp
FROM OPENJSON (@JSON_Designations)  ;

SELECT * 
into #featuresTemp 
FROM OPENJSON (@JSON) ;




with ctedesignations (DesignationCode, DesignationName)
as
(
select 
	'DesignationCode' = JSON_VALUE(#designation_temp.[value], '$.DESIGNATION_ID'),
	'DesignationName' = JSON_VALUE(#designation_temp.[value], '$."DESCRIPTION"')
from #designation_temp
),

    ctefeatures (FeatureGroup, FeatureName, SearchFilter, ItemDetail, DesignationCode)
as
(
select
		'FeatureGroup' = #featuresTemp.[key],
		'FeatureName' = JSON_VALUE(#featuresTemp.[value], '$.DES'),
		'SearchFilter' = JSON_VALUE(#featuresTemp.[value], '$.SEARCH_FILTER'),
		'ItemDetail' = JSON_VALUE(#featuresTemp.[value], '$.ITM_DETAIL'),
		--'PieceDesignations' = replace(replace(replace(JSON_QUERY(#featuresTemp.[value], '$.DESIGNATIONS'), '"', ''), '[', ''), ']', ''),
		'DesignationCode' = pieces.value
--into #featuresTemp2
from #featuresTemp 
cross apply string_split(replace(replace(replace(JSON_QUERY(#featuresTemp.[value], '$.DESIGNATIONS'), '"', ''), '[', ''), ']', ''), ',') pieces
)

select ctedesignations.DesignationCode, ctedesignations.DesignationName,ctefeatures.FeatureGroup, ctefeatures.FeatureName, ctefeatures.ItemDetail, ctefeatures.SearchFilter
from ctedesignations
join ctefeatures on ctedesignations.DesignationCode = ctefeatures.DesignationCode
order by ctedesignations.DesignationCode asc



