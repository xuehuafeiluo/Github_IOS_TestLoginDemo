//
//  ViewController.m
//  Play
//
//  Created by langhua on 16/10/30.
//  Copyright © 2016年 langhua. All rights reserved.
//

#import "ViewController.h"
#import "YYKeyboardManager.h"
#import "UICustomTextField.h"
#import "NSString+Unite.h"

@interface ViewController ()<YYKeyboardObserver>

@property (weak,nonatomic)UICustomTextField *userTextField;
@property (weak,nonatomic)UICustomTextField *passTextField;
@property (weak,nonatomic)UICustomTextField *verTextField;
@property (weak,nonatomic)UIButton *timeButt;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"登录";

    UICustomTextField *userTextField = [[UICustomTextField alloc] initWithFrame:CGRectMake(50, 100, CGRectGetWidth(self.view.frame)-50*2, 35) placeholder:@"输入手机号:"];
    _userTextField =userTextField;
    [self.view addSubview:userTextField];
    
    UICustomTextField *passTextField = [[UICustomTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(userTextField.frame), CGRectGetMaxY(userTextField.frame)+20, CGRectGetWidth(userTextField.frame), 35) placeholder:@"输入密码:"];
    _passTextField = passTextField;
    passTextField.secureTextEntry = YES;
    [self.view addSubview:passTextField];
    
    UICustomTextField *verTextField = [[UICustomTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(userTextField.frame), CGRectGetMaxY(passTextField.frame)+20, 220, 35) placeholder:@"输入验证码:"];
    _verTextField = verTextField;
    [self.view addSubview:verTextField];
    
    UIButton *timeButt = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButt = timeButt;
    timeButt.frame = CGRectMake(CGRectGetMaxX(verTextField.frame)+20, CGRectGetMinY(verTextField.frame), 80, 35);
    [timeButt addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    [timeButt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [timeButt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    timeButt.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:timeButt];
    
    UIButton *loginButt = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButt.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [loginButt setTitle:@"登 陆" forState:UIControlStateNormal];
    [loginButt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    loginButt.backgroundColor = [UIColor yellowColor];
    [loginButt addTarget:self action:@selector(onClickView:) forControlEvents:UIControlEventTouchUpInside];
    loginButt.frame = CGRectMake(CGRectGetMinX(verTextField.frame), CGRectGetMaxY(verTextField.frame)+20, CGRectGetWidth(passTextField.frame), 35);
    loginButt.layer.cornerRadius = 5.0f;
    loginButt.layer.masksToBounds = YES;
    loginButt.layer.borderColor = [UIColor grayColor].CGColor;
    loginButt.layer.borderWidth = 0.5f;
    [self.view addSubview:loginButt];
    
    [[YYKeyboardManager defaultManager] addObserver:self];

}

-(void)startTime{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_timeButt setTitle:@"获取验证码" forState:UIControlStateNormal];
                _timeButt.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_timeButt setTitle:[NSString stringWithFormat:@"%@秒",@([strTime integerValue])] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _timeButt.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark 点击事件
- (void)onClickView:(id)sender{
    NSString *userStr = _userTextField.text;
    NSString *passStr = _passTextField.text;

    if(![userStr isStringNotNil]||![passStr isStringNotNil]){
        NSLog(@"用户名或者密码为空");
    }else if(![userStr isValidateMobileOrLandLine]){
        NSLog(@"手机号不对");
    }
}

#pragma mark - @protocol YYKeyboardObserver

- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition {
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption animations:^{
        YYKeyboardManager *manager = [YYKeyboardManager defaultManager];
        
        //键盘高度
        CGRect kbFrame = [[YYKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        CGFloat moveHight;
        //delix 是最下面的UITextField 距离键盘的距离
        CGFloat delix = CGRectGetHeight(kbFrame)-(CGRectGetHeight(self.view.frame)-(CGRectGetMaxY(_passTextField.frame)));
        if(delix>0){//大于0才移动，证明是遮挡
            if(manager.isKeyboardVisible){
                moveHight -=delix;
            }
            else{
                moveHight +=delix;
            }
            _userTextField.frame = CGRectOffset(_userTextField.frame, 0, moveHight);
            _passTextField.frame = CGRectOffset(_passTextField.frame, 0, moveHight);
        }
        
       
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 点击空白隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[YYKeyboardManager defaultManager] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
