//
//  EAGLView.m
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月19日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import "EAGLView.h"

#import <QuartzCore/QuartzCore.h>
#import "MusicBoxViewController.h"
#import "MusicBoxConstants.h"

@interface EAGLView (PrivateMethods)
- (void)createFramebuffer;
- (void)deleteFramebuffer;
@end

@implementation EAGLView

@dynamic context;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:.
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.contentsScale = [[UIScreen mainScreen] scale];
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = @{
    kEAGLDrawablePropertyRetainedBacking: [NSNumber numberWithBool:FALSE],
        // kEAGLColorFormatRGBA8
        // kEAGLColorFormatRGB565
    kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
        };
    }
    
    
    touchDownObj = TOUCH_OBJ_NONE;
    return self;
}

- (void)dealloc
{
    [self deleteFramebuffer];
}

- (EAGLContext *)context
{
    return context;
}

- (void)setContext:(EAGLContext *)newContext
{
    if (context != newContext) {
        [self deleteFramebuffer];
        
        context = newContext;
        
        [EAGLContext setCurrentContext:nil];
        
    }
}

- (GLfloat)aspect
{
    if (!framebufferHeight) return 0.0;
    
    return ((GLfloat) framebufferWidth) / ((GLfloat) framebufferHeight);
}

- (void)createFramebuffer
{
    if (everyplayCapture == nil) {
        everyplayCapture = [[EveryplayCapture alloc] initWithView:self eaglContext:context layer:(CAEAGLLayer *)self.layer];
    }

    
    if (context && !defaultFramebuffer) {
        // Create default framebuffer object.
        glGenFramebuffers(1, &defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
        // Create color render buffer and allocate backing store.
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        // Attach color render buffer
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        
        // Create depth render buffer and allocate backing store.
        glGenRenderbuffers(1, &depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
        
        // Attach depth render buffer
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
        
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        glViewport(0, 0, framebufferWidth, framebufferHeight);
        
        [everyplayCapture createFramebuffer:defaultFramebuffer];

    }
}

- (void)deleteFramebuffer
{
    if (context) {
        [EAGLContext setCurrentContext:context];
        [everyplayCapture deleteFramebuffer];
        
        if (defaultFramebuffer) {
            glDeleteFramebuffers(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }
        
        if (colorRenderbuffer) {
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
        
        if (depthRenderbuffer) {
            glDeleteRenderbuffers(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        }
        
        [EAGLContext setCurrentContext:nil];

    }
}

- (void)setFramebuffer
{
    if (context) {
        [EAGLContext setCurrentContext:context];
        
        if (!defaultFramebuffer)
            [self createFramebuffer];
    }
}

- (BOOL)presentFramebuffer
{
    BOOL success = FALSE;
    
    if (context) {
        [EAGLContext setCurrentContext:context];
        
#define ARRAY_LENGTH(X) (sizeof(X) / sizeof((X)[0]))

        if (![everyplayCapture beforePresentRenderbuffer:defaultFramebuffer]) {
        
            static const GLenum s_attachments[] = { GL_DEPTH_ATTACHMENT };
            glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, ARRAY_LENGTH(s_attachments), s_attachments);

        
            glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        }
        success = [context presentRenderbuffer:GL_RENDERBUFFER];
        [everyplayCapture afterPresentRenderbuffer:defaultFramebuffer];
    }
    
    return success;
}

- (void)layoutSubviews
{
    // The framebuffer will be re-created at the beginning of the next setFramebuffer method call.
    [self deleteFramebuffer];
}

- (GLfloat) calculateDistanceFromCenter:(CGPoint)point {
	GLfloat dx = point.x - 402;
	GLfloat dy = point.y - 85;
	return sqrt(dx*dx + dy*dy);
}


- (GLfloat) calculateAngleFromCenter:(CGPoint)point {
	GLfloat dx = point.x - 402;
	GLfloat dy = point.y - 85;
    GLfloat finAngle = atan2(dy,dx);
    if (finAngle < 0.0f) {
        finAngle += M_PI * 2;
    }
	return finAngle;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint loc = [((UITouch*)[[touches allObjects] objectAtIndex:0]) locationInView:self];
    CGPoint loc2 = [((UITouch*)[[touches allObjects] objectAtIndex:0]) locationInView:self];
    if (IS_IPHONE_5) {
        loc.x -= 26.0f;
    }
    if ([MusicBoxAppDelegate isIOS7]){
        loc.y -= 18.0f;
    }
    if ([MusicBoxViewController sharedInstance].getIsInAniSelect) {
        touchDownObj = loc.x * 3.0f / (IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH);
    }
    else if([MusicBoxViewController sharedInstance].getIsInShowingBubble){
        touchDownObj = TOUCH_OBJ_NONE;
    }
    else{
        if (loc2.x >= 62.0f && loc2.x < 116.0f) {
            if ([[MusicBoxViewController sharedInstance] getPlayButtonState] == PLAY_BUTTON_STATE_SHOW_TAB
                && loc.y >= 13.0f && loc.y <= 50.0f) {
                touchDownObj = TOUCH_OBJ_PLAY_TAB_DOWN;
                [[MusicBoxViewController sharedInstance] toggleKeyboard:FALSE];
                return;
            }
            if ([[MusicBoxViewController sharedInstance] getPlayButtonState] == PLAY_BUTTON_STATE_SHOW_FULL
                && loc.y >= 13.0f && loc.y <= 50.0f) {
                touchDownObj = TOUCH_OBJ_PLAY_RECORD;
                [[MusicBoxViewController sharedInstance] toggleKeyboard:FALSE];
                return;
            }
            if ([[MusicBoxViewController sharedInstance] getPlayButtonState] == PLAY_BUTTON_STATE_SHOW_FULL
                && loc.y > 56.0f && loc.y <= 99.0f) {
                touchDownObj = TOUCH_OBJ_PLAY_TAB_UP;
                [[MusicBoxViewController sharedInstance] toggleKeyboard:FALSE];
                return;
            }
        }
        
        if (loc.y >= 148.0f && loc.x < 470.0f && loc.x > 337.0f) {
            touchDownObj = TOUCH_OBJ_PHOTO;
            [[MusicBoxViewController sharedInstance] toggleKeyboard:FALSE];
        }
        else if (loc.y >= 221.0f) {
            touchDownObj = TOUCH_OBJ_MSG_BAR;
            
        }
        else{
            [[MusicBoxViewController sharedInstance] toggleKeyboard:FALSE];
            if (loc.x >= 380 && loc.y >= 70.0f && loc.x <= 424 && loc.y <= 100.0f) {
                touchDownObj = TOUCH_OBJ_PLAY_BTN;
                [[MusicBoxViewController sharedInstance] playPressing];
            }
            else if(![[MusicBoxViewController sharedInstance] getIsPlaying]){
                float dist = [self calculateDistanceFromCenter:loc];
                if (dist >= 20 && dist <= 100){
                    touchDownObj = TOUCH_OBJ_HANDLE;
                    deltaAngle = [self calculateAngleFromCenter:loc];
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (touchDownObj == TOUCH_OBJ_HANDLE) {
        CGPoint loc = [((UITouch*)[[touches allObjects] objectAtIndex:0]) locationInView:self];
        if (IS_IPHONE_5) {
            loc.x -= 26.0f;
        }
        if ([MusicBoxAppDelegate isIOS7]){
            loc.y -= 18.0f;
        }

        float dist = [self calculateDistanceFromCenter:loc];
        if (dist > 0){
            GLfloat newAngle = [self calculateAngleFromCenter:loc];
            GLfloat angleDif = newAngle - deltaAngle;
            if (fabsf(angleDif) > M_PI) {
                if (angleDif < 0.0f) {
                    angleDif += M_PI * 2;
                }
                else{
                    angleDif -= M_PI * 2;
                }
            }
            deltaAngle = newAngle;
            [[MusicBoxViewController sharedInstance] leverRotated:angleDif];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([MusicBoxViewController sharedInstance].getIsInAniSelect) {
        [[MusicBoxViewController sharedInstance] switchStyle:touchDownObj];
        touchDownObj = TOUCH_OBJ_NONE;
    }
    else if([MusicBoxViewController sharedInstance].getIsInShowingBubble){
        [[MusicBoxViewController sharedInstance] screenClicked];
        touchDownObj = TOUCH_OBJ_NONE;
    }
    else{
        if (touchDownObj == TOUCH_OBJ_PLAY_BTN) {
            [[MusicBoxViewController sharedInstance] playSwitch];
        }
        else if (touchDownObj == TOUCH_OBJ_PLAY_TAB_DOWN) {
            [[MusicBoxViewController sharedInstance] clickPlayTabDown];
        }
        else if (touchDownObj == TOUCH_OBJ_PLAY_TAB_UP) {
            [[MusicBoxViewController sharedInstance] clickPlayTabUp];
        }
        else if (touchDownObj == TOUCH_OBJ_PLAY_RECORD) {
            [[MusicBoxViewController sharedInstance] clickPlayRecord];
        }
        else if(![[[Everyplay sharedInstance] capture] isRecording]){
            if(touchDownObj == TOUCH_OBJ_MSG_BAR){
                [[MusicBoxViewController sharedInstance] toggleKeyboard:TRUE];
            }
            else if(touchDownObj == TOUCH_OBJ_PHOTO){
                [[MusicBoxViewController sharedInstance] selectPhoto];
            }
        }
        
        touchDownObj = TOUCH_OBJ_NONE;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
}



@end
