//
//  WebPrdVideoFullViewController.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/19.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit
import AVFoundation

public enum VideoOrientationType {
    case portrait
    case landscape
}

class WebPrdVideoFullViewController: UIViewController {
    
    /// 실제 동영상이 플레이되는 영역뷰
    @IBOutlet weak var videoContainerView: UIView!
    /// Control 부모뷰
    @IBOutlet weak var controlView: UIView!
    /// Control뷰 - 재생, slider, 음소거, 전체보기 등이 있는 뷰
    @IBOutlet weak var controlBaseView: UIView!
    /// play, pause, replay 역할을 하는 버튼
    @IBOutlet weak var playBtn: UIButton!
    /// 재생시간 라벨
    @IBOutlet weak var playEndLbl: UILabel!
    
    /// 닫기버튼 상단여백
    @IBOutlet weak var closeBtnTop: NSLayoutConstraint!
    /// 닫기버튼 우측여백
    @IBOutlet weak var closeBtnTrailing: NSLayoutConstraint!
    
    /// 음소거 버튼
    @IBOutlet weak var speakerBtn: UIButton!
    /// 전체화면 버튼
    @IBOutlet weak var screenFullBtn: UIButton!
    ///전체화면 버튼 하단여백
    @IBOutlet weak var screenFullBtnBot: NSLayoutConstraint!
    ///전체화면 버튼 우측여백
    @IBOutlet weak var screenFullBtnTrailing: NSLayoutConstraint!
    
    /// 진행바 베이스 뷰
    @IBOutlet weak var sliderBaseView: UIStackView!
    /// 진행바 좌측 여백
    @IBOutlet weak var sliderBaseViewleading: NSLayoutConstraint!
    /// 진행바 우측 여백
    @IBOutlet weak var sliderBaseViewTrailing: NSLayoutConstraint!
    /// 진행바 아래 여백
    @IBOutlet weak var sliderBaseViewBot: NSLayoutConstraint!
    
    /// 진행바
    @IBOutlet weak var slider: WebPrdSlider!
    /// 현재시간 라벨
    @IBOutlet weak var currentTimeLbl: UILabel!
    /// 전체시간 라벨
    @IBOutlet weak var durationTimeLbl: UILabel!
    
    /// 동영상 플레이 종료여부 Flag
    private var isEndPlaying: Bool = false
    /// 애니메이션 Cancel을 위한 WorkItme 객체 - DispatchQueue들을 관리/보관하는 용도?
    private var workItem: DispatchWorkItem?
    
    private var playerLayer: AVPlayerLayer?
    
    
    /// WebPrdVideoView를 소유한 TargetViewController - 무조건 ResultWebViewController
    /// by narava 2020/09/03 시그니처 매장에서 공용으로 사용하기위해 타겟타입을 AnyObject로 변경 호출부분에 nil방지용 ? 도 추가
    
    weak var aTarget: AnyObject?
    ///  WebPrdView에서 BrightCove 컨트롤을 위한 델리게이트 객체
    weak var webPrdPlayerDelegate: WebPrdPlayerDelegate?
    /// 회전 방향
    var orientationType: VideoOrientationType = .landscape
    /// 동영상 타입
    var videoType: VideoType = .none
    /// 슬라이더 maxValue
    var sliderMaxValue: Float = .zero
    /// 슬라이드 사용자 Touch 중인지
    var isTouchingUser: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // 초기 UI 설정
        setInitUI()
        
        // 애니메이션 동작 WrokItem 초기화
        initWorkItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.applicationDelegate.gtMscreenOpenSendLog("iOS - VideoPlayer")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if self.orientationType == .landscape {
            return .landscapeRight
        } else {
            return .portrait
        }
    }
    
    
    @IBAction func sliderValueChangedAction(_ sender: UISlider) {
        self.isTouchingUser = true
    }
    
    @IBAction func sliderTouchDownInside(_ sender: UISlider) {
        self.isTouchingUser = true
        if let item = self.workItem {
            item.cancel()
            controlViewChangeAlpha(1.0)
        }
    }
    
    @IBAction func sliderTouchUpInside(_ sender: UISlider) {
        self.slider.setValue(sender.value, animated: true)
        self.currentTimeLbl.text = TimeInterval(sender.value).getPlayerLeftTime(videoType: self.videoType, isFullScreen: true)
        self.webPrdPlayerDelegate?.seekTo(value: sender.value, videoType: self.videoType)
        self.isTouchingUser = false
        
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: self.workItem!)
        }
    }
    
    @IBAction func sliderTouchUpOutside(_ sender: UISlider) {
        self.isTouchingUser = false
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: self.workItem!)
        }
    }
    
}

/// Private & Public Functions
extension WebPrdVideoFullViewController {
        
    private func setInitUI() {
        self.playEndLbl.isHidden = true
        self.sliderBaseView.isHidden = true
        if self.videoType != .live {
            self.slider.minimumValue = 0.0
            self.slider.maximumValue = self.sliderMaxValue
        } else {
            self.slider.minimumValue = 0.0
            self.slider.maximumValue = 1.0
        }
        self.slider.isContinuous = false
        if let thumbImage = UIImage(named: Const.Image.ic_slider_nor.name) {
            self.slider.setThumbImage(thumbImage, for: .normal)
        }
        
        // 세로영상인 경우 슬라이더 위치 변경
        if self.orientationType == .portrait {
            self.sliderBaseViewBot.constant = getSafeAreaInsets().bottom == 0 ? 72.0 : 110.0
            self.screenFullBtnBot.constant = getSafeAreaInsets().bottom == 0 ? 16.0 : 54.0
            
            self.closeBtnTop.constant = getSafeAreaInsets().top == 0 ? getStatusBarHeight() : getSafeAreaInsets().top
            self.closeBtnTrailing.constant = 0.0
            
            self.sliderBaseViewleading.constant = 24.0
            self.sliderBaseViewTrailing.constant = 24.0
        } else {
            self.sliderBaseViewBot.constant = getSafeAreaInsets().bottom == 0 ? 24.0 : 34.0
            self.screenFullBtnBot.constant = getSafeAreaInsets().bottom == 0 ? 16.0 : 24.0
            self.screenFullBtnTrailing.constant = getSafeAreaInsets().bottom == 0 ? 16.0 : 89.0
            
            self.closeBtnTop.constant = 0.0
            self.closeBtnTrailing.constant = getSafeAreaInsets().bottom == 0 ? 0.0 : 80.0
            
            self.sliderBaseViewleading.constant = getSafeAreaInsets().bottom == 0 ? 16.0 : 96.0
            self.sliderBaseViewTrailing.constant = getSafeAreaInsets().bottom == 0 ? 114.0 : 187.0
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.controlViewTapAction(_:)))
        self.controlView.addGestureRecognizer(tapGesture)
        
        // 애니메이션 동작 WrokItem 초기화
        initWorkItem()
        
        // 음소거 여부 설정 - "D": 디폴트(음소거) / "Y" : 소리on / "N" : 소리off(음소거)
        self.speakerBtn.isSelected = "Y" == DataManager.shared()?.strGlobalSoundForWebPrd ? true : false
        
        self.playEndLbl.setFontShadow(color: UIColor.getColor("000000"), alpha: 0.6, x: 0, y: 0, blur: 4.0, spread: 0)
        self.currentTimeLbl.setFontShadow(color: UIColor.getColor("000000"), alpha: 0.6, x: 0, y: 0, blur: 4.0, spread: 0)
        self.durationTimeLbl.setFontShadow(color: UIColor.getColor("000000"), alpha: 0.6, x: 0, y: 0, blur: 4.0, spread: 0)
        
    }
    
    private func initWorkItem() {
        self.workItem = DispatchWorkItem(block: {
            UIView.animate(withDuration: 0.5, animations: {
                self.controlViewChangeAlpha(0.0)
            }) { (isFinished) in

            }
        })
    }
    
    /// 일시정지뷰 노출여부 함수
    private func controlViewChangeAlpha(_ value: CGFloat) {
        self.controlBaseView.alpha = value
        
    }
    
    func addBrightCoveView(_ playerView: UIView) {
        self.sliderBaseView.isHidden = false
        
        playerView.backgroundColor = .black
        self.videoContainerView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        self.videoContainerView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: self.videoContainerView.topAnchor),
            playerView.trailingAnchor.constraint(equalTo: self.videoContainerView.trailingAnchor),
            playerView.leadingAnchor.constraint(equalTo: self.videoContainerView.leadingAnchor),
            playerView.bottomAnchor.constraint(equalTo: self.videoContainerView.bottomAnchor)
        ])
               
    }
    
    func addLivePlayerLayer(_ playerLayer: AVPlayerLayer) {
        if self.videoType == .live {
            self.sliderBaseView.isHidden = true
        } else {
            self.sliderBaseView.isHidden = false
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.playerLayer = playerLayer
        self.playerLayer!.frame = self.videoContainerView.layer.bounds
        // 미니플레이어는 꽉차게 나오도록
        playerLayer.videoGravity = .resizeAspect
        self.videoContainerView.layer.addSublayer(self.playerLayer!)
        CATransaction.commit()

    }
    
    
    /// 플레이어 재생
    func play() {
        self.isEndPlaying = false
        self.playBtn.isSelected = true
        self.speakerBtn.isHidden = false
        self.screenFullBtn.isHidden = false
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: self.workItem!)
        }
    }
    
    /// 플레이어 일시정지
    func pause() {
        self.playBtn.isSelected = false
        self.speakerBtn.isHidden = false
        self.screenFullBtn.isHidden = false
        
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
        }
    }
    
    /// 플레이어 다시재생
    func replay() {
        self.playBtn.setImage(UIImage(named: Const.Image.btn_play_nor.name), for: .normal)
        self.playBtn.isSelected = true
    }
    
    /// 플레이가 완료 되었을때 동작함수 - WebPrdView에서 호출한다
    func playEnd() {
        self.isEndPlaying = true
        self.playBtn.setImage(UIImage(named: Const.Image.btn_replay_nor.name), for: .normal)
        self.playBtn.isSelected = false
        self.slider.setValue(self.sliderMaxValue, animated: false)
        self.currentTimeLbl.text = TimeInterval(self.sliderMaxValue).getPlayerLeftTime(videoType: self.videoType, isFullScreen: true)
        
        if self.videoType == .live {
            self.playBtn.isHidden = true
            self.playEndLbl.isHidden = false
        }
        
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
        }
    }
}

/// MARK:- Button Action Functions
extension WebPrdVideoFullViewController {
    
    @IBAction func playBtnAction(_ sender: UIButton) {
        
        if sender.isSelected {
            // puase
            self.webPrdPlayerDelegate?.pause(isUserEvent: true)
            self.pause()
            self.aTarget?.sendBhrGbnEvent?("PAUSE", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
            if let item = self.workItem {
                item.cancel()
                initWorkItem()
                controlViewChangeAlpha(1.0)
            }
            sender.isSelected = false
        } else {
            
            // play 또는 replay
            if isEndPlaying {
                self.replay()
                self.webPrdPlayerDelegate?.replay()
            } else {
                self.play()
                self.webPrdPlayerDelegate?.play()
            }
        }
    }
    
    /// 영상뷰 tap 했을때 호출
    @objc func controlViewTapAction(_ gesture: UITapGestureRecognizer) {
        // 방송종류가 Live고, 방송이 종료되었을때
        if self.videoType == .live, self.isEndPlaying {
            controlViewChangeAlpha(1.0)
            return
        }
        
        // 현재 플레이중일때만 컨트롤영역이 사라져야 한다.
        if self.playBtn.isSelected == false {
            controlViewChangeAlpha(1.0)
            return
        }
        
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: self.workItem!)
        }
    }
    
    @IBAction func speakerBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            // 음소거에서 소리on으로 변경로직
            self.webPrdPlayerDelegate?.isMute(true)
            self.aTarget?.sendBhrGbnEvent?("SOUND_OFF", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
        } else {
            // 소리on에서 음소거로 변경로직
            self.webPrdPlayerDelegate?.isMute(false)
            self.aTarget?.sendBhrGbnEvent?("SOUND_ON", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
        }
        
        // 현재 플레이중일때만 컨트롤영역이 사라져야 한다.
        if self.playBtn.isSelected == false {
            controlViewChangeAlpha(1.0)
            return
        }
        
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: self.workItem!)
        }
    }
    
    @IBAction func screenFullBtnAction(_ sender: UIButton) {
        // FullScreen -> 일반 화면으로
        if let layer = self.playerLayer {
            layer.removeFromSuperlayer()
        }
        
        self.dismiss(animated: true) {
            self.aTarget?.sendBhrGbnEvent?("MINI", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
            self.webPrdPlayerDelegate?.showScreenFull(isFull: false)
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        if let layer = self.playerLayer {
            layer.removeFromSuperlayer()
        }
        
        if self.isEndPlaying == false {
            self.webPrdPlayerDelegate?.pause(isUserEvent: true)
        }
        
        
        self.dismiss(animated: true) {
            self.aTarget?.sendBhrGbnEvent?("EXIT", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
            self.webPrdPlayerDelegate?.showScreenFull(isFull: false)
        }
    }
}
