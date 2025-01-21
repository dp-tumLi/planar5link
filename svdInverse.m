function matrixInverse = svdInverse(matrix, threshold)
    % Validate the input matrix
    if ~ismatrix(matrix)
        error('Input must be a matrix.');
    end

    % Perform Singular Value Decomposition (SVD)
    [U, S, V] = svd(matrix);

    % Get the singular values from the diagonal matrix S
    singularValues = diag(S);

    % Remove (ignore) singular values below the threshold
    validSingularValues = singularValues > threshold;

    % Create a new diagonal matrix for the valid singular values
    S_inv = diag(1 ./ singularValues(validSingularValues));

    % Truncate U and V matrices based on valid singular values
    U_valid = U(:, validSingularValues);
    V_valid = V(:, validSingularValues);

    % Calculate the inverse using the modified SVD components
    matrixInverse = V_valid * S_inv * U_valid';

end
