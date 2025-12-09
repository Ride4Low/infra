load('ext://restart_process', 'docker_build_with_restart')

k8s_yaml('./development/k8s/app-config.yaml')
k8s_yaml('./development/k8s/secrets.yaml')

### RabbitMQ ###
k8s_yaml('./development/k8s/rabbitmq-deployment.yaml')
k8s_resource('rabbitmq', port_forwards=['5672', '15672'], labels='tooling')
### End RabbitMQ ###

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
    resource_deps = ['api-compile', 'rabbitmq'],
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
    resource_deps = ['trip-service-compile', 'rabbitmq'],
    labels = "services"
)
### End of Trip Service ###

### Start of Notifier Service ###
notifier_compile_cmd = 'CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/notifier ../notifier'

local_resource(
    'notifier-service-compile',
    notifier_compile_cmd,
    deps = ['../notifier', '../contracts'], labels = "compiles")

docker_build_with_restart(
    'ride4Low/notifier',
    '.',
    entrypoint = ['/app/build/notifier'],
    dockerfile = './development/docker/notifier.Dockerfile',
    only = [
        './build/notifier',
    ],
    live_update = [
        sync('./build/notifier', '/app/build/notifier'),
    ],
)

k8s_yaml('./development/k8s/notifier-deployment.yaml')

k8s_resource('notifier',
    port_forwards = ['8082:8082'],
    resource_deps = ['notifier-service-compile', 'rabbitmq'],
    labels = "services"
)
### End of Notifier Service ###


### Start of Driver Service ###
driver_compile_cmd = 'CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/driver-service ../driver-service/cmd/server/main.go'

local_resource(
    'driver-service-compile',
    driver_compile_cmd,
    deps = ['../driver-service', '../contracts'], labels = "compiles")

docker_build_with_restart(
    'ride4Low/driver-service',
    '.',
    entrypoint = ['/app/build/driver-service'],
    dockerfile = './development/docker/driver-service.Dockerfile',
    only = [
        './build/driver-service',
    ],
    live_update = [
        sync('./build/driver-service', '/app/build/driver-service'),
    ],
)

k8s_yaml('./development/k8s/driver-service-deployment.yaml')

k8s_resource('driver-service',
    resource_deps = ['driver-service-compile', 'rabbitmq'],
    labels = "services"
)
### End of Driver Service ###

### Start of Payment Service ###
payment_compile_cmd = 'CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/payment-service ../payment-service/cmd/main.go'

local_resource(
    'payment-service-compile',
    payment_compile_cmd,
    deps = ['../payment-service', '../contracts'], labels = "compiles")

docker_build_with_restart(
    'ride4Low/payment-service',
    '.',
    entrypoint = ['/app/build/payment-service'],
    dockerfile = './development/docker/payment-service.Dockerfile',
    only = [
        './build/payment-service',
    ],
    live_update = [
        sync('./build/payment-service', '/app/build/payment-service'),
    ],
)

k8s_yaml('./development/k8s/payment-service-deployment.yaml')

k8s_resource('payment-service',
    resource_deps = ['payment-service-compile', 'rabbitmq'],
    labels = "services"
)
### End of Payment Service ###

### Start of Web Service ###
docker_build(
  'ride4Low/web',
  '../web',
  dockerfile='./development/docker/web.Dockerfile',
  only=['.'],
  ignore=['node_modules', '.next'],
)

k8s_yaml('./development/k8s/web-deployment.yaml')
k8s_resource('web', port_forwards=3000, labels="frontend")

### End of Web Service ###

### Start of Jaeger ###
k8s_yaml('./development/k8s/jaeger-deployment.yaml')
k8s_resource('jaeger', port_forwards=['16686:16686', '14268:14268'], labels="tooling")
### End of Jaeger ###
