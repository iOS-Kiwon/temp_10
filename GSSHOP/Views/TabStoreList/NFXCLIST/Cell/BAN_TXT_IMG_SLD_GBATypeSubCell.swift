//
//  BAN_TXT_IMG_SLD_GBATypeSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/05/26.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_TXT_IMG_SLD_GBATypeSubCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var clipView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleBgView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var subTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.baseView.setShadow(color: .black, alpha: 0.06, x: 0, y: 2, blur: 8, spread: 0)
        self.clipView.setCorner(radius: 12.0)
        self.baseView.setCorner(radius: 12.0)
        self.baseView.clipsToBounds = false
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLbl.text = ""
        self.subTitleLbl.text = ""
    }
    
    func setData(_ data: Module) {
        
        self.titleLbl.text = data.title1
        self.subTitleLbl.text = data.title2
        
        //kiwon : 20. 06. 16. 색상은 흰색으로 간다고 함(이미선 디자이너)
        self.titleBgView.backgroundColor = .white
        
        // 이미지 설정
        ImageDownManager.blockImageDownWithURL(data.imageUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
            if error != nil || statusCode == 0 {
                self.imgView.image = UIImage(named: Const.Image.img_noimage_375_188.name)
                return
            }
            
            if isInCache == true {
                self.imgView.image = image
            } else {
                self.imgView.alpha = 0
                self.imgView.image = image

                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.imgView.alpha = 1
                })
            }
        }
        
        
        /// 접근성
        self.isAccessibilityElement = true
        self.accessibilityTraits = .button
        self.accessibilityLabel = "\(data.title1) \(data.title2)"
    }
}
