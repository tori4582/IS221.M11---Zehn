--==========================May ZEHN02========================================--

-- Login as sysdba and create user and grant privilege
CREATE USER zehn_02 IDENTIFIED BY 123456;
GRANT CONNECT, DBA to zehn_02;

--==========================CREATE TABLE======================================--
-- Open SQL Developer, add a new connection using zehn_02
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
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

    -- insert data into ZEHNSTORE
INSERT INTO zehn_02.ZEHNSTORE VALUES('ZS02', 'Zehn Store Thu Duc', 'Vo Van Ngan, Thu Duc, TPHCM');

    -- insert data into PHARMACIST
INSERT INTO zehn_02.PHARMACIST VALUES('PH21', 'Hoàng V?n Huân Võ', 'Nam', '1984-07-21', '0795685309', 'Xã Trung Hòa, Huy?n Chiêm Hóa, Tuyên Quang', 2021, 4, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH22', 'V? Bình Minh', 'Nam', '2000-08-21', '0350385255', 'Ph??ng 4, Thành ph? ?à L?t, Lâm ??ng', 2020, 3, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH23', 'Lê Th? H??ng Lâm', 'N?', '1996-12-04', '0864954383', 'Xã Gia Tân 2, Huy?n Th?ng Nh?t, ??ng Nai', 2019, 2, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH24', 'Lê Nguy?t Lan', 'N?', '2000-12-26', '0967404755', 'Xã H?ng Vân, Huy?n A L??i, Th?a Thiên Hu?', 2021, 1, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH25', 'Nguy?n T?nh Nh?', 'N?', '1985-08-12', '0859798719', 'Xã Th? L?c, Huy?n Th? Xuân, Thanh Hóa', 2021, 2, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH26', 'Lê Duy Hoàng', 'Nam', '1993-04-11', '0826657918', 'Xã An Châu, Huy?n ?ông H?ng, Thái Bình', 2020, 3, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH27', 'Nguy?n Võ Y?n Anh', 'N?', '1984-12-13', '0842911997', 'Xã Ph? Khánh, Th? xã ??c Ph?, Qu?ng Ngãi', 2019, 4, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH28', 'Nguy?n Lê Thi?n Luân', 'Nam', '1984-12-28', '0345937568', 'Xã V?n Yên, Huy?n ??i T?, Thái Nguyên', 2019, 3, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH29', 'Võ Ph?m Bích Trâm', 'N?', '1983-06-14', '0374457491', 'Xã Chính Lý, Huy?n Lý Nhân, Hà Nam', 2021, 2, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH30', 'Lê V? Ð?c Quang', 'Nam', '1985-04-11', '0970774435', 'Xã Ph??c H?u, Huy?n C?n Giu?c, Long An', 2020, 1, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH31', 'Ngô Th?y Trinh', 'N?', '1989-02-28', '0397971758', 'Ph??ng Phúc Tân, Qu?n Hoàn Ki?m, Hà N?i', 2019, 3, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH32', 'Nguy?n V? Th? Hùng', 'Nam', '1985-03-31', '0831223362', 'Th? tr?n Hi?p Hòa, Huy?n ??c Hòa, Long An', 2021, 2, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH33', '?? Nguy?n Nh?t Lan', 'N?', '1999-01-05', '0966603606', 'Ph??ng Nh?n Phú, Thành ph? Quy Nh?n, Bình ??nh', 2021, 4, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH34', 'Nguy?n B?o Duy', 'Nam', '1989-11-03', '0361521452', 'Xã V?nh L?c, Huy?n L?c Yên, Yên Bái', 2020, 1, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH35', 'Nguy?n Hàm Duyên', 'N?', '1997-02-16', '0853139484', 'Xã Liêm Chung, Thành ph? Ph? Lý, Hà Nam', 2019, 3, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH36', 'D??ng Thu?n Toàn', 'Nam', '2001-02-15', '0840639439', 'Ph??ng Ph? Vinh, Th? xã ??c Ph?, Qu?ng Ngãi', 2019, 2, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH37', 'Ph?m Quy?t Th?ng', 'Nam', '1994-08-11', '0336011148', 'Xã An Th?nh, Huy?n B?n L?c, Long An', 2021, 4, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH38', 'Nguy?n Ph??ng Hi?n', 'N?', '1986-04-19', '0354660091', 'Xã Ngh?a An, Huy?n Ninh Giang, H?i D??ng', 2020, 4, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH39', 'Tr?n Lê H?nh Vi', 'N?', '1999-04-03', '0975807200', 'Ph??ng Quán Bàu, Thành ph? Vinh, Ngh? An', 2019, 2, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH40', 'Nguy?n Tr?n B?u Di?p', 'Nam', '1993-08-08', '0709897146', 'Xã H?ng Phong, Huy?n Cao L?c, L?ng S?n', 2021, 1, 'ZS02');  

    -- insert data into CUSTOMER
INSERT INTO zehn_02.CUSTOMER VALUES('0985367353', 'Nguy?n Tr?n Cao S?', 'Nam', '1995-04-24', 1000, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0836289221', 'Ph?m Ph??ng Nhung', 'N?', '1982-04-11', 23500, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0362974048', 'Nguy?n Tr?n Ti?n Võ', 'Nam', '1984-10-27', 1050000, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0383371705', 'Nguy?n Lê Ng?c Tr?', 'Nam', '2002-02-15', 39250, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0971820839', 'Nguy?n Hoàng Nguyên Giang', 'Nam', '1988-03-20', 75000, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0828228999', 'Lê Nh?t Th??ng', 'N?', '1981-06-20', 514000, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0854263834', 'Nguy?n Mai Thy', 'N?', '1999-09-25', 2000, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0785368107', 'Ngô Thanh Vy', 'N?', '1984-01-22', 34500, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0399988381', 'Nguy?n Tr?n Anh Kh?i', 'Nam', '1989-03-15', 800, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0864952075', 'Nguy?n V? Khánh Hoàn', 'Nam', '1997-10-03', 2300, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0333967718', 'Nguy?n Quang Danh', 'Nam', '1988-02-06', 890500, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0866070516', 'Nguy?n Ngô Thái Sang', 'Nam', '1999-09-03', 56000, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0361412774', '??ng Nguy?n Anh Minh', 'Nam', '1992-03-06', 2600, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0831730136', 'Nguy?n Tr?n Lâm Ð?ng', 'Nam', '1998-05-14', 7800, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0847900236', 'Nguy?n Lê Minh Khuê', 'N?', '1985-12-25', 9000, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0356702531', 'Hu?nh Tr?ng T??ng', 'Nam', '1985-04-17', 77200, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0355395581', 'Ph?m V?n Quang', 'Nam', '1985-07-23', 51000, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0819496910', 'Lê V?n Chí Khang', 'Nam', '1992-12-30', 0, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0861347402', 'Hu?nh Th?y Du', 'N?', '1982-05-16', 100, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0361230015', 'Nguy?n Ph?m An Bình', 'N?', '1996-09-18', 8700, 'StandardCare');  

    -- insert data into PRODUCT
INSERT INTO zehn_02.PRODUCT VALUES('PR21', 'Acuvail 4,5mg/ml', 'KD', '2022-01-26', '?ng', 7400);    
INSERT INTO zehn_02.PRODUCT VALUES('PR22', 'Amaryl Glimepiride', 'KD', '2023-09-12', 'H?p', 162000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR23', 'Alphachymotrypsin 4,2mg', 'KD', '2024-05-29', 'Viên', 800);    
INSERT INTO zehn_02.PRODUCT VALUES('PR24', 'Acyclovir', 'KD', '2022-05-05', 'H?p', 12000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR25', 'Duoplavin 75mg/100mg', 'KD', '2022-04-24', 'Viên', 23100);    
INSERT INTO zehn_02.PRODUCT VALUES('PR26', 'Rupafin 10 mg', 'KD', '2023-01-28', 'Viên', 7500);    
INSERT INTO zehn_02.PRODUCT VALUES('PR27', 'Fucicort Dream', 'KD', '2024-12-11', 'Tuýp', 102800);    
INSERT INTO zehn_02.PRODUCT VALUES('PR28', 'Natri clorid 0.9%', 'KD', '2020-09-06', 'Chai', 9500);    
INSERT INTO zehn_02.PRODUCT VALUES('PR29', 'Trimebutin 100mg', 'KD', '2021-02-05', 'Viên', 780);    
INSERT INTO zehn_02.PRODUCT VALUES('PR30', 'Goutcolcin 1mg', 'KD', '2022-01-18', 'H?p', 29800);    
INSERT INTO zehn_02.PRODUCT VALUES('PR31', 'Livers Gold Plus', 'TPCN', '2022-08-04', 'H?p', 149000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR32', 'Entero Lactyl', 'TPCN', '2023-12-06', 'H?p', 94500);    
INSERT INTO zehn_02.PRODUCT VALUES('PR33', 'Tam Th?t Cali USA Nano Gold', 'TPCN', '2023-05-23', 'H?p', 250000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR34', 'Natures Way Beauty Collagen Gummies', 'TPCN', '2022-03-20', 'H?p', 450000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR35', 'Dr. Frei Magnesium + B complex', 'TPCN', '2020-01-31', 'Tuýp', 149000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR36', 'Kem tr? n?t gót chân Eureka', 'Others', '2019-10-02', 'H?p', 74700);    
INSERT INTO zehn_02.PRODUCT VALUES('PR37', 'Bông t?y trang Jomi', 'Others', '2026-05-09', 'Túi', 25740);    
INSERT INTO zehn_02.PRODUCT VALUES('PR38', 'Kh?u trang 3D Jomi Freesize', 'Others', '2023-11-01', 'Gói', 25000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR39', 'B? c?m bi?n máy ?o ???ng huy?t nhanh FreeStyle Libre', 'Others', '2021-12-23', 'H?p', 16000000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR40', 'B? xét nghi?m nhanh COVID-19 t?i nhà Humasis COVID-19 Ag Home Test', 'Others', '2022-05-11', 'H?p', 2950000);    

    -- insert data into RECEIPT
INSERT INTO zehn_02.RECEIPT VALUES('R21', '0380882442', 'PH21', 'ZS02', '2021-07-31', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R22', '0784878027', 'PH37', 'ZS02', '2021-08-15', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R23', '0399988381', 'PH33', 'ZS02', '2021-05-22', 0, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R24', '0971820839', 'PH22', 'ZS02', '2021-06-17', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R25', '0861347402', 'PH39', 'ZS02', '2021-06-19', 0, 'ZehnPoint');    
INSERT INTO zehn_02.RECEIPT VALUES('R26', '0827397398', 'PH28', 'ZS02', '2021-05-09', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R27', '0966657718', 'PH25', 'ZS02', '2021-03-28', 0, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R28', '0359055883', 'PH40', 'ZS02', '2021-04-13', 0, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R29', '0836564633', 'PH24', 'ZS02', '2021-01-05', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R30', '0828228999', 'PH31', 'ZS02', '2021-12-14', 0, 'ZehnPoint');    
INSERT INTO zehn_02.RECEIPT VALUES('R31', '0356702531', 'PH38', 'ZS02', '2021-09-26', 0, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R32', '0392215332', 'PH35', 'ZS02', '2021-07-01', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R33', '0356702531', 'PH26', 'ZS02', '2021-11-11', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R34', '0976716565', 'PH23', 'ZS02', '2021-01-05', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R35', '0828228999', 'PH35', 'ZS02', '2021-02-12', 0, 'ZehnPoint');    
INSERT INTO zehn_02.RECEIPT VALUES('R36', '0399988381', 'PH34', 'ZS02', '2021-11-15', 0, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R37', '0392215332', 'PH23', 'ZS02', '2021-03-15', 0, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R38', '0852896366', 'PH26', 'ZS02', '2021-12-05', 0, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R39', '0700382483', 'PH36', 'ZS02', '2021-04-13', 0, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R40', '0700382483', 'PH40', 'ZS02', '2021-04-23', 0, 'Credit');    

    -- insert data into RECEIPTDETAIL
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R21', 'PR05', 2, price, amount);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R22', 'PR04', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R23', 'PR17', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R24', 'PR23', 10, 800, 8000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R24', 'PR24', 1, 12000, 12000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R25', 'PR15', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R25', 'PR40', 1, 2950000, 2950000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R25', 'PR09', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR11', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR25', 3, 23100, 69300);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR37', 2, 25740, 51480);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR21', 3, 7400, 22200);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR03', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R27', 'PR19', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R28', 'PR35', 1, 149000, 149000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R28', 'PR13', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R28', 'PR20', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R28', 'PR11', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R29', 'PR17', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R29', 'PR08', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R30', 'PR40', 3, 2950000, 8850000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R31', 'PR39', 1, 16000000, 16000000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R32', 'PR38', 2, 25000, 50000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R32', 'PR34', 1, 450000, 450000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R33', 'PR02', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R33', 'PR28', 2, 9500, 19000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R33', 'PR01', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R34', 'PR36', 1, 74700, 74700);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R35', 'PR10', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R36', 'PR27', 1, 102800, 102800);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R37', 'PR08', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R37', 'PR12', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R38', 'PR38', 3, 25000, 75000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R38', 'PR26', 5, 7500, 37500);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R38', 'PR15', );    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R39', 'PR29', 20, 780, 15600);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R40', 'PR38', 5, 25000, 125000);    
    
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

