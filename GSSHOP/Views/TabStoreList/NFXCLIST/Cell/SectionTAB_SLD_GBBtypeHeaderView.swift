//
//  SectionTAB_SLD_GBBtypeHeaderView.swift
//  GSSHOP
//
//  Created by Kiwon on 04/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionTAB_SLD_GBBtypeHeaderView: UITableViewHeaderFooterView {
    
    private var COLLECTIONVIEW_CELL_HEIGHT: CGFloat = 50.0
    private let COLLECTIONVIEW_CELL_HEADER_WIDTH: CGFloat = 10.0
    private let COLLECTIONVIEW_CELL_MARGIN: CGFloat = 1.0           // SubCell 버튼 앞뒤 여백값
    
    /// Collection View
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lineView: UIView!
    
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
    /// 테이블뷰에 생성된 첫번재 카테고리(틀고정)의 section
    var firstSection: Int = 0
    /// 선언된 뷰타입
    var viewType:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInitUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundView = {
            // HeaderFooterView의 Background Color는 아래처럼 설정해야한다.
            let view = UIView()
            view.frame = self.frame
            view.backgroundColor = .white
            return view
        }()
    }
    
}

// MARK:- Private Functions
extension SectionTAB_SLD_GBBtypeHeaderView{
    
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
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: COLLECTIONVIEW_CELL_HEIGHT)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.scrollsToTop = false
        self.collectionView.register(UINib(nibName: SectionTAB_SLD_GBBtypeSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: SectionTAB_SLD_GBBtypeSubCell.reusableIdentifier)
    }
    
    /// CollectionViewFlowLayout의 Size 설정
    private func getSubCellSize(row: Int) -> CGSize {
        let title = self.modules[row].name
        if !title.isEmpty {
            let button  = CategoryButton(title: title)
            return CGSize(width: button.frame.width + (COLLECTIONVIEW_CELL_MARGIN * 2), height: COLLECTIONVIEW_CELL_HEIGHT)
        }
        return .zero
    }
}

// MARK:- Public Functions
extension SectionTAB_SLD_GBBtypeHeaderView{
    
    /// 데이터 설정
    func setCellInfo(module: Module, target: NFXCListViewController) {
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
    
    /// GS혜택 엥커용 데이터 설정
    func setData(_ module: Module, target: NFXCListViewController) {
        
        COLLECTIONVIEW_CELL_HEIGHT = 46.0
        
        self.lineView.backgroundColor = .getColor("111111", alpha: 0.1)
        
        self.module = module
        self.aTarget = target
        self.modules = module.moduleList
        if module.viewType == Const.ViewType.TAB_ANK_GBA.name {
            // 기획문서에 좌우 스크롤 불가로 정의되어 있음...
            self.collectionView.isScrollEnabled = false
            self.collectionView.backgroundColor = .getColor("f5f5f5")
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
                if let cell = self.collectionView.cellForItem(at: preIndexPath) as? SectionTAB_SLD_GBBtypeSubCell {
                    cell.cateBtn.isSelected = false
                    self.collectionView.deselectItem(at: preIndexPath, animated: false)
                }
                
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? SectionTAB_SLD_GBBtypeSubCell {
                    self.selectedCateIndex = indexPath.row
                    self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                    cell.cateBtn.isSelected = true
                }
                break
            }
        }
    }
}

// MARK:- UICollectionViewDelegate & UICollectionViewDataSource
extension SectionTAB_SLD_GBBtypeHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modules.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionTAB_SLD_GBBtypeSubCell.reusableIdentifier, for: indexPath) as? SectionTAB_SLD_GBBtypeSubCell else { return UICollectionViewCell() }
        
        // GS혜택 - 엥커/텝고정인 경우
        if let data = self.module, data.viewType == Const.ViewType.TAB_ANK_GBA.name {
            
            if let moduleData = self.modules[safe: indexPath.row] {
                cell.isAccessibilityElement = true
                cell.accessibilityTraits = .button
                cell.accessibilityLabel = moduleData.name
                cell.setCateBtnHeight(30.0)
                cell.setTitle(moduleData.name)
                
                cell.cateBtn.bgColorForNormal(.clear)
                cell.cateBtn.titleColorForNormal(UIColor.getColor("666666"))

                cell.cateBtn.bgColorForSelected(UIColor.getColor("74bc3c"))
                cell.cateBtn.titleColorForSelected(.white)
                
                /// 버튼 selected 상태 설정
                if data.tabSeq == moduleData.tabSeq {
                    cell.cateBtn.isSelected = true
                } else {
                    cell.cateBtn.isSelected = false
                }
            }

            // 버튼 이벤트는 didSelect가 대신한다.
            cell.cateBtn.isUserInteractionEnabled = false
            return cell
        }
        
        if let data = self.module, data.viewType == "TAB_SLD_ANK_GBA" {
            if let moduleData = self.modules[safe: indexPath.row] {
                cell.isAccessibilityElement = true
                cell.accessibilityTraits = .button
                cell.accessibilityLabel = moduleData.name
                cell.setCateBtnHeight(30.0)
                cell.setTitle(moduleData.name)
                
                cell.cateBtn.bgColorForNormal(.clear)
                cell.cateBtn.titleColorForNormal(UIColor.getColor("666666"))
                
                cell.cateBtn.bgColorForSelected(UIColor.getColor("74bc3c"))
                cell.cateBtn.titleColorForSelected(.white)
                
                if !data.activeTextColor.isEmpty {
                    cell.cateBtn.titleColorForSelected(UIColor.getColor(data.activeTextColor))
                }
                if !data.bgColor.isEmpty {
                    cell.cateBtn.bgColorForSelected(UIColor.getColor(data.bgColor))
                }

                
                /// 버튼 selected 상태 설정
                if data.moduleList[self.selectedCateIndex].tabSeq == moduleData.tabSeq {
                    cell.cateBtn.isSelected = true
                } else {
                    cell.cateBtn.isSelected = false
                }
            }
            
            // 버튼 이벤트는 didSelect가 대신한다.
            cell.cateBtn.isUserInteractionEnabled = false
            return cell
        }
            
        let data = self.modules[indexPath.row]
        cell.isAccessibilityElement = true
        cell.accessibilityTraits = .button
        cell.accessibilityLabel = data.name
        cell.setTitle(data.name)
        if !data.activeTextColor.isEmpty {
            cell.cateBtn.titleColorForSelected(UIColor.getColor(data.activeTextColor))
        }
        if !data.bgColor.isEmpty {
            cell.cateBtn.bgColorForSelected(UIColor.getColor(data.bgColor))
        }
        
        /// 현재 카테고리 Section 위치에 따른 버튼 selected 상태 설정
        if (self.section - self.firstSection) == indexPath.row {
            cell.cateBtn.isSelected = true
        } else {
            cell.cateBtn.isSelected = false
        }
        // 버튼 이벤트는 didSelect가 대신한다.
        cell.cateBtn.isUserInteractionEnabled = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // GS혜택 - 엥커/텝고정인 경우
        if let data = self.module, data.viewType == Const.ViewType.TAB_ANK_GBA.name,
            let nfxTB = self.aTarget {
            
            let moveIndexPath = IndexPath(row: 0, section: self.firstSection + indexPath.row)
            nfxTB.tableView.scrollToRow(at: moveIndexPath, at: .top, animated: true)
            
            // wiseLog 호출
            if let moduleData = self.modules[safe: indexPath.row],
                !moduleData.wiseLog.isEmpty,
                let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.wiseLogRestRequest(moduleData.wiseLog)
            }
            return
        }
        
        if let module = self.module,
            let data = self.modules[safe: indexPath.row],
            module.viewType == "TAB_SLD_ANK_GBA",
            let nfxTB = self.aTarget {
            nfxTB.moveToAnk(tabSeq: data.tabSeq)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            
            if let cell = collectionView.cellForItem(at: indexPath) as? SectionTAB_SLD_GBBtypeSubCell {
                self.selectedCateIndex = indexPath.row
                cell.cateBtn.isSelected = true
            }
            return
        }
        
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        let moduleData = self.modules[indexPath.row]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SectionTAB_SLD_GBBtypeSubCell {
            moduleData.tabOnImg = "Y"
            cell.cateBtn.isSelected = true
        }
        
        // 해당 카테고리 영역 호출
        self.aTarget?.onBtnTAB_SLD_GBB(moduleData, section: self.section, btnIndex: indexPath.row)
        
        // wiseLog 호출
        if !moduleData.wiseLog.isEmpty,
            let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.wiseLogRestRequest(moduleData.wiseLog)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // GS혜택 - 엥커/텝고정인 경우
        if let data = self.module, data.viewType == Const.ViewType.TAB_ANK_GBA.name {
            return
        }
        
        for m in self.modules {
            m.tabOnImg = "N"
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? SectionTAB_SLD_GBBtypeSubCell {
            self.modules[indexPath.row].tabOnImg = "N"
            cell.cateBtn.isSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // GS혜택 - 엥커/텝고정인 경우
        if let data = self.module, data.viewType == Const.ViewType.TAB_ANK_GBA.name {
            return
        }
        
        if let data = self.module, data.viewType == "TAB_SLD_ANK_GBA",
            let moduleData = self.modules[safe: indexPath.row],
            let willCell = cell as? SectionTAB_SLD_GBBtypeSubCell {
            
            if data.moduleList[self.selectedCateIndex].tabSeq == moduleData.tabSeq {
                willCell.cateBtn.isSelected = true
            } else {
                willCell.cateBtn.isSelected = false
            }
            return
        }
        
        if let willCell = cell as? SectionTAB_SLD_GBBtypeSubCell {
            let valueStr = self.modules[indexPath.row].tabOnImg
            willCell.cateBtn.isSelected = valueStr == "Y" ? true : false
        }
    }
}
// MARK:- UICollectionViewDelegateFlowLayout
extension SectionTAB_SLD_GBBtypeHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: COLLECTIONVIEW_CELL_HEADER_WIDTH, height: COLLECTIONVIEW_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: COLLECTIONVIEW_CELL_HEADER_WIDTH, height: COLLECTIONVIEW_CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getSubCellSize(row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
