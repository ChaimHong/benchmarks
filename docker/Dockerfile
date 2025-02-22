FROM debian:testing

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y dirmngr ca-certificates gnupg \
    && gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/debian stable-buster main" > /etc/apt/sources.list.d/mono-official-stable.list

RUN apt-get update && apt-get install -y \
    build-essential \
    chezscheme \
    clang-16 \
    cmake \
    cpanminus \
    curl \
    elixir \
    gcc-13 \
    gccgo-13 \
    gdc-13 \
    git \
    lbzip2 \
    libblas-dev \
    libc++-16-dev \
    libc++abi-16-dev \
    libevent-dev \
    libgmp-dev \
    libjq-dev \
    libjson-c-dev \
    libjson-glib-dev \
    liblapack-dev \
    liblapacke-dev \
    liblua5.4-dev \
    libncurses-dev \
    libncursesw6 \
    libnuma-dev \
    libomp-16-dev \
    libonig-dev \
    libopenblas-dev \
    libopenblas64-dev \
    libopenmpi-dev \
    libpcre3-dev \
    libpython3-stdlib \
    libpython3.11-stdlib \
    libssl-dev \
    libtool \
    libtool-bin \
    libxml2 \
    libyajl-dev \
    libyaml-dev \
    locales \
    locales-all \
    lua5.4 \
    mono-devel \
    nuget \
    opam \
    php \
    pipx \
    powercap-utils \
    python3 \
    python3-numpy \
    python3-pip \
    python3-ujson \
    tcl \
    tcllib \
    valac \
    vim \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 10 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 10 \
    && update-alternatives --install /usr/bin/gdc gdc /usr/bin/gdc-13 10 \
    && update-alternatives --install /usr/bin/gccgo gccgo /usr/bin/gccgo-13 10 \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-16 10 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-16 10 \
    && nuget update -self \
    && useradd -m dev

RUN mkdir /root/bin
WORKDIR /root/bin
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV PATH="/root/bin/:/root/.local/bin/:${PATH}" \
    JQ_LIB_DIR=/usr/lib/x86_64-linux-gnu/ \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN curl -Lo /root/bin/coursier https://git.io/coursier-cli \
    && chmod +x /root/bin/coursier

# https://www.idris-lang.org/pages/download.html
ARG IDRIS=0.6.0
RUN curl https://www.idris-lang.org/idris2-src/idris2-$IDRIS.tgz | tar -xz
WORKDIR /root/bin/Idris2-$IDRIS
ENV PATH="/root/bin/idris2/bin:${PATH}"
ENV LD_LIBRARY_PATH="/root/bin/idris2/lib:$LD_LIBRARY_PATH"
RUN PREFIX=/root/bin/idris2 make bootstrap SCHEME=chezscheme \
    && PREFIX=/root/bin/idris2 make install
WORKDIR /root/bin
RUN rm -rf Idris2-$IDRIS

# https://www.ruby-lang.org/en/downloads/
ARG RUBY=ruby-3.2.2
RUN curl https://cache.ruby-lang.org/pub/ruby/3.2/$RUBY.tar.gz | tar -xz
WORKDIR /root/bin/$RUBY
RUN CC=clang ./configure --prefix=/root/bin/ruby && make -j && make install
ENV PATH="/root/bin/ruby/bin:${PATH}"
WORKDIR /root/bin
RUN rm -rf $RUBY

# https://github.com/MLton/mlton/releases
ARG MLTON=20210117
RUN curl -L \
    https://github.com/MLton/mlton/releases/download/on-$MLTON-release/mlton-$MLTON-1.amd64-linux-glibc2.31.tgz \
    | tar -xz
ENV PATH="/root/bin/mlton-$MLTON-1.amd64-linux-glibc2.31/bin/:${PATH}"

# https://pypy.org/download.html
ARG PYPY=pypy3.10-v7.3.13-linux64
RUN curl \
    https://downloads.python.org/pypy/$PYPY.tar.bz2 \
    | tar -xj \
    && rm /root/bin/$PYPY/bin/python*
ENV PATH="/root/bin/$PYPY/bin:${PATH}"

# https://www.scala-lang.org/download/
ARG SCALA=3.3.1
RUN curl -L \
    https://github.com/lampepfl/dotty/releases/download/$SCALA/scala3-$SCALA.tar.gz \
    | tar -xz
ENV PATH="/root/bin/scala3-$SCALA/bin/:${PATH}"

# https://jdk.java.net/
ARG JDK=21
RUN curl \
    https://download.java.net/java/GA/jdk21/fd2272bbf8e04c3dbaee13770090416c/35/GPL/openjdk-21_linux-x64_bin.tar.gz \
    | tar -xz
ENV PATH="/root/bin/jdk-$JDK/bin:${PATH}"

# https://github.com/oracle/truffleruby/releases
ARG TRUBY=23.1.0
# Native Standalone
RUN curl -L \
    https://github.com/oracle/truffleruby/releases/download/graal-$TRUBY/truffleruby-$TRUBY-linux-amd64.tar.gz \
    | tar -xz
RUN mv /root/bin/truffleruby-$TRUBY-linux-amd64 /root/bin/truffleruby-native \
    && /root/bin/truffleruby-native/lib/truffle/post_install_hook.sh \
    && ln -s /root/bin/truffleruby-native/bin/truffleruby /root/bin/truffleruby
# JVM Standalone
RUN curl -L \
    https://github.com/oracle/truffleruby/releases/download/graal-$TRUBY/truffleruby-jvm-$TRUBY-linux-amd64.tar.gz \
    | tar -xz
RUN mv /root/bin/truffleruby-$TRUBY-linux-amd64 /root/bin/truffleruby-jvm \
    && /root/bin/truffleruby-jvm/lib/truffle/post_install_hook.sh \
    && ln -s /root/bin/truffleruby-jvm/bin/truffleruby /root/bin/truffleruby-jvm-bin

# https://github.com/crystal-lang/crystal/releases
ARG CRYSTAL=crystal-1.10.1-1
RUN curl -L \
    https://github.com/crystal-lang/crystal/releases/download/1.10.1/$CRYSTAL-linux-x86_64.tar.gz \
    | tar -xz
ENV PATH="/root/bin/$CRYSTAL/bin:${PATH}"

# https://github.com/ldc-developers/ldc/releases
ARG LDC=ldc2-1.34.0-linux-x86_64
RUN curl -L \
    https://github.com/ldc-developers/ldc/releases/download/v1.34.0/$LDC.tar.xz \
    | tar -xJ
ENV PATH="/root/bin/$LDC/bin/:${PATH}"

# https://nim-lang.org/install_unix.html
ARG NIM=nim-2.0.0
RUN curl \
    https://nim-lang.org/download/$NIM-linux_x64.tar.xz \
    | tar -xJ
ENV PATH="/root/bin/$NIM/bin/:${PATH}"

# https://dlang.org/download.html
RUN curl \
    https://downloads.dlang.org/releases/2.x/2.105.2/dmd.2.105.2.linux.tar.xz \
    | tar -xJ
ENV PATH="/root/bin/dmd2/linux/bin64/:${PATH}"

# https://www.jruby.org/download
ARG JRUBY=9.4.3.0
RUN curl \
    https://repo1.maven.org/maven2/org/jruby/jruby-dist/$JRUBY/jruby-dist-$JRUBY-bin.tar.gz \
    | tar -xz \
    && ln -s /root/bin/jruby-$JRUBY/bin/jruby /root/bin/jruby

# https://julialang.org/downloads/
ARG JULIA=julia-1.9.3
RUN curl \
    https://julialang-s3.julialang.org/bin/linux/x64/1.9/$JULIA-linux-x86_64.tar.gz \
    | tar -xz
ENV PATH="/root/bin/$JULIA/bin/:${PATH}"

# https://github.com/clojure/brew-install/releases
ARG CLOJURE=1.11.1.1413
RUN curl -L \
    https://github.com/clojure/brew-install/releases/download/$CLOJURE/linux-install.sh \
    | bash -s -- --prefix /root/

# https://swift.org/download/
ARG SWIFT=swift-5.9-RELEASE-ubuntu22.04
RUN curl -L \
    https://download.swift.org/swift-5.9-release/ubuntu2204/swift-5.9-RELEASE/swift-5.9-RELEASE-ubuntu22.04.tar.gz \
    | tar -xz \
    && ln -s /root/bin/$SWIFT/usr/bin/swift /root/bin/swift \
    && ln -s /root/bin/$SWIFT/usr/bin/swiftc /root/bin/swiftc
ENV LD_LIBRARY_PATH=/root/bin/$SWIFT/usr/lib/swift/linux:$LD_LIBRARY_PATH

ENV GHCUP_INSTALL_BASE_PREFIX="/root"
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org \
    | BOOTSTRAP_HASKELL_NONINTERACTIVE="y" sh
ENV PATH="/root/.ghcup/bin/:${PATH}"

# https://www.haskell.org/ghc/
ARG GHC_VER=9.4.7
RUN ghcup install ghc $GHC_VER && ghcup set ghc $GHC_VER

# Shared packages for all Haskell code
RUN cabal update \
    && cabal install network raw-strings-qq --lib \
    && cabal install hlint
ENV GHC_PACKAGE_PATH="~/.cabal/store/ghc-${GHC_VER}/package.db:"

# https://github.com/dotnet/core/tree/main/release-notes
RUN mkdir dotnet && curl \
    https://download.visualstudio.microsoft.com/download/pr/c4b5aad8-a416-436b-927c-3ebd5a9793ad/38efd1b64c8edc7c5f13699dd0be54e1/dotnet-sdk-7.0.402-linux-x64.tar.gz \
    | tar -xz -C dotnet
ENV PATH="/root/bin/dotnet:${PATH}"
ENV DOTNET_ROOT="/root/bin/dotnet"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

# https://nodejs.org/en/download/current/
ARG NODE=v20.8.1
RUN curl \
    https://nodejs.org/dist/$NODE/node-$NODE-linux-x64.tar.xz \
    | tar -xJ
ENV PATH="/root/bin/node-$NODE-linux-x64/bin/:${PATH}"

# https://golang.org/dl/
RUN curl -L \
    https://go.dev/dl/go1.21.3.linux-amd64.tar.gz \
    | tar -xz
ENV PATH="/root/bin/go/bin/:${PATH}"

# https://www.rust-lang.org/tools/install
ENV CARGO_HOME="/root/bin/.cargo" PATH="/root/bin/.cargo/bin:${PATH}"
RUN curl https://sh.rustup.rs | sh -s -- -y

# https://ocaml.org/releases/
ARG OCAML=5.1.0
RUN opam init --disable-sandboxing -n --root=/root/bin/opam --compiler=ocaml-base-compiler.$OCAML
ENV PATH="/root/bin/opam/ocaml-base-compiler.$OCAML/bin/:${PATH}"

# https://kotlinlang.org/docs/command-line.html
ARG KOTLIN=1.9.10
RUN curl -L -o kotlin-compiler-$KOTLIN.zip \
    https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN/kotlin-compiler-$KOTLIN.zip \
    && unzip kotlin-compiler-$KOTLIN.zip \
    && rm kotlin-compiler-$KOTLIN.zip
ENV PATH="/root/bin/kotlinc/bin/:${PATH}"

# https://download.racket-lang.org/
ARG RACKET=8.10
RUN curl -L -o racket-$RACKET-x86_64-linux-cs.sh \
    https://download.racket-lang.org/installers/$RACKET/racket-$RACKET-x86_64-linux-cs.sh \
    && sh racket-$RACKET-x86_64-linux-cs.sh --unix-style --dest /root/ \
    && rm racket-$RACKET-x86_64-linux-cs.sh

# https://ziglang.org/download
ARG ZIG=zig-linux-x86_64-0.11.0
RUN curl \
    https://ziglang.org/download/0.11.0/$ZIG.tar.xz \
    | tar -xJ
ENV PATH="/root/bin/$ZIG/:${PATH}"

# Using more stable LuaJIT, used in Alpine and other distros
# https://github.com/openresty/luajit2/tags
RUN export VERSION=2.1-20231006 \
    && curl -L \
    https://github.com/openresty/luajit2/archive/refs/tags/v$VERSION.tar.gz \
    | tar -xz \
    && make -C luajit2-$VERSION -j \
    && make -C luajit2-$VERSION install PREFIX=/root/bin/luajit \
    && rm -rf luajit2-$VERSION
ENV PATH="/root/bin/luajit/bin:${PATH}"

# https://github.com/vlang/v/releases
ARG VLANG=weekly.2023.41
RUN curl -Lo v_linux.zip \
    https://github.com/vlang/v/releases/download/$VLANG/v_linux.zip \
    && unzip -q v_linux.zip \
    && rm v_linux.zip
ENV PATH="/root/bin/v/:${PATH}"

# https://github.com/vlang/vsl and dependencies
# TODO - Install using specific VSL version as ARG
RUN v install vsl

ARG SCRIPTS_VER=unknown
COPY *.rb ./

RUN ./versions.rb

ENTRYPOINT ["./run.rb"]

RUN cat /etc/os-release
