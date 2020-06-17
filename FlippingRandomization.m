function [ data ] = FlippingRandomization( dataTree ,tagTree)
%randomize trait values
data=FlipNodes( dataTree,dataTree ,tagTree);

%sort trait values using tags
data=sortrows(data,1);

%delete tags
data(:,1)=[];
end

