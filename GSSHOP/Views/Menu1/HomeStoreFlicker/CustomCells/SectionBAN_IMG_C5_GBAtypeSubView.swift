//
//  SectionBAN_IMG_C5_GBAtypeSubView.swift
//  GSSHOP
//
//  Created by Kiwon on 10/09/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_IMG_C5_GBAtypeSubView: UIView {
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var button: UIButton!
    /// Cell이 생성된 ViewController
    var aTarget: AnyObject?
    /// 링크 Url
    var product: Module?
    /// 인덱스
    var index: Int = 0

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
        
    @IBAction func btnAction(_ sender: UIButton) {
        if let data = product {
            
            if let setcionTB = self.aTarget as? SectionTBViewController {
                setcionTB.touchEventDealCell(data.toJSON())
            } else if let nfxTB = self.aTarget as? NFXCListViewController {
                nfxTB.dctypetouchEventTBCell(dic: data.toJSON(), index: index, viewType: Const.ViewType.BAN_IMG_CX_GBA.name)
            }
        }
    }
}
