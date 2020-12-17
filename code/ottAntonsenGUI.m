function x = ottAntonsenGUI(values)

    %initialize variables from values
    i = 1;
    
    t0 = values{i}; i = i+1;
    tf = values{i}; i = i+1;
    dt = values{i}; i = i+1;
    
    tau_e = values{i}; i = i+1;
    tau_i = values{i}; i = i+1;
    
    amp = values{i}; i = i+1;
    beta = values{i}; i = i+1;
    omega = values{i}; i = i+1;
    
    Ie = values{i}; i = i+1;
    Ii = values{i}*Ie; i = i+1;
    sigma_e = values{i}; i = i+1;
    sigma_i = values{i}*sigma_e; i = i+1;
    
    gee = values{i}; i = i+1;
    gei = values{i}; i = i+1;
    gie = values{i}; i = i+1;
    gii = values{i};
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %set up integration and storage
    steps = floor(tf/dt);
    transient = floor(t0/dt)+1;
    x = zeros(6, steps);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for j = 2:steps+1
        
        %get instantaneous values
        x_t = x(:, j-1);
        re = x_t(1); ri = x_t(2);
        ve = x_t(3); vi = x_t(4);
        se = x_t(5); si = x_t(6);
        I_f = amp*exp(-beta*(1-cos(omega*j*dt)));
        
        %calculate change in values
        xprime = [2*re*ve+sigma_e;
                  2*ri*vi+sigma_i;
                  ve^2-re^2+Ie+I_f+gee*se-gei*si;
                  vi^2-ri^2+Ii+I_f+gie*se-gii*si;
                  (-se+(re/pi))/tau_e;
                  %-se/tau_e + re/pi;
                  (-si+(ri/pi))/tau_i];
                  %-si/tau_i + ri/pi];
        
        %update values
        x(:, j) = x_t + dt*xprime;
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %return from t0 to tf
    x = x(:, transient:end);

end