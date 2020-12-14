//
//  PMO_N_PRVCell.swift
//  GSSHOP
//
//  Created by Kiwon on 11/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PMO_T2_PREVIEWCell: BaseTableViewCell {
    
    private let DEFAULT_COLLECTIONVIEW_CELL_LEFT_MARGIN: CGFloat = 0.0
    private let DEFAULT_COLLECTIONVIEW_CELL_WIDTH: CGFloat = 78
    
    @objc var aTarget: AnyObject?

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var product : Module?
    private var products = [Module]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: PMO_T2_PREVIEWSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PMO_T2_PREVIEWSubCell.reusableIdentifier)
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

extension PMO_T2_PREVIEWCell {
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let prd = Module(JSON: dic) else { return }
        setData(prd, indexPath: indexPath)
    }
    
    func setData(_ product: Module, indexPath: IndexPath) {
        self.product = product
        self.products = product.subProductList
        
        self.imgView.setImgView(adultImg: UIImage(named: Const.Image.img_adult_375_188.name), data: product)
        
        self.collectionView.reloadData()
    }
}


extension PMO_T2_PREVIEWCell {
    private func setInitUI() {
        self.imgView.image = UIImage(named: Const.Image.img_noimage_375_188.name)
        self.collectionView.setContentOffset(.zero, animated: false)
    }
}

// MARK:- UICollectionViewDelegate & DataSource
extension PMO_T2_PREVIEWCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = self.products[indexPath.row]
        
        // 더보기 뷰타입인경우
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PMO_T2_PREVIEWSubCell.reusableIdentifier, for: indexPath) as? PMO_T2_PREVIEWSubCell else {
            return UICollectionViewCell()
        }
        cell.setData(product: product )
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.products[indexPath.row]
        // 더보기 클릭시
        if product.viewType == Const.ViewType.PMO_T2_PREVIEW_MORE.name,
            let sectionTB = self.aTarget as? SectionTBViewController,
            !product.linkUrl.isEmpty {
            sectionTB.delegatetarget.touchEventTBCellJustLinkStr?(product.linkUrl)
            return
        }
        
        // 상품 클릭시
        if let sectionTB = self.aTarget as? SectionTBViewController {
            sectionTB.dctypetouchEventTBCell(product.toJSON(), andCnum: NSNumber(value: indexPath.row), withCallType: "PMO_T2_PREVIEW")
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


extension PMO_T2_PREVIEWCell: UICollectionViewDelegateFlowLayout {
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
        return 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

