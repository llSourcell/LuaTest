

#import "GRHTTPClient.h"
#import "GRJSONRequestOperation.h"

@implementation GRHTTPClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
    	[self.operationQueue addObserver:self forKeyPath:@"operations" options:0 context:(__bridge void*)self];
	}
	
	return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == (__bridge void *)self) {
		if ([keyPath isEqualToString:@"operations"] && object == self.operationQueue) {
			if (self.operationQueue.operationCount > 0) {
				[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			} else {
				[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			}
		}
	}
}


- (void)dealloc {
	[self.operationQueue removeObserver:self forKeyPath:@"operations"];
}


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
							pathIdentifier:(NSString *)pathIdentifier
							pathParameters:(NSDictionary *)pathParameters
								parameters:(NSDictionary *)parameters
{
	return [self requestWithMethod:method path:nil parameters:parameters];
}


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
	
	return [self HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
}


- (void)cancelAllHTTPOperations {
	for (NSOperation *operation in [self.operationQueue operations]) {
		if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
			continue;
		}
		
		[operation cancel];
	}
}

@end
