function [img, isRandomized] = medianCut(img, modo, randomized, depth)

%n=4; img = imread('4k/picturesque.png'); img = imresize(img, [128, 128]); img2=medianCut(img, 0, n); img3=medianCut(img,1,n); img4=medianCut(img,2,n); subplot(2,2,1); imshow(img); xlabel('original'); subplot(2,2,2); imshow(img2); xlabel('median cut mean'); subplot(2,2,3); imshow(img3); xlabel('median cut medoid determinist'); subplot(2,2,4); imshow(img4); xlabel('median cut medoid randomized');

[sx sy nc] = size(img);
isUint8 = strcmp(class(img), 'uint8');

imgPixs = reshape(img, sx*sy, nc);
if isUint8
  imgPixs = int32(imgPixs);
end

%[row, col] = ind2sub([sx sy], 1:(sx*sy));
idxs = (1:(sx*sy))';

img_arr = [imgPixs, idxs];

imgs = cell(nc,1);
for k=1:nc
  if isUint8
    imgs{k} = zeros(sx, sy, 'uint8');
  else
    imgs{k} = zeros(sx, sy);
  end
end

[imgs, isRandomized] = split_into_buckets(imgs, false, img_arr, nc, modo, randomized, depth);

for k=1:nc
  img(:,:,k) = imgs{k};
end

function [imgs, isRandomized] = split_into_buckets(imgs, isRandomized, img_arr, nc, modo, randomized, depth)

  if numel(img_arr)==0
    return
  end
  if depth==0
    [imgs, isRandomized] = median_cut_quantize(imgs, isRandomized, img_arr, nc, modo, randomized);
    return;
  end
  ranges = nan(nc,1);
  for k=1:nc
    ranges(k) = max(img_arr(:,k))-min(img_arr(:,k));
  end
  [maximal,largest] = max(ranges);
  if randomized
    all_idxs = find(ranges==maximal);
    if numel(all_idxs)>1
      isRandomized = true;
      largest = all_idxs(randi(numel(all_idxs)));
    end
  end
  [~, idxs] = sort(img_arr(:,largest));
  img_arr = img_arr(idxs,:);
  median_index = round((numel(idxs))/2);
  [imgs, isRandomized] = split_into_buckets(imgs, isRandomized, img_arr(1:median_index,:), nc, modo, randomized, depth-1);
  [imgs, isRandomized] = split_into_buckets(imgs, isRandomized, img_arr(median_index+1:end,:), nc, modo, randomized, depth-1);

function [imgs, isRandomized] = median_cut_quantize(imgs, isRandomized, img_arr, nc, modo, randomized);

  if     modo==0 % cluster center
    mn = mean(img_arr(:,1:nc), 1);
  elseif modo==1 % cluster medoid
    dists = squareform(pdist(double(img_arr(:,1:nc))));
    sumdst = sum(dists,1);
    sumdst = sumdst/max(sumdst);
    [minimal,idx] = min(sumdst);
    if randomized
      all_idxs = find(sumdst==minimal);
      if numel(all_idxs)>1
        isRandomized = true;
        idx = all_idxs(randi(numel(all_idxs)));
      end
    end
    mn = img_arr(idx,1:nc);
  end
  idxs = img_arr(:,nc+1);
  for k=1:nc
    imgs{k}(idxs) = mn(k);
  end


