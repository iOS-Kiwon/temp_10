//
//  SectionBAN_IMG_SLD_GBAtypeSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 11/12/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_IMG_SLD_GBAtypeSubCell: BaseCollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timeTitle: UILabel!
    
    var aTarget : AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.isAccessibilityElement = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = ""
        self.timeTitle.text = ""
        self.imgView.image = nil
        self.accessibilityLabel = ""
    }

    func setData(_ data: Module) {
        
        self.title.text = data.productName
        self.timeTitle.text = data.promotionName
        self.imgView.setImgView(adultImg: nil, data: data)

        self.accessibilityLabel = data.productName
    }
}
