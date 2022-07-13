---------------------------------------------------
-- Finding total numbers of all approved PPP loans.
---------------------------------------------------

Select 
	COUNT (distinct OriginatingLender) NumberOfLenders,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(InitialApprovalAmount), 2) AmountApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize
From [SBASQLProject].[dbo].[sba_public_data]



------------------------------------------------------------
-- Comparing 2020 to 2021 numbers of all approved PPP loans.
------------------------------------------------------------

Select 
	YEAR(DateApproved) YearApproved,
	COUNT (distinct OriginatingLender) NumberOfLenders,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(InitialApprovalAmount), 2) AmountApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize
From [SBASQLProject].[dbo].[sba_public_data]
Where YEAR(DateApproved) = 2020
Group by YEAR(DateApproved)

Union

Select 
	YEAR(DateApproved) YearApproved,
	COUNT (distinct OriginatingLender) NumberOfLenders,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(InitialApprovalAmount), 2) AmountApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize
From [SBASQLProject].[dbo].[sba_public_data]
Where YEAR(DateApproved) = 2021
Group by YEAR(DateApproved)



---------------------------------------------------------------------
-- Finding the top lenders by total approved amount in 2020 and 2021.
---------------------------------------------------------------------

-- 2020
Select top 20
	OriginatingLender,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(InitialApprovalAmount), 2) AmountApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize
From [SBASQLProject].[dbo].[sba_public_data]
Where YEAR(DateApproved) = 2020
Group by OriginatingLender
Order by 3 desc

-- 2021
Select top 20
	OriginatingLender,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(InitialApprovalAmount), 2) AmountApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize
From [SBASQLProject].[dbo].[sba_public_data]
Where YEAR(DateApproved) = 2021
Group by OriginatingLender
Order by 3 desc



-------------------------------------------------------------------
-- Finding top industries that received PPP loans in 2020 and 2021.
-------------------------------------------------------------------

-- 2020
Select top 20 
	nscd.Sector,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(InitialApprovalAmount), 2) AmountApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize
From [SBASQLProject].[dbo].[sba_public_data] pd
	Inner Join [dbo].[sba_naics_sector_codes_description] nscd
		on Left(pd.NAICSCode, 2) = nscd.LookupCodes
Where YEAR(DateApproved) = 2020
Group by nscd.Sector
Order by 3 desc

-- 2021
Select top 20 
	nscd.Sector,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(InitialApprovalAmount), 2) AmountApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize
From [SBASQLProject].[dbo].[sba_public_data] pd
	Inner Join [dbo].[sba_naics_sector_codes_description] nscd
		on Left(pd.NAICSCode, 2) = nscd.LookupCodes
Where YEAR(DateApproved) = 2021
Group by nscd.Sector
Order by 3 desc



---------------------------------------------------------------------------------
-- Adding the percentage of the total approved amount from each industry in 2021.
---------------------------------------------------------------------------------

;With CTE as
(
Select top 20 
	nscd.Sector,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize,
	Round(SUM(InitialApprovalAmount), 2) AmountApproved
From [SBASQLProject].[dbo].[sba_public_data] pd
	Inner Join [dbo].[sba_naics_sector_codes_description] nscd
		on Left(pd.NAICSCode, 2) = nscd.LookupCodes
Where YEAR(DateApproved) = 2020
Group by nscd.Sector
)
Select 
	Sector, 
	NumberOfLoansApproved, 
	AverageLoanSize,
	AmountApproved, 
	Round(100 * (AmountApproved/SUM(AmountApproved) OVER()), 3) PercentageOfTotal
From CTE
Order by 4 desc



--------------------------------------------------------------------
-- Finding how many loans have been fully forgiven in 2020 and 2021.
--------------------------------------------------------------------

-- 2020
Select 
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(CurrentApprovalAmount), 2) CurrentAmountApproved,
	Round(AVG(CurrentApprovalAmount), 2) CurrentAverageLoanSize,
	Round(SUM(ForgivenessAmount), 2) AmountForgiven,
	Round(100 * (SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount)), 3) PercentageForgiven
From [SBASQLProject].[dbo].[sba_public_data] 
Where YEAR(DateApproved) = 2020

-- 2021
Select 
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(CurrentApprovalAmount), 2) CurrentAmountApproved,
	Round(AVG(CurrentApprovalAmount), 2) CurrentAverageLoanSize,
	Round(SUM(ForgivenessAmount), 2) AmountForgiven,
	Round(100 * (SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount)), 3) PercentageForgiven
From [SBASQLProject].[dbo].[sba_public_data] 
Where YEAR(DateApproved) = 2021



-------------------------------------------------------
-- Finding the months with the highest amount approved.
-------------------------------------------------------

Select top 10
	YEAR(DateApproved) YearApproved,
	MONTH(DateApproved) MonthApproved,
	COUNT(LoanNumber) NumberOfLoansApproved,
	Round(SUM(InitialApprovalAmount), 2) TotalAmountApproved,
	Round(AVG(InitialApprovalAmount), 2) AverageLoanSize
From [SBASQLProject].[dbo].[sba_public_data]
Group by 
	YEAR(DateApproved),
	MONTH(DateApproved)
Order by 4 desc