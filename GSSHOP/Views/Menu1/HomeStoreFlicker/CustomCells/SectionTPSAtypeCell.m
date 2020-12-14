//
//  SectionTPSACell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 5. 31..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//
// 플랙서블 E
#import "SectionTPSAtypeCell.h"

#import "HztbGlobalVariables.h"
#import "DealCell.h"
#import "LoginData.h"

@implementation SectionTPSAtypeCell

@synthesize horizontalTableView = _horizontalTableView;
@synthesize articles,imgArrow;
@synthesize targettb = _targettb;


@synthesize loadingImageURLString = loadingImageURLString_;


- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.backgroundColor = [UIColor clearColor];
    
    self.horizontalTableView.showsVerticalScrollIndicator = NO;
    self.horizontalTableView.showsHorizontalScrollIndicator = NO;
    self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    
    [self.horizontalTableView setFrame:CGRectMake(0 , 55 ,APPFULLWIDTH, 200.0)];
    
    self.horizontalTableView.rowHeight = kCellWidth;
    self.horizontalTableView.backgroundColor = [UIColor clearColor];
    
    
    
    self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.horizontalTableView.separatorColor = [UIColor blueColor];
    
    self.horizontalTableView.dataSource = self;
    self.horizontalTableView.delegate = self;
    
    
    
    self.productName.text = @"";
    self.productName.hidden = YES;
    
    self.imgArrow.hidden = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr
{
    self.backgroundColor = [UIColor clearColor];
    NSLog(@"rowinfoArrrowinfoArr = %@",rowinfoArr);
    
    self.articles  = (NSArray *)[rowinfoArr objectForKey:@"subProductList"];
    
   
    self.productName.text = NCS([rowinfoArr objectForKey:@"productName"]);
    if([self.productName.text length] > 0)
    {
        self.productName.hidden = NO;
    }
    else
    {
        self.productName.hidden = YES;
    }
    
    //linkUrl이 없으면 화살표 없앰.
    if( [NCS([rowinfoArr objectForKey:@"linkUrl"]) length] > 0 ){
        self.imgArrow.hidden = NO;
    }
    else{
        self.imgArrow.hidden = YES;
    }
    
    
    [self.horizontalTableView reloadData];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self.horizontalTableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
}




#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count: %lu",(unsigned long)[self.articles count]);
    return [self.articles count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellWidth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DealCell";
    
    __block DealCell *cell = (DealCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[DealCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)] ;
    }
    
    NSLog(@"count: %lu",(unsigned long)indexPath.row);

    __block NSDictionary *currentArticle = [self.articles objectAtIndex:indexPath.row];
    
    
    
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [cell setCellInfoNDrawData:currentArticle];
            
        });
    });
    
    
    
    cell.titleLabel.text = [currentArticle objectForKey:@"productName"];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [currentArticle objectForKey:@"salePrice"]  ];
    
    cell.wonLabel.text = [NSString stringWithFormat:@"%@", [currentArticle objectForKey:@"exposePriceText"]  ];
    
    
    
    CGSize size = [cell.priceLabel sizeThatFits:cell.priceLabel.frame.size];
    
    cell.wonLabel.frame =  CGRectMake(size.width, cell.wonLabel.frame.origin.y, cell.wonLabel.frame.size.width, cell.wonLabel.frame.size.height);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.targettb dctypetouchEventTBCell:[self.articles objectAtIndex:indexPath.row]  andCnum:[NSNumber numberWithInt:(int)indexPath.row] withCallType:@"TP_SA"];
}

@end
