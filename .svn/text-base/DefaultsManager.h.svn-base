//
//  DefaultsManager.h
//
//  Created by Chad Berkley on 4/27/11.
//

#import <Foundation/Foundation.h>

#define ROOT_OBJECT @"AVRootObject"


@interface DefaultsManager : NSObject 
{
    NSMutableDictionary *defaults;
}

//get an instance of this class
+ (DefaultsManager*)instance;

//set an object with a name
- (void)setObject:(NSObject*)obj withName:(NSString*)name;

//get an object with a name
- (NSObject*)getObjectWithName:(NSString*)name;

@end
