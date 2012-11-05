//
//  MyViewController.h
//  NSHTTP
//
//  Created by Ibokan on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import <SystemConfiguration/SystemConfiguration.h>
@interface MyViewController : UIViewController<ASIHTTPRequestDelegate,ASIProgressDelegate>
@property (retain, nonatomic) IBOutlet UIProgressView *myprogressView;
@property (retain, nonatomic) IBOutlet UIImageView *myimageView;
- (IBAction)btnPress:(id)sender;

@end
