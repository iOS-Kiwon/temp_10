//
//  DevViewController.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/01/16.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class DevViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showToastBtnAction(_ sender: UIButton) {
        Toast.show("토스트는 석봉토스트!")
    }
    
    @IBAction func showToast3secBtnAction(_ sender: UIButton) {
        Toast.show(3.0, andText: "3초동안 떠있는 토스트!")
    }
    
    @IBAction func showPopupOneBtnAction(_ sender: UIButton) {
        self.showPopupOneButton(titleStr: "제목입니다. Default는 '알림",
                                messsage: "메시지 입니다.\n버튼 Title의 Default는 '확인'",
                                btnTitle: "버튼튼") {
                                    // 확인 누른 후 동작들..
                                    Toast.show("버튼 누른 후 동작함.")
        }
    }
    
    @IBAction func showPopupOneNoTitleBtnAction(_ sender: UIButton) {
        self.showPopupOneButton(titleStr: "",
                                messsage: "메시지 입니다.\n버튼 Title의 Default는 '확인'",
                                btnTitle: "버튼튼") {
                                    // 확인 누른 후 동작들..
                                    Toast.show("버튼 누른 후 동작함.")
        }
    }
    
    @IBAction func showPopupTwoBtnAction(_ sender: UIButton) {
        self.showPopupTowButton(messsage: "버튼이 두개인 팝업입니다.",
                                btnLeftTitle: "예", btnRightTitle: "아니오",
                                btnLeftAction: {
                                    // 왼쪽 버튼 누른 후 동작
                                    Toast.show("예..를 누름")
        }) {
            // 오른쪽 버튼 누른 후 동작
            Toast.show("아니오..를 누름")
        }
    }
    
    @IBAction func showPopupTwoNoTitleBtnAction(_ sender: UIButton) {
        self.showPopupTowButton(titleStr: "",
                                messsage: "버튼이 두개인 팝업입니다.",
                                btnLeftTitle: "예", btnRightTitle: "아니오",
                                btnLeftAction: {
                                    // 왼쪽 버튼 누른 후 동작
                                    Toast.show("예..를 누름")
        }) {
            // 오른쪽 버튼 누른 후 동작
            Toast.show("아니오..를 누름")
        }
    }
    
    @IBAction func showPopupImageOneBtnAction(_ sender: UIButton) {
        self.showPopupImageOneButton(titleStr: "타이틀",
                                     messsage: "이미지 버튼입니다.\n이미지 버튼입니다.\n이미지 버튼입니다.",
                                     image: UIImage(named: Const.Image.img_adult_375.name)!,
                                     btnTitle: "확인") {
                                        // 오른쪽 버튼 누른 후 동작
                                        Toast.show("버튼 누른 후 동작함.")
        }
    }
    
    @IBAction func showPopupImageTwoBtnAction(_ sender: UIButton) {
        self.showPopupImageTwoButton(
            titleStr: "",
            messsage: "이미지 버튼입니다.\n이미지 버튼입니다.\n이미지 버튼입니다.",
            image: UIImage(named: Const.Image.img_adult_375_188.name)!,
            btnLeftTitle: "닫아줘",
            btnRightTitle: "안녕?",
            btnLeftAction: {
                // 왼쪽 버튼 누른 후 동작
                Toast.show("닫아줘..를 누름")
        }) {
            // 오른쪽 버튼 누른 후 동작
            Toast.show("안녕?..를 누름")
        }
    }
}

extension UIViewController {
    func showPopupOneButton(titleStr: String = Const.Text.notice.localized,
                       messsage: String,
                       btnTitle: String = Const.Text.confirm.localized,
                       btnAction: VoidClosure? = nil) {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        let view = PopupOneButtonView(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getAppFullHeight()))
        
        view.popupTitle = titleStr
        view.popupMsg = messsage
        view.btnAction = btnAction
        view.btnTitle = btnTitle
        window.addSubview(view)
    }
    
    func showPopupTowButton(titleStr: String = Const.Text.notice.localized,
                       messsage: String,
                       btnLeftTitle: String = Const.Text.cancel.localized,
                       btnRightTitle: String = Const.Text.confirm.localized,
                       btnLeftAction: VoidClosure? = nil,
                       btnRightAction: VoidClosure? = nil) {
        guard let window = UIApplication.shared.keyWindow  else { return }
        let view = PopupTwoButtonView(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getAppFullHeight()))
        
        view.popupTitle = titleStr
        view.popupMsg = messsage
        view.btnLeftTitle = btnLeftTitle
        view.btnRightTitle = btnRightTitle
        view.btnLeftAction = btnLeftAction
        view.btnRightAction = btnRightAction
        window.addSubview(view)
    }
    
    func showPopupImageOneButton(titleStr: String = Const.Text.notice.localized,
                                 messsage: String,
                                 image: UIImage,
                                 btnTitle: String = Const.Text.confirm.localized,
                                 btnAction: VoidClosure? = nil) {
        guard let window = UIApplication.shared.keyWindow  else { return }
        let view = PopupImageView(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getAppFullHeight()))
        
        view.popupTitle = titleStr
        view.popupMsg = messsage
        view.imgView.image = image
        view.btnAction = btnAction
        view.btnTitle = btnTitle
        view.popupImage = image
        window.addSubview(view)
    }
    
    func showPopupImageTwoButton(titleStr: String = Const.Text.notice.localized,
                                 messsage: String,
                                 image: UIImage,
                                 btnLeftTitle: String = Const.Text.cancel.localized,
                                 btnRightTitle: String = Const.Text.confirm.localized,
                                 btnLeftAction: VoidClosure? = nil,
                                 btnRightAction: VoidClosure? = nil) {
        guard let window = UIApplication.shared.keyWindow  else { return }
        let view = PopupImageTwoButtonView(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getAppFullHeight()))
        
        view.popupTitle = titleStr
        view.popupMsg = messsage
        view.imgView.image = image
        view.btnLeftTitle = btnLeftTitle
        view.btnRightTitle = btnRightTitle
        view.btnLeftAction = btnLeftAction
        view.btnRightAction = btnRightAction
        view.popupImage = image
        window.addSubview(view)
    }
    
//    func showPopupRecommendPushAgree
}
