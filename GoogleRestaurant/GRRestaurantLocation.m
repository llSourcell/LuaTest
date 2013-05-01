
#import "GRRestaurantLocation.h"

@implementation GRRestaurantLocation
@synthesize iconURL;
@synthesize name;
@synthesize priceLevel;
@synthesize latitude;
@synthesize longitude;
@synthesize vicinity;


- (NSString *)title {
    if (!self.name) {
        return @"Unknown";
    } 
	return self.name;
}

- (NSString *)subtitle {
	if (!self.vicinity) {
        return @"Unknown";
    }
	return self.vicinity;
}


- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.longitude = [self.longitude doubleValue];
	coordinate.latitude = [self.latitude doubleValue];
	return coordinate;
}


@end
