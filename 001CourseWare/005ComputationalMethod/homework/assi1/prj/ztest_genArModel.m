N = 2048;
a = [0.3, -0.1, 0.5];

ar_signal = generateArModel(N, a);

t = 1 : 1 : N;

plot(t, ar_signal);