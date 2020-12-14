//
//  SectionTAB_SLD_GBAtypeHeaderView.swift
//  GSSHOP
//
//  Created by Kiwon on 04/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionTAB_SLD_GBAtypeHeaderView: UITableViewHeaderFooterView {


    private let COLLECTIONVIEW_CELL_WIDTH: CGFloat = 68.0
    private let COLLECTIONVIEW_CELL_HEIGHT: CGFloat = 80.0 //COLLECTIONVIEW_CELL_HEIGHT
    private let COLLECTIONVIEW_CELL_HEADER_WIDTH: CGFloat = 4
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 모듈 객체
    private var module: Module?
    /// CollectionView에 필요한 Module 타입 배열 객체
    private var modules = [Module]()
    /// 셀 선택시 함수 Call할 타겟 VC
    var aTarget: NFXCListViewController?
    /// 해당 카테고리의 Section
    var section: Int = 0
    /// 선택된 Cell Index
    var selectedCateIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setInitUI()
    }
}

// MARK:- Private Functions
extension SectionTAB_SLD_GBAtypeHeaderView {
    
    /// 현재 Cell  초기화
    private func setInitUI() {
        // 현재 Cell UI 설정
        self.backgroundView = {
            // HeaderFooterView의 Background Color는 아래처럼 설정해야한다.
            let view = UIView()
            view.frame = self.frame
            view.backgroundColor = .white
            return view
        }()
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: COLLECTIONVIEW_CELL_HEIGHT)       // 121.0 = COLLECTIONVIEW_CELL_HEIGHT + 상단 10 마진 + 하단 1pt 라인
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: SectionTAB_SLD_GBAtypeSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: SectionTAB_SLD_GBAtypeSubCell.reusableIdentifier)
        self.collectionView.scrollsToTop = false
    }
}

// MARK:- Public Functions
extension SectionTAB_SLD_GBAtypeHeaderView {
    
    /// 데이터 설정
    @objc func setCellInfo(module: Module, target: NFXCListViewController) {
        self.module = module
        self.aTarget = target
        self.modules = module.moduleList
        for (index, m) in self.modules.enumerated() {
            if index == self.selectedCateIndex {
                m.tabOnImg = "Y"
            } else {
                m.tabOnImg = "N"
            }
        }
        self.collectionView.reloadData()
        let indexPath = IndexPath(item: self.selectedCateIndex, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func moveToNextTab(tabSeq: String) {

        for (index, module) in self.modules.enumerated() {
            if module.tabSeq == tabSeq {
                
                if index == self.selectedCateIndex {
                    // 같은 카테고리
                    break
                }
                
                // 이전 선택된 것 해제
                let preIndexPath = IndexPath(row: self.selectedCateIndex, section: 0)
                if let cell = self.collectionView.cellForItem(at: preIndexPath) as? SectionTAB_SLD_GBAtypeSubCell {
                    module.tabOnImg = "N"
                    cell.setImageRound(isSelected: false)
                    self.collectionView.deselectItem(at: preIndexPath, animated: false)
                }
                
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? SectionTAB_SLD_GBAtypeSubCell {
                    self.selectedCateIndex = indexPath.row
                    module.tabOnImg = "Y"
                    cell.setImageRound(isSelected: true)
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                }
                break
            }
        }
    }
}

extension SectionTAB_SLD_GBAtypeHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modules.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionTAB_SLD_GBAtypeSubCell.reusableIdentifier, for: indexPath) as? SectionTAB_SLD_GBAtypeSubCell else { return UICollectionViewCell() }
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = self.modules[indexPath.row].name
        cell.setCellInfoNDrawData(self.modules[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        let moduleData = self.modules[indexPath.row]
        if let module = self.module,
            let data = self.modules[safe: indexPath.row],
            module.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name,
            let nfxTB = self.aTarget {
            nfxTB.moveToAnk(tabSeq: data.tabSeq)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            
            if let cell = collectionView.cellForItem(at: indexPath) as? SectionTAB_SLD_GBAtypeSubCell {
                self.selectedCateIndex = indexPath.row
                moduleData.tabOnImg = "Y"
                cell.setImageRound(isSelected: true)
            }
            return
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SectionTAB_SLD_GBAtypeSubCell {
            moduleData.tabOnImg = "Y"
            cell.setImageRound(isSelected: true)
        }
        
        
        // 해당 카테고리 영역 호출
        self.aTarget?.onBtnTAB_SLD_GBA(moduleData, section: self.section, idxClicked: indexPath.row)
        
        // wiseLog 호출
        if !moduleData.wiseLog.isEmpty,
            let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.wiseLogRestRequest(moduleData.wiseLog)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        for m in self.modules {
            m.tabOnImg = "N"
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? SectionTAB_SLD_GBAtypeSubCell {
            self.modules[indexPath.row].tabOnImg = "N"
            cell.setImageRound(isSelected: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let willCell = cell as? SectionTAB_SLD_GBAtypeSubCell {
            let valueStr = self.modules[indexPath.row].tabOnImg
            willCell.setImageRound(isSelected: valueStr == "Y" ? true : false)
        }
    }
}


extension SectionTAB_SLD_GBAtypeHeaderView: UICollectionViewDelegateFlowLayout {
    
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

