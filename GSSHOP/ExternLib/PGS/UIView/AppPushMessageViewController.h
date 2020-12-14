#import <UIKit/UIKit.h>
#import "AppPushMessageTableView.h"
#import "AppPushDatabase.h"
@protocol AppPushMessageDelegate<NSObject>
//신규,과거 메시지 호출시
- (void)loadNewMsg:(NSString *)argStandardMsgId
           msgCode:(NSString *)argMsgCode
        courseType:(NSString *)argType;
- (void)pressTableCell:(NSDictionary *)argDic;
- (void)pressPersonalTableHeader:(NSString *)argLink;
@end
@interface AppPushMessageViewController : UIViewController <AppPushMessageTableViewDelegate> {
    
    AppPushMessageTableView         *msg_tableView;
    id<AppPushMessageDelegate>      __weak delegate;
    
}
@property (nonatomic, weak) id<AppPushMessageDelegate> delegate;
- (BOOL)loadMsgView:(NSString *)argMsgId;
//- (BOOL)loadMessage:(NSString *)argMsgId;
- (void)setViewFrame;
//개인화 헤더 클릭 전용
- (void)pressPersonalTableHeader:(NSDictionary *)argDic;
@end
