/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2011 Stuart Caunt
 * 
 * This class is inspired from equivalent functionality provided by cocos2d :
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 *
 */
 
#import "Isgl3dActionInstant.h"

#pragma mark Isgl3dActionCallFunc

/**
 * The Isgl3dActionCallFunc modifies the transparency of an object to a specified alpha.
 */
@interface Isgl3dActionCallFunc : Isgl3dActionInstant <NSCopying> {
	id _funcTarget;
	SEL _funcSelector;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionCallFunc with a function target and selector.
 * @param target The target to call the selector on
 * @param selector The selector to call
 */
+ (id) actionWithTarget:(id)target selector:(SEL)selector;

/**
 * Initialises the Isgl3dActionCallFunc with a function target and selector.
 * @param target The target to call the selector on
 * @param selector The selector to call
 */
- (id) initWithTarget:(id)target selector:(SEL)selector;

@end
