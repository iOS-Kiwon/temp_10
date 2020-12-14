//  SectionBAN_IMG_C5_GBAtypeSubView2.swift
//  GSSHOP
//
//  Created by Kiwon on 19/09/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_IMG_C5_GBAtypeSubView2: UIView {
    
    /// Cell이 생성된 ViewController
    var aTarget: SectionTBViewController?
    /// 링크 Url
    var product: Module?

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var topTitleLbl: UILabel!
    
    @IBOutlet weak var botTitleLbl: UILabel!
    
    @IBOutlet weak var horizontalLiveView: UIView!

    @IBOutlet weak var button: UIButton!
    
    @IBAction func btnAction(_ sender: UIButton) {
        if let data = self.product {
            self.aTarget?.touchEventDealCell(data.toJSON())
        }
    }
}
