FROM niicloudoperation/notebook
MAINTAINER mnagaku

USER root

RUN apt-get update && apt-get -y upgrade && apt-get install -y awscli lsb-release gnupg && \
    pip install boto3 boto && \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-bionic main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && sudo apt-get install -y google-cloud-sdk && \
    pip install -U sshkernel && python -m sshkernel install --sys-prefix && \
    pip install powershell_kernel && python -m powershell_kernel.install --sys-prefix && \
    pip install ansible-kernel && python -m ansible_kernel.install --sys-prefix && \
    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/ssh --sys-prefix && \
    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/powershell --sys-prefix && \
    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/ansible --sys-prefix && \
    rm -rf /opt/conda/share/jupyter/lc_wrapper_kernels/bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_USER
