//
//  BAN_MORE_GBACell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/07/14.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_MORE_GBACell: BaseTableViewCell {
    /// 브랜드 타이틀 라벨
    @IBOutlet weak var brandNameLbl: UILabel!
    /// 브랜드 더보기 버튼
    @IBOutlet weak var moreBtn: UIButton!
    
    /// 데이터 모델
    private var product: Module?
    /// 해당 셀 IndexPath
    private var indexPath: IndexPath?
    /// 해당 셀 대상타겟
    @objc var aTarget: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.brandNameLbl.text = ""
        self.moreBtn.isAccessibilityElement = false
        self.moreBtn.accessibilityLabel = ""
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        self.product = prd
        self.indexPath = indexPath
        
        setBrandName(prd)
    }
    
    private func setBrandName(_ data: Module) {
        
         let brandString = NSMutableAttributedString()
        
        if data.brandNm.isEmpty == false {
            let attrString = NSAttributedString(string: data.brandNm + " ", attributes: [
                .font: UIFont.systemFont(ofSize: 17.0, weight: .bold),
                .foregroundColor: UIColor.getColor("111111"),
            ])
            brandString.append(attrString)
        }
        
        if data.subName.isEmpty == false {
            let attrString = NSAttributedString(string: data.subName, attributes: [
                .font: UIFont.systemFont(ofSize: 17.0, weight: .regular),
                .foregroundColor: UIColor.getColor("111111"),
            ])
            brandString.append(attrString)
        }
        
        self.brandNameLbl.attributedText = brandString
        
        self.moreBtn.isAccessibilityElement = true
        self.moreBtn.accessibilityLabel = self.brandNameLbl.text
    }
    
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        guard let data = self.product else { return }
        
        if let vc = self.aTarget as? SectionTBViewController,
            let indexPath = self.indexPath {
            vc.dctypetouchEventTBCell(data.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "BAN_MORE_GBA")
        }
    }
}
