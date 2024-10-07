classdef ComputeMultipleCrystalPlasticityStress
  properties (Access = protected)
      % Number of plastic models
      num_models
      
      % User supplied crystal plasticity models
      models
      
      % Elasticity tensor
      elasticity_tensor
      
      % Tolerance parameters for stress residual equation
      rtol
      abs_tol
      
      % Iteration limits
      maxiter
      maxiterg
      
      % Flags for line search parameters
      use_line_search
      min_line_search_step_size
      line_search_tolerance
      line_search_max_iterations
      
      % Stateful properties
      plastic_deformation_gradient
      plastic_deformation_gradient_old
      deformation_gradient
      deformation_gradient_old
      pk2
      pk2_old
      total_lagrangian_strain
      updated_rotation
      crysrot
      
      % Flags for warnings and convergence checking
      print_convergence_message
      convergence_failed
      
      % Helper tensors for iterative solving
      temporary_deformation_gradient
      elastic_deformation_gradient
      inverse_plastic_deformation_grad
      inverse_plastic_deformation_grad_old
      inverse_eigenstrain_deformation_grad
      
      % Scales the substepping increment to obtain deformation gradient at a substep iteration
      dfgrd_scale_factor
  end
  
  methods (Static)
      function params = validParams()
          % Method to return valid parameters for the class
          params = struct();
          params.elasticity_tensor = []; % Initialize as empty or set a default
          params.crystal_plasticity_models = {}; % List of models
          params.rtol = 1e-6; % Relative tolerance for residuals
          params.abs_tol = 1e-6; % Absolute tolerance for residuals
          params.maxiter = 100; % Maximum number of iterations for stress update
          params.maxiter_state_variable = 100; % Maximum number of iterations for state variable update
          params.maximum_substep_iteration = 1; % Maximum number of substep iterations
          params.use_line_search = false; % Use line search in constitutive update
          params.min_line_search_step_size = 0.01; % Minimum line search step size
          params.line_search_tol = 0.5; % Line search bisection method tolerance
          params.line_search_maxiter = 20; % Line search bisection method maximum number of iterations
          params.print_state_variable_convergence_error_messages = false; % Print convergence error messages
      end
  end

  methods
      function obj = ComputeMultipleCrystalPlasticityStress(params)
          % Constructor to initialize properties
          obj.num_models = numel(params.crystal_plasticity_models);
          obj.models = params.crystal_plasticity_models;
          obj.elasticity_tensor = Vec2ElasTensor(params.elasticity_tensor); % Assuming Vec2ElasTensor is defined
          
          % Initialize properties from params
          obj.maxiter = params.maxiter;
          obj.maxiterg = params.maxiter_state_variable;
          obj.rtol = params.rtol;
          obj.abs_tol = params.abs_tol;

          obj.use_line_search = params.use_line_search;
          obj.min_line_search_step_size = params.min_line_search_step_size;
          obj.line_search_tolerance = params.line_search_tol;
          obj.line_search_max_iterations = params.line_search_maxiter;
          obj.print_convergence_message = params.print_state_variable_convergence_error_messages;

          % Initialize other properties
          obj.convergence_failed = false;

          % Initialize necessary parameters and crystal plasticity models
          obj.initialSetup();
          obj.initQpStatefulProperties();
      end
      
      function initialSetup(obj)
          % Get crystal plasticity models and check compatibility
          for i = 1:obj.num_models
              model = obj.models{i}; % Directly retrieve model object
              if ~isa(model, 'CrystalPlasticityStressUpdateBase')
                  error(['Model is not compatible with ComputeMultipleCrystalPlasticityStress']);
              end
          end
      end
      
      function initQpStatefulProperties(obj)
          % Initialize stateful properties at the quadrature point
          obj.plastic_deformation_gradient = eye(3); % Placeholder for actual tensor size
          obj.plastic_deformation_gradient_old = obj.plastic_deformation_gradient; % Example initialization
          obj.pk2 = zeros(3, 3); % Placeholder
          obj.total_lagrangian_strain = zeros(3, 3); % Placeholder
          obj.updated_rotation = eye(3); % Identity matrix as a placeholder
          
          % Initialize models
          for i = 1:obj.num_models
              obj.models{i}.initQpStatefulProperties();
          end
      end
  end
end
