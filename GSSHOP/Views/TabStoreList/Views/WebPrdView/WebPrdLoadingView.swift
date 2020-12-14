//
//  WebPrdLoadingView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/03/09.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdLoadingView: UIView {
    
    @IBOutlet weak var skeletonView: SkeletonView!
    @IBOutlet var views: [UIView]!
    
    @IBOutlet var circleView: [UIView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 동그라미가 될 뷰 설정
        self.circleView.forEach { (view) in
            view.layer.masksToBounds = true
            view.layer.cornerRadius = view.frame.height / 2
        }
    }
    
    func setMaskingViews() {
        self.skeletonView.setMaskingViews(self.views)
    }
}

extension UIView {
    func setMaskingViews(_ views:[UIView]){

        let mutablePath = CGMutablePath()

        //Append path for each subview
        views.forEach { (view) in
            guard self.subviews.contains(view) else{
                fatalError("View:\(view) is not a subView of \(self). Therefore, it cannot be a masking view.")
            }
            //Check if ellipse
            if view.layer.cornerRadius == view.frame.size.height / 2, view.layer.masksToBounds{
                //Ellipse
                mutablePath.addEllipse(in: view.frame)
            }else{
                //Rect
                mutablePath.addRect(view.frame)
            }
        }
        
        //Create layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = mutablePath
        
        //Apply layer as a mask
        self.layer.mask = maskLayer
    }
}
