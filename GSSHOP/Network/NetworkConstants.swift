//
//  NetworkConstants.swift
//  GSSHOP
//
//  Created by Kiwon on 15/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation
/*
#if SM14 && !APPSTORE
let SERVER_MAIN_DOMAIN =            "sm21.gsshop.com/"
let SERVER_URL =                    "http://sm21.gsshop.com/"
let SERVERURL_HTTPS =               "https://sm21.gsshop.com/"
let SERVER_MAIN_DOMAIN_FOR_SSL =    "sm21.gsshop.com/"       // SSL 설정용
#elseif TM14 && !APPSTORE
let SERVER_MAIN_DOMAIN =            "tm14.gsshop.com/"
let SERVER_URL =                    "http://tm14.gsshop.com/"
let SERVER_URL_HTTPS =              "http://tm14.gsshop.com/" //TM14는 https 예외
let SERVER_MAIN_DOMAIN_FOR_SSL =    "tm14.gsshop.com/"       // SSL 설정용
#else
let SERVER_MAIN_DOMAIN =            "m.gsshop.com/"
let SERVER_URL =                    "http://m.gsshop.com/"
let SERVER_URL_HTTPS =              "https://m.gsshop.com/"
let SERVER_MAIN_DOMAIN_FOR_SSL =    "m.gsshop.com/"
#endif
*/
public func ServerUrl() -> String {
    #if SM14
    let currentMode = UserDefaults.standard.object(forKey: DEV_MODE) as? String ?? DEV_MODE_DEFAULT_VALUE
    if currentMode == "TM14" {
        return "http://tm14.gsshop.com"
    } else if currentMode == "M" {
        return "http://m.gsshop.com"
    } else {
        return "http://sm20.gsshop.com"
    }
    #else
    return "http://m.gsshop.com"
    #endif
}

extension Const {
    
    /// URL은 대문자로 해볼까낭
    enum Url: String {
        case API_GROUP_LIST = "/app/navigation?version="
        
        /// GS SHOP
        case GS_SHOP_HOME = "http://gsshop.com"
        /// 사업자 정보
        case GS_COMPANY_INFO = "http://www.ftc.go.kr/bizCommPop.do?wrkr_no=1178113253"
        /// 채무 지급 보증
        case GS_COMPANY_GUARANTEE = "/mobile/etc/etc_loan.jsp"
        
        var url: String { return self.rawValue }
        
    }
    
    enum NetworkFilterURL : String { case
        mt = "http://mt.gsshop.com/",
        tm = "http://tm13.gsshop.com/",
        sm = "http://sm.gsshop.com/",
        tm14 = "http://tm14.gsshop.com/",
        sm20 = "http://sm20.gsshop.com/",
        dm13 = "http://dm13.gsshop.com/",
        sm15 = "http://sm15.gsshop.com/"
        
        var url: String {
            return self.rawValue
        }
        
        static let all: [NetworkFilterURL] =
            [.mt, .tm, .sm, .tm14, .sm20, .dm13, .sm15]
    }
    
}

extension Notification.Name {
    public static let NetworkReachabilityDidChange = Notification.Name(rawValue: "alamofire.notification.name.NetworkReachabilityDidChange")
}

extension NSNotification {
    @objc public static let NetworkReachabilityDidChange: NSString = "alamofire.notification.name.NetworkReachabilityDidChange"
}
