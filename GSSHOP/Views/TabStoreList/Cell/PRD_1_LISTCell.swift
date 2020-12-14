//
//  PRD_1_LISTCell.swift
//  GSSHOP
//
//  Created by Kiwon on 11/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PRD_1_LISTCell: BaseTableViewCell {

    /// 상품 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 좌상단 순위라벨
    @IBOutlet weak var rankLbl: UILabel!
    /// 일시품절 뷰
    @IBOutlet weak var soldOutView: UIView!
    /// 일시품절 뷰 높이
    @IBOutlet weak var soldOutViewHeight: NSLayoutConstraint!
    /// 방송시간 뷰
    @IBOutlet weak var broadTimeView: UIView!
    /// 방송시간 뷰
    @IBOutlet weak var broadTimeLbl: UILabel!
    /// 방송시간 뷰 높이
    @IBOutlet weak var broadTimeViewHeight: NSLayoutConstraint!
    /// 방송중 구매가능 뷰
    @IBOutlet weak var broadBuyView: UIView!
    /// 방송중 구매가능 뷰 높이
    @IBOutlet weak var broadBuyViewHeight: NSLayoutConstraint!
    /// 재생 버튼
    @IBOutlet weak var playImgView: UIImageView!
    /// 판매 가격
    @IBOutlet weak var salePriceLbl: UILabel!
    /// 상품명
    @IBOutlet weak var productNameLbl: UILabel!
    /// 혜택 라벨
    @IBOutlet weak var benefitLbl: BenefitLabel!
    /// 상품평 라벨
    @IBOutlet weak var gradeLbl: UILabel!
    /// 상품평 개수
    @IBOutlet weak var reviewCountLbl: UILabel!
    /// 찜 버튼
    @IBOutlet weak var zzimBtn: UIButton!
    /// 장바구니 버튼
    @IBOutlet weak var basketBtn: UIButton!
    /// 하단 라인과 cell 간격
    @IBOutlet weak var underLineBot: NSLayoutConstraint!
    /// 상품 객체
    private var product: Module?
    /// 테이블뷰 타겟
    @objc var aTarget: AnyObject?
    /// indexPath
    private var indexPath: IndexPath?
    
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
}

// MARK:- Public Functions
extension PRD_1_LISTCell {
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        setData(product: prd, indexPath: indexPath)
    }
    
    /// Cell 왼쪽 데이터 설정
    func setData(product: Module, indexPath: IndexPath) {
        self.product = product
        self.indexPath = indexPath
        self.imgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_166.name), data: product)
        self.rankLbl.setRank(data: product)
        self.soldOutView.setSoldOut(viewHeightConstraint: self.soldOutViewHeight, data: product)
        self.broadTimeView.setBroadTime(withLabel: self.broadTimeLbl, viewHeightConstraint: self.broadTimeViewHeight, data: product)
        self.broadBuyView.setBroadBuy(viewHeightConstraint: self.broadBuyViewHeight, data: product)
//        self.playImgView.setPlayImgView(data: product)
        // 127 : 이미지뷰, 16*2 : 양쪽여백, 12 : 이미지와 라벨사이
        let width = CGFloat( getAppFullWidth() - 127 - (16 * 2) - 12)
        self.salePriceLbl.setSalePriceAndRate(data: product, labelWidth: width)
        self.productNameLbl.setProductName(data: product)
        self.benefitLbl.setBenefit(data: product, labelWidth: (getAppFullWidth() - (16.0 * 2) - 127.0 - 12.0))
        self.gradeLbl.setReviewAverage(data: product)
        self.reviewCountLbl.setReviewCount(data: product)
//        self.zzimBtn.setZzim(data: product)
        self.basketBtn.setBasket(data: product)
        
        // 접근성
        self.accessibilityLabel = String(format: "%@  %@  %@", product.productName, product.salePrice, product.exposePriceText)
    }
    
    @objc func setDivider(_ height:CGFloat) {
        self.underLineBot.constant = height;
    }
}

// MARK:- Private Functions
extension PRD_1_LISTCell {
    private func setInitUI() {
        self.product = nil
        self.imgView.image = UIImage(named: Const.Image.img_noimage_127.name)
        self.rankLbl.isHidden = true
        self.rankLbl.text = ""
        self.broadTimeLbl.text = ""
        self.soldOutView.isHidden = true
        self.broadTimeView.isHidden = true
        self.broadBuyView.isHidden = true
        self.soldOutViewHeight.constant = 0.0
        self.broadTimeViewHeight.constant = 0.0
        self.broadBuyViewHeight.constant = 0.0
        self.playImgView.isHidden = true
        self.salePriceLbl.text = ""
        self.salePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.productNameLbl.text = ""
        self.productNameLbl.attributedText = NSMutableAttributedString(string: "")
        self.benefitLbl.text = ""
        self.benefitLbl.attributedText = NSMutableAttributedString(string: "")
        self.gradeLbl.text = ""
        self.reviewCountLbl.text = ""
        self.zzimBtn.isHidden = true
        self.basketBtn.isHidden = true
        self.accessibilityLabel = ""
        self.isAccessibilityElement = false
        self.accessibilityTraits = .button
    }
    
    /// 찜 설정
    private func setZzim(_ data: Module, sender: UIButton) {
        if sender.isSelected {
            // 찜하기 취소하기
            deleteZzim(url: data.brandWishRemoveUrl) { (isSuccess, zzimData) in
                if isSuccess {
                    DispatchQueue.main.async {
                        // 찜하기 취소 성공
                        if let sectionTB = self.aTarget as? SectionTBViewController,
                            let indexPath = self.indexPath {
                            sectionTB.brandZzimShowPopup(zzimData?.linkUrl, add: false)
                            sectionTB.tableDataUpdate(false, key: "isWish", cellIndex: indexPath.row, viewType: "PRD_1_LIST")
                            sender.isSelected = false
                        }
                    }
                }
            }
        } else {
            addZzim(url: data.brandWishAddUrl) { (isSuccess, zzimData) in
                if isSuccess {
                    DispatchQueue.main.async {
                        // 찜하기 성공
                        if let sectionTB = self.aTarget as? SectionTBViewController,
                            let indexPath = self.indexPath {
                            sectionTB.brandZzimShowPopup(zzimData?.linkUrl, add: true)
                            sectionTB.tableDataUpdate(true, key: "isWish", cellIndex: indexPath.row, viewType: "PRD_1_LIST")
                            sender.isSelected = true
                        }
                    }
                }
            }
        }
    }
    
    //// 장바구니 설정
    private func addBasket(_ data: Module) {
        if let superTarget = self.aTarget as? SUPListTableViewController,
            !data.linkUrl.isEmpty {
            superTarget.addCartProcess(data.toJSON())
        }
    }
}

// MARK- Action Button
extension PRD_1_LISTCell {
    /// 찜 버튼 액션
    @IBAction func zzimBtnAction(_ sender: UIButton) {
//        guard let product = self.product else { return }
//        setZzim(product, sender: sender)
    }

    /// 장바구니 버튼 액션
    @IBAction func basketBtnAction(_ sender: UIButton) {
//        guard let product = self.product else { return }
//        addBasket(product)
    }
}
