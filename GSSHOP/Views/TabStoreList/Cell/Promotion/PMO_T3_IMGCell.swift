//
//  PMO_T3_IMGCell.swift
//  GSSHOP
//
//  Created by Kiwon on 15/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T3_IMGCell: BaseTableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    /// 상품 객체
    private var product: Module?
    
    /// 타겟 테이블뷰
    @objc var aTarget: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setInitUI() {
        self.imgView.image = UIImage(named: Const.Image.img_noimage_375_188.name)
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>) {
        guard let product = Module(JSON: dic) else { return }
        
        self.product = product
        
        self.imgView.setImgView(adultImg: nil, data: product)
    }
    
}
