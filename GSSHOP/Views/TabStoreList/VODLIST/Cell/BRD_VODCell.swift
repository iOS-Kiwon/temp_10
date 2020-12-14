//
//  BRD_VODCell.swift
//  GSSHOP
//
//  Created by gsshop iOS on 29/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class BRD_VODCell: UITableViewCell {

    @objc var aTarget : AnyObject?
    @objc var path : NSIndexPath?
    private var dicAll = Module()
    private var dicRow = Module()
    private var dicPGM = Module()
    private var dicOrdInfo = DirectOrdInfo()
    private var imageURL : String = ""
    private var strPosterUrl : String = ""

    
    @IBOutlet weak var view_Default : UIView!                              //셀 베이스뷰
    @IBOutlet weak var imgThumbnail : UIImageView!                         //썸네일 이미지뷰
    @IBOutlet weak var promotionNameLabel : UILabel!                       //프로모션이 있을경우 프로모션
    @IBOutlet weak var productTitleLabel : UILabel!                        //상품 이름
    @IBOutlet weak var discountRateLabel : UILabel!                        //할인율
    @IBOutlet weak var gsPriceLabel : UILabel!                             //GS 가격
    @IBOutlet weak var gsPriceWonLabel : UILabel!                          //GS 가격 옆 원
    @IBOutlet weak var originalPriceLabel : UILabel!                       //원래가격
    @IBOutlet weak var originalPriceWonLabel : UILabel!                    //원래가격 옆 원
    @IBOutlet weak var originalPriceLine : UIView!                         //원래가격 중앙선
    @IBOutlet weak var lconstBasePriceLeading : NSLayoutConstraint!
    @IBOutlet weak var viewBottomSpace : NSLayoutConstraint!                 //하단 여백 설정값 외부에서 지정한다.
    @IBOutlet weak var lblPerMonth : UILabel!
    @IBOutlet weak var lconstPerMonthMargine : NSLayoutConstraint!
    @IBOutlet weak var lblLeftTime : UILabel!
    @IBOutlet weak var btnLeftTime : UIButton!
    @IBOutlet weak var viewImageArea : UIView!
    @IBOutlet weak var imgTagLive : UIImageView!
    @IBOutlet weak var imgTagMyShop : UIImageView!
    @IBOutlet weak var viewLeftTime : UIView!
    @IBOutlet weak var viewTopPromotion : UIView!
    @IBOutlet weak var view_dorder : UIView!
    @IBOutlet weak var btn_dorder : UIButton!
    @IBOutlet weak var btn_dordertxt : UILabel!
    @IBOutlet weak var lblBenefit : UILabel!
    @IBOutlet weak var lblReview : UILabel!
    @IBOutlet weak var btn_TVTOP : UIButton!;
    @IBOutlet weak var btn_TVLink : UIButton!;
    @IBOutlet weak var btn_TVLinkPriceArea : UIButton!;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewImageArea.layer.borderColor = UIColor.init(red: 17.0/255.0, green: 17.0/255.0, blue: 17.0/255.0, alpha: 0.06).cgColor
        self.viewImageArea.layer.borderWidth = 1.0
        
        self.viewLeftTime.layer.cornerRadius = self.viewLeftTime.frame.size.height/2.0
        self.viewLeftTime.layer.shouldRasterize = true
        self.viewLeftTime.layer.rasterizationScale = UIScreen.main.scale
        self.lblLeftTime.font = UIFont.monospacedDigitSystemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        self.view_dorder.layer.cornerRadius = 2.0;
        self.view_dorder.layer.shouldRasterize = true;
        self.view_dorder.layer.rasterizationScale = UIScreen.main.scale;
        
        // 상품이미지뷰 테두리
        self.imgThumbnail.setBorder(width: 1.0, color:"000000")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //parksegun : iOS 10에서 라운드 깨지는 현상 수정
    func viewTopRound() {
        self.viewTopPromotion.layer.mask = nil
        self.viewTopPromotion.layoutIfNeeded()
        Common_Util.cornerRadius(self.viewTopPromotion, byRoundingCorners: [.topRight,.bottomRight], cornerSize: self.viewTopPromotion.frame.size.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellScreenDefine()
    }
    
    func cellScreenDefine(){
        self.imgThumbnail.isHidden = false
        self.imgThumbnail.image = nil;
        self.originalPriceLine.isHidden = true
        self.gsPriceLabel.text = ""
        self.gsPriceWonLabel.isHidden = true
        self.originalPriceLabel.text = ""
        self.originalPriceWonLabel.isHidden = true
        self.discountRateLabel.isHidden = true
        self.discountRateLabel.text = ""
        self.productTitleLabel.text = ""
        self.promotionNameLabel.text = ""
        self.promotionNameLabel.attributedText = NSAttributedString.init(string: "")
        self.lblPerMonth.text = ""
        self.viewTopPromotion.layer.mask = nil
    }
    
    @objc func setDivider(height : CGFloat) {
        self.viewBottomSpace.constant = height
    }
    
    @objc func setCellInfoNDrawData(infoDic : Dictionary<String, Any> ){

        let strAccess : NSMutableString  = NSMutableString.init(string: "")
        
        guard let product = Module(JSON: infoDic) else { return }
        self.dicAll = product
        self.backgroundColor = UIColor.clear
        
        let subProductList = product.subProductList

        if (subProductList.count  > 1) {
            self.dicPGM = subProductList[1]
        }
        else {
            self.dicPGM.productName = ""
        }
    
        if (subProductList.count  > 0) {
            self.dicRow = subProductList[0]
        }
        else {
            return
        }
        
        self.cellScreenDefine()
        
        self.lblLeftTime.text = self.dicRow.videoTime
        self.strPosterUrl = self.dicAll.imageUrl
        
        if !self.strPosterUrl.isEmpty {
            ImageDownManager.blockImageDownWithURL(self.strPosterUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                if error == nil, self.strPosterUrl == strInputURL, let image = fetchedImage {
                    DispatchQueue.main.async {
                        if isInCache.boolValue {
                            self.imgThumbnail.image = image
                        } else {
                            self.imgThumbnail.alpha = 0
                            self.imgThumbnail.image = image
                            
                            UIView.animate(withDuration: 0.2,
                                           delay: 0.0,
                                           options: .curveEaseInOut,
                                           animations: {
                                            self.imgThumbnail.alpha = 1
                            }, completion: nil)
                        }
                    }// DispatchQueue
                }
            }// ImageDownManager
        }
        
        if product.subProductList.count > 0, let subPrd = product.subProductList.first {
            self.dicOrdInfo = subPrd.directOrdInfo
            let ordText : String  = self.dicOrdInfo.text
            if ordText.count > 0  {
                self.view_dorder.isHidden = false
                self.btn_dordertxt.text = ordText
                if(ordText == "구매하기") {
                    self.btn_dorder.accessibilityLabel = "현재 생방송중인 상품 구매하기"
                }
            }else{
                self.view_dorder.isHidden = true;
            }
            
        }else{
            self.view_dorder.isHidden = true;
        }
        
        self.view_dorder.layoutIfNeeded()
        self.productTitleLabel.attributedText = Common_Util.attributedProductTitle(self.dicRow.toJSON(), titleKey: "productName")
        self.lblReview.attributedText = Common_Util.attributedReview(self.dicRow.toJSON(), isWidth320Cut: true)
        let widthLblBenefit : CGFloat = getAppFullWidth() - (16.0 + 10.0 + self.view_dorder.frame.size.width + 16.0)
        
        self.lblBenefit.attributedText = Common_Util.attributedBenefitString(self.dicRow.toJSON(), widthLimit: widthLblBenefit, lineLimit: 2, fontSize: 14.0)
    
        let boldTextAttr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0),NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let normalTextAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),NSAttributedString.Key.foregroundColor: UIColor.white]
    
        let pipeTextAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),NSAttributedString.Key.foregroundColor: UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.2)]
        
        let strBroadTime : String = self.dicRow.promotionName
        let strAttr = NSMutableAttributedString(string: strBroadTime, attributes:normalTextAttr)

        let regex = try? NSRegularExpression(pattern: "[0-9:]", options: .caseInsensitive)
        let range = NSMakeRange(0, strBroadTime.count)
        
        if let matchResults = regex?.matches(in: strBroadTime, options: NSRegularExpression.MatchingOptions.reportCompletion, range:range ) {
            
            for match in matchResults {
                let matchRange = match.range
                strAttr.addAttributes(boldTextAttr, range: matchRange)
            }
        }
        
        if self.dicPGM.productName.count > 0 {
            let strPgmName = self.dicPGM.productName
            let strAttrPipe = NSAttributedString.init(string: " | ", attributes: pipeTextAttr)
            let strAttrPGM = NSAttributedString.init(string:strPgmName, attributes: normalTextAttr)
            
            strAttr.append(strAttrPipe)
            strAttr.append(strAttrPGM)
        }

        
        self.promotionNameLabel.attributedText = strAttr
        
        self.viewTopRound()
        
        strAccess.append(self.dicRow.productName)
        self.lconstPerMonthMargine.constant = 0.0;
        
        strAccess.append(" ")
        
        if (self.dicRow.deal == true && (self.dicRow.productType == "R" || self.dicRow.productType == "T" || self.dicRow.productType == "U" || self.dicRow.productType == "S"))
            || (self.dicRow.deal == false && self.dicRow.productType == "R")
        {
            self.lblPerMonth.isHidden = false
            self.gsPriceLabel.isHidden = false
            
            let rentalText:String = self.dicRow.rentalText
            let rentalPrice:String = self.dicRow.mnlyRentCostVal
            
            if self.dicRow.productType == "R", !rentalText.isEmpty {
                if "월 렌탈료" == rentalText || "월" == rentalText  {
                    self.lblPerMonth.text = "월"
                    self.lconstPerMonthMargine.constant = 3.0
                    if rentalPrice.isEmpty == false , rentalPrice.hasPrefix("0") == false {
                        self.gsPriceLabel.text = rentalPrice
                        strAccess.append("월 \(rentalPrice)")
                    }
                    else {
                        self.gsPriceLabel.text = ""
                        self.lblPerMonth.text = Const.Text.advice_only.name
                        strAccess.append(Const.Text.advice_only.name)
                    }
                }
                else { //rentalText 비어있음
                    //렌탈인데 월이 아니면,
                    if rentalPrice.isEmpty == false , rentalPrice.hasPrefix("0") == false {
                        self.gsPriceLabel.text = rentalPrice
                        strAccess.append(rentalPrice)
                    }
                    else {
                        self.gsPriceLabel.text = ""
                        self.lblPerMonth.text = Const.Text.advice_only.name
                        strAccess.append(Const.Text.advice_only.name)
                    }
                }
            }
            else if rentalPrice.isEmpty == false , rentalPrice.hasPrefix("0") == false {
                self.gsPriceLabel.text = rentalPrice
                strAccess.append(rentalPrice)
            }
            else {
                self.gsPriceLabel.text = ""
                self.lblPerMonth.text = Const.Text.advice_only.name
                strAccess.append(Const.Text.advice_only.name)
            }
        }
        else if (self.dicRow.productType == "I") {
            self.lblPerMonth.text = ""
            self.gsPriceLabel.text = ""
            
        }
        else {
            // 할인율 / GS가
            let removeCommadrstr = Mocha_Util.strReplace(",", replace: "", string: self.dicRow.discountRate.toString)
            if Common_Util.isThisValidNumberStr(removeCommadrstr) == true {
                if self.dicRow.discountRate > 0 {
                    self.discountRateLabel.isHidden = false;
                    self.discountRateLabel.text = "\(self.dicRow.discountRate)%"
                    self.lconstBasePriceLeading.constant = 3
                }else {
                    self.lconstBasePriceLeading.constant = 0;
                    self.discountRateLabel.isHidden = true;
                }
                
            }
            else {
                //전체 뷰히든
                self.discountRateLabel.isHidden = true;
            }
            
            var salePrice = 0;
            
            if self.dicRow.salePrice.count > 0  {
                // 판매 가격
                let removeCommaspricestr = Mocha_Util.strReplace(",", replace: "", string: self.dicRow.salePrice)
                
                if Common_Util.isThisValidNumberStr(removeCommaspricestr) == true {
                    salePrice = Int(removeCommaspricestr!)!
                    self.gsPriceLabel.text = Common_Util.commaString(fromDecimal: Int32(salePrice))
                    self.gsPriceWonLabel.text  =  self.dicRow.exposePriceText
                    self.gsPriceLabel.isHidden = false;
                    self.gsPriceWonLabel.isHidden = false;
                    strAccess.append(self.gsPriceLabel.text!)
                    strAccess.append(self.gsPriceWonLabel.text!)
                }
                else {
                    //숫자아님
                    self.gsPriceLabel.isHidden = true;
                    self.gsPriceWonLabel.isHidden = false;
                }
            }
            else {
                self.gsPriceLabel.isHidden = true;
                self.gsPriceWonLabel.isHidden = true;
            }
            
            
            
            
            //실선 baseprice 원래 가격
            let removeCommaorgstr = Mocha_Util.strReplace(",", replace: "", string: self.dicRow.basePrice)
            let basePrice = Int(removeCommaorgstr!)!
            if (basePrice > 0 && basePrice > salePrice) {
                
                self.originalPriceLabel.text = Common_Util.commaString(fromDecimal: Int32(basePrice))
                self.originalPriceWonLabel.text = self.dicRow.exposePriceText
                self.originalPriceLabel.isHidden = false
                self.originalPriceWonLabel.isHidden = false
                self.originalPriceLine.isHidden = false
            }
            else {
                self.originalPriceLabel.text = ""
                self.originalPriceWonLabel.text = ""
                self.originalPriceLabel.isHidden = true
                self.originalPriceWonLabel.isHidden = true
                self.originalPriceLine.isHidden = true
            }
            
        }
        
        
        if self.dicAll.cateGb == "LIVE" {
            self.imgTagLive.isHidden = false;
            self.imgTagMyShop.isHidden = true;
        }
        else if self.dicAll.cateGb == "DATA" {
            self.imgTagLive.isHidden = true;
            self.imgTagMyShop.isHidden = false;
        }
        else {
            self.imgTagLive.isHidden = true;
            self.imgTagMyShop.isHidden = true;
        }
        self.view_Default.layoutIfNeeded()
        

        self.btn_TVTOP.accessibilityLabel = "\(self.promotionNameLabel.text ?? "")"
        self.btn_TVLink.accessibilityLabel = strAccess as String
        self.btn_TVLinkPriceArea.accessibilityLabel = strAccess as String
    }
    
    
    @IBAction func onBtnTopBanner(_ sender : UIButton){
        if //let product = self.dicPGM,
            let sectionTB = self.aTarget as? VODListTableViewController {
            sectionTB.touchEventDealCell(self.dicPGM.toJSON())
        }
    }
    
    @IBAction func onBtnGoLinkUrl(_ sender : UIButton){
        if //let product = self.dicRow,
            let sectionTB = self.aTarget as? VODListTableViewController {
            sectionTB.touchEventTBCell(self.dicRow.toJSON())
        }
    }
    
    @IBAction func onBtnVodLink(_ sender : UIButton){
        if let sectionTB = self.aTarget as? VODListTableViewController {
            var strVodLink = self.dicRow.playUrl
            
            if strVodLink.contains("vodPlay=") == false {
                strVodLink = "\(self.dicRow.playUrl)&vodPlay=VOD"
            }
            sectionTB.touchEventTBCellJustLinkStr(strVodLink)
        }
    }
    
    @IBAction func onBtnDirectOrder(_ sender : UIButton){

        let linkUrl : String  = self.dicOrdInfo.linkUrl
        if let sectionTB = self.aTarget as? VODListTableViewController {
            sectionTB.touchEventTBCellJustLinkStr(linkUrl)
        }
        
    }
}

