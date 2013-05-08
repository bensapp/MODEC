function hi = flip_hog(hi)
order = get_hog_channel_flip_order();
hi = fliplr(hi);
hi(:,:,order(:,1)) = hi(:,:,order(:,2));

function order = get_hog_channel_flip_order()
%% this specifies the channel swapping required to make edge channels correct:
o = [1  10
    2  9
    3  8
    4  7
    5  5
    6  6
    11 18
    12 17
    13 16
    14 14
    15 15
    19 19
    20 27
    21 26
    22 25
    23 23
    24 24
    28 30
    29 31
    32 32
    ];
T = zeros(max(o(:)));
for i=1:size(o,1);
    T(o(i,1),o(i,2)) = 1;
    T(o(i,2),o(i,1)) = 1;
end
[r,c] = find(T);
order = [r,c];