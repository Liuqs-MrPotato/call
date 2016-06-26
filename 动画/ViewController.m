//
//  ViewController.m
//  动画
//
//  Created by 刘全水 on 16/6/23.
//  Copyright © 2016年 刘全水. All rights reserved.
//

#import "ViewController.h"
#import "PushuToViewController.h"
#import "LiuqsTransition.h"

//屏幕比例
#define screenRate [UIScreen mainScreen].bounds.size.width/320
//按钮的初始大小
#define iconSize 65
//屏幕宽度
#define Width CGRectGetWidth(self.view.bounds)
//屏幕高度
#define Height CGRectGetHeight(self.view.bounds)
//初始的动画value，用于缩放动画
#define SminValue [NSNumber numberWithFloat:1.0]
//最终的动画value，用于缩放动画
#define SmaxValue [NSNumber numberWithFloat:2.0]
//按钮执行移动动画的最终位置
#define showFrame CGRectMake(self.view.center.x - iconSize * 0.5 * screenRate, (200 - iconSize * 0.5) * screenRate, iconSize * screenRate, iconSize * screenRate)
//动画执行的时间
#define AnimationDuration 0.4
//规定的上下左右的坐标值
#define staticLeft 10 * screenRate + iconSize * 0.5
#define staticRight Width - (10 * screenRate + iconSize * 0.5)
#define staticUp 64 + iconSize * 0.5
#define staticdown

@interface ViewController ()<UINavigationControllerDelegate>

//记录悬浮按钮的位置
@property (assign, nonatomic)CGPoint lastPoint;


@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBgView];
    [self drawLayer];
    [self addNotis];
}

//添加通知
- (void)addNotis {
//    pop结束的通知，收到后执行hide事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popOKAction) name:@"popOK" object:nil];
}

//背景图
- (void)creatBgView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"12.JPG"];
    bgView.alpha = 0.8;
    [self.view addSubview:bgView];
}

//状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

//pop完成的通知事件
- (void)popOKAction {

    [self hide];
}

//创建悬浮按钮并添加手势
- (void)drawLayer {

    UIImageView *baseView = [[UIImageView alloc]initWithFrame:CGRectMake(Width - (iconSize + 30) * screenRate, Height - (200 - iconSize) * screenRate, iconSize * screenRate, iconSize * screenRate)];
    UIButton *btn = [[UIButton alloc]initWithFrame:showFrame];
    baseView.layer.cornerRadius = iconSize * 0.5 * screenRate;
    baseView.image = [UIImage imageNamed:@"tab_call_press"];
    baseView.layer.masksToBounds = YES;
    baseView.userInteractionEnabled = YES;
    baseView.contentMode = UIViewContentModeCenter;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    self.lastPoint = baseView.center;
    self.IconCenter = btn.center;
    self.baseView = baseView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMoving:)];
    [baseView addGestureRecognizer:pan];
    [baseView addGestureRecognizer:tap];
}

//按钮的拖拽手势
- (void)dragMoving:(UIPanGestureRecognizer *)pan {
//    当前手指的位置坐标
    CGPoint gestuerPoint = [pan locationInView:self.view];
//    改变按钮的位置，让它跟着手指移动
    self.baseView.center = gestuerPoint;
//    判断已经结束拖拽
    if (pan.state == UIGestureRecognizerStateEnded) {
        
//        创建一个坐标用来设置拖拽结束时按钮的位置
        CGPoint FinalStopCenter;
        
//        判断拖拽结束时按钮的位置然后重新设置其位置
        if (gestuerPoint.x <= Width * 0.5) {//结束时按钮在屏幕的左侧

            if (gestuerPoint.y > Height - iconSize * 0.5) {//结束时按钮在屏幕的下方（超出规定的最大高度）
//                设置最终的坐标
                FinalStopCenter = CGPointMake(staticLeft, Height - iconSize);
            }else if (gestuerPoint.y < 64){//结束时按钮在屏幕的上方（超出规定的最小高度）
//            设置最终的坐标
                FinalStopCenter = CGPointMake(staticLeft, staticUp);
            }else {//在左侧，高度在规定的范围
//            设置最终的坐标
                FinalStopCenter = CGPointMake(staticLeft, gestuerPoint.y);
            }
            
        }else {//结束时按钮在屏幕的右侧
            if (gestuerPoint.y > Height - iconSize * 0.5) {//结束时按钮在屏幕的下方（超出规定的最大高度）
//                设置最终的坐标
                FinalStopCenter = CGPointMake(staticRight, Height - iconSize);
            }else if (gestuerPoint.y < 64){//结束时按钮在屏幕的上方（超出规定的最小高度）
//                设置最终的坐标
                FinalStopCenter = CGPointMake(staticRight, staticUp);
            }else {//在右侧，高度在规定的范围
//                设置最终的坐标
                FinalStopCenter = CGPointMake(staticRight, gestuerPoint.y);
            }
        }
        //松开手指后执行一个动画让小按钮移动到屏幕边缘
        [UIView animateWithDuration:0.2 animations:^{
            self.baseView.center = FinalStopCenter;
        } completion:^(BOOL finished) {
            //保存当前按钮的位置（用于执行按钮展开收回动画的执行轨迹）
            self.lastPoint = FinalStopCenter;
        }];
    }
}

- (CABasicAnimation *)creatScaleAnimansWithFromValue:(id)fromValue andToValue:(id)toValue {
    //缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.repeatCount = 0;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.duration = AnimationDuration;
    scaleAnimation.fromValue = fromValue;
    scaleAnimation.toValue = toValue;
    return scaleAnimation;
}

//展开事件
- (void)show {
     __weak __typeof__(self) weakSelf = self;
//     创建一个缩放动画并执行
    CABasicAnimation *scalAnimation = [self creatScaleAnimansWithFromValue:SminValue andToValue:SmaxValue];
    [self.baseView.layer addAnimation:scalAnimation forKey:@"frameShow"];
//    用uiview动画改变按钮的frame，因为涉及到事件，用CABasicAnimation处理会很麻烦一点而且可能会出现问题
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.baseView.frame = showFrame;
        weakSelf.baseView.contentMode = UIViewContentModeScaleToFill;
        weakSelf.baseView.image = [UIImage imageNamed:@"icon.JPG"];
    } completion:^(BOOL finished) {
//        动画执行完以后，也就是按钮到达最终展开时的位置触发pushu方法
        PushuToViewController *pushVC = [[PushuToViewController alloc]init];
        pushVC.IconCenter = weakSelf.IconCenter;
        [weakSelf.navigationController pushViewController:pushVC animated:YES];
    }];
}

//收起事件
- (void)hide{

    __weak __typeof__(self) weakSelf = self;
    // 创建缩放动画并执行
    CABasicAnimation *scalAnimation = [self creatScaleAnimansWithFromValue:SmaxValue andToValue:SminValue];
    [self.baseView.layer addAnimation:scalAnimation forKey:@"frameHide"];
//    同时执行按钮frame改变的动画，动画的最终位置就是存储的最后一次展开式按钮的位置
    [UIView animateWithDuration:AnimationDuration animations:^{
        weakSelf.baseView.center = weakSelf.lastPoint;
    } completion:^(BOOL finished) {
        //动画完成改变按钮的图片
         weakSelf.baseView.contentMode = UIViewContentModeCenter;
        weakSelf.baseView.image = [UIImage imageNamed:@"tab_call_press"];
    }];
}

//点击按钮是执行展开的动画
- (void)btnClick {
    
    [self show];
}

#pragma mark - UINavigationControllerDelegate
//导航控制器的代理方法，在这里监听push事件，并拿自定义的跳转方式替换默认的
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        //push的跳转
        LiuqsTransition *ping = [[LiuqsTransition alloc]init];
        ping.IconCenter = self.IconCenter;
        return ping;
    }else{
        
        return nil;
    }
}

//移除通知
-(void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
