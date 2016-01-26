================================================================================================================================
lazar read across models for lowest adverse effect levels: A comparison of experimental variability with read across predictions 
================================================================================================================================

Christoph Helma, David Vorgrimmler, Martin Guetlein, Denis Gebele, Elena Lo Piparo

in silico toxicology gmbh, Rastatterstrasse 41, 4051 Basel, Switzerland

# Introduction

The main objectives of this study are

 - to investigate the experimental variability of LOAEL data
 - develop predictive model for lowest observed effect levels
 - compare the performance of model predictions with experimental variability

# Methods

## Data

### Mazzatorta dataset

### Swiss dataset

### Preprocessing

Missing and invalid SMILES
Unfortunately no identifier is complete across all compound  therefore we focused on SMILES. Missing SMILES were generated from other identifiers when available. 


study type/ table
        rat_chron
        mouse_chron
        multigen
        missing SMILES
        35
        27
        31
        invalid SMILES
        9
        6
        9
        corrected SMILES
        44
        33
        40
        Detailed tables:
https://docs.google.com/spreadsheets/d/14P8F-3iX5gr5FbN7oSeuwabUOr_xdDhhr5KwiUX6LXY/edit?usp=sharing


## Algorithms

For this study we are using the modular lazar (*la*zy *s*tructure *a*ctivity *r*elationships) framework (helma..) for model development and validation. 

lazar follows the following basic workflow: For a given chemical structure it searches in a database for similar structures (neighbors) with experimental data, builds a local (Q)SAR model with these neighbors and uses this model to predict the unknown activity of the query compound. This procedure resembles an automated version of *read across* predictions in toxicology, in machine learning terms it would be classified as a *k-nearest-neighbor* algorithm. 

Apart from this basic workflow lazar is completely modular and allows the researcher to use any algorithm for neighbor identification and local (Q)SAR modelling. Within this study we are using the following algorithms:

### Neighbor identification

Similarity calculations are based on TODO fingerprints (Bender 2003) from the OpenBabel chemoinformatics library (TODO). 
The TODO fingerprint uses atom environments as molecular representation, which resemble basically the chemical concept of functional groups. For each atom in a molecule the atom types of connected atoms are recorded. The same procedure is repeated for connected atoms up to a given distance of chemical bonds. From this data a vector with atom type counts at a given distance from the central atom is constructed. These vectors are used to calculate chemical similarities.

TODO: example???

Similarities are expressed as Tanimoto index 

TODO: Jaquard index?
TODO: formula
TODO: similarity threshold

Such a 
In machine learning

The main advantage of TODO fingerprints in comparison to fingerprints with predefined substructures such as MACCs fingerprints (TODO) is that 

TODO; toxicological relevance

Preliminary experiments have shown that predictions with TODO fingerprints are more accurate than fingerprints with predefined substructures (OpenBabel FP TODO) fingerprints, which is in agreement with findings in the literature (TOCDO cite).

### Local (Q)SAR models

As soon as neighbors for a query compound have been identified, we can use their experimental LOAEL values to predict the activity of the untested compound. In this case we are using the weighted mean (TODO median?) of the neighbors LOAEL values, where the contribution of each neighbor is weighted by its similarity to the query compound.

### Validation

## Results

### Dataset comparison

#### Structural composition

##### Ches-Mapper analysis

##### Distribution of functional groups

#### LOAEL values

##### Intra dataset variability

p-value: 0.4750771581019402

.. image:: loael-dataset-comparison-all-compounds.pdf

##### Inter dataset variability

.. image:: loael-dataset-comparison-common-compounds.pdf

##### LOAEL correlation between datasets

using means

.. image:: loael-dataset-correlation.pdf

with "identical" values

  r^2: 0.6106457754533314
  RMSE: 1.2228212261024438
  MAE: 0.801626064534318

### Read across predictions

## Discussion

### Chemical similarity 

### LOAEL variability

### Predictive performance

### 


