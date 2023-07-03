#!/bin/bash

set -eux

packages=(
# "github.com/tkuchiki/alp/cmd/alp@main"
# "github.com/klauspost/asmfmt/cmd/asmfmt"
# "golang.org/x/perf/cmd/benchstat"
"github.com/codesenberg/bombardier"
# "github.com/orisano/dlayer"
# "github.com/go-delve/delve/cmd/dlv"
# "github.com/alvaroloes/enumer"
# "github.com/kisielk/errcheck"
# "github.com/davidrjenni/reftools/cmd/fillstruct"
# "github.com/ramya-rao-a/go-outline"
# "github.com/766b/go-outliner"
# "github.com/tsliwowicz/go-wrk"
# "golang.org/dl/go1.18beta1"
# "github.com/atotto/clipboard/cmd/gocopy"
# "github.com/rogpeppe/godef"
# "golang.org/x/tools/cmd/godoc"
# "github.com/zmb3/gogetdoc"
# "golang.org/x/tools/cmd/goimports"
# "github.com/golangci/golangci-lint/cmd/golangci-lint"
# "golang.org/x/lint/golint"
# "github.com/fatih/gomodifytags"
# "github.com/atotto/clipboard/cmd/gopaste"
# "github.com/uudashr/gopkgs/v2/cmd/gopkgs"
# "github.com/haya14busa/goplay/cmd/goplay"
# "golang.org/x/tools/gopls"
# "github.com/goreleaser/goreleaser"
# "golang.org/x/tools/cmd/gorename"
# "github.com/mkouhei/gosh"
# "github.com/jstemmer/gotags"
# "github.com/cweill/gotests/gotests"
# "github.com/nao1215/gup"
# "golang.org/x/tools/cmd/guru"
# "helm.sh/helm/v3/cmd/helm"
# "github.com/rakyll/hey"
# "github.com/koron/iferr"
# "github.com/josharian/impl"
# "go.k6.io/k6"
# "github.com/derailed/k9s"
# "honnef.co/go/tools/cmd/keyify"
# "sigs.k8s.io/kind"
# "github.com/ahmetb/kubectx/cmd/kubectx"
# "github.com/ahmetb/kubectx/cmd/kubens"
# "sigs.k8s.io/kustomize/kustomize/v5"
# "github.com/jesseduffield/lazygit"
# "github.com/vektra/mockery/v2"
# "github.com/golang/mock/mockgen"
# "github.com/fatih/motion"
# "github.com/google/pprof"
# "google.golang.org/protobuf/cmd/protoc-gen-go"
# "google.golang.org/grpc/cmd/protoc-gen-go-grpc"
# "github.com/monochromegane/the_platinum_searcher/cmd/pt"
# "github.com/m3ng9i/ran"
# "github.com/mgechev/revive"
# "github.com/opencontainers/runc"
# "github.com/kyleconroy/sqlc/cmd/sqlc"
# "github.com/lestrrat-go/server-starter/cmd/start_server"
# "honnef.co/go/tools/cmd/staticcheck"
# "github.com/stern/stern"
# "golang.org/x/tools/cmd/stringer"
# "github.com/swaggo/swag/cmd/swag"
# "github.com/tsenart/vegeta"
# "github.com/umlx5h/zsh-manpage-completion-generator"
)

if ! command -v go &> /dev/null; then
    echo "go could not be found"
    exit
fi

for package in "${packages[@]}"; do
    if [[ $package =~ "@" ]]; then
        go install "$package"
    else
        go install "$package@latest"
    fi
done

