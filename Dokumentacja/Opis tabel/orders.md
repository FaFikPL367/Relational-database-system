# Kategoria Orders

## Tabela **Categories**
Zawiera informacje dotyczące kategorii
możliwych do zamówienia usług (produktów):
- **CategoryID** [int] — klucz główny, identyfikator kategorii
- **Name** [nvarchar(15)] - nazwa kategorii:
	- 'Course' - kurs
	- 'Meeting' - pojedyncze spotkanie studyjne z przedmiotu
	- 'Studies' - studia
	- 'Webinar' - webinar
	- 'Reunion' - pojedynczy zjazd na studiach
```SQL
CREATE TABLE Categories (
   CategoryID int  NOT NULL IDENTITY(1, 1),
   Name nvarchar(15)  NOT NULL CHECK (Name IN ('Course', 'Meeting', 'Studies', 'Webinar', 'Reunion')),
   CONSTRAINT Categories_pk PRIMARY KEY  (CategoryID)
);
```

## <hr>
## Tabela **Orders**
Zawiera informacje dotyczące zamówień złożonych przez użytkowników:
- **OrderID** [int] — klucz główny, identyfikator zamówienia
- **UserID** [int] — identyfikator użytkownika składającego zamówienie
- **OrderDate** [date] — data złożenia zamówienia w formacie 'rok-miesiąc-dzień'
- **PaymentLink** [nvarchar(100)] - link do płatności
```SQL
CREATE TABLE Orders (
   OrderID int  NOT NULL IDENTITY(1, 1),
   UserID int  NOT NULL,
   OrderDate date  NOT NULL,
   PaymentLink nvarchar(100)  NOT NULL,
   CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);
```

## <hr>
## Tabela **Orders_Details**
Zawiera informacje szczegółowe dotyczące danego zamówienia
oraz jego zamówień składowych:
- **SubOrderID** [int] — klucz główny, identyfikator zamówienia składowego
- **OrderID** [int] - identyfikator zamówienia
- **PaymentDeadline** [date] — termin, do którego trzeba dokonać płatności w formacie 'rok-miesiąc-dzień'
- **ExtendedPaymentDeadline** [date] — odroczony termin, do którego trzeba dokonać płatności w formacie 'rok-miesiąc-dzień' (jeśli jest podany,
to musi być późniejszy od poprzedniego terminu płatności)
- **PaymentDate** [date] — data dokonania płatności za dane zamówienie składowe w formacie 'rok-miesiąc-dzień'
- **FullPrice** [money] - pełna cena za dany produkt
- **ProductID** [int] — identyfikator zamawianego produktu
- **Payment** [money] — wartość, jaka została zapłacona za dany produkt np. za wpisowa na kurs czy studia
```SQL
CREATE TABLE Orders_Details (
   SubOrderID int  NOT NULL IDENTITY(1, 1),
   OrderID int  NOT NULL,
   PaymentDeadline date  NOT NULL,
   ExtendedPaymentDeadline date  NULL,
   PaymentDate date  NULL,
   FullPrice money  NOT NULL CHECK (FullPrice >= 0),
   ProductID int  NOT NULL,
   Payment money  NULL CHECK (Payment >= 0),
   CONSTRAINT Orders_Details_pk PRIMARY KEY  (SubOrderID)
);
```

## <hr>
## Tabela **Products**
Zawiera informacje o dostępnych produktach (usługach):
- **ProductID** [int] — klucz główny, identyfikator produktu
- **CategoryID** [int] - identyfikator kategorii produktu
- **Status** [bit] — informacje czy dany produkt jest dostępny dla użytkowników
```SQL
CREATE TABLE Products (
   ProductID int  NOT NULL IDENTITY(1, 1),
   CategoryID int  NOT NULL,
   Status bit  NOT NULL DEFAULT 0,
   CONSTRAINT Products_pk PRIMARY KEY  (ProductID)
);
```

## <hr>
## Tabela **Payment_for_reunions**
Zawiera ona informacje o płatnościach użytkowników za zjazdy, jeżeli zapisali się na jakieś studia:
- **SubOrderID** [int] — identyfikator podzamówienia
- **ReunionID** [int] — identyfikator zjazdu, za który jest wnoszona płatność
- **PaymentDeadline** [date] - ostateczna data zapłaty za zjazd
- **PaymentDate** [date] — faktyczna data zapłaty za zjazd
- **IsPaid** [bit] — wartość oznaczająca czy dany użytkownik zapłacił za dany zjazd

```SQL
CREATE TABLE Payment_for_reunions (
   SubOrderID int  NOT NULL,
   ReunionID int  NOT NULL,
   PaymentDeadline date  NOT NULL,
   PaymentDate date  NULL,
   IsPaid bit  NULL,
   CONSTRAINT Payment_for_reunions_pk PRIMARY KEY  (ReunionID,SubOrderID)
);
```
