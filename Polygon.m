classdef Polygon
    % Helper functions that work with a generic polygon.
    
    methods(Static)
        function zs = create_sources_boundary(ps, num)
            % Creates sources on the boundary of the given polygon chain.
            % ps is a 2xn list of points. num is the list of sources.
            % The last polygon point has to be equal to the first.
            
            nps = size(ps, 2);
            
            as = ps(:,1:nps-1);
            bs = ps(:,2:nps) - as;

            % weights are proportional to segment length
            ws = vecnorm(bs, 2); 

            indices = randsample(nps-1, num, true, ws);
            ts = rand(1, num);
            
            zs = ps(:, indices) + bs(:, indices) .* ts;
        end
        
        function zs = create_sources_inside(center, ps, num)
            % Creates sources on the inside of the given polygon.
            % ps is a 2xn list of points. num is the list of sources.
            % The last polygon point has to be equal to the first.
            % Assumes that the polygon is star-convex, and the center arg
            % is somewhere inside the polygon.

            nps = size(ps, 2);
            
            as = ps(:,1:nps-1);
            bs = ps(:,2:nps) - as;
            cs = as - center;
            
            % weights are proportional to area
            ws = abs(bs(1,:) .* cs(2,:) - bs(2,:) .* cs(1,:));
            
            indices = randsample(nps-1, num, true, ws);
            ts = rand(1, num);
            us = sqrt(rand(1, num));
            
            zs_boundary = ps(:, indices) + bs(:, indices) .* ts;
            zs = (1 - us) .* center + us .* zs_boundary;
        end
        
        function zs = project(ps, ys) 
            % Finds the closest point on the boundary to the points in ys.
            
            nps = size(ps, 2);
            nys = size(ys, 2);
            
            as = ps(:,1:nps-1);
            bs = ps(:,2:nps) - as;
            
            zs = zeros(2, nys);
            
            for i = 1:nys
                y = ys(:,i);
                yas = y - as;
                ts = sum(yas .* bs, 1) ./ sum(bs .* bs, 1);
                ts = max(min(ts, 1), 0);
                
                yzs = as + ts .* bs;
                
                dists = vecnorm(yzs - y, 2);
                [~,index] = min(dists);
                zs(:, i) = yzs(:,index);
            end            
        end

        function ds = signed_distance(ps, ys) 
            % Returns the signed distance to the shape. Equivalent to the
            % Euclidean distance, but positive if inside, negative if
            % outside. The points in ps should be counter-clockwise.
            
            nps = size(ps, 2);
            nys = size(ys, 2);
            
            as = ps(:,1:nps-1);
            bs = ps(:,2:nps) - as;
            
            ds = zeros(1, nys);
            
            for i = 1:nys
                y = ys(:,i);
                yas = y - as;
                ts = sum(yas .* bs, 1) ./ sum(bs .* bs, 1);
                ts = max(min(ts, 1), 0);
                
                % us is positive if ys is inside the polygon, negative else
                us = sign(yas(2,:) .* bs(1,:) - yas(1,:) .* bs(2,:));
                
                yzs = as + ts .* bs;
                
                dists = vecnorm(yzs - y, 2);
                [min_dist,index] = min(dists);
                
                ds(:, i) = min_dist * us(index);
            end            
        end
        
        function plot(ps)
            plot(ps(1,:), ps(2,:), 'LineWidth', 3);
        end
    end
end

