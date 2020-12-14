//
//  PRD_C_SQCell.swift
//  GSSHOP
//
//  Created by Kiwon on 01/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PRD_C_SQCell: BaseTableViewCell {

    private let DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN: CGFloat = 10.0
    private let DEFAULT_COLLECTIONVIEW_CELL_WIDTH: CGFloat = 156.0
    
     /// Collection뷰
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    /// Product 객체
    private var product: Module?
    
    /// 컬렉션뷰에 나타날 Sub Product
    private var products = [Module]()
    private var currentOperation: URLSessionDataTask?
    private var apiUseYN: Bool = false
    
    private var isValidImpression: Bool = false
    private var isImpressionDragOnce: Bool = false
    private var dicSendedIMP : Dictionary<String, Any> = [:]
    private var dicToSendIMP : Dictionary<String, Any> = [:]
    private var timerIMP : Timer?
    
    @objc var aTarget: AnyObject?
    
    //공통 타이틀 베너 적용
    private var mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    private var mBanButton:UIButton = UIButton(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: PRD_C_SQSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PRD_C_SQSubCell.reusableIdentifier)
        setInitUI()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.products.removeAll()
        self.mBanner.prepareForReuse()
        self.isValidImpression = false
        self.isImpressionDragOnce = false
        self.dicSendedIMP.removeAll()
        self.dicToSendIMP.removeAll()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        if self.products.count > 0  && self.apiUseYN {
            return
        }

        guard let prd = Module(JSON: dic) else { return }
        self.product = prd
        if self.currentOperation != nil {
            self.currentOperation?.cancel()
        }
        self.apiUseYN = true
        self.currentOperation = applicationDelegate.gshop_http_core
            .gsSECTIONUILISTURL(prd.linkUrl, isForceReload: true, onCompletion: { (result) in
                if let resultDic = result as? Dictionary<String, Any> ,
                    let product = Module(JSON: resultDic) {
                    self.product = product
                    self.products = product.subProductList
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.setTitleLbl(data: product)
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
    }
    
    @objc func setDataList(_ dic: Dictionary<String, Any>) {
        guard let prd = Module(JSON: dic) else { return }
        self.product = prd
        self.products = prd.subProductList
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: false)
        
        setTitleLbl(data: prd)
    }
    
    @objc func impressionValid(_ isImpression : Bool) {
        self.isValidImpression = isImpression
        
        if self.isValidImpression {
            self.dicSendedIMP.removeAll()
            self.dicToSendIMP.removeAll()
            self.isImpressionDragOnce = false
            
            //현제 화면에 노출되고있는 상품 mseq 전송
            let vCells = self.collectionView.getFullVisibleCells()
            vCells.forEach({
                if let pth = self.collectionView.indexPath(for: $0) {
                    //fullVisibleCells.append(pth)
                    if (self.dicSendedIMP[("\(pth.row)")] == nil) {
                        //self.dicToSendIMP[("\(pth.row)")] = "ToSend"
                        self.sendIMP_MSeq(pth)
                    }
                }
            })
        }
        
    }
    
    private func sendIMP_MSeq(_ path: IndexPath){
        if let prd = self.products[safe: path.row] {
            let number = path.row + 1
            var prdid = prd.dealNo
            if prdid == 0 {
                prdid = prd.prdid
            }
            let strMSeq = "?mseq=419669-\(number)-G-\(prdid)"
            applicationDelegate.wiseLogRestRequestNoCancel(wiselogcommonurl(pagestr:strMSeq))
            self.dicSendedIMP[("\(path.row)")] = "Sended"
        }
    }
    
    private func callTimerForIMP (){
        
        let vCells = self.collectionView.getFullVisibleCells()
        vCells.forEach({
            if let pth = self.collectionView.indexPath(for: $0) {
                //fullVisibleCells.append(pth)
                if (self.dicSendedIMP[("\(pth.row)")] == nil) {
                    self.dicToSendIMP[("\(pth.row)")] = "ToSend"
                }
            }
        })
        
        if let t = self.timerIMP, t.isValid {
           t.invalidate()
           self.timerIMP = nil
        }
        self.timerIMP = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkDicToSend) , userInfo: nil, repeats: false)
        RunLoop.main.add(self.timerIMP!, forMode: RunLoop.Mode.common)
    }
    
    @objc func checkDicToSend(){
        let vCells = self.collectionView.getFullVisibleCells()
        vCells.forEach({
            if let pth = self.collectionView.indexPath(for: $0) {
                //fullVisibleCells.append(pth)
                if (self.dicToSendIMP[("\(pth.row)")] != nil) {
                    self.sendIMP_MSeq(pth)
                }
            }
        })
        self.dicToSendIMP.removeAll()
    }
    
    private func setInitUI() {
        self.addSubview(self.mBanner)
        self.mBanButton.backgroundColor = .clear
        self.mBanButton.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
        self.mBanButton.addTarget(self, action: #selector(Btn_pressed(_:)), for: .touchDown)
        self.mBanButton.addTarget(self, action: #selector(Btn_released(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        self.mBanner.addSubview(self.mBanButton)
    }
    
    private func setTitleLbl(data: Module) {
        self.collectionViewTop.constant = 16.0
        
        // 타이틀 / 광고 / 더보깅에 따른 높이 변화...
        if data.productName.isEmpty && data.imageUrl.isEmpty && data.promotionName.isEmpty {
            if data.badgeRTType == "MORE" || data.badgeRTType == "AD" {
                self.collectionViewTop.constant = 56.0
            }
        } else {
            // 상단여백 24, 라벨높이 24, 하단여백 16
            self.collectionViewTop.constant = 56.0
        }
                
        
        // 이름 사용하는 플래그 활성
        if data.useName == "Y" {
          if let custName = DataManager.shared()?.userName {
             data.productName = custName + "님" + data.productName
          }
          else {
                data.productName = "고객님" + data.productName
            }
        }
        self.mBanner.makeGBAview(imageUrl: data.imageUrl, islink: !data.moreBtnUrl.isEmpty , title: data.productName, subTittle: data.promotionName)
        self.mBanner.setUnderLine(use: (!data.bdrBottomYn.isEmpty && data.bdrBottomYn == "Y"))
    }
    
    func setDataListForModule(_ dic: Dictionary<String, Any>) {
        guard let prd = Module(JSON: dic) else { return }
        self.product = prd
        self.products = prd.productList
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: false)
        
        
        // 공통 타이틀 설정
        if prd.name.isEmpty && prd.tabImg.isEmpty && prd.subName.isEmpty {
            self.collectionViewTop.constant = 16.0
        } else {
            // 타이틀 / 광고 / 더보깅에 따른 높이 변화...
            self.collectionViewTop.constant = 56.0
        }

        var titleStr = ""
        if let userName = DataManager.shared()?.userName, prd.viewType.contains("SRL") {
            titleStr = userName + "님 "
        }
        titleStr += prd.name
        
        let isLink = (prd.badgeRTType == "MORE" && !prd.moreBtnUrl.isEmpty)
        self.mBanner.makeGBAview(imageUrl: prd.tabImg, islink: isLink , title: titleStr, subTittle: prd.subName)
        self.mBanner.setUnderLine(use: (!prd.bdrBottomYn.isEmpty && prd.bdrBottomYn == "Y"))
    }
    
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        if let sectionTB = self.aTarget as? SectionTBViewController,
            let prd = self.product, !prd.moreBtnUrl.isEmpty {
            sectionTB.delegatetarget.touchEventTBCellJustLinkStr?(prd.moreBtnUrl)
        } else if let nfxcListVC = self.aTarget as? NFXCListViewController,
            let prd = self.product, !prd.moreBtnUrl.isEmpty {
            nfxcListVC.delegatetarget?.touchEventTBCellJustLinkStr?(prd.moreBtnUrl)
        }
    }
    
    @IBAction func Btn_pressed(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:true)
    }
    
    @IBAction func Btn_released(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:false)
    }
    
    
}

// MARK:- UICollectionViewDelegate & DataSource
extension PRD_C_SQCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PRD_C_SQSubCell.reusableIdentifier, for: indexPath) as? PRD_C_SQSubCell else {
            return UICollectionViewCell()
        }
        cell.isAccessibilityElement = true
        if let prd = self.products[safe: indexPath.row] {
            cell.setData(product: prd)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sectionTB = self.aTarget as? SectionTBViewController,
            let prd = self.products[safe: indexPath.row] {
            // 상품 클릭시
            sectionTB.dctypetouchEventTBCell(prd.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PRD_C_SQ")
        } else if let xfcListVC = self.aTarget as? NFXCListViewController,
            let prd = self.products[safe: indexPath.row] {
            xfcListVC.dctypetouchEventTBCell(dic: prd.toJSON(), index: indexPath.row, viewType: "PRD_C_SQ")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PRD_C_SQSubCell else { return }
        cell.didHighlightCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PRD_C_SQSubCell else { return }
        cell.didUnhighlightCell()
    }
}

extension PRD_C_SQCell: UICollectionViewDelegateFlowLayout {
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

extension PRD_C_SQCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isValidImpression == true , self.isImpressionDragOnce == false{
            //mseq 전송
            self.isImpressionDragOnce = true
            applicationDelegate.wiseLogRestRequestNoCancel(wiselogcommonurl(pagestr:"?mseq=419670"))
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.isValidImpression == true {
            //현제 화면에 노출되고있는 상품 mseq 전송
            self.callTimerForIMP()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            if self.isValidImpression == true {
                self.callTimerForIMP()
            }
        }
    }
}
