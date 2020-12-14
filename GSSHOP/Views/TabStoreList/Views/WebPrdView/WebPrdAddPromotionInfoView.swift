//
//  WebPrdAddPromotionInfoView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/04/06.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdAddPromotionInfoView: UIView {
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var iconImgView: UIImageView!
    /// 아이콘 이미지뷰 Width
    @IBOutlet weak var iconImgViewWidth: NSLayoutConstraint!
    /// 아이콘 이미지뷰 height
    @IBOutlet weak var iconImgViewHeight: NSLayoutConstraint!
    /// 이미지랑 텍스트 사이간격
    @IBOutlet weak var imgToTextMargin: NSLayoutConstraint!
    /// 라벨
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var linkImgView: UIImageView!
    
    @IBOutlet weak var linkImgViewWidth: NSLayoutConstraint!
    
    private var commonInfo: CommonInfo?
    
    private weak var aTarget: ResultWebViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImgViewWidth.constant = 20.0
        self.iconImgView.image = UIImage(named: Const.Image.ic_delivery_default.name)
    }
    
    func setData(_ data: CommonInfo, target: ResultWebViewController?) {
        self.commonInfo = data
        self.aTarget = target
        
        // 아이콘
        ImageDownManager.blockImageDownWithURL(data.iConUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
            if error != nil || statusCode == 0  || image == nil {
                return
            }
            
            self.imgToTextMargin.constant = 8.0
            // 20 x 20 사이즈로 고정하기로 함.
//            let width = self.makeRadioWidth(image?.size ?? CGSize(width: 0,height: 0), standardHeigth: self.iconImgViewHeight.constant)
//            self.iconImgViewWidth.constant = width < 20 ? 20 : width
            
            self.iconImgView.layoutIfNeeded()
            
            if isInCache == true {
                self.iconImgView.image = image
            } else {
                self.iconImgView.alpha = 0
                self.iconImgView.image = image
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.iconImgView.alpha = 1
                }, completion: nil)
            }
        }
        
        
        if data.linkUrl.isEmpty == false {
            self.linkImgView.isHidden = false
            self.linkImgViewWidth.constant = 24.0
        } else {
            self.linkImgView.isHidden = true
            self.linkImgViewWidth.constant = 0.0
        }
        
        let attributedString = NSMutableAttributedString(string: "")
        let minimumHeight: CGFloat = self.findMinimumLineHeight(data.pmoText)
        
        for textInfo in data.pmoText {

            let attrString = self.getAttributedString(withPrdTextInfo: textInfo)
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineBreakMode = .byWordWrapping
            style.minimumLineHeight = minimumHeight
            attributedString.addAttribute(
                .paragraphStyle, value: style,
                range: NSRange(location:0,
                               length: attributedString.length))
            
            attributedString.append(attrString)
        }

        self.textLbl.numberOfLines = 0
        self.textLbl.attributedText = attributedString
    }
    
    
    @IBAction func linkBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget, let data = self.commonInfo  {
            vc.dealPrdUrlAction(data.linkUrl, withParam: nil, loginCheck: false)
        }
    }
}
