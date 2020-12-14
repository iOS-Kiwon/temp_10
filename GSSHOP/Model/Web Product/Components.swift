//
//  Components.swift
//  GSSHOP
//
//  Created by Home on 05/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import Foundation
import ObjectMapper

class Components: NSObject, Mappable {
    
    /// 템플릿 타입
    var templateType: String = ""
    
    //=========================================
    // mediaInfo 타입에서 아용하는 객체
    /// 이미지 정보
    var imgUrlList = [String]()
    /// 영상 정보
    var videoInfoList = [VideoInfo]()
    /// 혜택 이미지 정보
    var benefits = [String]()
    
    //=========================================
    // broadInfo 타입에서 아용하는 객체
    var broadChannelImgUrl: String = ""
    /// 방송 Text 정보
    var broadText = [PrdTextInfo]()
    /// 알림신청 여부 - Y:알림신청함 N:알림신청안함
    var applyBroadAlamYN: String = ""
    /// 방송알림 실행 URL String
    var runUrl: String = ""
    /// 방송알림 여부 Y / N
    var tvAlarmBtnFlg: String = ""
    
    //=========================================
    // prdNmInfo 타입에서 아용하는 객체
    /// 상품 브랜드 Text정보
    var brandInfo: BrandInfo?
    /// 프로모션 Text정보
    var promotionText = [PrdTextInfo]()
    /// 상품 Text정보
    var expoName = [PrdTextInfo]()
    /// 원산지 Text정보
    var subInfoText = [PrdTextInfo]()
    /// 상품평 Text정보
    var reviewInfo : ReviewInfo?
    
    //=========================================
    // saleInfo 타입에서 아용하는 객체
    /// 미리계산버튼링크 URL String
    var preCalcurateUrl: String = ""
    /// 공유하기 URL String - toapp:// 처리 url
    var shareRunUrl: String = ""
    /// 찜 여부 - Y: 찜을 했음 /N: 찜은 안함 /X: 찜 버튼 노출X
    var favoriteYN: String = ""
    /// 찜 요청 api URL String
    var favoriteRunUrl: String = ""
    /// 가격 Text정보
    var priceInfo = [PrdTextInfo]()
    /// 할인가격 정보 객체
    var discountInfo = DiscountInfo()
    /// 추가 정보 Text정보 - 유류할증료, 여행사 등등
    var additionalList = [[PrdTextInfo]]()
    
    //=========================================
    // promotionInfo 타입에서 아용하는 객체
    /// 등급에 따른 가격정보
    var gradePmoInfo = [GradePmoInfo]()
    
    //=========================================
    // cardPmoInfo 타입에서 이용하는 객체
    /// 추가상세정보 URL String
    var addInfoUrl: String = ""
    /// 카드 이미지 URL String
    var cardImgUrl: String = ""
    /// 카드 정보
    var cardList = [CardInfo]()
    
    //=========================================
    // addPromotionInfo 타입 매핑
    /// 공통타입 리스트 정보
    var itemList = [CommonInfo]()
    
    //=========================================
    // personalCouponPmoInfo 타입에서 이용하는 객체
    /// 쿠폰 Text정보 - "고객님께만 ##원"
    var pmoText = [PrdTextInfo]()
    /// 쿠폰 가격 Text정보 - "##원"
    var pmoPrc = [PrdTextInfo]()
    /// 쿠폰 다운로드 URL String
    var pmoUrl: String = ""
    
    //=========================================
    // noInterestInfo 타입에서 이용하는 객체
    /// 무이자 아이콘 Url String
    var iConImgUrl: String = ""
    /// 무이자 Text정보
    var interestTxt = [PrdTextInfo]()
    
    //=========================================
    // deliveryInfo 타입에서 이용하는 객체
    /// 배송관련 Text 정보 - index 1개에 1줄
    var deliveryList = [DeliveryInfo]()
    
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
        /// 템플릿 타입 매핑
        self.templateType            <- map["templateType"]
        
        //=========================================
        // imgNvideoInfo 타입 매핑
        self.imgUrlList             <- map["imgUrlList"]
        self.videoInfoList          <- map["videoList"]
        self.benefits               <- map["benefits"]
        
        //=========================================
        // broadInfo 타입 매핑
        self.broadChannelImgUrl         <- map["broadChannelImgUrl"]
        self.broadText                  <- map["broadText"]
        self.applyBroadAlamYN           <- map["applyBroadAlamYN"]
        self.runUrl                     <- map["runUrl"]
        self.tvAlarmBtnFlg              <- map["tvAlarmBtnFlg"]
        
        //=========================================
        // prdNmInfo 타입 매핑
        self.brandInfo                  <- map["brandInfo"]
        self.promotionText              <- map["promotionText"]
        self.expoName                   <- map["expoName"]
        self.subInfoText                <- map["subInfoText"]
        self.reviewInfo                 <- map["reviewInfo"]
        
        //=========================================
        // saleInfo 타입 매핑
        self.preCalcurateUrl                <- map["preCalcurateUrl"]
        self.shareRunUrl                    <- map["shareRunUrl"]
        self.favoriteYN                     <- map["favoriteYN"]
        self.favoriteRunUrl                 <- map["favoriteRunUrl"]
        self.priceInfo                      <- map["priceInfo"]
        self.discountInfo                   <- map["discountInfo"]
        self.additionalList                 <- map["additionalList"]
        
        //=========================================
        // promotionInfo 타입 매핑
        self.gradePmoInfo                   <- map["gradePmoInfo"]
        
        //=========================================
        // cardPmoInfo 타입 매핑
        self.addInfoUrl                     <- map["addInfoUrl"]
        self.cardImgUrl                     <- map["cardImgUrl"]
        self.cardList                       <- map["cardList"]
        
        //=========================================
        // addPromotionInfo 타입 매핑
        self.itemList                       <- map["itemList"]
        
        //=========================================
        // personalCouponPmoInfo 타입 매핑
        self.pmoText                         <- map["pmoText"]
        self.pmoPrc                         <- map["pmoPrc"]
        self.pmoUrl                         <- map["pmoUrl"]
        
        //=========================================
        // noInterestInfo 타입 매핑
        self.iConImgUrl                     <- map["iConImgUrl"]
        self.interestTxt                    <- map["interestTxt"]
        
        //=========================================
        // deliveryInfo 타입 매핑
        self.deliveryList                   <- map["deliveryList"]
        
        
    }
}

/// 단품 비디오 정보 클래스
class VideoInfo: NSObject, Mappable {
    
    /// 생방송 여부
    var liveYN: String = ""
    /// 영상 미리보기 이미지 URL string
    var videoPreImgUrl: String = ""
    /// 영상 URL String
    var videoUrl: String = ""
    /// 영상(브라이트코드) Id
    var videoId: String = ""
    /// 영상 시작시간 - 20200229100000
    var startTime: String = ""
    /// 영상 끝시간 - 20200229100000
    var endTime: String = ""
    /// 비디오가 가로/세로/정사각 모드 구분값 - L,P,S -> 각 가로 세로 정사각 영상을 의미
    var videoMode: String = ""
    
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
        self.liveYN                 <- map["liveYN"]
        self.videoPreImgUrl         <- map["videoPreImgUrl"]
        self.videoUrl               <- map["videoUrl"]
        self.videoId                <- map["videoId"]
        self.startTime              <- map["startTime"]
        self.endTime                <- map["endTime"]
        self.videoMode              <- map["videoMode"]
    }
}

/// 단품 브랜드 정보 클래스
class BrandInfo: NSObject, Mappable {
    
    /// 브랜드 링크 URL...???
    var brandLogoUrl: String = ""
    /// 브랜드 타이틀 정보
    var brandTitle = [PrdTextInfo]()
    /// 브랜드 링크 URL String
    var brandLinkUrl: String = ""
    
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
        self.brandLogoUrl               <- map["brandLogoUrl"]
        self.brandTitle                 <- map["brandTitle"]
        self.brandLinkUrl               <- map["brandLinkUrl"]
    }
}

/// 단품에서 사용하는 Text 구조의 클래스
class PrdTextInfo: NSObject, Mappable {
    /// 타이틀 문구 (상품명, 프로모션명, 원산지 등)
    var textValue: String = ""
    /// 문구 색상
    var textColor: String = ""
    /// 볼트 여부 - Y / N
    var boldYN: String = ""
    /// 문구 폰트 사이즈
    var fontSize: String = ""
    /// 링크 URL String
    var linkUrl: String = "''"
    
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
        self.textValue          <- map["textValue"]
        self.textColor          <- map["textColor"]
        self.boldYN             <- map["boldYN"]
        self.fontSize           <- map["size"]
        self.linkUrl            <- map["linkUrl"]
    }
}

// 단품 상품평 정보 클래스
class ReviewInfo: NSObject, Mappable {
    /// 상품 평점 - 4.5
    var reviewPoint: String = ""
    /// 상품평 개수 문자열 - (99,999+)
    var reviewText = [PrdTextInfo]()
    /// 이동 링크
    var linkUrl: String = ""
    
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
        self.reviewPoint            <- map["reviewPoint"]
        self.reviewText             <- map["reviewText"]
        self.linkUrl                <- map["linkUrl"]
    }
}
/// 할인 정보 클래스
class DiscountInfo: NSObject, Mappable {
    
    /// 할인율
    var discountText = [PrdTextInfo]()
    /// 기본가격
    var originPrc = [PrdTextInfo]()
    /// 툴팁 링크 URL String
    var discountAddInfoUrl: String = ""
    
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
        self.discountText                   <- map["discountText"]
        self.originPrc                      <- map["originPrc"]
        self.discountAddInfoUrl             <- map["discountAddInfoUrl"]
    }
}

/// 등급 정보 클래스
class GradePmoInfo: NSObject, Mappable {
    /// 등급 이미지 URL String
    var gradeImgUrl: String = ""
    /// 등급명 정보
    var gradeTextInfo = [PrdTextInfo]()

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
        self.gradeImgUrl                <- map["gradeImgUrl"]
        self.gradeTextInfo              <- map["gradeText"]
    }
}

/// 카드정보 클래스
class CardInfo: NSObject, Mappable {
    
    /// 카드 할인정보 템플릿 타입 - personalCardPmoInfo / commonCardPmoInfo / commonCardPmoInfo / savedMoneyInfo
    var templateType: String = ""
    /// 카드 할인 정보
    var pmoText = [PrdTextInfo]()
    /// 카드 할인가격 정보
    var pmoPrc = [PrdTextInfo]()
    
    
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
        self.templateType                <- map["templateType"]
        self.pmoText                     <- map["pmoText"]
        self.pmoPrc                     <- map["pmoPrc"]
    }
}

/// 공통템플릿 정보 클래스
class CommonInfo: NSObject, Mappable {
    
    /// 템플릿 타입
    var templateType: String = ""
    /// 아이콘 Url
    var iConUrl: String = ""
    /// 링크 Url
    var linkUrl: String = ""
    /// 정보
    var pmoText = [PrdTextInfo]()
    
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
        self.templateType                <- map["templateType"]
        self.iConUrl                     <- map["iConUrl"]
        self.linkUrl                     <- map["linkUrl"]
        self.pmoText                     <- map["pmoText"]
    }
}

/// 배송정보 클래스
class DeliveryInfo: NSObject, Mappable {
    
    /// 배송정보 Info
    var deliveryInfoList = [DeliveryInfo]()
    /// 툴팁 노출여부 - Y/N
    var addressTooltip: String = ""
    /// 상세링크 URL String
    var addInfoUrl: String = ""
    /// 배송정보 아이콘 URL String - 택배배송 / 새벽배송
    var mainImgUrl: String = ""
    /// 배송지 선택/변경 Text wjdqh - 비로그인시 : 배송지선택/ 로그인시 : 배송지변경
    var changeAddress = [PrdTextInfo]()
    /// 배송 이미지 URL String - 주로 초이스 이미지일듯?
    var preImgUrl: String = ""
    /// 배송 Text 정보
    var textList = [PrdTextInfo]()

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
        self.preImgUrl              <- map["preImgUrl"]
        self.textList               <- map["textList"]
        
        self.deliveryInfoList               <- map["deliveryInfoList"]
        self.mainImgUrl                     <- map["mainImgUrl"]
        self.addInfoUrl                  <- map["addInfoUrl"]
        self.addressTooltip                 <- map["addressTooltip"]
        self.changeAddress                  <- map["changeAddress"]
    }
}


