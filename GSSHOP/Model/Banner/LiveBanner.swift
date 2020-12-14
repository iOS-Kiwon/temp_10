//
//  LiveBanner.swift
//  GSSHOP
//
//  Created by Kiwon on 25/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class LiveBanner: Banner {
    var imageAlt: String = ""
    var remark1: String = ""
    var remark2: String = ""
    var text: String = ""
    var videoId: String = ""

    required init?(map: Map) {
        super.init(map: map)
        mapping(map: map)
    }    
    
    override init(withDic dic: [String:Any]) {
        super.init(withDic: dic)
        let mapData = Map.init(mappingType: .fromJSON, JSON: dic)
        mapping(map: mapData)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.remark1        <- map["remark1"]
        self.remark2        <- map["remark2"]
        self.text           <- map["text"]
        self.videoId        <- map["videoid"]
    }
}
