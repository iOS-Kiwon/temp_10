//
//  SubMenu.swift
//  GSSHOP
//
//  Created by Kiwon on 07/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation
import ObjectMapper

class SubMenu:NSObject, Mappable {
    
    var sectionId: Int = 0
    var motherNavigationId: Int = 0
    var motherviewType: String = ""
    var navigationId: Int = 0
    var viewType: String = ""
    var sectionName: String = ""
    var sectionLinkUrl: String = ""
    var sectionLinkParams: String = ""
    var sectionImgOnUrl: String = ""
    var sectionImgOffUrl: String = ""
    var wiseLogUrl: String = ""
    
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
        self.sectionId          <- map["sectionId"]
        self.motherNavigationId <- map["motherNavigationId"]
        self.motherviewType     <- map["motherviewType"]
        self.navigationId       <- map["navigationId"]
        self.viewType           <- map["viewType"]
        self.sectionName        <- map["sectionName"]
        self.sectionLinkUrl     <- map["sectionLinkUrl"]
        self.sectionLinkParams  <- map["sectionLinkParams"]
        self.sectionImgOnUrl    <- map["sectionImgOnUrl"]
        self.sectionImgOffUrl   <- map["sectionImgOffUrl"]
        self.wiseLogUrl         <- map["wiseLogUrl"]
    }
}

class Section: Mappable {
    var subMenuList = [SubMenu]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.subMenuList    <- map["subMenuList"]
    }
}

