//
//  SectionBAN_TXT_EXP_GBATypeSubView.swift
//  GSSHOP
//
//  Created by admin on 03/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_TXT_EXP_GBATypeSubView: UIView {
    @IBOutlet weak var lbRate: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vArrow: UIView!
    @IBOutlet weak var lbChageRate: UILabel!
    @IBOutlet weak var lbNew: UILabel!
    @IBOutlet weak var vNoChange: UIView!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var lbTitleLeading: NSLayoutConstraint!
    
    var aTarget: AnyObject?;                                                        //클릭시 이벤트를 보낼 타겟
    var selDic:Module?
    
    override func awakeFromNib() -> Void {
        super.awakeFromNib();
    }
    
    
    func showUnderLine() {
        self.underLine.isHidden = false
        self.lbTitleLeading.constant = 20.0 //확장일땐 25
    }
    
    func setDisplayDic(_ dic:Module) {
        selDic = dic
        self.lbRate.text = dic.saleQuantity
        self.lbTitle.text = dic.productName
        self.lbChageRate.text = String(dic.discountRate)
        
        self.lbTitleLeading.constant = 20.0//기본은 16
        
        self.vArrow.isHidden = true
        self.lbChageRate.isHidden = true
        self.lbNew.isHidden = true
        self.vNoChange.isHidden = true
        arrowDraw(dic.discountRateText)
    }
    
    func prepareForReuse() {
        self.lbRate.text = ""
        self.lbTitle.text = ""
        self.lbChageRate.text = ""
        self.vArrow.isHidden = true
        self.lbChageRate.isHidden = true
        self.lbNew.isHidden = true
        self.vNoChange.isHidden = true
        self.underLine.isHidden = true
    }
    
    ///삼각형을 그립니다. n : 새로 진입    u : 상승    d : 하락    f : 변화없음,
    func arrowDraw(_ value:String) {
        let view = self.vArrow
        var color:UIColor = UIColor.getColor("ee1f60") //UIColor(red: 238/255, green: 31/255, blue: 96/255, alpha: 1.0)
        
        let path = UIBezierPath()
        switch value {
        case "u":
            self.vArrow.isHidden = false
            self.lbChageRate.isHidden = false
            path.move(to: CGPoint(x: view!.frame.size.width/2, y: 0.0)) //꼭짓점
            path.addLine(to: CGPoint(x: view!.frame.size.width, y: view!.frame.size.height))
            path.addLine(to: CGPoint(x: 0.0, y: view!.frame.size.height))
            //238 31 96
            color = UIColor.getColor("ee1f60")
            break
        case "d":
            self.vArrow.isHidden = false
            self.lbChageRate.isHidden = false
            path.move(to: CGPoint(x: view!.frame.size.width/2, y: view!.frame.size.height)) //꼭짓점
            path.addLine(to: CGPoint(x: view!.frame.size.width, y: 0.0))
            path.addLine(to: CGPoint(x: 0.0, y: 0.0))
            color = UIColor.getColor("111111")
            break
        case "n":
            self.vArrow.isHidden = true
            self.lbChageRate.isHidden = true
            self.lbNew.isHidden = false
            self.vNoChange.isHidden = true
            break
        case "f":
            self.vArrow.isHidden = true
            self.lbChageRate.isHidden = true
            self.lbNew.isHidden = true
            self.vNoChange.isHidden = false
            break
        default:
            self.vArrow.isHidden = true
            self.lbChageRate.isHidden = true
            self.lbNew.isHidden = true
            self.vNoChange.isHidden = true
        }
        path.close()
        
        if !self.vArrow.isHidden {
            self.vArrow!.layer.sublayers?.forEach { $0.removeFromSuperlayer() } //이미 있던 sublayer를 제거 한다. (중복방지)
            let layer = CAShapeLayer()
            layer.frame = self.vArrow!.bounds
            layer.path = path.cgPath
            layer.fillColor = color.cgColor
            layer.lineWidth = 1.0
            self.vArrow!.layer.addSublayer(layer)
            self.lbChageRate.textColor = color
        }
    }
      
    
    @IBAction func wordClick(_ sender: Any) {
        guard let method = self.aTarget?.touchEventDealCell else { return }
        method(self.selDic?.toJSON())
    }
    
}
