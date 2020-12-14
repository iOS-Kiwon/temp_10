//
//  SectionBAN_IMG_SLD_GBAtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 11/12/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

let BAN_IMG_SLD_GBA_SUB_CELL_HEIGHT: CGFloat = 155

class SectionBAN_IMG_SLD_GBAtypeCell: BaseTableViewCell {
    
    
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    
    private let mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    private var mBanButton:UIButton = UIButton(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    
    @objc var aTarget : AnyObject?

    private var prd = Module()
    private var subProductList = [Module]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectView.register(UINib(nibName: SectionBAN_IMG_SLD_GBAtypeSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: SectionBAN_IMG_SLD_GBAtypeSubCell.reusableIdentifier)
        self.titleView.addSubview(self.mBanner)
        self.mBanButton.backgroundColor = .clear
        self.mBanButton.addTarget(self, action: #selector(self.moreBtnAction(_:)), for: .touchUpInside)
        self.mBanButton.addTarget(self, action: #selector(self.Btn_pressed(_:)), for: .touchDown)
        self.mBanButton.addTarget(self, action: #selector(self.Btn_released(_:)), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        self.mBanner.addSubview(self.mBanButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mBanner.prepareForReuse()

    }
    
    @IBAction func Btn_pressed(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:true)
    }
    
    @IBAction func Btn_released(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:false)
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        if let sectionTB = self.aTarget, !self.prd.linkUrl.isEmpty {
            sectionTB.touchEventTBCellJustLinkStr?(self.self.prd.linkUrl)
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let module = Module(JSON: rowinfoDic) else { return }
        setCellInfoNDrawData(module)
    }
    
    func setCellInfoNDrawData(_ data: Module) {
        self.prd = data
        self.subProductList = data.subProductList
        self.mBanner.makeGBAview(imageUrl: self.prd.imageUrl, islink: !self.prd.linkUrl.isEmpty , title: self.prd.productName, subTittle: self.prd.promotionName)
        self.mBanner.setUnderLine(use: (!self.prd.bdrBottomYn.isEmpty && self.prd.bdrBottomYn == "Y"))
        self.mBanner.backgroundColor = .clear
        
        self.collectView.reloadData()
        self.collectView.layer.masksToBounds = false
    }
}

extension SectionBAN_IMG_SLD_GBAtypeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subProductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionBAN_IMG_SLD_GBAtypeSubCell.reusableIdentifier, for: indexPath) as? SectionBAN_IMG_SLD_GBAtypeSubCell else {
            return UICollectionViewCell()
        }
        let data = self.subProductList[indexPath.row]
        cell.setData(data)
        cell.aTarget = self;
        
        cell.backView.layer.cornerRadius = 6.0
        cell.backView.layer.masksToBounds = true
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor; //000000
        cell.layer.shadowOpacity = 0.16 //16%
        cell.layer.shadowOffset = CGSize(width:0.0, height: 2.0)
        cell.layer.shadowRadius = 12.0/2 //blur /2  = Radius
        let spread: CGFloat = 0.0
        let shadowFrame = CGRect(x: cell.layer.bounds.origin.x - spread,
                                 y: cell.layer.bounds.origin.y - (spread),
                                 width: cell.layer.bounds.size.width + spread,
                                         height: cell.layer.bounds.size.height + spread)
        let shadowPath = UIBezierPath(rect: shadowFrame).cgPath
        cell.layer.shadowPath = shadowPath;
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.aTarget as? SectionTBViewController {
            vc.touchEventDealCell(self.subProductList[indexPath.row].toJSON())
        }
    }
}

extension SectionBAN_IMG_SLD_GBAtypeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 104, height: BAN_IMG_SLD_GBA_SUB_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 0.0, 8.0, 32.0, 0.0
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 24.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    
}
