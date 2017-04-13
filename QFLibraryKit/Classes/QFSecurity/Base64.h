//
//  Base64.h
//  QingFeng
//
//  Created by GuoLiang Xie on 4/22/15.
//  Copyright (c) 2015 Shanghai QingFeng Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

/*!
 *  @method  encode:withWrapWidth:
 *  BASE64编码
 *
 *  @param data 待编码数据
 *  @param wrapWidth 每行的字符串数量，可选76,64
 *
 *  @return 返回编码结果
 */
+ (NSString *) encode : (NSData *)data withWrapWidth:(NSUInteger)wrapWidth;

/*!
 *  @method  encode:
 *  BASE64编码
 *
 *  @param data 待编码数据
 *
 *  @return 返回编码结果
 */
+ (NSString *) encode : (NSData *)data;

/*!
 *  @method decode:
 *  BASE64解码
 *
 *  @param string 待解码字符串
 *
 *  @return 返回解码结果
 */
+ (NSData *) decode : (NSString *)string;

#pragma mark - DES数据加解密
/**
 *  DES数据加密
 *
 *  @param text 明文
 *
 *  @param key 加密的密钥
 *  @return 密文
 */
+ (NSString *)desEncryptionStringFromText:(NSString *)text WithKey:(NSString *)key;

/**
 *  DES数据解密
 *
 *  @param text 密文
 *  @param key  解密密钥
 *
 *  @return 明文
 */
+ (NSString *)desDecryptStringFromText:(NSString *)text WithKey:(NSString *)key;

/**
 *  基于DES的base64数据加密
 *
 *  @param text 明文
 *  @param key  密钥
 *
 *  @return 密文
 */
+ (NSString *)base64StringFromText:(NSString *)text WithKey:(NSString *)key;


/**
 *  基于DES的base64数据解密
 *
 *  @param base64 base64密文
 *  @param key    密钥
 *
 *  @return 明文
 */
+ (NSString *)textFromBase64String:(NSString *)base64 WithKey:(NSString *)key;

@end
