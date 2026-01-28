#!/bin/bash

# Crée le dossier build s'il n'existe pas et va dedans
mkdir -p build
cd build

# Génère ou met à jour les fichiers de compilation
cmake ..

# Compile le projet
cmake --build .

# Lance l'exécutable
./Sterilizer