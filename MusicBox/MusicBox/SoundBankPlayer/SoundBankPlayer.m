
#import <AudioToolbox/AudioToolbox.h>
#import "SoundBankPlayer.h"
#import <Everyplay/EveryplaySoundEngine.h>

#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"


// How many Buffer objects we have. This limits the number of sound samples
// there can be in the sound bank.
#define MAX_BUFFERS 128

// How many Note objects we have. We can handle the entire MIDI range (0-127).
#define NUM_NOTES 128

// Describes a sound sample and connects it to an OpenAL buffer.
typedef struct
{
	float pitch;           // pitch of the note in the sound sample
	CFStringRef filename;  // name of the sound sample file
	ALuint bufferId;       // OpenAL buffer name
}
Buffer;

// Describes a MIDI note and how it will be played.
typedef struct
{
	float pitch;      // pitch of the note
	int bufferIndex;  // which buffer is assigned to this note (-1 = none)
	float panning;    // < 0 is left, 0 is center, > 0 is right
}
Note;

@interface SoundBankPlayer ()

//- (void)audioSessionBeginInterruption;
//- (void)audioSessionEndInterruption;
@end

@implementation SoundBankPlayer
{
	BOOL _initialized;             // whether OpenAL is initialized
	int _numBuffers;               // the number of active Buffer objects
	int _sampleRate;               // the sample rate of the sound bank
    
	Buffer _buffers[MAX_BUFFERS];  // list of buffers, not all are active
	Note _notes[NUM_NOTES];        // the notes indexed by MIDI note number
    
	ALCcontext *_context;          // OpenAL context
	ALCdevice *_device;            // OpenAL device
    
	NSString *_soundBankName;      // name of the current sound bank
}

@synthesize loopNotes = _loopNotes;

- (id)init
{
	if ((self = [super init]))
	{
		_initialized = NO;
		_soundBankName = @"";
		_loopNotes = NO;
		[self initNotes];
	}
    
	return self;
}

- (void)dealloc
{
	[self tearDownAudio];
}

- (void)setSoundBank:(NSString *)newSoundBankName
{
	if (![newSoundBankName isEqualToString:_soundBankName])
	{
		_soundBankName = [newSoundBankName copy];
        
		[self tearDownAudio];
		[self loadSoundBank:_soundBankName];
		[self setUpAudio];
	}
}

- (void)setUpAudio
{
	if (!_initialized)
	{
		_initialized = YES;
	}
}

- (void)tearDownAudio
{
	if (_initialized)
	{
		[self freeBuffers];
		_initialized = NO;
	}
}

- (void)initNotes
{
	// Initialize note pitches using equal temperament (12-TET)
	for (int t = 0; t < NUM_NOTES; ++t)
	{
		_notes[t].pitch = 440.0f * pow(2, (t - 69)/12.0);  // A4 = MIDI key 69
		_notes[t].bufferIndex = -1;
		_notes[t].panning = 0.0f;
	}
}

- (void)loadSoundBank:(NSString *)filename
{
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
	NSArray *array = [NSArray arrayWithContentsOfFile:path];
	if (array == nil)
	{
		NSLog(@"Could not load sound bank '%@'", path);
		return;
	}
    
	_sampleRate = [(NSString *)[array objectAtIndex:0] intValue];
    
	_numBuffers = ([array count] - 1) / 3;
	if (_numBuffers > MAX_BUFFERS)
		_numBuffers = MAX_BUFFERS;
    
	int midiStart = 0;
	for (int t = 0; t < _numBuffers; ++t)
	{
		_buffers[t].filename = CFBridgingRetain([array objectAtIndex:1 + t*3]);
		int midiEnd = [(NSString *)[array objectAtIndex:1 + t*3 + 1] intValue];
		int rootKey = [(NSString *)[array objectAtIndex:1 + t*3 + 2] intValue];
		_buffers[t].pitch = _notes[rootKey].pitch;
        
		if (t == _numBuffers - 1)
			midiEnd = 127;
        
		for (int n = midiStart; n <= midiEnd; ++n)
			_notes[n].bufferIndex = t;
        
		midiStart = midiEnd + 1;
	}
}

#pragma mark - OpenAL

- (void)freeBuffers
{
	for (int t = 0; t < _numBuffers; ++t)
	{
		CFRelease(_buffers[t].filename);
	}
}


#pragma mark - Playing Sounds


- (void)noteOn:(int)midiNoteNumber gain:(float)gain
{
	[self queueNote:midiNoteNumber gain:gain];
}

- (void)queueNote:(int)midiNoteNumber gain:(float)gain
{
	if (!_initialized)
	{
		NSLog(@"SoundBankPlayer is not initialized yet");
		return;
	}
    
	Note *note = _notes + midiNoteNumber;
    
    
	if (note->bufferIndex != -1)
	{
        Buffer *buffer = _buffers + note->bufferIndex;
        [[EveryplaySoundEngine sharedInstance] playEffect:(__bridge NSString *)(buffer->filename) pitch:note->pitch/buffer->pitch pan:note->panning gain:gain];
        
        //[[SimpleAudioEngine sharedEngine] playEffect:(__bridge NSString *)(buffer->filename) pitch:note->pitch/buffer->pitch pan:note->panning gain:gain];
            
	}
}

@end
