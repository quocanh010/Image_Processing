%Read Sensor Image
[cfa, info] = read_dng('lab1.dng');

%Linearized Sensor image
linearized_v = min(max(0, (cfa - info.black) / (info.white - info.black)), 1);

%Demosaic(basically padding the RGB color so that there are 3 chanels)
img = uint16(linearized_v*2^16);
Demosaic = demosaic(img, info.bayer_type);
%Normalize demosaic
Demosaic = im2double(Demosaic);

%Read color checkboard
fileID = fopen('colorchecker.txt');
formatSpec = '%i\n';
color_24 = fscanf(fileID, formatSpec);
color_24 = reshape(color_24, 3, 24);
color_24 = color_24';

% Read patch coordinates
fileID = fopen('patch_coor.txt');
formatSpec = '%i\n';
patch_24 = fscanf(fileID, formatSpec);
patch_24 = reshape(patch_24, 2, 96);
patch_24 = patch_24';

%Nomalize + Linearize batch color
color_24 = color_24 / 255;
color_24 = color_24 .^ (2.2);
%Get Device colors by extracting patches info and average them
device_color = zeros([24,3]);
for i = 1:1:24
    x_s = max(patch_24((i-1) * 4 + 1, 1), patch_24((i-1) * 4 + 1 + 3, 1)) % horizontal staring point of the rectagular region
    x_e = x_s + min(patch_24((i-1) * 4 + 1+1, 1) - patch_24((i-1) * 4 + 1, 1), patch_24((i-1) * 4 + 1+2, 1) - patch_24((i-1) * 4 + 1 + 3, 1)) % horiontal end point of the rectangular region
    y_s = max(patch_24((i-1) * 4 + 1, 2), patch_24((i-1) * 4 + 1 + 1, 2)) % vertical start of the retagular
    y_e = y_s + min(patch_24((i-1) * 4 + 1 + 3, 2) - patch_24((i-1) * 4 + 1, 2), patch_24((i-1) * 4 + 1 + 2, 2) - patch_24((i-1) * 4 + 1+1, 2))  % vertical end of teh rectangular
    device_color(i, :) = mean(Demosaic(y_s : y_e, x_s : x_e, :), [1 2])
    %device_color(i, 1) = mean(Demosaic( : ,  : , 1))
    %device_color(i, 2) = mean(Demosaic( : ,  : , 2))
    %device_color(i, 2) = mean(Demosaic( : ,  : , 3))
end

% use Penseudoinverse 
%M = pinv(device_color) * color_24
M = inv(device_color' * device_color) * device_color' * color_24;
% Fatten the original matrix
Demosaic = reshape(Demosaic, [size(Demosaic,1) * size(Demosaic,2), 3]);
%Time the conversion matrix to get sRGB
sRGB_img = Demosaic * M;
%Reshape to creat image
sRGB_img = reshape(sRGB_img, [size(cfa,1), size(cfa,2), 3]);
%Gamma correction
%sRGB_img = lin2rgb(sRGB_img,'OutputType','double');
%Reshape to creat image
sRGB_img = reshape(real(sRGB_img), [size(cfa,1), size(cfa,2), 3]);
%Gamma corrected
sRGB_img = sRGB_img .^ (1/2.2);
imshow(sRGB_img);

        