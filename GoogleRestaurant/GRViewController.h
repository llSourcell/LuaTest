
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GRViewController : UIViewController

/**
 * The containerView that all views should be added within the viewController
 */
@property (nonatomic, strong) UIView *containerView;

/**
 * Flag set to true if a mdoal view has been presented on top. In case an animation needs to begin
 */
@property (nonatomic, readwrite) BOOL isBelowModalView;

/**
 Used by subclasses to be notified when the views should be laid out
 */
- (void)layoutSubviews:(UIInterfaceOrientation)orientation;

@end
