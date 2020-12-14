//
//  SectionSPLtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 20..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionSPLtypeCell.h"
#import "HztbGlobalVariables.h"
#import "DealCell.h"


@implementation SectionSPLtypeCell
@synthesize targettb;
@synthesize view_Default;
@synthesize imageBackGround;
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
    imageBackGround.image = nil;
}



-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic {
    

    NSLog(@"viewHorizontal.frame = %@",NSStringFromCGRect(viewHorizontal.frame));
    NSLog(@"horizontalTableView.frame = %@",NSStringFromCGRect(horizontalTableView.frame));
    
    self.row_dic = rowinfoDic;

    
    NSString *imageURL = NCS([self.row_dic objectForKey:@"imageUrl"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache)
                                      {
                                          self.imageBackGround.image = fetchedImage;
                                      }
                                      else
                                      {
                                          self.imageBackGround.alpha = 0;
                                          self.imageBackGround.image = fetchedImage;
                                          
                                          
                                          
                                          
                                          [UIView animateWithDuration:0.2f
                                                                delay:0.0f
                                                              options:UIViewAnimationOptionCurveEaseInOut
                                                           animations:^{
                                                               
                                                               self.imageBackGround.alpha = 1;
                                                               
                                                           }
                                                           completion:^(BOOL finished) {
                                                               
                                                           }];
                                      }
            });
                                      
        }
      }];
    
    
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
    static NSString *CellIdentifier = @"DealCell";
    
    __block DealCell *cell = (DealCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[DealCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)] ;
    }
    
    __block NSDictionary *currentArticle = [self.articles objectAtIndex:indexPath.row];
    
    
    
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setCellInfoNDrawData:[self.articles objectAtIndex:indexPath.row]];
            
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
    
    
    [self.targettb dctypetouchEventTBCell:[self.articles objectAtIndex:indexPath.row]  andCnum:[NSNumber numberWithInt:(int)indexPath.row] withCallType:@"SPL"];
    
    NSLog(@" 인선택 %ld  %@",(long)indexPath.row , [self.articles objectAtIndex:indexPath.row]);
}

-(IBAction)onBtnBackGroundImage:(id)sender{
    [self.targettb dctypetouchEventTBCell:self.row_dic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"SPLBACKGROUND"   ];
}

@end
