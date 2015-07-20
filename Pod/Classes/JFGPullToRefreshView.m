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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.arrowView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.indicatorView.center = self.arrowView.center;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [newSuperview removeObserver:self forKeyPath:self.contentOffsetKeyPath context:(__bridge void *)self.kvoContext];
    UIScrollView *scrollView;
    if ((scrollView = (UIScrollView *)newSuperview)) {
        [scrollView addObserver:self forKeyPath:self.contentOffsetKeyPath options:NSKeyValueObservingOptionInitial context:(__bridge void *)self.kvoContext];
    }
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
            
            if (self.options.fixedSectionHeader && self.state == JFGPullToRefreshViewStateRefreshing) {
                if (scrollView.contentOffset.y > 0) {
                    scrollView.contentInset = UIEdgeInsetsZero;
                }
                return;
            }
            
            if (self.options.alpha) {
                double alpha = fabs(offsetWithoutInset) / (self.frame.size.height + 30);
                if (alpha > 0.8) {
                    alpha = 0.8;
                }
                self.arrowView.alpha = alpha;
            }
            
            CGRect oldRect = self.backgroundView.frame;
            if (self.options.fixedTop) {
                if (self.options.height < fabs(offsetWithoutInset)) {
                    CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width, fabs(offsetWithoutInset));
                    self.backgroundView.frame = newRect;
                } else {
                    CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width, self.options.height);
                    self.backgroundView.frame = newRect;
                }
            } else {
                CGRect newRect = CGRectMake(oldRect.origin.x, -fabs(offsetWithoutInset), oldRect.size.width, self.options.height + fabs(offsetWithoutInset));
                self.backgroundView.frame = newRect;
            }
            
            if (offsetWithoutInset < -self.frame.size.height) {
                if (!scrollView.isDragging && self.state != JFGPullToRefreshViewStateRefreshing) {
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
        [UIView animateWithDuration:self.options.animationDuration delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            scrollView.contentInset = insets;
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -insets.top);
        } completion:^(BOOL finished) {
            if (self.options.autoStopTime != 0) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, [NSNumber numberWithDouble:self.options.autoStopTime * NSEC_PER_SEC].longLongValue);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    self.state = JFGPullToRefreshViewStateNormal;
                });
            }
            [self.delegate pullToRefreshViewDidFinishRefreshing];
        }];
    }
}

- (void)stopAnimating
{
    [self.indicatorView stopAnimating];
    self.arrowView.transform = CGAffineTransformIdentity;
    self.arrowView.hidden = YES;
    
    UIScrollView *scrollView;
    if ((scrollView = (UIScrollView *)self.superview)) {
        scrollView.bounces = self.scrollViewBounces;
        [UIView animateWithDuration:self.options.animationDuration delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            scrollView.contentInset = self.scrollViewInsets;
        } completion:nil];
    }
}

- (void)arrowRotation
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.arrowView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)arrowRotationBack
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.arrowView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
