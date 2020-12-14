//
//  SectionBAN_IMG_F80_C_GBAtypeCell.swift
//  GSSHOP
//  좌측, 가운데, 우측 높이고정 이미지 정렬 베너
//  Created by Kiwon on 26/09/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_IMG_F80_X_GBAtypeCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.imgView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessibilityLabel = ""
        self.imgView.image = nil
        self.imgView.removeAllConstraints()
    }
    
    func setCellInfoNDrawData(_ module: Module) {
        self.accessibilityLabel = module.name
        self.imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0).isActive = true
        //self.imgView.heightAnchor.constraint(equalTo:self.heightAnchor).isActive = true
        self.imgView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        ImageDownManager.blockImageDownWithURL(module.imageUrl as NSString) { (statusCode, image, imgUrl, isInCache, error) in
            if error != nil || statusCode == 0 {
                return
            }
            
            if let fImg = image {
                //self.imgWidth.constant = fImg.size.width/2
                //self.imgView.widthAnchor.constraint(equalToConstant: fImg.size.width/2).isActive = true
                
                if isInCache.boolValue {
                    self.imgView.image = fImg
                }
                else {
                    self.imgView.alpha = 0
                    self.imgView.image = fImg
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.imgView.alpha = 1
                    }, completion: nil)
                }
                
                self.imgView.widthAnchor.constraint(equalToConstant: (40.0 * fImg.size.width/2) / (fImg.size.height/2) ).isActive = true
                
                // 정렬 확인
                switch module.viewType {
                case "BAN_IMG_F80_L_GBA": //좌측정렬
                    self.imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
                    break
                case "BAN_IMG_F80_C_GBA": //가운데정렬
                    self.imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    break
                case "BAN_IMG_F80_R_GBA": //우측정렬
                    self.imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10.0).isActive = true
                    break
                default:
                    self.imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
                }
                
                
            }//if let fImg
        }
        
    }
    
}
