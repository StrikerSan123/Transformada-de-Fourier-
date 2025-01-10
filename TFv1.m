% ENTRADA DATOS
%-----------------------------------------------------
[audio, Fs] = audioread('audio_2.wav');
%fs frecuencia a la que se muestreo el audio
%audio tiene una amplitud de -1 a 1
%-----------------------------------------------------

% Audio(jw)
audioFFT = fftshift(fft(audio));
% FILTRO PASA-BANDA H(jw)
N = length(audio);
freq = (-N/2:N/2-1)*(Fs/N);%centra en 0 

% Especificar las frecuencias de corte del filtro pasabandas en Hz
f_corte1_Hz = 2000; % Frecuencia de corte inferior en Hz
f_corte2_Hz = 3000; % Frecuencia de corte superior en Hz

% Convertir las frecuencias de corte a radianes por segundo
f_corte1_rad = 2 * pi * f_corte1_Hz;
f_corte2_rad = 2 * pi * f_corte2_Hz;

% Crear filtro pasabanda en el dominio de la frecuencia
filtro = zeros(size(freq));
filtro(abs(freq) >= f_corte1_Hz & abs(freq) <= f_corte2_Hz) = 1;

% Aplicar el filtro en el dominio de la frecuencia
% Y(jw)=X(jw).H(jw)
audioFFT_filtrado = audioFFT .* filtro';

% Transformar la señal de vuelta al dominio del tiempo
% y(t)=audio(t)*h(t)
audio_filtrado = ifft(ifftshift(audioFFT_filtrado));

% SALIDA
%-----------------------------------------------------------
audiowrite('audio_filtrado.wav', real(audio_filtrado), Fs);


% SALIDA GRAFICA
%-------H(jw) y h(t)---------------------------------------
syms t w
hw = heaviside(w - f_corte1_rad) - heaviside(w - f_corte2_rad);
ht = ifourier(hw, w, t);

% Graficar H(jw)
figure;
subplot(2,1,1);
fplot(hw, [f_corte1_rad-500, f_corte2_rad+500]);
xlabel('\omega');
ylabel('H(j\omega)');
title('Pulso Rectangular');

% Graficar h(t)
subplot(2,1,2);
fplot(real(ht), [-0.01, 0.01]);
xlabel('t');
ylabel('h(t)');
title('Transformada Inversa de Fourier del Pulso Rectangular');


%DOMINIO TIEMPO
%señales x(t), y(t)
figure;
subplot(2,1,1);
plot((1:length(audio))/Fs, audio, 'color', '#708090');
title('Señal Original en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(2,1,2);
plot((1:length(audio_filtrado))/Fs, real(audio_filtrado), 'color', '#708090');
title('Señal Filtrada en el Dominio del Tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

%DOMINIO FRECUENCIA
%señales X(jw), Y(jw)
figure;
subplot(2,1,1);
plot(freq, abs(audioFFT), 'color', '#008B8B');
title('Señal Original en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

subplot(2,1,2);
plot(freq, abs(audioFFT_filtrado), 'color', '#008B8B');
title('Señal Filtrada en el Dominio de la Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');

