function example_create_ellipse_measurements_inside
% state = [center_x, center_y, size_x, size_y, angle]';
x = [0, 0, 0.5, 1, pi/4]';

nzs = 150;
zs = Ellipse.create_sources_inside(x, nzs);

v_var = 0.01;
ys = Measurements.add_noise(zs, v_var);

clf;
hold on;
axis equal;

Ellipse.plot(x);
Measurements.plot(ys);

end