function [y, x, o] = GenerateSample(func, proportion, seed)
    
    % Set the random seed for reproducibility
    rng(seed);
    
    % Number of data points
    num = 100;  % You can adjust this number according to your needs
    
    % Generate x values linearly spaced between 0 and 10
    x = linspace(0, 10, num);
    
    % Evaluate the function
    fx = func(x);
    
    % Generate outliers
    % Determine the number of outliers based on the proportion
    numOutliers = round(num * proportion);
    
    % Randomly select indices for the outliers
    outlierIndices = randperm(num, numOutliers);
    
    % Generate outlier magnitudes (can be adjusted for different outlier effects)
    o = zeros(size(x)); % Initialize outliers vector
    % Here we apply a random perturbation to the selected outliers
    o(outlierIndices) = randn(1, numOutliers) * 2; % Scale of outliers can be changed
    
    % Compute the output y, x with added outliers
    y = fx + o;

end