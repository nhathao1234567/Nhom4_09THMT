CREATE DATABASE VLXD
GO
USE VLXD
GO
CREATE TABLE NhaCungCap (
    MaNhaCungCap INT PRIMARY KEY,
    TenNhaCungCap NVARCHAR(255),
    DiaChi NVARCHAR(255),
    SoDienThoai NVARCHAR(20)
);

CREATE TABLE KhachHang (
    MaKhachHang INT PRIMARY KEY,
    TenDau NVARCHAR(255),
    TenCuoi NVARCHAR(255),
    DiaChi NVARCHAR(255),
    SoDienThoai NVARCHAR(20),
    Email NVARCHAR(255)
);

CREATE TABLE DonHang (
    MaDonHang INT PRIMARY KEY,
    MaKhachHang INT,
    NgayDatHang DATE,
    TongTien MONEY,
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

CREATE TABLE SanPham (
    MaSanPham INT PRIMARY KEY,
    TenSanPham NVARCHAR(255),
    MoTa NVARCHAR(MAX),
    Gia MONEY,
    SoLuongTon INT,
    MaNhaCungCap INT,
    FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap)
);

CREATE TABLE ChiTietDonHang (
    MaChiTietDonHang INT PRIMARY KEY,
    MaDonHang INT,
    MaSanPham INT,
    SoLuong INT,
    GiaDonVi MONEY,
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);

CREATE TABLE ThongTinThanhToan (
    MaThanhToan INT PRIMARY KEY,
    MaDonHang INT,
    NgayThanhToan DATE,
    SoTienThanhToan MONEY,
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang)
);
--Thêm dữ liệu cho bảng NhaCungCap
INSERT INTO NhaCungCap (MaNhaCungCap, TenNhaCungCap, DiaChi, SoDienThoai)
VALUES
    (1, N'Nhà cung cấp A', N'Địa chỉ A', N'0123456789'),
    (2, N'Nhà cung cấp B', N'Địa chỉ B', N'0987654321');
--Thêm dữ liệu cho bảng KhachHang
INSERT INTO KhachHang (MaKhachHang, TenDau, TenCuoi, DiaChi, SoDienThoai, Email)
VALUES
    (1, N'Nguyễn', N'Văn A', N'Địa chỉ 1', N'0123456789', N'nguyenvana@example.com'),
    (2, N'Trần', N'Thị B', N'Địa chỉ 2', N'0987654321', N'tranthib@example.com'),
    (3, N'Lê', N'Thi C', N'Địa chỉ 3', N'0123123123', N'lethic@example.com');
--Thêm dữ liệu cho bảng DonHang
INSERT INTO DonHang (MaDonHang, MaKhachHang, NgayDatHang, TongTien)
VALUES
    (1, 1, '2023-08-01', 250000),
    (2, 2, '2023-08-02', 120000),
    (3, 3, '2023-08-03', 85000);
--Thêm dữ liệu cho bảng SanPham
INSERT INTO SanPham (MaSanPham, TenSanPham, MoTa, Gia, SoLuongTon, MaNhaCungCap)
VALUES
    (1, N'Gạch ceramic', N'Gạch ốp lát sàn', 15000, 500, 1),
    (2, N'Cát xây tường', N'Cát xây dựng tường', 8000, 1000, 2),
    (3, N'Sắt thép đặc', N'Sắt thép cường độ cao', 30000, 300, 2); -- Cùng một nhà cung cấp với Cát xây tường
--Thêm dữ liệu cho bảng ChiTietDonHang
INSERT INTO ChiTietDonHang (MaChiTietDonHang, MaDonHang, MaSanPham, SoLuong, GiaDonVi)
VALUES
    (1, 1, 1, 5, 15000),
    (2, 1, 2, 10, 8000),
    (3, 2, 1, 3, 15000),
    (4, 2, 3, 4, 30000),
    (5, 3, 2, 7, 8000),
    (6, 3, 3, 2, 30000);
--Thêm dữ liệu cho bảng ThongTinThanhToan
INSERT INTO ThongTinThanhToan (MaThanhToan, MaDonHang, NgayThanhToan, SoTienThanhToan)
VALUES
    (1, 1, '2023-08-02', 250000),
    (2, 2, '2023-08-03', 120000),
    (3, 3, '2023-08-04', 85000);

