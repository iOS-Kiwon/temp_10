//
//  WebPrdVipView.swift
//  GSSHOP
//
//  Created by Home on 04/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdVipView: UIView {
    
    private let BETWEEN_VIP_MARGIN: CGFloat = 12.0
    private let VERTICAL_SPACING_MARGIN: CGFloat = 4.0

    /// vip 베이스 뷰 객체
    @IBOutlet weak var baseView: UIView!
    
    private var gradeViewList = [WebPrdVipSubView]()
    
    private var grade01View: WebPrdVipSubView?
    private var grade02View: WebPrdVipSubView?
    private var grade03View: WebPrdVipSubView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ data: Components) {

        for gradeData in data.gradePmoInfo {

            if let vipSubView = Bundle.main.loadNibNamed(WebPrdVipSubView.className, owner: self, options: nil)?.first as? WebPrdVipSubView {
                self.baseView.addSubview(vipSubView)
                vipSubView.translatesAutoresizingMaskIntoConstraints = false
                vipSubView.setData(gradeData)
                self.gradeViewList.append(vipSubView)
            }
        }
        
        // 뷰 오토레이아웃 적용
        var lastAddedView: UIView?
        let margin: CGFloat = BETWEEN_VIP_MARGIN
        let limitedWidth = getAppFullWidth() - (14*2)
        var currentWidth: CGFloat = 0.0
        
        for (index, view) in self.gradeViewList.enumerated() {
            view.layoutIfNeeded()
            
            let nowWidth = view.frame.width
        
            if index == 0 {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: self.baseView.topAnchor),
                    view.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor),
                ])
                currentWidth = nowWidth + margin
                lastAddedView = view
                continue
            }
            
            // 옆에 붙힐지 아래에 붙힐지 결정!
            if currentWidth + nowWidth > limitedWidth {
                // 아래로 붙히기
                let trailingConstraint = lastAddedView!.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor)
                trailingConstraint.priority = UILayoutPriority(rawValue: 250)
                NSLayoutConstraint.activate([
                    trailingConstraint,
                    
                    view.topAnchor.constraint(equalTo: lastAddedView!.bottomAnchor, constant: VERTICAL_SPACING_MARGIN),
                    view.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor)
                ])
                
                currentWidth = (nowWidth + margin)
            } else {
                // 옆에 붙히기
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: lastAddedView!.topAnchor),
                    view.leadingAnchor.constraint(equalTo: lastAddedView!.trailingAnchor, constant: BETWEEN_VIP_MARGIN),
                ])
                
                currentWidth += (nowWidth + margin)
            }
            lastAddedView = view
        }
        
        if lastAddedView != nil {
            let trailingConstraint = lastAddedView!.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor)
            trailingConstraint.priority = .defaultLow
            trailingConstraint.isActive = true
            lastAddedView!.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor).isActive = true
        }
        
    }
    
}
