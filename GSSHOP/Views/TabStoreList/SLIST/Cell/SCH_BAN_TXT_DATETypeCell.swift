//
//  SCH_BAN_TXT_DATETypeCell.swift
//  GSSHOP
//
//  Created by admin on 2020/07/01.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//


import UIKit

@objc class SCH_BAN_TXT_DATETypeCell: UITableViewCell {
    @IBOutlet var dateText:UILabel!
    @IBOutlet var viewTextBG:UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.dateText.text = ""
        self.viewTextBG.layer.cornerRadius = 12.0
        self.viewTextBG.layer.borderWidth = 1.0
        self.viewTextBG.layer.borderColor = UIColor.init(red: 17.0/255.0, green: 17.0/255.0, blue: 17.0/255.0, alpha: 0.1).cgColor
        self.viewTextBG.layer.shouldRasterize = true
        self.viewTextBG.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        self.dateText.text = ""
    }

    @objc func setCellInfoNDrawData(_ rowinfoArr:Dictionary<String, Any>) {
        if let data = Module(JSON: rowinfoArr) {
            self.dateText.text = data.startTime
        }
        self.viewTextBG.layoutIfNeeded()
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
    

