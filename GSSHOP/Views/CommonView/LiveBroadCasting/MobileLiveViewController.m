//
//  MobileLiveViewController.m
//  GSSHOP
//
//  Created by nami0342 on 04/01/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "MobileLiveViewController.h"
#import "AppDelegate.h"
#import "MobileLiveAdminTalkCell.h"
#import "MobileLiveUserTalkCell.h"
#import "PrePrdView.h"
#import "MobileLiveProductCell.h"
#import <QuartzCore/QuartzCore.h>


#define CSP_STATUS_CONNECTED            3
#define INPUTTEXT_PLACEHOLDER_STRING    @"실시간 채팅 참여하기"   // 대화 입력창 Place holder
#define ML_SWITCH_BUTTON_TAG_PRODUCT    10                  //
#define ML_SWITCH_BUTTON_TAG_CHAT       11                  //
#define CSP_RECONNECT_TIME              60.0                // CSP 서버 미 접속 시 재 접속 타이머
#define NOTICE_ROLLING_TIME             5.0                 // 공지 사항 롤링 타이머

// Height
#define SWITCH_BOTTOM_HEGIHT_PRODUCT    146                 // 상품에서의 스위치 버튼 높이 기준

//
#define ALARM_SINGLE_VIEW_HIDDEN        0
#define ALARM_SINGLE_VIEW_SHOW          93
#define NOTICE_LABEL_HEIGHT             18


//#define API_MOBILELIVE_PRODUCT          @"http://tm14.gsshop.com/app/section/mobilelive/2675/0"



@interface MobileLiveViewController ()

// Login
@property (nonatomic, strong) AutoLoginViewController       *loginView;                 // 로그인 뷰 컨트롤러

// API
@property (nonatomic, strong) NSString                      *m_strAPIURL;               // API

// CSP
@property (nonatomic, strong) NSString                      *strCSP_NI;                 // CSP 사용자 이름
@property (nonatomic, readwrite) BOOL                       m_isConnectCSP_PCID;        // CSP 비 로그인 시 PCID로 접속했는지 체크

// Top View
@property (nonatomic, strong) IBOutlet UILabel              *m_lbPV;                    // CSP 현재 접속 사용자 수
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctPVlabelWidth;

@property (nonatomic, strong) IBOutlet UILabel              *m_lbRemainTime;            // 방송 남은 시간
@property (nonatomic, strong) NSTimer                       *m_timerRemainTime;         // 방송 남은 시간 타이머
@property (nonatomic, strong) IBOutlet UIImageView          *m_imgvLive;                // 시간 표시 배경 이미지 - 시간 단위일 때는 다른 이미지로 교체 함. (기본 분초 배경 이미지)
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctImgvLiveWidth;         // 분초 이미지와 시분초 이미지의 배경 넓이 조정용
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctLeftMarginTime;        // 분초 생방송, 재방송 이미지 대응 왼쪽 간격
@property (nonatomic, assign) BOOL                          m_isLiveStatus;             // 라이브 / 재방송 상태 정보 저장
@property (nonatomic, strong) IBOutlet UIButton             *m_btnMute;                 // 음소거 on/ off

// Player
@property (retain,nonatomic) IBOutlet UIView                *LivePlayerView;            // 생방송 플레이어 뷰
@property (retain, nonatomic) AVPlayerLayer                 *playerLayer;               // 플레이어 레이어
@property (retain, nonatomic) AVPlayer                      *moviePlayer;               // 플레이어
@property (nonatomic, strong) NSString                      *m_strPlayURL;              // 플레이 URL
@property (assign, nonatomic) BOOL                          isPlaying;                  // 미사용



// Chatting
@property (nonatomic, strong) IBOutlet UIView               *vChattingView;             // 채팅 뷰
@property (nonatomic, strong) IBOutlet UITextField          *tfInput;                   // 입력 창
@property (nonatomic, assign) IBOutlet NSLayoutConstraint   *m_ctInputViewHeight;       // 입력창 높이
@property (nonatomic, assign) IBOutlet NSLayoutConstraint   *m_ctChatHeight;            // 채탱뷰 높이
@property (nonatomic, assign) IBOutlet NSLayoutConstraint   *m_ctChatBottom;            // 입력창 바닥에서의 높이
@property (nonatomic, strong) IBOutlet UIButton             *m_btnSend;                 // 입력 전송
@property (nonatomic, strong) NSMutableDictionary           *m_marTableViewHeight;      // 전체 테이블 뷰의 높이 계산용이나 미 사용 - 채팅셀의 높이 계산을 위해 최초 입력 시 바닥이 아닌 상단에서 시작 협의 (디자이너)
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctInputBGRight;          // Text InputBox 오른쪽 여백 (버튼이나, 방송알림 노출을 위한 공간 확보용)
;               //

@property (nonatomic, strong) IBOutlet UIView               *m_bgInputTextBack;         // 입력창 텍스트 전체 배경 (흰색)
@property (nonatomic, strong) IBOutlet UIView               *m_bgInputText;             // 입력창 텍스트 영역 라운드 배경
@property (nonatomic, strong) IBOutlet UIView               *m_toastView;               // 신규 입력 시 노출용 토스트
@property (nonatomic, strong) IBOutlet UILabel              *m_lbToastMessage;          // 토스트 메시지
@property (nonatomic, readwrite) BOOL                       m_isChatPositionBottom;     // 채팅 스크롤이 맨 바닥인지 체크용.
@property (nonatomic, strong) IBOutlet UILabel              *m_lbShowChatLost;          // CSP 접속 불가에 따른 채팅 입력 불가 노출 뷰
@property (nonatomic, strong) CAGradientLayer               *m_grvGradient;             // 채팅 영역 상/하단 그라데이션 처리 - 딜레이가 있어. 향후 추가 협의 (디자이너)
@property (nonatomic, strong) NSTimer                       *m_timerReconnectCSP;       // CSP 재 접속용 타이머
@property (nonatomic, assign) BOOL                          m_isChatHide;               // 채팅 뷰 히든 처리 (음식 같은 상품 시

// 방송알림
@property (nonatomic, assign) IBOutlet UIView               *m_bgAlarmView;
@property (nonatomic, assign) IBOutlet NSLayoutConstraint   *m_ctAlarmButtonWidth;             // 방송알림 버튼 너비
@property (nonatomic, readwrite) BOOL                       m_isAlarmDone;              // 알림 클릭 여부

// 방송알림 독립 형
@property (nonatomic, assign) IBOutlet UIView              *m_vAlarmSingleView;





@property (nonatomic, strong) NSMutableArray                *m_arDatas;                 // 채팅 데이터 저장용
@property (nonatomic, readwrite) CGFloat                    m_fSafeAreaBottomHeight;    // 기준 SafeArea 파악용



// Notice
@property (nonatomic, strong) IBOutlet UIView               *bgNotice;                  // 공지사항 전체 뷰
@property (nonatomic, strong) IBOutlet UIImageView          *imgNotice;                 // 공지사항 이미지
@property (nonatomic, strong) IBOutlet UILabel              *lbNotice;                  // 공지사항 첫 번째 라벨 (스크롤뷰에 하나 붙여놨음)
@property (nonatomic, strong) IBOutlet UIScrollView         *scvNotice;                 // 공지사항 스크롤 뷰
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctNoticeHeight;          // 공지사항 높이
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctNoticeWidth;           // 공지사항 너비

@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctNotiAttatchBottom;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctNotiAttachChat;


@property (nonatomic, strong) NSMutableArray                *m_marNotice;               // 공지사항 전체 데이터 배열
@property (nonatomic, strong) NSMutableArray                *m_marNoticeView;           // 공지사항 스크롤용 라벨 배열
@property (nonatomic, strong) NSTimer                       *m_timerNotice;             // 공지사항 롤링 타이머
@property (nonatomic, strong) CAGradientLayer *maskLayer_Notice;




// Product list
@property (nonatomic, strong) NSMutableArray                *m_marProductList;          // 상품 배열 용
@property (nonatomic, strong) NSDictionary                  *m_dicAPI;                  // API 응답 Json 저장
@property (nonatomic, strong) IBOutlet NSLayoutConstraint   *m_ctScrollViewBottomHeight;// 상품 스크롤 하단에서의 높이 조정
@property (nonatomic, strong) IBOutlet UIPageControl        *m_pcProductList;           // 상품 페이지 컨트롤
@property (nonatomic, assign) int                           m_iCollectionIndex;         // 상품 순서 노출 위치


// Keyboard Hide and show
@property (nonatomic, readwrite) BOOL               m_isKeyboardShow;                   // 키보드 노출 여부

// Product view showing
@property (nonatomic, readwrite) BOOL               m_isProductViewShow;                // 상품리스트 노출 여부
@property (nonatomic, strong) PrePrdView            *viewPrePrd;                        // 미리보기 뷰

@property (nonatomic, strong) IBOutlet UICollectionView *colViewProduct;                // 상품 리스트 스크롤용 콜렉션 뷰
@property (nonatomic, assign) BOOL                      isPrdCenterScroll;              //


// 기타
@property (nonatomic, strong) NSString                      *m_strGatePageURL;                  // 종료 시 호출할 게이트 페이지 (API 에서 내려받음)
@property (nonatomic, strong) IBOutlet UIImageView          *m_vDimBottom;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *m_lcontTVChatBottom;         // 채팅내용 테이블뷰 bottom;
// 방송알림 팝업
@property (nonatomic, strong) IBOutlet UIImageView          *m_imgVAlarm;
@property (nonatomic, assign) NSInteger g_iNoticeIndex;
@property (nonatomic, assign) BOOL                          m_isFirstMessageLoading;


@end




@implementation MobileLiveViewController
@synthesize strCSP_ID = _strCSP_ID;
@synthesize m_contentURL = _m_contentURL;
@synthesize m_cspChat = _m_cspChat;
@synthesize m_ctChatBottom = _m_ctChatBottom;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ///////////////////
        // Init CSP
        self.m_cspChat = [[CSP_Base alloc] init];
        self.m_cspChat.delegate = self;
        ///////////////////
        
        self.m_isLiveStatus = YES;          // 생방송으로 최초 세팅
        
        self.tvChat.delegate = self;
        self.tvChat.dataSource = self;
        
        self.m_arDatas = [[NSMutableArray alloc] initWithCapacity:100];
        
        // Notice
        self.m_marNotice = [[NSMutableArray alloc] initWithCapacity:10];
        self.m_marNoticeView = [[NSMutableArray alloc] initWithCapacity:10];
        
        // Get API Data
        self.m_marProductList = [[NSMutableArray alloc] initWithCapacity:5];
        
        //앱 포그라운드 진입 노티
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAudioSessionInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        
        
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [ApplicationDelegate setAmplitudeEvent:@"View-모바일라이브-생방송페이지"];
    // Get API URL from toapp string
    if([self getAPIURLwithLiveStatus] == NO)
    {
        // 생방송중이 아니다.
        // 수정 필요 - Show alert popup
        return;
    }
    
    self.viewPrePrd = [[[NSBundle mainBundle] loadNibNamed:@"PrePrdView" owner:self options:nil] lastObject];
    self.viewPrePrd.frame = CGRectMake(0.0, APPFULLHEIGHT, APPFULLWIDTH, APPFULLHEIGHT);
    [self.view addSubview:self.viewPrePrd];
    
    [self.tvChat registerNib:[UINib nibWithNibName:@"MobileLiveAdminTalkCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MobileLiveAdminTalkCell"];
    [self.tvChat registerNib:[UINib nibWithNibName:@"MobileLiveUserTalkCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MobileLiveUserTalkCell"];
    
    self.tvChat.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tvChat.rowHeight = UITableViewAutomaticDimension;
    
    [self hideNoticeArea:YES];

    // 그라데이터 처리하려했으나... 나중에 적용 예정
//    CAGradientLayer *graWhiteAlpha = [self setWhiteAlphaGradientLayer];
//    graWhiteAlpha.frame = self.m_vGradient.bounds;
//    [self.m_vGradient.layer insertSublayer:graWhiteAlpha above:0];
    
    [self.colViewProduct registerNib:[UINib nibWithNibName:@"MobileLiveProductCell" bundle:nil] forCellWithReuseIdentifier:@"MobileLiveProductCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkstatus:)
                                                 name:NSNotification.NetworkReachabilityDidChange object:nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
    self.m_fSafeAreaBottomHeight = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        //        CGFloat topPadding = window.safeAreaInsets.top;
        self.m_fSafeAreaBottomHeight = window.safeAreaInsets.bottom;
        NSLog(@"%@", NSStringFromUIEdgeInsets(window.safeAreaInsets));
        NSLog(@"%@", NSStringFromUIEdgeInsets(window.layoutMargins));
    }
    else
    {
        if(IS_IPHONE_X_SERISE)
        {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            self.view.frame = CGRectMake(0, window.layoutMargins.top, APPFULLWIDTH, APPFULLHEIGHT - window.layoutMargins.top - window.layoutMargins.bottom);
            self.m_fSafeAreaBottomHeight = window.layoutMargins.bottom;
        }
        else if(IS_IPHONE)
        {
            // 11.0 이하는 viewdidappear 에서 처리
//            self.view.frame = CGRectMake(0, 20, APPFULLWIDTH, APPFULLHEIGHT - 20);
        }
        else if(IS_IPAD)
        {
            // 11.0 이하는 viewdidappear 에서 처리
            NSLog(@"%@", NSStringFromCGRect(self.view.frame));
//            self.view.frame = CGRectMake(0, 20, APPFULLWIDTH, APPFULLHEIGHT - 40);
//            self.view.bounds = CGRectMake(0, -20, APPFULLWIDTH, APPFULLHEIGHT);
        }
        else if(IS_IPAD_PRO)
        {
            self.view.frame = CGRectMake(0, 20, APPFULLWIDTH, APPFULLHEIGHT - 20);
        }
    }
    
    if(IS_IPHONE_X_SERISE == NO)
    {
        self.m_fSafeAreaBottomHeight = 0;
    }
    
    /////////////////
    // 채팅 창 높이를 가변으로 설정하기 위함. (하단부터 채팅 내용 노출 시키기 위해서 처리
    self.m_marTableViewHeight = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    
    // Set Message Input color
    self.m_bgInputTextBack.hidden = YES;
    [self.m_bgInputText.layer setCornerRadius:18];
    self.m_bgInputText.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    [self.m_bgInputText.layer setBorderWidth:1];
    self.tfInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:INPUTTEXT_PLACEHOLDER_STRING attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    
    // 글 입력 창에 방송알림 노출
//    self.m_ctInputBGRight.constant = 118;
//    self.m_bgAlarmView.hidden = NO;
    
    self.m_lbShowChatLost.layer.cornerRadius = 6.0;
    self.m_lbShowChatLost.clipsToBounds=YES;
    //
    [self.bgNotice.layer setCornerRadius:13];
    [self.bgNotice.layer setBorderWidth:0];
    
    self.maskLayer_Notice = [CAGradientLayer layer];
    self.maskLayer_Notice.colors = @[(id)[[Mocha_Util getColor:@"7f74ac"] CGColor], (id)[[Mocha_Util getColor:@"4a89b6"] CGColor]];
    
    self.maskLayer_Notice.startPoint = CGPointMake(0.0, 0.5);
    self.maskLayer_Notice.endPoint = CGPointMake(1.0, 0.5);
    self.maskLayer_Notice.locations = @[[NSNumber numberWithFloat:0.0],
                            [NSNumber numberWithFloat:0.4],
                            [NSNumber numberWithFloat:0.6],
                            [NSNumber numberWithFloat:1.0]];
    
    self.maskLayer_Notice.bounds = CGRectMake(0, 0,
                                  _bgNotice.frame.size.width,
                                  self.bgNotice.frame.size.height);
    self.maskLayer_Notice.anchorPoint = CGPointZero;
    self.maskLayer_Notice.cornerRadius = 13;
    [self.bgNotice.layer insertSublayer:self.maskLayer_Notice atIndex:0];
    
    [self getMobileLiveAPI];
    
    // 공지사항
    self.m_ctNotiAttatchBottom.active = NO;
    self.m_ctNotiAttachChat.active = YES;
    self.g_iNoticeIndex = 0;
    self.m_isFirstMessageLoading = YES;
    
    [self.view layoutIfNeeded];
    // nami0342 - 진입 시 효율 호출
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=418019")];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0){
        return UIStatusBarStyleLightContent;
    }else{
        return UIStatusBarStyleDefault;
    }
    
    
}

// 단말 네트워크 상태 처리
- (void) networkstatus : (NSNotification *) noti
{
    if([NetworkManager.shared currentReachabilityStatus] == NetworkReachabilityStatusNotReachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // CSP 연결 종료
            self.m_lbShowChatLost.hidden = NO;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // CSP 연결 성공
            if(self.m_cspChat.m_socket.status == CSP_STATUS_CONNECTED)
            {
                self.m_lbShowChatLost.hidden = YES;
            }
        });
    }
}



// Get API URL From URL String
- (BOOL) getAPIURLwithLiveStatus
{
    BOOL iReturn = NO;
    
    if(self.m_toappString.length > 0)
    {
        NSArray *arTemp = [self.m_toappString componentsSeparatedByString:@"?"];
        
        if(arTemp.count == 1)
            return iReturn;
        
        NSString *strSeperate = [arTemp objectAtIndex:1];
        NSArray *arTemp1 = [strSeperate componentsSeparatedByString:@"&"];
        
        for(NSString *strTemp in arTemp1)
        {
            if([strTemp hasPrefix:@"topapi="] == YES)
            {
                if(strTemp.length > 7)
                {
                    self.m_strAPIURL = [strTemp substringFromIndex:7];
                    iReturn = YES;
                }
            }
            
//            // 생방송 판단은 이전 게이트 페이지에서 처리하기로 해서 무쓸모나 놔둬 봄.
//            else if([strTemp hasPrefix:@"onAirYn="] == YES)
//            {
//                if(strTemp.length == 9 )
//                {
//                    NSString *strOnAir = [strTemp substringFromIndex:8];
//                    if([[strOnAir lowercaseString] isEqualToString:@"y"] == YES)
//                    {
//                        self.m_isLiveStatus = YES;
//                    }
//                    else
//                    {
//                        self.m_isLiveStatus = NO;
//                    }
//                }
//            }
        }
    }
    
    return iReturn;
}



- (IBAction) click_Close:(id)sender
{
    [self.m_arDatas removeAllObjects];
    [self.m_marTableViewHeight removeAllObjects];
    [self.m_marNotice removeAllObjects];
    [self.m_marNoticeView removeAllObjects];
    [self.m_marProductList removeAllObjects];
    
    [self.moviePlayer pause];
    [self.playerLayer removeFromSuperlayer];
    
    
    // CSP 연결종료
    [self.m_cspChat CSP_Disconnect];
    self.m_cspChat.delegate = nil;
    self.m_cspChat = nil;
    
    if([self.m_timerNotice isValid])
        [self.m_timerNotice invalidate];
    
    if([self.m_timerRemainTime isValid])
        [self.m_timerRemainTime invalidate];
    
    if([self.m_timerReconnectCSP isValid])
        [self.m_timerReconnectCSP invalidate];
    
    self.tvChat.delegate = nil;
    self.tvChat.dataSource = nil;
    self.playerLayer.delegate = nil;
    self.tfInput.delegate = nil;
    self.scvNotice.delegate = nil;
    self.colViewProduct.delegate = nil;
    
    [ApplicationDelegate setAmplitudeEvent:@"Click-모바일라이브-생방송나가기"];
    
    if(sender == nil)
    {
        // 닫고 게이트페이지로 이동
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
    /*
    // 백그라운드 음악 재생
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:&error];
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ApplicationDelegate.HMV.tabBarView.hidden = YES;
    
    //로그인창 호출후 패스워드를 입력시에도 키보드 노티가 날라와서 돌아왔을때 뷰가 꼬임
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 맨 처음 시작할 때는 여기서 한번, API 데이터 받고 바로 요청하게 되어 API 데이터 받기전에는 호출하지 않도록 철.
    // 단, 다른 곳 갔다가 왔을 경우에 새로 접속해야 하므로 위치는 여기에 유지.
    if([NCS([self.m_dicAPI objectForKey:@"liveNo"]) length] > 0)
    {
        //나갔다 들어올때... 안될때가 있다. 이거 안되면 다 꼬임. 막.. 접속자 수도 이상하게 나오고 채팅창이랑 상품보기도 겹치고 난리라고
        [self connectCSPServer];
    }
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self performSelector:@selector(setWidthtoNarrow:) withObject:@"Y" afterDelay:3.0f];
    
    if([NCS(self.m_strPlayURL) length] > 0)
    {
        [self.moviePlayer play];
    }
    
    
    NSLog(@"%lf", floor([[[UIDevice currentDevice] systemVersion] floatValue]));
    
    if (floor([[[UIDevice currentDevice] systemVersion] floatValue]) < 11)
    {
        if(IS_IPAD || (IS_IPHONE && !IS_IPHONE_X_SERISE))
        {
            self.view.frame = CGRectMake(0, 20, APPFULLWIDTH, APPFULLHEIGHT - 20);
        }
    }
}



- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.m_cspChat CSP_Disconnect];
    
    // Remove all chatting datas
    [self.m_arDatas removeAllObjects];
    [self.m_marTableViewHeight removeAllObjects];
    [self.tvChat reloadData];
    [self.moviePlayer pause];
    self.m_ctChatHeight.constant = 0;
    [self.view layoutIfNeeded];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //로그인창 호출후 패스워드를 입력시에도 키보드 노티가 날라와서 돌아왔을때 뷰가 꼬임
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// 동영상 세팅 - 전체화면으로 협의 (기획자)
-(void)setupPlayer
{
    // Set up URL
    NSURL *contentURL;
    if(self.m_contentURL == nil)
    {
        contentURL = [NSURL URLWithString:self.m_strPlayURL];
    }
    else
    {
        contentURL = self.m_contentURL;
    }
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:contentURL];
    self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    
    [self.moviePlayer seekToTime:kCMTimeZero];
    
    // Full 화면이 필요할 경우 주석 제거
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //
    if (@available(iOS 11.0, *))
    {
        UILayoutGuide *sGuide =  ApplicationDelegate.window.safeAreaLayoutGuide;
        self.playerLayer.frame = CGRectMake(0, 0, sGuide.layoutFrame.size.width, sGuide.layoutFrame.size.height);
    }
    else
    {
        // 수정 필요 - top view 위치 내려야 함.
        self.playerLayer.frame = self.LivePlayerView.bounds;
    }
    //    self.playerLayer.frame = self.LivePlayerView.bounds;
    
    NSLog(@"111 = %@, 2222 = %@", NSStringFromCGRect(self.playerLayer.frame), NSStringFromCGRect(self.LivePlayerView.frame));
    
    [self.LivePlayerView.layer addSublayer:self.playerLayer];
    self.m_contentURL = contentURL;
    
    
    [self.moviePlayer play];
    
    // Set mute status
    if ([[[DataManager sharedManager] strGlobalSound] isEqualToString:@"Y"] || [[[DataManager sharedManager] strGlobalSound] isEqualToString:@"D"])
    {   // Sound On
        self.m_btnMute.selected = NO;
        self.moviePlayer.muted = NO;
    }
    else
    {   // Sound Off
        self.m_btnMute.selected = YES;
        self.moviePlayer.muted = YES;
    }
    
//    // 3G 상태 체크 및 사용자 동의시에만 구동
//    if([self check3GNetworkAgree] == YES)
//    {
//        // Auto Play
//        [self.moviePlayer play];
//    }
}




- (BOOL) check3GNetworkAgree
{
    if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWWAN)
    {
        
        // 3G 기 허용일 때, 비노출 처리 필요 + 반대
        if([@"Y" isEqualToString:[DataManager sharedManager].strGlobal3GAgree] == YES)
        {
            return YES;
        }
        else
        {
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 888;
            [ApplicationDelegate.window addSubview:malert];
            
            return NO;
        }
        
        
    }else{
        return YES;
    }
}




// CSP 연결하기 - A called from other function After API call
- (void) connectCSPServer
{
    NSString *strLiveNo = NCS([self.m_dicAPI objectForKey:@"liveNo"]);
    
    
    // 비 로그인 상태 - PCID로 접속
    if(ApplicationDelegate.islogin == NO)
    {
        // GET catvid from cookie
        NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
        for (NSHTTPCookie *cookie in gsCookies) {
            if([cookie.name isEqualToString:@"pcid"]){
                self.strCSP_ID = NCS([cookie.value copy]);
                if ([self.strCSP_ID length] > 0) {
                    self.m_isConnectCSP_PCID = YES;
                    break;
                }
            }
        }
        
        if(NCS(self.strCSP_ID).length == 0)
        {
            self.strCSP_ID = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        }
    }
    else
    {
        // 고객번호로 접속
        self.strCSP_NI = [DataManager loadLoginData].loginid;
        self.strCSP_ID = NCS([DataManager sharedManager].customerNo);
        self.m_isConnectCSP_PCID = NO;
    }
    
    
    /*
     strCustomerNumber : 고객 번호 / 없을 경우 catvid
     strLiveNumber : liveNo (API 에서 읽어온 방송 번호)
     */
    [self.m_cspChat CSP_Disconnect];
    
#if DEBUG
    // nami0342 - 테스트를 위한 입장 채널 설정
//    strLiveNo = @"test";
#endif
    [self.m_cspChat CSP_ConnectWithNameSpce:@"/chat" customerID:self.strCSP_ID liveNo:strLiveNo];
}





// 공지 영역 히든 처리 - 공지 높이를 조절하더라도 내부에 있는 것들은 히든 처리 한다.
- (void) hideNoticeArea : (BOOL) isHide
{
    self.bgNotice.hidden = isHide;
    self.lbNotice.hidden = isHide;
    self.imgNotice.hidden = isHide;
    self.scvNotice.hidden = isHide;
}







// 채팅 창 상/하단의 셀 일부 사라지게 하는 처리 - 리소스 영향으로 느리게 대응되므로 로직 변경 필요. (상 하단으로 영역 분할 후 처리 검토 중)
- (CAGradientLayer *) setWhiteAlphaGradientLayer
{
    UIColor *colorOne = [UIColor clearColor];
    UIColor *colorTwo = [UIColor blackColor];

    
    NSArray *colors = [NSArray arrayWithObjects:(id)[colorOne CGColor], (id)[colorTwo CGColor], (id)[colorTwo CGColor], (id)[colorOne CGColor], nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.05];
    NSNumber *stopThree = [NSNumber numberWithFloat:0.95];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree,  stopFour, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
//    headerLayer.startPoint = CGPointMake(1.0, 0.0);
    headerLayer.locations = locations;
    headerLayer.frame = self.tvChat.bounds;
    self.tvChat.layer.mask = headerLayer;
    
    return headerLayer;
}


//pause 상태에서 다시 플레이 노티 처리
-(void)enterForeground:(NSNotification *)noti{
    
    [self.moviePlayer play];
}

- (void)handleAudioSessionInterruption:(NSNotification*)notification {
    
    NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
    NSNumber *interruptionOption = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
    
    switch (interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan:{
            // • Audio has stopped, already inactive
            // • Change state of UI, etc., to reflect non-playing state
        } break;
        case AVAudioSessionInterruptionTypeEnded:{
            // • Make session active
            // • Update user interface
            // • AVAudioSessionInterruptionOptionShouldResume option
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                // Here you should continue playback.
                [self.moviePlayer play];
            }
        } break;
        default:
            break;
    }
}


#pragma mark
#pragma mark Text view delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(self.m_cspChat.m_socket.status != CSP_STATUS_CONNECTED)
    {
        return NO;
    }
    
    
    if(ApplicationDelegate.islogin == NO) {
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"로그인 후\n이용이 가능합니다."  maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"),GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 1133;
        [ApplicationDelegate.window addSubview:lalert];
        return NO;
    }
    
    [ApplicationDelegate wiseLogRestRequest:WISELOGCOMMONURL(@"?mseq=417318")];
   
    
    return  YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        // return키를 누루면 원래 줄바꿈이 일어나므로 \n을 입력하는데 \n을 입력하면 실행하게 합니다.
        NSLog(@"return ");
    }
    
    NSString *replacedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //NSData *bytes = [replacedString dataUsingEncoding:NSUTF8StringEncoding];
    if(replacedString.length == 0)
    {
        [self.m_btnSend setImage:[UIImage imageNamed:@"mobileLive_ic_send_default"] forState:UIControlStateNormal];
    }
    else
    {
        [self.m_btnSend setImage:[UIImage imageNamed:@"mobileLive_icSendActive"] forState:UIControlStateNormal];
    }

    return YES;
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    //    bg_chatword.backgroundColor = [Mocha_Util getColor:@"FAFAFA"];
    return  YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

//UITextFiled delegate 입력한 텍스트 저장 및 전송
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    textField.inputAccessoryView = nil;
    
    
    NSString *strInputText =  [self.tfInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(strInputText.length == 0)
    {
        [textField setText:@""];
        [textField resignFirstResponder];
        return NO;
    }
    
    
    //
    //{ 'UO' : { 'U':  custNo, 'NI': nick }, 'MO' : { 'MG': message, 'EM': 이모티콘 코드 } }
    NSString *strName = [NSString stringWithFormat:@"%@", self.strCSP_NI];
    
    // Set name to masking - 기존과 다르지만 요청에 의해 email 영역중 도메인 영역 제거
    if(NCS(strName).length > 0)
    {
        NSArray *arTemp = [strName componentsSeparatedByString:@"@"];
        
        if([arTemp count] > 1)
        {
            NSString *strTemp = [arTemp objectAtIndex:0];
            
            if(strTemp.length >= 4)
            {
                NSRange range = NSMakeRange(2, strTemp.length-2);
                NSString *stars = [@"" stringByPaddingToLength:(strTemp.length-2) withString:@"*" startingAtIndex:0];
                strTemp = [strTemp stringByReplacingCharactersInRange:range withString:stars];
            }
            else
            {
                strTemp = @"***";
            }
            // 메일 도메인 부분은 제거
            strName = strTemp;
        }
        else
        {
            if(strName.length >= 6)
            {
                NSRange range = NSMakeRange(3, strName.length-3);
                NSString *stars = [@"" stringByPaddingToLength:(strName.length-3) withString:@"*" startingAtIndex:0];
                strName = [strName stringByReplacingCharactersInRange:range withString:stars];
            }
            else if(strName.length == 4 || strName.length == 5)
            {
                NSRange range = NSMakeRange((strName.length -3) , 3);
                NSString *stars = [@"" stringByPaddingToLength:3 withString:@"*" startingAtIndex:0];
                strName = [strName stringByReplacingCharactersInRange:range withString:stars];
            }
            else
            {
                strName = @"***";
            }
        }
    }
    
    
    NSDictionary *dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:textField.text, @"MG", nil],@"MO", [NSDictionary dictionaryWithObjectsAndKeys:self.strCSP_ID, @"U", strName, @"NI", nil], @"UO", nil];
    NSDictionary *dicSend = [NSDictionary dictionaryWithObjectsAndKeys:dicTemp, @"DT", @"MSSG", @"NM", nil];
    
    [textField setText:@""];
    [textField resignFirstResponder];
    
    [self.m_btnSend setImage:[UIImage imageNamed:@"mobileLive_ic_send_default"] forState:UIControlStateNormal];
    
    
    NSLog(@"%ld", (long)self.m_cspChat.m_socket.status);
    
    // 연결 상태라면
    if(self.m_cspChat.m_socket.status == CSP_STATUS_CONNECTED)
    {
        [ApplicationDelegate setAmplitudeEvent:@"Click-모바일라이브-톡등록"];
        [self.m_cspChat CSP_SendMSG:dicSend];
    }
    else
    {
        self.m_lbShowChatLost.hidden = NO;
        if([self.m_timerReconnectCSP isValid] == NO)
        {
            self.m_timerReconnectCSP = [NSTimer scheduledTimerWithTimeInterval:CSP_RECONNECT_TIME target:self selector:@selector(reConnectCSP) userInfo:nil repeats:YES];
        }
    }
    
    
    return YES;
}








// Text input area hide and show
- (void) hideTextInputArea : (BOOL) isHide
{
    self.m_bgInputText.hidden = isHide;
    self.tfInput.hidden = isHide;
    self.tvChat.hidden = isHide;
    self.m_bgAlarmView.hidden = isHide;
}



// 키보드가 아래에서 떠오르는 이벤트 발생 시 실행할 이벤트 처리 메서드입니다.
- (void) keyboardWillShow:(NSNotification *)notification {
    
    CGRect rectKeyboard;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&rectKeyboard];
    
    self.m_isKeyboardShow = YES;
    
//    CGFloat constBottom = 70.0 + self.m_ctNoticeHeight.constant;
//
//
//    [self.view removeConstraint:self.m_lcontTVChatBottom];
//    self.m_lcontTVChatBottom = [NSLayoutConstraint constraintWithItem:self.LivePlayerView
//                                                            attribute:NSLayoutAttributeBottom
//                                                            relatedBy:NSLayoutRelationEqual
//                                                               toItem:self.tvChat
//                                                            attribute:NSLayoutAttributeBottom
//                                                           multiplier:1
//                                                             constant:constBottom];
//    [self.view addConstraint:self.m_lcontTVChatBottom];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
                
        self.m_ctChatBottom.constant = (-rectKeyboard.size.height) + self.m_fSafeAreaBottomHeight;
        
        
        [self hideNoticeArea:YES];
        
        
        // 자판 위에 노출 될 텍스트 입력 버튼 UI 변경
        [self.m_bgInputText.layer setBorderColor:[[Mocha_Util getColor:@"BBBBBB"] CGColor]];
        [self.tfInput setTextColor:[Mocha_Util getColor:@"444444"]];
        self.tfInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:INPUTTEXT_PLACEHOLDER_STRING attributes:@{NSForegroundColorAttributeName: [Mocha_Util getColor:@"888888"]}];
        self.m_bgInputTextBack.hidden = NO;
        self.m_ctInputBGRight.constant = 55;
        self.m_btnSend.hidden = NO;
        
        self.m_ctAlarmButtonWidth.constant = 0;
        
        [self.view layoutIfNeeded];
    }];

}



// 키보드가 아래로 잠기는 이벤트 발생 시 실행할 이벤트 처리 메서드입니다.
- (void) keyboardWillHide:(NSNotification *)notification {
    
    self.m_isKeyboardShow = NO;
    
    CGRect rectKeyboard;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&rectKeyboard];
    
    [self.view layoutIfNeeded];
    
    //    [self.vChattingView updateConstraints];
 
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         
                         
                         if([self.m_marNotice count] > 0)
                         {
                             [self hideNoticeArea:NO];
                         }
                         
                         [self.m_bgInputText.layer setCornerRadius:18];
                         self.m_bgInputText.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
                         [self.m_bgInputText.layer setBorderWidth:1];
        if(self.m_isAlarmDone == YES)
        {
            self.m_ctInputBGRight.constant = 0;
        }
        else
        {
            self.m_ctInputBGRight.constant = 12;
        }
                         self.m_btnSend.hidden = YES;
                         
                         [self.tfInput setTextColor:[UIColor whiteColor]];
                         self.tfInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:INPUTTEXT_PLACEHOLDER_STRING attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
                         self.m_bgInputTextBack.hidden = YES;
                         
                         //
                            
                         self.m_ctChatBottom.constant = 0;
                         [self hideTextInputArea:NO];
        if(self.m_isAlarmDone == NO)
        {
            self.m_ctAlarmButtonWidth.constant = 96;
        }
        else
        {
            self.m_ctAlarmButtonWidth.constant = 0;
        }
                        
                         
                         [self.view layoutIfNeeded];
                         
                     }
     
                     completion:^(BOOL finished){
                         
                         
//                         [self.view removeConstraint:self.m_lcontTVChatBottom];
//                         self.m_lcontTVChatBottom = [NSLayoutConstraint constraintWithItem:self.bgNotice
//                                                                                 attribute:NSLayoutAttributeTop
//                                                                                 relatedBy:NSLayoutRelationEqual
//                                                                                    toItem:self.tvChat
//                                                                                 attribute:NSLayoutAttributeBottom
//                                                                                multiplier:1
//                                                                                  constant:12.0];
//                         [self.view addConstraint:self.m_lcontTVChatBottom];
                     }];
    
    
    
    
}


- (void) firstReloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.tvChat.hidden = YES;       // 망할.. 리로드 비동기라 체크가 안되네.
        [self.tvChat reloadData];
        [self.tvChat layoutIfNeeded];    // 이거 왜 안먹냐?
    });
    
    
    
    self.m_isChatPositionBottom = YES;
}



- (void) reloadChat
{
    [self.tvChat reloadData];
    
    [self performSelector:@selector(setScrolltoBottom) withObject:nil afterDelay:0.0f];
}

// 채팅 스크롤 최 하단으로 이동
- (void) setScrolltoBottom
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tvChat.hidden = NO;
        if([self.tvChat numberOfRowsInSection:0] > 0)
        {
            NSIndexPath* ipath = [NSIndexPath indexPathForRow: [self.tvChat numberOfRowsInSection:0] -1 inSection:0];
            [self.tvChat scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            self.m_isChatPositionBottom = YES;
        }
    });
}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    // Don't do it when a notice view pressed
    UITouch *touch = [[touches allObjects] lastObject];
    if(touch != nil && [touch.view isEqual:self.bgNotice] == YES)
        return;
    
    // 키패드가 이미 내려간 상태라면,
    if(self.m_isKeyboardShow == NO)
    {
        // 채팅 보기
        [self.view layoutIfNeeded];
        
        if(self.m_ctChatBottom.constant == 0)
        {
            // 안보이게 처리
            [UIView animateWithDuration:0.3 animations:^{
                // Hidden
                self.m_toastView.hidden = YES;
                self.m_vDimBottom.hidden = YES;

                self.m_ctChatBottom.constant = 46;
                [self hideTextInputArea:YES];
                self.m_lbShowChatLost.hidden = YES;
                self.colViewProduct.hidden = YES;
//                    self.bgNotice.hidden = YES;
                
                if(self.m_isChatHide == YES)
                {
                    self.m_vAlarmSingleView.hidden = YES;
                }
                
                [self performSelector:@selector(NoticeViewBottomPaddingZeroWithViewBottom:) withObject:[NSNumber numberWithBool:YES]];
                
                    
                [self.view layoutIfNeeded];
            }];
        }
        else if(self.m_ctChatBottom.constant == 46)
        {
            // 채팅 보이게 처리
            [UIView animateWithDuration:0.3 animations:^{
//                    self.m_toastView.hidden = NO;
                
                
                self.m_vDimBottom.hidden = NO;
                if(self.m_cspChat.m_socket.status != CSP_STATUS_CONNECTED)
                {
                    self.m_lbShowChatLost.hidden = NO;
                }
                
                self.m_ctChatBottom.constant = 0;
                [self hideTextInputArea:NO];
                self.colViewProduct.hidden = NO;
                
                if(self.m_marNotice.count == 0)
                {
                    [self hideNoticeArea:YES];
                }
                else
                {
                    [self hideNoticeArea:NO];
                }
                
                if(self.m_isChatHide == YES)
                {
                    if(self.m_isAlarmDone == NO)
                    {
                        self.m_vAlarmSingleView.hidden = NO;
                    }
                }
                else
                {
                    self.m_vAlarmSingleView.hidden = YES;
                }
                
                //
                [self performSelector:@selector(NoticeViewBottomPaddingZeroWithViewBottom:) withObject:[NSNumber numberWithBool:NO]];
                
                [self.view layoutIfNeeded];
            }];
            
            // 만일 토스트 메시지가 떠 있을 경우 터치를 통해 축소 -> 원복할 경우 채팅창을 가장 바닥으로 이동하게 처리 요청 (디자이너)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadChat];
            });
        }
   
        // 상품 보기에서 처리
        [self.view layoutIfNeeded];
        
    }
    
    [self.tfInput resignFirstResponder];
}



- (void) NoticeViewBottomPaddingZeroWithViewBottom : (NSNumber *) isShowOnly
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.m_marNotice.count > 0)
        {
            if([isShowOnly boolValue] == YES)
            {
                self.m_ctNotiAttatchBottom.constant = 16;
                
                self.m_ctNotiAttatchBottom.active = YES;
                self.m_ctNotiAttachChat.active = NO;
//                self.m_ctNotiAttatchBottom.priority = 1000;
//                self.m_ctNotiAttachChat.priority = 250;

                
                
            }
            else
            {
                self.m_ctNotiAttatchBottom.active = NO;
                self.m_ctNotiAttachChat.active = YES;
//                self.m_ctNotiAttatchBottom.priority = 250;
//                self.m_ctNotiAttachChat.priority = 1000;
//

            }
            
            [self.view layoutIfNeeded];
        }
    });
    
}



#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arDatas.count;
}



- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicTemp = [self.m_arDatas objectAtIndex:indexPath.row];
    
    NSDictionary *dicMO = [dicTemp objectForKey:@"MO"];
    NSString *strMG = NCS([dicMO objectForKey:@"MG"]);
    
    
    if(NCS(strMG).length > 0)
    {
        NSDictionary *dicUO = [dicTemp objectForKey:@"UO"];
        NSString *strUserNo = NCS([dicUO objectForKey:@"U"]);
        
      
        
        if([strUserNo isEqualToString:@"admin"] == YES)
        {
            MobileLiveAdminTalkCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"MobileLiveAdminTalkCell"];
            if(cell == nil)
            {
                cell = [[MobileLiveAdminTalkCell alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
            }
            
            cell.m_idParent = self;
            [cell setCellInfoNDrawData:dicTemp];
            return cell;
        }
        else if ([strUserNo isEqualToString:self.strCSP_ID] == YES)
        {
            MobileLiveAdminTalkCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"MobileLiveAdminTalkCell"];
            if(cell == nil)
            {
                cell = [[MobileLiveAdminTalkCell alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
            }
            
            cell.m_idParent = self;
            [cell setCellInfoNDrawData:dicTemp];
            return cell;
        }
        else
        {
            MobileLiveUserTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MobileLiveUserTalkCell"];
            if(cell == nil)
            {
                cell = [[MobileLiveUserTalkCell alloc] initWithFrame:CGRectMake(0, 0, 240, 100)];
            }
            
            cell.m_idParent = self;
            [cell setCellInfoNDrawData:dicTemp];
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
    
    return  nil;
}



// nami0342 - 채팅 창 그라데이션 처리
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat height = MIN(140, self.tvChat.contentSize.height);
    if(self.m_ctChatHeight.constant == 140)
    {
        if (!self.tvChat.layer.mask)
        {
            CAGradientLayer *maskLayer = [CAGradientLayer layer];
            
            maskLayer.locations = @[[NSNumber numberWithFloat:0.0],
                                    [NSNumber numberWithFloat:0.2],
                                    [NSNumber numberWithFloat:0.8],
                                    [NSNumber numberWithFloat:1.0]];
            
            maskLayer.bounds = CGRectMake(0, 0,
                                          self.tvChat.frame.size.width,
                                          self.tvChat.frame.size.height);
            maskLayer.anchorPoint = CGPointZero;
            
            self.tvChat.layer.mask = maskLayer;
        }
        [self scrollViewDidScroll:self.tvChat];
    }
    else
    {
        if(self.m_isProductViewShow == NO)
        {
            if(self.m_ctChatBottom.constant == 0)
            {   // 채팅 보기
                if(self.m_isChatHide == NO)
                {
                   self.m_ctChatHeight.constant = height;
                }
                else
                {
                    self.m_ctChatHeight.constant = 0;
                }
            
            }
            else
            {
                // 전체 보기
               
                self.m_ctChatHeight.constant = 0;
            }
            
            [self.view layoutIfNeeded];
        }
    }
    //
    
   
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(self.m_isFirstMessageLoading == YES)
    {
        self.tvChat.hidden = NO;
        [self performSelector:@selector(setScrolltoBottom) withObject:nil afterDelay:0.0f];
        self.m_isFirstMessageLoading = NO;
    }
}





#pragma mark
#pragma mark UIScrollView Delegate
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    if([scrollView isEqual:self.scvNotice] == YES)
        return;
    
//    if (scrollView == self.colViewProduct && self.isPrdCenterScroll == NO) {
//        CGPoint centerPoint = CGPointMake(self.colViewProduct.frame.size.width / 2 + scrollView.contentOffset.x, self.colViewProduct.frame.size.height /2 + scrollView.contentOffset.y);
//        NSIndexPath *centerCellIndexPath = [self.colViewProduct indexPathForItemAtPoint:centerPoint];
//
//        if (centerCellIndexPath != nil) {
//            self.m_pcProductList.currentPage = centerCellIndexPath.row;
//        }
//    }
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;

    if (scrollOffset == 0)
    {
        // Top
        // 현재 채팅 내용보다 더 이전 내용이 있는지 확인 - CSP 이용
        // 현재 스크롤 컨텐츠 길이 확인 - 나중에 스크롤 위치 잡기 위해서.
        // 현재 채팅 인덱스 가져오기 (현재 최상단 타임 스탬프)
        // (현재 최상단 타임 스탬프를)emit 호출하여 통해 이전 채팅 리스트 가져오기
        // 현재 채팅 리스트 상단에 수신받은 채팅 리스트 붙이기
        // 스크롤 위치 조정
        
    }
    else if (scrollOffset + scrollViewHeight + 10 >= scrollContentSizeHeight)
    {
        // 간혹 최하단으로 스크롤 해도, 약간 못 미치는 경우가 있어 + 10을 해줌.
        self.m_isChatPositionBottom = YES;
        self.m_toastView.hidden = YES;
    }
    else
    {
        self.m_isChatPositionBottom = NO;
    }
    
    // nami0342 - 채팅 스크롤 영역에 따른 그라데이션 처리
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    NSArray *colors;
    
    if (scrollView.contentOffset.y + scrollView.contentInset.top <= 0) {
        //Top of scrollView
        colors = @[(__bridge id)innerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)outerColor];
    } else if (scrollView.contentOffset.y + scrollView.frame.size.height
               >= scrollView.contentSize.height) {
        //Bottom of tableView
        colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)innerColor];
    } else {
        //Middle
        colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)outerColor];
    }
    ((CAGradientLayer *)scrollView.layer.mask).colors = colors;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    scrollView.layer.mask.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([scrollView isEqual:self.scvNotice] == YES)
        return;
    
    if([scrollView isEqual:self.tvChat] == YES)
        return;
    
    if (scrollView == self.colViewProduct && self.isPrdCenterScroll == NO) {
        CGPoint centerPoint = CGPointMake(self.colViewProduct.frame.size.width / 2 + scrollView.contentOffset.x, self.colViewProduct.frame.size.height /2 + scrollView.contentOffset.y);
        
        NSIndexPath *centerCellIndexPath = [self.colViewProduct indexPathForItemAtPoint:centerPoint];
        
        self.isPrdCenterScroll = YES;
        [self.colViewProduct scrollToItemAtIndexPath:centerCellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}



-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.colViewProduct) {
        CGPoint centerPoint = CGPointMake(self.colViewProduct.frame.size.width / 2 + scrollView.contentOffset.x, self.colViewProduct.frame.size.height /2 + scrollView.contentOffset.y);
        
        NSIndexPath *centerCellIndexPath = [self.colViewProduct indexPathForItemAtPoint:centerPoint];
        self.isPrdCenterScroll = YES;
        [self.colViewProduct scrollToItemAtIndexPath:centerCellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
}



-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.colViewProduct) {
        self.isPrdCenterScroll = NO;
        return;
    }
}





#pragma mark
#pragma mark Event handler

// 이모티콘 전송하는거 만들어 달라고 해서 만들었더니 안 한다고 함.. - 하지만 놔둬 봄.
- (IBAction) click_Emoticon:(id)sender
{
    //    UIButton *btnTag = sender;
    //
    //    switch (btnTag.tag) {
    //        case 1:
    //
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
    //    //{ 'UO' : { 'U':  custNo, 'NI': nick }, 'MO' : { 'MG': message, 'EM': 이모티콘 코드 } }
    //    NSDictionary *dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"MG",@"1", @"EM", nil],@"MO", [NSDictionary dictionaryWithObjectsAndKeys:self.strCSP_ID, @"U", self.strCSP_NI, @"NI", nil], @"UO", nil];
    //    NSDictionary *dicSend = [NSDictionary dictionaryWithObjectsAndKeys:dicTemp, @"DT", @"MSSG", @"NM", nil];
    //
    //    [self.m_arDatas addObject:dicSend];
    //    [self reloadChat];
}



// 메세지 전송 버튼 클릭
- (IBAction) click_MgsSend:(id)sender
{
    if(self.tfInput.text.length > 0)
    {
        [self textFieldShouldReturn:self.tfInput];
    }
}


// 토스트 메시지 클릭
- (IBAction) click_toast:(id)sender
{
    self.m_toastView.hidden = YES;
    [self reloadChat];
//    [self setScrolltoBottom];
    [ApplicationDelegate wiseLogRestRequest:WISELOGCOMMONURL(@"mseq=417317")];
}


- (IBAction) click_mute:(id)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    
    if(btnTemp.selected == NO)
    {   // Set mute on
        [DataManager sharedManager].strGlobalSound = @"N";
        btnTemp.selected = YES;
        self.moviePlayer.muted = YES;
    }
    else
    {   // Set mute Off
        [DataManager sharedManager].strGlobalSound = @"Y";
        btnTemp.selected = NO;
        self.moviePlayer.muted = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GS_GLOBAL_SOUND_CHANGE object:nil userInfo:nil];
}


// 방송알림 클릭
- (IBAction) clickAlarmButton:(id)sender
{
    // 로그인 필요
    if(ApplicationDelegate.islogin == NO) {
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"로그인 후\n이용이 가능합니다."  maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"),GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 1133;
        [ApplicationDelegate.window addSubview:lalert];
        return;
    }
    
    UIButton *btnTemp = (UIButton *)sender;
    
    // Amplitude
    NSString *strStartDate = NCS([self.m_dicAPI objectForKey:@"strDate"]);
    NSString *strLiveNumber = NCS([self.m_dicAPI objectForKey:@"liveNo"]);
    NSDictionary *dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:self.strCSP_ID, @"고객번호",
                             strLiveNumber, @"라이브번호",
                             strStartDate, @"지금방송시작시간",nil];
    [ApplicationDelegate setAmplitudeEventWithProperties:@"Click-모바일라이브-방송알림신청" properties:dicTemp];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.m_bgAlarmView.hidden = YES;
        self.m_ctAlarmButtonWidth.constant = ALARM_SINGLE_VIEW_HIDDEN;
        self.m_ctInputBGRight.constant = 0;
        
        if(btnTemp.tag == 2)
        {
            self.m_vAlarmSingleView.hidden = YES;
        }
        [self.view layoutIfNeeded];
    }];
    
    
    
    //
    //
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
       
       animation.duration = 0.2;
       animation.values = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.2],
                           [NSNumber numberWithFloat:0.6],
                           [NSNumber numberWithFloat:1.0],
                           nil];
       animation.keyTimes = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.0],
                             [NSNumber numberWithFloat:0.5],
                             [NSNumber numberWithFloat:1.0],
                             nil];
    
    self.m_imgVAlarm.hidden = NO;
    [self.m_imgVAlarm.layer addAnimation:animation forKey:@"scaleAnimation"];
    [self performSelector:@selector(fadeOutAlarmCancel) withObject:nil afterDelay:1.6];
}


-(void)fadeOutAlarmCancel{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         self.m_imgVAlarm.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                        self.m_imgVAlarm.hidden = YES;
                     }];

}


////////////////////////////////////////////////////////////////////////////////////////
    ////////////////     CSP Callback event handler      //////////////////////
///////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark Callback event handler
// Chat
- (void) CSP_CallbackMSSG : (nullable NSDictionary *) dicData
{
    if(NCO(dicData) == NO)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"===  %@", dicData);
        [self.m_arDatas addObject:dicData];
        
        // 채팅 ON/OFF 테스트 용
#if DEBUG
//            NSDictionary *dicMO = [dicData objectForKey:@"MO"];
//            NSString *strMG = [dicMO objectForKey:@"MG"];
//            if([@"hide" isEqualToString:strMG] == YES)
//            {
//                [self performSelector:@selector(hideChatView:) withObject:@"N"];
//            }
//            else if([@"show" isEqualToString:strMG] == YES)
//            {
//                [self performSelector:@selector(hideChatView:) withObject:@"Y"];
//            }
#endif
        //
        
        if([self.m_arDatas count] > 8)
        {
            // User Info
            NSDictionary *dicUO = [dicData objectForKey:@"UO"];
            NSString *strUserNo = NCS([dicUO objectForKey:@"U"]);
            
            if(self.m_isChatPositionBottom == NO && [self.strCSP_ID isEqualToString:strUserNo] == NO)
            {
                
                [self.tvChat reloadData];
                
                // 스크롤이 맨 하단이 아니면서 채팅화면일 경우에만 토스트 노출
                if(self.m_ctChatBottom.constant == 0)
                {
                    [self performSelector:@selector(showToast:) withObject:dicData afterDelay:0.0];
                }
            }
            else
            {
                [self reloadChat];
            }
        }
        else
        {
            [self reloadChat];
        }
    });
    
}


// 채팅 리스트 콜백
- (void) CSP_CallbackCHAT : (nullable NSDictionary *) dicData
{
    if(NCO(dicData) == NO)
            return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"===  %@", dicData);
            
            NSArray *arList = [dicData objectForKey:@"CA"];
            
            if(NCA(arList))
            {
                for(NSDictionary *dicTemp in arList)
                {
                    [self.m_arDatas addObject:dicTemp];
                }
            }
            if(self.m_cspChat.m_isRequestChatList == YES)
            {
                [self firstReloadData];
                self.m_cspChat.m_isRequestChatList = NO;
            }
            else
            {
                [self reloadChat];
            }
        });
}


// 토스트 노출
- (void) showToast : (NSDictionary *) dicData
{
    NSDictionary *dicMO = [dicData objectForKey:@"MO"];
    if(NCO(dicMO) == YES)
    {
        NSString *strMG = NCS([dicMO objectForKey:@"MG"]);
        [self.m_lbToastMessage setText:strMG];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.m_toastView.hidden = NO;
        }];
    }
}






// Notice
- (void) CSP_CallbackNOTI : (nullable NSDictionary *) dicData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 기존 공지 제거
        if([self.m_marNotice count] > 0)
        {
            [self.m_marNotice removeAllObjects];
            
        }
        
        
        self.m_marNotice = [dicData objectForKey:@"MA"];
        
        // 7개 이상 공지사항이 들어올 경우가 있다는데 7개로 막아달라고 했음.
        // 서버 사이드에서 막게 되면 사실 필요 없지만, 일단 넣어 놓음.
        if(self.m_marNotice.count > 7)
        {
            for(NSInteger i = self.m_marNotice.count; i>7; i--)
            {
                [self.m_marNotice removeLastObject];
            }
        }
        
        
        if(NCO(self.m_marNotice) == YES && [self.m_marNotice count] > 0)
        {
            // 정상적인 공지가 왔다.
            self.g_iNoticeIndex = 0;
            [self.m_timerNotice invalidate];
            self.m_timerNotice = nil;
            
            self.m_ctNoticeHeight.constant = 26;
            [self hideNoticeArea:NO];
            [self.view layoutIfNeeded];
            
            // Set notice datas to rolling label
            [self setRollingNotice];
            
            [self.view setNeedsDisplay];
        }
        
        if([self.m_marNotice count] == 0)
        {
            // 데이터 없는 공지가 왔다. (빈 공지 = 기존 공지 제거)
            self.g_iNoticeIndex = 0;
            self.m_ctNoticeHeight.constant = 0;
            [self.view layoutIfNeeded];
            
            // 빈 공지 올 경우 대응
            if([self.m_timerNotice isValid])
            {
                [self.m_timerNotice invalidate];
                self.m_timerNotice = nil;
            }
            
            [self.m_marNotice removeAllObjects];
            for(UILabel *lbTemp in self.m_marNoticeView)
            {
                [lbTemp removeFromSuperview];
            }
            
            [self hideNoticeArea:YES];
        }
        NSLog(@"=== NOTICE list ==   %@", self.m_marNotice);
    });
    
}

// 공지 롤링을 위한 데이터 세팅
- (void) setRollingNotice
{
    self.bgNotice.hidden = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize csScrollview = self.scvNotice.contentSize;
            
        // 이제 불필요
            [self.scvNotice setContentSize:CGSizeMake(csScrollview.width, NOTICE_LABEL_HEIGHT)];

            if(NCA(self.m_marNotice) == YES)
            {
                // 수정 필요 - XIB에서 제거 필요 시 제거 할 것. 1개만 붙여 놓음.
                [self.lbNotice setText:[self.m_marNotice objectAtIndex:0]];
                CGSize labelSize = [self.lbNotice.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
                
                float labelWidth = labelSize.width > APPFULLWIDTH -76 ? APPFULLWIDTH-76 : labelSize.width;
                
                self.lbNotice.lineBreakMode = NSLineBreakByCharWrapping;
                
                self.m_ctNoticeWidth.constant = labelWidth;
                
                self.maskLayer_Notice.bounds = CGRectMake(0, 0,(labelSize.width + 50>(APPFULLWIDTH-24)?APPFULLWIDTH-24 :labelSize.width + 50), self.bgNotice.frame.size.height);
                
                [self.view layoutIfNeeded];
            }
                    
            
            
            // Set rolling timer
            if(self.m_marNotice.count > 1)
            {
                self.m_timerNotice = [NSTimer scheduledTimerWithTimeInterval:NOTICE_ROLLING_TIME target:self selector:@selector(rollingNotice) userInfo:nil repeats:YES];
            }
    });
    
}


// Notice rolling
- (void) rollingNotice
{
    if(self.m_marNotice != nil && [self.m_marNotice count] > self.g_iNoticeIndex )
    {
        NSString *strText = [self.m_marNotice objectAtIndex:self.g_iNoticeIndex];
        self.lbNotice.text = strText;
        
        
        CGSize labelSize = [self.lbNotice.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        
        float labelWidth = labelSize.width > APPFULLWIDTH -76 ? APPFULLWIDTH-76 : labelSize.width;
        self.m_ctNoticeWidth.constant = labelWidth;
        
        
        self.maskLayer_Notice.bounds = CGRectMake(0, 0,(labelSize.width + 50>(APPFULLWIDTH-24)?APPFULLWIDTH-24 :labelSize.width + 50), self.bgNotice.frame.size.height);
        [self.view layoutIfNeeded];
        
        if(self.g_iNoticeIndex == 0)
        {
            self.g_iNoticeIndex++;
            if(self.g_iNoticeIndex >= self.m_marNotice.count)
            {
                self.g_iNoticeIndex = 0;
            }
        }
        else
        {
           self.g_iNoticeIndex++;
           if(self.g_iNoticeIndex >= self.m_marNotice.count)
           {
               self.g_iNoticeIndex = 0;
           }
        }
    }
    else
    {
        self.g_iNoticeIndex = 0;
    }
   
}


// Chat display On/Off setting
- (void) CSP_CallbackCONF : (nullable NSDictionary *) dicData
{
    NSDictionary *dicTemp = [dicData objectForKey:@"CO"];
    NSString *strChat;
    if(NCO(dicTemp) == YES)
    {
        strChat = NCS([dicTemp objectForKey:@"CHAT"]);
        self.m_isChatHide = [strChat isEqualToString:@"Y"] ? NO : YES;
        
        [self performSelector:@selector(hideChatView:) withObject:strChat];
        
    }
    
    NSLog(@"===  %@", strChat);
}


- (void) hideChatView : (NSString*) strHidden
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.m_isChatHide = [@"Y" isEqualToString:strHidden]?NO:YES;
         // 채팅창 숨기기
        if(self.m_isChatHide == YES)
        {
            [self.view layoutIfNeeded];
            self.vChattingView.hidden = YES;
            self.m_ctScrollViewBottomHeight.constant = 0;
            
            // 방송 알림 설정을 이미 했다면
            if(self.m_isAlarmDone == NO)
            {
                self.m_vAlarmSingleView.hidden = NO;
            }
            else
            {
                // 싱글 방송알림은 노출한다.
                self.m_vAlarmSingleView.hidden = YES;
            }
        }
        else
        {
            self.m_ctScrollViewBottomHeight.constant = 64;
            self.vChattingView.hidden = NO;
            self.m_vAlarmSingleView.hidden = YES;
        }
        [self.view layoutIfNeeded];
    });
}


// Status
/*
 SO =     {
 PV = 43;
 UV =         (
 7608979,
 1550481078302,
 1550481286071,
 1550482289338,
 1550482293005
 );
 };
 TS = 1550540409095;
 */
// 현재 접속자 콜백
- (void) CSP_CallbackSTAT : (nullable NSDictionary *) dicData
{
    NSDictionary *dicTemp = [dicData objectForKey:@"SO"];
    NSString *strPV;
    if(NCO(dicTemp) == YES)
    {
        strPV = [[dicTemp objectForKey:@"PV"] stringValue];
        [self performSelector:@selector(setPV:) withObject:strPV afterDelay:0.0];
        
    }
    
    NSLog(@"===  %@", strPV);
}

- (void) setPV : (NSString *) strPV
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.m_lbPV setText:[Mocha_Util numberFormat:strPV]];
        
        CGSize labelSize = [self.m_lbPV.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        
        self.m_ctPVlabelWidth.constant = labelSize.width+1;
        [self.view layoutIfNeeded];
    });
    
}


// 이게 간혹 온다... 안오다가 정말 신기하게 간혹 온다. 그래서 처리
- (void) CSP_CallbackLOST:(NSString *)strYN
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([strYN isEqualToString:@"Y"] == YES)
        {
            // CSP 연결 종료
            self.m_lbShowChatLost.hidden = NO;
            self.m_timerReconnectCSP = [NSTimer scheduledTimerWithTimeInterval:CSP_RECONNECT_TIME target:self selector:@selector(reConnectCSP) userInfo:nil repeats:YES];
        }
        else
        {
            // CSP 연결 성공
            self.m_lbShowChatLost.hidden = YES;
            if([self.m_timerReconnectCSP isValid])
            {
                [self.m_timerReconnectCSP invalidate];
                self.m_timerReconnectCSP = nil;
            }
        }
    });
}

// CSP 재 접속 타이머용.
- (void) reConnectCSP
{
    if(self.m_cspChat.m_socket.status == CSP_STATUS_CONNECTED)
    {
        if([self.m_timerReconnectCSP isValid])
        {
            [self.m_timerReconnectCSP invalidate];
            self.m_timerReconnectCSP = nil;
        }
    }
    else
    {
        [self connectCSPServer];
    }
}






// 상품 미리보기 처리
- (void) MobileLiveProduct_Preview : (id) sender
{
    //sender = @"external://directOrd?http://m.gsshop.com/section/mobileLive/prdPreview?prdCd=32089040";
    
    NSString *strTemp = NCS(sender);
    NSString *strCheck = @"external://prePrd?";
    
    if([Mocha_Util strContain:strCheck srcstring:strTemp] == YES)
    {
        strTemp = [strTemp substringToIndex:strCheck.length];
    }
    
    NSString *strExternal = @"external://prePrd?";
    if([strTemp hasPrefix:strExternal] == YES)
    {
        strTemp = [strTemp stringByReplacingOccurrencesOfString:strExternal withString:@""];
    }
    
    if ([strTemp length] > 0 && [strTemp hasPrefix:@"http"]) {
        [self.view bringSubviewToFront:self.viewPrePrd];
        [self.viewPrePrd openWithAnimated:YES withUrl:strTemp];
    }
    
    [ApplicationDelegate wiseLogRestRequest:WISELOGCOMMONURL(@"?mseq=417347")];
}



// 상품 바로 구매 처리
- (void) MobileLiveProduct_DirectOrderClick : (id) sender
{
    NSString *strTemp = sender;
//    strTemp = @"http://m.gsshop.com/prd/directOrd/27891161?mseq=A00054-C-BUY";
    NSLog(@"sender : %@", strTemp);
    
    NSString *strExternal = @"external://directOrd?";
    if([strTemp hasPrefix:strExternal] == YES)
    {
        strTemp = [strTemp substringFromIndex:strExternal.length];
    }
    [ApplicationDelegate wiseLogRestRequest:WISELOGCOMMONURL(@"?mseq=417346")];
    [ApplicationDelegate directOrdOptionViewShowURL:strTemp];
    [ApplicationDelegate setAmplitudeEvent:@"Click-모바일라이브-바로구매"];
}




#pragma mark
#pragma mark Product list
- (void) showProductList : (BOOL) isShow
{
    if(self.m_marProductList.count == 0)
        return;
    
    
    [self.view layoutIfNeeded];
   
    // 맨 처음 보여줄 상품 인덱스를 세팅한다.
    int iIndex = self.m_iCollectionIndex;
    
    // nami0342 - 현재 시간과 상품 시간 계산해서 해당 시간 상품 보여주기
//        double dblNowTime = [[NSDate date] timeIntervalSince1970];
//        //
//        NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
//        [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
//        [dateformat setDateFormat:@"yyyyMMddHHmmss"];
//
//        NSDate *endTime = [dateformat dateFromString:@"20190429104000"];
//        dblNowTime = [endTime timeIntervalSince1970];
//        //
//        for(MobileLiveProduct *product in self.m_marProductList)
//        {
//            if(dblNowTime <= product.m_dblDateOfEnd)
//            {
//                break;
//            }
//            iIndex++;
//        }
    // Move to product cell on now time
    NSIndexPath *idxCollection = [NSIndexPath indexPathForItem:iIndex inSection:0];
    [self.colViewProduct scrollToItemAtIndexPath:idxCollection atScrollPosition:UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    
    // Show Product ScrollView
    [UIView animateWithDuration:0.3 animations:^{
        // 수정 필요 - 상품이 오른쪽에서 왼쪽으로  <---   나오게 처리
        self.colViewProduct.hidden = NO;
        self.colViewProduct.alpha = 1.0;
        
        [self.view layoutIfNeeded];
    }];

}



#pragma mark
#pragma mark API Handler
- (void) getMobileLiveAPI
{
    //
    __block NSData *data = nil;
    NSString *strAPI = self.m_strAPIURL;
    NSURL *url = [NSURL URLWithString:strAPI];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 5;
    config.timeoutIntervalForResource = 15;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        if (!data) {
            //NSLog(@"%@", error);
            return;
        }
        
        if(error != nil)
            return;
        
        self.m_dicAPI = [data JSONtoValue];
        
        NSLog(@"____  %@", self.m_dicAPI);
        
        if(NCO(self.m_dicAPI) == NO)
            return;
        
        if(NCO([self.m_dicAPI objectForKey:@"mobileLivePrdsInfoList"]) == NO)
        {
            // nami0342 - 상품정보가 안들어오더라도, 진입되게 수정 요청 - 최유진m
//            return;
        }
        
        if([@"Y" isEqualToString:[self.m_dicAPI objectForKey:@"onAirYn"]] == NO)
        {
            // 수정 필요 - 방송 종료 팝업
            //            return;
        }
        
        NSLog(@"self.m_dicAPIself.m_dicAPIself.m_dicAPI = %@",self.m_dicAPI);
        // 생방송 / 재방송 판단
        if([@"replay" isEqualToString:[self.m_dicAPI objectForKey:@"broadType"]] == YES)
        {
            self.m_isLiveStatus = NO;
        }
        else
        {
            self.m_isLiveStatus = YES;
        }
        
        self.m_strGatePageURL = NCS([self.m_dicAPI objectForKey:@"gatePageUrl"]);
        
        // Set Live timer
        [self setLiveTimer];
        
        
        // 영상 정보 찾지 못했을 경우 처리
        if([NCS([self.m_dicAPI objectForKey:@"liveUrl"]) length] > 0)
        {
            self.m_strPlayURL = NCS([self.m_dicAPI objectForKey:@"liveUrl"]);
        }
        else
        {
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"home_nalbang_no_movie_text") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 111;
            [ApplicationDelegate.window addSubview:malert];
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        // 3G 상태 체크 및 사용자 동의시에만 구동
        if([self check3GNetworkAgree] == YES)
        {
            // Auto Play
            [self setupPlayer];
        }
        });
        
        // 상품 노출 순서 인덱스
        if([NCS([self.m_dicAPI objectForKey:@"currentPrdIndex"]) length] > 0 && [NCS([self.m_dicAPI objectForKey:@"currentPrdIndex"]) length] <2)
        {
            self.m_iCollectionIndex = [NCS([self.m_dicAPI objectForKey:@"currentPrdIndex"]) intValue];
        }
        else
        {
            self.m_iCollectionIndex = 0;
        }
        
        
        //스레드 체커가 appdelegate 는 메이스레드에서만 부르라고 경고줘서 추가
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectCSPServer];
        });
        
        // Set product list
        NSArray *arProductList = [self.m_dicAPI objectForKey:@"mobileLivePrdsInfoList"];
        if(NCO(arProductList) == YES)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                for(NSDictionary *dicTemp in arProductList)
                {
//                    // 판매가가 0원이나 없을 경우 제외 - 해당 부분만 안보이게 하고, 바로구매 비노출로 협의 (이민수) - 상품 클래스에서 해당 처리 함.
//                    if([NCS([dicTemp objectForKey:@"salePrice"]) length] == 0 || [@"0" isEqualToString:NCS([dicTemp objectForKey:@"salePrice"])] == YES)
//                    {
//                        continue;
//                    }
                    
                    MobileLiveProduct *productView  = [[[NSBundle mainBundle] loadNibNamed:@"MobileLiveProduct" owner:self options:nil] lastObject];
                    [self.m_marProductList addObject:productView];
                    
                    productView.delegate = self;
                    [productView setData:dicTemp];
                    
                }
                
                
                self.colViewProduct.hidden = YES;
                self.m_pcProductList.hidden = YES;
                
                if ([self.m_marProductList count] > 0) {
                    
                    self.m_ctScrollViewBottomHeight.constant = 64;
                    
                    self.m_pcProductList.numberOfPages = [self.m_marProductList count];
                    self.m_pcProductList.currentPage = 0;
                    [self.colViewProduct reloadData];
                    
                    [self showProductList:YES];
                    
                }
                else if([self.m_marProductList count] == 0)
                {
                
                }
                
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                // nami0342 - 상품정보가 없다. (판종일 경우 API에서 안 내려온다)
                
            });
        }
    }];
    [dataTask resume];
}




- (void) setLiveTimer
{
    /*
     liveNo: "2675",
     dealNo: "",
     mainTitle: "모바일라이브 보기",
     title: "테스트용날방",
     onAirYn: "N",
     nextLiveRemainTime: "",
     nextLiveStartTime: "",
     strDate: "20190214001000",
     endDate: "20190214003000",
     videoid: "5983716932001"
     */
    
    if(self.m_timerRemainTime.isValid)
    {
        [self.m_timerRemainTime invalidate];
        self.m_timerRemainTime = nil;
    }
    
    // Set timer for calcurate remain time.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.m_timerRemainTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(drawliveBroadlefttime) userInfo:nil repeats:YES];
    });
    
}



// 남은 시간 표시
- (void) drawliveBroadlefttime
{
    NSString *strEndDate = NCS([self.m_dicAPI objectForKey:@"endDate"]);
    
    // nami0342  - 장바구니 클릭해서 강제로 플레이어를 호출할 경우 시간 정보를 세팅해서 게이트 못 부르게 한다.
//#if DEBUG
//    strEndDate = @"20192220165000";
//#endif
    
    //((20 / 60) *100)
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    
    //종료시간
    NSDate *closeTime = [dateformat dateFromString:strEndDate];
    int closestamp = [closeTime timeIntervalSince1970];
    NSString * dbstr =   [NSString stringWithFormat:@"%d", closestamp];
    //reload tb 통신 실패시
    
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ self.m_lbRemainTime setText:[self getDateLeft:dbstr]];
            if(self.m_lbRemainTime.hidden == YES || self.m_imgvLive.hidden == YES)
            {
                self.m_lbRemainTime.hidden = NO;
                self.m_imgvLive.hidden = NO;
            }
        });
    }
    @catch (NSException *exception) {
        [self.m_timerRemainTime invalidate];
        NSLog(@"lefttimeLabel not Exist : %@",exception);
    }
    @finally {
    }
}


- (NSString *) getDateLeft:(NSString *)date {
    
    //self.m_isLiveStatus = NO;
    
    double left = [date doubleValue] - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    int tminite = left/60;
    int hour = left/3600;
    int minite = (left-(hour*3600))/60;
    int second = (left-(hour*3600)-(minite*60));
    NSString *callTemp = nil;
    
    
    if(tminite >= 60) {
        callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minite, second];
        
        if(self.m_isLiveStatus == YES)
        {   // Live
            if([self.m_imgvLive.image isEqual:[UIImage imageNamed:@"mobilelive_timerLive2.png"]] == NO)
            {
                self.m_imgvLive.image = [UIImage imageNamed:@"mobilelive_timerLive2.png"];
                self.m_ctImgvLiveWidth.constant = 128;
                self.m_ctLeftMarginTime.constant = 67;
            }
        }
        else
        {   // Replay
            if([self.m_imgvLive.image isEqual:[UIImage imageNamed:@"mobilelive_timerReplay2.png"]] == NO)
            {
                self.m_imgvLive.image = [UIImage imageNamed:@"mobilelive_timerReplay2.png"];
                self.m_ctImgvLiveWidth.constant = 137;
                self.m_ctLeftMarginTime.constant = 86;
            }
            
        }
    }
    else if(left <= 0) {
        //방송 종료 텍스트 bg가 mobileLive_onair_bg_live1 일경우 뚫고 나가고 bg_live2 일경우 앞 여백이 많이 남아서 스페이스 추가
        callTemp = [NSString stringWithFormat:@" %@",GSSLocalizedString(@"home_tv_live_view_close_text")];
        
        //방송 종료 텍스트 bg가 mobileLive_onair_bg_live1 일경우 뚫고 나가서 2로 변경
        if(self.m_isLiveStatus == YES)
        {   // Live
            self.m_imgvLive.image = [UIImage imageNamed:@"mobilelive_timerLive2.png"];
            self.m_ctImgvLiveWidth.constant = 128;
            self.m_ctLeftMarginTime.constant = 67;
        }
        else
        {   // Replay
            self.m_imgvLive.image = [UIImage imageNamed:@"mobilelive_timerReplay2.png"];
            self.m_ctImgvLiveWidth.constant = 137;
            self.m_ctLeftMarginTime.constant = 86;
        }
        
        
        // 방송 종료 처리 -
        [self performSelector:@selector(endOfLive) withObject:nil afterDelay:1.0];
        
        //타이머 초기화 안해서 1초후에 또 endOfLive 콜되서 웹뷰2개 뜨는 버그 수정
        if ([self.m_timerRemainTime isValid]) {
            [self.m_timerRemainTime invalidate];
        }
        
        
    }
    else {
        callTemp  = [NSString stringWithFormat:@"%02d:%02d", minite, second];
        
        
        
        if(self.m_isLiveStatus == YES)
        {   // Live
            if([self.m_imgvLive.image isEqual:[UIImage imageNamed:@"mobilelive_timerLive1.png"]] == NO)
            {
                self.m_imgvLive.image = [UIImage imageNamed:@"mobilelive_timerLive1.png"];
                self.m_ctImgvLiveWidth.constant = 102;
                self.m_ctLeftMarginTime.constant = 67;
            }
        }
        else
        {   // Replay
            if([self.m_imgvLive.image isEqual:[UIImage imageNamed:@"mobilelive_timerReplay1.png"]] == NO)
            {
                self.m_imgvLive.image = [UIImage imageNamed:@"mobilelive_timerReplay1.png"];
                self.m_ctImgvLiveWidth.constant = 120;
                self.m_ctLeftMarginTime.constant = 86;
            }
        }
    }
    
    if([callTemp isEqualToString:GSSLocalizedString(@"home_tv_live_view_close_text")]) {
        
    }
    return callTemp;
}



// 방송 종료 처리
- (void) endOfLive
{
    NSString *url = self.m_strGatePageURL;// [NSString stringWithString:GSMOBILELIVE_GATEPAGE]
    // 창 닫고, gatepage를 오출;
    
    // 나를 종료
    [self click_Close:nil];
    
    ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
    resVC.ordPass = NO;
    resVC.curUrlUse = YES;
    resVC.view.tag = 505;
    [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
}



#pragma mark
#pragma mark Alert delegate
- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 888)
    {
        if(index == 1)
        {
            // 3G 상태일 경우 허용
            // Auto Play
            [self setupPlayer];
            [DataManager sharedManager].strGlobal3GAgree = @"Y";
        }
        else
        {
            // 04.24 - 정진영이 닫아 달라고 알려줌
            [self click_Close:nil];
        }
    }
    else if(alert.tag == 111)
    {
        // 영상 정보 없어서 종료 처리
        [self click_Close:self];
    }
    else if(alert.tag ==1133) {
        
        switch (index) {
            case 1:
            {
                _loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                
                _loginView.loginViewType = 4;
                _loginView.btn_naviBack.hidden = NO;
                _loginView.delegate = self;
                
                [self.navigationController pushViewControllerMoveInFromBottom:_loginView];
            }
                break;
            default:
                
                break;
        }
    }
}




#pragma mark
#pragma mark 로그인 관련 delegate
- (NSString*) definecurrentUrlString {
    return @"MobileLive";
}

- (void) hideLoginViewController:(NSInteger)loginviewtype
{
}




#pragma marks - UICollection View Delegate & DataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.m_marProductList count] == 1) {
        
        return CGSizeMake(APPFULLWIDTH, 64.0);
        
    }else{
        
        if (indexPath.row == 0) {
            return CGSizeMake(12.0 + (APPFULLWIDTH -80.0) + 6.0 , 64.0);
        }else if (indexPath.row == [self.m_marProductList count]-1){ //row 0 과 동일하나 화면 개념상 적어둠
            return CGSizeMake(6.0 + (APPFULLWIDTH -80.0) + 12.0 , 64.0);
        }else{
            return CGSizeMake(6.0 + (APPFULLWIDTH -80.0) + 6.0, 64.0);
        }
        
    }
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.m_marProductList count];
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MobileLiveProductCell *cell = (MobileLiveProductCell *)[self.colViewProduct dequeueReusableCellWithReuseIdentifier:@"MobileLiveProductCell" forIndexPath:indexPath];

    for (MobileLiveProduct *subView in cell.subviews) {
        [subView removeFromSuperview];
    }
    
    MobileLiveProduct *subView = (MobileLiveProduct *)[self.m_marProductList objectAtIndex:indexPath.row];
    [cell addSubview:subView];
    
    
    if ([self.m_marProductList count] == 1) {
        
        subView.frame = CGRectMake(12.0, 0.0, APPFULLWIDTH - 24.0, 64.0);
        
    }else{
        
        if (indexPath.row == 0) {
            subView.frame = CGRectMake(12.0, 0.0, (APPFULLWIDTH -80.0), 64.0);
        }else if (indexPath.row == [self.m_marProductList count]-1){ //row 0 과 동일하나 화면 개념상 적어둠
            subView.frame = CGRectMake(6.0, 0.0, (APPFULLWIDTH -80.0), 64.0);
        }else{
            subView.frame = CGRectMake(6.0, 0.0, (APPFULLWIDTH -80.0), 64.0);
        }
        
    }
    
    
    
    return cell;
    
}


@end
