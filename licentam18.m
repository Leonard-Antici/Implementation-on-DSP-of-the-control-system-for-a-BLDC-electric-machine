%% 1. Codul MATLAB pentru controller-ul PI – params_PI
clc
clear all
close all
F = 200*10^6; %[Hz] system clock
TTBCLK = 1/F;
TiSamplePhaCrt = 10^-4;
Tf_spd = 0.01;
% Inverter PWM config.
F_PWM = 20000; %[Hz]
% the time-base clock (TBCLK) is a prescaled version of the system
% clock (SYSCLKOUT ---- For Up and Down Count ---- TPWM = 2*TBPRD*TTBCLK;
TPWM = 1/F_PWM;
TBPRD1 = uint16(TPWM/(2*TTBCLK));
RED = uint16(50); %rising edge delay
FED = uint16(50); %falling edge delay
% Tasks sampling time
T_pos = 5*10^-4;
Ts_crt_control = 1/30000;
%Tf_crt_control= 1/10000;
Ts_spd_control = 1/10000;
Ts = Ts_crt_control;
% SCI config
serial_data_length = 10;
h = 0.01;
Tf = 0.015;
% Interrupt table config
ECAP1_CPU = 4;
ECAP1_PIE = 1;
SCIA_RX_CPU = 9;
SCIA_RX_PIE = 1;
INT_CPU = [ECAP1_CPU, SCIA_RX_CPU];
INT_PIE = [ ECAP1_PIE, SCIA_RX_PIE];
% Motor control config.
pp = 16/2;   %perechi poli
MinDetectSpeed_RPM = 40; %RPM
MaxDetectSpeed_RPM = 2000; %RPM
MinDetectSpeed_radps = pp*MinDetectSpeed_RPM*pi/30;
MaxDetectSpeed_radps = pp*MaxDetectSpeed_RPM*pi/30;
MinDetectSpeed_period = 1/(MinDetectSpeed_radps/(2*pi));
MaxDetectSpeed_period = 1/(MaxDetectSpeed_radps/(2*pi));
MaxDetectSpeed_Freq = 1/MaxDetectSpeed_period;
MinDetectSpeed_Freq = 1/MinDetectSpeed_period;
Min_eCAP = (MaxDetectSpeed_period/TTBCLK);
Max_eCAP = (MinDetectSpeed_period/TTBCLK);
MaxIter_1_ms_eCAP_wait = MinDetectSpeed_period/T_pos;

vref=3.3;
xT=1.65;
% 12bits ADC=4095
%vref.....4095
%xT.......offset_ADC

offset_ADC = xT*4095/vref;

Rshunt=0.007;

%Isen=10*Ushunt;
%Ishunt=Ushunt/Rshunt;
%Ishunt=(reg_adc_i*vref/4095)/10)/Rshunt;

factor_conversie=(1/Rshunt)*(1/10)*(vref/4095);

%Kalman
TiSamplePos     = T_pos;

