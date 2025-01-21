% Example simulation results
% X and Y are matrices of size [numTimeSteps, 6]

[ numJoints, numTimeSteps] = size(out.Xlink.Data);
X = out.Xlink.Data;
Y = out.Ylink.Data;
Time = out.tout;
% Loop through each time step
for t = 1:1000:numTimeSteps
    plot5link(X(:,:,t), Y(:,:,t));
    pause(0.1); % Adjust pause for desired animation speed
    disp(Time(t))
end

% close all