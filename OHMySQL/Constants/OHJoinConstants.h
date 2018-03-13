//  Created by Oleg Hnidets on 6/8/16.
//  Copyright © 2016-2018 Oleg Hnidets. All rights reserved.
//

@import Foundation;

/// INNER JOIN type for combining records from two tables.
extern NSString *_Nonnull const OHJoinInner;

/// RIGHT JOIN type for performing a join starting with the second (right-most) table and then any matching first (left-most) table records.
extern NSString *_Nonnull const OHJoinRight;

/// LEFT JOIN type for performing a join starting with the first (left-most) table and then any matching second (right-most) table records.
extern NSString *_Nonnull const OHJoinLeft;

/// FULL JOIN type for all matching records from both tables whether the other table matches or not.
extern NSString *_Nonnull const OHJoinFull;
