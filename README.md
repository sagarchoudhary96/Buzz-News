# Buz News

An iPhone app that shows the latest news, news by different categories and allow user to add news to favorites and access them later.

## Requirements

 * Device running macOS(MacBook or iMac)
 * [Xcode](https://developer.apple.com/xcode/)

## How to Run
  * [Clone](https://github.com/sagarchoudhary96/Buzz-News.git) or [Download](https://github.com/sagarchoudhary96/Buzz-News/archive/master.zip) this repository.
  * `cd` into the project directory and run `pod install`.
  * Open the `Buzz News.xcworkspace` to open the project in Xcode.
  * Register on [Guardian](https://open-platform.theguardian.com/) to get your Guardian [API Key](https://open-platform.theguardian.com/access/).
  * Replace `GUARDIAN_API_KEY_HERE` text in `GuardianParamValues` in `Utils/Constants.swift` file by your api key.
  * Login to [Firebase](https://firebase.google.com/) and create a new [iOS app](https://firebase.google.com/docs/ios/setup) and place the downloaded `GoogleService-Info.plist` file in the Project Directory.

  <img width="267" alt="screenshot 2018-12-15 at 7 31 00 pm" src="https://user-images.githubusercontent.com/16102594/50043755-fadb8000-009f-11e9-8126-344ccc49b2e2.png">

  * Under the Firebase **Database** section change rules to the below rules:

 ```
  {
    "rules": {
      "news": {
        "$user_id": {
          ".read": "$user_id === auth.uid",
          ".write": "$user_id === auth.uid",
          ".indexOn": "webUrl"
        }
      }
    }
  }
  ```

  * Run the project using the `play` button on top left corner of xcode as you can see below in the screenshot.
  ![uploadImage](https://user-images.githubusercontent.com/16102594/50043842-1430fc00-00a1-11e9-88ca-02a9c1afb8e2.png)

## Things Learnt

 * Using FirebaseUI-Auth and RealTime Database
 * Researching and leveraging a new framework or library
 * Designing and building an app from the ground up
 * Finding sources of networked data

## ScreenShots
<img src="https://user-images.githubusercontent.com/16102594/50043852-375bab80-00a1-11e9-8b1c-dd6c11e81629.png" width="45%" height="800" align="left"/>
<img src="https://user-images.githubusercontent.com/16102594/50043853-375bab80-00a1-11e9-9140-3bb4bb1f2be6.png" width="45%" height="800" align="right"/>
