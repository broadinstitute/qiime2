FROM quay.io/broadinstitute/viral-baseimage:0.1.20

LABEL maintainer "viral-ngs@broadinstitute.org"

ENV \
	MINICONDA_PATH="/opt/miniconda" \
	CONDA_DEFAULT_ENV=qiime2
ENV \
	PATH="$MINICONDA_PATH/envs/$CONDA_DEFAULT_ENV/bin:$MINICONDA_PATH/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Prepare viral-ngs user and installation directory
# Set it up so that this slow & heavy build layer is cached
# unless the requirements* files or the install scripts actually change
WORKDIR /opt
RUN conda create -n $CONDA_DEFAULT_ENV python=3.9
RUN echo "source activate $CONDA_DEFAULT_ENV" > ~/.bashrc
RUN hash -r
COPY requirements-conda.txt /opt
RUN mamba install -y -p "$MINICONDA_PATH/envs/$CONDA_DEFAULT_ENV" \
    -c qiime2/label/r2022.8 -c conda-forge -c bioconda -c defaults \
    --file /opt/requirements-conda.txt

CMD ["/bin/bash"]