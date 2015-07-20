//
//  PullToRefreshViewOptions.h
//  Pods
//
//  Created by Tibor Molnár on 17/07/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DictionaryObjectOfClassForKey(dict, aClass, key) \
({                                                       \
    aClass *obj = [dict objectForKey:key];               \
    [obj isKindOfClass:[aClass class]] ? obj : nil;      \
})

#define InsertObjectOfClassForKey(dict, obj, key) \
({\
    do {\
        dict[key] = obj;\
    }while(0)\
)}

#define IS_OBJECT(T) _Generic( (T), id: YES, default: NO)

@interface JFGPullToRefreshOptions : NSObject

@property (nonatomic, readonly) BOOL alpha;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) NSString *imageName;
@property (nonatomic, readonly) double animationDuration;
@property (nonatomic, readonly) BOOL fixedTop;
@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIColor *indicatorColor;
@property (nonatomic, readonly) double autoStopTime;
@property (nonatomic, readonly) BOOL fixedSectionHeader;

- (id)initWithOptions:(NSDictionary *)options;

+ (NSUInteger)tag;
+ (NSDictionary *)defaultOptions;
+ (NSDictionary *)optionsWithDictionary:(NSDictionary *)optionsDictionary;
    
@end

