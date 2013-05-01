

#import "GRViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GRCoreLocationController.h"
#import "GRLocalRestautantController.h"
#import <MapKit/MapKit.h>

@interface GRLocalMapViewController : GRViewController <MKMapViewDelegate, GRCoreLocationControllerDelegate>

/**
 * The results controller makes the API call to the back end, and parses all the data. 
 * It holds on to an Array that can be accessed within the viewController
 */
@property (nonatomic, strong) GRLocalRestautantController *resultsController;
/**
 * Location Controller, performs a geolocation of user. Once it is found a 
 * search is triggered but the results controller in the delegate callback
 */
@property (nonatomic, strong) GRCoreLocationController *locationController;
@end
