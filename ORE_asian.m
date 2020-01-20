function ORE_asian(participantNumber)
%% Description
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This experiment shows particpants pairs of faces that are     %%%
%%% either asian or caucasian. The task is for participants to    %%%
%%% judge the similarity of the two expressions from 1-7          %%%
%%% (1 = different; 7 = similar). This allows for a behavioural   %%%
%%% measure for the full EEG experiment.                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%try

if nargin < 1;
    participantNumber = 0;
end

%% Clear the workspace
close all;
clc;
sca;
KbName('UnifyKeyNames');
spaceKey = KbName ('space');

oneKey = KbName('1!');
twoKey = KbName('2@');
threeKey = KbName('3#');
fourKey = KbName('4$');
fiveKey = KbName('5%');
sixKey = KbName('6^');
sevenKey = KbName('7&');
%     sameKey = KbName('l');
%     diffKey = KbName('a');

breakKey = KbName('tab');


ListenChar(2); 

%Listens to keyboard
RestrictKeysForKbCheck([spaceKey oneKey twoKey threeKey ...
    fourKey fiveKey sixKey sevenKey breakKey]);


%% Defining random seed
rand('seed', sum(100 * clock));
%   rng('shuffle');


%% Loading the order and training block
AsianFolder='C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian'; %Input the directory of the location where the Images are
cd(AsianFolder)
files=dir('*.png');

%% Colour coordinates constants
BLACK = [0 0 0];
RED = [255 0 0];
WHITE = [255 255 255];
BLUE = [0 0 255];
GREEN = [0 255 0];

%% Fixation cross

%Here we set the size of the arms of our fixation cross
fixCrossDimPix = 40;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Cross charactersistics
crossLength = 10;
crossColor = 0;
crossWidth = 4;

% Set start and end points of lines
crossLines = [-crossLength, 0; crossLength, 0; 0, -crossLength; 0, crossLength];
crossLines = crossLines';


%% Timing paramaters of diplay
FIXATION1 = 0.3; %first fixation cross
STIMDISPLAY1 = 1; % 1 s on block 1 % Display of the stimulus

%% Stimulus Order

% Number of blocks = 1 training, 5 experimental, and 1 consistency block %
numblocks = 7;

% Number of faces
numFaces = 30;

% Training order file
trainingPairs = nchoosek(1:numFaces, 2);
trainingPairs = trainingPairs(randperm(size(trainingPairs,1)),:);
trainingPairs = trainingPairs(1:5, :);

% Experimental order file. Here, I code it so every single possible pair combo
% is shown to the participants %
facePairs = nchoosek(1:numFaces, 2);
shuffledFaces = facePairs(randperm(size(facePairs,1)),:);

%% Start PsychToolbox
HideCursor;

PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
AssertOpenGL;
ListenChar(2);
screenNumber = max(Screen('Screens'));

bckColor=BlackIndex(screenNumber);

[WindowIndex, WindowIndexRect] = Screen('OpenWindow', max(Screen('Screens')), BLACK);

WaitSecs(0.5);
[screenXpixels, screenYpixels] = Screen('WindowSize', WindowIndex);
Screen('Flip', WindowIndex);% Flip to clear
ifi = Screen('GetFlipInterval', WindowIndex);% Query the frame duration
Screen('TextSize', WindowIndex, 40);% Set the text size
[xCenter, yCenter] = RectCenter(WindowIndexRect);

%% Instructions
DrawFormattedText(WindowIndex, 'PART 1: This experiment will have you compare and ', 10, 200, WHITE);
DrawFormattedText(WindowIndex, 'rate how similar two faces are. '...
    , 10, 250, WHITE);
DrawFormattedText(WindowIndex, 'You will be shown two faces at the same ', 10, 350, WHITE);
DrawFormattedText(WindowIndex, 'time and your task is to fixate on the cross and  ', 10, 400, WHITE);
DrawFormattedText(WindowIndex, 'rate how SIMILAR or DIFFERENT the two faces are.', 10, 450, WHITE);
DrawFormattedText(WindowIndex, 'The faces will either be Asian, or Caucasian.', 10, 500, WHITE);

DrawFormattedText(WindowIndex, 'Press SPACE BAR to go to the next screen of instructions.', 10, 600, WHITE);



Screen('Flip', WindowIndex);
WaitSecs(0.2);
KbWait;

DrawFormattedText(WindowIndex, 'You will be rating the faces from 1 to 7 using the keyboard'...
    , 10, 200, WHITE);
DrawFormattedText(WindowIndex, 'with 1 meaning the expressions are EXTREMELY DIFFERENT'...
    , 10, 250, WHITE);
DrawFormattedText(WindowIndex, 'and 7 meaning the expressions are EXTREMELY SIMILAR.' ...
    , 10, 300, WHITE);
DrawFormattedText(WindowIndex, 'You only need to respond when the you see the faces.' ...
    , 10, 350, WHITE);
DrawFormattedText(WindowIndex, 'Please use the full range of numbers between 1 and 7.'...
    , 10, 450, WHITE);
DrawFormattedText(WindowIndex, 'When you are ready, press SPACE BAR to the next screen of instructions.'...
    , 10, 550, WHITE);
%    DrawFormattedText(WindowIndex, 'TEST TEST TEST TEST', 0, 700, WHITE);


Screen('Flip', WindowIndex);
WaitSecs(0.2);
KbWait;

%% Setting up output matrices
pInput = [];
responseTime = [];

%% Experimental Routine
quit = 0;
trialtime = [];
blocktime = [];

for block = 1:1;
    block;
    bstart = GetSecs;
    
    DrawFormattedText(WindowIndex, 'TRAINING'...
        , 10, 200, WHITE);
    DrawFormattedText(WindowIndex, 'We will begin with a few training trials to get you used to the experiment.'...
        , 10, 300, WHITE);
    DrawFormattedText(WindowIndex, 'Reminder: 1 = VERY different; 7 = VERY similar.' ...
        , 10, 350, WHITE);
    DrawFormattedText(WindowIndex, 'Press SPACE BAR to begin the training.' ...
        , 10, 450, WHITE);
    
    
    Screen('Flip', WindowIndex);
    WaitSecs(0.2);
    KbWait;
    
    Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);
    Screen('Flip', WindowIndex);
    WaitSecs(FIXATION1*5)
    
    if block == 1
        
        
        for training_trial = 1:size(trainingPairs, 1)
            
            % White noise mask
            noise = imread('img_noise_1.png')
            
            %Fixation cross
             Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);
            Screen('Flip', WindowIndex);
            WaitSecs(FIXATION1)
            
            noiseIm = Screen('MakeTexture', WindowIndex, noise);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            
            Screen('Flip', WindowIndex);
            WaitSecs(0.2);
            
            
            asianFolder = ['C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\'];

            dispstart = GetSecs;
                                
            %DIsplaying faces
            
            resptobemade = 1;
            stim1 = imread((fullfile(asianFolder, [num2str(trainingPairs(training_trial, 1)), '.png'])));            
            stim2 = imread((fullfile(asianFolder, [num2str(trainingPairs(training_trial, 2)), '.png'])));
            stimImage1 = Screen('MakeTexture', WindowIndex, stim1);
            stimImage2 = Screen('MakeTexture', WindowIndex, stim2);
            

            Screen('DrawTexture', WindowIndex, stimImage1, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, stimImage2, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);

            Screen('Flip', WindowIndex);
            tStart = GetSecs;
             
%             Screen ('Close', stimImage1)
%             Screen ('Close', stimImage2)
            
            KbWait;   
            
            while resptobemade == 1;
                
                [keyIsDown,secs, keyCode] = KbCheck;
                
                if keyCode(breakKey)
                    quit = 1;
                    break;
                elseif keyCode(oneKey)
                    response = 1;
                    resptobemade = 0;
                elseif keyCode(twoKey)
                    response = 2;
                    resptobemade = 0;
                elseif keyCode(threeKey)
                    response = 3;
                    resptobemade = 0;
                elseif keyCode(fourKey)
                    response = 4;
                    resptobemade = 0;
                elseif keyCode(fiveKey)
                    response = 5;
                    resptobemade = 0;
                elseif keyCode(sixKey)
                    response = 6;
                    resptobemade = 0;
                elseif keyCode(sevenKey)
                    response = 7;
                    resptobemade = 0;
                elseif keyCode(spaceKey)
                    resptobemade = 1;
                end
            end
            
            tEnd = GetSecs;
            
            % Clearing Images to avoid any lag issues
            
            Screen ('Close', stimImage1);
            Screen ('Close', stimImage2);

            rt = tEnd-tStart;
            responseTime(block, training_trial) = rt;
            pInput(block, training_trial) = response;
            
            
            WaitSecs(FIXATION1);
            
            
            if quit
                break;
            end
            
        end
    end
    
    WaitSecs(FIXATION1);
    
    if quit
        break;
    end
    
    DrawFormattedText(WindowIndex, 'END OF TRAINING'...
        , 10, 200, WHITE);
    DrawFormattedText(WindowIndex, 'Reminder: 1 = VERY; different 7 = VERY similar.'...
        , 10, 350, WHITE);
    DrawFormattedText(WindowIndex, 'If you feel ready for the experiment'...
        , 10, 250, WHITE);
    DrawFormattedText(WindowIndex, 'press SPACE BAR to start. '...
        , 10, 300, WHITE);
    
    
    Screen('Flip', WindowIndex);
    WaitSecs(0.2);
    KbWait;
    
    
    %% block 1
    for trial_number = 1:87
        
        trial_number
        tStart = GetSecs;
        
           % White noise mask
            noise = imread('img_noise_1.png')
            
            %Fixation cross
             Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);
            Screen('Flip', WindowIndex);
            WaitSecs(FIXATION1)
            
            noiseIm = Screen('MakeTexture', WindowIndex, noise);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            
            Screen('Flip', WindowIndex);
            WaitSecs(0.2);
            
            
            asianFolder = ['C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\'];

            dispstart = GetSecs;
            
            %Displaying faces
            
            resptobemade = 1;
            stim1 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 1)), '.png'])));            
            stim2 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 2)), '.png'])));
            stimImage1 = Screen('MakeTexture', WindowIndex, stim1);
            stimImage2 = Screen('MakeTexture', WindowIndex, stim2);
            

            Screen('DrawTexture', WindowIndex, stimImage1, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, stimImage2, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);

            Screen('Flip', WindowIndex);
            tStart = GetSecs;
            
%             Screen ('Close', stimImage1)
%             Screen ('Close', stimImage2)
            
            KbWait;
        
        while resptobemade == 1;
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if keyCode(breakKey)
                quit = 1;
                break;
            elseif keyCode(oneKey)
                response = 1;
                resptobemade = 0;
            elseif keyCode(twoKey)
                response = 2;
                resptobemade = 0;
            elseif keyCode(threeKey)
                response = 3;
                resptobemade = 0;
            elseif keyCode(fourKey)
                response = 4;
                resptobemade = 0;
            elseif keyCode(fiveKey)
                response = 5;
                resptobemade = 0;
            elseif keyCode(sixKey)
                response = 6;
                resptobemade = 0;
            elseif keyCode(sevenKey)
                response = 7;
                resptobemade = 0;
            elseif keyCode(spaceKey)
                resptobemade = 1;
            end
        end
        
        tEnd = GetSecs;
        
        rt = tEnd-tStart;
        responseTime(block, trial_number) = rt;
        pInput(block, trial_number) = response;
        
        
        WaitSecs(FIXATION1);
        
        
        if quit
            break;
        end
        
        
        
    end
    
    DrawFormattedText(WindowIndex, 'Break! Finished block 1/10.'...
        , 10, 200, GREEN);
    DrawFormattedText(WindowIndex, 'Please press Space Bar to continue.'...
        , 10, 250, GREEN);
    
    Screen('Flip', WindowIndex);
    WaitSecs(0.2);
    KbWait;
    
    %% block 2
    for trial_number = 88:174
        
        trial_number
        tStart = GetSecs;
                 
            % White noise mask
            noise = imread('img_noise_1.png')
            
            %Fixation cross
             Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);
            Screen('Flip', WindowIndex);
            WaitSecs(FIXATION1)
            
            noiseIm = Screen('MakeTexture', WindowIndex, noise);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            
            Screen('Flip', WindowIndex);
            WaitSecs(0.2);
            
            
            asianFolder = ['C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\'];

            dispstart = GetSecs;       
            
            %Displaying faces
            
            resptobemade = 1;
            stim1 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 1)), '.png'])));            
            stim2 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 2)), '.png'])));
            stimImage1 = Screen('MakeTexture', WindowIndex, stim1);
            stimImage2 = Screen('MakeTexture', WindowIndex, stim2);
            

            Screen('DrawTexture', WindowIndex, stimImage1, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, stimImage2, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);

            Screen('Flip', WindowIndex);
            tStart = GetSecs;
        
        KbWait;
        
        while resptobemade == 1;
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if keyCode(breakKey)
                quit = 1;
                break;
            elseif keyCode(oneKey)
                response = 1;
                resptobemade = 0;
            elseif keyCode(twoKey)
                response = 2;
                resptobemade = 0;
            elseif keyCode(threeKey)
                response = 3;
                resptobemade = 0;
            elseif keyCode(fourKey)
                response = 4;
                resptobemade = 0;
            elseif keyCode(fiveKey)
                response = 5;
                resptobemade = 0;
            elseif keyCode(sixKey)
                response = 6;
                resptobemade = 0;
            elseif keyCode(sevenKey)
                response = 7;
                resptobemade = 0;
            elseif keyCode(spaceKey)
                resptobemade = 1;
            end
        end
        
        tEnd = GetSecs;
        
        rt = tEnd-tStart;
        responseTime(block, trial_number) = rt;
        pInput(block, trial_number) = response;
        
        
        
        WaitSecs(FIXATION1);
        
        
        if quit
            break;
        end
        
        
        
    end
    
    DrawFormattedText(WindowIndex, 'Break! Finished block 2/10.'...
        , 10, 200, GREEN);
    DrawFormattedText(WindowIndex, 'Please press Space Bar to continue.'...
        , 10, 250, GREEN);
    
    Screen('Flip', WindowIndex);
    WaitSecs(0.2);
    KbWait;
    %% block 3
    for trial_number = 175:261
        
        trial_number
        tStart = GetSecs;
            
          % White noise mask
            noise = imread('img_noise_1.png')
            
            %Fixation cross
             Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);
            Screen('Flip', WindowIndex);
            WaitSecs(FIXATION1)
            
            noiseIm = Screen('MakeTexture', WindowIndex, noise);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            
            Screen('Flip', WindowIndex);
            WaitSecs(0.2);
            
            
            asianFolder = ['C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\'];

            dispstart = GetSecs;
            
            %Displaying faces
            
            resptobemade = 1;
            stim1 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 1)), '.png'])));            
            stim2 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 2)), '.png'])));
            stimImage1 = Screen('MakeTexture', WindowIndex, stim1);
            stimImage2 = Screen('MakeTexture', WindowIndex, stim2);
            

            Screen('DrawTexture', WindowIndex, stimImage1, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, stimImage2, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);

            Screen('Flip', WindowIndex);
            tStart = GetSecs;
        
        KbWait;
        
        while resptobemade == 1;
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if keyCode(breakKey)
                quit = 1;
                break;
            elseif keyCode(oneKey)
                response = 1;
                resptobemade = 0;
            elseif keyCode(twoKey)
                response = 2;
                resptobemade = 0;
            elseif keyCode(threeKey)
                response = 3;
                resptobemade = 0;
            elseif keyCode(fourKey)
                response = 4;
                resptobemade = 0;
            elseif keyCode(fiveKey)
                response = 5;
                resptobemade = 0;
            elseif keyCode(sixKey)
                response = 6;
                resptobemade = 0;
            elseif keyCode(sevenKey)
                response = 7;
                resptobemade = 0;
            elseif keyCode(spaceKey)
                resptobemade = 1;
            end
        end
        
        tEnd = GetSecs;
        
        rt = tEnd-tStart;
        responseTime(block, trial_number) = rt;
        pInput(block, trial_number) = response;
        
        
        WaitSecs(FIXATION1);
        
        if quit
            break;
        end
        
        
        
    end
    
    DrawFormattedText(WindowIndex, 'Break! Finished block 3/10.'...
        , 10, 200, GREEN);
    DrawFormattedText(WindowIndex, 'Please press Space Bar to continue.'...
        , 10, 250, GREEN);
    
    Screen('Flip', WindowIndex);
    WaitSecs(0.2);
    KbWait;
    %% block 4
    for trial_number = 262:348
        
        trial_number
        tStart = GetSecs;
            
          % White noise mask
            noise = imread('img_noise_1.png')
            
            %Fixation cross
             Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);
            Screen('Flip', WindowIndex);
            WaitSecs(FIXATION1)
            
            noiseIm = Screen('MakeTexture', WindowIndex, noise);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            
            Screen('Flip', WindowIndex);
            WaitSecs(0.2);
            
            
            asianFolder = ['C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\'];

            dispstart = GetSecs;
            
            %Displaying faces
            
            resptobemade = 1;
            stim1 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 1)), '.png'])));            
            stim2 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 2)), '.png'])));
            stimImage1 = Screen('MakeTexture', WindowIndex, stim1);
            stimImage2 = Screen('MakeTexture', WindowIndex, stim2);
            

            Screen('DrawTexture', WindowIndex, stimImage1, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, stimImage2, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);

            Screen('Flip', WindowIndex);
            tStart = GetSecs;
        
        KbWait;
        
        while resptobemade == 1;
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if keyCode(breakKey)
                quit = 1;
                break;
            elseif keyCode(oneKey)
                response = 1;
                resptobemade = 0;
            elseif keyCode(twoKey)
                response = 2;
                resptobemade = 0;
            elseif keyCode(threeKey)
                response = 3;
                resptobemade = 0;
            elseif keyCode(fourKey)
                response = 4;
                resptobemade = 0;
            elseif keyCode(fiveKey)
                response = 5;
                resptobemade = 0;
            elseif keyCode(sixKey)
                response = 6;
                resptobemade = 0;
            elseif keyCode(sevenKey)
                response = 7;
                resptobemade = 0;
            elseif keyCode(spaceKey)
                resptobemade = 1;
            end
        end
        
        tEnd = GetSecs;
        
        rt = tEnd-tStart;
        responseTime(block, trial_number) = rt;
        pInput(block, trial_number) = response;
        
        
        WaitSecs(FIXATION1);
        
        if quit
            break;
        end
        
        
        
    end
    
    DrawFormattedText(WindowIndex, 'Break! Finished block 4/10.'...
        , 10, 200, GREEN);
    DrawFormattedText(WindowIndex, 'Please press Space Bar to continue.'...
        , 10, 250, GREEN);
    
    Screen('Flip', WindowIndex);
    WaitSecs(0.2);
    KbWait;
        %% block 5
    for trial_number = 349:435
        
        trial_number
        tStart = GetSecs;
            
          % White noise mask
            noise = imread('img_noise_1.png')
            
            %Fixation cross
             Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);
            Screen('Flip', WindowIndex);
            WaitSecs(FIXATION1)
            
            noiseIm = Screen('MakeTexture', WindowIndex, noise);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            
            Screen('Flip', WindowIndex);
            WaitSecs(0.2);
            
            
            asianFolder = ['C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\'];

            dispstart = GetSecs;
            
            %DIsplaying faces
            
            resptobemade = 1;
            stim1 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 1)), '.png'])));            
            stim2 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 2)), '.png'])));
            stimImage1 = Screen('MakeTexture', WindowIndex, stim1);
            stimImage2 = Screen('MakeTexture', WindowIndex, stim2);
            

            Screen('DrawTexture', WindowIndex, stimImage1, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, stimImage2, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);

            Screen('Flip', WindowIndex);
            tStart = GetSecs;
        
        KbWait;
        
        while resptobemade == 1;
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if keyCode(breakKey)
                quit = 1;
                break;
            elseif keyCode(oneKey)
                response = 1;
                resptobemade = 0;
            elseif keyCode(twoKey)
                response = 2;
                resptobemade = 0;
            elseif keyCode(threeKey)
                response = 3;
                resptobemade = 0;
            elseif keyCode(fourKey)
                response = 4;
                resptobemade = 0;
            elseif keyCode(fiveKey)
                response = 5;
                resptobemade = 0;
            elseif keyCode(sixKey)
                response = 6;
                resptobemade = 0;
            elseif keyCode(sevenKey)
                response = 7;
                resptobemade = 0;
            elseif keyCode(spaceKey)
                resptobemade = 1;
            end
        end
        
        tEnd = GetSecs;
        
        rt = tEnd-tStart;
        responseTime(block, trial_number) = rt;
        pInput(block, trial_number) = response;
        
        
        WaitSecs(FIXATION1);
        
        if quit
            break;
        end
        
        
        
    end
    
    DrawFormattedText(WindowIndex, 'Break! Finished block 5/10.'...
        , 10, 200, GREEN);
    DrawFormattedText(WindowIndex, 'You will now do a short block.'...
        , 10, 250, GREEN);
    DrawFormattedText(WindowIndex, 'Please press Space Bar to continue.'...
        , 10, 300, GREEN);
    
    Screen('Flip', WindowIndex);
    WaitSecs(0.2);
    KbWait;
 %% Consistency block
numFaces1 =30;
facePairs = nchoosek(1:numFaces1, 2);
shuffledFaces1 = facePairs(randperm(45),:);

    for trial_number = 1:45
        
        trial_number
        tStart = GetSecs;
        
            % White noise mask
            noise = imread('img_noise_1.png')
            
            %Fixation cross
             Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);
            Screen('Flip', WindowIndex);
            WaitSecs(FIXATION1)
            
            noiseIm = Screen('MakeTexture', WindowIndex, noise);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, noiseIm, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            
            Screen('Flip', WindowIndex);
            WaitSecs(0.2);
            
            
            asianFolder = ['C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\'];

            dispstart = GetSecs;
            
            %DIsplaying faces
            
            resptobemade = 1;
            stim1 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 1)), '.png'])));            
            stim2 = imread((fullfile(asianFolder, [num2str(shuffledFaces(trial_number, 2)), '.png'])));
            stimImage1 = Screen('MakeTexture', WindowIndex, stim1);
            stimImage2 = Screen('MakeTexture', WindowIndex, stim2);
            

            Screen('DrawTexture', WindowIndex, stimImage1, [], [xCenter-72*3 yCenter-100 xCenter-72 yCenter+100], 0);
            Screen('DrawTexture', WindowIndex, stimImage2, [], [xCenter+72 yCenter-100 xCenter+72*3 yCenter+100], 0);
            Screen('DrawLines', WindowIndex, crossLines, crossWidth, WHITE, [xCenter, yCenter]);

            Screen('Flip', WindowIndex);
            tStart = GetSecs;
            
%             Screen ('Close', stimImage1)
%             Screen ('Close', stimImage2)
            
            KbWait;
        
        while resptobemade == 1;
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if keyCode(breakKey)
                quit = 1;
                break;
            elseif keyCode(oneKey)
                response = 1;
                resptobemade = 0;
            elseif keyCode(twoKey)
                response = 2;
                resptobemade = 0;
            elseif keyCode(threeKey)
                response = 3;
                resptobemade = 0;
            elseif keyCode(fourKey)
                response = 4;
                resptobemade = 0;
            elseif keyCode(fiveKey)
                response = 5;
                resptobemade = 0;
            elseif keyCode(sixKey)
                response = 6;
                resptobemade = 0;
            elseif keyCode(sevenKey)
                response = 7;
                resptobemade = 0;
            elseif keyCode(spaceKey)
                resptobemade = 1;
            end
        end
        
        tEnd = GetSecs;
        
        rt = tEnd-tStart;
        responseTime(block, trial_number + 435) = rt;
        pInput(block, trial_number + 435) = response;
        
        
        WaitSecs(FIXATION1);
        
        
        if quit
            break;
        end
        
        
        
    end
    
    DrawFormattedText(WindowIndex, 'Finished Consistency block 1.'...
        , 10, 200, GREEN);
    DrawFormattedText(WindowIndex, 'Please press Space Bar to continue'...
        , 10, 250, GREEN);
    DrawFormattedText(WindowIndex, 'to the next part of the experiment.'...
        , 10, 300, GREEN);
    
    Screen('Flip', WindowIndex);
    WaitSecs(0.2);
    KbWait;    
    
    ListenChar(0);
end

%Save outputs%
mkdir('C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\Output\', [num2str(participantNumber)]);
outputFolder = ['C:\Users\shouramo\Desktop\Masters\ORE project\CFD images FINAL\norm_faces_asian\Output\', num2str(participantNumber)];
cd(outputFolder);
save('shuffledFaces.mat', 'shuffledFaces');
save('shuffledFaces1.mat', 'shuffledFaces1');
save('responseTime.mat', 'responseTime');
save('pInput.mat', 'pInput');

sca; 
% move on to the next section of the study (I spoke with one of hte
% instructors and they told me to only include the first section of my
% study, since the second section is identical, but with different stimuli%
ORE_white(participantNumber)

end



