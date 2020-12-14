//
//  PMO_T1_PREVIEW_DSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 05/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T1_PREVIEW_DSubCell: BaseCollectionViewCell {
    
    /// 상품 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 상품 가격 라벨
    @IBOutlet weak var priceLbl: UILabel!
    /// 상품명 라벨
    @IBOutlet weak var productNameLbl: UILabel!
    /// 일시품절 뷰
    @IBOutlet weak var soldOutView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
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
        self.priceLbl.text = ""
        self.productNameLbl.text = ""
        self.accessibilityLabel = ""
        self.soldOutView.isHidden = true
    }
    
    func setData(product: Module) {
        self.imgView.setImgView(adultImg: UIImage(named: Const.Image.img_noimage_144.name), data: product, isBorder: false)
        self.priceLbl.setSalePrice(data: product, priceFontSize: 16.0, exposeFontSize: 13.0, exposeBaseOffset: 1.5)
        self.productNameLbl.setProductName(data: product, isShowTF: false, fontSize: 14.0)
        
        //일시품절
        self.soldOutView.isHidden = ("SOLD_OUT" == product.imageLayerFlag.uppercased()) ? false : true
        
        // 접근성
        self.accessibilityLabel = String(format: "%@, %@", self.productNameLbl.text ?? "", self.priceLbl.text ?? "")
    }

}
