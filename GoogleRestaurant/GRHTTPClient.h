

#import "AFHTTPClient.h"

@interface GRHTTPClient : AFHTTPClient

- (void)cancelAllHTTPOperations;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
							pathIdentifier:(NSString *)pathIdentifier
							pathParameters:(NSDictionary *)pathParameters
								parameters:(NSDictionary *)parameters;

@end
