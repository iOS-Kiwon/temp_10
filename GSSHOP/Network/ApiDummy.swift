//
//  ApiDummy.swift
//  GSSHOP
//
//  Created by Kiwon on 05/12/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation

@objc enum DummyType: Int {
    /// TV편성표
    case SLIST
    /// 내일TV
    case VODLIST
    /// 홈
    case TCLIST
    /// 오늘추천
    case FXCLIST_todayRcmd
    /// 매직딜데이
    case FXLIST_dealDay
    /// GS X 브랜드
    case FXCLIST_gsXbrand
    /// 내일도착
    case NFXCLIST
    /// GS Fresh
    case SUPLIST
    /// 지금 Best
    case FXCLIST_newBest
    /// 오늘오픈
    case FXCLIST_todayOpen
    /// 오늘혜택
    case EILIST
    /// 단품
    case WebPrd
}

@objc class ApiDummy: NSObject {
    static let EILIST = "EILIST"
    static let FXLIST_dealDay = "FXLIST_dealDay"
    static let FXCLIST_gsXbrand = "FXCLIST_gsXbrand"
    static let FXCLIST_newBest = "FXCLIST_newBest"
    static let FXCLIST_todayOpen = "FXCLIST_todayOpen"
    static let FXCLIST_todayRcmd = "FXCLIST_todayRcmd"
    static let NFXCLIST = "NFXCLIST"
    static let SLIST = "SLIST"
    static let SUPLIST = "SUPLIST"
    static let TCLIST = "TCLIST"
    static let VODLIST = "VODLIST"
    static let WebPrd = "WebPrd"
    
    @objc static let shard = ApiDummy()
/*
     사용법 예시 - TV편성표 json dummy 데이터 호출시.
     
     NSDictionary *dic = [ApiDummy.shard getDummyDataWithType:DummyTypeSLIST];
     
     NSLog("===================================================\nDummy Data Start\n===================================================");
     NSLog(@"%@", dic);
     NSLog("===================================================\nDummy Data End\n===================================================");
 */
    
    /// 매장타입별(type) json파일의 데이터를 Dictionary 형태로 반환
    @objc func getDummyData(type: DummyType) -> [String: Any]? {
        
        if let data = self.getJsonFile(type) {
            return data
        }
        return nil
    }
    
    
    /// 매장타입에 따른 파일 이름 설정 후 json Data를 반환
    private func getJsonFile(_ type: DummyType) -> [String: Any]? {
        var fileName = ""
        switch type {
        case .EILIST:
            fileName = ApiDummy.EILIST
        case .FXLIST_dealDay:
            fileName = ApiDummy.FXLIST_dealDay
        case .FXCLIST_gsXbrand:
            fileName = ApiDummy.FXCLIST_gsXbrand
        case .FXCLIST_newBest:
            fileName = ApiDummy.FXCLIST_newBest
        case .FXCLIST_todayOpen:
            fileName = ApiDummy.FXCLIST_todayOpen
        case .FXCLIST_todayRcmd:
            fileName = ApiDummy.FXCLIST_todayRcmd
        case .NFXCLIST:
            fileName = ApiDummy.NFXCLIST
        case .SLIST:
            fileName = ApiDummy.SLIST
        case .SUPLIST:
            fileName = ApiDummy.SUPLIST
        case .TCLIST:
            fileName = ApiDummy.TCLIST
        case .VODLIST:
            fileName = ApiDummy.VODLIST
        case .WebPrd:
            fileName = ApiDummy.WebPrd
        }
        
        guard let path = Bundle.main.url(forResource: fileName, withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: path)
            if let json  = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            }
        } catch {
            return nil }
        
        return nil
    }
    
    
    
}
