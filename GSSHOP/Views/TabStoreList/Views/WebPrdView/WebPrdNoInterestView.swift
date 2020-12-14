//
//  WebPrdNoInterestView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/03/09.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdNoInterestView: UIView {
    
    @IBOutlet weak var lineView: UIView!

    @IBOutlet weak var iconImgView: UIImageView!
    /// 무이자 정보 라벨
    @IBOutlet weak var textLbl: UILabel!
    /// 링크 이미지뷰
    @IBOutlet weak var linkImgView: UIImageView!
    /// 링크 이미지 Width
    @IBOutlet weak var linkImgViewWidth: NSLayoutConstraint!
    /// 링크 버튼
    @IBOutlet weak var linkBtn: UIButton!
    /// 뷰 타겟 - ResultWebViewController
    private weak var aTarget: ResultWebViewController?
    /// 무이자 데이터 객체
    private var component: Components?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImgView.image = UIImage(named: Const.Image.ic_nointerest.name)
    }
    
    func setData(_ data: Components, target: ResultWebViewController?) {
        self.component = data
        self.aTarget = target
        
        // 무이자 아이콘
        if data.iConImgUrl.isEmpty == false {
            
            ImageDownManager.blockImageDownWithURL( data.iConImgUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                if error != nil || statusCode == 0 {
                    return
                }
                
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
        }
        
        // 상세 링크 노출여부
        if data.addInfoUrl.isEmpty == false {
            self.linkImgView.image = UIImage(named: Const.Image.ic_arrow_right_24.name)
            self.linkImgViewWidth.constant = 24.0
            self.linkBtn.isEnabled = true
        } else {
            self.linkImgView.image = nil
            self.linkImgViewWidth.constant = 0.0
            self.linkBtn.isEnabled = false
        }
        
        let attributedString = NSMutableAttributedString(string: "")
        let minimumHeight: CGFloat = self.findMinimumLineHeight(data.interestTxt)

        for textInfo in data.interestTxt {
            
            let attrString = self.getAttributedString(withPrdTextInfo: textInfo)
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineBreakMode = .byWordWrapping
            style.minimumLineHeight = minimumHeight < 20 ? 20 : minimumHeight
            attrString.addAttribute(
                .paragraphStyle, value: style,
                range: NSRange(location:0,
                               length: attrString.length))
            attributedString.append(attrString)            
        }
        
        self.textLbl.numberOfLines = 0
        self.textLbl.attributedText = attributedString
    }

    @IBAction func linkBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget, let data = self.component {
            vc.dealPrdUrlAction(data.addInfoUrl, withParam: nil,loginCheck: false)
            vc.sendAmplitudeAndMseq(withAction: "구매/배송_무이자")
        }
    }
}
