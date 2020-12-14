//
//  SectionBAN_IMG_C5_GBAtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 10/09/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_IMG_C5_GBAtypeCell: UITableViewCell {
    
    /// Horizontal Stack View
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var stackViewTopAc: NSLayoutConstraint!
    
    /// Cell이 생성된 ViewController
    @objc var aTarget: SectionTBViewController?
    
    var moreLinkUrl:String?
    
    private var mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    private var mBanButton:UIButton = UIButton(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.topView.addSubview(self.mBanner)
        self.mBanButton.backgroundColor = .clear
        self.mBanButton.addTarget(self, action: #selector(self.moreBtnAction(_:)), for: .touchUpInside)
        self.mBanButton.addTarget(self, action: #selector(self.Btn_pressed(_:)), for: .touchDown)
        self.mBanButton.addTarget(self, action: #selector(self.Btn_released(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        self.mBanner.addSubview(self.mBanButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in self.stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        self.mBanner.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func Btn_pressed(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:true)
    }
    
    @IBAction func Btn_released(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:false)
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        if let sectionTB = self.aTarget, !((self.moreLinkUrl ?? "").isEmpty) {
            sectionTB.delegatetarget.touchEventTBCellJustLinkStr?(self.moreLinkUrl)
        }
    }
    
    // 상풍 정보 렌더링
    @objc func setCellInfoNDrawData(_ rowinfoDic: [String: AnyObject]) {
        guard let product = Module(JSON: rowinfoDic) else { return }
        // kiwon : 2019.11.21 윤미정님 검수로 폰트사이즈 17 -> 19로 올려달라고 함. ->12월 17로 통일됨
        // 20200225 parksegun 타이틀값 없으면 영역 제거 : https://jira.gsenext.com/browse/SQA-394
        if product.productName.count > 0 || product.promotionName.count > 0 || product.imageUrl.count > 0 {
            self.topView.isHidden = false
            self.stackViewTopAc.constant = 57
            self.mBanner.makeGBAview(imageUrl: product.imageUrl, islink: !product.linkUrl.isEmpty , title: product.productName, subTittle: product.promotionName)

            self.mBanner.isAccessibilityElement = true
            self.mBanner.accessibilityLabel = product.productName
            
            if self.accessibilityElements == nil {
                self.accessibilityElements = [self.mBanner]
            } else {
                self.accessibilityElements?.append(self.mBanner)
            }
            
        }
        else {
            //영역 비노출
            self.topView.isHidden = true
            self.stackViewTopAc.constant = 0
        }
        self.mBanner.setUnderLine(use: (!product.bdrBottomYn.isEmpty && product.bdrBottomYn == "Y"))
        
        self.moreLinkUrl = product.linkUrl
        
        // 서비스 데이터가 2개인 경우 가로형 뷰를 보여줘야 한다.
        if product.subProductList.count == 2 {
            drow2productView(product: product)
            return
        }
        
        self.stackView.distribution = .equalSpacing
        
        //가상 더미뷰
        self.stackView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 98)))
        
        for subProduct in product.subProductList {
            
            guard let subView = Bundle.main.loadNibNamed(SectionBAN_IMG_C5_GBAtypeSubView.reusableIdentifier, owner: self, options: nil)?.first as? SectionBAN_IMG_C5_GBAtypeSubView else {
                return
            }
            subView.titleLbl.text = subProduct.productName
            subView.aTarget = self.aTarget
            subView.product = subProduct
            
            if product.subProductList.count == 5 {
                subView.frame = CGRect(x: 0, y: 0, width: 64, height: 90)
                subView.viewWidth.constant = 64.0
                subView.imgViewWidth.constant = 52.0
                subView.imgViewHeight.constant = 52.0
            } else {
                subView.frame = CGRect(x: 0, y: 0, width: 80, height: 90)
            }
            
            ImageDownManager.blockImageDownWithURL(subProduct.imageUrl as NSString) { (statusCode, image, imgUrl, isInCache, error) in
                if error != nil || statusCode == 0 || image == nil {
                    subView.imgView.image = UIImage(named: Const.Image.ic_skeleton_circle_56.name)
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
            subView.button.accessibilityLabel = subProduct.productName
            if self.accessibilityElements == nil {
                self.accessibilityElements = [subView.button]
            } else {
                self.accessibilityElements?.append(subView.button)
            }
        }
        //가상 더미뷰
        self.stackView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 98)))
    }
    
    
    private func drow2productView(product: Module) {
        for subProduct in product.subProductList {
            guard let subView = Bundle.main.loadNibNamed(SectionBAN_IMG_C5_GBAtypeSubView2.reusableIdentifier, owner: self, options: nil)?.first as? SectionBAN_IMG_C5_GBAtypeSubView2 else {
                return
            }

            subView.topTitleLbl.text = subProduct.promotionName
            subView.botTitleLbl.text = subProduct.productName
            subView.aTarget = self.aTarget
            subView.product = subProduct
            subView.horizontalLiveView.isHidden = true
            
            ImageDownManager.blockImageDownWithURL(subProduct.imageUrl as NSString) { (statusCode, image, imgUrl, isInCache, error) in
                if error != nil || statusCode == 0 || image == nil{
                    subView.imgView.image = UIImage(named: Const.Image.ic_skeleton_circle_56.name)
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
            
            // 접근성 추가
            subView.button.isAccessibilityElement = true
            subView.button.accessibilityLabel = "\(subProduct.promotionName) \(subProduct.productName)"
            if self.accessibilityElements == nil {
                self.accessibilityElements = [subView.button]
            } else {
                self.accessibilityElements?.append(subView.button)
            }
            
            self.stackView.addArrangedSubview(subView)
        }
        return
    }
}
