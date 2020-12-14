//
//  SectionMAP_CX_GBB_TITLEtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 11/12/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionMAP_CX_GBB_TITLEtypeCell: UITableViewCell {
    
    
    private var mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    private var mBanButton:UIButton = UIButton(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    

    private var product: Module!
    @objc var aTarget: AnyObject?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(self.mBanner)
        self.mBanButton.backgroundColor = .clear
        self.mBanButton.addTarget(self, action: #selector(self.moreBtnAction(_:)), for: .touchUpInside)
        self.mBanButton.addTarget(self, action: #selector(self.Btn_pressed(_:)), for: .touchDown)
        self.mBanButton.addTarget(self, action: #selector(self.Btn_released(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        self.mBanner.addSubview(self.mBanButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mBanner.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let product = Module(JSON: rowinfoDic) else { return }
        self.product = product
        self.mBanner.makeGBAview(islink: (self.product.linkUrl.count > 0), title: product.productName)
        self.mBanner.setUnderLine(use: true)
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget as? SUPListTableViewController,
            self.product.linkUrl.isEmpty == false {
            
            let logUrl = "?mseq=A00481-BA-1"
            applicationDelegate.wiseAPPLogRequest(logUrl)
            vc.onBtnSUPCellJustLinkStr(self.product.linkUrl)
        }
    }
    
    @IBAction func Btn_pressed(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:true)
    }
    //.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel
    @IBAction func Btn_released(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:false)
    }
    
}
