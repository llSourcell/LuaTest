

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GRRestaurantLocation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *vicinity;
@property (nonatomic, readwrite) NSNumber *priceLevel;
@property (nonatomic, readwrite) NSNumber *latitude;
@property (nonatomic, readwrite) NSNumber *longitude;
@end
