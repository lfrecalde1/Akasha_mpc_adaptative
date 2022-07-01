function [h] = system_akasha(h, v, ts, L)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

k1 = function_akasha(h, v, L);   % new
k2 = function_akasha(h + ts/2*k1, v, L); % new
k3 = function_akasha(h + ts/2*k2, v, L); % new
k4 = function_akasha(h + ts*k3, v, L); % new

h = h +ts*(k1); % new
end