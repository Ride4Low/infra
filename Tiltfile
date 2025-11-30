load('ext://restart_process', 'docker_build_with_restart')

k8s_yaml('./development/k8s/app-config.yaml')

api_compile_cmd = 'CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/api ../api'

local_resource(
    'api-compile',
    api_compile_cmd,
    deps = ['../api'], labels = "compiles")

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
    port_forwards = ['8080:8080'],
    resource_deps = ['api-compile'],
    labels = "services"
)
