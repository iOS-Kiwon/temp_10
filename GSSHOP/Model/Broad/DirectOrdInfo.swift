//
//  DirectOrdInfo.swift
//  GSSHOP
//
//  Created by Kiwon on 13/12/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation
import ObjectMapper

class DirectOrdInfo: Mappable {
    
    var imageUrl: String = ""
    var linkUrl: String = ""
    var imageAlt: String = ""
    var text: String = ""
    var remark1: String = ""
    var remark2: String = ""
    var videoid: String = ""

    required init?(map: Map) {}
    
    init() {}
    
    func mapping(map: Map) {
        self.imageUrl       <- map["imageUrl"]
        self.linkUrl        <- map["linkUrl"]
        self.imageAlt       <- map["imageAlt"]
        self.text           <- map["text"]
        self.remark1        <- map["remark1"]
        self.remark2        <- map["remark2"]
        self.videoid        <- map["videoid"]
    }
}
