//
//  SectionBAN_TXT_EXP_GBA_OTypeCell.swift
//  GSSHOP
//
//  Created by admin on 04/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
let PAGE_ITEM_COUNT:Int = 5
/// 확장한 BAN_TXT_EXP_GBA 배너
class SectionBAN_TXT_EXP_GBA_OTypeCell: UITableViewCell ,iCarouselDataSource, iCarouselDelegate {
    
    @objc var aTarget: AnyObject?;                                                        //클릭시 이벤트를 보낼 타겟
    @objc var cellIndexPath:IndexPath?
    var row_arr: Array<Module>!;                                                   //stackview 로 표현할 전체뷰 데이터
    var page_arr: Array<Array<Module>> = Array()                                   //5개씩 나눈다.
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var carouselProduct: iCarousel!;
    @IBOutlet weak var lbInfoText: UILabel!
    @IBOutlet weak var pageCnt: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.carouselProduct.type = iCarouselType.linear;
        self.carouselProduct.decelerationRate = 0.40;
        self.carouselProduct.delegate = self;
        self.carouselProduct.dataSource = self;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lbTitle.text = ""
        self.lbInfoText.text = ""
        self.row_arr.removeAll()
        self.page_arr.removeAll()
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let product = Module(JSON: rowinfoDic) else { return }
        self.lbTitle.text = product.exposePriceText
        self.lbInfoText.text = product.etcText1
        self.row_arr = product.subProductList
        if self.page_arr.count > 0 {
            self.page_arr.removeAll()
        }
        //페이징을 나눠야 한다. 몇개씩? 5개씩
        if self.row_arr.count > 0 {
            var arrRow:Array<Module> = Array<Module>()
            for index in 0..<self.row_arr.count {
                arrRow.append(self.row_arr[index])
                if (index+1)%PAGE_ITEM_COUNT == 0 || index+1 == self.row_arr.count {
                    self.page_arr.append(arrRow)
                    arrRow.removeAll()
                }
            }
        }
        
        self.pageCnt.numberOfPages = self.page_arr.count;
        self.carouselProduct.reloadData()
    }
    
    
    //iCarousel methods
    func numberOfItems(in carousel: iCarousel) -> UInt {
        return UInt(self.page_arr.count);        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: UInt, reusing view: UIView?) -> UIView {
        let subStackView:UIView
        if let xview = view {
            subStackView = xview ;
            for sub:UIView in subStackView.subviews {
                sub.removeFromSuperview()
            }
        }
        else {
           subStackView = UIView()
        }
        subStackView.frame = self.carouselProduct.frame        
        let prdList:Array<Module> = self.page_arr[Int(index)]
        var prdCount:CGFloat = 0
        for prd:Module in prdList {
            let subView:SectionBAN_TXT_EXP_GBATypeSubView = (Bundle.main.loadNibNamed("SectionBAN_TXT_EXP_GBATypeSubView", owner:self, options:nil)?.first as? SectionBAN_TXT_EXP_GBATypeSubView)!
            subView.frame = CGRect(x: 16.0, y: 0+(prdCount*48.0), width: subStackView.frame.width-32.0, height: 48.0)
            subView.aTarget = self.aTarget;
            subView.setDisplayDic(prd)
            subView.showUnderLine()
            subStackView.addSubview(subView)
            prdCount += 1
        }
        return subStackView;        
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
    
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.checkNowPages();
    }
    
    
    func checkNowPages() -> Void {
        if(self.page_arr.count > 1) {
                self.pageCnt.currentPage = self.carouselProduct.currentItemIndex;
        }
        else {
            self.carouselProduct.bounces = false;
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        // 다른 뷰로 교체 한다.
        if let bTarget:SectionTBViewController = self.aTarget as? SectionTBViewController {
            self.carouselProduct.currentItemIndex = 0
            bTarget.tableDataUpdate("" as NSObject, key: "randomYn", cellIndex: self.cellIndexPath!.row)
            bTarget.tableCellReload(self.cellIndexPath!.row)
        }
        
    }
}
