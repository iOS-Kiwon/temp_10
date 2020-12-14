//
//  NFXCList2TableViewController.swift
//  GSSHOP
//
//  Created by Kiwon on 26/09/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

@objc protocol NFXCListViewControllerDelegate {
    @objc optional func touchEventTBCellJustLinkStr(_ linkstr: String)
    @objc optional func touchEventTBCell(_ dic: Dictionary<String, Any>)
    @objc optional func customscrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func customscrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func customscrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func tablereloadAction()
    @objc optional func btntouchAction(_ sender: UIButton)
}

@objc
@objcMembers
class NFXCListViewController: PullRefreshTableViewController {
    
    let COMMON_MARGIN_BOTTOM: CGFloat = 9.0
    
    /// 매장이름
    var sectionName: String = ""
    /// 스크롤뷰 델리게이트
    var scrollExpandingDelegate: UIScrollViewDelegate?
    /// TableView 델리게이트
    var delegatetarget: NFXCListViewControllerDelegate?
    
    /// TableView에 사용될 Array
    private var dataList = [[Module]]()
    
    /// Model Data : init에서 guard 문으로 필터 후 값이 들어감.
    private var module: Module?
    /// 더보기 Ajax URL
    private var moreAjaxPageUrl: String = ""
    
    /// 카테고리(틀고정) Section Array
    private var sections = [Module]()
    /// 카테고리(틀고정)에 현재 선택된 Index
    private var selectedCateIndex: Int = 0
    /// 카테고리(틀고정) 최소 section 값 저장 -> TAB_SLD_GBB의 button selection 값에 사용
    private var firstSection: Int? = nil
    
    /// URLSessionDataTask
    var currentOperation1: URLSessionDataTask?
    
    /// 카테고리 여부 판단 플래그
    private var isCategoryModule: Bool = false
    
    /// 앵커 이동에 필요한 indexPath 저장변수 - Key:TabSeq / Value: IndexPath
    private var ankIndexPathDic = [String: IndexPath]()
    
    /// 장바구니 담았습니다 뷰 객체
    private var viewCartPopup: PopupCartView?
    
    /// 장바구니 링크 관련 변수
    private var curRequestString: String = ""
    
    /// 시그니처매장 동영상 플레이타임 저장함수
    private var dicGR_BRD_GBA_TimeList: Dictionary<IndexPath,Double> = Dictionary()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        setupInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc convenience init(style: UITableView.Style, sectionName: String) {
        self.init(style: style)
        self.sectionName = sectionName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.getColor("EEEEEE", defaultColor: .gray)
        
        if #available(iOS 11.0, *) {
            self.tableView.estimatedRowHeight = 0
            self.tableView.estimatedSectionHeaderHeight = 0
            self.tableView.estimatedSectionFooterHeight = 0
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    /// Pull Refresh
    @objc override func refresh() {
        super.refresh()
        self.delegatetarget?.tablereloadAction?()
    }
    
    deinit{
        print("!!deallocdealloc!!!")
    }
    
    @objc func checkDeallocNFXC(){
        
        self.scrollExpandingDelegate = nil
        self.delegatetarget = nil
        self.currentOperation1 = nil
        self.viewCartPopup = nil
        self.tableView = nil
    }
}

// MARK:- Public Functions
extension NFXCListViewController {
    
    @objc func setResultDic(_ dic: Dictionary<String, AnyObject>) {
        self.isCategoryModule = false
        self.selectedCateIndex = 0;
        
        guard let data = Module(JSON: dic) else { return }
        
        // kiwon : TEST!!!!!
//        guard let data = Module(JSON: ApiDummy.shard.getDummyData(type: DummyType.EILIST)!) else { return }
        // guard let data = Module(JSON: ApiDummy.shard.getDummyData(type: DummyType.NFXCLIST)!) else { return }
        
        self.dataList.removeAll()
        
        var sectionModule: Module?
        var ankSection: Int = 0
        
        for moduleItem in data.moduleList {
            /*
            // kiwon : 20.08.06 네비 8.3부터 TAB_SLD_GBB타입을 사용하지 않음
            // TAB_SLD_ANK_GBA를 사용함에 따라 예외처리 코드 추가함.
            if moduleItem.viewType == Const.ViewType.TAB_SLD_GBB.name {
                continue
            }
             */
            /* GSFresh / 새벽배송 데이터 구조 변경
             1. ViewType이 TAB_SLD_GBA 인 경우
             moduleList
                |-TAB_SLD_GBA       -> Section
                    |-BAN_MUT_GBA
                    |-BAN_MUT_GBA       -> Row
                    |-BAN_MUT_GBA
                    |-.....

             2. ViewType이 TAB_SLD_GBB 인 경우
             moduleList
                |-TAB_SLD_GBB       -> Section
                    |-MAP_CX_GBC
                    |-MAP_CX_GBC        -> Row
                    |-MAP_CX_GBC
                    |-.....
                |-TAB_SLD_GBB       -> Section
                    |-MAP_CX_GBC
                    |-MAP_CX_GBC        -> Row
                    |-MAP_CX_GBC
                    |-.....
             */
            // 틀고정 (section)할 viewType이 있는 경우,
            
            if moduleItem.viewType == Const.ViewType.TAB_SLD_GBA.name
                || moduleItem.viewType == Const.ViewType.TAB_SLD_GBB.name
                || moduleItem.viewType == Const.ViewType.TAB_ANK_GBA.name
                || moduleItem.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name
                || moduleItem.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name {

                sectionModule = nil
                // section 데이터 추가
                self.dataList.append([moduleItem])

                // product list 추가를 위한 section 데이터 별도 저장
                sectionModule = moduleItem

                self.isCategoryModule = true
                
                if moduleItem.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name
                || moduleItem.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name {
                    ankSection = self.dataList.count - 1
                }
            }
            else {
                
                if self.isCategoryModule {
                    // 카테고리 하위 녀석들은
                    if let product = Module(JSON: moduleItem.toJSON()), sectionModule != nil {
                        sectionModule?.productList.append(product)
                    }
                    
                }
                else {
                    for reMakeItem in self.reMakeViewType(moduleItem: moduleItem) {
                        self.dataList.append([reMakeItem])
                    }
                }
            }
        }
        
        print("self.dataList.count = \(self.dataList.count)")
        
        let items = self.itemReMakeProcess(prdList: sectionModule?.productList ?? [Module](), cateModule: sectionModule)
        // 엥커의 위치를 찾아 등록한다.
        // tabSeq이 처음 나타나는 곳의 Index를 이용하여 해당 위치를 저장한다.
        for (index, item) in items.enumerated() {
            if item.tabSeq.isEmpty == false,
                self.ankIndexPathDic.index(forKey: item.tabSeq) == nil {
                
                let indexPath = IndexPath(row: index, section: ankSection)
                self.ankIndexPathDic.updateValue(indexPath, forKey: item.tabSeq)
            }
        }
        
        if items.count > 0 {
            sectionModule?.productList.removeAll()
            sectionModule?.productList = items
        }
        else {
            sectionModule?.productList = items
        }
        
        //시그니처 매장용
        self.dicGR_BRD_GBA_TimeList.removeAll()
        
        
        // 더보기를 위한 ajaxURL 저장
        self.moreAjaxPageUrl = data.ajaxPageUrl
        
        self.tableView.reloadData()
        setTableViewFooterView()
    }
    
    /// 데이터 재구성 처리 로직 (ex: PRD_2 2단으로 만들어줌)
    func itemReMakeProcess(prdList:[Module], cateModule:Module? = nil) -> [Module] {
        // -- prd2 전용 2단 처리 로직 (2단으로 만들어줌)
        var prdItems = [Module]()
        
        var dummy: Module? = nil
        
        for prd in prdList {
            
            if prd.viewType == Const.ViewType.PRD_2.name || prd.viewType == Const.ViewType.MAP_CX_GBC.name {
                // PRD_2 타입으로 만들기
                if let dm = dummy {
                    dm.tabSeq = prd.tabSeq
                    dm.subProductList.append(prd)
                    prdItems.append(dm)
                    dummy = nil
                } else {
                    dummy = Module()
                    dummy!.viewType = Const.ViewType.PRD_2.name
                    dummy!.tabSeq = prd.tabSeq
                    dummy!.subProductList.append(prd)
                }
                
            } else {
                if let dm = dummy {
                    // 이전에 PRD_2로 만들던 데이터가 있으면 추가해줌. -> 홀수개
                    prdItems.append(dm)
                    dummy = nil
                }
                
                for reMakeItme in self.reMakeViewType(moduleItem: prd) {
                    prdItems.append(reMakeItme)
                }
            }
        }
        
        // 맨 마지막 데이터가 홀수개가 들어온경우
        // dummy 객체의 subProductList에 담겨있는채로 for이 끝난다.
        // 확인 하여 추가해준다.
        if let dm = dummy {
            prdItems.append(dm)
            dummy = nil
        }
        
        
        // 엥커 + 텝 형인 경우 더보기 뷰타입이 내려오므로 아래 로직이 필요없다.
        if let module = cateModule,
            (module.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name || module.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name) {
            return prdItems
        }
        
        // 더보기 뷰타입이 내려오는 관계로 코드 삭제
        if let module = cateModule,
            let firstModule = module.moduleList[safe: self.selectedCateIndex],
            firstModule.moreBtnUrl.isEmpty == false {
            // TAB_SLD_GBB 카테고리의 상품전체보기 추가 로직
            // TAB_SLD_GBB의 modulList속 data의 moreBtnUrl 값만을 확인해서 "상품전체보기" row 추가
            // 2020. 01. 14
            let moreModuleData = Module()
            moreModuleData.viewType = Const.ViewType.TAB_SLD_GBB_MORE_NOSPACE.name
            moreModuleData.moreBtnUrl = firstModule.moreBtnUrl
            prdItems.append(moreModuleData)
        }
        
        return prdItems
    }
    
    // 2단을 제외한 뷰타입 재구성용 메서드
    func reMakeViewType(moduleItem:Module) -> [Module] {
        
        var rValue = [Module]()
        
        if moduleItem.viewType == "PRD_C_B1", moduleItem.productList.count == 1 {
            let titleModule: Module = Module(JSON: moduleItem.toJSON()) ?? Module()
            titleModule.viewType = "BAN_TXT_IMG_LNK_GBA"
            titleModule.bdrBottomYn = "Y"
            titleModule.productList.removeAll()
            rValue.append(titleModule)
            
            let prd1Module:Module = Module(JSON: moduleItem.productList.first!.toJSON()) ?? Module()
            prd1Module.viewType = "PRD_1_640"
            rValue.append(prd1Module)
        }
           
        else {
            rValue.append(moduleItem)
        }
        
        return rValue
    }
    
    
    @objc func tableCellReloadForHeight(_ h: String, indexPath: IndexPath) {
        guard let sectionData = self.dataList[safe: indexPath.section] else { return }
        guard let data = sectionData.first else { return }
        // 탭고정인 경우
        if self.isCategoryModule,
            (data.viewType == Const.ViewType.TAB_SLD_GBA.name || data.viewType == Const.ViewType.TAB_SLD_GBB.name) {
            if let prd = data.productList[safe: indexPath.row] {
                if let height = NumberFormatter().number(from: h)?.intValue {
                    prd.calcHeight = height
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
            return
        }

        if let height = NumberFormatter().number(from: h)?.intValue {
            data.calcHeight = height
            self.dataList[indexPath.section][0] = data
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    
    @objc func tableCellReload(forDic:Dictionary<String, Any>, cellIndex:IndexPath) {
        objc_sync_enter(self.dataList)
        guard let sectionData = self.dataList[safe: cellIndex.section] else { return }
        guard let data = sectionData.first else { return }
        // 탭고정인 경우
        if self.isCategoryModule,
            (data.viewType == Const.ViewType.TAB_SLD_GBA.name || data.viewType == Const.ViewType.TAB_SLD_GBB.name) {
            if let prd = data.productList[safe: cellIndex.row] {
                guard let product = Module(JSON: forDic) else { return }
                
                prd.productList.remove(at: cellIndex.row)
                prd.productList.insert(product, at: cellIndex.row)
                self.tableView.reloadRows(at: [cellIndex], with: .none)
            }
            objc_sync_exit(self.dataList)
            return
        }
        guard let product = Module(JSON: forDic) else { return }
        
        data.productList.remove(at: cellIndex.row)
        data.productList.insert(product, at: cellIndex.row)
        self.tableView.reloadRows(at: [cellIndex], with: .none)
        objc_sync_exit(self.dataList)
    }
    
    
    /// //테이블뷰나 나타날때 호출됩니다.
    @objc func checkTableViewAppear() {
        for cell in self.tableView.visibleCells {
            if let findCell = cell as? SectionBAN_SLD_GBEtypeCell {
                //자동스크롤을 다시 시작해줍니다.
                findCell.startScrolling()
            }
        }
    }
    
    /// 새로 고침
    @objc func reloadAction() {
        //시그니처 매장용
        self.dicGR_BRD_GBA_TimeList.removeAll()
        
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.stopLoading()
        }
    }
    
    func getTotalHeightGR_BRD_GBA(_ module: Module , nextViewType:String) -> CGFloat{
        var totHeight : CGFloat = 0
        
        //타이틀 높이
        if module.brandNm.isEmpty == true  {
            totHeight = 0
        }else{
            totHeight = 56
        }
        

        //중단 이미지 or 비디오 높이
        if module.videoid.isEmpty == false && module.videoid.count > 4{

            //동영상일경우 높이
            totHeight = totHeight + ( 180.0/320.0  * getAppFullWidth() )
            
        }else{
            //이미지 일경우 높이 - 타이틀 영역이 먹고 들어가는 높이 54 빼기
            totHeight = totHeight + (getAppFullWidth() - 54.0)
            
        }
        
        var heightBrandImage : CGFloat = 0
        //브랜드 이미지 높이
        if module.brandImg.isEmpty == true {
            heightBrandImage = 0
        }else{
            heightBrandImage = 67 + 15
        }
        
        var strMiddleTitle = ""
        if module.title1.isEmpty == false {
            strMiddleTitle.append(module.title1)
            
            if module.title2.isEmpty == false {
                strMiddleTitle.append("\n")
                strMiddleTitle.append(module.title2)
            }
        }else{
            strMiddleTitle.append(module.title2)
        }
        
        
        
        var titleHeight : CGFloat = 62.5
        if IS_IPAD() {
            titleHeight = 31.5
        }
        
        //대 타이틀 영역
        let titleSize = UIFont.boldSystemFont(ofSize: 26.0).sizeOfString(string: strMiddleTitle, constrainedToSize: CGSize.init(width: getAppFullWidth() - 48.0, height: titleHeight))
        //print("titleSizetitleSize = \(titleSize)" )
        
        
        if heightBrandImage == 0 {
            totHeight = totHeight + titleSize.height + 27.0
        }else{
            
            //27은 타이틀 라벨 위 아래 여백
            
            totHeight = totHeight + heightBrandImage + 3.0 + titleSize.height + 8.0
            //11+ 82 = 93
        }
        
        
        
        //중단 설명 부분
        if module.subName.isEmpty == false {
            
            let descSize = UIFont.systemFont(ofSize: 15.0).sizeOfString(string: module.subName, constrainedToSize: CGSize.init(width: getAppFullWidth() - 48.0, height: 90.0))
            //height 90 은 폰트15일경우 최대 5줄일때의 높이값임
            
            print("titleSizetitleSize = \(descSize)" )
            //27은 타이틀 라벨 위 아래 여백
            totHeight = totHeight + descSize.height + 8.0
            
        }
        
        //사이 여백
        totHeight = totHeight + 20.0
        
        if module.productList.count > 4{
            totHeight = totHeight + (80.0 + 20.0) * 3.0 - 20

            if IS_IPAD() {
                if module.productList.count <= 6 {
                    totHeight = totHeight + 12
                }else{
                    totHeight = totHeight + 32
                }
            }else{
                totHeight = totHeight + 32
            }
            
        }else{
            totHeight = totHeight + (80.0 + 20.0) * CGFloat(module.productList.count) - 20
            totHeight = totHeight + 12
        }
        
        
        if module.moreBtnUrl.isEmpty == true {
            totHeight = totHeight + 38
        }else{
            totHeight = totHeight + 78
        }
        
        if nextViewType == Const.ViewType.GR_BRD_GBA.name {

        }else{
            totHeight = totHeight + 10.0
        }
        
        print("titleSizetitleSize = \(totHeight) , brandName = \(module.brandNm)" )
        
        return totHeight
        
    }
    
    func checkDivider(_ currentViewType:String, indexPos:IndexPath) -> CGFloat {
        //divider 가변식 처리 로직 대상 : PRD_1_*, PRD_2, BRD_VOD
        var divider:CGFloat = 0
        
        let data:[Module] = self.dataList[indexPos.section]
        if data.count == 1, self.dataList.count > indexPos.section + 1 { // 1개일경우 섹션을 다음으로 넘긴다.
            let nextSection:[Module] = self.dataList[indexPos.section+1]
            if currentViewType.isEmpty == false, nextSection.first?.viewType.uppercased() != currentViewType.uppercased(),
                nextSection.first?.viewType.uppercased() != Const.ViewType.TAB_SLD_GBB_MORE_NOSPACE.name {
                divider = 10
            }
        }
        else { //연속된 컬럼
            if currentViewType.isEmpty == false, data.count > indexPos.row + 1 {
                let nextViewType = data[indexPos.row+1].viewType
                if nextViewType.uppercased() != currentViewType.uppercased(),
                    nextViewType.uppercased() != Const.ViewType.TAB_SLD_GBB_MORE_NOSPACE.name {
                    divider = 10
                }
            }
        }
        return divider
    }
    
    
    //동적 이미지 베너 인지 체크
    func checkDinamicImageBanner(viewType:String) -> Bool {
        return (viewType == "PMO_T1_IMG" ||
        viewType == "PMO_T2_IMG" ||
        viewType == "PMO_T3_IMG")
    }
    
    // GS혜택 엥커 이동
    func moveTo(indexPath: IndexPath, animated: Bool = true) {
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
    
    // 새벽배송 앵커 이동
    func moveToAnk(tabSeq: String) {
        if let index = self.ankIndexPathDic.index(forKey: tabSeq) {
            let indexPath = self.ankIndexPathDic[index].value
            
            moveTo(indexPath: indexPath, animated: false)
        }
    }
    
    // 장바구니 이동
    func addBasket(data: Module) {
        
        if applicationDelegate.islogin == false {
            let loginView = AutoLoginViewController(nibName: AutoLoginViewController.className, bundle: nil)
            loginView.delegate = self
            loginView.loginViewMode = 4
            loginView.view.isHidden = false
            loginView.btn_naviBack.isHidden = false
            
            if let delegate = self.delegatetarget as? SectionView {
                loginView.deletargetURLstr = ServerUrl() + "/index.gs?tabId=\(String(describing: delegate.m_iNavigationID))"
            }
            applicationDelegate.mainNVC.pushViewControllerMoveIn(fromBottom: loginView)
            return
        }
        
        // 바로구매 인 경우
        let basketUrl = data.basket.url
        
        if basketUrl.hasPrefix(Const.Text.GSEXTERNLINKPROTOCOL.name+"directOrd?") {
         
            let linkstr = basketUrl.replacingOccurrences(of: Const.Text.GSEXTERNLINKPROTOCOL.name+"directOrd?", with: "")
            applicationDelegate.directOrdOptionViewShowURL(linkstr)
            return
        }
        
        
        if let url = URL(string: basketUrl) {
            var request = URLRequest(url: url)
            if let userAgentStr = UserDefaults.standard.object(forKey: "UserAgent") as? String {
                request.setValue(userAgentStr, forHTTPHeaderField: "User-Agent")
            }
            request.httpMethod = data.basket.format
            request.setValue(URLENCODEDFORMHEAD, forHTTPHeaderField: "Content-Type")
            
            var fullParamStr = ""
            for param in data.basket.params {
                fullParamStr.append("\(param.name)=\(param.value)")
                if let lastObj = data.basket.params.last, lastObj !== param {
                    fullParamStr.append("&")
                }
            }
            
            if let body = fullParamStr.data(using: .ascii, allowLossyConversion: true) {
                let postLengthStr = String(format: "%ld", body.count)
                request.setValue(postLengthStr, forHTTPHeaderField: "Content-Length")
                request.httpBody = body
                
                applicationDelegate.onloadingindicator()
                
                let session = URLSession.shared.dataTask(with: request) { (result, response, error) in
                    DispatchQueue.main.async {
                        self.applicationDelegate.offloadingindicator()
                        
                        guard let resultData = result else {
                            return
                        }
                        
                        do {
                            if let json = try JSONSerialization.jsonObject(with: resultData, options: .mutableContainers) as? [String: Any],
                                let result = BasketAddResult(JSON: json) {
                                
                                // 장바구니 뷰 확인
                                if self.viewCartPopup == nil,
                                    let view = Bundle.main.loadNibNamed(PopupCartView.className, owner: self, options: nil)?.first as? PopupCartView {
                                    view.setData(aTarget: self, basket: data.basket)
                                    self.viewCartPopup = view
                                }
                                
                                guard let popupView = self.viewCartPopup else { return }
                                popupView.basket = data.basket
                                
                                if result.code == .success || result.code == .aleadyExists {
                                    
                                    if result.code == .success {
                                        popupView.imgCartPopup.isHighlighted = false
                                        self.applicationDelegate.hmv.drawCartCountstr()
                                    } else {
                                        popupView.imgCartPopup.isHighlighted = true
                                    }
                                    
                                    popupView.setInitTimer()
                                    self.applicationDelegate.window.addSubview(popupView)
                                    popupView.showAnimationView()
                                    
                                    
                                    
                                } else if result.code == .selectLocation {
                                    
                                    self.curRequestString = result.retUrl
                                    //이동할 url이 있으면 취소/확인
                                    if self.curRequestString.isEmpty == false {
                                        
                                        if let alert = Mocha_Alert(title: result.retMsg, maintitle: nil, delegate: self, buttonTitle: ["취소","확인"]) {
                                            alert.tag = 55
                                            self.applicationDelegate.window.addSubview(alert)
                                        }
                                    }
                                    else {
                                        if let alert = Mocha_Alert(title: result.retMsg, maintitle: nil, delegate: self, buttonTitle: ["확인"]) {
                                            self.applicationDelegate.window.addSubview(alert)
                                        }
                                    }
                                } else {
                                    if let alert = Mocha_Alert(title: result.retMsg, maintitle: nil, delegate: self, buttonTitle: ["닫기"]) {
                                        self.applicationDelegate.window.addSubview(alert)
                                    }
                                }
                            }
                            
                        } catch let error {
                            print("장바구니 에러 : \(error.localizedDescription)")
                        }
                    }
                    
                }
                session.resume()
                
            }
        }
    }
    
    @objc func checkSignatureVODStop(){
        
        for cell in self.tableView.visibleCells {
            if let sigCell = cell as? GR_BRD_GBATypeCell {
                //시그니처 매장에 동영상 셀이 유효할경우 일시 정지
                sigCell.checkPauseFromTableView()
            }
        }
        
    }
    
    func pauseOtherSignatureVODStop(_ cellToPlay: GR_BRD_GBATypeCell){
        
        for cell in self.tableView.visibleCells {
            if let sigCell = cell as? GR_BRD_GBATypeCell {
                //시그니처 매장에 동영상 셀이 유효할경우 일시 정지
                if sigCell != cellToPlay {
                    sigCell.checkPauseFromTableView()
                }
            }
        }
    }
    
    func changeSoundStatus(_ cellFrom: GR_BRD_GBATypeCell){
        
        for cell in self.tableView.visibleCells {
            if let sigCell = cell as? GR_BRD_GBATypeCell {
                //시그니처 매장에 동영상 셀이 유효할경우 일시 정지
                if sigCell != cellFrom {
                    sigCell.changeSoundStatus()
                }
            }
        }
    }
}



// MARK: - UITableViewDelegate, UITableViewDataSource
extension NFXCListViewController  {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = self.dataList[safe: section] else { return 0 }
        guard let data = sectionData.first else { return 0 }
        
        // 틀고정 셀 타입인 경우 ProductList Count 만큼의 Cell을 나타내줘야함.
        if data.viewType == Const.ViewType.TAB_SLD_GBA.name {
            return data.productList.count
        }
        
        if data.viewType == Const.ViewType.TAB_SLD_GBB.name {
            if self.firstSection == nil {
                self.firstSection = section
            }
            
            return getDataCount(data)
        }
        
        if data.viewType == Const.ViewType.TAB_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name {
            if let fs = self.firstSection {
                self.firstSection = min(fs, section)
            } else {
                self.firstSection = section
            }
            return data.productList.count
        }
        
        return self.dataList[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionData = self.dataList[safe: section] else { return nil }
        guard let data = sectionData.first else { return nil }
        
        if data.viewType == Const.ViewType.TAB_SLD_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTAB_SLD_GBAtypeHeaderView.reusableIdentifier) as? SectionTAB_SLD_GBAtypeHeaderView else { return nil }
            view.section = section
            view.selectedCateIndex = self.selectedCateIndex
            view.setCellInfo(module: data, target: self)
            
            // 더보기 데이터 ajaxURL 저장
            if !data.ajaxTabPrdListUrl.isEmpty {
                self.moreAjaxPageUrl = data.ajaxTabPrdListUrl
            }
            return view
        } else if data.viewType == Const.ViewType.TAB_SLD_GBB.name {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTAB_SLD_GBBtypeHeaderView.reusableIdentifier) as? SectionTAB_SLD_GBBtypeHeaderView else { return nil }
            if let fs = self.firstSection {
                view.firstSection = fs
            }
            view.section = section
            view.selectedCateIndex = self.selectedCateIndex
            view.setCellInfo(module: data, target: self)
            
            // 더보기 데이터 ajaxURL 저장
            if !data.ajaxTabPrdListUrl.isEmpty {
                self.moreAjaxPageUrl = data.ajaxTabPrdListUrl
            }
            return view
        } else if data.viewType == Const.ViewType.TAB_ANK_GBA.name || data.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTAB_SLD_GBBtypeHeaderView.reusableIdentifier) as? SectionTAB_SLD_GBBtypeHeaderView else { return nil }
            if let fs = self.firstSection {
                view.firstSection = fs
            }
            view.section = section
            view.viewType = data.viewType
            view.selectedCateIndex = self.selectedCateIndex
            view.setData(data, target: self)
            return view
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: 0.0))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionData = self.dataList[safe: section] else { return .zero }
        guard let data = sectionData.first else { return .zero }
        
        if (data.viewType == Const.ViewType.TAB_SLD_GBA.name || data.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name),
            data.moduleList.count > 0 {
            return 80.0
        }
        
        if data.viewType == Const.ViewType.TAB_SLD_GBB.name,
            data.moduleList.count > 0 {
            return 50.0
        }
        
        if (data.viewType == Const.ViewType.TAB_ANK_GBA.name || data.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name),
            data.moduleList.count > 0 {
            return 46.0
        }
        
        return .zero
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionData = self.dataList[safe: indexPath.section] else { return UITableViewCell() }
        guard var data = sectionData.first else { return UITableViewCell() }

        // 탭고정인 경우
        if self.isCategoryModule,
            (data.viewType == Const.ViewType.TAB_SLD_GBA.name
                || data.viewType == Const.ViewType.TAB_SLD_GBB.name) {
            if let prd = data.productList[safe: indexPath.row], let module = Module(JSON: prd.toJSON()) {
                data = module
            }
        }
        
        // GS혜택 - 엥커 + 텝고정인 경우
        if data.viewType == Const.ViewType.TAB_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name {
            if let module = data.productList[safe: indexPath.row] {
                data = module
            }
        }
        
        if data.viewType == Const.ViewType.BAN_IMG_H000_GBC.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionBAN_IMG_H000_GBBtypeCell.reusableIdentifier) as? SectionBAN_IMG_H000_GBBtypeCell {
            cell.selectionStyle = .none
            cell.aTarget = self
            cell.setData(data, indexPath: indexPath)
            return cell
        }
        
        if data.viewType == Const.ViewType.BAN_IMG_H000_GBD.name || self.checkDinamicImageBanner(viewType: data.viewType),
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionBAN_IMG_H000_GBAtypeCell.reusableIdentifier) as? SectionBAN_IMG_H000_GBAtypeCell {
            cell.selectionStyle = .none
            cell.aTarget = self
            cell.setData(data, indexPath: indexPath)
            return cell
        }
        
        if data.viewType == Const.ViewType.BAN_SLD_GBE.name {
            
            // product List 갯수에 따라 cell 분기
            if data.productList.count > 1,
                let cell = tableView.dequeueReusableCell(withIdentifier: SectionBAN_SLD_GBEtypeCell.reusableIdentifier) as? SectionBAN_SLD_GBEtypeCell {
                cell.selectionStyle = .none
                cell.aTarget = self
                cell.setCellInfoNDrawData(data.toJSON())
                return cell
            }
            
            if data.productList.count == 1,
                let cell = tableView.dequeueReusableCell(withIdentifier: SectionBAN_SLD_GBE_ONEtypeCell.reusableIdentifier) as? SectionBAN_SLD_GBE_ONEtypeCell {
                cell.selectionStyle = .none
                cell.aTarget = self
                cell.setCellInfoNDrawData(data.toJSON())
                return cell
            }
        }
        
        if data.viewType == Const.ViewType.BAN_SLD_GBF.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionBAN_SLD_GBFtypeCell.reusableIdentifier) as? SectionBAN_SLD_GBFtypeCell {
            cell.selectionStyle = .none
            cell.aTarget = self
            cell.setCellInfoNDrawData(data)
            return cell
        }
        
        if data.viewType == Const.ViewType.BAN_MUT_GBA.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionBAN_MUT_GBAtypeCell.reusableIdentifier) as? SectionBAN_MUT_GBAtypeCell {
            cell.selectionStyle = .none
            cell.aTarget = self
            
            // 카테고리의 ProductList 데이터인 경우
            if let product = data.productList[safe: indexPath.row],
                product.viewType == Const.ViewType.BAN_MUT_GBA.name {
                cell.setCellInfoNDrawData(product)
                return cell
            }
            
            cell.setCellInfoNDrawData_Module(data)
            return cell
        }
        
        if data.viewType == Const.ViewType.BAN_IMG_F80_L_GBA.name || data.viewType == Const.ViewType.BAN_IMG_F80_C_GBA.name || data.viewType == Const.ViewType.BAN_IMG_F80_R_GBA.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionBAN_IMG_F80_X_GBAtypeCell.reusableIdentifier) as? SectionBAN_IMG_F80_X_GBAtypeCell {
            cell.selectionStyle = .none
            cell.setCellInfoNDrawData(data)
            return cell
        }
        
        if data.viewType == Const.ViewType.PMO_T1_PREVIEW_B.name {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PMO_T1_PREVIEW_BCell.reusableIdentifier) as? PMO_T1_PREVIEW_BCell  else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.aTarget = self
            cell.setData(data.toJSON(), indexPath: indexPath, isNFXCType: true)
            return cell
        }

        
        if (data.viewType == Const.ViewType.BAN_TXT_IMG_LNK_GBA.name || data.viewType == Const.ViewType.BAN_TXT_IMG_LNK_GBB.name),
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionBAN_TXT_IMG_LNK_GBAtypeCell.reusableIdentifier) as? SectionBAN_TXT_IMG_LNK_GBAtypeCell {
            cell.selectionStyle = .none
            cell.setCellInfoNDrawData(data.toJSON())
            return cell
        }
        
        if data.viewType == Const.ViewType.NO_DATA.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: SCH_BAN_NO_DATATypeCell.reusableIdentifier) as? SCH_BAN_NO_DATATypeCell {
            cell.selectionStyle = .none
            cell.setCellInfoNDrawData([:])
            return cell
        }
        
        if (data.viewType == "PRD_1_640" || data.viewType == "PRD_1_550"),
            let cell = tableView.dequeueReusableCell(withIdentifier: PRD_1Cell.reusableIdentifier) as? PRD_1Cell {
            cell.selectionStyle = .none
            cell.mTarget = self
            cell.setDivider( self.checkDivider(data.viewType, indexPos: indexPath) )
            cell.setCellInfoNDrawData(data.toJSON(), mPath: indexPath as NSIndexPath)
            return cell
        }
        
        if data.viewType == "PRD_2",
            let cell = tableView.dequeueReusableCell(withIdentifier: PRD_2Cell.reusableIdentifier) as? PRD_2Cell {
            cell.selectionStyle = .none
            cell.aTarget = self
            cell.setDivider( self.checkDivider(data.viewType, indexPos: indexPath) )
            if data.subProductList.count > 0 {
                cell.setData(data.toJSON(), indexPath: indexPath)
            }
            return cell
        }
        
        if data.viewType == "PRD_C_B1",
            let cell = tableView.dequeueReusableCell(withIdentifier: PRD_C_B1Cell.reusableIdentifier) as? PRD_C_B1Cell {
            cell.selectionStyle = .none
            cell.aTarget = self
            cell.setDataListForModule(data.toJSON(), indexPath : indexPath)
            return cell
        }
        
        if data.viewType == "PRD_C_SQ",
            let cell = tableView.dequeueReusableCell(withIdentifier: PRD_C_SQCell.reusableIdentifier) as? PRD_C_SQCell {
            cell.selectionStyle = .none
            cell.aTarget = self
            cell.setDataListForModule(data.toJSON())
            return cell
        }
        
        if data.viewType == "PMO_T2_PREVIEW",
            let cell = tableView.dequeueReusableCell(withIdentifier: PMO_T2_PREVIEWCell.reusableIdentifier) as? PMO_T2_PREVIEWCell {
            cell.selectionStyle = .none
            cell.aTarget = self
            cell.setData(data.toJSON(), indexPath: indexPath)
            return cell
        }
        
        if data.viewType == "PMO_T2_IMG_C",
            let cell = tableView.dequeueReusableCell(withIdentifier: PMO_T2_IMG_CCell.reusableIdentifier) as? PMO_T2_IMG_CCell {
            cell.atarget = self
            cell.selectionStyle = .none
            cell.setData(data.toJSON(), indexPath: indexPath)
            return  cell
        }
        
        if (data.viewType == Const.ViewType.TAB_SLD_GBB_MORE.name ||
            data.viewType == Const.ViewType.TAB_SLD_GBB_MORE_NOSPACE.name),
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionMAP_CX_GBCMoreCell.reusableIdentifier) as? SectionMAP_CX_GBCMoreCell {
            cell.aTarget = self
            cell.selectionStyle = .none
            cell.setData(data)
            return cell
        }
        
        /// GS혜택 - 롤링 이미지 배너
        if (data.viewType == Const.ViewType.BAN_TXT_IMG_SLD_GBA.name || data.viewType == Const.ViewType.BAN_TXT_IMG_SLD_GBB.name),
            let cell = tableView.dequeueReusableCell(withIdentifier: BAN_TXT_IMG_SLD_GBATypeCell.reusableIdentifier) as? BAN_TXT_IMG_SLD_GBATypeCell {
            cell.selectionStyle = .none
            cell.setData(data, target: self)
            return cell
        }
        
        /// GS헤택 - 바로가기
        if data.viewType == Const.ViewType.BAN_IMG_CX_GBA.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: BAN_IMG_CX_GBATypeCell.reusableIdentifier) as? BAN_IMG_CX_GBATypeCell {
            cell.selectionStyle = .none
            cell.setData(data, target: self, indexPath: indexPath)
            return cell
        }
        
        /// GS혜택 - 틀고정 앵커 하위뷰
        if data.viewType == Const.ViewType.BAN_IMG_TXT_GBA.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: BAN_IMG_TXT_GBATypeCell.reusableIdentifier) as? BAN_IMG_TXT_GBATypeCell {
            cell.selectionStyle = .none
            cell.setData(data, indexPath: indexPath)
            return cell
        }
        
        /// 시그니처 매장
        if data.viewType == Const.ViewType.GR_BRD_GBA.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: GR_BRD_GBATypeCell.reusableIdentifier) as? GR_BRD_GBATypeCell {
            cell.selectionStyle = .none
            cell.setData(data, target: self)
            
            if let lastTime = self.dicGR_BRD_GBA_TimeList[indexPath] ,lastTime != .zero  {
                cell.lastPlayTime = lastTime
            }
            
            return cell
        }
        if data.viewType == Const.ViewType.BAN_SLD_GBG.name,
            let cell = tableView.dequeueReusableCell(withIdentifier: BAN_SLD_GBGTypeCell.reusableIdentifier) as? BAN_SLD_GBGTypeCell {
            cell.selectionStyle = .none
            cell.setData(data, target: self)
            return cell
        }
        
        
        print("!!!!!!! NO ADD ViewTyp !!!!!!!!!  " + data.viewType)
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionData = self.dataList[safe: indexPath.section] else { return .zero }
        guard var data = sectionData.first else { return .zero }
        
        // 탭고정인 경우
        if self.isCategoryModule,
            (data.viewType == Const.ViewType.TAB_SLD_GBA.name || data.viewType == Const.ViewType.TAB_SLD_GBB.name) {
            if let prd = data.productList[safe: indexPath.row], let module = Module(JSON: prd.toJSON()) {
                data = module
            }
        }
        
        
        
        // GS혜택 - 엥커 + 텝고정인 경우
        var isLastRowInSection: Bool = false
        if data.viewType == Const.ViewType.TAB_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name {
            
            // 마지막 Row인지 판단 -> 하단 Bottom 영역값이 다르다...
            if self.dataList.count == indexPath.section + 1,
                data.productList.count == indexPath.row + 1 {
                isLastRowInSection = true
            }
            
            if let module = data.productList[safe: indexPath.row] {
                data = module
            }
        }
        
        if data.viewType == Const.ViewType.BAN_IMG_H000_GBC.name || data.viewType == Const.ViewType.BAN_IMG_H000_GBD.name || self.checkDinamicImageBanner(viewType: data.viewType) {
            if data.calcHeight != 0 {
                //계산된 CALCCELLHEIGHT 가 있으면 이 값을 사용한다.
                var height: CGFloat = CGFloat(data.calcHeight)
                if height <= 0 {
                    height = CGFloat(Common_Util.dpRateOriginVAL(160))
                }
                return height + ( (data.viewType == Const.ViewType.BAN_IMG_H000_GBD.name || self.checkDinamicImageBanner(viewType: data.viewType)) ? COMMON_MARGIN_BOTTOM : 0 )
            } else {
                var bannerHeight: Float = 0.0
                // 높이값에 따른 화면 비율 적용
                if let height = data.height {
                    bannerHeight = Float(height / 2)
                    if bannerHeight <= 0 {
                        bannerHeight = Common_Util.dpRateOriginVAL(160)
                    }
                } else {
                    bannerHeight = Common_Util.dpRateOriginVAL(160)
                }
                
                return CGFloat(Common_Util.dpRateOriginVAL(bannerHeight)) + ( (data.viewType == Const.ViewType.BAN_IMG_H000_GBD.name || self.checkDinamicImageBanner(viewType: data.viewType)) ? COMMON_MARGIN_BOTTOM : 0)
            }
        }
        
        if data.viewType == Const.ViewType.BAN_SLD_GBE.name {
            let count = data.productList.count
            if count > 1 {
                return 56.0 + (getAppFullWidth() / 1.189) + (125 * 0.772) + COMMON_MARGIN_BOTTOM
            } else if count == 1 {
                return 56.0 + (getAppFullWidth() / 1.189) + (92 * 0.692) + COMMON_MARGIN_BOTTOM
            }
            return .zero
        }
        
        if data.viewType == Const.ViewType.BAN_SLD_GBF.name {
            return 300.0 + COMMON_MARGIN_BOTTOM
        }
        
        if data.viewType == Const.ViewType.BAN_MUT_GBA.name {
            return 20.0 + (getAppFullWidth() / 1.361) + 15 + 130 + COMMON_MARGIN_BOTTOM
        }
        
        if data.viewType == Const.ViewType.BAN_IMG_F80_L_GBA.name || data.viewType == Const.ViewType.BAN_IMG_F80_C_GBA.name || data.viewType == Const.ViewType.BAN_IMG_F80_R_GBA.name {
            return 80.0;
        }
        
        if data.viewType == Const.ViewType.BAN_TXT_IMG_LNK_GBA.name || data.viewType == Const.ViewType.BAN_TXT_IMG_LNK_GBB.name {
            return 56.0
        }
        
        if data.viewType == Const.ViewType.NO_DATA.name {
            return 80.0
        }
        
        if data.viewType == "PRD_1_640" || data.viewType == "PRD_1_550"{
            var bannerHeigth:CGFloat = 0
            if data.viewType == "PRD_1_640" {
                bannerHeigth = CGFloat(getAppFullWidth()-32)/2
            }
            else {
                bannerHeigth = CGFloat(getAppFullWidth() - 100)
            }

            // 12 + 24 + 4 + 24 + 8 + 20
            var infoHeigth:CGFloat = 91
            var isHaveBenefitText = false
            let allBenefitArr:[ImageInfo] = data.allBenefit
            for benefit:ImageInfo in allBenefitArr {
                if false == benefit.text.isEmpty {
                    isHaveBenefitText = true
                    break
                }
            }
            
            if isHaveBenefitText || false == data.source?.text.isEmpty {
                let cheigth:CGFloat = Common_Util.attributedBenefitString(data.toJSON(), widthLimit: getAppFullWidth()-32, lineLimit: 1)?.boundingRect(with: CGSize(width: getAppFullWidth()-32, height: 300), options: .usesLineFragmentOrigin, context: nil).size.height ?? 0
                infoHeigth = infoHeigth + cheigth
            }
            else {
                // 혜택 없을때 20 + 8 - 16 = 12만큼 줄이기 0
                infoHeigth = infoHeigth - 12
            }
            return ceil( 16 + bannerHeigth + infoHeigth + self.checkDivider(data.viewType, indexPos: indexPath) )
        }
        
        if data.viewType == Const.ViewType.PRD_2.name {
            // 이미지 높이(전체 넓이 - 양쪽 side 32 - 중앙 margin 11)/2
            let imgHeight:CGFloat = (getAppFullWidth() - (16 * 2) - 11) / 2
            // 이미지 상단 16 + 이미지 하단 12 + 가격 23 + 할인율 14 + 여백 5 + 상품명 36 + 여백 8 + (상품평 20과 + 하단여백 17은 아래 로직에서 처리함 )
            let contentHeight: CGFloat = 16 + 12 + 23 + 14 + 5 + 36 + 8
            let height:CGFloat = imgHeight + contentHeight + 1
            // 혜택 유무 판단
            var benefitHeight:CGFloat = 0.0
            // 상품평 유무
            var reviewHeight:CGFloat = 0.0
            var isHaveReview = false
            
            if data.subProductList.count > 0 {
                for prd in data.subProductList {
                    var tempHeight: CGFloat = 0.0
                    if let benefitAttributedStr = Common_Util.attributedBenefitString(prd.toJSON(), widthLimit: imgHeight, lineLimit: 2),
                        benefitAttributedStr.length > 0 {
                        tempHeight = benefitAttributedStr.size().height
                    }
                    if benefitHeight < tempHeight {
                        benefitHeight = tempHeight
                    }
                    
                    if prd.addTextLeft.isEmpty == false ||
                        prd.addTextRight.isEmpty == false {
                        isHaveReview = true
                    }
                }
            }
            
            // 혜택높이가 1줄일때는 18pt , 2줄일때는 36pt, 하단 여백 9pt
            if benefitHeight > 0 && benefitHeight < 18.0 {
                benefitHeight = 18.0
            }
            
            if benefitHeight > 18 && benefitHeight < 36.0 {
                benefitHeight = 36.0
            }
            
            if benefitHeight <= 0.0 {
                // 혜택뷰 하단이 9이며, 상품명 하단여백 8에서 1을 더해줘야 함.
                benefitHeight += 1
            } else {
                // 혜택뷰 하단이 9
                benefitHeight += 9.0
            }
            
            if isHaveReview {
                // (상품평 20과 + 하단여백 17 로직 )
                reviewHeight = 20.0 + 17.0
            } else {
                // 하단여백 17.0 으로 맞춰야해서, 기본 8.0에다가 9.0을 더해줘야 함
                reviewHeight = 9.0
            }
            return height + benefitHeight + reviewHeight + self.checkDivider(data.viewType, indexPos: indexPath)
        }
        
        if data.viewType == "PRD_C_B1" {
            // 타이틀이 없을떄의 상단 Top 높이 16
            var titleHeight:CGFloat = 16.0
            
            // 타이틀 / 광고 / 더보깅에 따른 높이 변화...
            if data.name.isEmpty && data.tabImg.isEmpty && data.subName.isEmpty {
                if data.badgeRTType == "MORE" || data.badgeRTType == "AD" {
                    titleHeight = 56
                }
            } else {
                titleHeight = 56
            }
            
            // 상단 Top 높이 + 캐로셀 높이 249 + 하단여백 10
            let height = titleHeight + 249 + 10
            return height
            
        }
        
        if data.viewType == "PRD_C_SQ" {
            // 타이틀이 없을떄의 상단 Top 높이 16
            var titleHeight:CGFloat = 16.0
            
            // 타이틀 / 광고 / 더보깅에 따른 높이 변화...
            if data.name.isEmpty && data.tabImg.isEmpty && data.subName.isEmpty {
                if data.badgeRTType == "MORE" || data.badgeRTType == "AD" {
                    titleHeight = 56
                }
            } else {
                titleHeight = 56
            }
            
            // 공통 타이틀 + 캐로셀 높이 247 + 하단여백
            let height = titleHeight + 247 + 10
            return height
        }
        
        if data.viewType == Const.ViewType.PMO_T1_PREVIEW_B.name {
            // 화면 가로길이 2:1높이 + 하단 고정높이 188 + 하단여백 10
            var bottomHeight: CGFloat = 188.0//
            
            if getAppFullWidth() > 375 {
                return 375 + 10
            }
            else {

                if isiPhone5() {
                    bottomHeight = getAppFullWidth() / 2
                }
                return getAppFullWidth() / 2 + bottomHeight + 10
            }
            
        }
        
        if data.viewType == "PMO_T2_PREVIEW" {
            // 이미지 높이 + 캐로셀 87 + 하단여백 10
            return ((188.0 / 375.0) * getAppFullWidth()) + 87.0 + 10.0
        }
        
        if data.viewType == "PMO_T2_IMG_C" {
            return CGFloat(Common_Util.dpRateOriginVAL(160) + 10)
        }
        
        if data.viewType == Const.ViewType.TAB_SLD_GBB_MORE.name {
            // 네비 8.3 이상의 새벽배송 매장 카테고리(엥커+텝) 더보기 - 하단 여백 존재
            // 기본 44 + 하단여백 10
            return 44.0 + 10
        }
        
        if data.viewType == Const.ViewType.TAB_SLD_GBB_MORE_NOSPACE.name {
            // 네비 8.2 이하의 새벽배송 매장 카테고리 더보기 - 하단 여백 없음
            // 기본 44
            return 44.0
        }
        
        /// GS혜택 - 롤링 이미지 배너
        if data.viewType == Const.ViewType.BAN_TXT_IMG_SLD_GBA.name {
            return 284.0/375.0  * getAppFullWidth()
        }
        
        /// GS헤택 - 바로가기
        if data.viewType == Const.ViewType.BAN_IMG_CX_GBA.name {
            if data.moduleList.count <= 2 {
                return 88.0 + 10.0
            }
            // 고정높이 110 + 하단여백 10
            return 110 + 10.0
        }
        
        /// GS혜택 - 틀고정 앵커 하위뷰
        if data.viewType == Const.ViewType.BAN_IMG_TXT_GBA.name {
            // 상단여백 6, 이미지비율(375기준 좌우 8pt값 뺀), 타이틀영역 80, 하단여백 6
            var height: CGFloat = 6.0 + (180.0/359.0 * (getAppFullWidth() - 16.0)) + 80.0 + 6.0
            if indexPath.row == 0 {
                height += 6.0 // 첫번째 index Cell은 상단마진 +6.0
            }
            
            if isLastRowInSection {
                // 마지막 Row인지 판단 -> 하단 Bottom 영역값이 다르다...
                height += 16
            }
            return height
        }
        
        /// 시그니처 매장
        if data.viewType == Const.ViewType.GR_BRD_GBA.name {
            
            //
            //
            
            if self.dataList.count > indexPath.section {
                let nextIndex : Int = indexPath.section + Int(1)

                guard let nextSectionData = self.dataList[safe: nextIndex] else {
                    return self.getTotalHeightGR_BRD_GBA(data , nextViewType: "")
                }
                guard let nextData = nextSectionData.first else {
                    return self.getTotalHeightGR_BRD_GBA(data , nextViewType: "")
                }
                
                return self.getTotalHeightGR_BRD_GBA(data , nextViewType: nextData.viewType)
                
            }else{
                return self.getTotalHeightGR_BRD_GBA(data , nextViewType: "")
            }
            
            
        }
        
        if data.viewType == Const.ViewType.BAN_SLD_GBG.name{
            return 244.0
        }
        
        print("!!!!!!! NO ADD ViewTyp !!!!!!!!!  " + data.viewType)
        return .zero
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionData = self.dataList[safe: indexPath.section] else { return }
        guard var data = sectionData.first else { return }

        // 탭고정인 경우
        if self.isCategoryModule,
            (data.viewType == Const.ViewType.TAB_SLD_GBA.name || data.viewType == Const.ViewType.TAB_SLD_GBB.name) {
            if let prd = data.productList[safe: indexPath.row], let module = Module(JSON: prd.toJSON()) {
                data = module
            }
        }
        
        // 엥커+텝 고정인 경우
        if (data.viewType == Const.ViewType.TAB_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name) ,
            let module = data.productList[safe: indexPath.row] {
            data = module
        }
        
        // Row 이벤트 무시할 Cell들.
        //PRD_C_B1,PRD_C_SQ,PMO_T2_PREVIEW
        if data.viewType == Const.ViewType.BAN_SLD_GBE.name ||
            data.viewType == Const.ViewType.BAN_SLD_GBF.name ||
            data.viewType == Const.ViewType.PMO_T1_PREVIEW_B.name ||
            data.viewType == "PRD_C_B1" ||
            data.viewType == "PRD_C_SQ" ||
            data.viewType == "PMO_T2_PREVIEW" ||
            data.viewType == "GR_BRD_GBA"
            {
            return
        }
        
        // 탭고정인 경우
        if data.viewType == Const.ViewType.TAB_SLD_GBA.name ||
            data.viewType == Const.ViewType.TAB_SLD_GBB.name {
            // 데이터 확인
            if data.productList.count != 0,
                indexPath.row <= data.productList.count {

                let rowData = data.productList[indexPath.row]
                
                // SectionView의 touchEventTBCell 호출
                self.delegatetarget?.touchEventTBCell?(rowData.toJSON())
                
                guard let urlParser = URLParser.init(urlString: rowData.linkUrl) else { return }
                var prdno = ""
                if let dealNoStr = urlParser.value(forVariable: "dealNo"), !dealNoStr.isEmpty {
                    prdno = "_\(dealNoStr)"
                } else  if let prdStr = urlParser.value(forVariable: "prdid"), !prdStr.isEmpty {
                    prdno = "_\(prdStr)"
                }
                
                // productName을 보낸것인가, linkUrl을 보낼것인가.
                if !rowData.productName.isEmpty {
                    sendGTM(actionStr: self.sectionName + prdno, index: indexPath.row, label: rowData.productName)
                } else {
                    sendGTM(actionStr: self.sectionName + prdno, index: indexPath.row, label: rowData.linkUrl)
                }
            }
            
        } else {
            // SectionView의 touchEventTBCell 호출
            self.delegatetarget?.touchEventTBCell?(data.toJSON())
            guard let urlParser = URLParser.init(urlString: data.linkUrl) else { return }
            var prdno = ""
            if let dealNoStr = urlParser.value(forVariable: "dealNo"), !dealNoStr.isEmpty {
                prdno = "_\(dealNoStr)"
            } else  if let prdStr = urlParser.value(forVariable: "prdid"), !prdStr.isEmpty {
                prdno = "_\(prdStr)"
            }
            sendGTM(actionStr: self.sectionName + prdno, index: indexPath.row, label: data.linkUrl)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //GTM tracker 상하 스크롤중
        if indexPath.section != 0 && indexPath.row%25 == 0 {
            let actionStr = "App_" + self.sectionName + "_Impression"
            sendGTM(actionStr: actionStr, index: indexPath.row)
        }
        
        guard let data = self.dataList[indexPath.section].first else { return }
        // GS혜택 - 롤링 시작
        if data.viewType == Const.ViewType.BAN_TXT_IMG_SLD_GBA.name,
            let rollingCell = cell as? BAN_TXT_IMG_SLD_GBATypeCell {
            rollingCell.setAutoRolling()
        }
        
        // 20180220 페이징 처리 추가
        if self.moreAjaxPageUrl.isEmpty {
            return
        }
        
        let sectionCount = tableView.numberOfSections
        let rowsCount = tableView.numberOfRows(inSection: indexPath.section)
        
        if data.viewType == Const.ViewType.TAB_SLD_GBA.name,
            data.productList.count != 0,
            indexPath.row == rowsCount - 1 {
            // 카테고리 타입인 경우,
            // module객체 안에 있는 productList에 데이터가 있고, 마지막 데이터일 경우, 데이터 추가 조회
            loadMoreDataUrl(indexPath: indexPath)
            return
        } else if (data.viewType == Const.ViewType.TAB_SLD_GBB.name),
            data.productList.count != 0,
            indexPath.row == rowsCount - 1 {
            loadMoreDataUrl(indexPath: indexPath)
            return
        }
        
        if indexPath.section == sectionCount - 1,
            indexPath.row == rowsCount - 1 {
            
            loadMoreDataUrl(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // GS혜택 - 롤링 정지
        guard let sectionData = self.dataList[safe: indexPath.section] else { return }
        guard let data = sectionData.first else { return }

        if data.viewType == Const.ViewType.BAN_TXT_IMG_SLD_GBA.name,
            let rollingCell = cell as? BAN_TXT_IMG_SLD_GBATypeCell {
            rollingCell.setAutoRolling(isStop: true)
        }
        
        if data.viewType == Const.ViewType.GR_BRD_GBA.name,
            let checkCell = cell as? GR_BRD_GBATypeCell{

            if checkCell.videoType == .brightCove {
                if checkCell.playStatus == .play || checkCell.playStatus == .pause{
                    //시그니처 매장용
                    
                   var lastTime = checkCell.getCurrentTime()
                           
                   if lastTime.isNaN || lastTime.isInfinite {
                        lastTime = .zero
                   }
                    
                    self.dicGR_BRD_GBA_TimeList.updateValue(lastTime,forKey: indexPath)
                }else{
                    self.dicGR_BRD_GBA_TimeList.removeValue(forKey: indexPath)
                }
                checkCell.deinitBrightCove()
            }
        }
        
            
        
    }

}
// MARK:- UIScrollView Delegate
extension NFXCListViewController {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollExpandingDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        self.delegatetarget?.customscrollViewDidScroll?(scrollView)
        self.scrollExpandingDelegate?.scrollViewDidScroll?(scrollView)
        
        
        let basePosY = scrollView.frame.height * 0.333
        if let indexPath =  self.tableView.indexPathForRow(at: CGPoint(x: getAppFullWidth()/2, y: basePosY + scrollView.contentOffset.y)) {
            
            // 새벽배송
            if let sectionView = self.tableView.headerView(forSection: indexPath.section) as? SectionTAB_SLD_GBBtypeHeaderView,
                let cell = self.tableView.cellForRow(at: indexPath) as? PRD_2Cell,
                let product = cell.L_product {
                
                sectionView.moveToNextTab(tabSeq: product.tabSeq)
            }
            
            // 내일도착
            if let sectionView = self.tableView.headerView(forSection: indexPath.section) as? SectionTAB_SLD_GBAtypeHeaderView,
                let data = self.dataList[indexPath.section].first,
                let product = data.productList[safe: indexPath.row] {
                
                sectionView.moveToNextTab(tabSeq: product.tabSeq)
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //PulltoRefresh 용
        super.scrollViewWillBeginDragging(scrollView)
        self.scrollExpandingDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //PulltoRefresh 용
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        self.delegatetarget?.customscrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        self.scrollExpandingDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegatetarget?.customscrollViewDidEndDecelerating?(scrollView)
        self.scrollExpandingDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        _ = self.scrollExpandingDelegate?.scrollViewShouldScrollToTop?(scrollView)
        return true
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.scrollExpandingDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}

// MARK:- Private Functions
extension NFXCListViewController {
    private func setupInit() {
        setTableViewRegisterNib()

        self.tableView.separatorStyle = .none
    }
    
    private func setTableViewRegisterNib() {
        /// HEADER (
        self.tableView.register(UINib(nibName: SectionTAB_SLD_GBAtypeHeaderView.reusableIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: SectionTAB_SLD_GBAtypeHeaderView.reusableIdentifier)
        self.tableView.register(UINib(nibName: SectionTAB_SLD_GBBtypeHeaderView.reusableIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: SectionTAB_SLD_GBBtypeHeaderView.reusableIdentifier )
        
        /// CELL
        self.tableView.register(UINib.init(nibName: SectionBAN_TXT_IMG_LNK_GBAtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionBAN_TXT_IMG_LNK_GBAtypeCell.reusableIdentifier)
        
        self.tableView.register(UINib.init(nibName: SectionBAN_SLD_GBEtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionBAN_SLD_GBEtypeCell.reusableIdentifier)
        self.tableView.register(UINib.init(nibName: SectionBAN_SLD_GBE_ONEtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionBAN_SLD_GBE_ONEtypeCell.reusableIdentifier)
        self.tableView.register(UINib.init(nibName: SectionBAN_SLD_GBFtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionBAN_SLD_GBFtypeCell.reusableIdentifier)
        self.tableView.register(UINib.init(nibName: SectionBAN_MUT_GBAtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionBAN_MUT_GBAtypeCell.reusableIdentifier)
        self.tableView.register(UINib.init(nibName: SectionBAN_IMG_H000_GBBtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionBAN_IMG_H000_GBBtypeCell.reusableIdentifier)
        self.tableView.register(UINib.init(nibName: SectionBAN_IMG_H000_GBAtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionBAN_IMG_H000_GBAtypeCell.reusableIdentifier)
        self.tableView.register(UINib.init(nibName: SectionBAN_IMG_F80_X_GBAtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionBAN_IMG_F80_X_GBAtypeCell.reusableIdentifier)
        self.tableView.register(UINib.init(nibName: SectionMAP_CX_GBCtypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SectionMAP_CX_GBCtypeCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: SectionMAP_CX_GBCMoreCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: SectionMAP_CX_GBCMoreCell.reusableIdentifier)
        
        self.tableView.register(UINib(nibName: PRD_1Cell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: PRD_1Cell.reusableIdentifier)
        self.tableView.register(UINib(nibName: PRD_2Cell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: PRD_2Cell.reusableIdentifier)
        self.tableView.register(UINib(nibName: PRD_C_B1Cell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: PRD_C_B1Cell.reusableIdentifier)
        self.tableView.register(UINib(nibName: PRD_C_SQCell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: PRD_C_SQCell.reusableIdentifier)
        
        self.tableView.register(UINib(nibName: PMO_T1_PREVIEW_BCell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: PMO_T1_PREVIEW_BCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: PMO_T2_PREVIEWCell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: PMO_T2_PREVIEWCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: PMO_T2_IMG_CCell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: PMO_T2_IMG_CCell.reusableIdentifier)
        
    
        // GS헤택 매장 UI 개편
        self.tableView.register(UINib(nibName: BAN_TXT_IMG_SLD_GBATypeCell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: BAN_TXT_IMG_SLD_GBATypeCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: BAN_IMG_CX_GBATypeCell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: BAN_IMG_CX_GBATypeCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: BAN_IMG_TXT_GBATypeCell.reusableIdentifier, bundle:  Bundle.main), forCellReuseIdentifier: BAN_IMG_TXT_GBATypeCell.reusableIdentifier)
        
        //NO_DATA
        self.tableView.register(UINib.init(nibName: SCH_BAN_NO_DATATypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: SCH_BAN_NO_DATATypeCell.reusableIdentifier)
        
        // 시그니처 매장
        self.tableView.register(UINib.init(nibName: GR_BRD_GBATypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: GR_BRD_GBATypeCell.reusableIdentifier)
        self.tableView.register(UINib.init(nibName: BAN_SLD_GBGTypeCell.reusableIdentifier, bundle: Bundle.main), forCellReuseIdentifier: BAN_SLD_GBGTypeCell.reusableIdentifier)
        
        
    }
    
    private func setTableViewFooterView() {
        if self.dataList.count <= 0 {
            self.tableView.tableFooterView = nil
            return
        }
        
        let footerFrame = CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getFooterHeight())
        let footerView = SectionTBViewFooter(target: self, nframe: footerFrame)
        footerView?.backgroundColor = UIColor.getColor("e5e5e5")
        self.tableView.tableFooterView = footerView
    }
    
    private func changeTAB_SLD_GBACategory(section: Int, index: Int, productList: [Module]) {
//        if self.selectedCateIndex == idx {
//            // 선택된 카테로기 선택시 Reload 안되도록 return
//            // 2020.01.13. 오류로 올라와서 주석처리
//            return
//        }
        guard let sectionData = self.dataList[safe: section] else { return }
        guard let data = sectionData.first else { return }
        
        self.selectedCateIndex = index
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            
            // 이전 테이블뷰의 틀고정 section에 있는 Row들 삭제
            let rowsCount = self.tableView.numberOfRows(inSection: section)
            let preIndexPaths = (0..<rowsCount).map { IndexPath(row: $0, section: section) }
            self.tableView.deleteRows(at: preIndexPaths, with: .none)
            
            let items = self.itemReMakeProcess(prdList: productList, cateModule: data)
            
            data.productList.removeAll()
            data.productList = items
            
            // 새 데이터들이 있는 row들 추가
            let newRowsCount = getDataCount(data)
            let newIndexPaths = (0..<newRowsCount).map { IndexPath(row: $0, section: section) }
            self.tableView.insertRows(at: newIndexPaths, with: .none)
            
            
            let indexPath = IndexPath(row: 0, section: section)
            let contentOffset = self.tableView.contentOffset
            let firstRowRect = self.tableView.rectForRow(at: indexPath)
            let sectionHeight = tableView(self.tableView, heightForHeaderInSection: section)
            
            if contentOffset.y + sectionHeight > firstRowRect.origin.y {
                UIView.animate(withDuration: 0.0, animations: {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }, completion: { (success) in
                    let rowRect = self.tableView.rectForRow(at: indexPath)
                    let moveToOffset = CGPoint(x: 0, y: rowRect.origin.y - sectionHeight)
                    self.tableView.setContentOffset(moveToOffset, animated: false)
                })
            } else {
                self.tableView.setContentOffset(contentOffset, animated: false)
            }
            
            self.tableView.endUpdates()
        }
    }
    
    /// 카테고리 데이터 더 가져오기
    private func loadMoreDataUrl(indexPath: IndexPath) {
        applicationDelegate.onloadingindicator()
        if self.currentOperation1 != nil {
            self.currentOperation1?.cancel()
        }
        self.currentOperation1 = applicationDelegate.gshop_http_core.gsSECTIONUILISTURL(
            self.moreAjaxPageUrl, isForceReload: true, onCompletion: { (result) in
                guard let resultDic = result as? Dictionary<String, Any> else {
                    self.applicationDelegate.offloadingindicator()
                    return
                }
                
                if let ajaxUrl = resultDic["ajaxfullUrl"] as? String {
                    self.moreAjaxPageUrl = ajaxUrl
                } else {
                    // 더이상 로딩 하지 않음.
                    self.moreAjaxPageUrl = ""
                }
                
                // 데이터 추가
                if let productResultArray = resultDic["productList"] as? Array<[String: Any]> {
                    if productResultArray.count <= 0 {
                        self.moreAjaxPageUrl = ""
                    }
                    var moreProductArray = [Module]()
                    for product in productResultArray {
                        if let data = Module(JSON: product) {
                            moreProductArray.append(data)
                        }
                    }
                    // prd2 처리 로직
                    moreProductArray = self.itemReMakeProcess(prdList: moreProductArray)
                    
                    
                    if moreProductArray.count > 0,
                        let sectionData = self.dataList[safe: indexPath.section],
                        let data = sectionData.first {
                        
                        // 카테고리에서의 더보기
                        if self.isCategoryModule,
                            (data.viewType == Const.ViewType.TAB_SLD_GBA.name || data.viewType == Const.ViewType.TAB_SLD_GBB.name) {
                            
                            data.productList.append(contentsOf: moreProductArray)
                            
                            let rowCount = moreProductArray.count
                            
                            let indexPaths = (0..<rowCount).map { IndexPath(row: $0, section: indexPath.section) }
                            UIView.performWithoutAnimation {
                                self.tableView.beginUpdates()
                                self.tableView.insertRows(at: indexPaths, with: .none)
                                self.tableView.endUpdates()
                            }
                            
                        } else {
                            for (index, product) in moreProductArray.enumerated() {
                                let sectionIndex: Int = (indexPath.section + 1) + index
                                let indexSet = IndexSet(integer: sectionIndex)
                                
                                let rowIndexPath = IndexPath(row: 0, section: sectionIndex)
                                self.dataList.append([product])
                                UIView.performWithoutAnimation {
                                    self.tableView.beginUpdates()
                                    self.tableView.insertSections(IndexSet(indexSet), with: .none)
                                    self.tableView.insertRows(at:[rowIndexPath], with: .none)
                                    self.tableView.endUpdates()
                                }
                            }
                        }
                        
                        
                        
                    } else {
                        // 데이터가 없는 경우
                    }
                }
            
                self.applicationDelegate.offloadingindicator()
        }, onError: { (error) in
            self.applicationDelegate.offloadingindicator()
        })
        
    }
    
    private func sendGTM(actionStr: String, index: Int, label: String = "") {
        applicationDelegate.gtMsendLog(
            "Area_Tracking",
            withAction: "MC_" + actionStr,
            withLabel: DataManager.shared().abBulletVer + "_\(index)" + (label.isEmpty ? "" : "_" + label) )
    }
    
    private func getDataCount(_ data: Module) -> Int {
        if data.viewType == Const.ViewType.TAB_SLD_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_GBB.name
            || data.viewType == Const.ViewType.TAB_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBA.name
            || data.viewType == Const.ViewType.TAB_SLD_ANK_GBB.name{
            return data.productList.count
        } else {
            return 0
        }
    }
    
}

// MARK:- Tap Event & Button Actitons
extension NFXCListViewController {
    
    /// 카테고리 버튼 이벤트 - TAB_SLD_GBA타입
    func onBtnTAB_SLD_GBA(_ module: Module, section: Int, idxClicked idx: Int) {
//        if self.selectedCateIndex == idx {
//            // 선택된 카테로기 선택시 Reload 안되도록 return
//            // 2020.01.13. 오류로 올라와서 주석처리
//            return
//        }
        
        var strApiUrl = ""
        let arrApi = module.ajaxTabPrdListUrl.components(separatedBy: ".gsshop.com/")
        if arrApi.count > 1 {
            strApiUrl = arrApi.last ?? ""
        } else {
            strApiUrl = arrApi.first ?? ""
        }
        
        // 카테고리를 누르면 페이징 URL 초기화
        self.moreAjaxPageUrl = ""
        
        applicationDelegate.onloadingindicator()
        if self.currentOperation1 != nil {
            self.currentOperation1?.cancel()
        }
        self.currentOperation1 = applicationDelegate.gshop_http_core.gsSECTIONUILISTURL(
            strApiUrl, isForceReload: true, onCompletion: { (result) in
                guard let resultDic = result as? Dictionary<String, Any> else {
                    self.applicationDelegate.offloadingindicator()
                    return
                }

                guard let list = resultDic["productList"] as? Array<[String: Any]> else {
                    // 카테고리 페이징 데이터 없음
                    self.moreAjaxPageUrl = ""
                    self.applicationDelegate.offloadingindicator()
                    return
                }
                
                if let ajaxUrl = resultDic["ajaxfullUrl"] as? String {
                    self.moreAjaxPageUrl = ajaxUrl
                }
                
                var productList = [Module]()
                if list.count > 0 {
                    for item in list {
                        if let product = Module.init(JSON: item) {
                            productList.append(product)
                        }
                    }
                    self.changeTAB_SLD_GBACategory(section: section, index: idx, productList: productList)
                } else {
                    if let alert = Mocha_Alert.init(title: Const.Text.error_server.name, maintitle: Const.Text.notice.name, delegate: self, buttonTitle: [Const.Text.confirm.name]) {
                        self.applicationDelegate.window.addSubview(alert)
                    }
                }
                self.applicationDelegate.offloadingindicator()
        }) { (error) in
            self.applicationDelegate.offloadingindicator()
        }
    }
    
    /// 카텍고리 버튼 이벤트 - TAB_SLD_GBB 타입
    func onBtnTAB_SLD_GBB(_ module: Module, section: Int, btnIndex idx: Int) {
        self.selectedCateIndex = idx
        onBtnTAB_SLD_GBA(module, section: section, idxClicked: idx)
    }
    
    /// 단순 링크 이동
    func onBtnCellJustLinkStr(_ linkStr: String) {
        if !linkStr.isEmpty {
            self.delegatetarget?.touchEventTBCellJustLinkStr?(linkStr)
        }
    }
    
    /// Footer 버튼 이벤트
    func btntouchAction(_ sender: UIButton) {
        let tag = sender.tag
        
        if tag == 1005 {
            if let url = URL(string: Const.Url.GS_COMPANY_INFO.url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        } else if tag == 1006 {
            if let url = URL(string: ServerUrl() + Const.Url.GS_COMPANY_GUARANTEE.url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        } else {
            self.delegatetarget?.btntouchAction?(sender)
        }
    }
    
    ///브랜드관, 넘베딜, 그룹매장 상단 쩜쩜쩜 셀 클릭시
    func dctypetouchEventTBCell(dic: [String : Any], index: Int, viewType: String) {
        self.delegatetarget?.touchEventTBCell?(dic)
        let actionStr = self.sectionName + "_Main_" + viewType
        let labael: String = "Main_WeeklyBestDealNo1" == viewType ? (dic["linkUrl"] as? String ?? "") : (dic["productName"] as? String ?? "")
        sendGTM(actionStr: actionStr, index: index, label: labael)
    }
}

// MARK:- LoginViewCtrlPopDelegate
extension NFXCListViewController: LoginViewCtrlPopDelegate {
    func hideLoginViewController(_ loginviewtype: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 1초 뒤에 //로그인 성공시 이동
            self.onBtnCellJustLinkStr(self.curRequestString)
        }
    }
    
    func definecurrentUrlString() -> String! {
        return self.curRequestString
    }
    
    
}

// MARK:- unkwon functions
extension NFXCListViewController {
    @objc func sectionArrDataNeedMoreData(aType: PAGEACTIONTYPE) {
        print("kiwon : sectionArrDataNeedMoreData")
    }
    
}

// MARK:- 임시 Delegate {
extension NFXCListViewController: Mocha_AlertDelegate {
    func customAlert(_ alert: UIView!, clickedButtonAt index: Int) {
        let tag = alert.tag
        
        
        if tag == 55 {
            if index == 1 {
                if self.curRequestString.isEmpty == false {
                    self.onBtnCellJustLinkStr(self.curRequestString)
                }
                self.curRequestString = ""
            }
            else {
                self.curRequestString = ""
            }
            
        }
    }
}

