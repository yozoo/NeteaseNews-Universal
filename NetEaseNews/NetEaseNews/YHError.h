//
//  YHError.h
//  NetEaseNews
//
//  Created by yozoo on 5/8/16.
//  Copyright © 2016 yozoo. All rights reserved.
//  错误处理类

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, PTSErrorCode) {
//    PTSErrorNil = 1,  // 返回数据为空
//    PTSErrorSuccess, // 返回成功
//    PTSErrorOther
//};

@interface YHError : NSObject

/**
 *  错误信息
 */
@property (nonatomic, copy) NSString *errorString;

/**
 *  错误代码
 */
@property (nonatomic, assign) NSString *errorCode;

@end
