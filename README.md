# VietStock eKYC

Ứng dụng Flutter được viết theo thứ tự mũi tên trong Figma. Các frame chỉ khác
trạng thái đã được gộp để tránh màn hình trùng lặp.

## Flow chính

```text
ScreenWelcome
→ Screen-CCCD-HintText
→ ScreenIdentityCapture
→ ScreenOCRCCCD (camera mặt trước)
→ ScreenOCRCCCD (kết quả OCR)
→ ScreenBank
→ ScreenSMSOTP
→ ScreenSuccess
```

## Nhánh CCCD đã tồn tại

```text
Screen-CCCD-HintText
→ Screen-CCCD-DuplicatePopup
→ ScreenSMSOTP
→ ScreenSuccess
```

CCCD, số điện thoại và email được kiểm tra trùng trên Firebase trước khi chuyển
sang bước xác minh danh tính. Popup cảnh báo dùng đúng bố cục của Figma.

Mỗi màn hình chức năng được đặt trong một file riêng tại `lib/flow_screens/`.
Form trống/đã nhập, CCCD chưa chụp/đã chụp và OTP trống/đã nhập được xử lý
bằng state trong cùng màn hình.

## Đăng nhập và quản trị

```text
ScreenWelcome
→ ScreenLogin
→ ScreenHome
   ├─ ScreenMarket
   └─ ScreenAdminRegistrations (chỉ tài khoản admin)
```

- Đăng nhập bằng Firebase Authentication Email/Password.
- Người dùng thường xem Bitcoin và thị trường chứng khoán Việt Nam.
- Admin xem, duyệt hoặc từ chối các yêu cầu trong collection `registrations`.
- Bitcoin được tải từ CoinGecko. Chứng khoán Việt Nam đọc từ document
  `market_data/vietnam`; ứng dụng hiển thị dữ liệu mô phỏng khi document này
  chưa tồn tại.

## Firebase

- Firebase Core
- Firebase Anonymous Authentication
- Firebase Email/Password Authentication
- Cloud Firestore, collection `registrations`
- Collection `registration_identifiers` lưu khoá SHA-256 để kiểm tra trùng mà
  không công khai CCCD, số điện thoại hoặc email.
- Ảnh CCCD có thể chụp hoặc chọn từ thư viện. Google ML Kit đọc chữ trên thiết
  bị và đưa kết quả sang màn hình `ScreenOCRCCCD`.

Thiết lập trong Firebase Console:

1. Bật **Authentication > Sign-in method > Anonymous** và **Email/Password**.
2. Tạo Cloud Firestore Database.
3. Tạo người dùng đăng nhập trong **Authentication > Users**.
4. Với tài khoản quản trị, tạo document `users/{uid}`:

```json
{
  "role": "admin",
  "isActive": true
}
```

5. Có thể tạo document `market_data/vietnam` với mảng `quotes`:

```json
{
  "quotes": [
    {
      "name": "Chỉ số VN-Index",
      "symbol": "VN-INDEX",
      "price": 1250.0,
      "unit": "điểm",
      "changePercentage": 0.65
    }
  ]
}
```

6. Deploy rules:

```bash
firebase deploy --project hutech-ac20a --only firestore
```

## Chạy ứng dụng

```bash
flutter pub get
flutter run
```

### Chuẩn bị iOS

Firebase và Google ML Kit OCR yêu cầu iOS 15.5. Dự án đã đặt deployment target
15.5 trong Xcode và `AppFrameworkInfo.plist`. Luôn chuẩn bị iOS bằng script của
dự án trước khi mở Xcode:

```bash
./tool/prepare_ios.sh
open ios/Runner.xcworkspace
```
