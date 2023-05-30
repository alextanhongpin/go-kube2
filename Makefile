include .env
export

org := alextanhongpin
app := go-kube
img := $(org)/$(app)
tag := $(shell git rev-parse --short HEAD)

k := kubectl


start:
	@go run main.go


build:
	@docker build -t $(img):latest -t $(img):$(tag) .


up:
	@docker-compose up -d


down:
	@docker-compose down


dashboard:
	@$k apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
	@$k port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8000:443
	@open http://localhost:8000


deploy:
	@$k apply -f k8s-deployment.yaml
	@$k get deployments
	@# Ports are allocated a private IP address by default and cannot be reached outside of the cluster.
	@# Use the kubectl port-forward command to map a local port inside the pod like this.
	@$k port-forward deployment/go-kube 8080:8080


logs:
	@$k logs deployment/go-kube


# https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
dashboard-token:
	@# Create a role for kube-system in order to be able to list resources in the dashboard.
	@$k create token -n kubernetes-dashboard kubernetes-dashboard


dashboard-rbac:
	@$k apply -f perm.yaml
	@$k create sa kubernetes-dashboard
	@$k create clusterrolebinding kubernetes-dashboard-binding --clusterrole=kubernetes-dashboard --serviceaccount=kubernetes-dashboard:kubernetes-dashboard
	@$k create token -n kubernetes-dashboard kubernetes-dashboard
