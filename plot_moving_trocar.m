
figure
subplot(2,1,1)
xdes = squeeze(out.xdes.Data)';  % Removes the singleton dimension (size 1)
xee = squeeze(out.xee.Data)';  
plot(out.tout,xdes-xee(:,1:2))
ylabel("[m]")
legend("error-x","error-y")

subplot(2,1,2)
plot(out.tout,out.xc_proj.Data)
ylabel("[m]")
xlabel("Time [s]")
legend("x-proj-rcm")
%%

[ numJoints, numTimeSteps] = size(out.Xlink.Data);
X = out.Xlink.Data;
Y = out.Ylink.Data;
Time = out.tout;

% Figure setup
figure;
hold on;
xlabel('X (m)');
ylabel('Y (m)');
% title('Manipulator Trajectory Over Time');
% axis equal;
grid on;
xlim([-0.1 1]); % Adjust workspace limits if needed
ylim([-0.1 0.6]);

% Store TCP and trocar/RCM trajectories
tcp_trajectory = [];
trocar_trajectory = [];

% Loop through selected frames
for t = 1:50:numTimeSteps
    % Plot full manipulator trajectory for this frame
    plot(X(1:6, t), Y(1:6, t), 'Color', [0.75 0.75 0.75, 0.75]*0.5); % Gray transparent trajectory

    % Store TCP and trocar/RCM positions
%     tcp_trajectory = [tcp_trajectory; X(6, t), Y(6, t)];  % TCP point
    trocar_trajectory = [trocar_trajectory; X(7, t), Y(7, t)];  % Trocar/RCM point
end

% Plot final TCP and trocar trajectories
h1 = plot(X(6, :), Y(6, :), 'b-', 'LineWidth', 1.5, 'DisplayName', 'TCP Trajectory');
h2 = plot(trocar_trajectory(:,1), trocar_trajectory(:,2), 'rx', 'LineWidth', 1.5, 'DisplayName', 'Trocar/RCM Trajectory');
box on
% Add legend
legend([h1, h2], "tip","trocar");

% Save the final figure
% saveas(gcf, 'full_trajectory_plot.png');

















