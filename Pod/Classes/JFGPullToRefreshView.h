//
//  JFGRefreshContents.h
//  Pods
//
//  Created by Tibor Molnár on 17/07/15.
//
//

#import <UIKit/UIKit.h>

@class JFGPullToRefreshOptions;

typedef enum : NSUInteger {
    JFGPullToRefreshViewStateNormal,
    JFGPullToRefreshViewStatePulling,
    JFGPullToRefreshViewStateRefreshing
} JFGPullToRefreshViewState;

@protocol JFGPullToRefreshViewDelegate <NSObject>

- (void)pullToRefreshViewDidStartRefreshing;
- (void)pullToRefreshViewDidFinishRefreshing;

@end

@interface JFGPullToRefreshView : UIView

@property (nonatomic, readonly) NSString *contentOffsetKeyPath;
@property (nonatomic, strong) NSString *kvoContext;
@property (nonatomic, strong) id <JFGPullToRefreshViewDelegate> delegate;
@property (nonatomic, assign) JFGPullToRefreshViewState state;
@property (nonatomic, strong) JFGPullToRefreshOptions *options;

- (id)initWithFrame:(CGRect)frame withOptions:(JFGPullToRefreshOptions *)options withDelegate:(id<JFGPullToRefreshViewDelegate>)delegate;

@end
