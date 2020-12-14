//
//  BenefitLabel.swift
//  GSSHOP
//
//  Created by Kiwon on 28/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class BenefitLabel: UILabel {
    // 우선순위
    // 적립금, 릴레이캐시백, 3회사은품, 1+1상품, 행사상품, 전단상품, 배송료(유료/무료), 무이자적립금, 릴레이캐시백, 3회사은품, 1+1상품, 행사상품, 전단상품, 배송료(유료/무료), 무이자
    // TV상품 | 3%적립 ・ 3회사은품 ・ 무료배송 ・ 무이자 ・ 행사상품 ・ 전단상품 ・ 1+1상품
    
    private let TV_PROMOTION_COLOR = UIColor.getColor("111111", alpha: 0.5)
    private let PROMOTION_COLOR = UIColor.getColor("111111", alpha: 0.4)
    
    private let PROMOTION_SEPARATOR_TEXT = " ・ "
    private let PROMOTION_SEPARATOR_COLOR = UIColor.getColor("111111", alpha: 0.3)
    
    private let TV_SEPARATOR_TEXT = " | "
    private let TV_SEPARATOR_COLOR = UIColor.getColor("111111", alpha: 0.2)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.text = ""
        self.attributedText = .init(string: "")
    }
    
    /// 혜택 라벨에 TEXT 데이터 설정
    /// - parameter tvPromotion:    TV상품 TEXT (InfoBadge 객체)
    /// - parameter prdPromotion:   혜택 TEXT (ImgBadgeCornerB 객체)
    //func setInitUI(infoBadge: InfoBadge?, imgBadgeCorner: ImgBadgeCorner) {
    func setInitUI(source: ImageInfo?, benefitInfo: [ImageInfo]) {
        
        let attributedString = NSMutableAttributedString.init(string: "")
        
        // 값이 있는 경우,
        //if let infoBadgeTF = infoBadge?.TF, let tf = infoBadgeTF.first  {
        if let info = source {
            // 프로모션 추가
            let tvAttributedStr = NSMutableAttributedString(
                string: info.text,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13.0),
                    .foregroundColor: UIColor.getColor(info.type, defaultColor: TV_PROMOTION_COLOR)
                ])
            
            attributedString.append(tvAttributedStr)
        }
        
        // 뒤에 혜택이 있으면 구분자 추가
        if attributedString.length > 0 && benefitInfo.count > 0 {
            let tvSepaAttributedStr = NSMutableAttributedString(
                string: TV_SEPARATOR_TEXT,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13.0),
                    .foregroundColor: TV_SEPARATOR_COLOR
                ])
            attributedString.append(tvSepaAttributedStr)
        }
        
        // 상품 프로모션 TEXT 설정
        for promotion in benefitInfo {
            // 상품 프로모션 추가
            let prdAttributedStr = NSMutableAttributedString(
                string: promotion.text,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13.0),
                    .foregroundColor: UIColor.getColor(promotion.text, defaultColor: PROMOTION_COLOR)
                ])
            
            attributedString.append(prdAttributedStr)
            
            // 마지막일땐 구분자를 붙히지 않는다.
            if let lastPromo = benefitInfo.last,
                promotion.text == lastPromo.text {
                break
            }
            
            // 프로모션 구분자 추가
            let promoSepaAttributedStr = NSMutableAttributedString(
                string: PROMOTION_SEPARATOR_TEXT,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13.0),
                    .foregroundColor: PROMOTION_SEPARATOR_COLOR
                ])
            attributedString.append(promoSepaAttributedStr)
        }
        
        self.attributedText = attributedString
    }
    
    /// AttributedText Line Spaceing 설정함수
    func setLineSpacing(value: CGFloat = 1.0) {
        if let labelAttrText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: labelAttrText)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = value
            
            attributedString.addAttribute(.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSMakeRange(0, attributedString.length))
            self.attributedText = attributedString
        }
    }
}
