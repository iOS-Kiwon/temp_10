//
//  BAN_IMG_CX_GBATypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/06/01.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_IMG_CX_GBATypeCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var stackViewLeading: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailing: NSLayoutConstraint!
    
    private var module: Module?
    
    /// Cell이 생성된 ViewController
    @objc var aTarget: NFXCListViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in self.stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }

    
    // 상풍 정보 렌더링
    @objc func setData(_ module: Module, target: NFXCListViewController?, indexPath: IndexPath) {
        self.module = module
        self.aTarget = target
        
        // 서비스 데이터가 2개인 경우 가로형 뷰를 보여줘야 한다.
        let moduleCount = module.moduleList.count
        if moduleCount == 2 {
            drow2moduleView(module: module, indexPath: indexPath)
            return
        }
        
        self.stackView.distribution = .equalSpacing
        if moduleCount == 4 {
            if isiPhone5() {
                self.stackViewLeading.constant = 0.0
                self.stackViewTrailing.constant = 0.0
            } else {
                self.stackViewLeading.constant = 16.0
                self.stackViewTrailing.constant = 16.0
            }
        } else if moduleCount == 3 {
            self.stackViewLeading.constant = 24.0
            self.stackViewTrailing.constant = 24.0
        }
        
        for sub in module.moduleList {
            
            guard let subView = Bundle.main.loadNibNamed(SectionBAN_IMG_C5_GBAtypeSubView.reusableIdentifier, owner: self, options: nil)?.first as? SectionBAN_IMG_C5_GBAtypeSubView else {
                return
            }
            subView.titleLbl.text = sub.title1
            subView.aTarget = self.aTarget
            subView.product = sub
            subView.index = indexPath.row
            
            subView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            ImageDownManager.blockImageDownWithURL(sub.imageUrl as NSString) { (statusCode, image, imgUrl, isInCache, error) in
                if error != nil || statusCode == 0 {
                    return
                }
                
                if isInCache.boolValue {
                    subView.imgView.image = image
                } else {
                    subView.imgView.alpha = 0
                    subView.imgView.image = image
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        subView.imgView.alpha = 1
                    }, completion: nil)
                }
            }
            self.stackView.addArrangedSubview(subView)
            
            // 접근성 추가
            subView.button.isAccessibilityElement = true
            subView.button.accessibilityLabel = sub.title1
            if self.accessibilityElements == nil {
                self.accessibilityElements = [subView.button]
            } else {
                self.accessibilityElements?.append(subView.button)
            }
        }
    }
    
    
    private func drow2moduleView(module: Module, indexPath: IndexPath) {
        
        self.stackView.distribution = .fillEqually
        
        if isiPhone5() {
            self.stackView.spacing = 12.0
            self.stackViewLeading.constant = 12.0
            self.stackViewTrailing.constant = 0.0
        } else {
            self.stackView.spacing = 26.0
            self.stackViewLeading.constant = 26.0
            self.stackViewTrailing.constant = 0.0
        }
        
        for sub in module.moduleList {
            guard let subView = Bundle.main.loadNibNamed(BAN_IMG_CX_GBATypeSubView2.reusableIdentifier, owner: self, options: nil)?.first as? BAN_IMG_CX_GBATypeSubView2 else {
                return
            }

            subView.titleLbl.text = sub.title1
            subView.aTarget = self.aTarget
            subView.index = indexPath.row

            subView.product = sub
            
            ImageDownManager.blockImageDownWithURL(sub.imageUrl as NSString) { (statusCode, image, imgUrl, isInCache, error) in
                if error != nil || statusCode == 0 {
                    return
                }
                
                if isInCache.boolValue {
                    subView.imgView.image = image
                } else {
                    subView.imgView.alpha = 0
                    subView.imgView.image = image
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        subView.imgView.alpha = 1
                    }, completion: nil)
                }
            }
            
            if sub === module.moduleList.last {
                subView.horizontalView.isHidden = true
            } else {
                subView.horizontalView.isHidden = false
            }
            
            self.stackView.addArrangedSubview(subView)
            
            // 접근성 추가
            subView.button.isAccessibilityElement = true
            subView.button.accessibilityLabel = sub.title1
            if self.accessibilityElements == nil {
                self.accessibilityElements = [subView.button]
            } else {
                self.accessibilityElements?.append(subView.button)
            }
        }
        return
    }
}
