//
//  WebPrdCouponView.swift
//  GSSHOP
//
//  Created by Home on 27/02/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdCouponView: UIView {
    
    private static let DEFAULT_COUPON_LABEL_HEIGHT: CGFloat = 20.0
    
    @IBOutlet weak var leftTextLbl: UILabel!
    
    @IBOutlet weak var rightTextLbl: UILabel!
    /// 오른쪽 쿠폰다운로드 뷰의 Width
    @IBOutlet weak var rightViewWidth: NSLayoutConstraint!
    
    private var couponData: Components?
    private weak var aTarget: ResultWebViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.rightTextLbl.frame.width > 93.0 {
            self.rightViewWidth.constant = 148.0
        } else {
            self.rightViewWidth.constant = 142.0
        }
        self.layoutIfNeeded()
    }
    
    func setData(_ data: Components, target: ResultWebViewController? = nil) {
        self.couponData = data
        self.aTarget = target
        
        setCouponLeftText(data.pmoText)
        setCouponRightText(data.pmoPrc)
    }
    
    
    private func setCouponLeftText(_ dataList: [PrdTextInfo]) {
        if dataList.count <= 0 {
            self.leftTextLbl.text = ""
            return
        }
        
        let attributedString = NSMutableAttributedString(string: "")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping
        style.minimumLineHeight = self.findMinimumLineHeight(dataList)
        attributedString.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: attributedString.length))
        
        for data in dataList {
            let fontSize: CGFloat = isiPhone5() ? 12.0 : CGFloat(NSString(string: data.fontSize).floatValue)
            let attrString = self.getAttributedString(withPrdTextInfo: data, fontSize: fontSize)
            attributedString.append(attrString)
        }
        
        self.leftTextLbl.attributedText = attributedString
    }

    
    private func setCouponRightText(_ dataList: [PrdTextInfo]) {

        if dataList.count <= 0 {
            self.rightTextLbl.text = ""
            return
        }
        
        let attributedString = NSMutableAttributedString(string: "")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping
        style.minimumLineHeight = self.findMinimumLineHeight(dataList)
        attributedString.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: attributedString.length))
        
        for data in dataList {
            let fontSize: CGFloat = isiPhone5() ? 12.0 : CGFloat(NSString(string: data.fontSize).floatValue)
            let attrString = self.getAttributedString(withPrdTextInfo: data, fontSize: fontSize)
            attributedString.append(attrString)
        }

        self.rightTextLbl.attributedText = attributedString
    }
    
    @IBAction func downBtnAction(_ sender: UIButton) {
        if let data = self.couponData, data.pmoUrl.isEmpty == false {
            
            /// 다운로드 링크 이동
            self.aTarget?.dealPrdUrlAction(data.pmoUrl, withParam: "",loginCheck: false)
        }
    }
}
