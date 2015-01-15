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
sumOfTranNorm = sum(TransitionNorm,2);
for a=1:1:length(sumOfTranNorm)
    if(sumOfTranNorm(a) == 0)
        TransitionNorm(a,:) = 1/length(sumOfTranNorm);
    end
end

% normalize across 3rd dimension
DeltaNorm = zeros(size(Delta));
for a=1:1:size(Delta,1)
    for b=1:1:size(Delta,2)
        x = sum(Delta(a,b,1:size(Delta,3)));
        if x~=0
            for c=1:1:size(Delta,3)
                DeltaNorm(a,b,c) = Delta(a,b,c)/x;
            end
        else
            DeltaNorm(a,b,1:size(Delta,3)) = 1/size(Delta,3);
        end
    end
end

