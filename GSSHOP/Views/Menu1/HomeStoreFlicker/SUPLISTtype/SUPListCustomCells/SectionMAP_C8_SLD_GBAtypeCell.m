//
//  SectionMAP_C8_SLD_GBAtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 22..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_C8_SLD_GBAtypeCell.h"
#import "SUPListTableViewController.h"

@interface SectionMAP_C8_SLD_GBAtypeCell ()
@property (nonatomic, strong) NSMutableArray *arrSubProductList;
@property (nonatomic, strong) IBOutlet UIView *viewDefault;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
- (IBAction)clsButtonAction:(id)sender;
@end

@implementation SectionMAP_C8_SLD_GBAtypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.arrSubProductList = [[NSMutableArray alloc] init];
    self.collectView.scrollsToTop = NO;
    
    //라운드 적용
    //self.backGroundView.layer.cornerRadius = 20.0f;
    self.searchText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"GS 프레시몰 상품을 검색하세요."
                                                                            attributes:@{NSForegroundColorAttributeName: [Mocha_Util getColor:@"888888"]
                                                                                         ,NSFontAttributeName:[UIFont systemFontOfSize:15.0]} ];
    self.clsButton.hidden = YES;
    [self.collectView registerNib:[UINib nibWithNibName:@"SectionMAP_C8_SLD_GBAtypeSubCell" bundle:nil] forCellWithReuseIdentifier:MAP_C8_SLD_GBASubTypeIdentifier];
    //self.collectView.decelerationRate = 0.45;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    self.searchText.text = @"";
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowInfoDic {
    
    if(NCO(rowInfoDic)) {
        self.searchLink = NCS([rowInfoDic objectForKey:@"linkUrl"]);
    }
    
    [self.arrSubProductList removeAllObjects];
    NSArray *arrCate = [rowInfoDic objectForKey:@"subProductList"];
    //2개가 1셀
    if (NCA(arrCate)) {
        NSMutableArray *arrRow = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<[arrCate count]; i++) {
            [arrRow addObject:[arrCate objectAtIndex:i]];
            if ( ((i+1)%2 == 0) || (i+1 == [arrCate count]) ) {
                [self.arrSubProductList addObject:[arrRow copy]];
                [arrRow removeAllObjects];
            }
        }
        [self.collectView reloadData];
    }
}

-(void)onBtnMAP_C8_Category:(NSDictionary *)dicRow{
    NSString *strLink = NCS([dicRow objectForKey:@"linkUrl"]);
    if ([self.target respondsToSelector:@selector(onBtnSUPCellJustLinkStr:)] && [strLink length] > 0) {
        [self.target onBtnSUPCellJustLinkStr:strLink];
    }
}

- (IBAction)clsButtonAction:(id)sender {
    self.searchText.text = @"";
}

#pragma mark - UICollection View Delegate & DataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SectionMAP_C8_SLD_GBAtypeSubCell *cell = (SectionMAP_C8_SLD_GBAtypeSubCell *)[self.collectView dequeueReusableCellWithReuseIdentifier:MAP_C8_SLD_GBASubTypeIdentifier forIndexPath:indexPath];
    NSArray *arrRow = [self.arrSubProductList objectAtIndex:indexPath.row];
    cell.targetCell = self;
    [cell setCellInfoNDrawData:arrRow];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //셀너비는 82, 셀간격은 0
    return CGSizeMake(82, MAP_C8_SLD_GBA_SUB_CELL_HEIGHT);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //위 마진 15, 앞마진 0
    return UIEdgeInsetsMake(15.0, 0.0, 0.0, 0.0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.arrSubProductList count];
}

- (IBAction)searchBtn:(id)sender {
    if ([self.target respondsToSelector:@selector(goSearch:)]) {
        [self.target goSearch:self.searchText];
    }
}
@end
