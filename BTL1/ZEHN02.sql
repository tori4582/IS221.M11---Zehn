--==========================May ZEHN02========================================--

-- Login sqlplus as SYSDBA and create user and grant privilege
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER zehn_02 IDENTIFIED BY 123456;
GRANT CONNECT, DBA TO zehn_02;

CREATE USER director IDENTIFIED BY 123456;
CREATE USER zehn_bridge IDENTIFIED BY 123456;
CREATE USER manager_02 IDENTIFIED BY 123456;
CREATE USER cashier_02 IDENTIFIED BY 123456;

-- Create Role R_Director and grant priviliges

GRANT CREATE SESSION, CONNECT, RESOURCE TO director;

GRANT CREATE PUBLIC DATABASE LINK TO director;
GRANT ALTER PUBLIC DATABASE LINK TO director;
GRANT DROP PUBLIC DATABASE LINK TO director;

GRANT CREATE PUBLIC DATABASE LINK TO manager_02;

GRANT CREATE USER TO director;
GRANT ALTER USER TO director;
GRANT DROP USER TO director;

--==========================CREATE TABLE======================================--
-- Open SQL Developer, add a new connection using user zehn_02
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
    Address         NVARCHAR2(150)  NOT NULL,
    WorkYear        NUMBER          NOT NULL,
    WorkShift       NUMBER          NOT NULL,
    StoreId         VARCHAR2(10)    NOT NULL,
    
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
    ProductName     NVARCHAR2(150)   NOT NULL,
    ProductType     NVARCHAR2(30),
    ExpiredDate     DATE            NOT NULL,
    CountUnit       NVARCHAR2(10),
    Price           NUMBER          NOT NULL,
    
    CONSTRAINT PK_PRODUCT PRIMARY KEY(ProductId)
);

CREATE TABLE zehn_02.RECEIPT(
    ReceiptId       VARCHAR2(10),
    CustomerId      VARCHAR2(15)    NOT NULL,
    PharmacistId    VARCHAR2(10)    NOT NULL,
    StoreId         VARCHAR2(10)    NOT NULL,
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
    
    CONSTRAINT PK_DETAIL PRIMARY KEY(ReceiptId, ProductId)
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
-- login SQLPLUS zehn_02/123456
INSERT INTO zehn_02.CUSTOMER
SELECT * FROM zehn_01.CUSTOMER@manager_02_01;

    -- insert data into PRODUCT
-- login SQLPLUS zehn_02/123456
INSERT INTO zehn_02.PRODUCT
SELECT * FROM zehn_01.PRODUCT@manager_02_01;

    -- insert data into RECEIPT
INSERT INTO zehn_02.RECEIPT VALUES('R21', '0380882442', 'PH21', 'ZS02', '2021-07-31', 124000, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R22', '0784878027', 'PH37', 'ZS02', '2021-08-15', 336000, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R23', '0399988381', 'PH33', 'ZS02', '2021-05-22', 120000, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R24', '0971820839', 'PH22', 'ZS02', '2021-06-17', 20000, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R25', '0861347402', 'PH39', 'ZS02', '2021-06-19', 3372000, 'Zehn Point');    
INSERT INTO zehn_02.RECEIPT VALUES('R26', '0827397398', 'PH28', 'ZS02', '2021-05-09', 952980, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R27', '0966657718', 'PH25', 'ZS02', '2021-03-28', 120000, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R28', '0359055883', 'PH40', 'ZS02', '2021-04-13', 658000, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R29', '0836564633', 'PH24', 'ZS02', '2021-01-05', 377000, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R30', '0828228999', 'PH31', 'ZS02', '2021-12-14', 8850000, 'Zehn Point');    
INSERT INTO zehn_02.RECEIPT VALUES('R31', '0356702531', 'PH38', 'ZS02', '2021-09-26', 1600000, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R32', '0392215332', 'PH35', 'ZS02', '2021-07-01', 500000, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R33', '0356702531', 'PH26', 'ZS02', '2021-11-11', 212000, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R34', '0976716565', 'PH23', 'ZS02', '2021-01-05', 74700, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R35', '0828228999', 'PH35', 'ZS02', '2021-02-12', 56000, 'Zehn Point');    
INSERT INTO zehn_02.RECEIPT VALUES('R36', '0399988381', 'PH34', 'ZS02', '2021-11-15', 102800, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R37', '0392215332', 'PH23', 'ZS02', '2021-03-15', 497000, 'Cash');    
INSERT INTO zehn_02.RECEIPT VALUES('R38', '0852896366', 'PH26', 'ZS02', '2021-12-05', 459500, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R39', '0700382483', 'PH36', 'ZS02', '2021-04-13', 15600, 'Credit');    
INSERT INTO zehn_02.RECEIPT VALUES('R40', '0700382483', 'PH40', 'ZS02', '2021-04-23', 125000, 'Credit');    


    -- insert data into RECEIPTDETAIL
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R21', 'PR05', 2, 62000, 124000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R22', 'PR04', 3, 112000, 336000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R23', 'PR17', 1, 120000, 120000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R24', 'PR23', 10, 800, 8000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R24', 'PR24', 1, 12000, 12000); 
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R25', 'PR15', 1, 347000, 347000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R25', 'PR40', 1, 2950000, 2950000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R25', 'PR09', 1, 75000, 75000); 
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR11', 2, 360000, 720000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR25', 3, 23100, 69300);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR37', 2, 25740, 51480);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR21', 3, 7400, 22200);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R26', 'PR03', 1, 90000, 90000);  
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R27', 'PR19', 2, 60000, 120000);  
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R28', 'PR35', 1, 149000, 149000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R28', 'PR13', 1, 63000, 63000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R28', 'PR20', 1, 86000, 86000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R28', 'PR11', 1, 360000, 360000);   
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R29', 'PR17', 2, 120000, 240000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R29', 'PR08', 1, 137000, 137000);  
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R30', 'PR40', 3, 2950000, 8850000); 
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R31', 'PR39', 1, 1600000, 1600000); 
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R32', 'PR38', 2, 25000, 50000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R32', 'PR34', 1, 450000, 450000);
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R33', 'PR02', 1, 144000, 144000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R33', 'PR28', 2, 9500, 19000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R33', 'PR01', 1, 49000, 49000);
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R34', 'PR36', 1, 74700, 74700);  
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R35', 'PR10', 1, 56000, 56000);  
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R36', 'PR27', 1, 102800, 102800);   
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R37', 'PR08', 1, 137000, 137000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R37', 'PR12', 2, 180000, 360000);  
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R38', 'PR38', 3, 25000, 75000);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R38', 'PR26', 5, 7500, 37500);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R38', 'PR15', 1, 347000, 347000);  
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R39', 'PR29', 20, 780, 15600);    
INSERT INTO zehn_02.RECEIPTDETAIL VALUES('R40', 'PR38', 5, 25000, 125000);    
    
-- enable foreign key
ALTER TABLE zehn_02.PHARMACIST      ENABLE CONSTRAINT FK_PHARMARCIST_StoreId;
ALTER TABLE zehn_02.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_CustomerId;
ALTER TABLE zehn_02.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_StoreId;
ALTER TABLE zehn_02.RECEIPT         ENABLE CONSTRAINT FK_RECEIPT_PharmacistId;
ALTER TABLE zehn_02.RECEIPTDETAIL   ENABLE CONSTRAINT FK_DETAIL_ReceiptId;
ALTER TABLE zehn_02.RECEIPTDETAIL   ENABLE CONSTRAINT FK_DETAIL_ProductId;

--==========================CREATE DATABASE LINK==============================--
-- login sqlplus as user director/123456
CREATE PUBLIC DATABASE LINK director_02_01 CONNECT TO director IDENTIFIED BY "123456" USING 'ZEHN_02';

-- login sqlplus as user manager_02/123456
CREATE PUBLIC DATABASE LINK manager_02_01 CONNECT TO zehn_bridge IDENTIFIED BY "123456" USING 'ZEHN_02';

--==========================select ALL for checking===========================--
SELECT * FROM zehn_02.ZEHNSTORE;
SELECT * FROM zehn_02.PHARMACIST;
SELECT * FROM zehn_01.CUSTOMER@manager_02_01;
SELECT * FROM zehn_01.PRODUCT@manager_02_01;
SELECT * FROM zehn_02.RECEIPT;
SELECT * FROM zehn_02.RECEIPTDETAIL;

--==========================GRANTING PRIVILIGES===============================--
-- login sqlplus as SYSDBA
-----GRANTING for DIRECTOR-----
    -- ZEHNSTORE
GRANT INSERT ON zehn_02.ZEHNSTORE TO director;      
GRANT UPDATE ON zehn_02.ZEHNSTORE TO director;
GRANT DELETE ON zehn_02.ZEHNSTORE TO director;
GRANT SELECT ON zehn_02.ZEHNSTORE TO director;

GRANT INSERT ON zehn_01.ZEHNSTORE@director_02_01 TO director;
GRANT UPDATE ON zehn_01.ZEHNSTORE@director_02_01 TO director;
GRANT DELETE ON zehn_01.ZEHNSTORE@director_02_01 TO director;
GRANT SELECT ON zehn_01.ZEHNSTORE@director_02_01 TO director;

    -- PHARMACIST
GRANT INSERT ON zehn_02.PHARMACIST TO director;     
GRANT UPDATE ON zehn_02.PHARMACIST TO director;
GRANT DELETE ON zehn_02.PHARMACIST TO director;
GRANT SELECT ON zehn_02.PHARMACIST TO director;

GRANT UPDATE ON zehn_01.PHARMACIST@director_02_01 TO director;
GRANT INSERT ON zehn_01.PHARMACIST@director_02_01 TO director;
GRANT DELETE ON zehn_01.PHARMACIST@director_02_01 TO director;
GRANT SELECT ON zehn_01.PHARMACIST@director_02_01 TO director;

-- Just ZEHN_01 store because of replication
    -- PRODUCT
GRANT INSERT ON zehn_02.PRODUCT TO director;        
GRANT UPDATE ON zehn_02.PRODUCT TO director;
GRANT DELETE ON zehn_02.PRODUCT TO director;
GRANT SELECT ON zehn_02.PRODUCT TO director;

    -- CUSTOMER
GRANT SELECT ON zehn_02.CUSTOMER TO director;     

    -- RECEIPT
GRANT SELECT ON zehn_02.RECEIPT TO director;       
GRANT SELECT ON zehn_01.RECEIPT@director_02_01 TO director;

    -- RECEIPT DETAIL
GRANT SELECT ON zehn_02.RECEIPTDETAIL TO director;  
GRANT SELECT ON zehn_01.RECEIPTDETAIL@director_02_01 TO director;

-----GRANTING for ZEHN_BRIDGE-----

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE ROLE R_MANAGER;

GRANT CREATE SESSION, CONNECT TO R_MANAGER;

    -- PRODUCT
GRANT CREATE ON zehn_01.PRODUCT@director_02_01 TO R_MANAGER;       
GRANT ALTER ON zehn_01.PRODUCT@director_02_01 TO R_MANAGER;
GRANT DROP ON zehn_01.PRODUCT@director_02_01 TO R_MANAGER;
GRANT SELECT ON zehn_01.PRODUCT@director_02_01 TO R_MANAGER;

    -- CUSTOMER	
GRANT UPDATE ON zehn_01.CUSTOMER@director_02_01 TO R_MANAGER;      
GRANT INSERT ON zehn_01.CUSTOMER@director_02_01 TO R_MANAGER;
GRANT DELETE ON zehn_01.CUSTOMER@director_02_01 TO R_MANAGER;
GRANT SELECT ON zehn_01.CUSTOMER@director_02_01 TO R_MANAGER;
	
    -- ZEHNSTORE
GRANT SELECT ON zehn_02.ZEHNSTORE TO R_MANAGER;     
GRANT SELECT ON zehn_01.ZEHNSTORE@manager_02_01 TO R_MANAGER;

    -- PHARMACIST
GRANT SELECT ON zehn_02.PHARMACIST TO R_MANAGER;    
GRANT SELECT ON zehn_01.PHARMACIST@manager_02_01 TO R_MANAGER;

    -- RECEIPT
GRANT SELECT ON zehn_02.RECEIPT TO R_MANAGER;       
GRANT SELECT ON zehn_01.RECEIPT@manager_02_01 TO R_MANAGER;

    -- RECEIPT DETAIL
GRANT SELECT ON zehn_02.RECEIPTDETAIL TO R_MANAGER; 
GRANT SELECT ON zehn_01.RECEIPTDETAIL@manager_02_01 TO R_MANAGER;

GRANT R_MANAGER TO zehn_bridge;

-----GRANTING for MANAGER-----

GRANT R_MANAGER TO manager_02;

    -- PHARMACIST
GRANT UPDATE ON zehn_02.PHARMACIST TO manager_02;   
GRANT INSERT ON zehn_02.PHARMACIST TO manager_02;
GRANT DELETE ON zehn_02.PHARMACIST TO manager_02;

    -- RECEIPT
GRANT INSERT ON zehn_02.RECEIPT TO manager_02;      
GRANT UPDATE ON zehn_02.RECEIPT TO manager_02;
GRANT DELETE ON zehn_02.RECEIPT TO manager_02;

    -- RECEIPT DETAIL
GRANT INSERT ON zehn_02.RECEIPTDETAIL TO manager_02;
GRANT DELETE ON zehn_02.RECEIPTDETAIL TO manager_02;
GRANT UPDATE ON zehn_02.RECEIPTDETAIL TO manager_02;
    
    -- PRODUCT
grant select on zehn_02.product to manager_02;

-----GRANTING for CASHIER-----
GRANT CONNECT, CREATE SESSION TO cashier_02;

GRANT SELECT ON zehn_02.ZEHNSTORE TO cashier_02;
GRANT SELECT ON zehn_02.CUSTOMER TO cashier_02;
GRANT SELECT ON zehn_02.PRODUCT TO cashier_02;

GRANT INSERT ON zehn_01.CUSTOMER TO cashier_02;
GRANT UPDATE ON zehn_01.CUSTOMER TO cashier_02;
GRANT DELETE ON zehn_01.CUSTOMER TO cashier_02;
GRANT SELECT ON zehn_01.CUSTOMER TO cashier_02;
	
GRANT INSERT ON zehn_02.RECEIPT TO cashier_02;
GRANT UPDATE ON zehn_02.RECEIPT TO cashier_02;
GRANT DELETE ON zehn_02.RECEIPT TO cashier_02;
GRANT SELECT ON zehn_02.RECEIPT TO cashier_02;
	
GRANT INSERT ON zehn_02.RECEIPTDETAIL TO cashier_02;
GRANT UPDATE ON zehn_02.RECEIPTDETAIL TO cashier_02;
GRANT DELETE ON zehn_02.RECEIPTDETAIL TO cashier_02;
GRANT SELECT ON zehn_02.RECEIPTDETAIL TO cashier_02;

--==========================TRIGGER===========================================--
-- create or replace TRIGGER

-- test the TRIGGERs

--==========================PROCEDURE=========================================--

--==========================FUNCTION==========================================--

--==========================SELECT QUERIES====================================--
--Cau 6: 
--Truy van tai may ZEHN02 
--Tai khoan thu ngan: Truoc khi thanh toan, kiem tra ZehnPoint dang tich luy de co the thay the thanh toan tien mat hay khong? In ra thong tin khach hang
--Y nghia: Su dung trong truong hop khach hang muon su dung diem ZehnPoint de thanh toan ma khong can dung tien mat
--Dang nhap: cashier_02/123456

SELECT  
      C2.PhoneNumber, FullName, ZehnPoint, R2.ReceiptId, R2.Total
FROM
	zehn_02.CUSTOMER C2, 
      zehn_02.RECEIPT R2 
WHERE 
 R2.CustomerId = C2.PhoneNumber AND
 Total <= ZehnPoint;

--Cau 7: 
--Truy van tai may ZEHN02 toi may ZEHN01
--Tai khoan cua hang truong:  So luong tieu thu cua tung product theo tung thang tu tat ca cac chi nhanh
--Y nghia: De biet duoc doanh so cua cac san pham theo tung vi tri de dua ra du doan kinh doanh va dieu chinh so luong nhap san pham phu hop.
--Dang nhap: manager_02/123456


SELECT  
    EXTRACT(month FROM R2.PaymentTime) AS "Month" ,    
    Sum(D2.Quantity) AS "Tong_san_luong", 
    Pr.CountUnit,
    Pr.ProductName
FROM 
    zehn_02.RECEIPTDETAIL D2,
    zehn_02.RECEIPT R2,
    zehn_02.PRODUCT Pr
WHERE 
    R2.ReceiptId = D2.ReceiptId
    AND D2.ProductId = Pr.ProductId
GROUP BY R2.PaymentTime, D2.Quantity, Pr.CountUnit, Pr.ProductName
UNION
SELECT  
    EXTRACT(month FROM R1.PaymentTime) AS "Month" ,    
    Sum(D1.Quantity) AS "Tong_san_luong", 
    Pr.CountUnit,
    Pr.ProductName
FROM 
    zehn_01.RECEIPTDETAIL@manager_02_01 D1,
    zehn_01.RECEIPT@manager_02_01 R1,
    zehn_02.PRODUCT Pr
WHERE 
    R1.ReceiptId = D1.ReceiptId
    AND D1.ProductId = Pr.ProductId
GROUP BY R1.PaymentTime, D1.Quantity, Pr.CountUnit, Pr.ProductName;

--Cau 8: 
--Truy van tai may ZEHN02 
--Tai khoan cua hang truong: Xuat ra nhung product chi con han su dung trong 14 ngay (tinh tu ngay hom nay sysdate) tai may ZEHN02
--Y nghia: De nhan vien hieu thuoc co the thanh ly hoac tieu huy truoc khi den han su dung
--Dang nhap: manager_02/123456


SELECT 
    ProductId, ProductName
FROM 
     zehn_02.PRODUCT
WHERE 
     ExpiredDate <= (SYSDATE + 14) AND ExpiredDate > SYSDATE;

--Cau 9: Truy van tai may ZEHN02 toi may ZEHN01
--Tai khoan giam doc: In thong tin cua nhung duoc si co WorkYear >= "2015" va WorkShift = 4 tai tat ca chi nhanh
--Y nghia: Tim xem nhung duoc si co gan bo lau voi cua hang de trao giai “Duoc Si Cu Vo”
--Dang nhap: director/123456

SELECT  Ph2.* 
FROM 
  zehn_02.PHARMACIST Ph2
WHERE 
 Ph2.WorkYear >= 2015 AND Ph2.WorkShift = 4
UNION 
SELECT Ph1.* 
FROM  
  zehn_01.PHARMACIST@director_02_01 Ph1
WHERE 
  Ph1.WorkYear >= 2015 AND Ph1.WorkShift = 4;

--Cau 10: Truy van tai may ZEHN02 toi may ZEHN01
--Tai khoan giam doc: Liet ke cac product duoc tieu thu nhieu nhat tai tung chi nhanh.
--Y nghia: Tuong tu cau 7
--Dang nhap: director/123456


SELECT 
    COUNT(D2.ProductID), ProductName
FROM
    zehn_02.RECEIPTDETAIL D2, 
    zehn_01.PRODUCT@director_02_01 Pr
WHERE 
    Pr.ProductID = D2.ProductID
GROUP BY 
    D2.ProductID, ProductName
HAVING COUNT(D2.ProductID) >= (
    SELECT MAX(COUNT(D2A.ProductID))
    FROM zehn_02.RECEIPTDETAIL D2A
    GROUP BY D2A.ProductID
)
UNION
SELECT 
    COUNT(D1.ProductID), ProductName
FROM
    zehn_01.RECEIPTDETAIL@director_02_01 D1,
    zehn_02.PRODUCT Pr 
WHERE  
    Pr.ProductID = D1.ProductID
GROUP BY
    D1.ProductID, ProductName
HAVING COUNT(D1.ProductID) >= (
    SELECT MAX(COUNT(D1A.ProductID))
    FROM zehn_01.RECEIPTDETAIL@director_02_01 D1A
    GROUP BY D1A.ProductID
);


--==========================ISOLATION LEVEL===================================--

--==========================QUERY OPTIMIZER===================================--








