//
//  PMO_T1_PREVIEW_BCell.swift
//  GSSHOP
//
//  Created by Kiwon on 05/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T1_PREVIEW_BCell: BaseTableViewCell {
    
    private let DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN: CGFloat = 13.0
    private let DEFAULT_COLLECTIONVIEW_CELL_WIDTH: CGFloat = 110.0 + 3 + 3
    /// 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 브랜드명 라벨 Top
    @IBOutlet weak var titleLblTop: NSLayoutConstraint!
    /// 브랜드명 라벨
    @IBOutlet weak var titleLbl: UILabel!
    /// 브랜드명 라벨 Height
    @IBOutlet weak var titleLblHeight: NSLayoutConstraint!
    /// 서브카피 라벨
    @IBOutlet weak var subCopyLbl: UILabel!
    /// 헤드카피 이미지뷰
    @IBOutlet weak var headCopyImgView: UIImageView!
    /// 헤드카피 이미지뷰 Top
    @IBOutlet weak var headCopyImgViewTop: NSLayoutConstraint!
    /// 헤드카피 이미지뷰 Width
    @IBOutlet weak var headCopyImgViewWidth: NSLayoutConstraint!
    /// 프로모션1 라벨
    @IBOutlet weak var promotionLbl1: UILabel!
    /// 프로모션2 라벨
    @IBOutlet weak var promotionLbl2: UILabel!
    
    /// 그라데이션 이미지뷰
    @IBOutlet weak var gradientImgView: UIImageView!
    /// 하단 컬러코드뷰
    @IBOutlet weak var bottomColorView: UIView!
    
    /// 더보기 이미지뷰
    @IBOutlet weak var moreBtn: UIButton!
    
    /// 찜 버튼
    @IBOutlet weak var zzimBtn: UIButton!
    /// 찜 갯수
    @IBOutlet weak var zzimLbl: UILabel!
    /// Collection뷰
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var numberFormatter: NumberFormatter?
    
    private var product : Module?
    private var products = [Module]()
    private var indexPath: IndexPath?
    @objc var aTarget: AnyObject?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.numberFormatter = NumberFormatter()
        self.numberFormatter?.numberStyle = .decimal
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: PMO_T1_PREVIEW_DSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PMO_T1_PREVIEW_DSubCell.reusableIdentifier)
        self.collectionView.register(UINib(nibName: PMO_T1_PREVIEW_DSubMoreCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PMO_T1_PREVIEW_DSubMoreCell.reusableIdentifier)
        self.moreBtn.setCorner()
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath,  isNFXCType: Bool = false) {
        guard let product = Module(JSON: dic) else { return }
        setData(product, indexPath: indexPath, isNFXCType: isNFXCType)
    }
    
    func setData(_ prd: Module, indexPath: IndexPath, isNFXCType: Bool = false) {
        if isNFXCType {
            self.product = prd
            self.products = prd.productList
            self.indexPath = indexPath
        } else {
            if let subProduct = prd.subProductList.first {
                self.product = subProduct
                self.products = subProduct.subProductList
                self.indexPath = indexPath
            }
        }
        
        guard let product = self.product else { return }
        
        // 배경 이미지 설정
        ImageDownManager.blockImageDownWithURL(product.tabBgImg as NSString) { (httpStatusCode, fetchedImage, imageUrl, isInCache, error) in
            if error == nil, product.tabBgImg == imageUrl, let image = fetchedImage {
                DispatchQueue.main.async {
                    guard let resizedImage = image.aspectFillToWidth(withSize: self.imgView.frame.size) else { return }
                    if isInCache == true {
                        self.imgView.image = resizedImage
                    }
                    else {
                        self.alpha = 0
                        self.imgView.image = resizedImage
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.alpha = 1
                        })
                    }
                }//dispatch
            } else {
                self.imgView.image = UIImage(named: Const.Image.img_noimage_166.name)
            }
        }
        
        // 하단 컬러설정
        if product.bgColor.isEmpty == false && product.bgColor.count >= 6  {
            // 컬러값 설정 + 그라데이션뷰 숨기기
            self.bottomColorView.backgroundColor = UIColor.getColor(product.bgColor, defaultColor: .white)
            self.gradientImgView.isHidden  = true
        } else {
            self.bottomColorView.backgroundColor = .clear
            self.gradientImgView.isHidden  = false
        }
        
        // 서브카피
        if product.subName.isEmpty {
            self.subCopyLbl.text = ""
            self.titleLblTop.constant = 20.0
            self.headCopyImgViewTop.constant = 20.0
        } else {
            self.subCopyLbl.text = product.subName
            self.titleLblTop.constant = 50.0
            self.headCopyImgViewTop.constant = 50.0
        }
        
        // 타이틀 이미지
        if product.tabImg.isEmpty == false {
            // 해드카피 높이 설정함으로써 프로모션1, 2 라벨 위치를 정상적으로 노출시킨다.
            self.titleLblHeight.constant = 28.0
            
            /// 헤드카피 이미지로 노출
            ImageDownManager.blockImageDownWithURL(product.tabImg as NSString) { (httpStatusCode, fetchedImage, imageUrl, isInCache, error) in
                if error == nil, product.tabImg == imageUrl, let image = fetchedImage {
                    DispatchQueue.main.async {
                        if isInCache == true {
                            self.headCopyImgView.image = image
                        }
                        else {
                            self.alpha = 0
                            self.headCopyImgView.image = image
                            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                                self.alpha = 1
                            })
                        }
                        
                        self.headCopyImgViewWidth.constant = self.headCopyImgView.frame.height * image.size.width / image.size.height
                        self.layoutIfNeeded()
                    }
                }
            }
        } else if product.name.isEmpty == false {
            /// 헤드카피 Text로 노출
            self.titleLbl.isHidden = false
            self.titleLbl.text = product.name
            self.titleLblHeight.constant = 28.0
        } else {
            /// 헤드카피 이미지도 없고, Text도 없을 때
            self.titleLbl.isHidden = true
            self.titleLbl.text = ""
            self.titleLblHeight.constant = 0.0
        }
        
        if isiPhone5() {
            // 아이폰5 계열은 값 표현 안함
            self.promotionLbl1.text = ""
            self.promotionLbl2.text = ""
        } else if let textImageModule = product.textImageModule {
            // 프로모션 값
            if textImageModule.title1.isEmpty == false {
                self.promotionLbl1.text = textImageModule.title1
                
            }
            if textImageModule.title2.isEmpty == false {
                self.promotionLbl2.text = textImageModule.title2
                
            }
        }
        
        // 색상값 설정
        // Default값 먼저 설정
        self.subCopyLbl.textColor = .white
        self.titleLbl.textColor = .white
        self.promotionLbl1.textColor = .white
        self.promotionLbl2.textColor = .white
        
        if let textImageModule = product.textImageModule {
            if textImageModule.textColor == "A" {
                self.titleLbl.textColor = .white
                self.promotionLbl2.textColor = UIColor.getColor("111111", defaultColor: .white)
                self.promotionLbl1.textColor = UIColor.getColor("111111", defaultColor: .white)
            } else if textImageModule.textColor == "B" {
                self.subCopyLbl.textColor = UIColor.getColor("111111", alpha: 0.48)
                self.titleLbl.textColor = UIColor.getColor("111111", defaultColor: .white)
                self.promotionLbl2.textColor = UIColor.getColor("111111", defaultColor: .white)
                self.promotionLbl1.textColor = UIColor.getColor("111111", defaultColor: .white)
            }
        }
        
        
        // 더보기 아이콘
        if product.linkUrl.isEmpty {
            self.moreBtn.isHidden = true
        } else {
            self.moreBtn.isHidden = false
            self.moreBtn.accessibilityLabel = "더보기"
        }
        
        if product.isWishEnable {
            self.zzimBtn.setZzim(data: product)
            self.zzimCountUpdate()
        } else {
            self.zzimBtn.isHidden = true
            self.zzimBtn.isAccessibilityElement = false
        }
        
        
        
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: false)
        
    }
    
    func zzimCountUpdate(){
        let intCnt = Int(self.product!.wishCnt.replacingOccurrences(of: ",", with: "")) ?? 0
        if intCnt > 0 {
            let commaStringCnt = self.numberFormatter?.string(from: NSNumber(value: intCnt)) ?? ""
            self.zzimLbl.text = commaStringCnt
        }else{
            self.zzimLbl.text = ""
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let product = self.product, let indexPath = self.indexPath {
            if let sectionTB = self.aTarget as? SectionTBViewController {
                sectionTB.dctypetouchEventTBCell(product.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PMO_T1_PREVIEW_B")
            } else if let nfxcListVC = self.aTarget as? NFXCListViewController {
                nfxcListVC.dctypetouchEventTBCell(dic: product.toJSON(), index: indexPath.row, viewType: "PMO_T1_PREVIEW_B")
            }
        }
    }
    
    @IBAction func zzimBtnAction(_ sender: UIButton) {
        guard let product = self.product else { return }
        if sender.isSelected {
            // 찜하기 취소하기
            deleteZzim(url: product.brandWishRemoveUrl) { (isSuccess, zzimData) in
                if isSuccess {
                    DispatchQueue.main.async {
                        // 찜하기 취소 성공
                        if let sectionTB = self.aTarget as? SectionTBViewController,
                            let indexPath = self.indexPath {
                            sectionTB.brandZzimShowPopup(zzimData?.linkUrl, add: false)
                            sectionTB.tableDataUpdate(false, key: "isWish", cellIndex: indexPath.row, viewType: "PMO_T1_PREVIEW_B")

                            let intCnt = Int(self.product!.wishCnt.replacingOccurrences(of: ",", with: "")) ?? 0
                            let wishCnt = intCnt - 1
                            
                            if wishCnt > 0 {
                                let commaStringCnt = self.numberFormatter?.string(from: NSNumber(value: wishCnt)) ?? ""
                                self.product!.wishCnt = commaStringCnt
                                sectionTB.tableDataUpdate(commaStringCnt as NSString, key: "wishCnt", cellIndex: indexPath.row)
                                self.zzimLbl.text = commaStringCnt
                            }else{
                                self.product!.wishCnt = ""
                                sectionTB.tableDataUpdate("" as NSString, key: "wishCnt", cellIndex: indexPath.row)
                                self.zzimLbl.text = ""
                            }
                                
                            sender.isSelected = false
                        }
//                        else if let nfxcListVC = self.aTarget as? NFXCListViewController,
//                            let indexPath = self.indexPath {
//                            nfxcListVC.brandZzimShowPopup(zzimData?.linkUrl, add: false)
//                            nfxcListVC.tableDataUpdate(false, key: "isWish", cellIndex: indexPath.row, viewType: "PMO_T1_PREVIEW_B")
//                            sender.isSelected = false
//                        }
                    }
                }
            }
        } else {
            addZzim(url: product.brandWishAddUrl) { (isSuccess, zzimData) in
                if isSuccess {
                    DispatchQueue.main.async {
                        // 찜하기 성공
                        if let sectionTB = self.aTarget as? SectionTBViewController,
                            let indexPath = self.indexPath {
                            sectionTB.brandZzimShowPopup(zzimData?.linkUrl, add: true)
                            sectionTB.tableDataUpdate(true, key: "isWish", cellIndex: indexPath.row, viewType: "PMO_T1_PREVIEW_B")
                            
                            let intCnt = Int(self.product!.wishCnt.replacingOccurrences(of: ",", with: "")) ?? 0
                            let wishCnt = intCnt + 1
                            
                            if wishCnt > 0 {
                                let commaStringCnt = self.numberFormatter?.string(from: NSNumber(value: wishCnt)) ?? ""
                                self.product!.wishCnt = commaStringCnt
                                sectionTB.tableDataUpdate(commaStringCnt as NSString, key: "wishCnt", cellIndex: indexPath.row)
                                self.zzimLbl.text = commaStringCnt
                            }else{
                                self.product!.wishCnt = ""
                                sectionTB.tableDataUpdate("" as NSString, key: "wishCnt", cellIndex: indexPath.row)
                                self.zzimLbl.text = ""
                            }

                            sender.isSelected = true
                        }
//                        else if let nfxcListVC = self.aTarget as? NFXCListViewController,
//                            let indexPath = self.indexPath {
//                            nfxcListVC.brandZzimShowPopup(zzimData?.linkUrl, add: true)
//                            nfxcListVC.tableDataUpdate(true, key: "isWish", cellIndex: indexPath.row, viewType: "PMO_T1_PREVIEW_B")
//                            sender.isSelected = true
//                        }
                    }
                }
            }
        }
    }
}

extension PMO_T1_PREVIEW_BCell {
    private func setInitUI() {
        
        self.subCopyLbl.text = ""
        self.titleLbl.text = ""
        self.headCopyImgView.image = nil
        self.promotionLbl1.text = ""
        self.promotionLbl2.text = ""
        
        self.moreBtn.isHidden = true
        self.moreBtn.setBorder(width: 1.0, color: "ffffff", alpha: 0.3)
        self.zzimBtn.isHidden = true
        self.zzimLbl.text = ""
        self.imgView.image = UIImage(named: Const.Image.img_noimage_375_188.name)
        self.collectionView.setContentOffset(.zero, animated: false)
    }
}

// MARK:- UICollectionViewDelegate & DataSource
extension PMO_T1_PREVIEW_BCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = self.products[indexPath.row]
        
        // 더보기 뷰타입인경우
        if product.viewType == Const.ViewType.PMO_T1_PREVIEW_B_MORE.name {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PMO_T1_PREVIEW_DSubMoreCell.reusableIdentifier, for: indexPath) as? PMO_T1_PREVIEW_DSubMoreCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PMO_T1_PREVIEW_DSubCell.reusableIdentifier, for: indexPath) as? PMO_T1_PREVIEW_DSubCell else {
            return UICollectionViewCell()
        }
        
        cell.setData(product: product )
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.products[indexPath.row]
//        // 더보기 클릭시
//        if product.viewType == Const.ViewType.PMO_T1_PREVIEW_B_MORE.name, !product.linkUrl.isEmpty {
//            if let sectionTB = self.aTarget as? SectionTBViewController {
//                sectionTB.delegatetarget.touchEventTBCellJustLinkStr?(product.linkUrl)
//                return
//            } else if let nfxcListVC = self.aTarget as? NFXCListViewController {
//                nfxcListVC.delegatetarget?.touchEventTBCellJustLinkStr?(product.linkUrl)
//            }
//        }
//        
        // 상품 클릭시
        if let sectionTB = self.aTarget as? SectionTBViewController {
            sectionTB.dctypetouchEventTBCell(product.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PMO_T1_PREVIEW_B")
        } else if let nfxcListVC = self.aTarget as? NFXCListViewController {
            nfxcListVC.dctypetouchEventTBCell(dic: product.toJSON(), index: indexPath.row, viewType: "PMO_T1_PREVIEW_B")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell else { return }
        cell.didHighlightCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BaseCollectionViewCell else { return }
        cell.didUnhighlightCell()
    }
}


extension PMO_T1_PREVIEW_BCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 더보기 셀인 경우 Width값 -10pt 줄이기
        if let product = self.products[safe: indexPath.row], product.viewType == Const.ViewType.PMO_T1_PREVIEW_B_MORE.name {
            return CGSize(width: DEFAULT_COLLECTIONVIEW_CELL_WIDTH - 7.0, height: collectionView.frame.height)
        }
        return CGSize(width: DEFAULT_COLLECTIONVIEW_CELL_WIDTH, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
