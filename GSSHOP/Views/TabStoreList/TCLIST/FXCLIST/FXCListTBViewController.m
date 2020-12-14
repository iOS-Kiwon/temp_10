//
//  FXCListTBViewController.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "FXCListTBViewController.h"
#import "FXCCategoryView.h"

#import "SectionDCtypeCell.h"

#import "SectionBIStypeCell.h"
#import "SectionBIMtypeCell.h"
#import "SectionBILtypeCell.h"

#import "SectionBIM440StypeCell.h"

#import "SectionBIXLtypeCell.h"
#import "SectionBMIAtypeCell.h"
#import "SectionBSIStypeCell.h"
#import "SectionPSLtypeCell.h"
//#import "SectionBTStypeCell.h"

@interface FXCListTBViewController ()

@property (nonatomic, strong) FXCTextHeaderView *fxcTextHeaderView;     // 헤더 카테고리뷰

@end

@implementation FXCListTBViewController
@synthesize indexFXC;
@synthesize sectionView;

- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo
{
    self = [super init];
    if(self)
    {
        
        
        dicNeedsToCellClear = [[NSMutableDictionary alloc] init];
        dicMLCellPlayControl = [[NSMutableDictionary alloc] init];
        
        self.sectioninfodata = secinfo;
        self.apiResultDic = resultDic;
        isPagingComm =NO;
        tbviewrowmaxNum =0;
        
        // nami0342 - AB test
        self.m_isABTest = NO;
        
    }
    return self;
}

- (void)checkDeallocFXC{
    
    if (self.fxcTextHeaderView !=nil) {
        [self.fxcTextHeaderView removeFromSuperview];
        self.fxcTextHeaderView = nil;
    }
    
    if(self.tableView.tableHeaderView != nil) {
        [self.tableView.tableHeaderView removeFromSuperview];
        self.tableView.tableHeaderView  = nil;
    }
    self.tableView = nil;
    
    [self checkDealloc];
}

-(void) tableHeaderDraw :(TVCONTENTBASE)tvcbasesource {
    
    if(self.tableView.tableHeaderView != nil) {
        [self.tableView.tableHeaderView removeFromSuperview];
        self.tableView.tableHeaderView  = nil;
    }
    
    tableheaderBANNERheight = 0;
    tableheaderTVCVheight = 0;
    
    tableheaderNo1DealListheight= 0;
    tableheaderNo1DealZoneheight = 0;
    
    UIView *tvhview = [[UIView alloc] initWithFrame:CGRectZero ];
    
    //배너
    if([self isExsitSectionBanner]){
        NSInteger heightBanner = BANNERHEIGHT;
        if (NCO([self.apiResultDic objectForKey:@"banner"]) && [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) length] > 0) {
            heightBanner = [NCS([[self.apiResultDic objectForKey:@"banner"] objectForKey:@"height"]) integerValue];
        }
        tableheaderBANNERheight = [Common_Util DPRateOriginVAL:heightBanner];
        [tvhview addSubview:[self topBannerview]];
    }   
    
    
    if (NCA([self.sectioninfodata objectForKey:@"subMenuList"]) && [(NSArray *)[self.sectioninfodata objectForKey:@"subMenuList"] count] > 0) {
        
        NSLog(@"[self.sectioninfodata objectForKey:@subMenuList] objectAtIndex:0] = %@",[[self.sectioninfodata objectForKey:@"subMenuList"] objectAtIndex:0]);
        
        if (NCO([[self.sectioninfodata objectForKey:@"subMenuList"] objectAtIndex:0]) && [NCS([[(NSArray *)[self.sectioninfodata objectForKey:@"subMenuList"] objectAtIndex:0] objectForKey:@"viewType"]) isEqualToString:@"SUB_PRD_LIST_TEXT"]) {
            NSLog(@"indexCategory = %lu",(long)indexFXC);
            
            if (self.fxcTextHeaderView != nil) {
                self.fxcTextHeaderView.frame = CGRectMake(0, tableheaderBANNERheight, APPFULLWIDTH, self.fxcTextHeaderView.frame.size.height);
                tableheaderBANNERheight = tableheaderBANNERheight + self.fxcTextHeaderView.frame.size.height;
                [tvhview addSubview:self.fxcTextHeaderView];
            } else {
                FXCTextHeaderView *fxcView = [[FXCTextHeaderView alloc] init:self.sectioninfodata selectedIndex:indexFXC];
                fxcView.aTarget = sectionView;
                fxcView.frame = CGRectMake(0, tableheaderBANNERheight, APPFULLWIDTH, fxcView.frame.size.height);
                [tvhview addSubview:fxcView];
                tableheaderBANNERheight = tableheaderBANNERheight + fxcView.frame.size.height;
                self.fxcTextHeaderView = fxcView;
            }
            
            NSLog(@"tableheaderBANNERheight = %d",tableheaderBANNERheight);
        }
        else {
            NSLog(@"indexCategory = %lu",(long)indexFXC);
            FXCCategoryView *fxcView =   [[FXCCategoryView alloc] initWithTarget:sectionView cate:(NSArray *)[self.sectioninfodata objectForKey:@"subMenuList"] seletedIndex:indexFXC];
            fxcView.frame = CGRectMake(0, tableheaderBANNERheight, APPFULLWIDTH, fxcView.frame.size.height);
            [tvhview addSubview:fxcView];
            tableheaderBANNERheight = tableheaderBANNERheight + fxcView.frame.size.height;
            NSLog(@"tableheaderBANNERheight = %d",tableheaderBANNERheight);
        }
    }
    tvhview.frame =  CGRectMake(0,  0, APPFULLWIDTH, tableheaderBANNERheight+[Common_Util DPRateVAL:tableheaderTVCVheight withPercent:68]+tableheaderNo1DealListheight+tableheaderNo1DealZoneheight);
    
    
    self.tableView.tableHeaderView = tvhview;
    
}



#pragma mark - Table view data source


//DealCell 터치 전용
//tb delegate
- (void)touchEventDealCell:(NSDictionary *)dic {
    [delegatetarget touchEventTBCell:dic];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(self.sectionarrdata == nil && [self.sectionarrdata count] == 0 && self.sectionarrdata.count <= indexPath.row) { return; }
    
    NSDictionary *secdic = [self.sectionarrdata objectAtIndex:indexPath.row];
    
    
    //NSLog(@"연관추천AB : %@", [DataManager sharedManager].abBestdealVer);
    
    NSString *viewType = NCS([secdic objectForKey:@"viewType"]);
    
    if ([viewType isEqualToString:@"DSL_A"] || [viewType isEqualToString:@"DSL_B"] ||
        [viewType isEqualToString:@"DSL_A2"] || [viewType isEqualToString:@"RPS"] ||
        [viewType isEqualToString:@"FPC"] || [viewType isEqualToString:@"FPC_S"] ||
        [viewType isEqualToString:@"BFP"] || [viewType isEqualToString:@"TCF"]  ||
        [viewType isEqualToString:@"BAN_TXT_CHK_GBA"] || [viewType isEqualToString:@"API_SRL"])  {
        return;
    }
    
    
    [delegatetarget touchEventTBCell:secdic];
    
    
    @try {
        
        NSString *prdno = nil;
        URLParser *parser = [[URLParser alloc] initWithURLString:NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"])];
        if([parser valueForVariable:@"dealNo"] != nil){
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"dealNo"]];
        }else if([parser valueForVariable:@"prdid"] != nil){
            prdno = [NSString stringWithFormat:@"_%@",[parser valueForVariable:@"prdid"]];
            
        }else {
            prdno = @"";
        }
        
        //indexFXC
        NSLog(@"sssss %@  nnnnnnnnnn  %@",self.sectioninfodata , [self.sectionarrdata objectAtIndex:indexPath.row]);
        
        BOOL isexistpdname  =   ([NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]) length] > 1);
        
        NSLog(@"이벤트는 productName없음 %i", isexistpdname);
        
        
        NSLog(@"비탑 %@",   [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
        
        
        NSString *type = NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]);
        if([type isEqualToString:@"B_IL"]  ||
           [type isEqualToString:@"B_IM"]  ||
           [type isEqualToString:@"L"]  ||
           [type isEqualToString:@"B_IM440"]
           
           
           ){
            
            
            
            if (NCA([self.sectioninfodata objectForKey:@"subMenuList"]) && [(NSArray *)[self.sectioninfodata objectForKey:@"subMenuList"] count] > 0) {
                
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_%@_%@_%@",
                                                  NCS([self.sectioninfodata objectForKey:@"sectionName"]),
                                                  NCS([[[self.sectioninfodata objectForKey:@"subMenuList"] objectAtIndex:indexFXC] objectForKey:@"sectionName"]),
                                                  NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]) ]
                 
                                       withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", (int)indexPath.row ],
                                                    NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"]) ]  ];
                
                
            }else {
                
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_%@_%@",
                                                  NCS([self.sectioninfodata objectForKey:@"sectionName"]),
                                                  NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]) ]
                 
                                       withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", (int)indexPath.row ],  NCS( [[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"]) ]  ];
            }
            
            

            
        }
        
        else {
            
            
            if (NCA([self.sectioninfodata objectForKey:@"subMenuList"]) && [(NSArray *)[self.sectioninfodata objectForKey:@"subMenuList"] count] > 0) {
                
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_%@_%@_%@",
                                                  NCS([self.sectioninfodata objectForKey:@"sectionName"]),
                                                  NCS([[[self.sectioninfodata objectForKey:@"subMenuList"] objectAtIndex:indexFXC] objectForKey:@"sectionName"] ),
                                                  NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]) ]
                 
                                       withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", (int)indexPath.row ],  (isexistpdname)?NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]) : NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"]) ]  ];
                
                
            }else {
                
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_%@_%@",
                                                  NCS([self.sectioninfodata objectForKey:@"sectionName"]),
                                                  NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"viewType"]) ]
                 
                                       withLabel:  [NSString stringWithFormat:@"%@_%@", [NSString stringWithFormat:@"%d", (int)indexPath.row ],  (isexistpdname)?NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"productName"]) : NCS([[self.sectionarrdata objectAtIndex:indexPath.row] objectForKey:@"linkUrl"]) ]  ];
            }
            
            

            
            
        }
                
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleCommonCellView contentBinding : %@", exception);
    }
    @finally {
        
    }
    
    
}




@end
