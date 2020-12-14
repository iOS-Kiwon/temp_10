//
//  devModeView.swift
//  GSSHOP
//
//  Created by admin on 27/12/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class devModeView: UIView {
    
    @IBOutlet weak var mainViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var NavigationVersion: UITextField!
    @IBOutlet weak var devModeSelecter: UISegmentedControl!
    @IBOutlet weak var openDateValue: UITextField!
    @IBOutlet weak var brdTimeValue: UITextField!
    @IBOutlet weak var wapcidValue: UITextField!
    
    var selectedTextField : UITextField!
    let datePicker = UIDatePicker()
    
    var keyboardShown:Bool = false // 키보드 상태 확인

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerForKeyboardNotifications()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        let currentMode = UserDefaults.standard.object(forKey: DEV_MODE) as? String ?? DEV_MODE_DEFAULT_VALUE
        switch currentMode {
        case "M":
            self.devModeSelecter.selectedSegmentIndex = 0
            break
        case "SM21","SM20","SM14":
            self.devModeSelecter.selectedSegmentIndex = 1
            break
        case "TM14":
            self.devModeSelecter.selectedSegmentIndex = 2
            break
        default:
            self.devModeSelecter.selectedSegmentIndex = 1
        }
        let currentOpenDate = UserDefaults.standard.object(forKey: "API_ADD_OPEN_DATE") as? String ?? ""
        let currentOpenDateValue = currentOpenDate.replacingOccurrences(of: "&openDate=", with: "")
        self.openDateValue.text = currentOpenDateValue
        self.datePickerCurrentValue(dateValue: currentOpenDateValue)
        
        
        let currentBrdTime = UserDefaults.standard.object(forKey: "API_ADD_BRD_TIME") as? String ?? ""
        let currentBrdTimeValue = currentBrdTime.replacingOccurrences(of: "&brdTime=", with: "")
        self.brdTimeValue.text = currentBrdTimeValue
        self.datePickerCurrentValue(dateValue: currentBrdTimeValue)
        
        let appver:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        self.titleLb.text = "DEV_MODE\n AppVersion=" + appver
        
        let naviVarsion = UserDefaults.standard.object(forKey: DEV_VERSION_CODE) as? String ?? APP_NAVI_VERSION
        self.NavigationVersion.text = naviVarsion
        self.addDoneCancelToolbar()
        
        let wapcid = UserDefaults.standard.object(forKey: "DEV_USER_INPUT_WA_PCID") as? String ?? ""
        self.wapcidValue.text = wapcid
        self.addDoneCancelToolbar2()
        
    }
    
    func addDoneCancelToolbar2() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "적용", style: .done, target: self, action:#selector(doneButtonPCIDTapped(_:))),
            UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped(_:))),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: #selector(removePCIDPressed(_:)))
        ]
        toolbar.sizeToFit()
        
        self.wapcidValue.inputAccessoryView = toolbar
    }
    
    @IBAction func doneButtonPCIDTapped(_ sender: Any) {
        self.endEditing(true)
       //저장 및 리로드?
       UserDefaults.standard.set(self.wapcidValue.text, forKey: "DEV_USER_INPUT_WA_PCID")
      
       UserDefaults.standard.synchronize()
       //홈 초기화 갱신
       applicationDelegate.hmv.firstProc()
         Mocha_ToastMessage.toast(withDuration: 3.0, andText: "이 기능은 앱 종료후 재실행이 필요합니다.", in: applicationDelegate.window)
    }
    
    @IBAction func removePCIDPressed(_ sender: Any) {
        self.endEditing(true)
        self.wapcidValue.text = ""
        UserDefaults.standard.set("", forKey: "DEV_USER_INPUT_WA_PCID")
        UserDefaults.standard.synchronize()
        applicationDelegate.hmv.firstProc()
        Mocha_ToastMessage.toast(withDuration: 3.0, andText: "초기 쿠키에 남아있던 wa_pcid값으로 변경됩니다. 앱 재실행이 필요합니다.", in: applicationDelegate.window)
        
    }
    
    
    func addDoneCancelToolbar() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "적용", style: .done, target: self, action:#selector(doneButtonTapped))
        ]
        toolbar.sizeToFit()
        
        self.NavigationVersion.inputAccessoryView = toolbar
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.endEditing(true)
        //저장 및 리로드?
        UserDefaults.standard.set(self.NavigationVersion.text, forKey: DEV_VERSION_CODE)
       
        UserDefaults.standard.synchronize()
        //홈 초기화 갱신
        applicationDelegate.hmv.firstProc()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.endEditing(false)
        //값 원복
    }
    
    
    @IBAction func brdTimeEditBegin(_ sender: Any) {
        self.selectedTextField = self.brdTimeValue
        self.CreateDatePicker()
        if let date = self.brdTimeValue.text, date.count > 0 {
            self.datePickerCurrentValue(dateValue: date )
        }
    }
    
    @IBAction func openDateEditBegin(_ sender: Any) {
        self.selectedTextField = self.openDateValue
        self.CreateDatePicker()
        if let date = self.openDateValue.text, date.count > 0 {
            self.datePickerCurrentValue(dateValue: date )
        }
    }
    
    func datePickerCurrentValue( dateValue:String ) {
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyyMMddHHmmss"
        let datetime = dateform.date(from: dateValue)
        if let unwrappedDate = datetime {
            self.datePicker.setDate(unwrappedDate, animated: true)
        }
    }
    
    func CreateDatePicker() {
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.date = Date()
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed(_:)))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: #selector(removePressed(_:)))
        
        toolbar.setItems([doneButton,cancelButton,space,removeButton], animated: false)
        
        self.selectedTextField.inputAccessoryView = toolbar
        selectedTextField.inputView = datePicker
        
    }
    
    @IBAction func donePressed(_ sender : Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let strDate = dateFormatter.string(from: self.datePicker.date)        
        self.selectedTextField.text = strDate+"00"
        self.endEditing(true)
        
        
        if self.selectedTextField.tag == 1 {
            UserDefaults.standard.set("&openDate="+(self.selectedTextField.text ?? ""), forKey: "API_ADD_OPEN_DATE")
        }
        else { //brdTime
            UserDefaults.standard.set("&brdTime="+(self.selectedTextField.text ?? ""), forKey: "API_ADD_BRD_TIME")
        }
        
        
        UserDefaults.standard.synchronize()
        applicationDelegate.hmv.firstProc()
    }
    
    @IBAction func cancelPressed(_ sender : Any) {
        self.endEditing(false)
    }
    
    @IBAction func removePressed(_ sender : Any) {
        self.endEditing(true)
        self.selectedTextField.text = ""
        if self.selectedTextField.tag == 1 {
            UserDefaults.standard.set("", forKey: "API_ADD_OPEN_DATE")
        }
        else {
            UserDefaults.standard.set("", forKey: "API_ADD_BRD_TIME")
        }
        UserDefaults.standard.synchronize()
        applicationDelegate.hmv.firstProc()
    }
    
    
    @IBAction func modeChanged(_ sender: Any) {
        switch self.devModeSelecter.selectedSegmentIndex {
        case 0: //M
            UserDefaults.standard.set("M", forKey: DEV_MODE)
            break
        case 1: // SM14
            UserDefaults.standard.set("SM21", forKey: DEV_MODE)
            break
        case 2: // TM14
            UserDefaults.standard.set("TM14", forKey: DEV_MODE)
            break
        default:
            break
        }
        UserDefaults.standard.synchronize()
        
        //홈 초기화 갱신
        applicationDelegate.hmv.firstProc()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.unregisterForKeyboardNotifications()
        self.removeFromSuperview()
    }

    
    
    func registerForKeyboardNotifications() {
        // 옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    func unregisterForKeyboardNotifications() {
        // 옵저버 등록 해제
        NotificationCenter.default.removeObserver(self, name:UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @IBAction func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardSize.height == 0.0 || keyboardShown == true {
                return
            }
            
            UIView.animate(withDuration: 1.0, animations: {
                self.mainViewCenterY.constant =  -keyboardSize.height/2
            }) { (true) in
                self.keyboardShown = true
            }
            
        }
        
    }
    
    @IBAction func keyboardWillHide(note: NSNotification) {
        if self.keyboardShown == true {
            UIView.animate(withDuration: 1.0, animations: {
                self.mainViewCenterY.constant = 0
            }) { (true) in
                self.keyboardShown = false
            }
        }
    }

    
    
}
