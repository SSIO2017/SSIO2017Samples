CREATE TABLE OrderDetails (
    OrderId int NOT NULL,
    OrderDetailId int NOT NULL,
    ProductId int NOT NULL,
    Quantity int NOT NULL,
    ReturnedDate date SPARSE NULL,
    ReturnedReason varchar(50) SPARSE NULL);