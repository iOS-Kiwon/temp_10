#import "NSObject+AmailSBJSON.h"
#import "AmailSBJsonWriter.h"
@implementation NSObject (NSObject_AmailSBJSON)
- (NSString *)AmailJSONFragment {
    AmailSBJsonWriter *jsonWriter = [AmailSBJsonWriter new];
    NSString *json = [jsonWriter stringWithFragment:self];    
//    if (!json)
        //NSLog(@"-JSONFragment failed. Error trace is: %@", [jsonWriter errorTrace]);
//    [jsonWriter release];
    return json;
}
- (NSString *)AmailJSONRepresentation {
    AmailSBJsonWriter *jsonWriter = [AmailSBJsonWriter new];    
    NSString *json = [jsonWriter stringWithObject:self];
//    if (!json)
        //NSLog(@"-JSONRepresentation failed. Error trace is: %@", [jsonWriter errorTrace]);
//    [jsonWriter release];
    return json;
}
@end
