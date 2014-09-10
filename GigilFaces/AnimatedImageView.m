//
//  AnimatedImageView.m
//  GigilFaces
//
//  Created by Nicole on 8/25/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "AnimatedImageView.h"
#import "CancelButtonView.h"

@interface AnimatedImageView() <UIGestureRecognizerDelegate>
@property (nonatomic) BOOL animated;
@property (nonatomic) BOOL imageSelected;

// Gestures
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

// Cancel button
@property (strong, nonatomic) CancelButtonView *cancelButton;
@property (strong, nonatomic) UIBezierPath *cancelButtonBounds;
@end

@implementation AnimatedImageView {
    CGFloat lastRotation;
}

#pragma mark - Initialization

#pragma mark - Animation

- (void)animate {
    self.animated = !self.animated;
    if (self.animated) {
        [self startAnimating];
    }
    else {
        [self stopAnimating];
    }
}

- (void)selectAnimatedImage:(UITapGestureRecognizer *)gesture {

    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.imageSelected = !self.imageSelected;
        
        // If image is not selected, add a cancel button
        if (self.imageSelected) {
            
            // Change the background color
            //self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:166 / 255.0 blue:80 / 255.0 alpha:0.5];
            
            // Add a pan gesture recognizer
            self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAnimatedImage:)];
            [self addGestureRecognizer:self.pan];
            
            // Add a cancel button to the view
            const int cancelButtonSize = 25;
            CGRect cancelButtonFrame = CGRectMake(self.frame.size.width - (cancelButtonSize),
                                                0,
                                                cancelButtonSize,
                                                cancelButtonSize);
            self.cancelButtonBounds = [UIBezierPath bezierPathWithOvalInRect:cancelButtonFrame];
            self.cancelButton = [[CancelButtonView alloc] initWithFrame:cancelButtonFrame];
                                 
            [self addSubview:self.cancelButton];
            self.cancelButton.backgroundColor = [UIColor clearColor];
            
            // Add a rotate gesture to the rotation bounds
            //self.rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
            //[self addGestureRecognizer:self.rotate];
            //self.rotate.delegate = self;
            
            // Add a pinch gesture
            //self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
            //[self addGestureRecognizer:self.pinch];
            //self.pinch.delegate = self; // KEEP, allows two gestures at once
        }
        
        // If image is already selected, remove green background and pan gesture
        else {
            
            // Remove hightlighted background color
            //self.backgroundColor = [UIColor clearColor];
            
            // Remove the cancel button
            [self.cancelButton removeFromSuperview];
            
            // Remove pan gesture
            [self removeGestureRecognizer:self.pan];
            
            //[self removeGestureRecognizer:self.rotate];
            //[self removeGestureRecognizer:self.pinch];
        }
        
        // Bring selected view to the front of all other views
        [gesture.view.superview bringSubviewToFront:gesture.view];
    }
}

#pragma mark - Pan Gesture

- (void)moveAnimatedImage:(UIPanGestureRecognizer *)gesture {

    CGPoint movement;

    if (gesture.state == UIGestureRecognizerStateBegan
        || gesture.state == UIGestureRecognizerStateChanged
        || gesture.state == UIGestureRecognizerStateEnded) {

        // Get the view that the user clicked on
        UIView *singleView = gesture.view;
        CGRect rec = singleView.frame;

        // Bounds of the animated image superview
        UIView *bounceBounds = gesture.view.superview;
        CGRect animatedImageBounds = bounceBounds.bounds;
        
        // Make sure card does not go out of bounds
        if ((rec.origin.x >= animatedImageBounds.origin.x)
            && (rec.origin.x + rec.size.width <= animatedImageBounds.origin.x + animatedImageBounds.size.width)) {
            
            CGPoint translation = [gesture translationInView:bounceBounds];
            movement = translation;
            
            gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
                                              gesture.view.center.y + translation.y);
            rec = gesture.view.frame;
            
            // Right bounds
            if (singleView.frame.origin.x <= bounceBounds.bounds.origin.x) {
                rec.origin.x = singleView.bounds.origin.x;
            }
            
            // Left bounds
            else if ((singleView.frame.origin.x + singleView.frame.size.width) >
                     (bounceBounds.bounds.origin.x + bounceBounds.bounds.size.width)) {
                rec.origin.x = bounceBounds.bounds.origin.x + bounceBounds.bounds.size.width - singleView.frame.size.width;
            }
            
            // Top bounds
            if (singleView.frame.origin.y < bounceBounds.bounds.origin.y) {
                rec.origin.y = singleView.bounds.origin.y;
            }
            
            // Bottom bounds
            else if ((singleView.frame.origin.y + singleView.frame.size.height) >
                     (bounceBounds.bounds.origin.y + bounceBounds.bounds.size.height)) {
                rec.origin.y = bounceBounds.bounds.origin.y + bounceBounds.bounds.size.height - singleView.frame.size.height;
            }
            
            // Update the frame
            gesture.view.frame = rec;
            
            // Reset translation (IMPORTANT!)
            [gesture setTranslation:CGPointZero inView:bounceBounds];
        }
    }
}

- (BOOL)cancelButtonClicked:(CGPoint)point {
   
    if ([self.cancelButtonBounds containsPoint:point]) {
        return true;
    }
    return false;
}

#pragma mark - Image Names

- (NSArray *)animatedImageNames {
    return nil; // Abstract
}

- (NSString *)firstImageName {
    return nil; // Abstract
}

#pragma mark - Drawing

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
}
*/

#pragma mark - Setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    // Load images
    NSArray *imageNames = [[NSArray alloc] initWithArray:[self animatedImageNames]];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i += 1) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    self.animationImages = images;
    self.animationDuration = 2.0;
    
    self.image = [UIImage imageNamed:[self firstImageName]];
}

@end