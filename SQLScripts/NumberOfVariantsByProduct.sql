

  select a.Code , numVariants = count(*) 
  from VariantProducts 
  join  (select productid, 
				code, 
				rownum = ROW_NUMBER() over (partition by code order by code)
		from Products ) a on VariantProducts.Product_ProductId = a.ProductId
 where a.rownum = 1
  group by a.Code
  
  having count(*) >= 30
  order by count(*)  desc
