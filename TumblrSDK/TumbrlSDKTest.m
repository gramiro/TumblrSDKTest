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
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        if (limit) {
            [mutableParameters setValue:limit forKey:@"limit"];
        }
        if (offset) {
            [mutableParameters setValue:offset forKey:@"offset"];
        }
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/followers", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG FOLLOWERS REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
                
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"GET ERROR: %@", error);
        }];

        
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}

-(void)postCreateANewBlogTEXTPostWithBaseHostname:(NSString *)baseHostname AndBody:(NSString *)body AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
    
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        if (params)
            mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        [mutableParameters setValue:@"text" forKey:@"type"];
        [mutableParameters setValue:body forKey:@"body"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post", baseHostname]; 
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG POST REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET ERROR: %@", error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}

//MULTIPLE-Photo-Upload is not implemented yet.

-(void)postCreateANewBlogPHOTOPostWithBaseHostname:(NSString *)baseHostname AndSource:(NSString *)source OrImage:(UIImage *)image AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        if (params)
            mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        [mutableParameters setValue:@"photo" forKey:@"type"];

        if (source)
            [mutableParameters setValue:source forKey:@"source"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        if (image && !source)
        {
        NSData* uploadFile = nil;
        uploadFile = (NSData*)UIImageJPEGRepresentation(image,70);
          
            
        NSMutableURLRequest *apiRequest = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            if (uploadFile) {
                [formData appendPartWithFileData:uploadFile name:@"data" fileName:@"text.jpg" mimeType:@"image/jpeg"];
                
            }
        }];
        
        AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //success!
            NSLog(@"SUCCESS! :D, %@", responseObject);
            // completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"FAILURE :(");
            //failure :(
            // completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
        }];
        [operation start];
        
        }
        else
        {
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG POST REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET ERROR: %@", error);
        }];
        
        }
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}




-(void)postCreateANewBlogQUOTEPostWithBaseHostname:(NSString *)baseHostname AndQuote:(NSString *)quote AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        if (params)
            mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        [mutableParameters setValue:@"quote" forKey:@"type"];
        [mutableParameters setValue:quote forKey:@"quote"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG POST REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET ERROR: %@", error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}


-(void)postCreateANewBlogLINKPostWithBaseHostname:(NSString *)baseHostname AndLink:(NSString *)link AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        if (params)
            mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        [mutableParameters setValue:@"link" forKey:@"type"];
        [mutableParameters setValue:link forKey:@"url"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG POST REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET ERROR: %@", error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}

-(void)postCreateANewBlogCHATPostWithBaseHostname:(NSString *)baseHostname AndConversation:(NSString *)conversation AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        if (params)
            mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        [mutableParameters setValue:@"chat" forKey:@"type"];
        [mutableParameters setValue:conversation forKey:@"conversation"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG POST REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET ERROR: %@", error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}

-(void)postEditPostWithBaseHostname:(NSString *)baseHostname AndPostId:(NSString *)postId AndType:(NSString *)type AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        if (params)
            mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        [mutableParameters setValue:type forKey:@"type"];
        
        [mutableParameters setValue:postId forKey:@"id"];

        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post/edit", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG POST REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET ERROR: %@", error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}


-(void)postReblogPostWithBaseHostname:(NSString *)baseHostname AndPostId:(NSString *)postId AndReblogKey:(NSString *)reblog_key AndType:(NSString *)type AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        if (params)
            mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        [mutableParameters setValue:type forKey:@"type"];
        
        [mutableParameters setValue:postId forKey:@"id"];
        
        [mutableParameters setValue:reblog_key forKey:@"reblog_key"];

        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post/reblog", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG POST REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET ERROR: %@", error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}

-(void)postDeletePostWithBaseHostname:(NSString *)baseHostname AndPostId:(NSString *)postId AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        
        [mutableParameters setValue:postId forKey:@"id"];
        
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post/delete", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"BLOG POST REQUEST");
            NSLog(@"Response object: %@", responseObject);
            //Complete with delegate call
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET ERROR: %@", error);
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}

-(void)getBlogPublishedPostsWithBaseHostname:(NSString *)baseHostname AndPostType:(NSString *)type AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    
    NSString *path;
    
    if (type) {
        path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/posts/%@", baseHostname, type];
        }
    else {
       path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/posts", baseHostname];
        }
    
    
    [self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"BLOG PUBLISHED POSTS REQUEST");
        
        NSLog(@"Response object: %@", responseObject);
        
        //Complete with delegate call
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            
            }];
    
}

//This method only accepts MP3 files, please convert to MP3 type the file you want to upload.
-(void)postCreateANewBlogAUDIOPostWithBaseHostname:(NSString *)baseHostname AndSource:(NSString *)external_url OrAudioData:(NSData *)audioData AndParameters:(NSDictionary *)params AndWithDelegate:(NSObject<TumblrDelegate> *)delegate {
    
    
    [self setDefaultHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    
    [self authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"tumblrtest://success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" success:^(AFOAuth1Token *accessToken) {
        
        NSLog(@"TOKEN key: %@", accessToken.key);
        NSLog(@"TOKEN secret: %@", accessToken.secret);
        
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
        
        if (params)
            mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        [mutableParameters setValue:kConsumerKeyString forKey:@"api_key"];
        
        [mutableParameters setValue:@"audio" forKey:@"type"];
        
        if (external_url)
            [mutableParameters setValue:external_url forKey:@"external_url"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
        
        NSString *path = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post", baseHostname];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        if (audioData && !external_url)
        {
            NSData* uploadFile = nil;
            uploadFile = audioData;
            
            
            NSMutableURLRequest *apiRequest = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                if (uploadFile) {
                    [formData appendPartWithFileData:uploadFile name:@"data" fileName:@"data" mimeType:@"audio/mpeg"];
                    
                }
            }];
            
            AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                //success!
                NSLog(@"SUCCESS! :D, %@", responseObject);
                // completionBlock(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"FAILURE :( 123 %@", error);
                //failure :(
                // completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
            }];
            [operation start];
            
        }
        else
        {
            [self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"BLOG POST REQUEST");
                NSLog(@"Response object: %@", responseObject);
                //Complete with delegate call
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"GET ERROR: %@", error);
            }];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"AUTHORIZATION ERROR: %@", error);
    }];
    
}


@end
