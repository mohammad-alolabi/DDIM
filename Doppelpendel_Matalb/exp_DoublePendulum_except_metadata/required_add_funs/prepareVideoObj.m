function [vidObj,t_grid_video,VideoFPS_actual] = prepareVideoObj(t,options)

arguments
    %mandatory
        t
    %optional
        options.VideoFPS     = 30; % frames per second
        options.VideoSpeed   = 1;
        options.VideoTitle   = 'Animation';
        options.VideoQuality = 95;
        options.VideoFormat  = 'Motion JPEG AVI'; %'MPEG-4';
end
struct2CallerWS(options)

DataFPS         = VideoFPS/VideoSpeed;
T               = t(end)-t(1);
n_frames        = ceil(DataFPS*T);
DataFPS_actual  = n_frames/T;
VideoFPS_actual = DataFPS_actual*VideoSpeed;
t_grid_video    = linspace(t(1),t(end),n_frames);

vidObj = VideoWriter(VideoTitle,VideoFormat);
set(vidObj, 'Quality',VideoQuality, 'FrameRate',VideoFPS_actual);

end
