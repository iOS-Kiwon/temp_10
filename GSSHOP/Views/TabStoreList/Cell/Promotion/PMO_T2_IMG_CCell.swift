//
//  PMO_T2_IMG_CCell.swift
//  GSSHOP
//
//  Created by admin on 21/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T2_IMG_CCell: UITableViewCell {
    
    private var viewSLD:SectionBAN_SLD_GBABtypeView!
    @objc var atarget:AnyObject?
   

    override func awakeFromNib() {
        super.awakeFromNib()        
        self.viewSLD = SectionBAN_SLD_GBABtypeView.init(target: self, nframe: CGRect.init(x: 0.0, y:0.0, width: Double(getAppFullWidth()), height: Double(Common_Util.dpRateOriginVAL(160)+10) ), type: "PMO_T2_IMG_C")
        
        self.addSubview(self.viewSLD)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewSLD.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let product = Module(JSON: dic) else { return }
        self.setData(product)
    }
    
    func setData(_ prd:Module) {
        self.viewSLD.autoRollingValue = Float(prd.rollingDelay)
        self.viewSLD.isRandom = prd.randomYn == "Y" ? true : false
        self.viewSLD.setCellInfoNDrawData(prd.subProductList.toJSON())
        self.viewSLD.target = self.atarget
    }
    

    
    
}
