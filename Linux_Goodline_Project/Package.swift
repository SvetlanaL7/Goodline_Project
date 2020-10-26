// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Linux_Goodline_Project",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1"),
        //библиотека ColorizeSwift используется для создания стилей текста в консоли 
        //добавляет цвет текста, цвет фона и стиль для вывода консоли и командной строки в Swift
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.5.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Linux_Goodline_Project",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser"), "ColorizeSwift"],
            resources: [
                .process("dictionary.json")            
            ]),
        .testTarget(
            name: "Linux_Goodline_ProjectTests",
            dependencies: ["Linux_Goodline_Project"]),
    ]
)
