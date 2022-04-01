classdef Circle
    % Helper functions for a circle.
    % State is [center_x, center_y, size]
    
    methods(Static)
        function ps = as_polygon(x)
            % Returns the polygon chain that corresponds to the given x.
            center = x(1:2);
            size = abs(x(3));
            
            as = (0:15:360) * pi / 180;
            ps = [cos(as); sin(as)] .* size + center;
        end
        
        function zs = create_sources_boundary(x, num)
            % Creates sources on the boundary of the given shape.
            ps = Circle.as_polygon(x);
            zs = Polygon.create_sources_boundary(ps, num);
        end
        
        function zs = create_sources_inside(x, num)
            % Creates sources on the inside of the given shape.
            center = x(1:2);
            ps = Circle.as_polygon(x);
            zs = Polygon.create_sources_inside(center, ps, num);
        end
        
        function zs = project(x, ys) 
            % Finds the closest point on the shape to the points in ys.
            ps = Circle.as_polygon(x);
            zs = Polygon.project(ps, ys);
        end
                
        function ds = signed_distance(x, ys)
            % Returns the signed distance to the shape. Equivalent to the
            % Euclidean distance, but positive if inside, negative if
            % outside.
            ps = Circle.as_polygon(x);
            ds = Polygon.signed_distance(ps, ys);
        end
        
        function plot(x)
            % Plots the shape.
            ps = Circle.as_polygon(x);
            Polygon.plot(ps);
        end        
        
        function hs = measurement_function_fitting(xs, ys)
            % Measurement function for the shape.
            % xs is size nx * nh
            % ys is size 2 * ny
            % hs is size (2*ny) * nh
            hs = zeros(2 * size(ys, 2), size(xs, 2));
            
            for i = 1:size(xs, 2)
                x = xs(:, i);
                h = ys - Circle.project(x, ys);
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

                radius = abs(x(3));
                ds = Circle.signed_distance(x, ys);
                h = ds - (1 - Circle.signed_sqrt(s)) * radius;
                hs(:, i) = h';
            end
        end    
        
        function s = signed_sqrt(v)
            s = zeros(1, size(v, 2), 1);
            s(v > 0) = sqrt(v(v > 0));
            s(v < 0) = -sqrt(-v(v < 0));
        end
    end
end

