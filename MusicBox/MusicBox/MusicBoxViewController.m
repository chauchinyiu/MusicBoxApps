//
//  ViewController.m
//  MusicBox
//
//  Created by Chau Chin Yiu on 10/26/12.
//  Copyright (c) 2012 Chau Chin Yiu. All rights reserved.
//

#import "MusicBoxViewController.h"
#import "EAGLView.h"
#import <Accelerate/Accelerate.h>

// Uniform index.
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};



@interface MusicBoxViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, unsafe_unretained) CADisplayLink *__unsafe_unretained displayLink;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
- (BOOL)loadShaders;
- (void)setupTexture:(NSString *)fileName;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
- (void)loadTextures;
- (void)createBlankTexture:(GLuint)width:(GLuint)height;



-(void) updateTimer;
-(void) startAutoPlayer;
-(void) stopAutoPlayer;
-(void) changeSong:(NSInteger) index;
-(void) showSongList;
-(void) gotoCollectionView;
-(void) setNavigationItems;
@end

@implementation MusicBoxViewController
@synthesize context;
@synthesize displayLink;
@synthesize msgfield;

@synthesize recordMenuButton;
@synthesize videoButton;
@synthesize videoButton2;
 
@synthesize songsBtn;
@synthesize goToCollectionBtn;

 UIView *toolbar;
 UIView *righttoolbar;
int timeposition=0;
BOOL isPlaying ;
static MusicBoxViewController *sharedObject;

+ (MusicBoxViewController*)sharedInstance
{
    return sharedObject;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if ((interfaceOrientation == UIInterfaceOrientationLandscapeRight)||(interfaceOrientation==UIInterfaceOrientationLandscapeLeft)) {
        
        return YES;
    } else {
        return NO;
    }
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate{
    return NO;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sharedObject = self;
    
    _fileNameExtension =[MusicBoxAppDelegate fileExtension];
    _initial_X_Offset = [MusicBoxAppDelegate initialOffset];
    isPlaying = NO;
    keyboardVisible = false;
    keyboardShiftAmt = 0;

    [self setNavigationItems];
    ev = (EAGLView*)(self.view);
    
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!aContext) {
        aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    }
    
    if (!aContext) {
        NSLog(@"Failed to create ES context");
    } else if (![EAGLContext setCurrentContext:aContext]) {
        NSLog(@"Failed to set ES context current");
    }
    self.context = aContext;
    [ev setContext:aContext];
    [ev setFramebuffer];
    
    if ([context API] == kEAGLRenderingAPIOpenGLES2) {
        [self loadShaders];
        [self loadTextures];
        glGenBuffers(1, &vertexBuffer);
        for (int i = 0; i < TEXTURE_COUNT; i++) {
            glGenBuffers(1, &indexBuffer[i]);
        }
    }
    
    am = [[AnimationManager alloc]init];
    [self changeThemeTo:VALENTINE];
    [am changeThemeTo:VALENTINE ThemeName:_currentThemeTitle];
    [self resetAnimation];
    animating = FALSE;
    animationFrameInterval = 1;
    self.displayLink = nil;
    
    _soundBankPlayer = [[SoundBankPlayer alloc] init];
    [_soundBankPlayer setSoundBank:@"Musicbox"];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidShowNotification:)
     name:UIKeyboardDidShowNotification object:nil];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:0];
}


-(void) viewWillAppear:(BOOL)animated{
    // show instructions here!
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"welcome_instruction"]==nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"welcome_instruction"   forKey:@"welcome_instruction"];
        InstructionViewController *instruction = [[InstructionViewController alloc] initWithNibName:@"InstructionViewController" bundle:nil];
        //[self presentModalViewController:instruction animated:YES];
        [self presentViewController:instruction animated:YES completion:nil];
    }
    
    [self startAnimation];
    
    [super viewWillAppear:animated];

}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
     Frame interval defines how many display frames must pass between each time the display link fires.
     The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
     */
    if (frameInterval >= 1) {
        animationFrameInterval = frameInterval;
        
        if (animating) {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating) {
        CADisplayLink *aDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = aDisplayLink;
        
        animating = TRUE;
        lastRenderTime = CACurrentMediaTime();
    }
}

- (void)stopAnimation
{
    if (animating) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        animating = FALSE;
    }
}


-(void) viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
    
    glDeleteTextures(textCount, textID);
    
    // Tear down context.
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }

}

#pragma mark - RNFrostedSidebarDelegate

- (IBAction)showRecordMenu:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"record_menu"],
                        [UIImage imageNamed:@"play_menu"],
                        ];
    NSArray *colors = @[
                        [UIColor redColor],
                        [UIColor greenColor],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    //    callout.showFromRight = YES;
    [callout show];
}
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    if (index == 0) {
        [self recordButtonPressed:nil];
    }else{
        [self  videoButtonPressed:nil];
    }
    [sidebar dismiss];
    
}


- (void) setNavigationItems{
    CGRect toolbarFrame;
    CGRect righttoolbarFrame;
    CGRect songbtnFrame;
    CGRect collectionbtnFrame;
    CGRect recordmenuFrame;
    if([MusicBoxAppDelegate isIOS7]){
        toolbarFrame = CGRectMake(0, 0, 120 , 33);
        righttoolbarFrame =CGRectMake(0, 0, 200, 33);
        songbtnFrame = CGRectMake(35, 5, 60, 24 );
        collectionbtnFrame =CGRectMake(105, 5, 90,26);
        recordmenuFrame = CGRectMake(0, 10, 30, 17);
    }else{
        toolbarFrame =  CGRectMake(0, 0, 120 , 44);
        righttoolbarFrame =CGRectMake(0, 0, 200, 44);
        songbtnFrame = CGRectMake(35, 8.5, 60, 35);
        collectionbtnFrame = CGRectMake(105, 8.5, 90,35);
        recordmenuFrame = CGRectMake(0, 8.5, 30, 33);
    }
    
    toolbar =  [[UIView alloc] initWithFrame:toolbarFrame];
    recordMenuButton = [[UIButton alloc] initWithFrame:recordmenuFrame];
    [recordMenuButton setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
    
    [recordMenuButton addTarget:self action:@selector(showRecordMenu:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:recordMenuButton];
    
    songsBtn = [[UIButton alloc] initWithFrame:songbtnFrame];
    [self setButtonStyle:songsBtn];
    [songsBtn setTitle:@"Songs" forState:UIControlStateNormal];
    [songsBtn setBackgroundImage:[UIImage imageNamed:@"song_button"] forState:UIControlStateNormal];
    [songsBtn addTarget:self action:@selector(showSongList) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:songsBtn];
    
    righttoolbar =  [[UIView alloc] initWithFrame:righttoolbarFrame];
    
    goToCollectionBtn = [[UIButton alloc] initWithFrame:collectionbtnFrame];
    [self setButtonStyle:goToCollectionBtn];
    [goToCollectionBtn setTitle:@"Collection" forState:UIControlStateNormal];
    
    [goToCollectionBtn setBackgroundImage:[UIImage imageNamed:@"collection_btn"] forState:UIControlStateNormal];
    
    [goToCollectionBtn addTarget:self action:@selector(gotoCollectionView) forControlEvents:UIControlEventTouchUpInside];
    
    [righttoolbar addSubview:goToCollectionBtn];
    
    
    UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
    UIBarButtonItem *leftBtn  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    self.navigationItem.rightBarButtonItem =  rightBtn;
    self.navigationItem.leftBarButtonItem =  leftBtn;

}


//- (void) setNavigationItems{
//    if([MusicBoxAppDelegate isIOS7]){
//        toolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120 , 33)];
//        
//        songsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 60, 24)];
//        [self setButtonStyle:songsBtn];
//       // [songsBtn setTitle:NSLocalizedString(@"SONGS_BTN", @"Songs") forState:UIControlStateNormal];
//        [songsBtn setTitle:@"Songs"  forState:UIControlStateNormal];
//        [songsBtn setBackgroundImage:[UIImage imageNamed:@"song_button"] forState:UIControlStateNormal];
//        [songsBtn addTarget:self action:@selector(showSongList) forControlEvents:UIControlEventTouchUpInside];
//        [toolbar addSubview:songsBtn];
//        
//        righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 33)];
//        
//        goToCollectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(105, 5, 90,26)];
//        [self setButtonStyle:goToCollectionBtn];
////        [goToCollectionBtn setTitle:NSLocalizedString(@"COLLECTION_BTN", @"Collection") forState:UIControlStateNormal];
//        [goToCollectionBtn setTitle:@"Collection"  forState:UIControlStateNormal];
//        
//        [goToCollectionBtn setBackgroundImage:[UIImage imageNamed:@"collection_btn"] forState:UIControlStateNormal];
//        
//        
//        [goToCollectionBtn addTarget:self action:@selector(gotoCollectionView) forControlEvents:UIControlEventTouchUpInside];
//        
//        [righttoolbar addSubview:goToCollectionBtn];
//        
//        recordButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 5, 55, 26)];
//        [recordButton setImage:[UIImage imageNamed:@"rec"] forState:UIControlStateNormal];
//        
//        [recordButton addTarget:self action:@selector(recordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [toolbar addSubview:recordButton];
//        
//        UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
//        UIBarButtonItem *leftBtn  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
//        self.navigationItem.rightBarButtonItem =  rightBtn;
//        self.navigationItem.leftBarButtonItem =  leftBtn;
//        
//    }
//    else{
//        toolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120 , 44)];
//        
//        songsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 60, 35)];
//        [self setButtonStyle:songsBtn];
//        [songsBtn setTitle:@"Songs"  forState:UIControlStateNormal];
//        [songsBtn setBackgroundImage:[UIImage imageNamed:@"song_button"] forState:UIControlStateNormal];
//        [songsBtn addTarget:self action:@selector(showSongList) forControlEvents:UIControlEventTouchUpInside];
//        [toolbar addSubview:songsBtn];
//        
//        righttoolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200 , 44)];
//        
//        goToCollectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(105, 10, 90,35)];
//        [self setButtonStyle:goToCollectionBtn];
//        [goToCollectionBtn setTitle:@"Collection"  forState:UIControlStateNormal];
//        
//        [goToCollectionBtn setBackgroundImage:[UIImage imageNamed:@"collection_btn"] forState:UIControlStateNormal];
//        
//        
//        [goToCollectionBtn addTarget:self action:@selector(gotoCollectionView) forControlEvents:UIControlEventTouchUpInside];
//        
//        [righttoolbar addSubview:goToCollectionBtn];
//        
//        recordButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 10, 55, 35)];
//        [recordButton setImage:[UIImage imageNamed:@"rec"] forState:UIControlStateNormal];
//        
//        [recordButton addTarget:self action:@selector(recordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [toolbar addSubview:recordButton];
//        
//        UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
//        UIBarButtonItem *leftBtn  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
//        self.navigationItem.rightBarButtonItem =  rightBtn;
//        self.navigationItem.leftBarButtonItem =  leftBtn;
//        
//        
////    }
//}
- (void)setButtonStyle:(UIButton*) b{
    b.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:(17.0)];
    [b setTitleColor: [UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1.0] forState:UIControlStateNormal];
    b.titleLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    b.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
}
 

    
-(void) showSongList{
    CGPoint point;
    if([MusicBoxAppDelegate isIOS7]){
        point  = CGPointMake(80, 15);
    }else{
        point  = CGPointMake(80, 7);
    }
    [PopoverView showMusicBoxSongListPopoverAtPoint:point inView:self.view withTitle:_currentThemeTitle withStringArray:_currentSongNames withSelectedIndex:[_currentSongNames indexOfObject:_currentSongTitle] delegate:self];
    
}


-(void) gotoCollectionView{
    
    CollectionViewController *collection = [[CollectionViewController alloc]
                                            initWithNibName:@"CollectionViewController" bundle:nil withDelegate:self];
    [self.navigationController pushViewController:collection animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) wheelDidChangeNumber:(int )newValue inClockWise:(BOOL) isClockWise{
    //        NSLog(@"note position %d", newValue);
    
    int index =0;
    
    if(newValue>=0){
        index = newValue % [_currentNotesArray count];
    }else{
        index = abs([_currentNotesArray count]-newValue)% [_currentNotesArray count];
    }
    
    if(isClockWise){
        [am updateAniObjsStep];
    }
    
    
    
    NSString *nstring = [_currentNotesArray objectAtIndex:index];
    
    NSArray *narray = [nstring componentsSeparatedByString:@"_"];
    NSMutableArray *pins = [[NSMutableArray alloc] init];
    
    if([narray count]>1){
        for(int i=0 ; i<[narray count] ; i++){
            int chord =[[narray objectAtIndex:i] intValue];
            [_soundBankPlayer queueNote:chord gain: 0.5f];
            [pins addObject: [NSNumber numberWithInt:chord-72]];
        }
        [am startPinLocations:pins];
        
    }else{
        int note=  [[_currentNotesArray objectAtIndex:index] intValue];
        
        if(note != 0 ){
            [_soundBankPlayer noteOn:note gain:1.0f];
            [pins addObject: [NSNumber numberWithInt:note-72]];
            [am startPinLocations:pins];
        }
    }
    
}

#pragma mark - PopoverViewDelegate Methods

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index {
    int previous_index =[_currentSongNames indexOfObject:_currentSongTitle];
    //Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.80f];
    // change Song
    [popoverView moveRedPinAnimationfromIndex:previous_index toIndex:index];
    [self changeSong:index];
}

-(void) changeSong:(NSInteger) index{
    timeposition = 0;
    angleRotated = 0;
    
    _currentNotesArray = [[_currentSongNotes objectAtIndex:index] componentsSeparatedByString:@","];
    _currentNoteSpeed = [[_currentNoteSpeeds objectAtIndex:index] floatValue];
    _currentSongTitle = [_currentSongNames objectAtIndex:index];
    [am changeSongTo:_currentSongTitle];
    
    if(isPlaying){
        [self stopAutoPlayer];
        [self startAutoPlayer];
    }
    
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView {
    
}


-(void) updateTimer{
    if(timeposition >= [_currentNotesArray count]){
        timeposition =0;
    }
    [self wheelDidChangeNumber:timeposition inClockWise:YES];
    timeposition++;
}

-(void)startAutoPlayer{
    isPlaying = YES;
    timeCounter = 0;
}
-(void) stopAutoPlayer{
    isPlaying = NO;
}


// change theme and update songs

-(void) changeThemeTo:(MusicBoxThemeType) theme{
    [self stopAutoPlayer];

    [[ThemeManager sharedInstance] changeToTheme:theme withDelegate:self];
    _currentThemeTitle = @"Valentine";
    if(theme == CLASSIC){
        _currentThemeTitle = @"Classic";
    }else if(theme == CARNIVAL){
        _currentThemeTitle = @"Carnival";
    }else if(theme == CHRISTMAS){
        _currentThemeTitle = @"Christmas";
    }
    [am changeThemeTo:theme ThemeName:_currentThemeTitle];
    [msgfield setText:@""];
    [self resetAnimation];
    [self changeSong:0];
}

-(void) updateSongKeys:(NSArray *)keys andSongNames:(NSArray *)names andSongNotes:(NSArray *) notes withNoteSpeeds:(NSArray *)speeds{
    _currentSongNames =names;
    _currentSongNotes =notes;
    _currentNoteSpeeds = speeds;
    _currentNotesArray = [[_currentSongNotes objectAtIndex:0] componentsSeparatedByString:@","];
    _currentSongTitle = [_currentSongNames objectAtIndex:0];
    _currentNoteSpeed  = [[_currentNoteSpeeds objectAtIndex:0] floatValue];
    
    [am changeSongTo:_currentSongTitle];
}

#pragma mark - OpenGL rendering

- (void)resetAnimation
{
    for (int i = 0; i < TEXTURE_COUNT; i++) {
        indexCount[i] = 0;
        vertexCount[i] = 0;
    }
    [am fillBuffer];
}

- (void)addAnimationObject:(AnimationObject)aniObj{
    if (!aniObj.visible) {
        return;
    }
    if (vertexCount[aniObj.textID] > 255) {
        return;
    }
    
    GLfloat rmatrix[4];
    if (aniObj.r != 0.0f) {
        //x
        rmatrix[0] = (aniObj.w / 2.0f) * cosf(aniObj.r);
        rmatrix[1] = (aniObj.h / 2.0f) * (STD_HEIGHT /(IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH)) * (-sinf(aniObj.r));
        
        //y
        rmatrix[2] = (aniObj.w / 2.0f) * ((IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) / STD_HEIGHT) * sinf(aniObj.r);
        rmatrix[3] = (aniObj.h / 2.0f) * cosf(aniObj.r);
    }

    Vertex v;
    if (aniObj.r != 0.0f) {
        v.Position[0] = aniObj.x + rmatrix[0] - rmatrix[1];
        v.Position[1] = aniObj.y + rmatrix[2] - rmatrix[3];
    }
    else{
        v.Position[0] = aniObj.x + (aniObj.w / 2.0f);
        v.Position[1] = aniObj.y - (aniObj.h / 2.0f);
    }
    //----------- change for ios7
    if ([MusicBoxAppDelegate isIOS7]) {
        v.Position[1] = v.Position[1] * 0.95f - 0.05f;
    }
    v.Position[1] += keyboardShiftAmt;
    v.TexCoord[0] = aniObj.textCoordx2;
    v.TexCoord[1] = aniObj.textCoordy2;
    aniVertex[aniObj.textID][vertexCount[aniObj.textID]] = v;
    vertexCount[aniObj.textID]++;
    
    
    if (aniObj.r != 0.0f) {
        v.Position[0] = aniObj.x + rmatrix[0] + rmatrix[1];
        v.Position[1] = aniObj.y + rmatrix[2] + rmatrix[3];
    }
    else{
        v.Position[0] = aniObj.x + (aniObj.w / 2.0f);
        v.Position[1] = aniObj.y + (aniObj.h / 2.0f);
    }
     //----------- change for ios7
    if ([MusicBoxAppDelegate isIOS7]) {
        v.Position[1] = v.Position[1] * 0.95f - 0.05f;
    }
    
    v.Position[1] += keyboardShiftAmt;
    v.TexCoord[0] = aniObj.textCoordx2;
    v.TexCoord[1] = aniObj.textCoordy1;
    aniVertex[aniObj.textID][vertexCount[aniObj.textID]] = v;
    vertexCount[aniObj.textID]++;
    
    if (aniObj.r != 0.0f) {
        v.Position[0] = aniObj.x - rmatrix[0] + rmatrix[1];
        v.Position[1] = aniObj.y - rmatrix[2] + rmatrix[3];
    }
    else{
        v.Position[0] = aniObj.x - (aniObj.w / 2.0f);
        v.Position[1] = aniObj.y + (aniObj.h / 2.0f);
    }
    //----------- change for ios7
    if ([MusicBoxAppDelegate isIOS7]) {
        v.Position[1] = v.Position[1] * 0.95f - 0.05f;
    }
    v.Position[1] += keyboardShiftAmt;
    v.TexCoord[0] = aniObj.textCoordx1;
    v.TexCoord[1] = aniObj.textCoordy1;
    aniVertex[aniObj.textID][vertexCount[aniObj.textID]] = v;
    vertexCount[aniObj.textID]++;
    
    if (aniObj.r != 0.0f) {
        v.Position[0] = aniObj.x - rmatrix[0] - rmatrix[1];
        v.Position[1] = aniObj.y - rmatrix[2] - rmatrix[3];
    }
    else{
        v.Position[0] = aniObj.x - (aniObj.w / 2.0f);
        v.Position[1] = aniObj.y - (aniObj.h / 2.0f);
    }
    //----------- change for ios7
    if ([MusicBoxAppDelegate isIOS7]) {
        v.Position[1] = v.Position[1] * 0.95f - 0.05f;
    }
    
    v.Position[1] += keyboardShiftAmt;
    v.TexCoord[0] = aniObj.textCoordx1;
    v.TexCoord[1] = aniObj.textCoordy2;
    aniVertex[aniObj.textID][vertexCount[aniObj.textID]] = v;
    vertexCount[aniObj.textID]++;
    
    aniIndex[aniObj.textID][indexCount[aniObj.textID]] = vertexCount[aniObj.textID] - 4;
    indexCount[aniObj.textID]++;
    aniIndex[aniObj.textID][indexCount[aniObj.textID]] = vertexCount[aniObj.textID] - 3;
    indexCount[aniObj.textID]++;
    aniIndex[aniObj.textID][indexCount[aniObj.textID]] = vertexCount[aniObj.textID] - 2;
    indexCount[aniObj.textID]++;
    aniIndex[aniObj.textID][indexCount[aniObj.textID]] = vertexCount[aniObj.textID] - 2;
    indexCount[aniObj.textID]++;
    aniIndex[aniObj.textID][indexCount[aniObj.textID]] = vertexCount[aniObj.textID] - 1;
    indexCount[aniObj.textID]++;
    aniIndex[aniObj.textID][indexCount[aniObj.textID]] = vertexCount[aniObj.textID] - 4;
    indexCount[aniObj.textID]++;
}


- (void)startFrame{
    [ev setFramebuffer];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
}

- (void)endFrame{
    [ev presentFramebuffer];
}

- (void)renderLayer:(GLuint)t{
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * vertexCount[t], aniVertex[t], GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer[t]);    
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte) * indexCount[t], aniIndex[t], GL_STATIC_DRAW);
    
    if ([context API] == kEAGLRenderingAPIOpenGLES2) {
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        // Use shader program.
        glUseProgram(program);
        
        _positionSlot = glGetAttribLocation(program, "position");
        glEnableVertexAttribArray(_positionSlot);
        
        _texCoordSlot = glGetAttribLocation(program, "textCoordIn");
        glEnableVertexAttribArray(_texCoordSlot);
        _textureUniform = glGetUniformLocation(program, "Texture");
        
        // Add inside render:, right before glDrawElements
        glVertexAttribPointer(_positionSlot, 2, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), 0);
        glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), (GLvoid*) (sizeof(float) * 2));
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, textID[t]);
        glUniform1i(_textureUniform, 0);
        
        // Validate program before drawing. This is a good check, but only really necessary in a debug build.
        // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if DEBUG
        if (![self validateProgram:program]) {
            NSLog(@"Failed to validate program: %d", program);
            return;
        }
#endif
        // Render original demo
        glDrawElements(GL_TRIANGLES, indexCount[t],
                       GL_UNSIGNED_BYTE, 0);
        
    }
}

- (void)drawFrame
{
    
    CFTimeInterval ctime = CACurrentMediaTime();
    GLfloat timePassed = (ctime - lastRenderTime) / _currentNoteSpeed;
    if (keyboardVisible){
        if(keyboardShiftAmt < keyboardHeight) {
            keyboardShiftAmt += timePassed / 2.0f;
        }
        if(keyboardShiftAmt > keyboardHeight) {
            keyboardShiftAmt = keyboardHeight;
        }
    }
    else {
        if(keyboardShiftAmt > 0.0f) {
            keyboardShiftAmt -= timePassed / 2.0f;
        }
        if (keyboardShiftAmt < 0.0f) {
            keyboardShiftAmt = 0.0f;
        }
    }
    
    if (isPlaying) {
        timeCounter += timePassed;
        if (timeCounter >= 1.0f) {
            [self updateTimer];
            timeCounter -= 1.0f;
        }
    }
    [am updateAniObjs:timePassed IsAuto:isPlaying];
    [self resetAnimation];
    lastRenderTime = ctime;
    
    [self startFrame];
    for (int i = 0; i < TEXTURE_COUNT; i++) {
        [self renderLayer:i];
    }
    [self endFrame];
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if DEBUG
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if DEBUG
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (void)setupTexture:(NSString *)fileName {
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    textID[textCount] = texName;
    
    [self reloadTexture:textCount :fileName];
    textCount++;
}

- (void)reloadTexture:(GLuint)i :(NSString *)fileName{
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    glBindTexture(GL_TEXTURE_2D, textID[i]);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
}


-(void)createBlankTexture:(GLuint)width:(GLuint)height{
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	
	void *imageData = malloc( height * width * 4 );
	memset(imageData, 0, height * width * 4);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	free(imageData);
    
    textID[textCount] = texName;
    textCount++;
    
}

-(void)renderTextLoc:(GLuint)width:(GLuint)height:(UIColor*)c:(UIFont*)uf:(UITextAlignment)align:(NSString*)s:(GLuint)tid{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	void *imageData = malloc( height * width * 4 );
	memset(imageData, 0, height * width * 4);
	CGContextRef tcontext = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace,
                                                  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
	CGColorSpaceRelease( colorSpace );
	//CGContextSetRGBFillColor(tcontext, 1.0, 1.0, 1.0, 1.0);
    CGContextSetFillColorWithColor(tcontext, [c CGColor]);
	CGContextTranslateCTM( tcontext, 0, height);
	CGContextScaleCTM(tcontext, 1.0, -1.0);
	UIGraphicsPushContext(tcontext);
	
	CGSize psize = [s sizeWithFont:uf constrainedToSize:CGSizeMake(width, height) lineBreakMode:UILineBreakModeWordWrap];
    
	[s drawInRect:CGRectMake(0, (height - psize.height) / 2, width, height) withFont:uf lineBreakMode:UILineBreakModeWordWrap alignment:align];
	UIGraphicsPopContext();
	
	glBindTexture(GL_TEXTURE_2D, textID[tid]);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	
	CGContextRelease(tcontext);
	
	free(imageData);
	
}


- (void)loadTextures{
    textCount = 0;
    [self setupTexture:@"background_gl"];
    [self createBlankTexture:256 :256];
    [self createBlankTexture:256 :256];
    [self createBlankTexture:256 :256];
    [self setupTexture:@"wheel_gl"];
    [self setupTexture:@"comb_gl"];
    [self setupTexture:@"verticalgear_gl"];
    [self setupTexture:@"play_gl"];
    [self setupTexture:@"lightbox_1_gl"];
    [self setupTexture:@"gear_gl"];
    [self createBlankTexture:1024 :64];
    [self createBlankTexture:256 :256];
}

- (BOOL)loadShaders
{
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    NSString *vShaderFile = [[NSBundle mainBundle] pathForResource:@"Shader_v" ofType:@"glsl"];
    GLuint vShader = 0;
    if (![self compileShader:&vShader type:GL_VERTEX_SHADER file:vShaderFile]) {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    NSString *fShaderFile = [[NSBundle mainBundle] pathForResource:@"Shader_f" ofType:@"glsl"];
    GLuint fShader = 0;
    if (![self compileShader:&fShader type:GL_FRAGMENT_SHADER file:fShaderFile]) {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fShader);
    
    // Link program.
    if (![self linkProgram:program]) {
        NSLog(@"Failed to link program: %d", program);
        
        if (vShader) {
            glDeleteShader(vShader);
            vShader = 0;
        }
        if (fShader) {
            glDeleteShader(fShader);
            fShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }
    
    // Release vertex and fragment shaders.
    if (vShader) {
        glDeleteShader(vShader);
    }
    if (fShader) {
        glDeleteShader(fShader);
    }
    
    return TRUE;
}

#pragma mark - app interactions

- (void)playSwitch{
    if (isPlaying) {
        [self stopAutoPlayer];
    }
    else{
        [self startAutoPlayer];
    }
    [am changeAutoPlay:isPlaying ButtonPressed:FALSE];
    [self resetAnimation];    

}

- (BOOL)getIsPlaying{
    return isPlaying;
}

- (void)playPressing{
    [am changeAutoPlay:isPlaying ButtonPressed:TRUE];
    [self resetAnimation];
}

- (void)leverRotated:(GLfloat)angle{
    if (angle > 0) {
        angleRotated += angle;
        if (angleRotated >= M_PI / 2) {
            [self updateTimer];
            angleRotated -= M_PI / 2;
        }
    }
    [am leverRotated:angle];
    [self resetAnimation];
}

-(void)toggleKeyboard:(BOOL)isShowing{
    keyboardVisible = isShowing;
    if (keyboardVisible) {
        [msgfield becomeFirstResponder];
        //[msgfield setHidden:false];

    }
    else{
        [msgfield resignFirstResponder];
        //[msgfield setHidden:true];
    }
}


- (void) keyboardDidShowNotification:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat kbHeight =
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.width;
    
    keyboardHeight = kbHeight / STD_HEIGHT * 2.0f;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [am updateMessage:textView.text];
}


#pragma mark -


- (IBAction)recordButtonPressed:(id)sender {
    if ([[[Everyplay sharedInstance] capture] isRecording]) {
        [[[Everyplay sharedInstance] capture] stopRecording];
    } else {
        [[[Everyplay sharedInstance] capture] startRecording];
    }
}

- (IBAction)videoButtonPressed:(id)sender {
    [[Everyplay sharedInstance] playLastRecording];
}

#pragma mark - Delegate Methods
- (void)everyplayShown {
    NSLog(@"everyplayShown");
    
    [self stopAnimation];
}

- (void)everyplayHidden {
    NSLog(@"everyplayHidden");
    
    [self startAnimation];
}

- (void)everyplayRecordingStarted {
    NSLog(@"everyplayRecordingStarted");
   // [recordMenuButton setImage:[UIImage imageNamed:@"rec_press"] forState:UIControlStateNormal];

    videoButton.hidden = YES;
    videoButton2.hidden = YES;
}

- (void)everyplayRecordingStopped {
    NSLog(@"everyplayRecordingStopped");
   // [recordMenuButton setImage:[UIImage imageNamed:@"rec"] forState:UIControlStateNormal];
    
    [[Everyplay sharedInstance] mergeSessionDeveloperData:@{@"song" : _currentSongNames}];

    videoButton.hidden = NO;
    videoButton2.hidden = NO;
    
}


@end
