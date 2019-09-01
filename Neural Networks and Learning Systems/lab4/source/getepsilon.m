function epsilon = getepsilon(episode, maxEpisodes)
% GETEPSILON Function for getting epsilon (exploration factor) given several
% parameters, e.g. the current and total number of episodes.
% You may choose not to use this function but it might be helpful if you
% would like to plot how epsilon changes during the training. If you choose
% to use this function you are free to add or remove any parameters.
%
% Implement your own epsilon-function here if you want to.

    epsilon = 1 - episode / maxEpisodes;

end

