# META
~~~ini
description=String interpolation and concatenation
type=dev_object
~~~
# SOURCE
## app.roc
~~~roc
app [main] { pf: platform "./platform.roc" }

greeting = "Hello"
name = "World"
main = "${greeting}, ${name}!"
~~~
## platform.roc
~~~roc
platform ""
    requires {} { main : Str }
    exposes []
    packages {}
    provides { main_for_host: "main" }
    targets: {
        files: "targets/",
        exe: {
            x64glibc: [app],
        }
    }

main_for_host : Str
main_for_host = main
~~~
# MONO
~~~roc
# app
greeting = "Hello"
name = "World"
main = ""greeting", "name"!"

# platform
main_for_host = <required>

~~~
# DEV OUTPUT
~~~ini
x64mac=f9d21b2ad793feaa235c9d9ceb3f42b0c0c45c7a48cd243825f3a54a574e50f9
x64win=2a72f8fc2bb291fc757d87833755c0879c646a9ea1d87edca50e3c2dc26f11d7
x64freebsd=5cf6a2d1dfe3d31fd4b53eda162c3133738dd8e209e7f283eb6f734d15fdf066
x64openbsd=5cf6a2d1dfe3d31fd4b53eda162c3133738dd8e209e7f283eb6f734d15fdf066
x64netbsd=5cf6a2d1dfe3d31fd4b53eda162c3133738dd8e209e7f283eb6f734d15fdf066
x64musl=5cf6a2d1dfe3d31fd4b53eda162c3133738dd8e209e7f283eb6f734d15fdf066
x64glibc=5cf6a2d1dfe3d31fd4b53eda162c3133738dd8e209e7f283eb6f734d15fdf066
x64linux=5cf6a2d1dfe3d31fd4b53eda162c3133738dd8e209e7f283eb6f734d15fdf066
x64elf=5cf6a2d1dfe3d31fd4b53eda162c3133738dd8e209e7f283eb6f734d15fdf066
arm64mac=ffdf0beec95724ea52b193590ab417e385b4ef9f20bc5b714e30e90ce7cbc3de
arm64win=dfff5bd0c85cfe94a29572da2e7e853baca186908d322c48f8187800324f0ffc
arm64linux=a0ac94898b77396e33c593f5d870807e40fadc64a38c76fc9fb8259f56488889
arm64musl=a0ac94898b77396e33c593f5d870807e40fadc64a38c76fc9fb8259f56488889
arm64glibc=a0ac94898b77396e33c593f5d870807e40fadc64a38c76fc9fb8259f56488889
arm32linux=NOT_IMPLEMENTED
arm32musl=NOT_IMPLEMENTED
wasm32=NOT_IMPLEMENTED
~~~
