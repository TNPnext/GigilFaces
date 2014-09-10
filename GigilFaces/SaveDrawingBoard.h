//
//  SaveDrawingBoard.h
//  GigilFaces
//
//  Created by Nicole on 8/27/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDrawingBoard : NSObject

@property (nonatomic, strong) UIImage *finalImage;
@property (nonatomic, strong) UIImage *finalSmallImage;
@property (strong, nonatomic) NSString *finalImageTitle;
@property (strong, nonatomic) NSMutableArray *animatedImages;   // Of UIImageView
@property (strong, nonatomic) NSMutableArray *animatedImagesFrames; // Of CGRect
@property (strong, nonatomic) NSMutableArray *staticImages;     // ??Of UIImageView MIGHT CHANGE

@end
