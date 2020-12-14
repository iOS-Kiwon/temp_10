//
//  SectionBTStypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 28/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class SectionBTStypeCell: UITableViewCell {
    ///텍스트 라벨
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lblTitle.text = ""
    }
    
    ///셀 구성정보를 포함하고있는 딕셔너리 셋팅
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let product = Module(JSON: rowinfoDic) else { return }
        
        self.backgroundColor = .clear
        self.lblTitle.text = product.productName
    }
}
