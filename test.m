seed = 42; % random seed for reproduce numerical experienment
prop = 0.1; % porposion of noise
truedata = @(x) cos(sin(x)) + x;
[y, x, o] = GenerateSample(truedata, prop, seed);
% Parameters for denoising
alpha = 0.1;  % Regularization parameter for smoothness
beta = 0.01;   % Regularization parameter for sparsity of the outlier term 'o'
rho = 0.9;    % Step size reduction factor in iterative optimization
g = 0.1;      % Parameter for the Huber function, affects robustness
max_iter = 1000; % Maximum number of iterations
tol = 0.9; %termination parameter

% Perform denoising
[x_denoised, o_denoised] = denoising(beta, y, max_iter, g, rho, alpha,tol);
% Plot the true data, denoised data, and noise
% First plot: original function vs x_denoised
figure;
plot(x, truedata(x), '-r', 'DisplayName', 'True Data');  % True underlying function
hold on;
scatter(x, x_denoised, 'g', 'filled', 'DisplayName', 'x denoised');  
plot(x, y, 'o', 'DisplayName', 'Noisy Data'); 
legend show;
xlabel('Input x');
ylabel('Output y');
title('Comparison of True Data and x_denoised');
saveas(gcf, 'x.png'); % Save as PNG

% Second plot: original o vs o_denoised
figure;
plot(x, o, 'o', 'DisplayName', 'Original o');  % Assuming you have the original o
hold on;
scatter(x, o_denoised, 'b*', 'DisplayName', 'o denoised');  
legend show;
xlabel('Input x');
ylabel('Output o');
title('Comparison of Original o and o_denoised');
saveas(gcf, 'o.png'); % Save as PNG