/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 8: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Brandan Tyler Lasley
                DATE:      5/30/2014 19:27

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
PRINT 'CIS2275, Lab Week 8, Question 1  [3pts possible]:
Show the customer ID number, name, and email address for all customers; order the list by ID number.  You will 
need to join the CUSTOMER table with the EMAIL table to do this (either implicit or explicit syntax is ok); 
include duplicates for customers with multiple email accounts.  Format all output using CAST, CONVERT and/or STR ' + CHAR(10)

	Select	STR(CustomerID, 3) AS Cust#,
			CONVERT(VARCHAR(32), Name) AS Name,
			CONVERT(VARCHAR(32), EMailAddress) As Electronic_mail
	From CUSTOMER, EMAIL 
	WHERE FK_CustomerID = CustomerID
	Order By CustomerID;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 2  [3pts possible]:
Which stoves have been sold?  Project serial number, type, version, and color from the STOVE table; join with the 
INV_LINE_ITEM table to identify the stoves which have been sold.  Concatenate type and version to a single column 
with this format: "Firedup v.1".  Eliminate duplicate lines.  List in order by serial number, and format all output.' + CHAR(10)

	Select DISTINCT	CONVERT(INT, SerialNumber) AS SerialNumber,
			CONVERT(VARCHAR(20), (Type + 'v.' + Version)) AS 'Type/Version',
			CONVERT(VARCHAR(10), Color) AS Color
	From STOVE, INV_LINE_ITEM
	WHERE SerialNumber = FK_StoveNbr
	Order by SerialNumber;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 3  [3pts possible]:
For every invoice, show the invoice number, the name of the customer, and the name of the employee.  You will need to
join the INVOICE table with EMPLOYEE and CUSTOMER using the appropriate join conditions.  Show the results in ascending
order of invoice number.' + CHAR(10)

	Select	INV.InvoiceNbr,
			CUST.Name,  
			EMP.Name
	From CUSTOMER AS CUST, EMPLOYEE AS EMP, INVOICE AS INV
	WHERE INV.FK_CustomerID = CUST.CustomerID AND INV.FK_EmpID = EMP.EmpID
	Order By INV.InvoiceNbr ASC;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 4  [3pts possible]:
List all stove repairs; show the repair number, description, and the total cost of the repair.  You will need to 
join with the REPAIR_LINE_ITEM TABLE and add up the values of ExtendedPrice using SUM. ' + CHAR(10)

	Select RepairNbr, 
			Description, 
			SUM(ExtendedPrice) AS '$'
	From Stove_Repair, REPAIR_LINE_ITEM
	WHERE RepairNbr = FK_RepairNbr
	Group By RepairNbr, Description;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 5  [3pts possible]:
Show the name of every employee along with the total number of stove repairs performed by them
(this may be zero - be sure to show every employee!).  You will need to perform an outer join on
EMPLOYEE and STOVE_REPAIR.  Sort the results in descending order by the number of repairs.' + CHAR(10)


	Select	Name,
			Count(RepairNbr) AS '# of Repairs'
	From Employee LEFT OUTER JOIN STOVE_REPAIR 
	ON EmpID = FK_EmpID
	Group By Name
	Order By Count(RepairNbr) DESC;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 6  [3pts possible]:
Which sales were made in May of 2002? Display the invoice number, invoice date, and stove number (if any).
Use BETWEEN to specify the date range and list in chronological order by invoice date.' + CHAR(10)

	--Select	InvoiceNbr,
	--		InvoiceDT,
	--		FK_StoveNbr
	--From INVOICE, INV_LINE_ITEM
	--WHERE (DATEPART(month, InvoiceDT) = 5 AND DATEPART(year, InvoiceDt) = '2002') AND FK_InvoiceNbr = InvoiceNbr
	--Order By InvoiceDt;
	-- That works, but I didn't read I needed to use BETWEEN

	Select	InvoiceNbr,
			InvoiceDT,
			FK_StoveNbr
	From INVOICE, INV_LINE_ITEM
	WHERE (InvoiceDt BETWEEN '20020501' AND '20020601') AND FK_InvoiceNbr = InvoiceNbr
	Order By InvoiceDt;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 7  [3pts possible]:
Show a list of all states from the CUSTOMER table; for each, display the state, the total 
number of customers in that state, and the total number of suppliers there.  Include all
states from CUSTOMER even if they have no suppliers.  Order results by state.' + CHAR(10)

	Select	StateProvince,
			Count(StateProvince) + Count(State)
	From CUSTOMER LEFT OUTER JOIN SUPPLIER
	ON StateProvince = State
	Group By StateProvince
	Order By StateProvince;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 8  [3pts possible]:
Display a list of all stove repairs; for each, show the customer name, address, city/state/zip code (concatenated 
these last three into a single readable column), the repair date, and a description of the repair.  Order by 
repair date, and format all output.  Use an alias for the table names, and apply the alias to the beginning of 
the columns projected; e.g.:

SELECT t.COLUMN1
FROM   TABLENAME AS t
WHERE  t.COLUMN2 = 10;' + CHAR(10)

	Select	CT.Name,
			CT.StreetAddress,
			(CT.City + ', ' + CT.StateProvince + ' ' + CT.ZipCode),
			SR.RepairDt,
			SR.Description
	From STOVE_REPAIR AS SR, CUSTOMER AS CT
	WHERE CT.CustomerID = SR.FK_CustomerID;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 9  [3pts possible]:
Show a list of each supplier, along with a cash total of the extended price for all of their purchase orders. 
Display the supplier name and price total; sort alphabetically by supplier name and show the total in money 
format (i.e. $ and two decimal places ); rename the columns using AS.  Hint: you will need to join three tables,
use GROUP BY, and SUM(). ' + CHAR(10)

	Select	Name,
			SUM(ExtendedPrice) as '$'
	From SUPPLIER, PURCHASE_ORDER, PO_LINE_ITEM
	WHERE FK_SupplierNbr = SupplierNbr AND PONbr = FK_PONbr
	Group By Name
	Order By Name;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 10  [3pts possible]:
For each invoice, show the total cost of all parts; this is calculated by multiplying the invoice Quantity by the 
Cost for the part.   Show the invoice number and total cost (one line per invoice!).  Format all output (show 
money appropriately).' + CHAR(10)

	Select DISTINCT	CONVERT(INT, InvoiceNbr) AS 'INVOICE#', 
					ROUND(SUM(CONVERT(FlOAT(3), (Quantity * Cost))), 2) AS '$'
	From INVOICE, INV_LINE_ITEM, PART
	WHERE InvoiceNbr = FK_InvoiceNbr AND FK_PartNbr = PartNbr
	Group By InvoiceNbr;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 11  [3pts possible]:
Show the customer id, name, and the total of invoice extended price values for all customers who live in Oregon 
(exclude all others!).  Your output should include only one line for each customer.  Sort by customer ID.' + CHAR(10)

	Select	CustomerID,
			Name,
			SUM(ExtendedPrice) AS '$'
	From Customer, INVOICE, INV_LINE_ITEM
	WHERE StateProvince = 'OR' AND FK_CustomerID = CustomerID AND FK_InvoiceNbr = InvoiceNbr
	Group By CustomerID, Name
	Order By CustomerID;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 12  [3pts possible]:
For every invoice, display the invoice number, customer name, phone number, and email address.  Include duplicates 
where more than one email address or phone number exists.  List in order of customer name; format all output.' + CHAR(10)

	Select InvoiceNbr, Name, PhoneNbr, EMailAddress
	From Customer AS A, INVOICE AS B, EMAIL AS C, PHONE AS D
	WHERE (B.FK_CustomerID = A.CustomerID) AND (C.FK_CustomerID = A.CustomerID) AND (D.FK_CustomerID = A.CustomerID)
	Group By InvoiceNbr, Name, PhoneNbr, EMailAddress
	Order By EMailAddress; 

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 13  [3pts possible]:
For every stove repair, display the stove serial number, Type and Version, the Cost of the repair, the Price of the
stove, and the percentage of the Price which the repair actually cost (i.e. Cost divided by Price).  Try to display
this last value as a whole number with a percentage sign (%).' + CHAR(10)

	Select	B.SerialNumber, 
			Type, 
			Version, 
			Cost, 
			ExtendedPrice,
			(CONVERT(INT, ((Cost/ExtendedPrice)*100))) AS '%'
	From Stove_Repair AS A, Stove AS B, INV_LINE_ITEM AS C
	Where A.FK_StoveNbr = B.SerialNumber AND C.FK_StoveNbr = B.SerialNumber;

	-- Not possible with INT, unless I do another conversion out of INT, but that seems like unnecessary work just for a %

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 14  [3pts possible]:
For every part, display the part number, description, the total number of repairs involving this part, the total
Quantity of the part for those repairs (use SUM), the total number of invoices involving this part, and the total
Quantity of the part for those invoices.  Use OUTER JOINs to display information for all parts, even if they are not
involved with any repairs or invoices.  You can solve this using only three tables (but be sure to avoid duplicates in
your counts!)...  Sort the output by part number.' + CHAR(10)

	Select	A.PartNbr,
			A.Description, 
			Count(DISTINCT C.RepairNbr), 
			SUM(A.PartNbr), 
			SUM(B.Quantity), 
			Count(DISTINCT B.LineNBR)
	From Part AS A, REPAIR_LINE_ITEM AS B, STOVE_REPAIR AS C 
	WHERE A.PartNbr = B.FK_PartNbr AND B.FK_RepairNbr = C.RepairNbr
	Group By A.PartNbr, A.Description
	Order By A.PartNbr;
	-- This one was complex and I dont have enough sleep to follow it, may fix. 

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 15  [3pts possible]:
Which invoices have involved parts whose name contains the words "widget" or "whatsit" (anywhere within the 
string)?  Display the invoice number and invoice date; sort output by invoice number.' + CHAR(10)

	Select InvoiceNbr, 
			InvoiceDt
	From INVOICE, INV_LINE_ITEM, PART
	WHERE (InvoiceNbr = FK_InvoiceNbr) AND (FK_PartNbr = PartNbr) AND (Description LIKE '%Widget%' OR  Description LIKE '%Whatsit%')
	Order By InvoiceNbr;

GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 8' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


