//
//  SectionMAP_CX_GBCtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 26/09/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionMAP_CX_GBCtypeCell: UITableViewCell {
    /// 왼쪽 이미지뷰
    @IBOutlet weak var L_imgView: UIImageView!
    /// 왼쪽 New 딱지
    @IBOutlet weak var L_newImgView: UIImageView!
    /// 왼쪽 New 딱지 Width
    @IBOutlet weak var L_newImgViewWidth: NSLayoutConstraint!
    /// 왼쪽 New 딱지 Height
    @IBOutlet weak var L_newImgViewHeight: NSLayoutConstraint!
    /// 왼쪽 오늘의 딜
    @IBOutlet weak var L_todayImgView: UIImageView!
    /// 왼쪽 오늘의 딜 라벨
    @IBOutlet weak var L_todayLbl: UILabel!
    
    /// 왼쪽 상품명
    @IBOutlet weak var L_productNameLbl: UILabel!
    /// 왼쪽 할인율
    @IBOutlet weak var L_discountRateLbl: UILabel!
    /// 왼쪽 기존 가격
    @IBOutlet weak var L_basePriceLbl: UILabel!
    /// 왼쪽 판매 가격
    @IBOutlet weak var L_salePriceLbl: UILabel!
    /// 왼쪽뷰 전체버튼
    @IBOutlet weak var L_button: UIButton!
    
    /// 오른쪽 뷰
    @IBOutlet weak var rightView: UIView!
    /// 오른쪽 New 딱지
    @IBOutlet weak var R_newImgView: UIImageView!
    /// 오른쪽 New 딱지 Width
    @IBOutlet weak var R_newImgViewWidth: NSLayoutConstraint!
    /// 오른쪽 New 딱지 Height
    @IBOutlet weak var R_newImgViewHeight: NSLayoutConstraint!
    /// 오른쪽 오늘의 딜
    @IBOutlet weak var R_todayImgView: UIImageView!
    /// 왼쪽 오늘의 딜 라벨
    @IBOutlet weak var R_todayLbl: UILabel!
    
    /// 오른쪽 이미지뷰
    @IBOutlet weak var R_imgView: UIImageView!
    /// 오른쪽 상품명
    @IBOutlet weak var R_productNameLbl: UILabel!
    /// 오른쪽 할인율
    @IBOutlet weak var R_discountRateLbl: UILabel!
    /// 오른쪽 기존 가격
    @IBOutlet weak var R_basePriceLbl: UILabel!
    /// 오른쪽 판매 가격
    @IBOutlet weak var R_salePriceLbl: UILabel!
    /// 오른쪽 View 하단 라인
    @IBOutlet weak var R_underLine: UIView!
    /// 오른쪽 전체버튼
    @IBOutlet weak var R_button: UIButton!
    
    /// 왼쪽 Product 객체
    private var l_product: Module!
    /// 오른쪽 Product 객체
    private var r_product: Module!
    
    /// 타겟 테이블뷰
    var aTarget: NFXCListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
// MARK:- Public Functions
extension SectionMAP_CX_GBCtypeCell {
    /// 왼쪽 데이터 설정
    func setLeftProductData(_ data: Module) {
        self.l_product = data
        
        // 이미지 설정
        ImageDownManager.blockImageDownWithURL(data.imageUrl as NSString) { (httpStatusCode, fetchedImage, imageUrl, isInCache, error) in
            if error == nil, data.imageUrl == imageUrl, let image = fetchedImage {
                DispatchQueue.main.async {
                    if isInCache == true {
                        self.L_imgView.image = image
                    }
                    else {
                        self.L_imgView.alpha = 0
                        self.L_imgView.image = image
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.L_imgView.alpha = 1
                        })
                    }
                }//dispatch
            }//if
        }
        
        // 오늘의 딜
        if data.dealProductType == "Deal" {
            self.L_todayImgView.isHidden = false
        } else {
            self.L_todayImgView.isHidden = true
        }
        
        // New 딱지 이미지 / 랭킹 표시
        if let ltData = data.imgBadgeCorner.LT.first {
            if !ltData.imgUrl.isEmpty {
                ImageDownManager.blockImageDownWithURL(ltData.imgUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                    if error == nil, ltData.imgUrl == strInputURL, let image = fetchedImage {
                        DispatchQueue.main.async {
                            self.L_newImgView.isHidden = false
                            self.L_newImgViewWidth.constant = image.size.width / 2
                            self.L_newImgViewHeight.constant = image.size.height / 2
                            
                            if isInCache == true {
                                self.L_newImgView.image = image
                            }
                            else {
                                self.L_newImgView.alpha = 0
                                self.L_newImgView.image = image
                                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                                    self.L_newImgView.alpha = 1
                                })
                            }
                        }
                    }
                }
            } else {
                self.L_todayImgView.isHidden = true
                self.L_todayLbl.text = ""
                self.L_todayLbl.isHidden = true
                
                if self.L_todayImgView.isHidden,
                    !ltData.type.isEmpty {
                    if ltData.type == "T" {
                        self.L_todayImgView.image = UIImage(named: Const.Image.best_ranking1_5_bg.name)
                        self.L_todayLbl.textColor = UIColor.getColor("FFFFFF")
                    } else {
                        self.L_todayImgView.image = UIImage(named: Const.Image.best_ranking6_100_bg.name)
                        self.L_todayLbl.textColor = UIColor.getColor("ee2162")
                    }
                    
                    self.L_todayImgView.isHidden = false
                    self.L_todayLbl.text = ltData.text
                    self.L_todayImgView.isHidden = true
                }
            }
        }
        
        // 상품명
        self.L_productNameLbl.text = data.productName
        
        // 할인율이 0% 초과인 경우만 노출
        if data.discountRate > 0 {
            // 할인율
            self.L_discountRateLbl.text = data.discountRate.toString + "%"
            
            // Base 가격
            self.L_basePriceLbl.attributedText = setBasePrice(data.basePrice)
        }
        // 판매 가격
        self.L_salePriceLbl.attributedText = setSalePrice(data.salePrice, unit: data.exposePriceText)
        
        // 버튼에 접근성 설정
        self.L_button.accessibilityLabel = "\(data.productName) \(data.salePrice)\(data.exposePriceText)"
        self.L_button.isAccessibilityElement = true
    }
    
    /// 오른쪽 데이터 설정
    func setRightProductData(_ data: Module) {
        setRightViewHidden(false)
        self.r_product = data
        
        // 이미지 설정
        ImageDownManager.blockImageDownWithURL(data.imageUrl as NSString) { (httpStatusCode, fetchedImage, imageUrl, isInCache, error) in
            if error == nil, data.imageUrl == imageUrl, let image = fetchedImage {
                DispatchQueue.main.async {
                    if isInCache == true {
                        self.R_imgView.image = image
                    }
                    else {
                        self.R_imgView.alpha = 0
                        self.R_imgView.image = image
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.R_imgView.alpha = 1
                        })
                    }
                }//dispatch
            }//if
        }
        
        // 오늘의 딜
        if data.dealProductType == "Deal" {
            self.R_todayImgView.isHidden = false
        } else {
            self.R_todayImgView.isHidden = true
        }
        
        // New 딱지 이미지 / 랭킹 표시
        if let ltData = data.imgBadgeCorner.LT.first {
            if !ltData.imgUrl.isEmpty {
                ImageDownManager.blockImageDownWithURL(ltData.imgUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                    if error == nil, ltData.imgUrl == strInputURL, let image = fetchedImage {
                        DispatchQueue.main.async {
                            self.R_newImgView.isHidden = false
                            self.R_newImgViewWidth.constant = image.size.width / 2
                            self.R_newImgViewHeight.constant = image.size.height / 2
                            
                            if isInCache == true {
                                self.R_newImgView.image = image
                            }
                            else {
                                self.R_newImgView.alpha = 0
                                self.R_newImgView.image = image
                                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                                    self.R_newImgView.alpha = 1
                                })
                            }
                        }
                    }
                }
            } else {
                self.R_todayImgView.isHidden = true
                self.R_todayLbl.text = ""
                self.R_todayLbl.isHidden = true
                
                if self.R_todayImgView.isHidden,
                    !ltData.type.isEmpty {
                    if ltData.type == "T" {
                        self.R_todayImgView.image = UIImage(named: Const.Image.best_ranking1_5_bg.name)
                        self.R_todayLbl.textColor = UIColor.getColor("FFFFFF")
                    } else {
                        self.R_todayImgView.image = UIImage(named: Const.Image.best_ranking6_100_bg.name)
                        self.R_todayLbl.textColor = UIColor.getColor("ee2162")
                    }
                    
                    self.R_todayImgView.isHidden = false
                    self.R_todayLbl.text = ltData.text
                    self.R_todayImgView.isHidden = true
                }
            }
        }
        
        // 상품명
        self.R_productNameLbl.text = data.productName
        
        // 할인율이 0% 초과인 경우만 노출
        if data.discountRate > 0 {
            // 할인율
            self.R_discountRateLbl.text = data.discountRate.toString + "%"
            
            // Base 가격
            self.R_basePriceLbl.attributedText = setBasePrice(data.basePrice)
        }
        
        // 판매 가격
        self.R_salePriceLbl.attributedText = setSalePrice(data.salePrice, unit: data.exposePriceText)
        
        // 하단 라인 보이기
        self.R_underLine.isHidden = false
        
        // 버튼에 접근성 설정
        self.R_button.accessibilityLabel = "\(data.productName) \(data.salePrice)\(data.exposePriceText)"
        self.R_button.isAccessibilityElement = true
    }
    
    /// 오른쪽 화면을 hidden 처리
    func setRightViewHidden(_ value: Bool) {
        self.R_imgView.isHidden = value
        self.R_productNameLbl.isHidden = value
        self.R_discountRateLbl.isHidden = value
        self.R_basePriceLbl.isHidden = value
        self.R_salePriceLbl.isHidden = value
        self.R_underLine.isHidden = false
    }
}

// MARK:- Private Functions
extension SectionMAP_CX_GBCtypeCell {
        
    /// UI 초기화
    private func setInitUI() {
        self.contentView.backgroundColor = .white
        self.L_imgView.image = UIImage(named: Const.Image.img_noimage_166.name)
        self.L_productNameLbl.text = ""
        self.L_discountRateLbl.text = ""
        self.L_basePriceLbl.text = ""
        self.L_basePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.L_salePriceLbl.text = ""
        self.L_salePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.L_button.accessibilityLabel = ""
        self.L_button.isAccessibilityElement = false
        self.L_newImgView.isHidden = true
        self.L_todayImgView.isHidden = true
        self.L_todayLbl.text = ""
        self.l_product = nil
        
        setRightViewHidden(false)
        self.R_imgView.image = UIImage(named: Const.Image.img_noimage_166.name)
        self.R_productNameLbl.text = ""
        self.R_discountRateLbl.text = ""
        self.R_basePriceLbl.text = ""
        self.R_basePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.R_salePriceLbl.text = ""
        self.R_salePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.R_button.accessibilityLabel = ""
        self.R_button.isAccessibilityElement = false
        self.R_newImgView.isHidden = true
        self.R_todayImgView.isHidden = true
        self.R_todayLbl.text = ""
        self.r_product = nil
    }
    
    /// 판매 가격 설정
    private func setSalePrice(_ price: String, unit: String) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: price + unit, attributes: [
            .font: UIFont.systemFont(ofSize: 19.0, weight: .bold),
            .foregroundColor: UIColor.getColor("111111")
//            .kern: -0.51
            ])
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 15.0)
//            .kern: -0.4
        ], range: NSRange(location: price.count, length: unit.count))
        
        return attributedString
    }
    
    /// 할인 전 origin 판매가격 설정
    private func setBasePrice(_ price: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: price + "원", attributes: [
            .font: UIFont.systemFont(ofSize: 13.0),
            .foregroundColor: UIColor.getColor("999999"),
            ])
        attributedString.addAttribute(
            .strikethroughStyle ,
            value: 2,
            range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(
            .strikethroughColor,
            value: UIColor.getColor("999999"),
            range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}

// MARK:- Button Actions
extension SectionMAP_CX_GBCtypeCell {
    @IBAction func onClickLeftViewBtn(_ sender: UIButton) {
        self.aTarget?.onBtnCellJustLinkStr(self.l_product.linkUrl)
    }
    
    @IBAction func onClickRightViewBtn(_ sender: UIButton) {
        if self.r_product != nil {
            self.aTarget?.onBtnCellJustLinkStr(self.r_product.linkUrl)
        }
    }
}
