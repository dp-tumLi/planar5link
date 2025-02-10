function plot5link(x, y)
    % Inputs:
    % - x: A vector of x-coordinates of all link points [x0, x1, ..., x5].
    % - y: A vector of y-coordinates of all link points [y0, y1, ..., y5].

    % Declare persistent variables
    persistent fig links joints fixedPoint initialized
    
    if isempty(initialized) || ~isvalid(fig)
        % Initialize figure and plot objects on first execution or if the figure is invalid
        fig = figure('Name', 'Manipulator Animation', 'NumberTitle', 'off', 'Visible', 'on');
        hold on;
        axis equal;
        grid on;
        xlabel('X (m)');
        ylabel('Y (m)');
        title('Real-Time Manipulator Animation');
        xlim([-0.2 1.5]); % Adjust based on workspace size
        ylim([-0.2 1.5]);

        % Initialize links and joints
        linkColors = {'r', 'g', 'b', 'm', 'c'}; % Colors for the links
        links = gobjects(1, 5); % Preallocate plot handles
        for i = 1:5
            links(i) = plot([0, 0], [0, 0], 'LineWidth', 2, 'Color', linkColors{i});
        end
        joints = plot(zeros(1, 6), zeros(1, 6), 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');
        
        % Add a fixed point at the base
        fixedPoint = plot(x(7), y(7), 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % Red square marker

        % Mark initialization as done
        initialized = true;
    end

    % Update link positions
    for i = 1:5
        if isvalid(links(i))
            set(links(i), 'XData', [x(i), x(i+1)], 'YData', [y(i), y(i+1)]);
        end
    end

    % Update joint positions
    if isvalid(joints)
        set(joints, 'XData', x, 'YData', y);
    end

    % Ensure the fixed point remains unchanged
    if isvalid(fixedPoint)
        set(fixedPoint, 'XData', x(7), 'YData', y(7)); % Keep it fixed at the base
    end

    % Force MATLAB to update the figure
    drawnow limitrate;
end
