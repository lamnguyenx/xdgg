FROM condaforge/miniforge3:25.9.1-0

# RUN --mount=type=cache,target=/cache/conda \
#     CONDA_PKGS_DIRS=/cache/conda \
#     conda install -c conda-forge \
#         mitmproxy

RUN --mount=type=cache,target=/tmp/pip_cache \
    PIP_CACHE_DIR=/tmp/pip_cache \
    pip install \
        mitmproxy


CMD ["/bin/bash"]