//
//  TumbrlSDKTest.h
//  TumblrSDK
//
//  Created by Marco S. Graciano on 4/10/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import "AFOAuth1Client.h"
#import "AFJSONRequestOperation.h"
#import "AFImageRequestOperation.h"

@protocol TumblrDelegate <NSObject>

-(void)imageForImageViewWithImage:(UIImage *)image;

@end


@interface TumbrlSDKTest : AFOAuth1Client

+ (TumbrlSDKTest *)sharedClient;

//NOTE: READ THIS TUMBLR API WEB DOCUMENTATION (requests parameters, etc): http://www.tumblr.com/docs/en/api/v2

//BLOG METHODS
//Base Hostname: The standard or custom blog hostname
-(void)getBlogInfoWithBaseHostname:(NSString *)baseHostname AndWithDelegate:(NSObject <TumblrDelegate> *)delegate;
-(void)getBlogAvatarWithBaseHostname:(NSString *)baseHostname AndSize:(NSString *)avatarSize AndWithDelegate:(NSObject <TumblrDelegate> *)delegate;
-(void)getBlogLikesWithBaseHostname:(NSString *)baseHostname AndLimit:(NSString *)limit AndOffset:(NSString *)offset AndWithDelegate:(NSObject <TumblrDelegate> *)delegate;
-(void)getBlogFollowersWithBaseHostname:(NSString *)baseHostname AndLimit:(NSString *)limit AndOffset:(NSString *)offset AndWithDelegate:(NSObject <TumblrDelegate> *)delegate;
-(void)postCreateANewBlogTEXTPostWithBaseHostname:(NSString *)baseHostname AndBody:(NSString *)body AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;
-(void)postCreateANewBlogPHOTOPostWithBaseHostname:(NSString *)baseHostname AndSource:(NSString *)source OrImage:(UIImage *)image AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;
-(void)postCreateANewBlogQUOTEPostWithBaseHostname:(NSString *)baseHostname AndQuote:(NSString *)quote AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;
-(void)postCreateANewBlogLINKPostWithBaseHostname:(NSString *)baseHostname AndLink:(NSString *)link AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;
-(void)postCreateANewBlogCHATPostWithBaseHostname:(NSString *)baseHostname AndConversation:(NSString *)conversation AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;
-(void)postEditPostWithBaseHostname:(NSString *)baseHostname AndPostId:(NSString *)postId AndType:(NSString *)type AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;
-(void)postReblogPostWithBaseHostname:(NSString *)baseHostname AndPostId:(NSString *)postId AndReblogKey:(NSString *)reblog_key AndType:(NSString *)type AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;
-(void)postDeletePostWithBaseHostname:(NSString *)baseHostname AndPostId:(NSString *)postId AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;
-(void)getBlogPublishedPostsWithBaseHostname:(NSString *)baseHostname AndPostType:(NSString *)type AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;

-(void)postCreateANewBlogAUDIOPostWithBaseHostname:(NSString *)baseHostname AndSource:(NSString *)external_url OrAudioData:(NSData *)audioData AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate;

@end
