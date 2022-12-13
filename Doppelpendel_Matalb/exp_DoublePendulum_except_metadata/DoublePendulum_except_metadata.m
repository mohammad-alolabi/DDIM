%This file was auto-exported via export_custom_fun.m with all necessary dependancies
mfile_name    = mfilename('fullpath');
[pathstr,~,~] = fileparts(mfile_name);
cd(pathstr);
clearvars
addpath('.\required_add_funs')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear 
close all
clc

SetDefaultProperties('Fontsize',14)
date_time_string = [datestr(now,'yy_mm_dd'),'_at_',datestr(now,'hhMM')];
filename = [date_time_string,'__DoublePendulum'];


%% prepare computation of system dynamics
% parameters
g   = 9.81;
l_1 = 2;
m_1 = 4;
l_2 = 3;
m_2 = 1;
I_1 = 1/12*m_1*l_1^2;
I_2 = 1/12*m_2*l_2^2;

DOF = 2;
[q_t,dq_t,t,q,dq,ddq] = computeGenCO(DOF);
theta_1  = q_t{1};
theta_2  = q_t{2};
dtheta_1 = dq_t{1};
dtheta_2 = dq_t{2};

% position and velocity of pendulum midpoints
x_1 =  l_1/2*sin(theta_1);
y_1 = -l_1/2*cos(theta_1);
p_1 = [x_1;y_1];

x_2 =  l_1*sin(theta_1) + l_2/2*sin(theta_1+theta_2);
y_2 = -l_1*cos(theta_1) - l_2/2*cos(theta_1+theta_2);
p_2 = [x_2;y_2];

v_1 = replaceDerivs2(diff(p_1,t),DOF,q_t,dq_t,t);
v_2 = replaceDerivs2(diff(p_2,t),DOF,q_t,dq_t,t);

% save model parameters to struct
sys_params.g   = g;
sys_params.l_1 = l_1;
sys_params.m_1 = m_1;
sys_params.I_1 = I_1;
sys_params.l_2 = l_2;
sys_params.m_2 = m_2;
sys_params.I_2 = I_2;

% save parametrization of pendulum midpoints to struct
sys_params.pend_1_midp_param = p_1;
sys_params.pend_2_midp_param = p_2;


%% computing the system dynamics
K = 1/2 * ( v_1'*m_1*v_1           + v_2'*m_2*v_2 + ...
            dtheta_1'*I_1*dtheta_1 + dtheta_2'*I_2*dtheta_2 );
U = m_1*g*y_1 + m_2*g*y_2;
L = K-U;

[M_qq,tf,f] = ODEviaLagrange(L,DOF,q_t,dq_t,t,q,dq,ddq);
rhs = @(t,x) [x(3); x(4); f(x(1:2),x(3:4))]; % model of the double pendulum in state space representation: 
                                             % dx = rhs(t,x) with x=[theta_1,theta_2,dtheta_1,dtheta_2]'

clearvars -except rhs sys_params filename


%% simulation
t_sim = [0 20];
x_0 = [180*pi/180, -90*pi/180, 0, 0]';

ode45_opt = odeset('RelTol',10^-9,'AbsTol',10^-12);
sol = ode45(rhs,t_sim,x_0,ode45_opt);


%% save (meta)data
TODO = 'TODO: Save metadata and data'


%% animate the solution
animate_solution_on = 1;
if animate_solution_on==1   
    x_fun = @(t) deval(sol,t);

    [vidObj,t_grid_video,~] = prepareVideoObj(t_sim,'VideoTitle',filename, ...
                                              'VideoSpeed',1,'VideoQuality',100,'VideoFPS',20);
    FRAMES = animDoublePend(x_fun,t_grid_video,sys_params);
    writeFramesToVideo(FRAMES,vidObj)
end

