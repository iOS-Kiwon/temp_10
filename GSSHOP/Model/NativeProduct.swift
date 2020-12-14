//
//  NativeProduct.swift
//  GSSHOP
//
//  Created by gsshop iOS on 2020/02/11.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class NativeProduct: NSObject, Mappable {

    var prdCd:String = ""
    var type:String = ""
    var imgList = [ImgList]()
    var movList = [MovList]()
    var cartPrdNum:String = ""
    var prdNm:String = ""
    var prdPromoTxt:String = ""
    var liveBroadFlg: String = ""
    var isBroadPrd:Bool = false
    var broad = [Broad]()
    var preCachingUrl = ""
    
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
        self.prdCd                      <- map["prdCd"]
        self.type                       <- map["type"]
        self.imgList                    <- map["imgList"]
        self.movList                    <- map["movList"]
        self.cartPrdNum                 <- map["cartPrdNum"]
        self.prdNm                      <- map["prdNm"]
        self.prdPromoTxt                <- map["prdPromoTxt"]
        self.liveBroadFlg               <- map["liveBroadFlg"]
        self.isBroadPrd                 <- map["isBroadPrd"]
        self.broad                      <- map["broad"]
        self.preCachingUrl              <- map["preCachingUrl"]
    }
}

class ImgList: Mappable {
    
    var imgUrl:String = ""
//    var linkUrl:String = ""
//    var imgEUrl:String = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        self.imgUrl <- map["imgUrl"]
//        self.linkUrl <- map["linkUrl"]
//        self.imgEUrl <- map["imgEUrl"]
    }
}

class MovList: Mappable {
    
    var brightcoveYn:String = ""
    var movId:String = ""
    var videoVertYn:String = ""
    var videoUrl: String = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        self.brightcoveYn   <- map["brightcoveYn"]
        self.movId          <- map["movId"]
        self.videoVertYn    <- map["videoVertYn"]
        self.videoUrl       <- map["videoUrl"]
    }
}

class Broad: Mappable {
    
    var broadTime:String = ""
    var broadType:String = ""
    var broadAlamYN:String = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        self.broadTime <- map["broadTime"]
        self.broadType <- map["broadType"]
        self.broadAlamYN <- map["broadAlamYN"]
    }
}

///// Log 를 위한 Extension 추가
//extension Mappable {
//    var description: String {
//        get {
//            return Mapper().toJSONString(self, prettyPrint: false)!
//        }
//    }
//}
