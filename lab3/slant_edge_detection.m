
img = imread('slant_edge.tif');
%img = im2double(img);
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

p = polyfit(y,x,1);
f = y * p(1) + p(2);
f = int8(f)
xi = 0:63;
figure;
imshow(img);
hold on;
plot(f,y,'Color', 'r', 'LineStyle', '-', 'LineWidth',3);
hold off;
xf = p(1) * y;
x_t = round(4 * (xi' - (xf)));
%Binning
bin_v = zeros(284, 1);
bin_c = zeros(284, 1);

for y_i = 1:64
    for x_i = 1:64
        x_c = round(4 * (x_i - p(1) * y_i));
        bin_v(x_c) = double(bin_v(x_c)) + double(img( y_i, x_i));
        bin_c(x_c) = bin_c(x_c) + 1;
    end
end

bin_avg = bin_v ./ bin_c;
ESF = bin_avg(4:259);
lin = diff(ESF, 1 , 1)/2;
plot(ESF);
plot(lin);
a = fft(lin);
SRF = (abs(a) - min(abs(a)))  / (max(abs(a)) - min(abs(a)));
x_a = 1:255;
x_a = (x_a - 1) * 4/ 254;

plot(x_a(1:127), SRF(1:127));
%plot(a);
%plot([0:4], abs(a));
