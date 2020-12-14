//
//  WebPrdNameView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/24.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdNameView: UIView {
    
    /// 브렌드 뷰
    @IBOutlet weak var brandView: UIView!
    /// 브랜드 뷰 높이
    @IBOutlet weak var brandViewHeight: NSLayoutConstraint!
    /// 브랜드 아이콘 이미지뷰
    @IBOutlet weak var brandIconImgView: UIImageView!
    /// 브랜드 아이콘 이미지 너비
    @IBOutlet weak var brandIconImgWidth: NSLayoutConstraint!
    /// 브랜드 라벨
    @IBOutlet weak var brandLbl: UILabel!
    /// 브랜드 링크이동 이미지뷰
    @IBOutlet weak var brandLinkImgView: UIImageView!
    /// 브랜드 버튼
    @IBOutlet weak var brandBtn: UIButton!
    
    /// 프로모션 라벨
    @IBOutlet weak var promotionLbl: UILabel!
    /// 프로모션 라벨 상단 여백
    @IBOutlet weak var promotionLblTop: NSLayoutConstraint!
    
    /// 상품명 라벨
    @IBOutlet weak var productNameLbl: UILabel!
    /// 상품명 라벨 상단 여백
    @IBOutlet weak var productNameLblTop: NSLayoutConstraint!
    

    /// 원산지표시 라벨
    @IBOutlet weak var originLbl: UILabel!
    /// 원산지표시 라벨 상단여백
    @IBOutlet weak var originLblTop: NSLayoutConstraint!
    
    /// 평점 Base 뷰
    @IBOutlet weak var reviewBaseView: UIView!
    /// 평점 Base 뷰 상단 여백
    @IBOutlet weak var reviewBaseViewTop: NSLayoutConstraint!
    /// 평점 Base 뷰 높이
    @IBOutlet weak var reviewBaseViewHeight: NSLayoutConstraint!
    /// 평점 별 뷰
    @IBOutlet weak var starBaseView: UIView!
    
    /// 평점 별 초록색배경 뷰
    @IBOutlet weak var starGreenBgView: UIView!
    /// 평점 별 초록색배경 뷰의 Width
    @IBOutlet weak var starGreenBgViewWidth: NSLayoutConstraint!
    /// 평점 카운트 라벨
    @IBOutlet weak var reviewCntLbl: UILabel!
    /// 평점 상세보기
    @IBOutlet weak var reviewLinkBtn: UIButton!
    /// 평점 상세보기 아이콘
    @IBOutlet weak var reviewLinkImgView: UIImageView!
    
    private var prdNmInfo: Components?
    
    private weak var aTarget: ResultWebViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        // 브랜드 영역 초기화
        self.brandView.isHidden = true
        self.brandViewHeight.constant = 0.0
        self.promotionLblTop.constant = 0.0
        self.productNameLblTop.constant = 0.0
        self.originLblTop.constant = 0.0
        self.reviewBaseViewTop.constant = 0.0
        self.brandLbl.text = ""
        self.originLbl.text = ""
        self.brandIconImgView.image = nil
        self.brandIconImgView.isHidden = true
        self.brandLinkImgView.isHidden = true
        self.brandLinkImgView.image = nil
        self.brandBtn.isEnabled = false
        
        // 상품명 영역 초기화
        self.productNameLbl.text = ""
        
    }
    
    func setData(_ data: Components, target: ResultWebViewController) {
        self.prdNmInfo = data
        self.aTarget = target
        
        // 브랜드 설정
        setBrandUI(brandInfo: data.brandInfo)
        // 프로모션 Text 설정
        setPromotionTextUI(data.promotionText)
        // 상품명 설정
        setProductNameUI(data.expoName)
        // 원산지 정보 설정
        setOriginUI(data.subInfoText)
        // 리뷰 정보 설정
        setReviewUI(reviewInfo: data.reviewInfo)
    }
    
    /// 브랜드 정보 설정
    private func setBrandUI(brandInfo: BrandInfo?) {
        guard let data = brandInfo else {
            initUI()
            return
        }
        
        if data.brandLinkUrl.isEmpty, data.brandLogoUrl.isEmpty, data.brandTitle.count <= 0 {
            initUI()
            return
        }
        
        self.brandView.isHidden = false
        self.brandViewHeight.constant = 20.0
        self.promotionLblTop.constant = 4.0
        if data.brandLinkUrl.isEmpty == false {
            self.brandLinkImgView.isHidden = false
            self.brandLinkImgView.image = UIImage(named: Const.Image.ic_arrow_right_20.name)
            self.brandBtn.isEnabled = true
        } else {
            self.brandLinkImgView.isHidden = false
            self.brandLinkImgView.image = nil
            self.brandBtn.isEnabled = false
        }
        
        
        //브랜드 아이콘
        if data.brandLogoUrl.isEmpty == false {
            self.brandIconImgView.isHidden = false
            ImageDownManager.blockImageDownWithURL( data.brandLogoUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                if error != nil || statusCode == 0 {
                    self.brandIconImgView.image = nil
                    self.brandIconImgView.isHidden = true
                    return
                }
                
                self.brandIconImgWidth.constant = self.makeRadioWidth(image?.size ?? CGSize(width: 0,height: 0),standardHeigth: self.brandViewHeight.constant)
                
                if isInCache == true {
                    self.brandIconImgView.image = image
                } else {
                    self.brandIconImgView.alpha = 0
                    self.brandIconImgView.image = image
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.brandIconImgView.alpha = 1
                    }, completion: nil)
                }
            }
        }
        
        
        
        let brandAttributedString =  NSMutableAttributedString(string: "")
        
//        let style = NSMutableParagraphStyle()
//        style.alignment = .left
//        style.lineBreakMode = .byCharWrapping
//        style.minimumLineHeight = self.findMinimumLineHeight(data.brandTitle)
//        brandAttributedString.addAttribute(
//            .paragraphStyle, value: style,
//            range: NSRange(location:0,
//                           length: brandAttributedString.length))
        
        for data in data.brandTitle {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            brandAttributedString.append(attrString)
        }
        //self.brandLbl.lineBreakMode = .byClipping
        self.brandLbl.numberOfLines = 0
        self.brandLbl.attributedText = brandAttributedString
    }
    
    /// 상품명 위에오는 프로모션 문구 설정
    private func setPromotionTextUI(_ dataList: [PrdTextInfo]) {
        if dataList.count <= 0 {
            self.promotionLbl.text = ""
            self.promotionLbl.attributedText = NSMutableAttributedString()
            self.productNameLblTop.constant = 0.0
            return
        }
        
        let promoAttributedString = NSMutableAttributedString(string: "")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping
        style.minimumLineHeight = self.findMinimumLineHeight(dataList)
        promoAttributedString.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: promoAttributedString.length))
        
        for data in dataList {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            promoAttributedString.append(attrString)
        }
        
        self.promotionLbl.numberOfLines = 1
        self.promotionLbl.attributedText = promoAttributedString
        self.productNameLblTop.constant = 2.0
    }
    
    /// 상품명 설정
    private func setProductNameUI(_ dataList: [PrdTextInfo]) {
        if dataList.count <= 0 {
            self.productNameLbl.text = ""
            self.productNameLbl.attributedText = NSMutableAttributedString()
            self.productNameLblTop.constant = 0.0
            return
        }
        
        let productAttributedString = NSMutableAttributedString(string: "")
        let prdNameStyle = NSMutableParagraphStyle()
        prdNameStyle.alignment = .left
        prdNameStyle.lineBreakMode = .byWordWrapping
        prdNameStyle.minimumLineHeight = self.findMinimumLineHeight(dataList)
        productAttributedString.addAttribute(
            .paragraphStyle, value: prdNameStyle,
            range: NSRange(location:0,
                           length: productAttributedString.length))
        
        for data in dataList {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            productAttributedString.append(attrString)
        }
        
        self.productNameLbl.attributedText = productAttributedString
    }
    
    /// 원산지 라벨 설정
    private func setOriginUI(_ subInfoText: [PrdTextInfo]) {
        
        if subInfoText.count <= 0 {
            self.originLbl.text = ""
            self.originLbl.attributedText = NSMutableAttributedString()
            self.originLblTop.constant = 0.0
            
            return
        }
        
        let subInfoAttributedString = NSMutableAttributedString(string: "")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byCharWrapping
        style.minimumLineHeight = self.findMinimumLineHeight(subInfoText)
        subInfoAttributedString.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: subInfoAttributedString.length))
        
        for data in subInfoText {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            subInfoAttributedString.append(attrString)
        }
        
        self.originLbl.numberOfLines = 0
        self.originLbl.attributedText = subInfoAttributedString
        self.originLblTop.constant = 5.0
        
    }
    
    /// 상품평 UI 설정
    private func setReviewUI(reviewInfo: ReviewInfo?) {
        
        guard let reviewData = reviewInfo else {
            // 상품평 정보가 없는 경우
            self.reviewBaseViewHeight.constant = 0.0
            self.reviewBaseViewTop.constant = 0.0
            self.reviewCntLbl.text = ""
            self.reviewLinkBtn.isHidden = true
            self.starBaseView.isHidden = true
            self.reviewLinkImgView.isHidden = true
            return
        }
        
        if reviewData.reviewPoint.isEmpty, reviewData.reviewText.isEmpty {
            // 상품평 정보가 없는 경우
            self.reviewBaseViewHeight.constant = 0.0
            self.reviewCntLbl.text = ""
            self.reviewLinkBtn.isHidden = true
            self.starBaseView.isHidden = true
            self.reviewLinkImgView.isHidden = true
            return
        }
        
        // 상품평 정보가 있는 경우
        self.reviewBaseViewHeight.constant = 20.0
        self.reviewBaseViewTop.constant = 5.0
        
        
        self.reviewLinkBtn.isHidden = reviewData.linkUrl.isEmpty
        self.reviewLinkImgView.isHidden = reviewData.linkUrl.isEmpty
            
        // 별표
        setStarUI(point: CGFloat((reviewData.reviewPoint as NSString).floatValue))
                
        
        let pointAttributedString = NSMutableAttributedString(string: "")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byCharWrapping
        style.minimumLineHeight = self.findMinimumLineHeight(reviewInfo!.reviewText)
        pointAttributedString.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: pointAttributedString.length))
        
        for data in reviewInfo!.reviewText {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            pointAttributedString.append(attrString)
        }
        
        self.reviewCntLbl.attributedText = pointAttributedString
    }
    
    /// 별 색칠
    private func setStarUI(point: CGFloat) {
        
        // 색칠 고고
        var pathWidth = self.starBaseView.frame.width * point / 5.0
        if pathWidth > self.starBaseView.frame.width {
            pathWidth = self.starBaseView.frame.width
        }
        self.starGreenBgViewWidth.constant = pathWidth
    }

    // MARK:- Button Action Functions
    @IBAction func brandBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget, let data = self.prdNmInfo, let brandInfo = data.brandInfo {
            vc.dealPrdUrlAction(brandInfo.brandLinkUrl, withParam: nil,loginCheck: false)
            vc.sendAmplitudeAndMseq(withAction: "매장명(파트너스/JBP)")
        }
        
    }
    
    @IBAction func reviewMoreBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget, let data = self.prdNmInfo, let brandInfo = data.reviewInfo {
            vc.dealPrdUrlAction(brandInfo.linkUrl, withParam: nil,loginCheck: false)
            //엠플리튜드 전송 아래 함수가 받아서 한번더 가공후 전송
            self.aTarget?.sendAmplitudeAndMseq(withAction: "상품평_상품명하단")
        }
    }
}
