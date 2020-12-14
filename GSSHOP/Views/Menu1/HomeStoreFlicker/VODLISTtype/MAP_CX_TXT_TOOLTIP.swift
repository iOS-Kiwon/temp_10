//
//  MAP_CX_TXT_TOOLTIP.swift
//  GSSHOP
//
//  Created by admin on 28/08/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class MAP_CX_TXT_TOOLTIP: UIView {
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewBackGroundHeight: NSLayoutConstraint!
    @IBOutlet weak var lbTitleInfo: UILabel!
    @IBOutlet weak var lbDateInfo: UILabel!
    @IBOutlet weak var lbCard1: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lbCard2: UILabel!
    @IBOutlet weak var leadingMargin: NSLayoutConstraint! // 중앙렬 간격조정.
    @IBOutlet weak var bottomMargin: NSLayoutConstraint! // 하단 간격 조정
    
    @objc var aTarget: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBackGroundHeight.constant = 1.0 //처음엔 숨깁니다.
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // draw 시점에 코너 모서리 처리를 해야 양쪽다 잘따진다. ㅠ_- awakeFromNib여따 넣음 안됨... ㅠㅠㅠ 왼쪽만 됨 ㅠㅠㅠㅠㅠㅠ
        Common_Util.cornerRadius(self.viewBackGround, byRoundingCorners:[.topLeft, .topRight], cornerSize: 4.0)        
        self.bottomMargin.constant = APPTABBARHEIGHT()
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        guard let method = self.aTarget?.closeTooltip else { return }
        method()
    }
    
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let product = Module(JSON: rowinfoDic) else { return }
    
        
        self.lbTitleInfo.text = product.productName
        self.lbDateInfo.text = product.promotionName
        self.lbDateInfo.sizeToFit()
        
        let subProductList = product.subProductList
        
        if subProductList.count == 1 {
            self.lbCard1.isHidden = false
            self.lbCard2.isHidden = true
            self.viewLine.isHidden = true
            self.lbCard1.attributedText = self.makeInfoText(product.subProductList[0])
            self.lbCard1.sizeToFit()
            self.leadingMargin.constant = ( (getAppFullWidth() - 20) - (self.lbDateInfo.frame.width + 10 + self.lbCard1.frame.width))/2
        }
        else if subProductList.count >= 2 { // 최대 2개
            self.lbCard1.isHidden = false
            self.lbCard2.isHidden = false
            self.viewLine.isHidden = false
            self.lbCard1.attributedText = self.makeInfoText(subProductList[0])
            self.lbCard2.attributedText = self.makeInfoText(subProductList[1])
            self.lbCard1.sizeToFit()
            self.lbCard2.sizeToFit()
//            self.leadingMargin.constant = ( (getAppFullWidth() - 20) - (self.lbDateInfo.frame.width + 10 + self.lbCard1.frame.width + 10 + 1 + 10 + self.lbCard2.frame.width) )/2
        }
        else {
            // 아마 0 or 마이너스?
        }
        
        self.layoutIfNeeded()
    }
    
    
    func makeInfoText(_ subProduct:Module ) -> NSMutableAttributedString {
        var text1:String = "" ,text2:String = ""
        let arrCardString = subProduct.productName.components(separatedBy: "&")
        if arrCardString.count >= 2 {
            text1 = arrCardString[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            text2 = arrCardString[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        else if arrCardString.count == 1 {
            text1 = subProduct.productName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        else {
            
        }
        
        var textColor = UIColor.white
        if !subProduct.etcText1.isEmpty && subProduct.etcText1.count == 6 {
            textColor = UIColor.getColor(subProduct.etcText1)
        }
        
        var infoTextSize: CGFloat = 16.0
        var discountTextSize: CGFloat = 22.0
        var discountTextCalcSize: CGFloat = 16.0
        if isiPhone5() {
            infoTextSize = 13.0
            discountTextSize = 17.0
            discountTextCalcSize = 13.0
        }
        
        let infoText = NSMutableAttributedString(string: text1 + " " , attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-Regular", size: infoTextSize)!,
            .foregroundColor: textColor,
            .kern: -0.17
            ])
        let discountText = NSMutableAttributedString(string: String(subProduct.discountRate), attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-Regular", size: discountTextSize)!,
            .foregroundColor: textColor
            ])
        let discountTextCalc = NSMutableAttributedString(string: subProduct.discountRateText, attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-Regular", size: discountTextCalcSize)!,
            .foregroundColor: textColor,
            .kern: -0.17
            ])
        discountText.append(discountTextCalc)
        infoText.append(discountText)
        
        
        if text2.count > 0 {
            let addInfoText = NSMutableAttributedString(string: " " + text2 , attributes: [
                .font: UIFont(name: "AppleSDGothicNeo-Regular", size: infoTextSize)!,
                .foregroundColor: textColor,
                .kern: -0.17
                ])
            infoText.append(addInfoText)
        }
        
        return infoText
    }

}
