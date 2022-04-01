% rect state = [center_x, center_y, size_x, size_y, angle]';
real_rect_x = [0, 0, 0.5, 1, pi/4]';

% measurement noise variance
var_v = 1e-4;
% process noise variance
var_w = 1e-6;

% initialization
% starconvex state = [center_x, center_y, a0, a1, b1, ...]';
x = [0, 0, 0.25, 0, 0, 0, 0]';
Cx = eye(size(x, 1)) * 0.001;

% samples for the S2KF
samples = S2KF.create_samples_with_noise(x);

% draw first state
clf;
hold on;
axis equal;

Rectangle.plot(real_rect_x);
StarConvex.plot(x);
pause(0.5);

% start estimation
for i = 1:100
    % create sources
    zs = Rectangle.create_sources_inside(real_rect_x, 24);
    % add noise
    ys = Measurements.add_noise(zs, var_v);

    % update step
    [x, Cx] = S2KF.update(x, Cx, ys, var_v, samples, @StarConvex.measurement_function_rhm);
    
    % prediction step
    [x, Cx] = S2KF.predict_random_walk(x, Cx, var_w);
    
    % plot new state
    clf;
    hold on;
    axis equal;
    
    Rectangle.plot(real_rect_x);
    StarConvex.plot(x);
    Measurements.plot(ys);
    
    pause(0.5);
end
