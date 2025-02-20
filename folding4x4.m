function y = folding4x4(x, fold)

if fold
  y=cat(3,...
    x(1:4:end,1:4:end,:), ...
    x(1:4:end,2:4:end,:), ...
    x(1:4:end,3:4:end,:), ...
    x(1:4:end,4:4:end,:), ...
    x(2:4:end,1:4:end,:), ...
    x(2:4:end,2:4:end,:), ...
    x(2:4:end,3:4:end,:), ...
    x(2:4:end,4:4:end,:), ...
    x(3:4:end,1:4:end,:), ...
    x(3:4:end,2:4:end,:), ...
    x(3:4:end,3:4:end,:), ...
    x(3:4:end,4:4:end,:), ...
    x(4:4:end,1:4:end,:), ...
    x(4:4:end,2:4:end,:), ...
    x(4:4:end,3:4:end,:), ...
    x(4:4:end,4:4:end,:));
else
  sz = size(x);
  sz(1) = sz(1)*4;
  sz(2) = sz(2)*4;
  sz(3) = sz(3)/16;
  y = zeros(sz);
  y(1:4:end,1:4:end,:) = x(:,:,1:3);
  y(1:4:end,2:4:end,:) = x(:,:,4:6);
  y(1:4:end,3:4:end,:) = x(:,:,7:9);
  y(1:4:end,4:4:end,:) = x(:,:,10:12);
  y(2:4:end,1:4:end,:) = x(:,:,13:15);
  y(2:4:end,2:4:end,:) = x(:,:,16:18);
  y(2:4:end,3:4:end,:) = x(:,:,19:21);
  y(2:4:end,4:4:end,:) = x(:,:,22:24);
  y(3:4:end,1:4:end,:) = x(:,:,25:27);
  y(3:4:end,2:4:end,:) = x(:,:,28:30);
  y(3:4:end,3:4:end,:) = x(:,:,31:33);
  y(3:4:end,4:4:end,:) = x(:,:,34:36);
  y(4:4:end,1:4:end,:) = x(:,:,37:39);
  y(4:4:end,2:4:end,:) = x(:,:,40:42);
  y(4:4:end,3:4:end,:) = x(:,:,43:45);
  y(4:4:end,4:4:end,:) = x(:,:,46:48);
end

