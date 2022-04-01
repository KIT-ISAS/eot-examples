function example_create_rectangle_measurements
% state = [center_x, center_y, size_x, size_y, angle]';
x = [0, 0, 0.5, 1, pi/4]';

nzs = 15;
zs = Rectangle.create_sources_boundary(x, nzs);

v_var = 0.01;
ys = Measurements.add_noise(zs, v_var);

ps = Rectangle.project(x, ys);

clf;
hold on;
axis equal;

Rectangle.plot(x);
Measurements.plot(ys);
Measurements.plot_connect(ys, ps);

end