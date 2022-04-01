% state = [center_x, center_y, radius]';
real_x = [1, 1, 1]';

% measurement noise variance
var_v = 1e-4;
% process noise variance
var_w = 1e-7;

% initialization
x = [0, 0, 0.25]';
Cx = eye(size(x, 1)) * 1e-2;

% samples for the S2KF
samples = S2KF.create_samples_with_noise(x);

% draw first state
clf;
hold on;
axis equal;

Circle.plot(real_x);
Circle.plot(x);
pause(0.5);

% start estimation
for i = 1:100
    % create sources
    zs = Circle.create_sources_inside(real_x, 24);
    % add noise
    ys = Measurements.add_noise(zs, var_v);

    % update step
    [x, Cx] = S2KF.update(x, Cx, ys, var_v, samples, @Circle.measurement_function_rhm);
    
    % prediction step
    [x, Cx] = S2KF.predict_random_walk(x, Cx, var_w);
    
    % plot new state
    clf;
    hold on;
    axis equal;
    
    Circle.plot(real_x);
    Circle.plot(x);
    Measurements.plot(ys);
    
    pause(0.5);
end
