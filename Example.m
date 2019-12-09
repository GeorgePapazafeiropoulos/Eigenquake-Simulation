%% Example
% This example shows the procedure of the calculation of eigenquakes from
% an earthquake record suite, and the reproduction of the initial
% earthquake suite from the basis eigenquakes. It is found that the
% difference between the initial records and their corresponding simulated
% ones is small.
%
% References:
%
% # Alimoradi, A., & Beck, J. L. (2014). Machine-learning methods for
% earthquake ground motion analysis and simulation. Journal of Engineering
% Mechanics, 141(4), 04014147.
% # Alimoradi, A. (2011). Earthquake ground motion simulation using novel
% machine learning tools.
%

%% Install directory
S=mfilename('fullpath');
f=filesep;
ind=strfind(S,f);
S1=S(1:ind(end)-1);
addpath(genpath(S1));
cd(S1)

%% Load earthquake data

%%
%
load X

%% Reduce the earthquake set

%%
% Specify variance
variance = 0.995;

%%
% Normalize the features according to the formula:
% [X - mean(X)]/ std(X)
X2=X;
mu = mean(X2);
stddev = std(X2);

%%
% Subtract mean of each feature from original value
X2 = bsxfun(@minus,X2,mu);

%%
% Divide by standard deviation
X2 = bsxfun(@rdivide,X2,stddev);

%%
% Perform eigenquake reduction
UReduced = eigQuake(X2,variance);

%% Simulate the initial earthquake suite

%%
% Get data with reduced set of features.
reducedData = X2*UReduced;

%%
% Simulate the original data from the data set with reduced features.
XRecovered = reducedData*(UReduced');

%%
% Perform the inverse of the normalization process that is done in the
% beginning prior to performing PCA
XRecovered = bsxfun(@times,XRecovered,stddev);
XRecovered = bsxfun(@plus,XRecovered,mu);

%% Plots

%%
% Set the number of eigenquakes to be plotted
nEigQ=6;

%%
% Plot eigenquakes
for i=1:nEigQ
    figure(i)
    plot(UReduced(:,i));
    legend({['EigenQuake ',num2str(i)]})
end

%%
% Plot original and recovered earthquakes
for i=1:nEigQ
    figure(nEigQ+i)
    plot(X(i,:))
    hold on
    plot(XRecovered(i,:))
    legend({['EarthQuake ',num2str(i),' - initial'],...
        ['EarthQuake ',num2str(i),' - simulation']})
end

%%
%  ________________________________________________________________________
%  Copyright (c) 2019
%  George Papazafeiropoulos
%  Captain, Infrastructure Engineer, Hellenic Air Force
%  Civil Engineer, M.Sc., Ph.D. candidate, NTUA
%  Email: gpapazafeiropoulos@yahoo.gr
%  ________________________________________________________________________

