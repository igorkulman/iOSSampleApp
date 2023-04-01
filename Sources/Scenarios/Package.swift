// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Scenarios",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Scenarios",
            targets: [
              "About",
              "Common",
              "Resources",
              "Feed",
              "Setup",
              "Operators",
              "App"
            ]),
    ],
    dependencies: [
      .package(url: "https://github.com/ReactiveX/RxSwift", exact: "6.0.0"),
      .package(url: "https://github.com/AliSoftware/Reusable", exact: "4.1.1"),
      .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt", exact: "6.0.0"),
      .package(url: "https://github.com/nmdias/FeedKit", exact: "9.1.2"),
      .package(url: "https://github.com/kean/Nuke", exact: "9.2.3"),
      .package(url: "https://github.com/Daltron/NotificationBanner", exact: "3.0.4"),
      .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", exact: "6.6.0"),
      .package(url: "https://github.com/realm/SwiftLint", exact: "0.51.0"),
      .package(url: "https://github.com/Quick/Nimble", exact: "8.0.7"),
      .package(url: "https://github.com/Quick/Quick", exact: "2.2.0")
    ],
    targets: [
        .target(
            name: "About",
            dependencies: [
              "Common",
              "Resources",
              .product(name: "RxSwift", package: "RxSwift"),
              .product(name: "RxCocoa", package: "RxSwift"),
              "Reusable",
              "Operators"
            ],
            resources: [
              .copy("Data")
            ],
            plugins: [
              .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Common",
            dependencies: [
              "Resources",
              .product(name: "RxSwift", package: "RxSwift"),
              .product(name: "RxCocoa", package: "RxSwift"),
              .product(name: "NotificationBannerSwift", package: "NotificationBanner"),
            ],
            plugins: [
              .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Resources",
            dependencies: [],
            plugins: [
              .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .target(
            name: "Operators",
            dependencies: []),
        .target(
            name: "App",
            dependencies: [
              "Setup",
              "Common",
              "Feed",
              "About"
            ],
            plugins: [
              .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Feed",
            dependencies: [
              "Common",
              "Resources",
              .product(name: "RxSwift", package: "RxSwift"),
              .product(name: "RxCocoa", package: "RxSwift"),
              "Reusable",
              "Nuke",
              "FeedKit",
              "RxSwiftExt",
              "Operators"
            ],
            plugins: [
              .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Setup",
            dependencies: [
              "Common",
              "Resources",
              .product(name: "RxSwift", package: "RxSwift"),
              .product(name: "RxCocoa", package: "RxSwift"),
              "Reusable",
              "Nuke",
              "Operators"
            ],
            resources: [
              .copy("Data")
            ],
            plugins: [
              .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "SetupTests",
            dependencies: [
              "Setup",
              "Nimble",
              "Quick"
            ]),
        .testTarget(
            name: "FeedTests",
            dependencies: [
              "Feed",
              "Nimble",
              "Quick"
            ]),
    ]
)
