classdef Rectangle
    % Helper functions for a rectangle.
    % State is [center_x, center_y, size_x, size_x, angle]
    
    methods(Static)
        function ps = as_polygon(x)
            % Returns the polygon chain that corresponds to the given x.
            center = x(1:2);
            size = abs(x(3:4));
            angle = x(5);
            
            as = (45 + (0:90:360)) * pi / 180;
            cs = [cos(as); sin(as)] .* (size / sqrt(2));
            
            R = [cos(angle), -sin(angle); sin(angle), cos(angle)];
            ps = R * cs + center;
        end
        
        function zs = create_sources_boundary(x, num)
            % Creates sources on the boundary of the given rectangle.
            ps = Rectangle.as_polygon(x);
            zs = Polygon.create_sources_boundary(ps, num);
        end
        
        function zs = create_sources_inside(x, num)
            % Creates sources on the inside of the given rectangle.
            center = x(1:2);
            ps = Rectangle.as_polygon(x);
            zs = Polygon.create_sources_inside(center, ps, num);
        end
        
        function zs = project(x, ys) 
            % Finds the closest point on the rectangle to the points in ys.
            ps = Rectangle.as_polygon(x);
            zs = Polygon.project(ps, ys);
        end
        
        function ds = signed_distance(x, ys)
            % Returns the signed distance to the shape. Equivalent to the
            % Euclidean distance, but positive if inside, negative if
            % outside.
            ps = Rectangle.as_polygon(x);
            ds = Polygon.signed_distance(ps, ys);
        end        
        
        function plot(x)
            % Plots the rectangle.
            ps = Rectangle.as_polygon(x);
            Polygon.plot(ps);
        end
        
        function hs = measurement_function_fitting(xs, ys)
            % measurement function for the shape.
            % xs is size nx * nh
            % ys is size 2 * ny
            % hs is size (2*ny) * nh
            hs = zeros(size(ys, 1) * size(ys, 2), size(xs, 2));
            
            for i = 1:size(xs, 2)
                x = xs(:, i);
                h = ys - Rectangle.project(x, ys);
                hs(:, i) = reshape(h, 1, []);
            end
        end        
    end
end

