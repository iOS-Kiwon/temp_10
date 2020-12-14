//
//  TvLiveBanner.swift
//  GSSHOP
//
//  Created by gsshop iOS on 2020/06/30.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class TvLiveBanner: NSObject, Mappable {
    
    var saleQuantity:Int = 0
    var addTextLeft:String = ""
    var addTextRight:String = ""
    var rentalPriceText:String = ""
    var playUrl:String = ""
    var vipBadgeYn:String = ""
    var source:ImageInfo?
    var seq:Int = 0
    var tempOut: Bool = false
    var broadType:String = ""
    var imageUrl:String = ""
    var linkUrl:String = ""
    var productName:String = ""
    var salePrice:String = ""
    var basePrice:String = ""
    var exposePriceText:String = ""
    var broadScheduleLinkUrl:String = ""
    var broadStartTime:String = ""
    var broadCloseTime:String = ""
    var isCellPhone: Bool = false
    var isRental: Bool = false
    var accmText:String = ""
    var accmUrl:String = ""
    var orderQuantity:Int = 0
    var noIntYn:String = ""
    var noIntMmCnt:Int = 0
    var accAmtYn:String = ""
    var accAmt:Int = 0
    var liveBenefitsYn:String = ""
    var liveBenefitsText:String = ""
    var brodScheduleYn:String = ""
    var brodScheduleText:String = ""
    var rightNowBuyYn:String = ""
    var rightNowBuyUrl:String = ""
    var salesInfo : SalesInfo?
    var livePlay : LivePlay?
    var btnInfo3 : DirectOrdInfo?
    var imageLayerFlag:String = ""
    var priceMarkUp:String = ""
    var priceMarkUpType:String = ""
    var liveTalkYn:String = ""
    var liveTalkText:String = ""
    var liveTalkUrl:String = ""
    var rentalText:String = ""
    var rentalPrice:String = ""
    var rentalEtcText:String = ""
    
    
    var rwImgList = [String]()
    var totalPrdViewLinkUrl:String = ""
    var mobileLiveYn:String = ""
    var mobileLiveInfo : MobileLiveInfo?
    var imgBadgeCorner : ImgBadgeCorner?
    var infoBadge : InfoBadge?
    var allBenefit = [ImageInfo]()
    var brandNm:String = ""
    var reviewCount:Int = 0
    var reviewAverage:Int = 0
    var broadTimeText:String = ""
    var hasVod: Bool = false
    var rtamtCd:String = ""
    var rtamt:Int = 0

    
    //"banner": null, //구조를 알수없는 과거의 미사용 필드
    //"liveTalkBanner": null, //구조를 알수없는 과거의 미사용 필드
    
    
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
        self.saleQuantity           <- map["saleQuantity"]
        self.addTextLeft            <- map["addTextLeft"]
        self.addTextRight           <- map["addTextRight"]
        self.rentalPriceText        <- map["rentalPriceText"]
        self.playUrl                <- map["playUrl"]
        self.vipBadgeYn             <- map["vipBadgeYn"]
        self.source                 <- map["source"]
        self.seq                    <- map["seq"]
        self.tempOut                <- map["tempOut"]
        self.broadType              <- map["broadType"]
        self.imageUrl               <- map["imageUrl"]
        self.linkUrl                <- map["linkUrl"]
        self.productName            <- map["productName"]
        self.salePrice              <- map["salePrice"]
        self.basePrice              <- map["basePrice"]
        self.exposePriceText        <- map["exposePriceText"]
        self.broadScheduleLinkUrl   <- map["broadScheduleLinkUrl"]
        self.broadStartTime         <- map["broadStartTime"]
        self.broadCloseTime         <- map["broadCloseTime"]
        self.isCellPhone            <- map["isCellPhone"]
        self.isRental               <- map["isRental"]
        self.accmText               <- map["accmText"]
        self.accmUrl                <- map["accmUrl"]
        self.orderQuantity          <- map["orderQuantity"]
        self.noIntYn                <- map["noIntYn"]
        self.noIntMmCnt             <- map["noIntMmCnt"]
        self.accAmtYn               <- map["accAmtYn"]
        self.accAmt                 <- map["accAmt"]
        self.liveBenefitsYn         <- map["liveBenefitsYn"]
        self.liveBenefitsText       <- map["liveBenefitsText"]
        self.brodScheduleYn         <- map["brodScheduleYn"]
        self.brodScheduleText       <- map["brodScheduleText"]
        self.rightNowBuyYn          <- map["rightNowBuyYn"]
        self.rightNowBuyUrl         <- map["rightNowBuyUrl"]
        self.salesInfo              <- map["salesInfo"]
        self.livePlay               <- map["livePlay"]
        self.btnInfo3               <- map["btnInfo3"]
        self.imageLayerFlag         <- map["imageLayerFlag"]
        self.priceMarkUp            <- map["priceMarkUp"]
        self.priceMarkUpType        <- map["priceMarkUpType"]
        self.liveTalkYn             <- map["liveTalkYn"]
        self.liveTalkText           <- map["liveTalkText"]
        self.liveTalkUrl            <- map["liveTalkUrl"]
        self.rentalText             <- map["rentalText"]
        self.rentalPrice            <- map["rentalPrice"]
        self.rentalEtcText          <- map["rentalEtcText"]
        self.rwImgList              <- map["rwImgList"]
        self.totalPrdViewLinkUrl    <- map["totalPrdViewLinkUrl"]
        self.mobileLiveYn           <- map["mobileLiveYn"]
        self.mobileLiveInfo         <- map["mobileLiveInfo"]
        self.imgBadgeCorner         <- map["imgBadgeCorner"]
        self.infoBadge              <- map["infoBadge"]
        self.allBenefit             <- map["allBenefit"]
        self.brandNm                <- map["brandNm"]
        self.reviewCount            <- map["reviewCount"]
        self.reviewAverage          <- map["reviewAverage"]
        self.broadTimeText          <- map["broadTimeText"]
        self.hasVod                 <- map["hasVod"]
        self.rtamtCd                <- map["rtamtCd"]
        self.rtamt                  <- map["rtamt"]
        
    }
}


class SalesInfo: Mappable {

    var broadStrDtm: String = ""
    var ordQty: String = ""
    var suplyQty: String = ""
    var saleRate: String = ""
    var saleRateExposeYn: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.broadStrDtm <- map["broadStrDtm"]
        self.ordQty   <- map["ordQty"]
        self.suplyQty   <- map["suplyQty"]
        self.saleRate     <- map["saleRate"]
        self.saleRateExposeYn     <- map["saleRateExposeYn"]

    }
}

class LivePlay: Mappable {

    var videoid: String = ""
    var livePlayUrl: String = ""
    var livePlayYN: String = ""

    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.videoid <- map["videoid"]
        self.livePlayUrl   <- map["livePlayUrl"]
        self.livePlayYN   <- map["livePlayYN"]

    }
}


class MobileLiveInfo: Mappable {

    var imgUrl: String = ""
    var text: String = ""
    var linkUrl: String = ""

    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.imgUrl <- map["imgUrl"]
        self.text   <- map["text"]
        self.linkUrl   <- map["linkUrl"]

    }
}
