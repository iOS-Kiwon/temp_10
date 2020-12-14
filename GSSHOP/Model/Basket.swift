//
//  Basket.swift
//  GSSHOP
//
//  Created by Kiwon on 23/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class Basket: Mappable {
    
    var url: String = ""
    var format: String = ""
    var action: String = ""
    var params = [BasketParam]()
    /// 장바구니에 담긴 상품이 GS Fresh 여부
    var isFresh: String = ""

    required init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        self.url <- map["url"]
        self.format <- map["format"]
        self.action <- map["action"]
        self.params <- map["params"]
        self.isFresh <- map["isFresh"]
    }
}

class BasketParam: Mappable {
    
    var name: String = ""
    var value: String = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.name       <- map["name"]
        self.value      <- map["value"]
    }
    
}

/// 스마트카트 장바구니 담기 결과 객체
class BasketAddResult: Mappable {
    
    enum BasketAddResultCode: String {
        case success = "S"
        case aleadyExists = "EXP"
        case selectLocation = "NRD"
        case error = "E"
        case modifyCart = "M"
        case cert = "C"
        case none = "none"
        
        static let all:[BasketAddResultCode] = [.success, .aleadyExists, .selectLocation, .error, .modifyCart, .cert, .none]
    }
    
    /// 결과 코드
    ///
    /// S : 장바구니 담기 완료
    /// EXP : 장바구니에 상품이 이미 존재
    /// NRD : 마트 배송지 선택필요
    /// E : 오류 -> 일시품절 등
    /// M : 장바구니 수정 필요 (장바구니로 이동)
    /// C : 성인인증 필요
    var retCd: String = ""
    /// 결과 메시지
    var retMsg: String = ""
    /// 결과 링크
    var retUrl: String = ""
    /// 결과 코드값
    var code: BasketAddResultCode = .none
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.retCd          <- map["retCd"]
        self.retMsg         <- map["retMsg"]
        self.retUrl         <- map["retUrl"]
        
        BasketAddResultCode.all.forEach {
            if $0.rawValue == self.retCd {
                self.code = $0
            }
        }
        
        print("code : \(code.rawValue)")
    }
}
