//
//  PopupImageTwoButtonView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/01/17.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class PopupImageTwoButtonView: PopupBaseView {

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
    /// 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 취소 버튼
    @IBOutlet weak var btnLeft: UIButton!
    /// 확인 버튼
    @IBOutlet weak var btnRight: UIButton!
    /// 상단 닫기 버튼
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var titleLblTop: NSLayoutConstraint!
    @IBOutlet weak var titleLblHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLblBot: NSLayoutConstraint!
    
    @IBOutlet weak var imgViewTop: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    
    var popupTitle : String = "" {
        didSet {
            self.titleLbl.text = self.popupTitle
            if self.popupTitle.isEmpty {
                self.titleLblHeight.constant = 0.0
                self.titleLine.isHidden = true
                self.titleLblTop.constant = 0.0
                self.titleLblBot.constant = 0.0
            } else {
                var height = self.titleLbl.intrinsicContentSize.height
                if height < 20 { height = 20 }
                self.titleLblHeight.constant = height
                self.titleLbl.isHidden = false
                self.titleLine.isHidden = false
                self.titleLblTop.constant = TITLE_LABEL_TOP_MARGIN
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
    
    var popupImage: UIImage? = nil {
        didSet {
            // 이미지 설정
            if let image = self.popupImage {
                let imgWidth = image.size.width
                let imgHeight = image.size.height
                
                let raito = self.imgView.frame.width / imgWidth
                let scaledHeight = imgHeight * raito
                self.imgViewHeight.constant = scaledHeight
                self.imgViewTop.constant = 20
            } else {
                self.imgViewHeight.constant = 0.0
                self.imgViewTop.constant = 0.0
            }
            
            self.imgView.image = self.popupImage
        }
    }
    
    var btnLeftAction: VoidClosure? = nil
    var btnRightAction: VoidClosure? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setInitUI()
    }
    
    private func setInitUI() {
        let view = Bundle.main.loadNibNamed(PopupImageTwoButtonView.className, owner: self, options: nil)?.first as! UIView
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
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.removeFromSuperview(completion: nil)
    }
}
