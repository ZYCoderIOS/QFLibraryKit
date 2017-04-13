//
//  MiShu_Client_HTTP.h
//  MiShu
//
//  Created by QzydeMac on 15/11/17.
//  Copyright © 2015年 Qzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACSignal.h>

// 返回数据类型
typedef enum
{
    ReturnTypeString,
    ReturnTypeJson,
    ReturnTypeFile,
    ReturnTypeXml
}
ReturnType;


@class HttpPostedFile;

@interface QF_Client_HTTP : RACSignal

+ (RACSignal *)XJ_Client_HTTPWithAction:(NSString *)action parm:(NSDictionary *)parm;

@end
