//
//  HorizontalTableCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 3. 16..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface HorizontalTableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_horizontalTableView;
    NSArray *_articles;
}
@property (nonatomic, weak) id targettb;
@property (nonatomic, retain) UITableView *horizontalTableView;
@property (nonatomic, retain) NSArray *articles;

@end
 