//
//  RootViewController.m
//  TumblrSDK
//
//  Created by Marco S. Graciano on 4/10/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import "RootViewController.h"
#import "TumbrlSDKTest.h"
#import "AFImageRequestOperation.h"


@interface RootViewController ()

@end

@implementation RootViewController
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 128, 128)];
    [self.view addSubview:imageView];
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.contentMode = UIViewContentModeCenter;
	
    //BLOG METHODS TESTING:
   // [[TumbrlSDKTest sharedClient] getBlogInfoWithBaseHostname:@"zarph.tumblr.com" AndWithDelegate:nil];
    //[[TumbrlSDKTest sharedClient] getBlogAvatarWithBaseHostname:@"david.tumblr.com" AndSize:@"128" AndWithDelegate:self];
    //[[TumbrlSDKTest sharedClient] getBlogLikesWithBaseHostname:@"good.tumblr.com" AndLimit:@"5" AndOffset:@"3" AndWithDelegate:nil];
    //[[TumbrlSDKTest sharedClient] getBlogFollowersWithBaseHostname:@"marco85msg.tumblr.com" AndLimit:nil AndOffset:nil AndWithDelegate:nil];
    
    
   // [[TumbrlSDKTest sharedClient] getBlogFollowersWithBaseHostname:@"zarph.tumblr.com" AndLimit:nil AndOffset:nil AndWithDelegate:nil];
    
    
   // [[TumbrlSDKTest sharedClient] postCreateANewBlogPHOTOPostWithBaseHostname:@"zarph.tumblr.com" AndSource:nil OrImage:[UIImage imageNamed:@"51112.jpg"] AndParameters:nil AndWithDelegate:nil];
    
   // [[TumbrlSDKTest sharedClient] postCreateANewBlogTEXTPostWithBaseHostname:@"zarph.tumblr.com" AndBody:@"Test" AndParameters:nil AndWithDelegate:nil];
    
   // [[TumbrlSDKTest sharedClient] postCreateANewBlogQUOTEPostWithBaseHostname:@"zarph.tumblr.com" AndQuote:@"Quoting" AndParameters:nil AndWithDelegate:nil];
    
   // [[TumbrlSDKTest sharedClient] postCreateANewBlogLINKPostWithBaseHostname:@"zarph.tumblr.com" AndLink:@"http://thelink.com" AndParameters:nil AndWithDelegate:nil];
    
   // [[TumbrlSDKTest sharedClient] postCreateANewBlogCHATPostWithBaseHostname:@"zarph.tumblr.com" AndConversation:@"CONVO" AndParameters:nil AndWithDelegate:nil];
    
  //  [[TumbrlSDKTest sharedClient] getBlogPublishedPostsWithBaseHostname:@"zarph.tumblr.com" AndPostType:@"link" AndParameters:nil AndWithDelegate:nil];
    
  //  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Testing is fun!", @"body", nil];
    
   // [[TumbrlSDKTest sharedClient] postEditPostWithBaseHostname:@"zarph.tumblr.com" AndPostId:@"47817133365" AndType:@"text" AndParameters:params AndWithDelegate:nil];
    
   // [[TumbrlSDKTest sharedClient] postReblogPostWithBaseHostname:@"zarph.tumblr.com" AndPostId:@"47817109770" AndReblogKey:@"wL8ltLDl" AndType:@"text" AndParameters:nil AndWithDelegate:nil];
    
   //[[TumbrlSDKTest sharedClient] postDeletePostWithBaseHostname:@"zarph.tumblr.com" AndPostId:@"47817133365" AndWithDelegate:nil];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imageForImageViewWithImage:(UIImage *)image {
    self.imageView.image = image;
}

@end
