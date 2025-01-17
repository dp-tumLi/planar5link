% Example simulation results
% X and Y are matrices of size [numTimeSteps, 6]

[ numJoints, numTimeSteps] = size(out.Xlink.Data);
X = out.Xlink.Data;
Y = out.Ylink.Data;
% Loop through each time step
for t = 1:50:numTimeSteps
    plot5link(X(:,:,t), Y(:,:,t));
    pause(0.1); % Adjust pause for desired animation speed
end

% close all