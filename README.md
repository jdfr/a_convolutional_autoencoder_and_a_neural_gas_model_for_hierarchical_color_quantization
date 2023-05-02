# A convolutional autoencoder and a neural gas model based on Bregman divergences for hierarchical color quantization

This is the source code used to get the results in the paper "A convolutional autoencoder and a neural gas model based on Bregman divergences for hierarchical color quantization", accepted for publication in the journal Neurocomputing.

The code is written by Jose David Fernandez Rodriguez, building upon previous code for competitive clustering techniques (in a classic learning setting, i.e. before integrating convolutional autoencoders, and with a more limited analysis of results) by Jesus de Benito Picazo, Esteban Palomo Ferrer and Ezequiel Lopez Rubio.

The code is written as a set of Matlab scripts working together with a python script (`pruebaconv1.py`) to train and run the convolutional autoencoders using pytorch.

The main entry points to run experiments are `PruebasCuantificacionExternalAutoencoder.m`, `PruebasCuantificacionDivergenciasBregman.m`, `PruebasCuantificacionDivergenciasBregmanMatlabAutoencoder.m`, `PruebasCuantificacionDivergenciasBregmanAutoencoder.m`, `PruebasCuantificacionMulti.m`, `PruebasCuantificacionExternalAutoencoderExtension.m`, `PruebasCuantificacionDivergenciasBregmanConVentanas.m` and `PruebasMedianCutJustImage.m`. The main entry points to summarize and show data from the experiments are `compileAllData.m`, `seeResults.m`, `showPareto.m`, and `showPareto3.m`.

The images used to run the experiments described in the paper are available in the various folders (some of them appear more than once).

The parts of the code written by the authors are released under the GNU GPL.
