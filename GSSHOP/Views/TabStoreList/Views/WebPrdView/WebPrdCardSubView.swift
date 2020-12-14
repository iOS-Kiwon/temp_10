//
//  WebPrdCardSubView.swift
//  GSSHOP
//
//  Created by Home on 06/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdCardSubView: UIView {

    /// 카드혜택 라벨
    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ data: CardInfo) {
        setPmoTextUI(data.pmoText)
        
        setPmoPriceUI(data.pmoPrc)
        
        setAttributeStyle(pmoText: data.pmoText, pmoPrc: data.pmoPrc)
    }

    /// 카드 할인정보 TextInfo 설정
    private func setPmoTextUI(_ dataList: [PrdTextInfo]) {
        let attributedString = NSMutableAttributedString()
        for textInfo in dataList {
            if textInfo.textValue.isEmpty {
                continue
            }
            attributedString.append(self.getAttributedString(withPrdTextInfo: textInfo))
        }
        self.textLbl.attributedText = attributedString
    }
    
    /// 카드 가격정보 TextInfo 설정
    private func setPmoPriceUI(_ dataList: [PrdTextInfo]) {
        if dataList.count <= 0 {
            return
        }

        let attributedString = NSMutableAttributedString()
        for textInfo in dataList {
            if textInfo.textValue.isEmpty {
                continue
            }
            attributedString.append(self.getAttributedString(withPrdTextInfo: textInfo))
        }

        if let attr = self.textLbl.attributedText {
            let mutableAttr = NSMutableAttributedString(attributedString: attr)
            mutableAttr.append(attributedString)
            self.textLbl.attributedText = mutableAttr
        } else {
            self.textLbl.attributedText = attributedString
        }
    }
    
    /// 라벨 속성 스타일 추가
    private func setAttributeStyle(pmoText: [PrdTextInfo], pmoPrc: [PrdTextInfo]) {
        guard let text = self.textLbl.attributedText else { return }
        let attributedString = NSMutableAttributedString(attributedString: text)
        
        var pmoTextHeight = self.findMinimumLineHeight(pmoText)
        let pmoPrcHeight = self.findMinimumLineHeight(pmoPrc)
        
        if pmoTextHeight < pmoPrcHeight {
            pmoTextHeight = pmoPrcHeight
        }
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byCharWrapping
        style.minimumLineHeight = pmoTextHeight
        attributedString.addAttribute(
            .paragraphStyle, value: style, range: NSRange(location:0, length: attributedString.length))
    }
}
