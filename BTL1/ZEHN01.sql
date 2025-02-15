--==========================May ZEHN01========================================--

-- Create users on ZEHN01 machine with SYSDBA account via Sqlplus

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER zehn_01 IDENTIFIED BY 123456;
GRANT CONNECT, DBA TO zehn_01;

CREATE USER director IDENTIFIED BY 123456;
CREATE USER zehn_bridge IDENTIFIED BY 123456;
CREATE USER manager_01 IDENTIFIED BY 123456;
CREATE USER cashier_01 IDENTIFIED BY 123456;

-- Create Role R_Director and grant priviliges

GRANT CREATE SESSION, CONNECT, RESOURCE TO director;

GRANT CREATE PUBLIC DATABASE LINK TO director;
GRANT ALTER PUBLIC DATABASE LINK TO director;
GRANT DROP PUBLIC DATABASE LINK TO director;

GRANT CREATE PUBLIC DATABASE LINK TO manager_01;

GRANT CREATE USER TO director;
GRANT ALTER USER TO director;
GRANT DROP USER TO director;

--==========================CREATE TABLE======================================--

-- Create tables with SQLDeveloper by using connection "ZEHN01" with "zehn_01" account
CREATE TABLE zehn_01.ZEHNSTORE(
    StoreId     VARCHAR2(10),
    StoreName   NVARCHAR2(40) NOT NULL,  
    Address     NVARCHAR2(40) NOT NULL,
    
    CONSTRAINT PK_ZEHNSTORE PRIMARY KEY(StoreId)
);

CREATE TABLE zehn_01.PHARMACIST(
    PharmacistId    VARCHAR2(10),
    FullName        NVARCHAR2(30)   NOT NULL,
    Gender          NVARCHAR2(5)    NOT NULL,
    DoB             DATE            NOT NULL,
    PhoneNumber     VARCHAR2(15)    NOT NULL,
    Address         NVARCHAR2(150)  NOT NULL,
    WorkYear        NUMBER          NOT NULL,
    WorkShift       NUMBER          NOT NULL,
    StoreId         VARCHAR2(10)    NOT NULL,
    
    CONSTRAINT PK_PHARMACIST PRIMARY KEY(PharmacistId)
);

CREATE TABLE zehn_01.CUSTOMER(
    PhoneNumber     VARCHAR2(15),
    FullName        VARCHAR2(30),
    Gender          VARCHAR2(5),
    DoB             DATE,
    ZehnPoint       NUMBER          DEFAULT 0,
    CustomerType    VARCHAR2(15)    DEFAULT 'BasicCare',
    
    CONSTRAINT PK_CUSTOMER PRIMARY KEY(PhoneNumber)
);

CREATE TABLE zehn_01.PRODUCT(
    ProductId       VARCHAR2(10),
    ProductName     NVARCHAR2(150)  NOT NULL,
    ProductType     NVARCHAR2(30),
    ExpiredDate     DATE            NOT NULL,
    CountUnit       NVARCHAR2(10),
    Price           NUMBER          NOT NULL,
    
    CONSTRAINT PK_PRODUCT PRIMARY KEY(ProductId)
);

CREATE TABLE zehn_01.RECEIPT(
    ReceiptId       VARCHAR2(10),
    CustomerId      VARCHAR2(15)    NOT NULL,
    PharmacistId    VARCHAR2(10)    NOT NULL,
    StoreId         VARCHAR2(10)    NOT NULL,
    PaymentTime     DATE            NOT NULL,
    Total           NUMBER          NOT NULL,
    PaymentMethod   VARCHAR(10)     DEFAULT 'Cash',
    
    CONSTRAINT PK_RECEIPT PRIMARY KEY(ReceiptId)
);

CREATE TABLE zehn_01.RECEIPTDETAIL(
    ReceiptId       VARCHAR2(10),
    ProductId       VARCHAR2(10),
    Quantity        NUMBER          DEFAULT 1,
    Price           NUMBER          NOT NULL,
    Amount          NUMBER          NOT NULL,
    
    CONSTRAINT PK_DETAIL PRIMARY KEY(ReceiptId, ProductId)
);
--==========================FOREIGN KEY=======================================--
ALTER TABLE zehn_01.PHARMACIST
ADD CONSTRAINT FK_PHARMARCIST_StoreId FOREIGN KEY(StoreId)
REFERENCES zehn_01.ZEHNSTORE(StoreId);

ALTER TABLE zehn_01.RECEIPT
ADD CONSTRAINT FK_RECEIPT_CustomerId FOREIGN KEY(CustomerId)
REFERENCES zehn_01.CUSTOMER(PhoneNumber);

ALTER TABLE zehn_01.RECEIPT
ADD CONSTRAINT FK_RECEIPT_StoreId FOREIGN KEY(StoreId)
REFERENCES zehn_01.ZEHNSTORE(StoreId);

ALTER TABLE zehn_01.RECEIPT
ADD CONSTRAINT FK_RECEIPT_PharmacistId FOREIGN KEY(PharmacistId)
REFERENCES zehn_01.PHARMACIST(PharmacistId);

ALTER TABLE zehn_01.RECEIPTDETAIL
ADD CONSTRAINT FK_DETAIL_ReceiptId FOREIGN KEY(ReceiptId)
REFERENCES zehn_01.RECEIPT(ReceiptId);

ALTER TABLE zehn_01.RECEIPTDETAIL
ADD CONSTRAINT FK_DETAIL_ProductId FOREIGN KEY(ProductId)
REFERENCES zehn_01.PRODUCT(ProductId);

--==========================INSERT DATA=======================================--
-- disable foreign key
ALTER TABLE zehn_01.PHARMACIST      DISABLE CONSTRAINT FK_PHARMARCIST_StoreId;
ALTER TABLE zehn_01.RECEIPT         DISABLE CONSTRAINT FK_RECEIPT_CustomerId;
ALTER TABLE zehn_01.RECEIPT         DISABLE CONSTRAINT FK_RECEIPT_StoreId;
ALTER TABLE zehn_01.RECEIPT         DISABLE CONSTRAINT FK_RECEIPT_PharmacistId;
ALTER TABLE zehn_01.RECEIPTDETAIL   DISABLE CONSTRAINT FK_DETAIL_ReceiptId;
ALTER TABLE zehn_01.RECEIPTDETAIL   DISABLE CONSTRAINT FK_DETAIL_ProductId;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

-- insert data here
    -- insert data into ZEHNSTORE
INSERT INTO zehn_01.ZEHNSTORE VALUES('ZS01', 'Zehn Store Go Vap','Le Duc Tho, Go Vap, TPHCM');

    -- insert data into PHARMACIST
INSERT INTO zehn_01.PHARMACIST VALUES('PH01', 'Nguyen Do Tho Tho', 'Nu', '1991-02-09', '0322839231', 'Xa My Tai, Huyen Phu My, Binh Dinh', 2021, 1, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH02', 'Nguyen Pham Thanh Thien', 'Nam', '1996-10-08', '0378356038', 'Xa Viet Lap, Huyen Tan Yen, Bac Giang', 2020, 2, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH03', 'Vo Nguyen Thien Hung', 'Nam', '2001-07-30', '0382206497', 'Phuong Phuoc Hiep, Thanh pho Ba Ria, Ba Ria - Vung Tau', 2019, 3, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH04', 'Vo Van Tinh', 'Nam', '1999-12-19', '0352033882', 'Phuong 3, Thanh pho Da Lat, Lam Dong', 2019, 1, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH05', 'Tran Mai Anh', 'Nu', '2000-05-16', '0868278597', 'Phuong Nhon Thanh, Thi xa An Nhon, Binh Dinh', 2020, 2, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH06', 'Nguyen Tran Trong Viet', 'Nam', '1989-05-18', '0326297198', 'Xa Hong Van, Huyen Thuong Tin, Ha Noi', 2021, 3, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH07', 'Nguyen Huynh Bao An', 'Nam', '1984-06-12', '0337277289', 'Xa Luong Tai, Huyen Van Lam, Hung Yen', 2020, 1, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH08', 'Nguyen Thi Nha Trang', 'Nu', '2000-03-27', '0383998804', 'Xa Phuoc Binh, Huyen Long Thanh, Dong Nai', 2019, 2, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH09', 'Le Pham Hai Sinh', 'Nu', '1988-10-26', '0358322107', 'Xa Tram Tau, Huyen Tram Tau, Yen Bai', 2020, 3, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH10', 'Ho Da Huong', 'Nu', '1985-11-06', '0979293379', 'Xa Truc Thang, Huyen Truc Ninh, Nam Dinh', 2021, 1, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH11', 'Pham Ha Lien', 'Nu', '1992-03-03', '0960271324', 'Xa Tien Yen, Huyen Quang Binh, Ha Giang', 2020, 2, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH12', 'Tran Pham Huong Thuy', 'Nu', '1981-05-24', '0862029931', 'Phuong Phuoc Binh, Thanh pho Thu Duc, Ho Chi Minh', 2019, 3, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH13', 'Nguyen Thi Hue', 'Nu', '2000-03-23', '0867042245', 'Xa Phong Phu, Huyen Cau Ke, Tra Vinh', 2020, 1, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH14', 'Le Van Loc', 'Nam', '1992-07-14', '0828301929', 'Xa Thach Binh, Huyen Nho Quan, Ninh Binh', 2021, 2, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH15', 'Nguyen Thuy Hang', 'Nu', '1997-02-18', '0815749584', 'Xa Long Hoa, Huyen Dau Tieng, Binh Duong', 2020, 3, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH16', 'Nguyen Thuy Huyen', 'Nu', '1986-12-22', '0862277615', 'Xa Huong Linh, Huyen Huong Hoa, Quang Tri', 2019, 1, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH17', 'Nguyen Thi Thuc Nhi', 'Nu', '1998-09-07', '0385303151', 'Xa Tra Doc, Huyen Bac Tra My, Quang Nam', 2020, 2, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH18', 'Huynh Vo Thanh Hau', 'Nam', '1983-03-05', '0393395383', 'Xa Phong My, Huyen Cao Lanh, Dong Thap', 2021, 3, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH19', 'Vu Lam Nhi', 'Nu', '1995-04-23', '0846659598', 'Xa Dray Bhang, Huyen Cu Kuin, Dak Lak', 2020, 1, 'ZS01');
INSERT INTO zehn_01.PHARMACIST VALUES('PH20', 'Nguyen An Binh', 'Nam', '1996-07-10', '0357920448', 'Xa Tan Hiep, Huyen Hoc Mon, Ho Chi Minh', 2019, 2, 'ZS01');
	
    
    -- insert data into CUSTOMER
INSERT INTO zehn_01.CUSTOMER VALUES('0700382483', 'Le Diem Thu', 'Nu', '2002-02-24', 23000, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0976716565', 'Pham Ha Nhi', 'Nu', '1985-04-22', 40000, 'ExtraCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0349093356', 'Nguyen Chi Lan', 'Nu', '1990-04-29', 103000, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0845126570', 'Ngo Nguyen Ngoc Quynh', 'Nu', '1991-05-14', 30500, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0392215332', 'Nguyen Van Thanh Y', 'Nam', '1984-02-06', 5000, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0825558746', 'Nguyen �?ong Hai', 'Nam', '1993-04-28', 44000, 'StandardCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0380882442', 'Le Minh Huy', 'Nam', '1995-12-27', 8000, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0332051377', 'Pham Tran Hai Thuy', 'Nam', '2000-05-02', 503000, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0865087093', 'Vu Bao Huynh', 'Nam', '1982-09-05', 24500, 'StandardCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0359055883', 'Nguyen Lam Ha', 'Nu', '1994-12-06', 33500, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0836564633', 'Nguyen Thi My Dung', 'Nu', '1989-04-14', 4000, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0355972520', 'Nguyen Hoang Phi Phi', 'Nu', '1984-12-06', 12300, 'ExtraCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0373677397', 'Le Thanh Hao', 'Nu', '1984-12-06', 12300, 'ExtraCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0967973007', 'Dang Trung Nhan', 'Nam', '1982-07-14', 103500, 'StandardCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0791280861', 'Le Vo �?at Hoa', 'Nam', '1992-12-31', 2500, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0328349238', 'Duong Hoang Cao Nguyen', 'Nam', '1998-12-01', 15500, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0784878027', 'Dang Cao Nguyen', 'Nam', '1992-06-18', 32000, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0827397398', 'Nguyen Nguyet Minh', 'Nu', '2004-09-10', 80000, 'StandardCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0966657718', 'Tran Nguyen Bao Truc', 'Nu', '1999-10-23', 0, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0852896366', 'Huynh Nguyen My Hoan', 'Nu', '1999-10-23', 0, 'BasicCare');
INSERT INTO zehn_01.CUSTOMER VALUES('0985367353', 'Nguyen Tran Cao Si', 'Nam', '1995-04-24', 1000, 'BasicCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0836289221', 'Pham Phuong Nhung', 'Nu', '1982-04-11', 23500, 'StandardCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0362974048', 'Nguyen Tran Tien Vo', 'Nam', '1984-10-27', 1050000, 'ExtraCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0383371705', 'Nguyen Le Ngoc Tru', 'Nam', '2002-02-15', 39250, 'BasicCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0971820839', 'Nguyen Hoang Nguyen Giang', 'Nam', '1988-03-20', 75000, 'StandardCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0828228999', 'Le Nhat Thuong', 'Nu', '1981-06-20', 514000, 'ExtraCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0854263834', 'Nguyen Mai Thy', 'Nu', '1999-09-25', 2000, 'StandardCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0785368107', 'Ngo Thanh Vy', 'Nu', '1984-01-22', 34500, 'StandardCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0399988381', 'Nguyen Tran Anh Khai', 'Nam', '1989-03-15', 800, 'BasicCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0864952075', 'Nguyen Vu Khanh Hoan', 'Nam', '1997-10-03', 2300, 'BasicCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0333967718', 'Nguyen Quang Danh', 'Nam', '1988-02-06', 890500, 'ExtraCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0866070516', 'Nguyen Ngo Thai Sang', 'Nam', '1999-09-03', 56000, 'ExtraCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0361412774', 'Dang Nguyen Anh Minh', 'Nam', '1992-03-06', 2600, 'StandardCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0831730136', 'Nguyen Tran Lam �?ong', 'Nam', '1998-05-14', 7800, 'BasicCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0847900236', 'Nguyen Le Minh Khue', 'Nu', '1985-12-25', 9000, 'BasicCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0356702531', 'Huynh Trong Tuong', 'Nam', '1985-04-17', 77200, 'ExtraCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0355395581', 'Pham Van Quang', 'Nam', '1985-07-23', 51000, 'StandardCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0819496910', 'Le Van Chi Khang', 'Nam', '1992-12-30', 0, 'BasicCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0861347402', 'Huynh Thuy Du', 'Nu', '1982-05-16', 100, 'ExtraCare');  
INSERT INTO zehn_01.CUSTOMER VALUES('0361230015', 'Nguyen Pham An Binh', 'Nu', '1996-09-18', 8700, 'StandardCare');

commit;

    -- insert data into PRODUCT
INSERT INTO zehn_01.PRODUCT VALUES('PR01', 'Viem ngam dieu tri viem hong Dorithricin', 'KDD', '2025-04-23', 'Hop', 49000);
INSERT INTO zehn_01.PRODUCT VALUES('PR02', 'Pepsane', 'KDD', '2022-12-02', 'Hop', 144000);
INSERT INTO zehn_01.PRODUCT VALUES('PR03', 'Agimoti', 'KDD', '2023-07-01', 'Hop', 90000);
INSERT INTO zehn_01.PRODUCT VALUES('PR04', 'Buscopan', 'KDD', '2022-10-05', 'Hop', 112000);
INSERT INTO zehn_01.PRODUCT VALUES('PR05', 'Cetirizin 10mg', 'KDD', '2023-08-02', 'Hop', 62000);
INSERT INTO zehn_01.PRODUCT VALUES('PR06', 'Gastropulgite', 'KDD', '2023-01-01', 'Hop', 102000);
INSERT INTO zehn_01.PRODUCT VALUES('PR07', 'Thuoc dieu tri loet da day-ta trang Sucralfate', 'KDD', '2024-02-28', 'Hop', 22500);
INSERT INTO zehn_01.PRODUCT VALUES('PR08', 'Dosaff', 'KDD', '2025-01-01', 'Hop', 137000);
INSERT INTO zehn_01.PRODUCT VALUES('PR09', 'Glucosamin 500mg', 'KDD', '2022-06-20', 'Hop', 75000);
INSERT INTO zehn_01.PRODUCT VALUES('PR10', 'Effer-Paralmax 500', 'KDD', '2022-03-16', 'Hop', 56000);
INSERT INTO zehn_01.PRODUCT VALUES('PR11', 'Cumargold New', 'TPCN', '2025-09-20', 'Hop', 360000);
INSERT INTO zehn_01.PRODUCT VALUES('PR12', 'Thuc pham bao ve suc khoe Ferrovit C', 'TPCN', '2020-04-20', 'Hop', 180000);
INSERT INTO zehn_01.PRODUCT VALUES('PR13', 'Thuc pham bao ve suc khoe Hoat Huyet', 'TPCN', '2021-02-09', 'Hop', 63000);
INSERT INTO zehn_01.PRODUCT VALUES('PR14', 'Baigout', 'TPCN', '2022-03-16', 'Hop', 239000);
INSERT INTO zehn_01.PRODUCT VALUES('PR15', 'A+ Nutrition Multivitamin', 'TPCN', '2021-10-01', 'Hop', 347000);
INSERT INTO zehn_01.PRODUCT VALUES('PR16', 'Dau goi bo ket Thorakao (400ml)', 'Others', '2024-06-19', 'Chai', 65000);
INSERT INTO zehn_01.PRODUCT VALUES('PR17', 'Bao cao su Okamoto 0.03 Platinum', 'Others', '2025-01-01', 'Hop', 120000);
INSERT INTO zehn_01.PRODUCT VALUES('PR18', 'Phamatech Quickstick One-Step Midstream', 'Others', '2026-01-01', 'Hop', 75000);
INSERT INTO zehn_01.PRODUCT VALUES('PR19', 'Horien Eye Secret 15ml', 'Others', '2024-05-30', 'Chai', 60000);
INSERT INTO zehn_01.PRODUCT VALUES('PR20', 'Gel boi tron Durex Play Classic (50ml)', 'Others', '2024-08-01', 'Chai', 86000);
INSERT INTO zehn_01.PRODUCT VALUES('PR21', 'Acuvail 4,5mg/ml', 'KD', '2022-01-26', 'Ong', 7400);    
INSERT INTO zehn_01.PRODUCT VALUES('PR22', 'Amaryl Glimepiride', 'KD', '2023-09-12', 'Hop', 162000);    
INSERT INTO zehn_01.PRODUCT VALUES('PR23', 'Alphachymotrypsin 4,2mg', 'KD', '2024-05-29', 'Vien', 800);    
INSERT INTO zehn_01.PRODUCT VALUES('PR24', 'Acyclovir', 'KD', '2022-05-05', 'Hop', 12000);    
INSERT INTO zehn_01.PRODUCT VALUES('PR25', 'Duoplavin 75mg/100mg', 'KD', '2022-04-24', 'Vien', 23100);    
INSERT INTO zehn_01.PRODUCT VALUES('PR26', 'Rupafin 10 mg', 'KD', '2023-01-28', 'Vien', 7500);    
INSERT INTO zehn_01.PRODUCT VALUES('PR27', 'Fucicort Dream', 'KD', '2024-12-11', 'Tuyp', 102800);    
INSERT INTO zehn_01.PRODUCT VALUES('PR28', 'Natri clorid 0.9%', 'KD', '2020-09-06', 'Chai', 9500);    
INSERT INTO zehn_01.PRODUCT VALUES('PR29', 'Trimebutin 100mg', 'KD', '2021-02-05', 'Vien', 780);    
INSERT INTO zehn_01.PRODUCT VALUES('PR30', 'Goutcolcin 1mg', 'KD', '2022-01-18', 'Hop', 29800);    
INSERT INTO zehn_01.PRODUCT VALUES('PR31', 'Livers Gold Plus', 'TPCN', '2022-08-04', 'Hop', 149000);    
INSERT INTO zehn_01.PRODUCT VALUES('PR32', 'Entero Lactyl', 'TPCN', '2023-12-06', 'Hop', 94500);    
INSERT INTO zehn_01.PRODUCT VALUES('PR33', 'Tam That Cali USA Nano Gold', 'TPCN', '2023-05-23', 'Hop', 250000);    
INSERT INTO zehn_01.PRODUCT VALUES('PR34', 'Natures Way Beauty Collagen Gummies', 'TPCN', '2022-03-20', 'Hop', 450000);    
INSERT INTO zehn_01.PRODUCT VALUES('PR35', 'Dr. Frei Magnesium + B complex', 'TPCN', '2020-01-31', 'Tuyp', 149000);    
INSERT INTO zehn_01.PRODUCT VALUES('PR36', 'Kem tri nut got chan Eureka', 'Others', '2019-10-02', 'Hop', 74700);    
INSERT INTO zehn_01.PRODUCT VALUES('PR37', 'Bong tay trang Jomi', 'Others', '2026-05-09', 'Tui', 25740);    
INSERT INTO zehn_01.PRODUCT VALUES('PR38', 'Khau trang 3D Jomi Freesize', 'Others', '2023-11-01', 'Goi', 25000);    
INSERT INTO zehn_01.PRODUCT VALUES('PR39', 'Bo cam bien may do duong huyet nhanh FreeStyle Libre', 'Others', '2021-12-23', 'Hop', 16000000);    
INSERT INTO zehn_01.PRODUCT VALUES('PR40', 'Bo xet nghiem nhanh COVID-19 tai nha Humasis COVID-19 Ag Home Test', 'Others', '2022-05-11', 'Hop', 2950000);    

    -- insert data into RECEIPT
INSERT INTO zehn_01.RECEIPT VALUES('R01', '0392215332', 'PH01', 'ZS01', '2021-12-03', 301000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R02', '0355972520', 'PH01', 'ZS01', '2021-12-03', 503000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R03', '0700382483', 'PH01', 'ZS01', '2021-12-03', 360000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R04', '0784878027', 'PH03', 'ZS01', '2021-12-03', 354000, 'Credit');
INSERT INTO zehn_01.RECEIPT VALUES('R05', '0985367353', 'PH03', 'ZS01', '2021-12-03', 2176000, 'Credit');
INSERT INTO zehn_01.RECEIPT VALUES('R06', '0971820839', 'PH03', 'ZS01', '2021-10-14', 830400, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R07', '0864952075', 'PH05', 'ZS01', '2021-11-20', 488700, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R08', '0847900236', 'PH05', 'ZS01', '2021-11-25', 383000, 'Zehn Point');
INSERT INTO zehn_01.RECEIPT VALUES('R09', '0985367353', 'PH05', 'ZS01', '2021-11-25', 5447000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R10', '0785368107', 'PH07', 'ZS01', '2021-12-01', 1020000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R11', '0328349238', 'PH07', 'ZS01', '2021-12-02', 25000, 'Credit');
INSERT INTO zehn_01.RECEIPT VALUES('R12', '0865087093', 'PH07', 'ZS01', '2021-06-20', 658000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R13', '0349093356', 'PH09', 'ZS01', '2021-16-20', 894000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R14', '0332051377', 'PH09', 'ZS01', '2021-10-30', 165000, 'Zehn Point');
INSERT INTO zehn_01.RECEIPT VALUES('R15', '0985367353', 'PH09', 'ZS01', '2021-10-30', 204800, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R16', '0355395581', 'PH02', 'ZS01', '2021-10-30', 36000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R17', '0356702531', 'PH02', 'ZS01', '2021-05-21', 112000, 'Credit');
INSERT INTO zehn_01.RECEIPT VALUES('R18', '0866070516', 'PH02', 'ZS01', '2021-12-02', 495000, 'Cash');
INSERT INTO zehn_01.RECEIPT VALUES('R19', '0985367353', 'PH15', 'ZS01', '2021-08-04', 224000, 'Zehn Point');
INSERT INTO zehn_01.RECEIPT VALUES('R20', '0700382483', 'PH15', 'ZS01', '2021-09-03', 75000, 'Cash');
    
    -- insert data into RECEIPTDETAIL
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R01', 'PR01', 1, 49000, 49000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R01', 'PR24', 1, 12000, 12000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R01', 'PR17', 2, 120000, 240000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R02', 'PR10', 1, 56000, 56000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R02', 'PR31', 3, 149000, 447000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R03', 'PR12', 2, 180000, 360000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R04', 'PR02', 1, 144000, 144000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R04', 'PR04', 1, 112000, 112000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R04', 'PR01', 2, 49000, 98000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R05', 'PR39', 1, 1600000, 1600000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R05', 'PR02', 4, 144000, 576000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R06', 'PR30', 1, 29800, 29800);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R06', 'PR31', 2, 149000, 298000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R06', 'PR28', 1, 9500, 9500);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R06', 'PR25', 1, 23100, 23100);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R06', 'PR08', 1, 137000, 137000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R06', 'PR04', 3, 112000, 336000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R07', 'PR22', 2, 162000, 324000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R07', 'PR36', 1, 74700, 74700);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R07', 'PR07', 4, 22500, 90000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R08', 'PR14', 1, 239000, 239000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R08', 'PR02', 1, 144000, 144000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R09', 'PR08', 2, 137000, 274000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R09', 'PR31', 2, 149000, 298000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R09', 'PR39', 3, 16000000, 4800000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R09', 'PR18', 1, 75000, 75000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R10', 'PR35', 1, 149000, 149000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R10', 'PR31', 1, 149000, 149000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R10', 'PR33', 2, 250000, 500000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R10', 'PR01', 1, 49000, 49000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R10', 'PR08', 1, 137000, 137000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R10', 'PR24', 3, 12000, 36000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R11', 'PR38', 1, 25000, 25000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R12', 'PR14', 2, 239000, 478000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R12', 'PR12', 1, 180000, 180000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R13', 'PR31', 4, 149000, 596000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R13', 'PR35', 2, 149000, 298000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R14', 'PR03', 1, 90000, 90000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R14', 'PR09', 1, 75000, 75000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R15', 'PR27', 1, 102800, 102800);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R15', 'PR06', 1, 102000, 102000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R16', 'PR24', 3, 12000, 36000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R17', 'PR04', 1, 112000, 112000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R18', 'PR07', 2, 22500, 45000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R18', 'PR34', 1, 450000, 450000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R19', 'PR04', 2, 112000, 224000);
INSERT INTO zehn_01.RECEIPTDETAIL VALUES('R20', 'PR18', 1, 75000, 75000);
    
-- enable foreign key
ALTER TABLE zehn_01.PHARMACIST      ENABLE CONSTRAINT FK_PHARMARCIST_StoreId;
ALTER TABLE zehn_01.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_CustomerId;
ALTER TABLE zehn_01.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_StoreId;
ALTER TABLE zehn_01.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_PharmacistId;
ALTER TABLE zehn_01.RECEIPTDETAIL   ENABLE CONSTRAINT FK_DETAIL_ReceiptId;
ALTER TABLE zehn_01.RECEIPTDETAIL   ENABLE CONSTRAINT FK_DETAIL_ProductId;

--==========================TABLE TESTINGS====================================--

SELECT * FROM zehn_01.ZEHNSTORE;
SELECT * FROM zehn_01.PHARMACIST;
SELECT * FROM zehn_01.CUSTOMER;
SELECT * FROM zehn_01.PRODUCT;
SELECT * FROM zehn_01.RECEIPT;
SELECT * FROM zehn_01.RECEIPTDETAIL;

--==========================CREATE DATABASE LINK==============================--
-- Login as "director" account
CREATE DATABASE LINK director_01_02 CONNECT TO director IDENTIFIED BY "123456" USING 'ZEHN_01';
-- Login as "manager_01" account
CREATE DATABASE LINK manager_01_02 CONNECT TO zehn_bridge IDENTIFIED BY "123456" USING 'ZEHN_01';

--==========================GRANTING PRIVILIGES===============================--

commit;

-- Granting on SQLPLUS as sysdba account

-----GRANTING for DIRECTOR-----
    -- ZEHNSTORE
GRANT INSERT ON zehn_01.ZEHNSTORE TO director;      
GRANT UPDATE ON zehn_01.ZEHNSTORE TO director;
GRANT DELETE ON zehn_01.ZEHNSTORE TO director;
GRANT SELECT ON zehn_01.ZEHNSTORE TO director;

GRANT INSERT ON zehn_02.ZEHNSTORE@director_01_02 TO director;
GRANT UPDATE ON zehn_02.ZEHNSTORE@director_01_02 TO director;
GRANT DELETE ON zehn_02.ZEHNSTORE@director_01_02 TO director;
GRANT SELECT ON zehn_02.ZEHNSTORE@director_01_02 TO director;

    -- PHARMACIST
GRANT INSERT ON zehn_01.PHARMACIST TO director;     
GRANT UPDATE ON zehn_01.PHARMACIST TO director;
GRANT DELETE ON zehn_01.PHARMACIST TO director;
GRANT SELECT ON zehn_01.PHARMACIST TO director;

GRANT UPDATE ON zehn_02.PHARMACIST@director_01_02 TO director;
GRANT INSERT ON zehn_02.PHARMACIST@director_01_02 TO director;
GRANT DELETE ON zehn_02.PHARMACIST@director_01_02 TO director;
GRANT SELECT ON zehn_02.PHARMACIST@director_01_02 TO director;

-- Just ZEHN_01 store because of replication
    -- PRODUCT
GRANT INSERT ON zehn_01.PRODUCT TO director;        
GRANT UPDATE ON zehn_01.PRODUCT TO director;
GRANT DELETE ON zehn_01.PRODUCT TO director;
GRANT SELECT ON zehn_01.PRODUCT TO director;

    -- CUSTOMER
GRANT SELECT ON zehn_01.CUSTOMER TO director;       

    -- RECEIPT
GRANT SELECT ON zehn_01.RECEIPT TO director;        
GRANT SELECT ON zehn_02.RECEIPT@director_01_02 TO director;

    -- RECEIPT DETAIL
GRANT SELECT ON zehn_01.RECEIPTDETAIL TO director;  
GRANT SELECT ON zehn_02.RECEIPTDETAIL@director_01_02 TO director;

-----GRANTING for ZEHN_BRIDGE-----

CREATE ROLE R_MANAGER;

GRANT CREATE SESSION, CONNECT TO R_MANAGER;

    -- PRODUCT
GRANT UPDATE ON zehn_01.PRODUCT TO R_MANAGER;       
GRANT INSERT ON zehn_01.PRODUCT TO R_MANAGER;
GRANT DELETE ON zehn_01.PRODUCT TO R_MANAGER;
GRANT SELECT ON zehn_01.PRODUCT TO R_MANAGER;
	
    -- CUSTOMER
GRANT UPDATE ON zehn_01.CUSTOMER TO R_MANAGER;      
GRANT INSERT ON zehn_01.CUSTOMER TO R_MANAGER;
GRANT DELETE ON zehn_01.CUSTOMER TO R_MANAGER;
GRANT SELECT ON zehn_01.CUSTOMER TO R_MANAGER;
	
    -- ZEHNSTORE
GRANT SELECT ON zehn_01.ZEHNSTORE TO R_MANAGER;     
GRANT SELECT ON zehn_02.ZEHNSTORE@manager_01_02 TO R_MANAGER;

    -- PHARMACIST
GRANT SELECT ON zehn_01.PHARMACIST TO R_MANAGER;    
GRANT SELECT ON zehn_02.PHARMACIST@manager_01_02 TO R_MANAGER;

     -- RECEIPT
GRANT SELECT ON zehn_01.RECEIPT TO R_MANAGER;      
GRANT SELECT ON zehn_02.RECEIPT@manager_01_02 TO R_MANAGER;

    -- RECEIPT DETAIL
GRANT SELECT ON zehn_01.RECEIPTDETAIL TO R_MANAGER; 
GRANT SELECT ON zehn_02.RECEIPTDETAIL@manager_01_02 TO R_MANAGER;

GRANT R_MANAGER TO zehn_bridge;

-----GRANTING for MANAGER-----

GRANT R_MANAGER TO manager_01;

    -- PHARMACIST
GRANT UPDATE ON zehn_01.PHARMACIST TO manager_01;   
GRANT INSERT ON zehn_01.PHARMACIST TO manager_01;
GRANT DELETE ON zehn_01.PHARMACIST TO manager_01;

    -- RECEIPT
GRANT INSERT ON zehn_01.RECEIPT TO manager_01;      
GRANT UPDATE ON zehn_01.RECEIPT TO manager_01;
GRANT DELETE ON zehn_01.RECEIPT TO manager_01;

    -- RECEIPT DETAIL
GRANT INSERT ON zehn_01.RECEIPTDETAIL TO manager_01;
GRANT DELETE ON zehn_01.RECEIPTDETAIL TO manager_01;
GRANT UPDATE ON zehn_01.RECEIPTDETAIL TO manager_01;

-----GRANTING for CASHIER-----
GRANT CONNECT, CREATE SESSION TO cashier_01;

GRANT SELECT ON zehn_01.ZEHNSTORE TO cashier_01;
GRANT SELECT ON zehn_01.CUSTOMER TO cashier_01;
GRANT SELECT ON zehn_01.PRODUCT TO cashier_01;
GRANT SELECT ON zehn_01.PHARMACIST TO cashier_01;

GRANT INSERT ON zehn_01.CUSTOMER TO cashier_01;
GRANT UPDATE ON zehn_01.CUSTOMER TO cashier_01;
GRANT DELETE ON zehn_01.CUSTOMER TO cashier_01;
GRANT SELECT ON zehn_01.CUSTOMER TO cashier_01;
	
GRANT INSERT ON zehn_01.RECEIPT TO cashier_01;
GRANT UPDATE ON zehn_01.RECEIPT TO cashier_01;
GRANT DELETE ON zehn_01.RECEIPT TO cashier_01;
GRANT SELECT ON zehn_01.RECEIPT TO cashier_01;
	
GRANT INSERT ON zehn_01.RECEIPTDETAIL TO cashier_01;
GRANT UPDATE ON zehn_01.RECEIPTDETAIL TO cashier_01;
GRANT DELETE ON zehn_01.RECEIPTDETAIL TO cashier_01;
GRANT SELECT ON zehn_01.RECEIPTDETAIL TO cashier_01;

COMMIT;


--==========================TRIGGER===========================================--
-- create or replace TRIGGER
/*
Duoc si phai du 18 tuoi khi vao lam viec
Boi canh: PHARMACIST
Noi dung: \forall p \in PHARMACIST(p.(WorkYear-YEAR(DoB)) <18)
Bang tam anh huong: 
            Insert  Delete  Update
PHARMACIST    +       -       +(WorkYear, DoB)
*/
CREATE OR REPLACE TRIGGER trg_PHARMACIST_insert
AFTER INSERT OR UPDATE ON zehn_01.PHARMACIST FOR EACH ROW
BEGIN
    IF (:NEW.WorkYear - EXTRACT(year FROM :NEW.Dob)<18) THEN
        RAISE_APPLICATION_ERROR(-20100, 'Duoc si phai toi thieu 18 tuoi khi vao lam viec');
    END IF; 
END;

-- test the trigger
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
INSERT INTO zehn_01.PHARMACIST VALUES('Ph_test', 'Nguyen Van A', 'Nam', '2006-12-23', '0969334734', 'huyen Cao Loc, Lang Son', 2021, 1, 'ZS01');

--==========================PROCEDURE=========================================--
--Procedure: Thay doi ca lam WorkShift cua pharmacist
--Procedure Name: ChangeWorkShift
--Arguments: v_PharmacistID (Ma duoc si) , v_WorkShift  (Ca lam viec)
 
--Side effect: Tim duoc si co v_PharmacistID trong bang PHARMACIST tai tung chi nhanh va neu tim thay thay doi WorkShift thanh v_WorkShift
-- su dung tai khoan: director/123456
connect director/123456

CREATE OR REPLACE PROCEDURE ChangeWorkShift (v_PharmacistID in VARCHAR2, v_WorkShift in NUMBER)
AS
 dem int;
BEGIN
 SELECT COUNT(Ph2.PharmacistID) INTO dem 
 FROM zehn_02.PHARMACIST Ph2
 WHERE Ph2.PharmacistID = v_PharmacistID;
 IF (dem=1) THEN
	UPDATE zehn_02.PHARMACIST
	SET WorkShift = v_WorkShift
	WHERE PharmacistID = v_PharmacistID;
 ELSE
  SELECT COUNT(Ph1.PharmacistID) INTO dem 
  FROM zehn_01.PHARMACIST@director_02_01  Ph1
  WHERE Ph1.PharmacistID = v_PharmacistID;
   IF (dem =1) THEN
	UPDATE zehn_01.PHARMACIST@director_02_01
	SET WorkShift = v_WorkShift
	WHERE PharmacistID = v_PharmacistID;
   END IF;
 END IF;
COMMIT;
END;

-- truoc khi chay Procedure
select WorkShift,PHARMACISTID from PHARMACIST where PHARMACISTID = 'PH10';
-- thuc hien Procedure
begin 
   ChangeWorkShift ('PH10', 4);
end;
-- sau khi chay
select WorkShift,PHARMACISTID from PHARMACIST where PHARMACISTID = 'PH10';
--==========================FUNCTION==========================================--
--Function: Tinh tong tien cac hoa don cua mot khach hang bat ky
--Function Name: SumTotalMoney
--Arguments: v_CustomerId  (Ma khach hang)
--Output: Tong tien cac hoa don cua khach hang v_CustomerId

CREATE OR REPLACE FUNCTION SumToTalMoney(v_CustomerId IN VARCHAR2)
RETURN NUMBER
IS total_sum NUMBER :=0;
BEGIN
SELECT SUM(R.Total)INTO total_sum
FROM ZEHN_01.Receipt R
WHERE R.CustomerId = v_CustomerId;
RETURN total_sum;
END;

-- test fuction
select distinct SumTotalMoney ('0985367353') from CUSTOMER;
--==========================SELECT QUERIES====================================--
/**
Cau 1: Truy van tai may ZEHN01

Tai khoan cua hang truong: 
Tim tat ca khach hang co gioi tinh la nu mua san pham thuc pham chuc nang vao ngay 20/10 va co gia tri hoa don tu 500.000 tro len.
Y nghia: Dung trong xem xet ti le khach nu mua hang vao ngay 20/10 so voi tong luong mua cua ngay do.

Dang nhap: manager_01/123456
**/
SELECT 
    C.PhoneNumber, C.FullName
FROM 
    ZEHN_01.CUSTOMER C
WHERE Gender = 'Nu'
      AND NOT EXISTS (
        SELECT * FROM ZEHN_01.RECEIPT R
        WHERE EXTRACT(DAY FROM R.PaymentTime)= 20
                AND EXTRACT(MONTH FROM R.PaymentTime)= 10
                AND R.Total >= 500000
                AND NOT EXISTS (
                    SELECT * FROM 
                        ZEHN_01.RECEIPTDETAIL D, 
                        ZEHN_01.PRODUCT Pr
                    WHERE C.PhoneNumber = R.CustomerId
                        AND R.ReceiptId = D.ReceiptId 
                        AND D.ProductId = Pr.ProductId
                        AND Pr.ProductType = 'TPCN'
                )
    );

/**
Cau 2: Truy van tai may ZEHN01 toi may ZEHN02

Tai khoan giam doc: 
Tim nhung san pham thuc pham chuc nang (ma san pham, ten san pham) ban duoc tai nha thuoc ZENH01 nhung khong ban duoc tai nha thuoc ZENH02.
Y nghia: Nham nam duoc loai san pham khong co phan khuc khach hang phu hop voi moi dia phuong khac nhau.

Dang nhap: director/123456
**/
SELECT 
    Pr.ProductId, Pr.ProductName
FROM 
    ZEHN_01.PRODUCT Pr INNER JOIN ZEHN_01.RECEIPTDETAIL D1
        ON Pr.ProductId = D1.ProductId
WHERE Pr.ProductType = 'TPCN'
MINUS
SELECT 
    Pr.ProductId, Pr.ProductName
FROM  
    ZEHN_01.PRODUCT Pr INNER JOIN ZEHN_02.RECEIPTDETAIL@director_01_02 D2
        ON Pr.ProductId = D2.ProductId
WHERE Pr.ProductType = 'TPCN';

/**
Cau 3: Truy van tai may ZEHN01 toi may ZEHN02

Tai khoan cua hang truong: 
Khach hang co so dien thoai 0985367353 va  0399988381 duoc phat hien duong tinh voi Covid-19. 
Xuat thong tin nhan vien (ma nhan vien, ten nhan vien, so dien thoai, ngay ban) o tat ca chi nhanh tung tiep xuc voi hai khach hang tren 
trong khoang thoi gian tu ngay 15/11/2021 den 30/11/2021.

Dang nhap: manager_01/123456
**/
SELECT 
    Ph1.PharmacistId, Ph1.FullName, Ph1.PhoneNumber, R1.PaymentTime
FROM 
    ZEHN_01.PHARMACIST Ph1, 
    ZEHN_01.RECEIPT R1, 
    ZEHN_01.CUSTOMER C1
WHERE 
    Ph1.PharmacistId = R1.PharmacistId
        AND R1.CustomerId = C1.PhoneNumber
        AND (C1.PhoneNumber = '0985367353' OR C1.PhoneNumber = '0399988381')
        AND R1.PaymentTime BETWEEN  
            TO_DATE('2021-11-15', 'YYYY-MM-DD') 
            AND TO_DATE('2021-11-30', 'YYYY-MM-DD')
UNION
SELECT 
    Ph2.PharmacistId, Ph2.FullName, Ph2.PhoneNumber, R2.PaymentTime
FROM 
    ZEHN_02.PHARMACIST@manager_01_02 Ph2, 
    ZEHN_02.RECEIPT@manager_01_02 R2, 
    ZEHN_01.CUSTOMER C2
WHERE 
    Ph2.PharmacistId = R2.PharmacistId
        AND R2.CustomerId = C2.PhoneNumber
        AND R2.PaymentTime BETWEEN  
            TO_DATE('2021-11-15', 'YYYY-MM-DD') 
            AND TO_DATE('2021-11-30', 'YYYY-MM-DD')
        AND (C2.PhoneNumber = '0985367353' OR C2.PhoneNumber = '0399988381');

/**
Cau 4: Truy van tai may ZEHN01 toi may ZEHN02

Tai khoan cua hang truong: 
Tim san pham con han su dung 30 ngay va deu chua ban duoc lan nao o tat ca chi nhanh.
Y nghia: Nham tim ra san pham khong ban duoc de co the huy bo hang ton va tranh nhap them don hang moi

Dang nhap: manager_01/123456
**/
SELECT * FROM ZEHN_01.PRODUCT Pr
WHERE 
    Pr.ExpiredDate <= (SYSDATE + 30) 
    AND Pr.ExpiredDate > SYSDATE
    AND Pr.ProductId NOT IN (
        SELECT Pr.ProductId FROM 
            ZEHN_01.RECEIPT R1, ZEHN_01.RECEIPTDETAIL D1
        WHERE 
            R1.ReceiptId = D1.ReceiptId
            AND D1.ProductId = Pr.ProductId
    )
INTERSECT
SELECT * FROM ZEHN_01.PRODUCT Pr
WHERE 
    Pr.ExpiredDate <= (SYSDATE + 30) 
    AND Pr.ExpiredDate > SYSDATE
    AND Pr.ProductId NOT IN (
        SELECT Pr.ProductId FROM 
            ZEHN_02.RECEIPT@manager_01_02 R2, 
            ZEHN_02.RECEIPTDETAIL@manager_01_02 D2
        WHERE R2.ReceiptId = D2.ReceiptId
            AND D2.ProductId = Pr.ProductId
    );

/**
Cau 5: Truy xuat tai may ZEHN01

Tai khoan thu ngan: In thong tin tong so luong don vi san pham thanh toan bang Credit Card va tong doanh thu theo thoi gian trong ngay (ca).
Y nghia: Thong ke duoc ty le nguoi dung thanh toan bang the ngan hang va lap bang chi tiet sao ke cho ben ngan hang lien ket.

Dang nhap: cashier_01/123456
**/

SELECT 
    Ph1.WorkShift, SUM(D1.Quantity), SUM(D1.AMOUNT)
FROM 
    ZEHN_01.PHARMACIST Ph1, 
    ZEHN_01.RECEIPT R1, 
    ZEHN_01.RECEIPTDETAIL D1
WHERE  
    Ph1.PharmacistId = R1.PharmacistId
    AND R1.ReceiptId = D1.ReceiptId
    AND R1.PaymentMethod = 'Credit'
GROUP BY Ph1.WorkShift;



--==========================QUERY OPTIMIZER===================================--
------------------------CENTRALIZATION------------------------------------------
    --Original
SELECT /*+ GATHER_PLAN_STATISTICS */
    Ph.PharmacistId, Ph.FullName, Ph.PhoneNumber, 
    R.PaymentTime, 
    ZS.StoreName
FROM 
    PHARMACIST Ph, 
    RECEIPT R, 
    CUSTOMER C,
    ZEHNSTORE ZS
WHERE 
    Ph.PharmacistId = R.PharmacistId
        AND R.CustomerId = C.PhoneNumber
        AND R.StoreId = ZS.StoreId
        AND (C.PhoneNumber = '0985367353' OR C.PhoneNumber = '0399988381')
        AND R.PaymentTime BETWEEN '2021-11-15' AND '2021-11-30';
        
SELECT * FROM TABLE(DBMS_XPLAN.display_cursor(format=>'ALLSTATS LAST'));

    --Optimized
EXPLAIN PLAN FOR
SELECT /*+ GATHER_PLAN_STATISTICS */
    RPh.PharmacistId, RPh.FullName, RPh.PhoneNumber,
    RPh.PaymentTime,
    ZS.StoreName
FROM
(
    SELECT StoreId, StoreName FROM ZEHNSTORE
) ZS, 
(
    SELECT R.StoreId
    FROM 
    (
    SELECT
        PharmacistId, CustomerId, StoreId, PaymentTime
        FROM RECEIPT
        WHERE PaymentTime BETWEEN ('2021-11-15') AND ('2021-11-30')
    ) R, 
    (
        SELECT PhoneNumber FROM CUSTOMER
        WHERE PhoneNumber = '0985367353'
        OR PhoneNumber = '0399988381'
    ) C
    WHERE C.PhoneNumber = R.CustomerId
) RC, 
(
    SELECT
        Ph.PharmacistId, FullName, PhoneNumber,
        R.StoreId, PaymentTime
    FROM 
    (
        SELECT
            PharmacistId, CustomerId, StoreId, PaymentTime
        FROM RECEIPT
        WHERE PaymentTime BETWEEN ('2021-11-15') AND ('2021-11-30')
    ) R, 
    (
        SELECT PharmacistId, FullName, PhoneNumber
        FROM PHARMACIST
    ) Ph
    WHERE Ph.PharmacistId = R.PharmacistId
) RPh
WHERE
    RPh.StoreId = RC.StoreId AND RPh.StoreId = ZS.StoreId;
        
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
   
SELECT * FROM TABLE(DBMS_XPLAN.display_cursor(format=>'ALLSTATS LAST'));

----------------------------DISTRIBUTION----------------------------------------
SELECT DISTINCT
    RPh.PharmacistId, RPh.FullName, RPh.PhoneNumber,
    RPh.PaymentTime,
    ZS.StoreName
FROM
(
    SELECT StoreId, StoreName 
    FROM zehn_01.ZEHNSTORE
    UNION
    SELECT StoreId, StoreName 
    FROM zehn_02.ZEHNSTORE@manager_01_02
) ZS, 
(
    SELECT R.StoreId
    FROM 
    (
        SELECT PharmacistId, CustomerId, StoreId, PaymentTime
        FROM zehn_01.RECEIPT
        WHERE PaymentTime BETWEEN ('2021-11-15') AND ('2021-11-30')
        UNION
        SELECT PharmacistId, CustomerId, StoreId, PaymentTime
        FROM zehn_02.RECEIPT@manager_01_02
        WHERE PaymentTime BETWEEN ('2021-11-15') AND ('2021-11-30')
    ) R, 
    (
        SELECT PhoneNumber 
        FROM zehn_01.CUSTOMER
        WHERE PhoneNumber = '0985367353' OR PhoneNumber = '0399988381'
    ) C
    WHERE C.PhoneNumber = R.CustomerId
) RC, 
(
    SELECT
        Ph.PharmacistId, FullName, PhoneNumber,
        R.StoreId, PaymentTime
    FROM 
    (
        SELECT PharmacistId, CustomerId, StoreId, PaymentTime
        FROM zehn_01.RECEIPT
        WHERE PaymentTime BETWEEN ('2021-11-15') AND ('2021-11-30')
        UNION
        SELECT PharmacistId, CustomerId, StoreId, PaymentTime
        FROM zehn_02.RECEIPT@manager_01_02
        WHERE PaymentTime BETWEEN ('2021-11-15') AND ('2021-11-30')
    ) R, 
    (
        SELECT PharmacistId, FullName, PhoneNumber
        FROM zehn_01.PHARMACIST
        UNION
        SELECT PharmacistId, FullName, PhoneNumber
        FROM zehn_02.PHARMACIST@manager_01_02
    ) Ph
    WHERE Ph.PharmacistId = R.PharmacistId
) RPh
WHERE
    RPh.StoreId = RC.StoreId AND RPh.StoreId = ZS.StoreId;









