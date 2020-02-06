FROM niicloudoperation/notebook
MAINTAINER mnagaku

USER root

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache

RUN apt-get update && apt-get -y upgrade && apt-get install -y apt-transport-https gnupg lsb-release gnupg software-properties-common gss-ntlmssp less && \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-bionic main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y google-cloud-sdk && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y kubeadm kubectl kubelet && \
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    add-apt-repository universe && \
    apt-get install -y powershell && \
    echo "deb https://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/" | tee -a /etc/apt/sources.list.d/cran.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    apt-get update && apt-get install -y r-base && \
    Rscript -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest', 'IRkernel', 'tidyverse'))" && \
    pip --no-cache-dir install pywinrm boto3 boto awscli aws-parallelcluster ansible-jupyter-widgets && \
    pip --no-cache-dir install sshkernel && python -m sshkernel install --sys-prefix && \
    pip --no-cache-dir install powershell_kernel && python -m powershell_kernel.install --sys-prefix && \
    pip --no-cache-dir install git+https://github.com/ansible/ansible-jupyter-kernel && python -m ansible_kernel.install --sys-prefix && \
    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/ssh --sys-prefix && \
    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/powershell --sys-prefix && \
    jupyter wrapper-kernelspec install /opt/conda/share/jupyter/kernels/ansible --sys-prefix && \
    jupyter wrapper-kernelspec install /usr/local/lib/R/site-library/IRkernel/kernelspec --sys-prefix && \
    rm -rf /opt/conda/share/jupyter/lc_wrapper_kernels/bash && \
    rm packages-microsoft-prod.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pwsh \
      -NoLogo \
      -NoProfile \
      -Command " \
        \$ErrorActionPreference = 'Stop' ; \
        \$ProgressPreference = 'SilentlyContinue' ; \
        while(!(Test-Path -Path \$env:PSModuleAnalysisCachePath)) {  \
          Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
          Start-Sleep -Seconds 6 ; \
        }" && \
    chown -R jovyan:users /home/jovyan

COPY diff4013.patch /tmp

RUN cp /tmp/diff4013.patch /opt/conda/lib/python3.7/site-packages/powershell_kernel/ && \
    cd /opt/conda/lib/python3.7/site-packages/powershell_kernel && patch < diff4013.patch

USER $NB_USER

# I used the following for PowerShell.
# https://github.com/PowerShell/PowerShell-Docker/blob/master/release/stable/ubuntu18.04/docker/Dockerfile

