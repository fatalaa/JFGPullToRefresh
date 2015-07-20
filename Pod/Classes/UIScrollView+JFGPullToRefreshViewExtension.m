//
//  UIScrollView+JFGPullToRefreshViewExtension.m
//  Pods
//
//  Created by Tibor Molnár on 20/07/15.
//
//

#import "JFGPullToRefreshView.h"
#import "JFGPullToRefreshOptions.h"
#import "UIScrollView+JFGPullToRefreshViewExtension.h"

@interface UIScrollView ()

@property (nonatomic, strong) JFGPullToRefreshView *pullToRefreshView;

@end

@implementation UIScrollView (JFGPullToRefreshViewExtension)

- (JFGPullToRefreshView *)pullToRefreshView
{
    UIView *pullToRefreshView = [self viewWithTag:[JFGPullToRefreshOptions tag]];
    return (JFGPullToRefreshView *)pullToRefreshView;
}

- (void)addPullToRefreshWithOptions:(JFGPullToRefreshOptions *)pullToRefreshOptions withDelegate:(id<JFGPullToRefreshViewDelegate>)delegate
{
    CGRect refreshViewFrame = CGRectMake(0, -pullToRefreshOptions.height, self.frame.size.width, pullToRefreshOptions.height);
    JFGPullToRefreshView *pullToRefreshView = [[JFGPullToRefreshView alloc] initWithFrame:refreshViewFrame withOptions:pullToRefreshOptions withDelegate:delegate];
    pullToRefreshView.tag = [JFGPullToRefreshOptions tag];
    self.pullToRefreshView = pullToRefreshView;
    [self addSubview:pullToRefreshView];
}

- (void)startPullToRefresh
{
    self.pullToRefreshView.state = JFGPullToRefreshViewStateRefreshing;
}

- (void)stopPullToRefresh
{
    self.pullToRefreshView.state = JFGPullToRefreshViewStateNormal;
}

- (void)fixedPullToRefreshViewDidScroll
{
    if (self.pullToRefreshView.options.fixedTop) {
        if (self.contentOffset.y < -self.pullToRefreshView.options.height) {
            CGRect frame = self.pullToRefreshView.frame;
            if (!CGRectIsNull(frame)) {
                frame.origin = CGPointMake(self.pullToRefreshView.frame.origin.x, self.contentOffset.y);
                self.pullToRefreshView.frame = frame;
            }
            else {
                if (!CGRectIsNull(self.pullToRefreshView.frame)) {
                    frame = self.pullToRefreshView.frame;
                    frame.origin = CGPointMake(frame.origin.x, -self.pullToRefreshView.options.height);
                }
            }
        }
    }
}

@end
