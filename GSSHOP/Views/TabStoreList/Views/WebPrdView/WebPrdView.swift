//
//  WebPrdView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/01/31.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit
import AVFoundation

protocol WebPrdPlayerDelegate: class {
    func play()
    func pause(isUserEvent: Bool)
    func replay()
    func isMute(_ value: Bool)
    func showScreenFull(isFull: Bool)
    func miniPlayerClose()
    func seekTo(value: Float, videoType: VideoType)
    func getPlayStatus() -> PlayStatus
    func requestBrightCoveFindVideo()
    func getTotalTime() -> TimeInterval
    func getCurrentTime() -> TimeInterval
}

extension WebPrdPlayerDelegate {
    func isMute(_ value: Bool) {}
    func showScreenFull(isFull: Bool) {}
    func miniPlayerClose() {}
    func seekTo(value: Float, videoType: VideoType) {}
    func getPlayStatus() -> PlayStatus {return PlayStatus.none}
    func requestBrightCoveFindVideo() {}
    func getTotalTime() -> TimeInterval{return .zero}
    func getCurrentTime() -> TimeInterval{return .zero}
}

public enum VideoType {
    case live
    case mp4
    case brightCove
    case none
}

private enum VideoOrientation {
    case landscape
    case portrait
    case square
    case none
}

public enum PlayStatus {
    case ready
    case play
    case pause
    case end
    case none
}

@objc class WebPrdView: UIView {
    
    @IBOutlet weak var pageCountLbl: UILabel!
    @IBOutlet weak var pageCountBGView: UIView!
    @IBOutlet weak var prevCachingImgView: UIImageView!
    /// 단품 상단 이미지/비디오 영역 baseView
    @IBOutlet weak var topBaseView: UIView!
    /// 매장 이미지/플레이어 노출을 위한 CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    /// collectionView의 Width
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var playBtn: UIButton!

    /// 단품 데이터 객체
    private var webProduct: WebProduct?
    
    /// 동영상 플레이 CollectionViewCell 객체
    private var webPrdVideoCell: WebPrdVideoCell?
    /// 미니 플레이어뷰 객체
    private var miniPlayerView: WebPrdMiniPlayerView?
    /// 동영상 전체 플레이어 뷰컨트롤러
    private var webPrdViewFullViewController: WebPrdVideoFullViewController?
    /// 생방송에 사용하는 AVPlayerLayer
    private var livePlayerLayer: AVPlayerLayer?
    /// 타이머 객체 - 라이브 동영상 남은 시간 표시를 위함
    private var timer: Timer?
    
    /// 비디오정보 객체
    private var videoInfo: VideoInfo?
    /// 현재 비디오의 타입 (생방송이냐 브라이트코브냐)
    private var videoType = VideoType.none
    /// 현재 미니 플레이어가 노출되고 있는지 판단 플레그
    private var isPlayingMiniView = false
    /// 현재 비디오의 가로/세로/정사각 타입
    private var videoOrientation: VideoOrientation = .none
    
    /// 방송 이미지 URL String 배열 객체
    private var arrImageUrls = [String]()
    /// 혜택 URL String 배열객체
    private var benefitUrls = [String]()
    /// 브라이트 코드 ID
    private var brightCoveID: String = ""
    /// 방송영상 URL (생방송 링크, 데이터방송 링크 등)
    private var videoUrl: URL?
    /// 사용자가 직접 Pause(일시정지)버튼을 눌렀는지 여부
    private var isUserEventPause: Bool = true
    /// 미니 플레이어 이전 상태 체크
    private var beforePlayStatus:PlayStatus = .none
    
    // BrightCove 관련 객체들
    let sharedSDKManager = BCOVPlayerSDKManager.shared()
    let playbackService = BCOVPlaybackService(accountId: BRIGHTCOVE_ACCOUNTID, policyKey: BRIGHTCOVE_POLICY_KEY)!
    
    /// 브라이트코브 비디오 객체
    var brightCoveVideo: BCOVVideo?
    /// BrightCove의 playController
    @objc var playbackController :BCOVPlaybackController?
    /// BrightCove의 player View
    @objc weak var playerView: BCOVPUIPlayerView!
    /// 브라이트코브 AVPlayerController
    @objc var playerViewController = AVPlayerViewController()
    /// 동영상 플레이어 객체 - 볼륨 설정을 BrightCove에서 할 수 없어서 player객체에서 진행한다.
    @objc var videoPlayer: AVPlayer?
    /// 동영상 플레이어 상태옵져버 포인터
    private var AVPlayerStatusContext:  Int?
    
    /// 영상 전체 시간
    var durationTime: TimeInterval = .zero
    /// 영상 현재 시간
    var currentTime: TimeInterval = .zero
    /// 영상 남은 시간
    var leftTime: TimeInterval = .zero
    /// 플레이 상태값
    var playStatus: PlayStatus = .none
    /// 자동플레이 Flag
    private var isAutoPlaying: Bool = false
    
    /// WebPrdView를 소유한 TargetViewController - 무조건 ResultWebViewController?
    @objc weak var aTarget: ResultWebViewController?
    /// 단품 네이티브 화면변수들
    private weak var broadView: WebPrdBroadView?
    private weak var priceView: WebPrdPriceView?
    
    // 단품 네이티브 화면의 전체 높이
    var totalHeight: CGFloat = .zero
    
    /// 상품 정보영역 add된 마지막 뷰 객체
    weak var lastAddedView: UIView?
    
    var durationFromJson : TimeInterval = .zero
    
    /// 단품 로딩화면
    private weak var webPrdLoadingView: WebPrdLoadingView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        if let player = self.videoPlayer {
            if AVPlayerStatusContext != nil {
                player.removeObserver(self, forKeyPath: "status", context: &AVPlayerStatusContext!)
            }
            player.currentItem?.cancelPendingSeeks()
            player.currentItem?.asset.cancelLoading()
            player.replaceCurrentItem(with: nil)
            self.videoPlayer = nil
        }
        
        if self.livePlayerLayer != nil {
            self.livePlayerLayer = nil
        }
        
        print("kiwon : WebPrdView Deinit....")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerInterrupted(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerStalled(_:)), name: .AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerStalled(_:)), name: .AVPlayerItemNewErrorLogEntry, object: nil)
        
        self.playBtn.isHidden = true
        
        self.collectionViewWidth.constant = getAppFullWidth()
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: WebPrdCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: WebPrdCell.reusableIdentifier)
        self.collectionView.register(UINib(nibName: WebPrdVideoCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: WebPrdVideoCell.reusableIdentifier)
        
        // 카운팅 라벨뷰
        self.pageCountBGView.setCorner()
        self.pageCountBGView.isHidden = true
        
        // 로딩뷰
        if let view = Bundle.main.loadNibNamed(WebPrdLoadingView.className, owner: self, options: nil)?.first as? WebPrdLoadingView {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.webPrdLoadingView = view
            self.topBaseView.insertSubview(view, at: 0)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
            
            view.layoutIfNeeded()
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if let view = self.webPrdLoadingView {
            view.setMaskingViews()
        }
    }
    
    @objc func viewWillAppear() {
        if let playerBackVC = self.playbackController {
            playerBackVC.delegate = self
        }
        
        if let timer = self.timer, timer.isValid == false {
            self.setTimer()
        }
    }
    
    @objc func viewDidDisappear() {
        
        // 브라이트코드 플레이어 정지
        if self.playbackController != nil {
            self.playbackController!.delegate = nil
            self.playbackController!.pause()
        }
        
        // player pause
        if self.videoPlayer != nil {
            self.videoPlayer?.pause()
        }
        
        // UI 변경
        if self.playStatus == .play {
            self.pause()
        }
        
        if self.timer != nil {
            self.timer?.invalidate()
        }
        
        // observerValue 함수에서 자동플레이 플래그 true시 시작해버리는 오류가 있음.
        self.isAutoPlaying = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let player = self.videoPlayer else {
            return
        }
        
        if object as AnyObject? === player {
            if "status" == keyPath {
                if player.status == .readyToPlay {
                    
                    // 영상 가로/세로/정사각 설정
                    if let playerLayer = self.livePlayerLayer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.prevCachingImgView.isHidden = true
                            self.setPageControl()
                            
                            self.playStatus = .ready
                            if let item = player.currentItem {
                                self.durationTime = item.duration.seconds
                            }
                            
                            // 영상 가로/세로/정사각 설정
                            if playerLayer.videoRect != .zero {
                                let size = playerLayer.videoRect
                                
                                if size.height > size.width {
                                    self.videoOrientation = .portrait
                                } else if size.height < size.width {
                                    self.videoOrientation = .landscape
                                } else {
                                    self.videoOrientation = .square
                                }
                            }
                            
                            if self.isAutoPlaying {
                                self.play()
                                //엠플리튜드 전송 아래 함수가 받아서 한번더 가공후 전송
                                self.aTarget?.sendAmplitudeAndMseq(withAction: "대표_동영상_자동재생")
                                self.aTarget?.sendBhrGbnEvent("PLAY", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
                            }
                        }
                    }
                    
                }
            }
        }
    }
    

    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>) {
        guard let nProduct = NativeProduct(JSON: rowinfoDic) else { return }
        
        /// 캐싱된 이미지가 있는 경우, 캐싱이미지 노출!
        if nProduct.preCachingUrl.isEmpty == false {
            ImageDownManager.blockImageDownWithURL(nProduct.preCachingUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                
                if error != nil || statusCode == 0 {
                    return
                }
                
                if isInCache == true {
                    self.prevCachingImgView.image = image
                } else {
                    self.prevCachingImgView.alpha = 0
                    self.prevCachingImgView.image = image
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.prevCachingImgView.alpha = 1
                    }, completion: nil)
                }
            }
        }
        
    }
    
    @objc func setDataInfo(_ rowinfoDic: Dictionary<String, Any>) {
        if let view = self.webPrdLoadingView {
            view.removeFromSuperview()
            self.webPrdLoadingView = nil
        }
        
        /// 단품 API Response Model Mapping
        guard let webProduct = WebProduct(JSON: rowinfoDic) else {
            return
        }
        self.webProduct = webProduct
        
        var previousComponent = Components()
        for component in webProduct.components {
            
            switch component.templateType {
            case WebTemplateType.mediaInfo.name:
                setImageVideoInfoUI(component)
                
            case WebTemplateType.broadInfo.name:
                setBroadInfoUI(component)
                
            case WebTemplateType.prdNmInfo.name:
                setPrdNameInfoUI(component)
                
            case WebTemplateType.saleInfo.name:
                setSaleInfoUI(component)
                
            case WebTemplateType.promotionInfo.name:
                setPromotionInfo(component)
                
            case WebTemplateType.personalCouponPmoInfo.name:
                setCouponInfo(component)
                
            case WebTemplateType.cardPmoInfo.name:
                setCardInfo(component)
                
            case WebTemplateType.cardPmoInfo2.name:
                setCardInfo(component)
                
            case WebTemplateType.deliveryInfo.name:
                if previousComponent.templateType == WebTemplateType.promotionInfo.name {
                    // 라인 없음
                    setDeliveryInfo(component, isShowLine: false)
                } else {
                    setDeliveryInfo(component)
                }
            case WebTemplateType.noInterestInfo.name:
                if previousComponent.templateType == WebTemplateType.promotionInfo.name {
                    setNoInterestInfo(component, isShowLine: false)
                } else {
                    setNoInterestInfo(component)
                }
            case WebTemplateType.addPromotionInfo.name:
                if previousComponent.templateType == WebTemplateType.promotionInfo.name {
                    setAddPromotionInfo(component, isShowLine: false)
                } else {
                    setAddPromotionInfo(component)
                }
            default:
                break
            }
            
            previousComponent = component
        }

        
        if self.lastAddedView != nil {
            self.lastAddedView!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        }
        self.layoutIfNeeded()
        
        self.totalHeight = self.frame.height
        self.aTarget?.updateWebHeight(self.totalHeight)
        
        for view in self.subviews {
            if view is WebPrdDeliveryView {
                self.bringSubviewToFront(view)
            }
        }
    }
    
    // MARK:- Private functions

    /// 상단 이미지 / Video 뷰 설정
    private func setImageVideoInfoUI(_ data: Components) {
        
        // 1.video가 있는 경우 BrightCove Video 설정
        if data.videoInfoList.count > 0 {
            
            // 자동플레이 Flag 설정
            if let vc = self.aTarget, let urlComponents = URLComponents(string: vc.urlString),
                let urlQueryItems = urlComponents.queryItems,
                let param = urlQueryItems.filter({ $0.name == "vodPlay" }).first,
                let autoPlaying = param.value {
                
                // 자동 플레이여부 설정
                // vodPlay=LIVE
                // vodPlay=VOD
                if "LIVE" == autoPlaying || "VOD" == autoPlaying {
                    self.isAutoPlaying = true
                } else {
                    self.isAutoPlaying = false
                }
            }
            
            /// 플레이어 설정 - 자동플레이에 따라 자동실행되야 하는 로직
            setVideoInfo(data.videoInfoList)
        }

        // 2. 이미지 개수 설정
        self.arrImageUrls = data.imgUrlList
        // 혜택 이미지 설정
        self.benefitUrls = data.benefits
        
        if let firstImageUrl = self.arrImageUrls.first {
            // 3. 영상 타입에 따라 이미지 개수를 추가한다.
            if self.videoType == .none {
                // 이미지 갯수 그래도 노출
                setPageControl()
            } else if self.videoType == .live {
                //  영상 1 + 이미지 7 이면
                // 라이브 : 영상 1 + 이미지 2~7 까지 -> 총 7개 (이미지갯수와 동일한 count 리턴)
            } else {
                // VOD 영상 1 + 이미지 7 -> 총 8개
                self.arrImageUrls.insert(firstImageUrl, at: 0)
            }

        }
        
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: false)
        
    }
    
    /// page Control 설정
    private func setPageControl() {
        if self.arrImageUrls.count > 1 {
            self.pageCountBGView.isHidden = false
            self.pageCountLbl.text = String(format: "1 / %ld",self.arrImageUrls.count)
        }else{
            self.pageCountBGView.isHidden = true
        }
    }
    
    /// 방송 정보 뷰 추가
    private func setBroadInfoUI(_ data: Components) {
        if let broadView = Bundle.main.loadNibNamed(WebPrdBroadView.className, owner: self, options: nil)?.first as? WebPrdBroadView {
            self.broadView = broadView
            self.addSubViewAtWebPrdView(broadView)
            //데이터 설정
            if let aTarget = self.aTarget {
                broadView.setData(data, target: aTarget)
            }
            broadView.layoutIfNeeded()
        }
    }
    
    /// 상품명 정보 뷰 추가
    private func setPrdNameInfoUI(_ data: Components) {
        // 상품명 정보 추가
        if let prdNmView = Bundle.main.loadNibNamed(WebPrdNameView.className, owner: self, options: nil)?.first as? WebPrdNameView {
            self.addSubViewAtWebPrdView(prdNmView)
            //데이터 설정
            if let aTarget = self.aTarget {
                prdNmView.setData(data, target: aTarget)
            }
            prdNmView.layoutIfNeeded()
        }
    }
    
    /// 가격 정보 뷰 추가
    private func setSaleInfoUI(_ data: Components) {
        // 가격정보 추가
        if let priceView = Bundle.main.loadNibNamed(WebPrdPriceView.className, owner: self, options: nil)?.first as? WebPrdPriceView {
            self.priceView = priceView
            self.addSubViewAtWebPrdView(priceView)
            //데이터 설정
            if let aTarget = self.aTarget {
                priceView.setData(data, target: aTarget)
            }
            priceView.layoutIfNeeded()
        }
    }
    
    /// 등급 정보 뷰 추가
    private func setPromotionInfo(_ data: Components) {
        if data.gradePmoInfo.count <= 0 {
            return
        }
        
        // vip등급 정보 추가
        if let vipView = Bundle.main.loadNibNamed(WebPrdVipView.className, owner: self, options: nil)?.first as? WebPrdVipView {
            self.addSubViewAtWebPrdView(vipView)
            //데이터 설정
            vipView.setData(data)
            vipView.layoutIfNeeded()
        }
    }
    
    /// 쿠폰뷰 추가
    private func setCouponInfo(_ data: Components) {
        if let couponView = Bundle.main.loadNibNamed(WebPrdCouponView.className, owner: self, options: nil)?.first as? WebPrdCouponView {
            self.addSubViewAtWebPrdView(couponView)
            //데이터 설정
            if let aTarget = self.aTarget {
                couponView.setData(data, target: aTarget)
            }
            couponView.layoutIfNeeded()
        }
    }
    
    /// 카드할인정보 뷰 추가
    private func setCardInfo(_ data: Components) {
        
        if let view = Bundle.main.loadNibNamed(WebPrdCardView.className, owner: self, options: nil)?.first as? WebPrdCardView {
            self.addSubViewAtWebPrdView(view)
            //데이터 설정
            if let aTarget = self.aTarget {
                view.setData(data, target: aTarget)
            }
            view.layoutIfNeeded()
        }
    }
    
    /// 배송비 뷰 추가
    private func setDeliveryInfo(_ data: Components, isShowLine: Bool = true) {
        
        for (index, deliveryInfo) in data.deliveryList.enumerated() {
        
            if let view = Bundle.main.loadNibNamed(WebPrdDeliveryView.className, owner: self, options: nil)?.first as? WebPrdDeliveryView {
                self.addSubViewAtWebPrdView(view)
                //데이터 설정
                if let aTarget = self.aTarget {
                    view.setData(deliveryInfo, target: aTarget)
                }
                view.layoutIfNeeded()
                
                if index == 0, isShowLine == false {
                    view.lineView.isHidden = true
                }
            }
        }
    }
    
    /// 무이자 뷰 추가
    private func setNoInterestInfo(_ data: Components, isShowLine: Bool = true) {
        if let view = Bundle.main.loadNibNamed(WebPrdNoInterestView.className, owner: self, options: nil)?.first as? WebPrdNoInterestView {
            self.addSubViewAtWebPrdView(view)
            //데이터 설정
            if let aTarget = self.aTarget {
                view.setData(data, target: aTarget)
            }
            view.layoutIfNeeded()
            
            if isShowLine == false {
                view.lineView.isHidden = true
            }
        }
    }
    
    /// 공통템플릿 뷰 추가
    private func setAddPromotionInfo(_ data: Components, isShowLine: Bool = true) {
        
        for (index, commonInfo) in data.itemList.enumerated() {
            if let view = Bundle.main.loadNibNamed(WebPrdAddPromotionInfoView.className, owner: self, options: nil)?.first as? WebPrdAddPromotionInfoView {
                self.addSubViewAtWebPrdView(view)
                //데이터 설정
                if let aTarget = self.aTarget {
                    view.setData(commonInfo, target: aTarget)
                }
                view.layoutIfNeeded()
                
                if index == 0, isShowLine == false {
                    view.lineView.isHidden = true
                }
            }
        }
    }

    /// 뷰 Add 로직 함수
    private func addSubViewAtWebPrdView(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        var topConstraint: NSLayoutConstraint!
        if self.lastAddedView == nil {
            topConstraint = view.topAnchor.constraint(equalTo: self.topAnchor, constant: getAppFullWidth())
        } else {
            topConstraint = view.topAnchor.constraint(equalTo: self.lastAddedView!.bottomAnchor)
        }
        NSLayoutConstraint.activate([
            topConstraint,
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        self.lastAddedView = view
    }
    
    /// BrighteCove PlaybackController 초기화
    private func setBrightCovePlaybackController() -> BCOVPlaybackController {
        let playbackController = (sharedSDKManager?.createPlaybackController())!
        playbackController.analytics.account = BRIGHTCOVE_ACCOUNTID
        
        // 현재 재생session에서 재생종료시,  kBCOVPlaybackSessionLifecycleEventEnd를 보낸다.
        // 그때 다음 재생 session을 자동 플레이 할것인지 설정
        playbackController.isAutoAdvance = false
    
        // 자동재생 여부
        playbackController.isAutoPlay = false
        
        return playbackController
    }
    
    
    // 영상 관련 초기 뷰선언
    private func setVideoInfo(_ videoInfos: [VideoInfo]) {
        
        self.playbackController = setBrightCovePlaybackController()
        
        let options = BCOVPUIPlayerViewOptions()
        options.presentingViewController = self.aTarget
        // BrightCoveView 생성 - Control이 없는 뷰로..
        
        guard let bcPlayerView = BCOVPUIPlayerView(playbackController: self.playbackController, options: options, controlsView: nil) else {
            return
        }
        // 광고뷰 없애기
        bcPlayerView.adControlsView.advertisingMode = false
        bcPlayerView.adControlsView.isHidden = true
        bcPlayerView.frame = self.collectionView.frame
        bcPlayerView.backgroundColor = .white
        self.playerView = bcPlayerView
        self.playerView.playbackController = playbackController
        self.playerView.playbackController.delegate = self
        
        guard let firstVideoInfo = videoInfos.first else {
            // 비디오 관련 데이터 없음
            self.videoInfo = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.prevCachingImgView.isHidden = true
                self.setPageControl()
            }
            return
        }
                
        // 생방송판단 : 유효한 URL, liveYN == "Y", url 확장자가 .m3u8 일때
        
        if let url = URL(string: firstVideoInfo.videoUrl) {
            self.videoUrl = url
            
            // mp4 영상테스트 - 세로영상
//            data.videoUrl = "http://mobilevod.gsshop.com/shortbroad/201709/1504228134378_1.mp4"
            
            // mp4 영상테스트 - 가로영상
//            data.videoUrl = "http://mobilevod.gsshop.com/livedeal/20180111162257786043.mp4"
            
            // 라이브 테스트
//            data.videoUrl = "http://livem.gsshop.com/gsshop_hd/_definst_/gsshop_hd.stream/playlist.m3u8"
            
            // 생방송 종료시간 임의 조절
//            firstVideoInfo.endTime = "20200429091800"
            
            
            if "Y" == firstVideoInfo.liveYN, url.pathExtension.contains("m3u8") {
                // 생방송
                self.videoType = .live
                if self.timer == nil {
                    setTimer()
                }
                self.videoInfo = firstVideoInfo

                
                // 과금팝업 노출을 하는지 -> 노출하지 않는 경우는 Wifi이고 이미 과금팝업을 본 경우 자동실행
                if isShowNetworkPopup() == false {
                    setPlayer(url: url)
                }
            } else if url.pathExtension.contains("mp4") {
                self.videoType = .mp4
                self.videoInfo = firstVideoInfo
                if self.timer == nil {
                    setTimer()
                }

                // 과금팝업 노출을 하는지 -> 노출하지 않는 경우는 Wifi이고 이미 과금팝업을 본 경우 자동실행
                if isShowNetworkPopup() == false {
                    setPlayer(url: url)
                }
            } else if "N" == firstVideoInfo.liveYN, videoInfos.count >= 2 {
                // videoInfo의 두번째 배열에 브라이트 코브 데이터가 있다!
                if let lastVideoInfo = videoInfos[safe: 1] {
                    self.videoInfo = lastVideoInfo
                    setBrightCove(data: lastVideoInfo)
                } else {
                    // 비디오 관련 데이터 없음
                    self.videoInfo = nil
                    return
                }
            } else {
                // 비디오 관련 데이터 없음
                self.videoInfo = nil
                return
            }

        } else if firstVideoInfo.videoId.isEmpty == false {
            // 브라이트코브 데이터
            self.videoInfo = firstVideoInfo
            setBrightCove(data: firstVideoInfo)
        } else {
            // 비디오 관련 데이터 없음
            self.videoInfo = nil
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.prevCachingImgView.isHidden = true
            self.setPageControl()
        }
        
        // 미니플레이어뷰 설정
        setMiniPlayerUI()
    }
    
    /// 브라이트코브 설정
    private func setBrightCove(data: VideoInfo) {
        if data.videoId.isEmpty {
            // 비디오 관련 데이터 없음
            self.videoInfo = nil
            return
        }
        
        // 비디오타입 설정
        self.videoType = .brightCove
        
//        // 세로영상
//        data.videoId = "6032037590001"
//        
//        // 정사각 영상
//        data.videoId = "6135325000001"
//        
//        // 가로영상
//        data.videoId = "6098936474001"
//        
//        // 임의 영상
//        data.videoId = "6115234986001"
        
        // BrightCove 영상 id값으로 비디오 설정
        self.brightCoveID = data.videoId
        
        // 브라이트코브 서버에서 비디오 객체 얻어오기
        requestContentFromPlaybackService(id: data.videoId)
    }
    
    /// 미니플레이어뷰 설정
    private func setMiniPlayerUI() {
        if let resultVC = self.aTarget, let webPrdNaviBarView = resultVC.webPrdNaviBarView {
            let posY = webPrdNaviBarView.frame.origin.y + webPrdNaviBarView.frame.height
            self.miniPlayerView = Bundle.main.loadNibNamed(WebPrdMiniPlayerView.className, owner: self, options: nil)?.first as? WebPrdMiniPlayerView
            self.miniPlayerView!.frame = CGRect(x: 0, y: posY, width: getAppFullWidth(), height: WebPrdMiniPlayerView.WEB_PRD_MINI_PLAYER_HEIGHT)
            self.miniPlayerView?.autoresizingMask = .flexibleWidth
            self.miniPlayerView!.webPrdPlayerDelegate = self
            self.miniPlayerView!.aTarget = self.aTarget
            self.miniPlayerView!.videoType = self.videoType
            self.miniPlayerView!.isHidden = true
            
            if self.videoType == .live || self.videoType == .mp4 {
                if let layer = self.livePlayerLayer {
                    
                    if self.videoOrientation == .portrait || self.videoOrientation == .square {
                        // 세로 영상 or 정사각 영상
                        self.miniPlayerView!.addLivePlayerLayer(layer, isLandscape: false)
                    } else {
                        self.miniPlayerView!.addLivePlayerLayer(layer)
                    }
                }
            } else if self.videoType == .brightCove {
                
                if self.videoOrientation == .portrait || self.videoOrientation == .square {
                    // 세로 영상 or 정사각 영상
                    self.miniPlayerView!.addBrightCoveView(self.playerView, isLandscape: false)
                } else {
                    self.miniPlayerView!.addBrightCoveView(self.playerView)
                }
            }
        
            resultVC.view.addSubview(self.miniPlayerView!)
        }
    }
    
    /// 플레이어 설정
    private func setPlayer(url: URL) {
        let player = AVPlayer(url: url)
        AVPlayerStatusContext = 0
        player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: &AVPlayerStatusContext!)
        self.videoPlayer = player
        self.livePlayerLayer = AVPlayerLayer(player: self.videoPlayer)
        
        changePlayerView()
    }
    
    private func isShowNetworkPopup() -> Bool {
        if NetworkManager.shared.currentReachabilityStatus() == .viaWWAN,
            "N" == DataManager.shared()?.strGlobal3GAgree {
            // 자동재생 안하고 네트워크 팝업이 노출되야 함
            return true
        }
        return false
    }
    
    
    private func setNoteCnt(_ value: Int) {
        let currentRow = String(value)
        self.pageCountLbl.text = currentRow + " / \(self.arrImageUrls.count)"
    }
    
    private func updatePlayBtnUI(_ index: Int) {
        if self.videoType == .none {
            // 영상이 없으면 플레이버튼 안보이게
            self.playBtn.isHidden = true
        } else {
            // 영상이 있으면 플레이버튼 보이게
            // 영상이 있어도 첫번째 videoCell에서는 플레이버튼 안보이게
            if index == 0 {
                self.playBtn.isHidden = true
            } else {
                
                if self.videoType == .live && self.playStatus == .end {
                    // 라이브방송이 종료되었을 때는 숨기기
                    self.playBtn.isHidden = true
                } else {
                    self.playBtn.isHidden = false
                }
            }
        }
    }
    
    /// 이미지 Cell에 갔다가 비디오 Cell로 온 경우 비디오를 Play/Pause 하기 위함 함수.
    private func changePlayPause(_ index: Int) {
        if self.videoType == .none {
            // 영상이 없으면 패스~
            return
        }
        
        if index == 0 {
            
            if self.isUserEventPause {
                // 유저가 직접 Pause를 눌렀다면 영상 플레이 되면 안됨
                
            } else {
                // 유저가 직접 Pause를 눌렀다면 영상 플레이
                if self.playStatus == .end {
                    return
                } else {
                    self.play()
                }
            }
        } else {
            if self.playStatus == .play {
                // 영상이 일시정지
                self.pause(isUserEvent: false)
            }
        }
    }
    
    /// 플레이어 Interrupt 콜백 함수
    @objc private func playerInterrupted(_ notificaation: Notification) {
        if let _ = self.videoPlayer {
            if self.playStatus == .play {
                self.pause()
            }
        }
    }
    
    /// 플렝어 에러 노티콜백 함수
    @objc private func playerStalled(_ notification: Notification) {
        if let player = self.videoPlayer {
            if let currentItem = player.currentItem {
                if let log = currentItem.errorLog() {
                    print("kiwon AVPlayer ErrorLog allEvent : \(log.events)")
                    if let lastEvent = log.events.last {
                        print("kiwon AVPlayer ErrorLog lastEvent Coment : " + (lastEvent.errorComment ?? "errorComent = nil...??"))
                        print("kiwon AVPlayer ErrorLog lastEvent Code : \(lastEvent.errorStatusCode)")
                        print("kiwon AVPlayer ErrorLog lastEvent Code : " + (lastEvent.errorDomain))
                    }
                } else {
                    print("kiwon AVPlayer ErrorLog : player currentItem log is nil....")
                    if let error = currentItem.error {
                        print("kiwon AVPlayer ErrorLog : player currentItem error : " +  error.localizedDescription )
                    }
                }
            } else {
                print("kiwon AVPlayer ErrorLog : player currentItem is nil....")
            }
        } else {
            print("kiwon AVPlayer ErrorLog : player is nil....")
        }
        /*
         AVPlayerItemNewErrorLogEntry 로 나타나는 errorComment
         "Media file not received in 시간(s)"
         "HTTP404: file not found"
         "Segment exceeds specified bandwidth for variant"
         "Unsupported crypt format"
         */
        if notification.name == NSNotification.Name.AVPlayerItemPlaybackStalled {
            self.showNetworkErrorPopup()

        }
    }
    
    /// 네트워크 에러 팝업 노출
    private func showNetworkErrorPopup() {
        self.pause()
        
        self.playStatus = .none
        
        if let videoCell = self.webPrdVideoCell {
            videoCell.imgView.isHidden = false
            videoCell.dimView.backgroundColor = UIColor.getColor("000000", alpha: 0.15)
        }
        
        if self.isPlayingMiniView {
            self.miniPlayerClose()
        }
        
        if let alert = Mocha_Alert.init(title: "서비스가 원활하지 않습니다.\n잠시 후 다시 시도해 주세요.",
                                        maintitle: nil, delegate: self,
                                        buttonTitle: ["확인"]) {
            alert.tag = 20426
            
            var isShow: Bool = false
            for alertView in applicationDelegate.window.subviews {
                if let view = alertView as? Mocha_Alert,
                    view.tag == 20426 {
                    isShow = true
                    break
                }
            }
            
            if !isShow {
                applicationDelegate.window.addSubview(alert)
            }
        }
    }
    
    
// MARK:- public functions
    /// 전체화면 플레이어뷰컨트롤러 설정
    func setFullScreenView() {
        if self.webPrdViewFullViewController == nil {
            self.webPrdViewFullViewController = WebPrdVideoFullViewController(nibName: WebPrdVideoFullViewController.className, bundle: nil)
            self.webPrdViewFullViewController!.orientationType = .landscape
            self.webPrdViewFullViewController!.webPrdPlayerDelegate = self
            self.webPrdViewFullViewController!.aTarget = self.aTarget
        }
    }
    
    /// 브라이트코브 Id를 이용하여 비디오 객체 설정
    func requestContentFromPlaybackService(id: String) {
        print("BrigtCove Start ====== \(Date())")
        playbackService.findVideo(withVideoID: id, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            print("BrigtCove End ====== \(Date())")
            
            
            if let duration = jsonResponse?["duration"] {
                let duration1000 = duration as! TimeInterval
                self.durationFromJson = duration1000 / 1000
            }
            
            if let v = video {
                self.brightCoveVideo = v
                
                if self.isShowNetworkPopup() == false,
                    self.isAutoPlaying, let playBackVC = self.playbackController {
                    playBackVC.setVideos([v] as NSArray)
                    self.aTarget?.sendBhrGbnEvent("PLAY", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
                }
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.prevCachingImgView.isHidden = true
                }
                self.setPageControl()
                self.playbackController?.delegate = nil
                self.playbackController = nil
                self.playBtn.isHidden = true
                
                if let cell = self.webPrdVideoCell {
                    cell.playBtn.isHidden = true
                    cell.dimView.isHidden = true
                }
                self.videoType = .none
//                Mocha_ToastMessage.toast(withDuration: 2.0, andText: Const.Text.bcove_error.localized, in: self.applicationDelegate.window)
            }
        }
    }
    
    // BrightCove 미니버전으로 화면 전환여부 함수
    @objc func updateBrightCoveView(contentOffset posY: CGFloat, target: ResultWebViewController) {
        // 사용자가 플레이를 하지 않은 경우 미니플레이어가 나타나지 않는다
        if self.playStatus != .play {
            
            if posY < getAppFullWidth() {
                
                if isPlayingMiniView {
                    // 단품 네이티브에 들어오자마자 isPlayingMiniView = true이며,
                    // 아래 함수를 호출함으로써 틀고정 javascript를 호출하기 위함.
                    miniPlayerClose()
                }
                return
            }
            
            if self.isPlayingMiniView {
                return
            }
    
            return
        }
        
        if posY > getAppFullWidth() {
            // 상단 영상영역을 벗어났을때
            if isPlayingMiniView {
                return
            }
            
            if let miniView = self.miniPlayerView {
                if let data = self.webProduct, "DEAL" == data.prdTypeCode  {
                    self.isPlayingMiniView = false
                    return
                }
                
                self.isPlayingMiniView = true
                if self.videoType == .live || self.videoType == .mp4 {
                    if let playerLayer = self.livePlayerLayer {
                        
                        if self.videoOrientation == .portrait || self.videoOrientation == .square {
                            // 세로 영상 or 정사각 영상
                            miniView.addLivePlayerLayer(playerLayer, isLandscape: false)
                        } else {
                            miniView.addLivePlayerLayer(playerLayer)
                        }
                    }
                } else if self.videoType == .brightCove {
                    
                    if let view = self.playerView {
                        
                        if self.videoOrientation == .portrait || self.videoOrientation == .square {
                            // 세로 영상 or 정사각 영상
                            miniView.addBrightCoveView(view, isLandscape: false)
                        } else {
                            miniView.addBrightCoveView(view)
                        }
                    }
                }
                
                miniView.bringSubviewToFront(target.view)
                miniView.isHidden = false
            }
            
            // 웹으로 미니플레이어가 나타났음을 알려야함 -> 틀고정 위치값 조정
            if let vc = self.aTarget, let miniView = self.miniPlayerView, let data = self.webProduct {
                let statusBarHeight = isiPhoneXseries() ? getStatusBarHeight() + 5 : getStatusBarHeight()
                let height = "\(miniView.frame.origin.y + miniView.frame.height - statusBarHeight)"
                var jspPrefix = ""
                if "DEAL" == data.prdTypeCode {
                    jspPrefix = "dealAppController."
                } else if "PRD" == data.prdTypeCode || "PRD_FRESH" == data.prdTypeCode || "PRD_THEBANCHAN" == data.prdTypeCode {
                    jspPrefix = "prdAppController."
                }
                
                if jspPrefix.isEmpty == false {
                    vc.callJscriptMethod(jspPrefix + "setShowMiniPlayer(\(height));")
                }
            }
            
        } else {
            if isPlayingMiniView {
                miniPlayerClose()
            }
        }
    }
    
    /// 재생이 완료되면 호출해야하는 함수
    private func playEnd() {
        if let videoCell = self.webPrdVideoCell {
            videoCell.playEnd()
        }
        
        if let miniPlayer = self.miniPlayerView {
            miniPlayer.playEnd()
        }
        
        if let fullVC = self.webPrdViewFullViewController {
            fullVC.playEnd()
        }
        
        if self.videoType == .live {
            self.playBtn.isHidden = true
        }
        self.playStatus = .end
    }
    
    func setTimer(){
        if let timer = self.timer {
            if timer.isValid == false {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallBack), userInfo: nil, repeats: true)
                RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
            }
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallBack), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    /// 타이머 selector 함수
    @objc func timerCallBack() {
        if self.videoType == .none {
            return
        }
        
        var timeStr = ""
        if self.videoType == .live {
            guard let data = self.videoInfo else { return }
            let df = DateFormatter()
            df.dateFormat = "yyyyMMddHHmmss"
            
            guard let endDate = df.date(from: data.endTime) else { return }
            self.leftTime = endDate.timeOfDayInterval(toDate: Date())
            timeStr = self.leftTime.getPlayerLeftTime(videoType: self.videoType)
        
        } else if self.videoType == .mp4 {
            
            guard let player = self.videoPlayer, let item = player.currentItem else { return }
            self.currentTime = item.currentTime().seconds
            let leftTime = item.duration - item.currentTime()
            self.leftTime = TimeInterval(leftTime.seconds)
            timeStr = self.leftTime.getPlayerLeftTime(videoType: self.videoType)
                        
        } else if self.videoType == .brightCove {
            // BrightCove Delegate에서 시간을 설정하고 있다!
            return
        }
        
        print("leftString : " + timeStr)
        if self.leftTime <= 0,
            let timer = self.timer {
            timer.invalidate()
            
            //  방송종료
            self.pause()
            self.playEnd()
            
            if let view = self.webPrdVideoCell, self.leftTime <= 0 {
                view.playTimeLbl.text = ""
            }
            
            if self.videoType == .live {
                // 라이브 방송 종료 후 플레이버튼 숨기기
                self.playBtn.isEnabled = true
            }
            return
        }
        
        // VideoCell 남은시간 설정
        if let view = self.webPrdVideoCell {
            if self.videoType == .live ||
                (self.playStatus == .play || self.playStatus == .pause) {
                view.playTimeLbl.text = timeStr
            }
        }
        
        // 미니플레이어 남은시간 설정
        if let view = self.miniPlayerView {
            view.playtimeLbl.text = timeStr
        }
        
        // 전체플레이어 남은시간 설정
        if let vc = self.webPrdViewFullViewController, vc.isTouchingUser == false {
            vc.durationTimeLbl.text = self.durationTime.getPlayerLeftTime(videoType: self.videoType, isFullScreen: true)
            vc.currentTimeLbl.text = self.currentTime.getPlayerLeftTime(videoType: self.videoType, isFullScreen: true)
            let value = Float(self.currentTime)
            vc.slider.setValue(value, animated: true)
        }
    }
    
    /// 방송알림 설정완료 후 jsp로 호출되는 함수
    @objc func broadAlertSet() {
        if let view = self.broadView {
            view.setBroadNotiBtnUI(isNoti: true)
        }
    }
    
    /// 방송알림 취소 후 jsp로 호출되는 함수
    @objc func broadAlertCancel() {
        if let view = self.broadView {
            view.setBroadNotiBtnUI(isNoti: false)
        }
    }
    
    /// 찜 설정 후 호출되는 함수
    @objc func zzimSet() {
        if let view = self.priceView {
            view.setZzimBtnUI(isOn: true)
        }
    }
    
    /// 찜 취소 후 호출되는 함수
    @objc func zzimCancel() {
        if let view = self.priceView {
            view.setZzimBtnUI(isOn: false)
        }
    }
    
    /// 영상 정지 요청
    @objc func pauseFromWeb() {
        self.beforePlayStatus = self.playStatus
        if self.playStatus == .play {
            self.pause(isUserEvent: false)
        }
    }
    
    @objc func playFromWeb() {
        if self.beforePlayStatus == .play {
            self.play()
        }
    }
    
    /// 음소거 설정
    @objc func isMuteFromWeb(value: Bool) {
        self.isMute(value)
    }
    
    /// Web 영상플레이어 축소화면 클릭시 미니플레이어화면 숨기기
    @objc func hideMiniPlayerView() {
        if let view = self.miniPlayerView {
            view.isHidden = true
            // 웹으로 미니플레이어가 사라졌음을 알려야함 -> 틀고정 위치값 조정
            if let vc = self.aTarget, let naviBar = vc.webPrdNaviBarView, let data = self.webProduct {
                let height = "\(naviBar.frame.height)"

                var jspPrefix = ""
                if "DEAL" == data.prdTypeCode {
                    jspPrefix = "dealAppController."
                } else if "PRD" == data.prdTypeCode || "PRD_FRESH" == data.prdTypeCode || "PRD_THEBANCHAN" == data.prdTypeCode {
                    jspPrefix = "prdAppController."
                }
                
                if jspPrefix.isEmpty == false {
                    vc.callJscriptMethod(jspPrefix + "setHideMiniPlayer(\(height));")
                }
            }
        }
    }
    
    /// Web 영상플레이어 전체화면 클릭시 미니플레이어화면 보이기
    @objc func showMiniPlayerView() {
        if let view = self.miniPlayerView, self.isPlayingMiniView, view.isHidden == true {
            view.isHidden = false
            
            if let vc = self.aTarget, let miniView = self.miniPlayerView, let data = self.webProduct {
                let statusBarHeight = isiPhoneXseries() ? getStatusBarHeight() + 5 : getStatusBarHeight()
                let height = "\(miniView.frame.origin.y + miniView.frame.height - statusBarHeight)"
                var jspPrefix = ""
                if "DEAL" == data.prdTypeCode {
                    jspPrefix = "dealAppController."
                } else if "PRD" == data.prdTypeCode || "PRD_FRESH" == data.prdTypeCode || "PRD_THEBANCHAN" == data.prdTypeCode {
                    jspPrefix = "prdAppController."
                }
                
                if jspPrefix.isEmpty == false {
                    vc.callJscriptMethod(jspPrefix + "setShowMiniPlayer(\(height));")
                }
            }
            
        }
    }
    
    /// 미니플레이어 여부 확인
    @objc func isMiniplayer() -> Bool {
        if self.miniPlayerView != nil, self.isPlayingMiniView {
            return true
        }
        else {
            return false
        }
    }
    
    @objc func removeMiniPlayerView() {
        if let view = self.miniPlayerView {
            view.isHidden = true
            self.pauseFromWeb()
            self.miniPlayerView?.removeFromSuperview()
            self.miniPlayerView = nil
        }
    }
}

// MARK:- BCOVPlaybackControllerDelegate
extension WebPrdView: BCOVPlaybackControllerDelegate {
    /// 플레이어 Session Delegate 함수
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        // BrightCove player를 나의 플레이어로 넘겨받는다...?
        self.videoPlayer = session.player
    }

    /// 플레이 시간 Delegate 함수
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didChangeDuration duration: TimeInterval) {
        self.durationTime = duration
        
        /*
         // Play하기 전까지는 재생시간을 표시하지 않는다.
         
        var timeStr: String = ""
        if duration.isNan || duration.isInfinite  {
            timeStr = ""
        } else {
            timeStr = duration.getPlayerLeftTime()
        }
        
        // VideoCell 남은시간 설정
        if let view = self.webPrdVideoCell {
            view.playTimeLbl.text = timeStr
        }
        
        // 미니플레이어 남은시간 설정
        if let view = self.miniPlayerView {
            view.playtimeLbl.text = timeStr
        }
        
        // 전체플레이어 남은시간 설정
        if let vc = self.webPrdViewFullViewController {
            // vc.playTimeLbl.text = timeStr
            vc.currentTimeLbl.text = timeStr
        }
         */
    }
    
    /// 플레이에 따른 프로그레스 Delegate 함수
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        // 플레이 될때 호출 - 플레이시간을 여기서 설정할수 있다.
        self.currentTime = progress
        self.leftTime = self.durationTime - progress
        
        if self.leftTime.isNaN || self.leftTime.isInfinite {
            return
        }
        
        // 영상의 가로/세로/정사각 구분
        if self.videoOrientation == .none {
            
            let size = session.playerLayer.videoRect.size
            if size.height > size.width {
                self.videoOrientation = .portrait
            } else if size.height < size.width {
                self.videoOrientation = .landscape
            } else {
                self.videoOrientation = .square
            }
        }
        
        let timeStr = self.leftTime.getPlayerLeftTime(videoType: .brightCove)
        if self.leftTime  <= 0 {
            return
        }
        
        // VideoCell 남은시간 설정
        if let view = self.webPrdVideoCell {
            view.playTimeLbl.text = timeStr
        }
        
        // 미니플레이어 남은시간 설정
        if let view = self.miniPlayerView {
            view.playtimeLbl.text = timeStr
        }
        
        // 전체플레이어 남은시간 설정
        if let vc = self.webPrdViewFullViewController, vc.isTouchingUser == false {
            vc.durationTimeLbl.text = self.durationTime.getPlayerLeftTime(videoType: self.videoType, isFullScreen: true)
            vc.currentTimeLbl.text = self.currentTime.getPlayerLeftTime(videoType: self.videoType, isFullScreen: true)
            let value = Float(self.currentTime)
            vc.slider.setValue(value, animated: true)
        }
    }
    
    /// 플레이어 LifeCycle Delegate 함수
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!) {
        switch lifecycleEvent.eventType {
        case kBCOVPlaybackSessionLifecycleEventReady:
            // 영상 재생 준비완료!
            print("kBCOVPlaybackSessionLifecycleEvent[Ready] called")
            self.playStatus = .ready
            self.play()
            break
        case kBCOVPlaybackSessionLifecycleEventPlay:
            // 영상 재생시작
            print("kBCOVPlaybackSessionLifecycleEvent[Play] called")
            break
        case kBCOVPlaybackSessionLifecycleEventPause:
            // 영상 일시정지
            print("kBCOVPlaybackSessionLifecycleEvent[Pause] called")
            
            // 간혈적으로 BrightCove 자동재생시에 일시정지가 되는 경우가 있다.
            if self.playStatus == .play {
                self.play()
            }
            break
        case kBCOVPlaybackSessionLifecycleEventEnd:
            // 영상 종료
            print("kBCOVPlaybackSessionLifecycleEvent[End] called")
            self.playEnd()
        case kBCOVPlaybackSessionLifecycleEventFail:
            // 영상 로딩 실패?
            print("BrightCove Player is Fail")
            break
        case kBCOVPlaybackSessionLifecycleEventPlaybackStalled:
            // 영상이 네트워크 단절 등으로 종료될때
            print("kBCOVPlaybackSessionLifecycleEvent[PlaybackStalled]")
            showNetworkErrorPopup()
            break
        default:
            print("kBCOVPlaybackSessionLifecycleEvent[WTF????] " + lifecycleEvent.eventType)
            break
        }
    }
}

// MARK:- WebPrdViewPlayerDelegate
extension WebPrdView: WebPrdPlayerDelegate {
    
    func play() {
        if NetworkManager.shared.currentReachabilityStatus() == .notReachable ||
            NetworkManager.shared.currentReachabilityStatus() == .unknown {
            
            // 네트워크 에러 팝업
            self.showNetworkErrorPopup()
            return
        }
        
        
        if self.playStatus == .none {
            print("kBCOVPlaybackSessionLifecycleEvent[None] called")

            if self.videoType == .live || self.videoType == .mp4 {
                guard let url = self.videoUrl else {
                    print("비디오 링크 오류!!!")
                    return
                }
                // ready가 되면 자동재생되도록 플래그 설정
                self.isAutoPlaying = true
                setPlayer(url: url)
            } else if self.videoType == .brightCove {
                if let v = self.brightCoveVideo, let playBackVC = self.playbackController {
                    playBackVC.setVideos([v] as NSArray)
                }
            }
            return
        }
        
        self.isUserEventPause = false
        if let player = self.videoPlayer {
            player.isMuted = "Y" ==  DataManager.shared()?.strGlobalSoundForWebPrd ? false : true
        }
        
        setTimer()
        
        if let videoCell = self.webPrdVideoCell {
            videoCell.play()
        }
        
        if let miniPlayer = self.miniPlayerView {
            miniPlayer.play()
        }
        
        if let fullVC = self.webPrdViewFullViewController {
            fullVC.play()
        }
        
        if self.videoType == .live || self.videoType == .mp4 {
            
            if let player = self.videoPlayer {
                player.play()
            }
        } else if let playBackVC = self.playbackController {
            playBackVC.play()
        }
        self.playStatus = .play
        
        // App에서 영상 플레이시 Web 전달 -> 웹 플레이어 정지요청
        if let vc = self.aTarget, let data = self.webProduct {
            var jspPrefix = ""
            if "DEAL" == data.prdTypeCode {
                jspPrefix = "dealAppController."
            } else if "PRD" == data.prdTypeCode || "PRD_FRESH" == data.prdTypeCode || "PRD_THEBANCHAN" == data.prdTypeCode {
                jspPrefix = "prdAppController."
            }
            
            if jspPrefix.isEmpty == false {
                vc.callJscriptMethod(jspPrefix + "playStatus('Y');")
            }
            
        }
    }
    
    func pause(isUserEvent: Bool = true) {
        self.isUserEventPause = isUserEvent
        if let videoCell = self.webPrdVideoCell {
            videoCell.pause()
        }
        
        if let miniPlayer = self.miniPlayerView {
            miniPlayer.pause()
        }
        
        if let fullVC = self.webPrdViewFullViewController {
            fullVC.pause()
        }

        if let player = self.videoPlayer {
            player.pause()
        }
        self.playStatus = .pause
    }
    
    func replay() {
        setTimer()
        
        if self.videoType == .brightCove {
            if let playBackVC = self.playbackController {
                playBackVC.pause()
                playBackVC.seek(to: .zero) { (isFinished) in
                    if isFinished {
                        if let videoCell = self.webPrdVideoCell {
                            videoCell.replay()
                            videoCell.play()
                        }
                        
                        if let miniPlayer = self.miniPlayerView {
                            miniPlayer.replay()
                            miniPlayer.play()
                        }
                        
                        if let fullVC = self.webPrdViewFullViewController {
                            fullVC.replay()
                            fullVC.play()
                        }
                        
                        if let player = self.videoPlayer {
                            player.play()
                        }
                        self.playStatus = .play
                    }
                }
            }
        } else if let player = self.videoPlayer, let item = player.currentItem {
            item.seek(to: .zero)
            let durationTime = TimeInterval(item.duration.seconds)
            if let videoCell = self.webPrdVideoCell {
                videoCell.playTimeLbl.text = durationTime.getPlayerLeftTime(videoType: self.videoType)
                videoCell.replay()
                videoCell.play()
            }
            
            if let miniPlayer = self.miniPlayerView {
                miniPlayer.playtimeLbl.text = durationTime.getPlayerLeftTime(videoType: self.videoType)
                miniPlayer.replay()
                miniPlayer.play()
            }
            
            if let fullVC = self.webPrdViewFullViewController {
//                fullVC.playTimeLbl.text = durationTime.getPlayerLeftTime(videoType: self.videoType)
                fullVC.replay()
                fullVC.play()
            }
            
            if let player = self.videoPlayer {
                player.play()
            }
            self.playStatus = .play
        }
    }
    
    func isMute(_ value: Bool) {
        
        if let player = self.videoPlayer {
            player.isMuted = value
        }
        
        if value {
            // 음소거
            DataManager.shared()?.strGlobalSoundForWebPrd = "N"
        } else {
            // 소리 on
            DataManager.shared()?.strGlobalSoundForWebPrd = "Y"
        }
        
        if let videoCell = self.webPrdVideoCell {
            videoCell.speakerBtn.isSelected = !value
        }
        
        if let fullVC = self.webPrdViewFullViewController {
            fullVC.speakerBtn.isSelected = !value
        }
        
        
        // APP에서 영상 음소거시 Web으로 전달 - 웹에서 음소거 상태값 반영
        if let vc = self.aTarget, let data = self.webProduct {
            
            var jspPrefix = ""
            if "DEAL" == data.prdTypeCode {
                jspPrefix = "dealAppController."
            } else if "PRD" == data.prdTypeCode || "PRD_FRESH" == data.prdTypeCode || "PRD_THEBANCHAN" == data.prdTypeCode {
                jspPrefix = "prdAppController."
            }
            
            if jspPrefix.isEmpty == false {
                
                if value {
                    // 음소거
                    vc.callJscriptMethod(jspPrefix + "muteStatus('Y');")
                } else {
                    // 소리 on
                    vc.callJscriptMethod(jspPrefix + "muteStatus('N');")
                }
            }
            
        }
    }
    
    func showScreenFull(isFull: Bool) {
        
        if isFull {
            if NetworkManager.shared.currentReachabilityStatus() == .notReachable ||
                NetworkManager.shared.currentReachabilityStatus() == .unknown {
                
                // 네트워크 에러 팝업
                self.showNetworkErrorPopup()
                return
            }
            
            setFullScreenView()
            if let vc = self.webPrdViewFullViewController {
                vc.modalPresentationStyle = .overFullScreen
                vc.videoType = self.videoType
                vc.sliderMaxValue = Float(self.durationTime)
                
                if self.videoOrientation == .portrait {
                    vc.orientationType = .portrait
                }
                
                applicationDelegate.window.rootViewController?.present(vc, animated: true, completion: {
                    // 재생중으로 버튼 변경
                    vc.playBtn.isSelected = true
                    // 음소거 버튼 설정
                    if let player = self.videoPlayer {
                        vc.speakerBtn.isSelected = !player.isMuted
                    }
                    
                    if self.videoType == .live || self.videoType == .mp4 {
                        if let playerLayer = self.livePlayerLayer {
                            vc.addLivePlayerLayer(playerLayer)
                        }
                    } else if self.videoType == .brightCove {
                        vc.addBrightCoveView(self.playerView)
                    }
                    
                    if self.playStatus == .play {
                        vc.play()
                    } else if self.playStatus == .pause {
                        vc.pause()
                    } else if self.playStatus == .end {
                        vc.playEnd()
                    }
                    
                })
            }
        } else {
            changePlayerView()
            self.aTarget?.sendAmplitudeAndMseq(withAction: "대표_동영상_Mini")
        }
    }
    
    func miniPlayerClose() {
        self.isPlayingMiniView = false
        if let miniView = self.miniPlayerView {
            miniView.isHidden = true
            
            // 웹으로 미니플레이어가 사라졌음을 알려야함 -> 틀고정 위치값 조정
            if let vc = self.aTarget, let naviBar = vc.webPrdNaviBarView, let data = self.webProduct {
                let height = "\(naviBar.frame.height)"

                var jspPrefix = ""
                if "DEAL" == data.prdTypeCode {
                    jspPrefix = "dealAppController."
                } else if "PRD" == data.prdTypeCode || "PRD_FRESH" == data.prdTypeCode || "PRD_THEBANCHAN" == data.prdTypeCode {
                    jspPrefix = "prdAppController."
                }
                
                if jspPrefix.isEmpty == false {
                    vc.callJscriptMethod(jspPrefix + "setHideMiniPlayer(\(height));")
                }
            }
        }
        
        changePlayerView()
    }
    
    func changePlayerView() {
        if  let videoCell = self.webPrdVideoCell {
            videoCell.layoutIfNeeded()
            if self.videoType == .live || self.videoType == .mp4 {
                if let playerLayer = self.livePlayerLayer {
                    videoCell.addLivePlayerLayer(playerLayer, videoType: self.videoType)
                }
            } else if self.videoType == .brightCove {
                if let view = self.playerView {
                    videoCell.addBrightCoveView(view, videoType: self.videoType)
                }
            }
//            videoCell.videoContainerView.layoutIfNeeded()
        }
    }
    
    /// 진행바 움직이면 호출
    func seekTo(value: Float, videoType: VideoType) {
        if videoType == .none || videoType == .live {
            return
        }
        
        
        if videoType == .mp4, let player = self.videoPlayer, let _ = player.currentItem {
            let cmTime = CMTimeMakeWithSeconds(Float64(value), preferredTimescale: 1)
            player.seek(to: cmTime)
        } else if videoType == .brightCove {
            let cmTime = CMTimeMakeWithSeconds(Float64(value), preferredTimescale: 1)
            
            if let playBackVC = self.playbackController {
                playBackVC.seek(to: cmTime, completionHandler: nil)
            }
        }
        
        // 영상이 종료(end)상태일 때 진행바를 움직이면 재생되도록 수정
        if self.playStatus == .end {
            self.play()
        }
    }
    
    /// 현재 영상 상태값 리턴
    func getPlayStatus() -> PlayStatus {
        return self.playStatus
    }
    
    /// 브라이트코브 id값으로 다시 영상 찾기
    func requestBrightCoveFindVideo() {
        requestContentFromPlaybackService(id: self.brightCoveID)
    }
    
    func getTotalTime() -> TimeInterval {
        return self.durationFromJson
    }
    
    func getCurrentTime() -> TimeInterval {
        return self.currentTime
    }
}

// MARK:- UICollectionViewDelegate & DataSource
extension WebPrdView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrImageUrls.count <= 0, let _ = self.videoInfo {
            // 비디오 객체는 있지만, 이미지가 없는 경우
            return 1
        } else if self.arrImageUrls.count <= 0 {
            // 이미지 리스트가 없는 경우 -> gsshpo no이미지를 노출??
            return 1
        }
        return self.arrImageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let imgUrl = self.arrImageUrls[safe: indexPath.row] {
            
            // 이미지 리스트가 있는 경우
            if indexPath.row == 0 && self.videoType != .none {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebPrdVideoCell.reusableIdentifier, for: indexPath) as? WebPrdVideoCell else {
                    return UICollectionViewCell()
                }

                let isShowNetworkPopup = (self.isAutoPlaying == true && self.isShowNetworkPopup())
                cell.setData(imgUrl, target: self.aTarget, isShowNetworkPopup: isShowNetworkPopup)
                
                
                if self.videoType == .live || self.videoType == .mp4 {
                    if let playerLayer = self.livePlayerLayer {
                        cell.addLivePlayerLayer(playerLayer, videoType: self.videoType)
                    }
                } else if self.videoType == .brightCove {
                    if let bcPlayerView = self.playerView {
                        cell.addBrightCoveView(bcPlayerView, videoType: self.videoType)
                    }
                }

                cell.webPrdPlayerDelegate = self
                self.webPrdVideoCell = cell
                return cell
            }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebPrdCell.reusableIdentifier, for: indexPath) as? WebPrdCell else {
                return UICollectionViewCell()
            }
            
            cell.setData(imgUrl, indexPath: indexPath)
            cell.parentView = self
            if indexPath.row == 0 {
                cell.setBenefits(urls: self.benefitUrls)
            }
            return cell
        }
        
        
        // 이미지 리스트가 없는 경우 이하로직 진행
        if self.videoInfo != nil {
            // 영상객체가 있는 경우
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebPrdVideoCell.reusableIdentifier, for: indexPath) as? WebPrdVideoCell else {
                return UICollectionViewCell()
            }
            if self.playerView != nil {
                
                let isShowNetworkPopup = (self.isAutoPlaying == true && self.isShowNetworkPopup())
                
                cell.setData("", target: self.aTarget, isShowNetworkPopup: isShowNetworkPopup)
                if self.videoType == .live || self.videoType == .mp4 {
                    if let playerLayer = self.livePlayerLayer {
                        cell.addLivePlayerLayer(playerLayer, videoType: self.videoType)
                    }
                } else if self.videoType == .brightCove {
                    cell.addBrightCoveView(self.playerView, videoType: self.videoType)
                }
            }
            cell.webPrdPlayerDelegate = self
            self.webPrdVideoCell = cell
            return cell
        }
        
        // 이미지 리스트, 비디오객체 모두 없는 경우 -> 노이미지
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebPrdCell.reusableIdentifier, for: indexPath) as? WebPrdCell else {
            return UICollectionViewCell()
        }
        
        cell.setData("", indexPath: indexPath)
        cell.parentView = self
        if indexPath.row == 0 {
            cell.setBenefits(urls: self.benefitUrls)
        }
        return cell
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        setNoteCnt(index + 1)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        setNoteCnt(index + 1)
        
        // 영상 버튼 컨트롤
        updatePlayBtnUI(index)
        
        // 영상이 있다면, CollectionView 스크롤할때 영상정지/플레이 해야됨
        changePlayPause(index)
        

    }

    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging")
//
//        if !decelerate {
//            let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//            setNoteCnt(index + 1)
//
//            // 영상 버튼 컨트롤
//            updatePlayBtnUI(index)
//
//            // 영상이 있다면, CollectionView 스크롤할때 영상정지/플레이 해야됨
//            changePlayPause(index)
//        }
//    }
}

// UICollectionViewDelegateFlowLayout
extension WebPrdView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewWidth.constant,
                      height: self.collectionViewWidth.constant)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

// MARK:- Button Action functions
extension WebPrdView {
    @IBAction func playBtnAction(_ sender: UIButton) {
        if self.videoType == .none {
            // 영상이 없으면 패스~ (이미지만 있을때는 playBtn이 안나오지만 혹시 모르니 넣음)
            return
        }
        
        UIView.animate(withDuration: 0.0, animations: {
            self.collectionView.setContentOffset(.zero, animated: true)
            self.playBtn.isHidden = true
            self.setNoteCnt(1)
        }) { (_) in
            // 일시정지가 된 경우
            if self.isShowNetworkPopup() {
                // 자동재생 안하고 네트워크 팝업이 노출되야 함
                if let cell = self.webPrdVideoCell {
                    cell.networkPopupHidden(false)
                }
                return
            }
            
            if self.playStatus == .end {
                self.replay()
            } else {
                self.play()
            }
        }
    }
}

// MARK:- Mocha_AlertDelegate
extension WebPrdView: Mocha_AlertDelegate {
    func customAlert(_ alert: UIView!, clickedButtonAt index: Int) {
        switch alert.tag {
        case 1000:
            print("Player Error : Show Popup")
            if self.playStatus == .play {
                self.pause()
            }
        default:
            break
        }
    }
}
