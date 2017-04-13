//
//  ViewConfig.m
//  PinHuo
//
//  Created by QingFeng11 on 14-4-1.
//  Copyright (c) 2014年 QingFeng11. All rights reserved.
//

#import "ViewConfig.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HintContentLabel : UILabel
@end
@implementation HintContentLabel

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 6, 0, 6))];
}

@end


@implementation ViewConfig

+(void)promptByStr:(NSString *)str
{
    if ([str isEqualToString:@""] || !str) {
        return;
    }
    str = [str description];
    
    
    
    UILabel *promptlable=[[HintContentLabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 60)];
    promptlable.numberOfLines = 0;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    promptlable.layer.cornerRadius = 4.0;
    promptlable.layer.masksToBounds = YES;
    promptlable.backgroundColor=[UIColor blackColor];
    promptlable.textAlignment = NSTextAlignmentCenter;
    promptlable.text=str;
    promptlable.textColor=[UIColor whiteColor];
    promptlable.font = [UIFont systemFontOfSize:14];
    [window addSubview:promptlable];
    [promptlable sizeToFit];
    [window bringSubviewToFront:promptlable];
    promptlable.alpha=0.0;
    
    
    
    promptlable.frame = CGRectMake(0, 0, promptlable.frame.size.width + 15, promptlable.frame.size.height + 15);
    
    promptlable.center = CGPointMake(kScreenWidth/2.0, kScreenHeight - 80);
    [UIView animateWithDuration:0.5 animations:^
     {
         promptlable.alpha=0.8;
         promptlable.center = CGPointMake(kScreenWidth/2.0, kScreenHeight - 110);
     }
     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:1.0 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
             promptlable.alpha=0.0 ;

         } completion:^(BOOL finished) {
             [promptlable removeFromSuperview];
         }];
     }];
}

/**
 *  在屏幕偏上方显示提示
 */
+(void)abovePromptByStr:(NSString *)str
{
    CGSize trueSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    UILabel *promptlable=[[UILabel alloc]initWithFrame:CGRectMake(([ViewConfig contentWidth]-trueSize.width-30)/2, 120, trueSize.width+30, 30)];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    promptlable.layer.cornerRadius = 4.0;
    promptlable.layer.masksToBounds = YES;
    promptlable.backgroundColor=[UIColor blackColor];
    promptlable.textAlignment=NSTextAlignmentCenter;
    promptlable.text=str;
    promptlable.textColor=[UIColor whiteColor];
    promptlable.font = [UIFont systemFontOfSize:14];
    [window addSubview:promptlable];
    [window bringSubviewToFront:promptlable];
    promptlable.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^
     {
         promptlable.alpha=1.0;
     }
     completion:^(BOOL finished)
    {
        [UIView animateWithDuration:1.0 animations:^
        {
            promptlable.alpha=0.0 ;
            
        } completion:^(BOOL finished)
        {
            [promptlable removeFromSuperview];
        }];
     }];
}
/**
 * 内容视图宽度
 */
+(float)contentWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}
/**
 * 内容视图高度
 */
+(float)contentHeight
{
    return [[UIScreen mainScreen] bounds].size.height-64;
}

@end
