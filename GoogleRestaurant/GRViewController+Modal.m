

#import "GRViewController+Modal.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation GRViewController (Modal)

+ (CAAnimationGroup *)modalAnimationGroup:(BOOL)beingPresented {

	CATransform3D pushBackTransform = CATransform3DIdentity;
    pushBackTransform.m34 = 1.0/-500;
    pushBackTransform = CATransform3DScale(pushBackTransform, 0.95, 0.95, 1);
    pushBackTransform = CATransform3DRotate(pushBackTransform, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    CATransform3D scaleTransform = CATransform3DIdentity;
    scaleTransform.m34 = pushBackTransform.m34;
    scaleTransform = CATransform3DTranslate(scaleTransform, 0, 0, 0);
    scaleTransform = CATransform3DScale(scaleTransform, 0.75, 0.75, 1);
    
    CABasicAnimation *pushBackAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    pushBackAnimation.toValue = [NSValue valueWithCATransform3D:pushBackTransform];
	CFTimeInterval duration = 0.40f;
    pushBackAnimation.duration = duration/2;
    pushBackAnimation.fillMode = kCAFillModeForwards;
    pushBackAnimation.removedOnCompletion = NO;
    [pushBackAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:(beingPresented?scaleTransform:CATransform3DIdentity)];
    scaleAnimation.beginTime = pushBackAnimation.duration;
    scaleAnimation.duration = pushBackAnimation.duration;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:pushBackAnimation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:pushBackAnimation,scaleAnimation, nil]];
    return group;
}


- (void)presentModalController:(GRViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
	[self setIsBelowModalView:YES];
	[self.containerView.layer addAnimation:[[self class] modalAnimationGroup:YES] forKey:nil];
	[self presentViewController:viewControllerToPresent animated:YES completion:completion];
}


- (void)dismissModalViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
	[self dismissViewControllerAnimated:animated completion:completion];
}

@end
