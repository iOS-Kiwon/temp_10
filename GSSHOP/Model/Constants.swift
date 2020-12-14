//
//  Constants.swift
//  GSSHOP
//
//  Created by Kiwon on 21/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
// Kiwon : 글로벌 상수값 정의 예시
//let TVC_BOTTOM_MARGIN: CGFloat = 9.0
//let BENEFITTAG_HEIGTH: CGFloat = 25.0
//let CELL_CONTENTS_LEFT_MARGIN: CGFloat = 10
//let CELL_CONTENTS_BETWEEN_MARGIN: CGFloat = 7

let PUSH_ANIMATION_LOTTIE_JSON_FILE_NAME = "push_lottie"

enum Const {
    /// Cookie 상수 Enum
    enum Cookie: String {
        case Adalt = "adult"
        case `True` = "true"
        case Temp = "temp"
    }
    
    /// 문자열 상수 Enum
    enum Text: String {
        case Y = "Y"
        case N = "N"
        case timeDeal = "timeDeal"
        case gsShopImage = "GSSHOPImages"
        case http = "http"
        
        case error_server = "서버와의 연결이 원활하지 않습니다.\n잠시 후 다시 시도해주시기 바랍니다."
        case notice = "알림"
        case confirm = "확인"
        case cancel = "취소"
        case close = "닫기"
        case agree = "동의"
        case bcove_error = "동영상을 재생할 수 없습니다."
        
        case image_banner = "이미지 베너 입니다."
        /// Alert 관련
        case error_try_again = "잠시 후 다시 시도해주세요."
        /// 찜 버튼 접근성용
        case zzim_on = "찜하기"
        case zzim_off = "찜하기 취소"
        /// 장바구니 버튼 접근성용
        case basket_add = "장바구니에 담기"
        /// 상담전용 상품
        case advice_only = "상담신청상품"
        
        case GSEXTERNLINKPROTOCOL = "external://"
        
        /// 설정 - 광고성 알림 허용
        case ad_push_agree = "광고성 PUSH(알림) 수신동의가 \n 수신 으로 변경되었습니다. \n GS SHOP"
        case ad_push_disagree = "광고성 PUSH(알림) 수신동의가 \n 미 수신 으로 변경되었습니다. \n 아이폰 이용자의 경우, \n 실제 PUSH 미 수신까지는 \n 1~2일 정도 소요될 수 있습니다. \n GS SHOP"
        /// 설정 - 팝업 메시지
        case login_confirm_logout = "로그아웃 하시겠습니까?"
        case setting_autologin_off = "자동 로그인을 해제하시겠어요?"
        case setting_kakao_off = "카카오 로그인을 해제하시겠어요?"
        case setting_naver_off = "네이버 로그인을 해제하시겠어요?"
        case setting_fingerlogin_off = "지문 로그인을 해제하시겠어요?"
        case setting_facelogin_off = "페이스 로그인을 해제하시겠어요?"
        case setting_apple_off = "Apple ID 로그인을 해제하시겠어요?"
        case setting_autologin_on = "로그인 상태가 항상 유지됩니다."
        case setting_kakao_on = "GS SHOP이 카카오를\n사용하여 로그인합니다."
        case setting_naver_on = "GS SHOP이 네이버를\n사용하여 로그인합니다."
        case setting_apple_on = "GS SHOP이 Apple ID를\n사용하여 로그인합니다."
        case setting_biologin_on = "고객님 휴대폰에 등록된 바이오정보에 접근하여 GS SHOP 아이디와 연결하겠습니다."
        case setting_dont_use_bio = "바이오정보(지문/안면) 등록이 가능한\n휴대폰에서만 사용할 수 있습니다."
        
        var name: String { return self.rawValue }
        var localized: String { return self.rawValue.localized }
    }
    
    /// Image Resource 상수 Enum
    enum Image: String {
        case noimg_25 = "img_noimage_25"
        case noimg_320 = "noimg_320"
        case noimg_280 = "noimg_280"
        case prevent19cellimg = "prevent19cellimg"
        
        /// 상품 no 이미지 - 78 x 78
        case img_noimage_78 = "img_noimage_78"
        /// 상품 no 이미지 - 127 x 127
        case img_noimage_127 = "img_noimage_127"
        /// 상품 no 이미지 - 144 x 144
        case img_noimage_144 = "img_noimage_144"
        /// 상품 no 이미지 - 166 x 166
        case img_noimage_166 = "img_noimage_166"
        /// 상품 no 이미지 - 166 x 315
        case img_noimage_166_315 = "img_noimage_166_315"
        /// 상품 no 이미지 - 375 x 188
        case img_noimage_375_188 = "img_noimage_375_188"
        /// 상품 no 이미지 - 375 x 375
        case img_noimage_375 = "img_noimage_375"
        
        /// 19세 이미지 - 78 x 78
        case img_adult_78 = "img_adult_78"
        /// 19세 이미지 - 127 x 127
        case img_adult_127 = "img_adult_127"
        /// 19세 이미지 - 144 x 144
        case img_adult_144 = "img_adult_144"
        /// 19세 이미지 - 166 x 166
        case img_adult_166 = "img_adult_166"
        /// 19세 이미지  - 375 x 375
        case img_adult_375 = "img_adult_375"
        /// 19세 이미지 - 375 x 188
        case img_adult_375_188 = "img_adult_375_188"
        
        /// 광고 이미지 - light
        case cell_add_light = "cell_add_light"
        
        
        case best_ranking1_5_bg = "best_ranking1-5_bg"
        case best_ranking6_100_bg = "best_ranking6-100_bg"
        
        /// 동영상 재생 버튼
        case btn_play_nor = "btn_play_nor"
        /// 동영상 일시정지 버튼
        case btn_pause_nor = "btn_pause_nor"
        /// 동영상 리플레이 버튼
        case btn_replay_nor = "btn_replay_nor"
        
        /// 동영상 재생 버튼 - 미니플레이어용
        case btn_play_mini_nor = "btn_play_mini_nor"
        /// 동영상 일시정지 버튼 - 미니플레이어용
        case btn_pause_mini_nor = "btn_pause_mini_nor"
        /// 동영상 리플레이 버튼 - 미니플레이어용
        case btn_replay_mini_nor = "btn_replay_mini_nor"
        
        /// 동영상 슬라이더 아이콘 - normal
        case ic_slider_nor = "ic_slider_nor"
        
        /// 단품 방송알림 - 알림 off
        case ic_notification_off = "ic_notification_off"
        /// 단품 방송알림 - 알림 off
        case ic_notification_on = "ic_notification_on"
        
        /// 단품 브렌드 아이콘
        case ic_brand = "ic_brand"
        /// 단품 링크이동 화살표 이미지 20pt
        case ic_arrow_right_20 = "ic_arrow_right_20"
        /// 단품 링크이동 화살표 이미지 24pt
        case ic_arrow_right_24 = "ic_arrow_right_24"
        
        /// 단품 할인율 툴팁 이미지
        case ic_price_info_20 = "ic_price_info_20"
        /// 단품 등급 Gold 이미지
        case ic_grade_gold = "ic_grade_gold"
        /// 단품 등급 Vip 이미지
        case ic_grade_vip = "ic_grade_vip"
        /// 단품 등급 Vvip 이미지
        case ic_grade_vvip = "ic_grade_vvip"
        
        /// 단품 카드할인 아이콘
        case ic_card = "ic_card"
        
        /// 단품 적립금 아이콘
        case ic_save_money = "ic_save_money"
        
        /// 단품 찜취소 이미지
        case ic_zzim_off_64 = "ic_zzim_off_64"
        /// 단품 찜완료 이미지
        case ic_zzim_on_64 = "ic_zzim_on_64"
        
        /// 단품 배송지 아이콘
        case ic_delivery = "ic_delivery"
        /// 단품 배송지 디폴트 아이콘
        case ic_delivery_default = "ic_delivery_default"
        
        /// 단품 무이자 아이콘
        case ic_nointerest = "ic_nointerest"
        
        /// 스켈레톤 - 홈매장 자주 찾는 카테고리 전용
        case ic_skeleton_favo = "ic_skeleton_favo"
        /// 스켈레톤 - 56x56 원형
        case ic_skeleton_circle_56 = "ic_skeleton_circle_56"
        
        /// PRD_PAS_SQ 선호도 하트 0개
        case img_prefer_0 = "img_prefer_0"
        /// PRD_PAS_SQ 선호도 하트 1개
        case img_prefer_1 = "img_prefer_1"
        /// PRD_PAS_SQ 선호도 하트 2개
        case img_prefer_2 = "img_prefer_2"
        /// PRD_PAS_SQ 선호도 하트 3개
        case img_prefer_3 = "img_prefer_3"
        /// PRD_PAS_SQ 선호도 하트 4개
        case img_prefer_4 = "img_prefer_4"
        /// PRD_PAS_SQ 선호도 하트 5개
        case img_prefer_5 = "img_prefer_5"
        
        /// 우측 화살표 (8 x 15)
        case img_arrow_drop_down = "img_arrow_drop_down"
        
        /// 브랜드 개인화매장 No data
        case img_illust_noresult = "img_illust_noresult"
        
        
        var name: String { return self.rawValue }
    }
    
    /// xib name Enum
    enum Xib: String {
        case BenefitTagView = "BenefitTagView"
        var name: String { return self.rawValue }
    }
}

/// View Type을 정의한 상수 Enum
extension Const {
    enum ViewType: String {
        ////////////////////////////////////
        // 매장 UI 개편 뷰타입
        
        /// 일반 캐로셀 정사각 더보기
        case PRD_C_SQ_MORE = "PRD_C_SQ_MORE"
        /// AS-IS 개인화 뷰타입 더보기
        case API_SRL_MORE = "API_SRL_MORE"
        
        /// 상품 2단
        case PRD_2 = "PRD_2"
        /// 프로모션 케로셀 Default형 상품
        case PMO_T1_PREVIEW_D_PRD = "PMO_T1_PREVIEW_D_PRD"
        /// 프로모션 케로셀 Default형 더보기
        case PMO_T1_PREVIEW_D_MORE = "PMO_T1_PREVIEW_D_MORE"
        /// 프로모션 캐로셀 Brand형 상품
        case PMO_T1_PREVIEW_B = "PMO_T1_PREVIEW_B"
        /// 프로모션 캐로셀 Brand형 더보기
        case PMO_T1_PREVIEW_B_MORE = "PMO_T1_PREVIEW_B_MORE"
        /// 프로모션 캐로셀 미리보기형
        case PMO_T2_PREVIEW_MORE = "PMO_T2_PREVIEW_MORE"
        
        /// GS 혜택 롤링배너
        case BAN_TXT_IMG_SLD_GBA = "BAN_TXT_IMG_SLD_GBA"
        /// GS 혜택 롤링배너 - 8.2 네비버전 이후
        case BAN_TXT_IMG_SLD_GBB = "BAN_TXT_IMG_SLD_GBB"
        /// GS 혜택 바로가기 링크
        case BAN_IMG_CX_GBA = "BAN_IMG_CX_GBA"
        /// GS 혜택 틀고정 (엥커)
        case TAB_ANK_GBA = "TAB_ANK_GBA"
        /// GS 혜택 틀고정 하위뷰
        case BAN_IMG_TXT_GBA = "BAN_IMG_TXT_GBA"
        /// 새벽배송 카테고리 (엥커+텝)
        case TAB_SLD_ANK_GBA = "TAB_SLD_ANK_GBA"
        /// 구 버전 카테고리 (텝-새로고침) 더보기
        case TAB_SLD_GBB_MORE_ORIGINAL = "TAB_SLD_GBB_MORE_ORIGINAL"
        /// 새벽배송 카테고리 (엥커+텝) 더보기
        case TAB_SLD_GBB_MORE = "TAB_SLD_GBB_MORE"
        /// 새벽배송 카테고리 더보기 (네비 8.2 이하버전) - 하단 여백없음
        case TAB_SLD_GBB_MORE_NOSPACE = "TAB_SLD_GBB_MORE_NOSPACE"
        
        /// 내일도착 카테고리 (엥커+텝)
        case TAB_SLD_ANK_GBB = "TAB_SLD_ANK_GBB"
        
        /// 시그니처 매장 동영상+상품
        case GR_BRD_GBA = "GR_BRD_GBA"
        /// 시그니처 매장 배너 슬라이딩
        case BAN_SLD_GBG = "BAN_SLD_GBG"
        
        
        ////////////////////////////////////
        // 구매장 뷰타입
        case
        
        /// GS Choice(내일도착) 카테고리 (탭고정)
        TAB_SLD_GBA = "TAB_SLD_GBA",
        
        /// 새벽배송 카테고리 (탭고정)
        TAB_SLD_GBB = "TAB_SLD_GBB",

        /// GS Choice(내일도착) 가로 롤링형
        BAN_SLD_GBE = "BAN_SLD_GBE",
        
        /// GS Choice(내일도착) 가로 스크롤형 (탭고정)
        BAN_SLD_GBF = "BAN_SLD_GBF",
        
        /// 공통 이미지 배너 - 높이 가변형
        BAN_IMG_H000_GBC = "BAN_IMG_H000_GBC",
        
        /// GS Choice(내일도착) 동적이미지 배너
        BAN_IMG_H000_GBD = "BAN_IMG_H000_GBD",
        
        /// GS Choice(내일도착) 카테고리 하위 Cell
        BAN_MUT_GBA = "BAN_MUT_GBA",
        
        /// GS Choice(새벽배송) 카테고리 하위 cell
        MAP_CX_GBC = "MAP_CX_GBC",
        
        // 높이고정 이미지 좌측 정렬 cell
        BAN_IMG_F80_L_GBA = "BAN_IMG_F80_L_GBA",
        // 높이고정 이미지 가운데 정렬 cell
        BAN_IMG_F80_C_GBA = "BAN_IMG_F80_C_GBA",
        // 높이고정 이미지 우측 정렬 cell
        BAN_IMG_F80_R_GBA = "BAN_IMG_F80_R_GBA",
        
        /// GS Choice(새벽배송) 공통 타이틀
        BAN_TXT_IMG_LNK_GBA = "BAN_TXT_IMG_LNK_GBA",
        
        /// GS Choice(새벽배송) 공통 타이틀
        BAN_TXT_IMG_LNK_GBB = "BAN_TXT_IMG_LNK_GBB",
        
        /// 데이터가 없음(?)
        NO_DATA = "NO_DATA"
        
        var name: String { return self.rawValue }
    }
}


// MARK:- Font
extension Const {
    enum Font: String { case
        AppleSDGothicNeoBold = "AppleSDGothicNeo-Bold",
        AppleSDGothicNeoLight = "AppleSDGothicNeo-Light",
        AppleSDGothicNeoMedium = "AppleSDGothicNeo-Medium",
        AppleSDGothicNeoRegular = "AppleSDGothicNeo-Regular",
        AppleSDGothicNeoSemiBold = "AppleSDGothicNeo-SemiBold",
        AppleSDGothicNeoThin = "AppleSDGothicNeo-Thin",
        AppleSDGothicNeoUltraLight = "AppleSDGothicNeo-UltraLight"
        var name: String { return self.rawValue }
    }
}

//MARK:- StoryBoard
extension Const {
    enum StoryBoard: String {
        case Home = "Home"
        
        /// 임시 스토리보드 : 나중에 삭제해야함.
        case Temp = "Dev"
        
        var name: String { return self.rawValue }
    }
}



