//
//  BAN_IMG_CX_GBATypeSubView2.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/06/02.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_IMG_CX_GBATypeSubView2: UIView {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var horizontalView: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    /// Cell이 생성된 ViewController
    var aTarget: NFXCListViewController?
    /// 링크 Url
    var product: Module?
    /// 인덱스
    var index: Int = 0
    
    @IBAction func btnAction(_ sender: UIButton) {
        if let data = self.product {
            self.aTarget?.dctypetouchEventTBCell(dic: data.toJSON(), index: index, viewType: Const.ViewType.BAN_IMG_CX_GBA.name)
        }
    }
}
