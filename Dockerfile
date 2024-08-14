FROM niicloudoperation/notebook
LABEL maintainer="mnagaku"

USER root

RUN apt-get update && apt-get -yq upgrade && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && rm awscliv2.zip && rm -rf aws && \
    pip --no-cache-dir install boto boto3 && \
    pip --no-cache-dir install sshkernel && python -m sshkernel install --sys-prefix && \
    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/ssh --sys-prefix && \
    rm -rf /opt/conda/share/jupyter/lc_wrapper_kernels/bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    chown -R jovyan:users /home/jovyan

USER $NB_USER

