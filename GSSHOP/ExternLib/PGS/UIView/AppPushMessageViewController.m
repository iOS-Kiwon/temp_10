#import "AppPushMessageViewController.h"
#import "AppPushNetworkUtility.h"
#import "AmailJSON.h"
#import "AppPushUtil.h"
#import "AppPushConstants.h"
#import "AmailPopUpView.h"
#define BUBBLE_CUR_PAGE_COUNT           1
#define BUBBLE_PAGE_ROW_COUNT           20

#import "ViewPMSHeader.h"
#import "AppDelegate.h"
#import "DataManager.h"


@implementation AppPushMessageViewController
@synthesize delegate;

#pragma mark - cyclelife
- (void)dealloc {
    msg_tableView =nil;
    
    // nami0342
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        [self viewInitalization];
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageViewController viewDidLoad : %@", exception);
    }
}
//- (void)viewDidUnload {
//    @try {
//        [super viewDidUnload];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_DEF_NOTI_SET_THEME object:nil];
//    } @catch (NSException *exception) {
//        NSLog(@"PMS Exception at AppPushMessageViewController viewDidUnload : %@", exception);
//    }
//}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    @try {
        
        //temp
        /*
         NSMutableArray *arrTemp = [NSMutableArray array];
         
         [arrTemp addObject:[NSDictionary dictionaryWithObjectsAndKeys:
         @"음하핳하하 동해물과 백두산이 룰럴룰럴~",AMAIL_MSG_MSG,
         @"00000",AMAIL_MSG_MSG_CODE,
         @"A",AMAIL_MSG_MSG_TYPE,
         @"음하핳하하 동해물과 백두산이 룰럴룰럴~",AMAIL_MSG_ATTACH_INFO,
         @"Y",AMAIL_MSG_READ_YN,
         @"20130101165500",AMAIL_MSG_REG_DATE,
         nil]];
         
         [arrTemp addObject:[NSDictionary dictionaryWithObjectsAndKeys:
         @"음하핳하하 동해물과 백두산이 룰럴룰럴~음하핳하하 동해물과 백두산이 룰럴룰럴~음하핳하하 동해물과 백두산이 룰럴룰럴~",AMAIL_MSG_MSG,
         @"00000",AMAIL_MSG_MSG_CODE,
         @"A",AMAIL_MSG_MSG_TYPE,
         @"음하핳하하 동해물과 백두산이 룰럴룰럴~",AMAIL_MSG_ATTACH_INFO,
         @"N",AMAIL_MSG_READ_YN,
         @"20130104165500",AMAIL_MSG_REG_DATE,
         nil]];
         
         [msg_tableView addTableList:arrTemp];
         */
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageViewController viewDidAppear : %@", exception);
    }
    
}
- (BOOL)shouldAutorotate {
    return NO;
}


#pragma mark - Inner Method
- (void)viewInitalization {
    @try {
        //초기값 설정
        msg_tableView = [[AppPushMessageTableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                  0.0f,
                                                                                  self.view.frame.size.width,
                                                                                  self.view.frame.size.height)
                                                                 style:UITableViewStylePlain];
        msg_tableView.bounces = NO;
        msg_tableView.delegateList = self;
        [self.view addSubview:msg_tableView];
        
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageViewController viewInitalization : %@", exception);
    }
}

- (BOOL)loadMsgView:(NSString *)argMsgId {
    @try {
        
        if(argMsgId==nil) {
            //nil이면 신규 메시지 호출이라고 친다.
            [msg_tableView removeTableList];
        }
        
        return [self loadMessage:argMsgId];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageViewController loadMsgView : %@", exception);
        return NO;
    }
}

- (void)setViewFrame {
    @try {
        
        
        
        [msg_tableView setFrame:CGRectMake(0.0f,
                                           0.0f,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height )];
        
        ViewPMSHeader *pmsHeader = [[[NSBundle mainBundle] loadNibNamed:@"ViewPMSHeader" owner:self options:nil] firstObject];
        pmsHeader.delegate = self;
        
        //사이드 매뉴용 네비게이션 , 카테고리 호출
        ApplicationDelegate.currentOperation1 = [ApplicationDelegate.gshop_http_core gsMyShopRealMemberCustNo:NCS([[DataManager sharedManager] customerNo]) isForceReload:YES
                                                                            onCompletion:^(NSDictionary *result)   {
                                                                                
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    NSLog(@"resultresultresultresult = %@",result);
                                                                                    
                                                                                    if (result != nil &&
                                                                                        [result isKindOfClass:[NSDictionary class]] &&
                                                                                        [NCS([result objectForKey:@"custWelcome"]) length] > 0 ) {
                                                                                        [pmsHeader setCellInfo:result];
                                                                                        [msg_tableView setTableHeaderView:pmsHeader];
                                                                                        [msg_tableView reloadData];
                                                                                        
                                                                                    }else{
                                                                                        
                                                                                        [msg_tableView setTableHeaderView:nil];
                                                                                        [msg_tableView reloadData];
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                });
                                                                                
                                                                                
                                                                                
                                                                            }
                                  
                                  
                                                                                 onError:^(NSError* error) {
                                                                                     [msg_tableView setTableHeaderView:nil];
                                                                                     [msg_tableView reloadData];
                                                                                 }];

        
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageViewController setViewFrame : %@", exception);
    }
}

#pragma mark - msg data method

- (BOOL)loadMessage:(NSString *)argMsgId {
    @try {
        //argMsgId값이 있으면 그 값보다 작은(=등록일자가 오래된) msgID를 내림차순으로 가져온다!! 두둥!!!-ㅅ-a;; (nil이면 걍 최신부터 내림차순)
        NSArray *arrTempMsgList = [[AppPushDatabase sharedInstance] getMsgList:argMsgId
                                                                      rowCount:BUBBLE_PAGE_ROW_COUNT];
        if(arrTempMsgList!=nil && [arrTempMsgList count] > 0) {
            if([msg_tableView haveList]) {
                /*
                 [arrMessageList insertObjects:arrTempMsgList
                 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [arrTempMsgList count])]];
                 [msg_tableView insertTableList:arrTempMsgList middleIndex:0 isMiddle:NO];
                 */
                [msg_tableView addTableList:arrTempMsgList];
            } else {
                [msg_tableView setTableList:arrTempMsgList];
            }
            
            
            
            return YES;
        } else {
            
            [msg_tableView setTableList:nil];
            
            
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageViewController loadMessage : %@", exception);
        return NO;
    }
}

#pragma mark - MessageTableView delegate

- (void)pressPersonalTableHeader:(NSString *)argLink {
    @try {
        [delegate pressPersonalTableHeader:argLink];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageViewController pressTableCell : %@", exception);
    }
}

- (void)pressTableCell:(NSDictionary *)argDic {
    @try {
        [delegate pressTableCell:argDic];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageViewController pressTableCell : %@", exception);
    }
}

@end
