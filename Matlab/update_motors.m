if bluetooth_present || rak_only

    motor_command = zeros(1, 5);
    left_forward = sum([sum(neuron_contacts(firing,6)) sum(neuron_contacts(firing,8))]) / 2;
    right_forward = sum([sum(neuron_contacts(firing,10)) sum(neuron_contacts(firing,12))]) / 2;
    left_backward = sum([sum(neuron_contacts(firing,7)) sum(neuron_contacts(firing,9))]) / 2;
    right_backward = sum([sum(neuron_contacts(firing,11)) sum(neuron_contacts(firing,13))]) / 2;
    
    left_torque = left_forward - left_backward;
    left_dir = max([1 - sign(left_torque) 1]);
    left_torque = abs(left_torque);
    left_torque(left_torque > 250) = 250;
    motor_command(1,3) = left_torque;
    motor_command(1,4) = left_dir;    

    right_torque = right_forward - right_backward;
    right_dir = max([1 - sign(right_torque) 1]);
    right_torque = abs(right_torque); 
    right_torque(right_torque > 250) = 250;
    motor_command(1,1) = right_torque;
    motor_command(1,2) = right_dir;
    
    these_speaker_neurons = neuron_contacts(:, 4) & firing;
    if sum(these_speaker_neurons)
        these_tones = neuron_tones(these_speaker_neurons, 1);
        these_tones(these_tones == 0) = [];
        speaker_tone = mean(these_tones);
        speaker_tone = round(speaker_tone * 0.0039); % the arduino currently needs an 8-bit number and will multiply by 256
    else
        speaker_tone = 0;
    end
    motor_command(1,5) = speaker_tone;
    
    if ~sum(motor_command(1, [1 3]))
        if manual_control == 1
            motor_command = [90 1 90 2 speaker_tone];
        elseif manual_control == 2
            motor_command = [90 2 90 1 speaker_tone];
        elseif manual_control == 3
            motor_command = [150 1 150 1 speaker_tone];
        elseif manual_control == 4 
            motor_command = [150 2 150 2 speaker_tone];
        elseif manual_control == 5
            motor_command = [0 0 0 0 speaker_tone];
        end
    end

    if rak_only
        r_torque = motor_command(1,1);
        r_dir = motor_command(1,2);
        r_send = horzcat('r:', num2str(r_torque * r_dir));
        rak_cam.writeSerial(r_send)
%         disp(horzcat('Send to RAK via serial: ', r_send))
        pause(0.01)
        l_torque = motor_command(1,3);
        l_dir = motor_command(1,4);
        l_send = horzcat('l:', num2str(l_torque * l_dir));
        rak_cam.writeSerial(l_send)
%         disp(horzcat('Send to RAK via serial: ', l_send))        
        pause(0.01)
    elseif ~isequal(motor_command, prev_motor_command)
        bluetooth_send_motor_command
        prev_motor_command = motor_command;
    end
    
end