//
//  Module.swift
//  GSSHOP
//
//  Created by Kiwon on 14/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class Module: NSObject, Mappable {

    var moduleType:String = ""
    var viewType:String = ""
    var mseq:String = ""
    var wiseLog: String = ""
    var shopNumber:Int = 0
    var productList = [Module]()
    var gdLocseq:String = ""
    var gdCode:String = ""
    var moduleList = [Module]()
    var imageUrl:String = ""
    var linkUrl:String = ""
    var tabSeq:String = ""
    /// 내일도착 - 타이틀 헤드카피 
    var name:String = ""
    /// 내일도착 - 타이틀 이미지 url
    var tabImg: String = ""
    var tabBgImg:String = ""
    var tabOnImg:String = ""
    var tabOffImg:String = ""
    var swiperYn:String = ""
    var totalCnt:Int = 0
    var ajaxTabPrdListUrl:String = ""
    var title :String = ""
    /// 자동 스크롤 초 단위, 0이면 자동 스크롤링이 되지 않음
    var rollingDelay :Int = 0
    /// 이미지 높이
    var height: Int?
    /// 계산된 이미지 높이
    var calcHeight: Int = 0
    /// 더보기 Url
    var ajaxPageUrl: String = ""
    /// 내일도착 - SubTitle(주문마감 20:00)
    var subName: String = ""
    /// 내일도착 - Title 색상
    var textColor: String = ""
    /// 내일도착 - 카테고리 버튼 Selected상태 Text색상
    var activeTextColor: String = ""
    /// 내일도착 - 이미지배너 바로가기 Text
    var linkText: String = ""
    /// 내일도착 - 이미지배너 Bg 타입 (typeA / typeB)
    var linkBgColor: String = ""
    /// 내일도착 - 더보기 이미지
    var moreBtnImgUrl: String = ""
    /// 내일도착 - 더보기 링크
    var moreBtnUrl: String = ""
    /// 내일도착 - 이미지배너 Bg 색상
    var bgColor: String = ""
    /// listType
    var listType: Any?
    /// 내일도착 - 이미지배너 Text객체
    var textImageModule: Module?
    /// 내일도착 - 이미지배너 첫번째 Text
    var title1: String = ""
    /// 내일도착 - 이미지배너 두번째 Text
    var title2: String = ""
    /// 타이틀배너 하단 라인 추가 여부 기본값N
    var bdrBottomYn: String = "N"
    /// 내일도착 바로구매 정보
    var directOrdInfo = DirectOrdInfo()
    
    //--- 아래는 사실상 Product에 포함됨
    /// 리뷰 평점
    var reviewAverage: String = ""
    /// 브랜드 명
    var brandNm: String = ""
    /// 브랜드 아이콘 이미지
    var brandImg: String = ""
    /// 혜택? 앞 정보(ex: TV쇼핑)
    var source:ImageInfo?
    // 혜택 모음
    var allBenefit = [ImageInfo]()
    /// MORE : 더보기 표시 (선택시 linkUrl 로 이동), AD : '광고' 표시
    var badgeRTType:String = ""
    /// 가장 마지막 상품이 더보기 인지 여부
    var moreText:String = ""
    /// 방송시간
    var broadTimeText:String = ""
    
    //상품 우측에 상품평수 및 평점 혹은 구매 건수 노출 영역
    var addTextLeft:String = ""
    var addTextRight:String = ""
    
    //렌탈용 정보
    var rentalPriceText:String = ""
    var rentalPrice:String = ""
    var rentalText:String = ""
    var mnlyRentCostVal:String = ""
    
    
    
    //Product
    var exposePriceText: String = ""
    var etcText1: String = ""
    var prdid: Int = 0
    var dealNo: Int = 0
    var hasVod: Bool = false
    var productName: String = ""
    var promotionName: String = ""
    var discountRate: Int = 0
    var discountRateText: String = ""
    var salePrice: String = ""
    var basePrice: String = ""
    
    var saleQuantity: String = ""
    var saleQuantityText: String = ""
    var saleQuantitySubText: String = ""
    var productType: String  = ""
    var isTempOut: Bool = false
    /// 현재 안씀 :
    var isTempOutTime: Int = 0
    var dealProductType: String = ""
    
    var startDate: Int = 0
    var endDate: Int = 0
    var sectionId: String = ""
    var prdGbnCd: String = ""
    var cateGb: String = ""
    var isNo1Schedule: String = ""
    var no1ScheduleUrl: String = ""
    var dealType: String = ""
    
    /// 무슨값인지 모르겠다ㅠㅠㅠ
    var subContentChild = [Module]()
    var subProductList = [Module]()
    var imgBadgeCorner = ImgBadgeCorner()
    
    /// 숏방에서 사용한 wise log값
    var wiseLog2: String = ""
    var quickShippingYn: String = ""
    var freeDlvYn: String = ""
    var adultCertYn: String = ""
    var no1DealYn: String = ""
    var infoBadge = InfoBadge()
    
    var valueText: String = ""
    var valueInfo: String = ""
    var adDealYn: String = ""
    var startDtm: String = ""
    var isTvHot: String = ""
    var isTvHotLogo: String = ""
    var dealMcVideoUrlAddr: String = ""
    var imageList = [ImageInfo]()
    var videoTime: String = ""
    
    /// 해시태그 String List : 앱에서 사용중인가?
    var productHashTags = [String]()
    /// 해시태그 WiseLog String List : 사용중인가?
    var productHashTagWiseLogs = [String]()
    /// 찜하기
    var isWish: Bool?
    /// 찜 노출 여부
    var isWishEnable: Bool = false
    /// 브랜드 찜하기 url
    var brandWishAddUrl: String = ""
    /// 브랜드 찜하기 해제 url
    var brandWishRemoveUrl: String = ""
    /// 찜 갯수
    var wishCnt : String = ""
    var imageLayerFlag: String = ""
    var sbCateGb: String = ""
    var sbVideoNum: String = ""
    var directOrdUrl: String = ""
    var snsImageUrl: String = ""
    
    /// 롤링시 랜덤유무 값
    var randomYn: String = ""
    /// 롤링 시간
    var rwImgList = [String]()
    /// 장바구니
    var basket = Basket()
    var videoid: String = ""
    var vodImg: String = ""
    var exposPrSntncNm: String = ""
    /// 상품평 점수
    var reviewCount: String = ""
    /// 프로모션 타이틀
    var pmoTitle: String = ""
    /// 프로모션 서브 타이틀
    var pmoSubTitle: String = ""
    /// 방송모듈에서 플레이 버튼 클릭시 이동할 url
    var playUrl: String = ""
    
    
    //Broad    
    var pgmId: Int = 0
    var broadStartDate: String = ""
    var broadEndDate: String = ""
    var startTime: String = ""
    var specialPgmYn: String = ""
    var specialPgmInfo: Any?
    var publicBroadYn: String = ""
    var pgmLiveYn: String = ""
    var liveTalkInfo: Any?
    var livePlayInfo: Any?
    var liveBanner: LiveBanner?
    var product: Module?
    var liveBenefitLText: String = ""
    var liveBenefitRText: String = ""
    
    var deal:Bool = false
    
    var useName: String = "N"
    
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
        self.moduleType             <- map["moduleType"]
        self.viewType               <- map["viewType"]
        self.mseq                   <- map["mseq"]
        self.wiseLog                <- map["wiseLog"]
        self.shopNumber             <- map["shopNumber"]
        self.productList            <- map["productList"]
        self.gdLocseq               <- map["gdLocseq"]
        self.gdCode                 <- map["gdCode"]
        self.moduleList             <- map["moduleList"]
        self.imageUrl               <- map["imageUrl"]
        self.linkUrl                <- map["linkUrl"]
        self.tabSeq                 <- map["tabSeq"]
        self.name                   <- map["name"]
        
        self.tabImg                 <- map["tabImg"]
        self.tabBgImg               <- map["tabBgImg"]
        self.tabOnImg               <- map["tabOnImg"]
        self.tabOffImg              <- map["tabOffImg"]
        self.swiperYn               <- map["swiperYn"]
        self.totalCnt               <- map["totalCnt"]
        self.ajaxTabPrdListUrl      <- map["ajaxTabPrdListUrl"]
        self.title                  <- map["title"]
        self.rollingDelay           <- map["rollingDelay"]
        self.height                 <- map["height"]
        
        if let value = map.JSON["calcHeight"] as? Int {
            self.calcHeight  = value
        } else if let value = map.JSON["calcHeight"] as? String,
            let height = NumberFormatter().number(from: value)?.intValue {
            self.calcHeight = height
        }
        
        self.ajaxPageUrl            <- map["ajaxPageUrl"]
        self.subName                <- map["subName"]
        
        self.textColor              <- map["textColor"]
        self.activeTextColor        <- map["activeTextColor"]
        self.linkText               <- map["linkText"]
        self.linkBgColor            <- map["linkBgColor"]
        self.moreBtnImgUrl          <- map["moreBtnImgUrl"]
        self.moreBtnUrl             <- map["moreBtnUrl"]
        self.bgColor                <- map["bgColor"]
        self.listType               <- map["listType"]
        self.title1                 <- map["title1"]
        self.title2                 <- map["title2"]
        self.textImageModule        <- map["textImageModule"]
        self.bdrBottomYn            <- map["bdrBottomYn"]
        
        self.reviewAverage          <- map["reviewAverage"]
        self.brandNm                <- map["brandNm"]
        self.brandImg               <- map["brandImg"]
        self.source                 <- map["source"]
        self.allBenefit             <- map["allBenefit"]
        self.badgeRTType            <- map["badgeRTType"]
        self.moreText               <- map["moreText"]
        self.broadTimeText          <- map["broadTimeText"]
        
        self.addTextLeft            <- map["addTextLeft"]
        self.addTextRight           <- map["addTextRight"]
        
        self.rentalPriceText        <- map["rentalPriceText"]
        self.rentalPrice            <- map["rentalPrice"]
        self.rentalText             <- map["rentalText"]
        self.mnlyRentCostVal        <- map["mnlyRentCostVal"]
        
        self.directOrdInfo          <- map["directOrdInfo"]
        
        //Product
        self.exposePriceText <- map["exposePriceText"]
        self.etcText1 <- map["etcText1"]
        self.prdid <- map["prdid"]
        self.dealNo <- map["dealNo"]
        self.hasVod <- map["hasVod"]
        self.productName <- map["productName"]
        self.promotionName <- map["promotionName"]
        
        self.discountRate <- map["discountRate"]
        self.discountRateText <- map["discountRateText"]
        self.salePrice <- map["salePrice"]
        self.basePrice <- map["basePrice"]
        self.saleQuantity <- map["saleQuantity"]
        self.saleQuantityText <- map["saleQuantityText"]
        self.saleQuantitySubText <- map["saleQuantitySubText"]
        self.productType <- map["productType"]
        self.isTempOut <- map["isTempOut"]
        self.isTempOutTime <- map["isTempOutTime"]
        self.dealProductType <- map["dealProductType"]
        self.startDate <- map["startDate"]
        self.endDate <- map["endDate"]
        self.sectionId <- map["sectionId"]
        self.prdGbnCd <- map["prdGbnCd"]
        self.cateGb <- map["cateGb"]
        self.isNo1Schedule <- map["isNo1Schedule"]
        self.no1ScheduleUrl <- map["no1ScheduleUrl"]
        self.dealType <- map["dealType"]
        self.subContentChild <- map["subContentChild"]
        self.subProductList <- map["subProductList"]
        self.imgBadgeCorner <- map["imgBadgeCorner"]
        self.wiseLog2 <- map["wiseLog2"]
        self.quickShippingYn <- map["quickShippingYn"]
        self.freeDlvYn <- map["freeDlvYn"]
        self.adultCertYn <- map["adultCertYn"]
        self.no1DealYn <- map["no1DealYn"]
        self.infoBadge <- map["infoBadge"]
        self.valueText <- map["valueText"]
        self.valueInfo <- map["valueInfo"]
        self.adDealYn <- map["adDealYn"]
        self.startDtm <- map["startDtm"]
        self.isTvHot <- map["isTvHot"]
        self.isTvHotLogo <- map["isTvHotLogo"]
        self.dealMcVideoUrlAddr <- map["dealMcVideoUrlAddr"]
        self.imageList <- map["imageList"]
        self.videoTime <- map["videoTime"]
        self.productHashTags <- map["productHashTags"]
        self.productHashTagWiseLogs <- map["productHashTagWiseLogs"]
        
        if let value = map.JSON["isWish"] as? Bool {
            self.isWish = value
        } else if let value = map.JSON["isWish"] as? NSNumber {
            self.isWish = value.boolValue
        }
        else {
            self.isWish = nil
        }
        self.isWishEnable   <- map["isWishEnable"]
        self.wishCnt <- map["wishCnt"]
        
        self.brandWishAddUrl <- map["brandWishAddUrl"]
        self.brandWishRemoveUrl <- map["brandWishRemoveUrl"]
        self.imageLayerFlag <- map["imageLayerFlag"]
        self.sbCateGb <- map["sbCateGb"]
        self.sbVideoNum <- map["sbVideoNum"]
        self.directOrdUrl <- map["directOrdUrl"]
        self.snsImageUrl <- map["snsImageUrl"]
        self.randomYn <- map["randomYn"]
        self.rollingDelay <- map["rollingDelay"]
        self.rwImgList <- map["rwImgList"]
        self.basket <- map["basket"]
        self.videoid <- map["videoid"]
        self.vodImg <- map["vodImg"]
        self.exposPrSntncNm <- map["exposPrSntncNm"]
        self.reviewCount <- map["reviewCount"]
        self.pmoTitle   <- map["pmoTitle"]
        self.pmoSubTitle    <- map["pmoSubTitle"]
        self.playUrl    <- map["playUrl"]
        
        self.deal <- map["deal"]
        
        self.useName <- map["useName"]
        
        
        //broad
        self.broadEndDate           <- map["broadEndDate"]
        self.broadStartDate         <- map["broadStartDate"]
        self.liveBanner             <- map["liveBanner"]
        self.liveBenefitLText       <- map["liveBenefitLText"]
        self.liveBenefitRText       <- map["liveBenefitRText"]
        self.livePlayInfo           <- map["livePlayInfo"]
        self.liveTalkInfo           <- map["liveTalkInfo"]
        self.pgmId                  <- map["pgmId"]
        self.pgmLiveYn              <- map["pgmLiveYn"]
        self.product                <- map["product"]
        self.publicBroadYn          <- map["publicBroadYn"]
        self.specialPgmInfo         <- map["specialPgmInfo"]
        self.specialPgmYn           <- map["specialPgmYn"]
        self.startTime              <- map["startTime"]
        
        
    }
}

/// Log 를 위한 Extension 추가
extension Mappable {
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
}
