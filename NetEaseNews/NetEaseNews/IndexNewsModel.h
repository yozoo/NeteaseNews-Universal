//
//  IndexNewsModel.h
//  NetEaseNews
//
//  Created by yozoo on 5/29/16.
//  Copyright © 2016 yozoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexNewsModel : NSObject <NSCoding>

//@property (nonatomic, copy) NSString *token;
//@property (nonatomic, copy) NSString *role;


// postID
@property (nonatomic, copy) NSString *postid;
// 标题
@property (nonatomic, copy) NSString *title;
// 摘要
@property (nonatomic, copy) NSString *digest;
// 图片
@property (nonatomic, copy) NSString *imgsrc;
// 跟贴数
@property (nonatomic, copy) NSNumber *replyCount;
// 多张配图
@property (nonatomic, strong) NSArray *imgextra;
// 大图标记
@property (nonatomic, assign) BOOL imgType;
//@property (nonatomic,strong)NSArray *specialextra;

@property (nonatomic,copy) NSString *tname;
/**
 *  新闻发布时间
 */
@property (nonatomic,copy) NSString *ptime;
// 电脑版url
@property (nonatomic,copy) NSString *url_3w;
// url
@property (nonatomic,copy) NSString *url;
// 表决数
@property (nonatomic,copy) NSString *votecount;

@property (nonatomic,copy) NSString *skipID;
// 长标题
@property (nonatomic,copy) NSString *ltitle;

@property (nonatomic,copy) NSString *photosetID;
//@property (nonatomic,copy) NSNumber *hasHead;
//@property (nonatomic,copy) NSNumber *hasImg;
// 修改时间
@property (nonatomic,copy) NSString *lmodify;
@property (nonatomic,copy) NSString *template;
@property (nonatomic,copy) NSString *skipType;
// 修改时间
@property (nonatomic,copy) NSString *priority;
// 来源
@property (nonatomic,copy) NSString *source;

// 广告
@property (nonatomic,strong) NSArray *ads;


@end
