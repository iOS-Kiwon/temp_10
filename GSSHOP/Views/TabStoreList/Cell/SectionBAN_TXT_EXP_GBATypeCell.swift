//
//  SectionBAN_TXT_EXP_GBATypeCell.swift
//  GSSHOP
//
//  Created by admin on 31/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

@objc class SectionBAN_TXT_EXP_GBATypeCell: UITableViewCell ,iCarouselDataSource, iCarouselDelegate {

    @objc var aTarget: AnyObject?                                                        //클릭시 이벤트를 보낼 타겟
    @objc var cellIndexPath:IndexPath?
    var row_arr: Array<Module> = Array()                                                   //carousel 로 표현할 전체뷰 데이터
    var scrollTimer: Timer?                                                       //타이머
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet var carouselProduct: iCarousel!                                      //상품정보가 슬라이딩 될 carousel
    @IBOutlet var openAndCloseButton: UIButton!                                    //확장 버튼?
    @IBOutlet var selectButton: UIButton!;                                          //전체를 덮는 버튼?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.carouselProduct.type = iCarouselType.linear;
        self.carouselProduct.isVertical = true
        self.carouselProduct.delegate = self
        self.carouselProduct.dataSource = self
        //self.carouselProduct.isUserInteractionEnabled = false
        self.carouselProduct.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stopScrolling()
        self.titleLb.text = ""
        self.row_arr.removeAll()
    }
    
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let product = Module(JSON: rowinfoDic) else { return }
        self.titleLb.text = product.exposePriceText
        self.row_arr = product.subProductList
        self.carouselProduct.reloadData()
        self.startScrolling()
    }
    
    
    //iCarousel methods
   
    func numberOfItems(in carousel: iCarousel) -> UInt {
        return UInt(self.row_arr.count);
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: UInt, reusing view: UIView?) -> UIView {
        var subView:SectionBAN_TXT_EXP_GBATypeSubView!;

        if let xview = view {
            subView = xview as? SectionBAN_TXT_EXP_GBATypeSubView;
            subView.prepareForReuse();
        }
        else {
            subView = Bundle.main.loadNibNamed("SectionBAN_TXT_EXP_GBATypeSubView", owner:self, options:nil)?.first as? SectionBAN_TXT_EXP_GBATypeSubView
            subView.frame = self.carouselProduct.frame;
            subView.aTarget = self.aTarget;
        }

        subView?.setDisplayDic(self.row_arr[Int(index)])
        
        return subView;
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case iCarouselOption.spacing:
            return value * 1.0;
        case iCarouselOption.wrap:
            return 1;
        default:
            return value;
        }
    }
    
    func startScrolling() {
        self.scrollTimer?.invalidate()
        self.scrollTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector:#selector(scrollStep), userInfo: nil, repeats: true)
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
    
    @IBAction func openAndClose(_ sender: Any) {
        // 다른 뷰로 교체 한다.
        if let bTarget:SectionTBViewController = self.aTarget as? SectionTBViewController {
            self.stopScrolling()
            self.carouselProduct.currentItemIndex = 0
            bTarget.tableDataUpdate("OPN" as NSObject, key: "randomYn", cellIndex: self.cellIndexPath!.row)
            bTarget.tableCellReload(self.cellIndexPath!.row)
        }        
    }
}
