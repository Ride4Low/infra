load('ext://restart_process', 'docker_build_with_restart')

k8s_yaml('./development/k8s/app-config.yaml')

### Start of API Service ###
api_compile_cmd = 'CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/api ../api'

local_resource(
    'api-compile',
    api_compile_cmd,
    deps = ['../api', '../contracts'], labels = "compiles")

docker_build_with_restart(
    'ride4Low/api',
    '.',
    entrypoint = ['/app/build/api'],
    dockerfile = './development/docker/api.Dockerfile',
    only = [
        './build/api',
    ],
    live_update = [
        sync('./build/api', '/app/build/api'),
    ],
)

k8s_yaml('./development/k8s/api-deployment.yaml')

k8s_resource('api',
    port_forwards = ['8081:8081'],
    resource_deps = ['api-compile'],
    labels = "services"
)

### End of API Service ###

### Start of Trip Service ###
trip_compile_cmd = 'CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/trip-service ../trip-service/cmd/server/main.go'

local_resource(
    'trip-service-compile',
    trip_compile_cmd,
    deps = ['../trip-service', '../contracts'], labels = "compiles")

docker_build_with_restart(
    'ride4Low/trip-service',
    '.',
    entrypoint = ['/app/build/trip-service'],
    dockerfile = './development/docker/trip-service.Dockerfile',
    only = [
        './build/trip-service',
    ],
    live_update = [
        sync('./build/trip-service', '/app/build/trip-service'),
    ],
)

k8s_yaml('./development/k8s/trip-service-deployment.yaml')

k8s_resource('trip-service',
    port_forwards = ['9093:9093'],
    resource_deps = ['trip-service-compile'],
    labels = "services"
)
### End of Trip Service ###
