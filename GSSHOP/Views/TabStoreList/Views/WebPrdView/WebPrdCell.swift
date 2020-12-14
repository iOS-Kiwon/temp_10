//
//  WebProCell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/03.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdCell: BaseCollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    /// 혜택 이미지들의 베이스 스텍뷰
    @IBOutlet weak var benefitBaseView: UIStackView!
    
    /// 현재 Cell의 IndexPath
    private var indexPath : IndexPath?
    /// 혜택뷰가 나타났는지 플레그
    private var isShowBenefit: Bool = false
    
    /// 해당Cell을 갖고 있는 부모뷰
    weak var parentView: WebPrdView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.benefitBaseView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = UIImage(named: Const.Image.img_noimage_375.name)
    }

    func setData(_ imgUrl: String, indexPath: IndexPath) {
        self.indexPath = indexPath
        // 접근성
        //self.accessibilityLabel = product.productName
        
        // 이미지 설정
        ImageDownManager.blockImageDownWithURL(imgUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
            if error != nil || statusCode == 0 {
                self.imgView.image = UIImage(named: Const.Image.img_noimage_375.name)
                return
            }
            
            if isInCache == true {
                self.imgView.image = image
                if let indexPath = self.indexPath, indexPath.row == 0 {
                    self.parentView?.prevCachingImgView.isHidden = true
                }
            } else {
                self.imgView.alpha = 0
                self.imgView.image = image

                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.imgView.alpha = 1
                }) { (_) in
                    if let indexPath = self.indexPath, indexPath.row == 0 {
                        self.parentView?.prevCachingImgView.isHidden = true
                    }
                }
            }
        }
    }
    
    func setBenefits(urls: [String]) {
        if urls.count <= 0 || self.isShowBenefit {
            self.benefitBaseView.isHidden = true
            return
        }
        
        self.benefitBaseView.isHidden = false
        self.isShowBenefit = true
        for urlStr in urls {
            
            let tempImgView = UIImageView()
            
            // 이미지 설정
            ImageDownManager.blockImageDownWithURL(urlStr as NSString) { (statusCode, image, imgURL, isInCache, error) in
                guard let benefitImg = image else { return }
                if error != nil || statusCode == 0 {
                    return
                }
                
                if isInCache == true {
                    tempImgView.image = benefitImg
                } else {
                    tempImgView.alpha = 0
                    tempImgView.image = benefitImg
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        tempImgView.alpha = 1
                    }, completion: nil)
                }
                let width = benefitImg.size.width / benefitImg.size.height * 24.0 // 24 고정높이로 width 비율적용
                tempImgView.widthAnchor.constraint(equalToConstant: width).isActive = true
                self.benefitBaseView.addArrangedSubview(tempImgView)
            }
            
        }
    }
    
}
