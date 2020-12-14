//
//  PopupTwoButtonView.swift
//  GSSHOP
//
//  Created by Kiwon on 19/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PopupTwoButtonView: PopupBaseView {

    /// 백그라운드 뷰
    @IBOutlet weak var bgView: UIView!
    /// 팝업 전체뷰
    @IBOutlet weak var popupView: UIView!
    /// 타이틀 라벨
    @IBOutlet weak var titleLbl: UILabel!
    /// 타이틀 라인뷰
    @IBOutlet weak var titleLine: UIView!
    /// 메시지 라벨
    @IBOutlet weak var msgLbl: UILabel!
    /// 취소 버튼
    @IBOutlet weak var btnLeft: UIButton!
    /// 확인 버튼
    @IBOutlet weak var btnRight: UIButton!
    
    @IBOutlet weak var titleLbTop: NSLayoutConstraint!
    @IBOutlet weak var titleLblBot: NSLayoutConstraint!
    @IBOutlet weak var titleLblHeight: NSLayoutConstraint!

    var btnLeftAction: VoidClosure? = nil
    var btnRightAction: VoidClosure? = nil
    
    var popupTitle : String = "" {
        didSet {
            self.titleLbl.text = self.popupTitle
            if self.popupTitle.isEmpty {
                self.titleLblHeight.constant = 0.0
                self.titleLbl.isHidden = true
                self.titleLine.isHidden = true
                self.titleLbTop.constant = 0.0
                self.titleLblBot.constant = 0.0
            } else {
                var height = self.titleLbl.intrinsicContentSize.height
                if height < 20 { height = 20 }
                self.titleLblHeight.constant = height
                self.titleLbl.isHidden = false
                self.titleLine.isHidden = false
                self.titleLbTop.constant = TITLE_LABEL_BOT_MARGIN
                self.titleLblBot.constant = TITLE_LABEL_BOT_MARGIN
            }
        }
    }
    var popupMsg: String = "" {
        didSet { self.msgLbl.text = self.popupMsg }
    }
    
    var btnLeftTitle: String = "" {
        didSet { self.btnLeft.setTitle(self.btnLeftTitle, for: .normal) }
    }
    var btnRightTitle: String = "" {
        didSet { self.btnRight.setTitle(self.btnRightTitle, for: .normal) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setInitUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitUI()
    }
    
    private func setInitUI() {
        let view = Bundle.main.loadNibNamed("PopupTwoButtonView", owner: self, options: nil)?.first as! UIView
        view.backgroundColor = .clear
        view.frame = self.bounds
        self.addSubview(view)
        
        // bg 설정
        self.bgView.backgroundColor = UIColor.black
        self.bgView.alpha = 0.6
        
        // 라운딩
        self.popupView.clipsToBounds = true
        self.popupView.layer.cornerRadius = 5.0
        self.popupView.layer.shadowRadius = 5.0
        
        // UI 설정
        self.setPopupButton(self.btnLeft)
        self.setPopupButton(self.btnRight)
        self.setPopupTitleLabel(self.titleLbl)
        self.setPopupMsgLabel(self.msgLbl)
        
        // 팝업 애니메이션 추가
        addAnimate(inView: self.popupView)
    }
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        removeFromSuperview(completion: self.btnLeftAction)
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        removeFromSuperview(completion: self.btnRightAction)
    }
}
