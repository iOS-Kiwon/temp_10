//
//  My_Opt_ViewController.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/06/29.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

fileprivate enum SettingAlert: Int {
    case adPushAgree = 100
    case logOut
    case autoLoginOn
    case autoLoginOff
    case naverLoginOn
    case naverLoginOff
    case kakaoLoginOn
    case kakaoLoginOff
    case appleIdLoginOn
    case appleIdLoginOff
    case bioLoginOn
    case bioLoginOff
    var value: Int { return self.rawValue }
}

class My_Opt_ViewController: UIViewController {
    /// 최상단 타이틀뷰 Top
    @IBOutlet weak var titleViewTopConstraint: NSLayoutConstraint!
    
    // 아이디 / 로그인해주세요 뷰
    @IBOutlet weak var userIdView: UIView!
    /// 아이디 / 로그인해주세요 타이틀 라벨
    @IBOutlet weak var loginTitleLbl: UILabel!
    /// 사용자 ID 라벨
    @IBOutlet weak var userIdLbl: UILabel!
    /// 사용자 ID 라벨 Trailing
    @IBOutlet weak var userIdLblTrailingConstraint: NSLayoutConstraint!
    /// 로그인 화살표 이미지뷰
    @IBOutlet weak var loginArrowImgView: UIImageView!
    /// 로그인 화살표 이미지뷰 Width
    @IBOutlet weak var loginArrowImgViewWidthConstraint: NSLayoutConstraint!
    /// 로그인뷰의 버튼
    @IBOutlet weak var userIdViewBtn: UIButton!
    /// 로그인 관리 뷰
    @IBOutlet weak var loginManageView: UIView!
    
    /// 자동 로그인 스위치
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    /// 네이버 로그인 스위치
    @IBOutlet weak var naverLoginSwitch: UISwitch!
    /// 카카오 로그인 스위치
    @IBOutlet weak var kakaoLoginSwitch: UISwitch!
    /// Apple ID 로그인 스위치
    @IBOutlet weak var appleIdLoginSwitch: UISwitch!
    /// 지문/페이스 로그인 스위치
    @IBOutlet weak var bioLoginSwitch: UISwitch!
    /// 광고성 알림 스위치
    @IBOutlet weak var adPushSwitch: UISwitch!
    
    /// 자동 로그인 스위치
    @IBOutlet weak var autoLoginBtn: UIButton!
    /// 네이버 로그인 스위치
    @IBOutlet weak var naverLoginBtn: UIButton!
    /// 카카오 로그인 스위치
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    /// Apple ID 로그인 스위치
    @IBOutlet weak var appleIdLoginBtn: UIButton!
    /// 지문/페이스 로그인 스위치
    @IBOutlet weak var bioLoginBtn: UIButton!
    
    
    /// 지문/페이스 로그인 라벨
    @IBOutlet weak var bioLoginLbl: UILabel!
    /// 앱버전 라벨
    @IBOutlet weak var appVerLbl: UILabel!
    
    /// Apple ID 로그인 뷰
    @IBOutlet weak var appleIdLoginView: UIView!
    /// 지문/페이스 로그인 뷰
    @IBOutlet weak var bigLoginView: UIView!
    /// 버전정보 뷰
    @IBOutlet weak var versionInfoView: UIView!
    /// 버전정보뷰의 버튼
    @IBOutlet weak var versionInfoViewBtn: UIButton!
    /// 버전 업데이트 뷰
    @IBOutlet weak var updateView: UIView!
    /// 로그아웃 뷰
    @IBOutlet weak var logoutView: UIView!
    /// 로그아웃뷰의 버튼
    @IBOutlet weak var logoutviewBtn: UIButton!
    
    
    /// 회사소개 뷰
    @IBOutlet weak var aboutView: UIView!
    /// 회사소개뷰의 버튼
    @IBOutlet weak var aboutViewBtn: UIButton!
    
    /// 지문/페이스 로그인뷰 Top
    @IBOutlet weak var bioLoginViewTopConstraint: NSLayoutConstraint!
    /// 로그인 설명뷰 Top
    @IBOutlet weak var loginDescViewTopConstraint: NSLayoutConstraint!
    
    /// 광고성 알림뷰 Top - 상단 네비바 사이
    @IBOutlet var betweenAdPushViewToNaviBarTopConstraint: NSLayoutConstraint!
    /// 광고성 알림뷰 Top - 로그인 관리뷰 사이
    @IBOutlet var betweenAdPushViewToLoginManageViewTopConstraint: NSLayoutConstraint!
    /// 회사소개뷰 Top
    @IBOutlet weak var aboutViewTopConstraint: NSLayoutConstraint!
    /// 회사소개뷰 Bottom
    @IBOutlet weak var scrollViewBotConstraint: NSLayoutConstraint!
    
    
    /// 설정페이지를 불러온 부모객체
    private var aTarget: AnyObject?
    /// 로그인 데이터
    private var loginData: LoginData!
    /// SNS 로그인 상태확인 통인 session
    private var urlSessionDataTask: URLSessionDataTask?
    /// Naver Connection
    private var naverConnection: NaverThirdPartyLoginConnection!
    /// Naver 로그인 시도 여부
    private var isRetryNaverLogin: Bool = false
    
    /// LoginViewCtrlPopDelegate의 definecurrentUrlString함수에 리턴으로 줄 String - 현재 미사용중..
    private var curRequestString: String = ""
    
    @objc convenience init(target: AnyObject) {
        self.init()
        self.aTarget = target
        
        // naver login Connection 초기화
        setInitNaverSDK()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Wise Log 전송
        sendWiseLog()
        
        // SafeArea 확인
        self.titleViewTopConstraint.constant = getSafeAreaInsets().top == 0 ? getStatusBarHeight() : getSafeAreaInsets().top
        
        // 텝바 추가
        //addTabBarUI()
        //applicationDelegate.hmv.tabBarView.isHidden = false
        applicationDelegate.hmv.showTabbarView()
        
        // 아이폰X 이상인 경우 "페이스 로그인" 적용
        if isiPhoneXseries() {
            self.bioLoginLbl.text = "페이스 로그인"
            self.bioLoginSwitch.accessibilityLabel = "페이스 로그인"
        } else {
            self.bioLoginLbl.text = "지문 로그인"
            self.bioLoginSwitch.accessibilityLabel = "지문 로그인"
        }
        
        /// 하단 TabBar 높이 만큼 간격을 벌려줘야 함.
        self.scrollViewBotConstraint.constant = applicationDelegate.hmv.tabBarView.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 사용자 로그인 여부에 따른 UI변경
        if isUserLogin() {
            // 로그인함
            setLoginUI()
        } else {
            // 로그인 안함
            setNoneLoginUI()
        }
        
        // 광고성 알림 UI 설정
        setAdPushUI()
        
        // 버전정보 UI 설정
        setVersionUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applicationDelegate.gtMscreenOpenSendLog("iOS - Setting")
        // 로딩 정지
        DispatchQueue.main.async {
            self.applicationDelegate.gactivityIndicator.stopAnimating()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
// MARK:- Private functions
extension My_Opt_ViewController {
    
    /// 로그인 UI 설정
    private func setLoginUI() {
        
        // 로그인 버튼 Hidden
        self.userIdViewBtn.isHidden = true
        
        // 상단 아이디 영역
        self.loginTitleLbl.text = "아이디"
        
        self.userIdLbl.text = self.loginData.loginid.getIDMask()
        self.userIdLblTrailingConstraint.constant = 20.0
        self.loginArrowImgView.image = nil
        self.loginArrowImgViewWidthConstraint.constant = 0.0
        
        // 로그인 관리 영역
        self.loginManageView.isHidden = false
        
        // 자동 로그인 여부
        self.autoLoginSwitch.isOn = NSNumber(value: self.loginData.autologin).boolValue
        
        // 애플로그인 노출 판단
        if #available(iOS 13.0, *) {
            self.appleIdLoginView.isHidden = false
            self.bioLoginViewTopConstraint.constant = 56.0

            let center = NotificationCenter.default
            center.addObserver(self, selector: #selector(self.handleSignInWithAppleStateRevoked), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
        } else {
            self.appleIdLoginView.isHidden = true
            self.bioLoginViewTopConstraint.constant = 0.0
        }
        
        // 지문/페이스 로그인 노출 판단
        if applicationDelegate.isCanUseBioAuth() {
            self.bigLoginView.isHidden = false
            self.loginDescViewTopConstraint.constant = 56.0

            if Common_Util.loadLocalData(FINGERPRINT_USE_KEY) != nil {
                self.bioLoginSwitch.isOn = true
            } else {
                self.bioLoginSwitch.isOn = false
            }
        }
        else {
            self.bigLoginView.isHidden = true
            self.loginDescViewTopConstraint.constant = 0.0
        }
        
        // SNS 로그인 여부 조회 및 설정
        getSnsAccountCheck()
        
        // 상단 아이디 영역과 광고성알림뷰 영역 사이
        self.betweenAdPushViewToNaviBarTopConstraint.isActive = false
        self.betweenAdPushViewToLoginManageViewTopConstraint.isActive = true
        
        // 로그아웃뷰 보이기
        self.logoutView.isHidden = false
        
        // 회사소개 Top 넓히기
        self.aboutViewTopConstraint.constant = 56.0
        
    }
    
    /// 비로그인 UI 설정
    private func setNoneLoginUI() {
        
        // 로그인 버튼 Hidden
        self.userIdViewBtn.isHidden = false
        
        // 상단 아이디 영역
        self.loginTitleLbl.text = "로그인 해주세요"
        self.userIdLbl.text = "로그인"
        self.userIdLblTrailingConstraint.constant = 41.0
        self.loginArrowImgView.image = UIImage(named: Const.Image.ic_arrow_right_24.name)
        self.loginArrowImgViewWidthConstraint.constant = 24.0
        
        // 로그인 관리 영역
        self.loginManageView.isHidden = true
        
        // 상단 아이디 영역과 광고성알림뷰 영역 사이
        self.betweenAdPushViewToNaviBarTopConstraint.constant = 0.0
        self.betweenAdPushViewToNaviBarTopConstraint.isActive = true
        self.betweenAdPushViewToLoginManageViewTopConstraint?.isActive = false
        
        // 로그아웃뷰 숨기기
        self.logoutView.isHidden = true
        
        // 회사소개 Top 당기기
        self.aboutViewTopConstraint.constant = 0.0
    }
    
    /// SNS 로그인 여부 조회 및 설정
    private func getSnsAccountCheck() {
        if let dm = DataManager.shared(),
            dm.getCustomerNoInSwift().count > 0,
            applicationDelegate.islogin == true {
            
            
            if self.urlSessionDataTask != nil {
                self.urlSessionDataTask?.cancel()
            }
            
            self.urlSessionDataTask = applicationDelegate.gshop_http_core.gsSnsAccountCheck(dm.getCustomerNoInSwift(), onCompletion: { (result) in
                
                guard let dic = result as? Dictionary<String, Any> else {
                    self.naverLoginSwitch.isOn = false
                    self.kakaoLoginSwitch.isOn = false
                    self.appleIdLoginSwitch.isOn = false
                    return
                }
                
                if let isNaver = dic["naver"] as? Bool {
                    self.naverLoginSwitch.isOn = isNaver
                }
                
                if let isKakao = dic["kakao"] as? Bool {
                    self.kakaoLoginSwitch.isOn = isKakao
                }
                
                if let isApple = dic["apple"] as? Bool {
                    
                    if isApple {
                        self.checkVailedAppleLogin()
                    } else {
                        self.appleIdLoginSwitch.isOn = false
                        UserDefaults.standard.set("", forKey: APPLEIDCREDENTIALKEY)
                    }
                }
                
                
            }, onError: { (error) in
                self.naverLoginSwitch.isOn = false
                self.kakaoLoginSwitch.isOn = false
                self.appleIdLoginSwitch.isOn = false
            })
        }
    }
    
    // SNS 로그인 On값 서버로 전달
    private func setSnsAccountOn(type: SnsAccountType, accessToken: String, refreshToken: String) {
        
        guard let dm = DataManager.shared() else { return }
        DispatchQueue.main.async {
            self.applicationDelegate.gactivityIndicator.startAnimating()
        }
        
        if applicationDelegate.islogin && dm.getCustomerNoInSwift().count > 0 {
            if self.urlSessionDataTask != nil {
                self.urlSessionDataTask?.cancel()
            }
            
            self.urlSessionDataTask = applicationDelegate.gshop_http_core.gsSnsAccountOpenCustNo(dm.getCustomerNoInSwift(), snsType: type.name, snsAccessToken: accessToken, snsRefreshToken: refreshToken, onCompletion: { (result) in
                
                DispatchQueue.main.async {
                    self.applicationDelegate.gactivityIndicator.stopAnimating()
                    
                    guard let dic = result as? Dictionary<String, Any> else { return }
                    
                    if let isSuccess = dic["succs"] as? Bool, isSuccess == true {

                        if type == .naver {
                            self.naverLoginSwitch.isOn = true
                        } else if type == .kakao {
                            self.kakaoLoginSwitch.isOn = true
                        } else if type == .apple {
                            self.appleIdLoginSwitch.isOn = true
                        }
                    } else {
                        if let view = Bundle.main.loadNibNamed(ViewMyOptionSNSPopup.className, owner: self, options: nil)?.first as? ViewMyOptionSNSPopup {
                            
                            view.setViewInfoNDrawData(result)
                            self.applicationDelegate.window.addSubview(view)
                        }
                    }
                }
                
            }, onError: { (error) in
                DispatchQueue.main.async {
                    self.applicationDelegate.gactivityIndicator.stopAnimating()
                }
            })
        }
        
        
    }
    
    // SNS 로그인 Off값 서버로 전달
    private func setSnsAccountOff(type: SnsAccountType) {
        
        guard let dm = DataManager.shared() else { return }
        DispatchQueue.main.async {
            self.applicationDelegate.gactivityIndicator.startAnimating()
        }
        if applicationDelegate.islogin && dm.getCustomerNoInSwift().count > 0 {
            if self.urlSessionDataTask != nil {
                self.urlSessionDataTask?.cancel()
            }
            
            self.urlSessionDataTask = applicationDelegate.gshop_http_core.gsSnsAccountClose(dm.getCustomerNoInSwift(), snsType: type.name, onCompletion: { (result) in
                DispatchQueue.main.async {
                    self.applicationDelegate.gactivityIndicator.stopAnimating()
                    guard let dic = result as? Dictionary<String, Any> else { return }
                    
                    if let isSuccess = dic["succs"] as? Bool, isSuccess == true {
                        DataManager.shared()?.m_loginData.snsTyp = ""
                        DataManager.saveLoginData()
                        
                        self.loginData = DataManager.shared()?.m_loginData
                        
                        if type == .naver {
                            self.naverLoginSwitch.isOn = false
                        } else if type == .kakao {
                            self.kakaoLoginSwitch.isOn = false
                        } else if type == .apple {
                            self.appleIdLoginSwitch.isOn = false
                            UserDefaults.standard.set("", forKey: APPLEIDCREDENTIALKEY)
                        }
                    }
                }
            }, onError: { (error) in
                DispatchQueue.main.async {
                    self.applicationDelegate.gactivityIndicator.stopAnimating()
                }
            })
        }
    }
    
    /// 광고성 알림 UI 설정
    private func setAdPushUI() {
        
        guard  let isPush = UserDefaults.standard.object(forKey: GS_PUSH_RECEIVE) as? String else  {
            let err = NSError(domain: "app_setting_adPush", code: 30000, userInfo: nil)
            applicationDelegate.sendExceptionLog(err, msg: "광고성 알림 UI 설정(setAdPushUI) : UserDefaults.standard.object(forKey: GS_PUSH_RECEIVE = nil ")
            self.appVerLbl.text = ""
            self.updateView.isHidden = true
            self.versionInfoViewBtn.isHidden = true
            return
        }
        
        if isPush == "Y" {
            self.adPushSwitch.isOn = true
        } else {
            self.adPushSwitch.isOn = false
        }
    }
    
    /// 버전정보 UI 설정
    private func setVersionUI() {
        
        guard let appVersion = getAppBuildVersion() else {
            let err = NSError(domain: "app_setting_version", code: 30001, userInfo: nil)
            applicationDelegate.sendExceptionLog(err, msg: "버전정보 UI 설정(setVersionUI) : Bundle.main.object(forInfoDictionaryKey: CFBundleVersion) = nil ")
            self.appVerLbl.text = ""
            self.updateView.isHidden = true
            self.versionInfoViewBtn.isHidden = true
            return
        }
        
        if applicationDelegate.serverAppvercode.isEmpty {
            let err = NSError(domain: "app_setting_version", code: 30002, userInfo: nil)
            applicationDelegate.sendExceptionLog(err, msg: "버전정보 UI 설정(setVersionUI) : applicationDelegate.serverAppvercode = nil ")
            self.appVerLbl.text = ""
            self.updateView.isHidden = true
            self.versionInfoViewBtn.isHidden = true
            return
        }
        
        let appBuildVersion = (appVersion.replacingOccurrences(of: ".", with: "") as NSString).integerValue
        let serverBuildVersion = (applicationDelegate.serverAppvercode.trimmingCharacters(in: .whitespacesAndNewlines) as NSString).integerValue
        
        
        if appBuildVersion < serverBuildVersion {
            // 업데이트 O
            self.appVerLbl.text = "V\(getAppVersion())"
            self.appVerLbl.font = UIFont.systemFont(ofSize: 14.0)
            self.appVerLbl.textColor = UIColor.getColor("111111", alpha: 0.40)
            self.appVerLbl.textAlignment = .left
            self.updateView.isHidden = false
            self.versionInfoViewBtn.isHidden = false
        } else {
            // 업데이트 X
            self.appVerLbl.text = "V\(getAppVersion()) (최신)"
            self.appVerLbl.font = UIFont.systemFont(ofSize: 16.0)
            self.appVerLbl.textColor = UIColor.getColor("111111", alpha: 0.64)
            self.appVerLbl.textAlignment = .right
            self.updateView.isHidden = true
            self.versionInfoViewBtn.isHidden = true
        }
    }
    
    /// 사용자 로그인 데이터 조회
    private func isUserLogin() -> Bool {
        if let dm = DataManager.shared() {
            dm.getLoginData()
            self.loginData = dm.m_loginData
            
            if applicationDelegate.islogin && self.loginData.loginid.count > 0 {
                return true
            }
        }
        return false
    }
    
    private func checkVailedAppleLogin() {
        if #available(iOS 13.0, *) {

            guard let appleUserId = UserDefaults.standard.object(forKey: APPLEIDCREDENTIALKEY) as? String else {
                self.appleIdLoginSwitch.isOn = false
                return
            }
            
            let appleIdProvider = ASAuthorizationAppleIDProvider()
            appleIdProvider.getCredentialState(forUserID: appleUserId) { (state, error) in
                DispatchQueue.main.async {
                    if state == .authorized {
                        self.appleIdLoginSwitch.isOn = true
                    } else {
                        UserDefaults.standard.set("", forKey: APPLEIDCREDENTIALKEY)
                        self.appleIdLoginSwitch.isOn = false
                        
                        self.setSnsAccountOff(type: .apple)
                    }
                }
            }
        }
    }
    
    /// 하단 텝바 추가
//    private func addTabBarUI() {
//        if let tabBarView = Bundle.main.loadNibNamed(LastPrdCustomTabBarView.className, owner: self, options: nil)?.first as? LastPrdCustomTabBarView {
//            tabBarView.frame = CGRect(x: 0, y: getAppFullHeight() - APPTABBARHEIGHT(),
//                                      width: getAppFullWidth(), height: APPTABBARHEIGHT())
//            tabBarView.autoresizingMask = UIView.AutoresizingMask.init()
//            self.view.addSubview(tabBarView)
//
//            /// 하단 TabBar 높이 만큼 간격을 벌려줘야 함.
//            self.scrollViewBotConstraint.constant = tabBarView.frame.height // 8.0은 살짝 여백
//        }
//    }
    
    /// Wise로그 전송 함수
    private func sendWiseLog() {
        applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr: "?mseq=416298"))
    }
    
    /// 네이버 SDK 초기화
    private func setInitNaverSDK() {
        self.naverConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        self.naverConnection.delegate = self
    }
    
    private func setBackgroundColor(sender: UIButton, status: UIControl.State) {
        if status == .highlighted {
            
            let color = UIColor.getColor("000000", alpha: 0.04, defaultColor: .white)
            
            if sender.isEqual(self.userIdViewBtn) {
                self.userIdView.backgroundColor = color
            } else if sender.isEqual(self.versionInfoViewBtn) {
                self.versionInfoView.backgroundColor = color
            } else if sender.isEqual(self.aboutViewBtn) {
                self.aboutView.backgroundColor = color
            } else if sender.isEqual(self.logoutviewBtn) {
                self.logoutView.backgroundColor = color
            }
            
            
        } else if status == .normal {
            
            let color = UIColor.white
            
            if sender.isEqual(self.userIdViewBtn) {
                self.userIdView.backgroundColor = color
            } else if sender.isEqual(self.versionInfoViewBtn) {
                self.versionInfoView.backgroundColor = color
            } else if sender.isEqual(self.aboutViewBtn) {
                self.aboutView.backgroundColor = color
            } else if sender.isEqual(self.logoutviewBtn) {
                self.logoutView.backgroundColor = color
            }
        }
    }
    
    /// 로그아웃 프로세스 함수
    private func logout() {
        
        //로그아웃 한 다음 url을 가지고 다시 webview로 넘긴다.
        let loginVC = AutoLoginViewController(nibName: AutoLoginViewController.className, bundle: nil)
        loginVC.delegate = self
        loginVC.loginViewType = 33
        loginVC.modalTransitionStyle = .crossDissolve
        loginVC.isLogining = true
        loginVC.goLogin()
        loginVC.view.isHidden = true

    }
    
    /// Naver 로그인 연동 시도 함수
    private func requestNaverLogin() {
        // NaverThirdPartyLoginConnection의 인스턴스에 인증을 요청합니다.
        self.naverConnection.requestThirdPartyLogin()
        self.isRetryNaverLogin = true
    }
    
    /// 카카오 로그인 연동 시도 함수
    private func requestKakaoLogin() {
        if let kakaoSession = KOSession.shared() {
            if kakaoSession.isOpen() {
                kakaoSession.close()
            }
            
            kakaoSession.open { (error) in
                if let e = error {
                    print("Kakao 로그인 실패 : \(e.localizedDescription)")
                    return
                }
                
                if kakaoSession.isOpen(),
                    let token = kakaoSession.token {
                    self.setSnsAccountOn(type: .kakao, accessToken: token.accessToken, refreshToken: token.refreshToken)
                }
            }
        }
    }
    
    /// 지문/페이스 로그인 연동 시도 함수
    private func requestBioLogin() {
        
        if applicationDelegate.isCanUseBioAuth(),
            let dm = DataManager.shared() {

            Common_Util.setLocalData(dm.m_loginData, forKey: FINGERPRINT_USE_KEY)
            self.bioLoginSwitch.isOn = true
        } else {
            // 지문/페이스 로그인 불가능 alert
            if let alert = Mocha_Alert(title: Const.Text.setting_dont_use_bio.name, maintitle: nil, delegate: self, buttonTitle: [Const.Text.confirm.name]) {
                applicationDelegate.window.addSubview(alert)
            }
        }
    }
    
    /// Apple ID 로그인 연동 시도 함수
    private func requestAppleIdLogin() {
        if #available(iOS 13.0, *) {
            guard let appleUserId = UserDefaults.standard.object(forKey: APPLEIDCREDENTIALKEY) as? String else {
                return
            }
            
            if appleUserId.isEmpty {
                // Apple ID가 없는 경우
                
                // A mechanism for generating requests to authenticate users based on their Apple ID.
                let appleIDProvider = ASAuthorizationAppleIDProvider()

                // Creates a new Apple ID authorization request.
                let request = appleIDProvider.createRequest()

                // The contact information to be requested from the user during authentication.
                request.requestedScopes = [.fullName, .email]

                // A controller that manages authorization requests created by a provider.
                let controller = ASAuthorizationController(authorizationRequests: [request])

                // A delegate that the authorization controller informs about the success or failure of an authorization attempt.
                controller.delegate = self

                // A delegate that provides a display context in which the system can present an authorization interface to the user.
                controller.presentationContextProvider = self

                // starts the authorization flows named during controller initialization.
                controller.performRequests()
            } else {
                // 등록된 Apple ID가 있는 경우
                perfomExistingAccountSetupFlows()
            }
        }
    }
}

//MARK:- Button Action Funcions
extension My_Opt_ViewController {
    @IBAction func backBtnAction(_ sender: UIButton) {
        if let navi = self.navigationController {
            navi.popViewControllerMoveInFromTop()
            
            if let target  = self.aTarget as? Home_Main_ViewController {
                target.firstProc()
            } else if let target = self.aTarget as? MyShopViewController {
                target.firstProc()
            }
        }
    }
    
    /// 로그인 버튼 액션
    @IBAction func loginBtnAction(_ sender: UIButton) {
        print("kiwon : TouchUpInside")
        setBackgroundColor(sender: sender, status: .normal)
        
        if applicationDelegate.islogin == false {
        
            applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr: "?mseq=416287"))
            
            let loginVC = AutoLoginViewController(nibName: AutoLoginViewController.className, bundle: nil)
            loginVC.delegate = self
            loginVC.loginViewType = 4
            
            self.navigationController?.pushViewControllerMoveIn(fromBottom: loginVC)
        }
    }
    
    /// 앱 업데이트 버튼 액션
    @IBAction func updateBtnAction(_ sender: UIButton) {
        setBackgroundColor(sender: sender, status: .normal)
        //업데이트 URL
        applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr: "?mseq=416297"))
        if let url = URL(string: UPDATENEWVERSIONURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    /// 로그아웃 버튼 액션
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        setBackgroundColor(sender: sender, status: .normal)
    
        if applicationDelegate.islogin == true {
            //20160811 parksegun 로그인 버튼 밖으로..
            applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr: "?mseq=416288"))
            
            if let alert = Mocha_Alert(title: Const.Text.login_confirm_logout.name, maintitle: nil, delegate: self, buttonTitle: [Const.Text.cancel.name, Const.Text.confirm.name]) {
                alert.tag = SettingAlert.logOut.value
                applicationDelegate.window.addSubview(alert)
            }
        }
    }
    
    /// 회사소개 버튼 액션
    @IBAction func aboutBtnAction(_ sender: UIButton) {
        setBackgroundColor(sender: sender, status: .normal)
        if let resVC = ResultWebViewController(urlString: gsCompanyIntroURL()) {
            resVC.view.tag = 505
            //url을 웹뷰로 보여줌
            self.navigationController?.pushViewControllerMoveIn(fromBottom: resVC)
        }
    }
    
    /// 스위치 액션 - 자동 / 네이버 / 카카오 / AppleID / 지문(페이스) 로그인
    @IBAction func switchBtnAction(_ sender: UIButton) {
        
        var msg = ""
        var tag = 0
        
        if sender.isEqual(self.autoLoginBtn) {
        
            if self.autoLoginSwitch.isOn {
                msg = Const.Text.setting_autologin_off.name
                tag = SettingAlert.autoLoginOff.value
            } else {
                msg = Const.Text.setting_autologin_on.name
                tag = SettingAlert.autoLoginOn.value
            }
        } else if sender.isEqual(self.naverLoginBtn) {
            if self.naverLoginSwitch.isOn {
                msg = Const.Text.setting_naver_off.name
                tag = SettingAlert.naverLoginOff.value
            } else {
                msg = Const.Text.setting_naver_on.name
                tag = SettingAlert.naverLoginOn.value
            }
        } else if sender.isEqual(self.kakaoLoginBtn) {
            if self.kakaoLoginSwitch.isOn {
                msg = Const.Text.setting_kakao_off.name
                tag = SettingAlert.kakaoLoginOff.value
            } else {
                msg = Const.Text.setting_kakao_on.name
                tag = SettingAlert.kakaoLoginOn.value
            }
        } else if sender.isEqual(self.appleIdLoginBtn) {
            if self.appleIdLoginSwitch.isOn {
                msg = Const.Text.setting_apple_off.name
                tag = SettingAlert.appleIdLoginOff.value
            } else {
                msg = Const.Text.setting_apple_on.name
                tag = SettingAlert.appleIdLoginOn.value
            }
        } else if sender.isEqual(self.bioLoginBtn) {
            if self.bioLoginSwitch.isOn {
                msg = isiPhoneXseries() ? Const.Text.setting_facelogin_off.name : Const.Text.setting_fingerlogin_off.name
                tag = SettingAlert.bioLoginOff.value
            } else {
                msg = Const.Text.setting_biologin_on.name
                tag = SettingAlert.bioLoginOn.value
            }
        } else {
            return
        }
        
        if let alert = Mocha_Alert(title: msg, maintitle: nil, delegate: self, buttonTitle: [Const.Text.cancel.name, Const.Text.agree.name])
        {
            alert.tag = tag
            applicationDelegate.window.addSubview(alert)
        }
    }
    
    
    /// 광고성 알림 받기 스위치 액션
    @IBAction func adPushSwAction(_ sender: UISwitch) {
        
        applicationDelegate.firstAppsetting(withOptinFlag: sender.isOn, withResultAlert: false)
        
        //20160310 parksegun 푸시 설정에 따라 안내 팝업 노출 변경
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "YYYY.MM.dd"
        let dateStr = df.string(from: Date())
        
        let msg = sender.isOn == true ?
            Const.Text.ad_push_agree.name : Const.Text.ad_push_disagree.name
        
        let alertTitle = msg + " (\(dateStr))"
        
        if let alert = Mocha_Alert(title: alertTitle, maintitle: nil, delegate: self, buttonTitle: [Const.Text.confirm.name])
        {
            alert.tag = SettingAlert.adPushAgree.value
            applicationDelegate.window.addSubview(alert)
        }
    }
    
    
    
    @IBAction func commonTouchDownBtnAction(_ sender: UIButton) {
        setBackgroundColor(sender: sender, status: .highlighted)
    }
    
    @IBAction func commonTouchUpOutsideBtnAction(_ sender: UIButton) {
        setBackgroundColor(sender: sender, status: .normal)
    }
    
    @IBAction func commonTouchDragOutsideBtnAction(_ sender: UIButton) {
        setBackgroundColor(sender: sender, status: .normal)
    }
    
}

// MARK:- NaverThirdPartyLoginConnectionDelegate
extension My_Opt_ViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        setSnsAccountOn(type: .naver, accessToken: self.naverConnection.accessToken, refreshToken: self.naverConnection.refreshToken)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        setSnsAccountOn(type: .naver, accessToken: self.naverConnection.accessToken, refreshToken: self.naverConnection.refreshToken)
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        // 로그아웃 완료
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        // 네이버 로그인 실패시 1회만 재시도
        if self.isRetryNaverLogin {
            self.isRetryNaverLogin = false
            requestNaverLogin()
        }
    }
}

// MARK:- Apple ID
extension My_Opt_ViewController {
    @objc func handleSignInWithAppleStateRevoked() {
        
        UserDefaults.standard.set("", forKey: APPLEIDCREDENTIALKEY)
        
        DispatchQueue.main.async {
            if self.applicationDelegate.islogin == true,
                let dm = DataManager.shared(), dm.getCustomerNoInSwift().count > 0 {
                self.setSnsAccountOff(type: .apple)
            }
        }
    }
    
    func perfomExistingAccountSetupFlows() {
        if #available(iOS 13.0, *) {
            guard let appleUserId = UserDefaults.standard.object(forKey: APPLEIDCREDENTIALKEY) as? String else {
                return
            }
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleUserId) { (state, error) in
                if state == .revoked {
                    UserDefaults.standard.set("", forKey: APPLEIDCREDENTIALKEY)
                    
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    let request = appleIDProvider.createRequest()
                    request.requestedScopes = [.fullName, .email]
                    let controller = ASAuthorizationController(authorizationRequests: [request])
                    controller.delegate = self
                    controller.presentationContextProvider = self
                    controller.performRequests()
                } else if state == .authorized {
                    // A mechanism for generating requests to authenticate users based on their Apple ID.
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    // An OpenID authorization request that relies on the user’s Apple ID.
                    let request = appleIDProvider.createRequest()
                    
                    let controller = ASAuthorizationController(authorizationRequests: [request])
                    controller.delegate = self
                    controller.presentationContextProvider = self
                    controller.performRequests()
                    
                } else if state == .notFound {
                    UserDefaults.standard.set("", forKey: APPLEIDCREDENTIALKEY)
                }
            }
        }
    }
}

// MARK:- ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding
extension My_Opt_ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // Apple ID 로그인 성공
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            UserDefaults.standard.set(user, forKey: APPLEIDCREDENTIALKEY)
            
            setSnsAccountOn(type: .apple, accessToken: user, refreshToken: "")
        } else if let credential = authorization.credential as? ASPasswordCredential {
            let user = credential.user
            UserDefaults.standard.set(user, forKey: APPLEIDCREDENTIALKEY)
            
            setSnsAccountOn(type: .apple, accessToken: user, refreshToken: "")
        }
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK:- Mocha_AlertDelegate
extension My_Opt_ViewController: Mocha_AlertDelegate {
    func customAlert(_ alert: UIView!, clickedButtonAt index: Int) {
        
        let tag = alert.tag
        
        // 광고성 알림 팝업
        if tag == SettingAlert.adPushAgree.value {
            if self.adPushSwitch.isOn == true {
                // 수신
                applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr: "?mseq=416295"))
                if Mocha_Util.ispushalertoptionenable() == false {
                    applicationDelegate.showPushCheckAlert("SYSSETPUSH")
                }
            } else {
                // 미수신
                applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr: "?mseq=416361"))
                if Mocha_Util.ispushalertoptionenable() == true {
                    applicationDelegate.showPushCheckAlert("SYSSETPUSH")
                }
            }
            
            return
        }
        
        
        // 로그아웃 확인 버튼
        if tag == SettingAlert.logOut.value, index == 1 {
            //DATAHUB CALL
            //D_1033 로그아웃
            if let gsHub = GSDataHubTracker.sharedInstance() {
                gsHub.neoCallGTM(withReqURL: "D_1033", str2: "", str3: "")
            }
            
            logout()
        }
        
        
        if tag == SettingAlert.autoLoginOn.value, index == 1 {
            // 자동 로그인 설정(On)
            if applicationDelegate.islogin && self.loginData.loginid.count > 0,
                let dm = DataManager.shared() {
                dm.m_loginData.autologin = 1
                DataManager.saveLoginData()
                
                self.loginData = dm.m_loginData
                self.autoLoginSwitch.isOn = true
                
                applicationDelegate.wiseLogRestRequest("?mseq=416291")
            }
        } else if tag == SettingAlert.autoLoginOff.value, index == 1 {
            // 자동 로그인 해제(Off)
            if applicationDelegate.islogin && self.loginData.loginid.count > 0,
                let dm = DataManager.shared() {
                dm.m_loginData.autologin = 0
                DataManager.saveLoginData()
                
                self.loginData = dm.m_loginData
                self.autoLoginSwitch.isOn = false
                
                applicationDelegate.wiseLogRestRequest("?mseq=416357")
            }
        }
        
        else if tag == SettingAlert.naverLoginOn.value && index == 1{
            // 네이버 로그인 설정(On)
            requestNaverLogin()
            applicationDelegate.wiseLogRestRequest("?mseq=416292")
        } else if tag == SettingAlert.naverLoginOff.value && index == 1 {
            // 네이버 로그인 해제(Off)
            setSnsAccountOff(type: .naver)
            applicationDelegate.wiseLogRestRequest("?mseq=416358")
        }
        
        else if tag == SettingAlert.kakaoLoginOn.value && index == 1 {
            // 카카오 로그인 설정(On)
            requestKakaoLogin()
            applicationDelegate.wiseLogRestRequest("?mseq=416293")
        } else if tag == SettingAlert.kakaoLoginOff.value && index == 1 {
            // 카카오 로그인 해제(Off)
            setSnsAccountOff(type: .kakao)
            applicationDelegate.wiseLogRestRequest("?mseq=416359")
        }
        
        else if tag == SettingAlert.bioLoginOn.value && index == 1 {
            // 지문/페이스 로그인 설정(On)
            requestBioLogin()
            applicationDelegate.wiseLogRestRequest("?mseq=416294")
        } else if tag == SettingAlert.bioLoginOff.value && index == 1 {
            // 지문/페이스 로그인 설정(Off)
            Common_Util.setLocalData(nil, forKey: FINGERPRINT_USE_KEY)
            self.bioLoginSwitch.isOn = false
            applicationDelegate.wiseLogRestRequest("?mseq=416360")
        }
        
        else if tag == SettingAlert.appleIdLoginOn.value && index == 1 {
            // Apple ID 로그인 설정(On)
            requestAppleIdLogin()
            applicationDelegate.wiseLogRestRequest("?mseq=419318")
        } else if tag == SettingAlert.appleIdLoginOff.value && index == 1 {
            // Apple ID 로그인 해제(Off)
            applicationDelegate.wiseLogRestRequest("?mseq=419319")
            setSnsAccountOff(type: .apple)
        }
    }
}

// MARK:- LoginViewCtrlPopDelegate
extension My_Opt_ViewController: LoginViewCtrlPopDelegate {
    func hideLoginViewController(_ loginviewtype: Int) {
        if loginviewtype == 33 {
            
            applicationDelegate.mainNVC.popToRootViewController(animated: false)
            applicationDelegate.hmv.firstProc()
        }
    }
    
    func definecurrentUrlString() -> String! {
        return self.curRequestString
    }
}
