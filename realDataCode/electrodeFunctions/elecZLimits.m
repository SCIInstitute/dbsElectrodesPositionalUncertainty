% c stand for center
function [zLow,zMax] = elecZLimits(contactCenter,eL, eA1, eA2)

% spatially outmost point along the Z axis is some linear combination of z-componenets of d
% and dOrtho
% z-components of D and dOrtho:
zA1 = eA1(3);
zA2 = eA2(3);
% % Choosing maximum of these 2 would give maximum value of all possible
% % linear combinations of xD and xDortho. Thus, we get weight of 1 to maximum
% % of xD and xDortho, and weight of 0 to minimum of xD and xDortho.
% if abs(zD) > abs(zDortho)
%     if zD < zDortho
%         temp1 = center + d;
%         temp2 = center + w - d;
%     else
%         temp1 = center - d;
%         temp2 = center + w + d;
%     end
%     
% elseif abs(zDortho) > abs(zD)
%     if zDortho < zD
%         temp1 = center + dOrtho;
%         temp2 = center + w - dOrtho;
%     else
%         temp1 = center - dOrtho;
%         temp2 = center + w + dOrtho;
%     end
% end

if (eL(3) >= 0)
    % W along +ve Z axis
    if abs(zA1) >= abs(zA2)
        temp1 = contactCenter - eL - abs(eA1);
        temp2 = contactCenter + eL + abs(eA1);
    elseif abs(zA2) > abs(zA1)
        temp1 = contactCenter - eL - abs(eA2);
        temp2 = contactCenter + eL + abs(eA2);
    end
elseif (eL(3) < 0)    
    % W along -ve Z axis
    if abs(zA1) >= abs(zA2)
        temp1 = contactCenter + eL - abs(eA1);
        temp2 = contactCenter - eL + abs(eA1);
    elseif abs(zA2) > abs(zA1)
        temp1 = contactCenter + eL - abs(eA2);
        temp2 = contactCenter - eL + abs(eA2);
    end
end

zLow = temp1(3);
zMax = temp2(3);