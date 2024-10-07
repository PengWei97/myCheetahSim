classdef CrystalPlasticityStressUpdateBase
  properties (Access = protected)
      crystal_lattice_type % Crystal lattice type: BCC, FCC, HCP
      unit_cell_dimension % Dimensions of the unit cell
      number_slip_systems % Maximum number of active slip systems
      slip_sys_file_name % File containing slip plane normal and direction
      rel_state_var_tol % Relative state variable tolerance
      slip_incr_tol % Slip increment tolerance
      resistance_tol % Tolerance for change in slip system resistance=
      zero_tol % Residual tolerance when variable value is zero
      slip_resistance % Slip system resistance
      slip_increment % Current slip increment material property
      slip_direction % Slip system direction
      slip_plane_normal % Slip system plane normal
      flow_direction % Flow direction tensor
      tau % Resolved shear stress on each slip system
      print_convergence_message % Flag for printing convergence messages
      substep_dt % Substepping time step values
  end
  
  methods (Static)
    function params = validParams()
        % Method to define valid parameters
        params = struct();
        params.base_name = ''; % Define the parameter for base_name
        params.crystal_lattice_type = 'FCC'; % Default lattice type
        params.unit_cell_dimension = [1.0, 1.0, 1.0]; % Default unit cell dimension
        params.number_slip_systems = 12; % Default number of slip systems
        params.slip_sys_file_name = ''; % Default slip system file name
        params.stol = 1e-2; % Default tolerance
        params.slip_increment_tolerance = 2e-2; % Default slip increment tolerance
        params.resistance_tol = 1e-2; % Default resistance tolerance
        params.zero_tol = 1e-12; % Default zero tolerance
        params.print_state_variable_convergence_error_messages = false; % Default
    end
  end

  methods (Access = public)
    function obj = CrystalPlasticityStressUpdateBase(params)
        % Constructor for the base class
        obj.crystal_lattice_type = params.crystal_lattice_type; % Direct assignment
        obj.unit_cell_dimension = params.unit_cell_dimension;
        obj.number_slip_systems = params.number_slip_systems; % Direct assignment
        obj.slip_sys_file_name = params.slip_sys_file_name; % Direct assignment
        obj.rel_state_var_tol = params.stol; % Direct assignment
        obj.slip_incr_tol = params.slip_increment_tolerance; % Direct assignment
        obj.resistance_tol = params.resistance_tol; % Direct assignment
        obj.zero_tol = params.zero_tol; % Direct assignment
        obj.print_convergence_message = params.print_state_variable_convergence_error_messages; % Direct assignment
        
        % Initialize properties
        obj.slip_direction = cell(obj.number_slip_systems, 1);
        obj.slip_plane_normal = cell(obj.number_slip_systems, 1);
        obj.slip_resistance = zeros(1, obj.number_slip_systems); % Initialize with zeros
        obj.slip_increment = zeros(1, obj.number_slip_systems); % Initialize with zeros
        obj.flow_direction = cell(1, obj.number_slip_systems); % Initialize with cell array
        obj.tau = zeros(1, obj.number_slip_systems); % Initialize with zeros
    end
      
    function initQpStatefulProperties(obj)
        % Initialize stateful properties
        obj.setMaterialVectorSize();
    end
      
    function setMaterialVectorSize(obj)
        % Set the size of the material vector
        obj.tau = zeros(1, obj.number_slip_systems);
        for i = 1:obj.number_slip_systems
            obj.flow_direction{i} = zeros(3, 3); % Assuming RankTwoTensor is defined
            obj.tau(i) = 0.0;
        end
        obj.slip_resistance = zeros(1, obj.number_slip_systems);
        obj.slip_increment = zeros(1, obj.number_slip_systems);
    end
  end
end
