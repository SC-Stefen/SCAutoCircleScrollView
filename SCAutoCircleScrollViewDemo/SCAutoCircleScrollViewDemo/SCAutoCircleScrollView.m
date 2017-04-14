//
//  SCAutoCircleScrollView.m
//  SCAutoCircleScrollViewDemo
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 sc-ici. All rights reserved.
//

#import "SCAutoCircleScrollView.h"

@implementation SCAutoCircleScrollView


- (id)initThePageControlOnScrollViewWithFrame : (CGRect)pageControlFrame andAutoCircleScrollViewWithFrame : (CGRect)scrollViewFrame withViewsArray : (NSArray*)viewsArray withTimeInterval : (NSTimeInterval)timeInterval {
    
    
    self = [super initWithFrame:scrollViewFrame];
    
    if(self) {
        
        _autoCircleScrollViewSelectionType = SCAutoCircleScrollViewSelectionTypeTap;
        
        scrollViewSourceArray = viewsArray;
        
        scheduledtimeInterval = timeInterval;
        
        self.userInteractionEnabled = YES;
        
        [self initPageControlWithFrame:pageControlFrame andScrollViewsWithFrame:scrollViewFrame];
        
        
        
    }
    
    return  self;
}


- (void)initPageControlWithFrame : (CGRect)pageControlFrame andScrollViewsWithFrame: (CGRect)scrollViewFrame {
    
    CGFloat scrollViewWidth = scrollViewFrame.size.width;
    
    CGFloat scrollViewHeight = scrollViewFrame.size.height;
    
    //初始化ScrollView
    
    _autoCircleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    
    _autoCircleScrollView.backgroundColor = [UIColor redColor];
    _autoCircleScrollView.delegate = self;
    _autoCircleScrollView.showsVerticalScrollIndicator = NO;
    _autoCircleScrollView.showsHorizontalScrollIndicator = NO;
    _autoCircleScrollView.pagingEnabled = YES;
    _autoCircleScrollView.contentSize = CGSizeMake(([scrollViewSourceArray count] +2 ) * scrollViewWidth, scrollViewHeight);
    
    
    [self addSubview:_autoCircleScrollView];
    
    
    //将要自动循环的视图(UIImageView)添加到ScrollView上
    
    UIImageView *firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    firstImageView.image = [UIImage imageNamed:[scrollViewSourceArray lastObject]];  //如果图片保存在远程服务器、本机图片库或者应用程序沙盒中，需要修改一下该方法
    [_autoCircleScrollView addSubview:firstImageView];
    
    for (int i = 0; i < [scrollViewSourceArray count]; i++) {
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake((i+1)*scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
        imageview.image = [UIImage imageNamed:[scrollViewSourceArray objectAtIndex:i]];
        [_autoCircleScrollView addSubview:imageview];
    }
    
    UIImageView *lastImageView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollViewWidth*(scrollViewSourceArray.count+1), 0, scrollViewWidth, scrollViewHeight)];
    lastImageView.image = [UIImage imageNamed:[scrollViewSourceArray objectAtIndex:0]];
    [_autoCircleScrollView addSubview:lastImageView];
    
    //初始化时，将scrollView上的view设置为第一个view
    [_autoCircleScrollView scrollRectToVisible:CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight) animated:NO];
    
    //初始化pageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:pageControlFrame];
    _pageControl.numberOfPages = scrollViewSourceArray.count;
    _pageControl.currentPage = 0;
    _pageControl.enabled = YES;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self addSubview:_pageControl];
    
    //添加一个定时器，用于scrollView自动循环
    timer = [NSTimer scheduledTimerWithTimeInterval:scheduledtimeInterval target:self selector:@selector(scrollToNextPageAutomatically:) userInfo:nil repeats:YES];
    
    
    //添加一个点击手势，如果ScrollView设置的是可以点击状态，则触发响应的方法
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheScrollView:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
}



-(void)scrollToNextPageAutomatically:(id)sender
{
    //工作原理：
    
    //1. 首先，判断scrollView当前在第几页，此时可以通过计算scrollView的content的偏移量来协助确认：如果“偏移量/pageWidth”的值是0，说明当前scrollView的x坐标值为0，对应的是最后一张图像，那么当前pageControl.currentPage的值是最后一个(views的数量-1，因为pageControl的值是从0开始的，下同)；如果“偏移量/pageWidth”的值是“views数量+1”，说明当前scrollview显示的是第一张图片，那么当前pageControl.currentPage的值是0；其它情况是“偏移量/pageWidth” - 1.
    
    //2. 然后，根据_pageControl.currentPage的值，我们将scrollView滚动到下一张图上，这个通过设置“[_autoCircleScrollView scrollRectToVisible:rect animated:YES];”的方法来实现，并同时增加currentPageNumber的值(currentPageNumber的初始值为当前pageControl.currentPage的值)。
    
    //3. 最后，如果pageControl.currentPage的值为views的数量，那么从第一张图开始循环，并设置currentPageNumber的值为0.
    
    CGFloat pageWidth = _autoCircleScrollView.frame.size.width;
    int currentPage = _autoCircleScrollView.contentOffset.x/pageWidth;
    
    if (currentPage == 0) {
        
        _pageControl.currentPage = scrollViewSourceArray.count-1;
        
    }else if (currentPage == scrollViewSourceArray.count+1) {
        
        _pageControl.currentPage = 0;
        
    }else {
        
        _pageControl.currentPage = currentPage-1;
        
    }
    
    long currentPageNumber = _pageControl.currentPage;
    
    CGSize viewSize = _autoCircleScrollView.frame.size;
    
    CGRect rect = CGRectMake((currentPageNumber+2)*pageWidth, 0, viewSize.width, viewSize.height);
    
    [_autoCircleScrollView scrollRectToVisible:rect animated:YES];
    
    currentPageNumber++;
    
    if (currentPageNumber == scrollViewSourceArray.count) {
        
        _autoCircleScrollView.contentOffset = CGPointMake(0, 0);
        
        currentPageNumber = 0;
        
    }
    
    self.pageControl.currentPage = currentPageNumber;
    
}

//点击scrollView时触发
- (void)tapTheScrollView:(UITapGestureRecognizer *)tapGesture
{
    if (_autoCircleScrollViewSelectionType != SCAutoCircleScrollViewSelectionTypeTap) {
        return;
    }
    if (_autoCircleScrollViewDelegate && [_autoCircleScrollViewDelegate respondsToSelector:@selector(autoCircleScrollViewDidClickedAtPage:)]) {
        
        [_autoCircleScrollViewDelegate autoCircleScrollViewDidClickedAtPage:_pageControl.currentPage];
    }
}

#pragma mark---- UIScrollView delegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动scrollview的时候 停止计时器控制的跳转
    [timer invalidate];
    
    timer = nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat width = _autoCircleScrollView.frame.size.width;
    CGFloat height = _autoCircleScrollView.frame.size.height;
    
    
    //当手指滑动scrollview，而scrollview减速停止的时候 开始计算当前的图片的位置
    int currentPage = _autoCircleScrollView.contentOffset.x/width;
    
    if (currentPage == 0) {
        
        _autoCircleScrollView.contentOffset = CGPointMake(width * scrollViewSourceArray.count, 0);
        
        [_autoCircleScrollView scrollRectToVisible:CGRectMake(scrollViewSourceArray.count * width, 0, width, height) animated:YES];
        
        _pageControl.currentPage = scrollViewSourceArray.count-1;
        
    }else if (currentPage == scrollViewSourceArray.count+1) {
        
        _autoCircleScrollView.contentOffset = CGPointMake(width, 0);
        
        [_autoCircleScrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:YES];
        
        _pageControl.currentPage = 0;
        
    }else {
        
        _pageControl.currentPage = currentPage-1;
        
    }
    //拖动完毕的时候 重新开始计时器控制跳转
    timer = [NSTimer scheduledTimerWithTimeInterval:scheduledtimeInterval target:self selector:@selector(scrollToNextPageAutomatically:) userInfo:nil repeats:YES];

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
