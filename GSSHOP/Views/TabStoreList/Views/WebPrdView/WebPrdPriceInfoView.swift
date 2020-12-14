//
//  WebPrdPriceInfoView.swift
//  GSSHOP
//
//  Created by Home on 05/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdPriceInfoView: UIView {

    @IBOutlet weak var dotLbl: UILabel!
    
    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(_ dataList: [PrdTextInfo]) {
        
        let minimumHeight: CGFloat = self.findMinimumLineHeight(dataList)

        
        let attributedString = NSMutableAttributedString(string: "")

        for textInfo in dataList {
            if textInfo.textValue.isEmpty {
                continue
            }
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineBreakMode = .byWordWrapping
            style.minimumLineHeight = minimumHeight
            attributedString.addAttribute(
                .paragraphStyle, value: style,
                range: NSRange(location:0,
                               length: attributedString.length))
            
            let attrString = self.getAttributedString(withPrdTextInfo: textInfo)
            attributedString.append(attrString)
        }

        self.textLbl.numberOfLines = 0
        self.textLbl.attributedText = attributedString
        
        let dotAttributedString = NSMutableAttributedString(string: "•", attributes:[
            .font : UIFont.systemFont(ofSize: 12.0),
            .foregroundColor : UIColor.getColor("111111", alpha: 0.48)
        ])
        let dotStyle = NSMutableParagraphStyle()
        dotStyle.alignment = .center
        dotStyle.lineBreakMode = .byCharWrapping
        dotStyle.minimumLineHeight = minimumHeight
        dotAttributedString.addAttribute(
            .paragraphStyle, value: dotStyle, range: NSRange(location:0, length: 1))
        dotLbl.attributedText = dotAttributedString
        
    }
}
