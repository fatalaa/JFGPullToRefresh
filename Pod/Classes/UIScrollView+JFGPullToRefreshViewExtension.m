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

#import <objc/runtime.h>

static const NSString *JFGPullToRefreshViewKey = @"JFGPullToRefreshViewKey";

@implementation UIScrollView (JFGPullToRefreshViewExtension)

- (JFGPullToRefreshView *)pullToRefreshView
{
    UIView *pullToRefreshView = objc_getAssociatedObject(self, &JFGPullToRefreshViewKey);
    if (!pullToRefreshView) {
        pullToRefreshView = [self viewWithTag:[JFGPullToRefreshOptions tag]];
        objc_setAssociatedObject(self, &JFGPullToRefreshViewKey, pullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return (JFGPullToRefreshView *)pullToRefreshView;
}

- (void)setPullToRefreshView:(JFGPullToRefreshView *)pullToRefreshView
{
    objc_setAssociatedObject(self, &JFGPullToRefreshViewKey, pullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)addPullToRefreshWithOptions:(JFGPullToRefreshOptions *)pullToRefreshOptions withDelegate:(id<JFGPullToRefreshViewDelegate>)delegate
{
    CGRect refreshViewFrame = CGRectMake(0, -pullToRefreshOptions.height, self.frame.size.width, pullToRefreshOptions.height);
    self.pullToRefreshView = [[JFGPullToRefreshView alloc] initWithFrame:refreshViewFrame withOptions:pullToRefreshOptions withDelegate:delegate];
    [self addSubview: self.pullToRefreshView];
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
