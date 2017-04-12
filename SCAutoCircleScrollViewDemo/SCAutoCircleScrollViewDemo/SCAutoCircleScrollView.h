//
//  SCAutoCircleScrollView.h
//  SCAutoCircleScrollViewDemo
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 sc-ici. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    //Set the scrollView selection or not type. Dafult is SCAutoCircleScrollViewSelectionTypeTap
    
    SCAutoCircleScrollViewSelectionTypeTap,   //Can tap the scrollView to get a detail information or new view
    
    SCAutoCircleScrollViewSelectionTypeNone  //Cannot tap the scrollView
    
}SCAutoCircleScrollViewSelectionType;


@protocol SCAutoCircleScrollViewDelegate <NSObject>

@optional

- (void)autoCircleScrollViewDidClickedAtPage : (NSInteger)pageNumber;

@end

@interface SCAutoCircleScrollView : UIView<UIScrollViewDelegate>
{
    
    NSTimer *timer;
    
    NSArray *scrollViewSourceArray;
    
    NSTimeInterval scheduledtimeInterval;
}

@property (nonatomic, strong) UIScrollView *autoCircleScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) SCAutoCircleScrollViewSelectionType autoCircleScrollViewSelectionType;

@property (nonatomic, assign) id <SCAutoCircleScrollViewDelegate> autoCircleScrollViewDelegate;

- (id)initThePageControlOnScrollViewWithFrame : (CGRect)pageControlFrame andAutoCircleScrollViewWithFrame : (CGRect)scrollViewFrame withViewsArray : (NSArray*)viewsArray withTimeInterval : (NSTimeInterval)timeInterval;

//- (id)initAutoCircleScrollViewWithFrame : (CGRect)scrollViewFrame withViewsArray : (NSArray*)viewsArray;


@end
