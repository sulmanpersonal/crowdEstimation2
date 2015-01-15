%% normalizeTransitionAndDelta normalize the Transition across rows and Delta across time dimension
% @params:  Transition => TRANSITION_P / TRANSITION_N matrix to edit
%           Transition data according to the trajectory
%           Delta => DELTAT_P / DELTAT_N matrix to edit the transition time
%           according to the trajectory
% @return:  TransitionNorm => TRANSITION_P_NORM / TRANSITION_N_NORM matrix
%           that has normalized values of given transition matrix
%           DeltaNorm => DELTAT_P_NORM / DELTAT_N_NORM matrix
%           that has normalized values of given delta matrix
function [ TransitionNorm, DeltaNorm ] = normalizeTransitionAndDelta( Transition, Delta )
% normalize across rows
TransitionNorm = Transition./repmat(sum(Transition,2),[1 size(Transition,2)]);
TransitionNorm(isnan(TransitionNorm))=0;

% normalize across 3rd dimension
DeltaNorm = Delta./repmat(sum(Delta,2),[1 size(Delta,2) 1]);
DeltaNorm(isnan(DeltaNorm))=0;
end

