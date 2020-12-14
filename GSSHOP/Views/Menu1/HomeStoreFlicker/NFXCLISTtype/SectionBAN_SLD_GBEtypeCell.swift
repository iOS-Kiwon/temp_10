//
//  SectionBAN_SLD_GBEtypeCell.swift
//  GSSHOP
//
//  Created by gsshop iOS on 07/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_SLD_GBEtypeCell: UITableViewCell ,iCarouselDataSource, iCarouselDelegate {
    ///메인 이름
    //@IBOutlet weak var lbtitle: UILabel!
    @IBOutlet var carouselProduct: iCarousel!
    var row_arr: Array<Module> = Array()                                                   //carousel 로 표현할 전체뷰 데이터
    @objc var aTarget: AnyObject?                                                        //클릭시 이벤트를 보낼 타겟
    var selDic:Module!
    var scrollTimer: Timer?                                                        //타이머
    @IBOutlet weak var lbCurrentPage: UILabel!
    @IBOutlet weak var lbTotalPage: UILabel!
    var totalCount:Int = 0                                                      //전체 갯수
    
    @IBOutlet weak var titleView: UIView!
    //공통 타이틀 베너 적용
    private var mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth()-65, height: 56.0))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.carouselProduct.type = .linear
        self.carouselProduct.decelerationRate = 0.40
        self.carouselProduct.isAccessibilityElement = false;
        self.carouselProduct.isVertical = false //가로
        self.carouselProduct.delegate = self
        self.carouselProduct.dataSource = self
        
        self.titleView.addSubview(self.mBanner)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lbTotalPage.text = ""
        self.lbCurrentPage.text = ""
        self.row_arr.removeAll()
        self.mBanner.prepareForReuse()
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let module = Module(JSON: rowinfoDic) else { return }
        setCellInfoDrawData(module: module)
    }
    
    func setCellInfoDrawData(module: Module) {
        self.selDic = module
        self.mBanner.makeGBAview(title: self.selDic.name)
        self.mBanner.setUnderLine(use: (!self.selDic.bdrBottomYn.isEmpty && self.selDic.bdrBottomYn == "Y"))
        self.row_arr = self.selDic.productList
        self.totalCount = self.selDic.productList.count
        
        if(self.totalCount == 2) { //2개일때 예외 - 2개 추가한다.
            self.row_arr.append(contentsOf: self.selDic.productList)
        }
        
        self.lbTotalPage.text = String(self.totalCount)
        self.lbCurrentPage.text = "1"
        self.carouselProduct.reloadData()
        self.carouselProduct.currentItemIndex = 0
        //자동롤링
        self.startScrolling()
    }
    
    //iCarousel methods
    
    func numberOfItems(in carousel: iCarousel) -> UInt {
        return UInt(self.row_arr.count);
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: UInt, reusing view: UIView?) -> UIView {
        var subView:SectionBAN_SLD_GBEtypeSubView!;
        
        if let xview = view {
            subView = xview as? SectionBAN_SLD_GBEtypeSubView;
            subView.prepareForReuse();
        }
        else {
            subView = Bundle.main.loadNibNamed("SectionBAN_SLD_GBEtypeSubView", owner:self, options:nil)?.first as? SectionBAN_SLD_GBEtypeSubView
            subView.frame = CGRect(x:0 ,y: 0,width: self.carouselProduct.frame.width - 45, height: self.carouselProduct.frame.height )
            subView.aTarget = self.aTarget;
        }
        
        subView?.setDisplayDic(self.row_arr[Int(index)])
        
        return subView;
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case iCarouselOption.wrap:
            return CGFloat(truncating: true)
        case iCarouselOption.visibleItems:
            return 5 // 미리 5개 로딩
        default:
            return value
        }
    }
    
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        self.stopScrolling()
        
        self.aTarget?.dctypetouchEventTBCell(dic: self.row_arr[Int(index)].toJSON(), index: index, viewType: Const.ViewType.BAN_SLD_GBE.name)
    }    
    
    
    @objc func startScrolling() {
        if self.totalCount > 1, self.selDic!.rollingDelay > 0 ,(self.scrollTimer == nil || self.scrollTimer?.isValid == false) {
            self.scrollTimer?.invalidate()
            self.scrollTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.selDic!.rollingDelay), target: self, selector:#selector(scrollStep), userInfo: nil, repeats: true)
        }
    }
    
    @objc func scrollStep() {
        if !self.carouselProduct.isDragging, !self.carouselProduct.isDecelerating {
            let idxNext = (self.carouselProduct.currentItemIndex + 1 == self.row_arr.count) ? 0 : self.carouselProduct.currentItemIndex + 1;
            self.carouselProduct.scrollToItem(at: idxNext, animated: true)
        }
    }
    
    func stopScrolling() {
        self.scrollTimer?.invalidate()
        self.scrollTimer = nil;
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.checkNowPages();
    }
    
    
    func checkNowPages() {
        //2개 페이징 할때 예외처리
        if (self.totalCount == 2) {
            if(self.carouselProduct.currentItemIndex > 1) {
                self.lbCurrentPage.text = String(self.carouselProduct.currentItemIndex-1);
            }
            else {
                self.lbCurrentPage.text = String(self.carouselProduct.currentItemIndex+1);
            }
        }
        else if(self.totalCount > 1) {
            self.lbCurrentPage.text = String(self.carouselProduct.currentItemIndex+1);
        }
        else {
            self.carouselProduct.bounces = false;
        }
    }
    
}
