lammps
======

This is a docker container that runs a standard  install of [LAMMPS] with MPI support.

Packages
--------

The install is compiled with the following packages

- standard
- no-compress
- no-gpu
- no-kim
- no-kokkos
- no-voronoi

The excluded packages are excluded due to the more complicated install of the
extra libraries required to install them.

Running
-------

Opening a shell to the container can be done using the command

    docker run -ti -v $(pwd):/srv/input -v $HOME/scratch:/srv/scratch malramsay/lammps

[LAMMPS](http://lammps.sandia.gov/)
