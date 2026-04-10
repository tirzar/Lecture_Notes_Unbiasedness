%% =========================================================
%  Cyclic CRB Simulation: Phase Estimation in AWGN
%  Model: x[n] = A*exp(j*(n*omega + theta)) + w[n]
%  Routtenberg & Tabrikian, IEEE SPM Lecture Notes.
%
%  Parameters: N=5, A=1, SNR=-30:2:10 dB, 10000 MC trials
%% =========================================================
clear; clc; rng(0);

%% --- Parameters ---
N          = 5;
A          = 1;
theta_true = pi/4;
omega      = 0.2*pi;
num_trials = 100000;
SNR_dB     = -30:2:10;
snr_lin    = 10.^(SNR_dB/10);
sigma2_vec = A^2 ./ snr_lin;

%% --- Preallocate ---
mce_ml      = zeros(size(SNR_dB));
mse_ml      = zeros(size(SNR_dB));
bias_mean   = zeros(size(SNR_dB));
bias_cyclic = zeros(size(SNR_dB));
CRB         = zeros(size(SNR_dB));
CRB_cyc     = zeros(size(SNR_dB));

%% --- Vectorized Monte Carlo ---
fprintf('Running Monte Carlo (%d trials)...\n', num_trials);
n = (0:N-1).';

for i = 1:length(SNR_dB)
    sigma2 = sigma2_vec(i);

    s = A * exp(1j*(n*omega + theta_true));
    W = sqrt(sigma2/2) * (randn(N, num_trials) + 1j*randn(N, num_trials));
    X = s + W;

    X_demod   = X .* exp(-1j*omega*n);
    r         = mean(X_demod, 1);
    theta_hat = angle(r);

    diff = theta_hat - theta_true;

    mce_ml(i)      = mean(2 - 2*cos(diff));
    mse_ml(i)      = mean(diff.^2);
    bias_mean(i)   = mean(diff);
    bias_cyclic(i) = mean(sin(diff));

    gamma_N    = N * snr_lin(i);
    CRB(i)     = 1 / (2*gamma_N);
    CRB_cyc(i) = 2 - 2*sqrt(2*gamma_N / (1 + 2*gamma_N));
end
fprintf('Done.\n');

%% --- Figure: 2-panel ---
figure('Units','inches','Position',[1 1 9 4]);

%% Panel (a): Bias
subplot(2,1,1);
plot(SNR_dB, bias_mean,   'r-s', 'LineWidth',1.8, 'MarkerSize',4, ...
     'DisplayName','Mean bias $\mathbb{E}[\hat{\theta}-\theta;\theta]$');
hold on;
plot(SNR_dB, bias_cyclic, 'b-o', 'LineWidth',1.8, 'MarkerSize',4, ...
     'DisplayName','Cyclic bias $\mathbb{E}[\sin(\hat{\theta}-\theta);\theta]$');
yline(0,'k--','LineWidth',1,'HandleVisibility','off');
xlabel('SNR [dB]','FontSize',12);
ylabel('Bias','FontSize',12);
legend('Interpreter','latex','FontSize',10,'Location','southwest');
title('(a) Mean and cyclic bias of the ML estimator', ...
      'Interpreter','latex','FontSize',11);
grid on;
xlim([SNR_dB(1) SNR_dB(end)]);

%% Panel (b): Performance
subplot(2,1,2);

% Shading where MSE < CRB (CRB invalid)
invalid_mask = mse_ml < CRB;
if any(invalid_mask)
    xi = SNR_dB(invalid_mask);
    fill([xi, fliplr(xi)], ...
         [mse_ml(invalid_mask), fliplr(CRB(invalid_mask))], ...
         [1 0.85 0.85], 'EdgeColor','none','FaceAlpha',0.4, ...
         'HandleVisibility','off');
end
set(gca,'YScale','log');
hold on;

semilogy(SNR_dB, mce_ml,  'k-o',  'LineWidth',1.8, 'MarkerSize',4, ...
         'DisplayName','MCE (ML)');
semilogy(SNR_dB, mse_ml,  'k--s', 'LineWidth',1.8, 'MarkerSize',4, ...
         'DisplayName','MSE (ML)');
semilogy(SNR_dB, CRB_cyc, 'b-',   'LineWidth',2.2, ...
         'DisplayName','Cyclic CRB');
semilogy(SNR_dB, CRB,     'r--',  'LineWidth',2.2, ...
         'DisplayName','CRB');

xlabel('SNR [dB]','FontSize',12);
ylabel('MSE / MCE','FontSize',12);
legend('FontSize',10,'Location','southwest');
title('(b) MCE and MSE of ML estimator vs. CRBs', ...
      'Interpreter','latex','FontSize',11);
grid on;
xlim([SNR_dB(1) SNR_dB(end)]);

set(gcf,'Color','w');