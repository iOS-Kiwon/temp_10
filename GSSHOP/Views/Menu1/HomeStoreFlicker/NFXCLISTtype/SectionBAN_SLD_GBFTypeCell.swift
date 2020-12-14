//
//  SectionBAN_SLD_GBFtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 07/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_SLD_GBFtypeCell: UITableViewCell { 

    private let COLLECTIONVIEW_CELL_WIDTH: CGFloat = 140
    private let COLLECTIONVIEW_CELL_HEIGHT: CGFloat = 254-10
    private let COLLECTIONVIEW_CELL_HEADER_WIDTH: CGFloat = 10
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //공통 타이틀 베너 적용
    private var mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth()-65, height: 56.0))
    private var mBanButton:UIButton = UIButton(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 56.0))
    
    /// 더보기 버튼에 사용될 link URL String 객체
    private var linkURL = ""
    /// CollectionView에 필요한 Product 타입 배열 객체
    private var products = [Module]()
    
    /// 셀 선택시 함수 Call할 타겟 VC
    @objc var aTarget: NFXCListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInitUI()
        self.titleView.addSubview(self.mBanner)
        self.mBanButton.backgroundColor = .clear
        self.mBanButton.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
        self.mBanButton.addTarget(self, action: #selector(Btn_pressed(_:)), for: .touchDown)
        self.mBanButton.addTarget(self, action: #selector(Btn_released(_:)) , for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        self.mBanner.addSubview(self.mBanButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.products.removeAll()
        self.mBanner.prepareForReuse()
        // 재사용시 collectionview를 제일 앞으로..
        self.collectionView.setContentOffset(.zero, animated: false)
    }
    /// 현재 Cell  초기화
    private func setInitUI() {
        // 현재 Cell UI 설정
        self.backgroundColor = .white
        
        // CollectionView 설정
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: SectionBAN_SLD_GBFtypeSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: SectionBAN_SLD_GBFtypeSubCell.reusableIdentifier)
    }
    
    @IBAction func Btn_pressed(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:true)
    }
    
    @IBAction func Btn_released(_ sender: UIButton) {
        self.mBanner.highlightedStatusSwitch(status:false)
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        guard let method = self.aTarget?.onBtnCellJustLinkStr else { return }
        method(self.linkURL)
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let module = Module(JSON: rowinfoDic) else { return }
        setCellInfoNDrawData(module)
    }
    
    func setCellInfoNDrawData(_ module: Module) {
        self.mBanner.makeGBAview(title: module.name)
        self.mBanner.setUnderLine(use: (!module.bdrBottomYn.isEmpty && module.bdrBottomYn == "Y"))
        self.products = module.productList
        
        self.collectionView.reloadData()
    }
}

// MARK:- UICollectionViewDelegate & DataSource
extension SectionBAN_SLD_GBFtypeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionBAN_SLD_GBFtypeSubCell.reusableIdentifier, for: indexPath) as? SectionBAN_SLD_GBFtypeSubCell else {
            return UICollectionViewCell()
        }
        cell.setCellInfoNDrawData(self.products[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.aTarget?.dctypetouchEventTBCell(dic: self.products[indexPath.row].toJSON(), index: indexPath.row, viewType: Const.ViewType.TAB_SLD_GBA.name)
    }
    
}
extension SectionBAN_SLD_GBFtypeCell: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: COLLECTIONVIEW_CELL_HEADER_WIDTH, height: COLLECTIONVIEW_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: COLLECTIONVIEW_CELL_HEADER_WIDTH, height: COLLECTIONVIEW_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: COLLECTIONVIEW_CELL_WIDTH, height: COLLECTIONVIEW_CELL_HEIGHT)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
