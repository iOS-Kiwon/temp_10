//
//  PopupCartView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/07/30.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class PopupCartView: UIView {
    
    @IBOutlet weak var imgCartPopup: UIImageView!
    
    private var aTarget: AnyObject?
    /// 장바구니 데이터가 담긴 모듈
    var basket: Basket?

    /// UI Animation을 위한 타이머
    var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(aTarget: AnyObject, basket: Basket) {
        self.frame = CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getAppFullHeight())
        self.aTarget = aTarget
        self.basket = basket
    }
    
    func setInitTimer() {
        if let t = self.timer, t.isValid {
            t.invalidate()
        }
    }
    
    func showAnimationView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .beginFromCurrentState,
                       animations: {
                        self.alpha = 1.0
        }) { (isFinished) in
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.viewRemove), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func viewRemove() {
        setInitTimer()
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .beginFromCurrentState,
                       animations: {
                        self.alpha = 0.0
        }) { (isFinished) in
            self.removeFromSuperview()
        }
    }
    
    
    @IBAction func closePopupBtnAction(_ sender: UIButton) {
        viewRemove()
    }
    
    @IBAction func closeNmoveToBtnAction(_ sender: UIButton) {
        viewRemove()
        
        if let vc = self.aTarget as? NFXCListViewController,
            let data = self.basket {
            vc.onBtnCellJustLinkStr(smartCartUrl(isFresh: data.isFresh))
        }
    }
}
