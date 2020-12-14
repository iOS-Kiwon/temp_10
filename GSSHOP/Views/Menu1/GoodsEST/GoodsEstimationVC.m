//
//  GoodsEstimationVC.m
//  GSSHOP
//
//  Created by uinnetworks on 11. 7. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoodsEstimationVC.h"
#import "AppDelegate.h"
#import "DrawView.h"
#import "DataManager.h"
#import "GoodsInfoRequest.h"
#import "GoodsInfo.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FileUtil.h"
#import "Downloader.h"
@implementation GoodsEstimationVC
#define _RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//@synthesize goods;
@synthesize prdID;
@synthesize hiddenFrame;
@synthesize visibleFrame;
@synthesize btnTag;
@synthesize labelTag;
@synthesize bImgSend;
@synthesize goodsInfoDict;
@synthesize target;
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"");
    }
    return self;
} 
- (id)initWithPrdid:(id)sender prdids:(NSString *)prdid
{
    self = [super init];
    if(self)
    {
        target = sender;
        
        NSLog(@"prdid = %@",prdid);
        self.prdID = prdid;
        posGap = 0.0f;
        
        //상품평 데이터 받음 
        //GoodsInfoRequest *ge = [[[GoodsInfoRequest alloc]init]autorelease];
        //self.goods = [[ge recvData:self.prdID]retain];
        
        GoodsInfoRequest *ge = [[[GoodsInfoRequest alloc]init]autorelease];
        self.goodsInfoDict = [ge recvDataDic:self.prdID];
        NSLog(@"goodsInfoDict = %@",self.goodsInfoDict);
        
        if(self.goodsInfoDict == nil)
        {
            
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"데이터를 받아 올수 없습니다." maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
            lalert.tag = 12;
            [ApplicationDelegate.window addSubview:lalert];
            [lalert release];
            
            
             
        }
        NSLog(@"errorcode = %@",[self.goodsInfoDict valueForKey:@"errorCode"]);
        if([[self.goodsInfoDict valueForKey:@"errorCode"] isEqualToString:@""] || [[self.goodsInfoDict valueForKey:@"errorCode"] isEqualToString:@"00"])
        {
            
            
            
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:[self.goodsInfoDict valueForKey:@"errorMsg"] maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
            lalert.tag = 12;
            [ApplicationDelegate.window addSubview:lalert];
            [lalert release];
             
        }
        
        NSInteger messageid = [[self.goodsInfoDict valueForKey:@"messageId"] intValue];
        [self loadingDataSet];
        
        starNum[0] = 4;starNum[1] = 4;starNum[2] = 4;starNum[3] = 4;
        //self.bImgSend = 0;
        
        //네비게이션바 
        CGRect frame = CGRectMake(0, 0, 320, 45);
        UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [Mocha_Util getColor:@"454545"];
        if(messageid >0)
        {
            label.text = @"상품평수정";//상품평수정 masterId로 구분 
            NSLog(@"hidden_path_0 = %@", [self.goodsInfoDict valueForKey:@"hidden_path_0"]);
            if([[self.goodsInfoDict valueForKey:@"hidden_path_0"] isEqualToString:@""])
            {
                self.bImgSend = 0;
            }
            else
            {
                [self iconFileDownload:[self.goodsInfoDict valueForKey:@"hidden_path_0"]];
                self.bImgSend = 1;
                posGap = 57.0f;
                
            }
            
        }
        else{
            self.bImgSend = 0;
            label.text = @"상품평쓰기";//상품평수정 masterId로 구분 
        }
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"bg_title" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        UIImageView *naviBarImageView = [[UIImageView alloc] initWithImage:image];
        naviBarImageView.frame = CGRectMake(0, 0,  image.size.width, image.size.height);
        [self.view addSubview:naviBarImageView];
        [naviBarImageView release];
        
        [self.view addSubview:label];
        
        //back button
        UIButton *backBtn = [[UIButton alloc]init];
        NSString *path2 = [[NSBundle mainBundle]pathForResource:@"btn_back" ofType:@"png"];
        [backBtn setImage:[UIImage imageWithContentsOfFile:path2] forState:UIControlStateNormal];
        [backBtn setFrame:CGRectMake(10,7, 31, 28)];
        [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        [backBtn release];
    }
    return self;
}
- (void)loadingDataSet
{
    NSLog(@"self.goods.evalValue1 = %@",[self.goodsInfoDict valueForKey:@"evalValue1"]);
    if([[self.goodsInfoDict valueForKey:@"evalValue1"] isEqualToString:@""])
        [self.goodsInfoDict setValue:@"5" forKey:@"evalValue1"];    
    if([[self.goodsInfoDict valueForKey:@"evalValue2"] isEqualToString:@""])
        [self.goodsInfoDict setValue:@"5" forKey:@"evalValue2"];
    if([[self.goodsInfoDict valueForKey:@"evalValue3"] isEqualToString:@""])
        [self.goodsInfoDict setValue:@"5" forKey:@"evalValue3"];
    if([[self.goodsInfoDict valueForKey:@"evalValue4"] isEqualToString:@""])
        [self.goodsInfoDict setValue:@"5" forKey:@"evalValue4"];
}
- (NSString *) applicationCacheDirectory 
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
//도큐맨트에 파일 삭제하기/ 존재여부 확인후 삭제
- (BOOL)docFileDelete
{
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
- (void)GoBack
{
    NSLog(@"GoodsExtimate goBack");
    [self docFileDelete];
    [DataManager sharedManager].cameraFlag = NO;
     [target performSelector:@selector(webViewReload)];
    [self dismissModalViewControllerAnimated:YES];
    //탭바1
     [ApplicationDelegate tabbarHidden:[NSNumber numberWithInt:1]];
    //도큐멘트에 있는 찍은 사진을 삭제하고 넘어간다.
}
- (void)dealloc
{
    NSLog(@"");
    self.goodsInfoDict = nil;
    [infoView release];
    self.prdID = nil;
    [titleText release];
    [descTextView release];
    //self.goods  = nil;
    [aniView release];
    [scrollView release];
    
    [super dealloc];
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
           aliment:(UITextAlignment)aliment line:(NSInteger)num tags:(NSInteger) labelTags
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = name;
    [label setBackgroundColor:[UIColor clearColor]];
    label.textColor = color;
    label.tag = labelTags;
    label.textAlignment = aliment;
    //label.shadowColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:size];
    label.numberOfLines = num;
    label.adjustsFontSizeToFitWidth = YES;
    //label.center = CGPointMake(frame.origin.x +(frame.size.width/2), frame.origin.y +(frame.size.height/2));
    [mainview addSubview:label];
    [label release];
}
//image를 배경으로 한 뷰 생성
- (void)imageViewCreate:(NSString *)name frame:(CGRect)rect views:(UIView *)mainview
{
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"png"];
    UIImage *bg = [UIImage imageWithContentsOfFile:path];
    UIImageView *view = [[UIImageView alloc]initWithImage:bg];
    view.frame = rect;
    [mainview addSubview:view];
    //[bg release];
    [view release];
}
- (void)imageViewCreateDoc:(NSString *)name frame:(CGRect)rect views:(UIView *)mainview
{
    UIImage *bg = [[UIImage alloc]initWithContentsOfFile:name];
    UIImageView *view = [[UIImageView alloc]initWithImage:bg];
    view.frame = rect;
    [mainview addSubview:view];
    [bg release];
    [view release];
}
//from mainbundle
- (void)imageButtonCreate:(NSString *)name frame:(CGRect)rect views:(UIView *)mainview action:(SEL)action tag:(NSInteger)tag
{
    UIButton* btn = [[UIButton alloc] initWithFrame:rect];
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"png"];
    UIImage *i = [UIImage imageWithContentsOfFile:path];
    [btn setBackgroundImage:i forState:UIControlStateNormal];
    //[btn setBackgroundImage:i forState:UIControlStateHighlighted];
    btn.tag = tag;
    [mainview addSubview: btn];
    [btn addTarget:self action:action forControlEvents: UIControlEventTouchUpInside];
    [btn release]; 
}
- (void)imageButtonCreate1:(NSString *)name click:(NSString *)nameclick frame:(CGRect)rect views:(UIView *)mainview action:(SEL)action tag:(NSInteger)tag
{
    UIButton* btn = [[UIButton alloc] initWithFrame:rect];
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"png"];
    NSString *path1 = [[NSBundle mainBundle]pathForResource:nameclick ofType:@"png"];
    UIImage *i = [UIImage imageWithContentsOfFile:path];
    UIImage *i1 = [UIImage imageWithContentsOfFile:path1];
    [btn setBackgroundImage:i forState:UIControlStateNormal];
    [btn setBackgroundImage:i1 forState:UIControlStateHighlighted];
    btn.tag = tag;
    [mainview addSubview: btn];
    [btn addTarget:self action:action forControlEvents: UIControlEventTouchUpInside];
    [btn release]; 
}
#pragma mark -
#pragma mark UI
//상품 이름 
- (void)goodsNameUI
{
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    
    NSURL *videoURL = [NSURL URLWithString:[self.goodsInfoDict valueForKey:@"prdImg"]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL];
    webview.tag = 14;
    [webview loadRequest:requestObj];
    [scrollView addSubview:webview];
    [webview release];
    //제품 이름 
    //CGRect rect = CGRectMake(81, 10, 209, 13);
    //[self labelCreate:goods.brandName frame:rect views:scrollView txtSize:12 color:_RGBA(90,91,93,1) aliment:UITextAlignmentLeft line:0 tags:11];
    
    //제품상세이름 
    NSLog(@"prdname = %@", [self.goodsInfoDict valueForKey:@"prdname"]);
    NSLog(@"[goods.prdname length] = %d",[[self.goodsInfoDict valueForKey:@"prdname"] length]*12);
    if(([[self.goodsInfoDict valueForKey:@"prdname"] length]*12) >209)
    {
        CGRect rect1 = CGRectMake(81, 24, 209, 28);
        [self labelCreate:[self.goodsInfoDict valueForKey:@"prdname"] frame:rect1 views:scrollView txtSize:12 color:_RGBA(90,91,93,1) aliment:UITextAlignmentLeft line:2 tags:12];
    }
    else
    {
        CGRect rect1 = CGRectMake(81, 24, 209, 14);
        [self labelCreate:[self.goodsInfoDict valueForKey:@"prdname"] frame:rect1 views:scrollView txtSize:12 color:_RGBA(90,91,93,1) aliment:UITextAlignmentLeft line:0 tags:12];
    }
    
    //구분 라인
    DrawView *drawLine = [[DrawView alloc]initWithFrame:CGRectMake(0, 124-45, 320, 1)];
    [scrollView addSubview:drawLine];
    [drawLine release];
}
//상품 설명 
- (void)explainTextUI
{
    //상품평 설명 텍스트 
    CGRect rect1 = CGRectMake(10, 96, 280, 13);
    [self labelCreate:@"상품평 등록시 e코인 50개 적립해 드립니다." frame:rect1 views:scrollView txtSize:12 color:_RGBA(92,92,92,1) aliment:UITextAlignmentLeft line:0 tags:13];
    //구분라인
    DrawView *drawLine2 = [[DrawView alloc]initWithFrame:CGRectMake(0, 169-45, 320, 1)];
    [scrollView addSubview:drawLine2];
    [drawLine2 release];
}
//등급 주기 
- (void)starDisplayUI
{
    //-------
    CGRect rect1 = CGRectMake(10, 186-45, 280, 13);
    [self labelCreate:[self.goodsInfoDict valueForKey:@"evalName1"] frame:rect1 views:scrollView txtSize:12 color:_RGBA(92,92,92,1) aliment:UITextAlignmentLeft line:0 tags:20];
    [self imageButtonCreate:@"btn_dropdown" frame:CGRectMake(97, 179-45, 136, 26) views:scrollView action:@selector(starAction:) tag:1];
    //-----
    CGRect rect2 = CGRectMake(10, 216-45, 280, 13);
    [self labelCreate:[self.goodsInfoDict valueForKey:@"evalName2"] frame:rect2 views:scrollView txtSize:12 color:_RGBA(92,92,92,1) aliment:UITextAlignmentLeft line:0 tags:21];
    [self imageButtonCreate:@"btn_dropdown" frame:CGRectMake(97, 209-45, 136, 26) views:scrollView action:@selector(starAction:) tag:2];
    //-----
    CGRect rect3 = CGRectMake(10, 246-45, 280, 13);
    [self labelCreate:[self.goodsInfoDict valueForKey:@"evalName3"] frame:rect3 views:scrollView txtSize:12 color:_RGBA(92,92,92,1) aliment:UITextAlignmentLeft line:0 tags:22];
    [self imageButtonCreate:@"btn_dropdown" frame:CGRectMake(97, 239-45, 136, 26) views:scrollView action:@selector(starAction:) tag:3];
    //-----
    CGRect rect4 = CGRectMake(10, 276-45, 280, 13);
    [self labelCreate:[self.goodsInfoDict valueForKey:@"evalName4"] frame:rect4 views:scrollView txtSize:12 color:_RGBA(92,92,92,1) aliment:UITextAlignmentLeft line:0 tags:23];
    [self imageButtonCreate:@"btn_dropdown" frame:CGRectMake(97, 269-45, 136, 26) views:scrollView action:@selector(starAction:) tag:4];
    
    NSLog(@"self.goods.evalName1= %@",[self.goodsInfoDict valueForKey:@"evalName1"]);
    //별 표시
    [self starNumUI];
    //★
    //구분라인
    DrawView *drawLine3 = [[DrawView alloc]initWithFrame:CGRectMake(0, 304-45, 320, 1)];
    [scrollView addSubview:drawLine3];
    [drawLine3 release];
}
//별 표시 
- (void)starNumUI
{
    
    //권한없는 상품평 쓰기 시도시 에러. - shawn
    if([[self.goodsInfoDict valueForKey:@"errorCode"] isEqualToString:@""] || [[self.goodsInfoDict valueForKey:@"errorCode"] isEqualToString:@"00"]){
        return;
    }
        
    NSArray* arr = [NSArray arrayWithObjects:@"★", @"★  ★", @"★  ★  ★", @"★  ★  ★  ★", @"★  ★  ★  ★  ★",nil];
   
    //등급에 값이 있으면 받아와서 표시 한다. 처음 쓰는것이면 그냥 5개로 통일 
    CGRect rect = CGRectMake(109, 140, 100, 14);
    [self labelCreate:[arr objectAtIndex:[[self.goodsInfoDict valueForKey:@"evalValue1"] intValue]-1] frame:rect views:scrollView txtSize:12 color:_RGBA(0,0,0,1) aliment:UITextAlignmentLeft line:0 tags:31];
    
    rect = CGRectMake(109, 170, 100, 14);
    [self labelCreate:[arr objectAtIndex:[[self.goodsInfoDict valueForKey:@"evalValue2"] intValue]-1] frame:rect views:scrollView txtSize:12 color:_RGBA(0,0,0,1) aliment:UITextAlignmentLeft line:0 tags:32];
    
    rect = CGRectMake(109, 200, 100, 14);
    [self labelCreate:[arr objectAtIndex:[[self.goodsInfoDict valueForKey:@"evalValue3"] intValue]-1] frame:rect views:scrollView txtSize:12 color:_RGBA(0,0,0,1) aliment:UITextAlignmentLeft line:0 tags:33];
    
    rect = CGRectMake(109, 230, 100, 14);
    [self labelCreate:[arr objectAtIndex:[[self.goodsInfoDict valueForKey:@"evalValue4"] intValue]-1] frame:rect views:scrollView txtSize:12 color:_RGBA(0,0,0,1) aliment:UITextAlignmentLeft line:0 tags:34];
    
    //[self popPickerView];
}

//pickerview 
- (void)popPickerView
{
    picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
	picker.hidden = YES;
	picker.dataSource = self;
	picker.delegate = self;
	picker.showsSelectionIndicator = YES;
    
	//picker.field = self;
    
    CGRect windowBounds = [self.view bounds];
    CGRect pickerHiddenFrame = windowBounds;
    pickerHiddenFrame.origin.y = pickerHiddenFrame.size.height+216;
    pickerHiddenFrame.size.height = 216;
	
    // calucate our visible rect
    CGRect pickerVisibleFrame = windowBounds;
    pickerVisibleFrame.origin.y = windowBounds.size.height - 216;
    pickerVisibleFrame.size.height = 216;
	
    // tell the picker view the frames.
    self.hiddenFrame = pickerHiddenFrame;
    self.visibleFrame = pickerVisibleFrame;
	
    // set the initial frame so its hidden.
    picker.frame = pickerHiddenFrame;
	
    // add the picker view to our window so its top most like a keyboard.
    [self.view addSubview:picker];
    
}

//pickerview show hide
-(void) toggle 
{
	pickerActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [pickerActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    pickerActionSheet.tag = 11;
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    picker.showsSelectionIndicator = YES;
    picker.dataSource = self;
    picker.delegate = self;
    
    [pickerActionSheet addSubview:picker];
    [picker release];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"완료"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [pickerActionSheet addSubview:closeButton];
    [closeButton release];
    
    [pickerActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [pickerActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    
}
- (void)dismissActionSheet:(id)sender
{
    NSArray* arr = [NSArray arrayWithObjects:@"★", @"★  ★", @"★  ★  ★", @"★  ★  ★  ★", @"★  ★  ★  ★  ★",nil];
    for(UIView *view in scrollView.subviews)
    {
        UILabel *label = (UILabel *)view;
        
        if(label.tag == self.labelTag)
        {
            NSLog(@"labelTag = %d,self.labelTag = %d",label.tag,self.labelTag);
            label.text = [arr objectAtIndex:starNum[self.btnTag-1]];
        }
        
        if(self.btnTag == 1) 
            [self.goodsInfoDict setValue:[NSString stringWithFormat:@"%d",starNum[0]+1] forKey:@"evalValue1"];
        if(self.btnTag == 2) 
            [self.goodsInfoDict setValue:[NSString stringWithFormat:@"%d",starNum[1]+1] forKey:@"evalValue2"];
        if(self.btnTag == 3)
            [self.goodsInfoDict setValue:[NSString stringWithFormat:@"%d",starNum[2]+1] forKey:@"evalValue3"];
        if(self.btnTag == 4) 
            [self.goodsInfoDict setValue:[NSString stringWithFormat:@"%d",starNum[3]+1] forKey:@"evalValue4"];
        
    }
    
    [pickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSLog(@"");
}
//pickerView Delgate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray* arr = [NSArray arrayWithObjects:@"★★★★★", @"★★★★", @"★★★", @"★★", @"★",nil];
    
    return  [NSString stringWithString:[arr objectAtIndex:row]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //선택한 열의 데이터를 적용시킨다. 
    NSLog(@"row = %d",row);
    starNum[self.btnTag-1] = 4-row;
}
//별 갯수
- (NSInteger)labelTextNum:(NSInteger)tag
{
    for(UIView *view in scrollView.subviews)
    {
        UILabel *label = (UILabel *)view;
        if(label.tag == tag)
        {
            //문자열 공백 제거 후 문자열 갯수를 받아와서 피커에 적용
            NSString *str = [label.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            return [str length]-1;
        }
    }
    return 0;
}
- (void)starAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        self.btnTag = 1;
        self.labelTag = 31;
        NSInteger num = 4- [self labelTextNum:self.labelTag];
        NSLog(@"num = %d",num);
        [self toggle];
        [picker selectRow:num inComponent:0 animated:YES];
    }
    if(btn.tag == 2)
    {
        self.btnTag = 2;
        self.labelTag = 32;
        NSInteger num = 4- [self labelTextNum:self.labelTag];
        NSLog(@"num = %d",num);
        [self toggle];
        [picker selectRow:num inComponent:0 animated:YES];
    }
    if(btn.tag == 3)
    {
        self.btnTag = 3;
        self.labelTag = 33;
        NSInteger num = 4- [self labelTextNum:self.labelTag];
        NSLog(@"num = %d",num);
        [self toggle];
        [picker selectRow:num inComponent:0 animated:YES];
    }
    if(btn.tag == 4)
    {
        self.btnTag = 4;
        self.labelTag = 34;
        NSInteger num = 4- [self labelTextNum:self.labelTag];
        NSLog(@"num = %d",num);
        [self toggle];
        [picker selectRow:num inComponent:0 animated:YES];
    }
}
//----------------------------------------------------------------------------------------------------
//사진찍기 버튼  
- (void)upLoadPictureUI
{
    CGRect rect1 = CGRectMake(30, 312-45, 260, 30);
    //ActionSheet display
    [self imageButtonCreate:@"btn_photo_up" frame:rect1 views:scrollView action:@selector(pictureBtnAction) tag:1];
}
//수정될 이미지 다운로드 
- (void)iconFileDownload:(NSString *)imageUrl
{
   
	//self.documentsDirectory = [home stringByAppendingPathComponent:@"Documents"];
    
    
    Downloader *downLoader = [[[Downloader alloc]init]autorelease];
    //downLoader.delegate = self;                
    NSString *str = [NSString stringWithFormat:@"%@/%@",DOCS_DIR,@"image.jpg"];
    [downLoader download:imageUrl toLocal:str];//수정할때 이미지 다운해서 doc에 넣고 보여준다.
    
}
//올릴 사진 보여주기, 사진이 없으면 안보여진다. 
- (void)pictureViewUI
{
    NSString *path=nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDirectory = [self applicationCacheDirectory];
    NSString *writableDBPath = [cacheDirectory stringByAppendingPathComponent:@"image.jpg"];
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    if(dbexits)//파일 존재하면 
    {
        NSDictionary* attr;
        if ( (attr = [fileManager attributesOfItemAtPath:writableDBPath error:nil]) == nil)
            NSLog(@"파일의 속성을 가지고 올 수 없음");
        
        //NSLog(@"File size : %i", [[attr objectForKey:NSFileSize] intValue]);
        NSString * filesize = [NSString stringWithFormat:@"(%i byte)", [[attr objectForKey:NSFileSize] intValue]];
        
        for(UIImageView *iview in scrollView.subviews)
        {
            UIImageView *v = (UIImageView *)iview;
            if(v.tag == 40)
                [v removeFromSuperview];
            
        }
        for(UILabel *iview in scrollView.subviews)
        {
            UILabel *v = (UILabel *)iview;
            if(v.tag == 42)
                [v removeFromSuperview];
            
        }
        path = [NSString stringWithFormat:@"%@/image.jpg",DOCS_DIR];
        UIImage *img1 = [[UIImage alloc]initWithContentsOfFile:path];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img1];
        [imgView setFrame:CGRectMake(30, 349-45, 75, 50)];
        imgView.tag = 40;
        [scrollView addSubview:imgView];
        [scrollView setNeedsLayout];
        
        CGRect rect4 = CGRectMake(116, 362-45, 174, 12);
        [self labelCreate:@"image.jpg" frame:rect4 views:scrollView txtSize:11 color:_RGBA(153,153,153,1) aliment:UITextAlignmentLeft line:0 tags:41];
        CGRect rect5 = CGRectMake(116, 374-45, 174, 23);
        
        [self labelCreate:filesize frame:rect5 views:scrollView txtSize:11 color:_RGBA(153,153,153,1) aliment:UITextAlignmentLeft line:0 tags:42];
        
        [img1 release];
        [imgView release];
        
    }
}
//서버에 업로드할 이미지를 썸네일로 보여줌 
- (void)upLoadImageShow
{
    //posGap = 57.0f;
    //if(posGap >0.0f) //뷰에니메이션. 등록할 이미지가 보이면 밑에 컨트롤이 밀려난다. 
    {
        //[self pictureViewUI];
        scrollView.contentSize = CGSizeMake(320.0f,515+posGap); 
        
        aniView.center = CGPointMake(aniView.center.x, 591);
        //NSLog(@"aniView.center.y = %f",aniView.center.y);
    } 
}
#pragma mark - 
#pragma mark cameraload
//상품평 카메라 show
- (void)showCamera:(NSInteger)index
{
    //탭바0
    [ApplicationDelegate tabbarHidden:[NSNumber numberWithInt:0]];
    
    NSLog(@"camerashow = %d",index);
    UIImagePickerControllerSourceType sourceType;
    if(index == 0)
        sourceType = UIImagePickerControllerSourceTypeCamera;
    else
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
    
    //if ( [UIImagePickerController isSourceTypeAvailable:sourceType] ) 
    {
        UIImagePickerController* pickerview = [[[UIImagePickerController alloc] init] autorelease];
        pickerview.delegate = self;
        pickerview.sourceType = sourceType;
        pickerview.allowsEditing = YES;
        //iOS6 대응
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)])
        {
            // check 후 call
            [self presentViewController:pickerview animated:NO completion:nil];
            
        }
        else
        {
            // 예전 방식으로
            [self presentModalViewController:pickerview animated:NO];
            
        }
        
    }
    
}
- (NSString *)savePath
{
    NSString *path;
    path = [NSString stringWithFormat:@"%@/image.jpg",DOCS_DIR];
    return path;
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
    NSLog(@"cameraImage w = %f,h=%f",image.size.width,image.size.height);
    
    [self dismissModalViewControllerAnimated:YES];
    
    //파일을 기록한다. 
    [UIImageJPEGRepresentation(image, 0.75f) writeToFile:[self savePath] atomically:YES];
    
    self.bImgSend = 1;
    //탭바1
    [ApplicationDelegate tabbarHidden:[NSNumber numberWithInt:1]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    //탭바1
    [ApplicationDelegate tabbarHidden:[NSNumber numberWithInt:1]];
    NSLog(@"camera cancel");
    self.bImgSend = 0;
    // 취소되었을 때에 실시해야 할 처리를 하고 그 후 사진앨범을 닫는다 
	[self dismissModalViewControllerAnimated:YES];
    
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if ( error ) {
        // error가 nil이 아닌 경우는 보존 실패
    } else {
        // nil이라면 보존 성공
        self.bImgSend = 1;
    }
}
//사진찍기 액션시트 
- (void)pictureBtnAction//delegate 사용해서 탭바 위에 나타나도록 해야한다. 
{
    NSLog(@"사진찍기");
    [titleText resignFirstResponder];
    [descTextView resignFirstResponder];
    scrollView.contentSize = CGSizeMake(320.0f,515+posGap);//515
    //액션시트로 이미지 가져오기 선택(카메라 찍기, 앨범에서 가져오기)
    UIActionSheet *sheet = [[[UIActionSheet alloc]init]autorelease];
    sheet.delegate = self;
    sheet.tag = 333;
    [sheet addButtonWithTitle:@"사진찍기"];
    [sheet addButtonWithTitle:@"앨범에서가져오기"];
    [sheet addButtonWithTitle:@"취소"];
    sheet.cancelButtonIndex = 2;
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIActionSheet *action = (UIActionSheet *)actionSheet1;
    if(action.tag == 333)
    {
        NSLog(@"buttonIndex = %d action.cancelButtonIndex = %d",buttonIndex,action.cancelButtonIndex);
        if (buttonIndex == action.cancelButtonIndex ) 
        {
            NSLog(@"cancel");
        } 
        else if(buttonIndex == 0)
        {
            [self showCamera:0];
            [DataManager sharedManager].cameraFlag = YES;
        }
        else
        {
            [self showCamera:1];
            [DataManager sharedManager].cameraFlag = YES;
        }
    }
}
//----------------------------------------------------------------------------------------------------
//상품평 제목
- (void)titleDisplayUI
{
    NSLog(@"커커4 %f",posGap);
    aniView = [[UIView alloc]initWithFrame:CGRectMake(0, 304+posGap, 320, 460)];
    aniView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:aniView];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"bg_text_01" ofType:@"png"];
    UIImage *img1 = [UIImage imageWithContentsOfFile:path];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img1];
    [imgView setFrame:CGRectMake(15, 7, 290, 30)];
    [aniView addSubview:imgView];
    [imgView release];
    DrawView *drawLine4 = [[DrawView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];//업로드 이미지가 있으면 57이 더해지고 없으면 57 빼고 
    [aniView addSubview:drawLine4];
    [drawLine4 release];
    
    //키보드 완료 버튼 
    /*
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    inputAccessoryView.backgroundColor = [UIColor darkGrayColor];
    inputAccessoryView.alpha = 0.8f;
    
    [self imageButtonCreate1:@"btn_done" click:@"btn_done_click" frame:CGRectMake(259.0, 6.5, 55.0, 30.0) views:inputAccessoryView action:@selector(confirm:) tag:66];
    
    */
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    //toolBar.alpha = 1.0;
    /*
    UIBarButtonItem *prevBtn = [[UIBarButtonItem alloc] initWithTitle:@"이전" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldPriv:)];
    //[prevBtn setTag:textField.tag];
    
    if (prevBtn.tag == 100) {
        [prevBtn setEnabled:NO];
    }
    
    
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"다음" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldNext:)];
    //[nextBtn setTag:textField.tag];
    if (nextBtn.tag == 100) {
        [nextBtn setEnabled:NO];
    }
    */
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleDone target:self action:@selector(confirm:)];
    closeBtn.tag = 66;
    //UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(textFieldCancel)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects: flexibleSpace, closeBtn, nil] animated:YES];
    //[self.view.superview addSubview:toolBar];
    //[toolBar release];

    
    
    
    
    titleText = [[UITextField alloc]initWithFrame:CGRectMake(24, 17, 272, 14)];
    titleText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if([[self.goodsInfoDict valueForKey:@"title"] isEqualToString:@""])
        [titleText setPlaceholder:@"제목을 입력해주세요"];
    else
        titleText.text = [self.goodsInfoDict valueForKey:@"title"];
    [titleText setBorderStyle:UITextBorderStyleNone];
    titleText.returnKeyType = UIReturnKeyDone;
    titleText.delegate = self;
    [titleText setFont:[UIFont systemFontOfSize:12]]; //폰트 크기 설정
    [titleText setTextColor:_RGBA(92, 92, 92, 1)];
    titleText.inputAccessoryView = toolBar;
    [titleText addTarget:self action:@selector(textFiledDidChangeId:) forControlEvents:UIControlEventEditingChanged];
    [aniView addSubview:titleText];
    [toolBar release];
}
- (void)confirm:(id)sender {
	[titleText resignFirstResponder];
    scrollView.contentSize = CGSizeMake(320.0f,515+posGap);//515
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    scrollView.contentSize = CGSizeMake(320.0f,720+posGap);
    scrollView.contentOffset = CGPointMake(0, 300+posGap);
}
- (void)textFiledDidChangeId:(UITextField *)txt
{
    [self.goodsInfoDict setValue:txt.text forKey:@"title"];
    NSLog(@"title = %@",[self.goodsInfoDict valueForKey:@"title"]);
}
//UITextFiled delegate 입력한 텍스트 저장
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"");
    [titleText resignFirstResponder];
    scrollView.contentSize = CGSizeMake(320.0f,515+posGap);//515
    
    return YES;
}
 

//상품평 내용
- (void)goodsEstimationWriteUI
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"bg_text_02" ofType:@"png"];
    UIImage *img1 = [UIImage imageWithContentsOfFile:path];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img1];
    [imgView setFrame:CGRectMake(15, 44, 290, 108)];
    [aniView addSubview:imgView];
    [imgView release];
    
    //키보드 완료 버튼 
    
    /*
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    inputAccessoryView.backgroundColor = [UIColor darkGrayColor];
    inputAccessoryView.alpha = 0.8f;
    
    [self imageButtonCreate1:@"btn_done" click:@"btn_done_click" frame:CGRectMake(259.0, 6.5, 55.0, 30.0) views:inputAccessoryView action:@selector(confirm1:) tag:66];
     
     */
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
   // toolBar.alpha = 1.0;
    /*
     UIBarButtonItem *prevBtn = [[UIBarButtonItem alloc] initWithTitle:@"이전" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldPriv:)];
     //[prevBtn setTag:textField.tag];
     
     if (prevBtn.tag == 100) {
     [prevBtn setEnabled:NO];
     }
     
     
     UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"다음" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldNext:)];
     //[nextBtn setTag:textField.tag];
     if (nextBtn.tag == 100) {
     [nextBtn setEnabled:NO];
     }
     */
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStyleDone target:self action:@selector(confirm1:)];
    closeBtn.tag = 66;
    //UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(textFieldCancel)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects: flexibleSpace, closeBtn, nil] animated:YES];
     
     
    descTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 49, 272, 90)];
    //descTextView.keyboardType = 
    descTextView.textAlignment = UITextAlignmentLeft;
    descTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    descTextView.delegate = self;
    
    if([[self.goodsInfoDict valueForKey:@"messageDscr"] isEqualToString:@""])
        descTextView.text = @"상품평을 작성해 주세요";
    else
    {
        NSString *str1 = [self.goodsInfoDict valueForKey:@"messageDscr"];
        NSLog(@"messageDscr = %@",str1);
        str1 = [str1 stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        NSLog(@"messageDscr = %@",str1);
        descTextView.text = str1;//[self.goodsInfoDict valueForKey:@"messageDscr"];
    }
    
    descTextView.editable = YES;
    descTextView.inputAccessoryView = toolBar;
    [descTextView setFont:[UIFont systemFontOfSize:12]]; //폰트 크기 설정
    [descTextView setTextColor:[UIColor darkGrayColor]];
    [aniView addSubview:descTextView];
    [descTextView release];
    [toolBar release];
}
- (void)confirm1:(id)sender {
	[descTextView resignFirstResponder];
    scrollView.contentSize = CGSizeMake(320.0f,515+posGap);//515
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // return키를 누루면 원래 줄바꿈이 일어나므로 \n을 입력하는데 \n을 입력하면 실행하게 합니다.
        NSLog(@"return ");
        //[textView resignFirstResponder]; //키보드를 닫는 메소드입니다.
        //return FALSE; //리턴값이 FALSE이면, 입력한 값이 입력되지 않습니다.
    }
    return TRUE;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"");
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"");
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"상품평을 작성해 주세요"])
    {
        descTextView.text = @"";
    }
    
    scrollView.contentSize = CGSizeMake(320.0f,720+posGap);
    scrollView.contentOffset = CGPointMake(0, 300+posGap);
    NSLog(@"");
}
- (void)endEditing:(UIButton*)btn {
    [descTextView resignFirstResponder]; 
    scrollView.contentSize = CGSizeMake(320.0f,515+posGap);//515
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"");
}
- (void)textViewDidChange:(UITextView *)textView
{
    //textView에 어느 글을 쓰더라도 이 메소드를 호출합니다.
//    if ([textView.text isEqualToString:@"\n"]) {
//        // return키를 누루면 원래 줄바꿈이 일어나므로 \n을 입력하는데 \n을 입력하면 실행하게 합니다.
//        NSLog(@"엔터키를 첫다");
//    }
    [self.goodsInfoDict setValue:textView.text forKey:@"messageDscr"];
    NSLog(@"messageDscr = %@",[self.goodsInfoDict valueForKey:@"messageDscr"]);
}
//상품평 데이터 서버로 보내기 
- (void)btnAction:(id)sender
{
    //#define degreesToRadian(x) (M_PI * (x) /180.0)
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        if([[self.goodsInfoDict valueForKey:@"title"] isEqualToString:@""] || [[self.goodsInfoDict valueForKey:@"messageDscr"] isEqualToString:@""])
        {
             
            
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"타이틀 또는 상품평을 입력하지 않았습니다." maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
            [ApplicationDelegate.window addSubview:lalert];
            [lalert release];
        }
        else
        {
            
            NSString *str1 = [self.goodsInfoDict valueForKey:@"messageDscr"];
            str1 = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
            
            [self.goodsInfoDict setValue:str1 forKey:@"messageDscr"];
            NSLog(@"messageDscr = %@",str1);
            //-----------
            [titleText resignFirstResponder];
            [descTextView resignFirstResponder];
            if(self.bImgSend == 1)
            {
                [self.goodsInfoDict setValue:@"image.png" forKey:@"hidden_name_0"];
            }
            GoodsInfoRequest *ge = [[GoodsInfoRequest alloc]init];
            ge.delegate = self;
            NSLog(@"bImgSend = %d", self.bImgSend);
            
            if(self.bImgSend == 0)//이미지 없다.
            {
                [self.goodsInfoDict setValue:@"1" forKey:@"contentsFlag"];//이미지 없으면 1, 이미지 있으면 2
                NSLog(@"contentsFlag = %d", 1);
            }
            else
            {
                [self.goodsInfoDict setValue:@"2" forKey:@"contentsFlag"]; //이미지 없으면 1, 이미지 있으면 2
                NSLog(@"contentsFlag = %d", 2);
            }
            
            [ge sendDataDic:self.goodsInfoDict];
            [ge release];
            
        }
        
    }
    if(btn.tag == 2)
    {
        if([[self.goodsInfoDict valueForKey:@"title"] isEqualToString:@""] || [[self.goodsInfoDict valueForKey:@"messageDscr"] isEqualToString:@""])
        {
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"타이틀 또는 상품평을 입력하지 않았습니다." maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
            [ApplicationDelegate.window addSubview:lalert];
            [lalert release];
        }
        else
        {
            NSString *str1 = [self.goodsInfoDict valueForKey:@"messageDscr"];
            str1 = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
            
            [self.goodsInfoDict setValue:str1 forKey:@"messageDscr"];
            NSLog(@"messageDscr = %@",str1);
            
            [titleText resignFirstResponder];
            [descTextView resignFirstResponder];
            if(self.bImgSend == 1)
            {
                [self.goodsInfoDict setValue:@"image.png" forKey:@"hidden_name_0"];
            }
            GoodsInfoRequest *ge = [[GoodsInfoRequest alloc]init];
            ge.delegate = self;
            NSLog(@"bImgSend = %d", self.bImgSend);
            
            if(self.bImgSend == 0)//이미지 없다.
            {
                [self.goodsInfoDict setValue:@"1" forKey:@"contentsFlag"];//이미지 없으면 1, 이미지 있으면 2
            }
            else
            {
                [self.goodsInfoDict setValue:@"2" forKey:@"contentsFlag"]; //이미지 없으면 1, 이미지 있으면 2
            }
            
            [ge sendDataDic:self.goodsInfoDict];
            [ge release];
            
        }
    }
    if(btn.tag == 3)//설명서 
    {
        infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 320, 365)];
        [self.view addSubview:infoView];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"popup_review" ofType:@"png"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
        [infoView addSubview:imageView];
        [imageView release];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(14, 22, 30, 30)];
        //btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(infoClose:) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:btn];
        [btn release];
    }
}
- (void)infoClose:(UIButton *)btn
{
    [infoView removeFromSuperview];
    NSLog(@"close");
}
//등록 버튼 
- (void)registerGoodsEstimatiionUI
{
    CGRect rect1 = CGRectMake(15, 162, 110, 31);
    [self imageButtonCreate:@"btn_review_01" frame:rect1 views:aniView action:@selector(btnAction:) tag:1];
    
    CGRect rect2 = CGRectMake(129, 162, 110, 31);
    [self imageButtonCreate:@"btn_review_02" frame:rect2 views:aniView action:@selector(btnAction:) tag:2];
    
    CGRect rect3 = CGRectMake(243, 162, 62, 31);
    [self imageButtonCreate:@"btn_review_03" frame:rect3 views:aniView action:@selector(btnAction:) tag:3];
}
//결과넘어옴
- (BOOL)contain:(NSString*)string constring:(NSString *)containStr
{
    NSLog(@"---------");
    NSString *str = string;
    NSRange range = [str rangeOfString:containStr];
    if(range.location == NSNotFound)//없음 
    {
        NSLog(@"결과없음");
        return NO;
    }
    else{
        NSLog(@"결과있음");
        return YES;
    }
    
}
//상품평 데이터 넘기고 받을 결과 
- (void)doneRequest:(NSString *)status
{
    NSLog(@"status = %@",status);
    if([self contain:status constring:@"완료되었습니다"] || [self contain:status constring:@"감사합니다"])
    {
        NSInteger messageid = [[self.goodsInfoDict valueForKey:@"messageId"] intValue];
        
        
        
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:(messageid >0)?@"상품평 수정이 완료 되었습니다.":@"상품평 등록이 완료 되었습니다." maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
        lalert.tag = 11;
        [ApplicationDelegate.window addSubview:lalert];
        [lalert release];
        
         
    }
    else
    {
        
        
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"상품평 등록 오류" maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:@"확인", nil]];
        lalert.tag = 11;
        [ApplicationDelegate.window addSubview:lalert];
        [lalert release];
        
        
    }
    
    
}



#pragma mark UICustomAlertDelegate 

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 12) {
        
        [target performSelector:@selector(webViewReload)];
        [self dismissModalViewControllerAnimated:YES];
        //탭바1
        [ApplicationDelegate tabbarHidden:[NSNumber numberWithInt:1]];
        
        
    }else {
         [self GoBack];        
    }
    
    
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    
    scrollView = [[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 45.0f, 320.0f, [[UIScreen mainScreen] bounds].size.height-110)]autorelease];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeZero;
    //scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    [self goodsNameUI];//상품명
    [self explainTextUI];//
    [self starDisplayUI];//등급표시 
    [self upLoadPictureUI];
    
    [self titleDisplayUI];
    [self goodsEstimationWriteUI];
    [self registerGoodsEstimatiionUI];
    
    
    scrollView.contentSize = CGSizeMake(320.0f,515+posGap);//515
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self docFileDelete];
    NSLog(@"커커1");
}
- (void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"")
    
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"커커2");
    ///self.bImgSend = 1;
    if(self.bImgSend == 1)
    {
          NSLog(@"커커3");
        //self.bImgSend = 0;
        posGap = 57.0f;
        [self upLoadImageShow];
        [self pictureViewUI];
        [self.view setNeedsLayout];
    }
}
- (void)viewDidUnload
{
    //----------coding here
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
