//
//  SectionBAN_SLD_GBEtypeSubView.swift
//  GSSHOP
//
//  Created by admin on 14/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_SLD_GBEtypeSubView: UIView {

    @IBOutlet weak var imgLT: UIImageView!
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lbPromotion: UILabel!
    @IBOutlet weak var lbProduct: UILabel!
    @IBOutlet weak var lbDiscount: UILabel!
    @IBOutlet weak var lbSalePrice: UILabel!
    @IBOutlet weak var lbSalePriceText: UILabel!
    @IBOutlet weak var lbBase: UILabel!
    @IBOutlet weak var vBaseCancelLine: UIView!
    @IBOutlet weak var lbSaleCount: UILabel!
    /// defualt 8 discount 없으면 0
    @IBOutlet weak var loSalePriceLeading: NSLayoutConstraint!
    ///LT 높이
    @IBOutlet weak var loImgLT_h: NSLayoutConstraint!
    ///LT 너비
    @IBOutlet weak var loImgLT_w: NSLayoutConstraint!
    ///혜택 추가
    @IBOutlet weak var vBenefit: UIStackView!
    ///메인 이름
    var aTarget: AnyObject?;                                                        //클릭시 이벤트를 보낼 타겟
    var selDic:Module!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepareForReuse() {
        self.initControl()
    }
    
    ///컨트롤들 초기화 함수
    func initControl() {
        self.lbBase.text = ""
        self.lbProduct.text = ""
        self.lbDiscount.text = ""
        self.lbPromotion.text = ""
        self.lbSaleCount.text = ""
        self.lbSalePrice.text = ""
        self.lbSalePriceText.text = ""
        self.vBaseCancelLine.isHidden = true
        self.loSalePriceLeading.constant = 0
        self.imgProduct.image = UIImage(named: Const.Image.noimg_320.name)
        self.imgLT.image = nil
        //self.imgProduct.image = nil
        self.loImgLT_h.constant = 0
        self.loImgLT_w.constant = 0
        for view in self.vBenefit.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    @objc func setDisplayDic(_ rowinfoDic:Module) {
        self.selDic = rowinfoDic
        if self.selDic != nil {            
            self.lbPromotion.text = self.selDic.exposPrSntncNm.count > 0 ? self.selDic.exposPrSntncNm : " " //영역확보를 위한 공백 삽입 why? 프로모션 이 아래 상품명 기준점임.
            
            self.lbProduct.text = self.selDic.productName
            // 할인율이 0보다 커야 노출하고 할인율이 없으면 베이스가 노출안함.
            if self.selDic.discountRate > 0 {
                self.lbDiscount.text = String(self.selDic.discountRate) + "%"
                self.loSalePriceLeading.constant = 8
                self.lbBase.text = self.selDic.basePrice + self.selDic.exposePriceText
                self.vBaseCancelLine.isHidden = false
            }
            else { //할인율 노출 안함. 베이스가격 노출안함.
                self.lbDiscount.text = ""
                self.loSalePriceLeading.constant = 0
                self.lbBase.text = ""
                self.vBaseCancelLine.isHidden = true
            }
            
            self.lbSalePrice.text = self.selDic.salePrice
            self.lbSalePriceText.text = self.selDic.exposePriceText
            
            if self.selDic.saleQuantity != "" , self.selDic.saleQuantity != "0" {
                self.lbSaleCount.text = self.selDic.saleQuantity + self.selDic.saleQuantityText + " " + self.selDic.saleQuantitySubText
            }
            else if self.selDic.saleQuantityText.count > 0 { //텍스트만 노출
                self.lbSaleCount.text = self.selDic.saleQuantityText
            }
            else {
                
            }
            
            
            //이미지 처리 self.selDic.imageUrl
            ImageDownManager.blockImageDownWithURL(self.selDic!.imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                if error == nil, self.selDic.imageUrl == strInputURL, let fImg = fetchedImage {                    
                    DispatchQueue.main.async {
                        if isInCache == true {
                            self.imgProduct.image = fImg
                        }
                        else {
                            self.imgProduct.alpha = 0
                            self.imgProduct.image = fImg
                            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                                self.imgProduct.alpha = 1
                            }, completion: { (finished) in
                                
                            })
                        }
                    }//dispatch
                }//if
            }
            
            
            //LT처리
            //하나만 사용
            if let iLT:ImageInfo = self.selDic.imgBadgeCorner.LT.first {
                ImageDownManager.blockImageDownWithURL(iLT.imgUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                    if error == nil, iLT.imgUrl == strInputURL, let fImg = fetchedImage{
                        DispatchQueue.main.async {
                            //이미지 리사이즈
                            self.loImgLT_w.constant = fImg.size.width/2;
                            self.loImgLT_h.constant = fImg.size.height/2;
                            
                            if isInCache == true {
                                self.imgLT.image = fImg
                            }
                            else {
                                self.imgLT.alpha = 0
                                self.imgLT.image = fImg
                                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                                    self.imgLT.alpha = 1
                                }, completion: { (finished) in
                                    
                                })
                            }
                        }//dispatch
                    }//if
                }
            }
                        
            //해텍 처리
            Common_NFXC.makeBenefitStack(self.selDic.imgBadgeCorner.RB,self.vBenefit)
            
        }
        else {
            return
        }
    }    
    
}
