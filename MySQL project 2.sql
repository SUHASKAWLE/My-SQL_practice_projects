use northwind;

-- 1] Calculate average Unit Price for each Customer_Id.

SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;

SELECT 
	O.CUSTOMERID, AVG(AVG(OD.UNITPRICE)) OVER(PARTITION BY O.CUSTOMERID)AS AVG_UNITPRICE
FROM 
	ORDERS O INNER JOIN ORDER_DETAILS OD ON O.ORDERID=OD.ORDERID
Group by O.CUSTOMERID;


-- 2] Calculate average Unit Price for each group of CustomerId AND EmployeeId.

SELECT 
	O.CUSTOMERID,O.EMPLOYEEID,OD.UNITPRICE, AVG(OD.UNITPRICE) OVER(PARTITION BY O.CUSTOMERID ORDER BY EMPLOYEEID)AS AVG_UNIT
FROM 
	ORDERS O INNER JOIN ORDER_DETAILS OD ON O.ORDERID=OD.ORDERID
    ;


-- 3]Rank Unit Price in descending order for each CustomerId.

DROP VIEW IF EXISTS V_AVGUNITPRICE;
CREATE VIEW V_AVGUNITPRICE AS
SELECT O.CUSTOMERID, AVG(AVG(OD.UNITPRICE)) OVER(PARTITION BY O.CUSTOMERID)AS AVG_UNITPRICE
FROM ORDERS O INNER JOIN ORDER_DETAILS OD ON O.ORDERID=OD.ORDERID
Group by O.CUSTOMERID;

SELECT
	CUSTOMERID, AVG_UNITPRICE, 
	RANK() OVER (ORDER BY AVG_UNITPRICE DESC)AS RANKING 
FROM 
	V_AVGUNITPRICE;



-- 4] How can you pull the previous order date’s Quantity for each ProductId.
SELECT * FROM PRODUCTS;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;

SELECT P.PRODUCTID, OD.QUANTITY, O.ORDERDATE,
LAG(QUANTITY) OVER (PARTITION BY PRODUCTID ORDER BY ORDERDATE ) AS previous_OREDER_QUANTITY
FROM PRODUCTS P INNER JOIN ORDER_DETAILS OD ON P.PRODUCTID=OD.PRODUCTID
INNER JOIN ORDERS O ON O.ORDERID=OD.ORDERID;




-- 5] How can you pull the following order date’s Quantity for each ProductId.


SELECT P.PRODUCTID, OD.QUANTITY, O.ORDERDATE,
LEAD(QUANTITY) OVER (PARTITION BY PRODUCTID ORDER BY ORDERDATE ) AS FOLLOW_OREDER_QUANTITY
FROM PRODUCTS P INNER JOIN ORDER_DETAILS OD ON P.PRODUCTID=OD.PRODUCTID
INNER JOIN ORDERS O ON O.ORDERID=OD.ORDERID;




-- 6] Pull out the very first Quantity ever ordered for each ProductId.
WITH CTE AS
(
SELECT 
	P.PRODUCTID,ROW_NUMBER() OVER (PARTITION BY PRODUCTID)AS ORDER_NUMBER,OD.QUANTITY AS FIRST_ORDERED_QUANTITY,
    O.ORDERDATE
FROM 
	PRODUCTS P INNER JOIN ORDER_DETAILS OD ON P.PRODUCTID=OD.PRODUCTID
	INNER JOIN ORDERS O ON O.ORDERID=OD.ORDERID
)
SELECT * FROM CTE WHERE ORDER_NUMBER=1;

-- 7] Calculate a cumulative moving average UnitPrice for each CustomerId.

SELECT * FROM ORDER_DETAILS;
SELECT * FROM ORDERS;

DROP VIEW IF EXISTS V_CUMAVG;
CREATE VIEW V_CUMAVG AS
SELECT O.ORDERID,O.CUSTOMERID, OD.UNITPRICE,OD.ID
FROM ORDERS O INNER JOIN ORDER_DETAILS OD ON O.ORDERID=OD.ORDERID;

SELECT *FROM V_CUMAVG;
SELECT ORDERID, CUSTOMERID, UNITPRICE, AVG(UNITPRICE)OVER(PARTITION BY CUSTOMERID ORDER BY ID)AS CUM_AVG
FROM V_CUMAVG;



-- Q1] Can you define a trigger that is invoked automatically before a new row is inserted into a table?
## The trigger which is invoked automatically before a new row is inserted into table is BEFORE INSERT TRIGGER.
## CREATE TRIGGER trigger_name  BEFORE INSERT  ON table_name FOR EACH ROW  Trigger_body ;  


-- Q2] What are the different types of triggers?
-- In sql 3 main types of triggers are there 
##] DML TRIGGERS (CFREATE , ALTER, DROP) 
##] DML TRIIGERS (INSERT, UPDATE DELETE)
##] LOGON TRIGGERS

-- Sub types of triggers are 1]Before Triggers 2]After Triggers


-- Q3] How is Metadata expressed and structured?
## Metadata is “the data about the data.” 
## The basic building block of structural metadata is a model that describes 
## its data entities, their characteristics, and how they are related to one another.
## It holds information about:tables,columns,data types,table relationship,constraints etc.
## Types of Metadata:Technical Metadata, Business Metadata ,Descriptive Metadata


-- Q4] Explain RDS and AWS key management services.
-- RDS
## In RDS, AWS takes full responsibility for your database.
## The entire process of configuration, management, maintenance, and security is automated by AWS.
## RDS is easy to set up, cost-effective.

-- AWS KMS
## AWS Key Management Service (AWS KMS) is a managed service that makes it easy for you
## to create and control the cryptographic keys that are used to protect your data.
##  AWS Key Management Service is a useful and very beneficial service while dealing with sensitive data.
## Key Management Service is used to encrypt data in AWS.




-- Q5] What is the difference between amazon EC2 and RDS?
## In RDS, AWS takes full responsibility for your database. 
## In EC2 you have to manage manually all the operationby yourself.alter

## The entire process of configuration, management, maintenance, and security is automated by AWS.
## In EC2 allows you to hire your own database administrators.

## RDS is a highly available relational database.
## With EC2, you have to set up your database for high availability.

## RDS offers automated backups.
## With EC2, you have to take care of backup.

## RDS supports Aurora, SQL Server, MySQL, MariaDB, PostgreSQL, and Oracle.
## With EC2, you can configure any database you want.


