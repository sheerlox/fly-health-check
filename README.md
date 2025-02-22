# FlyHealthCheck (minimal reproduction)

Minimal reproduction repository of [traffic being routed to Fly.io instances not passing health check](https://community.fly.io/t/traffic-still-routed-to-instances-not-passing-health-check/24006).

## Files of interest

- [`lib/fly_health_check/startup.ex`](./lib/fly_health_check/startup.ex)
- [`lib/fly_health_check_web/plugs/slow_request.ex`](./lib/fly_health_check_web/plugs/slow_request.ex)
- [`lib/fly_health_check_web/plugs/health_check.ex`](./lib/fly_health_check_web/plugs/health_check.ex)

## Running the test

1. Update app name & `PHX_HOST` in `fly.toml` and commit the changes
2. Launch Fly.io app: `fly launch`
3. Reset concurrency settings in `fly.toml` and deploy again: `git restore fly.toml && fly deploy`
4. Stop one machine and open its logs: `fly machine list` / `fly machine stop ${id}` / `fly logs --machine ${id}`
5. [Install k6](https://grafana.com/docs/k6/latest/set-up/install-k6/)
6. Update `SERVER_URL` in `load-testing.js`
7. Run `k6 run load-testing.js`
