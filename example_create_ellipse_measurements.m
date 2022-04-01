function example_create_ellipse_measurements
% state = [center_x, center_y, size_x, size_y, angle]';
x = [0, 0, 0.5, 1, pi/4]';

nzs = 15;
zs = Ellipse.create_sources_boundary(x, nzs);

v_var = 0.01;
ys = Measurements.add_noise(zs, v_var);

ps = Ellipse.project(x, ys);

clf;
hold on;
axis equal;

Ellipse.plot(x);
Measurements.plot(ys);
Measurements.plot_connect(ys, ps);

end