//
//  SectionBAN_SLD_GBFtypeSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 07/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_SLD_GBFtypeSubCell: UICollectionViewCell {
        
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var newImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var newImgWidth: NSLayoutConstraint!
    @IBOutlet weak var newImgHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setInitUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.setInitUI()
    }
    
    private func setInitUI() {        
        self.imgView.image = UIImage(named: Const.Image.noimg_280.name)
        self.imgView.layer.borderWidth = 1.0
        self.imgView.layer.borderColor = UIColor.getColor("000000", alpha: 0.05).cgColor
        self.titleLbl.text = ""
        self.priceLbl.text = ""
        self.unitLbl.text = ""
        self.newImgView.isHidden = true
        self.newImgView.image = nil
        self.newImgWidth.constant = 0
        self.newImgHeight.constant = 0
        
        self.accessibilityLabel = ""
        for view in self.stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    func setCellInfoNDrawData(_ product: Module) {
        // 접근성
        self.accessibilityLabel = product.productName
        
        // 이미지 설정
        ImageDownManager.blockImageDownWithURL(product.imageUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
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
        
        self.titleLbl.text = product.productName
        self.priceLbl.text = product.salePrice
        self.unitLbl.text = product.exposePriceText
        
        //해텍 처리 : 2개만 나오개 방어로직 -> 3개째 나타나면 UI가 깨짐..ㅠ
        let badges = product.imgBadgeCorner.RB
        if badges.count > 2 {
           var newBadge = [ImageInfo]()
            newBadge.append(badges[0])
            newBadge.append(badges[1])
            Common_NFXC.makeBenefitStack(newBadge, self.stackView)
        } else {
            Common_NFXC.makeBenefitStack(badges, self.stackView)
        }

        // New 딱지!!!
        if let newImgData = product.imgBadgeCorner.LT.first {
            ImageDownManager.blockImageDownWithURL(newImgData.imgUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                if error != nil || statusCode == 0 {
                    self.newImgView.isHidden = true
                    self.newImgView.image = nil
                    return
                }
                
                if let newImg = image {
                    self.newImgWidth.constant = newImg.size.width / 2
                    self.newImgHeight.constant = newImg.size.height / 2
                }
                
                self.newImgView.isHidden = false
                if isInCache == true {
                    self.newImgView.image = image
                } else {
                    self.newImgView.alpha = 0
                    self.newImgView.image = image
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.newImgView.alpha = 1
                    }, completion: nil)
                }
            }
        }
    }
}
