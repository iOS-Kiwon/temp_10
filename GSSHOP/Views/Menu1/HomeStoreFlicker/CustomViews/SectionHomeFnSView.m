//
//  SectionHomeFnSView.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 18..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "SectionHomeFnSView.h"
#import "SectionView.h"


#define GROUP_FILTER_ORDER_POPBTN_TAG 40001
#define GROUP_FILTER_ORDER_NEWESTBTN_TAG 40002

@implementation SectionHomeFnSView



@synthesize target;
@synthesize label_catetitle, img_cate_arrow, btn_catename;

- (id)initWithTarget:(id)sender
{
    
    self = [super init];
    if (self)
    {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SectionHomeFnSView" owner:self options:nil];
        
        self = [nibs objectAtIndex:0];
        target = sender;
        
        //초기화
        
        self.img_cate_arrow.highlighted = NO;
        self.label_catetitle.textColor = [Mocha_Util getColor:@"222222"];

        self.label_catetitle.text = GSSLocalizedString(@"section_customview_homefns_catetitle");
        
        
    }
    return self;
    
    
    
}


-(void)drawRect:(CGRect)rect {
    
    
    self.label_catetitle.textColor = [Mocha_Util getColor:@"222222"];
    
    
}


-(IBAction)clickBtn:(id)sender {
    
    if(sender == self.btn_catename){
        //창 on off
        
        self.btn_catename.selected = !self.btn_catename.selected;
        if(self.btn_catename.selected){
            //노출
            self.label_catetitle.textColor = [Mocha_Util getColor:@"86CF00"];
            self.img_cate_arrow.highlighted = YES;
        }else {
            //닫기
            self.img_cate_arrow.highlighted = NO;
            self.label_catetitle.textColor = [Mocha_Util getColor:@"222222"];
        }
        
        [(SectionView*)target performSelector:@selector(HomeSubcategoryOpenButtonClicked:) withObject:self.btn_catename];
        
    }
    
}


-(void)categorychoiceWithName:(NSString*)catename withCount:(NSString*)catecount {
    self.label_catetitle.text = catename;
    
    float prevOffset = 10;
    float nextOffset = 5;
    {
        CGSize size1 = [self.label_catetitle sizeThatFits:self.label_catetitle.frame.size];
        
        self.label_catetitle.frame = CGRectMake(prevOffset,
                                                self.label_catetitle.frame.origin.y,
                                                size1.width,
                                                self.label_catetitle.frame.size.height);
        
        self.img_cate_arrow.frame = CGRectMake(prevOffset + self.label_catetitle.frame.size.width + nextOffset ,
                                               self.img_cate_arrow.frame.origin.y,
                                               self.img_cate_arrow.frame.size.width,
                                               self.img_cate_arrow.frame.size.height);
    }
    
    
    
}

-(void)catevClose {
    
    //닫기
    
    self.btn_catename.selected = NO;
    self.img_cate_arrow.highlighted = NO;
    self.label_catetitle.textColor = [Mocha_Util getColor:@"222222"]; 
    
    
}

@end
