#import "NSString+AmailSBJSON.h"
#import "AmailSBJsonParser.h"
@implementation NSString (NSString_AmailSBJSON)
- (id)AmailJSONFragmentValue
{
    AmailSBJsonParser *jsonParser = [AmailSBJsonParser new];    
    id repr = [jsonParser fragmentWithString:self];    
//    if (!repr) //NSLog(@"-JSONFragmentValue failed. Error trace is: %@", [jsonParser errorTrace]);
//    [jsonParser release];
    return repr;
}
- (id)AmailJSONValue
{
    AmailSBJsonParser *jsonParser = [AmailSBJsonParser new];
    id repr = [jsonParser objectWithString:self];
//    if (!repr) //NSLog(@"-JSONValue failed. Error trace is: %@", [jsonParser errorTrace]);
//    [jsonParser release];
    return repr;
}
@end
