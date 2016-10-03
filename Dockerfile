#
# Copyright (c) 2016 Malcolm Ramsay malramsay64@gmail.com
#
# Dockerfile to run lammps on a CentOS base install

FROM centos:7.2.1511

RUN yum -y update &&\
    yum -y install \
    git \
    make \
    gcc-c++ \
    wget \
    bc \
    python-devel \
    zlib-devel \
    fftw3-devel \
    mpich-devel && \
    yum clean all 

#RUN wget -P /tmp https://packages.openkim.org/rpm/centos/openkim-centos-rhel-repo-1-2.noarch.rpm && \
    #rpm -i /tmp/openkim-centos-rhel-repo-1-2.noarch.rpm && \
    #rm /tmp/openkim-centos-rhel-repo-1-2.noarch.rpm && \
    #yum update && \
    #yum -y install kim-api

#RUN wget -P /tmp http://math.lbl.gov/voro++/download/dir/voro++-0.4.6.tar.gz && \
    #cd /tmp && \
    #tar xvzf voro++-0.4.6.tar.gz && \
    #cd voro++-0.4.6 && \
    #make && make install && \
    #rm -rf /tmp/voro*

RUN git clone git://git.lammps.org/lammps-ro.git /srv/lammps &&\ 
    cd /srv/lammps && \
    git checkout r15407 && \
    cd src && \
    mkdir -p MAKE/MINE

RUN cd /srv/lammps/src && \
    export PATH=$PATH:/usr/lib64/mpich/bin && \
    python Make.py -m none -cc g++ -mpi mpich -fft fftw3 -a file && \
    python Make.py -m auto -a lib-meam lib-poems lib-reax && \
    python Make.py -m auto -p standard no-compress no-gpu no-kim no-kokkos no-voronoi
    #python Make.py -m auto  

RUN cd /srv/lammps/src && \
    make -j 4 auto MPI_INC="-DMPICH_SKIP_MPICXX -I/usr/include/mpich-x86_64" MPI_LIB="-Wl,-rpath,/usr/lib64/mpich/lib -L/usr/lib64/mpich/lib -lmpl -lmpich" FFT_LIB="-lfftw3" && \
    cp lmp_auto /usr/bin/lmp_mpi

ENV PATH /usr/lib64/mpich/bin:${PATH}






