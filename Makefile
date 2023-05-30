include .env
export

org := alextanhongpin
app := go-kube
img := $(org)/$(app)
tag := $(shell git rev-parse --short HEAD)


start:
	@go run main.go


build:
	@docker build -t $(img):latest -t $(img):$(tag) .
