#define MIN_ID  @"MIN_ID"
#define MAX_ID  @"MAX_ID"
#import <UIKit/UIKit.h>

#import "AppPushNoneImgCellTableViewCell.h"
#import "AppPushImgCellTableViewCell.h"
#import "Common_Util.h"
@protocol AppPushMessageTableViewDelegate <NSObject>
@optional
- (void)pressTableCell:(NSDictionary *)argDic;
-(void)pressPersonalTableHeader:(NSString *)argLink;
@end
@interface AppPushMessageTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray                          *_tableDataList;
    id<AppPushMessageTableViewDelegate>     __weak delegateList;
    UIView                                  *toplineView;
    BOOL  isThisCommComplete;
}
@property (nonatomic, weak) id<AppPushMessageTableViewDelegate> delegateList;

- (NSString *)getMinID;
- (NSString *)getMaxID;
- (NSDictionary *)getMinMaxID;
- (UIView*)noneMessageview ;
- (BOOL)haveList;
- (void)removeTableList;
- (void)setTableList:(NSArray *)argArr;
- (void)addTableList:(NSArray *)argArr;
- (void)insertTableList:(NSArray *)argArr middleIndex:(int)argIndex isMiddle:(BOOL)argIsMiddle;
@end