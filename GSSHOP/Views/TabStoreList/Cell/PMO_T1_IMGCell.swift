//
//  PMO_T1_IMGCell.swift
//  GSSHOP
//
//  Created by Kiwon on 04/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T1_IMGCell: BaseTableViewCell {
    /// 전체 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 이미지 영역 버튼
    @IBOutlet weak var button: UIButton!
    /// 메인 타이틀 라벨
    @IBOutlet weak var mainTitleLbl: UILabel!
    /// 메인 타이틀 라벨 Bot
    @IBOutlet weak var mainTitleBot: NSLayoutConstraint!
    /// 서브 타이틀 라벨
    @IBOutlet weak var subTitleLbl: UILabel!
    /// 서브 타이틀 라벨 Bot
    @IBOutlet weak var subTitleBot: NSLayoutConstraint!
    /// 더보기 이미지
    @IBOutlet weak var moreImgView: UIImageView!
    
    private var product: Module?
    private var indexPath: IndexPath?
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
        self.imgView.image = UIImage(named: Const.Image.img_noimage_166.name)
        self.mainTitleLbl.text = ""
        self.subTitleLbl.text = ""
        self.mainTitleBot.constant = 0.0
        self.subTitleBot.constant = 0.0
        self.moreImgView.isHidden = true
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let product = Module(JSON: dic) else { return }
        
        self.product = product
        self.indexPath = indexPath
        
        self.imgView.setImgView(adultImg: nil, data: product)
        self.imgView.contentMode = .scaleAspectFill
        /*
         // TODO: kiwon : 텍스트 추가!
        setProductNameLable(self.mainTitleLbl, data: product)
        setPromotionSubTitleLabel(self.subTitleLbl, data: product)
        if product.linkUrl.isEmpty {
            self.moreImgView.isHidden = true
        } else {
            self.moreImgView.isHidden = false
        }
        
        if let text = self.mainTitleLbl.text, !text.isEmpty {
            self.mainTitleBot.constant = 8.0
        } else {
            self.mainTitleBot.constant = 0.0
        }
        
        if let text = self.subTitleLbl.text, !text.isEmpty {
            self.subTitleBot.constant = 8.0
        } else {
            self.subTitleBot.constant = 0.0
        }
 */
        // 접근성 설정
        self.button.isAccessibilityElement = true
        if product.productName.isEmpty {
            self.button.accessibilityLabel = Const.Text.image_banner.name
        } else {
            self.button.accessibilityLabel = product.productName
        }
        
    }
    @IBAction func buttonAction(_ sender: UIButton) {
        if let product = self.product, let indexPath = self.indexPath,
            let sectionTB = self.aTarget as? SectionTBViewController {
            sectionTB.dctypetouchEventTBCell(product.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: " PMO_T1_IMG")
        }
    }
}
