% Generate 2D sample data
seed = 42; % random seed for reproduce numerical experiment
prop = 0.1; % proportion of noise
truedata = @(x, y) cos(sin(x))+sin(cos(y)); % True data for 2D, e^-(x^2 + y^2)

% Modify GenerateSample2D to handle 2D truedata
[y, x, o] = GenerateSample2D(truedata, prop, seed);

% Parameters for denoising
alpha = 0.005;  % Regularization parameter for smoothness
beta = 0.01;   % Regularization parameter for sparsity of the outlier term 'o'
rho = 0.9;    % Step size reduction factor in iterative optimization
g = 0.1;      % Parameter for the Huber function, affects robustness
max_iter = 1000; % Maximum number of iterations
tol = 0.9; % termination parameter

% Perform denoising
[x_denoised, o_denoised] = denoising_sparse(beta, y, max_iter, g, rho, alpha, tol, [length(x), 2]);

% Plot the true data, denoised data, and noise in 3D
% First plot: original function vs x_denoised
figure;
[X, Y] = meshgrid(linspace(-2*pi, 2*pi, sqrt(length(x))), linspace(-2*pi, 2*pi, sqrt(length(x))));
true_data = truedata(X, Y); % Evaluate true data
surf(X, Y, true_data); % Plot true data as a surface
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
plot3(X, Y, reshape(o, size(X)),'o', 'DisplayName', 'Original noise');  % Assuming you have the original o
hold on;
scatter3(x(:,1), x(:,2), o_denoised, 'b*', 'DisplayName', 'o denoised');  
legend show;
xlabel('Input x');
ylabel('Input y');
zlabel('Output z');
title('Comparison of Original o and o_denoised');
grid on;

% Save the second plot
saveas(gcf, 'comparison_original_denoised_o.png'); % Save as PNG

% Function to generate 2D sample data
function [y, x, o] = GenerateSample2D(truedata, proportion, seed)
    % Set the random seed for reproducibility
    rng(seed);
    
    % Number of data points
    n = 100; % Adjust the number of data points as needed
    [X, Y] = meshgrid(linspace(-2*pi, 2*pi, sqrt(n)), linspace(-2*pi, 2*pi, sqrt(n)));
    x = [X(:), Y(:)]; % Flatten the meshgrid into a list of points
    true_data = truedata(X, Y);
    
    % Generate outliers
    % Determine the number of outliers based on the proportion
    numOutliers = round(n * proportion);
    
    % Randomly select indices for the outliers
    outlierIndices = randperm(n, numOutliers);
    
    % Generate outlier magnitudes (can be adjusted for different outlier effects)
    o = zeros(size(true_data)); % Initialize outliers matrix
    % Here we apply a random perturbation to the selected outliers
    o(outlierIndices) = randn(1, numOutliers) * 2; % Scale of outliers can be changed
    
    % Compute the output y with added outliers
    y = true_data(:) + o(:);
    o = o(:);
end