function [spikes, se, si] = networkThetaGUI(values)
    
    %initialize variables from values
    i = 1;
    
    noise = values{i}; i = i+1;
    
    Ne = values{i}; i = i+1;
    Ni = values{i}; i = i+1;
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
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %set up integration and storage
    steps = floor(tf/dt);
    transient = floor(t0/dt)+1;
    
    theta_e = zeros(Ne, steps);
    theta_i = zeros(Ni, steps);
    se = zeros(1, steps);
    si = zeros(1, steps);
    spikes_e = zeros(Ne, steps);
    spikes_i = zeros(Ni, steps);
    
    %load initial values
    theta_e(:, 1) = 2*pi*rand(Ne, 1);
    theta_i(:, 1) = 2*pi*rand(Ni, 1);
    
    if ~noise  %heterogeniety from Lorentz distribution
        Ie = Ie + sigma_e*tan(pi*(rand(Ne, 1)-0.5));
        Ii = Ii + sigma_i*tan(pi*(rand(Ni, 1)-0.5));
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for j = 2:steps+1

        %get instantaneous values
        th_e = theta_e(:, j-1);
        th_i = theta_i(:, j-1);
        se_t = se(1, j-1);
        si_t = si(1, j-1);
        I_f = amp*exp(-beta*(1-cos(omega*j*dt)));

        %calculate excitatory theta'
        I_e = Ie + I_f + gee*se_t - gei*si_t;
        thPrime_e = 1-cos(th_e)+(1+cos(th_e)).*I_e;

        %calculate inhibitory theta'
        I_i = Ii + I_f + gie*se_t - gii*si_t;
        thPrime_i = 1-cos(th_i)+(1+cos(th_i)).*I_i;
        
        %add white noise
        if noise
            thPrime_e = thPrime_e + (sigma_e/sqrt(dt))*randn(Ne, 1);
            thPrime_i = thPrime_i + (sigma_i/sqrt(dt))*randn(Ni, 1); 
        end

        %update values (except se/si)
        th_e = th_e + dt*thPrime_e;
        th_i = th_i + dt*thPrime_i;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %find spiked neurons and reset to -pi
        fired_e = th_e >= pi;
        fired_i = th_i >= pi;
        f_e = sum(fired_e);
        f_i = sum(fired_i);
        th_e = th_e - 2*pi*fired_e;
        th_i = th_i - 2*pi*fired_i;

        %update se/si
        sePrime = (-se_t + f_e/Ne/dt)/tau_e;
        siPrime = (-si_t + f_i/Ni/dt)/tau_i;
        se_t = se_t + dt*sePrime;
        si_t = si_t + dt*siPrime;
        
        %store updated values
        theta_e(:, j) = th_e;
        theta_i(:, j) = th_i;
        se(j) = se_t;
        si(j) = si_t;
        spikes_e(:, j) = fired_e;
        spikes_i(:, j) = fired_i;
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %return from t0 to tf
    spikes = logical([spikes_e; spikes_i]);
    spikes = spikes(:, transient:end);
    se = se(:, transient:end);
    si = si(:, transient:end);
    
end