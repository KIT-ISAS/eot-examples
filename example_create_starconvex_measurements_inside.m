function example_create_starconvex_measurements_inside
% state = [center_x, center_y, a0, a1, b1, ...]';
x = [0, 0, 1.3, 0.4, 0.3, 0.4, 0.3]';

nzs = 250;
zs = StarConvex.create_sources_inside(x, nzs);

v_var = 0.001;
ys = Measurements.add_noise(zs, v_var);

clf;
hold on;
axis equal;

StarConvex.plot(x);
Measurements.plot(ys);

end