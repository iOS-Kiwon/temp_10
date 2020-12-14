//
//  GR_BRD_GBATypeCell.swift
//  GSSHOP
//
//  Created by neocyon MacBook on 2020/08/12.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class GR_BRD_GBATypeCell: UITableViewCell {

    
    @IBOutlet weak var viewTopBrandInfo: UIView!
    @IBOutlet weak var lblTopBrandTitle: UILabel!
    @IBOutlet weak var lcontViewTopBrandInfoHeight : NSLayoutConstraint!
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var viewVideoAndImage: UIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var imgVideoThumb: UIImageView!
    
    @IBOutlet weak var viewImages: UIView!
    @IBOutlet weak var lcontViewVideoAndImageHeight : NSLayoutConstraint!
    @IBOutlet weak var viewImageCounts: UIView!
    @IBOutlet weak var lblImageCounts: UILabel!
    
    @IBOutlet weak var viewMiddleTitle: UIView!
    @IBOutlet weak var lconstLblMiddleTitleTop: NSLayoutConstraint!
    @IBOutlet weak var lconstViewMiddleTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var imgMiddleBrandImage: UIImageView!
    @IBOutlet weak var lcontMiddleBrandImageWidth: NSLayoutConstraint!
    @IBOutlet weak var lcontViewMiddleTitleTop : NSLayoutConstraint!
    
    @IBOutlet weak var viewMiddleDesc: UIView!
    @IBOutlet weak var lblMiddleTitle: UILabel!
    @IBOutlet weak var lblMiddleDesc: UILabel!
    
    @IBOutlet weak var lcontCollectionPrdTop : NSLayoutConstraint!
    @IBOutlet weak var prdCollectionView: UICollectionView!
    @IBOutlet weak var lcontCollectionPrdHeight : NSLayoutConstraint!
    @IBOutlet weak var pageCollectionPrd : UIPageControl!
    
    @IBOutlet weak var lcontBottomGoBrandTop : NSLayoutConstraint!
    @IBOutlet weak var viewBottomGoAndLine: UIView!
    @IBOutlet weak var viewBottomLine: UIView!
    @IBOutlet weak var viewBottomGoBrand: UIView!
    @IBOutlet weak var btnBottomGoBrand: UIButton!
    @IBOutlet weak var lcontBottomGoBrandHeight : NSLayoutConstraint!
    @IBOutlet weak var lblBottomBrandTitle: UILabel!
    
    
    
    
    
    
    
    
    private var isImageOnly : Bool = false
    
    /// 모듈 객체
    private var module: Module?
    /// 셀 선택시 함수 Call할 타겟 VC
    weak var aTarget: NFXCListViewController?
    
    /// 방송 이미지 URL String 배열 객체
    private var arrImageUrls = [Module]()
    
    /// 상품 배열 객체
    private var arrPrdList = [Module]()
    
    let lineSpacePrdCollection: CGFloat = 12.0
    let heightPrdCollection: CGFloat = 80.0
    
    
    
    //비디오 관련
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
    
    /// 현재 비디오의 타입 (생방송이냐 브라이트코브냐) //by narava 테이블뷰에서 컨트롤할떄 기준값으로 사용하기위해 public으로 수정
    public var videoType = VideoType.none
    /// 브라이트 코드 ID
    private var brightCoveID: String = ""
    /// 방송영상 URL (생방송 링크, 데이터방송 링크 등)
    private var videoUrl: URL?
    
    ///  WebPrdView에서 BrightCove 컨트롤을 위한 델리게이트 객체
    weak var webPrdPlayerDelegate: WebPrdPlayerDelegate?
    
    /// 동영상 전체 플레이어 뷰컨트롤러
    private var webPrdViewFullViewController: WebPrdVideoFullViewController?
    
    
    /// 사용자가 직접 Pause(일시정지)버튼을 눌렀는지 여부
    private var isUserEventPause: Bool = true

    // BrightCove 관련 객체들
    let sharedSDKManager = BCOVPlayerSDKManager.shared()
    let playbackService = BCOVPlaybackService(accountId: BRIGHTCOVE_ACCOUNTID, policyKey: BRIGHTCOVE_POLICY_KEY)!
    
    /// 브라이트코브 비디오 객체
    var brightCoveVideo: BCOVVideo?
    /// BrightCove의 playController
    var playbackController :BCOVPlaybackController?
    /// BrightCove의 player View
    var playerView: BCOVPUIPlayerView!
    /// 동영상 플레이어 객체 - 볼륨 설정을 BrightCove에서 할 수 없어서 player객체에서 진행한다.
    var videoPlayer: AVPlayer?
    
    
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
    
    var durationFromJson : TimeInterval = .zero
    
    /// 영상재생중 사라질때 시간기록후 다시 그 시점에서 재생용
    var lastPlayTime : TimeInterval = .zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.collectionViewWidth.constant = getAppFullWidth()
        //self.prdCollectionView.backgroundColor = .clear
        self.prdCollectionView.delegate = self
        self.prdCollectionView.dataSource = self
        self.prdCollectionView.register(UINib(nibName: GR_BRD_GBATypeSubPrdCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: GR_BRD_GBATypeSubPrdCell.reusableIdentifier)
        
        self.prdCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        
        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self
        self.imgCollectionView.register(UINib(nibName: GR_BRD_GBATypeSubImgCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: GR_BRD_GBATypeSubImgCell.reusableIdentifier)
        
        

        self.viewBottomGoBrand.layer.cornerRadius = 4.0
        self.viewBottomGoBrand.layer.shouldRasterize = true
        self.viewBottomGoBrand.layer.borderWidth = 1.0
        self.viewBottomGoBrand.layer.borderColor = UIColor.getColor("D9D9D9", alpha: 1.0).cgColor
        self.viewBottomGoBrand.layer.rasterizationScale = UIScreen.main.scale;
        
        
        self.viewImageCounts.layer.cornerRadius = 11.0
        self.viewImageCounts.layer.shouldRasterize = true
        self.viewImageCounts.layer.rasterizationScale = UIScreen.main.scale;
        
        if IS_IPAD() {
            self.lblMiddleTitle.numberOfLines = 1
        }
        
        self.playTimeLbl.text = ""
        self.controlView.isHidden = false
        self.networkPopupView.isHidden = true
        self.speakerBtn.isHidden = true
        self.screenFullBtn.isHidden = true
        self.speakerBtn.isAccessibilityElement = true
        self.screenFullBtn.isAccessibilityElement = true
        
        
        self.networkPopupLbl.setCorner(radius: 8)
        self.cancelBtn.setCorner()
        self.cancelBtn.setBorder(color: "FFFFFF", alpha: 1.0)
        self.confirmBtn.setCorner()
        self.confirmBtn.setBorder(color: "FFFFFF", alpha: 1.0)
        self.dimView.backgroundColor = UIColor.getColor("000000", alpha: 0.15)
        
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
        
        self.imgMiddleBrandImage.image = nil
        self.lblTopBrandTitle.text = ""
        self.lblBottomBrandTitle.attributedText = NSAttributedString.init(string: "")
        self.lblMiddleTitle.text = ""
        self.lblMiddleDesc.text = ""
        self.imgVideoThumb.image = UIImage.init(named: "noimg_440.png")
        self.imgVideoThumb.isHidden = false
        
        self.playBtn.isHidden = false
        self.playBtn.setImage(UIImage(named: Const.Image.btn_play_nor.name), for: .normal)
        self.playBtn.isSelected = false
        self.videoType = .none
        self.playStatus = .none
        
        self.playTimeLbl.text = ""
        self.controlView.isHidden = false
        self.networkPopupView.isHidden = true
        self.speakerBtn.isHidden = true
        self.screenFullBtn.isHidden = true
        self.isEndPlaying = false
        
        // 애니메이션 동작 WrokItem 초기화
        initWorkItem()
        controlViewChangeAlpha(1.0)
        // 음소거 여부 설정 - "D": 디폴트(음소거) / "Y" : 소리on / "N" : 소리off(음소거)
        self.speakerBtn.isSelected = "Y" == DataManager.shared()?.strGlobalSoundForWebPrd ? true : false
    }
    
    deinit{
        print("!!deallocdealloc!!!")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isImageOnly {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 40.0, height: 40.0))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.viewMiddleTitle.layer.mask = mask
        }else{
            self.viewMiddleTitle.layer.mask = nil
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(_ module: Module, target: NFXCListViewController) {

        self.module = module
        self.aTarget = target
        
        self.setViewTopBrandInfo()
        self.setViewVideoAndImage(module)
        
        self.arrPrdList = module.productList

        
        if let imageUrl = self.module?.brandImg , imageUrl.hasPrefix("http") {
            self.imgMiddleBrandImage.isHidden = false
            self.imgMiddleBrandImage.isAccessibilityElement = true
            self.imgMiddleBrandImage.accessibilityLabel = self.module?.brandNm
            
            ImageDownManager.blockImageDownWithURL(imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                if error == nil, imageUrl == strInputURL, let fImg = fetchedImage {
                    DispatchQueue.main.async {

                        self.lcontMiddleBrandImageWidth.constant = (fImg.size.width/fImg.size.height)*67.0
                        self.imgMiddleBrandImage.image = fImg
                        self.viewTopBrandInfo.layoutIfNeeded()
                        
                    }//dispatch
                }
            }
        }else{
            self.imgMiddleBrandImage.isHidden = true
        }
        
        var strMiddleTitle = ""
        if module.title1.isEmpty == false {
            strMiddleTitle.append(module.title1)
            
            if module.title2.isEmpty == false {
                if IS_IPAD() {
                    strMiddleTitle.append(" ")
                }else{
                    strMiddleTitle.append("\n")
                }
                strMiddleTitle.append(module.title2)
            }
        }else{
            strMiddleTitle.append(module.title2)
        }

        
        
        //중간 대 타이틀 값 필수 값이라 없으면 API 가 안내려 주기로함
        self.lblMiddleTitle.text = strMiddleTitle
        self.lblMiddleTitle.isAccessibilityElement = true
        self.lblMiddleTitle.accessibilityLabel = strMiddleTitle
        
        if self.imgMiddleBrandImage.isHidden == true {
            self.lconstViewMiddleTitleHeight.constant = 27.0
            self.lconstLblMiddleTitleTop.constant = 19.0
        }else{
            self.lconstViewMiddleTitleHeight.constant = 93
            self.lconstLblMiddleTitleTop.constant = 85.0
        }
        
        self.viewMiddleTitle.layoutIfNeeded()
            
        if module.subName.isEmpty == true {
            self.viewMiddleDesc.isHidden = true
            
            self.removeConstraint(self.lcontCollectionPrdTop)
            let lcontPrdTop  = NSLayoutConstraint.init(item: self.viewMiddleTitle, attribute: .bottom, relatedBy: .equal, toItem: self.prdCollectionView, attribute: .top, multiplier: 1.0, constant: -20.0)
            self.lcontCollectionPrdTop = lcontPrdTop
            self.addConstraint(self.lcontCollectionPrdTop)
            
        }else{
            
            self.removeConstraint(self.lcontCollectionPrdTop)
            let lcontPrdTop = NSLayoutConstraint.init(item: self.viewMiddleDesc, attribute: .bottom, relatedBy: .equal, toItem: self.prdCollectionView, attribute: .top, multiplier: 1.0, constant: -20.0)
            self.lcontCollectionPrdTop = lcontPrdTop
            self.addConstraint(self.lcontCollectionPrdTop)
            
            self.viewMiddleDesc.isHidden = false
            self.lblMiddleDesc.text = module.subName
            self.lblMiddleDesc.isAccessibilityElement = true
            self.lblMiddleDesc.accessibilityLabel = module.subName
        }
        
        //상품이 4개 보다 많을경우
        if module.productList.count > 4{
            self.lcontCollectionPrdHeight.constant = (self.heightPrdCollection + 20.0) * 3.0 - 20.0
            self.pageCollectionPrd.isHidden = false
            self.lcontBottomGoBrandTop.constant = 32.0
            
            var divPages = 0
            
            if IS_IPAD() {
                
                if (module.productList.count%6 > 0){
                    divPages = 1
                }
                self.pageCollectionPrd.numberOfPages = module.productList.count/6 + divPages
                self.pageCollectionPrd.currentPage = 0
                
                if module.productList.count <= 6 {
                    self.pageCollectionPrd.isHidden = true
                    self.lcontBottomGoBrandTop.constant = 12.0
                }
                
            }else{
                
                if (module.productList.count%3 > 0){
                    divPages = 1
                }
                self.pageCollectionPrd.numberOfPages = module.productList.count/3 + divPages
                self.pageCollectionPrd.currentPage = 0
            }
            
            
        }else{
            self.lcontCollectionPrdHeight.constant = (self.heightPrdCollection + 20.0) * CGFloat(module.productList.count) - 20.0
            self.pageCollectionPrd.isHidden = true
            self.lcontBottomGoBrandTop.constant = 12.0
        }
        
        
        if module.moreBtnUrl.isEmpty == true {
            self.lcontBottomGoBrandHeight.constant = 28
            self.viewBottomGoBrand.isHidden = true
            self.viewBottomLine.isHidden = false
            
        }else{
            self.lcontBottomGoBrandHeight.constant = 78
            self.viewBottomGoBrand.isHidden = false
            self.viewBottomLine.isHidden = true
            
            //self.lblBottomBrandTitle.text = ("\(module.brandNm) \(module.moreText)")

            let text = ("\(module.brandNm) \(module.moreText)")
            let range = (text as NSString).range(of: module.brandNm)


            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16.0), range: range)
            self.lblBottomBrandTitle.attributedText = attributedString

            self.btnBottomGoBrand.isAccessibilityElement = true
            self.btnBottomGoBrand.accessibilityLabel = ("\(module.brandNm) \(module.moreText)")
        }
        
        self.prdCollectionView.reloadData()
        self.prdCollectionView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: false)
        
        self.layoutIfNeeded()
    }
    
    func setViewTopBrandInfo(){
        
        if self.module?.brandImg.isEmpty == true && self.module?.brandNm.isEmpty == true  {
            self.lcontViewTopBrandInfoHeight.constant = 0
        }else{
            self.lcontViewTopBrandInfoHeight.constant = 56
            self.lblTopBrandTitle.text = self.module?.brandNm
            self.lblTopBrandTitle.isAccessibilityElement = true
            self.lblTopBrandTitle.accessibilityLabel = self.module?.brandNm
        }
    }
    
    func setViewVideoAndImage(_ module: Module){
        self.arrImageUrls = module.moduleList
        
        if module.videoid.isEmpty == false && module.videoid.count > 4{
            self.isImageOnly = false
            self.lcontViewMiddleTitleTop.constant = 0.0;
            self.lcontViewVideoAndImageHeight.constant = 180.0/320.0  * getAppFullWidth()
            self.viewVideo.isHidden = false
            self.viewImages.isHidden = true
            
            if let imageUrl = self.module?.vodImg , imageUrl.hasPrefix("http") {
                ImageDownManager.blockImageDownWithURL(imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                    if error == nil, imageUrl == strInputURL, let fImg = fetchedImage {
                        DispatchQueue.main.async {

                            self.imgVideoThumb.image = fImg
                            
                        }//dispatch
                    }
                }
            }

            self.setVideoWithId(module.videoid)
            
            if let bcPlayerView = self.playerView {
                self.addBrightCoveView(bcPlayerView, videoType: self.videoType)
            }
            
            
            
            
        }else{
            self.lcontViewMiddleTitleTop.constant = -54.0;
            self.isImageOnly = true
            self.lcontViewVideoAndImageHeight.constant = getAppFullWidth()
            self.viewVideo.isHidden = true
            self.viewImages.isHidden = false
            
            self.imgCollectionView.reloadData()
            self.imgCollectionView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: false)
            
            if self.arrImageUrls.count <= 1 {
                self.viewImageCounts.isHidden = true
            }else{
                self.viewImageCounts.isHidden = false
                self.setNoteCnt(1)
            }
            
        }
        
        //"vodId": "6113147738001",
        //"vodImg": "https://cf-images.ap-northeast-1.prod.boltdns.net/v1/jit/5819061489001/bc5828fa-9cfd-4b88-8a87-1a4918967822/main/1280x720/26s325ms/match/image.jpg",
        
        self.viewVideoAndImage.layoutIfNeeded()
    }
    
    func setNoteCnt(_ value: Int) {
        let currentRow = String(value)
        self.lblImageCounts.text = currentRow + " / \(self.arrImageUrls.count)"
    }

    func onClickPrdCollection (_ indexPath : IndexPath){
        if let vc = self.aTarget,
            let prdData = self.arrPrdList[safe: indexPath.row]  {
            vc.onBtnCellJustLinkStr(prdData.linkUrl)
        }
    }
    
    @IBAction func onBtnBottomBrandGo (_sender : UIButton){
        if let vc = self.aTarget,
            let module = self.module {
            vc.onBtnCellJustLinkStr(module.moreBtnUrl)
        }
    }
    
    func checkPauseFromTableView(){
        if self.videoType == .brightCove && self.playStatus == .play {
            self.pause()
        }
    }
    
    func changeSoundStatus(){
        if self.videoType == .brightCove {
            self.speakerBtn.isSelected = "Y" == DataManager.shared()?.strGlobalSoundForWebPrd ? true : false
            
            if self.playStatus == .play || self.playStatus == .pause {
                if let player = self.videoPlayer {
                    player.isMuted = "Y" ==  DataManager.shared()?.strGlobalSoundForWebPrd ? false : true
                }
            }
        }
    }
    
    func deinitBrightCove(){
        
        self.brightCoveVideo = nil
        self.playbackController?.delegate = nil
        self.playbackController = nil
        self.playerView = nil
        self.videoPlayer = nil
        self.playStatus = .none
        self.videoType = .none
        
//        print(self.brightCoveVideo)
//        print(self.playbackController?.delegate)
//        print(self.playbackController)
//        print(self.playerView)
//        print(self.videoPlayer)
        
    }
    
    @objc public func sendBhrGbnEvent(_ strEvent:String, andTotalTime:TimeInterval, andCurrentTime:TimeInterval) {
        //bhrGbn=bcPlayer_LTE_Y&vid={VODID}&mseq=W00054-V-PLAY&pt={play길이}&tt={영상길이}
        var sendTime = 0.0
        var sendTotalTime = 0.0
        var sendEvent = ""
        
        if andCurrentTime.isNaN || andCurrentTime.isInfinite {
            sendTime = 0.0
        }else{
            sendTime = andCurrentTime
        }
        
        if andTotalTime.isNaN || andTotalTime.isInfinite {
            sendTotalTime = 0.0
        }else{
            sendTotalTime = andTotalTime
        }

        if strEvent == "EXIT" {
            sendEvent = "MINI"
        }else if strEvent == "REPLAY" {
            sendTime = 0.0
            sendEvent = "RESUME"
        }else{
            sendEvent = strEvent
        }
        
        let strParam = String(format: "?bhrGbn=bcPlayer_%@&vid=%@&mseq=A00538-V-PLAY&pt=%d&tt=%d", sendEvent,self.brightCoveID,Int(round(sendTime)),Int(round(sendTotalTime)))

        applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr:strParam))
    }
}

// MARK:- UICollectionViewDelegate & DataSource
extension GR_BRD_GBATypeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.imgCollectionView {
            return self.arrImageUrls.count
        }else{
            return self.arrPrdList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.imgCollectionView {
            if let imgData = self.arrImageUrls[safe: indexPath.row] {
            
                //하단 상품 셀들
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GR_BRD_GBATypeSubImgCell.reusableIdentifier, for: indexPath) as? GR_BRD_GBATypeSubImgCell else {
                    return UICollectionViewCell()
                }
                
                cell.setData(imgData)
                return cell
            }
            
            
            return UICollectionViewCell()
            
        }else{
            
            if let prdData = self.arrPrdList[safe: indexPath.row] {
            
                //하단 상품 셀들
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GR_BRD_GBATypeSubPrdCell.reusableIdentifier, for: indexPath) as? GR_BRD_GBATypeSubPrdCell else {
                    return UICollectionViewCell()
                }
                
                cell.setData(product: prdData, indexPath: indexPath, target: self)
                return cell
            }
            
            
            return UICollectionViewCell()
        }
    }
    
    
}

// UICollectionViewDelegateFlowLayout
extension GR_BRD_GBATypeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.imgCollectionView {
            return CGSize(width: getAppFullWidth(),height: getAppFullWidth())
        }else{
            if IS_IPAD() {
                return CGSize(width: (getAppFullWidth() - 24.0 - 29.0 - 24.0)/2.0,height: self.heightPrdCollection)
            }else{
                return CGSize(width: getAppFullWidth() - 65.0,height: self.heightPrdCollection)
            }
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.imgCollectionView {
            return .zero
        }else{
            return self.lineSpacePrdCollection
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.imgCollectionView {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }else{
            return UIEdgeInsets(top: 0.0, left: 24.0, bottom: 0.0, right: 41.0)
        }
        
    }
    
    //- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
}

extension GR_BRD_GBATypeCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("scrollViewDidScroll")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.imgCollectionView {
            let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            setNoteCnt(index + 1)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.imgCollectionView {
            let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            setNoteCnt(index + 1)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == self.prdCollectionView {
            print("targetContentOffset.pointee = \(targetContentOffset.pointee)")
            print("velocity = \(velocity)")

            //0  17+320 674 1011 1348
            
            
            if scrollView.contentSize.width > getAppFullWidth() {
                
                if targetContentOffset.pointee.x <= 0 {
                    scrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
                }else if targetContentOffset.pointee.x >= scrollView.contentSize.width {
                    scrollView.setContentOffset(CGPoint.init(x: scrollView.contentSize.width - getAppFullWidth(), y: 0.0), animated: true)
                }else{
                        let cellWidthIncludingSpacing = (getAppFullWidth() - 65.0) + 12.0
                        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
                        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
                        
                        var offset = targetContentOffset.pointee
                        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
                        var roundedIndex = round(index) // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
                        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
                        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
                        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
                            roundedIndex = floor(index)
                            
                        } else {
                            roundedIndex = ceil(index)
                            
                        }
                        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
                        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: 0.0)
                        targetContentOffset.pointee = offset
                    
                    
                        self.pageCollectionPrd.currentPage = Int(roundedIndex)
                }
            }
        }
        
    }
        
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset = \(scrollView.contentOffset)")
//        print("scrollView.contentOffset = \(scrollView.contentSize)")
    }
}

// MARK:- Button Action Functions
extension GR_BRD_GBATypeCell {
    @IBAction func playBtnAction(_ sender: UIButton) {

        if sender.isSelected {
            // puase
            self.pause(isUserEvent: true)
            //self.pause()
            self.sendBhrGbnEvent("PAUSE", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
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
            } else {
                self.play()
                
                let curTime = self.getCurrentTime()
                
                if curTime.isNaN == false &&  curTime.isInfinite == false && curTime > 0.0 {
                    self.sendBhrGbnEvent("RESUME", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
                }else{
                    self.sendBhrGbnEvent("PLAY", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
                }
                
            }
        }
    }
    
    /// 네트워크 팝업 취소 버튼 Action
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.sendBhrGbnEvent("LTE_N", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
        networkPopupHidden(true)
    }
    
    /// 네트워크 팝업 확인 버튼 Action
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        DataManager.shared()?.strGlobal3GAgree = "Y"
        networkPopupHidden(true)
        //self.webPrdPlayerDelegate?.play()
        self.play()
        
        self.sendBhrGbnEvent("LTE_Y", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
        
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
            self.isMute(true)
            self.sendBhrGbnEvent("SOUND_OFF", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
        } else {
            // 소리on에서 음소거로 변경로직
            self.isMute(false)
            self.sendBhrGbnEvent("SOUND_ON", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
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
        self.showScreenFull(isFull: true)
        self.sendBhrGbnEvent("FULL", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
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
    private func setVideoWithId(_ videoid: String) {
        
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
        bcPlayerView.frame = self.viewVideo.frame
        bcPlayerView.backgroundColor = .white
        
        print(bcPlayerView.frame)
        
        self.playerView = bcPlayerView
        
        print(self.playerView)
        
        self.playerView.playbackController = playbackController
        self.playerView.playbackController.delegate = self
        
        //self.videoInfo = firstVideoInfo
        setBrightCove(videoid)

    }
    
    /// 브라이트코브 설정
    private func setBrightCove(_ videoid: String) {
        if videoid.isEmpty {
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
        self.brightCoveID = videoid
        
        // 브라이트코브 서버에서 비디오 객체 얻어오기
        requestContentFromPlaybackService(id: videoid)
    }
    
    private func isShowNetworkPopup() -> Bool {
        if NetworkManager.shared.currentReachabilityStatus() == .viaWWAN,
            "N" == DataManager.shared()?.strGlobal3GAgree {
            // 자동재생 안하고 네트워크 팝업이 노출되야 함
            return true
        }
        return false
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
    
/// 네트워크 에러 팝업 노출
   private func showNetworkErrorPopup() {
       self.pause()
       
       self.playStatus = .none
       
       
        self.imgVideoThumb.isHidden = false
        self.dimView.backgroundColor = UIColor.getColor("000000", alpha: 0.15)
       
      
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
    
    /// 전체화면 플레이어뷰컨트롤러 설정
    func setFullScreenView() {
        if self.webPrdViewFullViewController == nil {
            self.webPrdViewFullViewController = WebPrdVideoFullViewController(nibName: WebPrdVideoFullViewController.className, bundle: nil)
            self.webPrdViewFullViewController!.orientationType = .landscape
            self.webPrdViewFullViewController!.webPrdPlayerDelegate = self
            self.webPrdViewFullViewController!.aTarget = self
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
                    self.sendBhrGbnEvent("PLAY", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
                }
            }
        }
    }
    
    /// 재생이 완료되면 호출해야하는 함수
    private func playEnd() {
        self.isEndPlaying = true
        self.playBtn.isSelected = false
        self.playTimeLbl.isHidden = true
        
        self.playBtn.setImage(UIImage(named: Const.Image.btn_replay_nor.name), for: .normal)
        
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
        }
        
        if let fullVC = self.webPrdViewFullViewController {
            fullVC.playEnd()
        }
        self.playStatus = .end
    }

}

// MARK:- BCOVPlaybackControllerDelegate
extension GR_BRD_GBATypeCell: BCOVPlaybackControllerDelegate {
    /// 플레이어 Session Delegate 함수
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        // BrightCove player를 나의 플레이어로 넘겨받는다...?
        self.videoPlayer = session.player
    }

    /// 플레이 시간 Delegate 함수
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didChangeDuration duration: TimeInterval) {
        self.durationTime = duration

    }
    
    /// 플레이에 따른 프로그레스 Delegate 함수
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        // 플레이 될때 호출 - 플레이시간을 여기서 설정할수 있다.
        self.currentTime = progress
        self.leftTime = self.durationTime - progress
        
        if self.leftTime.isNaN || self.leftTime.isInfinite {
            return
        }
        
        let timeStr = self.leftTime.getPlayerLeftTime(videoType: .brightCove)
        if self.leftTime  <= 0 {
            return
        }
        
        self.playTimeLbl.text = timeStr
        
        
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
            
            if self.lastPlayTime != .zero {
                
                if let player = self.videoPlayer {
                    player.seek(to: CMTimeMakeWithSeconds(self.lastPlayTime, preferredTimescale: Int32(self.durationTime)), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (isFinished:Bool) in
                        self.play()
                        self.lastPlayTime = .zero
                    }
                    
                }
            }else{
                self.play()
            }
            
            
            
            
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
extension GR_BRD_GBATypeCell: WebPrdPlayerDelegate {
    
    func play() {
        if NetworkManager.shared.currentReachabilityStatus() == .notReachable ||
            NetworkManager.shared.currentReachabilityStatus() == .unknown {
            
            // 네트워크 에러 팝업
            self.showNetworkErrorPopup()
            return
        }
        
        self.aTarget?.pauseOtherSignatureVODStop(self)
        
        self.isReadyToPlay = true
        self.isEndPlaying = false
        self.playBtn.isSelected = true
        self.playTimeLbl.isHidden = false
        self.imgVideoThumb.isHidden = true
        self.speakerBtn.isHidden = false
        self.screenFullBtn.isHidden = false
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: self.workItem!)
        }
        
        if self.playStatus == .none {
            print("kBCOVPlaybackSessionLifecycleEvent[None] called")
            
            if self.videoType == .brightCove {
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

        if let fullVC = self.webPrdViewFullViewController {
            fullVC.play()
        }
        
        if let playBackVC = self.playbackController {
            playBackVC.play()
        }
        
        self.playStatus = .play
        
    }
    
    
    
    func pause(isUserEvent: Bool = true) {
        
        self.playBtn.isSelected = false
        self.speakerBtn.isHidden = false
        self.screenFullBtn.isHidden = false
        
        if let item = self.workItem {
            item.cancel()
            initWorkItem()
            controlViewChangeAlpha(1.0)
        }
        
        self.isUserEventPause = isUserEvent
        
        if let fullVC = self.webPrdViewFullViewController {
            fullVC.pause()
        }

        if let player = self.videoPlayer {
            player.pause()
        }
        self.playStatus = .pause
    }
    
    func replay() {
        
        self.imgVideoThumb.isHidden = true
        self.playBtn.setImage(UIImage(named: Const.Image.btn_play_nor.name), for: .normal)
        
        if self.videoType == .brightCove {
            if let playBackVC = self.playbackController {
                playBackVC.pause()
                playBackVC.seek(to: .zero) { (isFinished) in
                    if isFinished {
                        if let fullVC = self.webPrdViewFullViewController {
                            fullVC.replay()
                            fullVC.play()
                        }
                        
                        self.play()
                        self.playStatus = .play
                        self.sendBhrGbnEvent("REPLAY", andTotalTime: self.getTotalTime(), andCurrentTime: self.getCurrentTime())
                    }
                }
            }
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

        if let fullVC = self.webPrdViewFullViewController {
            fullVC.speakerBtn.isSelected = !value
        }
        
        self.speakerBtn.isSelected = !value
        self.aTarget?.changeSoundStatus(self)
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
                vc.orientationType = .landscape
                
                applicationDelegate.window.rootViewController?.present(vc, animated: true, completion: {
                    // 재생중으로 버튼 변경
                    vc.playBtn.isSelected = true
                    // 음소거 버튼 설정
                    if let player = self.videoPlayer {
                        vc.speakerBtn.isSelected = !player.isMuted
                    }
                    
                    if self.videoType == .brightCove {
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
            self.webPrdViewFullViewController?.aTarget = nil
            self.webPrdViewFullViewController?.webPrdPlayerDelegate = nil
            self.webPrdViewFullViewController = nil
        }
    }
    
    func changePlayerView() {
        if self.videoType == .brightCove {
            if let view = self.playerView {
                self.addBrightCoveView(view, videoType: self.videoType)
            }
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

// MARK:- Mocha_AlertDelegate
extension GR_BRD_GBATypeCell: Mocha_AlertDelegate {
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
