# Pickleball Tournament Portal v7 - Netlify + Supabase

Bản này tách **code** và **data**:

```text
Code website: GitHub / Netlify
Data: Supabase database
```

Khi sửa code và deploy lại, dữ liệu giải đấu/đăng ký/lịch/kết quả vẫn nằm trong Supabase nên không mất.

## Files

- `index.html` - website chính
- `config.js` - cấu hình Supabase URL + anon key
- `supabase_schema.sql` - SQL tạo database, RLS policies và admin RPC functions
- `pickleball-schedule-template.csv` - file mẫu upload lịch

## Setup nhanh

### 1. Tạo Supabase project

Tạo project mới trong Supabase.

### 2. Chạy SQL schema

Mở Supabase SQL Editor, copy toàn bộ nội dung trong `supabase_schema.sql`.

Trước khi chạy, sửa dòng:

```sql
'CHANGE_THIS_ADMIN_PASSWORD'
```

thành mật khẩu Admin riêng của BTC.

Ví dụ:

```sql
'MyStrongPasswordHere'
```

Sau đó Run SQL.

### 3. Cấu hình website

Trong Supabase dashboard, vào Project Settings > API và copy:

- Project URL
- anon public key

Mở file `config.js` và điền:

```js
window.PB_CONFIG = {
  SUPABASE_URL: "https://xxxxx.supabase.co",
  SUPABASE_ANON_KEY: "your-anon-public-key"
};
```

### 4. Deploy lên Netlify

Khuyến nghị dùng GitHub + Netlify:

```text
GitHub repo
      ↓
Netlify import repo
      ↓
Mỗi lần sửa code, Netlify tự deploy lại cùng link
      ↓
Data vẫn giữ nguyên trong Supabase
```

Với website tĩnh này, Netlify không cần build command.

## Flow Admin

```text
Admin đăng nhập
      ↓
Setup giải đấu
      ↓
Upload banner
      ↓
Chọn nội dung thi đấu
      ↓
Nhập lệ phí
      ↓
Cập nhật giải thưởng + hình ảnh
      ↓
Upload lịch thi đấu hoặc tạo trận thủ công
      ↓
Duyệt đăng ký / thanh toán
      ↓
Duyệt kết quả người chơi gửi
```

## Flow người chơi

```text
Chọn giải đấu
      ↓
Đăng ký lần đầu
      ↓
Đăng nhập bằng Email + Họ tên
      ↓
Xem thông tin đăng ký
      ↓
Gửi kết quả nếu có tên trong trận
      ↓
Admin duyệt thì kết quả mới chính thức
```

## Lưu ý bảo mật

Bản này tốt hơn bản localStorage vì data nằm trong Supabase và admin operations đi qua RPC có kiểm tra mật khẩu.

Tuy nhiên đây vẫn là mô hình đơn giản cho nhóm nhỏ. Nếu dùng lâu dài/professional, nên nâng cấp thêm:

- Supabase Auth cho Admin
- Storage bucket cho ảnh banner/giải thưởng thay vì lưu base64 trong database
- Audit log cho các thay đổi Admin
- Email confirmation cho đăng ký


## Update v8

- Người chơi đăng nhập chỉ bằng Email đã đăng ký.
- Sau khi đăng nhập, người chơi xem được danh sách đã đăng ký của giải đang chọn.
- Danh sách người chơi không hiển thị email/số điện thoại của người khác.
- Cần chạy thêm file `supabase_update_v8.sql` trong Supabase SQL Editor trước khi upload `index.html` mới.


## v9 update

- Người chơi đăng nhập chỉ bằng email.
- Sau khi đăng nhập, người chơi xem được toàn bộ thông tin đăng ký của giải:
  - Họ tên
  - Email
  - Số điện thoại
  - Đơn vị / CLB
  - Nội dung thi đấu
  - Trình độ
  - Đồng đội
  - Email đồng đội
  - Trạng thái duyệt
  - Trạng thái thanh toán
  - Ghi chú

## Cách update từ v8 lên v9

1. Vào Supabase SQL Editor.
2. Chạy file `supabase_update_v9.sql`.
3. Thay file `index.html` trên GitHub bằng file v9.
4. Netlify tự deploy lại.
