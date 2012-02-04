//
//  DBUtil.h
//
//  Created by Chad Berkley on 10/14/11.
//  cberkley (at) gmail.com
//
//  Anyone is free to use or distribute this code.  There is no warranty
//  or license.  You assume all risk in using this code.  It is made freely
//  available to whoever finds it useful

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define SQLITE_FILE @"db.sqlite"

@interface DBUtil : NSObject 
{
    sqlite3* database;
}

@property (nonatomic, readonly) sqlite3 *database;

//initialize and return a database object
+ (sqlite3*) initializeDatabase;

//create an editable copy of the db file if it's not already there.
+ (void)createEditableCopyOfDatabaseIfNeeded;

//get an instance of this class
+ (DBUtil*)instance;

@end
