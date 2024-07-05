function hua_fft(y,fs,style,varargin)

nfft= 2^nextpow2(length(y)); 
  y=y-mean(y);
y_ft=fft(y,nfft);
y_p=y_ft.*conj(y_ft)/nfft;
y_f=fs*(0:nfft/2-1)/nfft;


if style==1
    if nargin==3
        plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));
    else
        f1=varargin{1};
        fn=varargin{2};
        ni=round(f1 * nfft/fs+1);
        na=round(fn * nfft/fs+1);
        plot(y_f(ni:na),abs(y_ft(ni:na)*2/nfft));
    end
elseif style==2
            plot(y_f,y_p(1:nfft/2));
    else
        subplot(211);plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));
        subplot(212);plot(y_f,y_p(1:nfft/2));
    end
end