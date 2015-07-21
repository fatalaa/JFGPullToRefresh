//
//  PullToRefreshViewOptions.m
//  Pods
//
//  Created by Tibor Molnár on 17/07/15.
//
//

#import "JFGPullToRefreshOptions.h"

@interface JFGPullToRefreshOptions ()

@property (nonatomic, strong) NSDictionary *options;

@end

@implementation JFGPullToRefreshOptions

- (id)initWithOptions:(NSDictionary *)options
{
    if (!options) {
        options = [JFGPullToRefreshOptions defaultOptions];
    }
    NSMutableDictionary *mutableOptions = [self.options mutableCopy];
    if (mutableOptions == nil) {
        mutableOptions = [NSMutableDictionary dictionary];
    }
    [options enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        mutableOptions[key] = obj;
    }];
    self.options = mutableOptions;
    
    return self;
}
            
- (BOOL)alpha
{
    return DictionaryObjectOfClassForKey(self.options, NSNumber, @"alpha").boolValue;
}
            
- (CGFloat)height
{
    return DictionaryObjectOfClassForKey(self.options, NSNumber, @"height").floatValue;
}
            
- (NSString *)imageName
{
    return DictionaryObjectOfClassForKey(self.options, NSString, @"imageName");
}
            
- (double)animationDuration
{
    return DictionaryObjectOfClassForKey(self.options, NSNumber, @"animationDuration").doubleValue;
}
            
- (BOOL)fixedTop
{
    return DictionaryObjectOfClassForKey(self.options, NSNumber, @"fixedTop").boolValue;
}

- (UIColor *)backgroundColor
{
    return DictionaryObjectOfClassForKey(self.options, UIColor, @"backgroundColor");
}

- (UIColor *)indicatorColor
{
    return DictionaryObjectOfClassForKey(self.options, UIColor, @"indicatorColor");
}

- (double)autoStopTime
{
    return DictionaryObjectOfClassForKey(self.options, NSNumber, @"autoStopTime").doubleValue;
}

- (BOOL)fixedSectionHeader
{
    return DictionaryObjectOfClassForKey(self.options, NSNumber, @"fixedSectionHeader").boolValue;
}

+ (NSUInteger)tag
{
    return 810;
}

+ (NSDictionary *)defaultOptions
{
    return @{
             @"tag" : [NSNumber numberWithInteger:810],
             @"alpha" : [NSNumber numberWithBool:YES],
             @"height" : [NSNumber numberWithFloat:80.0],
             @"imageName" : @"pulltorefresharrow.png",
             @"animationDuration" : [NSNumber numberWithDouble:0.4],
             @"fixedTop" : [NSNumber numberWithBool:NO],
             @"backgroundColor" : [UIColor clearColor],
             @"indicatorColor" : [UIColor grayColor],
             @"autoStopTime" : [NSNumber numberWithDouble:0.0],
             @"fixedSectionHeader" : [NSNumber numberWithBool:NO]
             };
}
            
+ (NSDictionary *)optionsWithDictionary:(NSDictionary *)optionsDictionary
{
    NSDictionary *newOptions = [JFGPullToRefreshOptions defaultOptions];
    [newOptions setValuesForKeysWithDictionary:optionsDictionary];
    return newOptions;
}

@end
