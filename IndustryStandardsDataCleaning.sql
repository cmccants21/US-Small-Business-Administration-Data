----------------------------------------------------------------
-- Separating the Industry Description data into the sector code
-- and the sector while putting the results into a table.
----------------------------------------------------------------

Select *
into sba_naics_sector_codes_description
from(
	SELECT	[NAICS_Industry_Description],
		iif([NAICS_Industry_Description] like '%–%', substring([NAICS_Industry_Description], 8, 2 ), '') LookupCodes,
		iif([NAICS_Industry_Description] like '%–%', ltrim(substring([NAICS_Industry_Description], CHARINDEX('–', [NAICS_Industry_Description]) + 1, LEN([NAICS_Industry_Description]))), '') Sector
		FROM [SBASQLProject].[dbo].[sba_industry_standards]
		where [NAICS_Codes] = ''
) main 
where
	LookupCodes != ''



-----------------------------------------------------------------------------
-- Filling in sector codes and updating rows with two special dash characters.
-----------------------------------------------------------------------------

SELECT [NAICS_Industry_Description]
      ,[LookupCodes]
      ,[Sector]
 FROM [SBASQLProject].[dbo].[sba_naics_sector_codes_description]
 order by LookupCodes

insert into [dbo].[sba_naics_sector_codes_description]
values 
	('Sector 31 – 33 – Manufacturing', 32, 'Manufacturing'), 
	('Sector 31 – 33 – Manufacturing', 33, 'Manufacturing'), 
	('Sector 44 - 45 – Retail Trade', 45, 'Retail Trade'),
	('Sector 48 - 49 – Transportation and Warehousing', 49, 'Transportation and Warehousing')

update [dbo].[sba_naics_sector_codes_description]
set Sector = 'Manufacturing'
where LookupCodes = 31



