

#import "AFJSONRequestOperation.h"

@interface GRJSONRequestOperation : AFJSONRequestOperation

+ (GRJSONRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
													success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success
													failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure;
@end
