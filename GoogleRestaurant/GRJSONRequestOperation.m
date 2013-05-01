

#import "GRJSONRequestOperation.h"

@implementation GRJSONRequestOperation

+ (GRJSONRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
													success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success
													failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure
{
	void (^failureHandler)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data){
		
		if (failure) {
			failure(request, response, error, data);
		}
	};
	
	id operation = [super JSONRequestOperationWithRequest:urlRequest success:success failure:failureHandler];
	
	return operation;
}


@end
