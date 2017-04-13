//
//  PGJ_Client_HTTP.m
//  PGJ
//
//  Created by QzydeMac on 15/11/17.
//  Copyright © 2015年 Qzy. All rights reserved.
//
#import "QF_Client_HTTP.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#import <ReactiveCocoa/RACSubject.h>
#import <CommonCrypto/CommonDigest.h>
#import "Base64.h"

// appid
static NSString * kXiaoJingAppid                            = @"appid";
// 时间戳
static NSString * kXiaoJingTimeStamp                        = @"timestamp";
// 签名
static NSString * kXiaoJingSignature                        = @"signature";


@interface QF_Client_HTTP ()
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@end

static QF_Client_HTTP * gSharedInstance = nil;
@implementation QF_Client_HTTP

+(QF_Client_HTTP *)sharedXJ_Client_HTTP
{
    @synchronized(self)
    {
        if (gSharedInstance == nil)
            gSharedInstance = [[QF_Client_HTTP alloc] init];
    }
    return gSharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
    }
    return self;
}

+ (RACSignal *)XJ_Client_HTTPWithAction:(NSString *)action parm:(NSDictionary *)parm
{
    NSMutableDictionary *tempParm;
    if (parm.count)
    {
        tempParm = [[NSMutableDictionary alloc] initWithDictionary:parm];
    }
    else
    {
        tempParm = [[NSMutableDictionary alloc] init];
    }
    
    NSString * methodName = [NSString stringWithFormat:@"%@RequestWithPram:",action];
    SEL sel = NSSelectorFromString(methodName);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
    
    // 需要在请求处处理请求框架
    if ([[QF_Client_HTTP sharedXJ_Client_HTTP] respondsToSelector:sel])
    {
        return [[QF_Client_HTTP sharedXJ_Client_HTTP] performSelector:sel withObject:tempParm];
    }
    
    return [[QF_Client_HTTP sharedXJ_Client_HTTP] performSelector:@selector(defaultRequestAction:WithPram:) withObject:action withObject:tempParm];
#pragma clang diagnostic pop
}

- (RACSignal *)rac_POST:(NSString *)subServerName parameters:(NSDictionary *)parm
{
    return [self rac_POST:subServerName parameters:parm returnType:ReturnTypeJson];
}

- (RACSignal *)rac_POST:(NSString *)subServerName parameters:(NSDictionary *)parm returnType:(ReturnType)type
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self POST:subServerName parameters:parm returnType:type subscriber:subscriber];
        return nil;
    }];
}

- (void)POST:(NSString *)subServerName
  parameters:(NSDictionary *)parm
  returnType:(ReturnType)type
  subscriber:(id<RACSubscriber>) subscriber

{
    NSMutableDictionary * newParm = [[NSMutableDictionary alloc]initWithDictionary:parm];

    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.requestSerializer.timeoutInterval = 10;
    
    // 设置加密请求头
    [_manager.requestSerializer setValue:@"" forHTTPHeaderField:kXiaoJingAppid];
    [_manager.requestSerializer setValue:@"" forHTTPHeaderField:kXiaoJingTimeStamp];
    [_manager.requestSerializer setValue:[self signatureWithRequestURL:subServerName] forHTTPHeaderField:kXiaoJingSignature];
    
    NSLog(@"请求地址-->%@\n%@ %@",subServerName,newParm,_manager.session);
    
    if (type == ReturnTypeJson)
    {
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];

        [_manager POST:subServerName  parameters:newParm success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSLog(@"请求结果-->%@\n%@",subServerName,responseObject);
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             [subscriber sendNext:responseObject];
             [subscriber sendCompleted];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // [MBProgressHUD dismiss];
             NSLog(@"error %@",error);
             NSLog(@"请求错误结果-->%@\n%@ %@",subServerName,newParm,_manager.session);
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             [subscriber sendError:error];
         }];
    }
    else
    {
        if(type == ReturnTypeFile)
        {
            _manager.responseSerializer = [AFImageResponseSerializer serializer];
        }
        else
        {
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        
        [_manager GET:subServerName  parameters:newParm success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             [subscriber sendNext:responseObject];
             [subscriber sendCompleted];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //[MBProgressHUD dismiss];
             NSLog(@"error %@",error);
             NSLog(@"请求请求错误结果-->%@\n%@ %@",subServerName,newParm,_manager.session);
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             [subscriber sendError:error];
         }];
    }
}

- (NSString *)signatureWithRequestURL:(NSString *)url
{
    NSString * timeStamp = [self timeStamp];
    static NSString * appKey = @"";
    NSString * plain = [NSString stringWithFormat:@"%@%@%@",appKey,timeStamp,url];
    return [self sha1_base64:plain];
}

- (NSString *)timeStamp
{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     return [dateFormat stringFromDate:[NSDate date]];
}

- (NSString *) sha1_base64:(NSString *)plain
{
    const char *cstr = [plain cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:plain.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    NSString * output = [Base64 encode:base64];
//    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

#pragma mark - 缺省的网络请求
- (RACSignal *)defaultRequestAction:(NSString *)subServerName WithPram:(NSDictionary *)parm
{
    return  [[self rac_POST:subServerName parameters:parm returnType:ReturnTypeJson] map:^id(id value) {
        return value;
    }];
}
@end
