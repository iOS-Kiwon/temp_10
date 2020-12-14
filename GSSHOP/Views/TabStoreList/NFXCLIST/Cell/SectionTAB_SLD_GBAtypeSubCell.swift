//
//  SectionTAB_SLD_GBAtypeSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 10/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionTAB_SLD_GBAtypeSubCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    /// product 객체
    private var module: Module?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }()
        
        // 이미지 라운딩
        self.imgView.layer.borderWidth = 1.0
        self.imgView.layer.borderColor = UIColor.clear.cgColor
        self.imgView.layer.cornerRadius = imgView.frame.height/2
        self.imgView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = UIImage.init(named: Const.Image.noimg_280.name)
        self.nameLbl.text = ""
        self.accessibilityLabel = ""
    }
    
    func setCellInfoNDrawData(_ module: Module) {
        // 접근성
        self.accessibilityLabel = module.name
        
        self.module = module
        ImageDownManager.blockImageDownWithURL(module.tabBgImg as NSString) { (statusCode, image, imgURL, isInCache, error) in
            if error != nil || statusCode == 0 {
                return
            }
            if isInCache == true {
                self.imgView.image = image
            } else {
                self.imgView.alpha = 0
                self.imgView.image = image
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.imgView.alpha = 1
                }, completion: nil)
            }
        }
        
        self.nameLbl.text = module.name
        
        // default selected
        if self.module?.tabOnImg == "Y" {
            self.setImageRound(isSelected: true)
        } else {
            self.setImageRound(isSelected: false)
        }
    }
    
    func setImageRound(isSelected value: Bool) {
        if value {
            // 하이라이트 되었을때 호출
            self.imgView.layer.borderColor = UIColor.getColor("8d6231").cgColor
        } else {
            self.imgView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
