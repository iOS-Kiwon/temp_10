//
//  CMPrd2TableViewCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 12. 20..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "CMPrd2TableViewCell.h"
#import "CMPrd2SubCell.h"


@implementation CMPrd2TableViewCell
@synthesize colviewProduct;
@synthesize arrProducts;
@synthesize dicRowInfo;
@synthesize startingScrollingOffset;
@synthesize viewDefault;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registerNib];
    self.colviewProduct.decelerationRate = 0.60f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
}

- (void)registerNib {
    
    [self.colviewProduct registerNib:[UINib nibWithNibName:@"CMPrd2SubCell" bundle:nil] forCellWithReuseIdentifier:CMPrd2SubTypeIdentifier];
}

-(void)setDicRowInfo:(NSDictionary *)rowinfo{
    
    self.arrProducts =(NSArray *)[rowinfo objectForKey:@"subProductList"];
    [self.colviewProduct reloadData];
    
    [self.viewDefault layoutIfNeeded];
    
    NSLog(@"self.arrProducts = %@",self.arrProducts);
}

#pragma marks - UICollection View Delegate & DataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heightCell = widthColViewPrd2 + 16.0 + 14.0 + 14.0 + 15.0 + 30.0 + 1.0;
    
    if (indexPath.row == 0) {
        return CGSizeMake(widthColViewPrd2 + 20.0, heightCell);
    }else{
        return CGSizeMake(widthColViewPrd2 + 10.0, heightCell);
    }
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.arrProducts count];
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CMPrd2SubCell *cell = (CMPrd2SubCell *)[self.colviewProduct dequeueReusableCellWithReuseIdentifier:CMPrd2SubTypeIdentifier forIndexPath:indexPath];
    
    //[cell setDataWithInfo:dicRow];
    
    
    return cell;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    startingScrollingOffset = scrollView.contentOffset ;
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    NSLog(@"targetContentOffset = %@",NSStringFromCGPoint(*targetContentOffset));
    
    CGFloat proposedPage = scrollView.contentOffset.x / widthColViewPrd2;
    CGFloat delta = scrollView.contentOffset.x > startingScrollingOffset.x ? 0.9 : 0.1;
    NSInteger idxRow = (NSInteger)(floor(proposedPage+delta));
    
    NSLog(@"proposedPage = %f",proposedPage);
    NSLog(@"floor(proposedPage+delta) = %f",floor(proposedPage+delta));
    NSLog(@"delta = %f",delta);
    
    if (idxRow < [self.arrProducts count]) {
        UICollectionViewLayoutAttributes *attributes = [self.colviewProduct layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:idxRow inSection:0]];
        CGRect rectToScroll = attributes.frame;
        
        CGFloat modX = 10.0;
        if (idxRow == 0) {
            modX = 0.0;
        }
        
        NSLog(@"[self.arrProducts count] = %ld",(long)[self.arrProducts count]);
        
        if ([self.arrProducts count] > idxRow && [self.arrProducts count] - 1 == idxRow) {
            [self.colviewProduct scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:idxRow inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }else{
            [self.colviewProduct setContentOffset:CGPointMake(rectToScroll.origin.x - modX,0.0 ) animated:YES];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat proposedPage = scrollView.contentOffset.x / widthColViewPrd2;
    CGFloat delta = scrollView.contentOffset.x > startingScrollingOffset.x ? 0.9 : 0.1;
    NSInteger idxRow = (NSInteger)(floor(proposedPage+delta));
    
    NSLog(@"proposedPage = %f",proposedPage);
    NSLog(@"floor(proposedPage+delta) = %f",floor(proposedPage+delta));
    NSLog(@"delta = %f",delta);
    
    if (idxRow < [self.arrProducts count]) {
        UICollectionViewLayoutAttributes *attributes = [self.colviewProduct layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:idxRow inSection:0]];
        CGRect rectToScroll = attributes.frame;
        
        CGFloat modX = 10.0;
        if (idxRow == 0) {
            modX = 0.0;
        }
        
        NSLog(@"[self.arrProducts count] = %ld",(long)[self.arrProducts count]);
        
        if ([self.arrProducts count] > idxRow && [self.arrProducts count] - 1 == idxRow) {
            [self.colviewProduct scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:idxRow inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }else{
            [self.colviewProduct setContentOffset:CGPointMake(rectToScroll.origin.x - modX,0.0 ) animated:YES];
        }
    }
    
}

@end
