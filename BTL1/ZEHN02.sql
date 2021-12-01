--==========================May ZEHN02========================================--

-- Login as sysdba and create user and grant privilege
CREATE USER zehn_02 IDENTIFIED BY 123456;
GRANT CONNECT, DBA to zehn_02;

--==========================CREATE TABLE======================================--
CREATE TABLE zehn_02.ZEHNSTORE(
    StoreId     VARCHAR2(10),
    StoreName   NVARCHAR2(40) NOT NULL,  
    Address     NVARCHAR2(40) NOT NULL,
    
    CONSTRAINT PK_ZEHNSTORE PRIMARY KEY(StoreId)
);

CREATE TABLE zehn_02.PHARMACIST(
    PharmacistId    VARCHAR2(10),
    FullName        NVARCHAR2(30)   NOT NULL,
    Gender          NVARCHAR2(5)    NOT NULL,
    DoB             DATE            NOT NULL,
    PhoneNumber     VARCHAR2(15)    NOT NULL,
    Address         NVARCHAR2(40)   NOT NULL,
    WorkYear        NUMBER          NOT NULL,
    WorkShift       NUMBER          NOT NULL,
    StoreId         VARCHAR2(10)    NOT NULL    UNIQUE,
    
    CONSTRAINT PK_PHARMACIST PRIMARY KEY(PharmacistId)
);

CREATE TABLE zehn_02.CUSTOMER(
    PhoneNumber     VARCHAR2(15),
    FullName        VARCHAR2(30),
    Gender          VARCHAR2(5),
    DoB             DATE,
    ZehnPoint       NUMBER          DEFAULT 0,
    CustomerType    VARCHAR2(15)    DEFAULT 'BasicCare',
    
    CONSTRAINT PK_CUSTOMER PRIMARY KEY(PhoneNumber)
);

CREATE TABLE zehn_02.PRODUCT(
    ProductId       VARCHAR2(10),
    ProductName     NVARCHAR2(40)   NOT NULL,
    ProductType     NVARCHAR2(30),
    ExpiredDate     DATE            NOT NULL,
    CountUnit       NVARCHAR2(10),
    Price           NUMBER          NOT NULL,
    
    CONSTRAINT PK_PRODUCT PRIMARY KEY(ProductId)
);

CREATE TABLE zehn_02.RECEIPT(
    ReceiptId       VARCHAR2(10),
    CustomerId      VARCHAR2(15)    NOT NULL    UNIQUE,
    PharmacistId    VARCHAR2(10)    NOT NULL    UNIQUE,
    StoreId         VARCHAR2(10)    NOT NULL    UNIQUE,
    PaymentTime     DATE            NOT NULL,
    Total           NUMBER          NOT NULL,
    PaymentMethod   VARCHAR(10)     DEFAULT 'Cash',
    
    CONSTRAINT PK_RECEIPT PRIMARY KEY(ReceiptId)
);

CREATE TABLE zehn_02.RECEIPTDETAIL(
    ReceiptId       VARCHAR2(10),
    ProductId       VARCHAR2(10),
    Quantity        NUMBER          DEFAULT 1,
    Price           NUMBER          NOT NULL,
    Amount          NUMBER          NOT NULL,
    
    CONSTRAINT zehn_02.PK_DETAIL PRIMARY KEY(ReceiptId, ProductId)
);
--==========================FOREIGN KEY=======================================--
ALTER TABLE zehn_02.PHARMACIST
ADD CONSTRAINT FK_PHARMARCIST_StoreId FOREIGN KEY(StoreId)
REFERENCES zehn_02.ZEHNSTORE(StoreId);

ALTER TABLE zehn_02.RECEIPT
ADD CONSTRAINT FK_RECEIPT_CustomerId FOREIGN KEY(CustomerId)
REFERENCES zehn_02.CUSTOMER(PhoneNumber);

ALTER TABLE zehn_02.RECEIPT
ADD CONSTRAINT FK_RECEIPT_StoreId FOREIGN KEY(StoreId)
REFERENCES zehn_02.ZEHNSTORE(StoreId);

ALTER TABLE zehn_02.RECEIPT
ADD CONSTRAINT FK_RECEIPT_PharmacistId FOREIGN KEY(PharmacistId)
REFERENCES zehn_02.PHARMACIST(PharmacistId);

ALTER TABLE zehn_02.RECEIPTDETAIL
ADD CONSTRAINT FK_DETAIL_ReceiptId FOREIGN KEY(ReceiptId)
REFERENCES zehn_02.RECEIPT(ReceiptId);

ALTER TABLE zehn_02.RECEIPTDETAIL
ADD CONSTRAINT FK_DETAIL_ProductId FOREIGN KEY(ProductId)
REFERENCES zehn_02.PRODUCT(ProductId);

--==========================INSERT DATA=======================================--
-- disable foreign key
ALTER TABLE zehn_02.PHARMACIST      DISABLE CONSTRAINT FK_PHARMARCIST_StoreId;
ALTER TABLE zehn_02.RECEIPT         DISABLE CONSTRAINT FK_RECEIPT_CustomerId;
ALTER TABLE zehn_02.RECEIPT         DISABLE CONSTRAINT FK_RECEIPT_StoreId;
ALTER TABLE zehn_02.RECEIPT         DISABLE CONSTRAINT FK_RECEIPT_PharmacistId;
ALTER TABLE zehn_02.RECEIPTDETAIL   DISABLE CONSTRAINT FK_DETAIL_ReceiptId;
ALTER TABLE zehn_02.RECEIPTDETAIL   DISABLE CONSTRAINT FK_DETAIL_ProductId;

-- insert data here
    -- insert data into ZEHNSTORE
INSERT INTO zehn_02.ZEHNSTORE VALUES('ZS02', 'Zehn Store Thu Duc', 'Vo Van Ngan, Thu Duc, TPHCM');

    -- insert data into PHARMACIST
    
    -- insert data into CUSTOMER
    
    -- insert data into PRODUCT
    
    -- insert data into RECEIPT
    
    -- insert data into RECEIPTDETAIL
    
    
-- enable foreign key
ALTER TABLE zehn_02.PHARMACIST      ENABLE CONSTRAINT FK_PHARMARCIST_StoreId;
ALTER TABLE zehn_02.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_CustomerId;
ALTER TABLE zehn_02.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_StoreId;
ALTER TABLE zehn_02.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_PharmacistId;
ALTER TABLE zehn_02.RECEIPTDETAIL   ENABLE CONSTRAINT FK_DETAIL_ReceiptId;
ALTER TABLE zehn_02.RECEIPTDETAIL   ENABLE CONSTRAINT FK_DETAIL_ProductId;

--==========================GRANTING PRIVILIGES===============================--

--==========================TRIGGER===========================================--
-- create or replace TRIGGER

-- test the TRIGGERs

--==========================PROCEDURE=========================================--

--==========================FUNCTION==========================================--

--==========================SELECT QUERIES====================================--

--==========================ISOLATION LEVEL===================================--

--==========================QUERY OPTIMIZER===================================--

