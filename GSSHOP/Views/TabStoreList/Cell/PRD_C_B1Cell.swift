//
//  PRD_C_B1Cell.swift
//  GSSHOP
//
//  Created by Kiwon on 01/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PRD_C_B1Cell: BaseTableViewCell {
    
    private let DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN: CGFloat = 10.0
    private let DEFAULT_COLLECTIONVIEW_CELL_WIDTH: CGFloat = 300.0
    
    private let DEFAULT_TITLE_TOP: CGFloat = 16.0
    private let DEFAULT_TITLE_LABEL_HEIGHT: CGFloat = 56.0
    
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleHeigth: NSLayoutConstraint!

    /// Collection뷰
    @IBOutlet weak var collectionView: UICollectionView!
    /// 광고뷰
    @IBOutlet weak var adView: UIView!
    /// Product 객체
    private var product: Module?
    
    /// 컬렉션뷰에 나타날 Sub Product
    private var products = [Module]()
    private var currentOperation: URLSessionDataTask?
    
    @objc var aTarget: AnyObject?
    
    //공통 타이틀 베너 적용
    private var mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    private var mBanButton:UIButton = UIButton(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: PRD_C_B1SubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PRD_C_B1SubCell.reusableIdentifier)
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.products.removeAll()
        self.mBanner.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func setDataList(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        self.product = prd
        self.products = prd.subProductList
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: false)
        setTitleLbl(data: prd)
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        self.product = prd
        if self.currentOperation != nil {
            self.currentOperation?.cancel()
        }
        
        self.currentOperation = applicationDelegate.gshop_http_core
            .gsSECTIONUILISTURL(prd.linkUrl, isForceReload: true, onCompletion: { (result) in
                if let resultDic = result as? Dictionary<String, Any> ,
                    let product = Module(JSON: resultDic) {
                    self.products = product.subProductList
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(.zero, animated: false)
                } else  {
                    if let sectionTB = self.aTarget as? SectionTBViewController {
                        sectionTB.tableCellRemove(indexPath.row)
                    }
                    return
                }
            }, onError: { (error) in
                if let sectionTB = self.aTarget as? SectionTBViewController {
                    sectionTB.tableCellRemove(indexPath.row)
                }
            })
        
        setTitleLbl(data: prd)
    }
    
    func setDataListForModule(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        self.product = prd
        self.products = prd.productList
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: false)
        
        // 공통 타이틀 설정
        self.adView.isHidden = true
        
        let isLink = (prd.badgeRTType == "MORE" && !prd.moreBtnUrl.isEmpty)
        
        self.titleHeigth.constant = DEFAULT_TITLE_TOP
        if !prd.name.isEmpty || !prd.tabImg.isEmpty {
            self.titleHeigth.constant = DEFAULT_TITLE_LABEL_HEIGHT
        }
        
        if isLink || "AD" == prd.badgeRTType {
            self.titleHeigth.constant = DEFAULT_TITLE_LABEL_HEIGHT
            
            if "AD" == prd.badgeRTType {
                self.adView.isHidden = false
            }
            else {
                self.adView.isHidden = true
            }
        }
        
        self.mBanner.makeGBAview(imageUrl: prd.tabImg, islink:isLink , title: prd.name, subTittle: prd.subName)
        self.mBanner.setUnderLine(use: (!prd.bdrBottomYn.isEmpty && prd.bdrBottomYn == "Y"))
    }
    
    private func setInitUI() {        
        self.adView.isHidden = true
        self.titleView.addSubview(self.mBanner)
        self.mBanButton.backgroundColor = .clear
        self.mBanButton.addTarget(self, action: #selector(self.moreBtnAction(_:)), for: .touchUpInside)
        self.mBanButton.addTarget(self, action: #selector(self.Btn_pressed(_:)), for: .touchDown)
        self.mBanButton.addTarget(self, action: #selector(self.Btn_released(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        self.mBanner.addSubview(self.mBanButton)
        
    }
    
    /// 상단 타이틀 영역 설정
    private func setTitleLbl(data: Module) {
        
        self.adView.isHidden = true
        
        let isLink = (data.badgeRTType == "MORE" && !data.moreBtnUrl.isEmpty)
        
        self.titleHeigth.constant = DEFAULT_TITLE_TOP
        if !data.productName.isEmpty || !data.imageUrl.isEmpty {
            self.titleHeigth.constant = DEFAULT_TITLE_LABEL_HEIGHT
        }
       
        if isLink || "AD" == data.badgeRTType {
            self.titleHeigth.constant = DEFAULT_TITLE_LABEL_HEIGHT
            
            if "AD" == data.badgeRTType {
                self.adView.isHidden = false
            }
            else {
                self.adView.isHidden = true
            }
        }
        
        
        
        self.mBanner.makeGBAview(imageUrl: data.imageUrl, islink:isLink , title: data.productName, subTittle: data.promotionName)
        self.mBanner.setUnderLine(use: (!data.bdrBottomYn.isEmpty && data.bdrBottomYn == "Y"))
    }
    
    
    @IBAction func Btn_pressed(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:true)
    }
    
    @IBAction func Btn_released(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:false)
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        if let sectionTB = self.aTarget as? SectionTBViewController,
            let prd = self.product, !prd.moreBtnUrl.isEmpty {
            sectionTB.delegatetarget.touchEventTBCellJustLinkStr?(prd.moreBtnUrl)
        }
    }
}
// MARK:- UICollectionViewDelegate & DataSource
extension PRD_C_B1Cell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PRD_C_B1SubCell.reusableIdentifier, for: indexPath) as? PRD_C_B1SubCell else {
            return UICollectionViewCell()
        }
        cell.setData(product: self.products[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sectionTB = self.aTarget as? SectionTBViewController {
            // 상품 클릭시
            sectionTB.dctypetouchEventTBCell(self.products[indexPath.row].toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PRD_C_B1")
        } else if let nfcxTB = self.aTarget as? NFXCListViewController {
            nfcxTB.dctypetouchEventTBCell(dic: self.products[indexPath.row].toJSON(), index: indexPath.row, viewType: "PRD_C_B1")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PRD_C_B1SubCell else { return }
        cell.didHighlightCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PRD_C_B1SubCell else { return }
        cell.didUnhighlightCell()
    }
}

extension PRD_C_B1Cell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DEFAULT_COLLECTIONVIEW_CELL_WIDTH, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
