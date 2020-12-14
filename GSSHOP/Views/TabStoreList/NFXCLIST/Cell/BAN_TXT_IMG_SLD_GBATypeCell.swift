//
//  BAN_TXT_IMG_SLD_GBATypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/05/26.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_TXT_IMG_SLD_GBATypeCell: UITableViewCell {

    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var pageCountLbl: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var aTarget: NFXCListViewController?
    /// BAN_TXT_IMG_SLD_GBA 타입 모듈 객체
    private var moduleData: Module?
    /// 이미지 객체 리스트
    private var moduleList = [Module]()
    /// 무한롤링을 위한 row Max값
    private let MAX_ROW: Int = 10000
    /// 자동스크롤을 위한 Timer
    private var timer: Timer?
    /// 자동스크롤 duration
    private var autoRollingDuration: CGFloat = 3.0
    /// 현재 index
    private var currentIndex: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: BAN_TXT_IMG_SLD_GBATypeSubCell.className, bundle: nil), forCellWithReuseIdentifier: BAN_TXT_IMG_SLD_GBATypeSubCell.className)
        
        // pageView 라운딩
        self.pageView.setCorner()
        
        // 자동롤링 설정
        setAutoRolling()
    }
    
    @objc func setData(_ dic: Dictionary<String, Any>, indexPath: IndexPath, target: NFXCListViewController) {
        guard let product = Module(JSON: dic) else { return }
        self.setData(product, target: target)
    }

    
    func setData(_ data: Module, target: NFXCListViewController) {
        self.aTarget = target
        self.moduleData = data
        self.moduleList = data.moduleList

        /// 페이지 설정
        self.currentIndex = self.MAX_ROW / 2 - (self.MAX_ROW/2 % data.moduleList.count)
        setPageCount()
        
        // 1개 미만인 경우, 페이징 x
        if data.moduleList.count <= 1 {
            self.pageView.isHidden = true
            self.collectionView.isScrollEnabled = false
        } else {
            self.pageView.isHidden = false
            self.collectionView.isScrollEnabled = true
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if UIAccessibility.isVoiceOverRunning {
                return
            }
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            self.currentIndex = indexPath.row
        }
        self.collectionView.reloadData()
        CATransaction.commit()
    }
    
    func setAutoRolling(isStop: Bool = false) {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        
        if isStop { return }
        // 1개 미만인 경우, 자동롤링 disable
        if self.moduleList.count <= 1 { return }
        
        if UIAccessibility.isVoiceOverRunning { return }
        
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.autoRollingDuration), target: self, selector: #selector(self.moveRolling), userInfo: nil, repeats: true)
    }
    
}
// MARK:- Private Functions
extension BAN_TXT_IMG_SLD_GBATypeCell {
    
    @objc private func moveRolling() {
        for cell in self.collectionView.visibleCells {
            if let indexPath = self.collectionView.indexPath(for: cell) {
                /*
                self.currentIndex += 1
                if self.currentIndex >= self.MAX_ROW {
                    self.currentIndex = self.MAX_ROW / 2 + (self.MAX_ROW/2 % self.moduleList.count) + (indexPath.row % self.moduleList.count) + 1
                }
                let nextIndexPath = IndexPath(row: self.currentIndex, section: indexPath.section)
                self.collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                */
            
                self.currentIndex += 1
                if self.currentIndex >= self.MAX_ROW - 1 {
                    let nextIndexPath = IndexPath(row: self.currentIndex, section: indexPath.section)
                    self.collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.currentIndex = self.MAX_ROW / 2 + (self.MAX_ROW/2 % self.moduleList.count) - 1
                        let nextIndexPath = IndexPath(row: self.currentIndex, section: indexPath.section)
                        self.collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: false)
                        print("index : \(self.currentIndex)")
                    }
                    
                    
                } else {
                    let nextIndexPath = IndexPath(row: self.currentIndex, section: indexPath.section)
                    self.collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                }
                
                
                
                /// 페이지 설정
                setPageCount()
            }
        }
    }
    
    private func setPageCount() {
        guard let data = self.moduleData else {
            self.pageCountLbl.text = ""
            return
        }
        let nowPage = self.currentIndex % self.moduleList.count + 1
        self.pageCountLbl.text = "\(nowPage)/\(data.moduleList.count)"
    }

}

extension BAN_TXT_IMG_SLD_GBATypeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.moduleList.count <= 0 {
            return 0
        }
        
        // 보이스 오버시 롤링 정지하도록 하자! -> 갯수만큼 뿌려야 정상적인 보이스오버 가능
        if UIAccessibility.isVoiceOverRunning {
            return self.moduleList.count
        }
        
        return MAX_ROW
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BAN_TXT_IMG_SLD_GBATypeSubCell.className, for: indexPath) as? BAN_TXT_IMG_SLD_GBATypeSubCell else {
            return UICollectionViewCell()
        }
        
        var index: Int = 0
        if UIAccessibility.isVoiceOverRunning {
            index = indexPath.row
        } else {
            index = indexPath.row % self.moduleList.count
        }
        
        guard let data = self.moduleList[safe: index] else {
            return UICollectionViewCell()
        }
        
        cell.setData(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var index: Int = 0
        if UIAccessibility.isVoiceOverRunning {
            index = indexPath.row
        } else {
            index = indexPath.row % self.moduleList.count
        }
        
        if let nfcxVC = self.aTarget, let data = self.moduleList[safe: index] {
            nfcxVC.dctypetouchEventTBCell(dic: data.toJSON(), index: indexPath.row, viewType: Const.ViewType.BAN_TXT_IMG_SLD_GBA.name)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 사용자가 드레깅 시작시 타이머를 없앤다.
        // scrollViewDidEndDecelerating 함수에서 다시 설정한다.
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let indexPath = self.collectionView.indexPathForItem(at: CGPoint(x: scrollView.contentOffset.x, y: 0.0) ) {
            self.currentIndex = indexPath.row
            
            /// 페이지 설정
            setPageCount()
            
            /// 자동스크롤 재설정 - 시간(타이머)초기화
            setAutoRolling()
        }
    }

}

extension BAN_TXT_IMG_SLD_GBATypeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getAppFullWidth(), height:  284.0/375.0  * getAppFullWidth())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
