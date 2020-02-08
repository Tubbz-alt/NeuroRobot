try
    serial_receive = rak_cam.readSerial();
%     disp(serial_receive)
    % this may need to read all available somehow or sensory input will pile up   
    if ~isempty(serial_receive)
        if(length(serial_receive)>=24)   
            these_vals = str2num(serial_receive(1:24));
            if ~isempty(these_vals)
                this_duration = these_vals(3);
                this_distance = (this_duration/2) / 29.1;
                this_distance(this_distance == 0) = 300;
            else
                disp('Empty serial values after str2num')
                this_distance = 300;
            end
        else
            disp('rak serial < 24 samples')
            this_distance = 300;
        end
    else
        this_distance = 300;
        if ~rem(nstep, 40) 
            disp('rak_cam readSerial empty (displaying 1 of 40 errors)')
        end
    end
catch
    disp('Error reading serial')
end