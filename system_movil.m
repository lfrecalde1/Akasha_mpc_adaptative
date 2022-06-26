function [h] = system_movil(h, v, ts, L)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

k1 = function_movil(h, v, L);   % new
k2 = function_movil(h + ts/2*k1, v, L); % new
k3 = function_movil(h + ts/2*k2, v, L); % new
k4 = function_movil(h + ts*k3, v, L); % new

h = h +ts/6*(k1 +2*k2 +2*k3 +k4); % new
end