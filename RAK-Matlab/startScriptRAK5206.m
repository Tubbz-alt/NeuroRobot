clear mex;
clear all;
close all;
clear functions;

if ~exist('RAK5206.mexw64', 'file')
%     mex RAK5206.cpp -IC:\boost_1_68_0 -LC:\boost_1_68_0\stage\lib -LC:\ffmpeg-4.1-win64-dev\lib -IC:\ffmpeg-4.1-win64-dev\include -lavcodec -lavformat -lavutil -lswscale -llibboost_system-vc141-mt-x64-1_68 -llibboost_chrono-vc141-mt-x64-1_68 -D_WIN32_WINNT=0x0A00
%     mex RAK5206.cpp -IC:\boost_1_69_0 -LC:\boost_1_69_0\stage\lib -LC:\ffmpeg-4.1.1-win64-dev\lib -IC:\ffmpeg-4.1.1-win64-dev\include -lavcodec -lavformat -lavutil -lswscale -llibboost_system-vc141-mt-x64-1_69 -llibboost_chrono-vc141-mt-x64-1_69 -D_WIN32_WINNT=0x0A00
%     mex RAK5206.cpp -I/usr/local/include -L/usr/local/lib -lboost_system -lboost_chrono -lboost_thread-mt -lavcodec -lavformat -lavutil -lswscale
%     mex RAK5206.cpp -I/usr/local/Cellar/boost/1.69.0_2/include -I/ffmpeg-custom/include -L/usr/local/Cellar/boost/1.69.0_2/lib -L/ffmpeg-custom/lib -lboost_system -lboost_chrono -lboost_thread-mt -lavcodec -lavformat -lavutil -lswscale
    mex RAK5206.cpp -IC:\boost_1_69_0 -LC:\boost_1_69_0\stage\lib -Llibraries\windows\ffmpeg\bin -Ilibraries\windows\ffmpeg\include -lavcodec -lavformat -lavutil -lswscale -llibboost_system-vc141-mt-x64-1_69 -llibboost_chrono-vc141-mt-x64-1_69 -D_WIN32_WINNT=0x0A00
end

if ~exist('rak', 'var')
    rak = RAK5206_matlab('192.168.100.1', '80');
end
rak.start();

% Init UI
fig1 = figure(1);
clf
set(fig1, 'position', [1 41 1536 800.8])
set(fig1, 'NumberTitle', 'off', 'Name', 'Neurorobot Matlab C++ WiFi RAK interface')
set(fig1, 'menubar', 'none', 'toolbar', 'none')
vid_ax = axes('position', [0.05 0.15 0.9 0.8]);
p1 = imshow(uint8(255* ones(720, 1280, 3)), []);
button_stop = uicontrol('Style', 'pushbutton', 'String', 'Stop', 'units', 'normalized', 'position', [0.4 0.05 0.2 0.05]);
set(button_stop, 'Callback', 'flag_run = 0;', 'FontSize', 18)

% Init data
audioMat = [];
serialData = [];
flag_run = 1;
serialCounter = 0;
tempTimestamp = now;
frequency = 10;
deltaTime = (1/frequency)*0.0001;
ledCounter = 1;
ledOrder = [1 3 4 2 5 6];


% Recording delays
FileName = fullfile('delays.txt');
fid = fopen(FileName, 'w');
if fid == -1
  error('Cannot open file: %s', FileName);
end
startDurations = [];
videoDurations = [];
audioDurations = [];
writeSerialDurations = [];
sendAudioDurations = [];
receiveSerialDurations = [];
startTimings = [];
videoTimings = [];
audioTimings = [];
writeSerialTimings = [];
sendAudioTimings = [];
receiveSerialTimings = [];

while rak.isRunning() && flag_run
    
    startTimings = [startTimings; clock];
    
    % Video stream
    imageMat = rak.readVideo();
    imageMat = flip(permute(reshape(imageMat, 3, 1280, 720), [3,2,1]), 3);
    set(p1, 'CData', imageMat);
    drawnow limitrate
    videoTimings = [videoTimings; clock];
    
    % Audio stream
    audioMat = [audioMat rak.readAudio()];
    audioTimings = [audioTimings; clock];
    
    % Write serial
    rak.writeSerial('d:0;');
    rak.writeSerial(sprintf('d:%d11;', ledOrder(ledCounter)));
    ledCounter = ledCounter + 1;
    if ledCounter > numel(ledOrder)
        ledCounter = 1;
    end
    writeSerialTimings = [writeSerialTimings; clock];
    
    % Send audio
%     if mod(serialCounter - 10, 500) == 0
    if serialCounter == 10
%         t = 0 : 1/1000 : 5;
%         y = sin(6.28 * 8 * t);
%         y = [y y y y]';
%         rak.sendAudio2(y);
        rak.sendAudio('EXPLOSION.mp3');
    end
    sendAudioTimings = [sendAudioTimings; clock];
    
    % Receive serial
    serialData = [serialData rak.readSerial()];
    receiveSerialTimings = [receiveSerialTimings; clock];
    
    serialCounter = serialCounter + 1;
end

% Printing delays
for i = 1:length(videoTimings) - 1
    videoDurations(i) = etime(videoTimings(i,:), startTimings(i,:)) * 1000;
    fprintf(fid, 'video: %f\n',  videoDurations(i));
end
fprintf(fid, '\n');
for i = 1:length(audioTimings) - 1
    audioDurations(i) = etime(audioTimings(i,:), videoTimings(i,:)) * 1000;
    fprintf(fid, 'audio: %f\n', audioDurations(i));
end
fprintf(fid, '\n');
for i = 1:length(writeSerialTimings) - 1
    writeSerialDurations(i) = etime(writeSerialTimings(i,:), audioTimings(i,:)) * 1000;
    fprintf(fid, 'write serial: %f\n', writeSerialDurations(i));
end
fprintf(fid, '\n');
for i = 1:length(sendAudioTimings) - 1
    sendAudioDurations(i) = etime(sendAudioTimings(i,:), writeSerialTimings(i,:)) * 1000;
    fprintf(fid, 'send audio: %f\n', sendAudioDurations(i));
end
fprintf(fid, '\n');
for i = 1:length(receiveSerialTimings) - 1
    receiveSerialDurations(i) = etime(receiveSerialTimings(i,:), sendAudioTimings(i,:)) * 1000;
    fprintf(fid, 'receive serial: %f\n', receiveSerialDurations(i));
end
fprintf(fid, '\n');
fprintf(fid, 'average video: %f\n', mean(videoDurations));
fprintf(fid, 'average audio: %f\n', mean(audioDurations));
fprintf(fid, 'average write serial: %f\n', mean(writeSerialDurations));
fprintf(fid, 'average send audio: %f\n', mean(sendAudioDurations));
fprintf(fid, 'average receive serial: %f\n', mean(receiveSerialDurations));
fprintf(fid, '\ntotal average: %f\n', mean(videoDurations) + mean(audioDurations) + mean(writeSerialDurations) + mean(sendAudioDurations) + mean(receiveSerialDurations));
fprintf(fid, '\n');
fclose(fid);

rak.stop();
pause(2);
audiowrite('test.wav', audioMat, 8000);
close all;
serialData