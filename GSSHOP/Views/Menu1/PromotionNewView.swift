//
//  PromotionNewView.swift
//  GSSHOP
//
//  Created by Home on 2020/08/25.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit
import Lottie

class PromotionNewView: UIView {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var alarmOnBtn: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var botConstraint: NSLayoutConstraint!
    /// 프로모션 API 모델
    private var pushPronotion: PushPromotion?
    /// 해당뷰 부모 객체
    private var aTarget: Home_Main_ViewController?
    /// 로티 객채
    private var animationView: LOTAnimationView?
    
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

    private func setInitUI() {
        // svg 애니메이션 적용
        let animationView = LOTAnimationView.init(name: PUSH_ANIMATION_LOTTIE_JSON_FILE_NAME)
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = false
        
        self.lottieView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: self.lottieView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: self.lottieView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: self.lottieView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: self.lottieView.bottomAnchor)
        ])
        self.animationView = animationView
        
        // 하단 safe area가 있는 경우 높이를 높인다.
        if IS_IPAD() {
            self.widthConstraint.constant = 375.0
            self.heightConstraint.constant += 20.0
        } else {
            self.heightConstraint.constant += getSafeAreaInsets().bottom
        }
        
        // 애니메이션 동작을 위해
        self.botConstraint.constant = -self.heightConstraint.constant
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.alarmOnBtn.setCorner(radius: 4.0)
        self.popupView.setCorner(corners: [.topLeft, .topRight], radius: 12.0)
    }
    
    @objc func setData(_ dic: [String: Any], target: Home_Main_ViewController) {
        self.aTarget = target
        guard let data = PushPromotion(JSON: dic) else {
            return
        }
        
        self.pushPronotion = data
        
        // 오늘 한 번 띄웠으면 오늘은 본 것으로 처리해서 동시에 안 뜨게 한다.
        applicationDelegate.isPromotionPopup = true
        // wise로그 보내기
        applicationDelegate.wiseLogRestRequest(wiselogpageurl(pagestr: "?mseq=415588"))
    }
    
    @objc func showAnimation() {
        self.botConstraint.constant = 0.0
        UIView.animate(withDuration: 0.2, delay: 0.2,
                       options: .curveEaseOut, animations: {
                        self.layoutIfNeeded()
        }, completion: { (isFinished) in
            if let view = self.animationView {
                view.play()
            }
        })
    }
    
    func hideAnimation(completion: @escaping () -> Void) {
        self.botConstraint.constant = -self.heightConstraint.constant
        UIView.animate(withDuration: 0.2, delay: 0.2,
                       options: .curveEaseOut, animations: {
                        self.layoutIfNeeded()
        }, completion: { (isFinished) in
            completion()
        })
    }
    
    
    @IBAction func onAlarmBtnAction(_ sender: UIButton) {
        if let target = self.aTarget {
            self.hideAnimation {
                target.clickPushAgreePopupBtn(NSNumber(integerLiteral: 3))
            }
        }
    }
    
    @IBAction func noShow7dayBtnAction(_ sender: UIButton) {
        if let target = self.aTarget {
            self.hideAnimation {
                target.clickPushAgreePopupBtn(NSNumber(integerLiteral: 2))
            }
        }
    }
    
}
