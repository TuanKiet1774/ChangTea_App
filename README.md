# 🍹Ứng dụng đặt trà sữa ChangTea

---

## 📌 Giới thiệu

**Ứng dụng đặt trà sữa ChangTea** mang đến trải nghiệm đặt trà sữa tiện lợi với giao diện thân thiện, hình ảnh minh họa sinh động, giá cả rõ ràng và thông tin chi tiết từng món. Khách hàng có thể dễ dàng:
- Duyệt menu theo hình ảnh và mô tả.
- Tìm kiếm món theo tên hoặc được đề xuất các món phù hợp với sở thích.
- Thêm món vào giỏ hàng, tùy chỉnh số lượng hoặc xoá nếu cần.
- Đặt hàng nhanh chóng và theo dõi chi tiết hóa đơn.
- Xem lại lịch sử các đơn hàng đã mua.
- Quản lý thông tin cá nhân như tên, địa chỉ, số điện thoại để thuận tiện hơn cho các lần đặt hàng tiếp theo.

---

## 🎯 Tính năng chính

Ứng dụng bao gồm các chức năng nổi bật sau:
- 📋 Hiển thị Menu: Danh sách các món trà sữa kèm hình ảnh, giá và thông tin chi tiết.
- 🔍 Tìm kiếm & Gợi ý: Tìm món theo tên hoặc đề xuất món tương tự theo sở thích.
- 🛒 Giỏ Hàng: Lưu các món đã chọn cho từng tài khoản, cho phép điều chỉnh số lượng hoặc xóa món.
- 🧾 Hóa Đơn: Xem thông tin hóa đơn sau khi đặt hàng và chi tiết từng đơn.
- 👤 Tài Khoản Người Dùng: Đăng nhập, lưu thông tin cá nhân để đặt hàng nhanh hơn.
- 📜 Lịch Sử Mua Hàng: Hiển thị danh sách các đơn hàng đã thực hiện.

---

## 🗃️Cơ sở dữ liệu
![image](https://github.com/user-attachments/assets/5877cd2d-77c3-401a-a8f2-4b094db694e6)

| Tên bảng| Chức năng| Các trường|
|---|---|---|
|TraSuaChangTea| Bảng chứa dữ liệu tất cả các món của quán (Trà sữa, trà trái cây, đồ ăn)| id, ten, gia, moTa, anh, danhGia, tag, loai|
|ToppingChangTea|Bảng chứa dữ liệu các topping của quán| id, ten, gia|
|KhachHangChangTea| Bảng chứa thông tin các khách hàng của quán| idKH, tenKH, diaChi, sdt|
|GioHangChangTea| Bảng chứa các món được khách hàng thêm vào giỏ hàng| idKH, idMon, soLuong, size, mucDa, topping, giaTopping|
|HoaDonChangTea|Bảng chứa các hóa đơn mà khách hàng đã đặt| idKH, idHD, thoiGian, tongTien, ghiChu|
|CTHDChangTea|Bảng chứa chi tiết các món của 1 hóa đơn| idHD, idMon, soLuong, size|

📝*Nền tảng [Supabase](https://supabase.com/)*: Tổ chức và lưu trữ cơ sở dữ liệu

---
## 🖼️ Ảnh minh họa cho ứng dụng
![image](https://github.com/user-attachments/assets/61d5af1f-d6e5-4119-9024-f92bd2f3b034)

