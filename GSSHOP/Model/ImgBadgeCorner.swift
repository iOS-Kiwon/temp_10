//
//  ImgBadgeCorner.swift
//  GSSHOP
//
//  Created by Kiwon on 23/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class ImgBadgeCorner: Mappable {
    
    var LT = [ImageInfo]()
    var RT = [ImageInfo]()
    var LB = [ImageInfo]()
    var RB = [ImageInfo]()
    //var ALL = [ImageInfo]()
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    init() {        
    }
    
    func mapping(map: Map) {
        self.LT <- map["LT"]
        self.RT <- map["RT"]
        self.LB <- map["LB"]
        self.RB <- map["RB"]
        //self.ALL <- map["ALL"]
    }
}

class ImageInfo: Mappable {
    var imgUrl: String = ""
    var text: String = ""
    var type: String = ""
    /// source에서 사용하는 BOLD/NOMAL 타입값
    var styleType: String = ""
    
    /// bg 속성의 이미지 : SectionTAB_SLtype 에서 사용
    var bg: String?
    /// 버튼따위의 on 이미지 : 숏방에 사용함
    var on: String?
    /// 버튼따위의 off 이미지 : 숏방에서 사용함
    var off: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.imgUrl <- map["imgUrl"]
        self.text   <- map["text"]
        self.type   <- map["type"]
        self.bg     <- map["bg"]
        self.on     <- map["on"]
        self.off    <- map["off"]
        self.styleType <- map["styleType"]
    }
}
