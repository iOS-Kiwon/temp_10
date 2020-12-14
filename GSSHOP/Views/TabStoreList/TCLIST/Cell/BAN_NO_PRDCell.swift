//
//  BAN_NO_PRDCell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/07/17.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_NO_PRDCell: BaseTableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var subNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLbl.text = ""
        self.subNameLbl.text = ""
        
        self.isAccessibilityElement = false
        self.nameLbl.isAccessibilityElement = false
        self.subNameLbl.isAccessibilityElement = false
        self.nameLbl.accessibilityLabel = ""
        self.subNameLbl.accessibilityLabel = ""
    }

    @objc func setData(_ dic: Dictionary<String, Any>) {
        guard let prd = Module(JSON: dic) else { return }
        self.nameLbl.text = prd.name
        self.subNameLbl.text = prd.subName
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = .staticText
        self.accessibilityLabel = prd.name + " " + prd.subName
    }
    
}
