//
//  WebPrdVideoCell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/10.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit
import AVFoundation

class WebPrdVideoCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var videoContainerView: UIView!

    /// Control 부모뷰
    @IBOutlet weak var controlView: UIView!
    /// Control뷰 - 재생, slider, 음소거, 전체보기 등이 있는 뷰
    @IBOutlet weak var controlBaseView: UIView!
    /// play, pause, replay 역할을 하는 버튼
    @IBOutlet weak var playBtn: UIButton!
    /// 재생시간 라벨
    @IBOutlet weak var playTimeLbl: UILabel!
    
    /// 음소거 버튼
    @IBOutlet weak var speakerBtn: UIButton!
    /// 전체화면 버튼
    @IBOutlet weak var screenFullBtn: UIButton!
    
    /// 3G/LTE 팝업뷰
    @IBOutlet weak var networkPopupView: UIView!
    /// 3G/LTE 팝업 타이틀라벨
    @IBOutlet weak var networkPopupLbl: UILabel!
    /// 3G/LTE 팝업 취소 버튼
    @IBOutlet weak var cancelBtn: UIButton!
    /// 3G/LTE 팝업 확인 버튼
    @IBOutlet weak var confirmBtn: UIButton!
    
    /// 라이브방송 종료 뷰 - 종료라벨 노출
    @IBOutlet weak var liveEndView: UIView!
    /// 라이브방송 종료 라벨
    @IBOutlet weak var liveEndLbl: UILabel!
    
    /// Dim뷰
    @IBOutlet weak var dimView: UIView!
    /// 동영상을 플레이 했는지 Flag
    private var isReadyToPlay = false
    /// 동영상 플레이 종료여부 Flag
    private var isEndPlaying: Bool = false
    /// 애니메이션 Cancel을 위한 WorkItme 객체 - DispatchQueue들을 관리/보관하는 용도?
    private var workItem: DispatchWorkItem?
    /// 라이브 동영상 플레이레이어 객체
    private var playerLayer: AVPlayerLayer?
    
    /// WebPrdView를 소유한 TargetViewController - 무조건 ResultWebViewController?
    weak var aTarget: ResultWebViewController?
    ///  WebPrdView에서 BrightCove 컨트롤을 위한 델리게이트 객체
    weak var webPrdPlayerDelegate: WebPrdPlayerDelegate?
    /// 동영상 타입
    var videoType: VideoType = .none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.image = nil
        self.playTimeLbl.text = ""
        self.controlView.isHidden = false
        self.networkPopupView.isHidden = true
        self.speakerBtn.isHidden = true
        self.screenFullBtn.isHidden = true
        
        self.networkPopupLbl.setCorner(radius: 8)
        self.cancelBtn.setCorner()
        self.cancelBtn.setBorder(color: "FFFFFF", alpha: 1.0)
        self.confirmBtn.setCorner()
        self.confirmBtn.setBorder(color: "FFFFFF", alpha: 1.0)
        self.dimView.backgroundColor = UIColor.getColor("000000", alpha: 0.15)
        self.liveEndView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.controlViewTapAction(_:)))
        self.controlView.addGestureRecognizer(tapGesture)
        
        // 애니메이션 동작 WrokItem 초기화
        initWorkItem()
        
        // 음소거 여부 설정 - "D": 디폴트(음소거) / "Y" : 소리on / "N" : 소리off(음소거)
        self.speakerBtn.isSelected = "Y" == DataManager.shared()?.strGlobalSoundForWebPrd ? true : false
        
        // 방송시간 그림자 적용
        self.playTimeLbl.setFontShadow(color: UIColor.getColor("000000"), alpha: 0.6, x: 0, y: 0, blur: 4.0, spread: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    /// 데이터를 이용하여 화면 구성 및 Player 설정
    func setData(_ imgUrl: String, target: ResultWebViewController?, isShowNetworkPopup: Bool) {
        self.aTarget = target
        
        // 접근성
//        self.accessibilityLabel = product.productName
        
        // 이미지 설정
        ImageDownManager.blockImageDownWithURL(imgUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
            if error != nil || statusCode == 0 {
                self.imgView.image = UIImage(named: Const.Image.img_noimage_375.name)
                return
            }
            
            if isInCache == true {
                self.imgView.image = image
            } else {
                self.imgView.alpha = 0
                self.imgView.image = image
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.imgView.alpha = 1
                }, completion: nil)
            }
        }
        
        if isShowNetworkPopup {
            // 3G-LTE 체크 및 팝업 노출
            if NetworkManager.shared.currentReachabilityStatus() == .viaWWAN,
                "N" == DataManager.shared()?.strGlobal3GAgree {
                // 3G/LTE 일때
                networkPopupHidden(false)
            } else {
                networkPopupHidden(true)
            }
        }  
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
        self.dimView.backgroundColor = UIColor.getColor("000000", alpha: 0.3)
        self.controlBaseView.alpha = value
        
    }

    /// 네트워크 팝업 노출여부 함수
    func networkPopupHidden(_ value: Bool) {
        if value {
            // 숨기기
            self.playBtn.isHidden = false
            self.playTimeLbl.isHidden = false
            self.networkPopupView.isHidden = true
        } else {
            // 보여주기
            self.playBtn.isHidden = true
            self.playTimeLbl.isHidden = true
            self.networkPopupView.isHidden = false
        }
    }
    
    
    /// BrightCove뷰를 add하는 함수
    func addBrightCoveView(_ playerView: UIView, videoType type: VideoType) {
        self.videoType = type
        
        self.videoContainerView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.videoContainerView.backgroundColor = .black
        self.videoContainerView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: self.videoContainerView.topAnchor),
            playerView.rightAnchor.constraint(equalTo: self.videoContainerView.rightAnchor),
            playerView.leftAnchor.constraint(equalTo: self.videoContainerView.leftAnchor),
            playerView.bottomAnchor.constraint(equalTo: self.videoContainerView.bottomAnchor)
        ])
        playerView.layoutIfNeeded()
    }
    
    func addLivePlayerLayer(_ playerLayer: AVPlayerLayer, videoType type: VideoType) {
        self.videoType = type
        self.videoContainerView.backgroundColor = .black
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        playerLayer.videoGravity = .resizeAspect
        
        self.videoContainerView.layer.addSublayer(playerLayer)
        CATransaction.commit()
    }
    
    /// 플레이어 재생
    func play() {
        self.isReadyToPlay = true
        self.isEndPlaying = false
        self.playBtn.isSelected = true
        self.playTimeLbl.isHidden = false
        self.imgView.isHidden = true
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
        self.imgView.isHidden = true
        self.playBtn.setImage(UIImage(named: Const.Image.btn_play_nor.name), for: .normal)
    }
    
    /// 플레이가 완료 되었을때 동작함수 - WebPrdView에서 호출한다
    func playEnd() {
        self.isEndPlaying = true
        self.playBtn.isSelected = false
        self.playTimeLbl.isHidden = true
        
        if self.videoType == .live {

            // 라이브 방송일 경우, '방송이 종료되었습니다' 노출
            self.playBtn.isHidden = true
            self.speakerBtn.isHidden = true
            self.screenFullBtn.isHidden = true
            self.liveEndView.isHidden = false
            self.liveEndLbl.setFontShadow(color: UIColor.getColor("000000"), alpha: 0.6, x: 0, y: 0, blur: 4.0, spread: 0)
            controlViewChangeAlpha(0.0)
            return
        }
        
        self.playBtn.setImage(UIImage(named: Const.Image.btn_replay_nor.name), for: .normal)
        
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
        }
    }
}


// MARK:- Button Action Functions
extension WebPrdVideoCell {
    @IBAction func playBtnAction(_ sender: UIButton) {

        if sender.isSelected {
            // puase
            self.webPrdPlayerDelegate?.pause(isUserEvent: true)
            self.pause()
            self.aTarget?.sendBhrGbnEvent("PAUSE", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
            if let item = self.workItem {
                item.cancel()
                initWorkItem()
                controlViewChangeAlpha(1.0)
            }
            sender.isSelected = false
        } else {
            // 3G-LTE 체크 및 팝업 노출
            if NetworkManager.shared.currentReachabilityStatus() == .viaWWAN,
                "N" == DataManager.shared()?.strGlobal3GAgree {
                // 3G/LTE 일때
                networkPopupHidden(false)
                return
            }
            
            // play 또는 replay
            if isEndPlaying {
                self.replay()
                self.webPrdPlayerDelegate?.replay()
            } else {
                self.play()
                self.webPrdPlayerDelegate?.play()
            }
            
            //엠플리튜드 전송 아래 함수가 받아서 한번더 가공후 전송
            self.aTarget?.sendAmplitudeAndMseq(withAction: "대표_동영상_Play")
            self.aTarget?.sendBhrGbnEvent("PLAY", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
        }
    }
    
    /// 네트워크 팝업 취소 버튼 Action
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.aTarget?.sendBhrGbnEvent("LTE_N", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
        networkPopupHidden(true)
    }
    
    /// 네트워크 팝업 확인 버튼 Action
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        DataManager.shared()?.strGlobal3GAgree = "Y"
        networkPopupHidden(true)
        self.webPrdPlayerDelegate?.play()
        self.play()
        
        // APP에서 데이터 경고창 노출여부 Web으로 전달 - 웹에서 경고창 상태값 반영
        if let vc = self.aTarget {
            vc.callJscriptMethod("setNoDataWarningFlag('Y');")
            self.aTarget?.sendBhrGbnEvent("LTE_Y", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
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
            if self.isReadyToPlay == false {
                // 최초 진입후 플레이를 한번도 안한 상태에서는 return -> dim 15% 유지하기 위함.
                return
            }
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
            self.aTarget?.sendBhrGbnEvent("SOUND_OFF", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
        } else {
            // 소리on에서 음소거로 변경로직
            self.webPrdPlayerDelegate?.isMute(false)
            self.aTarget?.sendBhrGbnEvent("SOUND_ON", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
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
        // 일반 화면 -> FullScreen화면으로
        self.webPrdPlayerDelegate?.showScreenFull(isFull: true)
        self.aTarget?.sendBhrGbnEvent("FULL", andTotalTime: (self.webPrdPlayerDelegate?.getTotalTime())!, andCurrentTime: (self.webPrdPlayerDelegate?.getCurrentTime())!)
    }
}
