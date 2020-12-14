//
//  SectionBAN_IMG_C2_GBBtypeSubView.swift
//  GSSHOP
//
//  Created by Kiwon on 29/07/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_IMG_C2_GBBtypeSubView: UIView {


    private let MIN_DISCOUNT_RATE_VALUE = 1                     // 할인율 표시 기준 : 1% 미만은 BasePrice만 노출
    
    @IBOutlet weak var baseView: UIView!                        // Cell의 BaseView
    @IBOutlet weak var L_productImageView: UIImageView!         // 상품 이미지
    //    @IBOutlet weak var L_promotionName: UILabel!                // 프로모션명
    @IBOutlet weak var L_productName:UILabel!                   // 상품명
    @IBOutlet weak var L_salePrice: UILabel!                    // 판매가
    @IBOutlet weak var L_exposePriceText: UILabel!              // 판매가 원/원~
    @IBOutlet weak var L_basePrice: UILabel!                    // 기본가
    @IBOutlet weak var L_basePrice_exposePriceText: UILabel!    // 기본가 원/원~
    @IBOutlet weak var L_basePriceCancelLine: UIView!           // 기본가 취소선
    @IBOutlet weak var L_promotionName: UILabel!                // 프로모션
    @IBOutlet weak var L_promotionNameHeight: NSLayoutConstraint! // 프로모션 높이
    @IBOutlet weak var L_promotionNameTop: NSLayoutConstraint!  // 프로모션 상단 Margin Constraint
    @IBOutlet weak var L_promotionNameBot: NSLayoutConstraint!  // 프로모션 상단 Margin Constraint
    @IBOutlet weak var L_LT: UIImageView!                       // 상품 이미지 좌상단 카운트 벳지 배경
    @IBOutlet weak var L_LTvalue: UILabel!                      // 상품 이미지 좌상단 카운트
    @IBOutlet weak var L_LT2: UIImageView!                      // 상품 이미지 좌상단 벳지
    @IBOutlet weak var L_TF: UILabel!                           // 타이틀 앞 텍스트 베너
    @IBOutlet weak var L_valuetext: UILabel!                    // 금액 정보 텍스트
    @IBOutlet weak var L_tvTimeLbl: UILabel!                    // 방송 시간 텍스트
    @IBOutlet weak var L_tvTimeView: UIView!                    // 방송 시간 View
    @IBOutlet weak var L_tvTimeViewHeight: NSLayoutConstraint!  // 방송 시간 View 높이
    @IBOutlet weak var L_air_onHeight: NSLayoutConstraint!      // 방송중 구매가능 레이어 높이
    @IBOutlet weak var L_air_on: UIView!                        // 방송중 구매가능 레이어
    @IBOutlet weak var L_link: UIButton!                        // View 전체를 덮는 투명 버튼
    @IBOutlet weak var L_discountValue: UILabel!                // 할인율의 숫자
    @IBOutlet weak var L_discountValueText: UILabel!            // 할인율의 퍼센트
    @IBOutlet weak var L_valuetextLeading: NSLayoutConstraint!  //
    @IBOutlet weak var L_basePriceLeading: NSLayoutConstraint!  //
    @IBOutlet weak var L_horizontal_line: UIView!               // 세로 라인
    @IBOutlet weak var L_under_line: UIView!                    // 하단 라인
    @IBOutlet weak var L_benefitStackView: UIStackView!         // 혜택 관련 StackView : 무료배송,무이자 등
    @IBOutlet weak var L_benefitView: UIView!                   // 혜택 관련 View : 릴캐, 5% 등
    @IBOutlet weak var L_saleQuantityLbl: UILabel!              // saleQuantity 관련 라벨
    
    private var L_imageURL: String = ""                         // 상품이지미 경로
    private var L_infoDic: Module?                           // 좌측 상품 정보 구조체
    
    @objc var isLastLine: Bool = false
    @objc var aTarget: SectionTBViewController?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initUI() {
        self.backgroundColor = .white
        self.L_basePriceCancelLine.isHidden = true
        self.L_basePrice.isHidden = true
        self.L_basePrice_exposePriceText.isHidden = true
        self.L_exposePriceText.isHidden = true
        self.L_LT.isHidden = true
        self.L_LTvalue.isHidden = true
        self.L_productName.isHidden = true
        self.L_promotionName.isHidden = true
        self.L_salePrice.isHidden = true
        self.L_TF.isHidden = true
        self.L_valuetext.isHidden = true
        self.L_valuetext.text = ""
        self.L_salePrice.text = ""
        self.L_promotionName.text = ""
        self.L_productName.text = ""
        self.L_LTvalue.text = ""
        self.L_exposePriceText.text = ""
        self.L_basePrice_exposePriceText.text = ""
        self.L_basePrice.text = ""
        self.L_productImageView.image = nil;
        self.L_LT.image = nil;
        self.L_LT2.isHidden = true
        self.L_air_on.isHidden = true
        self.L_tvTimeView.isHidden = true
        self.L_promotionNameTop.constant = 0.0
        self.L_promotionNameBot.constant = 0.0
        self.L_air_onHeight.constant = 0.0
        self.L_tvTimeViewHeight.constant = 0.0
        self.L_promotionNameHeight.constant = 0.0
        self.L_tvTimeLbl.text  = ""
        self.L_link.accessibilityLabel = ""
        self.L_discountValue.text = ""
        self.L_discountValueText.text = ""
        self.L_saleQuantityLbl.text = ""
        for view in self.L_benefitStackView.subviews {
            view.removeFromSuperview()
        }
        self.backgroundColor = .white
    }
    
    // 상풍 정보 렌더링
    @objc func setCellInfoNDrawData(product: Module) {
        if self.isLastLine {
            self.L_under_line.backgroundColor = .clear
        }else{
            self.L_under_line.backgroundColor = .getColor("EEEEEE")
        }
        self.L_infoDic = product
        updateLeftUI(product: product)
    }
    
    private func updateLeftUI(product: Module) {
        
        //////////// 상품 이미지 시작 //////////
        //19금 제한?
        if product.adultCertYn == "Y" && Common_Util.isthisAdultCerted() == false {
            self.L_productImageView.image = UIImage(named: Const.Image.prevent19cellimg.name)
        } else {
            self.L_imageURL = product.imageUrl
            if !self.L_imageURL.isEmpty {
                ImageDownManager.blockImageDownWithURL(self.L_imageURL as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                    if error == nil, self.L_imageURL == strInputURL, let image = fetchedImage {
                        DispatchQueue.main.async {
                            if isInCache.boolValue {
                                self.L_productImageView.image = image
                            } else {
                                self.L_productImageView.alpha = 0
                                self.L_productImageView.image = image
                                
                                UIView.animate(withDuration: 0.2,
                                               delay: 0.0,
                                               options: .curveEaseInOut,
                                               animations: {
                                                self.L_productImageView.alpha = 1
                                }, completion: nil)
                            }
                        }// DispatchQueue
                    }
                }// ImageDownManager
            }
        }
        //////////// 상품 이미지 종료 //////////
        
        ///////// 딜 벳지 노출 시작 /////////
        if product.dealProductType == "Deal" {
            self.L_LT2.isHidden = false
        } else {
            self.L_LT2.isHidden = true
        }
        ///////// 딜 벳지 노출 종료 /////////
        
        
        /////////// LT 벳지 카운트 정보 출력 시작 /////////
        if product.imgBadgeCorner.LT.count > 0, let badgeLT = product.imgBadgeCorner.LT.first {
            // 좌상단 벳지가 있으면 랭킹 표기 안함.
            if self.L_LT2.isHidden {
                if !badgeLT.text.isEmpty {
                    //T 이면 top5 라서 붉은 색 벳지
                    if badgeLT.type == "T" {
                        self.L_LT.image = UIImage(named: Const.Image.best_ranking1_5_bg.name)
                        self.L_LTvalue.textColor = UIColor.getColor("FFFFFF")
                    } else {
                        self.L_LT.image = UIImage(named: Const.Image.best_ranking6_100_bg.name)
                        self.L_LTvalue.textColor = UIColor.getColor("ee2162")
                    }
                    
                    self.L_LT.isHidden = false
                    self.L_LTvalue.isHidden = false
                    self.L_LTvalue.text = badgeLT.text
                    self.L_LT2.isHidden = true
                } else {
                    self.L_LT.isHidden = true
                    self.L_LTvalue.isHidden = true
                }
            }
        } else {
            // 뱃지 없음.
            self.L_LT.isHidden = true
            self.L_LTvalue.isHidden = true
        }
        /////////// LT 벳지 카운트 정보 출력 종료 /////////
        
        
        ////////// 상품명 노출 시작 (feat. TF)/////////
        if let badgeTF = product.infoBadge.TF?.first {
            self.L_TF.isHidden = false
            self.L_TF.text = badgeTF.text
            self.L_TF.textColor = UIColor.getColor(badgeTF.type)
        } else {
            self.L_TF.isHidden = true
            self.L_TF.text = ""
        }
        
        // 상품명 앞에 TF값이 있으면 넣어준다. 공간 확보용
        if self.L_TF.isHidden {
            self.L_productName.text = product.productName
        } else {
            self.L_productName.text = String(format: "%@ %@", self.L_TF.text ?? "", product.productName)
        }
        
        if let text = self.L_productName.text, !text.isEmpty  {
            self.L_productName.text = String(format: "%@\n", text) //줄바꿈?
            self.L_productName.isHidden = false
        } else {
            self.L_productName.isHidden = true
        }
        ////////// 상품명 노출 종료 //////////
        
        
        ///////// 프로모션 노출 시작 /////////
        self.L_promotionName.text = product.promotionName
        if let text = self.L_promotionName.text, !text.isEmpty {
            self.L_promotionName.isHidden = false
            self.L_promotionName.text = String(format: "(%@)", text)
            self.L_promotionNameHeight.constant = 14.0
            self.L_promotionNameTop.constant = -1.0
            self.L_promotionNameBot.constant = -1.0  // 기존 2값에서 변경함.
        }else {
            self.L_promotionName.isHidden = true
            self.L_promotionName.text = ""
            self.L_promotionNameHeight.constant = 0.0
            self.L_promotionNameTop.constant = 0.0
            self.L_promotionNameBot.constant = 0.0
        }
        ///////// 프로모션 노출 종료 /////////
        
        
        //////// 판매금액 노출 시작 ////////
        // 판매 가격 : 콤마 제거
        let salePriceStrNocomma = product.salePrice.replacingOccurrences(of: ",", with: "")
        if product.salePrice.isEmpty {
            self.L_salePrice.isHidden = true
            self.L_exposePriceText.isHidden = true
        } else {
            // 숫자인지 판단
            if salePriceStrNocomma.isThisValidWithZeroStr() {
                self.L_salePrice.text = product.salePrice
                self.L_exposePriceText.text = product.exposePriceText
                self.L_salePrice.isHidden = false
                self.L_exposePriceText.isHidden = false
            } else {
                // 숫자 아님
                self.L_salePrice.isHidden = true
                self.L_exposePriceText.isHidden = false
            }
        }
        //////// 판매금액 노출 종료 ////////
        
        
        //////// 원래금액 노출 시작 ////////
        
        self.L_basePrice.text = ""
        self.L_basePrice_exposePriceText.text = ""
        self.L_basePrice.isHidden = true
        self.L_basePrice_exposePriceText.isHidden = true
        self.L_basePriceCancelLine.isHidden = true
        
        self.L_discountValue.text = ""
        self.L_discountValueText.text = ""
        self.L_valuetextLeading.constant = 0.0
        self.L_basePriceLeading.constant = 0.0
        
        // 판매 가격 : 콤마 제거
        let basePriceStrNocomma = product.basePrice.replacingOccurrences(of: ",", with: "")
        if basePriceStrNocomma.isInt, let basePriceIntValue = Int(basePriceStrNocomma),
            salePriceStrNocomma.isInt, let salePriceIntValue = Int(salePriceStrNocomma){
            
            // BasePrice > Sale Price
            if basePriceIntValue > salePriceIntValue,
                product.discountRate > MIN_DISCOUNT_RATE_VALUE {
                
                self.L_basePrice.text = product.basePrice
                self.L_basePrice_exposePriceText.text = product.exposePriceText
                
                self.L_basePrice.isHidden = false
                self.L_basePrice_exposePriceText.isHidden = false
                self.L_basePriceCancelLine.isHidden = false
                
                self.L_discountValue.text = String(product.discountRate)
                self.L_discountValueText.text = "%"
                self.L_valuetextLeading.constant = 5.0
                self.L_basePriceLeading.constant = 5.0
            }// BasePrice > Sale Price && MIN_DISCOUNT_RATE_VALUE if
        }
        //////// 원래금액 노출 종료 ////////
        
        
        //////// valueInfo 노출 시작 ///////
        //valueInfo
        if product.valueText.isEmpty {
            self.L_valuetext.text = ""
            self.L_valuetext.isHidden = true
        } else {
            self.L_valuetext.isHidden = false
            self.L_valuetext.text = product.valueText
        }
        
        //////// 방송중구매 레이어 노출 시작 //////// 20160720 추가
        if !product.imageLayerFlag.isEmpty, product.imageLayerFlag == "AIR_BUY" {
            self.L_air_on.isHidden = false
            self.L_air_onHeight.constant = 28.0
        } else {
            self.L_air_on.isHidden = true
            self.L_air_onHeight.constant = 0.0
        }
        //////// 방송중구매 레이어 노출 종료 ////////
        
        
        ///////// 방송시간 노출 시작 //////////
        if !product.etcText1.isEmpty {
            self.L_tvTimeLbl.text  = product.etcText1
            self.L_tvTimeView.isHidden = false
            self.L_tvTimeViewHeight.constant = 28.0
        } else {
            self.L_tvTimeLbl.text  = ""
            self.L_tvTimeView.isHidden = true
            self.L_tvTimeViewHeight.constant = 0.0
        }
        ///////// 방송시간 노출 종료 //////////
        
        
        
        //////// 혜택 화면 시작 //////// 19.08.01 kiwon 추가
        // 1순위 : 5%적립 > 릴캐 > 사은품
        // 2순위 : 무료배송 > 무료설치 > 무이자 > 적립금
        self.L_benefitView.isHidden = true
        self.L_benefitStackView.isHidden = true
        if product.rwImgList.count > 0 {
            // 1순위 적용
            if let benefitView = Bundle.main.loadNibNamed(Const.Xib.BenefitTagView.name, owner: self, options: nil)?.first as? BenefitTagView {
                benefitView.setBenefitTag(product.toJSON())
                // X: -10 이유: BenefitView에 Default로 왼쪽여백 10.
                benefitView.frame = CGRect(x: -10, y: 0, width: self.L_benefitView.frame.width, height: self.L_benefitView.frame.height)
                self.L_benefitView.addSubview(benefitView)
                self.L_benefitView.isHidden = false
            }
        } else if product.imgBadgeCorner.RB.count > 0 {
            // 2순위 적용
            Common_NFXC.makeBenefitStack(product.imgBadgeCorner.RB, self.L_benefitStackView)
            self.L_benefitStackView.isHidden = false
        } else {
            // 아무것도 없는 경우
        }
        
        //////// 혜택 화면 종료 ////////
        

        //////// xx명 구매중 or 상품평 화면 시작 //////// 19.08.01 kiwon 추가
        if !product.saleQuantity.isEmpty {
            // product.saleQuantity 값이 숫자값인지, 0보다 큰 수 인지 판단.
            
            // 1. 혹시 있을지 모를 콤마제거
            let saleQuantityStr = product.saleQuantity.replacingOccurrences(of: ",", with: "")
            
            // 2. 숫자이면서 0보다 큰 값인지 판단.
            if saleQuantityStr.isInt,
                let numberSaleQuantity = Int(saleQuantityStr),
                numberSaleQuantity > 0 {
                self.L_saleQuantityLbl.text = "\(product.saleQuantity)\( product.saleQuantityText) \(product.saleQuantitySubText)"
            } else {
                
                // saleQuantity값이 숫자가 아님, 혹시 "0"인 값이 들어올 경우 ""값으로 치환.
                let saleQuantity = product.saleQuantity == "0" ? "" : product.saleQuantity
                self.L_saleQuantityLbl.text = "\(saleQuantity)\( product.saleQuantityText) \(product.saleQuantitySubText)"
            }
        } else {
            self.L_saleQuantityLbl.text = ""
        }
        
//        신규 로직 적용 중..
//        self.L_saleQuantityLbl.text = ""
//        if !product.saleQuantity.isEmpty {
//            // product.saleQuantity 값이 숫자값인지, 0보다 큰 수 인지 판단.
//
//            // 1. 혹시 있을지 모를 콤마제거
//            let saleQuantityStr = product.saleQuantity.replacingOccurrences(of: ",", with: "")
//
//
//            if Common_Util.isThisValidNumberStr(saleQuantityStr)  {
//                // 숫자가 맞음.
//                self.L_saleQuantityLbl.text = "\(product.saleQuantity)\( product.saleQuantityText) \(product.saleQuantitySubText)"
//            } else if product.saleQuantityText.count > 0 {
//                // 텍스트만 있는 경우 (첫 구매시!!)
//                self.L_saleQuantityLbl.text = product.saleQuantityText
//            }
//        }
        //////// xx명 구매중 or 상품평 화면 종료 ////////
        

        ///////////// accessibilityLabel 적용 /////////////
        self.L_link.accessibilityLabel = String(format: "%@  %@  %@", product.productName, product.salePrice, product.exposePriceText)
        //////////////////////////////////////////////////////////// L 종료 ///////////////////////////////////////////////////////////
    }
    
    /// 상품 클릭처리
    @IBAction func onBtnContents(sender: UIButton) {
        // Tag
        // 0 = L
        guard let method = self.aTarget?.dctypetouchEventTBCell else { return }
        method(self.L_infoDic?.toJSON(), NSNumber(value: sender.tag), "BFP")
    }
}
