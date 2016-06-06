//
//  YHManageTool.m
//  NetEaseNews
//
//  Created by yozoo on 5/8/16.
//  Copyright © 2016 yozoo. All rights reserved.

#import "YHManageTool.h"
#import "AFNetworking.h"

@implementation YHManageTool

#pragma mark - 获取管理对象
+ (AFHTTPSessionManager *)setupHttpManage
{
    // 创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 说明服务器返回json数据
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/javascript", @"text/json", nil];
    
    return mgr;
}

+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(YHError *))failure
{
    // 获取管理对象
    AFHTTPSessionManager *mgr = [self setupHttpManage];
    
    [mgr POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        // 如果有数据
        if ([responseObject count]) {
            
            if ([responseObject[@"code"] integerValue] == 200) { // 成功
                // 成功则返回json
                success(responseObject);
                // 成功则返回成功信息
                YHError *psError = [[YHError alloc] init];
                psError.errorCode = responseObject[@"code"];
                psError.errorString = @"成功";
            } else if ([responseObject[@"returns"] integerValue]) {
                // 成功则返回json
                success(responseObject);
            } else {
                // 失败则返回失败信息
                YHError *psError = nil;
                psError.errorCode = responseObject[@"code"];
                psError.errorString = responseObject[@"message"];
                failure(psError);
            }
            
        } else {
            // 没有数据则返回空代码
            YHError *psError = [[YHError alloc] init];
            psError.errorCode = @"404";
            psError.errorString = @"数据为空!";
            failure(psError);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 失败则返回失败信息
        YHError *psError = [[YHError alloc] init];
        psError.errorCode = error.localizedDescription;
        psError.errorString = @"数据库连接失败";
        failure(psError);
        
    }];

}

+ (void)GetWithURL:(NSString *)URL parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(YHError *))failure
{
    
    // 获取管理对象
    AFHTTPSessionManager *mgr = [self setupHttpManage];
    
    [mgr GET:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // 如果有数据
        if ([responseObject count]) {
            
                // 成功则返回json
                success(responseObject);
                // 成功则返回成功信息
                YHError *psError = [[YHError alloc] init];
                psError.errorCode = responseObject[@"replyCount"];
                psError.errorString = @"成功";
                failure(psError);
            
        } else {
            // 没有数据则返回空代码
            YHError *psError = [[YHError alloc] init];
            psError.errorCode = responseObject[@"code"];
            psError.errorString = @"数据为空!";
            failure(psError);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 失败则返回失败信息
        YHError *psError = [[YHError alloc] init];
        psError.errorCode = error.localizedDescription;
        psError.errorString = @"数据库连接失败";
        failure(psError);
        
    }];
}

+ (void)PostWithURL:(NSString *)URL parameters:(NSDictionary *)parameters formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(YHError *))failure
{
    
    // 获取管理对象
    AFHTTPSessionManager *mgr = [self setupHttpManage];
    
    [mgr POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull totalformData) {
        
        for (MyFormData *formData in formDataArray) {
            [totalformData appendPartWithFileData:formData.data name:formData.name fileName:formData.fileName mimeType:formData.mimeType];
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // 如果有数据
        if ([responseObject count]) {
            
            if ([responseObject[@"code"] integerValue] == 200) { // 成功
                // 成功则返回json
                success(responseObject);
                // 成功则返回成功信息
                YHError *psError = [[YHError alloc] init];
                psError.errorCode = responseObject[@"code"];
                psError.errorString = @"成功";
                failure(psError);
            } else if ([responseObject[@"returns"] integerValue]) {
                // 成功则返回json
                success(responseObject);
            } else {
                // 失败则返回失败信息
                YHError *psError = [[YHError alloc] init];
                psError.errorCode = responseObject[@"code"];
                psError.errorString = responseObject[@"message"];
                failure(psError);
            }
            
        } else {
            // 没有数据则返回空代码
            YHError *psError = [[YHError alloc] init];
            psError.errorCode = @"404";
            psError.errorString = @"数据为空!";
            failure(psError);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 失败则返回失败信息
        YHError *psError = [[YHError alloc] init];
        psError.errorCode = error.localizedDescription;
        psError.errorString = @"数据库连接失败";
        failure(psError);
        
    }];
    
}

@end
