# Build executable.
FROM golang:1.20.4-alpine3.18 AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

WORKDIR $GOPATH/src/alextanhongpin/go-kube
COPY . .

# Fetch dependencies.
RUN go get -d -v

# Build the binary.
RUN go build -o /go/bin/main


# Build a small image.
FROM scratch


# Copy our static executable.
COPY --from=builder /go/bin/main /go/bin/main

# Run the binary.
ENTRYPOINT ["/go/bin/main"]
