//
//  HorizontalProductTBCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 3. 19..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//


#import "HorizontalProductTBCell.h"
#import "DealCell.h"

#import "HztbGlobalVariables.h"

@implementation HorizontalProductTBCell

@synthesize horizontalTableView = _horizontalTableView;
@synthesize articles = _articles;
@synthesize targettb = _targettb;
@synthesize momdic = _momdic;

@synthesize loadingImageURLString = loadingImageURLString_;
@synthesize imageLoadingOperation = imageLoadingOperation_;

- (id)initWithFrame:(CGRect)frame withMomDic:(NSDictionary*)dic
{
    if ((self = [super initWithFrame:frame]))
    {
        
        UIView* tcontainerv = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, kProductFullCellHeight)];
        tcontainerv.backgroundColor= [UIColor whiteColor];
        
        
        UILabel *ctitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, APPFULLWIDTH-80, 20)];
        self.momtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, APPFULLWIDTH-100, 20)];
        
        ctitleLabel.textAlignment = NSTextAlignmentLeft;
        [ctitleLabel setTextColor:[Mocha_Util getColor:@"C3C3C3"]];
        [ctitleLabel setBackgroundColor:[UIColor clearColor]];
        ctitleLabel.font = [UIFont systemFontOfSize:14];;
        ctitleLabel.text = GSSLocalizedString(@"section_horizontal_producttbcell_saw");
        [tcontainerv addSubview:ctitleLabel];
        
        
        self.momtitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.momtitleLabel setTextColor:[Mocha_Util getColor:@"444444"]];
        [self.momtitleLabel setBackgroundColor:[UIColor clearColor]];
        self.momtitleLabel.font = [UIFont systemFontOfSize:15];;
        
        self.momtitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        NSString *  categoryName = [dic objectForKey:@"productName"];
        self.momtitleLabel.text = categoryName;
        [tcontainerv addSubview:self.momtitleLabel];
        
        
        self.momthumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60.0 , 60.0)];

        self.momthumbnail.backgroundColor = [UIColor clearColor];
        
        
        
        
      
        [ self.momthumbnail.layer setMasksToBounds:YES];
        self.momthumbnail.layer.cornerRadius =  self.momthumbnail.frame.size.height/2.0;
        self.momthumbnail.layer.shadowOffset = CGSizeMake(0, 0);
        self.momthumbnail.layer.shadowRadius = 0.0;
        self.momthumbnail.layer.borderWidth = 0;
      
        
        [tcontainerv addSubview:self.momthumbnail];
        
        
        
        UIImageView *masktimgv = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 76.0 , 76.0)];
        masktimgv.image = [UIImage imageNamed:@"spsection_maskcircle.png"];
        
        [tcontainerv addSubview:masktimgv];
        
        
        
        
        UIView *sbtmlineView = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH,  ([Common_Util isRetinaScale])?1.0:1.0)] ;
        sbtmlineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin  |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin ;
        sbtmlineView.backgroundColor = [Mocha_Util getColor:@"D9D9D9"];
        [tcontainerv addSubview:sbtmlineView];
        
        
        
        
        UIView *toplineView = [[UIView alloc] initWithFrame:CGRectMake(0,  kHeadlineProductSectionHeight-1, APPFULLWIDTH, ([Common_Util isRetinaScale])?1.0:1.0)] ;
        toplineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin  |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin ;
        toplineView.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
        [tcontainerv addSubview:toplineView];
        
        UIView *ctnrBaseView = [[UIView alloc] initWithFrame:CGRectMake(0,  kHeadlineProductSectionHeight, APPFULLWIDTH,kCellHeight)] ;
        
        
        [tcontainerv addSubview:ctnrBaseView];
        
        
        self.horizontalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH-kRightCellPadding, kCellHeight)];
        self.horizontalTableView.showsVerticalScrollIndicator = NO;
        self.horizontalTableView.showsHorizontalScrollIndicator = NO;
        self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        
        [self.horizontalTableView setFrame:CGRectMake(kRowHorizontalPadding , 0 ,APPFULLWIDTH-kRightCellPadding, kCellHeight)];
        
        self.horizontalTableView.rowHeight = kCellWidth;
        self.horizontalTableView.backgroundColor = [UIColor whiteColor];
        
        self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.horizontalTableView.dataSource = self;
        self.horizontalTableView.delegate = self;
         
        
        
        [ctnrBaseView addSubview:self.horizontalTableView];
        
        
        
        
        UIView *btmlineView = [[UIView alloc] initWithFrame:CGRectMake(0,  kProductFullCellHeight, APPFULLWIDTH,  ([Common_Util isRetinaScale])?1.0:1.0)] ;
        btmlineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin  |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin ;
        btmlineView.backgroundColor = [Mocha_Util getColor:@"D9D9D9"];
        [tcontainerv addSubview:btmlineView];
        
        [self addSubview:tcontainerv];
        
        
        
        
        
        UIView* tttv = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, 5)];
        tttv.backgroundColor= [UIColor whiteColor];
        _horizontalTableView.tableHeaderView.frame =  CGRectMake(0,  0, APPFULLWIDTH, 5);
        _horizontalTableView.tableHeaderView.layer.masksToBounds = YES;
        _horizontalTableView.tableHeaderView = tttv;
        
        
        
        UIView* ttbv = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, 5)];
        ttbv.backgroundColor= [UIColor whiteColor];
        _horizontalTableView.tableFooterView.frame =  CGRectMake(0,  0, APPFULLWIDTH, 5);
        _horizontalTableView.tableFooterView.layer.masksToBounds = YES;
        _horizontalTableView.tableFooterView = ttbv;
        

        
        
        
        
        if([NCS([dic objectForKey:@"imageUrl"]) length] > 0){
            
            self.loadingImageURLString =  NCS([dic objectForKey:@"imageUrl"]);
            
            [ImageDownManager blockImageDownWithURL:self.loadingImageURLString responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [self.loadingImageURLString isEqualToString:strInputURL]){

                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache) {
                          
                          self.momthumbnail.image = fetchedImage;
                      } else {
                          
                          
                          self.momthumbnail.alpha = 0;
                          self.momthumbnail.image = fetchedImage;
                          
                          
                          [UIView animateWithDuration:0.2f
                                                delay:0.0f
                                              options:UIViewAnimationOptionCurveEaseInOut
                                           animations:^{
                                               
                                               self.momthumbnail.alpha = 1;
                                               
                                           }
                                           completion:^(BOOL finished) {
                                               
                                           }];
                        
                      }
                    });
                                                                                  
                      
                }
                
              }];
        }
        else
        {
            
        }
        
    }
    
    return self;
}





-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    
    
    if([NCS([rowinfoArr objectForKey:@"imageUrl"]) length] > 0){
        
        self.loadingImageURLString =  NCS([rowinfoArr objectForKey:@"imageUrl"]);
        
        [ImageDownManager blockImageDownWithURL:self.loadingImageURLString responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [self.loadingImageURLString isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                      self.momthumbnail.image = fetchedImage;
                  } else {
                      
                      
                      self.momthumbnail.alpha = 0;
                      self.momthumbnail.image = fetchedImage;
                      
                      // nami0342 - main thread
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           
                                           self.momthumbnail.alpha = 1;
                                           
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






#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
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
    
    [self.targettb touchEventDealCell:[self.articles objectAtIndex:indexPath.row]];
    
    NSLog(@" 인선택 %ld  %@",(long)indexPath.row , [self.articles objectAtIndex:indexPath.row]);
}



#pragma mark - Memory Management

- (NSString *) reuseIdentifier
{
    return @"HorizontalCell";
}

- (void)dealloc
{
    self.horizontalTableView = nil;
    self.articles = nil;
    
}

@end
