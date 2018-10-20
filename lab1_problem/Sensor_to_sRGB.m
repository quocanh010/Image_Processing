%Read Sensor Image
[cfa, info] = read_dng('lab1.dng')

%Linearized Sensor image
linearized_v = min(max(0, (cfa - info.black) / (info.white - info.black)), 1)

%Demosaic
img = uint8(linearized_v*255)
Demosaic = demosaic(img, info.bayer_type)

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