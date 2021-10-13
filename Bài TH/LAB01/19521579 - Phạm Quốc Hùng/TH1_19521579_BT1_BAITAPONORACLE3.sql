
/* Create user for this exercise and configuration -------------------------- */

ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER BTHTTT3 IDENTIFIED BY "123456";
GRANT sysdba TO BTHTTT3;
ALTER SESSION SET NLS_DATE_FORMAT = ' DD/MM/YY HH24:MI:SS ';
ALTER USER BTHTTT3 QUOTA UNLIMITED ON USERS;

/* Create tables ------------------------------------------------------------ */

CREATE TABLE BTHTTT3.HANGHANGKHONG (
	MAHANG      VARCHAR(2),
	TENHANG     VARCHAR(50),
	NGTL        DATE,
	DUONGBAY    NUMBER,
    CONSTRAINT PK_HANGHANGKHONG PRIMARY KEY (MAHANG)
);

CREATE TABLE BTHTTT3.CHUYENBAY (
	MACB        VARCHAR(5),
	MAHANG      VARCHAR(2),
	XUATPHAT    VARCHAR(20),
	DIEMDEN     VARCHAR(20),
	BATDAU      DATE,
	TGBAY       DECIMAL(18, 1),
    CONSTRAINT PK_CHUYENBAY PRIMARY KEY (MACB)
);

CREATE TABLE BTHTTT3.NHANVIEN (
	MANV        VARCHAR(4),
	HOTEN       VARCHAR(50),
	GIOITINH    VARCHAR(5),
	NGSINH      DATE,
	NGVL        DATE,
	CHUYENMON   VARCHAR(20),
    CONSTRAINT PK_NHANVIEN PRIMARY KEY (MANV)
);

CREATE TABLE BTHTTT3.PHANCONG (
	MACB        VARCHAR(5),
	MANV        VARCHAR(4),
	NHIEMVU     VARCHAR(30),
	CONSTRAINT PK_PHANCONG PRIMARY KEY (MACB, MANV)
);

/* Foreign Key Referencing -------------------------------------------------- */

ALTER TABLE BTHTTT3.CHUYENBAY ADD FOREIGN KEY (MAHANG) 
            REFERENCES BTHTTT3.HANGHANGKHONG(MAHANG);
ALTER TABLE BTHTTT3.PHANCONG ADD FOREIGN KEY (MACB) 
            REFERENCES BTHTTT3.CHUYENBAY(MACB);
ALTER TABLE BTHTTT3.PHANCONG ADD FOREIGN KEY (MANV) 
            REFERENCES BTHTTT3.NHANVIEN(MANV);

/* Data initialization ------------------------------------------------------ */

INSERT INTO BTHTTT3.HANGHANGKHONG VALUES ('VN', 'Vietnam Airlines', '15/01/1956', 52);
INSERT INTO BTHTTT3.HANGHANGKHONG VALUES ('VJ', 'Vietjet Air', '25/12/2011', 33);
INSERT INTO BTHTTT3.HANGHANGKHONG VALUES ('BL', 'Jetstar Pacific Airlines', '01/12/1990', 13);

INSERT INTO BTHTTT3.CHUYENBAY VALUES ('VN550', 'VN', 'TP.HCM', N'Singapore', '20/12/2015 13:15', 2);
INSERT INTO BTHTTT3.CHUYENBAY VALUES ('VJ331', 'VJ', 'Đà Nẵng', N'Vinh', '28/12/2015 22:30', 1);
INSERT INTO BTHTTT3.CHUYENBAY VALUES ('BL696', 'BL', 'TP.HCM', N'Đà Lạt', '24/12/2015 06:00', 0.5);

INSERT INTO BTHTTT3.NHANVIEN VALUES	('NV01', N'Lâm Văn Bền', N'Nam', '10/09/1978', '05/06/2000', N'Phi công');
INSERT INTO BTHTTT3.NHANVIEN VALUES ('NV02', N'Dương Thị Lục', N'Nữ', '22/03/1989', '12/11/2013', N'Tiếp viên');
INSERT INTO BTHTTT3.NHANVIEN VALUES ('NV03', N'Hoàng Thanh Tùng', N'Nam', '29/07/1983', '11/04/2007', N'Tiếp viên');

INSERT INTO BTHTTT3.PHANCONG VALUES ('VN550', 'NV01', N'Cơ trưởng');
INSERT INTO BTHTTT3.PHANCONG VALUES ('VN550', 'NV02', N'Tiếp viên');
INSERT INTO BTHTTT3.PHANCONG VALUES ('BL696', 'NV03', N'Tiếp viên trưởng');


/* CÂU 3. Thực hiện ràng buộc toàn vẹn sau: Chuyên môn của nhân viên 
          chỉ được nhận giá trị là ‘Phi công’ hoặc ‘Tiếp viên’. */
          
ALTER TABLE BTHTTT3.NHANVIEN 
ADD CONSTRAINT CHECK_CHUYENMON CHECK(CHUYENMON = 'Phi công' 
                                        OR CHUYENMON = 'Tiếp viên');

/* CÂU 4. Thực hiện ràng buộc toàn vẹn sau: Ngày bắt đầu chuyến bay luôn 
          lớn hơn ngày thành lập hãng hàng không quản lý chuyến bay đó. */


/* CÂU 5. Tìm tất cả các nhân viên có sinh nhật trong tháng 07. */

SELECT * FROM BTHTTT3.NHANVIEN
         WHERE EXTRACT (MONTH FROM NGSINH) = 07;

/* CÂU 6. Tìm chuyến bay có số nhân viên nhiều nhất. */

SELECT MACB FROM BTHTTT3.PHANCONG 
            GROUP BY MACB
            HAVING COUNT(MANV) >= ALL (
                    SELECT COUNT(MANV) FROM BTHTTT3.PHANCONG
                    GROUP BY MACB
            );  

/* CÂU 7. Với mỗi hãng hàng không, thống kê số chuyến bay có điểm xuất phát
là ‘Đà Nẵng’ và có số nhân viên được phân công ít hơn 2. */

SELECT HHK.MAHANG, COUNT(DISTINCT PC.MACB) AS SOCHUYENBAY
        FROM BTHTTT3.HANGHANGKHONG HHK 
                JOIN BTHTTT3.CHUYENBAY CB  ON HHK.MAHANG = CB.MAHANG
                JOIN BTHTTT3.PHANCONG PC   ON CB.MACB    = PC.MACB   
        WHERE XUATPHAT = 'Đà Nẵng' AND PC.MACB IN (
            -- Tìm các CB có số NV <= 2 của mỗi hãng
                SELECT PC1.MACB FROM BTHTTT3.HANGHANGKHONG HHK1 
                    JOIN BTHTTT3.CHUYENBAY CB1  ON HHK1.MAHANG  = CB1.MAHANG
                    JOIN BTHTTT3.PHANCONG PC1   ON CB1.MACB     = PC1.MACB   
                WHERE XUATPHAT = 'Đà Nẵng'
                GROUP BY HHK1.MAHANG, PC1.MACB
                HAVING COUNT(MANV) <= 2
        )
        GROUP BY HHK.MAHANG;

/* CÂU 8. Tìm nhân viên được phân công tham gia tất cả các chuyến bay. */
SELECT * FROM BTHTTT3.NHANVIEN NV
        WHERE NOT EXISTS (
            SELECT * FROM BTHTTT3.CHUYENBAY CB
            WHERE NOT EXISTS (
                    SELECT * FROM BTHTTT3.PHANCONG PC
                    WHERE PC.MACB = CB.MACB
                        AND PC.MANV = NV.MANV
            )
        );

-- CÁCH 2: dùng COUNT
SELECT MANV FROM BTHTTT3.PHANCONG
        GROUP BY MANV
        HAVING COUNT(DISTINCT MACB) = (
                SELECT COUNT(MACB) FROM BTHTTT3.CHUYENBAY
        );

-- CÁCH 3: dùng NOT IN
SELECT * FROM BTHTTT3.NHANVIEN NV
        WHERE MANV NOT IN (
                SELECT MANV FROM BTHTTT3.CHUYENBAY CB
                WHERE MACB NOT IN (
                        SELECT MACB
                        FROM BTHTTT3.PHANCONG PC
                        WHERE PC.MACB = CB.MACB AND PC.MANV = NV.MANV
                )
        );