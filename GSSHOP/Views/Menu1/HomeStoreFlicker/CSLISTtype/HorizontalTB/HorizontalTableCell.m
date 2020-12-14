//
//  HorizontalTableCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 3. 16..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "HorizontalTableCell.h"
#import "DealCell.h"

#import "HztbGlobalVariables.h"

@implementation HorizontalTableCell

@synthesize horizontalTableView = _horizontalTableView;
@synthesize articles = _articles;
@synthesize targettb = _targettb;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        
        UIView* tcontainerv = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, kCellHeight)];
        tcontainerv.backgroundColor= [UIColor whiteColor];
        
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
        [tcontainerv addSubview:self.horizontalTableView];
        
        
        UIView *btmlineView = [[UIView alloc] initWithFrame:CGRectMake(0,  kCellHeight, APPFULLWIDTH,  ([Common_Util isRetinaScale])?1.0:1.0)] ;
        btmlineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin  |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin ;
        btmlineView.backgroundColor = [Mocha_Util getColor:@"D9D9D9"];
        [tcontainerv addSubview:btmlineView];
        
        [self addSubview:tcontainerv];
        
        UIView* tttv = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, 4)];
        tttv.backgroundColor= [UIColor whiteColor];
        _horizontalTableView.tableHeaderView.frame =  CGRectMake(0,  0, APPFULLWIDTH, 4);
        _horizontalTableView.tableHeaderView.layer.masksToBounds = YES;
        _horizontalTableView.tableHeaderView = tttv;
        
        
        
        UIView* ttbv = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, 4)];
        ttbv.backgroundColor= [UIColor whiteColor];
        _horizontalTableView.tableFooterView.frame =  CGRectMake(0,  0, APPFULLWIDTH, 4);
        _horizontalTableView.tableFooterView.layer.masksToBounds = YES;
        _horizontalTableView.tableFooterView = ttbv;

        
    }
    
    return self;
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
