//
//  Types.swift
//  GSSHOP
//
//  Created by Kiwon on 16/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation

@objc enum PathType: Int {
    case library
    case document
    case resource
    case bundle
    case temp
    case cache
}

enum WebTemplateType: String {
    case mediaInfo = "mediaInfo"
    case broadInfo = "broadInfo"
    case prdNmInfo = "prdNmInfo"
    case saleInfo = "saleInfo"
    case promotionInfo = "promotionInfo"
    case cardPmoInfo = "cardPmoInfo"
    case cardPmoInfo2 = "cardPmoInfo2"
    case personalCouponPmoInfo = "personalCouponPmoInfo"
    case noInterestInfo = "noInterestInfo"
    case deliveryInfo = "deliveryInfo"
    case savedMoneyInfo = "savedMoneyInfo"
    case addPromotionInfo = "addPromotionInfo"
    
    var name: String { return self.rawValue }
}

// 설정 - SNS Account Type
enum SnsAccountType: String {
    case apple = "AP"
    case naver = "NA"
    case kakao = "KA"
    var name: String { return self.rawValue }
}

/*  Kiwon : 아직 사용하지 않는 enum type : MOCHA 작업시 사용예정
enum TagImageType: String {
    case freeDlv = "freeDlv"
    case todayClose = "todayClose"
    case freeInstall = "freeInstall"
    case reserves = "Reserves"
    case interestFree = "interestFree"
    case quickDlv = "quickDlv"
    case worldDlv = "worldDlv"
    
    var name: String  {
        switch self {
        case .freeDlv:
            return Const.Image.dc_badge_free.rawValue
        case .todayClose:
            return Const.Image.dc_badge_end.rawValue
        case .freeInstall:
            return Const.Image.dc_badge_finstall.rawValue
        case .reserves:
            return Const.Image.dc_badge_reward.rawValue
        case .interestFree:
            return Const.Image.dc_badge_nogain.rawValue
        case .quickDlv:
            return Const.Image.dc_stag_delivery.rawValue
        case .worldDlv:
            return Const.Image.dc_btag_ocdelivery.rawValue
        }
    }
}
 */
