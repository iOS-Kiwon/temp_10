//
//  SCH_DAYTypeCell.swift
//  GSSHOP
//
//  Created by admin on 2020/07/03.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class SCH_DAYTypeCell: UITableViewCell {

    var celldic:SListDate?
    var todayYN:Bool = false

    @IBOutlet weak var dayCell: UIView!
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var dayTextView: UILabel!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    @objc var bTarget: SListTBViewController?
    @objc var indexPos = 0
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.dayCell.frame = self.frame
        self.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
        self.addSubview(self.dayCell)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.dayTextView.text = ""
        self.titleTextView.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.selected()
        }
        else {
            self.unSelected()
        }
    }
    
    func selected() {
        if self.celldic != nil {
            self.dayTextView.textColor = UIColor.getColor("EE1F60")
            self.titleTextView.textColor = UIColor.getColor("EE1F60")
            self.viewSelected.isHidden = false
            self.viewSelected.backgroundColor = UIColor.white
        }
    }
    
  

    func unSelected() {
        if self.celldic != nil {
            self.dayTextView.textColor = UIColor.getColor("FFFFFF")
            self.titleTextView.textColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.64)

            if self.todayYN {
                self.viewSelected.isHidden = false
                self.viewSelected.backgroundColor = UIColor(red: 17.0 / 255.0, green: 17.0 / 255.0, blue: 17.0 / 255.0, alpha: 0.28)
            }
            else {
                self.viewSelected.isHidden = true
            }
        }
        else {
        }
    }

    @IBAction func onBtnCell(_ sender: Any) {
        if self.bTarget != nil {
            self.bTarget?.onBtnNaviDay(self.celldic?.toJSON(), cellIndex: indexPos)
        }
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoArr:Dictionary<String, Any>) {
        self.celldic = SListDate(JSON: rowinfoArr)
        if let dic = self.celldic {
            
            self.dayTextView.text = "\(dic.day)일"
            self.titleTextView.text = dic.week
            self.todayYN = dic.todayYn == "Y" ? true : false
            self.btnCell.accessibilityLabel = dic.week+"\(dic.day)일"
        }
        
        self.viewSelected.layer.cornerRadius = 3.0
        self.viewSelected.layer.shouldRasterize = true
        self.viewSelected.layer.rasterizationScale = UIScreen.main.scale
        self.viewSelected.layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.16).cgColor
        self.viewSelected.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.viewSelected.layer.shadowRadius = 4.0/2.0 //=blur/2 = radius
        
    }
    
   
}
