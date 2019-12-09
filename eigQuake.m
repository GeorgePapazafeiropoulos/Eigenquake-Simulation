function UReduced = eigQuake(X,variance)
%
% Calculate eigenquakes from an earthquake suite
%
% [#UReduced#,#XRecovered#] = eigQuake(#X#,#variance#)
%
% Description
%     The eigenquakes of a given earthquake record time history suite are
%     computed. The eigenquakes constitute an orthonormal set of basis
%     vectors which represent characteristic earthquake records, in the
%     sense that any earthquake in the initial suite can be reproduced as a
%     linear combination of these basis vectors. The procedure for the
%     eigenquake calculation is the following:
%     1) Perform Principal Component Analysis (PCA), i.e. calculate the
%     covariance matrix and then perform Singular Value Decomposition (SVD)
%     on it to get the eigenquakes and eigenvalues
%     2) Find number of Principal Components (K) based on the required
%     variance. The formula for calculating minimum K is the following: 
%     {[trace from i=1 to K of S]/[trace of S]} >= variance
%
% Input parameters
%     #X# ([#m# x #n#]): double array containing the time histories of the
%         earthquake suite. Each row contains the time history of an
%         earthquake record. #m# is the number of records in the suite.
%     #variance# (scalar): is the variance based on which the number of the
%         basis vectors is determined.
%
% Output parameters
%     #UReduced# ([#nstep# x 1]): time-history of displacement
%
%__________________________________________________________________________
% Copyright (c) 2019
%     George Papazafeiropoulos
%     Captain, Infrastructure Engineer, Hellenic Air Force
%     Civil Engineer, M.Sc., Ph.D. candidate, NTUA
%     Email: gpapazafeiropoulos@yahoo.gr
% _________________________________________________________________________



% Perform PCA to get eigenquakes and eigenvalues
% Calculate the covariance matrix (Sigma) and then perform svd on it to get
% the eigenquakes and eigenvalues
[m,n] = size(X);
 % Covariance matrix
Sigma = (1/m)*(X')*(X);
% Singular Value Decomposition
[U,S,V] = svd(Sigma);

% Find number of Principal Components (K) based on variance needed
% Formula for calculating minimum K : 
% {[trace from i=1 to K of S]/[trace of S]} >= variance
traceS = trace(S); % Calculate sum of diagonal elements of S
for i=1:size(S,2)
    tempS = sum(diag(S(1:i,1:i))); % sum of K diagonal elements
    if ((tempS/traceS) >= variance)
        break;
    end
end
K = i;

% Consider only the first K features
UReduced = U(:,1:K);

end

