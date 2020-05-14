%Project
%Urban rooftops detection by use png

clc;
close all;
clear all;

%read original Image
original_image=imread('imageRGB.png');
figure(1);
imshow(original_image);
title('original RGB image');

%Converted to Gray Image using rgb2gray function
gray_image=rgb2gray(original_image);
figure(2); 
imshow(gray_image);
title('converted to gray from RGB image');

%threshold values of the gray_image at one point
t1=gray_image>110 & gray_image<150;
%xor operation for two blackndwhite area open 
value1 = xor(bwareaopen(t1,1000),  bwareaopen(t1,2500));

%threshold values of the gray_image at second point
t2=gray_image>85 & gray_image<103;
%xor operation for two blackndwhite area open 
value2 = xor(bwareaopen(t2,1800),  bwareaopen(t2,2000));

%threshold values of the gray_image at third point
t3=gray_image>160 & gray_image<210;
%xor operation for two blackndwhite area open 
value3 = xor(bwareaopen(t3,500),  bwareaopen(t3,1700));

%threshold values of the gray_image at fourth point
t4=gray_image>155 & gray_image<175;
value4 = xor(bwareaopen(t4,500),  bwareaopen(t4,700));

bw=logical(value1+value2+value3+value4);
figure;
imshow(bw);
title('final logical expression');

%filling the holes using imfill function.
bw1=imfill(bw,'holes');
figure;
imshow(bw1);

%Erosion of the binary image using imerode funciton with the help of
%creating the structuring element between 10 and 45
%Eroding means seperating the images or reducing 
st1 = strel('line',10,45);  
e1 = imerode(bw1,st1);
figure, imshow(e1); 
title('Binary image after Erosion');

%Now collecting the parts again:
d1 = imdilate(e1,st1);  %regrowing the pieces again
figure, imshow(d1); 
title('Binary image after Dilation');

%creating the structuring element between 10 and 100
str3 = strel('line',10,100);
d2 = imdilate(d1,str3); %regrowing the pieces again
figure, imshow(d2);
title('Binary image after Dilation adding one more time');


%creating the structuring element between 5 and 10
str4 = strel('line',5,10);
d3 = imdilate(d2,str4);  %regrowing the pieces again
figure, imshow(d3);
title('Binary image after Dilation one more time');


%creating the structuring element between 10 and 10
str5= strel('line',10,10);
c = imclose(d3,str5); 
figure, imshow(c);
title('Binary image after Dilation one more time');

%filling holes using imfill function
e = imfill(c,'holes'); 
figure, imshow(e);
title('Filled holes');

%the below functions shows the image considering the original image
figure;
imshow(original_image);

[X,Y] = bwboundaries(e);
hold on
for k=1:length(X)
	boundary = X{k};
	plot(boundary(:,2), boundary(:,1),...
		'y-', 'LineWidth', 2)
end
title('Extracted Rooftops from the given Original Image')