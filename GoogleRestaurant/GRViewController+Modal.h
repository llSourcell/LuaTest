

#import "GRViewController.h"

@interface GRViewController (Modal)

+ (CAAnimationGroup *)modalAnimationGroup:(BOOL)beingPresented;

- (void)presentModalController:(GRViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissModalViewAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end
