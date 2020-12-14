//
//  Banner.swift
//  GSSHOP
//
//  Created by Kiwon on 27/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class Banner: NSObject, Mappable {

    var imageUrl : String = ""
    var linkUrl : String = ""
    var title : String = ""
    var wiseLog : String = ""
    var height : String = ""
    
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
        self.imageUrl       <- map["imageUrl"]
        self.linkUrl        <- map["linkUrl"]
        self.title          <- map["title"]
        self.wiseLog        <- map["wiseLog"]
        self.height         <- map["height"]
    }
}
