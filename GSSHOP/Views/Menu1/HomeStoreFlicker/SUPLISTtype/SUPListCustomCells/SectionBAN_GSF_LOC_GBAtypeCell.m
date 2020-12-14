//
//  SectionBAN_GSF_LOC_GBAtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 22..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_GSF_LOC_GBAtypeCell.h"
#import "SUPListTableViewController.h"
#import "AppDelegate.h"

@interface SectionBAN_GSF_LOC_GBAtypeCell ()
@property (nonatomic,strong) IBOutlet UILabel *lblBranch;
@property (nonatomic,strong) IBOutlet UILabel *lblSelect;
@property (nonatomic,strong) IBOutlet UILabel *lblInfo;
@property (nonatomic,strong) IBOutlet UIView *viewSelect;
@property (nonatomic,strong) IBOutlet UIView *viewInfo;
@property (nonatomic,strong) IBOutlet UIView *viewDefault;
@property (nonatomic,strong) NSArray *arrSubProductList;
@property (nonatomic,strong) IBOutlet UIButton *btn01;
@property (nonatomic,strong) IBOutlet UIButton *btn02;
@end



@implementation SectionBAN_GSF_LOC_GBAtypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.viewSelect.layer.cornerRadius = 2.0;
    self.viewSelect.layer.borderWidth = 1.0;
    self.viewSelect.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    self.viewSelect.layer.shouldRasterize = YES;
    self.viewSelect.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.viewInfo.layer.cornerRadius = 2.0;
    self.viewInfo.layer.borderWidth = 1.0;
    self.viewInfo.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    self.viewInfo.layer.shouldRasterize = YES;
    self.viewInfo.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)prepareForReuse {
    [super prepareForReuse];
    self.viewInfo.hidden = YES;
    self.viewSelect.hidden = YES;
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowInfoDic{
    
    if(!NCO(rowInfoDic)) {
        return;
    }
    
    CGFloat widthBtns = 0.0;
    if (NCA([rowInfoDic objectForKey:@"subProductList"])) {
        self.arrSubProductList = [rowInfoDic objectForKey:@"subProductList"];
        //self.arrSubProductList = [NSArray arrayWithObject:[[rowInfoDic objectForKey:@"subProductList"] objectAtIndex:0]];
        
        if ([self.arrSubProductList count] > 1) {
            self.viewInfo.hidden = NO;
            self.lblInfo.text = NCS([[self.arrSubProductList objectAtIndex:1] objectForKey:@"productName"]);
            self.btn02.accessibilityLabel = NCS([[self.arrSubProductList objectAtIndex:1] objectForKey:@"productName"]);
            
            CGSize lblInfoSize = [NCS([[self.arrSubProductList objectAtIndex:1] objectForKey:@"productName"]) MochaSizeWithFont: [UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(200.0, 28.0) lineBreakMode:NSLineBreakByClipping];
            widthBtns = 16.0 + lblInfoSize.width + 5.0;
        
            self.viewSelect.hidden = NO;
            self.lblSelect.text = NCS([[self.arrSubProductList objectAtIndex:0] objectForKey:@"productName"]);
            self.btn01.accessibilityLabel = NCS([[self.arrSubProductList objectAtIndex:0] objectForKey:@"productName"]);
            
            CGSize lblSelectSize = [NCS([[self.arrSubProductList objectAtIndex:0] objectForKey:@"productName"]) MochaSizeWithFont: [UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(200.0, 28.0) lineBreakMode:NSLineBreakByClipping];
            
            widthBtns = widthBtns + 16 + lblSelectSize.width + 5.0;
            
        }else if ([self.arrSubProductList count] == 1) {
            
            self.viewInfo.hidden = NO;
            self.lblInfo.text = NCS([[self.arrSubProductList objectAtIndex:0] objectForKey:@"productName"]);
            self.btn02.accessibilityLabel = NCS([[self.arrSubProductList objectAtIndex:0] objectForKey:@"productName"]);
            
            CGSize lblInfoSize = [NCS([[self.arrSubProductList objectAtIndex:0] objectForKey:@"productName"]) MochaSizeWithFont: [UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(200.0, 28.0) lineBreakMode:NSLineBreakByClipping];
            widthBtns = 16.0 + lblInfoSize.width + 5.0;
        }
        
    }
    
    NSString *InfoMessage = NCS([rowInfoDic objectForKey:@"etcText1"]);
    if([InfoMessage length] > 0 ) {
       // 한번만 실행됨.
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:InfoMessage maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
           [ApplicationDelegate.window addSubview:malert];
       });
   }
    
    self.lblBranch.text = NCS([rowInfoDic objectForKey:@"productName"]);
    self.lblBranch.accessibilityLabel = NCS([rowInfoDic objectForKey:@"productName"]);

    
    self.lcontAddressWidth.constant = APPFULLWIDTH - 31.0 - widthBtns - 10.0;
    
    [self.viewDefault layoutIfNeeded];
}

-(IBAction)onBtnSelectOrInfo:(id)sender{
    
    if ([self.arrSubProductList count] > 1) {
    
        NSString *strLink = NCS([[self.arrSubProductList objectAtIndex:[((UIButton *)sender) tag]] objectForKey:@"linkUrl"]);
        
        
        if (ApplicationDelegate.islogin == NO && [((UIButton *)sender) tag] == 0) {
            if ([self.target respondsToSelector:@selector(callLogin:)] && [strLink length] > 0) {
                [self.target callLogin:strLink];
            }
        }else{
            if ([self.target respondsToSelector:@selector(onBtnSUPCellJustLinkStr:)] && [strLink length] > 0) {
                [self.target onBtnSUPCellJustLinkStr:strLink];
            }
        }
        
    }else if ([self.arrSubProductList count] == 1) {
        
        NSString *strLink = NCS([[self.arrSubProductList objectAtIndex:0] objectForKey:@"linkUrl"]);
        
        
        if ([self.target respondsToSelector:@selector(onBtnSUPCellJustLinkStr:)] && [strLink length] > 0) {
            [self.target onBtnSUPCellJustLinkStr:strLink];
        }
    }
    
    
}

@end
