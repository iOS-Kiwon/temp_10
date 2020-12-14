//
//  SectionFPCHeaderView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 4..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionFPCHeaderView.h"
#import "SectionView.h"

@implementation SectionFPCHeaderView
@synthesize target;
@synthesize imgCrown;
@synthesize label_catetitle;
@synthesize img_cate_arrow;
@synthesize btn_catename;
@synthesize viewAlpha;

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

-(IBAction)clickBtn:(id)sender{
    NSLog(@"");
    if(sender == self.btn_catename){
        //창 on off
        
        self.btn_catename.selected = !self.btn_catename.selected;
        if(self.btn_catename.selected){
            //노출
            self.img_cate_arrow.highlighted = YES;
            self.viewAlpha.alpha = 1.0;
        }else {
            //닫기
            self.img_cate_arrow.highlighted = NO;
            self.viewAlpha.alpha = 0.95;
        }
        
        if ([(SectionView*)target respondsToSelector:@selector(FPCCategoryOpenButtonClicked:)]) {
            [(SectionView*)target performSelector:@selector(FPCCategoryOpenButtonClicked:) withObject:self.btn_catename];
        }
    }
}
-(void)catevClose{
    self.btn_catename.selected = NO;
    self.img_cate_arrow.highlighted = NO;
    self.viewAlpha.alpha = 0.95;
    
}
-(void)categorychoiceWithName:(NSString*)catename showCrown:(BOOL)isShow{
    
    if (!isShow) {
    
        self.label_catetitle.frame = CGRectMake(10.0, self.label_catetitle.frame.origin.y, self.label_catetitle.frame.size.width, self.label_catetitle.frame.size.height);
        self.imgCrown.hidden = YES;
    }
    
    self.label_catetitle.text = catename;
}

-(void)FPC_SCategorychoiceWithName:(NSString*)catename showCrown:(BOOL)isShow{
    
    
    
    if (!isShow) {
        
        self.label_catetitle.frame = CGRectMake(10.0, self.label_catetitle.frame.origin.y, self.label_catetitle.frame.size.width, self.label_catetitle.frame.size.height);
        self.imgCrown.hidden = YES;
    }
    
    self.label_catetitle.text = catename;
}

@end
