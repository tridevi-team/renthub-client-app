class ConstantString {
  ConstantString._();

  static const String prefFirstLogin = 'first_login';

  static const String prefAccessToken = 'pref_access_token';
  static const String prefRefreshToken = 'pref_refresh_token';
  static const String prefAppType = 'pref_app'; // dùng để phân biệt token của firebase hay của server
  static const String prefTypePhone = 'pref_type_phone';
  static const String prefTypeEmail = 'pref_type_email';
  static const String prefTypeServer = 'pref_type_server';
  static const String prefCity = 'pref_city';
  static const String prefDistrict = 'pref_district';

  static const String titleTempReg = "Đăng ký tạm trú";
  static const String descriptionTempReg = "Bạn xác nhận những thông tin này là đúng sự thật. Nếu có bất cứ vấn đề gì bạn sẽ phải chịu hoàn toàn mọi trách nhiệm?";
  static const String serviceTypeWater = 'WATER_CONSUMPTION';
  static const String serviceTypeElectric = 'ELECTRICITY_CONSUMPTION';
  static const String serviceTypeRoom = 'ROOM';
  static const String serviceTypePeople = 'PEOPLE';
  static const String statusMaintain = 'MAINTENANCE';
  static const String statusExpired = 'EXPIRED';
  static const String statusPending = 'PENDING';
  static const String statusAvailable = 'AVAILABLE';
  static const String statusRented = 'RENTED';

  //message
  static const String messageNoInternet = 'Không có kết nối mạng.';
  static const String messageNoData = 'Không có dữ liệu.';
  static const String dataInvalidMessage = 'Dữ liệu không hợp lệ';
  static const String messageSuccess = 'Thành công';
  static const String messageError = 'Lỗi';
  static const String messageWarning = 'Cảnh báo';
  static const String messageConfirm = 'Xác nhận';
  static const String loginRequiredMessage = "Bạn cần đăng nhập để sử dụng chức năng này.";
  static const String tryAgainMessage = "Có lỗi xảy ra. Vui lòng thử lại.";
  static const String restartAppMessage = "Có lỗi xảy ra. Vui lòng khởi động lại ứng dụng.";
  static const String sessionTimeoutMessage = "Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại.";
  static const String accountNotFoundMessage = "Tài khoản không tồn tại trong hệ thống. Vui lòng liên hệ với quản lý toà nhà.";
  static const String updateFailedMessage = "Cập nhật thông tin thất bại. Vui lòng thử lại.";
  static const String uploadFailedMessage = "Tải file lên thất bại. Vui lòng thử lại.";

  static const List<Map<String, dynamic>> bankApps = [
    {
      "appId": "ocb",
      "appLogo": "https://play-lh.googleusercontent.com/AUZSfk4Zv0Y1QTwbPfjZkJKwWDMW7g9koW-CaxBgkkIKuVJZYZDDL8iizRKTvq-V6-o",
      "appName": "OCB OMNI - Digital Bank",
      "bankName": "Ngân hàng TMCP Phương Đông",
      "monthlyInstall": 80000,
      "deeplink": "https://dl.vietqr.io/pay?app=ocb",
      "autofill": 1
    },
    {
      "appId": "icb",
      "appLogo": "https://play-lh.googleusercontent.com/F8D0AbyMmiuwsTZYLaPsu_o40XGfQHgvRnq25lVSWupgHPpH3-TQ9soMrWwDJco3siI",
      "appName": "VietinBank iPay",
      "bankName": "Ngân hàng TMCP Công thương Việt Nam",
      "monthlyInstall": 200000,
      "deeplink": "https://dl.vietqr.io/pay?app=icb",
      "autofill": 0
    },
    {"appId": "mb", "appLogo": "https://play-lh.googleusercontent.com/rBEfIxFhnCIq9p6eMdw-U1RhD5psINWr0_Rbx3Wvy3HMJpRRsnG6efhug5eyPlJc7u0", "appName": "MB Bank", "bankName": "Ngân hàng TMCP Quân đội", "monthlyInstall": 500000, "deeplink": "https://dl.vietqr.io/pay?app=mb", "autofill": 0},
    {
      "appId": "bidv",
      "appLogo": "https://play-lh.googleusercontent.com/SD4lUzWCqLq6nqURm8abnazm8sC0h_hkikryHyODrVpI0g3xMjeuaVs379jUCKrd0vk",
      "appName": "BIDV SmartBanking",
      "bankName": "Ngân hàng TMCP Đầu tư và Phát triển Việt Nam",
      "monthlyInstall": 200000,
      "deeplink": "https://dl.vietqr.io/pay?app=bidv",
      "autofill": 0
    },
    {
      "appId": "vcb",
      "appLogo": "https://play-lh.googleusercontent.com/hRq2DVKkzBXQkyftxr0e2ytl0fS2hEWx3UTe3V652RfJVYWqVRGgBNhmZgqNzJ8PKHE",
      "appName": "Vietcombank",
      "bankName": "Ngân hàng TMCP Ngoại Thương Việt Nam",
      "monthlyInstall": 300000,
      "deeplink": "https://dl.vietqr.io/pay?app=vcb",
      "autofill": 0
    },
    {
      "appId": "tcb",
      "appLogo": "https://play-lh.googleusercontent.com/Ddr3ZQEu6Vef9JV9ITALeyBEXvYwQWZ3kKJXxrdncD9JR0xlsO--J6zo7uGARfuTBmk",
      "appName": "Techcombank Mobile",
      "bankName": "Ngân hàng TMCP Kỹ thương Việt Nam",
      "monthlyInstall": 200000,
      "deeplink": "https://dl.vietqr.io/pay?app=tcb",
      "autofill": 0
    },
    {"appId": "acb", "appLogo": "https://play-lh.googleusercontent.com/knIdLBzE-ngS8Fhim_0FxH56vWhXaQmuLcpMdAcoFY_790hd3t4_XQAlyEWUnYJRyWFP", "appName": "ACB One", "bankName": "Ngân hàng TMCP Á Châu", "monthlyInstall": 70000, "deeplink": "https://dl.vietqr.io/pay?app=acb", "autofill": 0},
    {
      "appId": "vpb",
      "appLogo": "https://play-lh.googleusercontent.com/u9fUwltudW3eSwh0RddQsiAzTpXWRtD8TS0TCC3s--NgUej28iWoCikXCrFLd89YgxHX",
      "appName": "VPBank NEO",
      "bankName": "Ngân hàng TMCP Việt Nam Thịnh Vượng",
      "monthlyInstall": 200000,
      "deeplink": "https://dl.vietqr.io/pay?app=vpb",
      "autofill": 0
    },
    {
      "appId": "vib-2",
      "appLogo": "https://play-lh.googleusercontent.com/1PXaSrS8B9f4u3OBz2IroGPIYri0Bb2PBH4CGOuZqPqgyQAoBCEFeBC7ty_hDVPaM98",
      "appName": "MyVIB 2.0",
      "bankName": "Ngân hàng TMCP Quốc tế Việt Nam",
      "monthlyInstall": 30000,
      "deeplink": "https://dl.vietqr.io/pay?app=vib-2",
      "autofill": 0
    },
    {
      "appId": "shb",
      "appLogo": "https://play-lh.googleusercontent.com/v5oiUb9OH80qpTRgcKPpXHkqmkO5MAZfxldamoCPCbdUMOruCabujukSJmXF2FK3hco",
      "appName": "SHB Mobile Banking",
      "bankName": "Ngân hàng TMCP Sài Gòn - Hà Nội",
      "monthlyInstall": 20000,
      "deeplink": "https://dl.vietqr.io/pay?app=shb",
      "autofill": 0
    },
    {
      "appId": "lpb",
      "appLogo": "https://play-lh.googleusercontent.com/D2T8P3NOeROq0vaYMdBgqrhfdH7tCPB_iQafQqBhVc-NiC5m-UacTDP0qY2dM3b9OZY",
      "appName": "Liên Việt 24h",
      "bankName": "Ngân hàng TMCP Bưu Điện Liên Việt",
      "monthlyInstall": 70000,
      "deeplink": "https://dl.vietqr.io/pay?app=lpb",
      "autofill": 0
    },
    {"appId": "seab", "appLogo": "https://play-lh.googleusercontent.com/njk0e9EHepwCNvgqcjBWYWyrnpQOnFCVzED_4S8ePI5V1vVKJ6QlVkjiwk7rhCQV0-Y", "appName": "SeAMobile", "bankName": "Ngân hàng TMCP Đông Nam Á", "monthlyInstall": 20000, "deeplink": "https://dl.vietqr.io/pay?app=seab", "autofill": 0},
    {"appId": "scb", "appLogo": "https://play-lh.googleusercontent.com/z7gOit-6cq79jN3hcU-lquDoswKkIKjMYRWCpYKQ9yefkCCJBxn7DBIz0GFOmEg2mug", "appName": "SCB Mobile Banking", "bankName": "Ngân hàng TMCP Sài Gòn", "monthlyInstall": 10000, "deeplink": "https://dl.vietqr.io/pay?app=scb", "autofill": 0},
    {
      "appId": "vietbank",
      "appLogo": "https://play-lh.googleusercontent.com/lW_BzZL3I2RmWFKAM56h93do2fmNApvi2ZAO5FhV6dxBTcOM5xLrzc79fpOvLbnEU0U",
      "appName": "Vietbank Digital",
      "bankName": "Ngân hàng TMCP Việt Nam Thương Tín",
      "monthlyInstall": 0,
      "deeplink": "https://dl.vietqr.io/pay?app=vietbank",
      "autofill": 0
    },
    {
      "appId": "cake",
      "appLogo": "https://play-lh.googleusercontent.com/RWPd1WdrkKP53RyHHRdmV35eOhxoCHmlujBUIizNf8Gy1pHN4_MVuYao4ncZwFp2Poc",
      "appName": "CAKE - Digital Banking",
      "bankName": "TMCP Việt Nam Thịnh Vượng - Ngân hàng số CAKE by VPBank",
      "monthlyInstall": 100000,
      "deeplink": "https://dl.vietqr.io/pay?app=cake",
      "autofill": 0
    },
    {
      "appId": "hdb",
      "appLogo": "https://play-lh.googleusercontent.com/W9AeQiFfNrAySMdcebkiVuA4KwoYRF3QcXa1I2QzlnNDgR9Sqdwzagz8XVCmZxnW5Q",
      "appName": "HDBank",
      "bankName": "Ngân hàng TMCP Phát triển Thành phố Hồ Chí Minh",
      "monthlyInstall": 30000,
      "deeplink": "https://dl.vietqr.io/pay?app=hdb",
      "autofill": 0
    },
    {
      "appId": "vba",
      "appLogo": "https://play-lh.googleusercontent.com/rNSXUqGnK-ljK6qUdUmy7h_sDrMOzZ1nPwAUAwshsmPaQuwNGn0Xwj-psgFrBSJOHg",
      "appName": "Agribank E-Mobile Banking",
      "bankName": "Ngân hàng Nông nghiệp và Phát triển Nông thôn Việt Nam",
      "monthlyInstall": 300000,
      "deeplink": "https://dl.vietqr.io/pay?app=vba",
      "autofill": 0
    },
    {"appId": "tpb", "appLogo": "https://play-lh.googleusercontent.com/DiXudMm5iNSTqI1RlC8L5lYZq7DhyQUIafQJJW1iwA4EYgLUaJIjbYx6jtdHKVy5ry8", "appName": "TPBank Mobile", "bankName": "Ngân hàng TMCP Tiên Phong", "monthlyInstall": 80000, "deeplink": "https://dl.vietqr.io/pay?app=tpb", "autofill": 0},
    {
      "appId": "timo",
      "appLogo": "https://play-lh.googleusercontent.com/vZpDzZUuTlE43Nf_XcjQOx9gxrBoKGzKMiPVuie3isiE3MTH5iv9PQ_OGJaod9AqS5M",
      "appName": "Timo Digital Bank",
      "bankName": "Ngân hàng TMCP Bản Việt",
      "monthlyInstall": 70000,
      "deeplink": "https://dl.vietqr.io/pay?app=timo",
      "autofill": 0
    },
    {"appId": "vib", "appLogo": "https://play-lh.googleusercontent.com/RRo7NaHuZaHpyJHJFPLp3ue4rK-BDe8MI4LquEFHs_mMtVET2ofH21PJn3t0vU7F3Q", "appName": "MyVIB", "bankName": "Ngân hàng TMCP Quốc tế Việt Nam", "monthlyInstall": 30000, "deeplink": "https://dl.vietqr.io/pay?app=vib", "autofill": 0},
    {
      "appId": "shbvn",
      "appLogo": "https://play-lh.googleusercontent.com/1BSuD_TyG_azvCaCH_p1WIv8NYdFC0GuS4tVMubcGRn1yXpGfOjeE-yPZ4lmzEdK-zg",
      "appName": "Shinhan Bank Vietnam SOL",
      "bankName": "Ngân hàng TNHH MTV Shinhan Việt Nam",
      "monthlyInstall": 20000,
      "deeplink": "https://dl.vietqr.io/pay?app=shbvn",
      "autofill": 0
    },
    {
      "appId": "nab",
      "appLogo": "https://play-lh.googleusercontent.com/dsST6B9oQ167K3Mar3x-GPVlO5jrA1TTfOjO1CtzQx0gexM8tg7ZBKsFMnFvp5fgCA",
      "appName": "Nam A Bank - Open Banking",
      "bankName": "Ngân hàng TMCP Nam Á",
      "monthlyInstall": 9000,
      "deeplink": "https://dl.vietqr.io/pay?app=nab",
      "autofill": 0
    },
    {"appId": "abb", "appLogo": "https://play-lh.googleusercontent.com/DPT0tkkufSaDOyToT-tA3GVKj1b6_b7fWBt27NHebdVhkqTemHJKOntP5sIKkb6zFN8", "appName": "AB Ditizen", "bankName": "Ngân hàng TMCP An Bình", "monthlyInstall": 9000, "deeplink": "https://dl.vietqr.io/pay?app=abb", "autofill": 0},
    {
      "appId": "eib",
      "appLogo": "https://play-lh.googleusercontent.com/ku03AFfcKRFoAZCg-coMNJdVFQ0pcDWwRxy416NMd4OJ7TlD21Ia3MyqrdN8LgJTOw",
      "appName": "Eximbank Mobile Banking",
      "bankName": "Ngân hàng TMCP Xuất Nhập khẩu Việt Nam",
      "monthlyInstall": 7000,
      "deeplink": "https://dl.vietqr.io/pay?app=eib",
      "autofill": 0
    },
    {
      "appId": "coopbank",
      "appLogo": "https://play-lh.googleusercontent.com/3Ca0E1CbxyY9sSeEmq_rNvPIFR4cFcpx9tlucR_UkWKkJb-eJm2jLAHj3C99djB_yYY",
      "appName": "Co-opBank Mobile Banking",
      "bankName": "Ngân hàng Hợp tác xã Việt Nam",
      "monthlyInstall": 6000,
      "deeplink": "https://dl.vietqr.io/pay?app=coopbank",
      "autofill": 0
    },
    {
      "appId": "pvcb",
      "appLogo": "https://play-lh.googleusercontent.com/vJX7EY--Lts1D3pRgCDGOtIafEuxKQjYugP58WGY9PBXiUWtkyY0-D7NGHR4BEUX7sw",
      "appName": "PV Mobile Banking",
      "bankName": "Ngân hàng TMCP Đại Chúng Việt Nam",
      "monthlyInstall": 5000,
      "deeplink": "https://dl.vietqr.io/pay?app=pvcb",
      "autofill": 0
    },
    {
      "appId": "wvn",
      "appLogo": "https://play-lh.googleusercontent.com/K6mADuiW7PgDg77dK03AWx-TLFaAMydQ9T05laBEwqJUa5lJMx6wZAMQidcoGYgRJg",
      "appName": "Woori WON Vietnam",
      "bankName": "Ngân hàng TNHH MTV Woori Việt Nam",
      "monthlyInstall": 0,
      "deeplink": "https://dl.vietqr.io/pay?app=wvn",
      "autofill": 0
    },
    {"appId": "klb", "appLogo": "https://play-lh.googleusercontent.com/wxlX5rGP2XiyvRqDYqsHFDjlDiim0bukT2tv1QfxcpkQ5OvfwCp4lDyvNWD9_HR8GQ", "appName": "KienlongBank Plus", "bankName": "Ngân hàng TMCP Kiên Long", "monthlyInstall": 0, "deeplink": "https://dl.vietqr.io/pay?app=klb", "autofill": 0},
    {"appId": "bvb", "appLogo": "https://play-lh.googleusercontent.com/ZdTADvcU3RICcXdz30qFskmAWe9i5wS-AR_Kk3OwtETvicsUwGR7328JEZRaiGZoV4M", "appName": "BAOVIET Smart", "bankName": "Ngân hàng TMCP Bảo Việt", "monthlyInstall": 0, "deeplink": "https://dl.vietqr.io/pay?app=bvb", "autofill": 0},
    {"appId": "vab", "appLogo": "https://play-lh.googleusercontent.com/9VrdSOnjmE5ocjxm85jFYEcdAWxYSyVGqkv6X1BBH7mdWiEQKO4Lo_lbk--MHH6p1Ck", "appName": "VietABank EzMobile", "bankName": "Ngân hàng TMCP Việt Á", "monthlyInstall": 0, "deeplink": "https://dl.vietqr.io/pay?app=vab", "autofill": 0},
    {
      "appId": "tpb-pay",
      "appLogo": "https://play-lh.googleusercontent.com/EV49lQLAwGgHIPSVMd0btjPvbikN---UyGkbHVw6ldLYdMeS_6LKpmpnLk9xIGR244E",
      "appName": "TPBank QuickPay",
      "bankName": "Ngân hàng TMCP Tiên Phong",
      "monthlyInstall": 0,
      "deeplink": "https://dl.vietqr.io/pay?app=tpb-pay",
      "autofill": 0
    },
    {"appId": "ncb", "appLogo": "https://play-lh.googleusercontent.com/oyLbSzQz6lBIuDEC2keVHGqNIAhRP4VvowENdvjTOc7877bniURrBnacwp3ov04UFw", "appName": "NCB iziMobile", "bankName": "Ngân hàng TMCP Quốc Dân", "monthlyInstall": 0, "deeplink": "https://dl.vietqr.io/pay?app=ncb", "autofill": 0},
    {"appId": "acb-biz", "appLogo": "https://play-lh.googleusercontent.com/oVYhKiohvZ2PnWSsfgmzMGQlCRQeJ-4Em4fNL8ooS6xyGNZwIHOruqscfU6-9Ez7sw", "appName": "ACB One Biz", "bankName": "Ngân hàng TMCP Á Châu", "monthlyInstall": 0, "deeplink": "https://dl.vietqr.io/pay?app=acb-biz", "autofill": 0},
    {
      "appId": "oceanbank",
      "appLogo": "https://play-lh.googleusercontent.com/FZ-e9Sjaoe_THpguYbw3BgG-uaUR5EmEsn5NRHRj684_8oYxJoj69P0MpqDcbn4zjB4",
      "appName": "OceanBank",
      "bankName": "Ngân hàng Thương mại TNHH MTV Đại Dương",
      "monthlyInstall": 0,
      "deeplink": "https://dl.vietqr.io/pay?app=oceanbank",
      "autofill": 0
    },
    {
      "appId": "pbvn",
      "appLogo": "https://play-lh.googleusercontent.com/7nGworLSRDx7Sz7bfTfynu-s74TDCscYd5eG4JAN5gHdSL8GoejBeB9E5RfqXkn2ASw",
      "appName": "PB engage VN",
      "bankName": "Ngân hàng TNHH MTV Public Việt Nam",
      "monthlyInstall": 0,
      "deeplink": "https://dl.vietqr.io/pay?app=pbvn",
      "autofill": 0
    },
    {
      "appId": "sgicb",
      "appLogo": "https://play-lh.googleusercontent.com/0G5pmrhbkXb__ZJJmQ_btF2V1sk90jnEGhvXdmm9FXORuo2T__GiSNrHWI6GlzupUds",
      "appName": "SAIGONBANK Smart Banking",
      "bankName": "Ngân hàng TMCP Sài Gòn Công Thương",
      "monthlyInstall": 0,
      "deeplink": "https://dl.vietqr.io/pay?app=sgicb",
      "autofill": 0
    },
    {
      "appId": "cimb",
      "appLogo": "https://play-lh.googleusercontent.com/9_Iv94hJnVokIouNdXH7Ctczh_ZYOyG8Hm9f5iL5GzJI6NlIBnB2oJ9bBUuyqXNu_sk",
      "appName": "OCTO by CIMB",
      "bankName": "Ngân hàng TNHH MTV CIMB Việt Nam",
      "monthlyInstall": 0,
      "deeplink": "https://dl.vietqr.io/pay?app=cimb",
      "autofill": 0
    }
  ];
}
