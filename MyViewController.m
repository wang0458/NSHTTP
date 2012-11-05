//
//  MyViewController.m
//  NSHTTP
//
//  Created by Ibokan on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyViewController.h"
#import "ASIDownloadCache.h"
#import "Reachability.h"
@implementation MyViewController
@synthesize myprogressView;
@synthesize myimageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (IBAction)btnPress:(id)sender {
      
    UIButton *btn=(UIButton *)sender;
    
    Reachability *ability=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([ability currentReachabilityStatus]==NotReachable) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
   
    }
        
    if (btn.tag==0) {
        NSURL *url=[NSURL URLWithString:@"http://allseeing-i.com"];
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url];
        [request startSynchronous];//发起同步请求
        NSError *error=[request error];
        if (!error) {
            NSString *response=[request responseString];
            NSLog(@"服务器返回信息%@",response);
        }
        
        else
        {
            NSLog(@"网络连接错误：%@",error);
        }
     
    }
    //异步请求下载图片
    else if(btn.tag==1)
    {
    
        NSURL *url=[NSURL URLWithString:@"http://az4.neostrada.pl/pliki/grafika/celawp/1.jpg"];
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:url];
        request.delegate=self;
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"xx.jpg",@"key",nil]];
        NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];//?
        NSLog(@"路径%@",cachePath);
        NSString *tempPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.jpg.download"];
        UIImage *image=[[UIImage alloc]init];//下载图片的话，要求临时目录里必须要先有个文件才可以
    NSData *data=[[NSData alloc]initWithData:UIImagePNGRepresentation(image)];
        [data writeToFile:tempPath atomically:YES];
//        UIImageView *imageTemp=[UIImageView alloc]initWithImage:<#(UIImage *)#>
        [request setTemporaryFileDownloadPath:tempPath];//缓存路径
        [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:@"xx.jpg"]];//下载路径
        [request setAllowResumeForFileDownloads:YES];//支持断点续传
        [request setDownloadCache:[ASIDownloadCache sharedCache]];//加上之后利用缓存，如果原来下载过就不在下载
        request.downloadProgressDelegate=self.myprogressView;//下载进度代理
        [myprogressView setProgress:0 animated:YES];
        [request startAsynchronous];//开始异步下载
        
          
    }
     
}
//异步下载图片完成后显示图片
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%s",__FUNCTION__);
    NSString *jpgName=[[request userInfo]objectForKey:@"key"];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    UIImage *image=[[UIImage alloc]initWithContentsOfFile:[[paths lastObject]stringByAppendingPathComponent:jpgName ]];
    self.myimageView.image=image;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
 
}

- (void)viewDidUnload
{
    [self setMyprogressView:nil];
    [self setMyimageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [myprogressView release];
    [myimageView release];
    [super dealloc];
}
@end
