//
//  SectionSS_LINEtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 12/12/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionSS_LINEtypeCell: BaseTableViewCell {
    
    @IBOutlet weak var btn_cate1: UIButton!
    @IBOutlet weak var btn_cate2: UIButton!
    @IBOutlet weak var btn_cate3: UIButton!
    @IBOutlet weak var btn_cate4: UIButton!
    @IBOutlet weak var btn_cate5: UIButton!
    @IBOutlet weak var btn_cate6: UIButton!
    @IBOutlet weak var btn_cate7: UIButton!
    @IBOutlet weak var btn_cate8: UIButton!
    
    

    private var product : Module?
    private var currentOperation: URLSessionDataTask?
    private var apiUseYN: Bool = false
    private var indexPath: IndexPath?
    
    @objc var aTarget: SectionTBViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.btn_cate1.accessibilityLabel = "카테고리 링크"
        self.btn_cate2.accessibilityLabel = "카테고리 링크"
        self.btn_cate3.accessibilityLabel = "카테고리 링크"
        self.btn_cate4.accessibilityLabel = "카테고리 링크"
        self.btn_cate5.accessibilityLabel = "카테고리 링크"
        self.btn_cate6.accessibilityLabel = "카테고리 링크"
        self.btn_cate7.accessibilityLabel = "카테고리 링크"
        self.btn_cate8.accessibilityLabel = "전체 카테고리보기 링크"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func callApisetCellInfoNDrawData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        if self.apiUseYN, let prd = self.product {
            self.setData(prd)
            return
        }
        
        guard let data = Module(JSON: dic) else { return }
        self.indexPath = indexPath
        self.apiUseYN = true
        applicationDelegate.gshop_http_core.gsSECTIONUILISTURL(
            data.linkUrl, isForceReload: true, onCompletion: { (result) in
                guard let resultDic = result as? Dictionary<String, Any> else {
                    self.applicationDelegate.offloadingindicator()
                    return
                }
                
                if let prd = Module(JSON: resultDic), let vc = self.aTarget  {
                    
                    if prd.subProductList.count <= 0,
                        let indexPath = self.indexPath {
                        vc.tableCellRemove(indexPath.row)
                    } else {
                        self.setData(prd)
                    }
                }
        }) { (error) in
            if let vc = self.aTarget,
                let indexPath = self.indexPath {
                vc.tableCellRemove(indexPath.row)
            }
        }
        
    }
    
    @objc func setCellInfoNDrawData(_ dic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let data = Module(JSON: dic) else { return }
        self.indexPath = indexPath
        self.product = data
        setData(data)
    }
    
    func setData(_ data: Module) {
        self.product = data
        let subProductList = data.subProductList
        
        if subProductList.count < 8 {
            // 안뿌릴꺼임
            return
        }
        
        self.setBtnImage(withBtn: self.btn_cate1, imageUrl: subProductList[0].imageUrl)
        self.setBtnImage(withBtn: self.btn_cate2, imageUrl: subProductList[1].imageUrl)
        self.setBtnImage(withBtn: self.btn_cate3, imageUrl: subProductList[2].imageUrl)
        self.setBtnImage(withBtn: self.btn_cate4, imageUrl: subProductList[3].imageUrl)
        self.setBtnImage(withBtn: self.btn_cate5, imageUrl: subProductList[4].imageUrl)
        self.setBtnImage(withBtn: self.btn_cate6, imageUrl: subProductList[5].imageUrl)
        self.setBtnImage(withBtn: self.btn_cate7, imageUrl: subProductList[6].imageUrl)
        self.setBtnImage(withBtn: self.btn_cate8, imageUrl: subProductList[7].imageUrl)
        
        self.btn_cate1.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        self.btn_cate2.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        self.btn_cate3.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        self.btn_cate4.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        self.btn_cate5.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        self.btn_cate6.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        self.btn_cate7.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        self.btn_cate8.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        
        self.btn_cate1.accessibilityLabel = subProductList[0].productName
        self.btn_cate2.accessibilityLabel = subProductList[1].productName
        self.btn_cate3.accessibilityLabel = subProductList[2].productName
        self.btn_cate4.accessibilityLabel = subProductList[3].productName
        self.btn_cate5.accessibilityLabel = subProductList[4].productName
        self.btn_cate6.accessibilityLabel = subProductList[5].productName
        self.btn_cate7.accessibilityLabel = subProductList[6].productName
        self.btn_cate8.accessibilityLabel = subProductList[7].productName
        
    }
    
    
    private func setBtnImage(withBtn btn: UIButton, imageUrl: String) {
        if imageUrl.count <= 0 {
            btn.setImage(UIImage(named: Const.Image.ic_skeleton_favo.name), for: .normal)
            return
        }
        
        ImageDownManager.blockImageDownWithURL(imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
            
            if error == nil, imageUrl == strInputURL, let img = fetchedImage {
                DispatchQueue.main.async {
                    if isInCache.boolValue {
                        btn.setImage(img, for: .normal)
                        return
                    }
                    
                    btn.alpha = 0.0
                    btn.setImage(img, for: .normal)
                    UIView.animate(
                        withDuration: 0.2, delay: 0.0,
                        options: .curveEaseOut, animations: {
                            btn.alpha = 1.0
                    }, completion: nil)
                }
            } else {
                btn.setImage(UIImage(named: Const.Image.ic_skeleton_favo.name), for: .normal)
            }
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        if let prd = self.product,
            let data = prd.subProductList[safe: sender.tag] {
            self.aTarget?.dctypetouchEventTBCell(data.toJSON(), andCnum: NSNumber(value: sender.tag), withCallType: "SUB_SEC_LINE_" + String(sender.tag))
        }
    }

}
