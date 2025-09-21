clc; clear; close all;

% --- User Inputs ---
carrierImageFile = 'Test3.jpg'; % Change to your carrier image filename
secretMessage = 'TOP SECRET CODE : 9a3G4Zmg%'; % Change your secret message here

% Read Carrier Image (grayscale or RGB)
carrierImg = imread(carrierImageFile);
if size(carrierImg,3) == 3
    carrierImgGray = rgb2gray(carrierImg);
else
    carrierImgGray = carrierImg;
end

imshow(carrierImgGray);
title('Original Carrier Image');

% Convert secret message to binary stream
msgBin = reshape(dec2bin(secretMessage, 8).'-'0', 1, []);
msgLength = length(msgBin);

% Check capacity
imageCapacity = numel(carrierImgGray);
if msgLength > imageCapacity
    error('Secret message too long to be hidden in this image.');
end

% Embed Secret Message using LSB substitution
stegoImg = carrierImgGray;
for i = 1:msgLength
    pixelVal = de2bi(stegoImg(i), 8);
    pixelVal(1) = msgBin(i); % Replace LSB with message bit
    stegoImg(i) = bi2de(pixelVal);
end

% Display stego image
figure;
imshow(stegoImg);
title('Stego Image with Hidden Message');

% Extract the secret message from stego image
extractedBits = zeros(1,msgLength);
for i = 1:msgLength
    pixelVal = de2bi(stegoImg(i), 8);
    extractedBits(i) = pixelVal(1);
end

% Convert binary to characters
extractedChars = char(bin2dec(reshape(char(extractedBits+'0'), 8, []).')).';

% Display secret messages
disp('Original Secret Message:');
disp(secretMessage);
disp('Extracted Secret Message:');
disp(extractedChars);

% Analysis - message similarity check
match = strcmp(secretMessage, extractedChars);
fprintf('Message Extraction %s\n', ternary(match, 'Successful', 'Failed'));

% Helper ternary function
function out = ternary(cond, valTrue, valFalse)
    if cond
        out = valTrue;
    else
        out = valFalse;
    end
end