/*----- CÂU 1. Tạo user tên BAITHI gồm có 4 table USER, CHANNEL, VIDEO, SHARE. Tạo khóa chính,
khóa ngoại cho các table đó. -----*/

/* Create user for this exercise and configuration -------------------------- */

ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER BTHTTT2 IDENTIFIED BY "123456";
GRANT sysdba TO BTHTTT2;
ALTER SESSION SET NLS_DATE_FORMAT = ' DD/MM/YY HH24:MI:SS ';
ALTER USER BTHTTT2 QUOTA UNLIMITED ON USERS;

/* Create tables ------------------------------------------------------------ */

CREATE TABLE BTHTTT2.USER_NEW (
    U_ID        VARCHAR(3),
    USERNAME    VARCHAR(20),
    PASS        VARCHAR(20),
    REGDAY      DATE,
    NATIONALITY VARCHAR(20), 
    CONSTRAINT PK_USER_NEW PRIMARY KEY (U_ID)
);

CREATE TABLE BTHTTT2.CHANNEL (
    CHANNELID   VARCHAR(4),
    CNAME       VARCHAR(20),
    SUBSCRIBES  NUMBER,
    OWNNER      VARCHAR(3),
    CREATED     DATE,
    CONSTRAINT PK_CHANNELID PRIMARY KEY(CHANNELID)
);

CREATE TABLE BTHTTT2.VIDEO (
    VIDEOID     VARCHAR(7),
    TITLE       VARCHAR(100),
    DURATION    NUMBER,
    AGE         NUMBER,
    CONSTRAINT PK_VIDEO PRIMARY KEY(VIDEOID)
);

CREATE TABLE BTHTTT2.SHARE_NEW (
    VIDEOID     VARCHAR(7),
    CHANNELID   VARCHAR(4),
    CONSTRAINT PK_SHARE_NEW PRIMARY KEY (VIDEOID, CHANNELID)
);

/* Foreign Key Referencing -------------------------------------------------- */

ALTER TABLE BTHTTT2.CHANNEL ADD FOREIGN KEY (OWNNER) 
                REFERENCES BTHTTT2.USER_NEW(U_ID);
ALTER TABLE BTHTTT2.SHARE_NEW ADD FOREIGN KEY (VIDEOID) 
                REFERENCES BTHTTT2.VIDEO(VIDEOID);
ALTER TABLE BTHTTT2.SHARE_NEW ADD FOREIGN KEY (CHANNELID) 
                REFERENCES BTHTTT2.CHANNEL(CHANNELID);


/* Data initialization ------------------------------------------------------ */

INSERT INTO BTHTTT2.USER_NEW VALUES('001', 'faptv', '123456abc', '01/01/2014', 'Việt Nam');
INSERT INTO BTHTTT2.USER_NEW VALUES('002', 'kemxoitv', '@147869iii', '05/06/2015', 'Campuchia');
INSERT INTO BTHTTT2.USER_NEW VALUES('003', 'openshare', 'qwertyuiop', '12/05/2009', 'Việt Nam');

INSERT INTO BTHTTT2.CHANNEL VALUES('C120', 'FAP TV', 2343, '001', '02/01/2014');
INSERT INTO BTHTTT2.CHANNEL VALUES('C905', 'Kem xôi TV', 1032, '002', '09/07/2015');
INSERT INTO BTHTTT2.CHANNEL VALUES('C357', 'OpenShare Cáfe', 5064, '003', '10/12/2010');

INSERT INTO BTHTTT2.VIDEO VALUES('V100229', 'FAPtv Cơm Nguội Tập 41 - �?ột Nhập', 469, 18);
INSERT INTO BTHTTT2.VIDEO VALUES('V211002', 'Kem xôi: Tập 31 -  Mẩy Kool tình yêu của anh', 312, 16);
INSERT INTO BTHTTT2.VIDEO VALUES('V400002', 'Nơi tình yêu kết thúc - Hoàng Tuấn', 378, 0);

INSERT INTO BTHTTT2.SHARE_NEW VALUES('V100229', 'C905');
INSERT INTO BTHTTT2.SHARE_NEW VALUES('V211002', 'C120');
INSERT INTO BTHTTT2.SHARE_NEW VALUES('V400002', 'C357');

/* CÂU 3. Hiện thực ràng buộc toàn vẹn sau: Ngày đăng ký được 
           mặc định là ngày hiện tại.*/
           
CREATE OR REPLACE TRIGGER USER_NEW_REGDAY 
    BEFORE INSERT ON BTHTTT2.USER_NEW
    FOR EACH ROW BEGIN
        :NEW.REGDAY := SYSDATE;
    END;

/* CÂU 4. Hiện thực ràng buộc toàn vẹn sau: Ngày tạo kênh luôn 
           lớn hơn hoặc bằng ngày đăng ký của ngư�?i dùng sở 
           hữu kênh đó. */


/* CÂU 5. Tìm tất cả các video có giới hạn độ tuổi từ 16 trở lên. */

SELECT * FROM BTHTTT2.VIDEO WHERE AGE >= 16;

/* CÂU 6. Tìm kênh có số ngư�?i theo dõi nhi�?u nhất. */
SELECT * FROM BTHTTT2.CHANNEL 
        WHERE OWNNER >= ALL (
                SELECT OWNNER
                FROM BTHTTT2.CHANNEL
        );

/* CÂU 7. Với mỗi video có giới hạn độ tuổi là 18, thống 
           kê số kênh đã chia sẻ. */
           
SELECT VIDEO.VIDEOID, COUNT(CHANNELID) AS COUNT_CHANNEL_SHARED
        FROM BTHTTT2.VIDEO VIDEO JOIN BTHTTT2.SHARE_NEW SHARE_NEW 
                ON VIDEO.VIDEOID = SHARE_NEW.VIDEOID
        WHERE AGE >= 18 GROUP BY VIDEO.VIDEOID;

/*----- CÂU 8. Tìm video được tất cả các kênh chia sẻ.  -----*/
SELECT * FROM BTHTTT2.VIDEO VIDEO
        WHERE NOT EXISTS (
                SELECT * FROM BTHTTT2.CHANNEL CHANNEL
                WHERE NOT EXISTS (
                        SELECT * FROM BTHTTT2.SHARE_NEW SHARE_NEW
                                WHERE SHARE_NEW.VIDEOID= VIDEO.VIDEOID
                                AND SHARE_NEW.CHANNELID = CHANNEL.CHANNELID
                )
        );

-- C�?CH 2: dùng COUNT
SELECT VIDEOID FROM BTHTTT2.SHARE_NEW
        GROUP BY VIDEOID
        HAVING COUNT(DISTINCT CHANNELID) = (
                SELECT COUNT(CHANNELID) FROM BTHTTT2.CHANNEL
        );

-- C�?CH 3: dùng NOT IN
SELECT * FROM BTHTTT2.VIDEO VIDEO
        WHERE VIDEOID NOT IN (
                SELECT VIDEOID FROM BTHTTT2.CHANNEL CHANNEL
                WHERE CHANNELID NOT IN (
                        SELECT CHANNELID FROM BTHTTT2.SHARE_NEW SHARE_NEW
                                WHERE SHARE_NEW.VIDEOID= VIDEO.VIDEOID
                                AND SHARE_NEW.CHANNELID = CHANNEL.CHANNELID
                )
        );  