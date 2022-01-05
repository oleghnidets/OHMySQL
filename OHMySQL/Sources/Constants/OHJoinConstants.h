//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
