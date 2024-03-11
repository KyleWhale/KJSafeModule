
#import "NSArray+NilSafe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSArray (NilSafe)

+ (void) load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayI") swizzleSelector:@selector(objectAtIndex:) andSwizzledSelector:@selector(safe_objectAtIndex:)];
        [objc_getClass("__NSArrayI") swizzleSelector:@selector(objectAtIndexedSubscript:) andSwizzledSelector:@selector(safe_objectAtIndexedSubscript:)];
    });
}

- (id)safe_objectAtIndex:(NSInteger)index
{
    if (index < self.count) {
        return [self safe_objectAtIndex:index];
    } else {
        return nil;
    }
}
- (id)safe_objectAtIndexedSubscript:(NSInteger)index
{
    if (index < self.count) {
        return [self safe_objectAtIndexedSubscript:index];
    } else {
        return nil;
    }
}

@end
