

#import "GRLocalMapViewController.h"
#import "GRRestaurantDetailViewController.h"
#import "GRLocalRestautantController.h"
#import "GRCoreLocationController.h"



@interface GRMoreButton : UIButton

@property (nonatomic, strong) GRRestaurantLocation *contentItem;

@end

@implementation GRMoreButton

@synthesize contentItem = contentItem_;

@end


@interface GRLocalMapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) GRMoreButton *infoButton;

- (void)refresh:(id)sender;
@end

@implementation GRLocalMapViewController
@synthesize resultsController = resultsController_;
@synthesize locationController = locationController_;
@synthesize mapView = mapView_;
@synthesize refreshButton = refreshButton_;
@synthesize infoButton = infoButton_;

CGFloat const kMetersPerMile = 1609.00;

static inline BOOL initGRHomeViewController(GRLocalMapViewController *controller) {
	[controller.containerView setBackgroundColor:[UIColor blueColor]];
	[controller.containerView addSubview:[controller mapView]];
	[controller.containerView addSubview:[controller refreshButton]];
	return YES;
}


- (id)init {
	self = [super init];
	if (self && initGRHomeViewController(self)) {
	}
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[[self locationController] performSync];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


- (void)layoutSubviews:(UIInterfaceOrientation)orientation {
	[super layoutSubviews:orientation];
	
	[self.containerView setFrame:self.view.bounds];
	[self.mapView setFrame:self.containerView.bounds];
	[self.refreshButton setFrame:CGRectMake(CGRectGetWidth(self.view.frame)-90.0f, 10.0f, 80.0f, 40.0f)];
}

- (void)locationUpdated:(CLLocation *)location {

	CLLocationCoordinate2D coord = [location coordinate];
   
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, kMetersPerMile, kMetersPerMile);
	MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
   
	[self.mapView setRegion:adjustedRegion animated:YES];
	
	[self.resultsController performSyncForLocation:location completion:^{
	
		for (id<MKAnnotation> annotation in mapView_.annotations) {
			[self.mapView removeAnnotation:annotation];
		}
		
		for (GRRestaurantLocation *locationItem in [self.resultsController locationsArray]) {
			[self.mapView addAnnotation:locationItem];
		}
		
	} failure:^(NSError *error) {
	
	}];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"LocationIdentifier";
    if ([annotation isKindOfClass:[GRRestaurantLocation class]]) {
        
        MKPinAnnotationView *view = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
       
		if (view == nil) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
		} else {
            view.annotation = annotation;
        }
		
        view.canShowCallout = YES;
        view.calloutOffset=CGPointMake(-20,10);
		
		[view setRightCalloutAccessoryView:[self infoButton]];
        return view;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	[[self infoButton] setContentItem:view.annotation];
}


- (GRLocalRestautantController *)resultsController {
	if (!resultsController_) {
		resultsController_ = [[GRLocalRestautantController alloc] init];
	}
	return resultsController_;
}


- (GRCoreLocationController *)locationController {
	if (!locationController_) {
		locationController_ = [[GRCoreLocationController alloc] init];
		[locationController_ setDelegate:self];
	}
	return locationController_;
}


- (MKMapView*)mapView {
	if (!mapView_){
		mapView_ = [[MKMapView alloc] initWithFrame:CGRectZero];
		[mapView_ setDelegate:self];
		mapView_.showsUserLocation = YES;
	}
	return mapView_;
}


- (UIButton*)refreshButton {
	if (!refreshButton_){
		refreshButton_ = [self newButton];
		[refreshButton_ setTitle:@"Locate" forState:UIControlStateNormal];
		[refreshButton_ addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
	}
	return refreshButton_;
}


- (void)refresh:(id)sender {
	[self.locationController performSync];
}


- (GRMoreButton*)infoButton {
	if (!infoButton_){
		infoButton_ = [[GRMoreButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
		[infoButton_ setBackgroundColor:[UIColor blackColor]];
		[infoButton_.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
		[infoButton_.titleLabel setShadowColor:[UIColor grayColor]];
		[infoButton_.titleLabel setShadowOffset:CGSizeMake(-1, 0)];
		[infoButton_ setTitle:@"More" forState:UIControlStateNormal];
		[infoButton_ addTarget:self action:@selector(tapped_info:) forControlEvents:UIControlEventTouchUpInside];
		[infoButton_.layer setCornerRadius:10.0f];
	}
	return infoButton_;
}


-(void)tapped_info:(id)sender {
	GRRestaurantDetailViewController *newDetailViewController = [[GRRestaurantDetailViewController alloc] init];
	[newDetailViewController.view setBackgroundColor:[UIColor redColor]];
	[newDetailViewController setModalPresentationStyle:UIModalPresentationFullScreen];
	[newDetailViewController setContentItem:((GRMoreButton*)sender).contentItem];
	[self presentModalController:newDetailViewController animated:YES completion:nil];
}


- (UIButton*)newButton {
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
	[button.layer setCornerRadius:5.0f];
	[button setBackgroundColor:[UIColor grayColor]];
	[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
	return button;
}

@end
