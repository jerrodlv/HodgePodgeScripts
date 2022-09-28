/*
/*Only run thnis if we need to repopulate this table. it takes a loooong time to run - i dont feel like tuning it. 
has taken ~30min so i took it away from the tmep table and made a real table so i dont have to run it every day*/


drop table if exists temp_variantsCSI
drop table if exists temp_variantsWAW
drop table if exists [temp_variantsFull]

CREATE TABLE [dbo].[temp_variantsFull] 
             ( 
                          [Code] [NVARCHAR](max) NULL, 
                          [MasterCatalog] [NVARCHAR](max) NULL, 
                          [Name] [NVARCHAR](max) NULL, 
                          [DisplayName] [NVARCHAR](max) NULL, 
                          [varmanufacturer] [NVARCHAR](max) NULL, 
                          [MinQuantity] [DECIMAL](18, 2) NULL, 
                          [SellingMultiple] [INT] NULL, 
                          [varweight] [DECIMAL](18, 2) NULL, 
                          [SellingUOM] [NVARCHAR](max) NULL, 
                          [PackageUOM] [NVARCHAR](max) NULL, 
                          [PriceFamily] [NVARCHAR](max) NULL, 
                          [TaxCategory] [NVARCHAR](max) NULL, 
                          [StockStatus] [NVARCHAR](max) NULL, 
                          [isDiscontinued] [INT] NULL, 
                          [isActive] [INT] NULL, 
                          [CustomSetupCode] [NVARCHAR](max) NULL, 
                          [CustomInkCode] [NVARCHAR](max) NULL, 
                          [BrandCode] [NVARCHAR](max) NULL, 
                          [TransTime] [NVARCHAR](29) NULL, 
                          [CustomPrintSubtitle] [NVARCHAR](max) NULL, 
                          [HasTwoInkOptions] [SMALLINT] NULL, 
                          [WAWCategory] [NVARCHAR](max) NULL, 
                          [WAWProductType] [NVARCHAR](max) NULL, 
                          [WAWStyle] [NVARCHAR](max) NULL, 
                          [WAWDesign] [NVARCHAR](max) NULL, 
                          [WAWDisplayName] [NVARCHAR](max) NULL, 
                          [Printer] [NVARCHAR](max) NULL, 
                          [Tex] [NVARCHAR](max) NULL, 
                          [Front Print] [NVARCHAR](max) NULL, 
                          [Extendable Handle] [NVARCHAR](max) NULL, 
                          [Slider Style] [NVARCHAR](max) NULL, 
                          [Weight] [NVARCHAR](max) NULL, 
                          [Gallon] [NVARCHAR](max) NULL, 
                          [Hanger Hole] [NVARCHAR](max) NULL, 
                          [Hoses] [NVARCHAR](max) NULL, 
                          [Custom Printing] [NVARCHAR](max) NULL, 
                          [Strap] [NVARCHAR](max) NULL, 
                          [Finish] [NVARCHAR](max) NULL, 
                          [Gusset] [NVARCHAR](max) NULL, 
                          [Compartments] [NVARCHAR](max) NULL, 
                          [Use] [NVARCHAR](max) NULL, 
                          [Manufacturer] [NVARCHAR](max) NULL, 
                          [Measurement] [NVARCHAR](max) NULL, 
                          [ColorPopular] [NVARCHAR](max) NULL, 
                          [Number] [NVARCHAR](max) NULL, 
                          [Quantity] [NVARCHAR](max) NULL, 
                          [Material] [NVARCHAR](max) NULL, 
                          [Part Type] [NVARCHAR](max) NULL, 
                          [Design] [NVARCHAR](max) NULL, 
                          [Bristle Length] [NVARCHAR](max) NULL, 
                          [Loop Style] [NVARCHAR](max) NULL, 
                          [Back Print] [NVARCHAR](max) NULL, 
                          [Standard] [NVARCHAR](max) NULL, 
                          [Header Style] [NVARCHAR](max) NULL, 
                          [Machine] [NVARCHAR](max) NULL, 
                          [Spool Amount] [NVARCHAR](max) NULL, 
                          [Color Group] [NVARCHAR](max) NULL, 
                          [Select Style] [NVARCHAR](max) NULL, 
                          [Loop Spacing] [NVARCHAR](max) NULL, 
                          [Author] [NVARCHAR](max) NULL, 
                          [Melting Temperature] [NVARCHAR](max) NULL, 
                          [Series] [NVARCHAR](max) NULL, 
                          [Thickness] [NVARCHAR](max) NULL, 
                          [Teeth Size] [NVARCHAR](max) NULL, 
                          [Material Type] [NVARCHAR](max) NULL, 
                          [Oz.] [NVARCHAR](max) NULL, 
                          [Style] [NVARCHAR](max) NULL, 
                          [Counter Display] [NVARCHAR](max) NULL, 
                          [BrandCSI] [NVARCHAR](max) NULL, 
                          [BrandWAW] [NVARCHAR](max) NULL, 
                          [Voltage & Watts] [NVARCHAR](max) NULL, 
                          [Color] [NVARCHAR](max) NULL, 
                          [Pressure Gauge] [NVARCHAR](max) NULL, 
                          [Lot Series] [NVARCHAR](max) NULL, 
                          [Length] [NVARCHAR](max) NULL, 
                          [Product Style] [NVARCHAR](max) NULL, 
                          [Category] [NVARCHAR](max) NULL, 
                         -- [Product Type] [NVARCHAR](max) NULL, 
						  CSIProductType [NVARCHAR](max) NULL, 
                          [Diameter] [NVARCHAR](max) NULL, 
                          [Size] [NVARCHAR](max) NULL, 
                          [Pocket] [NVARCHAR](max) NULL, 
                          [Model #] [NVARCHAR](max) NULL, 
                          [Type] [NVARCHAR](max) NULL, 
                          [Zipper] [NVARCHAR](max) NULL, 
                          [PSI] [NVARCHAR](max) NULL, 
                          [Tag Number] [NVARCHAR](max) NULL, 
                          [Manufacturer Name] [NVARCHAR](max) NULL, 
                          [Pad Type] [NVARCHAR](max) NULL, 
                          [Spacing] [NVARCHAR](max) NULL, 
                          [Needle System] [NVARCHAR](max) NULL, 
                          [Part] [NVARCHAR](max) NULL, 
                          [Shape] [NVARCHAR](max) NULL, 
                          [ColorHex] [NVARCHAR](max) NULL, 
                          [Product] [NVARCHAR](max) NULL
				)

insert into [temp_variantsFull] (code) select distinct code from Variants


select * 
  into temp_variantsCSI 
  from (
		SELECT Variants.VariantId                                                             
,            Variants.Code                                                                  
,            Products.MasterCatalog                                                         
,            Variants.Name                                                                  
,            Variants.DisplayName                                                           
,            Variants.Manufacturer  varmanufacturer
,            Variants.MinQuantity                                                           
,            Variants.SellingMultiple                                                       
,            Variants.Weight   varweight
,            Variants.SellingUOM                                                            
,            Variants.PackageUOM                                                            
,            Variants.PriceFamily                                                           
,            Variants.TaxCategory                                                           
,            Variants.StockStatus                                                           
,            abs(Variants.IsDiscontinued)  isDiscontinued
,            abs(Variants.IsActive)    isActive
,            Variants.CustomSetupCode                                                       
,            Variants.CustomInkCode                                                         
,            Variants.BrandCode                                                             
,            Variants.TransTime                                                             
,            Variants.CustomPrintSubtitle                                                   
,            Variants.HasTwoInkOptions                                                      
,            min(case attributes.[key] when 'Printer' then attributes.value end)             as 'Printer'
,            min(case attributes.[key] when 'Tex' then attributes.value end)                 as 'Tex'
,            min(case attributes.[key] when 'Front Print' then attributes.value end)         as 'Front Print'
,            min(case attributes.[key] when 'Extendable Handle' then attributes.value end)   as 'Extendable Handle'
,            min(case attributes.[key] when 'Slider Style' then attributes.value end)        as 'Slider Style'
,            min(case attributes.[key] when 'Weight' then attributes.value end)              as 'Weight'
,            min(case attributes.[key] when 'Gallon' then attributes.value end)              as 'Gallon'
,            min(case attributes.[key] when 'Hanger Hole' then attributes.value end)         as 'Hanger Hole'
,            min(case attributes.[key] when 'Hoses' then attributes.value end)               as 'Hoses'
,            min(case attributes.[key] when 'Custom Printing' then attributes.value end)     as 'Custom Printing'
,            min(case attributes.[key] when 'Strap' then attributes.value end)               as 'Strap'
,            min(case attributes.[key] when 'Finish' then attributes.value end)              as 'Finish'
,            min(case attributes.[key] when 'Gusset' then attributes.value end)              as 'Gusset'
,            min(case attributes.[key] when 'Compartments' then attributes.value end)        as 'Compartments'
,            min(case attributes.[key] when 'Use' then attributes.value end)                 as 'Use'
,            min(case attributes.[key] when 'Measurement' then attributes.value end)         as 'Measurement'
,            min(case attributes.[key] when 'ColorPopular' then attributes.value end)        as 'ColorPopular'
,            min(case attributes.[key] when 'Number' then attributes.value end)              as 'Number'
,            min(case attributes.[key] when 'Quantity' then attributes.value end)            as 'Quantity'
,            min(case attributes.[key] when 'Material' then attributes.value end)            as 'Material'
,            min(case attributes.[key] when 'Part Type' then attributes.value end)           as 'Part Type'
,            min(case attributes.[key] when 'Design' then attributes.value end)              as 'Design'
,            min(case attributes.[key] when 'Bristle Length' then attributes.value end)      as 'Bristle Length'
,            min(case attributes.[key] when 'Loop Style' then attributes.value end)          as 'Loop Style'
,            min(case attributes.[key] when 'Back Print' then attributes.value end)          as 'Back Print'
,            min(case attributes.[key] when 'Standard' then attributes.value end)            as 'Standard'
,            min(case attributes.[key] when 'Header Style' then attributes.value end)        as 'Header Style'
,            min(case attributes.[key] when 'Machine' then attributes.value end)             as 'Machine'
,            min(case attributes.[key] when 'Spool Amount' then attributes.value end)        as 'Spool Amount'
,            min(case attributes.[key] when 'Color Group' then attributes.value end)         as 'Color Group'
,            min(case attributes.[key] when 'Select Style' then attributes.value end)        as 'Select Style'
,            min(case attributes.[key] when 'Loop Spacing' then attributes.value end)        as 'Loop Spacing'
,            min(case attributes.[key] when 'Author' then attributes.value end)              as 'Author'
,            min(case attributes.[key] when 'Melting Temperature' then attributes.value end) as 'Melting Temperature'
,            min(case attributes.[key] when 'Series' then attributes.value end)              as 'Series'
,            min(case attributes.[key] when 'Thickness' then attributes.value end)           as 'Thickness'
,            min(case attributes.[key] when 'Teeth Size' then attributes.value end)          as 'Teeth Size'
,            min(case attributes.[key] when 'Material Type' then attributes.value end)       as 'Material Type'
,            min(case attributes.[key] when 'Oz.' then attributes.value end)                 as 'Oz.'
,            min(case attributes.[key] when 'Style' then attributes.value end)               as 'Style'
,            min(case attributes.[key] when 'Counter Display' then attributes.value end)     as 'Counter Display'
,            min(case attributes.[key] when 'Brand' then attributes.value end)               as 'Brand'
,            min(case attributes.[key] when 'Voltage & Watts' then attributes.value end)     as 'Voltage & Watts'
,            min(case attributes.[key] when 'Color' then attributes.value end)               as 'Color'
,            min(case attributes.[key] when 'Pressure Gauge' then attributes.value end)      as 'Pressure Gauge'
,            min(case attributes.[key] when 'Lot Series' then attributes.value end)          as 'Lot Series'
,            min(case attributes.[key] when 'Length' then attributes.value end)              as 'Length'
,            min(case attributes.[key] when 'Product Style' then attributes.value end)       as 'Product Style'
,            min(case attributes.[key] when 'Category' then attributes.value end)            as 'Category'
,            min(case attributes.[key] when 'Product Type' then attributes.value end)        as 'Product Type'
,            min(case attributes.[key] when 'Diameter' then attributes.value end)            as 'Diameter'
,            min(case attributes.[key] when 'Size' then attributes.value end)                as 'Size'
,            min(case attributes.[key] when 'Pocket' then attributes.value end)              as 'Pocket'
,            min(case attributes.[key] when 'Type' then attributes.value end)                as 'Type'
,            min(case attributes.[key] when 'Zipper' then attributes.value end)              as 'Zipper'
,            min(case attributes.[key] when 'PSI' then attributes.value end)                 as 'PSI'
,            min(case attributes.[key] when 'Tag Number' then attributes.value end)          as 'Tag Number'
,            min(case attributes.[key] when 'Manufacturer Name' then attributes.value end)   as 'Manufacturer Name'
,            min(case attributes.[key] when 'Pad Type' then attributes.value end)            as 'Pad Type'
,            min(case attributes.[key] when 'Spacing' then attributes.value end)             as 'Spacing'
,            min(case attributes.[key] when 'Needle System' then attributes.value end)       as 'Needle System'
,            min(case attributes.[key] when 'Part' then attributes.value end)                as 'Part'
,            min(case attributes.[key] when 'Shape' then attributes.value end)               as 'Shape'
,            min(case attributes.[key] when 'ColorHex' then attributes.value end)            as 'ColorHex'
,            min(case attributes.[key] when 'Product' then attributes.value end)             as 'Product'
FROM Variants                  
join ( select AttributeKeys.VariantId                                                  
	,         [key]                                                                    
	,         STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(attributevalues.Value,'')),'|') as [Value]
	from AttributeKeys  
	join attributevalues on attributekeys.AttributeKeyId = AttributeValues.AttributeKeyID
	group by AttributeKeys.VariantId
	,        [key])  attributes on variants.VariantId = attributes.VariantId
--join AttributeKeys on AttributeKeys.VariantId = variants.VariantId
--join attributevalues on attributekeys.AttributeKeyId = AttributeValues.AttributeKeyId
join VariantProducts            on Variants.VariantId = VariantProducts.Variant_VariantId
join Products                   on VariantProducts.Product_ProductId = Products.ProductId
where products.MasterCatalog = 'CSI'
group by 
Variants.VariantId                        
,            Variants.Code                
,            Products.MasterCatalog       
,            Variants.Name                
,            Variants.DisplayName         
,            Variants.Manufacturer        
,            Variants.MinQuantity         
,            Variants.SellingMultiple     
,            Variants.Weight              
,            Variants.SellingUOM          
,            Variants.PackageUOM          
,            Variants.PriceFamily         
,            Variants.TaxCategory         
,            Variants.StockStatus         
,            abs(Variants.IsDiscontinued) 
,            abs(Variants.IsActive)       
,            Variants.CustomSetupCode     
,            Variants.CustomInkCode       
,            Variants.BrandCode           
,            Variants.TransTime           
,            Variants.CustomPrintSubtitle 
,            Variants.HasTwoInkOptions   
		) as a

select * 
  into temp_variantsWAW
  from (
		SELECT Variants.VariantId                                                             
,            Variants.Code                                                                  
,            Products.MasterCatalog                                                         
,            Variants.Name                                                                  
,            Variants.DisplayName                                                           
,            Variants.Manufacturer  varmanufacturer
,            Variants.MinQuantity                                                           
,            Variants.SellingMultiple                                                       
,            Variants.Weight   varweight
,            Variants.SellingUOM                                                            
,            Variants.PackageUOM                                                            
,            Variants.PriceFamily                                                           
,            Variants.TaxCategory                                                           
,            Variants.StockStatus                                                           
,            abs(Variants.IsDiscontinued)  isDiscontinued
,            abs(Variants.IsActive)    isActive
,            Variants.CustomSetupCode                                                       
,            Variants.CustomInkCode                                                         
,            Variants.BrandCode                                                             
,            Variants.TransTime                                                             
,            Variants.CustomPrintSubtitle                                                   
,            Variants.HasTwoInkOptions                                                      
,            min(case attributes.[key] when 'Printer' then attributes.value end)             as 'Printer'
,            min(case attributes.[key] when 'Tex' then attributes.value end)                 as 'Tex'
,            min(case attributes.[key] when 'Front Print' then attributes.value end)         as 'Front Print'
,            min(case attributes.[key] when 'Extendable Handle' then attributes.value end)   as 'Extendable Handle'
,            min(case attributes.[key] when 'Slider Style' then attributes.value end)        as 'Slider Style'
,            min(case attributes.[key] when 'Weight' then attributes.value end)              as 'Weight'
,            min(case attributes.[key] when 'Gallon' then attributes.value end)              as 'Gallon'
,            min(case attributes.[key] when 'Hanger Hole' then attributes.value end)         as 'Hanger Hole'
,            min(case attributes.[key] when 'Hoses' then attributes.value end)               as 'Hoses'
,            min(case attributes.[key] when 'Custom Printing' then attributes.value end)     as 'Custom Printing'
,            min(case attributes.[key] when 'Strap' then attributes.value end)               as 'Strap'
,            min(case attributes.[key] when 'Finish' then attributes.value end)              as 'Finish'
,            min(case attributes.[key] when 'Gusset' then attributes.value end)              as 'Gusset'
,            min(case attributes.[key] when 'Compartments' then attributes.value end)        as 'Compartments'
,            min(case attributes.[key] when 'Use' then attributes.value end)                 as 'Use'
,            min(case attributes.[key] when 'Measurement' then attributes.value end)         as 'Measurement'
,            min(case attributes.[key] when 'ColorPopular' then attributes.value end)        as 'ColorPopular'
,            min(case attributes.[key] when 'Number' then attributes.value end)              as 'Number'
,            min(case attributes.[key] when 'Quantity' then attributes.value end)            as 'Quantity'
,            min(case attributes.[key] when 'Material' then attributes.value end)            as 'Material'
,            min(case attributes.[key] when 'Part Type' then attributes.value end)           as 'Part Type'
,            min(case attributes.[key] when 'Design' then attributes.value end)              as 'Design'
,            min(case attributes.[key] when 'Bristle Length' then attributes.value end)      as 'Bristle Length'
,            min(case attributes.[key] when 'Loop Style' then attributes.value end)          as 'Loop Style'
,            min(case attributes.[key] when 'Back Print' then attributes.value end)          as 'Back Print'
,            min(case attributes.[key] when 'Standard' then attributes.value end)            as 'Standard'
,            min(case attributes.[key] when 'Header Style' then attributes.value end)        as 'Header Style'
,            min(case attributes.[key] when 'Machine' then attributes.value end)             as 'Machine'
,            min(case attributes.[key] when 'Spool Amount' then attributes.value end)        as 'Spool Amount'
,            min(case attributes.[key] when 'Color Group' then attributes.value end)         as 'Color Group'
,            min(case attributes.[key] when 'Select Style' then attributes.value end)        as 'Select Style'
,            min(case attributes.[key] when 'Loop Spacing' then attributes.value end)        as 'Loop Spacing'
,            min(case attributes.[key] when 'Author' then attributes.value end)              as 'Author'
,            min(case attributes.[key] when 'Melting Temperature' then attributes.value end) as 'Melting Temperature'
,            min(case attributes.[key] when 'Series' then attributes.value end)              as 'Series'
,            min(case attributes.[key] when 'Thickness' then attributes.value end)           as 'Thickness'
,            min(case attributes.[key] when 'Teeth Size' then attributes.value end)          as 'Teeth Size'
,            min(case attributes.[key] when 'Material Type' then attributes.value end)       as 'Material Type'
,            min(case attributes.[key] when 'Oz.' then attributes.value end)                 as 'Oz.'
,            min(case attributes.[key] when 'Style' then attributes.value end)               as 'Style'
,            min(case attributes.[key] when 'Counter Display' then attributes.value end)     as 'Counter Display'
,            min(case attributes.[key] when 'Brand' then attributes.value end)               as 'Brand'
,            min(case attributes.[key] when 'Voltage & Watts' then attributes.value end)     as 'Voltage & Watts'
,            min(case attributes.[key] when 'Color' then attributes.value end)               as 'Color'
,            min(case attributes.[key] when 'Pressure Gauge' then attributes.value end)      as 'Pressure Gauge'
,            min(case attributes.[key] when 'Lot Series' then attributes.value end)          as 'Lot Series'
,            min(case attributes.[key] when 'Length' then attributes.value end)              as 'Length'
,            min(case attributes.[key] when 'Product Style' then attributes.value end)       as 'Product Style'
,            min(case attributes.[key] when 'Category' then attributes.value end)            as 'Category'
,            min(case attributes.[key] when 'Product Type' then attributes.value end)        as 'Product Type'
,            min(case attributes.[key] when 'Diameter' then attributes.value end)            as 'Diameter'
,            min(case attributes.[key] when 'Size' then attributes.value end)                as 'Size'
,            min(case attributes.[key] when 'Pocket' then attributes.value end)              as 'Pocket'
,            min(case attributes.[key] when 'Type' then attributes.value end)                as 'Type'
,            min(case attributes.[key] when 'Zipper' then attributes.value end)              as 'Zipper'
,            min(case attributes.[key] when 'PSI' then attributes.value end)                 as 'PSI'
,            min(case attributes.[key] when 'Tag Number' then attributes.value end)          as 'Tag Number'
,            min(case attributes.[key] when 'Manufacturer Name' then attributes.value end)   as 'Manufacturer Name'
,            min(case attributes.[key] when 'Pad Type' then attributes.value end)            as 'Pad Type'
,            min(case attributes.[key] when 'Spacing' then attributes.value end)             as 'Spacing'
,            min(case attributes.[key] when 'Needle System' then attributes.value end)       as 'Needle System'
,            min(case attributes.[key] when 'Part' then attributes.value end)                as 'Part'
,            min(case attributes.[key] when 'Shape' then attributes.value end)               as 'Shape'
,            min(case attributes.[key] when 'ColorHex' then attributes.value end)            as 'ColorHex'
,            min(case attributes.[key] when 'Product' then attributes.value end)             as 'Product'
FROM Variants                  
join ( select AttributeKeys.VariantId                                                  
	,         [key]                                                                    
	,         STRING_AGG(CONVERT(NVARCHAR(max), ISNULL(attributevalues.Value,'')),'|') as [Value]
	from AttributeKeys  
	join attributevalues on attributekeys.AttributeKeyId = AttributeValues.AttributeKeyID
	group by AttributeKeys.VariantId
	,        [key])  attributes on variants.VariantId = attributes.VariantId
--join AttributeKeys on AttributeKeys.VariantId = variants.VariantId
--join attributevalues on attributekeys.AttributeKeyId = AttributeValues.AttributeKeyId
join VariantProducts            on Variants.VariantId = VariantProducts.Variant_VariantId
join Products                   on VariantProducts.Product_ProductId = Products.ProductId
where products.MasterCatalog = 'WAW'
group by 
Variants.VariantId                        
,            Variants.Code                
,            Products.MasterCatalog       
,            Variants.Name                
,            Variants.DisplayName         
,            Variants.Manufacturer        
,            Variants.MinQuantity         
,            Variants.SellingMultiple     
,            Variants.Weight              
,            Variants.SellingUOM          
,            Variants.PackageUOM          
,            Variants.PriceFamily         
,            Variants.TaxCategory         
,            Variants.StockStatus         
,            abs(Variants.IsDiscontinued) 
,            abs(Variants.IsActive)       
,            Variants.CustomSetupCode     
,            Variants.CustomInkCode       
,            Variants.BrandCode           
,            Variants.TransTime           
,            Variants.CustomPrintSubtitle 
,            Variants.HasTwoInkOptions   
		) as a
	





update [temp_variantsFull]
set			[temp_variantsFull].[Name]					=			coalesce(temp_variantsCSI.[Name]			, temp_variantsWAW.[Name], '')
           ,[temp_variantsFull].[DisplayName]			=			temp_variantsCSI.[DisplayName]
           ,[temp_variantsFull].[varmanufacturer]		=			coalesce(temp_variantsCSI.[varmanufacturer]	    , temp_variantsWAW.[varmanufacturer]	 ,'')
           ,[temp_variantsFull].[MinQuantity]			=			coalesce(temp_variantsCSI.[MinQuantity]		    , temp_variantsWAW.[MinQuantity]		 )
          ,[temp_variantsFull].[SellingMultiple]		=			coalesce(temp_variantsCSI.[SellingMultiple]	    , temp_variantsWAW.[SellingMultiple]	 )
           ,[temp_variantsFull].[varweight]				=			coalesce(temp_variantsCSI.[varweight]		    , temp_variantsWAW.[varweight]			 )
              ,[temp_variantsFull].[SellingUOM]			=			coalesce(temp_variantsCSI.[SellingUOM]		    , temp_variantsWAW.[SellingUOM]			 )
           ,[temp_variantsFull].[PackageUOM]			=			coalesce(temp_variantsCSI.[PackageUOM]		    , temp_variantsWAW.[PackageUOM]			 , '')
            ,[temp_variantsFull].[PriceFamily]			=			coalesce(temp_variantsCSI.[PriceFamily]		    , temp_variantsWAW.[PriceFamily]		 , '')
           ,[temp_variantsFull].[TaxCategory]			=			coalesce(temp_variantsCSI.[TaxCategory]		    , temp_variantsWAW.[TaxCategory]		 , '')
           ,[temp_variantsFull].[StockStatus]			=			coalesce(temp_variantsCSI.[StockStatus]		    , temp_variantsWAW.[StockStatus]		 , '')
           ,[temp_variantsFull].[isDiscontinued]		=			coalesce(temp_variantsCSI.[isDiscontinued]	    , temp_variantsWAW.[isDiscontinued]		 , '')
           ,[temp_variantsFull].[isActive]				=			coalesce(temp_variantsCSI.[isActive]		    , temp_variantsWAW.[isActive]			 , '')
           ,[temp_variantsFull].[CustomSetupCode]		=			coalesce(temp_variantsCSI.[CustomSetupCode]	    , temp_variantsWAW.[CustomSetupCode]	 , '')
           ,[temp_variantsFull].[CustomInkCode]			=			coalesce(temp_variantsCSI.[CustomInkCode]	    , temp_variantsWAW.[CustomInkCode]		 , '')
           ,[temp_variantsFull].[BrandCode]				=			coalesce(temp_variantsCSI.[BrandCode]		    , temp_variantsWAW.[BrandCode]			 , '')
           ,[temp_variantsFull].[TransTime]				=			coalesce(temp_variantsCSI.[TransTime]		    , temp_variantsWAW.[TransTime]			 , '')
           ,[temp_variantsFull].[CustomPrintSubtitle]	=			coalesce(temp_variantsCSI.[CustomPrintSubtitle] , temp_variantsWAW.[CustomPrintSubtitle] , '')
           ,[temp_variantsFull].[HasTwoInkOptions]		=			coalesce(temp_variantsCSI.[HasTwoInkOptions]    , temp_variantsWAW.[HasTwoInkOptions]	 , '')
        ,[temp_variantsFull].[WAWCategory]				=			temp_variantsWAW.[Category]
           ,[temp_variantsFull].[WAWProductType]		=			temp_variantsWAW.[Type]
           ,[temp_variantsFull].[WAWStyle]				=			temp_variantsWAW.[Style]
           ,[temp_variantsFull].[WAWDesign]				=			temp_variantsWAW.[Design]
           ,[temp_variantsFull].[WAWDisplayName]		=			temp_variantsWAW.[DisplayName]
           ,[temp_variantsFull].[Printer]				=			coalesce(temp_variantsCSI.[Printer]				 , temp_variantsWAW.[Printer], '')
           ,[temp_variantsFull].[Tex]					=			coalesce(temp_variantsCSI.[Tex]					 , temp_variantsWAW.[Tex], '')
           ,[temp_variantsFull].[Front Print]			=			coalesce(temp_variantsCSI.[Front Print]			 , temp_variantsWAW.[Front Print], '')
           ,[temp_variantsFull].[Extendable Handle]		=			coalesce(temp_variantsCSI.[Extendable Handle]	 , temp_variantsWAW.[Extendable Handle], '')
           ,[temp_variantsFull].[Slider Style]			=			coalesce(temp_variantsCSI.[Slider Style]		 , temp_variantsWAW.[Slider Style], '')
           ,[temp_variantsFull].[Weight]				=			coalesce(temp_variantsCSI.[Weight]				 , temp_variantsWAW.[Weight], '')
           ,[temp_variantsFull].[Gallon]				=			coalesce(temp_variantsCSI.[Gallon]				 , temp_variantsWAW.[Gallon], '')
           ,[temp_variantsFull].[Hanger Hole]			=			coalesce(temp_variantsCSI.[Hanger Hole]			 , temp_variantsWAW.[Hanger Hole], '')
           ,[temp_variantsFull].[Hoses]					=			coalesce(temp_variantsCSI.[Hoses]				 , temp_variantsWAW.[Hoses], '')
           ,[temp_variantsFull].[Custom Printing]		=			coalesce(temp_variantsCSI.[Custom Printing]		 , temp_variantsWAW.[Custom Printing], '')
           ,[temp_variantsFull].[Strap]					=			coalesce(temp_variantsCSI.[Strap]				 , temp_variantsWAW.[Strap], '')
           ,[temp_variantsFull].[Finish]				=			coalesce(temp_variantsCSI.[Finish]				 , temp_variantsWAW.[Finish], '')
           ,[temp_variantsFull].[Gusset]				=			coalesce(temp_variantsCSI.[Gusset]				 , temp_variantsWAW.[Gusset], '')
           ,[temp_variantsFull].[Compartments]			=			coalesce(temp_variantsCSI.[Compartments]		 , temp_variantsWAW.[Compartments], '')
           ,[temp_variantsFull].[Use]					=			coalesce(temp_variantsCSI.[Use]					 , temp_variantsWAW.[Use], '')
           ,[temp_variantsFull].[Manufacturer]			=			coalesce(temp_variantsCSI.varmanufacturer		 , temp_variantsWAW.varmanufacturer, '')
           ,[temp_variantsFull].[Measurement]			=			coalesce(temp_variantsCSI.[Measurement]			 , temp_variantsWAW.[Measurement], '')
           ,[temp_variantsFull].[ColorPopular]			=			coalesce(temp_variantsCSI.[ColorPopular]		 , temp_variantsWAW.[ColorPopular], '')
           ,[temp_variantsFull].[Number]				=			coalesce(temp_variantsCSI.[Number]				 , temp_variantsWAW.[Number], '')
           ,[temp_variantsFull].[Quantity]				=			coalesce(temp_variantsCSI.[Quantity]			 , temp_variantsWAW.[Quantity] , '')
           ,[temp_variantsFull].[Material]				=			coalesce(temp_variantsCSI.[Material]			 , temp_variantsWAW.[Material] , '')
           ,[temp_variantsFull].[Part Type]				=			coalesce(temp_variantsCSI.[Part Type]			 , temp_variantsWAW.[Part Type], '')
           ,[temp_variantsFull].[Design]				=			isnull(temp_variantsCSI.[Design],'')
           ,[temp_variantsFull].[Bristle Length]		=			coalesce(temp_variantsCSI.[Bristle Length]		 , temp_variantsWAW.[Bristle Length], '')
           ,[temp_variantsFull].[Loop Style]			=			coalesce(temp_variantsCSI.[Loop Style]			 , temp_variantsWAW.[Loop Style], '')
           ,[temp_variantsFull].[Back Print]			=			coalesce(temp_variantsCSI.[Back Print]			 , temp_variantsWAW.[Back Print], '')
           ,[temp_variantsFull].[Standard]				=			coalesce(temp_variantsCSI.[Standard]			 , temp_variantsWAW.[Standard], '')
           ,[temp_variantsFull].[Header Style]			=			coalesce(temp_variantsCSI.[Header Style]		 , temp_variantsWAW.[Header Style], '')
           ,[temp_variantsFull].[Machine]				=			coalesce(temp_variantsCSI.[Machine]				 , temp_variantsWAW.[Machine], '')
           ,[temp_variantsFull].[Spool Amount]			=			coalesce(temp_variantsCSI.[Spool Amount]		 , temp_variantsWAW.[Spool Amount], '')
           ,[temp_variantsFull].[Color Group]			=			coalesce(temp_variantsCSI.[Color Group]			 , temp_variantsWAW.[Color Group], '')
           ,[temp_variantsFull].[Select Style]			=			coalesce(temp_variantsCSI.[Select Style]		 , temp_variantsWAW.[Select Style], '')
           ,[temp_variantsFull].[Loop Spacing]			=			coalesce(temp_variantsCSI.[Loop Spacing]		 , temp_variantsWAW.[Loop Spacing], '')
           ,[temp_variantsFull].[Author]				=			coalesce(temp_variantsCSI.[Author]				 , temp_variantsWAW.[Author], '')
           ,[temp_variantsFull].[Melting Temperature]	=			coalesce(temp_variantsCSI.[Melting Temperature]	 , temp_variantsWAW.[Melting Temperature], '')
           ,[temp_variantsFull].[Series]				=			coalesce(temp_variantsCSI.[Series]				 , temp_variantsWAW.[Series], '')
           ,[temp_variantsFull].[Thickness]				=			coalesce(temp_variantsCSI.[Thickness]			 , temp_variantsWAW.[Thickness], '')
           ,[temp_variantsFull].[Teeth Size]			=			coalesce(temp_variantsCSI.[Teeth Size]			 , temp_variantsWAW.[Teeth Size], '')
           ,[temp_variantsFull].[Material Type]			=			coalesce(temp_variantsCSI.[Material Type]		 , temp_variantsWAW.[Material Type], '')
           ,[temp_variantsFull].[Oz.]					=			coalesce(temp_variantsCSI.[Oz.]					 , temp_variantsWAW.[Oz.], '')
           ,[temp_variantsFull].[Style]					=			isnull(temp_variantsCSI.[Style], '')
           ,[temp_variantsFull].[Counter Display]		=			coalesce(temp_variantsCSI.[Counter Display]		 , temp_variantsWAW.[Counter Display], '')
           ,[temp_variantsFull].[BrandCSI]				=			coalesce(temp_variantsCSI.[Brand]				 ,'')
           ,[temp_variantsFull].[BrandWAW]				=			coalesce(temp_variantsWAW.[Brand]				 ,'')
           ,[temp_variantsFull].[Voltage & Watts]		=			coalesce(temp_variantsCSI.[Voltage & Watts]		 , temp_variantsWAW.[Voltage & Watts], '')
           ,[temp_variantsFull].[Color]					=			coalesce(temp_variantsCSI.[Color]				 , temp_variantsWAW.[Color], '')
           ,[temp_variantsFull].[Pressure Gauge]		=			coalesce(temp_variantsCSI.[Pressure Gauge]		 , temp_variantsWAW.[Pressure Gauge], '')
           ,[temp_variantsFull].[Lot Series]			=			coalesce(temp_variantsCSI.[Lot Series]			 , temp_variantsWAW.[Lot Series], '')
           ,[temp_variantsFull].[Length]				=			coalesce(temp_variantsCSI.[Length]				 , temp_variantsWAW.[Length], '')
           ,[temp_variantsFull].[Product Style]			=			coalesce(temp_variantsCSI.[Product Style]		 , temp_variantsWAW.[Product Style], '')
           ,[temp_variantsFull].[Category]				=			isnull(temp_variantsCSI.[Category], '')	
           ,[temp_variantsFull].[CSIProductType]			=			isnull(temp_variantsCSI.[Type], '')
           ,[temp_variantsFull].[Diameter]				=			coalesce(temp_variantsCSI.[Diameter]			 , temp_variantsWAW.[Diameter], '')
           ,[temp_variantsFull].[Size]					=			coalesce(temp_variantsCSI.[Size]				 , temp_variantsWAW.[Size], '')
           ,[temp_variantsFull].[Pocket]				=			coalesce(temp_variantsCSI.[Pocket]				 , temp_variantsWAW.[Pocket], '')
           ,[temp_variantsFull].[Zipper]				=			coalesce(temp_variantsCSI.[Zipper]				 , temp_variantsWAW.[Zipper], '')
           ,[temp_variantsFull].[PSI]					=			coalesce(temp_variantsCSI.[PSI]					 , temp_variantsWAW.[PSI], '')
           ,[temp_variantsFull].[Tag Number]			=			coalesce(temp_variantsCSI.[Tag Number]			 , temp_variantsWAW.[Tag Number], '')
           ,[temp_variantsFull].[Manufacturer Name]		=			coalesce(temp_variantsCSI.[Manufacturer Name]	 , temp_variantsWAW.[Manufacturer Name], '')
           ,[temp_variantsFull].[Pad Type]				=			coalesce(temp_variantsCSI.[Pad Type]			 , temp_variantsWAW.[Pad Type], '')
           ,[temp_variantsFull].[Spacing]				=			coalesce(temp_variantsCSI.[Spacing]				 , temp_variantsWAW.[Spacing], '')
           ,[temp_variantsFull].[Needle System]			=			coalesce(temp_variantsCSI.[Needle System]		 , temp_variantsWAW.[Needle System], '')
           ,[temp_variantsFull].[Part]					=			coalesce(temp_variantsCSI.[Part]				 , temp_variantsWAW.[Part], '')
           ,[temp_variantsFull].[Shape]					=			coalesce(temp_variantsCSI.[Shape]				 , temp_variantsWAW.[Shape], '')
           ,[temp_variantsFull].[ColorHex]				=			coalesce(temp_variantsCSI.[ColorHex]			 , temp_variantsWAW.[ColorHex], '')
           ,[temp_variantsFull].[Product]				=			coalesce(temp_variantsCSI.[Product] 			 , temp_variantsWAW.[Product], '')
from  [temp_variantsFull]
left join temp_variantsCSI on [temp_variantsFull].code = temp_variantsCSI.code
left join temp_variantsWAW on [temp_variantsFull].code = temp_variantsWAW.code






--populate customvariant displayname
 begin tran
  update  a
  set a.DisplayName = b.displayname
  from customvariants a
  join (select distinct code, Displayname from variants) b
    on a.customSku = b.code
rollback tran
commit tran




*/


------------String out the manufacturer and Model # attributes, since a variant can have many of each, so the above pivot does not respect that.
------------There is probable a better way to do this above.. but.. eh

	drop table if exists #temp_Mfg_attr_agg
	drop table if exists #temp_modelno_attr_agg

  select distinct code, 
				Manufacturer = STRING_AGG(value,';') 
  into #temp_Mfg_attr_agg
  from ( select distinct Variants.code, AttributeKeys.[key], [AttributeValues].value
		  from Variants 
		  join AttributeKeys on variants.variantid = attributekeys.variantid
		  join [AttributeValues] on [AttributeValues].AttributeKeyId = AttributeKeys.AttributeKeyId
		  where AttributeKeys.[key] = 'Manufacturer') temp_Mfg_attr
  group by code

  select distinct code, 
		Modelno = STRING_AGG(value,';') 
  into #temp_modelno_attr_agg
  from (select distinct Variants.code, AttributeKeys.[key], [AttributeValues].value
		  from Variants 
		  join AttributeKeys on variants.variantid = attributekeys.variantid
		  join [AttributeValues] on [AttributeValues].AttributeKeyId = AttributeKeys.AttributeKeyId
		  where AttributeKeys.[key] = 'Model #') temp_modelno_attr
  group by code


select distinct 
				ItemVariantCode = temp_variantsFull.[Code],
				--ItemCustomPrintColors =  isnull(CustomPrintColors_inriver.PrintXML, ''),
				--ItemDisplayName = temp_variantsFull.[DisplayName],
				--ItemCSIDisplayName = isnull(temp_variantsFull.[DisplayName], ''),
				--ItemWAWDisplayName = isnull(temp_variantsFull.WAWDisplayName, ''),
				--ItemStatus = 'New', 
				--ItemManufacturer = dbo.[RemoveNonAlphaCharacters]([varmanufacturer]),
				ItemMinimumOrderQTY = cast(isnull(temp_variantsFull.[MinQuantity], 1) as int),
				ItemMaximumOrderQuantity = '9999',
				ItemWeightAttribute = isnull(temp_variantsFull.Weight, ''),
				--ItemSellingMultiple = [SellingMultiple],
				--ItemWeight = [varweight],
				--ItemSellingUOM = temp_variantsFull.[SellingUOM],
				--ItemPackageUOM = temp_variantsFull.[SellingUOM],
				--ItemPriceFamily = [PriceFamily],
				--ItemTaxCategory = isnull([TaxCategory], ''),
				--ItemStockStatus = [StockStatus],
				--ItemIsDiscontinued = CASE WHEN [isDiscontinued] = 1 THEN 'TRUE' else 'FALSE'end,
				ItemCSICategory = isnull(temp_variantsFull.Category, ''),
				ItemWAWCategory = isnull(temp_variantsFull.WAWCategory, ''),	
				ItemCustomVariantCode = Coalesce(CustomOptionVar.CustomSku,CustomOnlyVar.CustomSku, ''),
				ItemCustomCSIDisplayName = Coalesce(CustomOptionVar.DisplayName,CustomOnlyVar.DisplayName, ''),
				ItemCustomWAWDisplayName = Coalesce(CustomOptionVar.DisplayName,CustomOnlyVar.DisplayName, ''),
				ItemCustomSetupCode = Coalesce(CustomOptionVar.PlateCharge,CustomOnlyVar.PlateCharge, ''),--isnull(temp_variantsFull.[CustomSetupCode], ''),
				ItemCustomInkCode = Coalesce(CustomOptionVar.InkChargeSku,CustomOnlyVar.InkChargeSku, ''), --isnull(temp_variantsFull.[CustomInkCode], ''),
				--ItemBrandCode = isnull([BrandCode], ''),
				ItemCustomPrintSubtitle = Coalesce(CustomOptionVar.Subtitle,CustomOnlyVar.Subtitle, ''), -- isnull(temp_variantsFull.[CustomPrintSubtitle], ''),
				itemCustomMinOrderQty = cast(Coalesce(CustomOptionVar.MinQOrderQty,CustomOnlyVar.MinQOrderQty, 0) as int), --isnull(customvar1.[MinQuantity], 0) as int),
				ItemHasTwoInkOptions = CASE WHEN Coalesce(CustomOptionVar.HasSecondInkColor,CustomOnlyVar.HasSecondInkColor, '') = '' then '' when Coalesce(CustomOptionVar.HasSecondInkColor,CustomOnlyVar.HasSecondInkColor, '') = 1 THEN 'TRUE' else 'FALSE'end,
				ItemPrinter = isnull([Printer],''),
				ItemTex = isnull([Tex],''),
				ItemFrontPrint = isnull([Front Print],''),
			    ItemExtendableHandle = isnull([Extendable Handle],''),
				ItemSliderStyle = isnull(dbo.[RemoveNonAlphaCharacters]([Slider Style]),''),
				ItemGallon = isnull([Gallon],''),
				ItemHangerHole = CASE WHEN  [Hanger Hole] is null then '' when [Hanger Hole] = 'Yes' THEN 'TRUE' else 'FALSE'end,
				ItemHoses = isnull([Hoses],''),
				ItemStrap =  case when [Strap] is null then '' when [Strap] = 'Yes' THEN 'TRUE' else 'FALSE'end,
				ItemFinish = isnull([Finish],''),
				ItemGusset = isnull([Gusset],''),
				ItemCompartments = isnull([Compartments],''),
				ItemUse = isnull([Use],''),
				ItemMeasurement = isnull([Measurement],''),
				ItemColorPopular = CASE WHEN [ColorPopular] is null then '' when [ColorPopular] = 'Yes' THEN 'TRUE' else 'FALSE'end,
				ItemNumber = isnull([Number],''),
				ItemQuantity = isnull([Quantity],''),
				ItemMaterialAttribute = isnull([Material],''),
				--ItemMaterialSpec = isnull(cleaners_cat.dbo.[RemoveNonAlphaCharacters]([Material]),''),
				ItemPartType = isnull([Part Type],''),
				ItemCSIDesign = isnull([Design],''),
				ItemWAWDesign = isnull([WAWDesign],''),
				ItemBristleLength = isnull([Bristle Length],''),
				ItemLoopStyle = isnull([Loop Style],''),
				ItemBackPrint =  CASE WHEN [Back Print] is null then '' when [Back Print] = 'Yes' THEN 'TRUE' else 'FALSE'end,
				--[Standard],
				ItemHeaderStyle = isnull([Header Style],''),
				ItemMachine = isnull([Machine],''),
				ItemSpoolAmount = isnull([Spool Amount],''),
				ItemColorGroup = isnull(dbo.[RemoveNonAlphaCharacters]([Color Group]),''),
				ItemSelectStyle = isnull([Select Style],''),
				ItemLoopSpacing = isnull([Loop Spacing],''),
				ItemAuthor = isnull([Author],''),
				ItemMeltingTemperature = isnull([Melting Temperature],''),
				ItemSeries = isnull([Series],''),
				ItemThickness = isnull([Thickness],''),
				ItemTeethSize = isnull(dbo.[RemoveNonAlphaCharacters]([Teeth Size]),''),
				ItemMaterialType = isnull([Material Type],''),
				ItemOz = isnull([Oz.],''),
				ItemCSIStyle = isnull([Style],''),
				ItemWAWStyle = isnull(WAWStyle,''),
			    ItemCounterDisplay = isnull([Counter Display],''),
				ItemBrandAttr = isnull([BrandCSI],''),
				ItemWAWBrand = isnull(BrandWAW, ''),
				--ItemBrandSpec = isnull(cleaners_cat.dbo.[RemoveNonAlphaCharacters]([Brand]),''),
				--ItemDimensions = '',
				ItemVoltageWatts = isnull([Voltage & Watts],''),
				ItemColor = isnull([Color],''),
				ItemPressureGauge = isnull([Pressure Gauge],''),
				ItemLotSeries = isnull([Lot Series],''),
				ItemLength = isnull([Length],''),
				ItemProductStyle = isnull([Product Style],''),
				ItemCSIProductType = isnull(temp_variantsFull.CSIProductType,''),
				ItemWAWProductType = isnull(temp_variantsFull.WAWProductType,''),
				ItemDiameter = isnull([Diameter],''),
				ItemSize = isnull([Size],''),
				ItemPocket = isnull([Pocket],''),
				--ItemModel = isnull([Model #],''),
				ItemZipper = CASE WHEN [Zipper] is null then '' when [Zipper] = 'Yes' THEN 'TRUE' else 'FALSE'end,
				ItemPsi = isnull([PSI],''),
				ItemTagNumber = isnull([Tag Number],''),
				ItemManufacturerName = isnull([Manufacturer Name],''),
				--[Pad Type],
				--ItemType = isnull(temp_variantsFull.Type, ''),
				ItemSpacing = isnull([Spacing],''),
				ItemNeedleSystem = isnull([Needle System],''),
				ItemPart = isnull(dbo.[RemoveNonAlphaCharacters]([Part]),''),
				ItemShape = isnull([Shape],''),
				ItemColorHex = isnull([ColorHex],''),
				ItemProduct = isnull([Product],''),
				--ProductCode = isnull(products.code, ''),

				ItemModel = isnull(#temp_modelno_attr_agg.Modelno,''),
				ItemManufacturer = isnull(#temp_Mfg_attr_agg.Manufacturer,''),
				CSIAdBlockName = 'CSIAdBlockName',
				WAWAdBlockName= 'WAWAdBlockName',
				CSIPriceBoxName = 'CSIPriceBoxName',
				WAWPriceBoxName = 'WAWPriceBoxName',
				ProductDetails = 'ProductDetails'


from temp_variantsFull 
 left join (SELECT BaseSku
				  ,CustomSku
				  ,InkChargeSku
				  ,PlateCharge
				  ,HasSecondInkColor
				  ,Subtitle
				  ,AdditionalLeadTime
				  ,MinQOrderQty
				  ,DisplayName
			  FROM customvariants
			  where BaseSku != CustomSku) CustomOptionVar
	   on temp_variantsFull.Code = CustomOptionVar.BaseSku
left join (SELECT BaseSku
				  ,CustomSku
				  ,InkChargeSku
				  ,PlateCharge
				  ,HasSecondInkColor
				  ,Subtitle
				  ,AdditionalLeadTime
				  ,MinQOrderQty
				  ,DisplayName
			  FROM customvariants
			  where BaseSku = CustomSku) CustomOnlyVar
	   on temp_variantsFull.Code = CustomOnlyVar.BaseSku
	left join Variants customvar1 on CustomOptionVar.CustomSku = customvar1.Code

	left join #temp_Mfg_attr_agg on temp_variantsFull.code = #temp_Mfg_attr_agg.code
	left join #temp_modelno_attr_agg on temp_variantsFull.code = #temp_modelno_attr_agg.code
 where  temp_variantsFull.[Code] not in (SELECT CustomSku
									   FROM customvariants
									  where BaseSku != CustomSku)

  --and isnull(temp_variantsFull.Weight, '') != ''
order by temp_variantsFull.code asc



