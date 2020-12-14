//
//  MainSearchCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 12..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "MainSearchCell.h"
#import "MainSearchView.h"
#import "Common_Util.h"
#import "AppDelegate.h"

#define CATE_ARROW_INTERVAL 0.0f

@implementation MainSearchCell
@synthesize target;
@synthesize viewBottomLine;


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    viewAuto.hidden = YES;
    viewPopular.hidden = YES;
    viewRecent.hidden = YES;
    viewCate.hidden = YES;
    imgArrow.hidden = YES;
    imgArrow.frame = CGRectMake(self.frame.size.width - imgArrow.frame.size.width - 8,self.frame.size.height/2 - imgArrow.frame.size.height/2, imgArrow.frame.size.width, imgArrow.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) prepareForReuse {
    
    viewAuto.hidden = YES;
    viewPopular.hidden = YES;
    viewRecent.hidden = YES;
    viewCate.hidden = YES;
    imgArrow.hidden = YES;
    viewBottomLine.hidden = NO;
    
    [super prepareForReuse];
    
}

-(void) setCellInfoNDrawData:(NSArray*)rowinfoArr type:(MainSearchCellType)tableType indexPath:(NSIndexPath*)path searchWord:(NSString *)strWord{
    
    arrRow = rowinfoArr;
    
    
    if (tableType == MainSearchModeRecent) {
        viewRecent.hidden = NO;
        viewBottomLine.hidden = NO;
        //Left
        if ([arrRow count] > 0 && [NCS([arrRow objectAtIndex:0]) length] > 0) {
            LlblRecentWord.hidden = NO;
            LlblRecentWord.text = [arrRow objectAtIndex:0];
            LbtnRecentWord.accessibilityLabel = [arrRow objectAtIndex:0];
            LbtnRecentWordDelete.accessibilityLabel = [NSString stringWithFormat:@"%@ 삭제",[arrRow objectAtIndex:0]];
            LlblRecentWord.frame = CGRectMake(16, LlblRecentWord.frame.origin.y, LlblRecentWord.frame.size.width, LlblRecentWord.frame.size.height);
            LbtnRecentWordDelete.tag = 0;
        }
        else {
            LlblRecentWord.hidden = YES;
            LbtnRecentWordDelete.hidden = YES;
        }
    }
    else if (tableType == MainSearchModePopular) {
        viewPopular.hidden = NO;
        viewBottomLine.hidden = NO;
        if ([arrRow count] > 0 && [NCS([arrRow objectAtIndex:0]) length] > 0) {
            lblPopularNumberLeft.hidden = NO;
            lblPopularLeft.hidden = NO;
            lblPopularNumberLeft.text = [NSString stringWithFormat:@"%lu",(long)(path.row*2)+1];
            lblPopularLeft.text = [arrRow objectAtIndex:0];
            btnPopularLeft.accessibilityLabel = [arrRow objectAtIndex:0];
            
            lblPopularLeft.frame = CGRectMake(39, lblPopularLeft.frame.origin.y, lblPopularLeft.frame.size.width, lblPopularLeft.frame.size.height);
            
        }else{
            lblPopularNumberLeft.hidden = YES;
            lblPopularLeft.hidden = YES;
        }

        if ([arrRow count] > 1 && [NCS([arrRow objectAtIndex:1]) length] > 0) {
            lblPopularNumberRight.hidden = NO;
            lblPopularRight.hidden = NO;
            lblPopularNumberRight.text = [NSString stringWithFormat:@"%lu",(long)(path.row*2)+2];
            lblPopularRight.text = [arrRow objectAtIndex:1];
            btnPopularRight.accessibilityLabel = [arrRow objectAtIndex:1];
            
            lblPopularRight.frame = CGRectMake(39.0, lblPopularRight.frame.origin.y, lblPopularRight.frame.size.width, lblPopularRight.frame.size.height);
            
            
        }else{
            lblPopularNumberRight.hidden = YES;
            lblPopularRight.hidden = YES;
        }
        
        
    }else if (tableType == MainSearchModeAuto){
        
        
        if ([arrRow count] > 0) {
            
            viewBottomLine.hidden = YES;
            imgArrow.hidden = NO;
            
            if ([[arrRow objectAtIndex:0] isKindOfClass:[NSString class]]) {
                
                viewAuto.hidden = NO;
                viewCate.hidden = YES;
                
                viewAuto.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, 48.0);
                
                if ([arrRow objectAtIndex:0] != nil) {
                    lblAutoHighlightLeft.hidden = NO;
                                        
                    btnAuto.accessibilityLabel = [arrRow objectAtIndex:0];
                    
                    @try {
                        NSString *autoText = [arrRow objectAtIndex:0];
                        
//                        if([autoText hasPrefix:strWord]) {
//                            autoText = [autoText stringByReplacingOccurrencesOfString:strWord withString:[NSString stringWithFormat:@"%@ ",strWord]];
//                        }
//                        else if([autoText hasSuffix:strWord]) {
//                            autoText = [autoText stringByReplacingOccurrencesOfString:strWord withString:[NSString stringWithFormat:@" %@",strWord]];
//                        }
//                        else {
//                            
//                        }
                        
                        [lblAutoHighlightLeft changeAllOccurrenceWithEntireString:autoText searchString:strWord];
                        [lblAutoHighlightLeft sizeToFit];
                    }
                    
                    @catch (NSException *exception) {
                        NSLog(@"exception = %@",exception);
                    }
                    @finally {
                        
                    }
                    
                }
                else
                {
                    lblAutoWordLeft.hidden = YES;
                    lblAutoHighlightLeft.hidden = YES;
                }
                
                
                
            }
            
            else if ([[arrRow objectAtIndex:0] isKindOfClass:[NSDictionary class]]) { // 카테고리
                
                CGFloat marginX = 16;
                
                viewAuto.hidden = YES;
                viewCate.hidden = NO;
                
                lblCateSearchWord.text = strWord;
                lblCateBig.text  = NCS([[arrRow objectAtIndex:0] objectForKey:@"title"]);
                btnCategory.accessibilityLabel = [NSString stringWithFormat:@"%@ %@",strWord,NCS([[arrRow objectAtIndex:0] objectForKey:@"title"])];
                [lblCateSearchWord sizeToFit];
                [lblCateBig sizeToFit];
                
                lblCateSearchWord.frame = CGRectMake(marginX, self.frame.size.height/2 - lblCateSearchWord.frame.size.height/2, lblCateSearchWord.frame.size.width, lblCateSearchWord.frame.size.height);
                
                lblCateBig.frame = CGRectMake(lblCateSearchWord.frame.size.width + marginX + 10, self.frame.size.height/2 - lblCateBig.frame.size.height/2, lblCateBig.frame.size.width, lblCateBig.frame.size.height);
                
            }
            else {
                
                lblAutoWordRight.hidden = YES;
                lblAutoHighlightRight.hidden = YES;
            }
            
        }
        
    }
    
    
    
}
-(IBAction)onBtnSelectWord:(id)sender{
    NSInteger tags = [((UIButton *)sender) tag];
    if (NCA(arrRow) && ([arrRow count] > tags)) {
        //[(MainSearchView*)target performSelector:@selector(goWebViewWithSearchWord:direct:) withObject:[arrRow objectAtIndex:[sender tag]]];
        
        NSString *strSearchWord = [arrRow objectAtIndex:tags];
        
        if([strSearchWord isKindOfClass:[NSString class]] == YES) {
            if ([target respondsToSelector:@selector(goWebViewWithSearchWord:direct:)]) {
                [(MainSearchView*)target goWebViewWithSearchWord:strSearchWord direct:NO];
            }
        }else{
            
            NSString *strMessage = @"잘못된 검색어 입니다.";
            
            [Mocha_ToastMessage toastWithDuration:2.0 andText:strMessage inView:ApplicationDelegate.window];
            
            return;
        }
    }
}

-(IBAction)onBtnCate:(id)sender{
    
    if (NCA(arrRow) && [arrRow count] > [((UIButton *)sender) tag] && [[arrRow objectAtIndex:[((UIButton *)sender) tag]] isKindOfClass:[NSDictionary class]]) {
        [(MainSearchView*)target performSelector:@selector(goWebViewWithCateUrl:) withObject:NCS([[arrRow objectAtIndex:[((UIButton *)sender) tag]] objectForKey:@"url"])];
    }
    
}

-(IBAction)onBtnWordDelete:(id)sender{
    [(MainSearchView*)target performSelector:@selector(delRecentWord:) withObject:[arrRow objectAtIndex:[((UIButton *)sender) tag]]];
}

@end
