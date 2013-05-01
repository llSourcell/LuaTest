

#import "GRCoreLocationController.h"
#import <CoreLocation/CoreLocation.h>

@implementation GRCoreLocationController
@synthesize locationManager = locationManager_;
@synthesize delegate = delegate_;


- (void)performSync {
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your location could not be determined." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (void)locationManager:(CLLocationManager *)manage didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
   [delegate_ locationUpdated:newLocation];
}


- (CLLocationManager*)locationManager {
	if (!locationManager_) {
		locationManager_ = [[CLLocationManager alloc] init];
		locationManager_.delegate = self;
		locationManager_.distanceFilter = 500;
		locationManager_.desiredAccuracy = kCLLocationAccuracyKilometer;
	}
	
	return locationManager_;
}

@end
