--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- T-SQL SAMPLE 5
--
CREATE TABLE OrderDetails (
    OrderId int NOT NULL,
    OrderDetailId int NOT NULL,
    ProductId int NOT NULL,
    Quantity int NOT NULL,
    ReturnedDate date SPARSE NULL,
    ReturnedReason varchar(50) SPARSE NULL);