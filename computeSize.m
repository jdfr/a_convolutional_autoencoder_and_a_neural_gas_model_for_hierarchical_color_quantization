function compressedSizeBits = computeSize(Modelo, size_init, use_autoencoder, folding, latentsize)

use_algorithm     = ~isempty(Modelo);

realToBits        = 16;

size_reduced      = size_init/folding;

numpixels_init    = size_init(1)   *size_init(2);
numpixels_reduced = size_reduced(1)*size_reduced(2);

numel_DecoderWeights   = latentsize*folding*folding*3;
numel_DecoderBiases    = folding*folding*3;

if use_autoencoder
  compressedSizeBits   = realToBits*(numel_DecoderWeights+numel_DecoderBiases);
  if use_algorithm
    Centroids          = GetCentroidsGHBNG(Modelo);
    NumNeurons         = size(Centroids,2);
    compressedSizeBits = compressedSizeBits + numpixels_reduced*(ceil(log2(NumNeurons))) + realToBits*latentsize*NumNeurons;
    fprintf('Use autoencoder and algorithm!: folding %d, latentsize %d, NumNeurons %d, weights %g + pixels %g + latents %g = %g\n', folding, latentsize, NumNeurons, realToBits*(numel_DecoderWeights+numel_DecoderBiases), numpixels_reduced*(ceil(log2(NumNeurons))), realToBits*latentsize*NumNeurons, compressedSizeBits);
  else
    compressedSizeBits = compressedSizeBits + realToBits*latentsize*numpixels_reduced;
    fprintf('Use just autoencoder!: folding %d, latentsize %d, weights %g + latents %g = %g\n', folding, latentsize, realToBits*(numel_DecoderWeights+numel_DecoderBiases), realToBits*latentsize*numpixels_reduced, compressedSizeBits);
  end
else
  if use_algorithm
    Centroids          = GetCentroidsGHBNG(Modelo);
    NumNeurons         = size(Centroids,2);
    compressedSizeBits = numpixels_init*(ceil(log2(NumNeurons))) + 8*3*NumNeurons;
    fprintf('Use just algorithm!: NumNeurons %d, pixels %g + colors %g = %g\n', NumNeurons, numpixels_init*(ceil(log2(NumNeurons))), 8*3*NumNeurons, compressedSizeBits);
  end
end


