//
//  PRD_C_SQSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 01/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PRD_C_SQSubCell: BaseCollectionViewCell {
    
    /// 상품 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 상품 가격 라벨
    @IBOutlet weak var priceLbl: UILabel!
    /// 상품명 라벨
    @IBOutlet weak var productNameLbl: UILabel!
    /// 더보기 라벨
    @IBOutlet weak var moreLbl: UILabel!
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
        self.priceLbl.text = ""
        self.productNameLbl.text = ""
        self.moreLbl.isHidden = true
        self.priceLbl.isHidden = false
        self.productNameLbl.isHidden = false
        self.accessibilityLabel = ""
        self.soldOutView.isHidden = true
    }
    
    func setData(product: Module) {
        self.imgView.setImgView(adultImg: UIImage(named: Const.Image.img_noimage_144.name), data: product)
        
        // 더보기 Cell 인경우,
        if product.viewType == Const.ViewType.PRD_C_SQ_MORE.name ||
            product.viewType == Const.ViewType.API_SRL_MORE.name {
            self.moreLbl.isHidden = false
            self.priceLbl.isHidden = true
            self.productNameLbl.isHidden = true
            self.accessibilityLabel = self.moreLbl.text
            return
        }

        self.priceLbl.setSalePrice(data: product, exposeBaseOffset: 1.5)
        self.productNameLbl.setProductName(data: product, isShowTF: true)
        
        //일시품절
        self.soldOutView.isHidden = ("SOLD_OUT" == product.imageLayerFlag.uppercased()) ? false : true
        
        // 접근성
        self.accessibilityLabel = String(format: "%@, %@", self.productNameLbl.text ?? "", self.priceLbl.text ?? "")
    }
}
