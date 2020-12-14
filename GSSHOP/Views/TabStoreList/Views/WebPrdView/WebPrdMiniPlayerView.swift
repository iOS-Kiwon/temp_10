//
//  WebPrdMiniPlayerView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/11.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdMiniPlayerView: UIView {
    
    static public let WEB_PRD_MINI_PLAYER_HEIGHT: CGFloat = 64
    static public let WEB_PRD_MINI_PLAYER_PORTRATE_WIDTH: CGFloat = 64
    static public let WEB_PRD_MINI_PLAYER_PORTRATE_HEIGHT: CGFloat = 114

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playtimeLbl: UILabel!
    
    private var playerBaseView = UIView()
    
    /// 동영상 플레이 종료여부 Flag
    private var isEndPlaying: Bool = false
    
    ///  WebPrdView에서 BrightCove 컨트롤을 위한 델리게이트 객체
    var webPrdPlayerDelegate: WebPrdPlayerDelegate?
    /// 방송타입
    var videoType: VideoType = .none
    /// WebPrdVideoView를 소유한 TargetViewController - 무조건 ResultWebViewController
    weak var aTarget: ResultWebViewController?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// 브라이트코브 뷰를 미니플레이어에 add 한다
    func addBrightCoveView(_ playView: UIView, isLandscape: Bool = true) {
        self.playerView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.playerView.clipsToBounds = true
        
        self.playerBaseView = UIView()
        self.playerBaseView.backgroundColor = .clear
        
        self.playerBaseView.addSubview(playView)
        playView.translatesAutoresizingMaskIntoConstraints = false

        
        self.playerView.addSubview(self.playerBaseView)
        self.playerBaseView.translatesAutoresizingMaskIntoConstraints = false
        
        if isLandscape {
            // 가로 영상
            NSLayoutConstraint.activate([
                playView.topAnchor.constraint(equalTo: self.playerBaseView.topAnchor),
                playView.leadingAnchor.constraint(equalTo: self.playerBaseView.leadingAnchor),
                playView.trailingAnchor.constraint(equalTo: self.playerBaseView.trailingAnchor),
                playView.bottomAnchor.constraint(equalTo: self.playerBaseView.bottomAnchor),
                
                
                self.playerBaseView.topAnchor.constraint(equalTo: self.playerView.topAnchor),
                self.playerBaseView.leadingAnchor.constraint(equalTo: self.playerView.leadingAnchor),
                self.playerBaseView.trailingAnchor.constraint(equalTo: self.playerView.trailingAnchor),
                self.playerBaseView.bottomAnchor.constraint(equalTo: self.playerView.bottomAnchor)
                
                
                
            ])
        } else {
            // 세로 영상 or 정사각 영상
            NSLayoutConstraint.activate([
                playView.topAnchor.constraint(equalTo: self.playerBaseView.topAnchor),
                playView.leadingAnchor.constraint(equalTo: self.playerBaseView.leadingAnchor),
                playView.trailingAnchor.constraint(equalTo: self.playerBaseView.trailingAnchor),
                playView.bottomAnchor.constraint(equalTo: self.playerBaseView.bottomAnchor),
                playView.widthAnchor.constraint(equalToConstant: WebPrdMiniPlayerView.WEB_PRD_MINI_PLAYER_PORTRATE_WIDTH),
                playView.heightAnchor.constraint(equalToConstant: WebPrdMiniPlayerView.WEB_PRD_MINI_PLAYER_PORTRATE_HEIGHT),
                
                self.playerBaseView.centerYAnchor.constraint(equalTo: self.playerView.centerYAnchor),
                self.playerBaseView.centerXAnchor.constraint(equalTo: self.playerView.centerXAnchor)
            ])
        }
    }
    
    /// 생방송인 경우, layer를 add 한다
    func addLivePlayerLayer(_ playerLayer: AVPlayerLayer, isLandscape: Bool = true) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if isLandscape {
            // 미니플레이어는 꽉차게 나오도록
            playerLayer.frame = self.playerView.frame
            playerLayer.videoGravity = .resizeAspect
        } else {
            // 세로 영상 or 정사각 영상
            let width = WebPrdMiniPlayerView.WEB_PRD_MINI_PLAYER_PORTRATE_WIDTH
            let height = WebPrdMiniPlayerView.WEB_PRD_MINI_PLAYER_PORTRATE_HEIGHT
            
            let posX = self.playerView.center.x - width/2
            let posY = 0 - (height/2 - self.playerView.center.y)
                
            playerLayer.frame.origin = CGPoint(x: posX, y: posY)
            playerLayer.frame.size = CGSize(width: width, height: height)
            playerLayer.videoGravity = .resizeAspectFill
            
            self.playerView.layer.masksToBounds = true
        }
        
        self.playerView.layer.addSublayer(playerLayer)
        CATransaction.commit()
    }
    
    
    /// 플레이어 재생
    func play() {
        self.isEndPlaying = false
        self.playBtn.isSelected = true
    }
    
    /// 플레이어 일시정지
    func pause() {
        self.playBtn.isSelected = false
    }
    
    /// 플레이어 다시재생
    func replay() {
        self.playBtn.setImage(UIImage(named: Const.Image.btn_play_mini_nor.name), for: .normal)
        self.playBtn.isSelected = true
    }
    
    /// 플레이가 완료 되었을때 동작함수 - WebPrdView에서 호출한다
    func playEnd() {
        self.isEndPlaying = true
        self.playBtn.setImage(UIImage(named: Const.Image.btn_replay_mini_nor.name), for: .normal)
        self.playBtn.isSelected = false
        if self.videoType == .live {
            self.playtimeLbl.text = "방송이 종료되었습니다."
            self.playBtn.isHidden = true
        } else {
            self.playtimeLbl.text = TimeInterval.zero.getPlayerLeftTime(videoType: self.videoType)
        }
    }
    
    @IBAction func playBtnAction(_ sender: UIButton) {

        if sender.isSelected {
            // puase
            self.webPrdPlayerDelegate?.pause(isUserEvent: true)
            self.pause()
            
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

    @IBAction func closeBtnAction(_ sender: UIButton) {
        // 닫기(x) 누르면 해당 뷰 없어지면서 일시정지
        self.webPrdPlayerDelegate?.miniPlayerClose()
        self.webPrdPlayerDelegate?.pause(isUserEvent: true)
        
    }
    
    @IBAction func playerViewBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget {
            vc.wview.scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
}
