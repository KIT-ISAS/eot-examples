function example_create_rectangle_measurements_inside
% state = [center_x, center_y, size_x, size_y, angle]';
x = [0, 0, 2, 1, pi/4]';

nzs = 150;
zs = Rectangle.create_sources_inside(x, nzs);

v_var = 0.001;
ys = Measurements.add_noise(zs, v_var);

clf;
hold on;
axis equal;

Rectangle.plot(x);
Measurements.plot(ys);

end