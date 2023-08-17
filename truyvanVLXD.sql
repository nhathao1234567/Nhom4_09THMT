

--Stored Procedure 


--thêm dữ liệu vào bảng SanPham

CREATE PROCEDURE sp_InsertSanPham
    @MaSanPham INT,
    @TenSanPham NVARCHAR(255),
    @MoTa NVARCHAR(MAX),
    @Gia MONEY,
    @SoLuongTon INT,
    @MaNhaCungCap INT
AS
BEGIN
    INSERT INTO SanPham (MaSanPham, TenSanPham, MoTa, Gia, SoLuongTon, MaNhaCungCap)
    VALUES (@MaSanPham, @TenSanPham, @MoTa, @Gia, @SoLuongTon, @MaNhaCungCap);
END;
-- Gọi stored procedure để thêm dữ liệu vào bảng SanPham
EXEC sp_InsertSanPham
    @MaSanPham = 4,
    @TenSanPham = N'Sản phẩm mới',
    @MoTa = N'Mô tả sản phẩm mới',
    @Gia = 35000,
    @SoLuongTon = 200,
    @MaNhaCungCap = 1;

SELECT* FROM SanPham

--stored procedure để sửa dữ liệu trong bảng SanPham
CREATE PROCEDURE sp_UpdateSanPham
    @MaSanPham INT,
    @TenSanPham NVARCHAR(255),
    @MoTa NVARCHAR(MAX),
    @Gia MONEY,
    @SoLuongTon INT,
    @MaNhaCungCap INT
AS
BEGIN
    UPDATE SanPham
    SET TenSanPham = @TenSanPham,
        MoTa = @MoTa,
        Gia = @Gia,
        SoLuongTon = @SoLuongTon,
        MaNhaCungCap = @MaNhaCungCap
    WHERE MaSanPham = @MaSanPham;
END;
-- Gọi stored procedure để sửa thông tin sản phẩm
EXEC sp_UpdateSanPham
    @MaSanPham = 4,
    @TenSanPham = N'Sản phẩm đã sửa',
    @MoTa = N' sản phẩm đã sửa',
    @Gia = 40000,
    @SoLuongTon = 150,
    @MaNhaCungCap = 2;

SELECT* FROM SanPham


-- stored procedure để xóa dữ liệu trong bảng SanPham
CREATE PROCEDURE sp_DeleteSanPham
    @MaSanPham INT
AS
BEGIN
    DELETE FROM SanPham
    WHERE MaSanPham = @MaSanPham;
END;
-- Gọi stored procedure để xóa dữ liệu khỏi bảng SanPham
EXEC sp_DeleteSanPham
    @MaSanPham = 4; -- Thay đổi mã sản phẩm tương ứng
SELECT* FROM SanPham




--stored procedure để hiển thị danh sách dữ liệu trong bảng Sanpham
CREATE PROCEDURE sp_GetDanhSachSanPham
AS
BEGIN
    SELECT * FROM SanPham;
END;
-- Gọi stored procedure để lấy danh sách dữ liệu từ bảng SanPham
EXEC sp_GetDanhSachSanPham;



--Function để tính tổng giá trị đơn hàng dựa trên mã đơn hàng
CREATE FUNCTION dbo.CalculateTotalPrice
(
    @MaDonHang INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;
    
    SELECT @Total = SUM(ctdh.SoLuong * sp.Gia)
    FROM ChiTietDonHang ctdh
    JOIN SanPham sp ON ctdh.MaSanPham = sp.MaSanPham
    WHERE ctdh.MaDonHang = @MaDonHang;
    
    RETURN @Total;
END;
--Sau khi đã tạo function như trên, có thể sử dụng nó để tính tổng giá trị đơn hàng
-- Sử dụng function để tính tổng giá trị đơn hàng
DECLARE @MaDonHang INT;
SET @MaDonHang = 1; -- Thay đổi mã đơn hàng tương ứng

DECLARE @TongTien MONEY;
SET @TongTien = dbo.CalculateTotalPrice(@MaDonHang);

SELECT @TongTien AS TongTienDonHang;




--tổng số lượng sản phẩm trong một đơn hàng dựa trên mã đơn hàng
CREATE FUNCTION dbo.CalculateTotalQuantity
(
    @MaDonHang INT
)
RETURNS INT
AS
BEGIN
    DECLARE @TotalQuantity INT;
    
    SELECT @TotalQuantity = SUM(SoLuong)
    FROM ChiTietDonHang
    WHERE MaDonHang = @MaDonHang;
    
    RETURN @TotalQuantity;
END;
--Sau khi đã tạo function như trên, có thể sử dụng nó để tính tổng số lượng sản phẩm trong một đơn hàng
-- Sử dụng function để tính tổng số lượng sản phẩm trong đơn hàng
DECLARE @MaDonHang INT;
SET @MaDonHang = 1; -- Thay đổi mã đơn hàng tương ứng

DECLARE @TongSoLuong INT;
SET @TongSoLuong = dbo.CalculateTotalQuantity(@MaDonHang);

SELECT @TongSoLuong AS TongSoLuongSanPham;





--lấy thông tin chi tiết đơn hàng
CREATE FUNCTION dbo.LayChiTietDonHang (@MaDonHang INT)
RETURNS TABLE
AS
RETURN
(
    SELECT ctdh.MaChiTietDonHang, sp.TenSanPham, ctdh.SoLuong, ctdh.GiaDonVi
    FROM ChiTietDonHang ctdh
    INNER JOIN SanPham sp ON ctdh.MaSanPham = sp.MaSanPham
    WHERE ctdh.MaDonHang = @MaDonHang
);

SELECT * 
FROM dbo.LayChiTietDonHang(1); -- 1  Mã đơn hàng cần truy vấn(có thể dùng mã đơn hàng khác)




--Tổng số đơn hàng của một khách hàng
CREATE FUNCTION dbo.TinhTongDonHangCuaKhachHang (@MaKhachHang INT)
RETURNS INT
AS
BEGIN
    DECLARE @TongDonHang INT;

    SELECT @TongDonHang = COUNT(*)
    FROM DonHang
    WHERE MaKhachHang = @MaKhachHang;

    RETURN @TongDonHang;
END;
--
DECLARE @MaKhachHang INT = 1; -- Thay 1 bằng Mã khách hàng cần tính

DECLARE @TongDonHang INT;
SELECT @TongDonHang = dbo.TinhTongDonHangCuaKhachHang(@MaKhachHang);

SELECT @TongDonHang AS TongDonHangCuaKhachHang;




--trigger sau khi thêm dữ liệu vào bảng DonHang để cập nhật tổng tiền
CREATE TRIGGER UpdateTongTienAfterInsert
ON DonHang
AFTER INSERT
AS
BEGIN
    DECLARE @MaDonHang INT;

    SELECT @MaDonHang = inserted.MaDonHang FROM inserted;

    UPDATE DonHang
    SET TongTien = (SELECT SUM(GiaDonVi * SoLuong) FROM ChiTietDonHang WHERE MaDonHang = @MaDonHang)
    WHERE MaDonHang = @MaDonHang;
END;


-- Thêm dữ liệu vào bảng DonHang với mã đơn hàng là 3
INSERT INTO DonHang (MaDonHang, MaKhachHang, NgayDatHang)
VALUES (3, 1, GETDATE());

-- Hiển thị thông tin trong bảng DonHang cho mã đơn hàng là 3
SELECT * FROM DonHang WHERE MaDonHang = 3;




--lỗi
/*
-- Trigger sau khi thêm dữ liệu vào bảng ChiTietDonHang để cập nhật số lượng tồn của sản phẩm
CREATE TRIGGER UpdateInventory
ON ChiTietDonHang
AFTER INSERT
AS
BEGIN
    DECLARE @MaSanPham INT;

    SELECT @MaSanPham = i.MaSanPham
    FROM inserted i;

    UPDATE SanPham
    SET SoLuongTon = SoLuongTon - (SELECT SoLuong FROM inserted WHERE MaSanPham = @MaSanPham)
    WHERE MaSanPham = @MaSanPham;
END;

-- Thêm đơn hàng mới vào bảng DonHang (hãy thay đổi MaDonHang và MaKhachHang theo nhu cầu)
INSERT INTO DonHang (MaDonHang, MaKhachHang, NgayDatHang)
VALUES (5, 2, GETDATE());

-- Thêm chi tiết đơn hàng liên quan (hãy thay đổi MaDonHang, MaSanPham, SoLuong, và GiaDonVi theo nhu cầu)
INSERT INTO ChiTietDonHang (MaDonHang, MaSanPham, SoLuong, GiaDonVi)
VALUES (5, 2, 3, 15000);


SELECT * FROM SanPham;
*/
--lỗi




--VIEW

-- Tạo view để hiển thị thông tin chi tiết đơn hàng
CREATE VIEW dbo.ViewChiTietDonHang AS
SELECT ctdh.MaChiTietDonHang, sp.TenSanPham, ctdh.SoLuong, ctdh.GiaDonVi
FROM ChiTietDonHang ctdh
INNER JOIN SanPham sp ON ctdh.MaSanPham = sp.MaSanPham;

-- Truy vấn thông tin chi tiết đơn hàng từ view
SELECT * FROM dbo.ViewChiTietDonHang;



--View Danh Sách Sản Phẩm và Số Lượng Tồn:

CREATE VIEW dbo.ViewDanhSachSanPham
AS
SELECT sp.MaSanPham, sp.TenSanPham, sp.Gia, sp.SoLuongTon, ncc.TenNhaCungCap
FROM SanPham sp
INNER JOIN NhaCungCap ncc ON sp.MaNhaCungCap = ncc.MaNhaCungCap;

SELECT * FROM dbo.ViewDanhSachSanPham;



--View Danh Sách Đơn Hàng của Khách Hàng
CREATE VIEW dbo.ViewDanhSachDonHangKhachHang
AS
SELECT dh.MaDonHang, kh.TenDau, kh.TenCuoi, dh.NgayDatHang, dh.TongTien
FROM DonHang dh
INNER JOIN KhachHang kh ON dh.MaKhachHang = kh.MaKhachHang;

SELECT * FROM dbo.ViewDanhSachDonHangKhachHang;


--View Danh Sách Đơn Hàng và Tổng Tiền
CREATE VIEW dbo.ViewDanhSachDonHangVaTongTien
AS
SELECT dh.MaDonHang, dh.NgayDatHang, SUM(ctdh.GiaDonVi * ctdh.SoLuong) AS TongTien
FROM DonHang dh
INNER JOIN ChiTietDonHang ctdh ON dh.MaDonHang = ctdh.MaDonHang
GROUP BY dh.MaDonHang, dh.NgayDatHang;

SELECT * FROM dbo.ViewDanhSachDonHangVaTongTien;



--View Danh Sách Nhà Cung Cấp và Số Lượng Sản Phẩm
CREATE VIEW dbo.ViewDanhSachNhaCungCapVaSoLuongSanPham
AS
SELECT ncc.MaNhaCungCap, ncc.TenNhaCungCap, COUNT(sp.MaSanPham) AS SoLuongSanPham
FROM NhaCungCap ncc
LEFT JOIN SanPham sp ON ncc.MaNhaCungCap = sp.MaNhaCungCap
GROUP BY ncc.MaNhaCungCap, ncc.TenNhaCungCap;


SELECT * FROM dbo.ViewDanhSachNhaCungCapVaSoLuongSanPham;


