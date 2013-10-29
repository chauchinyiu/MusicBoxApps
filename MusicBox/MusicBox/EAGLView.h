//
//  EAGLView.h
//  MusicBox2
//
//  Created by Ming Kei Wong on 13年4月19日.
//  Copyright (c) 2013年 Ming Kei Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "Config.h"

#import <Everyplay/Everyplay.h>


@interface EAGLView : UIView{
@private
    EAGLContext *context;
    
    // The pixel dimensions of the CAEAGLLayer.
    GLint framebufferWidth;
    GLint framebufferHeight;
    
    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view.
    GLuint defaultFramebuffer, colorRenderbuffer, depthRenderbuffer;
        
    //touch states
    GLint touchDownObj;
    GLfloat deltaAngle;
    
    EveryplayCapture *everyplayCapture;

    
}

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign, readonly) GLfloat aspect;

- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;


@end
