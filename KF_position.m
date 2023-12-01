
% Bayesian Estimation and Stochastic Optimization
% Jaume Anguera Peris


%% Known parameters of the simulation

deltaTime = .1;     % Time between samples
N = 100;            % Length of the simulation

% Position matrix
A = eye(2);

% Observation matrix
C = eye(2);

% Bayesian Estimation and Stochastic Optimization
% Jaume Anguera Peris

%% Iterative process

% Initial values
xHat = zeros(2,1);
covHat = zeros(2,2);

% Initial position and velocity
x = zeros(2,1);

% Accumulation states, observations, and estimates
% for 2D state vectors, x = [pos x, pos y]' and y = [pos x, pos y]';
states = zeros(2, N);   
obs = zeros(2, N);
est = zeros(2, N);

% Covariance noise in the positions
Q = 1e-3*eye(2);

% Covariance noise in the observations
R = 0.001*eye(2);


for n = 1:N
    
    % State
    x = A*x + mvnrnd(zeros(1,2),Q)';

    % Observation
    y = C*x + mvnrnd(zeros(2,1),R)';
    
    % Store history of states and observations
    states(:,n) = x;
    obs(:,n) = y;

    % Predicted state, covariance, and observation
    xPred = A * xHat;
    covPred = A * covHat * A' + Q;
    yPred = C * xPred;

    % Estimation variables
    S = C * covPred' * C' + R;
    B = C * covPred';
    klm_gain = (S \ B)';

    % Estimated state, covarianve, and observation
    xHat = xPred + klm_gain * (y - yPred);
    covHat = covPred - klm_gain * C * covPred;
    yHat = C * xHat;

    % Store estimated positions and velocities
    est(:,n) = xHat;

end


figure('Name','Estimate positions in x-axis')
plot(states(1,:), 'o', 'DisplayName',' True sates'); hold on;
plot(obs(1,:), 'rx', 'DisplayName', 'Observations');
plot(est(1,:), 'k-', 'DisplayName', 'Estimate'); hold off;
legend('Location','northeast');
xlabel('Position X');
ylabel('Position Y');
set(gca,'FontSize',14);
grid minor;

figure('Name','Estimate positions in y-axis')
plot(states(2,:), 'o', 'DisplayName',' True sates'); hold on;
plot(obs(2,:), 'rx', 'DisplayName', 'Observations');
plot(est(2,:), 'k-', 'DisplayName', 'Estimate'); hold off;
legend('Location','northeast');
xlabel('Position X');
ylabel('Position Y');
set(gca,'FontSize',14);
grid minor;
