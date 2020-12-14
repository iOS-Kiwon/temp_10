//
//  GoodsEstNewViewController.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 5..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//
#import "GoodsEstNewViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "GoodsInfoRequest.h"
#import "GoodsInfo.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FileUtil.h"

#import <AVFoundation/AVFoundation.h>

@implementation GoodsEstNewViewController
#define _RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define RGBA_R(num) (((num&0xFF0000)>>16)/255.0)

#define RGBA_G(num) (((num&0x00FF00)>>8)/255.0)

#define RGBA_B(num) (((num&0x0000FF))/255.0)

#define DETAILIMGHEIGT 185.0

#define PHOTO_VIEW_TAG  300


#define RestrictedComment  GSSLocalizedString(@"review_hint_contents_restricted")

#define NonRestrictedComment  GSSLocalizedString(@"review_hint_contents_normal")
@synthesize prdID;
@synthesize hiddenFrame;
@synthesize visibleFrame;
@synthesize btnTag;
@synthesize labelTag;
@synthesize bImgSend;
@synthesize goodsInfoDict;
@synthesize rating1,rating2, rating3, rating4;
@synthesize target;

@synthesize pickerController;
@synthesize restrictByteLabel;
@synthesize imageLoadingOperation = imageLoadingOperation_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (id)initWithPrdid:(id)sender prdids:(NSString *)prdid {
    self = [super init];
    if(self) {
        self.target = sender;
        NSLog(@"prdid = %@",prdid);
        self.prdID = prdid;
        posGap = 0.0f;
        if(_sendimgArr == nil) {
            _sendimgArr = [[NSMutableArray alloc] init];
        }
        else {
            [_sendimgArr removeAllObjects];
        }
        
        //상품평 데이터 받음
        GoodsInfoRequest *ge = [[GoodsInfoRequest alloc]init];
        self.goodsInfoDict = [ge recvDataDic:self.prdID];
        NSLog(@"goodsInfoDict = %@",self.goodsInfoDict);
        
        if(self.goodsInfoDict == nil) {
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_failed_load_data") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 12;
            [ApplicationDelegate.window addSubview:lalert];
        }
        NSLog(@"errorMessage = %@",[self.goodsInfoDict valueForKey:@"errorMessage"]);
        if([self.goodsInfoDict valueForKey:@"webError"] != nil ) {
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:[[self.goodsInfoDict valueForKey:@"webError"] valueForKey:@"errorMessage"] maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 12;
            [ApplicationDelegate.window addSubview:lalert];
        }
    }
    return self;
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    LastPrdCustomTabBarView *tabBarView  = [[[NSBundle mainBundle] loadNibNamed:@"LastPrdCustomTabBarView" owner:self options:nil] firstObject];
    tabBarView.frame = CGRectMake(0.0, APPFULLHEIGHT - APPTABBARHEIGHT, APPFULLWIDTH, APPTABBARHEIGHT);
    tabBarView.autoresizesSubviews = NO;
    tabBarView.autoresizingMask = UIViewAutoresizingNone;
    
    self.topHeaderView.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH,45 + STATUSBAR_HEIGHT);
    
    [self.view addSubview:tabBarView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    CGFloat heightContents = view_g1.frame.size.height + view_g2.frame.size.height + view_g3.frame.size.height + view_g4.frame.size.height + view_g5.frame.size.height + view_g6.frame.size.height;
    
    BOOL photenabled = [[[self.goodsInfoDict valueForKey:CONTENT] objectForKey:PRDREVWTYPCD] isEqualToString:@"generalProduct"] ? YES : NO;
    
    scrViewAttach.frame = CGRectMake(scrViewAttach.frame.origin.x, scrViewAttach.frame.origin.y, APPFULLWIDTH-30.0, scrViewAttach.frame.size.height);
    [scrViewAttach setContentSize:CGSizeMake(330.0, scrViewAttach.frame.size.height)];
    
    view_g7.hidden = YES;
    
    if (!photenabled) {
        view_g5.hidden = YES;
        view_g4.hidden = YES;
        view_g7.hidden = NO;
        
        //20161125 parksegun 상품평 정보 추가
        
        NSString *msg = GSSLocalizedString(@"review_info");
        
        CGSize totsize = [msg MochaSizeWithFont: [UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(APPFULLWIDTH - 80, 100.0) lineBreakMode:NSLineBreakByWordWrapping];
        infoMsg.text = msg;
        infoMsg.frame = CGRectMake(infoMsg.frame.origin.x, infoMsg.frame.origin.y, infoMsg.frame.size.width, totsize.height);
        
        
        viewg7_bg.frame = CGRectMake(viewg7_bg.frame.origin.x, viewg7_bg.frame.origin.y, viewg7_bg.frame.size.width,infoMsg.frame.size.height + 30);
        view_g7.frame = CGRectMake(view_g7.frame.origin.x, view_g7.frame.origin.y, view_g7.frame.size.width, viewg7_bg.frame.size.height + 15);
        
        
        
        view_g6.frame = CGRectMake(view_g6.frame.origin.x, view_g7.frame.origin.y + view_g7.frame.size.height , view_g6.frame.size.width, view_g6.frame.size.height);
        view_g1.frame = CGRectMake(view_g1.frame.origin.x, view_g6.frame.origin.y + view_g6.frame.size.height, view_g1.frame.size.width, view_g1.frame.size.height);
        
        [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height- view_g5.frame.size.height - view_g4.frame.size.height )];
        
        heightContents = heightContents - view_g4.frame.size.height;
        heightContents = heightContents - view_g5.frame.size.height + view_g7.frame.size.height;

    }
    imgview_detailimg.frame = CGRectMake(APPFULLWIDTH/2.0 - (160.0), 0.0, 320.0, DETAILIMGHEIGT);
    
    //네비게이션바
    NSString* reviewid = [[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:PRDREVWID];
    
    //별점없으면 5로 세팅 - 기본5점 내려주므로 제외
    
    if(![reviewid isKindOfClass:[NSNull class]] || reviewid == nil)
    {
        label_vtitle.text = GSSLocalizedString(@"review_title_modify");//상품평수정 masterId로 구분
        
        view_g1.hidden = YES;
        
        heightContents = heightContents - view_g1.frame.size.height;
        
        //isEqualToString:@"<null> 이렇게 올수도 있는데 배열일경우에는 crash 나네...
        if([[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:ATACHFILEPATHLIST] isKindOfClass:[NSNull class]])
        {
            
            NSLog(@"[NSNull class]");
            self.bImgSend = 0;
        }
        else
        {

            NSLog(@"[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:ATACHFILEPATHLIST] = %@",[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:ATACHFILEPATHLIST]);
            
            //혹시나 배열로 안오고 <null> 이런것으로 올지 모르니 배열 일경우에만!
            if ([[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:ATACHFILEPATHLIST] isKindOfClass:[NSArray class]]) {
                NSArray *arrFilePathList = (NSArray *)[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:ATACHFILEPATHLIST];
                [self attachFileListDownload:arrFilePathList];
                self.bImgSend = 1;
                
                posGap = 57.0f;
            }

            
        }
        
    }
    else{
        self.bImgSend = 0;
        label_vtitle.text = GSSLocalizedString(@"review_title_write");//상품평수정 masterId로 구분
        view_g1.hidden = NO;
    }

    
    [self.view insertSubview:scrollView atIndex:0];
    
    NSLog(@"insertSubviewinsertSubview scrollview");

    scrViewAttach.scrollsToTop = NO;
    scrollView.scrollsToTop = NO;
    
    //scrollView.frame = CGRectMake(0.0f, 45.0f, APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height-113);
    scrollView.frame = CGRectMake(0.0f, 20.0 + 45.0f, APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height-113);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(APPFULLWIDTH,heightContents + (IS_IPHONE_X_SERISE ? 40 : 0));
    
    [self goodsNameUI];//상품명
    [self starDisplayUI];//등급표시
    [self goodsEstimationWriteUI];
    [self registerGoodsEstimatiionUI];
    
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(closeCameraorAlbumModal) withObject:nil afterDelay:0.01f];
    [super viewWillAppear:NO];
    
}

//in-call 스테이터스바 확장 대응 2016.01 yunsang.jin
-(void)viewWillLayoutSubviews {
    NSLog(@"scrollView = %@",scrollView);
    scrollView.frame = CGRectMake(0.0f, STATUSBAR_HEIGHT + 45.0f, APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height-93 - STATUSBAR_HEIGHT);
    NSLog(@"scrollView = %@",scrollView);
}

-(void)closeCameraorAlbumModal {
    [self  dismissViewControllerAnimated:YES completion:nil];
}
//GA 추적
- (void)viewDidAppear:(BOOL)animated {
    [ApplicationDelegate GTMscreenOpenSendLog:@"iOS - Review"];
    [self performSelector:@selector(pictureViewUI) withObject:nil afterDelay:1.0f];
    [super viewDidAppear:NO];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)loadingDataSet {
    NSLog(@"self.goods.ratingScore1 = %@",[self.goodsInfoDict valueForKey:@"ratingScore1"]);
    if([NCS([self.goodsInfoDict valueForKey:@"ratingScore1"]) isEqualToString:@""]) {
        [self.goodsInfoDict setValue:@"5" forKey:@"ratingScore1"];
    }
    if([NCS([self.goodsInfoDict valueForKey:@"ratingScore2"]) isEqualToString:@""]) {
        [self.goodsInfoDict setValue:@"5" forKey:@"ratingScore2"];
    }
    if([NCS([self.goodsInfoDict valueForKey:@"ratingScore3"]) isEqualToString:@""]) {
        [self.goodsInfoDict setValue:@"5" forKey:@"ratingScore3"];
    }
    if([NCS([self.goodsInfoDict valueForKey:@"ratingScore4"]) isEqualToString:@""]) {
        [self.goodsInfoDict setValue:@"5" forKey:@"ratingScore4"];
    }
    
}
//캐시폴더에 이미지저장.
- (NSString *) applicationCacheDirectory {
    if([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) count] > 0)
        return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    else
        return @"";
}
//캐시폴더 파일 삭제하기/ 존재여부 확인후 삭제
- (BOOL)docFileDelete {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDirectory = [self applicationCacheDirectory];
    NSString *writableDBPath = [cacheDirectory stringByAppendingPathComponent:@"image.jpg"];
    NSLog(@"file = %@",writableDBPath);
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    
    if (dbexits) //존재하면 삭제
    {
        [fileManager removeItemAtPath:writableDBPath error:NULL];
    }
    
    return YES;
}

//goWebView
- (IBAction)GoBackNGoDetailURL {
    
    NSLog(@"GoodsExtimate goBack N Detail Page");
    [_sendimgArr removeAllObjects];
    [DataManager sharedManager].cameraFlag = NO;
    
    [self.target performSelector:@selector(goWebView:) withObject:[NSString stringWithFormat:@"%@%@",GSPRODUCTDETAILURL, [[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDCD]] afterDelay:0.1f];
    [self.navigationController  popViewControllerAnimated:NO];
    
    
}

- (void)goReturnURL:(NSString *)returnURL {
    NSLog(@"GoodsExtimate goBack");
    [_sendimgArr removeAllObjects];
    [DataManager sharedManager].cameraFlag = NO;
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVERURI, returnURL];
    [self.target performSelector:@selector(goWebView:) withObject:url];
    [self.navigationController popViewControllerMoveInFromTop];
    
    //탭바1
    [ApplicationDelegate tabbarHidden:NO animated:YES];
    //도큐멘트에 있는 찍은 사진을 삭제하고 넘어간다.
}

- (IBAction)GoBack
{
    NSLog(@"GoodsExtimate goBack");
    [_sendimgArr removeAllObjects];
    [DataManager sharedManager].cameraFlag = NO;
    [self.target performSelector:@selector(webViewReload)];
    [self.navigationController popViewControllerMoveInFromTop];
    
    //탭바1
    [ApplicationDelegate tabbarHidden:NO animated:YES];
    //도큐멘트에 있는 찍은 사진을 삭제하고 넘어간다.
}
- (void)dealloc
{
    NSLog(@"");
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"");
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark -
#pragma mark UI Method
//label create
-(void)labelCreate:(NSString *)name frame:(CGRect)frame views:(UIView *)mainview txtSize:(NSInteger)size color:(UIColor *)color
           aliment:(NSTextAlignment)aliment line:(NSInteger)num tags:(NSInteger) labelTags
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = name;
    [label setBackgroundColor:[UIColor clearColor]];
    label.textColor = color;
    label.tag = labelTags;
    label.textAlignment = aliment;
    label.font = [UIFont systemFontOfSize:size];
    label.numberOfLines = num;
    label.adjustsFontSizeToFitWidth = YES;
    
    [label setIsAccessibilityElement:YES];
    [mainview addSubview:label];
}


#pragma mark -
#pragma mark UI

//상품 이름
- (void)goodsNameUI
{

    NSURL *productImageURL = [NSURL URLWithString:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDIMG]];
    
    imgProduct.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:productImageURL]];
    lblProductName.text = [[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EXPOSPRDNM];
    
    NSLog(@" %@",[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDIMG]);
    //제품상세이름
    NSLog(@"productName = %@", [[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EXPOSPRDNM]);
    NSLog(@"[productName length] = %d",(int)[[self.goodsInfoDict valueForKey:@"productName"] length]*12);
    
    //단품이동 버튼
    UIButton* cbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn setFrame:CGRectMake(0,0,APPFULLWIDTH-110,80)];
    [cbtn addTarget:self action:@selector(GoBackNGoDetailURL) forControlEvents:UIControlEventTouchUpInside];
    [view_g2 addSubview:cbtn];
}

//등급 주기
- (void)starDisplayUI
{
    
    [viewg3_bg.layer setMasksToBounds:NO];
    viewg3_bg.layer.shadowOffset = CGSizeMake(0, 0);
    viewg3_bg.layer.shadowRadius = 0.0;
    viewg3_bg.layer.borderColor = [Mocha_Util getColor:@"D6D6D6"].CGColor;
    viewg3_bg.layer.borderWidth = 1;
    
    
    UIImage *myNoRatingImage = [UIImage imageNamed:@"ico_star_off.png"];
    
    
    UIImage *myRatingImage = [UIImage imageNamed:@"ico_star_on.png"];
    
    
    NSLog(@"%@",[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMVAL1]);
    
    //88,75
    CGRect rect1 = CGRectMake(44, 34, [Mocha_Util DPRateOriginVAL:58] , 14);
    [self labelCreate:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMNM1] frame:rect1 views:view_g3 txtSize:13 color:[Mocha_Util getColor:@"444444"] aliment:NSTextAlignmentRight line:0 tags:20];
    
    //121,36
    
    rating1 = [[MochaUIRating alloc] initWithFrame:CGRectMake((APPFULLWIDTH/2)-39,29,250,22)];
    self.rating1.onRatingImage = myRatingImage;
    self.rating1.offRatingImage = myNoRatingImage;
    self.rating1.scale = MochaRatingScaleWhole;
    [self.rating1 setRating:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMVAL1] intValue]];
    self.rating1.delegate = self;
    self.rating1.tag = 1;
    self.rating1.backgroundColor = [UIColor clearColor];
    
    [view_g3 addSubview:rating1];
    
    CGRect rect2 = CGRectMake(44, 34 + 40.0, [Mocha_Util DPRateOriginVAL:58], 14);
    
    [self labelCreate:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMNM2] frame:rect2 views:view_g3 txtSize:13 color:[Mocha_Util getColor:@"444444"] aliment:NSTextAlignmentRight line:0 tags:21];
    
    rating2 = [[MochaUIRating alloc] initWithFrame:CGRectMake((APPFULLWIDTH/2)-39,29 + 40.0,250,22)];
    self.rating2.onRatingImage = myRatingImage;
    self.rating2.offRatingImage = myNoRatingImage;
    self.rating2.scale = MochaRatingScaleWhole;
    
    [self.rating2 setRating:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMVAL2] intValue]];
    
    self.rating2.delegate = self;
    self.rating2.tag = 2;
    self.rating2.backgroundColor = [UIColor clearColor];
    
    [view_g3 addSubview:rating2];
    
    
    CGRect rect3 = CGRectMake(44, 34 + 80.0, [Mocha_Util DPRateOriginVAL:58], 14);
    [self labelCreate:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMNM3] frame:rect3 views:view_g3 txtSize:13 color:[Mocha_Util getColor:@"444444"] aliment:NSTextAlignmentRight line:0 tags:22];
    
    
    rating3 = [[MochaUIRating alloc] initWithFrame:CGRectMake((APPFULLWIDTH/2)-39,29 + 80.0,250,22)];
    self.rating3.onRatingImage = myRatingImage;
    self.rating3.offRatingImage = myNoRatingImage;
    self.rating3.scale = MochaRatingScaleWhole;
    
    [self.rating3 setRating:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMVAL3] intValue]];
    self.rating3.delegate = self;
    self.rating3.tag = 3;
    self.rating3.backgroundColor = [UIColor clearColor];
    
    [view_g3 addSubview:rating3];
    
    
    CGRect rect4 = CGRectMake(44, 34 + 120.0, [Mocha_Util DPRateOriginVAL:58], 14);
    [self labelCreate:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMNM4] frame:rect4 views:view_g3 txtSize:13 color:[Mocha_Util getColor:@"444444"] aliment:NSTextAlignmentRight line:0 tags:23];
    
    rating4 = [[MochaUIRating alloc] initWithFrame:CGRectMake((APPFULLWIDTH/2)-39,29 + 120.0,250,22)];
    self.rating4.onRatingImage = myRatingImage;
    self.rating4.offRatingImage = myNoRatingImage;
    self.rating4.scale = MochaRatingScaleWhole;
    [self.rating4 setRating:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMVAL4] intValue]];
    self.rating4.delegate = self;
    self.rating4.tag = 4;
    self.rating4.backgroundColor = [UIColor clearColor];
    

    [view_g3 addSubview:rating4];
}

//상품평 내용
- (void)goodsEstimationWriteUI
{
    
    [viewg4_bg.layer setMasksToBounds:NO];
    viewg4_bg.layer.shadowOffset = CGSizeMake(0, 0);
    viewg4_bg.layer.shadowRadius = 0.0;
    viewg4_bg.layer.borderColor = [Mocha_Util getColor:@"B8B8B8"].CGColor;
    viewg4_bg.layer.borderWidth = 1;
    
    //외각 라인 넣기
    [viewg7_bg.layer setMasksToBounds:NO];
    viewg7_bg.layer.shadowOffset = CGSizeMake(0, 0);
    viewg7_bg.layer.shadowRadius = 0.0;
    viewg7_bg.layer.borderColor = [Mocha_Util getColor:@"e5e5e5"].CGColor;
    viewg7_bg.layer.borderWidth = 1;
    
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height, APPFULLWIDTH, 44)];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        toolBar.barStyle = UIBarStyleDefault;
    } else {
        
        toolBar.barStyle = UIBarStyleBlackTranslucent;
    }
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:(version >= 7.0)?GSSLocalizedString(@"common_txt_alert_btn_complete"):GSSLocalizedString(@"common_txt_alert_btn_close") style:(version >= 7.0)?UIBarButtonItemStylePlain:UIBarButtonItemStyleDone target:self action:@selector(confirm1:)];
    closeBtn.tag = 66;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects: flexibleSpace, closeBtn, nil] animated:NO];
    
    
    descTextView = [[UITextView alloc]initWithFrame:CGRectMake(25, 22, APPFULLWIDTH-53, 130)];

    descTextView.textAlignment = NSTextAlignmentLeft;
    descTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    descTextView.delegate = self;
    descTextView.scrollsToTop = NO;
    
    if(([[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] isKindOfClass:[NSNull class]]) ||
       ([[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY]  == NULL))  {
        
        // 20140219 Youngmin Jin -Start
        // 안내 문구 조건 변경
        BOOL photenabled = [[[self.goodsInfoDict valueForKey:CONTENT] objectForKey:PRDREVWTYPCD] isEqualToString:@"generalProduct"] ? YES : NO;
        // 20140219 Youngmin Jin -End
        if (photenabled) {
            descTextView.text = NonRestrictedComment;
        }else {
            descTextView.text = RestrictedComment;
        }
        
    }
    else
    {

        NSString *str1 = [[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY];
        NSLog(@"reviewContents = %@",str1);
        str1 = [str1 stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        NSLog(@"reviewContents = %@",str1);
        
        //HTML구문제거 - image tag 삭제를 위한.
        descTextView.text = [Mocha_Util stringByStrippingHTML:str1];
        
        NSInteger convertedLength = [descTextView.text lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
        [restrictByteLabel setText:[NSString stringWithFormat:@"%ld",(unsigned long)convertedLength]];
        
    }
    
    descTextView.editable = YES;
    descTextView.inputAccessoryView = toolBar;
    [descTextView setFont:[UIFont systemFontOfSize:13]]; //폰트 크기 설정
    [descTextView setTextColor:[Mocha_Util getColor:@"aaaaaa"]];
    
    
    [view_g4 addSubview:descTextView];
    
    
}
- (void)confirm1:(id)sender {
    [descTextView resignFirstResponder];
}



-(IBAction)detailViewSwitch:(id)sender {
    
    btn_g1_detail.selected = !btn_g1_detail.selected;
    
    CGFloat heightContents = 640.0;
    if (view_g5.hidden) {
        heightContents = heightContents - view_g5.frame.size.height;
    }
    
    if(btn_g1_detail.selected) {
        
        view_g1_bottomLine.hidden = YES;
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             
                             view_g1.frame =   CGRectMake(view_g1.frame.origin.x,view_g1.frame.origin.y, APPFULLWIDTH,30+DETAILIMGHEIGT);
                             scrollView.contentSize = CGSizeMake(APPFULLWIDTH,heightContents+DETAILIMGHEIGT);
                             if(imgview_detailimg.image == nil) {
                                 UIImage *dimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:GSESTMATEINFOIMGURL]]];
                                 imgview_detailimg.image = dimage;
                             }
                             imgview_detailimg.frame = CGRectMake(APPFULLWIDTH/2.0 - (160.0), 30.0, 320.0, DETAILIMGHEIGT);
                             
                             
                             
                             
                             if([descTextView isFirstResponder]){
                                 scrollView.contentOffset= CGPointMake(0,scrollView.contentOffset.y+DETAILIMGHEIGT+30);
                             }else {
                                 scrollView.contentOffset= CGPointMake(0,scrollView.contentOffset.y+DETAILIMGHEIGT);
                                 NSLog(@"");
                             }

                         }
         
                         completion:^(BOOL finished){
                             
                             
                         }];
    }
    //닫기
    else {
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             
                             
                             view_g1.frame =   CGRectMake(0.0,view_g1.frame.origin.y, APPFULLWIDTH,30);
                             scrollView.contentSize = CGSizeMake(APPFULLWIDTH,heightContents);//515
                             
                             imgview_detailimg.frame = CGRectMake(APPFULLWIDTH/2.0 - (160.0), 30.0, 320.0, 0);
                             
                             
                         }
         
                         completion:^(BOOL finished){
                             
                             
                             view_g1_bottomLine.hidden = NO;
                             
                             if(getLongerScreenLength == 480) {
                                 if([descTextView isFirstResponder]){
                                     [descTextView becomeFirstResponder];
                                     scrollView.contentOffset = CGPointMake(0, 275);
                                 }
                             }
                             else if(getLongerScreenLength == 568) {
                                 
                                 if([descTextView isFirstResponder]){
                                     [descTextView becomeFirstResponder];
                                     scrollView.contentOffset = CGPointMake(0, 287);
                                 }
                             }
                             else if(getLongerScreenLength == 667) {
                                 
                                 if([descTextView isFirstResponder]){
                                     [descTextView becomeFirstResponder];
                                     scrollView.contentOffset = CGPointMake(0, 264);
                                 }
                             }
                             else {
                                 
                                 
                             }
                             
                             
                             
                             
                         }];
        
    }
    
    
}










//----------------------------------------------------------------------------------------------------

//수정될 이미지 다운로드

-(void)attachFileListDownload:(NSArray *)arrFilePath{
    
    [ApplicationDelegate.gactivityIndicator startAnimating];
    
    NSMutableArray *arrImageAsync = [[NSMutableArray alloc] initWithCapacity:[arrFilePath count]];
    NSMutableArray *arrIndexAsync = [[NSMutableArray alloc] initWithCapacity:[arrFilePath count]];
    
    for (int i=0; i<[arrFilePath count]; i++) {
        
        NSString *imageURL = NCS([arrFilePath objectAtIndex:i]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                  {
                      NSLog(@"isInCache !!");
                  }
                  
                    [arrImageAsync addObject:fetchedImage];
                    [arrIndexAsync addObject:[NSNumber numberWithInteger:i]];
                    
//                    NSLog(@"arrImageAsync = %@",arrImageAsync);
//                    NSLog(@"arrIndexAsync = %@",arrIndexAsync);
                    
                  if ([arrImageAsync count] == [arrFilePath count]) {
                      //파일이 모두 비동기로 다운로드 완료 되었으면
                      
                      NSMutableArray *arrReOrder = [[NSMutableArray alloc] init];
                      
                      for (NSInteger idx = 0; idx<[arrIndexAsync count]; idx++) {
                          for (NSInteger r=0; r<[arrIndexAsync count]; r++) {
                              if ([[arrIndexAsync objectAtIndex:r] integerValue] == idx) {
                                  [arrReOrder addObject:[arrImageAsync objectAtIndex:r]];
                                  break;
                              }
                              
                          }
                      }
                      
                      [_sendimgArr addObjectsFromArray:arrReOrder];
                      [self pictureViewUI];
                  }
                });
                  
            }
            
      }];
    }
    
    
    NSLog(@"attachFileListDownload end????");


    
}
//올릴 사진 보여주기, 사진이 없으면 안보여진다.
- (void)pictureViewUI
{
    // test code 20140108 -Youngmin Jin Start
    BOOL photenabled = [[[self.goodsInfoDict valueForKey:CONTENT] objectForKey:PRDREVWTYPCD] isEqualToString:@"generalProduct"] ? YES : NO;
    // test code 20140108 -Youngmin Jin End
    if(!photenabled) {
        
        return;
    
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [ApplicationDelegate.gactivityIndicator stopAnimating];
        
    });
    
    NSLog(@"카운텃: %ld byte ",(unsigned long)[_sendimgArr count]);
    
    
    int intViewRemove=10;
    int intViewAdd=20;
    for (int i=0; i<RESTRICT_ESTPHOTOCOUNT; i++) {
        [view_g5 viewWithTag:(i*100+intViewRemove)].hidden = YES;
        [view_g5 viewWithTag:(i*100+intViewAdd)].hidden = NO;
        ((UIImageView *)[view_g5 viewWithTag:(i*100+intViewRemove + 1)]).image = nil;
    }
    
    if([_sendimgArr count] > 0)//파일 존재하면
    {
        
        for (int i=0; i<[_sendimgArr count]; i++) {
            if ([[_sendimgArr objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                
                [view_g5 viewWithTag:(i*100+intViewAdd)].hidden = YES;
                [view_g5 viewWithTag:(i*100+intViewRemove)].hidden = NO;
                ((UIImageView *)[view_g5 viewWithTag:(i*100+intViewRemove + 1)]).image = (UIImage *)[_sendimgArr objectAtIndex:i];
                
            }
        }
        self.bImgSend = 1;
        
    }else {
        
        self.bImgSend = 0;
    }
    
}
//서버에 업로드할 이미지를 썸네일로 보여줌
- (void)upLoadImageShow
{
}

#pragma mark MochaUIRatingDelegate

-(void) DidChangePoint:(MochaUIRating *) rating {
    
}

#pragma mark -
#pragma mark image Control
//상품평 카메라 show

-(IBAction)onBtnAddPhoto:(id)sender{

    [self pictureBtnAction:sender];
    
}
-(IBAction)onBtnRemovePhoto:(id)sender{
    [self pictureBtnAction:sender];
}


#pragma mark -
#pragma mark UITextView DELEGATE



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // return키를 누루면 원래 줄바꿈이 일어나므로 \n을 입력하는데 \n을 입력하면 실행하게 합니다.
        NSLog(@"return ");
        //[textView resignFirstResponder]; //키보드를 닫는 메소드입니다.
        //return FALSE; //리턴값이 FALSE이면, 입력한 값이 입력되지 않습니다.
    }
    
    

    NSString *replacedString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSUInteger convertedLength = [replacedString lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
    
    
    if (convertedLength <= RESTRICT_ESTBYTEINTEGER) {
        
        return YES;
    }else{
        BOOL isthereMarlert = NO;
        for ( UIView* v in  [ApplicationDelegate.window subviews] )
        {
            
            if(v.tag == 379){
                isthereMarlert = YES;
            }
            
        }
        
        if(isthereMarlert==NO){
            
            
            [descTextView resignFirstResponder];
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"review_exceed_len")  maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 379;
            [ApplicationDelegate.window addSubview:lalert];
        }
        
        return NO;
    }
    
    
    NSLog(@"");
    return TRUE;
}



- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"");
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         
                         
                         if(getLongerScreenLength == 480) {
                             scrollView.contentOffset = CGPointMake(0, 180);
                         }
                         else if(getLongerScreenLength == 568) {
                             
                             scrollView.contentOffset = CGPointMake(0, 50);
                             
                         } else if(getLongerScreenLength == 667) {
                             
                             
                             scrollView.contentOffset = CGPointMake(0, 0);
                         }
                         
                         else if(getLongerScreenLength == 736) {
                             
                             
                             scrollView.contentOffset = CGPointMake(0, 0);
                         }
                         
                         else if(getLongerScreenLength == 1024) {
                             
                             
                         }else {
                             
                             
                         }
                         
                         
                         
                         
                         
                     }
     
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"");
    if(([textView.text isEqualToString:NonRestrictedComment]) ||([textView.text isEqualToString:RestrictedComment]))
    {
        [descTextView setTextColor:[Mocha_Util getColor:@"888888"]];
        descTextView.text = @"";
        [self.restrictByteLabel setText:[NSString stringWithFormat:@"0"]];
    }
    
    
    
    
    
    dispatch_async( dispatch_get_main_queue(), ^(void){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        
        
        if(getLongerScreenLength == 480) {
            scrollView.contentOffset = CGPointMake(0, 270);
        }
        else if(getLongerScreenLength == 568) {
            
            scrollView.contentOffset = CGPointMake(0, 264);
            
        } else if(getLongerScreenLength == 667) {
            scrollView.contentOffset = CGPointMake(0, 264);
            
        }
        
        else if(getLongerScreenLength == 736) {
            scrollView.contentOffset = CGPointMake(0, 264);
            
        }
        
        else if(getLongerScreenLength == 1024) {
            
            
        }else {
            
            
        }
        
        
        
        [UIView commitAnimations];
        
    });
    
    NSLog(@"");
}
- (IBAction)descTextViewendEditing:(id)sender{
    [descTextView resignFirstResponder];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"");
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    NSLog(@"");
    NSInteger convertedLength = [textView.text lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
    [restrictByteLabel setText:[NSString stringWithFormat:@"%ld",(unsigned long)convertedLength]];
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    NSInteger convertedLength = [textView.text lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
    
    const char *targetChar = [textView.text cStringUsingEncoding:(0x80000000 + 0x0422)];
    
    NSLog(@"%ld 글자 입력", (long)convertedLength);
    if (convertedLength > RESTRICT_ESTBYTEINTEGER) {
        NSData *data = [NSData dataWithBytes:targetChar length:RESTRICT_ESTBYTEINTEGER];
        NSString *convertedStr = [[NSString alloc] initWithData:data encoding:(0x80000000 + 0x0422)];
        if (convertedStr == nil) {
            data = [NSData dataWithBytes:targetChar length:RESTRICT_ESTBYTEINTEGER-1];
            convertedStr = [[NSString alloc] initWithData:data encoding:(0x80000000 + 0x0422)];
        }
        textView.text = convertedStr;
        
        
        
        BOOL isthereMarlert = NO;
        for ( UIView* v in  [ApplicationDelegate.window subviews] )
        {
            
            if(v.tag == 379){
                isthereMarlert = YES;
            }
            
        }
        
        if(isthereMarlert==NO){
            
            
            [descTextView resignFirstResponder];
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"review_exceed_len")  maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 379;
            [ApplicationDelegate.window addSubview:lalert];
        }
        
        
    }
    convertedLength = [textView.text lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
    [restrictByteLabel setText:[NSString stringWithFormat:@"%ld",(unsigned long)convertedLength]];
    
    [[self.goodsInfoDict valueForKey:CONTENT] setValue:[Mocha_Util stringByStrippingHTML:textView.text] forKey:PRDREVWBODY];
    NSLog(@"reviewContents = %@",[self.goodsInfoDict valueForKey:CONTENT]);
}

//상품평 데이터 서버로 보내기
- (IBAction)btnAction:(id)sender
{
    
    
    if( rating1.rating < 1 || rating2.rating < 1 || rating3.rating < 1 || rating4.rating < 1){
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"review_validation_rating")  maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 379;
        [ApplicationDelegate.window addSubview:lalert];
        return;
    }
    
    
    NSInteger convertedLength = [[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"입력글자length: %ld",  (long)convertedLength);
    

    //20140425 오류 확인및 수정 shawn
    if([[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWTYPCD] isEqualToString:@"evaluationProduct"]  ){
        
        //식품-의약품의 경우 상품평 null 인정 20140425 수정 prdrevwTypCd = evaluationProduct 인경우
        
    }
    else {
        if ([[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] isKindOfClass:[NSNull class]])
        {
            [descTextView resignFirstResponder];
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"review_validation_nothing") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 379;
            [ApplicationDelegate.window addSubview:lalert];
            return;
        }else
            if(convertedLength < 13)
            {
                
                [descTextView resignFirstResponder];
                
                Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"review_validation_min_length") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                lalert.tag = 379;
                [ApplicationDelegate.window addSubview:lalert];
                return;
            }
        
        
        
    }
    
    
    
    //#define degreesToRadian(x) (M_PI * (x) /180.0)
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1) {
        NSString *str1 = [[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY];
        str1 = [str1 stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        [[self.goodsInfoDict valueForKey:CONTENT] setValue:str1 forKey:PRDREVWBODY];
        NSLog(@"reviewContents = %@",str1);
        //-----------
        [descTextView resignFirstResponder];
        if(self.bImgSend == 1) {
            [self.goodsInfoDict setValue:@"image.png" forKey:@"hidden_name_0"];
        }
        GoodsInfoRequest *ge = [[GoodsInfoRequest alloc]init];
        ge.delegate = self;
        // NSLog(@"bImgSend = %d", self.bImgSend);
        
        
        NSLog(@" %@, %@, %@, %@",  [NSString stringWithFormat:@"%.00f",rating1.rating],  [NSString stringWithFormat:@"%.00f",rating2.rating],  [NSString stringWithFormat:@"%.00f",rating3.rating],  [NSString stringWithFormat:@"%.00f",rating4.rating]);
        
        // 2013 12 27 Youngmin Jin send Data Create - Start
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDCD] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDCD]];
        [dic setValue:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:ORDNO] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, ORDNO]];
        
        [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EXPOSPRDNM] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EXPOSPRDNM]];
        [dic setValue:@"1" forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, ATACHFILEGBN]];
        [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMNM1] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EVALITMNM1]];
        [dic setValue:[NSString stringWithFormat:@"%.00f",rating1.rating] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EVALITMVAL1]];
        [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMNM2] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EVALITMNM2]];
        [dic setValue:[NSString stringWithFormat:@"%.00f",rating2.rating] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EVALITMVAL2]];
        [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMNM3] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EVALITMNM3]];
        [dic setValue:[NSString stringWithFormat:@"%.00f",rating3.rating] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EVALITMVAL3]];
        [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:EVALITMNM4] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EVALITMNM4]];
        [dic setValue:[NSString stringWithFormat:@"%.00f",rating4.rating] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, EVALITMVAL4]];
        
        if (![[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA]valueForKey:ORDITEMOPTNM1] isKindOfClass:[NSNull class]]) {
            [dic setValue:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:ORDITEMOPTNM1] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, ORDITEMOPTNM1]];
        }
        else {
            [dic setValue:@"" forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, ORDITEMOPTNM1]];
        }
        
        if (![[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA]valueForKey:ORDITEMOPTNM2] isKindOfClass:[NSNull class]]) {
            [dic setValue:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:ORDITEMOPTNM2] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, ORDITEMOPTNM2]];
        }
        else {
            [dic setValue:@"" forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, ORDITEMOPTNM2]];
        }
        
        [dic setValue:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:HPTSTFLG] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, HPTSTFLG]];
        [dic setValue:@"mobilePrd" forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDREVWWRITEPATH]];
        
        
        if([[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] length] == 0) {
            [dic setValue:@""  forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDREVWBODY]];
        }
        else {
            [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDREVWBODY]];
        }
        NSLog(@" PRDREVWBODY] length %lu", (long)[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] length] );
        
        if([[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] length] == 0) {
            [dic setValue:@"" forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDREVWTITLE]];
        }
        else if([[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] length] < 50) {
            [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDREVWTITLE]];
        }
        else {
            NSLog(@"[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] substringToIndex:50] = %@",[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] substringToIndex:50]);
            [dic setValue:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWBODY] substringToIndex:50] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDREVWTITLE]];
        }
        
        [dic setValue:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:ORDITEMOPTEXPOSFLG] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, ORDITEMOPTEXPOSFLG]];
        [dic setValue:[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:PRDREVWTYPCD] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDREVWTYPCD]];
        [dic setValue:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:HPTSTPMONO] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, HPTSTPMONO]];
        
        if([[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:PRDREVWID] isKindOfClass:[NSNull class]] == NO) {
            [dic setObject:[[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:PRDREVWID] forKey:[NSString stringWithFormat:@"%@.%@", PRDREVW, PRDREVWID]];
        }
        
        if ([_sendimgArr count] > 0) {
            [dic setObject:_sendimgArr forKey:RRDREVWIMAGE_ARR];
        }
        
        [dic setValue:NCS([[DataManager sharedManager] customerNo]) forKey:[NSString stringWithFormat:@"%@.appCustNo", PRDREVW]];

        //20170907 배포 상품평 파라메터 추가
        [dic setValue:NCS(USERAGENTCUSTOMVERSION) forKey:[NSString stringWithFormat:@"%@.appVersion", PRDREVW]];
        [dic setValue:NCS(USERAGENTCODE) forKey:[NSString stringWithFormat:@"%@.appCode", PRDREVW]];
        [dic setValue:NCS(USERAGENTAPPGB) forKey:[NSString stringWithFormat:@"%@.appGB", PRDREVW]];

        
        NSLog(@"최종딕 %@", dic);
        [ge sendDataDic:dic];
        // 2013 12 27 Youngmin Jin send Data Create - End
    }
    
    if(btn.tag == 2) {
        NSString *str1 = [self.goodsInfoDict valueForKey:@"reviewContents"];
        str1 = [str1 stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        [self.goodsInfoDict setValue:str1 forKey:@"reviewContents"];
        NSLog(@"reviewContents = %@",str1);
        [descTextView resignFirstResponder];
        if(self.bImgSend == 1) {
            [self.goodsInfoDict setValue:@"image.png" forKey:@"hidden_name_0"];
        }
        GoodsInfoRequest *ge = [[GoodsInfoRequest alloc]init];
        ge.delegate = self;
        NSLog(@" %@, %@, %@, %@",  [NSString stringWithFormat:@"%.00f",rating1.rating],  [NSString stringWithFormat:@"%.00f",rating2.rating],  [NSString stringWithFormat:@"%.00f",rating3.rating],  [NSString stringWithFormat:@"%.00f",rating4.rating]);
        [self.goodsInfoDict setValue:[NSString stringWithFormat:@"%.00f",rating1.rating] forKey:@"ratingScore1"];
        [self.goodsInfoDict setValue:[NSString stringWithFormat:@"%.00f",rating2.rating] forKey:@"ratingScore2"];
        [self.goodsInfoDict setValue:[NSString stringWithFormat:@"%.00f",rating3.rating] forKey:@"ratingScore3"];
        [self.goodsInfoDict setValue:[NSString stringWithFormat:@"%.00f",rating4.rating] forKey:@"ratingScore4"];
        [self.goodsInfoDict setValue:NCS([[DataManager sharedManager] customerNo]) forKey:[NSString stringWithFormat:@"%@.appCustNo", PRDREVW]];
        //20170907 배포 상품평 파라메터 추가
        [self.goodsInfoDict setValue:NCS(USERAGENTCUSTOMVERSION) forKey:[NSString stringWithFormat:@"%@.appVersion", PRDREVW]];
        [self.goodsInfoDict setValue:NCS(USERAGENTCODE) forKey:[NSString stringWithFormat:@"%@.appCode", PRDREVW]];
        [self.goodsInfoDict setValue:NCS(USERAGENTAPPGB) forKey:[NSString stringWithFormat:@"%@.appGB", PRDREVW]];
        [ge sendDataDic:self.goodsInfoDict];
    }
    if(btn.tag == 3) {//설명서
        infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, APPFULLWIDTH, 365)];
        [self.view addSubview:infoView];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"popup_review" ofType:@"png"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
        [infoView addSubview:imageView];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(14, 22, 30, 30)];
        [btn addTarget:self action:@selector(infoClose:) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:btn];
    }
}

- (void)infoClose:(UIButton *)btn {
    [infoView removeFromSuperview];
    NSLog(@"close");
}

//등록 버튼
- (void)registerGoodsEstimatiionUI {
    
    [btnCancel.layer setMasksToBounds:NO];
    btnCancel.layer.shadowOffset = CGSizeMake(0, 0);
    btnCancel.layer.shadowRadius = 0.0;
    btnCancel.layer.borderColor = [Mocha_Util getColor:@"C9C9C9"].CGColor;
    btnCancel.layer.borderWidth = 1;
    [btnCancel setTitle:GSSLocalizedString(@"review_cancel") forState:UIControlStateNormal];
    NSString* reviewid = [[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:PRDREVWID];
    if(![reviewid isKindOfClass:[NSNull class]] || reviewid == nil) {
        [btn_write setTitle:GSSLocalizedString(@"review_update") forState:UIControlStateNormal];
    }
    else {
        [btn_write setTitle:GSSLocalizedString(@"review_save") forState:UIControlStateNormal];
    }
    
    wguide_txt.contentMode = UIViewContentModeCenter;
    wguide_bg.frame = CGRectMake(0, 0, APPFULLWIDTH, 44);
    int version =  [[UIDevice currentDevice] systemVersion].intValue;
    if(version<6) {
        [wguide_bg setImage:[[UIImage imageNamed:@"bg_rewardsguide"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f]];
    }
    else {
        [wguide_bg setImage:[[UIImage imageNamed:@"bg_rewardsguide"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch]];
    }
    reward_guidetxt.text = GSSLocalizedString(@"review_rewards");
}



//결과넘어옴
- (BOOL)contain:(NSString*)string constring:(NSString *)containStr {
    NSLog(@"---------");
    NSString *str = string;
    NSRange range = [str rangeOfString:containStr];
    if(range.location == NSNotFound) {//없음
        return NO;
    }
    else {
        return YES;
    }
}


//상품평 데이터 넘기고 받을 결과
- (void)doneRequest:(NSString *)status {
    NSLog(@"status = %@",status);
    // nami0342 - JSON
    NSDictionary *result = [status JSONtoValue];
    // nami0342 - 비 정상적인 Json 데이터가 내려올 경우 처리
    if(result == nil) {
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"review_failed_savenmodify") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 999;
        [ApplicationDelegate.window addSubview:lalert];
        return;
    }
    
    NSLog(@"status = %@",[result objectForKey:@"succs"]);
    
    // 20140220 Youngmin Jin -Start
    // 로직변경
    // rtnUrl 있는 경우 / 있지만 내용이 없는 경우 조건 추가
    if ([[result valueForKey:@"rtnUrl"] isKindOfClass:[NSNull class]] == NO && [result objectForKey:@"rtnUrl"] != nil) {
        NSString* reviewid = [[[self.goodsInfoDict valueForKey:CONTENT] valueForKey:HIDDENDATA] valueForKey:PRDREVWID];
        
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:([reviewid isKindOfClass:[NSNull class]]) ? GSSLocalizedString(@"review_success_save"): GSSLocalizedString(@"review_success_modify") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 12;
        
        [ApplicationDelegate.window addSubview:lalert];
    }
    else {
        if ([[[result valueForKey:@"webError"] valueForKey:@"errorMessage"] isKindOfClass:[NSNull class]] == NO && [[[result valueForKey:@"webError"] valueForKey:@"errorMessage"] length] > 0) {
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:[[result valueForKey:@"webError"] valueForKey:@"errorMessage"] maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 999;
            [ApplicationDelegate.window addSubview:lalert];
        }
        else {
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"review_failed_savenmodify")  maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 999;
            [ApplicationDelegate.window addSubview:lalert];
        }
    }
    
}



#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 12) {
        
        [self.target performSelector:@selector(webViewReload)];
        [self.navigationController popViewControllerMoveInFromTop];
        //탭바1
        [ApplicationDelegate tabbarHidden:NO animated:YES];
        
        
    }else if(alert.tag == 379) {
        //일반 알럿
        
    }
    else if(alert.tag == 380) {
        
        switch (index) {
            case 1:
                NSLog(@"설정");
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            default:
                break;
        }
        
    }
    else if(alert.tag == 444) {
        //사진 삭제alert Y or N
        
        if(index==1){
            
            [self docFileDelete];
            
            for(UIView *v in view_g4.subviews)
            {
                if((v.tag==40) ||(v.tag==2))
                    [v removeFromSuperview];
                
            }
            self.bImgSend = 0;
            [self pictureViewUI];
        }
        
        
    }
    else if(alert.tag == 11) {
        // 신규 작성 및 수정 성공 후 return URL 로 이
        // 20140210 Youngmin Jin -Start
        // /knownew/estimate/estimateList.gs?prdid=11631183
        [self goReturnURL:goReturnURL];
        // 20140210 Youngmin Jin -End
    }
    else {
        [self GoBack];
    }
    
    
}


#pragma mark - WSAssetPickerControllerDelegate Methods


- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    
    [ApplicationDelegate.gactivityIndicator startAnimating];
    
    
    if([[DataManager sharedManager].uploadfiletypestr isEqualToString:@"video"]){
        
        
        [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            
            if (assets.count < 1) return;
            
            
            for (ALAsset *asset in assets) {
                
                NSLog(@"에셋url:  %@",  [[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString] );
                
                
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *buffer = (Byte*)malloc( (unsigned long)rep.size  );
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length: (unsigned long)rep.size error:nil];
                NSData *videofile = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                
                
                //videofile 10메가 체크 todo
                //#define PHOTOUPLOADBYTELIMIT 10240000 //사진첨부 제한 크기 byte
                //#define PHOTOSIZEWIDTHLIMIT 600 //가로기준 사이즈 강제 조절크기
                
                NSLog(@"비디오 byte사이즈: %ld byte ",(unsigned long)[videofile length]);
                
                
                if([videofile length] > VIDEOUPLOADBYTELIMIT) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [ApplicationDelegate.gactivityIndicator stopAnimating];
                        
                    });
                    Mocha_Alert *alt = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:GSSLocalizedString(@"assetpicker_video_size_over"),VIDEOUPLOADBYTELIMIT/(1024*1024) ] maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:nil buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                    [ApplicationDelegate.window addSubview:alt];
                    return;
                }
                
                
                
                
                NSString *tmpVideoPath = [NSString stringWithFormat:@"%@/iOSmedia.mp4",DOCS_DIR];
                
                
                AVAsset *avAsset = [AVAsset assetWithURL:[[asset defaultRepresentation] url]];
                
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                BOOL dbexits = [fileManager fileExistsAtPath:tmpVideoPath];
                
                if (dbexits) //존재하면 삭제
                {
                    [fileManager removeItemAtPath:tmpVideoPath error:NULL];
                    NSLog(@"delete tmp mp4 file complete!!!!!!!!");
                }
                
                
                
                AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
                
                exportSession.outputURL = [NSURL fileURLWithPath:tmpVideoPath];
                
                exportSession.outputFileType = AVFileTypeMPEG4;
                
                CMTime start = CMTimeMakeWithSeconds(0.0, 600);
                
                CMTime duration = avAsset.duration;
                
                CMTimeRange range = CMTimeRangeMake(start, duration);
                
                exportSession.timeRange = range;
                
                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                    
                    switch ([exportSession status]) {
                            
                        case AVAssetExportSessionStatusFailed:
                            NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                            
                            break;
                            
                        case AVAssetExportSessionStatusCancelled:
                            
                            NSLog(@"Export canceled");
                            
                            break;
                            
                        default:
                        {
                            
                            if([self uploadAttachVideo:[NSData dataWithContentsOfFile:tmpVideoPath]] ==YES){
                                
                                dispatch_async(dispatch_get_main_queue(),^{
                                    [ApplicationDelegate.gactivityIndicator stopAnimating];
                                    
                                });
                                

                                
                                
                                
                            }else {

                                dispatch_async(dispatch_get_main_queue(),^{
                                    [ApplicationDelegate.gactivityIndicator stopAnimating];
                                    
                                });


                                
                            }
                            
                            
                        }
                            
                            break;
                            
                    }
                }];
                
                
                
            }
            
            
            
            
        }];
        
        
        
        
    }
    
    
    if([[DataManager sharedManager].uploadfiletypestr isEqualToString:@"image"]){
        
        
        [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            
            if (assets.count < 1) return;
            
            int intvi=0;
            for (ALAsset *asset in assets) {
                
                UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
                
                
                
                CGRect imageViewFrame = CGRectZero;
                imageViewFrame.origin.y = 0;
                
                float widthLimit = 600;
                NSLog(@"에셋url:%@ ===  %@",    [[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString] , [DataManager sharedManager].uploadfiletypestr );
                NSLog(@"widthLimit = %f",widthLimit);
                
                
                
                float actualHeight = image.size.height;
                float actualWidth = image.size.width;
                
                
                UIImage *img;
                if (image.size.width > widthLimit) {
                    
                    float imgRatio = widthLimit / actualWidth;
                    actualHeight = imgRatio * actualHeight;
                    actualWidth = widthLimit;
                    NSLog(@"궁금값 %f, %f ", imgRatio, actualHeight);
                    
                    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
                    UIGraphicsBeginImageContext(rect.size);
                    [image drawInRect:rect];
                    img = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }else{
                    img = image;
                }
                
                NSLog(@"image SIze = %@  === upurl : %@",NSStringFromCGSize(img.size),  [DataManager sharedManager].imguploadTargetUrlstr);
                
                intvi++;
                if(_sendimgArr==nil) {
                    _sendimgArr = [NSMutableArray array];
                }
                
                [_sendimgArr addObject:img];
                
                
                [self pictureViewUI];
            }
        }];
        
    }
    
    self.bImgSend = 1;
    //탭바1
    [ApplicationDelegate tabbarHidden:NO animated:YES];
    
    
    
}


#pragma mark -
#pragma mark cameraload
// 카메라 show
- (void)showCamera:(NSInteger)index
{
    //탭바0
    [ApplicationDelegate tabbarHidden:YES animated:NO];
    
    NSLog(@"camerashow = %ld",(long)index);
    UIImagePickerControllerSourceType sourceType;
    if(index == 0){
        //촬영
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            // do your logic
            NSLog(@"");
            
            sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController* pickerview = [[UIImagePickerController alloc] init];
            pickerview.delegate = self;
            pickerview.sourceType = sourceType;
            //라이브톡용 이미지 업로드 규격적용
            if([[DataManager sharedManager].caller isEqualToString:@"livetalk"])
            {
                pickerview.allowsEditing = NO;
            }
            else
            {
                pickerview.allowsEditing = YES;
            }
            [ApplicationDelegate.window.rootViewController presentViewController:pickerview animated:YES completion:nil];
            
            
        } else if(authStatus == AVAuthorizationStatusDenied){
            // denied
            NSLog(@"");
            
            Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_require_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"alert_authorization_no"),GSSLocalizedString(@"alert_authorization_yes"), nil]];
            lalert.tag = 380;
            [ApplicationDelegate.window addSubview:lalert];
            
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // restricted, normally won't happen
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){
                    NSLog(@"Granted access to %@", mediaType);
                    dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController* pickerview = [[UIImagePickerController alloc] init];
                    pickerview.delegate = self;
                    pickerview.sourceType = UIImagePickerControllerSourceTypeCamera;
                    //라이브톡용 이미지 업로드 규격적용
                    if([[DataManager sharedManager].caller isEqualToString:@"livetalk"])
                    {
                        pickerview.allowsEditing = NO;
                    }
                    else
                    {
                        pickerview.allowsEditing = YES;
                    }
                    [ApplicationDelegate.window.rootViewController presentViewController:pickerview animated:YES completion:nil];
                        });
                    
                } else {
                    NSLog(@"Not granted access to %@", mediaType);
                    dispatch_async(dispatch_get_main_queue(), ^{
                    Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_require_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"alert_authorization_no"),GSSLocalizedString(@"alert_authorization_yes"), nil]];
                    lalert.tag = 380;
                    [ApplicationDelegate.window addSubview:lalert];
                        });
                }
            }];
        } else {
            // impossible, unknown authorization status
        }
        
        
        
        
        
    }else {
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        
        if (status == ALAuthorizationStatusDenied){
            
            Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_require_usephoto") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"alert_authorization_no"),GSSLocalizedString(@"alert_authorization_yes"), nil]];
            lalert.tag = 380;
            [ApplicationDelegate.window addSubview:lalert];
            
            return;
            
        }
        
        
        if(index == 1){
            //앨범에서 사진만 가져오기
            
            
            pickerController = [[WSAssetPickerController alloc] initWithDelegate:self];
            
            pickerController.navigationBar.barStyle = UIBarStyleDefault;
            pickerController.navigationBar.translucent = NO;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
                pickerController.navigationBar.barTintColor = [UIColor whiteColor];
                pickerController.navigationBar.tintColor = [UIColor blackColor];
            }else {
                [pickerController.navigationBar setTintColor:[UIColor whiteColor]];
                
            }
            
            [ApplicationDelegate.window.rootViewController presentViewController:pickerController animated:YES completion:nil];
            
        }else if(index == 2){
            //앨범에서 비디오만 가져오기
            
            
            pickerController = [[WSAssetPickerController alloc] initWithDelegate:self];
            
            pickerController.navigationBar.barStyle = UIBarStyleDefault;
            pickerController.navigationBar.translucent = NO;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
                pickerController.navigationBar.barTintColor = [UIColor whiteColor];
                pickerController.navigationBar.tintColor = [UIColor blackColor];
            }else {
                [pickerController.navigationBar setTintColor:[UIColor whiteColor]];
                
            }
            
            [ApplicationDelegate.window.rootViewController presentViewController:pickerController animated:YES completion:nil];
            
        }
        
    }
    
}


//camera close.이미지를 선책하고 나올때 불려진다.
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    
    // 편집한 사진을 취득
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ( !image ) {
        // 편집한 사진이 없으면 오리지널 사진을 취득한다
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"");
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [ApplicationDelegate.gactivityIndicator startAnimating];
        
    });
    
    
    NSLog(@"cameraImage w = %f,h=%f",image.size.width,image.size.height);
    
    [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [ApplicationDelegate tabbarHidden:NO animated:YES];
        
        
        CGRect imageViewFrame = CGRectZero;
        imageViewFrame.origin.y = 0;
        
        float widthLimit = 600;
        
        NSLog(@"widthLimit = %f",widthLimit);
        
        
        
        float actualHeight = image.size.height;
        float actualWidth = image.size.width;
        
        
        UIImage *img;
        if (image.size.width > widthLimit) {
            
            float imgRatio = widthLimit / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = widthLimit;
            NSLog(@"궁금값 %f, %f ", imgRatio, actualHeight);
            
            CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
            UIGraphicsBeginImageContext(rect.size);
            [image drawInRect:rect];
            img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }else{
            img = image;
        }
        
        NSLog(@"image SIze = %@  === upurl : %@",NSStringFromCGSize(img.size),  [DataManager sharedManager].imguploadTargetUrlstr);
        
        
        if(_sendimgArr==nil) {
            _sendimgArr = [NSMutableArray array];
        }
        
        [_sendimgArr addObject:img];
        
        
        [self pictureViewUI];
        
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    //탭바1
    [ApplicationDelegate tabbarHidden:NO animated:YES];
    NSLog(@"camera cancel");
    
    // 취소되었을 때에 실시해야 할 처리를 하고 그 후 사진앨범을 닫는다
    [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if ( error ) {
        // error가 nil이 아닌 경우는 보존 실패
    } else {
        // nil이라면 보존 성공
        
    }
}





//사진찍기 액션시트
- (IBAction)pictureBtnAction:(id)sender
{
    UIButton *cbtn = (UIButton*)sender;
    
    
    if(cbtn.tag == 1) {
        
        if([_sendimgArr count] >= RESTRICT_ESTPHOTOCOUNT){
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:GSSLocalizedString(@"review_attach_image_limit"),RESTRICTPHOTOCOUNT ]   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 444;
            [ApplicationDelegate.window addSubview:lalert];
            
            
            return;
        }
        
        
        [descTextView resignFirstResponder];
        //액션시트로 이미지 가져오기 선택(카메라 찍기, 앨범에서 가져오기)
        UIActionSheet *sheet = [[UIActionSheet alloc]init];
        sheet.delegate = self;
        sheet.tag = 333;
        [sheet addButtonWithTitle:GSSLocalizedString(@"assetpicker_actsheet_takepic")];
        [sheet addButtonWithTitle:GSSLocalizedString(@"assetpicker_actsheet_album")];
        [sheet addButtonWithTitle:GSSLocalizedString(@"common_txt_alert_btn_cancel")];
        sheet.cancelButtonIndex = 2;
        
        [sheet showInView:self.view];
        self.bImgSend = 0;
    } else {
        //삭제
        //10001
        
        int btninitialint=10000;
        NSUInteger tgindex = (NSUInteger)cbtn.tag - btninitialint;
        [_sendimgArr removeObjectAtIndex:tgindex];
        [self pictureViewUI];
        
               
        
        
        
    }
   
}


//- (void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex  //iPad에서 새창이 안올라오는 버그때문에 아래로 변경
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    UIActionSheet *action = (UIActionSheet *)actionSheet;
    if(action.tag == 333)
    {
        if (buttonIndex == action.cancelButtonIndex )
        {
            NSLog(@"cancel");
        }
        else if(buttonIndex == 0)
        {
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
                
                Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_cant_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                lalert.tag = 379;
                [ApplicationDelegate.window addSubview:lalert];
                
                return;
            }else {
                
                [self showCamera:0];
                [DataManager sharedManager].cameraFlag = YES;
            }
        }
        else
        {
            
            [DataManager sharedManager].imguploadTargetUrlstr = @"";
            [DataManager sharedManager].imguploadTargetJsFuncstr = @"";
            [DataManager sharedManager].uploadfiletypestr = @"image";
            
            
            
            
            [DataManager sharedManager].photoLimit = RESTRICT_ESTPHOTOCOUNT -[_sendimgArr count] ;
            
            [self showCamera:1];
            [DataManager sharedManager].cameraFlag = YES;
        }
    }
    
}




-(BOOL)uploadAttachImage:(UIImage *)image withPhNum:(NSUInteger)tpnum{
    
    
    
    //#define PHOTOUPLOADBYTELIMIT 5120000 //사진첨부 제한 크기 byte
    //#define PHOTOSIZEWIDTHLIMIT 600 //가로기준 사이즈 강제 조절크기
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75f);
    NSLog(@"이미지 byte사이즈: %ld byte ",(unsigned long)[imageData length]);
    
    
    if([imageData length] > PHOTOUPLOADBYTELIMIT) {
        Mocha_Alert *alt = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"assetpicker_photo_size_over") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:nil buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        [ApplicationDelegate.window addSubview:alt];
        return NO;
    }
    
    
    
    
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    
    
    
    NSLog(@"uuuuurrrrr str %@", [[DataManager sharedManager].imguploadTargetUrlstr urlDecodedString]);
    NSURL *url = [NSURL URLWithString:[[DataManager sharedManager].imguploadTargetUrlstr urlDecodedString]];
    //NSURL *url = [NSURL URLWithString:@"http://10.52.38.13/cafe/common/doFileUploadApp.gs"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
    [post_dict setObject:@"iOSimage.jpg" forKey:@"fileName"];
    [post_dict setObject:imageData forKey:@"file"];
    
    NSLog(@"   %%%%%%%% = %@",  post_dict);
    
    // Create the post data from the post dictionary
    NSData *postData = [ApplicationDelegate  generateFormDataFromPostDictionary:post_dict];
    
    
    [urlRequest setHTTPBody: postData];
    
    // Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
    NSLog(@"Contacting Server....");
    NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    
    
    
    if (!result)
    {
        return NO;
    }else {
        
        // nami0342 - JSON
        NSDictionary *resultj = [result JSONtoValue];
        
        NSString* drs1 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"result"]];
        NSString* drs2 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"tmpFileName"]];
        NSString* drs3 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"realFileName"]];
        NSString* drs4 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"fileUrl"]];
        NSString* strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\",\"%@\")",[DataManager sharedManager].imguploadTargetJsFuncstr,  drs1, drs2,drs3,drs4    ];
        NSLog(@"%@ === vvvvvvvvv ",     strjs);

        
        NSLog(@"콜제이에스");
        
        
        //webview callJscriptMethod runloop 오류 대응
        CFRunLoopRunInMode((CFStringRef)NSDefaultRunLoopMode, 0.25, NO);
        [self performSelectorOnMainThread:@selector(callJscriptMethod:) withObject:strjs waitUntilDone:NO modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
        
        
        if([NCS([resultj objectForKey:@"result"]) isEqualToString:@"success"]){
            return YES;
        }
        
    }
    
    return NO;
    
    
}



-(BOOL)uploadAttachVideo:(NSData *)videodata {
    
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    
    
    
    
    NSLog(@"uuuuurrrrr str %@", [[DataManager sharedManager].imguploadTargetUrlstr urlDecodedString]);
    NSURL *url = [NSURL URLWithString:[[DataManager sharedManager].imguploadTargetUrlstr urlDecodedString]];
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
    [post_dict setObject:@"iOSmedia.mp4" forKey:@"fileName"];
    [post_dict setObject:videodata forKey:@"file"];
    
    NSLog(@"   %%%%%%%% = %@",  post_dict);
    
    // Create the post data from the post dictionary
    NSData *postData = [ApplicationDelegate  generateFormVideoDataFromPostDictionary:post_dict];
    
    
    [urlRequest setHTTPBody: postData];
    
    // Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
    NSLog(@"Contacting Server....");
    NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    
    
    
    if (!result)
    {
        return NO;
    }else {
        
        // nami0342 - JSON
        NSDictionary *resultj = [result JSONtoValue];
        
        NSString* drs1 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"result"]];
        NSString* drs2 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"tmpFileName"]];
        NSString* drs3 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"realFileName"]];
        NSString* drs4 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"fileUrl"]];
        NSString* strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\",\"%@\")",[DataManager sharedManager].imguploadTargetJsFuncstr,  drs1, drs2,drs3,drs4    ];
        NSLog(@"%@ === vvvvvvvvv ",     strjs);
        
        [self performSelectorOnMainThread:@selector(callJscriptMethod:) withObject:strjs waitUntilDone:NO];
        
        if([NCS([resultj objectForKey:@"result"]) isEqualToString:@"success"]){
            return YES;
        }
        
    }
    
    return NO;
    
    
}


@end
