//
//  WebPrdSlider.swift
//  GSSHOP
//
//  Created by Home on 25/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdSlider: UISlider {
    
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let adjustThumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        
        let thumbOffsetToApplyOnEachSide:CGFloat = adjustThumbRect.size.width / 2.0
        let minOffsetToAdd = -thumbOffsetToApplyOnEachSide
        let maxOffsetToAdd = thumbOffsetToApplyOnEachSide
        
        var betweenValue: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        if betweenValue != 0 {
            betweenValue = CGFloat(value) / betweenValue
        }
        
        let offsetForValue = minOffsetToAdd + (maxOffsetToAdd - minOffsetToAdd) * betweenValue
        var origin = adjustThumbRect.origin
        origin.x += offsetForValue
        return CGRect(origin: origin, size: adjustThumbRect.size)
    }
}
