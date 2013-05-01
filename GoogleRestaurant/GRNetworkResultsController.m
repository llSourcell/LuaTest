

#import "GRNetworkResultsController.h"
#import "GRJSONRequestOperation.h"

@implementation GRNetworkResultsController
@synthesize httpClient;

- (id)init {
	self = [super init];
	if (self) {
		self.httpClient = [[GRHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json"]];
		[self.httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	}
    return self;
}

@end
