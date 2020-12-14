//
//  PMO_T1_PREVIEW_DCell.swift
//  GSSHOP
//
//  Created by Kiwon on 05/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T1_PREVIEW_DCell: BaseTableViewCell {
    
    private let DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN: CGFloat = 13.0
    private let DEFAULT_COLLECTIONVIEW_CELL_WIDTH: CGFloat = 110.0 + 3 + 3
    /// 이미지뷰
    @IBOutlet weak var imgView: UIImageView!
    /// 뷰 버튼
    @IBOutlet weak var button: UIButton!
    /// Collection뷰
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var product : Module?
    private var products = [Module]()
    private var indexPath: IndexPath?
    @objc var aTarget: AnyObject?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: PMO_T1_PREVIEW_DSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PMO_T1_PREVIEW_DSubCell.reusableIdentifier)
        self.collectionView.register(UINib(nibName: PMO_T1_PREVIEW_DSubMoreCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PMO_T1_PREVIEW_DSubMoreCell.reusableIdentifier)
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let product = Module(JSON: dic) else { return }
        if let subProduct = product.subProductList.first {
            self.product = subProduct
            self.products = subProduct.subProductList
            self.indexPath = indexPath
            self.imgView.setImgView(adultImg: UIImage(named: Const.Image.img_noimage_166.name), data: subProduct)
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(.zero, animated: false)
            
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let product = self.product, let indexPath = self.indexPath,
            let sectionTB = self.aTarget as? SectionTBViewController {
            sectionTB.dctypetouchEventTBCell(product.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PMO_T1_PREVIEW_D")
        }
    }
}

extension PMO_T1_PREVIEW_DCell {
    private func setInitUI() {
        self.imgView.image = UIImage(named: Const.Image.img_noimage_166.name)
    }
}

// MARK:- UICollectionViewDelegate & DataSource
extension PMO_T1_PREVIEW_DCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = self.products[indexPath.row]
        
        // 더보기 뷰타입인경우
        if product.viewType == Const.ViewType.PMO_T1_PREVIEW_D_MORE.name {
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
        // 더보기 클릭시
        if product.viewType == Const.ViewType.PMO_T1_PREVIEW_D_MORE.name,
            let sectionTB = self.aTarget as? SectionTBViewController,
            !product.linkUrl.isEmpty {
            sectionTB.delegatetarget.touchEventTBCellJustLinkStr?(product.linkUrl)
            return
        }
        
        // 상품 클릭시
        if let sectionTB = self.aTarget as? SectionTBViewController {
            sectionTB.dctypetouchEventTBCell(product.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PMO_T1_PREVIEW_D")
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


extension PMO_T1_PREVIEW_DCell: UICollectionViewDelegateFlowLayout {
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
