//
//  Functions.swift
//  GSSHOP
//
//  Created by Kiwon on 26/07/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

//let YES :  Bool = true
//let NO : Bool = false

public func getAppFullWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

public func getAppFullHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}

public func getFooterHeight() -> CGFloat {
    return 300.0
}

public func getStatusBarHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.height
}

/// 단말의 Safe Area Inset값을 가져온다.
func getSafeAreaInsets() -> UIEdgeInsets {
    if isiPhoneXseries() {
        if #available(iOS 11.0, *),
            let window = UIApplication.shared.windows.first {
            return window.safeAreaInsets
        }
    }
    return .zero
}


/*
 #define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
 
 #define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
 #define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
 #define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
 
 #define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
 #define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
 #define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
 #define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
 #define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)
 
 #define IS_PLUS_OR_MAX (IS_IPHONE && SCREEN_WIDTH >= 414.0)
 
 // nami0342 - 아이폰 X 판단 -> 아이폰 XS, XR, XS max 대응 추가
 #if TARGET_OS_SIMULATOR || TARGET_IPHONE_SIMULATOR
 #define IS_IPHONE_X_SERISE ((SCREEN_MAX_LENGTH == 812.0 || SCREEN_MAX_LENGTH == 896.0) && IS_IPHONE)
 */
/// GSSHOP 앱 버전 : ex) 4.4.8
public func getAppVersion() -> String {
    if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
        return version
    }
    return ""
}

/// GSSHOP 빌드 버전 : ex) 267
public func getAppBuildVersion() ->  String? {
    if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
        return version
    }
    return nil
}

public func IS_IPHONE() -> Bool {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
}

public func IS_IPAD() -> Bool {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
}

public func SCREEN_WIDTH() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

public func SCREEN_HEIGHT() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

public func SCREEN_MAX_LENGTH() -> CGFloat {
    return max(SCREEN_WIDTH(),SCREEN_HEIGHT())
}

// MARK: - Devices
public func isIOS11() -> Bool{
    return CGFloat((UIDevice.current.systemVersion as NSString).floatValue) >= 11.0
}

public func isiPhone4() -> Bool{
    return UIScreen.main.bounds.size.height == 480.0
}

public func isiPhone5() -> Bool{
    return UIScreen.main.bounds.size.height == 568.0
}

public func isiPhone8() -> Bool{
    return UIScreen.main.bounds.size.height == 812.0
}

public func isiPhoneX() -> Bool{
    return UIScreen.main.bounds.size.height == 812.0
}

public func isiPhoneXr() -> Bool{
    return UIScreen.main.bounds.size.height == 896.0
}

public func isiPhoneXs() -> Bool{
    return UIScreen.main.bounds.size.height == 896.0
}

public func isiPhoneXsMax() -> Bool{
    return UIScreen.main.bounds.size.height == 896.0
}

public func isiPhoneXseries() -> Bool{
    if isiPhoneX() || isiPhoneXr() || isiPhoneXs() || isiPhoneXsMax() {
        return true
    }
    return false
}

public func IS_IPHONE_X_SERISE() -> Bool {
    return ((SCREEN_MAX_LENGTH() == 812.0 || SCREEN_MAX_LENGTH() == 896.0) && IS_IPHONE())
}

public func APPTABBARHEIGHT() -> CGFloat {
    return  IS_IPHONE_X_SERISE() ? 80.0 : 50.0
}

// MARK:- Mocha.Framework에서 가져온 함수들 정리.

////가로기준 세로비율 계산반환  가변높이영역 100%기준
public func getDPRateOriginVAL(_ tval : CGFloat) -> CGFloat {
    
    let screenLength = max(getAppFullWidth(), getAppFullHeight())

    if(screenLength == 480) {
        return tval;
    }
    else if(screenLength == 568) {
        
        return tval;
        
    } else if(screenLength == 667 || screenLength == 812) {
        
        return tval * 1.171875;
    }
        
    else if(screenLength == 736) {
        
        return tval * 1.29375;
    }
        
    else if(screenLength == 1024) {
        
        return tval * 2.4;
    }else {
        
        return tval;
    }
}


//#define WISELOGPAGEURL(pagestr) [NSString stringWithFormat:@"%@/app/statistic/wiseLog%@", SERVERURI, pagestr]
//#define WISELOGCOMMONURL(pagestr) [NSString stringWithFormat:@"%@/mobile/commonClickTrac.jsp%@", SERVERURI, pagestr]
//#define WISELOGSHORTBANG(pagestr) [NSString stringWithFormat:@"%@/app/static/shortbang%@", SERVERURI, pagestr]

// MAKR: - 와이즈로그 URL Define

public func wiselogpageurl(pagestr:String) -> String {
    return ServerUrl() + "/app/statistic/wiseLog" + pagestr
}

public func wiselogcommonurl(pagestr:String) -> String {
    return ServerUrl() + "/mobile/commonClickTrac.jsp" + pagestr
}

//public func wiselogshortbang(pagestr:String) -> String {
//    return ServerUrl() + "/app/static/shortbang" + pagestr
//}

// MARK:- 회사소개 URL
// #define GSCOMPANYINTROEURL [NSString stringWithFormat:@"%@/m/mygsshop/companyInfo.gs?fromApp=Y",SERVERURI]
public func gsCompanyIntroURL() -> String {
    return ServerUrl() + "/m/mygsshop/companyInfo.gs?fromApp=Y"
}

public func smartCartGsFreshUrl() -> String {
    return ServerUrl() + "/mobile/cart/viewCart.gs?mseq=398045&fromApp=Y&cartTabId=mart"
}

public func smartCartUrl(isFresh: String) -> String {
    let value = isFresh == "Y" ? true : false
    if value {
        return ServerUrl() + "/mobile/cart/viewCart.gs?mseq=398045&fromApp=Y&cartTabId=mart"
    }
    return ServerUrl() + "/mobile/cart/viewCart.gs?mseq=398045&fromApp=Y"
}



// nami0342 : Swift 용 NCS() - 입력 데이터의 문자화 및 null 처리
/*
 사용법 : product.Name 의 변수일 경우  WCS(input : product.Name)
 결과값 : String 값 (변환 실패일 경우 "" (빈 값) - 기존 NCS()와 동일)
 */
@inline (__always)func WCS (input : Any?)->String
{
    if let notnullInput = input
    {
        if let strInput = notnullInput as? String
        {
            if strInput.isEmpty {return ""}
            
            switch strInput
            {
            case "<null>":
                return ""
            case "(null)":
                return ""
            case "[null]":
                return ""
            default:
                return strInput
            }
        }
        else if let intInput = notnullInput as? Int{ return intInput.description }
        else if let floatInput = notnullInput as? Float { return floatInput.description }
        else if let doubleInput = notnullInput as? Double { return doubleInput.description }
        else { return ""}
    }
    else
    {
        return ""
    }
}
