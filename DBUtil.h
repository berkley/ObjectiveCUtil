//
//  DBUtil.h
//
//  Created by Chad Berkley on 10/14/11.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define SQLITE_FILE @"services.sqlite"
#define COUNTRIES_TABLE @"countries"

@interface DBUtil : NSObject 
{
    sqlite3* database;
}

@property (nonatomic, readonly) sqlite3 *database;

+ (sqlite3*) initializeDatabase;
+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (DBUtil*)instance;

@end
