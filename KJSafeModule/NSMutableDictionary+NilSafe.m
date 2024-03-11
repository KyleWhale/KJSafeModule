
#import "NSMutableDictionary+NilSafe.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (NilSafe)

- (void)swizzleMethod:(SEL)origSelector andMethod:(SEL)newSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    BOOL didAddMethod = class_addMethod(class, origSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load 
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(setObject:forKey:) andMethod:@selector(safe_setObject:forKey:)];
    });
}

- (void)safe_setObject:(id)value forKey:(NSString *)key {
    if (value) {
        [self safe_setObject:value forKey:key];
    }
}

@end
