# Kategoria Orders
---

## Categories
---
Zawiera informacje dotyczące kategorii możliwych do zamówienia usług (produktów):
- CategoryID [int] - klucz główny, identyfikator kategorii
- Name [nvarchar(15)] - nazwa kategorii 


```
CREATE TABLE Categories (
   CategoryID int  NOT NULL,
   Name nvarchar(15)  NOT NULL CHECK (Name IN ('Course', 'Meeting', 'Studies', 'Subject', 'Webinar')),
   CONSTRAINT Categories_pk PRIMARY KEY  (CategoryID)
);
```
---

## Orders
---
Zawiera informacje dotyczące zamówień złożonych przez użytkowników:
- OrderID [int] - klucz główny, identyfikator zamówienia
- UserID [int] - identyfikator użytkownika składającego zamówienie
- OrderDate [date] - data złożenia zamówienia
- PaymentLink [nvarchar(100)] - link do płatności

```
CREATE TABLE Orders (
   OrderID int  NOT NULL,
   UserID int  NOT NULL,
   OrderDate date  NOT NULL,
   PaymentLink nvarchar(100)  NOT NULL,
   CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);
```
---

## Orders_Details
---
Zawiera informacje szczegółowe dotyczące danego zamówienia
oraz jego zamówień składowych:
- SubOrderID [int] - klucz główny, identyfikator zamówienia składowego
- OrderID [int] - identyfikator zamówienia
- PaymentDeadline [date] - termin płatności
- ExtendedPaymentDeadline [date] - odroczony termin płatności
- PaymentDate [date] - data dokonania płatności za dane zamówienie składowe
- Price [money] - wpłacona kwota
- ProductID [int] - identyfikator zamawianego produktu

```
CREATE TABLE Orders_Details (
   SubOrderID int  NOT NULL,
   OrderID int  NOT NULL,
   PaymentDeadline date  NOT NULL,
   ExtendedPaymentDeadline date  NULL CHECK (ExtendedPaymentDeadline > PaymentDeadline),
   PaymentDate date  NULL,
   Price money  NOT NULL CHECK (Price > 0),
   ProductID int  NOT NULL,
   CONSTRAINT Orders_Details_pk PRIMARY KEY  (SubOrderID)
);
```
---

## Products
---
Zawiera informacje o dostępnych produktach (usługach):
- ProductID [int] - klucz główny, identyfikator produktu
- CategoryID [int] - identyfikator kategorii produktu

```
CREATE TABLE Products (
   ProductID int  NOT NULL,
   CategoryID int  NOT NULL,
   CONSTRAINT Products_pk PRIMARY KEY  (ProductID)
);
```
