
#import "NSMutableArray+NilSafe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSMutableArray (NilSafe)

+ (void)load 
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndex:) andSwizzledSelector:@selector(safe_objectAtIndex:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndexedSubscript:) andSwizzledSelector:@selector(safe_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(addObject:) andSwizzledSelector:@selector(safe_addObject:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(insertObject:atIndex:) andSwizzledSelector:@selector(safe_insertObject:atIndex:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(removeObject:) andSwizzledSelector:@selector(safe_removeObject:)];
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(removeObjectAtIndex:) andSwizzledSelector:@selector(safe_removeObjectAtIndex:)];
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

- (void)safe_addObject:(id)value
{
    if (value) {
        [self safe_addObject:value];
    }
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject == nil) {
        return;
    }
    if (index > self.count) {
        return;
    }
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_removeObject:(id)obj 
{
    if (obj == nil) {
        return;
    }
    [self safe_removeObject:obj];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index 
{
    if (self.count <= 0) {
        return;
    }
    if (index >= self.count) {
        return;
    }
    [self safe_removeObjectAtIndex:index];
}

@end
