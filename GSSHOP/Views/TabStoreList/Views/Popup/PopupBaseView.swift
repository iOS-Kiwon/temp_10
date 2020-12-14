//
//  PopupBaseView.swift
//  GSSHOP
//
//  Created by Kiwon on 17/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

typealias VoidClosure = () -> Swift.Void

class PopupBaseView: UIView {
    
    let TITLE_LABEL_TOP_MARGIN: CGFloat = 10.0
    let TITLE_LABEL_BOT_MARGIN: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    
    deinit {
        print("PopupBaseView deinit")
    }
    
    open func removeFromSuperview(completion: (() -> Void)? = nil) {
        removeAnimate(completion: completion)
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.transition(with: self,
                          duration: 0.25, options: [.transitionCrossDissolve],
                          animations: {
                            self.removeFromSuperview()
        }) { (isFinish) in
            completion?()
        }
    }
    
    /// 애니메이션을 view에 추가
    func addAnimate(inView view: UIView) {
        let showAnimation = CAKeyframeAnimation()
        showAnimation.keyPath = "transform.scale"
        showAnimation.duration = 0.5 / 2
        showAnimation.values = [0.1, 1.2, 0.9, 1.0]
        showAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0]
        view.layer.add(showAnimation, forKey: "showAnimation")
    }
    
    
    /// 버튼 설정
    func setPopupButton(_ btn: UIButton) {
        let titleColor = UIColor.getColor("888888")
        let backgroundColor = UIColor.getColor("F1F1F1")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitleColor(titleColor, for: .highlighted)
        btn.setBackgroundImage(self.image(withColor: .white), for: .normal)
        btn.setBackgroundImage(self.image(withColor: backgroundColor), for: .highlighted)
    }
    
    /// 타이틀 레이블 설정
    func setPopupTitleLabel(_ lbl: UILabel) {
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 15.0)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
    }
    
    /// 메시지 레이블 설정
    func setPopupMsgLabel(_ lbl: UILabel) {
        lbl.textColor = UIColor.getColor("111111")
        lbl.font = UIFont.systemFont(ofSize: 15.0)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
    }
    
    // 라인 그리기
    func drawLine(inView drawingPlace: UIView, start: CGPoint, end: CGPoint, color: UIColor, width: CGFloat = 1.0) {

        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: start.x, y: start.y - 10))
        linePath.addLine(to: CGPoint(x: end.x, y: end.y - 10))
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.lineWidth = width
        line.lineCap = .butt
        drawingPlace.layer.addSublayer(line)
    }
    
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
