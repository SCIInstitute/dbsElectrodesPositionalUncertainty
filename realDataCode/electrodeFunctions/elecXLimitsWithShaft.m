function [xLow,xMax] = elecXLimitsWithShaft(electrodeCenter, eL, eA1, eA2)

% spatially outmost point along the X axis is some linear combination of
% x-componenets of A1 and A2
% x-components of A1 and A2:
xA1 = eA1(1);
xA2 = eA2(1);
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

if (eL(1) >= 0)
    % L in Octant 1 (+ve X, +ve Y and +ve Z)
    % or in general when L is along +ve X axis
    if abs(xA1) >= abs(xA2)
        temp1 = electrodeCenter - eL - abs(eA1);
        % One end is shaft. When L along +ve x, negative end belongs to
        % terminal contact and positive end belongs to shaft
        temp2 = electrodeCenter + eL + abs(eA1/norm(eA1)*0.32);
    elseif abs(xA2) > abs(xA1)
        temp1 = electrodeCenter - eL - abs(eA2);
        temp2 = electrodeCenter + eL + abs(eA2/norm(eA2)*0.32);
    end
elseif (eL(1) < 0)    
    % L in Octant 2 (-ve X, +ve Y and +ve Z)
    % or in general when L is along -ve X axis
    if abs(xA1) >= abs(xA2)
        % One end is shaft. When L along -ve x, negative end belongs to
        % shaft and positive end belongs to terminal contact
        temp1 = electrodeCenter + eL - abs(eA1/norm(eA1)*0.32);
        temp2 = electrodeCenter - eL + abs(eA1);
    elseif abs(xA2) > abs(xA1)
        temp1 = electrodeCenter + eL - abs(eA2/norm(eA2)*0.32);
        temp2 = electrodeCenter - eL + abs(eA2);
    end
end

xLow = temp1(1);
xMax = temp2(1);