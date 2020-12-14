//
//  PRD_2Cell.swift
//  GSSHOP
//
//  Created by Kiwon on 28/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PRD_2Cell: BaseTableViewCell {
    
    let DEFAULT_BENEFIT_WIDTH: CGFloat = ((getAppFullWidth() - (16.0 * 2) - 11.0 ) / 2.0)
    
    /// 왼쪽 전체 이미지뷰
    @IBOutlet weak var L_fullImgView: UIImageView!
    /// 왼쪽 상품 이미지뷰
    @IBOutlet weak var L_imgView: UIImageView!
    /// 왼쪽 좌상단 순위라벨
    @IBOutlet weak var L_rankLbl: UILabel!
    /// 왼쪽 일시품절 뷰
    @IBOutlet weak var L_soldOutView: UIView!
    /// 왼쪽 일시품절 뷰 높이
    @IBOutlet weak var L_soldOutViewHeight: NSLayoutConstraint!
    /// 왼쪽 방송시간 뷰
    @IBOutlet weak var L_broadTimeView: UIView!
    /// 왼쪽 방송시간 라벨
    @IBOutlet weak var L_broadTimeLbl: UILabel!
    /// 왼쪽 방송시간 뷰 높이
    @IBOutlet weak var L_broadTimeViewHeight: NSLayoutConstraint!
    /// 왼쪽 방송중 구매가능 뷰
    @IBOutlet weak var L_broadBuyView: UIView!
    /// 왼쪽 방송중 구매가능 뷰 높이
    @IBOutlet weak var L_broadBuyViewHeight: NSLayoutConstraint!
    /// 왼쪽 재생 버튼
    @IBOutlet weak var L_playImgView: UIImageView!
    /// 왼쪽 판매 가격
    @IBOutlet weak var L_salePriceLbl: UILabel!
    /// 왼쪽 할인율
    @IBOutlet weak var L_discountRateLbl: UILabel!
    /// 왼쪽 기존 가격
    @IBOutlet weak var L_basePriceLbl: UILabel!
    /// 왼쪽 상품명
    @IBOutlet weak var L_productNameLbl: UILabel!
    /// 왼쪽 혜택 라벨
    @IBOutlet weak var L_benefitLbl: BenefitLabel!
    /// 왼쪽 상품평 라벨
    @IBOutlet weak var L_gradeLbl: UILabel!
    /// 왼쪽 상품평 라벨 우측여백
    @IBOutlet weak var L_gradeLblTrailing: NSLayoutConstraint!
    /// 왼쪽 상품평 개수
    @IBOutlet weak var L_reviewCountLbl: UILabel!
    /// 왼쪽 찜 버튼
    @IBOutlet weak var L_zzimBtn: UIButton!
    /// 왼쪽 찜 버튼
    @IBOutlet weak var L_basketBtn: UIButton!
    /// 왼쪽 전체버튼
    @IBOutlet weak var L_button: UIButton!
    /// 오른쪽 전체뷰
    @IBOutlet weak var L_view: UIView!    
    
    /// 오른쪽 전체 이미지뷰
    @IBOutlet weak var R_fullImgView: UIImageView!
    /// 오른쪽 상품 이미지뷰
    @IBOutlet weak var R_imgView: UIImageView!
    /// 오른쪽 좌상단 순위라벨
    @IBOutlet weak var R_rankLbl: UILabel!
    /// 오른쪽 일시품절 뷰
    @IBOutlet weak var R_soldOutView: UIView!
    /// 오른쪽 일시품절 뷰 높이
    @IBOutlet weak var R_soldOutViewHeight: NSLayoutConstraint!
    /// 오른쪽 방송시간 뷰
    @IBOutlet weak var R_broadTimeView: UIView!
    /// 오른쪽 방송시간 라벨
    @IBOutlet weak var R_broadTimeLbl: UILabel!
    /// 오른쪽 방송시간 뷰 높이
    @IBOutlet weak var R_broadTimeViewHeight: NSLayoutConstraint!
    /// 오른쪽 방송중 구매가능 뷰
    @IBOutlet weak var R_broadBuyView: UIView!
    /// 오른쪽 방송중 구매가능 뷰 높이
    @IBOutlet weak var R_broadBuyViewHeight: NSLayoutConstraint!
    /// 오른쪽 재생 버튼
    @IBOutlet weak var R_playImgView: UIImageView!
    /// 오른쪽 판매 가격
    @IBOutlet weak var R_salePriceLbl: UILabel!
    /// 오른쪽 할인율
    @IBOutlet weak var R_discountRateLbl: UILabel!
    /// 오른쪽 기존 가격
    @IBOutlet weak var R_basePriceLbl: UILabel!
    /// 오른쪽 상품명
    @IBOutlet weak var R_productNameLbl: UILabel!
    /// 오른쪽 혜택 라벨
    @IBOutlet weak var R_benefitLbl: BenefitLabel!
    /// 오른쪽 상품평 라벨
    @IBOutlet weak var R_gradeLbl: UILabel!
    /// 오른쪽 상품평 라벨 우측여백
    @IBOutlet weak var R_gradeLblTrailing: NSLayoutConstraint!
    /// 오른쪽 상품평 개수
    @IBOutlet weak var R_reviewCountLbl: UILabel!
    /// 오른쪽 찜 버튼
    @IBOutlet weak var R_zzimBtn: UIButton!
    /// 오른쪽 찜 버튼
    @IBOutlet weak var R_basketBtn: UIButton!
    /// 오른쪽 전체버튼
    @IBOutlet weak var R_button: UIButton!
    /// 오른쪽 전체뷰
    @IBOutlet weak var R_view: UIView!
    
    /// 왼쪽 Product 객체
    var L_product: Module?
    /// 오른쪽 Product 객체
    var R_product: Module?
    /// 현재 Cell IndexPath
    private var indexPath: IndexPath?
    
    @IBOutlet weak var viewBottomSpace: NSLayoutConstraint!
    
    
    /// 테이블뷰 타겟
    @objc var aTarget: AnyObject?

    override func awakeFromNib() {
        super.awakeFromNib()
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }

    @objc func setDivider(_ heigth:CGFloat){
        self.viewBottomSpace.constant = heigth
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        self.indexPath = indexPath
        
        let subProdList = prd.subProductList
        if subProdList.count > 0, let leftData = subProdList.first {
            setLeftData(product: leftData, indexPath: indexPath)
        }
        
        if subProdList.count >= 2, let rightData = subProdList.last {
            setRightData(product: rightData, indexPath: indexPath)
        }
    }
    
    func setDataForGBC(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        self.indexPath = indexPath
        
        let prdList = prd.productList
        if prdList.count > 0, let leftData = prdList.first {
            setLeftData(product: leftData, indexPath: indexPath)
        }
        
        if prdList.count >= 2, let rightData = prdList.last {
            setRightData(product: rightData, indexPath: indexPath)
        }
    }
}

// MARK:- Public Functions
extension PRD_2Cell {
    /// Cell 왼쪽 데이터 설정
    func setLeftData(product: Module, indexPath: IndexPath) {
        self.L_product = product
        self.indexPath = indexPath
        self.L_button.isAccessibilityElement = true
        
        /// 전체 이미지 설정 : GS fresh에서 사용됨.
        if product.viewType == "IMG_ONLY" {
            self.L_view.isHidden = true
            self.L_fullImgView.isHidden = false
            self.L_fullImgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_166.name), data: product)
            // 접근성
            if product.productName.isEmpty {
                self.L_button.accessibilityLabel = Const.Text.image_banner.name
            } else {
                self.L_button.accessibilityLabel = product.productName
            }
            return
        }
        self.L_view.isHidden = false
        self.L_imgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_166.name), data: product)
        self.L_rankLbl.setRank(data: product)
        self.L_soldOutView.setSoldOut(viewHeightConstraint: self.L_soldOutViewHeight, data: product)
        self.L_broadTimeView.setBroadTime(withLabel:  self.L_broadTimeLbl, viewHeightConstraint: self.L_broadTimeViewHeight, data: product)
        self.L_broadBuyView.setBroadBuy(viewHeightConstraint: self.L_broadBuyViewHeight, data: product)
//        self.L_playImgView.setPlayImgView(data: product)
        self.L_salePriceLbl.setSalePrice(data: product)
        self.L_discountRateLbl.setDiscountRate(withBaseLabel: self.L_basePriceLbl, data: product)
        self.L_productNameLbl.setProductName(data: product)
        
        self.L_benefitLbl.setBenefit(data: product, labelWidth: DEFAULT_BENEFIT_WIDTH)
        self.L_gradeLbl.setReviewAverage(data: product)
        if self.L_gradeLbl.text == "" {
            self.L_gradeLblTrailing.constant = 0.0
        } else {
            self.L_gradeLblTrailing.constant = 3.0
        }
        self.L_reviewCountLbl.setReviewCount(data: product)
        self.L_basketBtn.setBasket(data: product)
        
        // 접근성
        self.L_button.accessibilityLabel = String(format: "%@  %@  %@", product.productName, product.salePrice, product.exposePriceText)
    }

    
    /// Cell 오른쪽 데이터 설정
    func setRightData(product: Module, indexPath: IndexPath) {
        self.R_product = product
        self.indexPath = indexPath
        self.R_button.isAccessibilityElement = true
        
        /// 전체 이미지 설정 : GS fresh에서 사용됨.
        if product.viewType == "IMG_ONLY" {
            self.R_view.isHidden = true
            self.R_fullImgView.isHidden = false
            self.R_fullImgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_166.name), data: product)
            // 접근성
            if product.productName.isEmpty {
                self.L_button.accessibilityLabel = Const.Text.image_banner.name
            } else {
                self.L_button.accessibilityLabel = product.productName
            }
            return
        }
        self.R_view.isHidden = false
        self.R_button.isHidden = false
        self.R_imgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_166.name), data: product)
        self.R_rankLbl.setRank(data: product)
        self.R_soldOutView.setSoldOut(viewHeightConstraint: self.R_soldOutViewHeight, data: product)
        self.R_broadTimeView.setBroadTime(withLabel:  self.R_broadTimeLbl, viewHeightConstraint: self.R_broadTimeViewHeight, data: product)
        self.R_broadBuyView.setBroadBuy(viewHeightConstraint: self.R_broadBuyViewHeight, data: product)
//        self.R_playImgView.setPlayImgView(data: product)
        self.R_salePriceLbl.setSalePrice(data: product)
        self.R_discountRateLbl.setDiscountRate(withBaseLabel: self.R_basePriceLbl, data: product)
        self.R_productNameLbl.setProductName(data: product)
        
        self.R_benefitLbl.setBenefit(data: product, labelWidth: DEFAULT_BENEFIT_WIDTH)
        self.R_gradeLbl.setReviewAverage(data: product)
        if self.R_gradeLbl.text == "" {
            self.R_gradeLblTrailing.constant = 0.0
        } else {
            self.R_gradeLblTrailing.constant = 3.0
        }
        self.R_reviewCountLbl.setReviewCount(data: product)
        self.R_basketBtn.setBasket(data: product)
        
        // 접근성
        self.R_button.accessibilityLabel = String(format: "%@  %@  %@", product.productName, product.salePrice, product.exposePriceText)
    }
}


// MARK:- Private Functions
extension PRD_2Cell {
    private func setInitUI() {
        self.L_product = nil
        self.L_fullImgView.isHidden = true
        self.L_fullImgView.image = UIImage(named: Const.Image.img_noimage_166_315.name)
        self.L_imgView.image = UIImage(named: Const.Image.img_noimage_166.name)
        self.L_rankLbl.isHidden = true
        self.L_rankLbl.text = ""
        self.L_broadTimeLbl.text = ""
        self.L_soldOutView.isHidden = true
        self.L_broadTimeView.isHidden = true
        self.L_broadBuyView.isHidden = true
        self.L_soldOutViewHeight.constant = 0.0
        self.L_broadTimeViewHeight.constant = 0.0
        self.L_broadBuyViewHeight.constant = 0.0
        self.L_playImgView.isHidden = true
        self.L_salePriceLbl.text = ""
        self.L_salePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.L_discountRateLbl.text = ""
        self.L_basePriceLbl.text = ""
        self.L_basePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.L_productNameLbl.text = ""
        self.L_productNameLbl.attributedText = NSMutableAttributedString(string: "")
        self.L_benefitLbl.text = ""
        self.L_benefitLbl.attributedText = NSMutableAttributedString(string: "")
        self.L_gradeLbl.text = ""
        self.L_reviewCountLbl.text = ""
        //self.L_zzimBtn.isHidden = true
        self.L_basketBtn.isHidden = true
        self.L_button.accessibilityLabel = ""
        self.L_button.isAccessibilityElement = false
        self.L_view.isHidden = true
     
        self.R_product = nil
        self.R_fullImgView.isHidden = true
        self.R_fullImgView.image = UIImage(named: Const.Image.img_noimage_166_315.name)
        self.R_imgView.image = UIImage(named: Const.Image.img_noimage_166.name)
        self.R_rankLbl.isHidden = true
        self.R_rankLbl.text = ""
        self.R_broadTimeLbl.text = ""
        self.R_soldOutView.isHidden = true
        self.R_broadTimeView.isHidden = true
        self.R_broadBuyView.isHidden = true
        self.R_soldOutViewHeight.constant = 0.0
        self.R_broadTimeViewHeight.constant = 0.0
        self.R_broadBuyViewHeight.constant = 0.0
        self.R_playImgView.isHidden = true
        self.R_salePriceLbl.text = ""
        self.R_salePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.R_discountRateLbl.text = ""
        self.R_basePriceLbl.text = ""
        self.R_basePriceLbl.attributedText = NSMutableAttributedString(string: "")
        self.R_productNameLbl.text = ""
        self.R_productNameLbl.attributedText = NSMutableAttributedString(string: "")
        self.R_benefitLbl.text = ""
        self.R_benefitLbl.attributedText = NSMutableAttributedString(string: "")
        self.R_gradeLbl.text = ""
        self.R_reviewCountLbl.text = ""
        //self.R_zzimBtn.isHidden = true
        self.R_basketBtn.isHidden = true
        self.R_button.isHidden = true
        self.R_button.accessibilityLabel = ""
        self.R_button.isAccessibilityElement = false
        self.R_view.isHidden = true
    }
    
    /// 상품 이동
    private func moveToProduct(_ data: Module) {
        if let superTarget = self.aTarget as? SUPListTableViewController,
            !data.linkUrl.isEmpty {
            superTarget.onBtnSUPCellJustLinkStr(data.linkUrl)
        } else if let sectionTB = self.aTarget as? SectionTBViewController,
            !data.linkUrl.isEmpty {
            let tag: Int = data == self.L_product ? 0 : 1
            sectionTB.dctypetouchEventTBCell(data.toJSON(), andCnum: NSNumber(value: tag), withCallType: "PRD_2")
        } else if let nfxcTB = self.aTarget as? NFXCListViewController,
            !data.linkUrl.isEmpty {
            let tag: Int = data == self.L_product ? 0 : 1
            nfxcTB.dctypetouchEventTBCell(dic: data.toJSON(), index: tag, viewType: "PRD_2")
        }
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
                            sectionTB.tableDataUpdate(false, key: "isWish", cellIndex: indexPath.row, viewType: "PRD_2")
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
                            sectionTB.tableDataUpdate(true, key: "isWish", cellIndex: indexPath.row, viewType: "PRD_2")
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
            data.linkUrl.isEmpty == false {
            
            // 바로구매 인 경우
            let basketUrl = data.basket.url
            
            if basketUrl.hasPrefix(Const.Text.GSEXTERNLINKPROTOCOL.name+"directOrd?") {
                let linkstr = basketUrl.replacingOccurrences(of: Const.Text.GSEXTERNLINKPROTOCOL.name+"directOrd?", with: "")
                applicationDelegate.directOrdOptionViewShowURL(linkstr)
            }
            else {
                superTarget.addCartProcess(data.toJSON())
            }
        } else if let nfxcList = self.aTarget as? NFXCListViewController,
            data.linkUrl.isEmpty == false {
            // 바로구매 로직이 추가되어 있음
            nfxcList.addBasket(data: data)
        }
    }
}

// MARK:- Button Actions
extension PRD_2Cell {
    
    /// 왼쪽 상품 버튼 액션
    @IBAction func leftProductBtnAction(_ sender: UIButton) {
        guard let product = self.L_product else { return }
        moveToProduct(product)
    }
    
    /// 왼쪽 찜 버튼 액션
    @IBAction func leftZzimBtnAction(_ sender: UIButton) {
//        guard let product = self.L_product else { return }
//        setZzim(product, sender: sender)
    }
    
    /// 왼쪽 장바구니 버튼 액션
    @IBAction func leftBasketBtnAction(_ sender: UIButton) {
        guard let product = self.L_product else { return }
        addBasket(product)
    }
    
    /// 오른쪽 상품 버튼 액션
    @IBAction func rightProductBtnAction(_ sender: UIButton) {
        guard let product = self.R_product else { return }
        moveToProduct(product)
    }
    
    /// 오른쪽 찜 버튼 액션
    @IBAction func rightZzimBtnAction(_ sender: UIButton) {
//        guard let product = self.R_product else { return }
//        setZzim(product, sender: sender)
    }
    
    /// 오른쪽 장바구니 버튼 액션
    @IBAction func rightBasketBtnAction(_ sender: UIButton) {
        guard let product = self.R_product else { return }
        addBasket(product)
    }
}
