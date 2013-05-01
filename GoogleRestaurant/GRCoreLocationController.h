

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GRCoreLocationControllerDelegate
@required
/**
 * Location delegate should respond to location change
 */
- (void)locationUpdated:(CLLocation *)location;
@end

@interface GRCoreLocationController : NSObject <CLLocationManagerDelegate>

/**
 * Location Manager
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/**
 * Location delegate to responds to location change
 */
@property (nonatomic, weak) id<GRCoreLocationControllerDelegate> delegate;

/**
 * Perform a sync for the current location
 */
- (void)performSync;

@end
