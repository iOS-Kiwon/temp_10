//
//  WebPrdPriceView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/25.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdPriceView: UIView {
        
    /// 가격 라벨
    @IBOutlet weak var priceLbl: UILabel!
    /// 미리보기 버튼
    @IBOutlet weak var preViewBtn: UIButton!
    /// 미리보기 버튼 Width
    @IBOutlet weak var previewBtnWidth: NSLayoutConstraint!
    
    /// 할인율/베이스 가격이 있는 뷰
    @IBOutlet weak var basePriceView: UIView!
    /// 할인율/베이스 가격이 있는 뷰 상단 여백
    @IBOutlet weak var basePriceViewTop: NSLayoutConstraint!
    /// 할인율/베이스 가격이 있는 뷰 높이
    @IBOutlet weak var basePriceViewHeight: NSLayoutConstraint!
    /// 할인율 라벨
    @IBOutlet weak var discountRateLbl: UILabel!
    /// 원래가격 (베이스가) 라벨
    @IBOutlet weak var basePriceLbl: UILabel!
    /// 할인 툴팁 이미지뷰
    @IBOutlet weak var tooltipImgView: UIImageView!
    
    /// 찜 버튼
    @IBOutlet weak var zzimBtn: UIButton!
    
    /// 하단 정보뷰
    @IBOutlet weak var infoView: UIView!
    /// 하단 정보뷰의 상단 여백
    @IBOutlet weak var infoViewTop: NSLayoutConstraint!
    /// 하단 정보뷰의 하단 여백
    @IBOutlet weak var infoViewBot: NSLayoutConstraint!
    
    private var saleInfo: Components?
    
    private weak var aTarget: ResultWebViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.preViewBtn.setCorner(radius: 2)
        self.preViewBtn.setBorder(width: 1, color: "d9d9d9", alpha: 1.0)
    }
    
    /// 데이터 설정
    func setData(_ data: Components, target: ResultWebViewController?) {
        self.saleInfo = data
        self.aTarget = target
        
        // UI 초기화
        self.infoViewTop.constant = 0.0
        self.tooltipImgView.image = nil
        
        // 찜버튼 노출여부
        if "X" == data.favoriteYN {
            self.zzimBtn.isHidden = true
        } else {
            self.zzimBtn.isHidden = false
            
            if "Y" == data.favoriteYN {
                // 찜을 함.
                self.zzimBtn.isSelected = true
            } else {
                // 찜을 안함
                self.zzimBtn.isSelected = false
            }
        }
        
        // 미리보기 노출여부
        if data.preCalcurateUrl.isEmpty == false {
            self.preViewBtn.isHidden = false
            self.previewBtnWidth.constant = 63.0
        } else {
            self.preViewBtn.isHidden = true
            self.previewBtnWidth.constant = 0.0
        }
        
        
        // 판매 가격 설정
        setPriceUI(data.priceInfo)
        
        // 할인율 / 원래가격 설정
        setDiscountUI(data.discountInfo)

        // 하단 추가 정보 설정
        setAddtionUI(data.additionalList)
    }
    
    /// 찜 버튼 UI 설정
    func setZzimBtnUI(isOn value: Bool) {
        self.zzimBtn.isSelected = value
        /*
        guard let vc = self.aTarget else { return }
        guard let zzimView = Bundle.main.loadNibNamed(WebPrdZzimView.className, owner: self, options: nil)?.first as? WebPrdZzimView else { return}
        
        self.zzimBtn.isSelected = value
        zzimView.setZzim(isOn: value)

        vc.view.addSubview(zzimView)
        zzimView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            zzimView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            zzimView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            zzimView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            zzimView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])
        
        zzimView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            // spring damping     0과 1 사이의 수로 0에 가까울수록 애니메이션은 더 진동한다.
            // spring velocity     애니메이션을 시작할 때 뷰의 상대적 속도.
            zzimView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                zzimView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                zzimView.alpha = 0.0
            }) { (_) in
                zzimView.removeFromSuperview()
            }
        }
         */
    }
    
    /// 가격 정보 설정
    private func setPriceUI(_ dataList: [PrdTextInfo]) {
        if dataList.count <= 0 {
            self.priceLbl.text = ""
            return
        }
        
        let priceAttributedString = NSMutableAttributedString(string: "")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byCharWrapping
        style.minimumLineHeight = self.findMinimumLineHeight(dataList)
        priceAttributedString.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: priceAttributedString.length))
        
        for data in dataList {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            priceAttributedString.append(attrString)
        }

        self.priceLbl.attributedText = priceAttributedString
        self.layoutIfNeeded()
        
        let lines = self.priceLbl.getLines()
        if lines > 1 {
            // 라인이 2줄 이상이고, ~ 표시가 있을때 줄바꿈을 ~다음에 \n로 줄바꿈
            if priceAttributedString.mutableString.contains("~") {
                let range = priceAttributedString.mutableString.range(of: "~")
                
                // ~ 표시가 String의 마지막에 위치해있다면 (~표시 다음에 오는 String이 없는 경우는 제외)
                if range.location + range.length != priceAttributedString.length {
                    let replaceAttr = NSAttributedString(string: "~\n")
                    priceAttributedString.replaceCharacters(in: range, with: replaceAttr)
                    self.priceLbl.attributedText = priceAttributedString
                }
            }
        }
    }
    
    /// 할인율 정보 설정
    private func setDiscountUI(_ data: DiscountInfo?) {
        guard let discountInfo = data else {
            self.basePriceView.isHidden = true
            self.basePriceLbl.attributedText = NSMutableAttributedString(string: "")
            self.discountRateLbl.attributedText = NSMutableAttributedString(string: "")
            self.basePriceViewTop.constant = 0.0
            self.basePriceViewHeight.constant = 0.0
            return
        }
        
        if discountInfo.discountAddInfoUrl.isEmpty, discountInfo.discountText.count <= 0, discountInfo.originPrc.count <= 0 {
            self.basePriceView.isHidden = true
            self.basePriceLbl.attributedText = NSMutableAttributedString(string: "")
            self.discountRateLbl.attributedText = NSMutableAttributedString(string: "")
            self.basePriceViewTop.constant = 0.0
            self.basePriceViewHeight.constant = 0.0
            return
        }
        
        self.basePriceViewHeight.constant = 20.0
        self.basePriceViewTop.constant = 4.0
        
        // 할인율
        let discountAttributedString = NSMutableAttributedString(string: "")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineBreakMode = .byWordWrapping
        style.minimumLineHeight = self.findMinimumLineHeight(discountInfo.discountText)
        discountAttributedString.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: discountAttributedString.length))
        
        for data in discountInfo.discountText {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            discountAttributedString.append(attrString)
        }

        self.discountRateLbl.attributedText = discountAttributedString
        
        // 원래 가격 // 취소선 필수
        let basePriceAttributedString = NSMutableAttributedString(string: "")
        basePriceAttributedString.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: basePriceAttributedString.length))

        for data in discountInfo.originPrc {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            basePriceAttributedString.append(attrString)
        }

        basePriceAttributedString.addAttributes([
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strokeColor : UIColor.black,
            .baselineOffset: 0 //iOS 10.3.* 버전에서 이값이 같이 설정되어 있지 않으면 위에 strike 설정이 되지 않는다.
            ], range: NSRange(location:0,
                              length: basePriceAttributedString.length))
        self.basePriceLbl.attributedText = basePriceAttributedString
        
        // 툴팁 설정
        if discountInfo.discountAddInfoUrl.isEmpty == false {
            self.tooltipImgView.image = UIImage(named: Const.Image.ic_price_info_20.name)
        } else {
            self.tooltipImgView.image = nil
        }
    }
    
    /// 추가 정보 설정 - 여행사 / 유류할증료 등등
    private func setAddtionUI(_ dataList: [[PrdTextInfo]]) {
        if dataList.count <=  0 {
            self.infoViewTop.constant = 0.0
            self.infoViewBot.constant = 16.0
            return
        }
        
        self.infoViewTop.constant = 16.0
        
        var lastAddedView: UIView?
        
        for data in dataList {
            let view = Bundle.main.loadNibNamed(WebPrdPriceInfoView.className, owner: self, options: nil)?.first as! WebPrdPriceInfoView
            self.infoView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            var topConstraint: NSLayoutConstraint!
            if lastAddedView == nil {
                topConstraint = view.topAnchor.constraint(equalTo: self.infoView.topAnchor)
            } else {
                topConstraint = view.topAnchor.constraint(equalTo: lastAddedView!.bottomAnchor, constant: 4.0)
            }
            NSLayoutConstraint.activate([
                topConstraint,
                view.leadingAnchor.constraint(equalTo: self.infoView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.infoView.trailingAnchor),
            ])
            lastAddedView = view
            
            view.setData(data)
            view.layoutIfNeeded()
        }
        
        if lastAddedView != nil {
            lastAddedView!.bottomAnchor.constraint(equalTo: self.infoView.bottomAnchor).isActive = true
        }
        self.layoutIfNeeded()
    }
    
    /// 가격 정보 버튼 액션
    @IBAction func priceInfoBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget,let data = self.saleInfo {
            vc.dealPrdUrlAction(data.discountInfo.discountAddInfoUrl, withParam: "",loginCheck: false);
            vc.sendAmplitudeAndMseq(withAction: "판매가_할인혜택보기")
        }
    }
    
    /// 공유하기 버튼 액션
    @IBAction func shareBtnAction(_ sender: UIButton) {
         if let vc = self.aTarget,let data = self.saleInfo {
            vc.dealPrdUrlAction(data.shareRunUrl, withParam: nil,loginCheck: false);
            vc.sendAmplitudeAndMseq(withAction: "공유하기")
        }
    }
    /// 미리계산하기 버튼 액션
    @IBAction func previewCalcPriceAction(_ sender: Any) {
        if let vc = self.aTarget,let data = self.saleInfo {
            vc.dealPrdUrlAction(data.preCalcurateUrl, withParam: nil,loginCheck: true);
            vc.sendAmplitudeAndMseq(withAction: "판매가_미리계산")
        }
    }
    /// 찜 버튼 액션
    @IBAction func zzimBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget,let data = self.saleInfo {
            vc.dealPrdUrlAction(data.favoriteRunUrl, withParam: nil,loginCheck: true);
            vc.sendAmplitudeAndMseq(withAction: "찜")
        }
    }
    
    //MARK:- Private functions
    private func updateZzim(url: String, completion: @escaping (_ isSuccess: Bool, _ data: Zzim?) -> Void) {
        // 로그인 체크
        if applicationDelegate.islogin == false {
            if applicationDelegate.hmv.loginView == nil {
                applicationDelegate.hmv.loginView = AutoLoginViewController.init(nibName: "AutoLoginViewController", bundle: nil)
            } else {
                applicationDelegate.hmv.loginView.clearTextFields()
            }
            
            applicationDelegate.hmv.loginView.delegate = applicationDelegate.hmv
            applicationDelegate.hmv.loginView.loginViewType = 33
            applicationDelegate.hmv.loginView.loginViewMode = 0
            applicationDelegate.hmv.loginView.view.isHidden = false
            applicationDelegate.hmv.loginView.btn_naviBack.isHidden = false
            
            if let topVC = applicationDelegate.hmv.navigationController?.topViewController,
                !topVC.isKind(of: AutoLoginViewController.self) {
                applicationDelegate.hmv.navigationController?.pushViewControllerMoveIn(fromBottom: applicationDelegate.hmv.loginView)
            }
            return
        }
        
        guard let zzimURL = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: zzimURL)
        if let userAgent = UserDefaults.standard.object(forKey: "UserAgent") as? String {
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        request.httpMethod = "GET"  // Default가 get이긴 하다.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared
            .dataTask(with: request) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let resultData = data,
                    let json = try? JSONSerialization.jsonObject(with: resultData, options: []),
                    let jsonDic = json as? [String: Any],
                    let zzim = Zzim(JSON: jsonDic),
                    zzim.success == 1 {
                    completion(true, zzim)
                } else {
                    return
                }
        }
        task.resume()
    }
}
