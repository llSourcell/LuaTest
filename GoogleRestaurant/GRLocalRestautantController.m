

#import "GRLocalRestautantController.h"
#import "GRJSONRequestOperation.h"

NSString * const GRResultsKey = @"results";

@implementation GRLocalRestautantController
@synthesize locationsArray;

- (void)performSyncForLocation:(CLLocation*)location
					completion:(GRNetworkResultsControllerSuccessBlock)completionBlock
					   failure:(GRNetworkResultsControllerFailureBlock)failureBlock
{
	
	/***
	 * This should be in a config manager
	 */
    
	NSDictionary *parameters = @{@"key": @"AIzaSyAN_s25HwH-6saWq_eHZAJGmFXQ1vke0B0",
							  @"location" : [NSString stringWithFormat:@"%.8f,%.8f", location.coordinate.latitude, location.coordinate.longitude],
							  @"type": @"restaurant",
							  @"sensor" : @"false",
							  @"radius": @"1000"};
    
	
	NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json" parameters:parameters];
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
	{
		
		NSArray *data = [JSON objectForKey:GRResultsKey];
		
		NSMutableArray *parsedObjects = [NSMutableArray array];
		
		/**
		 * The mapping for the restaurant item is \Rources\DataMapping
		 */
		
		for(NSDictionary *dict in data) {
			GRRestaurantLocation *restaurantItem = [[GRRestaurantLocation alloc] init];
			[restaurantItem mapAttributesFromDictionary:dict];
			[parsedObjects addObject:restaurantItem];
		}
		
		self.locationsArray = parsedObjects;

		if (completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock();
			});
		}
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
		if (failureBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				failureBlock(error);
			});
		}
		
	}];
	
	[self.httpClient enqueueHTTPRequestOperation:operation];

}


@end
