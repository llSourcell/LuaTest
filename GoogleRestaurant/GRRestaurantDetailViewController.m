

#import "GRRestaurantDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GRDetailView.h"

@interface GRRestaurantDetailViewController ()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) GRDetailView *detailView;
@end

@implementation GRRestaurantDetailViewController
@synthesize closeButton = closeButton_;
@synthesize detailView = detailView_;
@synthesize contentItem = contentItem_;

- (id)init {
	self = [super init];
	if (self) {
		[self.containerView addSubview:[self detailView]];
		[self.containerView addSubview:[self closeButton]];
	}
	return self;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)setContentItem:(GRRestaurantLocation *)contentItem {
	if (contentItem_ == contentItem) {
		return;
	}
	
	contentItem_ = contentItem;
	[self.detailView setContentItem:contentItem_];
}


- (void)tapped_dismiss:(id)sender {
	[self dismissModalViewAnimated:YES completion:nil];
}


- (void)layoutSubviews:(UIInterfaceOrientation)orientation {
	[super layoutSubviews:orientation];
	[self.detailView setFrame:self.containerView.bounds];
	[self.closeButton setFrame:CGRectMake(CGRectGetWidth(self.view.frame)-90.0f, 10.0f, 80.0f, 40.0f)];
}


- (UIButton*)closeButton {
	if (!closeButton_){
		closeButton_ = [self newButton];
		[closeButton_ setTitle:@"Close" forState:UIControlStateNormal];
		[closeButton_ addTarget:self action:@selector(tapped_dismiss:) forControlEvents:UIControlEventTouchUpInside];
	}
	return closeButton_;
}


- (UIButton*)newButton {
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
	[button.layer setCornerRadius:5.0f];
	[button setBackgroundColor:[UIColor grayColor]];
	[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
	return button;
}

-(GRDetailView *)detailView {
	
	if(!detailView_) {
		detailView_ = [[GRDetailView alloc] initWithFrame:CGRectZero];
	}
	return detailView_;
}

@end
