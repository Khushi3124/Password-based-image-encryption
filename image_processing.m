image = imread('lena.jpg');

% Get the dimensions of the image
[rows, cols, channels] = size(image);
fprintf('The image has %d rows, %d columns, and %d color channels.\n', rows, cols, channels);

% Calculate the total number of pixels
pixels = rows * cols * channels;
disp('Total number of pixels:');
disp(pixels);

% Find the best dimensions for the 2D matrix
[nh, nw, min_diff] = find_best_dimensions(pixels);
fprintf('The minimum absolute difference is %f.\n', min_diff);
fprintf('The values of nh and nw are %d and %d, respectively.\n', nh, nw);

% Prompt the user for a password and derive the value of asc
password = input('Enter a password: ', 's');
password_ascii = double(password);
asc = sum(password_ascii) + 1; % Ensure asc is odd

% Create a new 2D matrix M with the specified rule
M = zeros(nh, nw);
for i = 1:nh
    for j = 1:nw
        if i + j == 0
            M(i, j) = mod(floor(asc / 1), 10); % Handle the division by zero case separately
        else
            M(i, j) = mod(floor(asc / (i * j)), 10);
        end
    end
end

%disp('New 2D matrix M:');
%disp(M);

% Reshape the image data into a 2D matrix of dimensions nh x nw
flattened_image = reshape(image, [], 1);

% Ensure the total number of elements matches nh * nw
if length(flattened_image) < nh * nw
    % Pad the flattened image with zeros if necessary
    flattened_image = [flattened_image; zeros(nh * nw - length(flattened_image), 1)];
elseif length(flattened_image) > nh * nw
    % Truncate the flattened image if necessary
    flattened_image = flattened_image(1:nh * nw);
end

% Reshape the 1D array into a 2D matrix
reshaped_matrix = reshape(flattened_image, nh, nw);

%disp('Reshaped 2D matrix:');
%disp(reshaped_matrix);

% Perform the substitution: substituted_matrix = (reshaped_matrix * M) mod 256
substituted_matrix = mod(double(reshaped_matrix) .* double(M), 256);
%disp('Substituted matrix:');
%disp(substituted_matrix);

% Interchange rows and columns of the substituted matrix
transposed_matrix = substituted_matrix';
%disp('Transposed matrix (rows and columns interchanged):');
%disp(transposed_matrix);

% Generate chaotic map sequence using logistic map
initial_seed = sum(double(password)) / length(password); % Derive initial seed from password
r = 3.99; % Logistic map parameter, must be in the range 3.57 < r < 4 for chaos

% Generate the chaotic sequence
chaotic_sequence = zeros(1, nh * nw);
chaotic_sequence(1) = initial_seed;
for k = 2:nh * nw
    chaotic_sequence(k) = r * chaotic_sequence(k-1) * (1 - chaotic_sequence(k-1));
end

% Convert the chaotic sequence to binary (0 or 1) using a threshold of 0.5
chaotic_sequence_binary = chaotic_sequence > 0.5;

% Reshape the binary chaotic sequence into a 2D matrix of dimensions nh x nw
chaotic_matrix = reshape(chaotic_sequence_binary, nh, nw);
%disp('Chaotic matrix (binary):');
%disp(chaotic_matrix);

% Implementing LFSR using the password
password_bin = de2bi(password_ascii, 8, 'left-msb')';
password_bin = password_bin(:)'; % Convert to a binary sequence
lfsr_len = nh * nw;
taps = [1, 3, 5, 7, 8]; % Example taps for an 8-bit LFSR

% Generate LFSR sequence
lfsr_seq = zeros(1, lfsr_len);
lfsr_state = password_bin(1:8); % Initial state of the LFSR

for k = 1:lfsr_len
    lfsr_seq(k) = lfsr_state(end);
    feedback = mod(sum(lfsr_state(taps)), 2);
    lfsr_state = [feedback, lfsr_state(1:end-1)];
end

% Reshape the LFSR sequence into a 2D matrix of dimensions nh x nw
lfsr_matrix = reshape(lfsr_seq, nh, nw);
%disp('LFSR matrix:');
%disp(lfsr_matrix);

% Perform XOR operation between LFSR matrix and chaotic matrix
xor_result_matrix = xor(lfsr_matrix, chaotic_matrix);
%disp('XOR result matrix:');
%disp(xor_result_matrix);

% Perform encryption: C = transposed_matrix XOR xor_result_matrix
encrypted_matrix = xor(transposed_matrix, xor_result_matrix);
%disp('Encrypted matrix:');
%disp(encrypted_matrix);

% Convert the encrypted matrix to binary image for display
binary_encrypted_image = uint8(encrypted_matrix * 255); % 1 -> 255 (white), 0 -> 0 (black)

% Display the encrypted binary image
imshow(binary_encrypted_image);
title('Encrypted Image (Binary)');

% Function to find the best dimensions for the 2D matrix
function [nh, nw, min_diff] = find_best_dimensions(pixels)
    min_diff = inf;
    nh = 0;
    nw = 0;
    for i = 1:pixels
        j = floor(pixels / i);
        diff = abs(i - j);
        if diff < min_diff
            min_diff = diff;
            nh = i;
            nw = j;
        end
    end
end

% Utility function to convert decimal to binary
function bin = de2bi(d, n, varargin)
    bin = fliplr(dec2bin(d, n) - '0');
end