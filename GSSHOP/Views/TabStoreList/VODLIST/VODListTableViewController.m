//
//  VODListTBViewController.m
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 4. 8..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import "VODListTableViewController.h"

@interface VODListTableViewController ()
@property (nonatomic, strong) MAP_CX_TXT_TOOLTIP *viewtooltip;

@end

@implementation VODListTableViewController
@synthesize apiResultDic;
- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo
{
    self = [super init];
    if(self)
    {
        self.sectioninfodata = secinfo;
        self.dicOpenWaitCells = [[NSMutableDictionary alloc] init];
        [self setApiResultDic:resultDic];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reSetIndexPathForVODPlaying)
                                                     name:MAINSECTION_VODVIDEOALLKILL
                                                   object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"!!deallocdealloc!!!")
}

-(void)checkDeallocVOD{
    if (self.viewtooltip != nil) {
        [self.viewtooltip removeFromSuperview];
        self.viewtooltip = nil;
    }
    
    if (self.BAN_ORD_GBAView != nil) {
        [self.BAN_ORD_GBAView removeFromSuperview];
        self.BAN_ORD_GBAView = nil;
    }

    self.tableView = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.fixedWidth = APPFULLWIDTH;
    self.fixedHeight = APPFULLHEIGHT;
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self tableViewRegisterNib];

    self.tableView.backgroundColor = [UIColor getColor:@"EEEEEE" alpha:1 defaultColor:UIColor.grayColor];
    
    
    if (@available(iOS 11,*)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
}

// 테이블뷰가 노출될때 호출됨.
- (void)checkTableViewAppear {
    if(self.viewtooltip != nil && ApplicationDelegate.isShowVodTooltipView == NO) {
        self.viewtooltip.frame = ApplicationDelegate.HMV.view.frame;//ApplicationDelegate.window.frame;
        // 현 매장 위에 다른게 있는지 확인
        NSString *strLastViewController = NSStringFromClass([[[ApplicationDelegate.mainNVC viewControllers] lastObject] class]);
        if([ApplicationDelegate.HMV isCurrentHomeMainTabMyList:HOMESECTVODLIST] && [strLastViewController isEqualToString:@"Home_Main_ViewController"]) {
            //[ApplicationDelegate.window addSubview:self.viewtooltip];
            [ApplicationDelegate.HMV.view addSubview:self.viewtooltip];
            //보여주기전 frame 위치 세팅
            [self.viewtooltip layoutIfNeeded];
            //먼저 보여줬으니 담엔 안보여줄란다. 껏다 키렴.... 그럼 보일께야...
            ApplicationDelegate.isShowVodTooltipView = YES;            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.viewtooltip.viewBackGroundHeight.constant = 84.0;
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:(void (^)(void)) ^{
                                     [self.viewtooltip layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                 }];
            });
            
            //5초뒤 사라저 볼까?
            [self performSelector:@selector(closeTooltip) withObject:nil afterDelay:5.0];
        }
    }
}

-(void)closeTooltip {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.viewtooltip.viewBackGroundHeight.constant = 1.0;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             [self.viewtooltip layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             [self.viewtooltip removeFromSuperview];
                         }];
    });
}


- (void)setApiResultDic:(NSDictionary *)resultDic {
    apiResultDic = resultDic;
    if(sectionorigindata == nil) {
        sectionorigindata = [[NSMutableArray alloc] init];
    }
    else {
        [sectionorigindata removeAllObjects];
    }
    
    sectionorigindata = [self.apiResultDic objectForKey:@"productList"];
    //[[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONDEALVIDEOALLKILL object:nil userInfo:nil];
    
    [DataManager sharedManager].brigCoveAutoPlayYn = [NCS([self.apiResultDic objectForKey:@"brigCoveAutoPlayYn"]) isEqualToString:@"Y"] ? YES : NO ;
    
    if(self.sectionarrdata == nil) {
        self.sectionarrdata = [[NSMutableArray alloc] init];
    }
    else {
        [self.sectionarrdata removeAllObjects];
    }
    
    [self sectionarrdataNeedMoreData:ONLYDATASETTING];
}

// 딜전용
- (void)sectionarrdataNeedMoreData:(PAGEACTIONTYPE)atype {
    NSMutableArray *fetchedArray = [NSMutableArray array];
    
    for (NSInteger i=0; i<[sectionorigindata count]; i++) {
        
        NSDictionary *dicRow = [sectionorigindata objectAtIndex:i];
        
        if([NCS([dicRow objectForKey:@"viewType"]) isEqualToString:@"BAN_ORD_GBA"]) {

            if (atype != HOLDRELOADING) {
                if (self.BAN_ORD_GBAView != nil) {
                    [self.BAN_ORD_GBAView removeFromSuperview];
                    self.BAN_ORD_GBAView = nil;
                }
                isORD = YES;
                idxORD = i;
                rectORDCell = CGRectZero;
                idxORD_SelectedCate = 0;
                self.BAN_ORD_GBAView = [[[NSBundle mainBundle] loadNibNamed:@"SectionBAN_ORD_GBAtypeview" owner:self options:nil] firstObject];
                self.BAN_ORD_GBAView.frame = CGRectMake(0, 0, APPFULLWIDTH, BAN_ORD_GBA_view_HEIGHT);
                [self.BAN_ORD_GBAView setCellInfo:[sectionorigindata objectAtIndex:i] index:idxORD_SelectedCate target:self];
            }
            //[fetchedArray insertObject:[sectionorigindata objectAtIndex:i] atIndex:0];
            [fetchedArray addObject:[sectionorigindata objectAtIndex:i]];

        }else {
            [fetchedArray addObject:[sectionorigindata objectAtIndex:i]];
            //NSLog(@"[sectionorigindata objectAtIndex:i] = %@",[sectionorigindata objectAtIndex:i]);
        }
    }
    
    
    if(atype == (PAGEACTIONTYPE)FULLRELOADING) {
        self.sectionarrdata = fetchedArray;
        CGPoint offset = self.tableView.contentOffset;
        offset.y = 0.0f;
        [self.tableView setContentOffset:offset animated:NO];
        [self tableFooterDraw];
        [self.tableView reloadData];
    }
    else if(atype == (PAGEACTIONTYPE)HOLDRELOADING) {
        [self.sectionarrdata addObjectsFromArray:fetchedArray];
        CGPoint offset = self.tableView.contentOffset;
        [self.tableView setContentOffset:offset animated:NO];
        [self.tableView reloadData];
    }
    else if(atype == (PAGEACTIONTYPE)ONLYDATASETTING) {
        
        self.sectionarrdata = fetchedArray;
        
        NSLog(@"self.sectionarrdataself.sectionarrdata = %ld",(long)[self.sectionarrdata count]);
    
        [self tableFooterDraw];
        [self.tableView reloadData];
    }
}

- (void)reloadAction {

    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONDEALVIDEOALLKILL object:nil userInfo:nil];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0f];
}

- (void)setIndexPathForVODPlaying:(NSIndexPath *)path andStatus:(NSString *)strStatus{
    
    if ([strStatus isEqualToString:VODVIEW_OPEN]) {
        self.pathVODPlaying = path;
    }else{
        self.pathVODPlaying = nil;
    }
    
    NSLog(@"self.pathVODPlaying = %@",self.pathVODPlaying);

    if ([strStatus isEqualToString:VODVIEW_OPEN]) {
        [self.dicOpenWaitCells setObject:VODVIEW_OPEN forKey:[NSString stringWithFormat:@"%ld",(long)path.row]];
    }

    NSArray *arrVisibleRows = [self.tableView visibleCells];
    
    for (id cell in arrVisibleRows) {
        if ([cell isKindOfClass:[SectionBAN_VOD_GBAtypeCell class]]) {
            SectionBAN_VOD_GBAtypeCell *cellVOD = (SectionBAN_VOD_GBAtypeCell *)cell;
            if (cellVOD.path != self.pathVODPlaying) {
                //[self.dicOpenWaitCells setObject:VODVIEW_OPEN forKey:[NSString stringWithFormat:@"%ld",(long)cellVOD.path.row]];
                [cellVOD stopMoviePlayer];
            }
        }
    }
    
    [UIView performWithoutAnimation:^{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];

    [self.dicOpenWaitCells removeAllObjects];
}

- (void)reSetIndexPathForVODPlaying{
    self.pathVODPlaying = nil;
    NSLog(@"self.pathVODPlaying = %@",self.pathVODPlaying);
}


-(SectionBAN_VOD_GBAtypeCell *)findValidVODPlayerCell:(UIScrollView*)scrollView{
    NSArray *arrVisibleCells = [self.tableView visibleCells];
    
    SectionBAN_VOD_GBAtypeCell *cellReturn = nil;
    for (id tCell in arrVisibleCells) {
        if ([tCell isKindOfClass:[SectionBAN_VOD_GBAtypeCell class]]) {
            SectionBAN_VOD_GBAtypeCell *cell = (SectionBAN_VOD_GBAtypeCell *)tCell;
            //NSLog(@"cells title = %@",cell.productTitleLabel.text);
            CGRect rectCell = [self.tableView rectForRowAtIndexPath:cell.path];
            CGRect rectCheckArea = CGRectMake(0.0, rectCell.origin.y + cell.viewVideoArea.frame.origin.y, cell.viewVideoArea.frame.size.width, cell.viewVideoArea.frame.size.height);
            
            //NSLog(@"rectCell = %@",NSStringFromCGRect(rectCell));
            //NSLog(@"rectCheckArea = %@",NSStringFromCGRect(rectCheckArea));
            
            CGRect rectToCheck = [scrollView convertRect:rectCheckArea toView:scrollView.superview];
            if (CGRectContainsRect(scrollView.frame,rectToCheck)) {
                //NSLog(@"CGRectContainsRect = YES");
                cellReturn = cell;
                break;
            }else{
                //NSLog(@"CGRectContainsRect = NO");
            }
        }
    }
    
    return cellReturn;
}

-(SectionBAN_VOD_GBAtypeCell *)checkCellVODAreaDisapper:(UIScrollView*)scrollView{
    NSArray *arrVisibleCells = [self.tableView visibleCells];
    SectionBAN_VOD_GBAtypeCell *cellReturn = nil;
    for (id tCell in arrVisibleCells) {
        if ([tCell isKindOfClass:[SectionBAN_VOD_GBAtypeCell class]]) {
            //첫번째 SectionBAN_VOD_GBAtypeCell 셀만 체크하면 됨
            SectionBAN_VOD_GBAtypeCell *cell = (SectionBAN_VOD_GBAtypeCell *)tCell;
            //NSLog(@"cells title = %@",cell.productTitleLabel.text);
            CGRect rectCell = [self.tableView rectForRowAtIndexPath:cell.path];
            CGRect rectCheckArea = CGRectMake(0.0, rectCell.origin.y + cell.viewVideoArea.frame.origin.y, cell.viewVideoArea.frame.size.width, cell.viewVideoArea.frame.size.height);

            CGRect rectToCheck = [scrollView convertRect:rectCheckArea toView:scrollView.superview];
            if (CGRectIntersectsRect(scrollView.frame,rectToCheck)) {
                
            }
            else {
                //완전히 동영상 영역이 사라짐을 체크
                cellReturn = cell;
            }
            break;
        }
    }
    return cellReturn;
}


#pragma mark - Table view data source
- (void)tableViewRegisterNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_ORD_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_ORD_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_SLD_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_SLD_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_VOD_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_VOD_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionMAP_CX_TXT_GBBtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MAP_CX_TXT_GBBtypeIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BRD_VODCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BRD_VODCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_H000_GBAtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_H000_GBAtypeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionBAN_IMG_H000_GBBtypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BAN_IMG_H000_GBBtypeIdentifier];
    //
    [self.tableView registerNib:[UINib nibWithNibName:@"PRD_2Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PRD_2Cell"];
    
    
}


- (float) checkDivider:(NSString *) currentViewType nextIndexPos:(NSInteger) row {
    //divider 가변식 처리 로직 대상 : PRD_1_*, PRD_2, BRD_VOD
    float divider = 0;
    if(currentViewType.length > 0 && self.sectionarrdata.count > row) {
        NSString *nextViewType = NCS([[self.sectionarrdata objectAtIndex:row] objectForKey:@"viewType"]);
        if( ![currentViewType.uppercaseString isEqualToString:nextViewType.uppercaseString]) {
            divider = 10;
        }
    }
    return divider;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionarrdata count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionarrdata.count < indexPath.row ) {
        return [[UITableViewCell alloc] init];
    }
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    //NSLog(@"viewType = %@",viewType);
    if([viewType  isEqualToString:@"BAN_ORD_GBA"]) {
        SectionBAN_ORD_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_ORD_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        idxORD = indexPath.row;
        if (isORD && CGRectEqualToRect(rectORDCell, CGRectZero)) {
            rectORDCell = [self.tableView rectForRowAtIndexPath:indexPath];
            [cell addSubview:self.BAN_ORD_GBAView];
        }
        return cell;
    } else if( [viewType  isEqualToString:@"BAN_IMG_SLD_GBA"]) {
        
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        SectionBAN_IMG_SLD_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_SLD_GBAtypeIdentifier];
        cell.isAccessibilityElement = NO;
        cell.aTarget = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }

    else if( [viewType  isEqualToString:@"BRD_VOD"]) {
        NSLog(@" %d %d", (unsigned int)indexPath.row, (unsigned int)[self.sectionarrdata count]);
        NSLog(@"viewType = %@",viewType);
        
        BRD_VODCell *cell = [tableView dequeueReusableCellWithIdentifier:BRD_VODCellIdentifier];
        cell.aTarget = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.path = indexPath;
        [cell setDividerWithHeight:[self checkDivider:viewType nextIndexPos:indexPath.row+1]];
        [cell setCellInfoNDrawDataWithInfoDic:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return  cell;
    }

    else if([viewType isEqualToString:@"MAP_CX_TXT_GBB"]) {
        SectionMAP_CX_TXT_GBBtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:MAP_CX_TXT_GBBtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row]];
        return cell;
    }
    else if([viewType isEqualToString:@"MAP_CX_TXT_TOOLTIP"]) {
        // 셀이 아님.. 전체 팝업 뷰 노출
        if(self.viewtooltip == nil && ApplicationDelegate.isShowVodTooltipView == NO) {
            self.viewtooltip = [[[NSBundle mainBundle] loadNibNamed:@"MAP_CX_TXT_TOOLTIP" owner:self options:nil] firstObject];
            [self.viewtooltip setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] ];
            self.viewtooltip.aTarget = self;
        }
        //nil 리턴 하면 터짐.
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        return cell;
    }
    // nami0342 - PRD2 노출되게 추가
    else if ([viewType isEqualToString:@"PRD_2"]) {
        PRD_2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRD_2Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setDivider: [self checkDivider:viewType nextIndexPos:indexPath.row+1]];
        if (NCA([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"subProductList"])) {
            [cell setData:[self.sectionarrdata objectAtIndex:indexPath.row] indexPath: indexPath];
        }
        return cell;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [self isPMOIMG:viewType] ) {
        SectionBAN_IMG_H000_GBAtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_H000_GBAtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] position:indexPath];
        return cell;
    }
    else if( [viewType isEqualToString:@"BAN_IMG_H000_GBB"] ) {
        SectionBAN_IMG_H000_GBBtypeCell *cell = [tableView dequeueReusableCellWithIdentifier:BAN_IMG_H000_GBBtypeIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.aTarget = self;
        [cell setCellInfoNDrawData:[self.sectionarrdata objectAtIndex:indexPath.row] position:indexPath];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        return cell;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.sectioninfodata objectForKey:@"viewType"] == [NSNull null] || self.sectionarrdata.count < indexPath.row) {
        return 0;
    }
    
    NSString *viewType = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
    if([viewType  isEqualToString:@"BAN_ORD_GBA"]) {
        return  BAN_ORD_GBA_view_HEIGHT;
    }
    
    else if( [viewType  isEqualToString:@"BAN_IMG_SLD_GBA"]) {
        /// 타이틀 + 하단뷰 + 10 여백
        return 56 + 179 + 10;
    }
    else if([viewType  isEqualToString:@"BRD_VOD"]) {
        
        return (50.0+roundf((APPFULLWIDTH - 32.0)*(1.0/2.0))+ BRD_VODCell_heightPriceArea) + 1.0 + [self checkDivider:viewType nextIndexPos:indexPath.row+1];
    }
   
    else if([viewType  isEqualToString:@"MAP_CX_TXT_GBB"] ) {
        return 111.0 + 10;
    }
    // nami0342 - PRD2  추가
    else if ([viewType isEqualToString:@"PRD_2"]) {
        // 이미지 높이(전체 넓이 - 양쪽 side 32 - 중앙 margin 11)/2 + 기본 높이 158 + 하단 여백 1
        CGFloat imgHeight = (APPFULLWIDTH - (16 * 2) - 11) / 2;
        CGFloat height = imgHeight + 158 +  1;
        // 혜택 유무 판단
        NSDictionary *dic = [self.sectionarrdata objectAtIndex:indexPath.row];
        NSArray *subPrdList = [dic objectForKey:@"subProductList"];
        CGFloat benefitHeight = 0.0;
        if (NCA(subPrdList) && [subPrdList count] > 0) {
            for(NSDictionary *prdDic in subPrdList) {
                CGFloat tempHeight = [[Common_Util attributedBenefitString:prdDic widthLimit:imgHeight lineLimit:2] size].height;
                if (benefitHeight < tempHeight) {
                    benefitHeight = tempHeight;
                }
            }
        }
        
        // 혜택높이가 1줄일때는 18pt , 2줄일때는 36pt
        if (benefitHeight > 0 && benefitHeight < 18.0) {
            benefitHeight = 18.0;
        }
        
        if (benefitHeight > 18 && benefitHeight < 36.0) {
            benefitHeight = 36.0;
        }
        
        if (benefitHeight <= 0.0) {
            // 혜택뷰 하단 여백만큼 빼준다.
            height -= 9;
        }
        return height + benefitHeight + [self checkDivider:viewType nextIndexPos:indexPath.row+1];
    } else if([viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [viewType isEqualToString:@"BAN_IMG_H000_GBB"] || [self isPMOIMG:viewType]) {
        //높이값을 받아온다.// 가변형 이미지 베너
        float bannerHeigth = 0;
        NSDictionary *item = [self.sectionarrdata objectAtIndex:indexPath.row];
        //계산된 CALCCELLHEIGHT 가 있으면 이 값을 사용한다.
        if(NCO([item objectForKey:CALCCELLHEIGHT]) && ![NCS([item objectForKey:CALCCELLHEIGHT]) isEqualToString:@""]) {
            
            float h = [[item objectForKey:CALCCELLHEIGHT] floatValue];
            if(h <= 0) {
                h = [Common_Util DPRateOriginVAL:160];
            }
            return h + ( ([viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [self isPMOIMG:viewType]) ? kTVCBOTTOMMARGIN : 0);
        }
        else {
            if(NCO([item objectForKey:@"height"]) && ![NCS([item objectForKey:@"height"]) isEqualToString:@""]) {
                bannerHeigth = [[item objectForKey:@"height"] floatValue] / 2;
                if(bannerHeigth <= 0) {
                    bannerHeigth = [Common_Util DPRateOriginVAL:160];
                }
            }
            else {
                bannerHeigth =  [Common_Util DPRateOriginVAL:160]; //20190423 parksegun QA요청으로 이미지가 없을경우 기본 높이 노출 - Android기본 너비 160에 비례
            }
            return  [Common_Util DPRateOriginVAL:bannerHeigth] + (([viewType isEqualToString:@"BAN_IMG_H000_GBA"] || [self isPMOIMG:viewType]) ? kTVCBOTTOMMARGIN : 0);
        }
    } else {
        return CGFLOAT_MIN;
    }
}


- (void)touchEventTBCell:(NSDictionary *)dic {
    NSLog(@"");
    [delegatetarget touchEventTBCell:dic];
}
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr{
    [delegatetarget touchEventTBCellJustLinkStr:linkstr];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.sectionarrdata count] == 0 || self.sectionarrdata == nil) {
        return;
    }
    
    NSDictionary *secdic = [self.sectionarrdata objectAtIndex:indexPath.row];
    NSString *viewType = NCS([secdic objectForKey:@"viewType"]);
    
    if ([viewType isEqualToString:@"BAN_ORD_GBA"] || [viewType isEqualToString:@"BAN_VOD_GBA"] || [viewType isEqualToString:@"BAN_VOD_GBB"]) {
        return;
    }
    
    
    [delegatetarget touchEventTBCell:secdic];
    
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell isKindOfClass:[SectionBAN_VOD_GBAtypeCell class]]) {
        SectionBAN_VOD_GBAtypeCell *cellVOD = (SectionBAN_VOD_GBAtypeCell *)cell;
        [cellVOD checkEndDisplayingCell];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [scrollExpandingDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [delegatetarget customscrollViewDidScroll:(UIScrollView *)scrollView];
    [scrollExpandingDelegate scrollViewDidScroll:scrollView];
    
    if (isORD && !CGRectEqualToRect(rectORDCell, CGRectZero)) {
        CGRect cellRect = [scrollView convertRect:rectORDCell toView:scrollView.superview];
        CGFloat yposORD = 0.0;
        yposORD = cellRect.origin.y;
        //NSLog(@"yposORD %f",yposORD);
        if(yposORD >= 0  && self.sectionarrdata.count >= idxORD)  {
            SectionBAN_ORD_GBAtypeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idxORD inSection:0]];
            if (![[[cell subviews] lastObject] isKindOfClass:[SectionBAN_ORD_GBAtypeview class]]) {
                [cell addSubview:self.BAN_ORD_GBAView];
            }
            [delegatetarget headerFlowViewDisplay:NO headerView:self.BAN_ORD_GBAView];
        }
        else {
            if (lastPostion > yposORD) {
                // move up
                // 사라짐..
                [delegatetarget headerFlowViewDisplay:NO headerView:self.BAN_ORD_GBAView];
            }
            else if (lastPostion < yposORD) {
                // move down
                // 나타남.
                [delegatetarget headerFlowViewDisplay:YES headerView:self.BAN_ORD_GBAView];
            }
        }
        lastPostion = yposORD;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    [scrollExpandingDelegate scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [super scrollViewDidEndDecelerating:scrollView];
    NSLog(@"scrollViewDidEndDeceleratingscrollViewDidEndDecelerating");

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [super scrollViewDidEndScrollingAnimation:scrollView];
    NSLog(@"scrollViewDidEndScrollingAnimation");

}

//이벤트 매장에서 사용할 한줄짜리 틀고정 탭메뉴
- (void)apiCall_ListChange:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr {
    NSString *strApiUrl = nil;
    NSArray *arrApi = [[dic objectForKey:@"linkUrl"] componentsSeparatedByString:@".gsshop.com/"];
    if ([arrApi count]> 1) {
        strApiUrl = [arrApi objectAtIndex:1];
    }
    else {
        strApiUrl = [arrApi objectAtIndex:0];
    }
    
    [ApplicationDelegate onloadingindicator];
    
    //wiseLog
    NSString *strClickWiseLog = [dic objectForKey:@"wiseLog"];
    //와이즈로그 전송
    if ([NCS(strClickWiseLog) length] > 0 && [NCS(strClickWiseLog) hasPrefix:@"http"]) {
        [ApplicationDelegate wiseLogRestRequest:strClickWiseLog];
    }
    
    [self.currentOperation1 cancel];
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:strApiUrl
                                                                       isForceReload:NO
                                                                        onCompletion:^(NSDictionary *result) {
                                                                            NSLog(@"result = %@",result);
                                                                            idxORD_SelectedCate = [cnum integerValue];
                                                                            
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                [ApplicationDelegate offloadingindicator];
                                                                                [self replaceList:result];
                                                                            });
                                                                            
                                                                            
                                                                        }
                                                                             onError:^(NSError* error) {
                                                                                 NSLog(@"COMM ERROR");
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                     [ApplicationDelegate offloadingindicator];
                                                                                 });
                                                                             }];
}


- (void)replaceList:(NSDictionary *)dicAll {
    NSArray *arrProduct = [dicAll objectForKey:@"productList"];
    if(NCA(arrProduct)) {
        [sectionorigindata removeAllObjects];
        sectionorigindata = [arrProduct mutableCopy];
        
        //arr에서 제거 ORD_GBA를 제외한 나머지 제거
        //NSLog(@"[self.sectionarrdata:s %ld",[self.sectionarrdata count]);
        if([self.sectionarrdata count] > (idxORD + 1) ) {
            [self.sectionarrdata removeObjectsInRange:NSMakeRange( idxORD + 1, [self.sectionarrdata count] - idxORD - 1 )];
        }
        //NSLog(@"[self.sectionarrdata:f %ld",[self.sectionarrdata count]);
        
        for (NSDictionary *dic in sectionorigindata) {
            if( ![[dic objectForKey:@"viewType"] isEqualToString:@"BAN_ORD_GBA"]) {
                [self.sectionarrdata addObject:dic];
            }
        }
    }//if
    else { //0개인가..
        //제거
        if([self.sectionarrdata count] > (idxORD + 1) ) {
            [self.sectionarrdata removeObjectsInRange:NSMakeRange( idxORD + 1, [self.sectionarrdata count] - idxORD - 1 )];
        }
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView reloadData];

}
@end
