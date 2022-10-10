
SELECT distinct Products.code ProductCode
			,variants.code ItemVariantCode
  FROM  Products 
  join VariantProducts on products.ProductId = VariantProducts.Product_ProductId
  join Variants on VariantProducts.Variant_VariantId = variants.VariantId
  where products.code in (select productcode from Temp_Products)
  order by Products.code