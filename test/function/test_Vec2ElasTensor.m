% Example vector with 9 elements
vec = [1.0, 2.0, 3.0, 0.5, 0.5, 0.2, 0.5, 0.2, 0.5]; % C11, C22, C33, C12, C13, C23 (repeated for demonstration)

% Convert the vector to an elastic tensor
elasTensor = Vec2ElasTensor(vec);

% Display the elastic tensor
disp('Elastic Tensor:');
disp(elasTensor);
