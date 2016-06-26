//
//  LiuqsTranisition.m
//  动画
//
//  Created by 刘全水 on 16/6/23.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "LiuqsInvertTranisition.h"
#import "ViewController.h"
#import "PushuToViewController.h"
#define screenRate [UIScreen mainScreen].bounds.size.width/320
#define iconSize 65

@interface LiuqsInvertTranisition()

@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;

@end

@implementation LiuqsInvertTranisition


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.4f;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;

    PushuToViewController *fromVC = (PushuToViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC   = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(toVC.IconCenter.x - (iconSize * 1.5 * 0.5 * screenRate), toVC.IconCenter.y - (iconSize * 1.5 * 0.5 * screenRate), iconSize * 1.5 * screenRate, iconSize * 1.5 * screenRate)];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    
    CGPoint finalPoint;
    
    //判断触发点在那个象限
    if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else{
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = [self transitionDuration:transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"pushuAnimation"];
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popOK" object:nil];
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    
}

@end
