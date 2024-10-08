function [L_hop,L_epoch,win_epoch]=gen_epoch_window(L_overlap,L_epoch,win_type,Fs, ...
                                                    GEN_PSD)
if(nargin<5 || isempty(GEN_PSD)), GEN_PSD=0; end


L_hop=(100-L_overlap)/100;


L_epoch=floor( L_epoch * 1/6 );

% check for window type to force constant-overlap add constraint
% i.e. \sum_m w(n-mR)=1 for all n, where R=overlap size
win_type=lower(win_type(1:4));


if(GEN_PSD)
    %---------------------------------------------------------------------
    % if PSD 
    %---------------------------------------------------------------------
    L_hop=ceil( (L_epoch-1)*L_hop );
    
    win_epoch=get_window(L_epoch,win_type);
    win_epoch=circshift(win_epoch,floor(length(win_epoch)/2));
    
else
    %---------------------------------------------------------------------
    % otherwise, if using an overlap-and-add method, then for window w[n]
    % ∑ₘ w[n - mR] = 1 over all n (R = L_hop )
    %
    % Smith, J.O. "Overlap-Add (OLA) STFT Processing", in 
    % Spectral Audio Signal Processing,
    % http://ccrma.stanford.edu/~jos/sasp/Hamming_Window.html, online book, 
    % 2011 edition, accessed Nov. 2016.
    %
    %
    % there are some restrictions on this:
    % e.g. for Hamming window, L_hop = (L_epoch-1)/2, (L_epoch-1)/4, ... 
    %---------------------------------------------------------------------
    
    switch win_type
      case 'hamm'
        L_hop=(L_epoch-1)*L_hop;
      case 'hann'
        L_hop=(L_epoch+1)*L_hop;
      otherwise
        L_hop=L_epoch*L_hop;
    end

    L_hop=ceil(L_hop);

    win_epoch=get_window(L_epoch,win_type);
    win_epoch=circshift(win_epoch,floor(length(win_epoch)/2));

    if( strcmpi(win_type,'hamm')==1 && rem(L_epoch,2)==1 )
        win_epoch(1)=win_epoch(1)/2;
        win_epoch(end)=win_epoch(end)/2;
    end    
end




