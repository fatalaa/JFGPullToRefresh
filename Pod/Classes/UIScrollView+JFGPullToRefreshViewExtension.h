//
//  UIScrollView+JFGPullToRefreshViewExtension.h
//  Pods
//
//  Created by Tibor Molnár on 20/07/15.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (JFGPullToRefreshViewExtension)

- (void)addPullToRefreshWithOptions:(JFGPullToRefreshOptions *)pullToRefreshOptions withDelegate:(id<JFGPullToRefreshViewDelegate>)delegate;

@end
