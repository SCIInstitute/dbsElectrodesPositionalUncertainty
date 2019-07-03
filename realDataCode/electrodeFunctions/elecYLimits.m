function [yLow,yMax] = elecYLimits(contactCenter,eL, eA1, eA2)

% spatially outmost point along the Y axis is some linear combination of y-componenets of d
% and dOrtho
% y-components of D and dOrtho:
 yA1 = eA1(2);
 yA2 = eA2(2);
% % Choosing maximum of these 2 would give maximum value of all possible
% % linear combinations of yD and yDortho. Thus, we get weight of 1 to maximum
% % of yD and yDortho, and weight of 0 to minimum of yD and yDortho.
% if abs(yD) > abs(yDortho)
%     if yD < yDortho
%         temp1 = center + d;
%         temp2 = center + w - d;
%     else
%         temp1 = center - d;
%         temp2 = center + w + d;
%     end
%     
% elseif abs(yDortho) > abs(yD)
%     if yDortho < yD
%         temp1 = center + dOrtho;
%         temp2 = center + w - dOrtho;
%     else
%         temp1 = center - dOrtho;
%         temp2 = center + w + dOrtho;
%     end
% end

if (eL(2) >= 0)
    % W along +ve Y axis
    if abs(yA1) >= abs(yA2)
        temp1 = contactCenter - eL - abs(eA1);
        temp2 = contactCenter + eL + abs(eA1);
    elseif abs(yA2) > abs(yA1)
        temp1 = contactCenter - eL - abs(eA2);
        temp2 = contactCenter + eL + abs(eA2);
    end
elseif (eL(2) < 0)    
    % W along -ve Y axis
    if abs(yA1) >= abs(yA2)
        temp1 = contactCenter + eL - abs(eA1);
        temp2 = contactCenter - eL + abs(eA1);
    elseif abs(yA2) > abs(yA1)
        temp1 = contactCenter + eL - abs(eA2);
        temp2 = contactCenter - eL + abs(eA2);
    end
end

yLow = temp1(2);
yMax = temp2(2);