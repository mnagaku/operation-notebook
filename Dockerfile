FROM niicloudoperation/notebook
MAINTAINER mnagaku

USER root

RUN apt-get update && apt-get -y upgrade && apt-get install -y apt-utils apt-transport-https ca-certificates gnupg \
    unzip groff less dirmngr software-properties-common libcurl4-openssl-dev libxml2-dev file && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && apt-get install -y google-cloud-sdk && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y kubeadm kubectl kubelet && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && \
    rm awscliv2.zip && rm -rf aws && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/' && \
    apt-get update && apt-get install -y r-base && \
    Rscript -e "install.packages(c('repr','IRdisplay','evaluate','crayon','pbdZMQ','devtools','uuid','digest','IRkernel',\
    'tidyverse','RcppRoll','caret'), dependencies=TRUE)" && \
    pip --no-cache-dir install aws-parallelcluster ansible-jupyter-widgets boto boto3 && \
    pip --no-cache-dir install sshkernel && python -m sshkernel install --sys-prefix && \
#    pip --no-cache-dir install ansible-kernel && python -m ansible_kernel.install --sys-prefix && \
    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/ssh --sys-prefix && \
#    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/ansible --sys-prefix && \
    jupyter wrapper-kernelspec install /usr/local/lib/R/site-library/IRkernel/kernelspec --sys-prefix && \
    rm -rf /opt/conda/share/jupyter/lc_wrapper_kernels/bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    chown -R jovyan:users /home/jovyan

USER $NB_USER

