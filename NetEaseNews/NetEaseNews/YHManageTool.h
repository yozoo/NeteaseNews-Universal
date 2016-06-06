//
//  PTSManageTool.h
//  PTS80
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//
//  网络请求类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YHError.h"

@interface YHManageTool : NSObject

/**
 *  发送Post请求
 *
 *  @param URL        url地址
 *  @param parameters 参数
 *  @param success    成功后的json
 *  @param failure    失败后的error
 */
+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(YHError * error))failure;

/**
 *  发送Get请求
 *
 *  @param URL        url地址
 *  @param parameters 参数
 *  @param success    成功后的json
 *  @param failure    失败后的error
 */
+ (void)GetWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(YHError * error))failure;

/**
 *  表单形式的多图上传
 *
 *  @param URL           url地址
 *  @param parameters    参数
 *  @param formDataArray 表单数组，数组里面放的时MyFormData模型
 *  @param success       成功后的json
 *  @param failure       失败后的error
 */
+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(YHError * error))failure;

@end

@interface MyFormData : NSObject
/**
 *  图片数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  文件名称
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;
@end
