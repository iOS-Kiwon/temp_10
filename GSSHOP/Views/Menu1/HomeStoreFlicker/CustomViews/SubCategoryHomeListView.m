//
//  SubCategoryHomeListView.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 18..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "SubCategoryHomeListView.h"
#import "SectionView.h"

@implementation SubCategoryHomeListView
@synthesize target;





- (id)initWithTarget:(id)sender andDic:(NSMutableArray*)tdic
{
    
    self = [super init];
    if (self)
    {
        target = sender;
        category_arr = tdic;
        
        
        iscallWiseLog = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        //초기화
        if(tdic == nil){
            
            self.frame = CGRectMake(0,0,APPFULLWIDTH, 0);
        }
        
        else if((int)[tdic count] > 0){
            
            NSInteger tdindex =0;
            
            [self  redrawcatetitle:tdindex];
            
        }
    }
    return self;
}


-(void)drawRect:(CGRect)rect {
}


-(void)redrawcatetitle:(NSInteger)tindex {
    
    if(containview != nil){
        [containview removeFromSuperview ];
    }
    containview = [[UIView alloc] initWithFrame:CGRectMake(10,  0, APPFULLWIDTH-20, 0)];
    containview.backgroundColor = [Mocha_Util getColor:@"e6e6e6"];
    
    {
        
        CGFloat offsetY = 0 + 1;
        
        const int cellHeight= 40;
        const int cellWidth= (APPFULLWIDTH-20)/2;
        
        for (int i=0, j=((int)[category_arr count] + 1)/2; i<j; i++)
        {
            for (int k=0; k<2; k++)
            {
                int index = i * 2 + k;
                
                
                
                
                UIButton *bgv = [UIButton buttonWithType:UIButtonTypeCustom];
                
                bgv.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
                [bgv setBackgroundColor:[UIColor whiteColor]];
                
                
                [containview addSubview:bgv];
                
                
                if (k == 0)
                {
                    bgv.frame = CGRectMake(0, (i==0)?0:offsetY, cellWidth, (i==0)?cellHeight:cellHeight - 1);
                }
                else if (k == 1)
                {
                    bgv.frame = CGRectMake(cellWidth , (i==0)?0:offsetY, cellWidth , (i==0)?cellHeight:cellHeight - 1);
                }
                
                
                
                
                
                NSString *title = (index < [category_arr count]) ? [(NSDictionary *)[category_arr objectAtIndex:index] objectForKey:@"categoryName"] : @"";
                NSString *sectct;
                // 전체일경우도 카운트내려오면 표기
                if(i==0 && k==0){
                    if([[(NSDictionary *)[category_arr objectAtIndex:index] objectForKey:@"totalCnt"] intValue] > 0){
                        sectct = [NSString stringWithFormat:@"(%@)", [Common_Util commaStringFromDecimal: [[(NSDictionary *)[category_arr objectAtIndex:index] objectForKey:@"totalCnt"] intValue] ] ];
                    }else {
                        
                        sectct = @"";
                    }
                    
                }
                else if(index < [category_arr count])  {
                    if([[(NSDictionary *)[category_arr objectAtIndex:index] objectForKey:@"totalCnt"] intValue] > 0){
                    sectct = [NSString stringWithFormat:@"(%@)", [Common_Util commaStringFromDecimal: [[(NSDictionary *)[category_arr objectAtIndex:index] objectForKey:@"totalCnt"] intValue] ] ];
                    }else {
                         sectct = @"";
                    }
                }else {
                    sectct = @"";
                }
                
                
                
                
                
                UILabel* label_tcell = [[UILabel alloc] init];
                
                label_tcell.text = [NSString stringWithFormat:@"%@", title];
                label_tcell.textAlignment = NSTextAlignmentLeft;

                
                if( [label_tcell.text isEqualToString: [(NSDictionary *)[category_arr objectAtIndex:(unsigned long)tindex] objectForKey:@"categoryName"]]){
                    label_tcell.font = [UIFont boldSystemFontOfSize:14];
                    //카테고리선택  MFSEQ wiseAPPLogRequest

                    
                    if(iscallWiseLog == NO){
                        iscallWiseLog = YES;
                        
                    }else {
                        
                        ////탭바제거
                        [ApplicationDelegate wiseCommonLogRequest:[(NSDictionary *)[category_arr objectAtIndex:(unsigned long)tindex] objectForKey:@"mseqUrl"]];
                        
                    }
                    
                    
                    
                    
                }
                else
                {
                    label_tcell.font = [UIFont systemFontOfSize:14];
                    
                }
                
                
                label_tcell.backgroundColor = [UIColor clearColor];
                label_tcell.textColor = [Mocha_Util getColor:@"222222"];
                label_tcell.lineBreakMode = NSLineBreakByTruncatingTail;
                label_tcell.tag = 1000+index;
                [containview addSubview:label_tcell];
                
                
                UILabel* label_ctcell = [[UILabel alloc] init];
                
                label_ctcell.text = [NSString stringWithFormat:@"%@", ([sectct isEqualToString:@""])?@"":sectct ];
                label_ctcell.textAlignment = NSTextAlignmentLeft;
                label_ctcell.font = [UIFont systemFontOfSize:11];
                label_ctcell.backgroundColor = [UIColor clearColor];
                label_ctcell.textColor = [Mocha_Util getColor:@"C3C3C3"];
                label_ctcell.lineBreakMode = NSLineBreakByTruncatingTail;
                
                [containview addSubview:label_ctcell];
                
                
                
                float prevOffset = 2;
                
                CGSize size1 = [label_tcell sizeThatFits:label_tcell.frame.size];
                CGSize size2 = [label_ctcell sizeThatFits:label_ctcell.frame.size];
                
                
                if (k == 0)
                {
                    label_tcell.frame = CGRectMake(0, (i==0)?0:offsetY, size1.width, (i==0)?cellHeight:cellHeight - 1);
                    label_ctcell.frame = CGRectMake(prevOffset + label_tcell.frame.size.width  ,
                                                    label_tcell.frame.origin.y,
                                                    size2.width,
                                                    label_tcell.frame.size.height);
                }
                else if (k == 1)
                {
                    label_tcell.frame = CGRectMake(cellWidth , (i==0)?0:offsetY, size1.width , (i==0)?cellHeight:cellHeight - 1);
                    label_ctcell.frame = CGRectMake(cellWidth + prevOffset + label_tcell.frame.size.width   ,
                                                    label_tcell.frame.origin.y,
                                                    size2.width,
                                                    label_tcell.frame.size.height);
                }
                
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail; ;
                
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
                [button setBackgroundColor:[UIColor clearColor]];
                
                if (index < [category_arr count])
                {
                    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag =   index;
                }
                else
                {
                    button.enabled = NO;
                }
                
                [containview addSubview:button];
                
                
                if (k == 0)
                {
                    button.frame = CGRectMake(0, (i==0)?0:offsetY, cellWidth, (i==0)?cellHeight:cellHeight - 1);
                }
                else if (k == 1)
                {
                    button.frame = CGRectMake(cellWidth , (i==0)?0:offsetY, cellWidth , (i==0)?cellHeight:cellHeight - 1);
                }
            }
            
            offsetY += cellHeight;
        }
        
        containview.frame = CGRectMake(10, 0, cellWidth * 2, offsetY - 1 + 1);
    }
    
    
    
    
    
    if(containview.frame.size.height > APPFULLHEIGHT-260 ){
        
        self.frame = CGRectMake(0,0,APPFULLWIDTH,  APPFULLHEIGHT-250);
        base_scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, APPFULLWIDTH, APPFULLHEIGHT-250)];
        base_scrollview.backgroundColor = [UIColor whiteColor];
        base_scrollview.scrollEnabled = YES;
        base_scrollview.bounces = NO;
        base_scrollview.contentSize = CGSizeMake(APPFULLWIDTH, containview.frame.size.height);
        [base_scrollview addSubview:containview];
        [self addSubview:base_scrollview];
        
        
    }else {
        
        [self addSubview:containview];
        self.frame = CGRectMake(0,0,APPFULLWIDTH, containview.frame.size.height);
    }
}





-(void)clickBtn:(id)sender {
    NSInteger index = [(UIButton*)sender tag];
    NSString *title = (index < [category_arr count]) ? [(NSDictionary *)[category_arr objectAtIndex:index] objectForKey:@"categoryName"] : @"";

    
    [self redrawcatetitle:index];

  [(SectionView*)target FILTERACTIONHOMECATEGORYSELECT:title  andtag:index];
    
}

@end
