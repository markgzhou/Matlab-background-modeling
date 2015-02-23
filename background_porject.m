% Author: Guanlong Zhou %
% University of Missouri - Columbia %
% Site: http://www.WhoIsLong.com %
% Eigen-background and W4 with dynamic update training %

clear all;
clc;
%Option values%
training_number = 18;
total = 211;
imgsizeX=480;
imgsizeY=640;
%Option values%


for i=1:training_number
    name0 = num2str(i);
    %disp (name);
    number='000';
    name0 =[number(1:(3-length(name0))) name0];
    name0 = [name0 '.jpg'];
    disp (['Reading Training File ' name0]);
    read = imread(name0);
    read = rgb2gray(read);
    X(:,i) = reshape(read,imgsizeY*imgsizeX,1);
end
meanIMG = sum(X')'/training_number;
%Training Finished, Get meanIMG -> gray img
meanIMG2= meanIMG;

A = double(X) - meanIMG*ones(1,training_number);
D = A'*A;
[th L] = eig(D);
w1 = A*th;
w = w1';
for i=training_number+1:total
    name1 = num2str(i);
    number='000';
    name1 =[number(1:(3-length(name1))) name1];
    filename = [name1 '.jpg'];
    ProcessImg = imread(filename);
    OriginIMG = imread(filename);
    
    disp (['Processing File ' filename]);
    
    figure(1);
    subplot(2,4,1);
    imshow(ProcessImg);
    title('Origin IMG');
    subplot(2,4,5);
    imshow(ProcessImg);
    title('Origin IMG');
    q = rgb2gray(ProcessImg);
    q = reshape(q,imgsizeY*imgsizeX,1);
    I = double(q) - meanIMG;
    Ip = w*I/1000000;
    Ir = w1*Ip;
    residue = I -Ir;
    background = reshape(residue,imgsizeX,imgsizeY);
    background = abs(background);
    Threshold = 0.10*255;
    background(background>=Threshold)=255;
    background(background<Threshold)=0;
    
    subplot(2,4,2);
    result1(:,:,1) = background;
    result1(:,:,2) = background;
    result1(:,:,3) = background;
    imshow(result1);
    title('Eigen-Background');
    
    
    Threshold2=0.0004*255;
    I2=double(q) - meanIMG2;
    residue2 = I2;
    background2 = reshape(I2/255,imgsizeX,imgsizeY);
    background2 = abs(background2);
    background2(background2>=Threshold2)=255;
    background2(background2<Threshold2)=0;
    I3=I2;
    I3(I3>0)=1;
    I3((I3<0))=-1;
    subplot(2,4,6);
    result4(:,:,1) = background2;
    result4(:,:,2) = background2;
    result4(:,:,3) = background2;
    imshow(result4);
    title('W4 with dynamic training');
    meanIMG2=meanIMG2+I3;
    
    
    
    
    se = strel('disk',50,4);
    %     Erosion and Dilation => Closing -- too slow
    %     darta=imdilate(background,se);
    %     episilon=imerode(darta,se);
    %     ForeGround2=episilon;
    
    ForeGround = imclose(background,se);
    ForeGround = uint8(ForeGround);
    
    
    
    result2(:,:,1) = ForeGround;
    result2(:,:,2) = ForeGround;
    result2(:,:,3) = ForeGround;
    subplot(2,4,3);
    imshow(result2);
    title('Eigen-Background & Dilation');
    
    ForeGround2 = imclose(background2,se);
    ForeGround2 = uint8(ForeGround2);
    result5(:,:,1) = ForeGround2;
    result5(:,:,2) = ForeGround2;
    result5(:,:,3) = ForeGround2;
    subplot(2,4,7);
    imshow(result5);
    title('W4 & Dilation');
    
    
    
    %     ProcessImg2(:,:,1) = ForeGround2;
    %     ProcessImg2(:,:,2) = ForeGround2;
    %     ProcessImg2(:,:,3) = ForeGround2;
    %     subplot(2,4,7);
    %     imshow(ProcessImg2);
    
    
    result3(:,:,1) = (ForeGround/255).*OriginIMG(:,:,1);
    result3(:,:,2) = (ForeGround/255).*OriginIMG(:,:,2);
    result3(:,:,3) = (ForeGround/255).*OriginIMG(:,:,3);
    subplot(2,4,4);
    imshow(result3);
    title('Result1');
    
    
    result6(:,:,1) = (ForeGround2/255).*OriginIMG(:,:,1);
    result6(:,:,2) = (ForeGround2/255).*OriginIMG(:,:,2);
    result6(:,:,3) = (ForeGround2/255).*OriginIMG(:,:,3);
    subplot(2,4,8);
    imshow(result6);
    title('Result2');
    
    
     Result = [OriginIMG result1 result2 result3; OriginIMG result4 result5 result6];
     newfile=['New' name1 '.jpg'];
     imwrite(Result,newfile);
end