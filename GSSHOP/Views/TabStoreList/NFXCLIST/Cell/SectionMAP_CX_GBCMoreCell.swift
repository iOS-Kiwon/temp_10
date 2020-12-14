//
//  SectionMAP_CX_GBCMoreCell.swift
//  GSSHOP
//
//  Created by Kiwon on 14/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionMAP_CX_GBCMoreCell: BaseTableViewCell {
    // 타이틀 / 매장이름 라벨
    @IBOutlet weak var nameLbl: UILabel!
    // 전체보기 / 더보기 버튼
    @IBOutlet weak var moreBtn: UIButton!
    
    // 타겟 테이블뷰
    var aTarget: NFXCListViewController?
    // 모듈 데이터
    var module: Module?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ data: Module) {
        self.module = data
        if data.viewType == Const.ViewType.TAB_SLD_GBB_MORE.name {
            let text = data.name.isEmpty == false ? data.name + " 더보기" : "더보기"
            
            let attriString = NSMutableAttributedString(string: text)
            attriString.addAttributes([
                .font: UIFont.systemFont(ofSize: 17.0, weight: .bold),
                .foregroundColor: UIColor.getColor("111111")
            ], range: NSMakeRange(0, data.name.count) )
            self.nameLbl.attributedText = attriString
        } else {
            self.nameLbl.text = "상품 전체보기"
        }
        
        self.moreBtn.isAccessibilityElement = true
        self.moreBtn.accessibilityLabel = self.nameLbl.text
    }
    
    @IBAction func onClickBtn(_ sender: UIButton) {
        if let data = self.module, !data.moreBtnUrl.isEmpty {
            self.aTarget?.onBtnCellJustLinkStr(data.moreBtnUrl)
        }
    }
}


// MARK:- Private Functions
extension SectionMAP_CX_GBCMoreCell{
    
    /// 현재 Cell  초기화
    private func setInitUI() {
        self.nameLbl.text = ""
        self.isAccessibilityElement = false
    }
}
