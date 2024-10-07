% TODO ~ 验证该代码赋予的正确性
function elasTensor = Vec2ElasTensor(vec)
    % Vec2ElasTensor Converts a 9-element vector to a 3x3x3x3 elastic tensor.
    % 
    % Inputs:
    %   vec - A 9-element vector [C11, C22, C33, C12, C13, C23, C11, C22, C33]
    % 
    % Outputs:
    %   elasTensor - A 3x3x3x3 elastic tensor.

    % Check if the input vector has exactly 9 elements
    if numel(vec) ~= 9
        error('Input must be a 9-element vector.');
    end
    
    % Initialize the elastic tensor (4th order)
    elasTensor = zeros(3, 3, 3, 3);
    
    % Fill the tensor based on the symmetry of the elastic tensor
    elasTensor(1, 1, 1, 1) = vec(1); % C11
    elasTensor(2, 2, 2, 2) = vec(2); % C22
    elasTensor(3, 3, 3, 3) = vec(3); % C33
    elasTensor(1, 2, 1, 2) = vec(4); % C12
    elasTensor(1, 3, 1, 3) = vec(5); % C13
    elasTensor(2, 3, 2, 3) = vec(6); % C23

    % Exploit symmetry to fill the rest of the tensor
    elasTensor(2, 1, 2, 1) = elasTensor(1, 2, 1, 2); % C12
    elasTensor(3, 1, 3, 1) = elasTensor(1, 3, 1, 3); % C13
    elasTensor(3, 2, 3, 2) = elasTensor(2, 3, 2, 3); % C23

    % Optionally, fill out remaining components as zeros (or use them as needed)
    elasTensor(1, 1, 2, 2) = 0; % C11
    elasTensor(1, 1, 3, 3) = 0; % C11
    elasTensor(2, 2, 1, 1) = 0; % C22
    elasTensor(2, 2, 3, 3) = 0; % C22
    elasTensor(3, 3, 1, 1) = 0; % C33
    elasTensor(3, 3, 2, 2) = 0; % C33

end
