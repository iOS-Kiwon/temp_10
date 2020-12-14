//
//  SkeletonView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/05/15.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class SkeletonView: UIView {
    
    private let ANIMATION_KEY = "locations"
    
    var startLocations : [NSNumber] = [-0.5, -0.3, 0.0]
    var endLocations : [NSNumber] = [1.0,1.3,1.5]
    /// 하단 배경 색상
    var gradientBackgroundColor : CGColor = UIColor.getColor("EEEEEE").cgColor
    /// 움직이는 영역 색상
    var gradientMovingColor : CGColor = UIColor.getColor("d9d9d9").cgColor
    /// 움직이는 시간
    var movingAnimationDuration : CFTimeInterval = 2.5
    /// 재실행 될때까지의 딜레이 시간
    var delayBetweenAnimationLoops : CFTimeInterval = 0.0
    
    
    var gradientLayer : CAGradientLayer?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            gradientBackgroundColor,
            gradientMovingColor,
            gradientBackgroundColor
        ]
        gradientLayer.locations = self.startLocations
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
        
        startAnimating()
    }
   
    
    
    func startAnimating(){
        let animation = CABasicAnimation(keyPath: ANIMATION_KEY)
        animation.fromValue = self.startLocations
        animation.toValue = self.endLocations
        animation.duration = self.movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = self.movingAnimationDuration + self.delayBetweenAnimationLoops
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        if let layer = self.gradientLayer {
            layer.add(animationGroup, forKey: animation.keyPath)
        }
    }
    
    func stopAnimating() {
        
        if let layer = self.gradientLayer {
            
            if layer.animation(forKey: ANIMATION_KEY) != nil {
                layer.removeAnimation(forKey: ANIMATION_KEY)
            }
            layer.removeFromSuperlayer()
        }
        
    }
    
}
