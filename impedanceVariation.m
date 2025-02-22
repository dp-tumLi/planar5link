% Define time vector
t = linspace(0, 50, 1000);

% Initial, min, and max stiffness
K0 = 100;    % Initial stiffness (autonomous mode)
K_max = 100; % Maximum stiffness (autonomous)
K_min = 0;  % Minimum stiffness (user dragging)

% Adaptation parameters
alpha = 0.3;  % Rate at which K drops when force is applied
beta = 10.0;   % Rate at which K recovers when force is removed
gamma = 0.3;  % Controls how strongly torque influences adaptation

% Define external torque function (e.g., user applies force from 3s to 7s)
tau_h_fun = @(t) 10 * (t > 13 & t < 23.5); 

% Run the adaptive impedance function
K_profile = adaptive_impedance(t, K0, K_max, K_min, alpha, beta, gamma, tau_h_fun);

figure
subplot(2,1,1)
plot(t,tau_h_fun(t))
subplot(2,1,2)
plot(K_profile(:,1),K_profile(:,2));


function K = adaptive_impedance(t, K0, K_max, K_min, alpha, beta, gamma, tau_h_fun)
    % Solves differential equation for stiffness K variation over time
    % INPUTS:
    %   t        - Time vector (e.g., linspace(0, 10, 100))
    %   K0       - Initial stiffness value
    %   K_max    - Maximum stiffness (autonomous mode)
    %   K_min    - Minimum stiffness (user-drag mode)
    %   alpha    - Adaptation rate (pulls towards K_min when user applies force)
    %   beta     - Recovery rate (pulls towards K_max when force is removed)
    %   gamma    - Scaling factor for exponential recovery based on torque
    %   tau_h_fun - Function handle for external torque tau_h(t)
    %
    % OUTPUT:
    %   K        - Stiffness profile over time

    % Define the stable differential equation
    dKdt = @(t, K) -alpha * (K - K_min)*(abs(tau_h_fun(t)) > 0) + beta * (K_max - K) * exp(-gamma * abs(tau_h_fun(t)));

    % Solve the ODE using ode45
    [T, K_vals] = ode45(dKdt, t, K0);

    % Plot the stiffness variation
    figure;
    plot(T, K_vals, 'b', 'LineWidth', 2);
    xlabel('Time (s)');
    ylabel('Stiffness K');
    title('Stable Adaptive Impedance Variation');
    grid on;

    % Return stiffness values
    K = [T, K_vals];
end

