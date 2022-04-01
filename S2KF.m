classdef S2KF
    methods(Static)
        function samples = create_samples(x)
            % Retrieves samples suitable for estimating x.
            dim_x = size(x, 1);
            samples = S2KF.create_samples_for_dim(dim_x);
        end
        
        function samples = create_samples_with_noise(x)
            % Retrieves samples suitable for estimating x with a scalar noise.
            dim_x = size(x, 1);
            samples = S2KF.create_samples_for_dim(dim_x + 1);
        end

        function samples = create_samples_for_dim(dim_x)
            % Retrieves samples for estimating a state of the given dimension.
            sampling = GaussianSamplingLCD();
            sampling.setNumSamplesByFactor(15);
            samples = sampling.getStdNormalSamples(dim_x);
        end

        function [xe, Cxe] = update(xp, Cxp, ys, Cy, samples, measurementFunction)
            % Simplified S2KF update step.
            % Here, we assume that the measurement equation is 
            % 0 = measurementFunction(xs, ys), with Cy passed separately.
            % If dealing with RHMs, the measurement equation should be
            % 0 = measurementFunction(xs, ys, vs).
            
            m = size(samples, 2);
            n = size(xp, 1);

            
            Cxp_sqrt = chol(Cxp)';
            
            if size(samples, 1) == n
                % Usual noise term.
                delta_x_samples = Cxp_sqrt * samples;
                x_samples = xp + delta_x_samples;
                hs = measurementFunction(x_samples, ys);
            else 
                % RHM noise term. 
                x_samples = samples(1:n, :); % state samples
                v_samples = samples((n+1):end, :); % noise samples
                delta_x_samples = Cxp_sqrt * x_samples;
                x_samples = xp + delta_x_samples;
                hs = measurementFunction(x_samples, ys, v_samples);
            end
            
            h_mean = mean(hs, 2);
            hs = hs - h_mean;
            Ch = hs * hs' / m;
            Cxh = delta_x_samples * hs' / m;
            
            dim_Cy = size(Cy, 1);
            if dim_Cy == 1
                Ch = Ch + Cy * eye(size(hs, 1));
            else
                num_repeat = size(hs, 1) / dim_Cy;
                Cy_repeat = repmat({Cy}, 1, num_repeat);  
                Ch = Ch + blkdiag(Cy_repeat{:});
            end
            
            K = Cxh / Ch;
            xe = xp - K * h_mean;
            
            KCh_sqrt = K * chol(Ch)';
            Cxe = Cxp - KCh_sqrt * KCh_sqrt';
        end
        
        function [xp, Cxp] = predict_random_walk(xe, Cxe, var_q)
            % Random walk. Mean is not changed, var_q is added directly to Cx.
            xp = xe;
            Cxp = Cxe + var_q * eye(size(xe, 1));
        end        
        
        function [xp, Cxp] = predict_linear(xe, Cxe, F, Q)
            % Linear prediction step.
            xp = F * xe;
            Cxp = F * Cxe * F' + Q;
        end
    end
end
