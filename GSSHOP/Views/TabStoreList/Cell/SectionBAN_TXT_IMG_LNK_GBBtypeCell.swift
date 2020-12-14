//
//  SectionBAN_TXT_IMG_LNK_GBBtypeCell.swift
//  GSSHOP
//
//  Created by admin on 11/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_TXT_IMG_LNK_GBBtypeCell: UITableViewCell {
    private let mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    private var adImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 16))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(self.mBanner)
        
        self.adImgView.image = UIImage(named: Const.Image.cell_add_light.name)
        self.addSubview(self.adImgView)
        self.adImgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.adImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.trailingAnchor.constraint(equalTo: self.adImgView.trailingAnchor, constant: 16.0)
            ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.adImgView.isHidden = true
        self.mBanner.prepareForReuse()
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let product = Module(JSON: rowinfoDic) else { return  }
        
        // 이름 사용하는 플래그 활성
        if product.useName == "Y" {
            if let custName = DataManager.shared()?.userName {
               product.productName = custName + "님" + product.productName
            }
            else {
                product.productName = "고객님" + product.productName
            }
        }
        
        if product.badgeRTType == "AD" {
            // AD 이미지 노출
            self.adImgView.isHidden = false
            self.mBanner.frame.size.width = getAppFullWidth() - 63 // 광고 영역 : 63 (제플린참고)
            self.mBanner.makeGBAview(imageUrl: product.tabImg, islink: false , title: product.productName,
                                     subTittle: product.promotionName, fontColor:product.textColor)
            
        }
        else {
            self.adImgView.isHidden = true
            self.mBanner.makeGBAview(imageUrl: product.tabImg, islink: !product.linkUrl.isEmpty , title: product.productName,
                                     subTittle: product.promotionName, fontColor:product.textColor)
            
        }
        self.mBanner.setUnderLine(use: !(product.bdrBottomYn == "N") )
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setSelected(highlighted, animated: animated)
        self.mBanner.highlightedStatusSwitch(status: highlighted)        
    }
    
}
