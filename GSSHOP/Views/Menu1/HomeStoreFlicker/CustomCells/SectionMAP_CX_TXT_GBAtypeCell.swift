//
//  SectionMAP_CX_TXT_GBAtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 09/07/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionMAP_CX_TXT_GBAtypeCell: UITableViewCell {

    
    @IBOutlet weak var imgCard : UIImageView!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblCardName : UILabel!
    @IBOutlet weak var viewCardInfo : UIView!
    @IBOutlet weak var viewCardInfoLine : UIView!
    @IBOutlet weak var cardViewHeigth : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imgCard.image = nil
        self.lblDate.text = ""
        self.lblCardName.text = ""
        self.viewCardInfo.isHidden = true
        for sub in self.viewCardInfoLine.subviews {
            sub.removeFromSuperview()
        }
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let product = Module(JSON: rowinfoDic) else { return }
        
        // 카드 할인 정보 설정 : XX카드 & 즉시할인
        let prdName = product.productName
        // prdName = "XX카드. & 즉시할인"
        let arrCardString = prdName.components(separatedBy: "&")
        if arrCardString.count >= 2 {
            let discountColor = UIColor.getColor(product.etcText1)
            
            let textValue: [NSAttributedString.Key: Any] = [
                .font : UIFont.systemFont(ofSize: 20),
                .foregroundColor : UIColor.getColor("111111")
            ]
            
            let discountValue: [NSAttributedString.Key: Any] = [
                .font : UIFont.systemFont(ofSize: 26),
                .foregroundColor : discountColor
            ]
            
            let discountValue2: [NSAttributedString.Key: Any] = [
                .font : UIFont.systemFont(ofSize: 26),
                .foregroundColor :discountColor
            ]
            
            let name = NSMutableAttributedString(string: arrCardString.first ?? "", attributes: textValue)
            let discount = NSMutableAttributedString(string: String(product.discountRate), attributes: discountValue)
            let discountText = NSMutableAttributedString(string: product.discountRateText, attributes: discountValue2)
            let info = NSMutableAttributedString(string: arrCardString.last ?? "", attributes: textValue)
            
            name.append(discount)
            name.append(discountText)
            name.append(info)
            
            self.lblCardName.attributedText = name
        }
        
        
        // 날짜 설정
        self.lblDate.text = product.promotionName
        
        // 카드 이미지 설정
        let imageUrl = product.imageUrl
        if imageUrl.hasPrefix(Const.Text.http.rawValue) {
            ImageDownManager.blockImageDownWithURL(imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                if isInCache == true {
                    self.imgCard.image = fetchedImage
                    return
                }
                
                self.imgCard.alpha = 0
                self.imgCard.image = fetchedImage
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                                self.imgCard.alpha = 1
                }, completion: nil)
            }
        }
        
        // accessibilityLabel 설정
        self.accessibilityLabel = String(format: "%@ %@ ", self.lblDate.text ?? "", self.lblCardName.text ?? "")
        
        // 전날 / 다음날 카드할인 정보 설정
        DispatchQueue.main.async {
            let subProductList = product.subProductList
            if subProductList.count > 0 {
                self.viewCardInfo.isHidden = false
                
                for (index, card) in subProductList.enumerated() {
                    self.makeCardInfoView(card, total: subProductList.count, position: index)
                }
            } else {
                self.viewCardInfo.isHidden = true
            }
            
            self.layoutIfNeeded()
        }
    }
    
    /// 카드 할인정보 view 설정
    private func makeCardInfoView(_ viewInfo: Module, total: Int, position: Int) {
        //1개일땐 2픽셀, 2개일땐 3픽셀, 3개일땐 4픽셀
        
        let count = CGFloat(total)
        let pos = CGFloat(position)
        
        let cardWidth: CGFloat = (self.viewCardInfoLine.frame.width - (count + 1)) / count
        let cardTotalHeigth: CGFloat = self.viewCardInfoLine.frame.height - 2
        let startXpos = (pos == 0) ? 1 : (cardWidth * pos) + pos + 1
        
        let dateInfo = UILabel(frame: CGRect(x: startXpos, y: 1, width: cardWidth, height: 24) ) //상단 높이를 고정으로 가자..
        dateInfo.textAlignment = .center
        dateInfo.textColor = UIColor.getColor("999999")
        dateInfo.backgroundColor = .white
        dateInfo.font = UIFont.systemFont(ofSize: 15)
        dateInfo.text = viewInfo.promotionName
        self.viewCardInfoLine.addSubview(dateInfo)
        
        let cardInfo = UILabel(frame: CGRect(x: startXpos, y: dateInfo.frame.height + 2, width: cardWidth, height: cardTotalHeigth - dateInfo.frame.height - 1))
        cardInfo.textAlignment = .center
        cardInfo.backgroundColor = .white
        cardInfo.attributedText = self.makeCardInfoText(viewInfo)
        
        self.accessibilityLabel = String(format: "%@ %@ %@", self.accessibilityLabel ?? "", dateInfo.text ?? "", cardInfo.text ?? "")
        self.viewCardInfoLine.addSubview(cardInfo)
    }
    
    /// 카드 할인정보 Attributes 설정
    private func makeCardInfoText(_ viewInfo: Module) -> NSMutableAttributedString {
        let cardName: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.getColor("777777")
        ]
        let cardDiscount: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.getColor("777777")
        ]
        let name = viewInfo.productName
        let discount = viewInfo.discountRate
        let discountText = viewInfo.discountRateText
        
        let rValue1 = NSMutableAttributedString(string: name, attributes: cardName)
        let rValue2 = NSMutableAttributedString(string: String(discount), attributes: cardDiscount)
        let rValue3 = NSMutableAttributedString(string: discountText, attributes: cardDiscount)
        
        rValue1.append(rValue2)
        rValue1.append(rValue3)
        
        return rValue1
    }

}
