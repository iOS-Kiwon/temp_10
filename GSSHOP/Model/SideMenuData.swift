//
//  SideMenuData.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/06/12.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import Foundation
import ObjectMapper

class SideMenuData: NSObject, Mappable {
    
    var viewType: String = ""
    var desc: String = ""
    var title: String = ""
    var imageUrl: String = ""
    var linkUrl: String = ""
    var subContentList = [SideMenuData]()
    var imageUrlLogo: String = ""
    var wiseLogUrl: String = ""
    
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
        self.viewType               <- map["viewType"]
        self.desc                   <- map["description"]
        self.title                  <- map["title"]
        self.imageUrl               <- map["imageUrl"]
        self.linkUrl                <- map["linkUrl"]
        self.subContentList         <- map["subContentList"]
        self.imageUrlLogo           <- map["imageUrlLogo"]
        self.wiseLogUrl             <- map["wiseLogUrl"]
    }
}
