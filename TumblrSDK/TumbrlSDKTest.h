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



@end
