//
//  SectionRPStypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionRPStypeCell.h"
#import "AppDelegate.h"

#define arrColor [NSArray arrayWithObjects:@"f8abce",@"e1afd6",@"cbb2dc",@"acbae6",@"9ebfec",@"8cc4ee",@"82c7e5",@"82d7e5",@"7ecbc7",@"7ecfb4",@"84cfa2",@"95cc9d",@"a9ca91",@"bbd08b",@"cdd488",@"ddce84",@"eec183",@"fab583",@"faae91",@"faa8a4",nil]


@implementation SectionRPStypeCell

@synthesize target;
@synthesize viewDefault;
@synthesize viewWords;
@synthesize viewTopLine;
@synthesize viewBottomLine;
@synthesize arrRow;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, heightOneLine);
    viewDefault.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, heightOneLine + 43.0 + 20.0);
    viewWords.frame = CGRectMake(10.0, 43.0 + 10.0, APPFULLWIDTH - 20.0, heightOneLine);
    viewTopLine.frame = CGRectMake(viewTopLine.frame.origin.x, viewTopLine.frame.origin.y, APPFULLWIDTH, 1.0);
    viewBottomLine.frame = CGRectMake(viewBottomLine.frame.origin.x, viewDefault.frame.size.height, APPFULLWIDTH, 1.0);
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, APPFULLWIDTH - (self.titleLabel.frame.origin.x * 2), self.titleLabel.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    
}

-(void)prepareForReuse{
    [super prepareForReuse];
    viewDefault.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, heightOneLine + 43.0 + 20.0);
    viewWords.frame = CGRectMake(10.0, 43.0 + 10.0, APPFULLWIDTH - 20.0, heightOneLine);
    viewTopLine.frame = CGRectMake(viewTopLine.frame.origin.x, viewTopLine.frame.origin.y, APPFULLWIDTH, 1.0);
    viewBottomLine.frame = CGRectMake(viewBottomLine.frame.origin.x, viewDefault.frame.size.height, APPFULLWIDTH, 1.0);
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, APPFULLWIDTH - (self.titleLabel.frame.origin.x * 2), self.titleLabel.frame.size.height);
    
    for (UIView *view in viewWords.subviews) {
        [view removeFromSuperview];
    }
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    self.backgroundColor = [UIColor clearColor];
    
    [self calcRPSViews:rowinfo];
    
    //20170613 실시간 인기 검색어 텍스트 값이 있으며 출력 없으면 디폴트인 "실시간 인기 검색어" 노출
    NSString *title = NCS([rowinfo objectForKey:@"productName"]);
    if( [title length] > 0 && ![title isEqualToString:@""] ) {
        self.titleLabel.text = title;
    }
    else {
        self.titleLabel.text = @"실시간 인기 검색어";
    }
       
       
    
}

- (void) calcRPSViews : (id) rowinfo
{
    arrRow = (NSArray *)[rowinfo objectForKey:@"subProductList"];
    
    CGFloat widthLimit = viewWords.frame.size.width;
    CGFloat widthSum = 0.0;
    CGFloat heightReturn = 0.0;
    
    CGRect frameKeyWordView = CGRectZero;
    
    for (NSInteger i=0; i<[arrRow count]; i++) {
        if (i == 0) {
            heightReturn = heightOneLine;
        }
        
        NSString *strWord = [NSString stringWithFormat:@"#%@",[[arrRow objectAtIndex:i] objectForKey:@"productName"]];
        
        CGSize keyWordSize = [strWord MochaSizeWithFont: [UIFont systemFontOfSize:fontSizeRPS] constrainedToSize:CGSizeMake(APPFULLWIDTH - 20.0, heightOneLine) lineBreakMode:NSLineBreakByClipping];
        
        
        if ((widthSum+keyWordSize.width+ insideSearchWord*2.0) <= widthLimit) {
            //다음 키워드의 넓이값과 기존 키워드들의 합이 제한안에 들어올경우 키워드의 프레임 계산
            widthSum = widthSum +keyWordSize.width+ insideSearchWord*2.0;
            
            frameKeyWordView = CGRectMake(frameKeyWordView.origin.x + frameKeyWordView.size.width, frameKeyWordView.origin.y , keyWordSize.width+ insideSearchWord*2.0, heightOneLine);
            
        }else{
            
            
            if (keyWordSize.width >= (APPFULLWIDTH - 20.0)) {
                //다음 키워드의 넓비값과 기존 키워드들의 합이 가로 제한보다 크면서
                //키워드 1개가 총 제한 넓이보다 클경우
                
                
                if (widthSum == 0.0) {
                    //키워드가 행의 첫번째일경우 모두 표시하고 가로제한 넘어가는 부분은 clip
                    widthSum = keyWordSize.width + insideSearchWord*2.0;
                    frameKeyWordView = CGRectMake(0.0, frameKeyWordView.origin.y, keyWordSize.width + insideSearchWord*2, heightOneLine);
                }else{
                    //키워드가 행의 첫번째가 아닐경우 줄바꿈후 모두 표시하고 가로제한 넘어가는 부분은 clip
                    widthSum = keyWordSize.width+ insideSearchWord*2.0;
                    heightReturn = heightReturn + heightOneLine;
                    frameKeyWordView = CGRectMake(0.0, frameKeyWordView.origin.y + heightOneLine, keyWordSize.width + insideSearchWord*2.0, heightOneLine);
                }
                
                
                
            }else{
                //다음 키워드의 넓비값과 기존 키워드들의 합이 가로 제한보다 클경우
                
                widthSum = keyWordSize.width+ insideSearchWord*2.0;
                heightReturn = heightReturn + heightOneLine;
                frameKeyWordView = CGRectMake(0.0, frameKeyWordView.origin.y + heightOneLine, keyWordSize.width+ insideSearchWord*2.0, heightOneLine);
                
            }
        }
        
        [self addViewWithFrame:frameKeyWordView andKeyWord:strWord andTag:i];
        
        
        frameKeyWordView = CGRectMake(frameKeyWordView.origin.x, frameKeyWordView.origin.y,frameKeyWordView.size.width + intervalSearchWord, heightOneLine);
        widthSum += intervalSearchWord;
    }
    
    viewDefault.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, heightReturn + 43.0 + 20.0);
    viewWords.frame = CGRectMake(10.0, 43.0 + 15.0 , APPFULLWIDTH - 20.0, heightReturn);
    viewTopLine.frame = CGRectMake(viewTopLine.frame.origin.x, viewTopLine.frame.origin.y, APPFULLWIDTH, 1.0);
    viewBottomLine.frame = CGRectMake(viewBottomLine.frame.origin.x, viewDefault.frame.size.height, APPFULLWIDTH, 1.0);
    
    NSLog(@"viewDefault.frame = %@",NSStringFromCGRect(viewDefault.frame));
    
}





//뷰에 키워드 셋팅하기
-(void)addViewWithFrame:(CGRect)viewRect andKeyWord:(NSString *)strWord andTag:(NSInteger)btnTag{
    UIView *viewBG = [[UIView alloc] initWithFrame:viewRect];
    
    UIView *viewColorBG = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, viewRect.size.width, viewRect.size.height - intervalSearchWord)];
    
    if ([arrColor count] > btnTag) {
        viewColorBG.backgroundColor = [Mocha_Util getColor:[arrColor objectAtIndex:btnTag]];
    }else{
        viewColorBG.backgroundColor = [Mocha_Util getColor:[arrColor objectAtIndex:btnTag % 20]];
    }
    
    
    
    [viewBG addSubview:viewColorBG];
    
    UILabel *lblKeyWord = [[UILabel alloc] initWithFrame:CGRectMake(insideSearchWord, 0.0, viewRect.size.width - insideSearchWord*2.0, viewRect.size.height - intervalSearchWord)];
    lblKeyWord.font = [UIFont systemFontOfSize:fontSizeRPS];
    lblKeyWord.text = strWord;
    lblKeyWord.textColor = [Mocha_Util getColor:@"FFFFFF"];
    lblKeyWord.lineBreakMode = NSLineBreakByClipping;
    
    
    
    UIButton *btnGoSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGoSearch.frame = CGRectMake(0.0, 0.0, viewRect.size.width, viewRect.size.height);
    btnGoSearch.tag = btnTag;
    [btnGoSearch addTarget:self action:@selector(onBtnSearchWord:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewBG addSubview:lblKeyWord];
    [viewBG addSubview:btnGoSearch];
    
    
    
    
    [viewWords addSubview:viewBG];
    
}


//버튼 클릭
-(void)onBtnSearchWord:(UIButton *)sender{
    
    NSLog(@"[arrRow objectAtIndex:[sender tag]] = %@",[arrRow objectAtIndex:[((UIButton *)sender) tag]]);
    
    NSInteger tagIndex = [((UIButton *)sender) tag];
    
    if ([arrRow count] > tagIndex) {
        
        
        NSMutableDictionary *dicTqEnc = [[NSMutableDictionary alloc] initWithDictionary:[arrRow objectAtIndex:tagIndex]];
        
        NSString *strUrl = [dicTqEnc objectForKey:@"linkUrl"];
        
        if ([strUrl hasPrefix:@"http://"])
        {
            URLParser *parser = [[URLParser alloc] initWithURLString:strUrl];
            NSString *strTQ = NCS([parser valueForVariable:@"tq"]);
            //
            if(strTQ.length > 0 && [strUrl rangeOfString:@"%"].location == NSNotFound)
            {
                //
                strUrl = [strUrl stringByReplacingOccurrencesOfString:strTQ withString:[strTQ urlEncodedString]];
            }
            
            [dicTqEnc setObject:strUrl forKey:@"linkUrl"];
            
            [target dctypetouchEventTBCell:dicTqEnc andCnum:[NSNumber numberWithInt:(int)tagIndex] withCallType:@"RPS"];
            
        }else{
            return;
        }
        
        
        
        
    }else{
        return;
    }
    
    
    
}


@end
