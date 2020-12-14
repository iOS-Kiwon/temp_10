//
//  FXCTextHeaderViewSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 07/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class FXCTextHeaderViewSubCell: BaseCollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.titleLbl.textAlignment = .center
        self.titleLbl.backgroundColor = .clear
        self.titleLbl.text = ""
        self.titleLbl.textColor = .getColor("111111", alpha: 0.48)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLbl.text = ""
        self.titleLbl.textColor = .getColor("111111", alpha: 0.48)
    }
    
    func setTitleLabel(isSelected value: Bool) {
        if value {
            self.titleLbl.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
            self.titleLbl.textColor =   .getColor("111111")
        } else {
            self.titleLbl.font = UIFont.systemFont(ofSize: 16.0)
            self.titleLbl.textColor = .getColor("111111", alpha: 0.48)
        }
    }
}
