function y = folding(x, foldNumber, direction)

if foldNumber==1
  y=x;
elseif foldNumber==2
  if direction
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
elseif foldNumber==4
  if direction
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
elseif foldNumber==8
  if direction
    ys = cell(8*8,1);
    ab=1;
    for a=1:8
      for b=1:8
        ys{ab}=x(a:8:end,b:8:end,:);
        ab=ab+1;
      end
    end
    y=cat(3, ys{:});
  else
    sz = size(x);
    sz(1) = sz(1)*8;
    sz(2) = sz(2)*8;
    sz(3) = sz(3)/(8*8);
    y = zeros(sz);
    n1=1;
    n2=3;
    for a=1:8
      for b=1:8
        y(a:8:end,b:8:end,:) = x(:,:,n1:n2);
        n1=n1+3;
        n2=n2+3;
      end
    end
  end
end
