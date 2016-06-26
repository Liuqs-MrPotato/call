//
//  PushuToViewController.m
//  动画
//
//  Created by 刘全水 on 16/6/23.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "PushuToViewController.h"
#import "LiuqsInvertTranisition.h"

#define ColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:0.9f]
#define DiyBlueColor  ColorRGB(44, 133, 255)
#define Width CGRectGetWidth(self.view.bounds)
#define Height CGRectGetHeight(self.view.bounds)
#define screenRate [UIScreen mainScreen].bounds.size.width/320
#define iconSize 65
#define enlargeRate 2.0

@interface PushuToViewController ()<UINavigationControllerDelegate>

@end

@implementation PushuToViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self creatBgView];
    [self drawLayer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)creatBgView {
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgView.alpha = 0.8;
    bgView.image = [UIImage imageNamed:@"13.JPG"];
    [self.view addSubview:bgView];
}

- (void)drawLayer {
    
    UIButton *baseView = [[UIButton alloc]initWithFrame:CGRectMake(self.IconCenter.x - (iconSize * enlargeRate * 0.5 * screenRate), self.IconCenter.y - (iconSize * enlargeRate * 0.5 * screenRate), iconSize * enlargeRate * screenRate, iconSize * enlargeRate * screenRate)];
    baseView.layer.cornerRadius = iconSize * enlargeRate * 0.5 * screenRate;
    [baseView setImage:[UIImage imageNamed:@"icon.JPG"] forState:UIControlStateNormal];
    baseView.layer.masksToBounds = YES;
    baseView.backgroundColor = DiyBlueColor;
    [self.view addSubview:baseView];
    
    UIButton *hideBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.IconCenter.x - 20 * screenRate, Height - 100 * screenRate, 40 * screenRate, 40 * screenRate)];
    hideBtn.layer.cornerRadius = 20 * screenRate;
    hideBtn.backgroundColor = [UIColor whiteColor];
    [hideBtn setImage:[UIImage imageNamed:@"shutdown"] forState:UIControlStateNormal];
    [hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideBtn];
}

- (void)hide {

    [self.navigationController popViewControllerAnimated:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        LiuqsInvertTranisition *pingInvert = [[LiuqsInvertTranisition alloc]init];
        return pingInvert;
    }else{
        return nil;
    }
}

@end
