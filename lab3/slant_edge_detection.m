
img = imread('slant_edge.tif');
img = im2double(img);
m = mean(img, 'all');
x = zeros(64, 1);
y = zeros(64, 1);
% Gx = diff(img,1, 2);
[Gx,~] = imgradientxy(img);
for yi = 1:64
    for xi = 1:63
        if(Gx(yi,xi) > m/2)
            break
        end
    end
    x(yi,1) = xi;
    y(yi,1) = yi;
end

p = polyfit(y,x,1)
f = y * p(1) + p(2)
f = int8(f)
figure;
imshow(img);
hold on;
plot(f,y,'Color', 'r', 'LineStyle', '-', 'LineWidth',3);
hold off;
xf = p(1) * y;
x_t = round(4 * (x - xf));
%Binning
bin_v = x_t
for i = 1:64
    bin_v = bin_v + img(i,i);
end
bin_c = bin_v + 1;
bin_avg = bin_v / bin_c;
lin = diff(bin_avg,1 , 2)/2;
