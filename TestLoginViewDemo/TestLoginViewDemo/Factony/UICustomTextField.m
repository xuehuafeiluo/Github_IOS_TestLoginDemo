//
//  UICustomTextField.m
//  Play
//
//  Created by langhua on 16/10/31.
//  Copyright © 2016年 langhua. All rights reserved.
//

#import "UICustomTextField.h"

@interface UICustomTextField ()<UITextFieldDelegate>

@end

@implementation UICustomTextField

#define kMaxLength 20


- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placehString{
    self = [super initWithFrame:frame];
    if(self){

        self.frame = frame;
        self.placeholder = placehString;//提示字符
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [self setValue:[UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:0.5f] forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont systemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
        self.delegate = self;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius =CGRectGetHeight(self.frame)/2;
        self.layer.masksToBounds=  YES;
        [self distanceLeftView:self];
        [self addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

#pragma mark 最多多少个字符
- (void)textFieldTextDidChanged:(UITextField *)sender
{
    NSString * tempString = sender.text;
    
    if (sender.markedTextRange == nil && tempString.length > kMaxLength)
    {
        sender.text = [tempString substringToIndex:kMaxLength];
        [sender.undoManager removeAllActions];
    }
}

// 1.找到弹出键盘的textFie// 3.编写协议方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 回收键盘
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 距离左边的距离 15 是距离
- (void)distanceLeftView:(UITextField *)textField{
    //UITextField左边的距离
    CGRect frame = [textField frame];
    frame.size.width = 15;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    textField.leftView = leftview;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
