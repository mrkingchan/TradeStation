
// .h文件
#define NNHSingletonH + (instancetype)sharedInstance;

// .m文件
#define NNHSingletonM \
static id _instace; \
 \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instace = [super allocWithZone:zone]; \
    }); \
    return _instace; \
} \
 \
+ (instancetype)sharedInstance \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instace = [[self alloc] init]; \
    }); \
    return _instace; \
} \
 \
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _instace; \
}
