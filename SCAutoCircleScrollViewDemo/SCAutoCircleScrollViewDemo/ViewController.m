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
    
    sourceArray = [[NSArray alloc]initWithObjects:@"IMG_001.jpg",@"IMG_002.jpg",@"IMG_003.jpg",@"IMG_004.jpg", nil];
    
    
    SCAutoCircleScrollView *scrollView = [[SCAutoCircleScrollView alloc]initThePageControlOnScrollViewWithFrame:CGRectMake(0, 170, deviceScreenWidth, 30) andAutoCircleScrollViewWithFrame:CGRectMake(0, 30, deviceScreenWidth, 200) withViewsArray:sourceArray withTimeInterval : 2.0];
    

    scrollView.autoCircleScrollViewDelegate = self;
    
    [self.view addSubview:scrollView];
    
    
}

- (void)autoCircleScrollViewDidClickedAtPage:(NSInteger)pageNumber
{
    
    NSLog(@"点击了第%ld个view",(long)pageNumber);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
