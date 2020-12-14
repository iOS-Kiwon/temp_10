//
//  WebPrdZzimView.swift
//  GSSHOP
//
//  Created by Home on 17/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdZzimView: UIView {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bgView.setCorner(radius: 16.0)
    }
    
    func setZzim(isOn value: Bool) {
        if value {
            // 찜 완료
            self.imgView.image = UIImage(named: Const.Image.ic_zzim_on_64.name)
            self.titleLbl.text = "찜 완료!"
        } else {
            // 찜 취소
            self.imgView.image = UIImage(named: Const.Image.ic_zzim_off_64.name)
            self.titleLbl.text = "찜 취소!"
        }
    }
    
    func showZzim() {
        
    }
}
