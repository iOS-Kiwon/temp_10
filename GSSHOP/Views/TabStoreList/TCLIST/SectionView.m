//
//  SectionView.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 3..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "SectionView.h"
#import "AppDelegate.h"

#import "BCListTBViewController.h"
#import "TDCLiveTBViewController.h"
#import "FXCListTBViewController.h"
#import "EIListPSCViewController.h"
#import "NTCListTBViewController.h"
#import "NSTFCListTBViewController.h"
#import "SListTBViewController.h"
#import "SUPListTableViewController.h"
#import "VODListTableViewController.h"

#import "SectionView+TDCLIST.h"
#import "SectionView+FXCLIST.h"
#import "SectionView+EILIST.h"
#import "SectionView+NTCLIST.h"
#import "SectionView+NSTFCLIST.h"
#import "SectionView+SLIST.h"

#import "SectionView+SUPLIST.h"
#import "SectionView+VODLIST.h"
#import "SectionView+NFXCLIST.h"

#import "WKManager.h"

@interface SectionView ()
@end
@implementation SectionView

#define GROUP_FILTER_ORDER_POPBTN_TAG 40001
#define GROUP_FILTER_ORDER_NEWESTBTN_TAG 40002

@synthesize tbv;
@synthesize homeHeaderView, subcategoryHomeListView;
@synthesize headerViewFPC;
@synthesize headerViewFPCSub;
@synthesize headerFlowView;
@synthesize viewFPC_SubCate;
@synthesize viewFPC;
@synthesize sectionarrdata = sectionarrdata_;
@synthesize currentOperation1 = currentOperation1_;
@synthesize delegatetarget;
@synthesize bg_section_mask;
@synthesize tdcliveTbv;
@synthesize eiPcv;
@synthesize nalTbv;
@synthesize shortTbv;
@synthesize scheduleTbv;
@synthesize btngoTop;
@synthesize btnSiren;
@synthesize specialSectionApiResult, specialSectionRightApiResult;
@synthesize homeSectionApiResult;
@synthesize viewBestSubCate,sectionViewType;


// nami0342 - CSP
@synthesize m_btnCSPIcon = _m_btnCSPIcon, m_btnMessageNLink = _m_btnMessageNLink, m_dicMsg = _m_dicMsg, m_isAnimating = _m_isAnimating, m_iNavigationID = _m_iNavigationID;
@synthesize m_fXpos = _m_fXpos, m_strCSPType = _m_strCSPType, m_btnMessageNLink2 = _m_btnMessageNLink2, m_iType = _m_iType, m_imgvCursor = _m_imgvCursor;


-(void) dealloc {
    // nami0342
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _sectioninfoDic = nil;

    
    self.sectionarrdata = nil;
    self.homeHeaderView = nil;
    self.subcategoryHomeListView = nil;
    self.homeSectionApiResult = nil;
    self.bg_section_mask = nil;
    self.btngoTop = nil;
    self.specialSectionApiResult = nil;
    self.specialSectionRightApiResult = nil;
    
    
    self.tbv = nil;
    self.eiPcv = nil;
    self.nalTbv = nil;
    self.tdcliveTbv = nil;
    self.scheduleTbv = nil;
    self.tdcliveTbv = nil;
    self.fxcTbv = nil;
    self.eiPcv = nil;
    self.nalTbv = nil;
    self.shortTbv = nil;
    self.scheduleTbv = nil;
    self.feedTbv = nil;
    self.supTbv = nil;
    self.vodTbv = nil;
    self.nfxcTbv2 = nil;
}


-(void)removeFromSuperview {
    if( self.currentOperation1  != nil){
        [self.currentOperation1 cancel];
        self.currentOperation1 = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MAINSECTIONGOTOPNRELOADNOTI  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MAINSECTIONHIDEBUTTONSIREN  object:nil];

    // nami0342 - CSP
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
    if (sectionViewType == SectionViewTypeHome) {
        if(self.tbv != nil) {
            [self.tbv checkDealloc];
            self.tbv=nil;
        }
    }
    else if (sectionViewType == SectionViewTypeTVShop) {
        if(self.tdcliveTbv != nil) {
            [self.tdcliveTbv checkDealloc];
            self.tdcliveTbv=nil;
        }
    }
    else if (sectionViewType == SectionViewTypeFlexible || sectionViewType == SectionViewTypeNewEvent) {
        if(self.fxcTbv != nil) {
            [self.fxcTbv checkDeallocFXC];
            [self.fxcTbv.view removeFromSuperview];
            self.fxcTbv=nil;
        }
    }
    else if (sectionViewType == SectionViewTypeNalbang) {
        if(self.nalTbv != nil) {
            //[self.tbv checkDealloc];
            self.nalTbv=nil;
        }
    }
    
    else if (sectionViewType == SectionViewTypeShortbang) {
        if(self.shortTbv != nil) {
            //[self.tbv checkDealloc];
            self.shortTbv=nil;
        }
    }
    
    else if (sectionViewType == SectionViewTypeSchedule) {
        if(self.scheduleTbv != nil) {
            [self.scheduleTbv checkDeallocSList];
            [self.scheduleTbv.view removeFromSuperview];
            self.scheduleTbv=nil;
        }
    }
    
    else if (sectionViewType == SectionViewTypeSUPList)
    {
        if(self.supTbv != nil) {
            [self.supTbv checkDeallocSUP];
            [self.supTbv.view removeFromSuperview];
            self.supTbv=nil;
        }
        
    }
    else if (sectionViewType == SectionViewTypeVODList)
    {
        if(self.vodTbv != nil) {
            [self.vodTbv checkDeallocVOD];
            [self.vodTbv.view removeFromSuperview];
            self.vodTbv=nil;
        }
        
    }
    else if (sectionViewType == SectionViewTypeNewFlexible)
    {
        if(self.nfxcTbv2 != nil) {
            [self.nfxcTbv2 checkDeallocNFXC];
            [self.nfxcTbv2.view removeFromSuperview];
            self.nfxcTbv2=nil;
        }
        
    }
    else
    {
        //다른 타입의 뷰 처리 요망
    }
    
    //subview 삭제 (Home_Main_ViewController에서 이동)
    NSArray *subviews = [self subviews];
    for (int i=0, j=(int)[subviews count]; i<j; i++)
    {
        UIView *subview = [subviews objectAtIndex:i];
        [subview removeFromSuperview];
    }
    
    [super removeFromSuperview];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (id)initWithTargetdic:(NSDictionary*)sectioninfo {
    self = [super init];
    if(self) {
        sectionViewType = SectionViewTypeHome;
        if(_sectioninfoDic == nil) {
            _sectioninfoDic = sectioninfo;
        }
        else {
            _sectioninfoDic = nil;
            _sectioninfoDic = sectioninfo;
        }
        self.currentCateinfoindex=0;
        self.currentOrderinfoindex = GROUP_FILTER_ORDER_POPBTN_TAG;
        
        [self setup];

    }
    return self;
}


- (id)initSpecialTypeWithTargetdic:(NSDictionary*)sectioninfo withType:(SectionViewType)stype subCategory:(NSString *)subCate {
    if([NCS(subCate) length] > 0) {
        self.tabIdBysubCategoryName = subCate;
    }
    return [self initSpecialTypeWithTargetdic:sectioninfo withType:stype];
}

- (id)initSpecialTypeWithTargetdic:(NSDictionary*)sectioninfo withType:(SectionViewType)stype {
    self = [super init];
    if(self) {
        sectionViewType = stype;
        if(_sectioninfoDic == nil) {
            _sectioninfoDic = sectioninfo;
        }
        else {
            _sectioninfoDic = nil;
            _sectioninfoDic = sectioninfo;
        }
        self.currentCateinfoindex=0;
        if(sectionViewType == SectionViewTypeTVShop){
            self.currentOrderinfoindex = TDC_SECTION_TAB1_TAG;
        }

        [self setup];
        
       
    }
    return self;
}

//
- (void)setup {
    

    // nami0342 - CSP
    self.m_iNavigationID = [_sectioninfoDic objectForKey:@"navigationId"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CSP_ShowIcon:) name:NOTI_CSP_SHOW_MESSAGES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CSP_HideIcon:) name:NOTI_CSP_ALL_CLEAR object:nil];

    
    isHiddenTopTabview = NO;
    isFirstwiseAppLog = YES;
    self.currentCateinfoindex = 0;
    //인증시 각섹션별 전체 화면을 새로고침 하지 않아도 되어 v3.1.7.18 부터 특정섹션만 observer 추가
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sectiongoTopNReload:)
                                                 name:MAINSECTIONGOTOPNRELOADNOTI
                                               object:(NSNumber*)sectiongoTopnotinum];

    
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self ScreenDefine];
    
    self.backgroundColor = [UIColor whiteColor];//[Mocha_Util getColor:@"e5e5e5"];
    
    //UI 변경
    btngoTop = [UIButton buttonWithType:UIButtonTypeCustom];
    [btngoTop addTarget:self action:@selector(sectiongoTop) forControlEvents:UIControlEventTouchUpInside];
    [btngoTop setBackgroundImage:[UIImage imageNamed:@"bt_common_top"] forState:UIControlStateNormal] ;
    [btngoTop setBackgroundImage:[UIImage imageNamed:@"bt_common_top"] forState:UIControlStateHighlighted];
    btngoTop.accessibilityLabel = @"화면을 최상단으로 이동";
    if (sectionViewType != SectionViewTypeSchedule) {
        btngoTop.alpha = 0.0f;
        [self addSubview:btngoTop];
        isBtnAlphaZero = YES;
    }

 

    // Create label link - 1줄
    self.m_btnMessageNLink = [UIButton buttonWithType:UIButtonTypeCustom];
    self.m_btnMessageNLink.frame = CGRectMake(26, self.frame.size.height - 65+6, 0, 35); // !!!!!
    self.m_btnMessageNLink.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.m_btnMessageNLink.backgroundColor =[Mocha_Util getColor:@"444444"];
    self.m_btnMessageNLink.alpha = 0.9f;
    self.m_btnMessageNLink.clipsToBounds = YES;
    self.m_btnMessageNLink.layer.cornerRadius = 17.5f;
    self.m_btnMessageNLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.m_btnMessageNLink.contentEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [self.m_btnMessageNLink addTarget:self action:@selector(CSP_WebLink:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger nTabId = 0;
    NSString *strTabId = [_sectioninfoDic objectForKey:@"navigationId"];
    if(NCS(strTabId).length > 0)
    {
        nTabId = strTabId.integerValue;
        self.m_btnMessageNLink.tag = nTabId;
    }
    [self addSubview:_m_btnMessageNLink];
    
    
    // 2줄
    self.m_btnMessageNLink2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.m_btnMessageNLink2.frame = CGRectMake(65, self.frame.size.height - 65+6 , 0, 55); // !!!!!
    [self.m_btnMessageNLink2 setBackgroundImage:[UIImage imageNamed:@"csp_balloon"] forState:UIControlStateNormal];
    [self.m_btnMessageNLink2 setBackgroundImage:[UIImage imageNamed:@"csp_balloon"] forState:UIControlStateSelected];
    [self.m_btnMessageNLink2 setBackgroundImage:[[self.m_btnMessageNLink2 backgroundImageForState:UIControlStateNormal] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 50, 50)] forState:UIControlStateNormal];
    self.m_btnMessageNLink2.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 15);
    self.m_btnMessageNLink2.titleLabel.numberOfLines = 2;
    self.m_btnMessageNLink2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
  
    if(NCS(strTabId).length > 0)
    {
        nTabId = strTabId.integerValue;
        self.m_btnMessageNLink2.tag = nTabId;
    }
    [self addSubview:_m_btnMessageNLink2];
    
    
    
    
    
    // Icon button
    self.m_btnCSPIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.m_btnCSPIcon.frame = CGRectMake(-90, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
    [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_benepit"] forState:UIControlStateNormal];
    [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_benepit"] forState:UIControlStateFocused];
    self.m_btnCSPIcon.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.m_btnCSPIcon addTarget:self action:@selector(CSP_clickIcon:) forControlEvents:UIControlEventTouchUpInside];
    self.m_btnCSPIcon.tag = nTabId;
    
    [self addSubview:_m_btnCSPIcon];
    
    self.m_btnCSPIcon.hidden = YES;
    self.m_btnMessageNLink.hidden = YES;
    self.m_btnMessageNLink2.hidden = YES;

}


// nami0342 - Icon 클릭 시 마지막에 받은 메시지를 노출 시킨다.
- (void) CSP_clickIcon : (id) sender
{
    if(self.m_isAnimating == NO){
        self.m_isAnimating = YES;
        [self CSP_ShowMessage:self.m_dicMsg];
    }
    else
        return;
    
}


// nami0342 - Link clicked on the mesage label
- (void) CSP_WebLink : (id)sender
{
    if(NCO(_m_dicMsg) == NO)
        return;
    
    NSString *strLinkURL = NCS([self.m_dicMsg objectForKey:@"LN"]);
    if (strLinkURL.length == 0) {
        return;
    }
    
    ResultWebViewController *wRWebview = [[ResultWebViewController alloc] initWithUrlString:strLinkURL];
    [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:wRWebview];
}

// nami0342 - 아이콘 노출되었을 경우 Commaon Click을 호출한다.
- (void) CSP_CommonClick : (NSDictionary *) dicData
{
    NSString *strCClick = NCS([dicData objectForKey:@"TL"]);
    if(strCClick.length == 0)
        return;
    
    [ApplicationDelegate wiseLogRestRequest:strCClick];
}


// nami0342 - CSP
- (void) CSP_HideIcon : (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.m_btnMessageNLink.hidden = YES;
        self.m_btnMessageNLink2.hidden = YES;
        self.m_btnCSPIcon.hidden = YES;
    });
}

// nami0342 - Show SCP Icon
- (void) CSP_ShowIcon : (NSNotification *) notification
{
    
    if([notification isKindOfClass:[NSDictionary class]] == NO)
    {
        
        NSDictionary *dicUserInfo = notification.userInfo;
        
        if(NCO(dicUserInfo) == NO)
            return;
        
        if(NCO([dicUserInfo objectForKey:@"msg"]) == NO)
            return;
        
        if(NCO([dicUserInfo objectForKey:@"navigationId"]) == NO)
            return;
        
        
        if(ApplicationDelegate.strNavigationTabID.intValue != self.m_btnCSPIcon.tag)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_btnCSPIcon.hidden = YES;
                self.m_btnMessageNLink.hidden = YES;
                self.m_btnMessageNLink2.hidden = YES;
            });
            return;
        }
       
        
        self.m_dicMsg = [dicUserInfo objectForKey:@"msg"];
    }
    else
    {
        self.m_dicMsg = (NSDictionary *)notification;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSString *strShow = [_m_dicMsg objectForKey:@"VI"];
        if(NCS(strShow).length > 0 && [strShow isEqualToString:@"Y"] == YES)
        {
            
            // Banner 처리일 경우 - Image URL - I / Landing URL - LN으로 처리
            if([NCS([_m_dicMsg objectForKey:@"I"]) length] > 0)
            {
                [self CSP_ShowBanner:_m_dicMsg];
                return;
            }
            
            
            // 타입 변경 필요 시 처리
            if(self.m_btnCSPIcon != nil) {
                self.m_btnCSPIcon.hidden = NO;
            }
            
            NSString *strType = [NSString stringWithFormat:@"%@", NCS([_m_dicMsg objectForKey:@"TP"])];
            
            // 타입 변경 필요 시 처리
            if([strType isEqualToString:@"view"] == YES)
            {
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_eye"] forState:UIControlStateNormal];
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_eye"] forState:UIControlStateFocused];
            }
            else if([strType isEqualToString:@"save"] == YES)
            {
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_benepit"] forState:UIControlStateNormal];
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_benepit"] forState:UIControlStateFocused];
            }
            else if([strType isEqualToString:@"tip"] == YES)
            {
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_tip"] forState:UIControlStateNormal];
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_tip"] forState:UIControlStateFocused];
            }
            else if([strType isEqualToString:@"alert"] == YES)
            {
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_alarm"] forState:UIControlStateNormal];
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_alarm"] forState:UIControlStateFocused];
            }
            else
            {
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_alarm"] forState:UIControlStateNormal];
                [self.m_btnCSPIcon setImage:[UIImage imageNamed:@"ic_alarm"] forState:UIControlStateFocused];
            }
            
            // Animation 을 위해 위치 초기화
            CGRect rect = self.m_btnCSPIcon.frame;
            rect.origin.x = -90;
            rect.origin.y = self.frame.size.height- 65 - 10;
            self.m_btnCSPIcon.frame = rect;
            
            [UIView animateWithDuration:0.5f delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                CGRect frame = _m_btnCSPIcon.frame;
                frame.origin.x = 1;
                _m_btnCSPIcon.frame = frame;
                
            } completion:^(BOOL finished) {
                // TL 파싱해서 Commonclick으로 호출
                if(finished == YES)
                {
                    [self CSP_ShowMessage:_m_dicMsg];
                    [self CSP_CommonClick:_m_dicMsg];
                }
            }];
        
    
            // 효율코드 호출 - TL
            NSString *strMseq = [_m_dicMsg objectForKey:@"TL"];
            if(NCS(strMseq).length > 0)
            {
                [ApplicationDelegate wiseAPPLogRequest:strMseq];
            }
        }
    });
}



// nami0342 - Show CSP banner
- (void) CSP_ShowBanner : (NSDictionary *) dicMsg
{
    
    NSString *strImage = [NSString stringWithFormat:@"%@", NCS([_m_dicMsg objectForKey:@"I"])];
    NSString *strLink = [NSString stringWithFormat:@"%@", NCS([_m_dicMsg objectForKey:@"LN"])];
    
    NSLog(@"@@@@@@@  Img (%@) / Link (%@", strImage, strLink);
    
    if(NCO(self.tbv)) {
        [self.tbv callCSP];
    }
}


// nami0342 - Show CSP message
- (void) CSP_ShowMessage : (NSDictionary *) dicMsg
{
    
    if(ApplicationDelegate.strNavigationTabID.intValue != self.m_btnMessageNLink.tag &&
       ApplicationDelegate.strNavigationTabID.intValue != self.m_btnMessageNLink2.tag)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.m_btnCSPIcon != nil) {
            self.m_btnCSPIcon.hidden = NO;
        }
        
        // Show Message
        NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                        NSForegroundColorAttributeName : [Mocha_Util getColor:@"ffffff"]
                                        };
        NSDictionary *spetialTextAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],
                                          NSForegroundColorAttributeName : [Mocha_Util getColor:@"e2ff3a"]
                                          };
        
        
        NSString *strMsg0 = NCS([dicMsg objectForKey:@"M0"]);
        NSString *strMsg1 = NCS([dicMsg objectForKey:@"M1"]);
        NSString *strMsg2 = NCS([dicMsg objectForKey:@"M2"]);
        NSString *strLink = @"  ";
        if(SYSTEM_VERSION_LESS_THAN(@"9.0")) {
            strLink = @" >";
        }
        else
        {
            strLink = @"";
        }
        
        //        strMsg0 = @"111";
        //        strMsg1 = @"강조되는 부분 ";
        //        strMsg2 = @"33333";
        
        NSMutableAttributedString *attrMsg0 = [[NSMutableAttributedString alloc]initWithString:strMsg0 attributes:nomalTextAttr];
        NSMutableAttributedString *attrMsg1 = [[NSMutableAttributedString alloc]initWithString:strMsg1 attributes:spetialTextAttr];
        NSMutableAttributedString *attrMsg2 = [[NSMutableAttributedString alloc]initWithString:strMsg2 attributes:nomalTextAttr];
        NSMutableAttributedString *attLink  = [[NSMutableAttributedString alloc]initWithString:strLink attributes:nomalTextAttr];
        
        [attrMsg0 appendAttributedString:attrMsg1];
        [attrMsg0 appendAttributedString:attrMsg2];
        
        
        if([attrMsg0.string rangeOfString:@"</br>"].location != NSNotFound)
        {
            NSRange range;
            range.location = [attrMsg0.string rangeOfString:@"</br>"].location;
            range.length = [attrMsg0.string rangeOfString:@"</br>"].length;
            self.m_iType = 2;  // 2줄
            [attrMsg0 replaceCharactersInRange:range withString:@"\n"];
        }
        else
        {
            self.m_iType = 1;   // 1줄
        }
        
        // nami0342 - 강제 1줄로 고정
        self.m_iType = 1;   // 1줄
        
        // Link가 있을 경우 꺽쇠를 붙여준다.
        NSString *strLinkURL = NCS([self.m_dicMsg objectForKey:@"LN"]);
        
        
        // nami0342 - 글자 수가 2줄 이상이라고 생각되면 말풍선으로 변경한다.
        if(self.m_iType == 2)
        {
            // 2줄 (말 풍선)
            self.m_btnMessageNLink.hidden = YES;
            self.m_btnMessageNLink2.hidden = NO;
            
            [self.m_btnMessageNLink2 setAttributedTitle:attrMsg0 forState:UIControlStateNormal];
            [self.m_btnMessageNLink2 setAttributedTitle:attrMsg0 forState:UIControlStateHighlighted];
            
            if(self.m_btnMessageNLink2.currentAttributedTitle.length == 0) {
                return;
            }
            
            [self.m_btnMessageNLink2 setBackgroundImage:[UIImage imageNamed:@"csp_balloon"] forState:UIControlStateNormal];
            [self.m_btnMessageNLink2 setBackgroundImage:[UIImage imageNamed:@"csp_balloon"] forState:UIControlStateSelected];
            [self.m_btnMessageNLink2 setBackgroundImage:[[self.m_btnMessageNLink2 backgroundImageForState:UIControlStateNormal] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 50, 50)] forState:UIControlStateNormal];
            
            self.m_btnMessageNLink2.titleLabel.numberOfLines = 2;
            self.m_btnMessageNLink2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
            

            CGSize labelSize = [self.m_btnMessageNLink2.currentAttributedTitle.string sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:self.m_btnMessageNLink2.titleLabel.font.fontName size:15]}];
            labelSize.width = labelSize.width + ((strLinkURL.length > 0) ? 63 : 53);
            
            
            self.m_fXpos = self.m_btnCSPIcon.frame.origin.x + self.m_btnCSPIcon.frame.size.width + 3;
         
            CGRect lbFrame = _m_btnMessageNLink2.frame;
            if(labelSize.width < (self.frame.size.width - (self.m_btnMessageNLink2.frame.origin.x + ((strLinkURL.length > 0) ? 63 : 10))))
            {
                lbFrame.size.width = labelSize.width;
            }
            else
            {
                lbFrame.size.width = (self.frame.size.width - (self.m_btnMessageNLink2.frame.origin.x + 10));
            }
      
            lbFrame.size.height = 55;
            self.m_btnMessageNLink2.frame = lbFrame;
            
            //
            if (strLinkURL.length > 0) {
                [attrMsg0 appendAttributedString:attLink];
                if (@available(iOS 9.0, *)) { //setSemanticContentAttribute는 iOS 9.0이상부터 지원
                    if(self.m_imgvCursor == nil)
                    {
                        self.m_imgvCursor = [[UIImageView alloc] initWithFrame:CGRectMake(_m_btnMessageNLink2.frame.size.width - 10 - 19, _m_btnMessageNLink2.frame.size.height/2 - 18/2, 19, 19)];
                        self.m_imgvCursor.image = [UIImage imageNamed:@"csp_arrow2"];
                        [self.m_btnMessageNLink2 addSubview:_m_imgvCursor];
                        self.m_btnMessageNLink2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        self.m_btnMessageNLink2.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 25);
                    }
                }
                else {
                    // Text - '>' 로 처리
                    self.m_btnMessageNLink2.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
                }
            }
            else {
                self.m_btnMessageNLink2.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
            }
        }
        else
        {
            // 1줄
            self.m_btnMessageNLink.hidden = NO;
            self.m_btnMessageNLink2.hidden = YES;
            
            self.m_fXpos = 26;
            
            if (strLinkURL.length > 0) {
                [attrMsg0 appendAttributedString:attLink];
                if (@available(iOS 9.0, *)) { //setSemanticContentAttribute는 iOS 9.0이상부터 지원
                    [self.m_btnMessageNLink setImage:[UIImage imageNamed:@"csp_arrow"] forState:UIControlStateNormal];
                    [self.m_btnMessageNLink setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                    self.m_btnMessageNLink.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                }
                else {
                    // Text - '>' 로 처리
                    
                }
            }
            else {
                [self.m_btnMessageNLink setImage:nil forState:UIControlStateNormal];
            }
            
            [self.m_btnMessageNLink setAttributedTitle:attrMsg0 forState:UIControlStateNormal];
            [self.m_btnMessageNLink setAttributedTitle:attrMsg0 forState:UIControlStateHighlighted];
            
            if(self.m_btnMessageNLink.currentAttributedTitle.length == 0) {
                return;
            }
            
            CGRect lbFrame = _m_btnMessageNLink.frame;
            lbFrame.size.width = self.m_btnMessageNLink.currentAttributedTitle.size.width + ((strLinkURL.length > 0) ? 63 : 53);
            self.m_btnMessageNLink.frame = lbFrame;
        }
        
        
        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{

            
        } completion:^(BOOL finished) {
            // 5초 후 사라지게 만들기
            if(finished == YES) {
                [self performSelector:@selector(CSP_disappearMessage) withObject:nil afterDelay:5.0f];
            }
        }];
    });
}





// nami0342 - 애니메이션으로 나왔던 메시지를 사라지게 한다. (만일 2중 애니메이션 처리로 감싸면, 클릭 이벤트를 먹어서 별도로 분리 함)
- (void) CSP_disappearMessage
{
    if(self.m_iType == 1)
    {
        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect lbFrame = _m_btnMessageNLink.frame;
            lbFrame.size.width = 0;

            self.m_btnMessageNLink.frame =  lbFrame;
            
        } completion:^(BOOL finished) {
            if(finished == YES) {
                self.m_isAnimating = NO;
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect lbFrame = _m_btnMessageNLink2.frame;
            lbFrame.size.width = 0;
            self.m_btnMessageNLink2.frame =  lbFrame;
            
        } completion:^(BOOL finished) {
            if(finished == YES) {
                self.m_isAnimating = NO;
            }
        }];
    }
}





- (void)drawRect:(CGRect)rect {
    [btngoTop setFrame:CGRectMake(self.frame.size.width-45-10, self.frame.size.height-45-10, 45, 45)];
    btngoTop.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;

    

    // nami0342 - CSP
    if(self.m_btnCSPIcon.hidden == NO)
    {
        self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
        self.m_btnCSPIcon.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
 
        // nami0342
        if(self.m_iType == 1)
        {
            rect.origin.x = self.m_fXpos;
            rect.origin.y = self.m_btnCSPIcon.frame.origin.y + (self.m_btnCSPIcon.frame.size.height/2 - self.m_btnMessageNLink.frame.size.height/2);
            self.m_btnMessageNLink.frame = rect;
        }
        else if(self.m_iType == 2)
        {
            rect.origin.x = self.m_fXpos;
            rect.origin.y = self.m_btnCSPIcon.frame.origin.y + (self.m_btnCSPIcon.frame.size.height/2 - self.m_btnMessageNLink2.frame.size.height/2);
            self.m_btnMessageNLink2.frame = rect;
        }
        else{
            
        }
    }
}




- (SectionViewType)getSectionViewType {
    return sectionViewType;
}



- (void)toggleSirenButton:(NSNotification *)noti {
    BOOL isHide = NO;
    if([NCS([[noti userInfo] objectForKey:@"isHide"]) isEqualToString:@"YES"]){
        isHide = YES;
    }
    btnSiren.hidden = isHide;
}

- (void)onBtnSiren {
    [delegatetarget touchEventTBCellJustLinkStr:GSSIRENURL];
}

- (void)layoutSubviews {
    if (sectionViewType == SectionViewTypeHome) {
        if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  ) {
            self.tbv.view.frame = CGRectMake(0, self.homeHeaderView.frame.origin.y+40, APPFULLWIDTH, self.frame.size.height-(self.homeHeaderView.frame.origin.y+40));
        }
        else {
            self.tbv.view.frame = self.bounds;
        }
    }
    else if (sectionViewType == SectionViewTypeTVShop) {
        if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTTDCLIST]  ) {
            self.tdcliveTbv.view.frame = self.bounds;
        }
    }
    btngoTop.frame = CGRectMake(self.frame.size.width-45-10, self.frame.size.height-45-10, 45, 45);
    

    // nami0342 - CSP
//    btnSiren.frame = CGRectMake(10, self.frame.size.height-45-10, 45, 45);
    if(self.m_btnCSPIcon.hidden == NO)
    {
        self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
        

        // nami0342
        if(self.m_iType == 1)
        {
            CGRect rect = self.m_btnMessageNLink.frame;
            rect.origin.x = self.m_fXpos;
            rect.origin.y = self.m_btnCSPIcon.frame.origin.y + (self.m_btnCSPIcon.frame.size.height/2 - self.m_btnMessageNLink.frame.size.height/2);
            self.m_btnMessageNLink.frame = rect;
        }
        else if(self.m_iType == 2)
        {
            CGRect rect = self.m_btnMessageNLink2.frame;
            rect.origin.x = self.m_fXpos;
            rect.origin.y = self.m_btnCSPIcon.frame.origin.y + (self.m_btnCSPIcon.frame.size.height/2 - self.m_btnMessageNLink2.frame.size.height/2);
            self.m_btnMessageNLink2.frame = rect;
        }
        else
        {
            
        }
//
//        self.m_btnMessageNLink.titleLabel.numberOfLines = 2;
        
        if(self.m_fXpos != 26)
        {
            // 2줄
          
        }
        else
        {
            // 1줄
            
        }
        
    }

}


- (void)sectiongoTop {
    if(sectionViewType == SectionViewTypeHome) {
        CGPoint offset = self.tbv.tableView.contentOffset;
        offset.y = 0.0f;
        [self.tbv.tableView setContentOffset:offset animated:YES];
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.tbv.tableView];
    }
    else  if (sectionViewType == SectionViewTypeTVShop) {
        CGPoint offset = self.tdcliveTbv.tableView.contentOffset;
        offset.y = 0.0f;
        [self.tdcliveTbv.tableView setContentOffset:offset animated:YES];
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.tdcliveTbv.tableView];
    }
    else if (sectionViewType == SectionViewTypeFlexible || sectionViewType == SectionViewTypeNewEvent) {
        CGPoint offset = self.fxcTbv.tableView.contentOffset;
        offset.y = 0.0f;
        [self.fxcTbv.tableView setContentOffset:offset animated:YES];
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.fxcTbv.tableView];
    }
    else if (sectionViewType == SectionViewTypeNalbang) {
        CGPoint offset = self.nalTbv.tableView.contentOffset;
        offset.y = 0.0f;
        [self.nalTbv.tableView setContentOffset:offset animated:YES];
        
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.nalTbv.tableView];
    }
    else if (sectionViewType == SectionViewTypeShortbang) {
        CGPoint offset = self.nalTbv.tableView.contentOffset;
        offset.y = 0.0f;
        [self.shortTbv.tableView setContentOffset:offset animated:YES];
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.shortTbv.tableView];
    }
    else if (sectionViewType == SectionViewTypeSchedule) {
        //탑버튼은 비노출지만 scrollToTop 이 사용될수 있음으로
        [self.scheduleTbv.tableLeftProduct setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.scheduleTbv.tableLeftProduct];
    }
   
    else if (sectionViewType == SectionViewTypeSUPList) {
        CGPoint offset = self.supTbv.tableView.contentOffset;
        offset.y = 0.0f;
        [self.supTbv.tableView setContentOffset:offset animated:YES];
        [self.supTbv removeFreezPanses];
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.supTbv.tableView];
    }
    else if (sectionViewType == SectionViewTypeVODList) {
        CGPoint offset = self.vodTbv.tableView.contentOffset;
        offset.y = 0.0f;
        [self.vodTbv.tableView setContentOffset:offset animated:YES];
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.vodTbv.tableView];
    }else if (sectionViewType == SectionViewTypeNewFlexible) {
        CGPoint offset = self.nfxcTbv2.tableView.contentOffset;
        offset.y = 0.0f;
        [self.nfxcTbv2.tableView setContentOffset:offset animated:YES];
        [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.nfxcTbv2.tableView];
//        [self.nfxcTbv2 performSelector:@selector(checkFreezePanes) withObject:nil afterDelay:0.5];
    }
    else {
        //다른 타입의 뷰 처리 요망
    }
}

- (void)ProcSyncAfter:(void (^)(void))handler {
    [ApplicationDelegate performSelectorOnMainThread:@selector(onloadingindicator) withObject:nil waitUntilDone:NO];
    NSLog(@"proctm1");
    handler();
}


-(void)sectiongoTopNReload: (NSNotification *)noti {
    sectiongoTopnotinum = [noti object];
    if([sectiongoTopnotinum intValue] == 0) {
        if (sectionViewType == SectionViewTypeHome) {
            CGPoint offset = self.tbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.tbv.tableView setContentOffset:offset animated:NO];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.tbv.tableView];
        }
        else  if (sectionViewType == SectionViewTypeTVShop) {
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.tdcliveTbv.tableView];
            CGPoint offset = self.tdcliveTbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.tdcliveTbv.tableView setContentOffset:offset animated:NO];
        }
        else if (sectionViewType == SectionViewTypeFlexible || sectionViewType == SectionViewTypeNewEvent) {
            CGPoint offset = self.tbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.fxcTbv.tableView setContentOffset:offset animated:NO];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.fxcTbv.tableView];
        }
        else if (sectionViewType == SectionViewTypeSUPList) {
            CGPoint offset = self.supTbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.supTbv.tableView setContentOffset:offset animated:YES];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.supTbv.tableView];
        }
        else if (sectionViewType == SectionViewTypeVODList) {
            CGPoint offset = self.vodTbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.vodTbv.tableView setContentOffset:offset animated:YES];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.vodTbv.tableView];
        }
        else if (sectionViewType == SectionViewTypeNewFlexible) {
            CGPoint offset = self.nfxcTbv2.tableView.contentOffset;
            offset.y = 0.0f;
            [self.nfxcTbv2.tableView setContentOffset:offset animated:YES];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.nfxcTbv2.tableView];
        }
        else {
            //다른 타입의 뷰 처리 요망
        }
    }
    else {
        if (sectionViewType == SectionViewTypeHome) {
            CGPoint offset = self.tbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.tbv.tableView setContentOffset:offset animated:NO];
            [self ScreenReDefine];
        }
        else if (sectionViewType == SectionViewTypeTVShop) {
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.tdcliveTbv.tableView];
            CGPoint offset = self.tdcliveTbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.tdcliveTbv.tableView setContentOffset:offset animated:NO];
            [self ScreenReDefine];
        }
        else if (sectionViewType == SectionViewTypeFlexible || sectionViewType == SectionViewTypeNewEvent) {
            CGPoint offset = self.tbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.fxcTbv.tableView setContentOffset:offset animated:NO];
            [self ScreenReDefine];
        }
        else if (sectionViewType == SectionViewTypeSchedule) {
            [self.scheduleTbv.tableLeftProduct setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
            //[self.scheduleTbv.tableRightTimeLine setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.scheduleTbv.tableLeftProduct];
            [self ScreenReDefine];
        }
        
        else if (sectionViewType == SectionViewTypeSUPList) {
            CGPoint offset = self.supTbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.supTbv.tableView setContentOffset:offset animated:YES];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.supTbv.tableView];
            [self ScreenReDefine];
        }
        else if (sectionViewType == SectionViewTypeVODList) {
            CGPoint offset = self.vodTbv.tableView.contentOffset;
            offset.y = 0.0f;
            [self.vodTbv.tableView setContentOffset:offset animated:YES];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.vodTbv.tableView];
            [self ScreenReDefine];
        }
        else if (sectionViewType == SectionViewTypeNewFlexible) {
            CGPoint offset = self.nfxcTbv2.tableView.contentOffset;
            offset.y = 0.0f;
            [self.nfxcTbv2.tableView setContentOffset:offset animated:YES];
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.nfxcTbv2.tableView];
            [self ScreenReDefine];
        }
        else {
            //다른 타입의 뷰 처리 요망
        }
    }
}

-(NSString *)checkAdidRequest:(NSString *)strRequest{
    
    NSString *strAddAdid = strRequest;
    
    if ([strRequest containsString:@"adid="]) {
        NSString *strADID = [Common_Util getAppleADID];
        NSURLComponents *components = [NSURLComponents componentsWithString:strRequest];
        NSURLQueryItem * newAdidQueryItem = [[NSURLQueryItem alloc] initWithName:@"adid" value:strADID];
        NSMutableArray * newQueryItems = [NSMutableArray arrayWithCapacity:[components.queryItems count] + 1];
        for (NSURLQueryItem * qi in components.queryItems) {
            if (![qi.name isEqual:newAdidQueryItem.name]) {
                [newQueryItems addObject:qi];
            }
        }
        [newQueryItems addObject:newAdidQueryItem];
        [components setQueryItems:newQueryItems];
        strAddAdid = components.string;
        //NSLog(@"strAddAdid = %@",strAddAdid);
    }
    
    return strAddAdid;
}


- (void)ScreenDefine {
    if (sectionViewType == SectionViewTypeHome) {
        [self ScreenDefineHome];
    }
    else if (sectionViewType == SectionViewTypeTVShop) {
        [self ScreenDefineTDCLIST];
    }
    else if (sectionViewType == SectionViewTypeFlexible || sectionViewType == SectionViewTypeNewEvent) {
        [self ScreenDefineFXCLIST];
    }
    else if (sectionViewType == SectionViewTypeNalbang) {
        [self ScreenDefineNTCLIST];
    }
    else if (sectionViewType == SectionViewTypeShortbang) {
        [self ScreenDefineNSTFCLIST];
    }
    else if (sectionViewType == SectionViewTypeSchedule) {
        //매장이 그러지기 전이라면???
        if([NCS(self.tabIdBysubCategoryName) length] <= 0) {
            [self ScreenDefineSLIST];
        }
        else {
            [self loadBroadTypeSLIST:self.tabIdBysubCategoryName];
            self.tabIdBysubCategoryName = @"";
        }
    }
    
    else if (sectionViewType == SectionViewTypeSUPList) {
        [self ScreenDefineSUPLIST];
    }
    else if (sectionViewType == SectionViewTypeVODList) {
        [self ScreenDefineVODLIST];
    }
    else if (sectionViewType == SectionViewTypeNewFlexible) {
        [self ScreenDefineNFXCLIST];
    }
    else {
        //다른 타입의 뷰 처리 요망
    }
}

- (void)ScreenDefineHome {
    //홈메인 듀얼 캐시 삭제
    [self ScreenDefineHomeWith:YES];
}


- (void)ScreenReDefineHome {
    //새로고침 용도
    [self ScreenDefineHomeWith:YES];
}


- (void)ScreenDefineHomeWith:(BOOL)isReDefine {
    
    [ApplicationDelegate onloadingindicator];
    
    if(self.currentOperation1 != nil) {
        [self.currentOperation1 cancel];
        self.currentOperation1 = nil;
    }
    
    NSString* apiURL =  [Mocha_Util strReplace:SERVERURI replace:@"" string:[_sectioninfoDic objectForKey:@"sectionLinkUrl"]];
    
    apiURL =  [Mocha_Util strReplace:@"http://mt.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://tm14.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm20.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://dm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL =  [Mocha_Util strReplace:@"http://sm15.gsshop.com/" replace:@"" string:apiURL];
    
    if ([NCS([_sectioninfoDic objectForKey:@"sectionLinkParams"]) length] > 0) {
        apiURL = [NSString stringWithFormat:@"%@?%@%@%@", apiURL, [_sectioninfoDic objectForKey:@"sectionLinkParams"],@"&reorder=true",ABTESTBULLETVERSTR([DataManager sharedManager].abBulletVer)];
    }
    else {
        apiURL = [NSString stringWithFormat:@"%@?%@%@", apiURL, @"reorder=true",ABTESTBULLETVERSTR([DataManager sharedManager].abBulletVer)];
    }
    
    apiURL = [self checkAdidRequest:apiURL];
    
    
    NSLog(@"secapiUrl %@", apiURL);
#if APPSTORE
#else
    
    // nami0342 - BRD Time 적용
    NSString *strBrdTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_BRD_TIME"];
    if(NCS(strBrdTime).length > 0)
    {
        apiURL = [NSString stringWithFormat:@"%@%@", apiURL, strBrdTime];
    }
    // 치명!!!
    //apiURL = [NSString stringWithFormat:@"%@&openDate=2016070113000000",apiURL];
    
    //apiURL = [NSString stringWithFormat:@"%@&brdTime=2015111419200000",apiURL]; //렌탈 단품
    //apiURL = [NSString stringWithFormat:@"%@&brdTime=2015111209200000",apiURL]; //렌탈 복수
    //apiURL = [NSString stringWithFormat:@"%@&brdTime=2015110717300000",apiURL]; //휴대폰
    //apiURL = [NSString stringWithFormat:@"%@&brdTime=201511112140000",apiURL]; //보험
    //apiURL = [NSString stringWithFormat:@"%@&brdTime=2015111004050000",apiURL]; //공익방송
    //apiURL = [NSString stringWithFormat:@"%@&brdTime=2015110802000000",apiURL]; //여행상품
    //apiURL = [NSString stringWithFormat:@"%@&brdTime=2015111109300000",apiURL]; //80% 이상인것
    
    //apiURL = [NSString stringWithFormat:@"%@&brdTime=2017071909200000",apiURL]; //80% 이상인것
    
    //NSLog(@"apiURLapiURLapiURLapiURLapiURLapiURLapiURL %@", apiURL);
    
    // NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    // [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    //NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    //for (NSHTTPCookie *cookie in gsCookies) {
    //    NSLog(@"coookie5 GSShop cookies  ================== %@ === %@", cookie.name,cookie.value );
    //}
#endif
    
    
    //TV쇼핑에서 라이브 영역 시간이 만료되어.  '하단 홈' 버튼을 클릭한 후 다시 TV쇼핑 매장으로 이동해도. 라이브 영역이 만료된 상태로 나옴.
    //무조건 새로고침 으로 수정2018.09.19 ,더불어 홈도 무조건 새로고침으로 수정 isReDefine = YES
    //2018.10.02 isReDefine 값에따라 로딩 인디케이터를 끄는 부분지 작동안해서 계속 도는 버그 발생함
    //isReDefine = YES ---> 20190130 다시 캐시 적용

    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if ([cookie.name isEqualToString:@"pcid"]){
            NSLog(@"pcidddddcookie.value = %@",cookie.value);
            [[WKManager sharedManager] printCookie];
        }
    }
    
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:apiURL
                                                                         isForceReload:isReDefine
                                                                          onCompletion:^(NSDictionary *result)   {
                                                                              self.homeSectionApiResult = result;
#if APPSTROE
#else
                                                                              //치명
                                                                              //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.38.223:8080/app/main/todayopen?version=4.2&pageIdx=1&pageSize=420&naviId=61"];
                                                                              //
                                                                              //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.38.223:8080/app/main/gsPlanShop?version=4.3&pageIdx=1&pageSize=10&naviId=210"];
                                                                              //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.37.213:9999/app/main/bestdeal?version=4.6&pageIdx=1&pageSize=400&naviId=54"];
                                                                              //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.37.29:8081/app/main/event?version=4.9&pageIdx=1&pageSize=400&naviId=60"];
                                                                              
                                                                              //self.homeSectionApiResult = [self loadTestApiUrl:@"http://10.52.37.213:9999/app/main/bestdeal?version=5.2&pageIdx=1&naviId=54&varnishYn=Y"];

#endif                
       
                                                                              if(self.tbv == nil) {
                                                                                  /* 필터복원 20141208 */
                                                                                  if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST] ) {
                                                                                      self.currentCateinfoindex = 0;
                                                                                      
                                                                                      //서브카테고리뷰
                                                                                      if(self.subcategoryHomeListView != nil) {
                                                                                          [self.subcategoryHomeListView removeFromSuperview];
                                                                                          self.subcategoryHomeListView = nil;
                                                                                      }
                                                                                      
                                                                                      if(!NCO([result objectForKey:@"groupSortFillterInfo"]) && !NCO([[result objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"]) ) {
                                                                                          self.subcategoryHomeListView = [[SubCategoryHomeListView alloc] initWithTarget:self andDic:nil];
                                                                                      }
                                                                                      else {
                                                                                          self.subcategoryHomeListView = [[SubCategoryHomeListView alloc] initWithTarget:self andDic:([(NSDictionary*)[[result objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"] count] > 0)?[[result objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"] :nil];
                                                                                      }
                                                                                      
                                                                                      self.subcategoryHomeListView.frame = CGRectMake(0, -self.subcategoryHomeListView.frame.size.height, APPFULLWIDTH, self.subcategoryHomeListView.frame.size.height);
                                                                                      [self addSubview:self.subcategoryHomeListView];
                                                                                      
                                                                                      self.clipsToBounds = YES;
                                                                                      //필터뷰
                                                                                      if(self.homeHeaderView != nil) {
                                                                                          [self.homeHeaderView removeFromSuperview];
                                                                                          self.homeHeaderView = nil;
                                                                                      }
                                                                                      
                                                                                      
                                                                                      self.homeHeaderView = [self viewhomeheaderView];
                                                                                      [self addSubview:self.homeHeaderView];
                                                                                  }
                                                                                  
                                                                                  
                                                                                  
                                                                                  if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTBCLIST]  ) {
                                                                                      self.tbv = [[BCListTBViewController alloc] initWithSectionResult:self.homeSectionApiResult  sectioninfo:_sectioninfoDic ];
                                                                                  }
                                                                                  else {
                                                                                      self.tbv = [[SectionTBViewController alloc] initWithSectionResult:self.homeSectionApiResult  sectioninfo:_sectioninfoDic ];
                                                                                  }
                                                                                  
                                                                                  
                                                                                  [self.tbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                  
                                                                                  self.tbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                  self.tbv.view.frame = self.bounds;
                                                                                  //상단 로딩바 막자
                                                                                  self.tbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                  
                                                                                  
                                                                                  self.tbv.delegatetarget = (id)self;
                                                                                  self.tbv.tableView.scrollsToTop = NO;
                                                                                  
                                                                                  [self addSubview:self.tbv.view];
                                                                                  if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  ) {
                                                                                      [self bringSubviewToFront:self.subcategoryHomeListView];
                                                                                      [self bringSubviewToFront:self.homeHeaderView];
                                                                                  }
                                                                                  
                                                                                  [self.tbv checkFPCMenu];
                                                                                  
                                                                                  if(!isReDefine) {
                                                                                      //어떤 섹션이든 신규 로딩이 다 불리워지고 tbv가 addsubview 된 후에 scrollstotop 제어
                                                                                      [delegatetarget latelysetscrollstotop];
                                                                                  }
                                                                                  
                                                                              }
                                                                              else {
                                                                                  //새로고침
                                                                                  /* 필터복원 20141208 */
                                                                                  if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  )
                                                                                  {
                                                                                      self.currentCateinfoindex=0;
                                                                                      //서브카테고리뷰
                                                                                      if(self.subcategoryHomeListView != nil){
                                                                                          [self.subcategoryHomeListView removeFromSuperview];
                                                                                          self.subcategoryHomeListView = nil;
                                                                                      }
                                                                                      
                                                                                      if(!NCO([result objectForKey:@"groupSortFillterInfo"]) && !NCO([[result objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"]) ) {
                                                                                          self.subcategoryHomeListView = [[SubCategoryHomeListView alloc] initWithTarget:self andDic:nil];
                                                                                      }
                                                                                      else {
                                                                                          self.subcategoryHomeListView = [[SubCategoryHomeListView alloc] initWithTarget:self andDic:([(NSDictionary*)[[result objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"] count] > 0)?[[result objectForKey:@"groupSortFillterInfo"] objectForKey:@"filterInfo"] :nil];
                                                                                      }
                                                                                      self.subcategoryHomeListView.frame = CGRectMake(0, -self.subcategoryHomeListView.frame.size.height, APPFULLWIDTH, self.subcategoryHomeListView.frame.size.height);
                                                                                      [self addSubview:self.subcategoryHomeListView];
                                                                                      
                                                                                      
                                                                                      //필터뷰
                                                                                      if(self.homeHeaderView != nil){
                                                                                          [self.homeHeaderView removeFromSuperview];
                                                                                          self.homeHeaderView = nil;
                                                                                      }
                                                                                      
                                                                                      
                                                                                      self.homeHeaderView = [self viewhomeheaderView];
                                                                                      [self addSubview:self.homeHeaderView];
                                                                                  }
                                                                                  
                                                                                  self.tbv.apiResultDic = self.homeSectionApiResult;
                                                                                  
                                                                                  if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  )
                                                                                  {
                                                                                      [self bringSubviewToFront:self.subcategoryHomeListView];
                                                                                      [self  bringSubviewToFront:self.homeHeaderView];
                                                                                  }
                                                                                  
                                                                                  [self.tbv reloadAction];
                                                                                  
                                                                                  
                                                                                  
                                                                              }
                                                                              [self  bringSubviewToFront:btngoTop];
                                                                              

                                                                              // nami0342 - CSP
//                                                                              [self  bringSubviewToFront:btnSiren];
                                                                              [self bringSubviewToFront:_m_btnMessageNLink];
                                                                              [self bringSubviewToFront:_m_btnMessageNLink2];
                                                                              [self bringSubviewToFront:_m_btnCSPIcon];

                                                                              //새로고침 버튼이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                              
                                                                              [self.tbv checkFPCMenu];
                                                                              
                                                                              //if(isReDefine ==NO) {
                                                                                  [ApplicationDelegate offloadingindicator];
                                                                              //}
                                                                              
                                                                              // nami0342 - 새로고침 안내화면이 있다면 삭제
                                                                              [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                              
                                                                          }
                              
                              
                                                                               onError:^(NSError* error) {
                                                                                   NSLog(@"COMM ERROR");
                                                                                   
                                                                                   //새로고침실패시 테이블 컨텐츠 제거를 위한
                                                                                   self.tbv.apiResultDic = nil;
                                                                                   
                                                                                   
                                                                                   if(self.tbv == nil){
                                                                                       
                                                                                       /* 필터복원 20141208 */
                                                                                       if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  )
                                                                                       {
                                                                                           //서브카테고리뷰
                                                                                           if(self.subcategoryHomeListView != nil){
                                                                                               [self.subcategoryHomeListView removeFromSuperview];
                                                                                               self.subcategoryHomeListView = nil;
                                                                                           }
                                                                                           self.subcategoryHomeListView = [[SubCategoryHomeListView alloc] initWithTarget:self andDic:nil];
                                                                                           self.subcategoryHomeListView.frame = CGRectMake(0, -self.subcategoryHomeListView.frame.size.height, APPFULLWIDTH, self.subcategoryHomeListView.frame.size.height);
                                                                                           [self addSubview:self.subcategoryHomeListView];
                                                                                           
                                                                                           
                                                                                           //필터뷰
                                                                                           if(self.homeHeaderView != nil){
                                                                                               [self.homeHeaderView removeFromSuperview];
                                                                                               self.homeHeaderView = nil;
                                                                                           }
                                                                                           
                                                                                           
                                                                                           self.homeHeaderView = [self viewhomeheaderView];
                                                                                           [self addSubview:self.homeHeaderView];
                                                                                       }
                                                                                       
                                                                                       
                                                                                       self.tbv = [[SectionTBViewController alloc] initWithSectionResult:nil sectioninfo:_sectioninfoDic ];
                                                                                       
                                                                                       
                                                                                       
                                                                                       [self.tbv.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                                                                                       
                                                                                       self.tbv.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                                                                                       self.tbv.view.frame = self.bounds;
                                                                                       
                                                                                       self.tbv.scrollExpandingDelegate = (id<UIScrollViewDelegate>)delegatetarget;
                                                                                       
                                                                                       self.tbv.delegatetarget = (id)self;
                                                                                       self.tbv.tableView.scrollsToTop = NO;
                                                                                       
                                                                                       [self addSubview:self.tbv.view];
                                                                                       
                                                                                       if ([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  )
                                                                                       {
                                                                                           [self  bringSubviewToFront:self.homeHeaderView];
                                                                                       }
                                                                                       
                                                                                   }else {
                                                                                       //새로고침
                                                                                       [self.tbv reloadAction];
                                                                                       [self  bringSubviewToFront:btngoTop];
                                                                                       

                                                                                       // nami0342 - CSP
                                                                                       // [self  bringSubviewToFront:btnSiren];
                                                                                       [self bringSubviewToFront:_m_btnMessageNLink];
                                                                                       [self bringSubviewToFront:_m_btnMessageNLink2];
                                                                                       [self bringSubviewToFront:_m_btnCSPIcon];

                                                                                   }
                                                                                   
                                                                                   //새로고침 안내화면이 있다면 삭제
                                                                                   [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
                                                                                   
                                                                                   
                                                                                   //실패시 새로고침 안내뷰
                                                                                   [self.tbv.view addSubview:[self RefreshGuideView] ];
                                                                                   
                                                                                   [self.tbv checkFPCMenu];
                                                                                   
                                                                                   
                                                                                   //if(isReDefine ==NO) {
                                                                                       [ApplicationDelegate offloadingindicator];
                                                                                   //}
                                                                               }];
    
}

#pragma mark - Homeheaderfilterview

- (SectionHomeFnSView *)viewhomeheaderView
{
    
    //section 타입별로 헤더뷰생성
    SectionHomeFnSView* tmpheaderview =  [[SectionHomeFnSView alloc] initWithTarget:self];
    tmpheaderview.frame = CGRectMake(0, 0, APPFULLWIDTH, SECTIONSEARCHVIEWHEIGHT);
    return  tmpheaderview;
    
}

- (void)viewheaderFPCTitle:(NSDictionary *)rowinfo andIndex:(NSInteger)index andSubIndex:(NSInteger)subIndex showCrown:(BOOL)isShow {
    NSArray *arrFPC = [rowinfo objectForKey:@"subProductList"];
    NSDictionary *dicRow = [arrFPC objectAtIndex:index];
    
    if (self.headerViewFPC !=nil) {
        [self.headerViewFPC removeFromSuperview];
        self.headerViewFPC = nil;
    }
    
    self.headerViewFPC = [[[NSBundle mainBundle] loadNibNamed:@"SectionFPCHeaderView" owner:self options:nil] firstObject];
    self.headerViewFPC.target = self;
    self.headerViewFPC.frame = CGRectMake(0, -SECTIONFPCVIEWHEIGHT, APPFULLWIDTH, SECTIONFPCVIEWHEIGHT);
    
    if ([NCS([rowinfo objectForKey:@"viewType"]) isEqualToString:@"FPC"] || [NCS([rowinfo objectForKey:@"viewType"]) isEqualToString:@"FPC_P"]) {
        [self.headerViewFPC categorychoiceWithName:[NSString stringWithFormat:@"%@",[dicRow objectForKey:@"promotionName"]] showCrown:isShow];
    }
    else {
        //FPC_S 2016/11 월 추가
        [self.headerViewFPC FPC_SCategorychoiceWithName:NCS([rowinfo objectForKey:@"promotionName"]) showCrown:isShow];
    }
    
    [self addSubview:self.headerViewFPC];
    NSLog(@"headerViewFPCheaderViewFPC = %@",self.headerViewFPC);
    NSLog(@"selfselfself = %@",self);
    
    self.clipsToBounds = YES;    
    if (self.headerViewFPCSub != nil) {
        [self.headerViewFPCSub removeFromSuperview];
        self.headerViewFPCSub = nil;
    }
    
    self.headerViewFPCSub = [[UIView alloc] initWithFrame:CGRectZero];
    self.headerViewFPCSub.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat heightViewDefault = 0.0;
    
    if (self.viewFPC !=nil) {
        [self.viewFPC removeFromSuperview];
        self.viewFPC = nil;
    }
    
    self.viewFPC = [[[NSBundle mainBundle] loadNibNamed:@"SectionFPCtypeSubview" owner:self options:nil] firstObject];
    self.viewFPC.targetFPC = self;
    
    
    if ([NCS([rowinfo objectForKey:@"viewType"]) isEqualToString:@"FPC"] || [NCS([rowinfo objectForKey:@"viewType"]) isEqualToString:@"FPC_P"]) {
        heightViewDefault = kHEIGHTFPC_S * ([arrFPC count]/3 + (([arrFPC count]%3>0)?1.0:0.0));
        self.viewFPC.frame = CGRectMake(10.0, 10.0, APPFULLWIDTH - 20.0,heightViewDefault);
        //[self.viewFPC setCellInfoNDrawData:arrFPC seletedIndex:index];
        [self.viewFPC setCellInfoNDrawData:arrFPC seletedIndex:index andItemViewColorOn:@"A4DE00" andItemViewColorOff:@"F4F4F4" andLineColor:@"FFFFFF"];
        self.headerViewFPCSub.frame = CGRectMake(0.0, -(heightViewDefault +20), APPFULLWIDTH, heightViewDefault +20);
        
    }
    else {
        heightViewDefault = kHEIGHTFPC_S * ([arrFPC count]/3 + (([arrFPC count]%3>0)?1.0:0.0));
        self.viewFPC.frame = CGRectMake(10.0, 10.0, APPFULLWIDTH - 20.0,heightViewDefault);
        [viewFPC setCellInfoNDrawData:arrFPC seletedIndex:index andItemViewColorOn:@"A4DE00" andItemViewColorOff:@"F4F4F4" andLineColor:@"FFFFFF"];
        
        
        BOOL isValidSubSubList = NO;
        NSString *strSubSubText = nil;
        
        //베스트 매장의 대분류 아래의 서브 매장의 데이터와 ,promotionName 텍스트가 유효한지 검증
        if (NCA(arrFPC) && NCO([arrFPC objectAtIndex:index]) && NCA([[arrFPC objectAtIndex:index] objectForKey:@"subProductList"])) {
            NSArray *arrSubSubList = [[arrFPC objectAtIndex:index] objectForKey:@"subProductList"];
            
            if ([arrSubSubList count] > subIndex) {
                
                if (NCO([arrSubSubList objectAtIndex:subIndex]) && [NCS([(NSDictionary *)[arrSubSubList objectAtIndex:subIndex] objectForKey:@"promotionName"]) length] > 0) {
                    
                    strSubSubText = NCS([(NSDictionary *)[arrSubSubList objectAtIndex:subIndex] objectForKey:@"promotionName"]);
                    
                    isValidSubSubList = YES;
                }
            }
            
            
        }
        
        
        if (isValidSubSubList) {
            
            if (self.viewFPC_SubCate != nil) {
                [self.viewFPC_SubCate removeFromSuperview];
                self.viewFPC_SubCate = nil;
            }
            self.viewFPC_SubCate = [[[NSBundle mainBundle] loadNibNamed:@"SectionFPC_SubCategoryView" owner:self options:nil] firstObject];
            
            self.viewFPC_SubCate.frame = CGRectMake(0.0, viewFPC.frame.origin.y + viewFPC.frame.size.height +1.0, APPFULLWIDTH,55.0);
            
            self.viewFPC_SubCate.target = self;
            
            [self.viewFPC_SubCate setCellInfoLabelText:strSubSubText];
            
            self.headerViewFPCSub.frame = CGRectMake(0.0, -(heightViewDefault +20), APPFULLWIDTH, heightViewDefault +20 + 45.0);
            
            [self.headerViewFPCSub addSubview:self.viewFPC_SubCate];
            
        }else{
            
            self.headerViewFPCSub.frame = CGRectMake(0.0, -(heightViewDefault +20), APPFULLWIDTH, heightViewDefault +20);
        }
        
        
    }
    
    
    
    [self.headerViewFPCSub addSubview:viewFPC];
    
    self.headerViewFPCSub.alpha = 0.0f;
    
    [self addSubview:self.headerViewFPCSub];
    
    
}


- (void)viewheaderCX_SLD {
    if (self.headerViewCX_SLD == nil) {
        self.headerViewCX_SLD = [[[NSBundle mainBundle] loadNibNamed:@"SectionCX_SLD_HeaderView" owner:self options:nil] firstObject];
        self.headerViewCX_SLD.frame = CGRectMake(0.0,-SECTIONCX_SLDVIEWHEIGHT, APPFULLWIDTH, SECTIONCX_SLDVIEWHEIGHT);
        [self addSubview:self.headerViewCX_SLD];
        
        //2018.10.26 GS X 브랜드선택시 매장 네비게이션 바 위로 선이 보이는 현상수정
        self.headerViewCX_SLD.hidden = YES;
    }
}

- (void)viewheaderCX_CATE {
    if (self.headerViewCX_CATE == nil) {
        self.headerViewCX_CATE = [[[NSBundle mainBundle] loadNibNamed:@"SectionCX_CATE_HeaderView" owner:self options:nil] firstObject];
        self.headerViewCX_CATE.frame = CGRectMake(0.0,-CX_CATE_HEIGHT, APPFULLWIDTH, CX_CATE_HEIGHT);
        [self addSubview:self.headerViewCX_CATE];
    }
}

-(UIView*)RefreshGuideView {
    
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    [containView setCenter:CGPointMake(self.center.x, self.center.y + 50)];
    containView.backgroundColor= [UIColor clearColor];
    containView.tag = TBREFRESHBTNVIEW_TAG;
    //새로고침아이콘
    UIImageView* loadingimgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Network_error_icon.png"]];
    [loadingimgView setFrame:CGRectMake(150-37, 40, 75, 88)];
    [containView addSubview:loadingimgView];


    UILabel* gmentLabel = [[UILabel alloc] init];
    gmentLabel.text = [NSString stringWithFormat:@"%@", @"데이터 연결이 원활하지 않습니다."];
    gmentLabel.textAlignment = NSTextAlignmentCenter;
    gmentLabel.font = [UIFont boldSystemFontOfSize:17];
    gmentLabel.backgroundColor = [UIColor clearColor];
    gmentLabel.textColor = [[Mocha_Util getColor:@"111111"] colorWithAlphaComponent:0.64] ;
    gmentLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [gmentLabel setFrame:CGRectMake(25, 147, 250, 24)];
    [containView addSubview:gmentLabel];
    UILabel* gmentLabel1 = [[UILabel alloc] init];
    gmentLabel1.text = [NSString stringWithFormat:@"%@", @"잠시 후 다시 시도해 주시기 바랍니다."];
    gmentLabel1.textAlignment = NSTextAlignmentCenter;
    gmentLabel1.font = [UIFont boldSystemFontOfSize:14];
    gmentLabel1.backgroundColor = [UIColor clearColor];
    gmentLabel1.textColor = [[Mocha_Util getColor:@"111111"] colorWithAlphaComponent:0.48] ;
    gmentLabel1.lineBreakMode = NSLineBreakByTruncatingTail;

    [gmentLabel1 setFrame:CGRectMake(25, 175, 250, 20)];
    [containView addSubview:gmentLabel1];
    
    //새로고침 버튼
    UIButton* cbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn1 setFrame:CGRectMake(containView.frame.size.width/2 - 85,205,70,32)];
    [cbtn1 addTarget:self action:@selector(ActionBtnContentRefresh:) forControlEvents:UIControlEventTouchUpInside];
    cbtn1.backgroundColor = [UIColor whiteColor];
    [cbtn1 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateNormal];
    [cbtn1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateNormal];
    [cbtn1 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateHighlighted];
    [cbtn1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateHighlighted];
    cbtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    cbtn1.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    cbtn1.layer.cornerRadius = 4.0f;
    [cbtn1.layer setMasksToBounds:NO];
    cbtn1.layer.shadowOffset = CGSizeMake(0, 0);
    cbtn1.layer.shadowRadius = 0.0;
    cbtn1.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    cbtn1.layer.borderWidth = 1;
    cbtn1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    cbtn1.tag = 1;
    [containView addSubview:cbtn1];
    
    // nami0342 - [웹으로 보기] 버튼 추가
    UIButton* cbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn2 setFrame:CGRectMake(containView.frame.size.width/2 -7,205,85,32)];
    [cbtn2 addTarget:self action:@selector(ActionBtnContentRefresh:) forControlEvents:UIControlEventTouchUpInside];
    cbtn2.backgroundColor = [UIColor whiteColor];
    [cbtn2 setTitle:GSSLocalizedString(@"View_on_the_web_text")  forState:UIControlStateNormal];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateNormal];
    [cbtn2 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateHighlighted];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateHighlighted];
    cbtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    cbtn2.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    cbtn2.layer.cornerRadius = 4.0f;

    [cbtn2.layer setMasksToBounds:NO];
    cbtn2.layer.shadowOffset = CGSizeMake(0, 0);
    cbtn2.layer.shadowRadius = 0.0;
    cbtn2.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    cbtn2.layer.borderWidth = 1;
    cbtn2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    cbtn2.tag = 2;
    [containView addSubview:cbtn2];
    
    return containView;
}

//버튼 전용
-(void)ActionBtnContentRefresh:(id)sender {
    [ApplicationDelegate onloadingindicator];
    
    if(sender == nil)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *btnTemp = (UIButton *)sender;
        
        if(btnTemp.tag == 1)
        {
            [[self viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
            [self tablereloadAction];
            [self  bringSubviewToFront:btngoTop];
            
            
            // nami0342 - CSP
            // [self  bringSubviewToFront:btnSiren];
            [self bringSubviewToFront:_m_btnMessageNLink];
            [self bringSubviewToFront:_m_btnMessageNLink2];
            [self bringSubviewToFront:_m_btnCSPIcon];
        }
        else if(btnTemp.tag == 2)
        {
            
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
    });
    
    
    

}

- (void)showDidMain1 {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showDidMain2)];
    self.tbv.view.transform = CGAffineTransformMakeTranslation(-30.0f, 0.0f);
    [UIView commitAnimations];
}

- (void)showDidMain2 {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    self.tbv.view.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
    [UIView commitAnimations];
}

- (void)ScreenReDefine {
    if (sectionViewType == SectionViewTypeHome) {
        [self ScreenReDefineHome];
    }
    else if (sectionViewType == SectionViewTypeTVShop) {
        [self ScreenReDefineTDCLIST];
    }
    else if (sectionViewType == SectionViewTypeFlexible || sectionViewType == SectionViewTypeNewEvent) {
        [self ScreenReDefineFXCLIST];
    }
    else if (sectionViewType == SectionViewTypeNalbang) {
        [self ScreenReDefineNTCLIST];
    }
    else if (sectionViewType == SectionViewTypeShortbang) {
        [self ScreenReDefineNSTFCLIST];
    }
    else if (sectionViewType == SectionViewTypeSchedule) {
        // 현재 라이브인지 데이터인지 뭔지 판단한다.
        if(self.scheduleTbv != nil) {
            //현재 화면 유지
            [self loadBroadTypeSLIST:self.scheduleTbv.strBrdType];
        }
        else {
            [self ScreenReDefineSLIST];
        }
    }
    else if (sectionViewType == SectionViewTypeSUPList) {
        [self ScreenReDefineSUPLIST];
    }
    else if (sectionViewType == SectionViewTypeVODList) {
        [self ScreenReDefineVODLIST];
    }
    else if (sectionViewType == SectionViewTypeNewFlexible) {
        [self ScreenReDefineNFXCLIST];
    }
    else {
        //다른 타입의 뷰 처리 요망
    }
}

//베스트딜 하단 핫링크용
-(void)TopCategoryTabButtonClicked:(id)sender {
    [delegatetarget TopCategoryTabButtonClicked:sender ];
}


- (void)touchEventTBCell:(NSDictionary *)dic {
    [delegatetarget touchEventTBCell:dic];
}

- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr {
    [delegatetarget touchEventTBCellJustLinkStr:linkstr];
}

- (void)touchEventBannerCell:(NSDictionary *)dic {
    [delegatetarget touchEventBannerCell:dic];
}

- (void)touchEventShortBang:(NSDictionary *)dic index:(NSInteger)index indexCate:(NSInteger)indexCate arrShortBangAll:(NSArray*)arrSB imageRect:(CGRect)imageRect backGroundImage:(UIImage *)image apiString:(NSString *)strApi {
    [delegatetarget touchEventShortBang:dic index:index indexCate:indexCate arrShortBangAll:arrSB imageRect:imageRect backGroundImage:image apiString:strApi];
}


- (void)tablereloadAction {
    [self ScreenReDefine];
}

- (void)btntouchAction:(id)sender {
    [delegatetarget btntouchAction:sender];
}

- (void)btntouchWithDicAction:(NSDictionary*)tdic tagint:(int)tint {
    [delegatetarget btntouchWithDicAction:tdic tagint:tint];
}

//GroupSection셀이 눌렸을 때, GroupSection셀 내부의 버튼이 눌렸을 때 호출됨
- (void)touchEventGroupTBCellWithRowInfo:(NSDictionary *)rowInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender {
    [delegatetarget touchEventGroupTBCellWithRowInfo:rowInfoDic sectionInfo:sectionInfoDic sender:sender];
}

//GroupSection 서브 카테고리 버튼, 상단 배너 버튼 눌렸을 때 호출됨. (하단 footer의 로그인 버튼 등은 기존 Section(Home) 방식으로 상속 처리)
- (void)btntouchGroupTBWithApiInfo:(NSDictionary *)apiInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender {
    [delegatetarget btntouchGroupTBWithApiInfo:apiInfoDic sectionInfo:sectionInfoDic sender:(id)sender];
}








#pragma mark - Filter N Order

- (void)HomeSubcategoryOpenButtonClicked:(id)sender {
    BOOL selstate =  ((UIButton*)sender).selected;
    if(selstate) {
        if(self.bg_section_mask != nil){
            [self.bg_section_mask removeFromSuperview];
            self.bg_section_mask = nil;
        }
        //노출
        self.bg_section_mask = [[UIView alloc] initWithFrame:CGRectMake(0,  SECTIONSEARCHVIEWHEIGHT, APPFULLWIDTH, APPFULLHEIGHT)];
        [self.bg_section_mask.layer setMasksToBounds:NO];
        self.bg_section_mask.layer.backgroundColor = [UIColor blackColor].CGColor;
        self.bg_section_mask.layer.opacity = 0.5;
        self.bg_section_mask.userInteractionEnabled = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
        [self.bg_section_mask addSubview:button];
        [button addTarget:self action:@selector(HomeGrvclose) forControlEvents:UIControlEventTouchUpInside];
        button.tag = SECTION_SUBCATEGORY_OPEN_BUTTON_TAG;
        [self addSubview:self.bg_section_mask];
        [self HomeDisplaysubCategoryView:YES];
    }
    else {
        [self HomeDisplaysubCategoryView:NO];
    }
}




- (void)HomeGrvclose {
    //닫기
    [self.homeHeaderView catevClose];
    [self HomeDisplaysubCategoryView:NO];
}


- (void)HomeDisplaysubCategoryView:(BOOL)disp {
    if(disp) {
        [self bringSubviewToFront:self.subcategoryHomeListView];
        [self bringSubviewToFront:self.homeHeaderView];
        self.subcategoryHomeListView.alpha = 0.0f;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.subcategoryHomeListView.alpha = 1.0f;
                             self.subcategoryHomeListView.frame = CGRectMake(0, SECTIONSEARCHVIEWHEIGHT, APPFULLWIDTH, self.subcategoryHomeListView.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             [self bringSubviewToFront:self.subcategoryHomeListView];
                         }];
    }
    else {
        //닫기
        if(self.bg_section_mask != nil){
            [self.bg_section_mask removeFromSuperview];
            self.bg_section_mask = nil;
        }
        self.subcategoryHomeListView.alpha = 1.0f;
        [self bringSubviewToFront:self.homeHeaderView];
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.subcategoryHomeListView.alpha = 0.0f;
                             self.subcategoryHomeListView.frame = CGRectMake(0, -self.subcategoryHomeListView.frame.size.height, APPFULLWIDTH, self.subcategoryHomeListView.frame.size.height   );
                         }
                         completion:^(BOOL finished){
                         }];
    }
}


#pragma mark - Filter N Order Best FPC Type

- (void)FPCDisplayView:(BOOL)disp {
    if(disp) {
        if (self.headerViewFPC.frame.origin.y == 0.0) {
            return;
        }
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.headerViewFPC.frame = CGRectMake(0, 0, APPFULLWIDTH, self.headerViewFPC.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                             [self bringSubviewToFront:self.headerViewFPC];
                         }];
    }
    else {
        if(self.headerViewFPC.frame.origin.y == -self.headerViewFPC.frame.size.height) {
            return;
        }
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.headerViewFPC.frame = CGRectMake(0, -self.headerViewFPC.frame.size.height, APPFULLWIDTH, self.headerViewFPC.frame.size.height   );
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)CX_SLDDisplayView:(BOOL)disp cateView:(SectionBAN_CX_SLD_CATE_GBASubView*)viewCX_SLD_CATE {
    if(disp) {
        if (self.headerViewCX_SLD.frame.origin.y == 0.0) {
            return;
        }
        
        //2018.10.26 GS X 브랜드선택시 매장 네비게이션 바 위로 선이 보이는 현상수정
        self.headerViewCX_SLD.hidden = NO;
        
        self.headerViewCX_SLD.frame = CGRectMake(0, 0, APPFULLWIDTH, self.headerViewCX_SLD.frame.size.height);
        [self.headerViewCX_SLD addSubview:viewCX_SLD_CATE];
        
    }
    else {
        if(self.headerViewCX_SLD.frame.origin.y == -self.headerViewCX_SLD.frame.size.height) {
            return;
        }
        
        //2018.10.26 GS X 브랜드선택시 매장 네비게이션 바 위로 선이 보이는 현상수정
        self.headerViewCX_SLD.hidden = YES;
        self.headerViewCX_SLD.frame = CGRectMake(0, -self.headerViewCX_SLD.frame.size.height, APPFULLWIDTH, self.headerViewCX_SLD.frame.size.height   );
    }
}

// 싱글타입 틀고정 탭
- (void)CX_CATEDisplayView:(BOOL)disp cateView:(SectionBAN_CX_CATE_GBASubView*)viewCX_CATE {
    if(disp) {
        if (self.headerViewCX_CATE.frame.origin.y == 0.0) {
            return;
        }
        self.headerViewCX_CATE.frame = CGRectMake(0, 0, APPFULLWIDTH, self.headerViewCX_CATE.frame.size.height);
       
        [self.headerViewCX_CATE addSubview:viewCX_CATE];
    }
    else {
        if(self.headerViewCX_CATE.frame.origin.y == -self.headerViewCX_CATE.frame.size.height) {
            return;
        }
        self.headerViewCX_CATE.frame = CGRectMake(0, -self.headerViewCX_CATE.frame.size.height, APPFULLWIDTH, self.headerViewCX_CATE.frame.size.height);
    }
}


- (void)FPCCategoryOpenButtonClicked:(id)sender {
    BOOL selstate =  ((UIButton*)sender).selected;
    if(selstate) {
        if(self.bg_section_mask != nil) {
            [self.bg_section_mask removeFromSuperview];
            self.bg_section_mask = nil;
        }
        //노출
        self.bg_section_mask = [[UIView alloc] initWithFrame:CGRectMake(0,  SECTIONFPCVIEWHEIGHT, APPFULLWIDTH, APPFULLHEIGHT)];
        [self.bg_section_mask.layer setMasksToBounds:NO];
        self.bg_section_mask.layer.backgroundColor = [UIColor blackColor].CGColor;
        self.bg_section_mask.layer.opacity = 0.6;
        self.bg_section_mask.userInteractionEnabled = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
        [self.bg_section_mask addSubview:button];
        [button addTarget:self action:@selector(FPCGrvclose) forControlEvents:UIControlEventTouchUpInside];
        button.tag = SECTION_SUBCATEGORY_OPEN_BUTTON_TAG;
        [self addSubview:self.bg_section_mask];
        [self FPCDisplayCategoryView:YES];
    }
    else {
        [self FPCDisplayCategoryView:NO];
    }
}




- (void)FPCGrvclose {
    //닫기
    [self.headerViewFPC catevClose];
    [self FPCDisplayCategoryView:NO];
}



- (void)FPCDisplayCategoryView:(BOOL)disp {
    if(disp) {
        [self bringSubviewToFront:self.headerViewFPCSub];
        [self bringSubviewToFront:self.headerViewFPC];
        self.headerViewFPCSub.alpha = 0.0f;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.headerViewFPCSub.alpha = 1.0f;
                             self.headerViewFPCSub.frame = CGRectMake(0, SECTIONFPCVIEWHEIGHT, APPFULLWIDTH, self.headerViewFPCSub.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [self bringSubviewToFront:self.headerViewFPCSub];
                         }];
    }
    else {
        //닫기
        if(self.bg_section_mask != nil) {
            [self.bg_section_mask removeFromSuperview];
            self.bg_section_mask = nil;
        }
        
        self.headerViewFPCSub.alpha = 1.0f;
        [self bringSubviewToFront:self.headerViewFPC];
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.headerViewFPCSub.alpha = 0.0f;
                             self.headerViewFPCSub.frame = CGRectMake(0, -self.headerViewFPCSub.frame.size.height, APPFULLWIDTH, self.headerViewFPCSub.frame.size.height   );
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

- (void)FPCDisplaySubCategoryView:(BOOL)disp andCateHeaderShow:(BOOL)isHeaderShow {
    if (viewBestSubCate == nil) {
        viewBestSubCate = [[[NSBundle mainBundle] loadNibNamed:@"SectionBestSubCate" owner:self options:nil] firstObject];
        viewBestSubCate.target = self;
    }
    if(disp == YES) {
        if (self.fxcTbv !=nil) {
            [self.fxcTbv setFPCSubCateView:viewBestSubCate];
        }
        else if (self.tbv != nil) {
            [self.fxcTbv setFPCSubCateView:viewBestSubCate];
        }
        
        [ApplicationDelegate.window addSubview:viewBestSubCate];
        [viewBestSubCate bestSubCateShow:YES andCateHeaderShow:YES];
    }
    else {
        [viewBestSubCate removeFromSuperview];
        viewBestSubCate = nil;
        if (isHeaderShow == NO) {
            [self FPCDisplayCategoryView:NO];
        }
    }
}

- (void)onBtnCateTag:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic {
    [self FPCGrvclose];
    NSLog(@"self.tbvself.tbv = %@",self.tbv);
    NSLog(@"self.fxcTbv = %@",self.fxcTbv);
    NSLog(@"delegatetarget = %@",delegatetarget);
    if (self.fxcTbv !=nil) {
        [self.fxcTbv onBtnFPCCate:dic andCnum:[NSNumber numberWithInt:(int)btnTag] withCallType:@"FPC_HEADER"];
    }
    else if (self.tbv != nil){
        [self.tbv onBtnFPCCate:dic andCnum:[NSNumber numberWithInt:(int)btnTag] withCallType:@"FPC_HEADER"];
    }
}


- (void)onBtnCateSub:(NSInteger)subIndex withInfoDic:(NSDictionary *)dic {
    if (self.fxcTbv !=nil) {
        [self.fxcTbv onBtnFPCCateSub:dic andCnum:[NSNumber numberWithInt:(int)subIndex] withCallType:@"FPC_HEADER_SUB"];
    }
    else if (self.tbv != nil) {
        [self.tbv onBtnFPCCateSub:dic andCnum:[NSNumber numberWithInt:(int)subIndex] withCallType:@"FPC_HEADER_SUB"];
    }
}


//btnTop 알파교정
- (void)setbtnTopDisplayed:(BOOL)displayed animated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    if( [NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTTCLIST] ) {
        BOOL animationsEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:animated];
        [UIView animateWithDuration:0.3f
                              delay:delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.btngoTop.alpha = displayed ? 1.0f : 0.0f;
                         } completion:^(BOOL finished) {
                             if (finished) {
                             }
                         }];
        [UIView setAnimationsEnabled:animationsEnabled];
    }
}



//홈전용 - 서브카테고리 선택
- (void)FILTERACTIONHOMECATEGORYSELECT:(NSString*)catename  andtag:(NSInteger)index {
    if([NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTFCLIST]  ) {
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:[NSString stringWithFormat:@"MC_%@_Tab",[_sectioninfoDic objectForKey:@"sectionName"]] withLabel:catename ];
        
    }
    [self HomeGrvclose];
    self.currentCateinfoindex=index;
    //홈= ordering 없으므로 POP
    self.currentOrderinfoindex = GROUP_FILTER_ORDER_POPBTN_TAG;
    [self.homeHeaderView categorychoiceWithName:catename withCount:nil];
    [self.tbv filteredApiResultDicforHome:index  ];
}



- (void)alphaDownTopButton {
    if (isBtnAlphaZero == YES) {
        return;
    }
    else {
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             btngoTop.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             isBtnAlphaZero = YES;
                         }];
    }
}

- (void)alphaUpTopButton {
    if (isBtnAlphaZero == NO) {
        return;
    }
    else {
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             btngoTop.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             
                             isBtnAlphaZero = NO;
                         }];
    }
}



- (void)SectionViewDisappear {
    if(sectionViewType == SectionViewTypeHome) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             [self HomeGrvclose];
                         }
                         completion:^(BOOL finished){
                         }];
    }
}



- (void)SectionViewAppear {
    if (sectionViewType == SectionViewTypeHome) {
        //2020.08.06 impression 효율추가
        [self.tbv reCheckPRD_C_SQ];
        
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.homeHeaderView.frame = CGRectMake(0, 0, APPFULLWIDTH, 40);
                             btngoTop.frame = CGRectMake(self.frame.size.width-45-10, self.frame.size.height-45-10, 45, 45);
                             

                             
                             // nami0342 - CSP
                             //    btnSiren.frame = CGRectMake(10, self.frame.size.height-45-10, 45, 45);
                             if(self.m_btnCSPIcon.hidden == NO)
                             {
                                 if(self.m_iType == 1)
                                 {
                                     self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
                                     CGRect rect = self.m_btnMessageNLink.frame;
                                     rect.origin.x = 226;
                                     rect.origin.y = self.frame.size.height - 65 + 6;
                                     self.m_btnMessageNLink.frame = rect;
                                 }
                                 else if (self.m_iType == 2)
                                 {
                                     self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height - 65 -10, 65, 65);
                                     CGRect rect = self.m_btnMessageNLink2.frame;
                                     rect.origin.x = rect.origin.x + rect.size.width + 10;
                                     rect.origin.y = self.frame.size.height - 65 + 6;
                                     self.m_btnMessageNLink2.frame = rect;
                                 }
                                 else
                                 {
                                     
                                 }
                             }

                             /*
                             //tv방송종료확인 새로고침
                             if( [NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTTCLIST] ){
                                 [self.tbv refreshCheckNDrawTVC];
                             }
                              */
                         }
                         completion:^(BOOL finished){
                         }];
    }
    else if (sectionViewType == SectionViewTypeTVShop) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             btngoTop.frame = CGRectMake(self.frame.size.width-45-10, self.frame.size.height-45-10, 45, 45);


                             // nami0342 - CSP
                             //    btnSiren.frame = CGRectMake(10, self.frame.size.height-45-10, 45, 45);
                             if(self.m_btnCSPIcon.hidden == NO)
                             {
                                 if(self.m_iType == 1)
                                 {
                                     self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
                                     CGRect rect = self.m_btnMessageNLink.frame;
                                     rect.origin.x = 226;
                                     rect.origin.y = self.frame.size.height - 65 + 6;
                                     self.m_btnMessageNLink.frame = rect;
                                 }
                                 else if(self.m_iType == 2)
                                 {
                                     self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
                                     CGRect rect = self.m_btnMessageNLink2.frame;
                                     rect.origin.x = rect.origin.x + rect.size.width + 10;
                                     rect.origin.y = self.frame.size.height - 65 + 6;
                                     self.m_btnMessageNLink2.frame = rect;
                                 }
                                 else{
                                     
                                 }
                             }

                             /*
                             //tv방송종료확인 새로고침
                             if( [NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTTDCLIST] ) {
                                 [self.tdcliveTbv refreshCheckNDrawTVC];
                             }
                              */
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    else if (sectionViewType == SectionViewTypeNewFlexible) {
//        [self.nfxcTbv performSelector:@selector(checkTableViewAppear) withObject:nil afterDelay:0.5];
        [self.nfxcTbv2 performSelector:@selector(checkTableViewAppear) withObject:nil afterDelay:0.5];
    }
    else if (sectionViewType == SectionViewTypeSUPList) {
        [self.supTbv performSelector:@selector(checkTableViewAppear) withObject:nil afterDelay:0.5];
    }
    else if (sectionViewType == SectionViewTypeVODList) {
        [self.vodTbv performSelector:@selector(checkTableViewAppear) withObject:nil afterDelay:0.5];
    }
    
}

//20180622 parksegun 탭이동시 서브 카테가 있는 경우에만 동작한다.
- (void)SectionViewAppear:(NSString *) subCate {
    
    // nami0342 - 데이터 재연결 화면일 경우 처리 
    if ([self viewWithTag:TBREFRESHBTNVIEW_TAG] != nil)
    {
        [self ScreenReDefine];
    }
    
    
    if (sectionViewType == SectionViewTypeHome) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.homeHeaderView.frame = CGRectMake(0, 0, APPFULLWIDTH, 40);
                             btngoTop.frame = CGRectMake(self.frame.size.width-45-10, self.frame.size.height-45-10, 45, 45);
                             

                             // nami0342 - CSP
                             //    btnSiren.frame = CGRectMake(10, self.frame.size.height-45-10, 45, 45);
                             if(self.m_btnCSPIcon.hidden == NO)
                             {
                                 if(self.m_iType == 1)
                                 {
                                     self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
                                     CGRect rect = self.m_btnMessageNLink.frame;
                                     rect.origin.x = 226;
                                     rect.origin.y = self.frame.size.height - 65 + 6;
                                     self.m_btnMessageNLink.frame = rect;
                                 }
                                 else if (self.m_iType ==2)
                                 {
                                     self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
                                     CGRect rect = self.m_btnMessageNLink2.frame;
                                     rect.origin.x = rect.origin.x + rect.size.width + 10;
                                     rect.origin.y = self.frame.size.height - 65 + 6;
                                     self.m_btnMessageNLink2.frame = rect;
                                 }
                                 else{
                                     
                                 }
                             }

                             /*
                             //tv방송종료확인 새로고침
                             if( [NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTTCLIST] ){
                                 [self.tbv refreshCheckNDrawTVC];
                             }
                              */
                         }
                         completion:^(BOOL finished){
                         }];
    }
    else if (sectionViewType == SectionViewTypeTVShop) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             btngoTop.frame = CGRectMake(self.frame.size.width-45-10, self.frame.size.height-45-10, 45, 45);
                             

                             // nami0342 - CSP
                             //    btnSiren.frame = CGRectMake(10, self.frame.size.height-45-10, 45, 45);
                             if(self.m_btnCSPIcon.hidden == NO)
                             {
                                 if(self.m_iType == 1)
                                 {
                                     self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
                                     CGRect rect = self.m_btnMessageNLink.frame;
                                     rect.origin.x = 226;
                                     rect.origin.y = self.frame.size.height - 65 + 6;
                                     self.m_btnMessageNLink.frame = rect;
                                 }
                                 else if(self.m_iType == 2)
                                 {
                                     self.m_btnCSPIcon.frame = CGRectMake(1, self.frame.size.height- 65 - 10, 65, 65); // !!!!!
                                     CGRect rect = self.m_btnMessageNLink2.frame;
                                     rect.origin.x = rect.origin.x + rect.size.width + 10;
                                     rect.origin.y = self.frame.size.height - 65 + 6;
                                     self.m_btnMessageNLink2.frame = rect;
                                    }
                                 else{
                                     
                                 }
                             }
                             

                             /*
                             //tv방송종료확인 새로고침
                             if( [NCS([_sectioninfoDic objectForKey:@"viewType"]) isEqualToString:HOMESECTTDCLIST] ) {
                                 [self.tdcliveTbv refreshCheckNDrawTVC];
                             }
                              */
                         }
                         completion:^(BOOL finished) {
                         }];
    }//편성표일때 예외추가
    
    else if (sectionViewType == SectionViewTypeSchedule) {
        // 새로고침? 생방송 이동? 판단 필요.
        if(![[self.scheduleTbv strBrdType] isEqualToString:subCate]) {
            [delegatetarget performSelector:@selector(scrollViewShouldScrollToTop:) withObject:self.scheduleTbv.tableLeftProduct];
            [self loadBroadTypeSLIST:subCate];
        }
        else {
        }
    }
}

- (void)customscrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < scrollView.frame.size.height) {
        [self alphaDownTopButton];
    }
    else {
        [self alphaUpTopButton];
    }
}

- (void)customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)customscrollViewDidEndDecelerating:(UIScrollView*)scrollView {

}

- (NSDictionary *)loadTestApiUrl:(NSString *)strUrl {
    NSURL *turl = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
    [urlRequest setHTTPMethod:@"GET"];
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSError *error;
    NSURLResponse *response;
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:30 error:&error];
    return [result JSONtoValue];
}


@end
