In order to run this container, you need to place the following, or similar, in the root of the project. (if you use different names be sure to update the dockerfile, improvements to such workflow are planned)
Note that the project has only been tested with the exact files mentioned here, you are on your own if you decide to use older or newer versions of this software

```
hailo_dataflow_compiler-3.30.0-py3-none-linux_x86_64.whl
```
```
hailort_4.20.0_amd64.deb
```
```
hailort-4.20.0-cp310-cp310-linux_x86_64.whl
```
```
jaxlib-0.4.13-cp310-cp310-manylinux2014_x86_64.whl
```

**I CANNOT GIVE THESE TO YOU, YOU MUST OBTAIN THEM ON YOUR OWN**

The Hailo wheels and the deb can be found in the [Hailo Developer zone (login required)](https://hailo.ai/developer-zone/software-downloads/)

Please note the following, according to Hailo:

```
Some of the AI Vision Processor downloads and documents are restricted to authorized customers. If you don’t see what you need, please contact your Hailo-15 provider / Hailo point of contact. 
```

As for ```jaxlib 0.4.13```, you can find the wheel [Here](https://dashboard.stablebuild.com/pypi-deleted-packages/pkg/jaxlib/0.4.13)

Place it in the root of the project, along with the other binaries you have downloaded. Once this is done, you are ready to follow the project [Instructions](readme.md)
