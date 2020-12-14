//
//  SUPBannerModal.swift
//  GSSHOP
//
//  Created by Home on 2020/09/15.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import Foundation


class SUPBannerModal: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lcontTopMargin: NSLayoutConstraint!
    
    /// 베너 배열 객체
    private var bannerArr = [Dictionary<String, AnyObject>]()
    /// 해당뷰 부모객체
    @objc var aTarget: SUPListTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lcontTopMargin.constant = IS_IPHONE_X_SERISE() ? 50 : 20
         
        self.tableView.register(UINib(nibName: SectionSUPBannerModalCell.className, bundle: nil) , forCellReuseIdentifier: SectionSUPBannerModalCell.className)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeBtnAction(_:)), name: NSNotification.Name(rawValue: MAINSECTIONGOTOPNRELOADNOTI), object: nil)
    }
    
    @objc func setData(_ arrInfo: [Dictionary<String, AnyObject>]) {
        self.bannerArr.removeAll()
        self.bannerArr.append(contentsOf: arrInfo)
        
        self.tableView.reloadData()
    }
}

extension SUPBannerModal: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bannerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowDic = self.bannerArr[safe: indexPath.row] else { return UITableViewCell() }
        guard let data = Module(JSON: rowDic) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SectionSUPBannerModalCell.className) as! SectionSUPBannerModalCell
        cell.setData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ceil((187.0/375.0) * getAppFullWidth()) + 1.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let rowDic = self.bannerArr[safe: indexPath.row] else { return }
        guard let data = Module(JSON: rowDic) else { return }
        
        if let target = self.aTarget, data.linkUrl.isEmpty == false {
            target.onBtnSUPCellJustLinkStr(data.linkUrl)
            self.removeFromSuperview()
        }
    }
}

/// Button Action Functions
extension SUPBannerModal {
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
