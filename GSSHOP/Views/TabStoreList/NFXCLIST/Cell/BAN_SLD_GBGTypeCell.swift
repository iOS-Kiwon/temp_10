//
//  BAN_SLD_GBGTypeCell.swift
//  GSSHOP
//
//  Created by neocyon MacBook on 2020/08/19.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_SLD_GBGTypeCell: UITableViewCell {

    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var lblTopTitle: UILabel!
    
    /// 모듈 객체
    private var module: Module?
    /// 셀 선택시 함수 Call할 타겟 VC
    weak var aTarget: NFXCListViewController?
    /// 방송 이미지 URL String 배열 객체
    private var arrImageUrls = [Module]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self
        self.imgCollectionView.register(UINib(nibName: BAN_SLD_GBGTypeSubImgCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: BAN_SLD_GBGTypeSubImgCell.reusableIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblTopTitle.text = ""
    }
 
    func setData(_ module: Module, target: NFXCListViewController) {

        self.module = module
        self.aTarget = target
        
        self.lblTopTitle.text = module.name
        self.arrImageUrls = module.moduleList
        self.imgCollectionView.reloadData()
        self.imgCollectionView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: false)
        self.layoutIfNeeded()
    }
    
    func onBtnImgCollection (_ indexPath : IndexPath){
        if let vc = self.aTarget,
            let imgData = self.arrImageUrls[safe: indexPath.row]  {
            vc.onBtnCellJustLinkStr(imgData.linkUrl)
        }
    }
}

// MARK:- UICollectionViewDelegate & DataSource
extension BAN_SLD_GBGTypeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let imgData = self.arrImageUrls[safe: indexPath.row] {
        
            //하단 상품 셀들
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BAN_SLD_GBGTypeSubImgCell.reusableIdentifier, for: indexPath) as? BAN_SLD_GBGTypeSubImgCell else {
                return UICollectionViewCell()
            }
            
            cell.setData(imgData, indexPath: indexPath, target: self)
            return cell
        }
        return UICollectionViewCell()
    }
}

// UICollectionViewDelegateFlowLayout
extension BAN_SLD_GBGTypeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140.0,height: 172.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 20.0, bottom: 16.0, right: 20.0)
        
    }
}
