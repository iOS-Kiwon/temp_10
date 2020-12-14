//
//  SectionTAB_SLD_GBBtypeSubCell.swift
//  GSSHOP
//
//  Created by Kiwon on 10/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionTAB_SLD_GBBtypeSubCell: UICollectionViewCell {

    @IBOutlet weak var cateBtn: CategoryButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }
    
    /// 현재 Cell  초기화
    private func setInitUI() {
        self.cateBtn.title = ""
        self.cateBtn.isSelected = false
    }
    
    /// 카테고리 높이 설정
    func setCateBtnHeight(_ value: CGFloat) {
        self.cateBtn.HEIGHT = value
    }
    
    /// 버튼 설정
    func setTitle(_ title: String) {
        self.cateBtn.setInitUI(title: title)
    }
    
    /// 버튼 TextColor 설정
    func setCateBtnTextColor(_ color: UIColor) {
        self.cateBtn.titleColorForNormal(color)
    }
    
    /// 버튼 Bg 설정
    func setCateBtnBgColor(_ color: UIColor) {
        self.cateBtn.bgColorForNormal(color)
    }
}
