//
//  GR_PMO_T2_MoreCell.swift
//  GSSHOP
//
//  Created by gsshop iOS on 2020/06/16.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class GR_PMO_T2_MoreCell: UITableViewCell {

    @objc var aTarget: AnyObject?
    private var product : Module?
    private var indexPath: IndexPath?
    
    @IBOutlet var btnMore : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let product = Module(JSON: dic) else { return }
        setData(product, indexPath: indexPath)
    }
    
    func setData(_ prd: Module, indexPath: IndexPath) {
        self.product = prd
        self.indexPath = indexPath
        self.btnMore.accessibilityLabel = "상품 전체보기"
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let product = self.product, let indexPath = self.indexPath {
            if let sectionTB = self.aTarget as? SectionTBViewController {
                sectionTB.dctypetouchEventTBCell(product.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "GR_PMO_T2_More")
            } else if let nfxcListVC = self.aTarget as? NFXCListViewController {
                nfxcListVC.dctypetouchEventTBCell(dic: product.toJSON(), index: indexPath.row, viewType: "GR_PMO_T2_More")
            }
        }
    }
}
