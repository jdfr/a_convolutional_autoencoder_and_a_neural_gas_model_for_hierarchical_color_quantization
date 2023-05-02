function y = folding2x2(x, fold)

if fold
  y=cat(3,...
    x(1:2:end,1:2:end,:), ...
    x(1:2:end,2:2:end,:), ...
    x(2:2:end,1:2:end,:), ...
    x(2:2:end,2:2:end,:));
else
  sz = size(x);
  sz(1) = sz(1)*2;
  sz(2) = sz(2)*2;
  sz(3) = sz(3)/4;
  y = zeros(sz);
  y(1:2:end,1:2:end,:) = x(:,:,1:3);
  y(1:2:end,2:2:end,:) = x(:,:,4:6);
  y(2:2:end,1:2:end,:) = x(:,:,7:9);
  y(2:2:end,2:2:end,:) = x(:,:,10:12);
end

