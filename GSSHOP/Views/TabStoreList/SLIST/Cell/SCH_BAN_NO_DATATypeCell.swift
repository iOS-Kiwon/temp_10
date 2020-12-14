//
//  SCH_BAN_NO_DATATypeCell.swift
//  GSSHOP
//
//  Created by admin on 2020/06/30.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

@objc class SCH_BAN_NO_DATATypeCell: UITableViewCell {
    
    @IBOutlet var firstText:UILabel!
    @IBOutlet var seText:UILabel!
    @IBOutlet var lcontImageTop:NSLayoutConstraint!
    @IBOutlet var viewWhiteBG:UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.firstText.text = ""
        self.seText.text = ""
    }

    @objc func setCellInfoNDrawData(_ rowinfoDic:Dictionary<String, Any>) {
        if let dic:Module = Module(JSON: rowinfoDic) {
            self.firstText.text = dic.liveBenefitLText
            self.seText.text = dic.liveBenefitRText            
        }
        else {
            self.firstText.text = "상품 준비중입니다."
            self.seText.text = ""
        }
        
        self.lcontImageTop.constant = 8.0
        self.viewWhiteBG.isHidden = true
        self.layoutIfNeeded()
    }

    @objc func setCellInfoNDrawDatafromFresh() {
       self.firstText.text = "판매중인 상품이 없습니다.";
       self.seText.text = "";
       self.lcontImageTop.constant = 38.0;
       self.viewWhiteBG.isHidden = false;
       
       self.layoutIfNeeded()
    }
    
}
