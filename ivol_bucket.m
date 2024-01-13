function [value] = ivol_bucket(vol,volunder,volupper,n)
if isnan(vol)
    value = 0;
elseif (vol>volunder) && (vol<=volupper)
    value = n;
else
    value = 0;
end