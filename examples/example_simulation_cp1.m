close all
clear
clc

% 
% 初始化 - 设定参数
% 

% Retrieve valid parameters for the class
params = ComputeMultipleCrystalPlasticityStress.validParams();

% Modify any required parameters
params_model1 = CrystalPlasticityStressUpdateBase.validParams();
params_model2 = CrystalPlasticityStressUpdateBase.validParams();
model1 = CrystalPlasticityStressUpdateBase(params_model1);
model2 = CrystalPlasticityStressUpdateBase(params_model2);
params.crystal_plasticity_models = {model1, model2};% Another model

% 材料参数
params.elasticity_tensor = [1.0, 2.0, 3.0, 0.5, 0.5, 0.2, 0.5, 0.2, 0.5]; % C11, C22, C33, C12, C13, C23 (repeated for demonstration);

% Create an instance of the ComputeMultipleCrystalPlasticityStress class
cpStressModel = ComputeMultipleCrystalPlasticityStress(params);
