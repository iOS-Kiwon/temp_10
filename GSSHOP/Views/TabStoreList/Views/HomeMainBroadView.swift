//
//  HomeMainBroadView.swift
//  GSSHOP
//
//  Created by gsshop iOS on 2020/06/30.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

@objc class HomeMainBroadView: UIView {

    @objc var target: AnyObject?                                                        //클릭시 이벤트를 보낼 타겟
    private var rdic: TvLiveBanner?
    private var TVCapirequestcount:Int = 0
    
    @IBOutlet weak var viewTopArea: UIView!
    @IBOutlet weak var imgLiveStatus: UIImageView!
    @IBOutlet weak var imgShopLive: UIImageView!
    @IBOutlet weak var imgMyShop: UIImageView!
    @IBOutlet weak var lconstLiveStausLeading: NSLayoutConstraint!
    @IBOutlet weak var view_livetalk: UIView!
    @IBOutlet weak var btn_livetalk: UIButton!
    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var lefttimelabel: UILabel!
    @IBOutlet weak var viewLeftTime: UIView!
    @IBOutlet weak var btnLeftTime: UIButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var lblDiscountRate: UILabel!
    @IBOutlet weak var lblBasePrice: UILabel!
    @IBOutlet weak var lconstBasePriceLeading: NSLayoutConstraint!
    @IBOutlet weak var viewBasePriceStrikeLine: UIView!
    @IBOutlet weak var lblPerMonth: UILabel!
    @IBOutlet weak var lconstPerMonthMargine: NSLayoutConstraint!
    @IBOutlet weak var lblSalePrice: UILabel!
    @IBOutlet weak var lblSalePriceWon: UILabel!
    @IBOutlet weak var btn_TVLink: UIButton!
    @IBOutlet weak var btn_TVLinkPriceArea: UIButton!
    @IBOutlet weak var viewTvArea: UIView!
    @IBOutlet weak var viewPriceArea: UIView!
    @IBOutlet weak var lblBenefit: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var view_dorder: UIView!
    @IBOutlet weak var btn_dorder: UIButton!
    @IBOutlet weak var btn_dordertxt: UILabel!
    
    //private var imageLoadingOperation : MochaNetworkOperation?
    private var imageURL : String?
    private var curRequestString : String?
    private var isLivePlay : Bool = false
    private var mseqValue : String?
    private var isDualLive : Bool = false
    private var timer : Timer?
    private var dateformat = DateFormatter()
    
    @objc var strSectionName: String?
    @objc var strSectionCode: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblSalePriceWon.text = "home_tv_live_view_no_won".localized
        self.btn_dordertxt.text =  "home_tv_live_btn_tv_pay_text".localized

        self.lblBasePrice.isHidden = true
        self.viewBasePriceStrikeLine.isHidden = true
        self.lblPerMonth.isHidden = true
        self.lblSalePrice.isHidden = true
        self.lblSalePriceWon.isHidden = true
        self.lblSalePrice.textColor = UIColor.getColor("111111", alpha: 1.0)
        self.lblSalePriceWon.textColor = UIColor.getColor("111111", alpha: 1.0)

        self.viewLeftTime.layer.cornerRadius = self.viewLeftTime.frame.size.height/2.0
        self.viewLeftTime.layer.shouldRasterize = true
        self.viewLeftTime.layer.rasterizationScale = UIScreen.main.scale

        self.view_dorder.layer.cornerRadius = 2.0
        self.view_dorder.layer.shouldRasterize = true
        self.view_dorder.layer.rasterizationScale = UIScreen.main.scale

        self.viewTvArea.layer.borderColor = UIColor.init(red: 17.0/255.0, green: 17.0/255.0, blue: 17.0/255.0, alpha: 0.06).cgColor
        self.viewTvArea.layer.borderWidth = 1.0
        
        dateformat.dateFormat = "yyyyMMddHHmmss"
        dateformat.locale = Locale(identifier: "ko_KR")
    }
    
    deinit {

        self.target = nil
        self.rdic = nil

        self.imageURL = nil
        self.curRequestString = nil
        
        self.mseqValue = nil

        if let t = self.timer, t.isValid {
           t.invalidate()
           self.timer = nil
        }

        self.strSectionName = nil
        self.strSectionCode = nil
        
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any> , isShopLive : Bool) {
    
        guard let infoDic = TvLiveBanner(JSON: rowinfoDic) else { return }
        self.rdic = infoDic

        self.productImageView.image = nil
        if infoDic.imageUrl.isEmpty == false {
            
            self.imageURL = infoDic.imageUrl
            ImageDownManager.blockImageDownWithURL(infoDic.imageUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                
                DispatchQueue.main.async {
                    
                    self.productImageView.layoutIfNeeded()
                    self.productImageView.clipsToBounds = true
                    
                    if isInCache == true {
                        self.productImageView.image = image
                    }
                    else {
                        self.productImageView.alpha = 0
                        self.productImageView.image = image
                        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.productImageView.alpha = 1
                        }, completion: { (finished) in
                            
                        })
                    }
                }//dispatch
            }
        }
        
        if infoDic.broadStartTime.isEmpty && infoDic.broadCloseTime.isEmpty {
            
            if (infoDic.broadType == "베스트") == false {
                self.viewLeftTime.isHidden = false;
                self.lefttimelabel.text = "TV HIT"
                self.lefttimelabel.textAlignment = NSTextAlignment.center;
            }
            
            
        }else{
            self.viewLeftTime.isHidden = false;
        }


        if infoDic.broadType == "베스트" {
            self.imgLiveStatus.isHidden = true;
            self.lconstLiveStausLeading.constant = 0.0;
            self.viewLeftTime.isHidden = true;
        }else{
            self.imgLiveStatus.isHidden = false;
            self.lconstLiveStausLeading.constant = 17.0;
            self.viewLeftTime.isHidden = false;
        }

         self.imgMyShop.isHidden = isShopLive;
         self.imgShopLive.isHidden = !isShopLive;

         self.isDualLive = isShopLive;

         if self.isDualLive {
             self.mseqValue = "?mseq=A00054-C-2_PLAY";
         }
         else {
             self.mseqValue = "?mseq=A00054-C-2_DPLAY";
         }

        self.viewTopArea.layoutIfNeeded()

         //할인률 표시하는 로직, 이 부분과 베이스가 부분 수정해야할듯

        if infoDic.priceMarkUpType == "RATE" && infoDic.priceMarkUp.isEmpty == false {
            self.lblDiscountRate.text = "\(infoDic.priceMarkUp)%"
             self.lconstBasePriceLeading.constant = 3;
         }
         else {
             self.lblDiscountRate.text = "";
             self.lconstBasePriceLeading.constant = 0;
         }

        self.productTitleLabel.attributedText = Common_Util.attributedProductTitle(rowinfoDic, titleKey: "productName")

         self.lconstPerMonthMargine.constant = 0.0;

        if infoDic.isRental == true { //렌탈
             self.lblSalePriceWon.isHidden = true;


             self.lblBasePrice.isHidden = true;
             self.viewBasePriceStrikeLine.isHidden = true;

             self.lblPerMonth.isHidden = false;
             self.lblSalePrice.isHidden = false;

            let rentalText = infoDic.rentalText
            let rentalPrice = infoDic.rentalPrice
            var strVoiceOver = ""


             if (rentalText.count > 0) {

                if ("월 렌탈료" == rentalText || "월" == rentalText ) {
                     self.lblPerMonth.text = "월";
                     self.lconstPerMonthMargine.constant = 3.0;
                    if ( rentalPrice.count > 0 && rentalPrice.hasPrefix("0") == false ) {
                         self.lblSalePrice.text = rentalPrice;
                         strVoiceOver = "월 \(rentalPrice)"
                     }
                     else {
                         self.lblSalePrice.text = "";
                         self.lblPerMonth.text = "home_tv_live_councel_text".localized
                         strVoiceOver = "home_tv_live_councel_text".localized
                     }


                 }
                 else { //rentalText 비어있음
                     //렌탈인데 월이 아니면,
                    if ( rentalPrice.count > 0 && rentalPrice.hasPrefix("0") == false ) {
                         self.lblSalePrice.text = rentalPrice;
                         self.lblPerMonth.text = "";
                         strVoiceOver = rentalPrice;
                     }
                     else {
                        self.lblSalePrice.text = "";
                        self.lblPerMonth.text = "home_tv_live_councel_text".localized
                        strVoiceOver = "home_tv_live_councel_text".localized
                     }
                 }
             }
             else if ( rentalPrice.count > 0 && rentalPrice.hasPrefix("0") == false ) {
                 self.lblSalePrice.text = rentalPrice;
                 self.lblPerMonth.text = "";
                 strVoiceOver = rentalPrice;
             }
             else {
                 self.lblSalePrice.text = "";
                self.lblPerMonth.text = "home_tv_live_councel_text".localized
                strVoiceOver = "home_tv_live_councel_text".localized
             }

             self.btn_TVLinkPriceArea.accessibilityLabel = strVoiceOver;
             self.btn_TVLink.accessibilityLabel = strVoiceOver;
         }
         else { // 일반

             self.lblPerMonth.isHidden = true;
             self.lblPerMonth.text = "";

             self.lblSalePrice.isHidden = false;
             self.lblSalePriceWon.isHidden = false;
            self.lblSalePrice.text = infoDic.salePrice
            self.lblSalePriceWon.text = infoDic.exposePriceText

            self.btn_TVLinkPriceArea.accessibilityLabel = "\(infoDic.productName) \(infoDic.salePrice) \(infoDic.exposePriceText)"

             self.btn_TVLink.accessibilityLabel = "\(infoDic.productName) \(infoDic.salePrice) \(infoDic.exposePriceText)"

            if(infoDic.basePrice == "0" || infoDic.basePrice.count == 0) {
                 self.lblBasePrice.isHidden = true;
                 self.viewBasePriceStrikeLine.isHidden = true;
             }
             else {
                 self.lblBasePrice.isHidden = false;
                 self.viewBasePriceStrikeLine.isHidden = false;
                self.lblBasePrice.text = "\(infoDic.basePrice)원"
             }
         }

        if infoDic.liveTalkYn == "Y" {
            self.view_livetalk.isHidden = false;
            self.btn_livetalk.accessibilityLabel = "라이브톡"
         }else{
             self.view_livetalk.isHidden = true;
         }


        self.lblReview.attributedText = Common_Util.attributedReview(rowinfoDic, isWidth320Cut: true)

         //바로구매-상담하기 기본텍스트 및 내려주는 텍스트
        if infoDic.isRental == true {
            self.btn_dordertxt.text = "home_tv_live_view_no_advice_text02".localized
            self.btn_dorder.accessibilityLabel = "현재 생방송중인 상품 상담하기"
         }

        if let btnInfo3 = infoDic.btnInfo3 {
            if (btnInfo3.text.count > 0 ) {
                 self.btn_dordertxt.text = btnInfo3.text
                 if( self.btn_dordertxt.text == "구매하기") {
                    self.btn_dorder.accessibilityLabel = "현재 생방송중인 상품 구매하기"
                 }
             }
         }
        self.viewPriceArea.layoutIfNeeded()

        let widthLblBenefit = getAppFullWidth() - (16.0 + 8.0 + self.view_dorder.frame.size.width + 16.0);

        self.lblBenefit.attributedText = Common_Util.attributedBenefitString(rowinfoDic, widthLimit: widthLblBenefit, lineLimit: 2, fontSize: 14.0)

        self.viewPriceArea.layoutIfNeeded()




        if let t = self.timer, t.isValid {
           t.invalidate()
           self.timer = nil
        }

        self.drawliveBroadlefttime()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerProc) , userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)

    }
    
    @objc func stopTimer(){

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(refreshTVLiveContents), object: nil)

        if let t = self.timer, t.isValid {
           t.invalidate()
           self.timer = nil
        }
    }
    
    @IBAction func tvcBtnAction (_ sender : UIButton){
        //GTMSendLog:: Area_Tracking, MC_홈_생방송_Main_Live, 0_[세실엔느] 3D보정 초밀착 팬티 패키지 7종
        
        if let sectionTB = self.target as? SectionTBViewController,
            let rDic = self.rdic {
         
            if( sender.tag == 3007 || sender.tag == 3008) {
                //플레이 버튼 영역 클릭

                if self.strSectionName?.isEmpty == false {
                    var liveStr = ""
                    if self.isDualLive == true {
                        liveStr = "_생방송_Main_Live"
                    }else{
                        liveStr = "_데이터 홈쇼핑_Main_Live"
                    }
                    let actionStr = "MC_" + (self.strSectionName ?? "") + liveStr
                    let labelStr = "0_" + rDic.productName
                    applicationDelegate.gtMsendLog("Area_Tracking", withAction:actionStr , withLabel:labelStr)
                }
                
                sectionTB.touchEventDualPlayerJustLinkStr(rDic.linkUrl)

            }
            else if(sender.tag == 3009) {
                //라이브톡

                
                if rDic.liveTalkUrl.count > 0 {
                    applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr:"?mseq=A00054-C_LIVE-TALK"))
                }
                sectionTB.touchEventDualPlayerJustLinkStr(rDic.liveTalkUrl)
                
            }
            else if(sender.tag == 3010) {
                //편성표 링크
                sectionTB.touchEventDualPlayerJustLinkStr(rDic.broadScheduleLinkUrl)
            }
            else if(sender.tag == 3011) {

                //바로구매
                if let btnInfo3 = rDic.btnInfo3 {
                    let linkUrl = btnInfo3.linkUrl
                    
                    if (linkUrl.count > 0 && linkUrl.hasPrefix(Const.Text.GSEXTERNLINKPROTOCOL.name)) {
                     
                        let linkstr = linkUrl.replacingOccurrences(of: Const.Text.GSEXTERNLINKPROTOCOL.name, with: "")
                        let strDirectOrd = linkstr.replacingOccurrences(of: "directOrd?", with: "")
                        applicationDelegate.directOrdOptionViewShowURL(strDirectOrd)
                        
                    }else{
                        
                        sectionTB.touchEventDualPlayerJustLinkStr(linkUrl)
                    }

                    if self.strSectionName?.isEmpty == false {
                        let actionStr = "MC_App_" + (self.strSectionName ?? "") + "_DirectOrd"
                        applicationDelegate.gtMsendLog("Area_Tracking", withAction:actionStr , withLabel:linkUrl)
                    }

                }else{
                    
                    let rightNowUrl = rDic.rightNowBuyUrl
                    
                    sectionTB.touchEventDualPlayerJustLinkStr(rightNowUrl)
                    
                    if self.strSectionName?.isEmpty == false {
                        let actionStr = "MC_App_" + (self.strSectionName ?? "") + "_DirectOrd"
                        applicationDelegate.gtMsendLog("Area_Tracking", withAction:actionStr , withLabel:rightNowUrl)
                    }
                    
                    
                }
                    
                

            }else if(sender.tag == 3012) {
                //전체상품보기 링크
                sectionTB.touchEventDualPlayerJustLinkStr(rDic.totalPrdViewLinkUrl)
            }
    
        }
    }
    
    @IBAction func onBtnVodLink (_ sender : UIButton){
        
        if let sectionTB = self.target as? SectionTBViewController,
            let rDic = self.rdic {
            var strVodLink = rDic.playUrl
            if strVodLink.contains("vodPlay=") == false {
                strVodLink = strVodLink + "&vodPlay=LIVE"
            }
            
            sectionTB.touchEventDualPlayerJustLinkStr(strVodLink)
        }
    }

    @objc func timerProc(){
        self.drawliveBroadlefttime()
    }

    func drawliveBroadlefttime() {

        if let rDic = self.rdic,
            rDic.broadCloseTime == "" {
            if let t = self.timer, t.isValid {
               t.invalidate()
               self.timer = nil
            }
            self.viewLeftTime.isHidden = true
            return
        }

        if let rDic = self.rdic, rDic.broadType == "베스트" {
            self.viewLeftTime.isHidden = true
            self.btnLeftTime.isHidden = true
        }else{
            self.viewLeftTime.isHidden = false
            self.btnLeftTime.isHidden = false
        }


        let closeTime : Date = dateformat.date(from: self.rdic?.broadCloseTime ?? "") ?? Date()
//        let closestamp = closeTime?.timeIntervalSince1970 ?? 0
//        let dbstr =   String(format:"%d", closestamp)
        //reload tb 통신 실패시
        
        //if closeTime > 0 {
            self.lefttimelabel.text = self.getDateLeft(date: closeTime)
            self.lefttimelabel.textAlignment = NSTextAlignment.center
        //}
            
        
    }

    func getSWSeoulDateTime() -> Date? {
        
        let curDate = Date()
        let dfTime = DateFormatter()
        dfTime.timeZone = TimeZone(identifier: "Asia/Seoul")
        dfTime.dateFormat = "yyyyMMddHHmmss"
        
        let strSeoulTime = dfTime.string(from: curDate)
        
        let dfSeoult = DateFormatter()
        dfSeoult.dateFormat = "yyyyMMddHHmmss"
        dfSeoult.locale = Locale(identifier: "ko_KR")
        
        if let dtSeoul = dfSeoult.date(from: strSeoulTime) {
            return dtSeoul
        }
        
        return nil
    }

    func getDateLeft(date:Date) -> String {
        
        guard let dtSeoul = self.getSWSeoulDateTime() else {
            return ""
        }
        
        let left = Int(date.timeIntervalSince1970  - dtSeoul.timeIntervalSince1970)

        let tminite = left/60;
        let hour = left/3600;
        let minite = (left-(hour*3600))/60;
        let second = (left-(hour*3600)-(minite*60));
        var callTemp = "";

        if(tminite >= 60) {
            callTemp = String(format:"%02d:%02d:%02d 남음", hour, minite, second)
            TVCapirequestcount = 0;
        }
        else if(left <= 0) {
            callTemp = "00:00:00 남음"
            TVCapirequestcount = TVCapirequestcount+1;
        }
        else {
            callTemp  = String(format:"00:%02d:%02d 남음", minite, second)
            TVCapirequestcount = 0;
        }

        //print(callTemp)

        if callTemp == "00:00:00 남음" {

            self.stopTimer()

            let randNum = Int.random(in: 0..<11) + 5;
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(refreshTVLiveContents), object: nil)
            self.perform(#selector(refreshTVLiveContents), with: nil, afterDelay:Double(randNum))


        }
        return callTemp;
    }

    func sectionReloadTimerRemove(){
        self.stopTimer()
    }

    @objc func refreshTVLiveContents (){
        
        let itemString = self.strSectionCode?.replacingOccurrences(of: "#", with: "") ?? ""
        
        let strBrdTime = (UserDefaults.standard.object(forKey: "API_ADD_BRD_TIME")  as? String) ?? ""
        let broadURL = self.isDualLive == true ? HOME_MAIN_TVSHOP_LIVE_URL : HOME_MAIN_TVSHOP_DATA_URL
        let url = String(format: "%@?sectionCode=%@&version=%@%@", broadURL, itemString,APP_NAVI_VERSION,strBrdTime)
        guard let turl = URL.init(string:url) else {
            return
        }
        
        print("refresh url = \(url)")

        var request = URLRequest(url: turl)
        if let userAgent = UserDefaults.standard.object(forKey: "UserAgent") as? String {
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        request.httpMethod = "GET"  // Default가 get이긴 하다.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 3.0
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let task = URLSession.shared
            .dataTask(with: request) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let resultData = data,
                    let json = try? JSONSerialization.jsonObject(with: resultData, options: []),
                    let jsonDic = json as? [String: Any]
                    
                {
                    
                    DispatchQueue.main.async {
                        
                        if let dic = jsonDic["tvLiveBanner"] as? Dictionary<String, Any> {
                            guard let infoDic = TvLiveBanner(JSON: dic) else { return }
                            
                            if let closeTime : Date = self.dateformat.date(from: infoDic.broadCloseTime),
                                let dtSeoul = self.getSWSeoulDateTime() {
                                
                                let left = Int(closeTime.timeIntervalSince1970  - dtSeoul.timeIntervalSince1970)
                                
                                print(left)
                                
                                if (left <= 0) {
                                    
                                    if(self.TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                                        self.TVCapirequestcount = self.TVCapirequestcount+1;
                                        
                                        print("551 self.TVCapirequestcount = \(self.TVCapirequestcount)")
                                        
                                        if (infoDic.broadCloseTime.isEmpty == false) {
                                            
                                            self.stopTimer()
                                            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerProc) , userInfo: nil, repeats: true)
                                            RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
                                        }
                                    }
                                }
                                else {
                                    
                                    if let sectionTB = self.target as? SectionTBViewController {
                                       let headerBtype = self.isDualLive == true ? HEADER_BTYPE_LIVE : HEADER_BTYPE_MYSHOP
                                       sectionTB.updateHeaderDicInfo(dic, broadType:headerBtype)
                                    }

                                    if infoDic.broadType.isEmpty == false && infoDic.imageUrl.isEmpty == false && infoDic.linkUrl.isEmpty == false {
                                        self.setCellInfoNDrawData(dic, isShopLive:self.isDualLive)
                                    }
                                    
                                }
                            }
                            
                        }else{
                            if(self.TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                                self.TVCapirequestcount = self.TVCapirequestcount+1;
                                print("578 self.TVCapirequestcount = \(self.TVCapirequestcount)")
                                self.stopTimer()
                                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerProc) , userInfo: nil, repeats: true)
                                RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
                            }
                        }
                    }
                    
                } else {
                    return
                }
        }
        task.resume()
    }
    
}
