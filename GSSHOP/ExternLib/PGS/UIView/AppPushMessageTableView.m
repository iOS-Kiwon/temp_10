#import "AppPushMessageTableView.h"
#import "AppPushDatabase.h"
#import "AppPushConstants.h"
#import "AppDelegate.h"
#define CELL_HEIGHT_NORMAL    125
#define CELL_HEIGHT_EXISTIMG  280

@implementation AppPushMessageTableView
@synthesize delegateList;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    @try {
        self = [super initWithFrame:frame style:style];
        if (self) {
            [self viewInitalization];
        }
        return self;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView initWithFrame : %@", exception);
    }
}
- (void) dealloc
{
    _tableDataList=nil;
}
#pragma mark - inner Method
- (void) viewInitalization
{
    @try {
        if(_tableDataList==nil) _tableDataList = [[NSMutableArray alloc]init];
        isThisCommComplete = NO;
        self.delegate = self;
        self.dataSource = self;
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setBackgroundColor:[Mocha_Util getColor:@"ebebeb"]];
        self.showsVerticalScrollIndicator = YES;
        // self.scrollsToTop = NO;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView viewInitalization : %@", exception);
    }
}

- (NSString *)getMaxID {
    @try {
        @synchronized(_tableDataList) {
            if([_tableDataList count]>0) {
                NSDictionary *dic = [_tableDataList objectAtIndex:0];
                return [dic valueForKey:@"MSG_ID"];
            } else {
                return nil;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView getMinID : %@", exception);
        return nil;
    }
}
- (NSString *)getMinID {
    @try {
        @synchronized(_tableDataList) {
            
            if([_tableDataList count]>0) {
                NSDictionary *dic = [_tableDataList objectAtIndex:([_tableDataList count]-1)];
                return [dic valueForKey:@"MSG_ID"];
            } else {
                return nil;
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView getMaxID : %@", exception);
        return nil;
    }
}
- (NSDictionary *)getMinMaxID {
    @try {
        @synchronized(_tableDataList) {
            if([_tableDataList count]==0) return nil;
            return [NSDictionary dictionaryWithObjectsAndKeys:
                    [self getMinID],MIN_ID,
                    [self getMaxID],MAX_ID,
                    nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView getMinMaxID : %@", exception);
        return nil;
    }
}

#pragma mark - tablebinding

- (BOOL)haveList {
    @try {
        @synchronized(_tableDataList) {
            if([_tableDataList count]>0) {
                return YES;
            } else {
                return NO;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView haveList : %@", exception);
        return NO;
    }
}

- (void)removeTableList {
    @try {
        @synchronized(_tableDataList) {
            
            [_tableDataList removeAllObjects];
        }
        [self reloadAniTB];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView removeTableList : %@", exception);
    }
}
- (void) setTableList:(NSArray *)argArr {
    @try {
        if (argArr == nil || [argArr count]==0) {
            isThisCommComplete = YES;
            
            [ApplicationDelegate offloadingindicator];
            return;
        }
        @synchronized(_tableDataList) {
            [_tableDataList removeAllObjects];
            [_tableDataList setArray:argArr];
        }
        
        [ApplicationDelegate offloadingindicator];
        [self reloadAniTB];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView setTableList : %@", exception);
    }
}
- (void) addTableList:(NSArray *)argArr {
    @try {
        if (argArr == nil || [argArr count]==0) {
            isThisCommComplete = YES;
            
            [ApplicationDelegate offloadingindicator];
            return;
        }
        @synchronized(_tableDataList) {
            [_tableDataList addObjectsFromArray:argArr];
        }
        
        [self reloadAniTB];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView addTableList : %@", exception);
    }
}
- (void)insertTableList:(NSArray *)argArr middleIndex:(int)argIndex isMiddle:(BOOL)argIsMiddle {
    @try {
        if (argArr == nil || [argArr count]==0) {
            [self reloadData];
            
            return;
        }
        //beforeContentHeight = self.contentSize.height;
        @synchronized(_tableDataList) {
            if(argIsMiddle) [_tableDataList removeObjectAtIndex:argIndex];
            [_tableDataList insertObjects:argArr
                                atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(argIndex, [argArr count])]];
        }
        
        [self reloadAniTB];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView insertTableList : %@", exception);
    }
}
#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @try {
        return 1;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView numberOfSectionsInTableView : %@", exception);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
        NSLog(@"  %lu", (unsigned long)[_tableDataList count]);
        return [_tableDataList count];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView numberOfRowsInSection : %@", exception);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        
        
        static NSString *CellNoneImgIdentifier = @"AppPushNoneImgCellTableViewCell";
        static NSString *CellImgIdentifier = @"AppPushImgCellTableViewCell";
        
        
        
        NSDictionary *dic = [_tableDataList objectAtIndex:indexPath.row];
        
        
        //none imgcell
        if  ([[dic objectForKey:AMAIL_MSG_MAP3] isEqualToString:@""]) {
            
            
            AppPushNoneImgCellTableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:CellNoneImgIdentifier];
            
            
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AppPushNoneImgCellTableViewCell" owner:self options:nil];
                for (id oneObject in nib)
                    if ([oneObject isKindOfClass:[AppPushNoneImgCellTableViewCell class]]) {
                        cell = (AppPushNoneImgCellTableViewCell *)oneObject;
                        
                        [cell setData:dic];
                        
                    }
                
            }else {
                
                [cell setData:dic];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            return  cell;
            
        }
        
        else {
            
            
            AppPushImgCellTableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:CellImgIdentifier];
            
            
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AppPushImgCellTableViewCell" owner:self options:nil];
                for (id oneObject in nib)
                    if ([oneObject isKindOfClass:[AppPushImgCellTableViewCell class]]) {
                        cell = (AppPushImgCellTableViewCell *)oneObject;
                        
                        [cell setData:dic];
                        
                    }
                
                
            }else {
                
                [cell setData:dic];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            
            return  cell;
            
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageTableView cellForRowAtIndexPath : %@", exception);
        return nil;
    }
}
// cell의 높이를 정의하기 위한 이벤트
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [_tableDataList objectAtIndex:indexPath.row];
    
    
    if([[dic objectForKey:AMAIL_MSG_MAP3] isEqualToString:@""]){
        
        return  CELL_HEIGHT_NORMAL;
    }else {
        
        return [Common_Util DPRateVAL:CELL_HEIGHT_EXISTIMG withPercent:55];
        
    }
    
}
// cell을 선택했을때 이벤트
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [delegateList pressTableCell:[_tableDataList objectAtIndex:indexPath.row]];
    
}


-(UIView*)noneMessageview {
    UIView *introwview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, APPFULLHEIGHT-85)] ;
    
    
    UIImageView* warnv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PMS.bundle/image/push_nomsg_icon.png"] ];
    warnv.frame = CGRectMake((APPFULLWIDTH/2)-(70/2), 20, 70, 70);
    [introwview addSubview:warnv];
    
    
    
    
    
    UILabel  *nomsglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, APPFULLWIDTH, 36)];
    [nomsglabel setTextAlignment:NSTextAlignmentCenter];
    [nomsglabel setFont:[UIFont systemFontOfSize:15.0f]];
    [nomsglabel setTextColor:[Mocha_Util getColor:@"444444"]];
    [nomsglabel setBackgroundColor:[UIColor clearColor]];
    [nomsglabel setText:GSSLocalizedString(@"pms_no_msg")];
    
    [introwview addSubview:nomsglabel];
    
    
    
    
    introwview.alpha = 1.0f;
    
    toplineView = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, 1)] ;
    toplineView.backgroundColor = [Mocha_Util getColor:@"D1D1D1"];
    [introwview addSubview:toplineView];
    
    return introwview;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    @synchronized(_tableDataList) {
        
        if( isThisCommComplete == YES) {
            
            if([_tableDataList count]>0) {
                
                [self setBackgroundColor:[Mocha_Util getColor:@"ebebeb"]];
                return nil;
            } else {
                
                
                return [self noneMessageview];
            }
        }else {
            
            [self setBackgroundColor:[Mocha_Util getColor:@"ebebeb"]];
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    @synchronized(_tableDataList) {
        if([_tableDataList count]>0) {
            return 0.0f;
        }else {
            return APPFULLHEIGHT-85;
        }
    }
}


-(void) reloadAniTB {
    
    // nami0342 - To run on the main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self reloadData];
        
        
        // nami0342 - CRASH!!!!!!!
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             [self setContentOffset:CGPointZero];
                         }
         
                         completion:^(BOOL finished){
                             
                             if([_tableDataList count]>0) {
                                 
                                 
                                 toplineView.hidden = YES;
                                 self.scrollEnabled = YES;
                                 [self setBackgroundColor:[Mocha_Util getColor:@"ebebeb"]];
                             }else {
                                 toplineView.hidden = NO;
                                 self.scrollEnabled = NO;
                                 [self setBackgroundColor:[Mocha_Util getColor:@"ffffff"]];
                             }
                             
                             [CATransaction begin];
                             CATransition *transition;
                             transition = [CATransition animation];
                             transition.type = kCATransitionFade;
                             transition.subtype = kCATransitionFromBottom;
                             transition.duration = 0.5;
                             
                             [CATransaction setValue:(id)kCFBooleanTrue
                                              forKey:kCATransactionAnimationDuration];
                             
                             
                             [[self layer] addAnimation:transition forKey:nil];
                             
                             [CATransaction commit];
                             
                         }];
    });
    
    
    
    
    
}


@end
