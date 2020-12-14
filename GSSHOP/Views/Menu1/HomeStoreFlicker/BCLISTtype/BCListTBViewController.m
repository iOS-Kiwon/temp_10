//
//  BCListTBViewController.m
//  GSSHOP
//
//  Created by gsshop on 2015. 5. 18..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "BCListTBViewController.h"



#import "SectionBCCell.h"




#define BRANDBANNERTOP_HEIGHT 120
#define BRANDTABBARTOP_HEIGHT 50
#define BRANDTOPSECTIONHEADER_HEIGHT 40

#define BRANDTOPSECTIONFOOTER_HEIGHT 20




@interface BCListTBViewController ()

@end



@implementation BCListTBViewController


@synthesize apiResultDic;
@synthesize  brandBannerarr;

- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo
{
    self = [super init];
    if(self)
    {
        
        
        
        self.sectioninfodata = secinfo;
        self.apiResultDic = resultDic;
        isPagingComm =NO;
        tbviewrowmaxNum =0;
        
        
    }
    return self;
}


- (void)setApiResultDic:(NSDictionary *)resultDic
{
    
    if(self.tbheaderv != nil){
        [self.tbheaderv removeFromSuperview];
    }
    self.tbheaderv = nil;
    
    
    
    if(self.BottomCellInforow == nil){
        self.BottomCellInforow = [[NSMutableArray alloc] init];
        
    }else {
        [self.BottomCellInforow removeAllObjects];
    }
    
    
    
    selcategorybtntag = CATEGORYMENUTAG0;
    
    
    apiResultDic = resultDic;
    isPagingComm =NO;
    tbviewrowmaxNum =0;
    
    if(sectionorigindata == nil){
        sectionorigindata = [[NSMutableArray alloc] init];
        
    }else {
        [sectionorigindata removeAllObjects];
    }
    
    
    
    sectionorigindata = [resultDic objectForKey:@"productList"];
    
    
    
    if(self.sectionarrdata == nil){
        self.sectionarrdata = [[NSMutableArray alloc] init];
        
    }else {
        [self.sectionarrdata removeAllObjects];
    }
    
    self.sectionarrdata  = sectionorigindata;
    
    
    
    if(self.brandBannerarr == nil){
        self.brandBannerarr = [[NSMutableArray alloc] init];
        
    }else {
        [self.brandBannerarr removeAllObjects];
    }
    
    NSArray *currentCategory;
    
    
    for (int i = 0; i < [self.sectionarrdata count]; i++)
    {
        
        currentCategory = [[self.sectionarrdata objectAtIndex:i] objectForKey:@"subProductList"];
        
        for (int j = 0; j < [currentCategory count]; j++)
        {
            
            if(j==0){
                
                
                
                CellSubInfoData *data = [[CellSubInfoData alloc] init];
                switch (i) {
                    case 0:
                        data.CellViewType = [NSString stringWithFormat:@"%d",CATEGORYMENUTAG0 ];
                        break;
                    case 1:
                        data.CellViewType = [NSString stringWithFormat:@"%d",CATEGORYMENUTAG1 ];
                        break;
                    case 2:
                        data.CellViewType = [NSString stringWithFormat:@"%d",CATEGORYMENUTAG2 ];
                        break;
                    case 3:
                        data.CellViewType = [NSString stringWithFormat:@"%d",CATEGORYMENUTAG3 ];
                        break;
                    default:
                        break;
                }
                [self.BottomCellInforow addObject:data];
                [self.brandBannerarr addObject:[self sectionHeaderViewForBrandWithSection:(NSInteger)i]];
                
            }
            
            CellSubInfoData *data = [[CellSubInfoData alloc] init];
            data.CellViewType = [NSString stringWithFormat:@"%d",i ];
            [self.BottomCellInforow addObject:data];
            [self.brandBannerarr addObject:[currentCategory objectAtIndex:j]];
            
            
            if(  i < [self.sectionarrdata count]-1 && [currentCategory count]-1 == j   ){
                //20픽셀여백삽입
                CellSubInfoData *data = [[CellSubInfoData alloc] init];
                data.CellViewType = [NSString stringWithFormat:@"BPADDING" ];
                [self.BottomCellInforow addObject:data];
                [self.brandBannerarr addObject:[self sectionFooterViewForBrand]];
                
            }
        }
        
        
        
        
    }
    NSLog(@" 총갯수 %ld", (long)[self.brandBannerarr count]);
    

    
    self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
    
    
    [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
    
}

-(void) dealloc
{
    self.sectionType = nil;
    self.apiResultDic = nil;
    self.sectioninfodata = nil;
    self.sectionarrdata = nil;
    
    self.brandBannerarr = nil;
    self.tbheaderv = nil;
    
    
    self.sectionarrdata = nil;
    self.sectioninfodata = nil;
    
    [timer invalidate];
    timer = nil;
    
    isTimer = NO;
}





#pragma mark - Header
-(void) tableHeaderDraw :(TVCONTENTBASE)tvcbasesource
{
    if (self.tableView.tableHeaderView != nil)
    {
        [self.tableView.tableHeaderView removeFromSuperview];
        self.tableView.tableHeaderView  = nil;
    }
    tableheaderNo1DealListheight= 0;
    tableheaderNo1DealZoneheight = 0;
    
    
    // 리스트 데이터 없으면 헤더 표시 안하도록
    if  (![self isExsitSectionBanner])
    {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return;
        
    }
    
    
    
    float tableheaderheight = 0;
    
    UIView *tvhview = [[UIView alloc] initWithFrame:CGRectZero ];
    
    
    
    //brandbanner
    if(NCO([self.apiResultDic objectForKey:@"brandBanner"]) && [(NSMutableArray*)[self.apiResultDic objectForKey:@"brandBanner"] count] > 0) {
        //상단여백 0px 을 위한 0 adding
        tableheaderheight = tableheaderheight +0;
        
        tableheaderNo1DealZoneheight = [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT];
        
        BrandBannerListView  *tcell = [[BrandBannerListView alloc] initWithTarget:self Nframe:CGRectMake(0,  tableheaderheight, APPFULLWIDTH, tableheaderNo1DealZoneheight)];
        
        [tvhview addSubview:tcell];
        
        [tcell setCellInfoNDrawData:[self.apiResultDic objectForKey:@"brandBanner"] ];
        
    }
        
    
    tvhview.frame =  CGRectMake(0,  0, APPFULLWIDTH, tableheaderheight+tableheaderNo1DealZoneheight);
    
    
    
    
    self.tableView.tableHeaderView = tvhview;
}



- (BOOL)isExsitSectionBanner {
    @try {
        
        if(( [self.apiResultDic objectForKey:@"brandBanner"]   != [NSNull null]) ){
            
            if( [(NSMutableArray*)[self.apiResultDic objectForKey:@"brandBanner"] count] > 0) {
                return YES;
            }else {
                return NO;
            }
            
        }else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return  NO;
    }
    
}



-(UIView*)topCATEGORYBTNview {
    
    UIView *menucontainview = [[UIView alloc] initWithFrame: CGRectMake(0,   0, APPFULLWIDTH, BRANDTABBARTOP_HEIGHT)] ;
    
    menucontainview.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
    float cellwidth;
    
    cellwidth = (APPFULLWIDTH-10-10)/4;
    
    btn_cate1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, cellwidth, 34)];
    btn_cate2 = [[UIButton alloc] initWithFrame:CGRectMake(10+cellwidth, 8, cellwidth, 34)];
    btn_cate3 = [[UIButton alloc] initWithFrame:CGRectMake(10+cellwidth+cellwidth,8, cellwidth, 34)];
    btn_cate4 = [[UIButton alloc] initWithFrame:CGRectMake(10+cellwidth+cellwidth+cellwidth, 8, cellwidth, 34)];
    
    if([self.sectionarrdata count] >= 4){
    
        NSLog(@"dddd %@", [[self.sectionarrdata  objectAtIndex:0] objectForKey:@"productName"]);
        
        [btn_cate1 setTitle:[[self.sectionarrdata  objectAtIndex:0] objectForKey:@"productName"] forState:UIControlStateNormal];
        btn_cate1.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn_cate2 setTitle:[[self.sectionarrdata  objectAtIndex:1] objectForKey:@"productName"] forState:UIControlStateNormal];
        btn_cate2.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn_cate3 setTitle:[[self.sectionarrdata  objectAtIndex:2] objectForKey:@"productName"] forState:UIControlStateNormal];
        btn_cate3.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn_cate4 setTitle:[[self.sectionarrdata  objectAtIndex:3] objectForKey:@"productName"] forState:UIControlStateNormal];
        btn_cate4.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        
        
        
        btn_cate1.titleLabel.textColor = [Mocha_Util getColor:@"999999"];
        [btn_cate1 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateNormal];
        [btn_cate1 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateReserved];
        [btn_cate1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateSelected];
        [btn_cate1 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateDisabled];
        [btn_cate1 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateHighlighted];
        
        [btn_cate1 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateHighlighted];
        [btn_cate1 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateSelected];
        [btn_cate1 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"F4F4F4"]] forState:UIControlStateNormal];
        btn_cate1.adjustsImageWhenHighlighted = NO;
        [btn_cate1.layer setMasksToBounds:NO];
        btn_cate1.layer.shadowOffset = CGSizeMake(0, 0);
        btn_cate1.layer.shadowRadius = 0.0;
        btn_cate1.layer.borderColor = [Mocha_Util getColor:@"DEDEDE"].CGColor;
        btn_cate1.layer.borderWidth =([Common_Util isRetinaScale])?0.5:1.0;
        btn_cate1.tag = CATEGORYMENUTAG0;
        [btn_cate1 addTarget:self action:@selector(btntouchCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        
        btn_cate2.titleLabel.textColor = [Mocha_Util getColor:@"999999"];
        [btn_cate2 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateNormal];
        [btn_cate2 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateReserved];
        [btn_cate2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateSelected];
        [btn_cate2 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateDisabled];
        [btn_cate2 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateHighlighted];
        
        [btn_cate2 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateHighlighted];
        [btn_cate2 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateSelected];
        [btn_cate2 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"F4F4F4"]] forState:UIControlStateNormal];
        btn_cate2.adjustsImageWhenHighlighted = NO;
        [btn_cate2.layer setMasksToBounds:NO];
        btn_cate2.layer.shadowOffset = CGSizeMake(0, 0);
        btn_cate2.layer.shadowRadius = 0.0;
        btn_cate2.layer.borderColor = [Mocha_Util getColor:@"DEDEDE"].CGColor;
        btn_cate2.layer.borderWidth = ([Common_Util isRetinaScale])?0.5:1.0;
        btn_cate2.tag = CATEGORYMENUTAG1;
        [btn_cate2 addTarget:self action:@selector(btntouchCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        btn_cate3.titleLabel.textColor = [Mocha_Util getColor:@"999999"];
        [btn_cate3 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateNormal];
        [btn_cate3 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateReserved];
        [btn_cate3 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateSelected];
        [btn_cate3 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateDisabled];
        [btn_cate3 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateHighlighted];
        
        [btn_cate3 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateHighlighted];
        [btn_cate3 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateSelected];
        [btn_cate3 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"F4F4F4"]] forState:UIControlStateNormal];
        btn_cate3.adjustsImageWhenHighlighted = NO;
        [btn_cate3.layer setMasksToBounds:NO];
        btn_cate3.layer.shadowOffset = CGSizeMake(0, 0);
        btn_cate3.layer.shadowRadius = 0.0;
        btn_cate3.layer.borderColor = [Mocha_Util getColor:@"DEDEDE"].CGColor;
        btn_cate3.layer.borderWidth = ([Common_Util isRetinaScale])?0.5:1.0;
        btn_cate3.tag = CATEGORYMENUTAG2;
        [btn_cate3 addTarget:self action:@selector(btntouchCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        btn_cate4.titleLabel.textColor = [Mocha_Util getColor:@"999999"];
        [btn_cate4 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateNormal];
        [btn_cate4 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateReserved];
        [btn_cate4 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateSelected];
        [btn_cate4 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateDisabled];
        [btn_cate4 setTitleColor:[Mocha_Util getColor:@"999999"] forState:UIControlStateHighlighted];
        
        [btn_cate4 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateHighlighted];
        [btn_cate4 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateSelected];
        [btn_cate4 setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"F4F4F4"]] forState:UIControlStateNormal];
        btn_cate4.adjustsImageWhenHighlighted = NO;
        [btn_cate4.layer setMasksToBounds:NO];
        btn_cate4.layer.shadowOffset = CGSizeMake(0, 0);
        btn_cate4.layer.shadowRadius = 0.0;
        btn_cate4.layer.borderColor = [Mocha_Util getColor:@"DEDEDE"].CGColor;
        btn_cate4.layer.borderWidth = ([Common_Util isRetinaScale])?0.5:1.0;
        btn_cate4.tag = CATEGORYMENUTAG3;
        [btn_cate4 addTarget:self action:@selector(btntouchCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [menucontainview addSubview:btn_cate1];
        [menucontainview addSubview:btn_cate2];
        [menucontainview addSubview:btn_cate3];
        [menucontainview addSubview:btn_cate4];
        
        btn_cate1.selected = YES;
        
        
        UIView *ttmlineView = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH,  ([Common_Util isRetinaScale])?0.5:1.0)] ;
        ttmlineView.backgroundColor = [Mocha_Util getColor:@"E5E5E5"];
        [menucontainview addSubview:ttmlineView];
        
        
        UIView *btmlineView = [[UIView alloc] initWithFrame:CGRectMake(0,  BRANDTABBARTOP_HEIGHT-1, APPFULLWIDTH,  ([Common_Util isRetinaScale])?0.5:1.0)] ;
        btmlineView.backgroundColor = [Mocha_Util getColor:@"E5E5E5"];
        [menucontainview addSubview:btmlineView];
        
    }
    
    return menucontainview;
    
    
}

-(void)btntouchCategory:(id)sender {
    
    selcategorybtntag = (int)[((UIButton *)sender) tag];
    
    btn_cate1.selected = NO;
    btn_cate2.selected = NO;
    btn_cate3.selected = NO;
    btn_cate4.selected = NO;
    ((UIButton*)sender).selected = YES;
    
    
    int tgs= 0;
    
    for (int i=0; i<[self.brandBannerarr count]; i++) {
        
        CellSubInfoData *data =  [self.BottomCellInforow objectAtIndex:i];
        if( [data.CellViewType  isEqualToString:[NSString stringWithFormat:@"%d",selcategorybtntag]]){
            tgs = i;
        }
        
    }
    
    
    
    NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:tgs inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPaths atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}




- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - Footer

-(void) tableFooterDraw
{
    if (self.tableView.tableFooterView != nil)
    {
        [self.tableView.tableFooterView removeFromSuperview];
        self.tableView.tableFooterView  = nil;
    }
    
    // 리스트 데이터 없으면 푸터 표시 안하도록
    if ([self.sectionarrdata count] < 1)
    {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return;
    }
    
    float tablefooterheight = 0;
    
    UIView *tvfview = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    UIView *loginView = [self footerLoginView];
    
    float offset = 9;
    loginView.frame = CGRectMake(0,    offset, APPFULLWIDTH, loginView.frame.size.height);
    tablefooterheight = loginView.frame.origin.y + loginView.frame.size.height;
    
    tvfview.frame =  CGRectMake(0,  0, APPFULLWIDTH, tablefooterheight);
    
    
    [tvfview addSubview:loginView];
    self.tableView.tableFooterView= tvfview;
}










#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"sectionct: %ld === %ld", (long)[self.sectionarrdata count], (long)[brandBannerarr count]);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.brandBannerarr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return BRANDTABBARTOP_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section==0)  {
        
        if(self.tbheaderv != nil){
            [self.tbheaderv removeFromSuperview];
            self.tbheaderv = nil;
        }
        return  [self topCATEGORYBTNview];
    }else {
        return  nil;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BCtypeIdentifier = @"SectionBCCell";
    
    if ([[self.brandBannerarr objectAtIndex:indexPath.row] isKindOfClass:[UIView class]])
    {
        
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString	stringWithFormat:@"L-%d", (int)indexPath.row]];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString	stringWithFormat:@"L-%d", (int)indexPath.row]];
            [cell addSubview:[self.brandBannerarr objectAtIndex:indexPath.row]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else {
        
        SectionBCCell *cell     = [tableView dequeueReusableCellWithIdentifier:BCtypeIdentifier];
        
        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionBCCell" owner:self options:nil];
//            for (id oneObject in nib)
//                if ([oneObject isKindOfClass:[SectionBCCell class]]) {
//                    cell = (SectionBCCell *)oneObject;
//                }
            cell = (SectionBCCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionBCCell" owner:self options:nil] firstObject];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellInfoNDrawData:[self.brandBannerarr objectAtIndex:indexPath.row]];
        
        return  cell;
    }
    
    
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ( [[self.brandBannerarr objectAtIndex:indexPath.row] isKindOfClass:[UIView class]])
    {
        
        
        CellSubInfoData *data =  [self.BottomCellInforow objectAtIndex:indexPath.row];
        
        if([data.CellViewType  isEqualToString:[NSString stringWithFormat:@"BPADDING" ]]){
            return BRANDTOPSECTIONFOOTER_HEIGHT;
        }else {
            
            return BRANDTOPSECTIONHEADER_HEIGHT;
        }
    }else {

        return   [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT];
    }
    
}


//tb delegate
- (void)touchEventTBCell:(NSDictionary *)dic {
    [delegatetarget touchEventTBCell:dic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.brandBannerarr count] == 0 || self.brandBannerarr == nil) { return; }
    
    if (indexPath.section == 0 && [[self.brandBannerarr objectAtIndex:indexPath.row] isKindOfClass:[UIView class]]) { return; }
    
    //20161021 parksegun 방어코드 추가
    
    if(self.brandBannerarr.count <= indexPath.row) {return;}
    
    NSDictionary *secdic = [self.brandBannerarr objectAtIndex:indexPath.row];
    
    if(secdic == nil) {return;}
    
    [delegatetarget touchEventTBCell:secdic];
    @try {
        
        
        BOOL isforevent  =   ([NCS([secdic objectForKey:@"productName"]) length] > 1);
        
        NSArray *currentCategory;
        NSString *curCName;
        NSInteger selint=0;
        for (int i = 0; i < [self.sectionarrdata count]; i++)
        {
            
            currentCategory = [[self.sectionarrdata objectAtIndex:i] objectForKey:@"subProductList"];
            
            if(currentCategory == nil ){break;}
            
            for (int j = 0; j < [currentCategory count]; j++)
            {
                if([NCS([secdic objectForKey:@"linkUrl"]) isEqualToString:NCS([[currentCategory objectAtIndex:j] objectForKey:@"linkUrl"])]){
                    curCName = [NSString stringWithFormat:@"%@", NCS([[self.sectionarrdata objectAtIndex:i] objectForKey:@"productName"])   ];
                    selint =j;
                }
                
                
                
            }
            
            
            
            
        }
        
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                              withAction:[NSString stringWithFormat:@"MC_%@_%@", NCS([self.sectioninfodata objectForKey:@"sectionName"]), curCName]
         
                               withLabel:  [NSString stringWithFormat:@"%@_%@_%@", [DataManager sharedManager].abBulletVer , [NSString stringWithFormat:@"%d", (int)selint ],   (isforevent)?NCS([secdic objectForKey:@"productName"]):NCS([secdic objectForKey:@"linkUrl"])  ]  ];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleCommonCellView contentBinding : %@", exception);
    }
    @finally {
        
    }
    
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tbviewrowmaxNum <= indexPath.row) { tbviewrowmaxNum = (int)indexPath.section;  }
}


-(void)TopCategoryTabButtonClicked:(id)sender {
    
    [delegatetarget  TopCategoryTabButtonClicked:sender];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.sectionarrdata == nil) return;
    if([self.sectionarrdata count] >= 3) return;
    
    int toppadding = [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT];
    
    NSUInteger crow1= [ ((NSArray*)[[self.sectionarrdata objectAtIndex:0] objectForKey:@"subProductList"]) count] * [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT];
    NSUInteger crow2= [ ((NSArray*)[[self.sectionarrdata objectAtIndex:1] objectForKey:@"subProductList"]) count] * [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT];
    NSUInteger crow3= [ ((NSArray*)[[self.sectionarrdata objectAtIndex:2] objectForKey:@"subProductList"]) count] * [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT];
    
    if(scrollView.contentOffset.y < toppadding+BRANDTOPSECTIONHEADER_HEIGHT+crow1+BRANDTOPSECTIONFOOTER_HEIGHT ) {
        selcategorybtntag = CATEGORYMENUTAG0;
        btn_cate2.selected = NO;
        btn_cate3.selected = NO;
        btn_cate4.selected = NO;
        btn_cate1.selected = YES;
    }else if(scrollView.contentOffset.y >= toppadding+BRANDTOPSECTIONHEADER_HEIGHT+crow1+BRANDTOPSECTIONFOOTER_HEIGHT    &&
             scrollView.contentOffset.y < toppadding+BRANDTOPSECTIONHEADER_HEIGHT+crow1+BRANDTOPSECTIONFOOTER_HEIGHT+BRANDTOPSECTIONHEADER_HEIGHT+crow2+BRANDTOPSECTIONFOOTER_HEIGHT ) {
        selcategorybtntag = CATEGORYMENUTAG1;
        btn_cate2.selected = YES;
        btn_cate3.selected = NO;
        btn_cate4.selected = NO;
        btn_cate1.selected = NO;
    }else if(scrollView.contentOffset.y >= toppadding+BRANDTOPSECTIONHEADER_HEIGHT+crow1+BRANDTOPSECTIONFOOTER_HEIGHT+BRANDTOPSECTIONHEADER_HEIGHT+crow2+BRANDTOPSECTIONFOOTER_HEIGHT  &&
             scrollView.contentOffset.y < toppadding+BRANDTOPSECTIONHEADER_HEIGHT+crow1+BRANDTOPSECTIONFOOTER_HEIGHT+BRANDTOPSECTIONHEADER_HEIGHT+crow2+BRANDTOPSECTIONFOOTER_HEIGHT+BRANDTOPSECTIONHEADER_HEIGHT+crow3+BRANDTOPSECTIONFOOTER_HEIGHT ) {
        selcategorybtntag = CATEGORYMENUTAG2;
        btn_cate2.selected = NO;
        btn_cate3.selected = YES;
        btn_cate4.selected = NO;
        btn_cate1.selected = NO;
    }else if( scrollView.contentOffset.y >= toppadding+BRANDTOPSECTIONHEADER_HEIGHT+crow1+BRANDTOPSECTIONFOOTER_HEIGHT+BRANDTOPSECTIONHEADER_HEIGHT+crow2+BRANDTOPSECTIONFOOTER_HEIGHT+BRANDTOPSECTIONHEADER_HEIGHT+crow3+BRANDTOPSECTIONFOOTER_HEIGHT ) {
        selcategorybtntag = CATEGORYMENUTAG3;
        btn_cate2.selected = NO;
        btn_cate3.selected = NO;
        btn_cate4.selected = YES;
        btn_cate1.selected = NO;
    }else {
        
    }
    
    
    
    
    
    [super scrollViewDidScroll:scrollView];
    
    
    
}




#pragma mark - Table refresh action

- (void)refresh {
    [timer invalidate];
    timer = nil;
    isTimer = NO;
    [delegatetarget tablereloadAction];

}

- (void)reloadAction {
    
    [self tableHeaderDraw:(TVCONTENTBASE)SectionContentsBase];
    [self tableFooterDraw];
    
    self.tableView.backgroundColor = [Mocha_Util getColor:@"e5e5e5"];
    
    animtbindex = -1;
    [self.tableView reloadData];
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0f];
    
}



- (UIView *)sectionFooterViewForBrand {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, BRANDTOPSECTIONFOOTER_HEIGHT)];
    containerView.backgroundColor = [Mocha_Util getColor:@"E5E5E5"];
    
    return containerView;
}



- (UIView *)sectionHeaderViewForBrandWithSection:(NSInteger)section
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, BRANDTOPSECTIONHEADER_HEIGHT)];
    containerView.backgroundColor = [Mocha_Util getColor:@"FFFFFF"];
    

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, APPFULLWIDTH -20, 13)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [Mocha_Util getColor:@"111111"];
    
    NSLog(@"section: %@", [[sectionorigindata objectAtIndex:section] objectForKey:@"productName"]);
    
    label.text = [NSString stringWithFormat:@"%@ ", [[sectionorigindata objectAtIndex:section] objectForKey:@"productName"]];
    [containerView addSubview:label];
    
    return containerView;
}


@end
