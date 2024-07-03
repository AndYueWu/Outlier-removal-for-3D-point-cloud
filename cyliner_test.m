% Read the data from the file
data = readmatrix('/Users/yuewu/Documents/MSc project/cylinder_data/grooved_rail_left.txt');

% Create a 3D scatter plot of the point cloud
figure;
plot3(normalize(data(:, 1),'range'), normalize(data(:, 2),'range'), normalize(data(:, 3),'range'), 'k.'); % 'k.' specifies black color for the points
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Point Cloud Visualization');
grid on;

% Ensure the axes are equal
axis equal;

x = data(:, 1:2); % First two columns are x and y coordinates
y = data(:, 3);   % Third column is the z coordinate (observed data)

% Generate 2D true data function (adjust this if your true data model is different)
truedata = @(x, y) cos(sin(x))+sin(cos(y)); % True data for 2D, e^-(x^2 + y^2)

% Generate true data based on the provided x coordinates
true_data = truedata(x(:,1), x(:,2));

% Generate outliers (assuming noise is already in your data, we set o to zero)
o = zeros(size(y)); % No additional outliers as data is assumed noisy already

% Parameters for denoising
alpha = 0.005;  % Regularization parameter for smoothness
beta = 0.01;   % Regularization parameter for sparsity of the outlier term 'o'
rho = 0.9;    % Step size reduction factor in iterative optimization
g = 0.1;      % Parameter for the Huber function, affects robustness
max_iter = 1000; % Maximum number of iterations
tol = 0.9; % Termination parameter

% Perform denoising
[x_denoised, o_denoised] = denoising_sparse(beta, y, max_iter, g, rho, alpha, tol, [length(x), 2]);

% Plot the true data, denoised data, and noise in 3D
% First plot: original function vs x_denoised
figure;
scatter3(x(:,1), x(:,2), true_data, 'r', 'DisplayName', 'True Data'); % Plot true data as a scatter
hold on;
scatter3(x(:,1), x(:,2), x_denoised, 'g', 'filled', 'DisplayName', 'x denoised');  
scatter3(x(:,1), x(:,2), y, 'o', 'DisplayName', 'Noisy Data'); 
legend show;
xlabel('Input x');
ylabel('Input y');
zlabel('Output z');
title('Comparison of True Data and x_denoised');
grid on;

% Save the first plot
saveas(gcf, 'comparison_true_denoised.png'); % Save as PNG

% Second plot: original o vs o_denoised
figure;
scatter3(x(:,1), x(:,2), o, 'o', 'DisplayName', 'Original noise');  % Assuming you have the original o
hold on;
scatter3(x(:,1), x(:,2), o_denoised, 'b*', 'DisplayName', 'o denoised');  
legend show;
xlabel('Input x');
ylabel('Input y');
zlabel('Output z');
title('Comparison of Original o and o_denoised');
grid on;