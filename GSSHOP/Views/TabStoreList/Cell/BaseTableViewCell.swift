//
//  BaseTableViewCell.swift
//  GSSHOP
//
//  Created by Kiwon on 01/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func addZzim(url: String, completion: @escaping (_ isSuccess: Bool, _ zzimData: Zzim?) -> Void) {
        updateZzim(value: true, url: url, completion: completion)
    }
    
    func deleteZzim(url: String, completion: @escaping (_ isSuccess: Bool, _ zzimData: Zzim?) -> Void) {
        updateZzim(value: false, url: url, completion: completion)
    }
    
    /// Cell 전체를 Scale 비율로 축소
    func didHighlightCell(_ scale: CGFloat = 0.96) {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        UIView.animate(withDuration: 0.0) {
            self.contentView.transform = transform
        }
    }
    
    /// Cell 전체를 Scale 비율로 확대
    func didUnhighlightCell(_ scale: CGFloat = 1.0) {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        UIView.animate(withDuration: 0.0) {
            self.contentView.transform = transform
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension BaseTableViewCell {
    private func updateZzim(value: Bool, url: String, completion: @escaping (_ isSuccess: Bool, _ data: Zzim?) -> Void) {
        // 로그인 체크
        if applicationDelegate.islogin == false {
            if applicationDelegate.hmv.loginView == nil {
                applicationDelegate.hmv.loginView = AutoLoginViewController.init(nibName: "AutoLoginViewController", bundle: nil)
            } else {
                applicationDelegate.hmv.loginView.clearTextFields()
            }
            
            applicationDelegate.hmv.loginView.delegate = applicationDelegate.hmv
            applicationDelegate.hmv.loginView.loginViewType = 33
            applicationDelegate.hmv.loginView.loginViewMode = 0
            applicationDelegate.hmv.loginView.view.isHidden = false
            applicationDelegate.hmv.loginView.btn_naviBack.isHidden = false
            
            if let topVC = applicationDelegate.hmv.navigationController?.topViewController,
                !topVC.isKind(of: AutoLoginViewController.self) {
                applicationDelegate.hmv.navigationController?.pushViewControllerMoveIn(fromBottom: applicationDelegate.hmv.loginView)
            }
            return
        }
        
        guard let zzimURL = URL(string: url) else {
            self.showZzimAlert()
            return
        }
        
        var request = URLRequest(url: zzimURL)
        if let userAgent = UserDefaults.standard.object(forKey: "UserAgent") as? String {
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        request.httpMethod = "GET"  // Default가 get이긴 하다.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared
            .dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.showZzimAlert()
                    return
                }
                
                if let resultData = data,
                    let json = try? JSONSerialization.jsonObject(with: resultData, options: []),
                    let jsonDic = json as? [String: Any],
                    let zzim = Zzim(JSON: jsonDic),
                    zzim.success == 1 {
                    completion(true, zzim)
                } else {
                    self.showZzimAlert()
                    return
                }
        }
        task.resume()
    }
    
    private func showZzimAlert() {
        DispatchQueue.main.async {
            if let alert = Mocha_Alert(title: Const.Text.error_try_again.name, maintitle: "", delegate: self, buttonTitle: [Const.Text.confirm.name]) {
                self.applicationDelegate.window.addSubview(alert)
            }
        }
    }
}
