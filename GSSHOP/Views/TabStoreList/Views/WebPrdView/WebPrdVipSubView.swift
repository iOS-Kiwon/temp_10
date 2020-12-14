//
//  WebPrdVipSubView.swift
//  GSSHOP
//
//  Created by Home on 04/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdVipSubView: UIView {
    
    /// 등급 아이콘 이미지뷰
    @IBOutlet weak var gradeImgView: UIImageView!
    /// 등급 정보 라벨
    @IBOutlet weak var gradeTextLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ data: GradePmoInfo) {
        
        if data.gradeImgUrl.isEmpty || data.gradeImgUrl.hasPrefix("http") == false {
            self.setDefaultGradeImage(data: data)
        } else {
            
            // 아이콘
            ImageDownManager.blockImageDownWithURL(data.gradeImgUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                if error != nil || statusCode == 0 {
                    self.setDefaultGradeImage(data: data)
                    return
                }
                
                if isInCache == true {
                    self.gradeImgView.image = image
                } else {
                    self.gradeImgView.alpha = 0
                    self.gradeImgView.image = image
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.gradeImgView.alpha = 1
                    }, completion: nil)
                }
            }
        }
        
        let attributedString = NSMutableAttributedString()
        for textInfo in data.gradeTextInfo {
            attributedString.append(self.getAttributedString(withPrdTextInfo: textInfo))
        }
//        attributedString.setMinimumLineHeight(20.0)
        self.gradeTextLbl.attributedText = attributedString
    }
    
    
    private func setDefaultGradeImage(data: GradePmoInfo) {
        if let firstData = data.gradeTextInfo.first {
            
            if "GOLD " == firstData.textValue {
                self.gradeImgView.image = UIImage(named: Const.Image.ic_grade_gold.name)
            } else if "VIP " == firstData.textValue {
                self.gradeImgView.image = UIImage(named: Const.Image.ic_grade_vip.name)
            } else if "VVIP " == firstData.textValue {
                self.gradeImgView.image = UIImage(named: Const.Image.ic_grade_vvip.name)
            }
        }
    }
}
