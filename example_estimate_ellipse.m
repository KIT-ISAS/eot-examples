% state = [center_x, center_y, size_x, size_y, angle]';
real_x = [0, 0, 0.5, 1, pi/4]';

% measurement noise variance
var_v = 1e-4;
% process noise variance
var_w = 1e-5;

% initialization
x = [0, 0, 0.05, 0.05, 0]';
Cx = eye(size(x, 1)) * 0.01;

% samples for the S2KF
samples = S2KF.create_samples(x);

% draw first state
clf;
hold on;
axis equal;

Ellipse.plot(real_x);
Ellipse.plot(x);
pause(0.5);

% start estimation
for i = 1:100
    % create sources
    zs = Ellipse.create_sources_boundary(real_x, 8);
    % add noise
    ys = Measurements.add_noise(zs, var_v);

    % update step
    [x, Cx] = S2KF.update(x, Cx, ys, var_v, samples, @Ellipse.measurement_function_fitting);
    
    % prediction step
    [x, Cx] = S2KF.predict_random_walk(x, Cx, var_w);
    
    % plot new state
    clf;
    hold on;
    axis equal;
    
    Ellipse.plot(real_x);
    Ellipse.plot(x);
    Measurements.plot(ys);
    
    pause(0.5);
end
