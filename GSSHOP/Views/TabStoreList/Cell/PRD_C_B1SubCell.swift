//
//  PRD_C_B1SubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 01/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PRD_C_B1SubCell: BaseCollectionViewCell {

    /// 상품 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 광고 이미지뷰
    @IBOutlet weak var addImgView: UIImageView!
    
    /// 상품 가격 라벨
    @IBOutlet weak var priceLbl: UILabel!
    /// 상품명 라벨
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var widthLT: NSLayoutConstraint!
    @IBOutlet weak var heightLT: NSLayoutConstraint!
    /// 상품 더보기 라벨
    @IBOutlet weak var moreLbl: UILabel!
    /// 혜택뷰 라벨
    @IBOutlet weak var benefitLbl: BenefitLabel!
    /// 상품 구매수 라벨
    @IBOutlet weak var reviewCountLbl: UILabel!
    /// 상품 평
    @IBOutlet weak var gradeLbl: UILabel!
    /// 일시품절 뷰
    @IBOutlet weak var soldOutView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isAccessibilityElement = true
        self.accessibilityTraits = .button
        setInitUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }
    
    private func setInitUI() {
        self.imgView.image = UIImage(named: Const.Image.img_noimage_144.name)
        self.addImgView.isHidden = true
        self.moreLbl.isHidden = true
        self.priceLbl.isHidden = false
        self.productNameLbl.isHidden = false
        self.priceLbl.text = ""
        self.gradeLbl.text = ""
        self.reviewCountLbl.text = ""
        self.productNameLbl.attributedText = NSMutableAttributedString(string: "")
        self.accessibilityLabel = ""
        self.soldOutView.isHidden = true
    }
    
    func setData(product: Module) {
        self.imgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_144.name), data: product)
        
        // 더보기 Cell 인경우,
        if product.viewType == Const.ViewType.PMO_T1_PREVIEW_B_MORE.name {
            self.moreLbl.isHidden = false
            self.priceLbl.isHidden = true
            self.productNameLbl.isHidden = true
            self.accessibilityLabel = self.moreLbl.text
            return
        }
        self.priceLbl.setSalePrice(data: product, exposeBaseOffset: 1.5)
        self.productNameLbl.setProductName(data: product)
        self.reviewCountLbl.setReviewCount(data: product)
        self.gradeLbl.setReviewAverage(data: product)
        self.benefitLbl.setBenefit(data: product, labelWidth: self.benefitLbl.frame.width, lineLimit: 1)
        
        //일시품절
        self.soldOutView.isHidden = ("SOLD_OUT" == product.imageLayerFlag.uppercased()) ? false : true
        
        // 접근성
        self.accessibilityLabel = String(format: "%@, %@", self.productNameLbl.text ?? "", self.priceLbl.text ?? "")
    }
}
