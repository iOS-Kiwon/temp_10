//
//  GR_BRD_GBATypeSubPrdCell.swift
//  GSSHOP
//
//  Created by neocyon MacBook on 2020/08/12.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class GR_BRD_GBATypeSubPrdCell: UICollectionViewCell {

    /// 상품 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 상품 이미지 테두리
    @IBOutlet weak var imgBorderView: UIView!
    /// 방송중 구매가능 뷰
    @IBOutlet weak var broadBuyView: UIView!
    @IBOutlet weak var broadBuyLbl: UILabel!
    
    /// 방송중 구매가능 뷰 높이
    @IBOutlet weak var broadBuyViewHeight: NSLayoutConstraint!
    /// 판매 가격
    @IBOutlet weak var salePriceLbl: UILabel!
    /// 상품명
    @IBOutlet weak var productNameLbl: UILabel!
    /// 혜택 라벨
    @IBOutlet weak var benefitLbl: BenefitLabel!
    
    /// 버튼
    @IBOutlet weak var btnProduct: UIButton!
    
    /// 상품 객체
    private var product: Module?
    /// 테이블뷰 타겟
    @objc var aTarget: GR_BRD_GBATypeCell?
    /// indexPath
    private var indexPath: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgBorderView.layer.borderWidth = 1.0
        self.imgBorderView.layer.borderColor = UIColor.getColor("000000", alpha: 0.06).cgColor
        self.isAccessibilityElement = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
        self.salePriceLbl.text = ""
        self.productNameLbl.text = ""
        self.benefitLbl.text = ""
    }
    
    /// Cell 왼쪽 데이터 설정
    func setData(product: Module, indexPath: IndexPath ,target:GR_BRD_GBATypeCell) {
        self.product = product
        self.indexPath = indexPath
        self.aTarget = target
        self.imgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_166.name), data: product)
        
        if product.broadTimeText.isEmpty == false {
            self.broadBuyView.isHidden = false
            self.broadBuyLbl.text = product.broadTimeText
        }else{
            self.broadBuyView.isHidden = true
            self.broadBuyLbl.text = ""
        }

        // 80.0 : 이미지뷰, 24 41  : 양쪽여백, 10 : 이미지와 라벨사이
        let limitWidth = CGFloat( getAppFullWidth() - 80.0  - (24 + 41 ) - 10)
        self.salePriceLbl.setSalePriceAndRate(data: product, labelWidth: limitWidth)
        self.productNameLbl.setProductName(data: product, isShowTF: true,fontSize: 15.0)
        self.benefitLbl.attributedText = Common_Util.attributedBenefitString(product.toJSON(), widthLimit: limitWidth, lineLimit: 2, fontSize: 13.0)

        // 접근성
        self.btnProduct.accessibilityLabel = String(format: "%@  %@  %@", product.productName, product.salePrice, product.exposePriceText)
        self.accessibilityLabel = String(format: "%@  %@  %@", product.productName, product.salePrice, product.exposePriceText)
    }
    
    @IBAction func onClickPrdCollection (_ sender : UIButton){
        if let vc = self.aTarget ,
            let path = self.indexPath {
            vc.onClickPrdCollection(path)
        }
    }
}
