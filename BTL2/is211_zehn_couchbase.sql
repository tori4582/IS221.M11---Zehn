-- ######################IS211 - Zehn: Couchbase #####################################

--######################################################################################

-- Truy vấn dữ liệu 

-- example 
select a.id, a.name, a.country from airline a

 -- Truy vấn dữ liệu phân tán bằng Query Workbench của Couchbase dùng N1QL Query
    /* Liệt kê các sân bay (airports) và địa điểm du lịch (landmarks) trong cùng một thành phố, 
    với các thành phố này thuộc nước Mỹ , sắp xếp theo địa điểm du lịch. */
SELECT DISTINCT 
    MIN(aport.airportname) AS Airport__Name,
    MIN(lmark.name) AS Landmark_Name,
    MIN(aport.tz) AS Landmark_Time
FROM 
    `travel-sample`.inventory.airport aport
    RIGHT JOIN `travel-sample`.inventory.landmark lmark
        ON aport.city = lmark.city
        AND aport.country = "United States"
GROUP BY lmark.name
ORDER BY lmark.name;


--######################################################################################

-- Thao tác thêm dữ liệu
INSERT INTO `travel-sample`.inventory.airline ( KEY, VALUE )
VALUES ( "airline-test", {
        "id": 9999,
        "type": "airport",
        "airportname": "Test",
        "city": "Test",
    }
)

--######################################################################################

-- Thao tác xoá dữ liệu

-- Thao tác xoá dữ liệu có điều kiện
    /* Thực hiện xoá các document hotel khách sạn tại thành phố San Francisco 
    tại collection “hotel” của scope “inventory”.*/
DELETE FROM `travel-sample`.inventory.hotel
    WHERE city = "San Francisco";

-- Thao tác xoá dữ liệu sử dụng ID của document
    /* Thực hiện xoá các document airline có ID document là “airline-test” 
    tại collection “airline” của scope “inventory”. */
DELETE FROM `travel-sample`.inventory.airline 
    USE KEYS "airline-test";

--######################################################################################

-- Thao tác sửa dữ liệu

-- Thao tác sửa dữ liệu dùng ID document
    /* Sửa nickname của landmark có ID là 10090 thành “Squiggly Bridge” 
    tại collection “landmark” của scope “inventory”.*/
UPDATE `travel-sample`.inventory.landmark
    USE KEYS "landmark_10090"
    SET nickname = "Squiggly Bridge";

-- Thao tác sửa dữ liệu dùng Sub-query
    /* Thêm thông tin khách sạn cho sân bay có “faa” là “NCE” và thông tin những khách sạn sẽ thêm vào 
    sẽ là tên khách sạn và ID của khách sạn đó với những khách sạn ở thành phố “Nice”.*/
UPDATE `travel-sample`.inventory.airport AS a
SET hotels = (
    SELECT  h.name, h.id
    FROM    `travel-sample`.inventory.hotel AS h
    WHERE   h.city = "Nice"
)
WHERE a.faa ="NCE"
