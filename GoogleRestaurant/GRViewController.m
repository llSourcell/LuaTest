

#import "GRViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GRRestaurantDetailViewController.h"

@interface GRViewController ()
@end

@implementation GRViewController
@synthesize containerView = containerView_;
@synthesize isBelowModalView;

static inline BOOL initGRViewController(GRViewController *controller) {
	[controller.view addSubview:[controller containerView]];
	return YES;
}

- (id)init {
	self = [super init];
	if (self && initGRViewController(self)) {
	}	
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self layoutSubviews:[[UIApplication sharedApplication] statusBarOrientation]];
	
	if(self.isBelowModalView) {
		[self.containerView.layer addAnimation:[[self class] modalAnimationGroup:NO] forKey:nil];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


- (void)layoutSubviews:(UIInterfaceOrientation)orientation {
	[self.containerView setFrame:self.view.bounds];
}


- (UIView*)containerView {
	
	if (!containerView_) {
		containerView_ = [[UIView alloc] initWithFrame:CGRectZero];
		[containerView_ setBackgroundColor:[UIColor colorWithRed:241.0f green:241.0f blue:241.0f alpha:1.0]];
	}
	return containerView_;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self layoutSubviews:toInterfaceOrientation];
}



@end
