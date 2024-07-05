function y=lowp(x,f1,f3,rp,rs,Fs)

wp=2*pi*f1/Fs;
ws=2*pi*f3/Fs;
[n,wn]=cheb1ord(wp/pi,ws/pi,rp,rs);
[bz1,az1]=cheby1(n,rp,wp/pi);
[h,w]=freqz(bz1,az1,256,Fs);
h=20*log10(abs(h));
y=filter(bz1,az1,x);
index = floor(length(y)*0.1);
if  length(index) > 1100
    y(1:index) =  smooth(x(1:index), 1000)
else
    y(1:index) =  x(1:index);
end