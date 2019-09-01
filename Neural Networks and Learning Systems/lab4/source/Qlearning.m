%% Initialization
%  Initialize the world, Q-table, and hyperparameters
world_no = 4;
gwinit(world_no);

s = gwstate;

% define map properties
xsize = s.xsize;
ysize = s.ysize;
actions = [1,2,3,4];
probs = [1,1,1,1];
n_action = 4;
% Define the Q-table
Q = rand(ysize, xsize, n_action);
Q(1,:,2) = -inf;
Q(ysize,:,1) = -inf;
Q(:,1,4) = -inf;
Q(:,xsize,3) = -inf;

% parameters
discount_factor = 0.9;
learning_rate = 0.2;
max_steps = 100;
total_episodes = 2500;

%% Training loop
%  Train the agent using the Q-learning algorithm.
for eps = 1: total_episodes
    gwinit(world_no);
    s_1 = gwstate;
    exploration_factor = getepsilon(eps, total_episodes);
    for i = 1:max_steps
        [act, opt_act] = chooseaction(Q, s_1.pos(1), s_1.pos(2), actions, probs, exploration_factor);
        s_i = gwaction(act);
        while ~ s_i.isvalid
            %display("edge changed")
            [act, opt_act] = chooseaction(Q, s_1.pos(1), s_1.pos(2), actions, probs, exploration_factor);
            s_i = gwaction(act);
        end
        
        Q(s_1.pos(1), s_1.pos(2), act) = ...
            (1-learning_rate) * Q(s_1.pos(1), s_1.pos(2), act) + ...
            learning_rate * (s_i.feedback + discount_factor * max(squeeze(Q(s_i.pos(1), s_i.pos(2),:))));
       
        
        
        if s_i.isterminal
            %display(i);
            %display("Here is my gooaal! Thanks for training me!");
            break;
        else
            s_1 = s_i;
        end
    end
end

gwdraw(Q)

%% Test loop Arrow the Path
%  Test the agent (subjectively) by letting it use the optimal policy
%  to traverse the gridworld. Do not update the Q-table when testing.
%  Also, you should not explore when testing, i.e. epsilon=0, always pick
%  the optimal action.

% get optimal policy for each state
opt_policy = gwgetpolicy(Q);
% initialize a random world
gwinit(world_no);
% parameters
step_i = 1
max_steps = 200;

gwdraw

while step_i<max_steps
    % change current state
    cur_step = gwstate;
    % get the optimal action from optimal policy
    act = opt_policy(cur_step.pos(1), cur_step.pos(2))
    % plote the action
    gwplotarrow(cur_step.pos, act)
    % check if next step is  terminal
    % get the next step's state
    next_step = gwaction(act)
    if next_step.isterminal
        display("Thanks for training me, you are a perfect person <3")
        break
    else
        % increment step count
        step_i = step_i + 1
    end
end

%% Plot V Function as surface
[V, ~] = max(Q, [], 3);
surf(V)

%% Test loop Animation
%  Test the agent (subjectively) by letting it use the optimal policy
%  to traverse the gridworld. Do not update the Q-table when testing.
%  Also, you should not explore when testing, i.e. epsilon=0, always pick
%  the optimal action.
opt_policy = gwgetpolicy(Q);

gwinit(world_no);
max_steps = 400;



while max_steps>0
    cur_step = gwstate;
    act = opt_policy(cur_step.pos(1), cur_step.pos(2))
    next_step = gwaction(act)
    gwdraw
    max_steps = max_steps - 1
    if next_step.isterminal
        display("Thanks for training me, you are a perfect person <3")
        break
    end
end



