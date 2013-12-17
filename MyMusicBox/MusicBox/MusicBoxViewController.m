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
#import <MobileCoreServices/MobileCoreServices.h>
#import "CMPopTipView.h"
#import "AppFlood.h"


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
@property (nonatomic, strong) WSAssetPickerController *pickerController;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;


- (BOOL)loadShaders;
- (void)setupTexture:(NSString *)fileName;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
- (void)loadTextures;
- (void)createBlankTexture:(GLuint)width:(GLuint)height;
- (void)copyPhoto:(UIImage*)photo ToTexture:(GLuint)id;
- (UIImage *)RotateImage:(UIImage *)image;


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
@synthesize songsBtn;
@synthesize goToCollectionBtn;

int timeposition=0;
BOOL isPlaying ;
bool firstFrame;

int bubblesViewed = 0;
int bubblesViewed2 = 0;

int selectPhotoIndex;
int photoIndex;
UIPopoverController *popover;
UIImagePickerController *imagePicker;
NSMutableArray* selectedPhotoUTI;
CMPopTipView *navBarLeftButtonPopTipView;
CMPopTipView *navWheelPopTipView;
ALAssetsLibrary* library;

UIView *toolbar;
UIView *righttoolbar;

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

//- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
//    if (itemEnabled) {
//        [self.optionIndices addIndex:index];
//    }
//    else {
//        [self.optionIndices removeIndex:index];
//    }
//}


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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    am = [[AnimationManager alloc]init];
    int loadSong = [defaults integerForKey:@"user_Song"];
    int x = [defaults integerForKey:@"user_Theme"];
    [self changeThemeTo:x];
    [self changeSong:loadSong];
    
    [am changeThemeTo:[defaults integerForKey:@"user_Theme"] ThemeName:_currentThemeTitle];
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
    
    selectedPhotoUTI = [[NSMutableArray alloc] init];
    isInAniSelect = false;
    playButtonState = PLAY_BUTTON_STATE_NOT_SHOWING;
    
    library = [[ALAssetsLibrary alloc] init];
    
    /*
     if ([defaults objectForKey:@"BubblesViewed"]!=nil)
     bubblesViewed = [defaults integerForKey:@"BubblesViewed"];
     if (bubblesViewed == 0) {
     [self updateBubbles];
     }
     */
    if([defaults objectForKey:@"user_message"]!=nil){
        msgfield.text = [defaults objectForKey:@"user_message"];
        [am updateMessage:msgfield.text isDefault:false];
    }
    
    if ([defaults objectForKey:@"BubblesViewed2"]!=nil)
        bubblesViewed2 = [defaults integerForKey:@"BubblesViewed2"];
    [self updateBubbles2];
    
    firstFrame = true;
     self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
}


-(void) viewWillAppear:(BOOL)animated{
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
    [songsBtn setTitle:NSLocalizedString(@"SONGS_BTN", @"SONGS_BTN") forState:UIControlStateNormal];
    [songsBtn setBackgroundImage:[UIImage imageNamed:@"song_button"] forState:UIControlStateNormal];
    [songsBtn addTarget:self action:@selector(showSongList) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:songsBtn];
    
    righttoolbar =  [[UIView alloc] initWithFrame:righttoolbarFrame];
    
    goToCollectionBtn = [[UIButton alloc] initWithFrame:collectionbtnFrame];
    [self setButtonStyle:goToCollectionBtn];
    [goToCollectionBtn setTitle:NSLocalizedString(@"COLLECTION_BTN", @"COLLECTION_BTN") forState:UIControlStateNormal];
    
    [goToCollectionBtn setBackgroundImage:[UIImage imageNamed:@"collection_btn"] forState:UIControlStateNormal];
    
    [goToCollectionBtn addTarget:self action:@selector(gotoCollectionView) forControlEvents:UIControlEventTouchUpInside];
    
    [righttoolbar addSubview:goToCollectionBtn];
    
    
    UIBarButtonItem *rightBtn  = [[UIBarButtonItem alloc] initWithCustomView:righttoolbar];
    UIBarButtonItem *leftBtn  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    self.navigationItem.rightBarButtonItem =  rightBtn;
    self.navigationItem.leftBarButtonItem =  leftBtn;
    

    
    
}




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
    NSDate *lasttimeshow=[[NSUserDefaults standardUserDefaults] objectForKey:@"ADS_POPUP_LASTTIME"];
    NSDate *now= [NSDate date];
    if(lasttimeshow!=nil){
        
        NSLog(@"now :%@ , lasttime :%@", now , lasttimeshow);
        if([now timeIntervalSinceDate:lasttimeshow] > 1000*60*30*1){
            [AppFlood showFullscreen];
            [[NSUserDefaults standardUserDefaults] setObject:now forKey:@"ADS_POPUP_LASTTIME"];
        }
    }else{
        [AppFlood showFullscreen];
        [[NSUserDefaults standardUserDefaults] setObject:now forKey:@"ADS_POPUP_LASTTIME"];
    }
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:index forKey:@"user_Song"];
    [defaults synchronize];
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
    _currentThemeTitle = NSLocalizedString(@"VALENTINE_THEME_NAME", @"valentine theme name");
    
    if(theme == CLASSIC){
        _currentThemeTitle = @"Classic";
    }else if(theme == CARNIVAL){
        _currentThemeTitle = NSLocalizedString(@"CARNIVAL_THEME_NAME", @"carnival theme name");
    }else if(theme == CHRISTMAS){
        _currentThemeTitle = @"Christmas";
    }
    [am changeThemeTo:theme ThemeName:_currentThemeTitle];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:theme forKey:@"user_Theme"];
    [defaults synchronize];
    
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
    if ([MusicBoxAppDelegate isIOS7]) {
        v.Position[1] = v.Position[1] * 0.95f - 0.05f;
    }
    if(aniObj.followShift) v.Position[1] += keyboardShiftAmt;
    
    
    v.TexCoord[0] = aniObj.textCoordx2;
    v.TexCoord[1] = aniObj.textCoordy2;
    v.alpha = aniObj.alpha;
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
    if ([MusicBoxAppDelegate isIOS7]) {
        v.Position[1] = v.Position[1] * 0.95f - 0.05f;
    }
    
    if(aniObj.followShift) v.Position[1] += keyboardShiftAmt;
    v.TexCoord[0] = aniObj.textCoordx2;
    v.TexCoord[1] = aniObj.textCoordy1;
    v.alpha = aniObj.alpha;
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
    if ([MusicBoxAppDelegate isIOS7]) {
        v.Position[1] = v.Position[1] * 0.95f - 0.05f;
    }
    
    if(aniObj.followShift) v.Position[1] += keyboardShiftAmt;
    v.TexCoord[0] = aniObj.textCoordx1;
    v.TexCoord[1] = aniObj.textCoordy1;
    v.alpha = aniObj.alpha;
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
    if ([MusicBoxAppDelegate isIOS7]) {
        v.Position[1] = v.Position[1] * 0.95f - 0.05f;
    }
    
    if(aniObj.followShift) v.Position[1] += keyboardShiftAmt;
    v.TexCoord[0] = aniObj.textCoordx1;
    v.TexCoord[1] = aniObj.textCoordy2;
    v.alpha = aniObj.alpha;
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
        
        _alphaSlot = glGetAttribLocation(program, "alphaValue");
        glEnableVertexAttribArray(_alphaSlot);
        
        
        // Add inside render:, right before glDrawElements
        glVertexAttribPointer(_positionSlot, 2, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), 0);
        glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), (GLvoid*) (sizeof(float) * 2));
        glVertexAttribPointer(_alphaSlot, 1, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), (GLvoid*) (sizeof(float) * 4));
        
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
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self startFrame];
        for (int i = 0; i < TEXTURE_COUNT; i++) {
            [self renderLayer:i];
        }
        [self endFrame];
        
        if (firstFrame) {
            [self loadPhoto];
            firstFrame = false;
        }
        
    }
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

- (UIImage *)RotateImage:(UIImage *)image {
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (void)switchTexture:(GLuint)t1 :(GLuint)t2{
    GLuint tid;
    tid = textID[t1];
    textID[t1] = textID[t2];
    textID[t2] = tid;
}

- (void)copyPhoto:(UIImage*)photo ToTexture:(GLuint)id{
    // 1
    CGImageRef spriteImage = [self RotateImage:photo].CGImage;
    if (!spriteImage) {
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    CGRect cropRect;
    if(width > height){
        cropRect.origin.y = 0;
        cropRect.origin.x = (width - height) / 2;
        cropRect.size.height = height;
        cropRect.size.width = height;
    }
    else{
        cropRect.origin.y = (height - width) / 2;
        cropRect.origin.x = 0;
        cropRect.size.height = width;
        cropRect.size.width = width;
    }
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(spriteImage, cropRect);
    
    GLubyte * spriteData = (GLubyte *) calloc(PHOTO_SIZE*PHOTO_SIZE*2*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, PHOTO_SIZE * 2, PHOTO_SIZE, 8, PHOTO_SIZE * 2 *4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, PHOTO_SIZE, PHOTO_SIZE), imageRef);
    
    CGContextRelease(spriteContext);
    
    glBindTexture(GL_TEXTURE_2D, textID[id]);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, PHOTO_SIZE * 2, PHOTO_SIZE, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    
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

- (GLfloat)renderTextLocScroll:(GLuint)width:(GLuint)height:(UIColor*)c:(UIFont*)uf:(UITextAlignment)align:(NSString*)s:(GLuint)tid :(GLfloat)scroll :(BOOL)isScrolling{
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
	CGSize psize2 = [s sizeWithFont:uf];
    GLfloat tScroll = scroll;
    
    if ((psize2.width > width) && !isScrolling) {
        tScroll = psize2.width - width;
    }
    
	[s drawInRect:CGRectMake(-tScroll, (height - psize.height) / 2, psize2.width, height) withFont:uf lineBreakMode:UILineBreakModeWordWrap alignment:align];
	UIGraphicsPopContext();
	
	glBindTexture(GL_TEXTURE_2D, textID[tid]);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	
	CGContextRelease(tcontext);
	
	free(imageData);
    
    if (scroll > psize2.width) {
        return -(IS_IPHONE_5 ? WIDE_WIDTH : STD_WIDTH) * 1.5f;
    }
    else{
        return tScroll;
    }
}


-(void)renderTextLocAutoSize:(GLuint)width:(GLuint)height:(UIColor*)c:(UIFont*)uf:(UITextAlignment)align:(NSString*)s:(GLuint)tid{
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
	
    UIFont* rf;
    CGFloat fontSize = 48.0;
    BOOL hasWork = true;
    CGSize psize;
    while (fontSize > 0 && hasWork) {
        rf = [uf fontWithSize:fontSize];
        psize = [s sizeWithFont:rf constrainedToSize:CGSizeMake(width, height * 3) lineBreakMode:UILineBreakModeWordWrap];
        if (psize.height < height) {
            hasWork = false;
        }
        else{
            fontSize--;
        }
    }
    
	[s drawInRect:CGRectMake(0, (height - psize.height) / 2, width, height) withFont:rf lineBreakMode:UILineBreakModeWordWrap alignment:align];
	UIGraphicsPopContext();
	
	glBindTexture(GL_TEXTURE_2D, textID[tid]);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	
	CGContextRelease(tcontext);
	
	free(imageData);
	
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
    [self setupTexture:@"lightbox_1_gl"];
    [self setupTexture:@"photo_frame_gl"];
    [self createBlankTexture:512 :128];
    [self createBlankTexture:1024 :512];
    [self createBlankTexture:1024 :512];
    [self createBlankTexture:1024 :512];
    [self createBlankTexture:256 :256];
    [self createBlankTexture:256 :256];
    [self createBlankTexture:256 :256];
    [self setupTexture:@"wheel_gl"];
    [self setupTexture:@"comb_gl"];
    [self setupTexture:@"verticalgear_gl"];
    [self setupTexture:@"gear_gl"];
    [self createBlankTexture:1024 :64];
    [self createBlankTexture:256 :256];
    [self setupTexture:@"play_gl"];
    
    textID[TEXTURE_ANI_STYLE] = textID[TEXTURE_BG];
    textCount++;
    [self createBlankTexture:1024 :64];
    textCount += 9;
    //[self setupTexture:@"dropdown_gl"];
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

#pragma mark - bubbles

- (void)updateBubbles2{
    [self clearBubble2];
    if (bubblesViewed2 < 9) {
        [am darkenScreen:true];
        isInShowingBubble = true;
    }
    switch (bubblesViewed2) {
        case 0:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_0", @"INSTRUCTION_0")];
            navWheelPopTipView.delegate = self;
            [navWheelPopTipView presentPointingAtPointX:(IS_IPHONE_5? 26 : 0) + 405 pointY:50 inView:ev animated:YES width:200];
            break;
        case 1:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_1", @"INSTRUCTION_1")];
            navWheelPopTipView.delegate = self;
            [navWheelPopTipView presentPointingAtPointX:(IS_IPHONE_5? 26 : 0) + 405 pointY:100 inView:ev animated:YES width:200];
            break;
        case 2:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_2", @"INSTRUCTION_2")];
            navWheelPopTipView.delegate = self;
            [navWheelPopTipView presentPointingAtPointX:(IS_IPHONE_5? 26 : 0) + 405 pointY:165 inView:ev animated:YES width:200];
            break;
        case 3:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_3", @"INSTRUCTION_3")];
            navWheelPopTipView.delegate = self;
            [navWheelPopTipView presentPointingAtPointX:(IS_IPHONE_5? 26 : 0)+200 pointY:250 inView:ev animated:YES width:200];
            break;
        case 4:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_4", @"INSTRUCTION_4")];
            navWheelPopTipView.delegate = self;
            [navWheelPopTipView presentPointingAtView:songsBtn inView:toolbar animated:YES];
            break;
        case 5:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_5", @"INSTRUCTION_5")];
            [navWheelPopTipView presentPointingAtView:recordMenuButton inView:toolbar animated:YES];
            break;
        case 6:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_6", @"INSTRUCTION_6")];
            [navWheelPopTipView presentPointingAtView:recordMenuButton inView:toolbar animated:YES];
            break;
        case 7:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_7", @"INSTRUCTION_7")];
            [navWheelPopTipView presentPointingAtView:recordMenuButton inView:toolbar animated:YES];
            break;
        case 8:
            navWheelPopTipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(@"INSTRUCTION_8", @"INSTRUCTION_8")];
            navWheelPopTipView.delegate = self;
            [navWheelPopTipView presentPointingAtView:goToCollectionBtn inView:righttoolbar animated:YES];
            break;
        default:
            break;
    }
}

- (void)clearBubble2{
    if (navWheelPopTipView) {
        [navWheelPopTipView dismissAnimated:TRUE];
        navWheelPopTipView = NULL;
    }
    [am darkenScreen:FALSE];
    isInShowingBubble = FALSE;
}

- (BOOL)getIsInShowingBubble{
    return isInShowingBubble;
}

- (void)screenClicked{
    bubblesViewed2++;
    [self updateBubbles2];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:bubblesViewed2 forKey:@"BubblesViewed2"];
    [defaults synchronize];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{
    [self screenClicked];
}

- (void)resetInstruction{
    bubblesViewed2 = 0;
    [self updateBubbles2];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:bubblesViewed2 forKey:@"BubblesViewed2"];
    [defaults synchronize];
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
    [self clearBubble2];
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
    [self clearBubble2];
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
    [am updateMessage:textView.text isDefault:false];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:textView.text forKey:@"user_message"];
}
#pragma mark - photo

-(void)selectPhoto{
    self.pickerController = [[WSAssetPickerController alloc] initWithDelegate:self];
    self.pickerController.selectionLimit = 3;
    [self.pickerController setPreselectedAssets:selectedPhotoUTI];
    
    [self presentViewController:self.pickerController animated:YES completion:NULL];
    
}




- (IBAction)saveImagesDone:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [popover dismissPopoverAnimated:YES];
    }
    else{
        [imagePicker dismissModalViewControllerAnimated:YES];
    }
}


- (BOOL)getIsInAniSelect{
    return isInAniSelect;
}

- (void)switchStyle:(int)style{
    isInAniSelect = false;
    [am switchStyle:style];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:style forKey:@"photo_style"];
    [defaults synchronize];
}

- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    // Dismiss the WSAssetPickerController.
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    // Hang on to the picker to avoid ALAssetsLibrary from being released (see note below).
    self.pickerController = sender;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    selectPhotoIndex = assets.count;
    [selectedPhotoUTI removeAllObjects];
    if (selectPhotoIndex == 0) {
        [am updatePhoto:0];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:selectPhotoIndex forKey:@"photo_count"];
    
    for (int i = 0; i < selectPhotoIndex; i++) {
        UIImage *image = [[UIImage alloc] initWithCGImage:((ALAsset*)[assets objectAtIndex:i]).defaultRepresentation.fullScreenImage];
        
        [self copyPhoto:image ToTexture:TEXTURE_PHOTO1 + i];
        [am updatePhoto:i + 1];
        [selectedPhotoUTI addObject:[((ALAsset*)[assets objectAtIndex:i]).defaultRepresentation.url absoluteString]] ;
        
        [defaults setObject:[((ALAsset*)[assets objectAtIndex:i]).defaultRepresentation.url absoluteString] forKey:[NSString stringWithFormat:@"%@_%d",@"photo_url", i]];
    }
    
    if (selectPhotoIndex > 1) {
        isInAniSelect = true;
        textID[TEXTURE_ANI_STYLE_1_0] = textID[TEXTURE_PHOTO1];
        textID[TEXTURE_ANI_STYLE_2_0] = textID[TEXTURE_PHOTO2];
        textID[TEXTURE_ANI_STYLE_3_0] = textID[TEXTURE_PHOTO3];
        textID[TEXTURE_ANI_STYLE_1_1] = textID[TEXTURE_PHOTO1];
        textID[TEXTURE_ANI_STYLE_2_1] = textID[TEXTURE_PHOTO2];
        textID[TEXTURE_ANI_STYLE_3_1] = textID[TEXTURE_PHOTO3];
        textID[TEXTURE_ANI_STYLE_1_2] = textID[TEXTURE_PHOTO1];
        textID[TEXTURE_ANI_STYLE_2_2] = textID[TEXTURE_PHOTO2];
        textID[TEXTURE_ANI_STYLE_3_2] = textID[TEXTURE_PHOTO3];
    }
    [defaults synchronize];
    
}

-(void)loadPhoto{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    selectPhotoIndex = [defaults integerForKey:@"photo_count"];
    photoIndex = 0;
    for (int i = 0; i < selectPhotoIndex; i++) {
        NSString* photoURL = [defaults objectForKey:[NSString stringWithFormat:@"%@_%d",@"photo_url", i]];
        
        [library assetForURL:[NSURL URLWithString:photoURL] resultBlock:^(ALAsset *asset) {
            if (asset) {
                ALAssetRepresentation *assetRepresentation = asset.defaultRepresentation;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [[UIImage alloc] initWithCGImage:assetRepresentation.fullScreenImage];
                    [self copyPhoto:image ToTexture:TEXTURE_PHOTO1 + photoIndex];
                    [am updatePhoto: photoIndex + 1];
                    
                    photoIndex++;
                    [selectedPhotoUTI addObject:photoURL] ;
                    
                });
            }
            
        } failureBlock:^(NSError *error) {
            
            NSLog(@"Failed to get Image");
        }];
    }
    [am switchStyle:[defaults integerForKey:@"photo_style"]];
}



#pragma mark -


- (IBAction)recordButtonPressed:(id)sender {
    [am showPullDown:YES];
    if (!(isInAniSelect || keyboardVisible)) {
        if ([[[Everyplay sharedInstance] capture] isRecording]) {
            [[[Everyplay sharedInstance] capture] stopRecording];
        } else {
            [[[Everyplay sharedInstance] capture] startRecording];
            
        }
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
    
    /*
     videoButton.hidden = YES;
     videoButton2.hidden = YES;
     */
    [am showPullDown:FALSE];
    playButtonState = PLAY_BUTTON_STATE_NOT_SHOWING;
    
    if(bubblesViewed == 0){
        bubblesViewed = 1;
    }
}

- (void)everyplayRecordingStopped {
    NSLog(@"everyplayRecordingStopped");
    //[recordMenuButton setImage:[UIImage imageNamed:@"rec"] forState:UIControlStateNormal];
    
    [[Everyplay sharedInstance] mergeSessionDeveloperData:@{@"song" : _currentSongTitle}];
    
    /*
     videoButton.hidden = NO;
     videoButton2.hidden = NO;
     */
    [am showPullDown:TRUE];
    playButtonState = PLAY_BUTTON_STATE_SHOW_TAB;
    if(bubblesViewed <= 2){
        bubblesViewed = 2;
        
    }
}

- (int)getPlayButtonState{
    return playButtonState;
}

- (void)clickPlayTabDown{
    [am pullDownPlayButton];
    playButtonState = PLAY_BUTTON_STATE_SHOW_FULL;
    if(bubblesViewed == 2){
        bubblesViewed = 3;
        
    }
}

- (void)clickPlayTabUp{
    [am returnPlayButton];
    playButtonState = PLAY_BUTTON_STATE_SHOW_TAB;
}

- (void)clickPlayRecord{
    [[Everyplay sharedInstance] playLastRecording];    
}



@end
