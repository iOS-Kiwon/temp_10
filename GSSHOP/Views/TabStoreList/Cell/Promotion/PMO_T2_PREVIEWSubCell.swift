//
//  PMO_T2_PREVIEWSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 20/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T2_PREVIEWSubCell: BaseCollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var moreLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setInitUI() {
        self.imgView.image = UIImage(named: Const.Image.img_noimage_78.name)
        self.moreLbl.isHidden = false
    }
    
    func setData(product: Module) {
        
        self.imgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_78.name), data: product)
        
        if product.viewType == Const.ViewType.PMO_T2_PREVIEW_MORE.name {
            self.moreLbl.isHidden = false
        } else {
            self.moreLbl.isHidden = true
        }
    }

}
