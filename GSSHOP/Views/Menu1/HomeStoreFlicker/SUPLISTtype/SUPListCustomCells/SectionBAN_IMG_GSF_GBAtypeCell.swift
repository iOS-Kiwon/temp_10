//
//  SectionBAN_IMG_GSF_GBAtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 23/08/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
class SectionBAN_IMG_GSF_GBAtypeCell: UITableViewCell {
    
    @IBOutlet weak var topTooltipView: UIView!
    @IBOutlet weak var topTooltipImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topTooltipLblHeight: NSLayoutConstraint!
    @IBOutlet weak var topTooltipViewHight: NSLayoutConstraint!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnDeli: UIButton!
    @IBOutlet weak var btnGSfresh: UIButton!
    @IBOutlet weak var lconstImageWidth: NSLayoutConstraint!
    @IBOutlet weak var viewWhiteCover: UIView!    

    @objc var aTarget: AnyObject?
    @objc var viewType: String = ""
    private var taskToolTip: DispatchWorkItem?
    private var product: Module?
 
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.getColor("404BAE")
        
        initTaskTooltip()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewType = ""
        self.imgLogo.isHighlighted = false
        self.btnDeli.isHidden = true
        self.product = nil
        // 상단 새벽배송 안내뷰 - 숨기기
        self.topTooltipView.isHidden = true
//        self.topTooltipViewHight.constant = 0.0
//        self.topTooltipImgViewHeight.constant = 0.0
//        self.topTooltipLblHeight.constant = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// 해당 Cell이 아래 Queue가 동작하기 전에 사라질때, Queue Cancel을 위함.
    private func initTaskTooltip() {
        self.taskToolTip = DispatchWorkItem(block: {
            [weak self] in
            guard let method = self?.aTarget?.showTooltip else { return }
            method(self)
        })
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        
        guard let product = Module(JSON: rowinfoDic) else { return }
        self.viewType = product.viewType
        self.product = product
        
        if product.viewType == "BAN_IMG_GSF_GBB" {
            self.btnDeli.isHidden = false
            self.imgLogo.isHighlighted = false
            self.btnDeli.isSelected = false
            self.lconstImageWidth.constant = 198;
            self.viewWhiteCover.isHidden = true
        } else if product.viewType == "BAN_IMG_GSF_GBC" {
            self.btnDeli.isHidden = false
            self.imgLogo.isHighlighted = true
            self.btnDeli.isSelected = true
            self.lconstImageWidth.constant = 198;
            self.viewWhiteCover.isHidden = true
        } else if product.viewType == "BAN_IMG_GSF_GBD" {
            self.btnDeli.isHidden = true
            self.imgLogo.isHighlighted = false
            self.lconstImageWidth.constant = 198
            self.viewWhiteCover.isHidden = false
        } else if product.viewType == "BAN_IMG_GSF_GBE" {
            self.btnDeli.isHidden = false
            self.btnDeli.isSelected = false
            self.imgLogo.isHighlighted = false
            self.lconstImageWidth.constant = 198
            self.viewWhiteCover.isHidden = false
        } else {
            //GBA
            self.btnDeli.isHidden = true
            self.imgLogo.isHighlighted = false
            self.lconstImageWidth.constant = 198;
            self.viewWhiteCover.isHidden = true
        }
        // (공통) 상단 새벽배송 안내뷰 - 숨기기
        self.topTooltipView.isHidden = true
        self.topTooltipViewHight.constant = 0.0
        
        
        //당일에서 새벽버튼 클릭시 : A00481-ED-1
        //새벽에서 당일버튼 클릭시 : A00481-DD-1
        
        // 접근성 설정
        // GS fresh(당일배송) 이미지 베너
        let  accessStr = product.productName
        if accessStr.count > 0 {
            self.accessibilityLabel = accessStr
        } else {
            self.accessibilityLabel = "이미지 베너 입니다."
        }
        
        self.layoutIfNeeded()
    }
    
    @IBAction func onBtnDeliChange(sender: UIButton) {
        
        guard let subProduct = self.product?.subProductList.first else { return }
        
        let wiseLog = subProduct.wiseLog
        if wiseLog.count > 0, wiseLog.hasPrefix("http"), let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.wiseLogRestRequest(wiseLog)
        }
        
        guard let method = self.aTarget?.changeMartDelivery else { return }
        method(subProduct.linkUrl)
        
    }
    
    func showTopView(isHidden: Bool) {
        
        if isHidden {
            // 숨기기
            self.topTooltipView.isHidden = true
            self.topTooltipViewHight.constant = 0.0
        } else {
            self.topTooltipView.isHidden = true
            self.topTooltipViewHight.constant = 0.0
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            if appDelegate.isShowGsFreshTopView {
                return
            }
            
            // 상단 새벽배송 안내뷰 - 보이기
            self.topTooltipView.isHidden = false
            self.topTooltipViewHight.constant = 46.0
        }
    }
    
    @objc func showTopView() {
        guard let task = self.taskToolTip else { return }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDelegate.isActivateGsFreshTopView {
            return
        }
        DispatchQueue.main.async(execute: task)
    }
    
    @objc func cancelTaskToopTip() {
        if self.viewType == "BAN_IMG_GSF_GBE" || self.viewType == "BAN_IMG_GSF_GBB" {
            guard let task = self.taskToolTip else { return }
            task.cancel()
            initTaskTooltip()
        }
    }
}
