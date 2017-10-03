//
//  SwinjectStoryboard.h
//  SwinjectStoryboard
//
//  Created by Yoichi Tagaya on 5/5/16.
//  Copyright © 2016 Swinject Contributors. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for SwinjectStoryboard.
FOUNDATION_EXPORT double SwinjectStoryboardVersionNumber;

//! Project version string for SwinjectStoryboard.
FOUNDATION_EXPORT const unsigned char SwinjectStoryboardVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SwinjectStoryboard/PublicHeader.h>


// TARGET_OS_MAC includes iOS, watchOS and tvOS, so TARGET_OS_MAC must be evaluated after them.
#if TARGET_OS_IOS || TARGET_OS_TV || (!TARGET_OS_WATCH && TARGET_OS_MAC)

#import <SwinjectStoryboard/_SwinjectStoryboardBase.h>
#import <SwinjectStoryboard/SwinjectStoryboardProtocol.h>

#endif
