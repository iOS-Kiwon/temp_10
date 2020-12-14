//
//  SectionSPCtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 20..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionSPCtypeCell.h"
#import "HztbGlobalVariables.h"
#import "SectionSPCtypeSubCell.h"


@implementation SectionSPCtypeCell
@synthesize targettb;
@synthesize view_Default;
@synthesize btnBackGround;
@synthesize horizontalTableView;

@synthesize articles;
@synthesize loadingImageURLString;
@synthesize imageLoadingOperation;
@synthesize viewHorizontal;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.horizontalTableView = [[UITableView alloc] initWithFrame:self.viewHorizontal.frame];
    self.horizontalTableView.showsVerticalScrollIndicator = NO;
    self.horizontalTableView.showsHorizontalScrollIndicator = NO;
    self.horizontalTableView.delegate = self;
    self.horizontalTableView.dataSource = self;
    self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    
    [self.horizontalTableView setFrame:CGRectMake(0.0, 0.0, APPFULLWIDTH, self.viewHorizontal.frame.size.height)];
    
    [self.viewHorizontal addSubview:self.horizontalTableView];
    
    self.horizontalTableView.rowHeight = kCellWidth;
    self.horizontalTableView.backgroundColor = [UIColor clearColor];
    
    
    
    self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




-(void)prepareForReuse{
    [super prepareForReuse];
    [self.horizontalTableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic {
    
    
    NSLog(@"viewHorizontal.frame = %@",NSStringFromCGRect(viewHorizontal.frame));
    NSLog(@"horizontalTableView.frame = %@",NSStringFromCGRect(horizontalTableView.frame));
    
    self.row_dic = rowinfoDic;
    
    NSLog(@"self.row_dic = %@",self.row_dic);
    
    
    
    if (NCA([rowinfoDic objectForKey:@"subProductList"]) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0) {
        
        self.articles =  [rowinfoDic objectForKey:@"subProductList"];
        [self.horizontalTableView reloadData];
        
    }
    
    
}






#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.articles count] > 0 && indexPath.row +1 == [self.articles count]){
        return 130.0;
    }else{
        return 120.0;
    }
        
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SectionSPCtypeSubCell";
    
    __block SectionSPCtypeSubCell *cell = (SectionSPCtypeSubCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionSPCtypeSubCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[SectionSPCtypeSubCell class]]) {
                cell = (SectionSPCtypeSubCell *)oneObject;
            }
    }
    
    
    //108x158
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setCellInfoNDrawData:[self.articles objectAtIndex:indexPath.row]];
            
        });
    });
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.targettb dctypetouchEventTBCell:[self.articles objectAtIndex:indexPath.row]  andCnum:[NSNumber numberWithInt:(int)indexPath.row] withCallType:@"SPC"];
    
    NSLog(@" 인선택 %ld  %@",(long)indexPath.row , [self.articles objectAtIndex:indexPath.row]);
}

-(IBAction)onBtnBackGroundImage:(id)sender{
    [self.targettb dctypetouchEventTBCell:self.row_dic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"SPCBACKGROUND"   ];
}

@end
