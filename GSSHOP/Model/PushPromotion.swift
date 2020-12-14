//
//  PushPromotion.swift
//  GSSHOP
//
//  Created by Home on 2020/08/25.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import Foundation
import ObjectMapper

class PushPromotion: NSObject, Mappable {
    /*
    "result": "Y",
    "link": "http://m.gsshop.com/index.gs",
    "bannertype": "P",
    "linktype": "A",
    "imgurl": "http://image.gsshop.com/planprd/banner_MOBILE/35632508_02.jpg"
    */
    
    var result: String = ""
    var link: String = ""
    var bannerType: String = ""
    var linkType: String = ""
    var imgUrl: String = ""
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    /// Dictionary 객체를  mapper 객체로 초기화
    @objc init(withDic dic: [String: Any]) {
        super.init()
        let mapData = Map.init(mappingType: .fromJSON, JSON: dic)
        mapping(map: mapData)
    }
    
    func mapping(map: Map) {
        self.result         <- map["result"]
        self.link           <- map["link"]
        self.bannerType     <- map["bannertype"]
        self.linkType       <- map["linktype"]
        self.imgUrl         <- map["imgurl"]
    }
}
