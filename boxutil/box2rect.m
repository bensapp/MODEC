function r = box2rect(boxes)
r = [boxes(:,1:2) boxes(:,3)-boxes(:,1) boxes(:,4)-boxes(:,2)];