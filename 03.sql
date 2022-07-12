/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 4: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Brandan Tyler Lasley
                DATE:      5/1/2014 22:19

*******************************************************************************************
*/

USE FiredUp    -- ensures correct database is active


GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and table names; you should also put each projected column on its own line
and use indentation for neatness.  Example:

   SELECT Name,
          CustomerID
   FROM   CUSTOMER
   WHERE  CustomerID < 106;

All SQL statements should end in a semicolon.  Whatever format you choose for your queries, make
sure that it is readable and consistent.' + CHAR(10)
PRINT 'Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS2275, Lab Week 4, Question 1  [3pts possible]:
Show the employee ID number, name, and title for all employees; list them in alphabetical order by job title.
Format all columns using CAST, CONVERT, and/or STR, and rename the columns (try to make the output look 
well-formatted by shortening the column widths).' + CHAR(10)
	Select STR(EmpID, 1) AS "ID:",
		   CONVERT(VARCHAR(15), Name) AS "Name:",
		   CAST(title as VARCHAR(15)) AS "Title:"
	From EMPLOYEE
	Order by title ASC;
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 2  [3pts possible]:
Show the invoice number and total price from the INVOICE table for all of the invoices for customer number 125.
List them in order of invoice date, and rename the columns using AS.' + CHAR(10)
	Select InvoiceNBR AS "#", -- Not very helpful... but it works.
		   TotalPrice AS "$"
	From INVOICE
	WHERE FK_CustomerID = 125
	Order By InvoiceDT ASC; 
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 3  [3pts possible]:
Show the employee ID number and name for only the first three employees (the ones with the three lowest ID numbers). 
Hint: use TOP while sorting by ID number.  Format all columns using CAST, CONVERT, and/or STRING, and rename the 
columns using AS.' + CHAR(10)
	Select TOP 3 
		CAST(EmpID AS VARCHAR(1)) AS "#",
		CAST(Name AS VARCHAR(12)) AS "Name"
	From EMPLOYEE;
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 4  [3pts possible]:
Select the part number and cost for the three parts with the lowest cost value; use TOP...WITH TIES.  How many 
values are returned?  Why?  (answer with a PRINT statement or in comments)' + CHAR(10)
	Select TOP 3 WITH TIES
		PartNBR,
		Cost
	From PART
	ORDER BY [Cost] ASC;
GO
PRINT CHAR(10) + 'Because Cost 0.44 is a duplicate!' + CHAR(10)

GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 5  [3pts possible]:
Select the Line number and quantity from the PO_LINE_ITEM table; use CONVERT to change the quantity into 
CHAR format, and rename the value "CHARQTY".  Sort the results by "CHARQTY".  Do you see anything wrong with 
the output?  What is it?  (answer with a PRINT statement or in comments)' + CHAR(10)
	Select LineNbr,
		   CONVERT(CHAR, Quantity) AS "CHARATY"
	From PO_LINE_ITEM;
GO
PRINT CHAR(10) + 'No... it looks perfectly fine. It didnt convert it to ACSII which I thought it would.' + CHAR(10)

GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 6  [3pts possible]:
Show the name, street address, and city/state/ZIP code for all customers who live in Oregon.  Combine 
city, state, and ZIP code into a single line in this format:

  "Portland, OR 97201"

...and rename this column City/State/ZIP (exactly this name! there is a way to do it).' + CHAR(10)
	Select Name, 
		   StreetAddress,
		   CONCAT(City + ', ',
		   StateProvince + ' ', 
		   ZipCode) AS 'City/State/ZIP'
	from CUSTOMER
	WHERE StateProvince = 'OR';
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 7  [3pts possible]:
For each row in the REPAIR_LINE_ITEM table, show the repair number, line number, and values of ExtendedPrice
and "Labor Charge" added together (rename this value to TotalCharge).  Sort results in descending order by TotalCharge.' + CHAR(10)
	Select FK_RepairNbr, 
		   CONCAT(LineNbr, 
		   ExtendedPrice,
		   [Labor Charge]) AS 'TotalCharge'
	From REPAIR_LINE_ITEM
	Order By 'TotalCharge';
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 8  [3pts possible]:
For all STOVE_REPAIR records, show the repair number, stove number, repair description, and repair date.
Order the data chronologically by repair date (most recent first), and display the date in this 
format: MM/DD/YYYY.  Format the output to be readable (i.e. to fit neatly into a page).' + CHAR(10)
	Select RepairNbr,
		   FK_StoveNbr,
		   CONVERT(VARCHAR(8), RepairDt, 1)
		   [Description], 
		   Cost, 
		   FK_CustomerID,
		   FK_EmpID
	From STOVE_REPAIR
	Order by RepairDT ASC;
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 9  [3pts possible]:
For all INVOICE rows which have a TotalPrice value between $100 and $200 (inclusive), show the invoice number,
total price, and employee number.  Order the output by invoice number.  Format all three columns using STR; 
display the cost as money (i.e. use two decimal places for cents, and put a dollar sign before it; e.g. $12.54).' + CHAR(10)

	Select InvoiceNbr,
		   InvoiceDt, 
		   CONCAT('$', STR(TotalPrice,9,2)) AS 'TotalPrice',
		   FK_CustomerID, 
		   STR(FK_EmpID, 3) as 'Fk_EmpID'
	From INVOICE 
	WHERE TotalPrice Between 100 and 300
	Order By InvoiceNbr; 

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 4, Question 10  [3pts possible]:
Show the repair number, description, and cost of the most expensive STOVE_REPAIR entry (i.e. the line with the highest
Cost value).  Limit your results to only this record (Hint: use TOP).  Format output to be readable.' + CHAR(10)
	Select TOP 1  RepairNbr, 
		   [Description],
		   Cost
	From STOVE_REPAIR;
GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 4' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


