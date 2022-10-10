
--aggregate product categories into a string for upload
  select sku
	  ,replace(string_agg(concat('Wolf Medical:' ,category), ',') within group (order by category asc),'/',':') as cats_agg
--into #tempCategory	   
from [Categories_active]
group by sku
order by sku


--get product images
select sku
	  ,RIGHT(image1, CHARINDEX('/',REVERSE(image1))-1) image1
	  ,isnull(RIGHT(image2, CHARINDEX('/',REVERSE(image2))-1), '') image2
	  --,cats_agg
from 
(
select sku
	  ,concat('image', row_number() over (partition by sku order by sku)) as imagenumber
	 , ProductImages.imagepath imagepath
from ProductImages
where downloaded = 1
) as src
PIVOT (max(imagepath) for imagenumber in (image1, image2)) as pivottable
--where sku = '3M1650'


