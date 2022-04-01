classdef Measurements
    methods(Static)
        function ys = add_noise(zs, var)
            ys = zs + normrnd(0, sqrt(var), 2, size(zs, 2));
        end
        
        function plot(ys)
            % Plot the points in ys.
            scatter(ys(1,:), ys(2,:), 'filled');
        end
        
        function plot_connect(as, bs)
            % Plot lines that connect each point in as with the point in
            % bs.
            nas = size(as, 2);
            ls = zeros(2,3*nas);
            for i = 1:nas
                ls(:,3*i-2) = as(:,i);
                ls(:,3*i-1) = bs(:,i);
                ls(:,3*i) = nan(2,1);
            end
            plot(ls(1,:), ls(2,:), 'LineWidth', 3);
        end
    end
end