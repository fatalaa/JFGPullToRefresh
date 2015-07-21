//
//  UIScrollView+JFGPullToRefreshViewExtension.h
//  Pods
//
//  Created by Tibor Molnár on 20/07/15.
//
//

#import <UIKit/UIKit.h>

@class JFGPullToRefreshOptions;
@protocol JFGPullToRefreshViewDelegate;

@interface UIScrollView (JFGPullToRefreshViewExtension)

@property (nonatomic, strong) JFGPullToRefreshView *pullToRefreshView;

- (void)addPullToRefreshWithOptions:(JFGPullToRefreshOptions *)pullToRefreshOptions withDelegate:(id<JFGPullToRefreshViewDelegate>)delegate;
- (void)fixedPullToRefreshViewDidScroll;

@end
