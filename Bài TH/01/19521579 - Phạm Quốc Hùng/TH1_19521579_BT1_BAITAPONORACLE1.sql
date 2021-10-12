
/* Create user for this exercise and configuration -------------------------- */

ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER BTHTTT1 IDENTIFIED BY "123456";
GRANT sysdba TO BTHTTT1;
ALTER SESSION SET NLS_DATE_FORMAT = ' DD/MM/YY HH24:MI:SS ';
ALTER USER BTHTTT1 QUOTA UNLIMITED ON USERS;

/* Create tables ------------------------------------------------------------ */

CREATE TABLE BTHTTT1.XE (
    MAXE        VARCHAR2(3),
    BIENKS      VARCHAR2(10),
    MATUYEN     VARCHAR(4),
    SOGHET1     NUMBER,
    SOGHET2     NUMBER,
    CONSTRAINT PK_XE PRIMARY KEY(MAXE)
)

CREATE TABLE BTHTTT1.TUYEN (
    MATUYEN     VARCHAR(4),
    BENDAU      VARCHAR(3) NOT NULL,
    BENCUOI     VARCHAR(3) NOT NULL,
    GIATUYEN    DECIMAL,
    NGXB        DATE,
    TGDK        NUMBER,
    CONSTRAINT PK_TUYEN PRIMARY KEY(MATUYEN)
)

CREATE TABLE BTHTTT1.HANHKHACH (
    MAHK        VARCHAR(4),
    HOTEN       VARCHAR(20),
    GIOITINH    VARCHAR(3),
    CMND        NUMBER(11),
    CONSTRAINT PK_HANHKHACH PRIMARY KEY(MAHK)
)

CREATE TABLE BTHTTT1.VEXE (
    MATUYEN VARCHAR(4),
    MAHK VARCHAR(4),
    NGMUA DATE,
    GIAVE DECIMAL,
    CONSTRAINT PK_VEXE PRIMARY KEY (MATUYEN, MAHK, NGMUA)
)

/* Foreign Key Referencing -------------------------------------------------- */



/* Data initialization ------------------------------------------------------ */

INSERT INTO BTHTTT1.XE VALUES('X01', '52LD-4393', 'T11A', 20, 20);
INSERT INTO BTHTTT1.XE VALUES('X02', '59LD-7247', 'T32D', 36, 36);
INSERT INTO BTHTTT1.XE VALUES('X03', '55LD-6850', 'T06F', 15, 15);

INSERT INTO BTHTTT1.TUYEN VALUES('T11A', 'SG', 'DL', 210.000, '26/12/2016', 6);
INSERT INTO BTHTTT1.TUYEN VALUES('T32D', 'PT', 'SG', 120.000, '30/12/2016', 4);
INSERT INTO BTHTTT1.TUYEN VALUES('T06F', 'NT', 'DNG', 225.000, '02/01/2017', 7);

INSERT INTO BTHTTT1.HANHKHACH VALUES ('KH01', 'Lâm Văn B�?n', 'Nam', 655615896);
INSERT INTO BTHTTT1.HANHKHACH VALUES ('KH02', 'Dương Thị Lục', 'Nữ', 275648642);
INSERT INTO BTHTTT1.HANHKHACH VALUES ('KH03', 'Hoàng Thanh Tùng', 'Nam', 456889143);

INSERT INTO BTHTTT1.VEXE VALUES ('T11A', 'KH01', '20/12/2016', 210.000);
INSERT INTO BTHTTT1.VEXE VALUES ('T32D', 'KH02', '25/12/2016', 144.000);
INSERT INTO BTHTTT1.VEXE VALUES ('T06F', 'KH03', '30/12/2016', 270.000);


/* CÂU 3. Hiện thực ràng buộc toàn vẹn sau: Các tuyến xe có 
           Th�?i gian dự kiến lớn hơn 5 tiếng luôn có giá tuyến 
           lớn hơn 200.000. */
           
ALTER TABLE BTHTTT1.TUYEN ADD CONSTRAINT CHECK_GIATUYEN 
                CHECK((TGDK > 5 AND GIATUYEN > 200.000) OR TGDK <= 5);

/* CÂU 4. Hiện thực ràng buộc toàn vẹn sau: Tuyến xe có ngày 
           xuất bến từ ngày 29/12/2016 đến ngày 05/01/2017 sẽ có
           giá vé tăng 20%. */



/* CÂU 5. Tìm tất cả các vé xe mua trong tháng 12, sắp xếp kết 
           quả giảm dần theo giá vé. */
           
SELECT * FROM BTHTTT1.VEXE 
        WHERE EXTRACT( MONTH FROM NGMUA) = 12
        ORDER BY GIAVE DESC;

/* CÂU 6. Tìm tuyến xe có số vé xe ít nhất trong năm 2016. */

SELECT DISTINCT MATUYEN FROM BTHTTT1.VEXE 
        WHERE EXTRACT(YEAR FROM NGMUA) = 2016
        GROUP BY MATUYEN
        HAVING COUNT(MATUYEN) <= ALL (
                SELECT COUNT(MATUYEN) FROM BTHTTT1.VEXE
                        WHERE EXTRACT(YEAR FROM NGMUA) = 2016
                        GROUP BY MATUYEN
        );

/* CÂU 7. Tìm tuyến xe có cả hành khách nam và hành khách nữ mua vé. */

SELECT VEXE.MATUYEN FROM BTHTTT1.VEXE VEXE 
                JOIN BTHTTT1.HANHKHACH HK ON VEXE.MAHK = HK.MAHK
        WHERE GIOITINH = 'Nam'
                    
INTERSECT
                    
SELECT VEXE.MATUYEN FROM BTHTTT1.VEXE VEXE 
                JOIN BTHTTT1.HANHKHACH HK ON VEXE.MAHK = HK.MAHK
        WHERE GIOITINH = 'Nữ';

/* CÂU 8. Tìm hành khách nữ đã từng mua vé tất cả các tuyến xe */
SELECT * FROM BTHTTT1.HANHKHACH HK
        WHERE GIOITINH = 'Nữ'
        AND NOT EXISTS (
                SELECT * FROM BTHTTT1.TUYEN TUYEN 
                        WHERE NOT EXISTS (
                                SELECT * FROM BTHTTT1.VEXE VEXE
                                        WHERE VEXE.MATUYEN = TUYEN.MATUYEN
                                        AND VEXE.MAHK = HK.MAHK
                        )
        );
                     
-- C�?CH 2: dùng COUNT

SELECT VEXE.MAHK FROM BTHTTT1.VEXE VEXE JOIN BTHTTT1.HANHKHACH HK ON VEXE.MAHK = HK.MAHK
WHERE GIOITINH = 'Nữ'
GROUP BY VEXE.MAHK
HAVING COUNT(DISTINCT MATUYEN) = (
                                   SELECT COUNT(MATUYEN)
                                   FROM BTHTTT1.TUYEN
                                 );                      
                        
-- C�?CH 3: dùng NOT IN
SELECT * FROM BTHTTT1.HANHKHACH HK
        WHERE GIOITINH = 'Nữ'
        AND MAHK NOT IN (
                SELECT MAHK FROM BTHTTT1.TUYEN TUYEN 
                        WHERE MATUYEN NOT IN (
                                SELECT MATUYEN FROM BTHTTT1.VEXE VEXE
                                        WHERE VEXE.MATUYEN = TUYEN.MATUYEN
                                        AND VEXE.MAHK = HK.MAHK
                        )
        );
                    