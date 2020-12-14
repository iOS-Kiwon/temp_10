//
//  FXCTextHeaderView.swift
//  GSSHOP
//
//  Created by Kiwon on 07/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import Foundation

private let DEFAULT_TITLE_MARGIN: CGFloat = 10.0 * 2
private let DEFAULT_VIEW_HEIGHT: CGFloat = 54.0
private let DEFAULT_CELL_MARGIN: CGFloat = 8.0

class FXCTextHeaderView: UIView {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    /// Product 배열
    private var menus = [SubMenu]()
    /// 타이틀의 Width 길이 배열
    private var titleWidths = [CGFloat]()
    /// 타이틀의 위치 배열
    private var titlePosXList = [CGFloat]()
    /// 선택표시 라인
    private var lineView = UIView()
    /// 현재 선택된 Index
    private var currentSelectedIndex: Int = 0
    /// 이전에 선택한 IndexPath
    private var previousSelectedIndexPath: IndexPath!
    
    @objc var aTarget: AnyObject?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: DEFAULT_VIEW_HEIGHT))
        setInitUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setInitUI()
    }
    
    @objc convenience init(_ dic: Dictionary<String, Any>, selectedIndex: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: DEFAULT_VIEW_HEIGHT))
        
        guard let section = Section(JSON: dic) else { return }
        self.menus = section.subMenuList
        self.currentSelectedIndex = selectedIndex
        // 카테 메뉴 타이틀 설정
        setTitle()
        // 선택표시 라인 추가
        self.collectionView.addSubview(self.lineView)
        UIView.animate(withDuration: 0.0,
                       animations: {
                        self.collectionView.reloadData()
        }) { (success) in
            // 선택표시 라인 이동
            self.setSelectLine(index: self.currentSelectedIndex, animated: false)
        }
    }
    
    private func setInitUI() {
        let view = Bundle.main.loadNibNamed(FXCTextHeaderView.reusableIdentifier,  owner: self, options: nil)?.first as! UIView
        view.backgroundColor = .clear
        view.frame = self.bounds
        self.addSubview(view)
        
        self.collectionView.backgroundColor = .getColor("f5f5f5")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: FXCTextHeaderViewSubCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: FXCTextHeaderViewSubCell.reusableIdentifier)
        
        self.lineView = UIView(frame: CGRect(x: 0, y: 43.0, width: 0, height: 1) )
        self.lineView.backgroundColor = UIColor.getColor("444444")
    }
    
    private func setTitle() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        for menu in self.menus {
            var titleWidth: CGFloat = 0.0
            if !menu.sectionName.isEmpty {
                label.text = menu.sectionName
                titleWidth = label.intrinsicContentSize.width
            }
    
            self.titleWidths.append(titleWidth)
        }
    }
    
    private func setSelectLine(index: Int, animated: Bool = true) {
        if self.titlePosXList.count <= 0 || self.titleWidths.count <= 0 {
            self.lineView.frame = CGRect(x: 0, y: self.lineView.frame.origin.y,
                                         width: 0, height: self.lineView.frame.height)
            return
        }
        var posX = self.titlePosXList[index]
        let width =  self.titleWidths[index]
        if width <= (44 - DEFAULT_TITLE_MARGIN) {
            // 최소사이즈 일 경우
            posX += ((44 - DEFAULT_TITLE_MARGIN) - posX)
        }
        
        let frame = CGRect(x: posX, y: self.lineView.frame.origin.y,
                           width: width, height: self.lineView.frame.height)
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.lineView.frame = frame
            }
        } else {
            self.lineView.frame = frame
        }
    }
}

extension FXCTextHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FXCTextHeaderViewSubCell.reusableIdentifier, for: indexPath) as? FXCTextHeaderViewSubCell else {
            return UICollectionViewCell()
        }
        cell.titleLbl.text = self.menus[indexPath.row].sectionName
        if indexPath.row == self.currentSelectedIndex {
            cell.setTitleLabel(isSelected: true)
            self.previousSelectedIndexPath = indexPath
        } else {
            cell.setTitleLabel(isSelected: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.currentSelectedIndex == indexPath.row {
            return
        }

        // 현재 Cell Label 변경
        if let cell = collectionView.cellForItem(at: indexPath) as? FXCTextHeaderViewSubCell {
            cell.setTitleLabel(isSelected: true)
        }
        
        // 이전 Cell Label 변경
        if let cell = collectionView.cellForItem(at: self.previousSelectedIndexPath) as? FXCTextHeaderViewSubCell {
            cell.setTitleLabel(isSelected: false)
        }
        
        // CollectionView cell의 위치를 center로
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        // 라인 이동
        setSelectLine(index: indexPath.row)
        // 현재 index row값 저장
        self.currentSelectedIndex = indexPath.row
        // 이전 index값 저장
        self.previousSelectedIndexPath = indexPath
        
        if let fxcListTB = self.aTarget as? SectionView {
            let tag = NSNumber(value: self.currentSelectedIndex)
            fxcListTB.selectedfxccategorywithtag(tag)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? FXCTextHeaderViewSubCell {
            if self.titlePosXList[safe: indexPath.row] == nil {
                let newPosX = cell.frame.origin.x + cell.titleLbl.frame.origin.x
                self.titlePosXList.append(newPosX)
            }
        }
    }
}

extension FXCTextHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: DEFAULT_CELL_MARGIN, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: DEFAULT_CELL_MARGIN, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = self.titleWidths[indexPath.row] + DEFAULT_TITLE_MARGIN
        if width < 44.0  {
            width = 44.0
        }
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
