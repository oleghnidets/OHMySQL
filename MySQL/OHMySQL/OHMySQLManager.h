//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

#import "OHConstants.h"

@class OHMySQLUser, OHMySQLQuery;

@interface OHMySQLManager : NSObject

@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, strong, readonly, null_unspecified) OHMySQLUser *user;

+ (nonnull OHMySQLManager *)sharedManager;


- (void)connectWithUser:(nonnull OHMySQLUser *)user;

/**
 *  Select all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of target table.
 *  @param condition Condition like in real SQL query (e.g: id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray *)selectAll:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/**
 *  Update all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of target table.
 *  @param set       Key is column' name in table, value is your object.
 *  @param condition Condition like in real SQL query (e.g: name='Name'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHQueryResultErrorType)updateAll:(nonnull NSString *)tableName set:(nonnull NSDictionary *)set condition:(nullable NSString *)condition;

/**
 *  Deletes all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of target table.
 *  @param condition Condition like in real SQL query (e.g: id>'10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHQueryResultErrorType)deleteAllFrom:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/**
 *  Insert a new record.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of target table.
 *  @param set       Key is column' name in table, value is your object.
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHQueryResultErrorType)insertInto:(nonnull NSString *)tableName set:(nonnull NSDictionary *)set;

//! Executes SELECT query if only sqlQuery.queryString is SELECT-based.
- (nullable NSArray *)executeSELECTQuery:(nonnull OHMySQLQuery *)sqlQuery;
//! Executes SELECT query if only sqlQuery.queryString is UPDATE-based.
- (void)executeUPDATEQuery:(nonnull OHMySQLQuery *)sqlQuery;
//! Executes SELECT query if only sqlQuery.queryString is DELETE-based.
- (void)executeDELETEQuery:(nonnull OHMySQLQuery *)sqlQuery;

//! Executes any query.
- (OHQueryResultErrorType)executeQuery:(nonnull OHMySQLQuery *)sqlQuery;

@end
