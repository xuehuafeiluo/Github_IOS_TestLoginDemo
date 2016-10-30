//
//  NSString+Unite.m
//  Play
//
//  Created by langhua on 16/10/31.
//  Copyright © 2016年 langhua. All rights reserved.
//

#import "NSString+Unite.h"

@implementation NSString (Unite)

#pragma mark 是否是手机号或者座机号
- (BOOL)isValidateMobileOrLandLine
{
    NSString *phoneRegex = @"^(((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8})|(\\(?0\\d{2}\\)?[- ]?\\d{8}|0\\d{2}[- ]?\\d{8})$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

#pragma mark 字符串是否为空
- (BOOL)isStringNotNil
{
    return (self.length > 0 && ![self isEqualToString:@""] && self!= nil && self != NULL);
}


@end
