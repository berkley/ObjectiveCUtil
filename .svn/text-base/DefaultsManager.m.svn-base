//
//  DefaultsManager.m
//
//  Created by Chad Berkley on 4/27/11.
//

#import "DefaultsManager.h"


@implementation DefaultsManager

static DefaultsManager *instance = nil;

//singleton accessor
+ (DefaultsManager*)instance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        //deserialize any defaults here
        defaults = [[NSUserDefaults standardUserDefaults] objectForKey:ROOT_OBJECT];
        if(defaults == nil)
        {
            defaults = [[NSMutableDictionary alloc] init];       
        }
    }
    return self;
}

- (void)setObject:(NSObject*)obj withName:(NSString*)name
{
    if(obj == nil || name == nil)
        return;
    [defaults setObject:obj forKey:name];
    [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:ROOT_OBJECT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSObject*)getObjectWithName:(NSString*)name
{
    return [defaults objectForKey:name];
}

@end
