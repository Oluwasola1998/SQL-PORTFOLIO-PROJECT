-- 1. Retrieve Employee Job Title and Rate for Employee who are single.
SELECT* FROM HumanResources.Employee;
SELECT* FROM HumanResources.EmployeePayHistory;
SELECT HE.JobTitle, HP.Rate, HE.MaritalStatus
FROM HumanResources.Employee AS HE
INNER JOIN HumanResources.EmployeePayHistory AS HP
ON HE.BusinessEntityID = HP.BusinessEntityID
WHERE MaritalStatus = 's';

--2. Retrieve the order detaiils(Product ID, Order quantity, Unit price) along with the order date and customer ID for all sales order.
SELECT* FROM Sales.SalesOrderDetail;
SELECT* FROM Sales.SalesOrderHeader;
SELECT SOD.ProductID, SOD.OrderQty, SOD.UnitPrice, SOH.OrderDate, SOH.CustomerID
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
ON SOD.SalesOrderID = SOH.SalesOrderID;

--3.Retrieve the BusinessEntityID, CreditCardID and CardType for individuals who have vista and distinguish cardtype.
SELECT* FROM Sales.CreditCard;
SELECT* FROM Sales.PersonCreditCard;
SELECT PCC.BusinessEntityID, PCC.CreditCardID, CC.CardType
FROM Sales.PersonCreditCard AS PCC
INNER JOIN Sales.CreditCard AS CC
ON PCC.CreditCardID = CC.CreditCardID
WHERE CC.CardType IN ('Vista','Distinguish');

--4. Retrieves the total sales amount for each custommer who has placed order, those with total sales less than 7,000
SELECT* FROM Sales.Customer;
SELECT* FROM Sales.SalesOrderHeader;
SELECT SC.CustomerID, SUM(SOH.TotalDue) AS SUM_SALES
FROM Sales.Customer AS SC
INNER JOIN Sales.SalesOrderHeader AS SOH
ON SC.CustomerID = SOH.CustomerID
GROUP BY SC.CustomerID
HAVING SUM(SOH.TotalDue) < 7000;

--5. Retrieve the PurchasrOrderID, ProductID, OrderQty, StockedQty, OrderDate and ShipDate
SELECT* FROM Purchasing.PurchaseOrderDetail;
SELECT* FROM Purchasing.PurchaseOrderHeader;
SELECT POD.PurchaseOrderID, POD.ProductID, POD.OrderQty, POD.StockedQty, POH.OrderDate, POH.ShipDate
FROM Purchasing.PurchaseOrderDetail AS POD
INNER JOIN Purchasing.PurchaseOrderHeader AS POH
ON POD.PurchaseOrderID = POH.PurchaseOrderID;

--6. Retrieve the ProductID, ProductPhotoID and LargePhoto
SELECT* FROM Production.ProductPhoto;
SELECT* FROM Production.ProductProductPhoto;
SELECT PPP.ProductID, PPP.ProductPhotoID, PP.LargePhoto
FROM Production.ProductProductPhoto AS PPP
INNER JOIN Production.ProductPhoto AS PP
ON PPP.ProductPhotoID = PP.ProductPhotoID;

--7. Retrieve all persons including those who do not have a phone number types
SELECT* FROM Person.Person;
SELECT* FROM Person.PersonPhone;
SELECT* FROM Person.PhoneNumberType;
SELECT P.BusinessEntityID, P.FirstName, P.LastName, PP.PhoneNumber
FROM Person.Person AS P
LEFT JOIN Person.PersonPhone AS PP
ON P.BusinessEntityID = PP.BusinessEntityID
LEFT JOIN Person.PhoneNumberType AS PNT
ON PP.PhoneNumberTypeID = PNT.PhoneNumberTypeID;

--8. Retrieve employees with Male Gender and Married, including those who do not have pay history, along with their vacation hours and pay history details.
SELECT* FROM HumanResources.Employee;
SELECT* FROM HumanResources.EmployeeDepartmentHistory;
SELECT* FROM HumanResources.EmployeePayHistory;
SELECT E.BusinessEntityID, E.Gender, E.MaritalStatus, E.VacationHours, EPH.PayFrequency
FROM HumanResources.Employee AS E
LEFT JOIN HumanResources.EmployeePayHistory AS EPH
ON E.BusinessEntityID = EPH.BusinessEntityID
WHERE E.Gender = 'F' AND E.MaritalStatus = 'M';

--9. Retrieve the JobCandidate IDs and resume of candidates who were eventually hires as employees
SELECT* FROM HumanResources.JobCandidate;
SELECT* FROM HumanResources.Employee;
-- INNER QUERY
SELECT JC.JobCandidateID, JC.Resume
FROM HumanResources.JobCandidate AS JC;
-- OUTER QUERY
SELECT JC.JobCandidateID, JC.Resume
FROM HumanResources.JobCandidate AS JC
WHERE JC.BusinessEntityID IN (SELECT E.BusinessEntityID FROM HumanResources.Employee AS E);

--10. Retrieve the product IDs and names of products that  have a standard cost greater than the average standard cost of products in the 'bikes' category.
SELECT* FROM Production.Product;
SELECT* FROM Production.ProductCategory;
SELECT* FROM Production.ProductCostHistory;
-- INNER QUERY
SELECT P.ProductID, P.Name
FROM Production.Product AS P;
-- OUTER QUERY
SELECT P.ProductID, P.Name
FROM Production.Product AS P
WHERE P.StandardCost > (SELECT AVG(P.StandardCost)
FROM Production.Product AS P
INNER JOIN Production.ProductCategory AS PC
ON P.ProductSubcategoryID = PC.ProductCategoryID
INNER JOIN Production.ProductCostHistory AS PCH
ON PC.ProductCategoryID = PC.ProductCategoryID
WHERE PC.Name = 'Bikes');

--11. Retrieve the product IDs and names of products that have been scheduled for production and have a specific operation with a scheduled start date in the future
SELECT* FROM Production.WorkOrder;
SELECT* FROM Production.Product;
SELECT* FROM Production.WorkOrderRouting;
--INNER QUERY
SELECT P.ProductID, P.Name
FROM Production.Product AS P;
--OUTER QUERY
SELECT P.ProductID, P.Name
FROM Production.Product AS P
WHERE P.ProductID IN (SELECT WO.ProductID
                      FROM Production.WorkOrder AS WO
					  INNER JOIN Production.WorkOrderRouting AS WOR
					  ON WO.WorkOrderID = WOR.WorkOrderID
					  WHERE WOR.ScheduledStartDate > '2011-01-01' );

--12. Retrieve the business entity IDs and job titles of employees who have worked in the department with ID 1 and have a salaried flag of 1
-- soerted in ascending order by business entity ID
SELECT* FROM HumanResources.Employee;
SELECT* FROM HumanResources.EmployeeDepartmentHistory;
--INNER QUERY
SELECT E.BusinessEntityID, E.JobTitle
FROM HumanResources.Employee AS E;
--OUTER QUERY
SELECT E.BusinessEntityID, E.JobTitle
FROM HumanResources.Employee AS E
WHERE E.BusinessEntityID IN (SELECT EDH.BusinessEntityID 
                             FROM HumanResources.EmployeeDepartmentHistory AS EDH
							 WHERE EDH.DepartmentID = 1)
							 AND E.SalariedFlag = 1
							 ORDER BY E.BusinessEntityID ASC;

--13. Find the number of employees who hold the title of Design Engineer and Production supervisor, along with Vacation hours less than 55
SELECT* FROM HumanResources.Employee;
--INNER QUERY
SELECT COUNT(JobTitle) AS JTitle
FROM HumanResources.Employee AS E
WHERE E.VacationHours < 55 AND E.JobTitle IN ('Design Engineer', 'Production Supervisor');
--OUTER QUERY
SELECT COUNT(JobTitle) AS JTitle
FROM HumanResources.Employee AS E
WHERE E.BusinessEntityID IN (SELECT BusinessEntityID 
                             FROM HumanResources.Employee
							 WHERE JobTitle IN ('Design Engineer', 'Production Supervisor') 
							 AND VacationHours < 55 );

--14. Find the sales order IDs and customer IDs of sales orders that have a total due amount greater than the total due amount of sales order ID 43659.
SELECT* FROM Sales.SalesOrderHeader;
--INNER QUERY
SELECT SalesOrderID, CustomerID
FROM Sales.SalesOrderHeader;
--OUTER QUERY
SELECT SalesOrderID, CustomerID
FROM Sales.SalesOrderHeader
WHERE TotalDue > (SELECT TotalDue FROM Sales.SalesOrderHeader
                  WHERE SalesOrderID = 43659 );

--15. Retreive the product ID and names of products that are in the same product category as product id 770.
SELECT* FROM Production.ProductSubcategory;
SELECT* FROM Production.Product;
SELECT P.ProductID, P.Name
FROM Production.Product AS P
WHERE P.ProductSubcategoryID IN (SELECT PS.ProductSubcategoryID
                                 FROM Production.ProductSubcategory AS PS
								 WHERE P.ProductID = 770 );

