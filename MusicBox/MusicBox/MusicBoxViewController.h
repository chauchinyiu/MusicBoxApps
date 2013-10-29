//
//  ViewController.h
//  MusicBox
//
//  Created by Chau Chin Yiu on 10/26/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import <QuartzCore/CABase.h>
#import <UIKit/UIKit.h>
#import "SoundBankPlayer.h"
#import "PopoverView.h"
#import <AVFoundation/AVFoundation.h>
#import "CollectionViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "InstructionViewController.h"
#import "RNFrostedSidebar.h"
#import "AnimationManager.h"
#import "MusicBoxConstants.h"
#import "EAGLView.h"

#import <Everyplay/Everyplay.h>


typedef struct {
    float Position[2];
    float TexCoord[2];
} Vertex;

typedef struct {
    GLfloat w;
    GLfloat h;
    GLfloat x;
    GLfloat y;
    GLfloat r;
    GLfloat textCoordx1;
    GLfloat textCoordy1;
    GLfloat textCoordx2;
    GLfloat textCoordy2;
    GLuint textID;
    GLfloat alpha;
    BOOL visible;
    BOOL followShift;
} AnimationObject;


 
@interface MusicBoxViewController : UIViewController<PopoverViewDelegate,RNFrostedSidebarDelegate, ThemeProtocol, CollectionProtocol, EveryplayDelegate, UITextViewDelegate>{
    SoundBankPlayer *_soundBankPlayer;
	NSTimer *_timer;
    NSArray *_currentNotesArray;
    NSString *_currentSongTitle;
    NSArray *_currentSongNames;
    NSArray *_currentSongNotes;
    NSArray *_currentNoteSpeeds;
    float _currentNoteSpeed;
    NSString *_currentThemeTitle;
    int _notePosition;
    float _initial_X_Offset;
    NSString *_fileNameExtension;
    
    EAGLView *ev;
    BOOL animating;
    EAGLContext *context;
    GLuint program;
    NSInteger animationFrameInterval;
    CADisplayLink *__unsafe_unretained displayLink;
    
    Vertex aniVertex[TEXTURE_COUNT][MAX_VERTEX];
    GLuint vertexCount[TEXTURE_COUNT];
    GLubyte aniIndex[TEXTURE_COUNT][MAX_INDEX];
    GLuint indexCount[TEXTURE_COUNT];
    AnimationManager *am;
    GLuint textID[TEXTURE_COUNT];
    GLuint textCount;
    GLuint _texCoordSlot;
    GLuint _textureUniform;
    GLuint _positionSlot;
    GLuint vertexBuffer;
    GLuint indexBuffer[TEXTURE_COUNT];
    
    CFTimeInterval lastRenderTime;
    GLfloat timeCounter;
    GLfloat angleRotated;
    BOOL keyboardVisible;
    GLfloat keyboardShiftAmt;
    GLfloat keyboardHeight;
    
    UITextView* msgfield;
       int playButtonState;
    
}
@property (strong, nonatomic) IBOutlet UITextView* msgfield;

//@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *videoButton;
@property (nonatomic, retain) IBOutlet UIButton *videoButton2;

@property (nonatomic, retain) IBOutlet UIButton *recordMenuButton;
@property (nonatomic, retain) IBOutlet UIButton *songsBtn;
@property (nonatomic, retain) IBOutlet UIButton *goToCollectionBtn;

+(MusicBoxViewController *) sharedInstance ;
- (void)startAnimation;
- (void)stopAnimation;
- (void)resetAnimation;
- (void)addAnimationObject:(AnimationObject)aniObj;
- (void)startFrame;
- (void)endFrame;
- (void)renderLayer:(GLuint)t;
- (void)renderTextLoc:(GLuint)width:(GLuint)height:(UIColor*)c:(UIFont*)uf:(UITextAlignment)align:(NSString*)s:(GLuint)tid;
//- (void)renderTextLocWithWidth:(GLuint)width withHeight:(GLuint)height withColor:(UIColor*)c withFont:(UIFont*)uf withAlignment:(UITextAlignment)align withString:(NSString*)s withTid:(GLuint)tid;
- (void)reloadTexture:(GLuint)i :(NSString *)fileName;

 

- (void)playSwitch;
- (BOOL)getIsPlaying;
- (void)playPressing;
- (void)leverRotated:(GLfloat)angle;
- (void)toggleKeyboard:(BOOL)isShowing;
- (void) keyboardDidShowNotification:(NSNotification *)aNotification;
- (void)setButtonStyle:(UIButton*) b;
 - (int)getPlayButtonState;
@end
