classdef StarConvex
    % Helper functions for a star-convex shape.
    % State is [center_x, center_y, a0, a1, b1, ...]';
    % See Sec IV.A in https://isas.iar.kit.edu/pdf/Fusion11_Baum-RHM.pdf

    methods(Static)
        function ps = as_polygon(x)
            % Returns the polygon chain that corresponds to the given x.            
            center = x(1:2);
            phis = (0:5:360) * pi / 180;
            
            rs = StarConvex.radius(x, phis);
            ps = [cos(phis); sin(phis)] .* rs + center;
        end
        
        function rs = radius(x, phis)
            a0 = x(3);
            
            ab = x(4:end);
            nf = size(ab, 1) / 2;
            
            js = reshape(1:nf, 1, 1, []);
            jphis = js .* phis;
            as = reshape(ab(1:2:end), 1, 1, []);
            bs = reshape(ab(2:2:end), 1, 1, []);
            
            rs = a0 / 2 + sum(as .* cos(jphis) + bs .* sin(jphis), 3);
        end
        
        function zs = create_sources_boundary(x, num)
            % Creates sources on the boundary of the given shape.
            ps = StarConvex.as_polygon(x);
            zs = Polygon.create_sources_boundary(ps, num);
        end
        
        function zs = create_sources_inside(x, num)
            % Creates sources on the inside of the given rectangle.
            center = x(1:2);
            ps = StarConvex.as_polygon(x);
            zs = Polygon.create_sources_inside(center, ps, num);
        end        
        
        function zs = project(x, ys) 
            % Finds the closest point on the shape to the points in ys.
            ps = StarConvex.as_polygon(x);
            zs = Polygon.project(ps, ys);
        end        
        
        function ds = signed_distance(x, ys)
            % Returns the signed distance to the shape. Equivalent to the
            % Euclidean distance, but positive if inside, negative if
            % outside.
            ps = StarConvex.as_polygon(x);
            ds = Polygon.signed_distance(ps, ys);
        end      
        
        function zs = project_radial(x, ys) 
            % Finds the closest point on the shape to the points in ys.
            center = x(1:2);
            ys_local = ys - center;
            
            phis = atan2(ys_local(2,:), ys_local(1,:));
            rs_x = StarConvex.radius(x, phis);
            zs = [cos(phis); sin(phis)] .* rs_x + center;
        end          
        
        function ds = signed_radial_distance(x, ys)
            % Returns the signed radial distance to the shape. Positive if 
            % inside, negative if outside.
            
            center = x(1:2);
            ys_local = ys - center;
            
            phis = atan2(ys_local(2,:), ys_local(1,:));
            rs_y = vecnorm(ys_local);
            rs_x = StarConvex.radius(x, phis);
            
            ds = rs_x - rs_y;
        end              
        
        function plot(x)
            % Plots the rectangle.
            ps = StarConvex.as_polygon(x);
            Polygon.plot(ps);
        end        
        
        function hs = measurement_function_fitting(xs, ys)
            % Radial measurement function for the shape.
            % xs is size nx * nh
            % ys is size 2 * ny
            % hs is size (2*ny) * nh
            hs = zeros(size(ys, 1) * size(ys, 2), size(xs, 2));
            
            for i = 1:size(xs, 2)
                x = xs(:, i);
                h = ys - StarConvex.project_radial(x, ys);
                hs(:, i) = reshape(h, 1, []);
            end
        end     
        
        function hs = measurement_function_rhm(xs, ys, vs)
            % RHM measurement function for the shape.
            % xs is size nx * nh
            % ys is size 2 * ny
            % hs is size ny * nh
            % vs is normally distributed with mean 0 and var 1
            hs = zeros(size(ys, 2), size(xs, 2));
            
            for i = 1:size(xs, 2)
                x = xs(:, i);
                v = vs(:, i);
                s = v / sqrt(12) + 0.5;

                center = x(1:2);
                ys_local = ys - center;
            
                phis = atan2(ys_local(2,:), ys_local(1,:));
                rs_y = vecnorm(ys_local);
                rs_x = StarConvex.radius(x, phis);
                
                h = rs_y - Circle.signed_sqrt(s) * rs_x;
                hs(:, i) = h';
            end
        end        
    end
end
