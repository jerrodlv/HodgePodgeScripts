--pivot the item specs into a temp table
SELECT * 
into #ItemSpecTemp
FROM   (SELECT code, 
                       specifications.[key], 
                       specifications.[value] 
        FROM   variants 
               JOIN specifications 
                 ON variants.variantid = specifications.VariantId 
       ) AS ItemSpec 
       PIVOT (Max([value]) 
             FOR [key] IN ([Brand], 
                           [Material], 
                           [Size / Dimension], 
                           [Special Instructions], 
                           [Units]) ) AS pivotTable 
ORDER  BY code ASC 



select * from #ItemSpecTemp
where code in (select variants.Code
					  from products 
					  join variantproducts on Products.ProductId = VariantProducts.Product_ProductId
					  join Temp_Products on Products.Code = Temp_Products.ProductCode
					  join variants on VariantProducts.Variant_VariantId = variants.VariantId)