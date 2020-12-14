//
//  PMO_T2_IMGCell.swift
//  GSSHOP
//
//  Created by Kiwon on 04/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T2_IMGCell: BaseTableViewCell {

    /// 전체 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 이미지 영역 버튼
    @IBOutlet weak var button: UIButton!
    /// 타이틀 라벨
    @IBOutlet weak var titleLbl: UILabel!
    /// 타켓 테이블뷰
    @objc var aTarget: AnyObject?
    
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
    
    private func setInitUI() {
        self.imgView.image = UIImage(named: Const.Image.img_noimage_375_188.name)
        self.titleLbl.text = ""
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let product = Module(JSON: dic) else { return }
        
        self.imgView.setImgView(adultImg: nil, data: product)
        self.imgView.contentMode = .scaleAspectFill
        
        // TODO:- kiwon : titleLbl 설정
        self.titleLbl.isHidden = true
        
        
        // 접근성 설정
        self.button.isAccessibilityElement = true
        if product.productName.isEmpty {
            self.button.accessibilityLabel = Const.Text.image_banner.name
        } else {
            self.button.accessibilityLabel = product.productName
        }
        
    }
    @IBAction func buttonAction(_ sender: UIButton) {
//        if let sectionTB = self.aTarget as? SectionTBViewController {
//            
//        }
    }
}
