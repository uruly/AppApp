# AppApp
AppAppはAppStoreのアプリをコレクションするためのアプリです。

AppApp is an app for collecting AppStore apps.

![appapp_icatch](https://user-images.githubusercontent.com/10204705/53691235-cdf45a80-3dbc-11e9-8c7b-86b48c231f57.png)

## Environment

 - Xcode 15.0.1
 - Swift 5.9
 - mint 0.17.5
 - iOS 17.3.1
 
上記環境にて開発・確認済みです。

## Introduction

導入方法は以下

```
git clone git@github.com:uruly/AppApp.git
cd AppApp
mint run carthage bootstrap --platform iOS --no-use-binaries --use-xcframeworks
open AppApp.xcodeproj
```


### Functions
 1. Save from AppStore
 
 ![screenshot2](https://user-images.githubusercontent.com/10204705/53691253-01cf8000-3dbd-11e9-97b9-db3a858fc430.png)
 
 2. Collection
 
 ![screenshot](https://user-images.githubusercontent.com/10204705/53691258-36dbd280-3dbd-11e9-91a9-fc3b3db606d0.png)
 
 3. Check Web or AppStore
 
 ![screenshot5](https://user-images.githubusercontent.com/10204705/53691264-67237100-3dbd-11e9-823c-cdb5f27dd2be.png)
 
### Details

詳細はブログにて。
https://uruly.xyz/my/appapp/

### History

リファクタリングブログを書きました。

 1. SwiftLint導入 https://uruly.xyz/refactor-appapp-swiftlint/
 1. SwiftLint導入後 Error解消 https://uruly.xyz/appapp-refactor-swiftlint-2/
 1. SwiftLint導入後 Warning解消 https://uruly.xyz/refactor-appapp-swiftlint-3/
 1. コーディング規約 https://uruly.xyz/refactor-appapp-4/
 1. ディレクトリ構成 https://uruly.xyz/refactor-appapp-5/
 1. R.swift導入 https://uruly.xyz/refactor-appapp-6/
 1. 画像・色の管理 https://uruly.xyz/refactor-appapp-7/
 1. Carthage/LicensePlist 導入 https://uruly.xyz/refactor-appapp-8/
 1. Realm① https://uruly.xyz/refactor-appapp-9/
 1. Realm②　https://uruly.xyz/refactor-appapp-10/

