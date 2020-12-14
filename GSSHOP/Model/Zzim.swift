//
//  Zzim.swift
//  GSSHOP
//
//  Created by Kiwon on 06/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation
import ObjectMapper

class Zzim: NSObject, Mappable {
    
    var isFile: Bool?
    var resultMessage: String = ""
    var resultCode: String = ""
    var success: Int = -1
    var linkUrl: String = ""
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    override init() {
        super.init()
    }
    
    /// Dictionary 객체를  mapper 객체로 초기화
    @objc init(withDic dic: [String: Any]) {
        super.init()
        let mapData = Map.init(mappingType: .fromJSON, JSON: dic)
        mapping(map: mapData)
    }
    
    func mapping(map: Map) {
        if let value = map.JSON["isFile"] as? Bool {
            self.isFile = value
        } else {
            self.isFile = nil
        }
        
        self.resultMessage      <- map["resultMessage"]
        self.resultCode         <- map["resultCode"]
        self.success            <- map["success"]
        self.linkUrl            <- map["linkUrl"]
    }
    
}
