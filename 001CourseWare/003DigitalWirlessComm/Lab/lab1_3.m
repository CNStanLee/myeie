Bw = 5e6;
Ts = 1/Bw;
fc = 5.9 * 16 ^ 9;

delay_norm


power_db

Ds = 100e-9;
delay_actual = delay_norm * Ds;
maxdelay = delay_actual(end);
newdelays = (0 : Ts : maxdelay);
newpowers = interp1(delay_actual, Power_db, newdelays);
pow_prof = 10.^(0.1 * newpowers);
len = length(pow_prof);
h = sqrt(pow_prof.'/2)*(randn(len, 1) + 1i * randn(len, 1));