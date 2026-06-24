dependencies: [
    .package(url: "https://github.com/bmob/BmobSwiftSDK", from: "1.0.2")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "BmobSDK", package: "BmobSwiftSDK")
    ])
]