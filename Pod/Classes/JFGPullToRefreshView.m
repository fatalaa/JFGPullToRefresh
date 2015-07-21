//
//  JFGRefreshContents.m
//  Pods
//
//  Created by Tibor Molnár on 17/07/15.
//
//

#import "JFGPullToRefreshView.h"
#import "JFGPullToRefreshOptions.h"


@interface JFGPullToRefreshView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) BOOL scrollViewBounces;
@property (nonatomic, assign) UIEdgeInsets scrollViewInsets;
@property (nonatomic, assign) CGFloat previousOffset;

@end

@implementation JFGPullToRefreshView

- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}

- (id)initWithFrame:(CGRect)frame withOptions:(JFGPullToRefreshOptions *)options withDelegate:(id<JFGPullToRefreshViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.options = options;
        self.delegate = delegate;
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backgroundView.backgroundColor = self.options.backgroundColor;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.backgroundView];
        
        self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.arrowView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.arrowView.image = [UIImage imageNamed: self.options.imageName];
        [self addSubview:self.arrowView];
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.bounds = self.arrowView.bounds;
        self.indicatorView.autoresizingMask = self.arrowView.autoresizingMask;
        self.indicatorView.hidesWhenStopped = YES;
        self.indicatorView.color = self.options.indicatorColor;
        [self addSubview:self.indicatorView];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)setState:(JFGPullToRefreshViewState)state
{
    if (_state == state) {
        return;
    }

    _state = state;
    switch (_state) {
        case JFGPullToRefreshViewStateNormal:
            [self stopAnimating];
            break;
        case JFGPullToRefreshViewStateRefreshing:
            [self startAnimating];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.arrowView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.indicatorView.center = self.arrowView.center;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    UIScrollView *scrollView = (UIScrollView *) newSuperview;
    if (self.superview && !newSuperview) {
        [scrollView removeObserver:self forKeyPath:self.contentOffsetKeyPath];
    }
    [scrollView addObserver:self forKeyPath:self.contentOffsetKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void *)self.kvoContext];

}

- (void)dealloc
{
    UIScrollView *scrollView;
    if ((scrollView = (UIScrollView *)self.superview)) {
        [scrollView removeObserver:self forKeyPath:self.contentOffsetKeyPath context:(__bridge void *)self.kvoContext];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == (__bridge void *)self.kvoContext && keyPath == self.contentOffsetKeyPath) {
        UIScrollView *scrollView;
        if ((scrollView = (UIScrollView *) object)) {
            CGFloat offsetWithoutInset = self.previousOffset + self.scrollViewInsets.top;

            // Update the content inset for fixed section headers
            if (self.options.fixedSectionHeader && self.state == JFGPullToRefreshViewStateRefreshing) {
                if (scrollView.contentOffset.y > 0) {
                    scrollView.contentInset = UIEdgeInsetsZero;
                }
                return;
            }

            // Alpha set
            if (self.options.alpha) {
                double alpha = fabs(offsetWithoutInset) / (self.frame.size.height + 30);
                if (alpha > 0.8) {
                    alpha = 0.8;
                }
                self.arrowView.alpha = (CGFloat) alpha;
            }
            
            CGRect oldRect = self.backgroundView.frame;
            // Backgroundview frame set
            if (self.options.fixedTop) {
                if (self.options.height < fabs(offsetWithoutInset)) {
                    CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width, (CGFloat) fabs(offsetWithoutInset));
                    self.backgroundView.frame = newRect;
                } else {
                    CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width, self.options.height);
                    self.backgroundView.frame = newRect;
                }
            } else {
                CGRect newRect = CGRectMake(oldRect.origin.x, (CGFloat) -fabs(offsetWithoutInset), oldRect.size.width, (CGFloat) (self.options.height + fabs(offsetWithoutInset)));
                self.backgroundView.frame = newRect;
            }

            // Pulling State Check
            if (offsetWithoutInset < -self.frame.size.height) {

                // pulling or refreshing
                if (!scrollView.dragging && self.state != JFGPullToRefreshViewStateRefreshing) {
                    self.state = JFGPullToRefreshViewStateRefreshing;
                } else if (self.state != JFGPullToRefreshViewStateRefreshing) {
                    [self arrowRotation];
                    self.state = JFGPullToRefreshViewStatePulling;
                }
            } else if (self.state != JFGPullToRefreshViewStateRefreshing && offsetWithoutInset < 0) {
                [self arrowRotationBack];
            }
            self.previousOffset = scrollView.contentOffset.y;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)startAnimating
{
    [self.delegate pullToRefreshViewDidStartRefreshing];
    [self.indicatorView startAnimating];
    self.arrowView.hidden = YES;
    
    UIScrollView *scrollView;
    if ((scrollView = (UIScrollView *)self.superview)) {
        self.scrollViewBounces = scrollView.bounces;
        self.scrollViewInsets = scrollView.contentInset;
        
        UIEdgeInsets insets = scrollView.contentInset;
        insets.top += self.frame.size.height;
        CGPoint oldContentOffset = scrollView.contentOffset;
        scrollView.contentOffset = CGPointMake(oldContentOffset.x, self.previousOffset);
        scrollView.bounces = NO;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:self.options.animationDuration delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            scrollView.contentInset = insets;
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -insets.top);
        } completion:^(BOOL finished) {
            if (weakSelf.options.autoStopTime != 0) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, @(weakSelf.options.autoStopTime * NSEC_PER_SEC).longLongValue);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    weakSelf.state = JFGPullToRefreshViewStateNormal;
                });
            }
            [weakSelf.delegate pullToRefreshViewDidFinishRefreshing];
            weakSelf.state = JFGPullToRefreshViewStateNormal;
        }];
    }
}

- (void)stopAnimating
{
    [self.indicatorView stopAnimating];

    __weak typeof(self) weakSelf = self;
    __weak UIScrollView *scrollView;
    if ((scrollView = (UIScrollView *)self.superview)) {
        scrollView.bounces = self.scrollViewBounces;
        [UIView animateWithDuration:self.options.animationDuration delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            scrollView.contentInset = weakSelf.scrollViewInsets;
            weakSelf.arrowView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            weakSelf.arrowView.hidden = NO;
        }];
    }
}

- (void)arrowRotation
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.arrowView.transform = CGAffineTransformMakeRotation(@(M_PI - 0.0000001).floatValue);
    } completion:nil];
}

- (void)arrowRotationBack
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.arrowView.transform = CGAffineTransformMakeRotation(@(M_PI - 0.0000001).floatValue);
    } completion:nil];
}

- (NSString *)kvoContext
{
    return @"";
}

- (NSString *)contentOffsetKeyPath
{
    return @"contentOffset";
}

@end
