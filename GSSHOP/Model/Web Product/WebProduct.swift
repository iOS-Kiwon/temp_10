//
//  WebProduct.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/26.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import Foundation
import ObjectMapper

class WebProduct: NSObject, Mappable {
    
    /// 상품 코드
    var prdCode: String = ""
    /// 딜 코드
    var dealNo: String = ""
    /// 상품 타입 - 딜,단품,프리미엄,GS Fresh
    var prdTypeCode: String = ""
    /// 성인인증 여부 Y / N
    var checkAdultPrdYN: String = ""
    /// 성인인증 링크
    var adultCertRetUrl: String = ""
    /// 상품 컴포넌트 배열 객채
    var components = [Components]()
    /// 결과 코드
    var resultCode: String = ""
    /// 결과 메시지
    var resultMessage: String = ""
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    init(withDic dic: [String:Any]) {
        super.init()
        let mapData = Map.init(mappingType: .fromJSON, JSON: dic)
        mapping(map: mapData)
    }
    
    func mapping(map: Map) {
        self.prdCode                    <- map["prdCd"]
        self.dealNo                     <- map["dealNo"]
        self.prdTypeCode                <- map["prdTypeCode"]
        self.checkAdultPrdYN            <- map["checkAdultPrdYN"]
        self.adultCertRetUrl            <- map["adultCertRetUrl"]
        self.components                 <- map["components"]
        self.resultCode                 <- map["resultCode"]
        self.resultMessage              <- map["resultMessage"]
    }
}

