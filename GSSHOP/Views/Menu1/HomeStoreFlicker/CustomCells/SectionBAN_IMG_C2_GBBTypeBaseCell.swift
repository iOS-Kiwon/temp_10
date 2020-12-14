//
//  SectionBAN_IMG_C2_GBBTypeBaseCell.swift
//  GSSHOP
//
//  Created by Kiwon on 26/07/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_IMG_C2_GBBTypeBaseCell: UITableViewCell {
    
    let BAN_IMG_C2_GBB_HEIGHT = (getAppFullWidth() / 2.0) + 100 + 16 + 4 + 16 + 13    // 가변이미지뷰(상하여백포함) + 제품뷰 + margin + 혜택뷰높이 + 사이 margin + 구매중 높이 + bot margin
    
    @IBOutlet weak var viewBottomLine: UIView!
    
    @objc var isLastLine: Bool = false {
        didSet {
            self.viewBottomLine.isHidden = !self.isLastLine
        }
    }
    @objc var aTarget: SectionTBViewController?
    
    private var leftView: SectionBAN_IMG_C2_GBBtypeSubView?
    private var rightView: SectionBAN_IMG_C2_GBBtypeSubView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in self.subviews {
            if view.isKind(of: SectionBAN_IMG_C2_GBBtypeSubView.self) {
                view.removeFromSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.leftView?.frame = CGRect(x: 0, y: 0, width: getAppFullWidth()/2, height: BAN_IMG_C2_GBB_HEIGHT)
        self.rightView?.frame = CGRect(x: getAppFullWidth()/2, y: 0, width: getAppFullWidth()/2, height: BAN_IMG_C2_GBB_HEIGHT)
    }
    
    // 상풍 정보 렌더링
    @objc func setCellInfoNDrawData(_ rowinfoDic: [String: AnyObject]) {
        
        guard let product = Module.init(JSON: rowinfoDic) else { return }
        
        if product.subProductList.count > 0,
            let leftProduct = product.subProductList.first {
            guard let view = Bundle.main.loadNibNamed(SectionBAN_IMG_C2_GBBtypeSubView.reusableIdentifier, owner: self, options: nil)?.first as? SectionBAN_IMG_C2_GBBtypeSubView else { return }
            self.leftView = view
            self.leftView!.initUI()
            self.leftView!.aTarget = self.aTarget
            self.leftView!.L_horizontal_line.isHidden = false
            self.leftView!.isLastLine = self.isLastLine
            self.leftView!.setCellInfoNDrawData(product: leftProduct)
            self.addSubview(self.leftView!)
            
        }
        
        if product.subProductList.count > 1,
            let rightProduct = product.subProductList.last {
            guard let view = Bundle.main.loadNibNamed(SectionBAN_IMG_C2_GBBtypeSubView.reusableIdentifier, owner: self, options: nil)?.last as? SectionBAN_IMG_C2_GBBtypeSubView else { return }
            self.rightView = view
            self.rightView!.initUI()
            self.rightView!.L_horizontal_line.isHidden = true
            self.rightView!.aTarget = self.aTarget
            self.rightView!.isLastLine = self.isLastLine
            self.rightView!.setCellInfoNDrawData(product: rightProduct)
            self.addSubview(self.rightView!)
        }
    }
}
