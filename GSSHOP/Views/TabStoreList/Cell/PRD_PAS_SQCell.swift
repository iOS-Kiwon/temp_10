//
//  PRD_PAS_SQCell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/07/14.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class PRD_PAS_SQCell: BaseTableViewCell {
    
    private let DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN: CGFloat = 10.0
    private let DEFAULT_COLLECTIONVIEW_CELL_WIDTH: CGFloat = 156.0

    /// 타이틀 라벨
    @IBOutlet weak var titleLbl: UILabel!
    /// 더보기 뷰
    @IBOutlet weak var moreView: UIView!
    /// 더보기 버튼
    @IBOutlet weak var moreBtn: UIButton!
    
    /// 선호도 뷰
    @IBOutlet weak var preferView: UIView!
    /// 선호도 이름 라벨
    @IBOutlet weak var preferNameLbl: UILabel!
    /// 선호도 하트뷰
    @IBOutlet weak var preferImgView: UIImageView!
    /// 선호도 서브 이름 라벨
    @IBOutlet weak var preferSubNameLbl: UILabel!
    
    /// 상단 타이틀뷰 높이
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    /// Collection뷰
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    /// Product 객체
    private var product: Module?
    
    /// 컬렉션뷰에 나타날 Sub Product
    private var products = [Module]()
    private var currentOperation: URLSessionDataTask?
    private var apiUseYN: Bool = false
    
    @objc var aTarget: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.preferView.isHidden = true
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: PRD_C_SQSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PRD_C_SQSubCell.reusableIdentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.products.removeAll()
        self.preferView.isHidden = true
        self.preferImgView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        self.product = prd
        self.products = prd.subProductList
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: false)
        
        setTitleViewUI(data: prd)
    }
    
    private func setTitleViewUI(data: Module) {
        // 상단 브랜드명(타이틀)
        self.titleLbl.text = data.productName
        
        // 더보기 노출여부
        if data.moreBtnUrl.isEmpty {
            self.moreView.isHidden = true
            self.moreBtn.isEnabled = false
        } else {
            self.moreView.isHidden = false
            self.moreBtn.isEnabled = true
        }
        
        self.titleViewHeight.constant = 56.0
         
        // 선호도뷰 설정
        if data.wishCnt.isEmpty == false {
            self.titleViewHeight.constant = 80.0
            
            self.preferNameLbl.text = data.name
            
            let count = round(NSString(string: data.wishCnt).doubleValue)

            switch count {
            case 0:
                self.preferImgView.image = UIImage(named: Const.Image.img_prefer_0.name)
            case 1:
                self.preferImgView.image = UIImage(named: Const.Image.img_prefer_1.name)
            case 2:
                self.preferImgView.image = UIImage(named: Const.Image.img_prefer_2.name)
            case 3:
                self.preferImgView.image = UIImage(named: Const.Image.img_prefer_3.name)
            case 4:
                self.preferImgView.image = UIImage(named: Const.Image.img_prefer_4.name)
            case 5:
                self.preferImgView.image = UIImage(named: Const.Image.img_prefer_5.name)
            default:
                self.preferImgView.image = UIImage(named: Const.Image.img_prefer_0.name)
            }
            
            self.preferSubNameLbl.text = data.subName
            self.preferView.isHidden = false
        } else {
            // 상단여백 24, 라벨높이 24, 하단여백 16
            self.titleViewHeight.constant = 56.0
            self.preferView.isHidden = true
        }
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
}

// MARK:- UICollectionViewDelegate & DataSource
extension PRD_PAS_SQCell: UICollectionViewDelegate, UICollectionViewDataSource {
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
            sectionTB.dctypetouchEventTBCell(prd.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PRD_PAS_SQ")
        } else if let xfcListVC = self.aTarget as? NFXCListViewController,
            let prd = self.products[safe: indexPath.row] {
            xfcListVC.dctypetouchEventTBCell(dic: prd.toJSON(), index: indexPath.row, viewType: "PRD_PAS_SQ")
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

extension PRD_PAS_SQCell: UICollectionViewDelegateFlowLayout {
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
