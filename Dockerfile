 FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04 AS base_cuda


ENV DEBIAN_FRONTEND=noninteractive

ENV TZ="America/Denver"

ENV LANG=en_US.UTF-8

ENV LC_ALL=en_US.UTF-8

ENV USER=hailo


RUN apt-get update && apt-get install --no-install-recommends -y \

    locales python3 python3-pip curl libgl1 libglib2.0-0 git build-essential \

    python3.10-dev python3.10-distutils python3-tk libfuse2 graphviz \

    graphviz-dev libgraphviz-dev sudo && \

    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \

    dpkg-reconfigure locales && update-locale && \

    apt-get clean && rm -rf /var/lib/apt/lists/*


ARG USERNAME=hailo

ARG USER_UID=1000

ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \

    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \

    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \

    chmod 0440 /etc/sudoers.d/$USERNAME


COPY ./constraints.txt /home/$USERNAME/constraints.txt


COPY ./hailort_4.20.0_amd64.deb /tmp/hailort_4.20.0_amd64.deb

RUN dpkg-deb -x /tmp/hailort_4.20.0_amd64.deb /tmp/hailort_extract && \
    cp -rT /tmp/hailort_extract/usr /usr && \
    if [ -d /tmp/hailort_extract/etc ]; then cp -rT /tmp/hailort_extract/etc /etc; fi


USER $USERNAME

ENV PATH="/home/hailo/.local/bin:${PATH}"


RUN pip install --no-cache-dir -c /home/$USERNAME/constraints.txt pygraphviz jax==0.4.13

#the jaxlib wheel is needed, unfortunately, as it seems to have been pulled

COPY ./jaxlib-0.4.13-cp310-cp310-manylinux2014_x86_64.whl /home/$USERNAME/

RUN pip install --no-cache-dir -c /home/$USERNAME/constraints.txt \

    /home/$USERNAME/jaxlib-0.4.13-cp310-cp310-manylinux2014_x86_64.whl && \

    rm /home/$USERNAME/jaxlib-0.4.13-cp310-cp310-manylinux2014_x86_64.whl


COPY ./hailo_dataflow_compiler-3.30.0-py3-none-linux_x86_64.whl /home/$USERNAME/

RUN pip install --no-cache-dir -c /home/$USERNAME/constraints.txt \

    /home/$USERNAME/hailo_dataflow_compiler-3.30.0-py3-none-linux_x86_64.whl && \

    rm /home/$USERNAME/*.whl


COPY ./hailort-4.20.0-cp310-cp310-linux_x86_64.whl /home/$USERNAME/

RUN pip install --no-cache-dir -c /home/$USERNAME/constraints.txt \

    /home/$USERNAME/hailort-4.20.0-cp310-cp310-linux_x86_64.whl && \

    rm /home/$USERNAME/*.whl


RUN git clone --depth 1 --branch v2.14 https://github.com/hailo-ai/hailo_model_zoo.git /home/$USERNAME/hailo_model_zoo && \

    pip install --no-cache-dir -c /home/$USERNAME/constraints.txt -e /home/$USERNAME/hailo_model_zoo


WORKDIR /workspace


COPY ./entrypoint.sh /home/hailo/entrypoint.sh

CMD ["/bin/bash", "/home/hailo/entrypoint.sh"]
