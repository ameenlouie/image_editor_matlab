function image_editor()

clc;
clear global;
close all;

global originalImg editedImg;

% Create Figure
f = figure('Name','MATLAB Image Editor',...
    'NumberTitle','off',...
    'Position',[300 100 1000 600],...
    'Color',[0.9 0.9 0.9]);

% Axes for image display
ax = axes('Parent',f,'Units','pixels','Position',[250 100 700 450]);

% ================= BUTTONS =================

uicontrol('Style','pushbutton','String','Load Image',...
    'Position',[20 520 200 40],'FontSize',11,...
    'Callback',@loadImage);

uicontrol('Style','pushbutton','String','Save Image',...
    'Position',[20 470 200 40],'FontSize',11,...
    'Callback',@saveImage);

uicontrol('Style','pushbutton','String','Grayscale',...
    'Position',[20 420 200 40],'FontSize',11,...
    'Callback',@grayImage);

uicontrol('Style','pushbutton','String','Blur',...
    'Position',[20 370 200 40],'FontSize',11,...
    'Callback',@blurImage);

uicontrol('Style','pushbutton','String','Edge Detection',...
    'Position',[20 320 200 40],'FontSize',11,...
    'Callback',@edgeImage);

uicontrol('Style','pushbutton','String','Rotate 90°',...
    'Position',[20 270 200 40],'FontSize',11,...
    'Callback',@rotateImage);

uicontrol('Style','pushbutton','String','Reset',...
    'Position',[20 220 200 40],'FontSize',11,...
    'Callback',@resetImage);

% Brightness Slider
uicontrol('Style','text','String','Brightness',...
    'Position',[20 180 200 30],'FontSize',11);

brightnessSlider = uicontrol('Style','slider',...
    'Min',-100,'Max',100,'Value',0,...
    'Position',[20 150 200 30],...
    'Callback',@adjustBrightness);

% ================= FUNCTIONS =================

    function loadImage(~,~)
        [file,path] = uigetfile({'*.jpg;*.png;*.bmp'});
        if isequal(file,0)
            return;
        end
        img = imread(fullfile(path,file));
        originalImg = img;
        editedImg = img;
        imshow(img,'Parent',ax);
        title(ax,'Original Image');
    end

    function saveImage(~,~)
        if isempty(editedImg)
            return;
        end
        [file,path] = uiputfile('edited.png');
        if isequal(file,0)
            return;
        end
        imwrite(editedImg,fullfile(path,file));
        msgbox('Image Saved Successfully!');
    end

    function grayImage(~,~)
        if isempty(editedImg)
            return;
        end
        if size(editedImg,3) == 3
            editedImg = rgb2gray(editedImg);
            imshow(editedImg,'Parent',ax);
        end
    end

    function blurImage(~,~)
        if isempty(editedImg)
            return;
        end
        editedImg = imgaussfilt(editedImg,2);
        imshow(editedImg,'Parent',ax);
    end

    function edgeImage(~,~)
        if isempty(editedImg)
            return;
        end
        if size(editedImg,3) == 3
            gray = rgb2gray(editedImg);
        else
            gray = editedImg;
        end
        editedImg = edge(gray,'Canny');
        imshow(editedImg,'Parent',ax);
    end

    function rotateImage(~,~)
        if isempty(editedImg)
            return;
        end
        editedImg = imrotate(editedImg,90);
        imshow(editedImg,'Parent',ax);
    end

    function adjustBrightness(~,~)
        if isempty(originalImg)
            return;
        end
        val = round(get(brightnessSlider,'Value'));
        editedImg = originalImg + val;
        imshow(editedImg,'Parent',ax);
    end

    function resetImage(~,~)
        if isempty(originalImg)
            return;
        end
        editedImg = originalImg;
        imshow(originalImg,'Parent',ax);
        set(brightnessSlider,'Value',0);
    end

end
