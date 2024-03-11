

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector;

@end
