function Lambda_c = computeLambdaC(J_ee, M_c, P, epsilon)
    %#codegen
    % Predefine the output size and type
    Lambda_c = zeros(3, 3); % Assuming Lambda_c is always 3x3

    % Compute the inverse of the constrained joint inertia matrix
%     M_c_inv = inv(M_c);

    % Compute the projected inertia matrix in task space
    M_proj = J_ee / M_c * P * J_ee';

    % Perform Singular Value Decomposition (SVD)
    [U, Sigma, V] = svd(M_proj);

    % Extract the singular values
    singular_values = diag(Sigma);

    % Regularize small singular values
    singular_values_reg = singular_values;
    singular_values_reg(singular_values < epsilon) = 0;

    % Construct the inverse of the regularized singular values
    Sigma_inv = zeros(size(Sigma)); % Maintain 3x3 size
    for i = 1:length(singular_values_reg)
        if singular_values_reg(i) > 0
            Sigma_inv(i, i) = 1 / singular_values_reg(i);
        end
    end

    % Reconstruct the regularized inverse inertia matrix
    Lambda_c = V * Sigma_inv * U';
end
