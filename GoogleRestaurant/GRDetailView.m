

#import "GRDetailView.h"
#import "UIImageView+AFNetworking.h"

@interface GRDetailView ()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLevelLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@end

@implementation GRDetailView
@synthesize contentItem = contentItem_;
@synthesize iconImage = iconImage_;
@synthesize titleLabel = titleLabel_;
@synthesize priceLevelLabel = priceLevelLabel_;
@synthesize addressLabel = addressLabel_;

static inline bool initGRDetailView(GRDetailView *view) {
	[view addSubview:[view iconImage]];
	[view addSubview:[view titleLabel]];
	[view addSubview:[view priceLevelLabel]];
	[view addSubview:[view addressLabel]];
	return true;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self && initGRDetailView(self)) {
	}
    return self;
}


- (void)setContentItem:(GRRestaurantLocation *)contentItem {
	if (contentItem_ == contentItem) {
		return;
	}
	
	contentItem_ = contentItem;
	[self.iconImage setImageWithURL:[NSURL URLWithString:[contentItem_ iconURL]]];
	[self.titleLabel setText:[contentItem title]];
	[self.addressLabel setText:[contentItem vicinity]];
	
	if ([contentItem priceLevel]) {
		[self.priceLevelLabel setText:[NSString stringWithFormat:@"Price Range %@", [contentItem priceLevel]]];
	}
	
	[self setNeedsLayout];
}


-(void)layoutSubviews {
	[self.iconImage setFrame:CGRectMake(20, 20, 100, 100)];
	[self.titleLabel setFrame:CGRectMake(20, 120, 260, 40)];
	[self.addressLabel setFrame:CGRectMake(20, 150, 260, 40)];
	[self.priceLevelLabel setFrame:CGRectMake(20, 180, 260, 40)];
}


- (UIImageView *)iconImage {
	if (!iconImage_) {
		iconImage_ = [[UIImageView alloc] initWithFrame:CGRectZero];
		[iconImage_ setContentMode:UIViewContentModeScaleToFill];
		[iconImage_ setClipsToBounds:YES];
		[iconImage_ setBackgroundColor:[UIColor clearColor]];
		[iconImage_ setOpaque:NO];
		[iconImage_.layer setOpaque:NO];
		
	}
	return iconImage_;
}


-(UILabel*)titleLabel {
	if(!titleLabel_) {
		titleLabel_ = [self newLabel];
	}
	return titleLabel_;
}


-(UILabel*)priceLevelLabel {
	if(!priceLevelLabel_) {
		priceLevelLabel_ = [self newLabel];
	}
	return priceLevelLabel_;
}


-(UILabel*)addressLabel {
	if(!addressLabel_) {
		addressLabel_ = [self newLabel];
	}
	return addressLabel_;
}


- (UILabel*)newLabel {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont fontWithName:@"Hevelitca-Bold" size:14]];
	[label setTextAlignment:NSTextAlignmentLeft];
	
	return label;
}

@end
