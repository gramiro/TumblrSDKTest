//
//  TumbrlSDKTest.m
//  TumblrSDK
//
//  Created by Marco S. Graciano on 4/10/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import "TumbrlSDKTest.h"
#import "AFImageRequestOperation.h"

static NSString * const kOAuth1BaseURLString = @"http://www.tumblr.com";
static NSString * const kConsumerKeyString = @"5Z6BdkIl3CPQyzfo86YgBYfMY7RcNjRUqiNXaq0JWbgMFQALJ8";
static NSString * const kConsumerSecretString = @"30IBPzuizZfFFNevUjP3yTOHoEIaxHTApgi27lIMd57bcpr494";
static NSString * const kTokenString = @"";
static NSString * const kTokenSecretString = @"";


@implementation TumbrlSDKTest

+ (TumbrlSDKTest *)sharedClient {
    static TumbrlSDKTest *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[TumbrlSDKTest alloc] initWithBaseURL:[NSURL URLWithString:kOAuth1BaseURLString] key:kConsumerKeyString secret:kConsumerSecretString];
        [_sharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [_sharedClient setDefaultHeader:@"Accept" value:@"application/json"];
                
    });
    
    return _sharedClient;
}

//BLOG METHODS
-(void)getBlogInfoWithBaseHostname:(NSString *)baseHostname AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
    NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    
    NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/info", baseHostname];
    
    [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"BLOG INFO REQUEST");
        
        NSLog(@"Response object: %@", responseObject);
        
        //Complete with delegate call
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];

}


//This method gets the avatar image and not a JSON response
-(void)getBlogAvatarWithBaseHostname:(NSString *)baseHostname AndSize:(NSString *)avatarSize AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    NSString *path;
    
    if (avatarSize) {
        path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/avatar/%@", baseHostname, avatarSize];
    }
    else {
        path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/avatar", baseHostname];
    }
    
    [self registerHTTPOperationClass:[AFImageRequestOperation class]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    AFImageRequestOperation *operation;
    operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        NSLog(@"SUCCESS!");
        [delegate imageForImageViewWithImage:image];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error retrieving image: %@", error);
    }];
    
    [operation start];
     
}

-(void)getBlogLikesWithBaseHostname:(NSString *)baseHostname AndLimit:(NSString *)limit AndOffset:(NSString *)offset AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {

    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
    
    if (limit) {
        [mutableParameters setValue:limit forKey:@"limit"];
    }
    if (offset) {
        [mutableParameters setValue:offset forKey:@"offset"];
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    
    NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/likes", baseHostname];
    
    [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"BLOG LIKES REQUEST");
        
        NSLog(@"Response object: %@", responseObject);
        
        //Complete with delegate call
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];

}

-(void)getBlogFollowersWithBaseHostname:(NSString *)baseHostname AndLimit:(NSString *)limit AndOffset:(NSString *)offset AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN: %@", accessToken);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        //[mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        if (limit) {
            [mutableParameters setValue:limit forKey:@"limit"];
        }
        if (offset) {
            [mutableParameters setValue:offset forKey:@"offset"];
        }
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        parameters = nil;
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/followers", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG FOLLOWERS REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
                
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
        }];

        
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


@end
