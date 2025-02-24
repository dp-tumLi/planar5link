% Symbolic variables
syms theta1 theta2 theta3 theta4 theta5 real
syms dtheta1 dtheta2 dtheta3 dtheta4 dtheta5 real
syms ddtheta1 ddtheta2 ddtheta3 ddtheta4 ddtheta5 real
syms l1 l2 l3 l4 l5 l5_general real % Link lengths
syms lc1 lc2 lc3 lc4 lc5 real % COM distances
syms m1 m2 m3 m4 m5 real % Masses
syms I1 I2 I3 I4 I5 real % Rotational inertias
syms g real % Gravitational acceleration

% Joint angle and velocity vectors
theta = [theta1; theta2; theta3; theta4; theta5];
dtheta = [dtheta1; dtheta2; dtheta3; dtheta4; dtheta5];

% Position of each link's center of mass (COM) in Cartesian coordinates
x1 = lc1 * cos(theta1);
y1 = lc1 * sin(theta1);

x2 = l1 * cos(theta1) + lc2 * cos(theta1 + theta2);
y2 = l1 * sin(theta1) + lc2 * sin(theta1 + theta2);

x3 = l1 * cos(theta1) + l2 * cos(theta1 + theta2) + lc3 * cos(theta1 + theta2 + theta3);
y3 = l1 * sin(theta1) + l2 * sin(theta1 + theta2) + lc3 * sin(theta1 + theta2 + theta3);

x4 = l1 * cos(theta1) + l2 * cos(theta1 + theta2) + l3 * cos(theta1 + theta2 + theta3) + lc4 * cos(theta1 + theta2 + theta3 + theta4);
y4 = l1 * sin(theta1) + l2 * sin(theta1 + theta2) + l3 * sin(theta1 + theta2 + theta3) + lc4 * sin(theta1 + theta2 + theta3 + theta4);

x5 = l1 * cos(theta1) + l2 * cos(theta1 + theta2) + l3 * cos(theta1 + theta2 + theta3) + l4 * cos(theta1 + theta2 + theta3 + theta4) + lc5 * cos(theta1 + theta2 + theta3 + theta4 + theta5);
y5 = l1 * sin(theta1) + l2 * sin(theta1 + theta2) + l3 * sin(theta1 + theta2 + theta3) + l4 * sin(theta1 + theta2 + theta3 + theta4) + lc5 * sin(theta1 + theta2 + theta3 + theta4 + theta5);

% Velocities of each COM
v1 = jacobian([x1; y1], theta) * dtheta;
v2 = jacobian([x2; y2], theta) * dtheta;
v3 = jacobian([x3; y3], theta) * dtheta;
v4 = jacobian([x4; y4], theta) * dtheta;
v5 = jacobian([x5; y5], theta) * dtheta;

% Kinetic energy of each link
T1 = 0.5 * m1 * (v1' * v1) + 0.5 * I1 * dtheta1^2;
T2 = 0.5 * m2 * (v2' * v2) + 0.5 * I2 * (dtheta1 + dtheta2)^2;
T3 = 0.5 * m3 * (v3' * v3) + 0.5 * I3 * (dtheta1 + dtheta2 + dtheta3)^2;
T4 = 0.5 * m4 * (v4' * v4) + 0.5 * I4 * (dtheta1 + dtheta2 + dtheta3 + dtheta4)^2;
T5 = 0.5 * m5 * (v5' * v5) + 0.5 * I5 * (dtheta1 + dtheta2 + dtheta3 + dtheta4 + dtheta5)^2;

% Total kinetic energy
T = T1 + T2 + T3 + T4 + T5;

% Potential energy of each link
U1 = m1 * g * y1;
U2 = m2 * g * y2;
U3 = m3 * g * y3;
U4 = m4 * g * y4;
U5 = m4 * g * y5;

% Total potential energy
U = U1 + U2 + U3 + U4 + U5;

% Lagrangian
L = T - U;

% Inertia matrix (M)
M = sym(zeros(5, 5));
for i = 1:5
    for j = 1:5
        M(i, j) = simplify(diff(diff(L, dtheta(i)), dtheta(j)));
    end
end

% Coriolis and centrifugal matrix (C)
C = sym(zeros(5, 5));
for i = 1:5
    for j = 1:5
        for k = 1:5
            C(i, j) = C(i, j) + 0.5 * (diff(M(i, j), theta(k)) + diff(M(i, k), theta(j)) - diff(M(k, j), theta(i))) * dtheta(k);
        end
    end
end
C = simplify(C);

% Gravity vector (G)
G = sym(zeros(5, 1));
for i = 1:5
    G(i) = simplify(diff(U, theta(i)));
end

% Jacobian for the end-effector (including rotational coordinate)
% x_ee = x4+l5*cos(theta5);
% y_ee = x4+l5*sin(theta5);
x_ee = l1 * cos(theta1) + l2 * cos(theta1 + theta2) + l3 * cos(theta1 + theta2 + theta3) + l4 * cos(theta1 + theta2 + theta3 + theta4) + l5 * cos(theta1 + theta2 + theta3 + theta4 + theta5);
y_ee = l1 * sin(theta1) + l2 * sin(theta1 + theta2) + l3 * sin(theta1 + theta2 + theta3) + l4 * sin(theta1 + theta2 + theta3 + theta4) + l5 * sin(theta1 + theta2 + theta3 + theta4 + theta5);

x_ee
y_ee

x_4e = l1 * cos(theta1) + l2 * cos(theta1 + theta2) + l3 * cos(theta1 + theta2 + theta3) + 0*l4 * cos(theta1 + theta2 + theta3 + theta4);
y_4e = l1 * sin(theta1) + l2 * sin(theta1 + theta2) + l3 * sin(theta1 + theta2 + theta3) + 0*l4 * sin(theta1 + theta2 + theta3 + theta4);

x_4e
y_4e

x_general = l1 * cos(theta1) + l2 * cos(theta1 + theta2) + l3 * cos(theta1 + theta2 + theta3) + l4 * cos(theta1 + theta2 + theta3 + theta4) + l5_general * cos(theta1 + theta2 + theta3 + theta4 + theta5);
y_general = l1 * sin(theta1) + l2 * sin(theta1 + theta2) + l3 * sin(theta1 + theta2 + theta3) + l4 * sin(theta1 + theta2 + theta3 + theta4) + l5_general * sin(theta1 + theta2 + theta3 + theta4 + theta5);

x_2e = l1 * cos(theta1) + l2 * cos(theta1 + theta2);
y_2e = l1 * sin(theta1) + l2 * sin(theta1 + theta2);
Phi_2e = theta1+theta2;
x_2e
y_2e

phi_ee = theta1 + theta2 + theta3 + theta4 + theta5;
J = jacobian([x_ee; y_ee; phi_ee], theta);

J_general = jacobian([x_general; y_general; phi_ee], theta);

J_4 = jacobian([x_4e; y_4e; theta1 + theta2 + theta3 + theta4 ], theta);
J_4e = jacobian([x_4e; y_4e; theta1 + theta2 + theta3 + theta4], theta);
J_2e = jacobian([x_2e; y_2e; Phi_2e], theta);
% Display results
M
C
G
J
J_general
J_4
J_4e
J_2e
%%
l = [1; 1; 1; 1; 2]*0.2;
lc = l./2;
m = [1; 1; 1; 0.3; 0.3]*1;
I = [1; 1; 1; 0.5; 0.5]*1;
q0 = [pi/2; -pi/4; -1*pi/6;-pi/12;0;];
theta_min = [-0.915*pi; -0.915*pi; -0.915*pi; -0.915*pi; -0.915*pi;];
theta_max = [0.915*pi; 0.915*pi; 0.915*pi; 0.915*pi; 0.915*pi;];






