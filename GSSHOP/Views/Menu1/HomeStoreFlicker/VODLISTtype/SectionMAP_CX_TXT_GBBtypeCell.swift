//
//  SectionMAP_CX_TXT_GBBtypeCellTableViewCell.swift
//  GSSHOP
//
//  Created by admin on 28/08/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionMAP_CX_TXT_GBBtypeCell: UITableViewCell {
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var lbTitleInfo: UILabel!
    @IBOutlet weak var lbDateInfo: UILabel!
    @IBOutlet weak var lbInfo: UILabel!    
    @IBOutlet weak var viewCardInfo: UIView!
    
    @IBOutlet weak var viewOneCard: UIView!
    @IBOutlet weak var lbOneCardInfo: UILabel!
    
    @IBOutlet weak var viewTwoCard: UIView!
    @IBOutlet weak var lbTwoCardInfo_1: UILabel!
    @IBOutlet weak var lbTwoCardInfo_2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lbTwoCardInfo_2.text = ""
        self.lbTwoCardInfo_1.text = ""
        self.lbOneCardInfo.text = ""
        self.lbTitleInfo.text = ""
        self.lbDateInfo.text = ""
        self.viewOneCard.isHidden = true
        self.viewTwoCard.isHidden = true
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let product = Module(JSON: rowinfoDic) else { return }
        
        self.lbTitleInfo.text = product.productName
        self.lbDateInfo.text = product.promotionName
        
        let subProductList = product.subProductList
        
        if subProductList.count == 1 {
            self.viewOneCard.isHidden = false
            self.viewTwoCard.isHidden = true
            self.lbOneCardInfo.attributedText = self.makeInfoText(subProductList[0])
            self.viewCardInfo.addSubview(self.viewOneCard)
        }
        else if subProductList.count >= 2 { // 최대 2개
            self.viewOneCard.isHidden = true
            self.viewTwoCard.isHidden = false
            self.lbTwoCardInfo_1.attributedText = self.makeInfoText(subProductList[0])
            self.lbTwoCardInfo_2.attributedText = self.makeInfoText(subProductList[1])
            
            self.viewCardInfo.addSubview(self.viewTwoCard)
        }
        else {
            // 아마 0 or 마이너스?
        }
        
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
        
        
        var infoTextSize: CGFloat = 18.0
        var discountTextSize: CGFloat = 24.0
        var discountTextCalcSize: CGFloat = 18.0
        if isiPhone5() {
            infoTextSize = 16.0
            discountTextSize = 20.0
            discountTextCalcSize = 16.0
        }
        
        let infoText = NSMutableAttributedString(string: text1 + " ", attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-Regular", size: infoTextSize)!,
            .foregroundColor: UIColor(white: 17.0 / 255.0, alpha: 1.0),
            .kern: -0.27
            ])
        let discountText = NSMutableAttributedString(string: String(subProduct.discountRate), attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-Regular", size: discountTextSize)!,
            .foregroundColor: UIColor.getColor(subProduct.etcText1),
            .kern: -0.29
            ])
        let discountTextCalc = NSMutableAttributedString(string: subProduct.discountRateText, attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-Regular", size: discountTextCalcSize)!,
            .foregroundColor: UIColor.getColor(subProduct.etcText1),
            .kern: -0.29
            ])
        discountText.append(discountTextCalc)
        infoText.append(discountText)
        if text2.count > 0 {
            let addInfoText = NSMutableAttributedString(string: " " + text2, attributes: [
                .font: UIFont(name: "AppleSDGothicNeo-Regular", size: infoTextSize)!,
                .foregroundColor: UIColor(white: 17.0 / 255.0, alpha: 1.0),
                .kern: -0.27
                ])
            infoText.append(addInfoText)
        }
        
        return infoText
    }
    
    
    
    
}
