%Basic example of one- and two-sided correlation
%data sequences must first be set up

%two sided correlation examined first
N = 4;
%create verticle vector of data
x = [1:4]';
y = [6:9]';
%create the two sided correlation
CCR2 = zeros(2 * N - 1, 1);

%iterate over all possible lags from -N + 1 to N - 1
for lag = -N + 1 : N - 1
    %set the CC sum for each lag
    CC = 0;
    %loop over all of the signal indices, the lag is computed for the
    %indices
    for idx = 1 : N
        lag_idx = idx - lag;
        %ensure that the lag is within the bounds of our signal. If it is
        %within bounds add to our CC
        
        %the only time this is true is when idx = 4, then lag_idx = 4 + 3 =
        %1
        if((lag_idx >= 1) && (lag_idx <= N))
            CC = CC + x (idx) * y (lag_idx);
        end
    end
    
    %ensures correct indexing for postive and negative lags
    CCR2(lag + N) = CC;
end
disp('Double sided CCR');
disp(CCR2)

%one-sided correlation
CCR1 = zeros(N, 1);

%iterate over all lags from = 0 to N-1
for lag = 0 : N - 1
    %set the CC sum for each lag
    CC = 0;
    %loop over all of the signal indices
    for idx = lag + 1:N
        lag_idx = idx - lag;
        CC = CC + x(idx) * y(lag_idx);
    end
    
    CCR1(lag + 1) = CC;
end

disp('Single sided CCR')
disp(CCR1);