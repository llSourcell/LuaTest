

#import "GRNetworkResultsController.h"
#import <CoreLocation/CoreLocation.h>

@interface GRLocalRestautantController : GRNetworkResultsController

@property (nonatomic, strong) NSArray *locationsArray;

- (void)performSyncForLocation:(CLLocation*)location
					completion:(GRNetworkResultsControllerSuccessBlock)completionBlock
					   failure:(GRNetworkResultsControllerFailureBlock)failureBlock;
@end
