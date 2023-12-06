  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [F1]
      ,[F2]
      ,[F3]
      ,[F4]
      ,[F5]
      ,[F6]
      ,[F7]
      ,[F8]
      ,[F9]
      ,[F10]
      ,[F11]
      ,[F12]
      ,[F13]
      ,[F14]
      ,[F15]
      ,[F16]
      ,[F17]
      ,[F18]
      ,[F19]
      ,[F20]
      ,[F21]
      ,[F22]
      ,[F23]
      ,[F24]
      ,[F25]
      ,[F26]
      ,[F27]
      ,[F28]
      ,[F29]
      ,[F30]
      ,[F31]
      ,[F32]
      ,[F33]
      ,[F34]
      ,[date]
      ,[F11converted]
      ,[unitprice]
  FROM [SalesDataWalmart].[dbo].[WalmartSalesData]

--Data Wrangling

EXEC sp_rename 'dbo.WalmartSalesData.F7', 'unit_price', 'COLUMN'

SELECT * 
FROM SalesDataWalmart..WalmartSalesData

EXEC sp_rename 'dbo.WalmartSalesData.F1', 'Invoice_ID', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F2', 'Branch', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F3', 'City', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F4', 'Customer_type', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F5', 'Gender', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F6', 'Product_line', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F8', 'Quantity', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F9', 'VAT', 'COLUMN'

SELECT * 
FROM SalesDataWalmart..WalmartSalesData

EXEC sp_rename 'dbo.WalmartSalesData.F10', 'Total', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F11', 'date', 'COLUMN'

ALTER TABLE dbo.WalmartSalesData
DROP COLUMN date

ALTER TABLE dbo.WalmartSalesData
DROP COLUMN F11converted

ALTER TABLE dbo.WalmartSalesData
DROP COLUMN unitprice

EXEC sp_rename 'dbo.WalmartSalesData.F12', 'Time', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F13', 'Paymet_method', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.Paymet_method', 'Payment_method', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F14', 'COGS', 'COLUMN'

SELECT * 
FROM SalesDataWalmart..WalmartSalesData

EXEC sp_rename 'dbo.WalmartSalesData.F15', 'Gross', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.Gross', 'Gross_margin_pct', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F16', 'Gross_income', 'COLUMN'

EXEC sp_rename 'dbo.WalmartSalesData.F17', 'Rating', 'COLUMN'

DELETE FROM dbo.WalmartSalesData
WHERE Invoice_ID = 'Invoice ID'

ALTER TABLE dbo.WalmartSalesData
DROP COLUMN F18

ALTER TABLE dbo.WalmartSalesData
DROP COLUMN F19, F20, F21

ALTER TABLE dbo.WalmartSalesData
DROP COLUMN F22, F23, F24, F25, F26, F27, F28, F29, F30, F31, F32, F33, F34 

--PIVOT to show total Males and Females in Branch A, B, C.

SELECT Branch, Male,Female
FROM

	(SELECT Branch, Gender, Quantity
	FROM SalesDataWalmart..WalmartSalesData) AS Src

PIVOT

(	SUM(Quantity) FOR GENDER IN (Male, Female)

) AS PVT

SELECT * 
FROM SalesDataWalmart..WalmartSalesData

--FEATURE ENGINEERING: This will generate some new columns from existing ones
--(1) Time of Day

SELECT Time,
CASE
	WHEN Time BETWEEN '1899-12-30 00:00:00.000' AND '1899-12-30 12:00:00.000' THEN 'Morning'
	WHEN Time BETWEEN '1899-12-30 12:01:00.000' AND '1899-12-30 16:00:00.000' THEN 'Afternoon'
	ELSE 'Evening'
END AS Time_of_Day
FROM dbo.WalmartSalesData

ALTER TABLE dbo.WalmartSalesData
ADD Time_of_Day VARCHAR(20);

UPDATE dbo.WalmartSalesData
SET Time_of_Day = (CASE
	WHEN Time BETWEEN '1899-12-30 00:00:00.000' AND '1899-12-30 12:00:00.000' THEN 'Morning'
	WHEN Time BETWEEN '1899-12-30 12:01:00.000' AND '1899-12-30 16:00:00.000' THEN 'Afternoon'
	ELSE 'Evening'
END);

--(2) Day_name

SELECT date, DATENAME(DW,date) AS Day_name
FROM dbo.WalmartSalesData

SELECT * 
FROM SalesDataWalmart..WalmartSalesData

ALTER TABLE DBO.WalmartSalesData
ADD Day_name VARCHAR(20)

UPDATE DBO.WalmartSalesData
SET Day_name = DATENAME(DW,date)

SELECT DATENAME(Month,date) AS Month_name
FROM DBO.WalmartSalesData

ALTER TABLE DBO.WalmartSalesData
ADD Month_name VARCHAR(20)

UPDATE DBO.WalmartSalesData
SET Month_name = DATENAME(Month,date)

--EXPLORATORY DATA ANALYSIS(EDA): It is performed to answer business questions
--(1) Generic question
--(a) How many unique cities does the data have?

SELECT City
FROM DBO.WalmartSalesData

SELECT DISTINCT City
FROM DBO.WalmartSalesData

--(b) In which city is each branch

SELECT DISTINCT Branch
FROM DBO.WalmartSalesData

SELECT DISTINCT City, Branch
FROM DBO.WalmartSalesData

--PRODUCT
--(1) How many unique product lines does the data have?
SELECT DISTINCT Product_line
FROM DBO.WalmartSalesData

SELECT COUNT(DISTINCT Product_line)
FROM DBO.WalmartSalesData

--(2) Most common payment method
SELECT * 
FROM SalesDataWalmart..WalmartSalesData

SELECT Payment_method
FROM DBO.WalmartSalesData

SELECT DISTINCT Payment_method
FROM DBO.WalmartSalesData

SELECT Payment_method, COUNT(Payment_method) AS CNT
FROM DBO.WalmartSalesData
GROUP BY Payment_method

--(3) Most Selling product line

SELECT Product_line, COUNT(Product_line) AS MSPl
FROM dbo.WalmartSalesData
GROUP BY Product_line
ORDER BY MSPl DESC

--(4) What is the Total revenue by month

SELECT Month_name AS Month
FROM dbo.WalmartSalesData

SELECT Month_name AS Month, SUM(Total) AS Total_revenue
FROM dbo.WalmartSalesData
GROUP BY Month_name
ORDER BY Total_revenue DESC

--(5) What Month had the largest COGS?

SELECT Month_name AS Month, SUM(COGS) AS COGS
FROM dbo.WalmartSalesData
GROUP BY Month_name
ORDER BY COGS DESC

--(6) What Product line had the largest revenue?

SELECT Product_line, SUM(Total) AS Largest_revenue
FROM dbo.WalmartSalesData
GROUP BY Product_line
ORDER BY Largest_revenue DESC

--(7) What City is with the largest revenue

SELECT City,SUM(Total) AS Largest_revenue
FROM dbo.WalmartSalesData
GROUP BY City
ORDER BY Largest_revenue DESC

--(8) What product line had the largest VAT?

SELECT Product_line, AVG(VAT) AS VAT
FROM DBO.WalmartSalesData
GROUP BY Product_line
ORDER BY VAT DESC

--(9) Fetch each Product Line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT * 
FROM SalesDataWalmart..WalmartSalesData

SELECT ROUND(AVG(COGS),2) AS Avg_Sales
FROM dbo.WalmartSalesData

SELECT Product_line, COGS,
CASE
	WHEN COGS > 307.59 THEN 'Good'
	ELSE 'Bad'
END
FROM dbo.WalmartSalesData

ALTER TABLE DBO.WalmartSalesData
ADD GoodBad VARCHAR(10)

EXEC sp_rename 'dbo.WalmartSalesData.GoodBad', 'Pdtline_AvgSales', 'COLUMN'

UPDATE dbo.WalmartSalesData
SET Pdtline_AvgSales = (CASE
	WHEN COGS > 307.59 THEN 'Good'
	ELSE 'Bad'
END)

--(10) Which Branch sold more products than average product sold?

SELECT Branch, SUM(COGS) AS Avg_PdtSold
FROM dbo.WalmartSalesData
GROUP BY Branch
HAVING SUM(COGS)>(SELECT AVG(COGS) FROM dbo.WalmartSalesData)
ORDER BY Avg_PdtSold DESC


--(11) What is the most common product line by gender

SELECT Gender, Product_line, COUNT(Product_line) AS MostCommonPdtline
FROM dbo.WalmartSalesData
GROUP BY Gender, Product_line

--(12) What is the average rating of each product line?

SELECT Product_line,AVG(Rating) AS AVG_Rating
FROM dbo.WalmartSalesData
GROUP BY Product_line
ORDER BY AVG_Rating DESC

--SALES
--(1) Number of sales made in each time of the day per weekend

SELECT * 
FROM SalesDataWalmart..WalmartSalesData

SELECT Time_of_day, COUNT(*) AS Total_sales
FROM WalmartSalesData
GROUP BY Time_of_Day
ORDER BY Total_sales DESC

--(2) Which of the customer types brings the most revenue?
SELECT Customer_type, SUM(Total) AS Most_revenue
FROM DBO.WalmartSalesData
GROUP BY Customer_type
ORDER BY Most_revenue DESC

--(3) Which city has the largest tax percent/VAT (Value Added Tax)?

SELECT City, SUM(VAT) AS Largest_Tax
FROM dbo.WalmartSalesData
GROUP BY City
ORDER BY Largest_Tax DESC

--(4) Which customer type pays the most in VAT?

SELECT Customer_type, SUM(VAT) AS VAT
FROM dbo.WalmartSalesData
GROUP BY Customer_type
ORDER BY VAT DESC

--CUSTOMER
--(1) How many unique customer types does the data have?

SELECT DISTINCT Customer_type
FROM dbo.WalmartSalesData

--(2) How many Unique Payment method does the data have?

SELECT DISTINCT Payment_method
FROM DBO.WalmartSalesData

--(3) What is the most common customer type?

SELECT Customer_type, COUNT(Customer_type) AS MostCommon
FROM dbo.WalmartSalesData
GROUP BY Customer_type
ORDER BY MostCommon DESC

--(4) What is the Gender of Most of the Customers?
SELECT * 
FROM SalesDataWalmart..WalmartSalesData

SELECT Gender, COUNT(Gender) AS MostGender
FROM dbo.WalmartSalesData
GROUP BY Gender
ORDER BY MostGender DESC

--(5) What is the gender distribution per branch?

SELECT Branch, Gender, COUNT(Gender) AS Distribution
FROM dbo.WalmartSalesData
GROUP BY Branch, Gender
ORDER BY Distribution

--(6) Which time of the day do customers give most ratings?
 
SELECT Time_of_day, SUM(Rating) AS MostRating
FROM DBO.WalmartSalesData
GROUP BY Time_of_Day
ORDER BY MostRating DESC

SELECT Time_of_day, AVG(Rating) AS MostRating
FROM DBO.WalmartSalesData
GROUP BY Time_of_Day
ORDER BY MostRating DESC

--(7) Which time of the day do customers give most ratings per branch?

SELECT Branch, Time_of_day, AVG(Rating) AS Rating_branch
FROM dbo.WalmartSalesData
GROUP BY Branch, Time_of_Day
ORDER BY Rating_branch DESC

--Applying PIVOT gives a vivid overview of the Time_of_day per Branch in line with the above question.

 SELECT Branch, [Morning], [Afternoon], [Evening]
 FROM
		(SELECT Branch, Time_of_day, ROUND(AVG(Rating),2) AS Rating_branch
		FROM dbo.WalmartSalesData
		GROUP BY Branch, Time_of_Day) AS SRC
PIVOT
		(SUM(Rating_branch) FOR Time_of_day IN ([Morning],[Afternoon],[Evening])
) AS PVT

--(8) Which day of the week has the best avgerage ratings?
SELECT * 
FROM SalesDataWalmart..WalmartSalesData

SELECT Day_name, ROUND(AVG(Rating),2) AS BestDayRating
FROM dbo.WalmartSalesData
GROUP BY Day_name
ORDER BY BestDayRating DESC

--(9) Which day of the week has the best average ratings per branch?

SELECT Branch, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
FROM
	(SELECT Branch, Day_name, ROUND(AVG(Rating),2) AS BestRatingWeek
	FROM dbo.WalmartSalesData
	GROUP BY Branch, Day_name) AS SRC
PIVOT
	(SUM(BestRatingWeek) FOR Day_name IN (Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday)
) PVT


















