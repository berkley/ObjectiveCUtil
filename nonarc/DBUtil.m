//
//  DBUtil.m
//
//  Created by Chad Berkley on 10/14/11.
//
//  Anyone is free to use or distribute this code.  There is no warranty
//  or license.  You assume all risk in using this code.  It is made freely
//  available to whoever finds it useful

#import "DBUtil.h"

@implementation DBUtil

static DBUtil *dbutil;

+ (DBUtil*)instance
{
    if(dbutil == nil)
        dbutil = [[DBUtil alloc] init];
    return dbutil;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [DBUtil createEditableCopyOfDatabaseIfNeeded];
    }
    return self;
}

/**
 * create the database if it needs to be created on startup
 */
+ (void)createEditableCopyOfDatabaseIfNeeded 
{
    //set up the db
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:SQLITE_FILE];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if(success) 
    {
        return;        
    }
    
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLITE_FILE];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if(!success)
	{
        //NSLog(@"DB file is %s", SQL_FILE);
		NSAssert1(0, @"ERROR: Failed to create writable database file with message '%s'.", [error localizedDescription]);
	}
}

/**
 * get an instance of the database to use for queries
 */
+ (sqlite3*) initializeDatabase
{
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:SQLITE_FILE];
	NSLog(@"DB Path: %@", path);
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        return database;
    }
    else 
    {
        NSLog(@"ERROR: Failed to get database object.");
        return nil;
    }
}

- (sqlite3*)database
{
    if(database == nil)
    {
        database = [DBUtil initializeDatabase];
    }
    return database;
}

@end
