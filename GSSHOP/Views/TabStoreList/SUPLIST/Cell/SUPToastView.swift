//
//  SUPToastView.swift
//  GSSHOP
//
//  Created by admin on 2020/09/14.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class SUPToastView: UIView {
    
    @objc var aTarget: AnyObject?
    @IBOutlet var viewDimmBG: UIView!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblDeleveryTime: UILabel!
    var dicRow: Module?
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDimmBG.layer.cornerRadius = 2.0
        viewDimmBG.layer.shouldRasterize = true
        viewDimmBG.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    @objc func setToastInfo(_ dicInfo: Dictionary<String, Any>) {
        guard let product = Module(JSON: dicInfo) else { return }
        self.dicRow = product
        self.lblDesc.text = self.dicRow?.productName
        self.lblDeleveryTime.text = self.dicRow?.promotionName

        self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fadeOutSelf), userInfo: nil, repeats: false)
    }

    @objc func fadeOutSelf() {
        //SL(Date(), GS_SUPER_TOAST)
        Common_Util.setLocalData(Date(), forKey: GS_SUPER_TOAST)
        if self.timer?.isValid ?? false {
            self.timer?.invalidate()
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .beginFromCurrentState,
            animations: {
                self.alpha = 0.0
            }) { finished in
                self.removeFromSuperview()
            }
    }
    
    @IBAction func onBtnGoDetail(_ sender: Any) {
        let strLink = self.dicRow?.linkUrl
        guard let method = self.aTarget?.onBtnSUPCellJustLinkStr else { return }
        method(strLink)
        self.fadeOutSelf()
    }
    
}
