//
//  WebPrdNaviBarView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/03.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

@objc protocol WebPrdNaviBarViewDelegate {
    @objc func didDoneLogin()
}

class WebPrdNaviBarView: UIView {
    //백드라운드 (그라데이션 적용)
    @IBOutlet weak var naviBarBackground: UIView!
    
    @objc public static let WEB_PRD_NAVIBAR_HEIGHT: CGFloat = 50.0
    
    /// GNB - White 테마
    @IBOutlet weak var naviBarWhiteView: UIView!
    /// GNB - Black 테마
    @IBOutlet weak var naviBarBlackView: UIView!
    
    /// GNB - Black 테마의 뒤로가기
    @IBOutlet weak var backBlackBtn: UIButton!
    /// GNB - White 테마의 뒤로가기
    @IBOutlet weak var backWhiteBtn: UIButton!

    /// GNB - Black 테마의 뒤로가기 홈버튼
    @IBOutlet weak var backHomeBlackBtn: UIButton!
    /// GNB - White 테마의 뒤로가기 홈버튼
    @IBOutlet weak var backHomeWhiteBtn: UIButton!
    
    /// GNB - 장바구니 뱃지뷰
    @IBOutlet weak var cartBadgeView: UIView!
    /// GNB - Dim뷰: 레이어팝업 나타날때 노출됨
    @IBOutlet weak var dimView: UIView!
    
    /// 상단 그라데이션
    let gradientLayer = CAGradientLayer()
    
    @objc weak var aTarget: AnyObject? {
        didSet {
            self.updateNaviUI()
        }
    }
    
    @objc var cartUrl = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInitUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {

        self.gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor,
                                UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor]

        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: getAppFullWidth(), height: self.naviBarBackground.frame.height + 12.0)
        self.naviBarBackground.layer.insertSublayer(self.gradientLayer, at: 0)
    }
    
    deinit {
           NotificationCenter.default.removeObserver(self)
       }

    
    private func setInitUI() {
        self.dimView.isHidden = true
        self.backHomeBlackBtn.isHidden = true
        self.backHomeWhiteBtn.isHidden = false
        self.naviBarBlackView.alpha = 0.0
        self.cartBadgeView.backgroundColor = .clear
        
        self.cartBadgeView.setCorner()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCartCountView), name: NSNotification.Name(rawValue: MAINSECTIONGOTOPNRELOADNOTI), object: nil)
    }
    
    private func updateNaviUI() {
//        if let vc = self.aTarget as? ResultWebViewController {
//            guard let _ = vc.navigationController else {
//                // 푸시 등으로 바로 띄운 경우: 뒤로가기에 있는 홈버튼 보여지게
//                self.backHomeBlackBtn.isHidden = false
//                self.backHomeWhiteBtn.isHidden = false
//                
//                self.backBlackBtn.isHidden = true
//                self.backWhiteBtn.isHidden = true
//                return
//            }
            
            /// 네비게이션으로 해당뷰를 연 경우: 뒤로가기에 있는 홈버튼 숨김
            self.backHomeBlackBtn.isHidden = true
            self.backHomeWhiteBtn.isHidden = true
            
            self.backBlackBtn.isHidden = false
            self.backWhiteBtn.isHidden = false
//        }
    }
    
    @objc func setDimView(isShow: Bool) {
        if isShow {
            // DimView가 최상단으로 오도록
            self.dimView.bringSubviewToFront(self)
            //배경을 흰색으로?
            //self.dimView.alpha = 1 - self.naviBarWhiteView.alpha
        }
//        else {
//            self.dimView.alpha = 0.5
//        }
        self.dimView.isHidden = !isShow
    }
    
    @objc func updateCartCountView() {
        
        guard var cartStr = CooKieDBManager.getCartCountstr() else  {
            self.cartBadgeView.isHidden = true
            return
        }

        if cartStr.isInt {
            if let intValue = Int(cartStr), intValue > 99 {
                cartStr = "99"
            }
            
            if let intValue = Int(cartStr), intValue <= 0 {
                self.cartBadgeView.isHidden = true
                return
            }
        } else {
            // 혹시 숫자가 아닐수도 있을까... -> 안그리기
            self.cartBadgeView.isHidden = true
            return
        }
        
        for subView in self.cartBadgeView.subviews{
            subView.removeFromSuperview()
        }
        
        guard let badgeView = CustomBadge(string: cartStr) else {
            self.cartBadgeView.isHidden = true
            return
        }
        
        self.cartBadgeView.isHidden = false
        badgeView.alpha = 1.0
        badgeView.badgeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cartBtnAction(_:)))
        self.cartBadgeView.addGestureRecognizer(tapGesture)
        self.cartBadgeView.insertSubview(badgeView, belowSubview: self.cartBadgeView)
    }
    
    @objc func updateNaviBar(offset: CGFloat) {
        let alpha = min(1, offset / (getAppFullWidth() / 2))
        //print("alpha : \(alpha)")
        self.naviBarWhiteView.alpha = 1 - alpha
        self.naviBarBlackView.alpha = alpha
        self.gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.4 - alpha).cgColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor]
        
        if alpha >= 1 {
            self.naviBarWhiteView.isHidden = true
        } else {
            self.naviBarWhiteView.isHidden = false
        }
    }
}

extension WebPrdNaviBarView {
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget as? ResultWebViewController {
            vc.backFromWebviewHeader()
            
            
            // 푸시 등으로 바로 띄운 경우
            // TODO:-
        }
    }
    
    @IBAction func backHomeBtnAction(_ sender: UIButton) {
        // 푸시 등으로 바로 띄운 후 home 매장으로 이동
        // TODO:-모두 닫기
        if let vc = self.aTarget as? ResultWebViewController {
            vc.homeFromWebviewHeader()
            vc.sendAmplitudeAndMseq(withAction: "header_home")
        }
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        //검색창 호출
        if let vc = self.aTarget as? ResultWebViewController {
            vc.sendAmplitudeAndMseq(withAction: "header_검색")
        }
        applicationDelegate.searchviewShow()
    }
    
    @IBAction func homeBtnAction(_ sender: UIButton) {
        
        //단순 닫기가 아닌 홈매장으로 이동해야함 하단 탭바 홈버튼 처럼동작
        if let vc = self.aTarget as? ResultWebViewController {
            vc.homeFromWebviewHeader()
            vc.sendAmplitudeAndMseq(withAction: "header_home")
        }

    }

    @IBAction func cartBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget as? ResultWebViewController,
            let resultVC = ResultWebViewController.init(urlString: self.cartUrl),
            self.cartUrl.isEmpty == false {
            vc.sendAmplitudeAndMseq(withAction: "header_장바구니")
            resultVC.webPrdNaviBarViewDelegate = self
            //vc.navigationController?.pushViewController(resultVC, animated: true)
            vc.navigationController?.pushViewControllerMoveIn(fromBottom: resultVC)
        }
    }
}

extension WebPrdNaviBarView: WebPrdNaviBarViewDelegate {
    func didDoneLogin() {
        self.updateCartCountView()
    }
}
