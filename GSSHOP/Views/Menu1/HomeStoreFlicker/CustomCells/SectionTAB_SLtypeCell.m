//
//  SectionTAB_SLtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 12. 8..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionTAB_SLtypeCell.h"
#import "HztbGlobalVariables.h"
#import "DealCell.h"


@implementation SectionTAB_SLtypeCell
@synthesize targettb;
@synthesize view_Default;
@synthesize imageBackGround;
@synthesize horizontalTableView;

@synthesize articles;
@synthesize loadingImageURLString;
@synthesize imageLoadingOperation;
@synthesize viewHorizontal;

@synthesize btnTab01;
@synthesize btnTab02;
@synthesize btnTab03;

@synthesize imgArrow;
@synthesize arrowCenter;

@synthesize btn01Leading;
@synthesize btn02Center;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.horizontalTableView = [[UITableView alloc] initWithFrame:self.viewHorizontal.frame];
    self.horizontalTableView.showsVerticalScrollIndicator = NO;
    self.horizontalTableView.showsHorizontalScrollIndicator = NO;
    self.horizontalTableView.delegate = self;
    self.horizontalTableView.dataSource = self;
    self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    
    [self.horizontalTableView setFrame:CGRectMake(0.0, 5.0, APPFULLWIDTH, self.viewHorizontal.frame.size.height-5.0)];
    
    [self.viewHorizontal addSubview:self.horizontalTableView];
    
    self.horizontalTableView.rowHeight = kCellWidth;
    self.horizontalTableView.backgroundColor = [UIColor clearColor];
    
    
    
    self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    idxTab = 0;
    
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
    

    @try {
        self.row_dic = rowinfoDic;
    }
    @catch (NSException *exception) {
        NSLog(@"exceptionexceptionexception = %@",exception);
        
        return;
    }

    
    
    
    
    
    NSArray *tarr = (NSArray *)[rowinfoDic objectForKey:@"subProductList"];
    if(NCA(tarr))
    {
        for (NSInteger i=0; i<[tarr count]; i++)
        {
            if(NCO([[tarr objectAtIndex:i] objectForKey:@"imageList"]))
            {
                NSDictionary *dicBtn = [[tarr objectAtIndex:i] objectForKey:@"imageList"];
                
                NSLog(@"dicBtn = %@",dicBtn);
                [self setButtonImages:dicBtn withButton:(UIButton *)[view_Default viewWithTag:1000+i]];
            }
        }
    }
    
    if (NCA(tarr) && [tarr count] == 2) {
        UIButton *btn01 = (UIButton *)[view_Default viewWithTag:1000];
        UIButton *btn02 = (UIButton *)[view_Default viewWithTag:1001];
        
        
        [view_Default removeConstraint:btn01Leading];
        [view_Default removeConstraint:btn02Center];

        
        btn01Leading = [NSLayoutConstraint constraintWithItem:btn01
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:imageBackGround
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:-imageBackGround.frame.size.width/4.0];
        [view_Default addConstraint:btn01Leading];

        btn02Center = [NSLayoutConstraint constraintWithItem:btn02
                                                    attribute:NSLayoutAttributeCenterX
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:imageBackGround
                                                    attribute:NSLayoutAttributeCenterX
                                                   multiplier:1.0
                                                     constant:imageBackGround.frame.size.width/4.0];
        [view_Default addConstraint:btn02Center];
        
        
        
        [view_Default layoutIfNeeded];
        
    }
    
    
    if (NCA(tarr) && [tarr count] > 0) {
        
        [self onBtnTabButton:(UIButton *)[view_Default viewWithTag:1000+idxTab]];
        
        
        
    }
}


-(void)setButtonImages:(NSDictionary*)dic withButton:(UIButton *)btn{
    
    NSString *imageURL = NCS([dic objectForKey:@"off"]);
    if([imageURL length] > 0){
        
        btn.hidden = NO;
        
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        
                                                                                  NSLog(@"Data from cache Image");
                                                                                  [btn setImage:fetchedImage forState:UIControlStateNormal];
                                                                                  
                                                                              } else {
                                                                                  
                                                                                  
                                                                                  btn.alpha = 0;
                                                                                  
                                                                                  [btn setImage:fetchedImage forState:UIControlStateNormal];
                                                                                  
                                                                                  // nami0342 - main thread
                                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                                      [UIView animateWithDuration:0.2f
                                                                                                        delay:0.0f
                                                                                                      options:UIViewAnimationOptionCurveEaseInOut
                                                                                                   animations:^{
                                                                                                       
                                                                                                       btn.alpha = 1;
                                                                                                       
                                                                                                   }
                                                                                                   completion:^(BOOL finished) {
                                                                                                       
                                                                                                   }];

                                                                                  });
                                                                              } 
                });
                
            }
                                                                          }];
        
        NSString *strImageURL = NCS([dic objectForKey:@"on"]);
        
        [ImageDownManager blockImageDownWithURL:strImageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [strImageURL isEqualToString:strInputURL]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        
                                                                                  NSLog(@"Data from cache Image");
                                                                                  [btn setImage:fetchedImage forState:UIControlStateHighlighted];
                                                                                  [btn setImage:fetchedImage forState:UIControlStateSelected];
                                                                                  
                                                                              } else {
                                                                                  
                                                                                  
                                                                                  btn.alpha = 0;
                                                                                  [btn setImage:fetchedImage forState:UIControlStateHighlighted];
                                                                                  [btn setImage:fetchedImage forState:UIControlStateSelected];
                                                                                  
                                                                                  // nami0342 - main thread
                                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                                      [UIView animateWithDuration:0.2f
                                                                                                        delay:0.0f
                                                                                                      options:UIViewAnimationOptionCurveEaseInOut
                                                                                                   animations:^{
                                                                                                       
                                                                                                       btn.alpha = 1;
                                                                                                       
                                                                                                   }
                                                                                                   completion:^(BOOL finished) {
                                                                                                       
                                                                                                   }];
                                                                                  });
                                                                                  
                                                                              }
                });
                                                                              
            }
      }];
        
    }else {
        
    }
}


-(void)setBackgroundImage{
    
    NSString *imageURL = nil;
    @try {
        imageURL = NCS([[[(NSArray *)[self.row_dic objectForKey:@"subProductList"] objectAtIndex:idxTab] objectForKey:@"imageList"] objectForKey:@"bg"]);
    }
    @catch (NSException *exception) {
        NSLog(@"exceptionexceptionexception = %@",exception);
    }
    
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
    
    
    [self.targettb dctypetouchEventTBCell:[self.articles objectAtIndex:indexPath.row]  andCnum:[NSNumber numberWithInt:(int)indexPath.row] withCallType:[NSString stringWithFormat:@"TAB_SL||%lu",(long)idxTab]];
    
    NSLog(@" 인선택 %ld  %@",(long)indexPath.row , [self.articles objectAtIndex:indexPath.row]);
}

-(IBAction)onBtnTabButton:(id)sender{
    
    idxTab = [((UIButton *)sender) tag] - 1000;
    
    [self setBackgroundImage];
    

    
    UIButton *btnSender = (UIButton *)sender;
    
    NSLog(@"btnSender = %@",btnSender);
    
    if (btnSender == arrowCenter.secondItem) {
        NSLog(@"arrowCenter.secondItem = %@",arrowCenter.secondItem);
        return;
    }
    
    for (NSInteger i=0; i<3; i++) {
        UIButton *btnCheck = (UIButton *)[view_Default viewWithTag:1000+i];
        btnCheck.selected = (idxTab==i)?YES:NO;
    }

    
    [view_Default removeConstraint:arrowCenter];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         arrowCenter = [NSLayoutConstraint constraintWithItem:imgArrow
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:btnSender
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0.0];
                         
                         [view_Default addConstraint:arrowCenter];
                         
                         [view_Default layoutIfNeeded];
                         
                     }
     
                     completion:^(BOOL finished) {
                         self.articles =  [[(NSArray *)[self.row_dic objectForKey:@"subProductList"] objectAtIndex:idxTab] objectForKey:@"subProductList"];
                         [self.horizontalTableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
                         [self.horizontalTableView reloadData];
                         
                        [self.targettb dctypetouchEventTBCell:[[self.row_dic objectForKey:@"subProductList"] objectAtIndex:idxTab]  andCnum:[NSNumber numberWithInt:-1] withCallType:[NSString stringWithFormat:@"TAB_SL||%lu",(long)idxTab]];
                     }];
    
}

@end
