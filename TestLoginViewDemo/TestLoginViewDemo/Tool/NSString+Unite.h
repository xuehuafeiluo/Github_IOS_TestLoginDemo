//
//  NSString+Unite.h
//  Play
//
//  Created by langhua on 16/10/31.
//  Copyright © 2016年 langhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Unite)
/**是否是手机号或者座机号*/
- (BOOL)isValidateMobileOrLandLine;
/**字符串是否为空*/
- (BOOL)isStringNotNil;
@end
