//
//  InfoBadge.swift
//  GSSHOP
//
//  Created by Kiwon on 23/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class InfoBadge: Mappable {
    /// Title Front : 제목 앞에 오는 벳지
    var TF: [ImageInfo]?
    /// Value Tail : 가격 뒤에 오는 벳지
    var VT: [ImageInfo]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        self.TF <- map["TF"]
        self.VT <- map["VT"]
    }
}
