function [xLow,xMax] = xLimits(contactCenter,L, A1, A2)

% spatially outmost point along the X axis is some linear combination of x-componenets of d
% and dOrtho
% x-components of D and dOrtho:
xA1 = A1(1);
xA2 = A2(1);
% % Choosing maximum of these 2 would give maximum value of all possible
% % linear combinations of xD and xDortho. Thus, we get weight of 1 to maximum
% % of xD and xDortho, and weight of 0 to minimum of xD and xDortho.
% if abs(xD) > abs(xDortho)
%     if xD < xDortho
%         temp1 = center + d;
%         temp2 = center + w - d;
%     else
%         temp1 = center - d;
%         temp2 = center + w + d;
%     end
%     
% elseif abs(xDortho) > abs(xD)
%     if xDortho < xD
%         temp1 = center + dOrtho;
%         temp2 = center + w - dOrtho;
%     else
%         temp1 = center - dOrtho;
%         temp2 = center + w + dOrtho;
%     end
% end

if (L(1) >= 0)
    % W in Octant 1 (+ve X, +ve Y and +ve Z)
    % Similar analysis when W along +ve X axis
    if abs(xA1) >= abs(xA2)
        temp1 = contactCenter - L - abs(A1);
        temp2 = contactCenter + L + abs(A1);
    elseif abs(xA2) > abs(xA1)
        temp1 = contactCenter - L - abs(A2);
        temp2 = contactCenter + L + abs(A2);
    end
elseif (L(1) < 0)    
    % W in Octant 2 (-ve X, +ve Y and +ve Z)
    % Similar analysis when W along -ve X axis
    if abs(xA1) >= abs(xA2)
        temp1 = contactCenter + L - abs(A1);
        temp2 = contactCenter - L + abs(A1);
    elseif abs(xA2) > abs(xA1)
        temp1 = contactCenter + L - abs(A2);
        temp2 = contactCenter - L + abs(A2);
    end
end

xLow = temp1(1);
xMax = temp2(1);