//
//  recommendedRelatedSearchCell.swift
//  GSSHOP
//
//  Created by admin on 2020/05/18.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class recommendedRelatedSearchCell: UICollectionViewCell {

    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var lineView: UIView!
    @objc var atarget:MainSearchView?
    var colorArray:Array = ["A5B511","84B433","62B256","42B178","00AEBD"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textView.text = ""
    }
    
    @objc func setDisplayDic(_ dic:NSDictionary, index:Int) {
        if let value = dic.object(forKey:"rtq") as? String {
            self.textView.text = value
            let i = index%5
            let color = self.colorArray[i]
            print("aaaaaaa:"+i.toString+" "+color)
            self.lineView.layer.cornerRadius = self.frame.height/2
            self.lineView.layer.borderColor = UIColor.getColor(color).cgColor
            self.lineView.layer.borderWidth = 1
        }
        else {
            self.textView.text = ""
        }
    }

}
