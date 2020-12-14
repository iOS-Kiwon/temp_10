//
//  PMO_T2_A_Cell.swift
//  GSSHOP
//
//  Created by gsshop iOS on 2020/06/16.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T2_A_Cell: BaseTableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    /// 브랜드명 라벨 Top
    @IBOutlet weak var titleLblTop: NSLayoutConstraint!
    /// 브랜드명 라벨
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var promotionLbl1: UILabel!

    @IBOutlet weak var moreBtn: UIButton!
    /// 찜 버튼
    @IBOutlet weak var zzimBtn: UIButton!
    /// 찜 갯수
    @IBOutlet weak var zzimLbl: UILabel!
    
    private var product : Module?
    private var indexPath: IndexPath?
    private var numberFormatter: NumberFormatter?
    
    @objc var aTarget: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.numberFormatter = NumberFormatter()
        self.numberFormatter?.numberStyle = .decimal
        
        self.moreBtn.setCorner()
        setInitUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath,  isNFXCType: Bool = false) {
            guard let product = Module(JSON: dic) else { return }
            setData(product, indexPath: indexPath, isNFXCType: isNFXCType)
        }
        
    func setData(_ prd: Module, indexPath: IndexPath, isNFXCType: Bool = false) {
        self.product = prd
        self.indexPath = indexPath
        
        guard let product = self.product else { return }
        
        // 배경 이미지 설정
        ImageDownManager.blockImageDownWithURL(product.imageUrl as NSString) { (httpStatusCode, fetchedImage, imageUrl, isInCache, error) in
            if error == nil, product.imageUrl == imageUrl, let image = fetchedImage {
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
                self.imgView.image = UIImage(named: Const.Image.img_noimage_375_188.name)
            }
        }

        self.titleLbl.text = product.productName
        self.promotionLbl1.text = product.promotionName

        
        // 더보기 아이콘
        if product.linkUrl.isEmpty {
            self.moreBtn.isHidden = true
        } else {
            self.moreBtn.isHidden = false
            self.moreBtn.accessibilityLabel = "더보기"
        }

        self.zzimBtn.setZzim(data: product)
        self.zzimCountUpdate()
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
                sectionTB.dctypetouchEventTBCell(product.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PMO_T2_A_Cell")
            } else if let nfxcListVC = self.aTarget as? NFXCListViewController {
                nfxcListVC.dctypetouchEventTBCell(dic: product.toJSON(), index: indexPath.row, viewType: "PMO_T2_A_Cell")
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
                            sectionTB.tableDataUpdate(false, key: "isWish", cellIndex: indexPath.row, viewType: "PMO_T2_A_Cell")
                            
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
                            sectionTB.tableDataUpdate(true, key: "isWish", cellIndex: indexPath.row, viewType: "PMO_T2_A_Cell")
                            
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

extension PMO_T2_A_Cell {
    private func setInitUI() {
        
        self.titleLbl.text = ""
        self.promotionLbl1.text = ""
        
        self.moreBtn.isHidden = true
        self.moreBtn.setBorder(width: 1.0, color: "ffffff", alpha: 0.3)
        self.zzimBtn.isHidden = true
        self.zzimLbl.text = ""
        self.imgView.image = UIImage(named: Const.Image.img_noimage_375_188.name)

    }
}
