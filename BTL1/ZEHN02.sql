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
INSERT INTO zehn_02.PHARMACIST VALUES('PH21', 'Hoang Van Huan Vo', 'Nam', '1984-07-21', '0795685309', 'Xa Trung Hoa, Huyen Chiem Hoa, Tuyen Quang', 2021, 4, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH22', 'Vu Binh Minh', 'Nam', '2000-08-21', '0350385255', 'Phuong 4, Thanh pho Da Lat, Lam Dong', 2020, 3, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH23', 'Le Thi Huong Lam', 'Nu', '1996-12-04', '0864954383', 'Xa Gia Tan 2, Huyen Thong Nhat, Dong Nai', 2019, 2, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH24', 'Le Nguyet Lan', 'Nu', '2000-12-26', '0967404755', 'Xa Hong Van, Huyen A Luoi, Thua Thien Hue', 2021, 1, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH25', 'Nguyen Tinh Nhu', 'Nu', '1985-08-12', '0859798719', 'Xa Tho Loc, Huyen Tho Xuan, Thanh Hoa', 2021, 2, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH26', 'Le Duy Hoang', 'Nam', '1993-04-11', '0826657918', 'Xa An Chau, Huyen Dong Hung, Thai Binh', 2020, 3, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH27', 'Nguyen Vo Yen Anh', 'Nu', '1984-12-13', '0842911997', 'Xa Pho Khanh, Thi xa Duc Pho, Quang Ngai', 2019, 4, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH28', 'Nguyen Le Thien Luan', 'Nam', '1984-12-28', '0345937568', 'Xa Van Yen, Huyen Dai Tu, Thai Nguyen', 2019, 3, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH29', 'Vo Pham Bich Tram', 'Nu', '1983-06-14', '0374457491', 'Xa Chinh Ly, Huyen Ly Nhan, Ha Nam', 2021, 2, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH30', 'Le Vu Ðuc Quang', 'Nam', '1985-04-11', '0970774435', 'Xa Phuoc Hau, Huyen Can Giuoc, Long An', 2020, 1, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH31', 'Ngo Thuy Trinh', 'Nu', '1989-02-28', '0397971758', 'Phuong Phuc Tan, Quan Hoan Kiem, Ha Noi', 2019, 3, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH32', 'Nguyen Vu The Hung', 'Nam', '1985-03-31', '0831223362', 'Thi tran Hiep Hoa, Huyen Duc Hoa, Long An', 2021, 2, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH33', 'Do Nguyen Nhat Lan', 'Nu', '1999-01-05', '0966603606', 'Phuong Nhon Phu, Thanh pho Quy Nhon, Binh Dinh', 2021, 4, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH34', 'Nguyen Bao Duy', 'Nam', '1989-11-03', '0361521452', 'Xa Vinh Lac, Huyen Luc Yen, Yen Bai', 2020, 1, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH35', 'Nguyen Ham Duyen', 'Nu', '1997-02-16', '0853139484', 'Xa Liem Chung, Thanh pho Phu Ly, Ha Nam', 2019, 3, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH36', 'Duong Thuan Toan', 'Nam', '2001-02-15', '0840639439', 'Phuong Pho Vinh, Thi xa Duc Pho, Quang Ngai', 2019, 2, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH37', 'Pham Quyet Thang', 'Nam', '1994-08-11', '0336011148', 'Xa An Thanh, Huyen Ben Luc, Long An', 2021, 4, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH38', 'Nguyen Phuong Hien', 'Nu', '1986-04-19', '0354660091', 'Xa Nghia An, Huyen Ninh Giang, Hai Duong', 2020, 4, 'ZS02');  
INSERT INTO zehn_02.PHARMACIST VALUES('PH39', 'Tran Le Hanh Vi', 'Nu', '1999-04-03', '0975807200', 'Phuong Quan Bau, Thanh pho Vinh, Nghe An', 2019, 2, 'ZS02');
INSERT INTO zehn_02.PHARMACIST VALUES('PH40', 'Nguyen Tran Buu Diep', 'Nam', '1993-08-08', '0709897146', 'Xa Hong Phong, Huyen Cao Loc, Lang Son', 2021, 1, 'ZS02');  

    -- insert data into CUSTOMER
INSERT INTO zehn_02.CUSTOMER VALUES('0985367353', 'Nguyen Tran Cao Si', 'Nam', '1995-04-24', 1000, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0836289221', 'Pham Phuong Nhung', 'Nu', '1982-04-11', 23500, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0362974048', 'Nguyen Tran Tien Vo', 'Nam', '1984-10-27', 1050000, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0383371705', 'Nguyen Le Ngoc Tru', 'Nam', '2002-02-15', 39250, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0971820839', 'Nguyen Hoang Nguyen Giang', 'Nam', '1988-03-20', 75000, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0828228999', 'Le Nhat Thuong', 'Nu', '1981-06-20', 514000, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0854263834', 'Nguyen Mai Thy', 'Nu', '1999-09-25', 2000, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0785368107', 'Ngo Thanh Vy', 'Nu', '1984-01-22', 34500, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0399988381', 'Nguyen Tran Anh Khai', 'Nam', '1989-03-15', 800, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0864952075', 'Nguyen Vu Khanh Hoan', 'Nam', '1997-10-03', 2300, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0333967718', 'Nguyen Quang Danh', 'Nam', '1988-02-06', 890500, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0866070516', 'Nguyen Ngo Thai Sang', 'Nam', '1999-09-03', 56000, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0361412774', 'Dang Nguyen Anh Minh', 'Nam', '1992-03-06', 2600, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0831730136', 'Nguyen Tran Lam Ðong', 'Nam', '1998-05-14', 7800, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0847900236', 'Nguyen Le Minh Khue', 'Nu', '1985-12-25', 9000, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0356702531', 'Huynh Trong Tuong', 'Nam', '1985-04-17', 77200, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0355395581', 'Pham Van Quang', 'Nam', '1985-07-23', 51000, 'StandardCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0819496910', 'Le Van Chi Khang', 'Nam', '1992-12-30', 0, 'BasicCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0861347402', 'Huynh Thuy Du', 'Nu', '1982-05-16', 100, 'ExtraCare');  
INSERT INTO zehn_02.CUSTOMER VALUES('0361230015', 'Nguyen Pham An Binh', 'Nu', '1996-09-18', 8700, 'StandardCare');  

    -- insert data into PRODUCT
INSERT INTO zehn_02.PRODUCT VALUES('PR21', 'Acuvail 4,5mg/ml', 'KD', '2022-01-26', 'Ong', 7400);    
INSERT INTO zehn_02.PRODUCT VALUES('PR22', 'Amaryl Glimepiride', 'KD', '2023-09-12', 'Hop', 162000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR23', 'Alphachymotrypsin 4,2mg', 'KD', '2024-05-29', 'Vien', 800);    
INSERT INTO zehn_02.PRODUCT VALUES('PR24', 'Acyclovir', 'KD', '2022-05-05', 'Hop', 12000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR25', 'Duoplavin 75mg/100mg', 'KD', '2022-04-24', 'Vien', 23100);    
INSERT INTO zehn_02.PRODUCT VALUES('PR26', 'Rupafin 10 mg', 'KD', '2023-01-28', 'Vien', 7500);    
INSERT INTO zehn_02.PRODUCT VALUES('PR27', 'Fucicort Dream', 'KD', '2024-12-11', 'Tuyp', 102800);    
INSERT INTO zehn_02.PRODUCT VALUES('PR28', 'Natri clorid 0.9%', 'KD', '2020-09-06', 'Chai', 9500);    
INSERT INTO zehn_02.PRODUCT VALUES('PR29', 'Trimebutin 100mg', 'KD', '2021-02-05', 'Vien', 780);    
INSERT INTO zehn_02.PRODUCT VALUES('PR30', 'Goutcolcin 1mg', 'KD', '2022-01-18', 'Hop', 29800);    
INSERT INTO zehn_02.PRODUCT VALUES('PR31', 'Livers Gold Plus', 'TPCN', '2022-08-04', 'Hop', 149000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR32', 'Entero Lactyl', 'TPCN', '2023-12-06', 'Hop', 94500);    
INSERT INTO zehn_02.PRODUCT VALUES('PR33', 'Tam That Cali USA Nano Gold', 'TPCN', '2023-05-23', 'Hop', 250000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR34', 'Natures Way Beauty Collagen Gummies', 'TPCN', '2022-03-20', 'Hop', 450000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR35', 'Dr. Frei Magnesium + B complex', 'TPCN', '2020-01-31', 'Tuyp', 149000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR36', 'Kem tri nut got chan Eureka', 'Others', '2019-10-02', 'Hop', 74700);    
INSERT INTO zehn_02.PRODUCT VALUES('PR37', 'Bong tay trang Jomi', 'Others', '2026-05-09', 'Tui', 25740);    
INSERT INTO zehn_02.PRODUCT VALUES('PR38', 'Khau trang 3D Jomi Freesize', 'Others', '2023-11-01', 'Goi', 25000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR39', 'Bo cam bien may do duong huyet nhanh FreeStyle Libre', 'Others', '2021-12-23', 'Hop', 16000000);    
INSERT INTO zehn_02.PRODUCT VALUES('PR40', 'Bo xet nghiem nhanh COVID-19 tai nha Humasis COVID-19 Ag Home Test', 'Others', '2022-05-11', 'Hop', 2950000);    

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

