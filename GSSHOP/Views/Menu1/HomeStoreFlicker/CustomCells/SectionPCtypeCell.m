//
//  SectionPCtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 23..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionPCtypeCell.h"
#import "AppDelegate.h"
#import "SectionPCtypeSubCell.h"

@implementation SectionPCtypeCell
@synthesize target;
@synthesize view_Default;
@synthesize row_dic;
@synthesize loadingImageURLString;
@synthesize imageLoadingOperation;
@synthesize lblTitle;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.arrProgram = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    self.tableProgram = [[UITableView alloc] initWithFrame:self.viewProgram.frame];
    self.tableProgram.showsVerticalScrollIndicator = NO;
    self.tableProgram.showsHorizontalScrollIndicator = NO;
    self.tableProgram.delegate = self;
    self.tableProgram.dataSource = self;
    self.tableProgram.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    [self.tableProgram setFrame:CGRectMake(0.0, 0.0, APPFULLWIDTH, 139.0)];
    [self.viewProgram addSubview:self.tableProgram];
    self.tableProgram.backgroundColor = [UIColor clearColor];
    self.tableProgram.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) prepareForReuse {
    [super prepareForReuse];
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic {
    self.row_dic = rowinfoDic;
    if ([[rowinfoDic objectForKey:@"productName"] isKindOfClass:[NSNull class]] == NO && [[rowinfoDic objectForKey:@"productName"] length] > 0) {
        self.lblTitle.text = [rowinfoDic objectForKey:@"productName"];
    }
    else {
        self.lblTitle.text = @"인기 프로그램";
    }
    NSString *imageURL = NCS([rowinfoDic objectForKey:@"imageUrl"]);
    if ([imageURL length] > 0 && [imageURL hasPrefix:@"http"]) {
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(isInCache) {
                        self.imgTitleIcon.image = fetchedImage;
                    }
                    else {
                        self.imgTitleIcon.alpha = 0;
                        self.imgTitleIcon.image = fetchedImage;
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.imgTitleIcon.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                    }
                });
            }
        }];
    }
    if (NCA([self.row_dic objectForKey:@"subProductList"])) {
        [self.arrProgram addObjectsFromArray:[self.row_dic objectForKey:@"subProductList"]];
    }
}

- (IBAction)onBtnBanner:(NSIndexPath *)path {
    @try {
        [self.target dctypetouchEventTBCell:[[self.row_dic objectForKey:@"subProductList"] objectAtIndex:path.row]  andCnum:[NSNumber numberWithInt:(int)path.row] withCallType:@"PC"];
    }
    @catch (NSException *exception) {
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrProgram count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.arrProgram count] > 0 && indexPath.row == 0) {
        return 10.0 + 78.0 + 23.0;
    }
    else {
        return 78.0 + 23.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dicRow = [self.arrProgram objectAtIndex:indexPath.row];
    SectionPCtypeSubCell *cell = (SectionPCtypeSubCell *)[tableView dequeueReusableCellWithIdentifier:SectionPCtypeSubCellIdentifier];
    if (cell == nil) {
        cell = (SectionPCtypeSubCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionPCtypeSubCell" owner:self options:nil] firstObject];
    }
    cell.delegate = self;
    if (NCO(dicRow) && [dicRow isKindOfClass:[NSDictionary class]]) {
        [cell setCellInfoNDrawData:dicRow andIndexPath:indexPath];
    }
    return  cell;
}

@end
