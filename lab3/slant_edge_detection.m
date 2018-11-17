
img = imread('slant_edge.tif');
img = im2double(img);
m = mean(img, 'all');
x = zeros(64, 1);
y = zeros(64, 1);
[Gx,~] = imgradientxy(img);
for yi = 1:64
    for xi = 1:64
        if(Gx(yi,xi) > m/2)
            break
        end
    end
    x(yi,1) = xi;
    y(yi,1) = yi;
end

p = polyfit(y,x,1)
f = polyval(p,y);
figure;
imshow(img);
hold on;
plot(int8(f),y,'Color', 'r', 'LineStyle', '-');
