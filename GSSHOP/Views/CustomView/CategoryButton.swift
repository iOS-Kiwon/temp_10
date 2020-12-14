//
//  CategoryButton.swift
//  GSSHOP
//
//  Created by Kiwon on 30/09/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class CategoryButton: UIButton {
    
    private let MARGIN: CGFloat = 16.0
    var HEIGHT: CGFloat = 32.0
    
    /// 버튼 타이틀
    var title: String? {
        didSet {
            self.setTitle(self.title, for: .normal)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            super.isSelected = newValue
        }
        
        didSet {
            if self.isSelected {
                self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
            } else {
                self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc convenience init(title: String) {
        self.init(frame: .zero)
        self.setInitUI(title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func setInitUI(title: String) {
        self.setTitle(title, for: .normal)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.lineBreakMode = .byClipping
        self.titleLabel?.textColor = .white
        
        bgColorForNormal()
        bgColorForSelected()
        titleColorForNormal()
        titleColorForSelected()
        
        // frame 설정
        self.titleLabel?.sizeToFit()
        let labelWidth: CGFloat = self.titleLabel?.frame.width ?? 0.0
        var newWidth = (MARGIN * 2) + labelWidth
        // 최소사이즈 결정
        if newWidth < 62.0 {
            newWidth = 62.0
        }
        let size = CGSize(width: newWidth, height: HEIGHT)
        self.frame = CGRect(origin: self.frame.origin, size: size)
        
        self.setCorner()
        self.clipsToBounds = true
    }

    @objc func bgColorForNormal(_ color: UIColor = .clear) {
        self.setBackgroundColor(color, for: .normal)
        self.setBackgroundColor(color, for: [.selected, .highlighted])
    }
    
    @objc func bgColorForSelected(_ color: UIColor = UIColor.getColor("00aebd")) {
        self.setBackgroundColor(color, for: .highlighted)
        self.setBackgroundColor(color, for: .selected)
    }
    
    @objc func titleColorForNormal(_ color: UIColor = UIColor.getColor("666666")) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: [.selected, .highlighted])
    }
    
    @objc func titleColorForSelected(_ color: UIColor = .white) {
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .selected)
    }
}
