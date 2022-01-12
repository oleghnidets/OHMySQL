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

/**
 *  Client error codes and messages.
 */
typedef NS_ENUM(NSUInteger, OHResultErrorType) {
    /**
     *  Success.
     */
    OHResultErrorTypeNone = 0,
    /**
     *  Commands were executed in an improper order.
     */
    OHResultErrorTypeSync = 2014,
    /**
     *  The MySQL server has gone away.
     */
    OHResultErrorTypeGone = 2006,
    /**
     *  The connection to the server was lost during the query.
     */
    OHResultErrorTypeLost = 2013,
    /**
     *  An unknown error occurred.
     */
    OHResultErrorTypeUnknown = 2000,
    /**
     *  An unknown error code received. Look at debug console.
     */
    OHResultErrorTypeUnknownCode = 1071994,
} NS_SWIFT_NAME(ResultErrorType);

OHResultErrorType ResultErrorConvertion(NSInteger input) NS_REFINED_FOR_SWIFT;
