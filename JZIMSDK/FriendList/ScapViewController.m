//
//  ScapViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/10/25.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "ScapViewController.h"

@interface ScapViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation ScapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Image Capturing";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addWebView];
    [self createNavBar];
}

- (void)createNavBar
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStyleDone target:self action:@selector(navBarButtonClick:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)navBarButtonClick:(id)nav
{
    CGFloat height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    CGSize size = CGSizeMake(_webView.frame.size.width, height);
    UIGraphicsBeginImageContext(size);
    
   __block UIView *t_view = nil;
    
    [_webView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) hasPrefix:@"UIWebBrowserView"])
        {
            t_view = obj;
        }
    }];
    
    if (!t_view) {
        return;
    }
    [t_view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self saveImageToPhotos:image];

//    NSData *data = UIImageJPEGRepresentation(image, 1);
//    NSArray *fileDic = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [fileDic objectAtIndex:0];
//    NSLog(@"%@",filePath);
//    NSString *imagePath = [filePath stringByAppendingPathComponent:[[NSDate date] description]];
//    [data writeToFile:[NSString stringWithFormat:@"%@.png",imagePath] atomically:YES];
//    NSLog(@"%@",image);
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addWebView
{
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.delegate = self;
    _webView.pageLength = MAXFLOAT;
    _webView.scalesPageToFit = NO;
//    _webView.paginationBreakingMode = UIWebPaginationBreakingModeColumn;
    _webView.suppressesIncrementalRendering = YES;
    _webView.paginationMode = UIWebPaginationModeUnpaginated;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://baike.baidu.com/link?url=_8AG6Ie09SmiBXlYFvakEZmWFBgDELi-STbM7dotfINo9a3bNG9_nN9Jha-f7vXwJXGr4Ts2cIJcHF2F2mN7-q"]];
    
    [_webView loadRequest:urlRequest];
    
    [self.view addSubview:_webView];
}

- (UIImage *)imageRepresentation
{
    CGSize boundsSize =  _webView.bounds.size;
    CGFloat boundsWidth = _webView.bounds.size.width;
    CGFloat boundsHeight = _webView.bounds.size.height;
    
    CGPoint offset = _webView.scrollView.contentOffset;
    [_webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    CGFloat contentHeight = _webView.scrollView.contentSize.height;
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        UIGraphicsBeginImageContext(boundsSize);
        [_webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = _webView.scrollView.contentOffset.y;
        [_webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    [_webView.scrollView setContentOffset:offset];
    
    UIGraphicsBeginImageContext(_webView.scrollView.contentSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0, boundsHeight * idx, boundsWidth, boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
}

#pragma mark - webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGFloat height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    CGSize size = CGSizeMake(_webView.frame.size.width, height);
//    UIGraphicsBeginImageContext(size);
//    [_webView.scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, _webView.scrollView.frame);
//    UIImage *image1 = [UIImage imageWithCGImage:ref];
//    
//    NSData *data = UIImageJPEGRepresentation(image1, 1);
//    NSArray *fileDic = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [fileDic objectAtIndex:0];
//    NSLog(@"%@",filePath);
//    NSString *imagePath = [filePath stringByAppendingPathComponent:[[NSDate date] description]];
//    [data writeToFile:[NSString stringWithFormat:@"%@.png",imagePath] atomically:YES];
//    NSLog(@"%@",image1);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

@end
