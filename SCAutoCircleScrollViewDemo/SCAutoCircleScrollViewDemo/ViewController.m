//
//  ViewController.m
//  SCAutoCircleScrollViewDemo
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 sc-ici. All rights reserved.
//

#import "ViewController.h"

#define deviceScreenWidth [[UIScreen mainScreen]bounds].size.width

#define deviceScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化自动循环的scrollView
    //json解析
    
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1/exerciseAutoScrollView/exerciseAutoScrollView.php"]];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestURL
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          
                                          NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[[NSData alloc]
                                                                                                            initWithData:data]
                                                                                                   options:NSJSONReadingMutableContainers
                                                                                                     error:nil];
                                          
                                          //NSDictionary *weatherInfo = [jsonData objectForKey:@"IMG_003"];
                                          
                                          NSArray *arr = [[NSArray alloc]initWithArray:[jsonData allKeys]];
                                          
                                          // NSLog(@"arr里面的内容为--》%@", [weatherInfo objectForKey:@"location"]);
                                          
                                          NSLog(@"arr里面的内容为--》%@", arr);
                                          
                                          NSMutableArray *textArr = [[NSMutableArray alloc]initWithCapacity:10];
                                          
                                          for(int i =0; i < [arr count]; i++) {
                                              
                                              NSDictionary *imageDataInfoDic = [jsonData objectForKey:[arr objectAtIndex:i]];
                                              
                                              [textArr addObject:[imageDataInfoDic objectForKey:@"location"]];
                                          }
                                          
                                          sourceArray = [[NSArray alloc]initWithArray:textArr];
                                          
                                          NSLog(@"sourceArray=%@", sourceArray);
                                          
                                          
                                          
                                          SCAutoCircleScrollView *scrollView = [[SCAutoCircleScrollView alloc]initThePageControlOnScrollViewWithFrame:CGRectMake(deviceScreenWidth / 2, 100, deviceScreenWidth / 2, 30) andAutoCircleScrollViewWithFrame:CGRectMake(0, 0, deviceScreenWidth, 130) withViewsArray:sourceArray withTimeInterval : 2.0];
                                          
                                          scrollView.autoCircleScrollViewDelegate = self;
                                          
                                          [self.view addSubview:scrollView];
                                          
                                      }];
    // 使用resume方法启动任务
    [dataTask resume];
    
    
}

#pragma mark 实现SCAutoCircleScrollViewDelegate中的方法

- (void)autoCircleScrollViewDidClickedAtPage:(NSInteger)pageNumber
{
    
    NSLog(@"点击了第%ld个view",(long)pageNumber);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
