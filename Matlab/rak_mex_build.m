
%% Chris' build prior to 6/14/2019
% mex RAK5206.cpp -IC:\boost_1_69_0 -LC:\boost_1_69_0\stage\lib -LC:\ffmpeg_mod\bin -IC:\ffmpeg_mod\include -lavcodec -lavformat -lavutil -lswscale -llibboost_system-vc141-mt-x64-1_69 -llibboost_chrono-vc141-mt-x64-1_69 -D_WIN32_WINNT=0x0A00

%% Chris' build after 6/14/2019
% mex RAK5206.cpp -IC:\boost_1_69_0 -LC:\boost_1_69_0\stage\lib -LC:\ffmpeg_mod2\bin -IC:\ffmpeg_mod2\include -lavcodec -lavformat -lavutil -lswscale -llibboost_system-vc141-mt-x64-1_69 -llibboost_chrono-vc141-mt-x64-1_69 -D_WIN32_WINNT=0x0A00

%% Chris' build after 8/17/2019
% mex RAK_MatlabBridge.cpp RAK5206.cpp SharedMemory.cpp Log.cpp VideoAndAudioObtainer.cpp Socket.cpp -IC:\boost_1_69_0 -LC:\boost_1_69_0\stage\lib -Llibraries\windows\ffmpeg\bin -Ilibraries\windows\ffmpeg\include -lavcodec -lavformat -lavutil -lswscale -llibboost_system-vc141-mt-x64-1_69 -llibboost_chrono-vc141-mt-x64-1_69 -D_WIN32_WINNT=0x0A00
mex RAK_MatlabBridge.cpp RAK5206.cpp SharedMemory.cpp Log.cpp VideoAndAudioObtainer.cpp Socket.cpp -IC:\boost_1_69_0 -LC:\boost_1_69_0\stage\lib -LC:\ffmpeg_mod2\bin -IC:\ffmpeg_mod2\include -lavcodec -lavformat -lavutil -lswscale -llibboost_system-vc141-mt-x64-1_69 -llibboost_chrono-vc141-mt-x64-1_69 -D_WIN32_WINNT=0x0A00