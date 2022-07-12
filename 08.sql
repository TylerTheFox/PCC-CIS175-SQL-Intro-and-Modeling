/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 9: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Brandan Tyler Lasley
                DATE:      6/5/2014 11:39

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
PRINT 'CIS2275, Lab Week 9, Question 1  [3pts possible]:
Show the serial numbers of all the "FiredAlways" stoves which have been invoiced.  Use whichever method you prefer 
(a join or a subquery).  List in order of serial number and eliminate duplicates.' + CHAR(10)

	Select SerialNumber 
	From STOVE 
	WHERE SerialNumber IN (	Select DISTINCT FK_StoveNbr 
							From INV_LINE_ITEM 
						   )
					   AND Type = 'FiredAlways'
	Order By SerialNumber;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 2  [3pts possible]:
Show the name and email address of all customers who have ever brought a stove in for repair (include duplicates and 
ignore customers without email addresses). ' + CHAR(10)

	Select	Name, 
			EmailAddress
	From Email JOIN CUSTOMER ON FK_CustomerID = CustomerID
	WHERE CustomerID IN (	Select FK_CustomerID 
							From INVOICE WHERE FK_CustomerID = CustomerID
						);

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 3  [3pts possible]:
What stoves have been sold to customers with the last name of "Smith"?  Display the customer name, stove number, stove 
type, and stove version and show the results in customer name order.' + CHAR(10)

	Select	Name,
			SerialNumber,
			Type,
			Version 
	From Customer, INVOICE, INV_LINE_ITEM, STOVE  
	WHERE Name LIKE '%Smith' AND CustomerID = FK_CustomerID AND FK_InvoiceNbr = InvoiceNbr AND SerialNumber = FK_StoveNbr
	Order By Name ASC;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 4  [3pts possible]:
What employee has sold the most stoves in the most popular state?  ("most popular state" means the state or states for 
customers who purchased the most stoves, regardless of the stove type and version; do not hardcode a specific state 
into your query)  Display the employee number, employee name, the name of the most popular state, and the number of 
stoves sold by the employee in that state.  If there is more than one employee then display them all.' + CHAR(10)

	Select TOP 1	EmpID,
					EMPLOYEE.Name,
					StateProvince
	From CUSTOMER, INVOICE, EMPLOYEE
	WHERE EmpID = FK_EmpID AND FK_CustomerID = CustomerID
	Group By EMPLOYEE.Name, StateProvince, StateProvince, EmpID
	Order by Count(StateProvince) DESC;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 5  [3pts possible]:
Identify all the sales associates who have ever sold the FiredAlways version 1 stove; show a breakdown of the total 
number sold by color.  i.e. for each line, show the employee name, the stove color, and the total number sold.  Sort 
the results by name, then color.' + CHAR(10)

	Select	Name,
			Color,
			Count(Color) AS '#'
	From EMPLOYEE, STOVE
	WHERE EmpID = STOVE.FK_EmpId AND Version = 1 AND Type = 'FiredAlways'
	Group By Name, Color
	Order By Name, Color;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 6  [3pts possible]:
Show the name and phone number for all customers who have a Hotmail address (i.e. an entry in the EMAIL table which 
ends in hotmail.com).  Include duplicate names where multiple phone numbers exist; sort results by customer name.' + CHAR(10)

	Select	Name, 
			PhoneNbr
	From Customer, EMAIL, PHONE
	WHERE PHONE.FK_CustomerID = CustomerID AND EMAIL.FK_CustomerID = CustomerID AND EMailAddress LIKE '%@hotmail.com'
	-- Well, at least it isn't AIM right? 

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 7  [3pts possible]:
Show the purchase order number, average SalesPrice, and average ExtendedPrice for parts priced between $1 and $2 which 
were ordered from suppliers in Virginia.  List in descending order of average ExtendedPrice.  Format all output. ' + CHAR(10)

	Select	STR(PONbr) AS PONbr,
			ROUND(AVG(SalesPrice), 2) AS 'AVG Sales Price',
			ROUND(AVG(ExtendedPrice), 2) AS 'AVG Extended Price'
	From SUPPLIER, PURCHASE_ORDER, PO_LINE_ITEM, PART
	WHERE PartNbr = Fk_PartNbr AND FK_PONbr = PONbr AND FK_SupplierNbr = SupplierNbr AND SalesPrice BETWEEN 1 AND 2 AND State = 'VA'
	Group By PONbr
	Order By AVG(ExtendedPrice) DESC;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 8  [3pts possible]:
Which invoice has the second-lowest total price among invoices that do not include a sale of a FiredAlways stove? 
Display the invoice number, invoice date, and invoice total price.  If there is more than one invoice then display all 
of them. (Note: finding invoices that do not include a FiredAlways stove is NOT the same as finding invoices where a 
line item contains something other than a FiredAlways stove -- invoices have more than one line.  Avoid a JOIN with the 
STOVE since the lowest price may not involve any stove sales.)' + CHAR(10)

	SELECT TOP 1 WITH TIES
		   InvoiceNbr AS 'Invoice Number',
		   InvoiceDt AS 'Invoice Date',
		   TotalPrice AS 'Invoice Total Price'
	FROM (SELECT TOP 2 WITH TIES
				 InvoiceNbr ,
				 InvoiceDT ,
				 TotalPrice 
		  FROM INVOICE
		  WHERE InvoiceNbr NOT IN (SELECT FK_InvoiceNbr
								   FROM INV_LINE_ITEM
								   WHERE FK_StoveNbr IN (SELECT serialnumber
														 FROM STOVE
														WHERE type = 'FiredAlways'))
		  ORDER BY TotalPrice ASC) as MYTABLE
	ORDER BY 'Invoice Total Price' DESC;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 9  [3pts possible]:
What employee(s) have sold the most stoves in the least popular color ("least popular color" means the color that has 
been purchased the least number of times, regardless of the stove type and version. Do not hardcode a specific color 
into your query)?  If there is more than one employee tied for the most then display them all.  If there is a tie for 
"least popular color" then you may pick ANY of them.  Display the employee name, number of stoves sold, and the least 
popular color.' + CHAR(10)

	Select TOP 1	Name,
					Count(S.FK_EmpId),
					Color
	From INVOICE AS I, EMPLOYEE AS E, STOVE AS S, INV_LINE_ITEM AS ILI
	WHERE EmpID = S.FK_EmpId AND ILI.FK_StoveNbr = S.SerialNumber AND ILI.FK_InvoiceNbr = I.InvoiceNbr
	Group By Name, Color
	Order By Count(Color) ASC;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 10  [3pts possible]:
Show a breakdown of all part entries in invoices.  For each invoice, show the customer name, invoice number, the number 
of invoice lines for parts (exclude stoves!), the total number of parts for the invoice (add up Quantity), and the total 
ExtendedPrice values for these parts.  Format all output; sort by customer name, then invoice number. ' + CHAR(10)

	Select	CONVERT(VARCHAR(20), Name) AS 'Name',
			CONVERT(INT, InvoiceNbr) AS 'Invoice Number',
			Count(LineNbr) AS 'Line Number'
	From CUSTOMER, INVOICE, INV_LINE_ITEM, PART
	WHERE CustomerID = FK_CustomerID AND InvoiceNBR = FK_InvoiceNbr AND PartNbr = FK_PartNbr AND FK_StoveNbr IS NULL
	Group By Name, InvoiceNbr
	Order By Name, InvoiceNbr;

GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 9' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


