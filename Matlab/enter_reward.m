
if run_button == 5
    
    % Command log
    if save_data_and_commands
        this_time = string(datetime('now', 'Format', 'yyyy-MM-dd-hh-mm-ss-ms'));
        command_log.entry(command_log.n).time = this_time;
        command_log.entry(command_log.n).action = 'enter reward';
        command_log.n = command_log.n + 1;
    end

    % Capture video and audio
    brain.rewarded_frames(nreward, :, :, :) = large_frame;
    brain.nrewarded_sounds(nreward, :) = this_audio; 
    
    % Display and update
    disp(horzcat('Dopamine reward :)'))
    run_button = 0;
    reward = 1;
    
end

if sum(da_rew_neurons(firing))
    reward = 1;
end

if reward
    set(button_reward, 'BackgroundColor', [0.75 1 0.5]);
else
    set(button_reward, 'BackgroundColor', [0.8 0.8 0.8]);
end


%%% SCRAP? %%%
%     col = [0.8 1 0.8];
%     button_reward.BackgroundColor = col;
%     status_ax.Color = col;
%     set(status_ax, 'xcolor', col, 'ycolor', col)
%     fig_design.Color = col;
%     if manual_controls
%         manual_control_title.BackgroundColor = col;
%     end

%     for ii = [1 0.8]
%         button_reward.BackgroundColor = [0.8 ii 0.8];
%         col = [(1.6- ii) 0.8 (1.6 - ii)] + 0.2;
%         status_ax.Color = col;
%         set(status_ax, 'xcolor', col, 'ycolor', col)
%         fig_design.Color = col;
%         if manual_controls
%             manual_control_title.BackgroundColor = col;
%         end          
%         pause(0.05)
%     end

