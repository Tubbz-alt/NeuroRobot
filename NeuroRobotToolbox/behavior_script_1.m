
% Spin with tune

script_step_count = script_step_count + 1;

if script_step_count <= 20
%     left_forward = left_forward + (script_step_count * 2.5);
%     right_backward = right_backward + (script_step_count * 2.5);
%     speaker_tone = script_step_count * 200;
    just_red
elseif script_step_count > 20
%     left_forward = left_forward + (40 - script_step_count) * 2.5;
%     right_backward = right_backward + (40 - script_step_count) * 2.5; 
%     speaker_tone = (40 - script_step_count) * 200;
    just_off
end

if script_step_count > 40
    script_running = 0;
    script_step_count = 0;
end

% just_monkey
% just_red