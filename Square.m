classdef Square
    % Helper functions for a square.
    % State is [center_x, center_y, size]
    
    methods(Static)
        function ps = as_polygon(x)
            % Returns the polygon chain that corresponds to the given x.
            center = x(1:2);
            size = abs(x(3));
            angle = x(4);
            
            as = (45 + (0:90:360)) * pi / 180;
            cs = [cos(as); sin(as)] .* (size/sqrt(2));
            
            R = [cos(angle), -sin(angle); sin(angle), cos(angle)];
            ps = R * cs + center;
        end
        
        function zs = create_sources_boundary(x, num)
            % Creates sources on the boundary of the given shape.
            ps = Square.as_polygon(x);
            zs = Polygon.create_sources_boundary(ps, num);
        end
        
        function zs = create_sources_inside(x, num)
            % Creates sources on the inside of the given rectangle.
            center = x(1:2);
            ps = Square.as_polygon(x);
            zs = Polygon.create_sources_inside(center, ps, num);
        end
        
        function zs = project(x, ys) 
            % Finds the closest point on the shape to the points in ys.
            ps = Square.as_polygon(x);
            zs = Polygon.project(ps, ys);
        end
        
        function ds = signed_distance(x, ys)
            % Returns the signed distance to the shape. Equivalent to the
            % Euclidean distance, but positive if inside, negative if
            % outside.
            ps = Square.as_polygon(x);
            ds = Polygon.signed_distance(ps, ys);
        end        
        
        function plot(x)
            % Plots the shape.
            ps = Square.as_polygon(x);
            Polygon.plot(ps);
        end
        
        function hs = measurement_function_fitting(xs, ys)
            % Measurement function for the shape
            % xs is size nx * nh
            % ys is size 2 * ny
            % hs is size (2*ny) * nh
            hs = zeros(size(ys, 1) * size(ys, 2), size(xs, 2));
            
            for i = 1:size(xs, 2)
                x = xs(:, i);
                h = ys - Square.project(x, ys);
                hs(:, i) = reshape(h, 1, []);
            end
        end      
        
        function hs = measurement_function_rhm(xs, ys, vs)
            % RHM measurement function for the shape.
            % xs is size nx * nh
            % ys is size 2 * ny
            % hs is size ny * nh
            hs = zeros(size(ys, 2), size(xs, 2));
            
            for i = 1:size(xs, 2)
                x = xs(:, i);
                v = vs(:, i);
                s = v / sqrt(12) + 0.5;

                phi_max = abs(x(3))/2; % max level-set
                ds = Square.signed_distance(x, ys);
                h = ds - (1 - Circle.signed_sqrt(s)) * phi_max;
                hs(:, i) = h';
            end
        end            
    end
end

