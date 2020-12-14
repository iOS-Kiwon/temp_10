//
//  WebPrdDeliverySubView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/04/08.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdDeliverySubView: UIView {

    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var iconImgView: UIImageView!
    
    @IBOutlet weak var iconImgViewWidth: NSLayoutConstraint!
    /// 아이콘 이미지뷰 높이
    @IBOutlet weak var iconImgViewHeight: NSLayoutConstraint!
    /// 이미지랑 텍스트 사이간격
    @IBOutlet weak var imgToTextMargin: NSLayoutConstraint!
    
    private weak var aTarget: ResultWebViewController?
    private var linkUrlStr: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImgViewWidth.constant = 0.0
        self.iconImgViewHeight.constant = 15.0
        self.imgToTextMargin.constant = 0.0
    }

    //return으로 Add여부를 결정한다.
    func setData(_ dataList: [PrdTextInfo], target: ResultWebViewController? = nil, linkUrl: String, imageUrlStr: String) -> Bool {
        self.aTarget = target
        self.linkUrlStr = linkUrl
        
        // 아이콘
        ImageDownManager.blockImageDownWithURL(imageUrlStr as NSString) { (statusCode, image, imgURL, isInCache, error) in
            if error != nil || statusCode == 0  || image == nil {
                self.imgToTextMargin.constant = 0.0
                self.iconImgViewWidth.constant = 0.0
                self.iconImgViewHeight.constant = 0.0
                self.iconImgView.image = nil
                self.iconImgView.layoutIfNeeded()
                return
            }
            
            self.imgToTextMargin.constant = 8.0
            self.iconImgViewWidth.constant = self.makeRadioWidth(image?.size ?? CGSize(width: 0,height: 0),standardHeigth: self.iconImgViewHeight.constant)
            
            self.layoutIfNeeded()
            
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
        
        let attributedString = NSMutableAttributedString(string: "")
        let minimumHeight: CGFloat = self.findMinimumLineHeight(dataList)
        
        if minimumHeight <= 0 {
            return false
        }
        
        for textInfo in dataList {
            if textInfo.textValue.isEmpty {
                continue
            }
            let attrString = self.getAttributedString(withPrdTextInfo: textInfo)
            attributedString.append(attrString)
            
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineBreakMode = .byWordWrapping
            style.minimumLineHeight = minimumHeight > 20.0 ? minimumHeight : 20.0
            attributedString.addAttribute(
                .paragraphStyle, value: style,
                range: NSRange(location:0,
                               length: attributedString.length))
        }

        self.textLbl.numberOfLines = 0
        self.textLbl.attributedText = attributedString
        
        
        if linkUrl.isEmpty == false {
            let imageAttachment = NSTextAttachment()
            if let image = UIImage(named: Const.Image.ic_arrow_right_20.name) {
                imageAttachment.image = image
                let posY = (self.textLbl.font.capHeight - image.size.height).rounded() / 2
                imageAttachment.bounds = CGRect(x: -5, y: posY, width: 20, height: 20)
                attributedString.append(NSAttributedString(attachment: imageAttachment))
                self.textLbl.attributedText = attributedString
            }
        }
        
        return true
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        if let vc = self.aTarget {
            vc.dealPrdUrlAction(self.linkUrlStr, withParam: nil, loginCheck: false)
            vc.sendAmplitudeAndMseq(withAction: "구매/배송_묶음배송")
            
        }
    }
}
