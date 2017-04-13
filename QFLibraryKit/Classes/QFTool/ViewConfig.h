//
//  ViewConfig.h
//  PinHuo
//
//  Created by QingFeng11 on 14-4-1.
//  Copyright (c) 2014年 QingFeng11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewConfig : NSObject

//提示
+(void)promptByStr:(NSString *)str;

//在屏幕的上方的提示
+(void)abovePromptByStr:(NSString *)str;
@end
