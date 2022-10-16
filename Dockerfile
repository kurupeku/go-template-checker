FROM --platform=linux/amd64 node:18

ENV PACKAGES zsh neovim git curl jq ripgrep
ENV GOPATH /usr/local/go
ENV GOBIN ${GOPATH}/bin
ENV PATH ${PATH}:${GOBIN}
ENV ROOT ${GOPATH}/src/app
ENV CGO_ENABLED 0

# Set Up Apt
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends ${PACKAGES} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && chsh -s /bin/zsh

# Set Up Golang
RUN wget https://go.dev/dl/go1.19.2.linux-amd64.tar.gz \
  && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz \
  && go install github.com/go-task/task/v3/cmd/task@latest \
  && go install golang.org/x/tools/gopls@latest \
  && go install honnef.co/go/tools/cmd/staticcheck@latest \
  && go install golang.org/x/tools/cmd/goimports@latest \
  && go install mvdan.cc/gofumpt@latest \
  && go install github.com/cweill/gotests/gotests@latest \
  && go install github.com/fatih/gomodifytags@latest \
  && go install github.com/josharian/impl@latest \
  && go install github.com/haya14busa/goplay/cmd/goplay@latest \
  && go install github.com/jesseduffield/lazygit@latest \
  && go install mvdan.cc/sh/v3/cmd/shfmt@latest

WORKDIR ${ROOT}

# Prepare Project
COPY ./ ./
RUN go mod download && npm install -g npm && npm install

CMD [ "/bin/zsh" ]
