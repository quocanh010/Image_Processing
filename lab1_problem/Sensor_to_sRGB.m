%Read Sensor Image
[cfa, info] = read_dng('lab1.dng')

%Linearized Sensor image
linearized_v = min(max(0, (cfa - info.black) / (info.white - info.black)), 1)

%Demosaic
img = uint8(linearized_v*255)
Demosaic = demosaic(img, info.bayer_type)
%Normalize demosaic
Demosaic = im2double(Demosaic)

%Read color checkboard
fileID = fopen('colorchecker.txt')
formatSpec = '%i\n'
color_24 = fscanf(fileID, formatSpec)
color_24 = reshape(color_24, 3, 24)
color_24 = color_24'

% Read patch coordinates
fileID = fopen('patch_coor.txt')
formatSpec = '%i\n'
patch_24 = fscanf(fileID, formatSpec)
patch_24 = reshape(patch_24, 2, 96)
patch_24 = patch_24'

%Nomalize + Linearize batch color
color_24 = im2double(color_24)
color_24 = color_24 .^ (2.2)
%Get Device colors by extracting patches info and average them
device_color = zeros([24,3])
for i = 1:24
    x_s = max(patch_24(i, 1), patch_24(i + 3, 1)) % horizontal staring point of the rectagular region
    x_e = x_s + min(patch_24(i+1, 1) - patch_24(i, 1), patch_24(i+2, 1) - patch_24(i + 3, 1)) % horiontal end point of the rectangular region
    y_s = max(patch_24(i, 2), patch_24(i + 1, 2)) % vertical start of the retagular
    y_e = y_s + min(patch_24(i+3, 2) - patch_24(i, 2), patch_24(i+2, 2) - patch_24(i+1, 2))  % vertical end of teh rectangular
    patch_i = Demosaic(y_s : y_e, x_s : x_e, :)
    device_color(i, 1) = mean2(patch_i(:,:,1))
    device_color(i, 2) = mean2(patch_i(:,:,2))
    device_color(i, 3) = mean2(patch_i(:,:,3))
end
        