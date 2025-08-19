//
//  Copyright (c) 2015-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

@import Foundation;

#ifdef DEBUG
#define OHLog(frmt, ...) NSLog(@"%s -[INFO] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
#define OHLog(frmt, ...) ;
#endif

#ifdef DEBUG
#define OHLogError(frmt, ...) NSLog(@"%s -[ERROR] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
#define OHLogError(frmt, ...) ;
#endif

#ifdef DEBUG
#define OHLogWarn(frmt, ...) NSLog(@"%s -[WARNING] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
#define OHLogWarn(frmt, ...) ;
#endif
