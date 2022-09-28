
drop table if exists #Cleaners_Clearance_items;
drop table if exists #WAW_Clearance_items;

/*Get the items that are categorized in clearance (in any of the tax groups) for Cleaners*/
SELECT distinct [New EPI Product] ProductID
	into #Cleaners_Clearance_items
FROM [Cleaners].[dbo].[CategoryNodeFile]
where [New EPI Product] is not null
	and (
		isnull([CSI L1] , '') = 'Clearance'
		or isnull([ALT CSI L1] , '') = 'Clearance'
		or isnull([ALT 1 CSI L1] , '') = 'Clearance'
		or isnull([ALT 3 CSI L1] , '') = 'Clearance'
		or isnull([ALT 4 CSI L1] , '') = 'Clearance');


/*Get the items that are categorized in clearance (in any of the tax groups) for Wawak*/
SELECT distinct [New EPI Product] ProductID
	into #WAW_Clearance_items
FROM [Cleaners].[dbo].[CategoryNodeFile]
where [New EPI Product] is not null
	and (
		isnull([WAW L1] , '') = 'Clearance'
		or isnull([Alt 1 WAW L1] , '') = 'Clearance'
		or isnull([Alt 2 WAW L1] , '') = 'Clearance'
		or isnull([Alt 3 WAW L1] , '') = 'Clearance'
		or isnull([Alt 4 WAW L1] , '') = 'Clearance'
		or isnull([Alt 5 WAW L1] , '') = 'Clearance');





with Nodes_Cleaned as (
select distinct [New EPI Product] as  Product_id                 
,      CSI_Tax1_L1 = case isnull([CSI L1] , '')       when 'Clearance' Then '' else isnull([CSI L1] , '') end  
,      CSI_Tax1_L2 = case isnull([CSI L1] , '')       when 'Clearance' Then '' else isnull([CSI L2] , '') end  
,      CSI_Tax1_L3 = case isnull([CSI L1] , '')       when 'Clearance' Then '' else isnull([CSI L3] , '') end  
,      CSI_Tax2_L1 = case isnull([ALT CSI L1] , '')   when 'Clearance' Then '' else isnull([ALT CSI L1] , '') end  
,      CSI_Tax2_L2 = case isnull([ALT CSI L1] , '')   when 'Clearance' Then '' else isnull([ALT CSI L2] , '') end  
,      CSI_Tax2_L3 = case isnull([ALT CSI L1] , '')   when 'Clearance' Then '' else isnull([ALT CSI L3] , '') end  
,      CSI_Tax3_L1 = case isnull([ALT 1 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 1 CSI L1] , '') end  
,      CSI_Tax3_L2 = case isnull([ALT 1 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 1 CSI L2] , '') end  
,      CSI_Tax3_L3 = case isnull([ALT 1 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 1 CSI L3] , '') end  
,      CSI_Tax4_L1 = case isnull([ALT 3 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 3 CSI L1] , '') end  
,      CSI_Tax4_L2 = case isnull([ALT 3 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 3 CSI L2] , '') end  
,      CSI_Tax4_L3 = case isnull([ALT 3 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 3 CSI L3] , '') end  
,      CSI_Tax5_L1 = case isnull([ALT 4 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 4 CSI L1] , '') end  
,      CSI_Tax5_L2 = case isnull([ALT 4 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 4 CSI L2] , '') end  
,      CSI_Tax5_L3 = case isnull([ALT 4 CSI L1], '')  when 'Clearance' Then '' else isnull([ALT 4 CSI L3] , '') end  
,      WAW_Tax1_L1 = case isnull([WAW L1] , '')		  when 'Thread' Then '' when 'Clearance' Then '' else isnull([WAW L1] , '') end    
,      WAW_Tax1_L2 = case isnull([WAW L1] , '')		  when 'Thread' Then '' when 'Clearance' Then '' else isnull([WAW L2] , '') end 
,      WAW_Tax1_L3 = case isnull([WAW L1] , '')		  when 'Thread' Then '' when 'Clearance' Then '' else isnull([WAW L3] , '') end   
,      WAW_Tax2_L1 = case isnull([Alt 1 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 1 WAW L1], '') end
,      WAW_Tax2_L2 = case isnull([Alt 1 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 1 WAW L2], '') end
,      WAW_Tax2_L3 = case isnull([Alt 1 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 1 WAW L3], '') end
,      WAW_Tax3_L1 = case isnull([Alt 2 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 2 WAW L1], '') end
,      WAW_Tax3_L2 = case isnull([Alt 2 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 2 WAW L2], '') end
,      WAW_Tax3_L3 = case isnull([Alt 2 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 2 WAW L3], '') end
,      WAW_Tax4_L1 = case isnull([Alt 3 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 3 WAW L1], '') end
,      WAW_Tax4_L2 = case isnull([Alt 3 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 3 WAW L2], '') end
,      WAW_Tax4_L3 = case isnull([Alt 3 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 3 WAW L3], '') end
,	   WAW_Tax5_L1 = case isnull([Alt 4 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 4 WAW L1], '') end
,	   WAW_Tax5_L2 = case isnull([Alt 4 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 4 WAW L2], '') end
,	   WAW_Tax5_L3 = case isnull([Alt 4 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 4 WAW L3], '') end
,	   WAW_Tax6_L1 = case isnull([Alt 5 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 5 WAW L1], '') end
,	   WAW_Tax6_L2 = case isnull([Alt 5 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 5 WAW L2], '') end
,	   WAW_Tax6_L3 = case isnull([Alt 5 WAW L1] , '') when 'Thread' Then '' when 'Clearance' Then '' else isnull([Alt 5 WAW L3], '') end
from [dbo].[CategoryNodeFile]
where [New EPI Product] is not null
) 
 

 
 select Product_id
		,      CSI_Tax1_L1 = left(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax1_L1), '    ', ''),'   ',''),'  ',''),' ',''), 64)
		,      CSI_Tax1_L2 = case  when CSI_Tax1_L2 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax1_L1), '    ', ''),'   ',''),'  ',''),' ','') 
									           ,replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax1_L2), '    ', ''),'   ',''),'  ',''),' ','')),64)
								   else ''
							end
		,      CSI_Tax1_L3= case  when CSI_Tax1_L3 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax1_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax1_L2), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax1_L3), '    ', ''),'   ',''),'  ',''),' ','')),64)
								   else ''
							end
		,      CSI_Tax2_L1 = left(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax2_L1), '    ', ''),'   ',''),'  ',''),' ',''), 64)
		,      CSI_Tax2_L2 = case  when CSI_Tax2_L2 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax2_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax2_L2), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      CSI_Tax2_L3= case  when CSI_Tax2_L3 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax2_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax2_L2), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax2_L3), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      CSI_Tax3_L1 = left(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax3_L1), '    ', ''),'   ',''),'  ',''),' ',''), 64)
		,      CSI_Tax3_L2 = case  when CSI_Tax3_L2 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax3_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax3_L2), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      CSI_Tax3_L3= case  when CSI_Tax3_L3 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax3_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax3_L2), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax3_L3), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      CSI_Tax4_L1 =  case when #Cleaners_Clearance_items.ProductID is null then 
									left(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax4_L1), '    ', ''),'   ',''),'  ',''),' ',''), 64)
							    else 'Clearance'
							  end
		,      CSI_Tax4_L2 =  case when #Cleaners_Clearance_items.ProductID is null then
									(case  when CSI_Tax4_L2 != '' then 
											left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax4_L1), '    ', ''),'   ',''),'  ',''),' ','')
											, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax4_L2), '    ', ''),'   ',''),'  ',''),' ','')), 64)
										   else ''
									end)
								else ''
							  end
		,      CSI_Tax4_L3= case when #Cleaners_Clearance_items.ProductID is null then
									(case  when CSI_Tax4_L3 != '' then 
										left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax4_L1), '    ', ''),'   ',''),'  ',''),' ','')
										, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax4_L2), '    ', ''),'   ',''),'  ',''),' ','')
										, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax4_L3), '    ', ''),'   ',''),'  ',''),' ','')), 64)
									   else ''
									end)
								else ''
							  end
		--,CSI_Clearance = case when #Cleaners_Clearance_items.ProductID is null then '' else 'Clearance' end
		--,      CSI_Tax5_L1 = replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax5_L1), '    ', ''),'   ',''),'  ',''),' ','')
		--,      CSI_Tax5_L2 = case  when CSI_Tax5_L2 != '' then 
		--							CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax5_L1), '    ', ''),'   ',''),'  ',''),' ','')
		--							, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax5_L2), '    ', ''),'   ',''),'  ',''),' ',''))
		--						   else ''
		--					end
		--,      CSI_Tax5_L3= case  when CSI_Tax5_L3 != '' then 
		--							CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax5_L1), '    ', ''),'   ',''),'  ',''),' ','')
		--							, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax5_L2), '    ', ''),'   ',''),'  ',''),' ','')
		--							, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(CSI_Tax5_L3), '    ', ''),'   ',''),'  ',''),' ',''))
		--						   else ''
		--					end
		,      WAW_Tax1_L1 = left(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax1_L1), '    ', ''),'   ',''),'  ',''),' ',''), 64)
		,      WAW_Tax1_L2 = case  when WAW_Tax1_L2 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax1_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax1_L2), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      WAW_Tax1_L3= case  when WAW_Tax1_L3 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax1_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax1_L2), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax1_L3), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      WAW_Tax2_L1 = left(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax2_L1), '    ', ''),'   ',''),'  ',''),' ',''), 64)
		,      WAW_Tax2_L2 = case  when WAW_Tax2_L2 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax2_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax2_L2), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      WAW_Tax2_L3= case  when WAW_Tax2_L3 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax2_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax2_L2), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax2_L3), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      WAW_Tax3_L1 = left(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax3_L1), '    ', ''),'   ',''),'  ',''),' ',''), 64)
		,      WAW_Tax3_L2 = case  when WAW_Tax3_L2 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax3_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax3_L2), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      WAW_Tax3_L3= case  when WAW_Tax3_L3 != '' then 
									left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax3_L1), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax3_L2), '    ', ''),'   ',''),'  ',''),' ','')
									, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax3_L3), '    ', ''),'   ',''),'  ',''),' ','')), 64)
								   else ''
							end
		,      WAW_Tax4_L1 = case when #WAW_Clearance_items.ProductID is null then 
									left(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax4_L1), '    ', ''),'   ',''),'  ',''),' ',''), 64)
								    else 'Clearance' 
							 end
		,      WAW_Tax4_L2 = case when #WAW_Clearance_items.ProductID is null then
									(case  when WAW_Tax4_L2 != '' then 
											left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax4_L1), '    ', ''),'   ',''),'  ',''),' ','')
											, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax4_L2), '    ', ''),'   ',''),'  ',''),' ','')), 64)
										   else ''
									end)
								else '' 
							end
		,      WAW_Tax4_L3 = case when #WAW_Clearance_items.ProductID is null then
									(case  when WAW_Tax4_L3 != '' then 
											left(CONCAT(replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax4_L1), '    ', ''),'   ',''),'  ',''),' ','')
											, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax4_L2), '    ', ''),'   ',''),'  ',''),' ','')
											, replace(replace(replace(replace(Cleaners.dbo.RemoveNonAlphaCharacters(WAW_Tax4_L3), '    ', ''),'   ',''),'  ',''),' ','')), 64)
										   else ''
									end)
							    else  ''
							 end
		--,WAW_Clearance = case when #WAW_Clearance_items.ProductID is null then '' else 'Clearance' end

		--,	   WAW_Tax5_L1
		--,	   WAW_Tax5_L2
		--,	   WAW_Tax5_L3
		--,	   WAW_Tax6_L1
		--,	   WAW_Tax6_L2
		--,	   WAW_Tax6_L3
		from Nodes_Cleaned
		left join #Cleaners_Clearance_items on Nodes_Cleaned.Product_id = #Cleaners_Clearance_items.ProductID
		left join #WAW_Clearance_items on Nodes_Cleaned.Product_id = #WAW_Clearance_items.ProductID
