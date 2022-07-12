/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 7: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Brandan Tyler Lasley
                DATE:      5/23/2014 00:12

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
PRINT 'CIS2275, Lab Week 7, Question 1  [3pts possible]:
Show the invoice number and total price for all invoices which go to customers from Oregon.  Use an uncorrelated IN 
subquery to identify Oregon customers (you will not need to join any tables).  Format all output, and show in 
chronological order by invoice date. ' + CHAR(10)

	Select InvoiceNbr,
			TotalPrice
	From INVOICE 
	WHERE FK_CustomerID IN (Select CustomerID From CUSTOMER Where StateProvince = 'OR' )
	Order By InvoiceDT; 

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 2  [3pts possible]:
Display the serial number, manufacture date, and color for all FiredNow stoves which were not built by Mike Wentland. 
Do not assume that we know Mike''s employee number; use an uncorrelated NOT IN subquery to identify the correct 
employee (you will not need to join any tables).  Rename all columns, and format the date to MM/DD/YYYY.  Sort output 
in descending order by manufacture date.' + CHAR(10)

	Select SerialNumber AS 'SerialNbr', 
		   CONVERT(VARCHAR(10), DateOfManufacture, 101) AS 'DATETIME', 
		   Color AS 'COLOUR'
	From Stove 
	WHERE FK_EmpID NOT IN (Select EmpID From EMPLOYEE Where Name LIKE 'Mike%') AND Type = 'FiredNow'
	Order By DateOfManufacture DESC;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 3  [3pts possible]:
Show the invoice number, part number, and quantity for all invoices lines which are for parts which have a Cost value 
less than $1.50.  Use a correlated IN subquery to identify the parts (the correlation is not necessary, but apply it
anyway).  Format all output, and show in descending order by Quantity.    ' + CHAR(10)

	--Select FK_InvoiceNbr, 
	--	   FK_PartNbr, 
	--	   Quantity 
	--From INV_LINE_ITEM 
	--WHERE FK_InvoiceNbr IN (Select InvoiceNbr
	--						From Invoice 
	--						WHERE InvoiceNbr = FK_InvoiceNbr AND FK_PartNbr IN (Select PartNbr 
	--																		   From Part 
	--																		   WHERE Cost < 1.50) 
	--						)
	--Order By Quantity DESC;  --This works... but its completely stupid so I rewrote it. 

	Select Convert(VARCHAR(3), FK_InvoiceNbr) AS 'Invoice Number', 
		   Convert(VARCHAR(3), FK_PartNbr) AS 'Part Number', 
		   Convert(VARCHAR(1), Quantity) AS 'Quantity'
	From INV_LINE_ITEM WHERE FK_PartNbr IN ( Select PartNbr 
											 From Part 
											 WHERE Cost < 1.50 AND PartNbr = FK_PartNbr )
	Order By Quantity DESC; 

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 4  [3pts possible]:
Which customers have not returned stoves for repair?  List the customer’s name only and show the results in customer 
name order (alphabetical, A-Z).  Use the SQL keyword EXISTS (or NOT EXISTS) and a correlated subquery. ' + CHAR(10)

	Select Name
	From Customer
	WHERE NOT EXISTS (Select FK_CustomerID
					  From STOVE_REPAIR 
					  WHERE FK_CustomerID = CustomerID) 
	Order By Name;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 5  [3pts possible]:
Identify invoices which contain charges for more than one of the same part (i.e. the Quantity is greater than 1). 
Use a correlated EXISTS subquery to identify the correct entries.  For each invoice, display the invoice 
number, date, and total price.  Format all output; show date in YYYYMMDD format. ' + CHAR(10)

	Select	Convert(VARCHAR(3), InvoiceNbr) AS 'Invoice #', 
			CONVERT(VARCHAR(8), InvoiceDt, 112) AS 'Invoice DT',
			CONVERT(VARCHAR(6),TotalPrice) AS 'Total $'
	From Invoice
	WHERE EXISTS (	Select Quantity 
					From INV_LINE_ITEM 
					WHERE Quantity > 1 and FK_InvoiceNbr = InvoiceNbr
		);
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 6  [3pts possible]:
Identify the type/version (from the STOVE_TYPE table) of the stove model which has the highest Price value. 
Use an = subquery to find the correct value (you will need to ensure that your subquery returns only one column and 
only one row!).  Display the type and version together in this format: "FiredNow v1" and label the concatenated 
column Type/version.' + CHAR(10)

	Select TOP 1 (Type + 'v' + Version) AS 'Type/version'
	From Stove_Type st 
	WHERE Type = (Select DISTINCT Type 
				  From STOVE_TYPE WHERE st.Type = Type)
	Order by Price; -- I have no idea what you wanted from this question, and why it needed a subquery. 

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 7  [3pts possible]:
Show the invoice number, date, and total price for invoices which have been taken by ''Sales Associate'' employees, 
and which have sold to customers whose ZIP code begins with ''9''.  Format all output.  Use subqueries and no joins.' + CHAR(10)

	Select	CONVERT(VARCHAR(3), InvoiceNbr) AS 'Invoice #', 
			CONVERT(VARCHAR(24), InvoiceDT) AS 'Invoice DT', 
			CONVERT(VARCHAR(7), TotalPrice) AS 'Total $'
	From INVOICE 
	WHERE FK_EmpID IN (	Select EmpID 
						From Employee 
						Where Title LIKE 'Sales%' AND EmpID = FK_EmpID) AND
	FK_CustomerID IN (	Select CustomerID 
						From CUSTOMER 
						WHERE CONVERT (VARCHAR(1), ZipCode) = '9'
						);

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 8  [3pts possible]:
Show the customer ID number and name (format and rename columns) for all customers who have purchased a FiredNow 
version 1 stove.  Use only subqueries, and no joins.' + CHAR(10)

	Select	 Convert(VARCHAR(3), CustomerID) AS 'ID', 
			 Convert(VARCHAR(20),Name) AS 'Name'
	From CUSTOMER
	WHERE CustomerID IN (	Select DISTINCT FK_CustomerID 
							From INVOICE 
							WHERE InvoiceNbr IN (	Select DISTINCT FK_InvoiceNbr 
													From INV_LINE_ITEM 
													WHERE FK_StoveNbr IN (	Select SerialNumber 
																			From STOVE WHERE Type = 'FiredNow' And Version = 1 and SerialNumber = FK_StoveNbr)
																		)
												);
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 9  [3pts possible]:
Which stoves were sold to Oregon customers?  Display stove type and version of stoves involved in invoices for Oregon 
customers.  Eliminate duplicate values in your results.  Sort output on type and version.' + CHAR(10)

	Select DISTINCT	Type, 
					Version 
	From Stove 
	WHERE EXISTS (	Select SerialNumber 
							From INV_LINE_ITEM 
							WHERE SerialNumber = FK_StoveNbr AND FK_InvoiceNbr IN (	Select InvoiceNbr 
																					From INVOICE 
																					WHERE FK_CustomerID IN ( SELECT CustomerID
																											 From CUSTOMER
																											 WHERE StateProvince = 'OR'   )
																											 ) 
																				   )
	Order By Type, Version;

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 10  [3pts possible]:
Show the repair number and description for every stove repair which either (belongs to a
customer from California or Washington) or (is blue in color).  Be careful to use parentheses
to apply the correct logic!
Note that the primary key of the STOVE table (Serialnumber) corresponds to the foreign key
FK_StoveNbr in STOVE_REPAIR.' + CHAR(10)

	Select	RepairNbr,
			Description
	From STOVE_REPAIR
	WHERE FK_CustomerID IN (	Select CustomerID 
								From Customer 
								WHERE StateProvince IN ('OR', 'WA') ) OR FK_StoveNbr IN (	Select 
																							SerialNumber 
																							From STOVE WHERE Color = 'BLUE');
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 11  [3pts possible]:
Which employee(s) has all but one of their invoices written after February 15, 2002?  (Hint: "all but one after" is the 
same as saying "only one was written on or before Feb 15") Make sure that the employee also has some Invoices written 
after February 15, 2002.  (Other hint: review the use of GROUP BY with HAVING)  Display the employee name(s).' + CHAR(10)

	Select Name
	From EMPLOYEE 
	WHERE 1 = (	Select Count(InvoiceDT) 
				From INVOICE WHERE InvoiceDt <= '20020215' AND FK_EmpID = EmpID) AND 0 < (	Select Count(InvoiceDT) 
																							From INVOICE WHERE InvoiceDt >= '20020215' AND FK_EmpID = EmpID);

-- Really tired, I'm sure HAVING or GROUP BY would have made this easier, but this is what I could come up with at my current level of consciousness. 
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 12  [3pts possible]:
Show the name of the employee who has built the most expensive stove (i.e. the one with the highest price listed in 
STOVE_TYPE).  Use subqueries and no joins.' + CHAR(10)

	Select Name 
	From Employee
	WHERE EmpID IN (Select DISTINCT FK_EmpID 
					From Stove WHERE Stove.Type IN ( Select TOP 1 Type From STOVE_TYPE Order By Price DESC ) AND Stove.Version IN ( Select TOP 1 Version 
																																	From STOVE_TYPE 
																																	Order By Price DESC) 
																																   );

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 13  [3pts possible]:
Show the names of all customers who are on invoices which contain parts.  Use subqueries and no joins.' + CHAR(10)

	Select Name
	From CUSTOMER 
	WHERE CustomerID IN (Select 
						 FK_CustomerID 
						 From INVOICE
						  WHERE InvoiceNbr IN (Select FK_InvoiceNbr From INV_LINE_ITEM WHERE FK_PartNbr IS NOT NULL)
						);
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 14  [3pts possible]:
Show the purchase order number and Terms from the PURCHASE_ORDER table where the corresponding supplier''s
RepPhoneNumber is in the 541 area code.  Use subqueries and no joins.' + CHAR(10)
	Select	PONbr, 
			Terms 
	From PURCHASE_ORDER 
	WHERE FK_SupplierNbr IN (	Select SupplierNbr 
								From SUPPLIER 
								WHERE RepPhoneNumber LIKE '541%');
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 7, Question 15  [3pts possible]:
Which stove models (combination of type and version) have NEVER been purchased by customers in California?
Display the stove type and stove version.  Hint: finding stoves never sold in CA is NOT the same as finding stoves
sold outside of CA; it''s easier to identify stoves which *have* sold in CA and filter them out via a subquery.' + CHAR(10)


	Select	Type, 
			Version 
	From Stove SA 
	Where Type NOT IN (Select Type From Stove SB WHERE SA.Version != SB.Version AND SB.SerialNumber IN (Select FK_StoveNbr 
																										From INV_LINE_ITEM 
																										WHERE FK_InvoiceNbr IN (Select InvoiceNbr From INVOICE Where FK_CustomerID IN (Select CustomerID From Customer WHERE StateProvince = 'CA'))));
	-- This one got crazy real fast, This would be so much easier if STOVE_TYPE had some unique identifer. 

GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 7' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


