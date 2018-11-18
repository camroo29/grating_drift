
function DriftDemo

% DriftDemo
% Original code was developed by PTB-3 http://psychtoolbox.org/
% I have developed the original code to drift the grating with the
% movement of the mouse throughout the entire monitor.
% The drift of the grating helps to monitor the ratinal response of
% experiment animal.

try
    AssertOpenGL;
    
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    white=WhiteIndex(screenNumber);
    black=BlackIndex(screenNumber);
    
    gray=round((white+black)/2);
    
    if gray == white
        gray=white / 2;
    end
    
    inc=white-gray;
    
    % Open a double buffered fullscreen window and select a gray background
    w = Screen('OpenWindow',screenNumber, gray);
    
    [width, height] = Screen('WindowSize', screenNumber);
    
    % Compute each frame of the movie and convert the those frames, stored in
    % MATLAB matices, into Psychtoolbox OpenGL textures using 'MakeTexture';
    
    numFrames=5;
    
    [keyIsDown, secs, keyCode] = KbCheck;
    while ~keyCode(38)  % UP KEY
        [keyIsDown, secs, keyCode] = KbCheck;
        [a, b, buttons] = GetMouse;
        centreX = width/2 - a;
        centreY = height/2 - b;
        for i=1:numFrames
            phase=(i/numFrames)*2*pi;
            dim = 500; % related to dimension of the monitor 
            [x,y]= meshgrid(-dim + centreX:dim+centreX,-dim + centreY:dim + centreY);
            angle=30*pi/180; % 30 deg orientation.
            f=0.05*2*pi; % cycles/pixel
            a=cos(angle)*f;
            b=sin(angle)*f;
            m=exp(-((x/90).^2)-((y/90).^2)).*sin(a*x+b*y+phase);
            tex(i)=Screen('MakeTexture', w, round(gray+inc*m));
            Screen('DrawTexture', w, tex(i));
            Screen('Flip', w);
        end
    end
    Screen('Close');
    sca;
catch
    sca;
    Priority(0);
    psychrethrow(psychlasterror);
end 
