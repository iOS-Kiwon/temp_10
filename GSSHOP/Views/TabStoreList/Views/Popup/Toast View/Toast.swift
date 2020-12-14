//
//  Toast.swift
//  GSSHOP
//
//  Created by Kiwon on 05/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

private enum ToastDuration: Int {
    case short, `default`, long
    var value: CGFloat {
        switch self {
        case .short:
            return 1.0
        case .default:
            return 2.0
        case .long:
            return 3.0
        }
    }
}

@objcMembers
class Toast: UIView {
    
    static var toast: Toast?
    
    private let HorizontalPadding: CGFloat  =               40.0
    private let VerticalPadding : CGFloat   =               26.0
    
    private let LabelVerticalPositionRatio : CGFloat    =        0.50
    private let LabelHorizontalPositionRatio : CGFloat  =        0.50
    
    private let VerticalPositionRatio : CGFloat     =          0.50
    private let HorizontalPositionRatio : CGFloat   =          0.83
    
    private var label: UILabel!
    private var duration: CGFloat = ToastDuration.default.value
    private var text: String = ""

    init(withDuration duration: CGFloat, andText message: String) {
        super.init(frame: .zero)
        self.duration = duration
        self.text = message
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        self.label.font = UIFont.systemFont(ofSize: 15.0)
        self.label.text = self.text
        self.label.numberOfLines = 10
        self.label.adjustsFontSizeToFitWidth = true
        
        var frame = CGRect.zero
        frame.size = self.label.sizeThatFits(self.label.frame.size)
        self.label.frame = frame
        
        frame.size = CGSize(width: frame.size.width + HorizontalPadding, height: frame.size.height + VerticalPadding)
        self.frame = frame
        
        self.label.center = CGPoint(x: frame.size.width * LabelHorizontalPositionRatio, y: frame.size.height * LabelVerticalPositionRatio)
        
        self.label.layer.shadowRadius = 1.0
        self.label.layer.shadowOpacity = 0.75
        self.label.layer.shadowColor = UIColor.black.cgColor
        self.label.layer.shadowOffset = .zero
        self.addSubview(self.label)
        
        self.label.textColor = .white
        self.label.backgroundColor = .clear
        
        self.layer.borderColor = UIColor(white: 0.70, alpha: 0.80).cgColor
        self.layer.borderWidth = 0.0
        
        self.backgroundColor = UIColor(white: 0.30, alpha: 0.90)
        self.layer.cornerRadius = 22.0
        
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func show( _ message: String) {
        Toast.show(ToastDuration.default.value, andText: message)
    }
    
    static func show( _ message: String, inView view: UIView) {
        Toast.show(ToastDuration.default.value, andText: message, inView: view)
    }
    
    static func show( _ duration: CGFloat, andText message: String) {
        if let view = UIApplication.shared.keyWindow!.rootViewController?.view {
            Toast.show(ToastDuration.default.value, andText: message, inView: view)
        }
    }
    
    static func show( _ duration: CGFloat, andText message: String, inView view: UIView) {
        if let tst = self.toast {
            tst.removeFromSuperview()
        }
        toast = Toast(withDuration: duration, andText: message)
        toast!.displayInView(view)
    }
    
    func displayInView(_ view: UIView) {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            self.center = CGPoint(x: view.frame.size.width * VerticalPositionRatio, y: view.frame.size.height * HorizontalPositionRatio)
        } else {
            self.center = CGPoint(x: view.frame.size.height * VerticalPositionRatio, y: view.frame.size.width * HorizontalPositionRatio)
        }
        self.alpha = 0.0
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        self.alpha = 1.0
        }) { (isFinish) in
            UIView.animate(withDuration: 0.5, 
                           delay: TimeInterval(self.duration),
                           options: .curveEaseOut,
                           animations: {
                            self.alpha = 0.0
            }, completion: { (isFinish) in
                self.removeFromSuperview()
            })
        }
    }
}

private extension UIView {
    var insetsForSafeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }
}
